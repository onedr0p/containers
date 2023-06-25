#! /usr/bin/env python3

import sys

import json
import subprocess

from datetime import datetime, timezone
from os.path import isfile


def get_upstream_version(app, channel):
    latest_script = f"./apps/{app}/ci/latest.sh"
    if not isfile(latest_script):
        return ""

    args = [latest_script, channel]
    output = subprocess.check_output(args)
    return output.decode("utf-8").strip()

if __name__ == "__main__":

    changed_apps = json.loads(sys.argv[1])
    forRelease = sys.argv[2] == "true"

    out = {"manifestsToBuild": [], "imagePlatformPermutations": []}

    for app in changed_apps:
        name = app["app"]
        channel = str(app["channel"])
        with open(f"./apps/{name}/metadata.json") as f:
            metadata = json.load(f)

        # Generate Config
        cfg = {}
        for ch in metadata["channels"]:
            if str(ch["name"]) == channel:
                cfg = ch
                break

        app["chan_build_date"] = datetime.now(timezone.utc).isoformat()
        app["chan_stable"] = cfg["stable"]
        app["chan_tests_enabled"] = cfg["tests"]["enabled"]
        app["chan_tests_type"] = cfg["tests"]["type"]
        app["chan_upstream_version"] = get_upstream_version(name, channel)

        if app["chan_tests_enabled"] and app["chan_tests_type"] == "cli":
            app["chan_goss_args"] = "tail -f /dev/null"

        if app.get("base", False):
            app["chan_label_type"] ="org.opencontainers.image.base"
        else:
            app["chan_label_type"]="org.opencontainers.image"

        if isfile(f"./apps/{name}/{channel}/Dockerfile"):
            app["chan_dockerfile"] = f"./apps/{name}/{channel}/Dockerfile"
            app["chan_goss_config"] = f"./apps/{name}/{channel}/goss.yaml"
        else:
            app["chan_dockerfile"] = f"./apps/{name}/Dockerfile"
            app["chan_goss_config"] = f"./apps/{name}/ci/goss.yaml"

        if app["chan_stable"]:
            app["chan_image_name"] = name
            app["chan_tag_rolling"] = f"{name}:rolling"
            app["chan_tag_version"] = f"{name}:{app['chan_upstream_version']}"
            app["chan_tag_testing"] = f"{name}:testing"
        else:
            app["chan_image_name"] = f"{name}-{channel}"
            app["chan_tag_rolling"] = f"{name}-{channel}:rolling"
            app["chan_tag_version"] = f"{name}-{channel}:{app['chan_upstream_version']}"
            app["chan_tag_testing"] = f"{name}-{channel}:testing"

        for platform in cfg["platforms"]:
            if platform != "linux/amd64" and not forRelease:
                continue
            to_append = app.copy()
            to_append["platform"] = platform
            if platform != "linux/amd64":
                to_append["chan_tests_enabled"] = False
            out["imagePlatformPermutations"].append(to_append)

        manifest = {
            "image": app["chan_image_name"],
            "app": name,
            "channel": channel,
            "tags": [app["chan_tag_rolling"], app["chan_tag_version"]],
            "platforms": cfg["platforms"],
            "version": app["chan_upstream_version"],
        }
        out["manifestsToBuild"].append(manifest)

    print(json.dumps(out))
