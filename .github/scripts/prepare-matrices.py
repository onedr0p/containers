#!/usr/bin/env python3
import importlib.util
import sys
import os

import json
import yaml
import requests

from subprocess import check_output

from os.path import isfile


TESTABLE_PLATFORMS = ["linux/amd64"]

def load_metadata_file_yaml(file_path):
    with open(file_path, "r") as f:
        return yaml.safe_load(f)

def load_metadata_file_json(file_path):
    with open(file_path, "r") as f:
        return json.load(f)

def get_latest_version_py(latest_py_path, channel_name):
    spec = importlib.util.spec_from_file_location("latest", latest_py_path)
    latest = importlib.util.module_from_spec(spec)
    sys.modules["latest"] = latest
    spec.loader.exec_module(latest)
    return latest.get_latest(channel_name)

def get_latest_version_sh(latest_sh_path, channel_name):
    out = check_output([latest_sh_path, channel_name])
    return out.decode("utf-8").strip()

def get_latest_version(subdir, channel_name):
    ci_dir =  os.path.join(subdir, "ci")
    if os.path.isfile(os.path.join(ci_dir, "latest.py")):
        return get_latest_version_py(os.path.join(ci_dir, "latest.py"), channel_name)
    elif os.path.isfile(os.path.join(ci_dir, "latest.sh")):
        return get_latest_version_sh(os.path.join(ci_dir, "latest.sh"), channel_name)
    elif os.path.isfile(os.path.join(subdir, channel_name, "latest.py")):
       return get_latest_version_py(os.path.join(subdir, channel_name, "latest.py"), channel_name)
    elif os.path.isfile(os.path.join(subdir, channel_name, "latest.sh")):
        return get_latest_version_sh(os.path.join(subdir, channel_name, "latest.sh"), channel_name)
    return None

def get_published_version(image_name):
    r = requests.get(
        f"https://api.github.com/users/onedr0p/packages/container/{image_name}/versions",
        headers={
            "Accept": "application/vnd.github.v3+json",
            "Authorization": "token " + os.environ["TOKEN"]
        },
    )

    if r.status_code != 200:
        return None

    data = json.loads(r.text)
    for image in data:
        tags = image["metadata"]["container"]["tags"]
        if "rolling" in tags:
            tags.remove("rolling")
            # Assume the longest string is the complete version number
            return max(tags, key=len)

def get_image_metadata(subdir, meta, forRelease=False, force=False, channels=None):
    imagesToBuild = {
        "images": [],
        "imagePlatforms": []
    }

    if channels is None:
        channels = meta["channels"]
    else:
        channels = [channel for channel in meta["channels"] if channel["name"] in channels]


    for channel in channels:
        version = get_latest_version(subdir, channel["name"])
        if version is None:
            continue

        # Image Name
        toBuild = {}
        if channel.get("stable", False):
            toBuild["name"] = meta["app"]
        else:
            toBuild["name"] = "-".join([meta["app"], channel["name"]])

        # Skip if latest version already published
        if not force:
            published = get_published_version(toBuild["name"])
            if published is not None and published == version:
                continue
            toBuild["published_version"] = published

        toBuild["version"] = version

        # Image Tags
        toBuild["tags"] = ["rolling", version]
        if meta.get("semantic_versioning", False):
            parts = version.split(".")[:-1]
            while len(parts) > 0:
                toBuild["tags"].append(".".join(parts))
                parts = parts[:-1]

        # Platform Metadata
        for platform in channel["platforms"]:

            if platform not in TESTABLE_PLATFORMS and not forRelease:
                continue

            toBuild.setdefault("platforms", []).append(platform)

            platformToBuild = {}
            platformToBuild["name"] = toBuild["name"]
            platformToBuild["platform"] = platform
            platformToBuild["version"] = version
            platformToBuild["channel"] = channel["name"]

            if meta.get("base", False):
                platformToBuild["label_type"] ="org.opencontainers.image.base"
            else:
                platformToBuild["label_type"]="org.opencontainers.image"

            if isfile(os.path.join(subdir, channel["name"], "Dockerfile")):
                platformToBuild["dockerfile"] = os.path.join(subdir, channel["name"], "Dockerfile")
                platformToBuild["context"] = os.path.join(subdir, channel["name"])
                platformToBuild["goss_config"] = os.path.join(subdir, channel["name"], "goss.yaml")
            else:
                platformToBuild["dockerfile"] = os.path.join(subdir, "Dockerfile")
                platformToBuild["context"] = subdir
                platformToBuild["goss_config"] = os.path.join(subdir, "ci", "goss.yaml")

            platformToBuild["goss_args"] = "tail -f /dev/null" if channel["tests"].get("type", "web") == "cli" else ""

            platformToBuild["tests_enabled"] = channel["tests"]["enabled"] and platform in TESTABLE_PLATFORMS

            imagesToBuild["imagePlatforms"].append(platformToBuild)
        imagesToBuild["images"].append(toBuild)
    return imagesToBuild

if __name__ == "__main__":
    apps = sys.argv[1]
    forRelease = sys.argv[2] == "true"
    force = sys.argv[3] == "true"
    imagesToBuild = {
        "images": [],
        "imagePlatforms": []
    }

    if apps != "all":
        channels=None
        apps = apps.split(",")
        if len(sys.argv) == 5:
            channels = sys.argv[4].split(",")

        for app in apps:
            if not os.path.exists(os.path.join("./apps", app)):
                print(f"App \"{app}\" not found")
                exit(1)

            meta = None
            if os.path.isfile(os.path.join("./apps", app, "metadata.yaml")):
                meta = load_metadata_file_yaml(os.path.join("./apps", app, "metadata.yaml"))
            elif os.path.isfile(os.path.join("./apps", app, "metadata.json")):
                meta = load_metadata_file_json(os.path.join("./apps", app, "metadata.json"))

            imageToBuild = get_image_metadata(os.path.join("./apps", app), meta, forRelease, force=force, channels=channels)
            if imageToBuild is not None:
                imagesToBuild["images"].extend(imageToBuild["images"])
                imagesToBuild["imagePlatforms"].extend(imageToBuild["imagePlatforms"])
    else:
        for subdir, dirs, files in os.walk("./apps"):
            for file in files:
                meta = None
                if file == "metadata.yaml":
                    meta = load_metadata_file_yaml(os.path.join(subdir, file))
                elif file == "metadata.json":
                    meta = load_metadata_file_json(os.path.join(subdir, file))
                else:
                    continue
                if meta is not None:
                    imageToBuild = get_image_metadata(subdir, meta, forRelease, force=force)
                    if imageToBuild is not None:
                        imagesToBuild["images"].extend(imageToBuild["images"])
                        imagesToBuild["imagePlatforms"].extend(imageToBuild["imagePlatforms"])
    print(json.dumps(imagesToBuild))