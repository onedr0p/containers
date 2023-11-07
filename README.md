<!---
NOTE: AUTO-GENERATED FILE
to edit this file, instead edit its template at: ./github/scripts/templates/README.md.j2
-->
<div align="center">


## Containers

_An opinionated collection of container images_

</div>

<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/tuxpeople/containers?style=for-the-badge)
![GitHub forks](https://img.shields.io/github/forks/tuxpeople/containers?style=for-the-badge)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/tuxpeople/containers/release-scheduled.yaml?style=for-the-badge&label=Scheduled%20Release)

</div>

Welcome to our container images, if looking for a container start by [browsing the container packages](https://github.com/tuxpeople?tab=packages&repo_name=containers).

## Mission statement

The goal of this project is to support [semantically versioned](https://semver.org/), [rootless](https://rootlesscontaine.rs/), and [multiple architecture](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/) containers for various applications.

We also try to adhere to a [KISS principle](https://en.wikipedia.org/wiki/KISS_principle), logging to stdout, [one process per container](https://testdriven.io/tips/59de3279-4a2d-4556-9cd0-b444249ed31e/), no [s6-overlay](https://github.com/just-containers/s6-overlay) and all images are built on top of [Alpine](https://hub.docker.com/_/alpine) or [Ubuntu](https://hub.docker.com/_/ubuntu).

## Tag immutability

The containers built here do not use immutable tags, as least not in the more common way you have seen from [linuxserver.io](https://fleet.linuxserver.io/) or [Bitnami](https://bitnami.com/stacks/containers).

We do take a similar approach but instead of appending a `-ls69` or `-r420` prefix to the tag we instead insist on pinning to the sha256 digest of the image, while this is not as pretty it is just as functional in making the images immutable.

| Container                                          | Immutable |
|----------------------------------------------------|-----------|
| `ghcr.io/tuxpeople/sonarr:rolling`                   | ❌         |
| `ghcr.io/tuxpeople/sonarr:3.0.8.1507`                | ❌         |
| `ghcr.io/tuxpeople/sonarr:rolling@sha256:8053...`    | ✅         |
| `ghcr.io/tuxpeople/sonarr:3.0.8.1507@sha256:8053...` | ✅         |

_If pinning an image to the sha256 digest, tools like [Renovate](https://github.com/renovatebot/renovate) support updating the container on a digest or application version change._

## Passing arguments to a application

Some applications do not support defining configuration via environment variables and instead only allow certain config to be set in the command line arguments for the app. To circumvent this, for applications that have an `entrypoint.sh` read below.

1. First read the Kubernetes docs on [defining command and arguments for a Container](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/).
2. Look up the documentation for the application and find a argument you would like to set.
3. Set the argument in the `args` section, be sure to include `entrypoint.sh` as the first arg and any application specific arguments thereafter.

    ```yaml
    args:
      - /entrypoint.sh
      - --port
      - "8080"
    ```

## Configuration volume

For applications that need to have persistent configuration data the config volume is hardcoded to `/config` inside the container. This is not able to be changed in most cases.

## Available Images

Each Image will be built with a `rolling` tag, along with tags specific to it's version. Available Images Below

Container | Channel | Image | Latest Tags
--- | --- | --- | ---
[bazarr](https://github.com/tuxpeople/containers/pkgs/container/bazarr) | stable | ghcr.io/tuxpeople/bazarr |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.3](https://img.shields.io/badge/1.3-blue?style=flat-square) ![1.3.1](https://img.shields.io/badge/1.3.1-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[cni-plugins](https://github.com/tuxpeople/containers/pkgs/container/cni-plugins) | stable | ghcr.io/tuxpeople/cni-plugins |![1.3.0](https://img.shields.io/badge/1.3.0-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[home-assistant](https://github.com/tuxpeople/containers/pkgs/container/home-assistant) | stable | ghcr.io/tuxpeople/home-assistant |![2023.11.1](https://img.shields.io/badge/2023.11.1-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[jbops](https://github.com/tuxpeople/containers/pkgs/container/jbops) | stable | ghcr.io/tuxpeople/jbops |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.0](https://img.shields.io/badge/1.0-blue?style=flat-square) ![1.0.893](https://img.shields.io/badge/1.0.893-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[kubernetes-kubectl](https://github.com/tuxpeople/containers/pkgs/container/kubernetes-kubectl) | kubectl | ghcr.io/tuxpeople/kubernetes-kubectl |![1.28.3](https://img.shields.io/badge/1.28.3-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[lidarr](https://github.com/tuxpeople/containers/pkgs/container/lidarr) | master | ghcr.io/tuxpeople/lidarr |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.4](https://img.shields.io/badge/1.4-blue?style=flat-square) ![1.4.5](https://img.shields.io/badge/1.4.5-blue?style=flat-square) ![1.4.5.3639](https://img.shields.io/badge/1.4.5.3639-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[lidarr-develop](https://github.com/tuxpeople/containers/pkgs/container/lidarr-develop) | develop | ghcr.io/tuxpeople/lidarr-develop |![2](https://img.shields.io/badge/2-blue?style=flat-square) ![2.0](https://img.shields.io/badge/2.0-blue?style=flat-square) ![2.0.1](https://img.shields.io/badge/2.0.1-blue?style=flat-square) ![2.0.1.3769](https://img.shields.io/badge/2.0.1.3769-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[lidarr-nightly](https://github.com/tuxpeople/containers/pkgs/container/lidarr-nightly) | nightly | ghcr.io/tuxpeople/lidarr-nightly |![2](https://img.shields.io/badge/2-blue?style=flat-square) ![2.0](https://img.shields.io/badge/2.0-blue?style=flat-square) ![2.0.2](https://img.shields.io/badge/2.0.2-blue?style=flat-square) ![2.0.2.3777](https://img.shields.io/badge/2.0.2.3777-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[lidarr-plugins](https://github.com/tuxpeople/containers/pkgs/container/lidarr-plugins) | plugins | ghcr.io/tuxpeople/lidarr-plugins |![2](https://img.shields.io/badge/2-blue?style=flat-square) ![2.0](https://img.shields.io/badge/2.0-blue?style=flat-square) ![2.0.2](https://img.shields.io/badge/2.0.2-blue?style=flat-square) ![2.0.2.3773](https://img.shields.io/badge/2.0.2.3773-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[par2cmdline-turbo](https://github.com/tuxpeople/containers/pkgs/container/par2cmdline-turbo) | stable | ghcr.io/tuxpeople/par2cmdline-turbo |![1.1.0](https://img.shields.io/badge/1.1.0-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[plex](https://github.com/tuxpeople/containers/pkgs/container/plex) | stable | ghcr.io/tuxpeople/plex |![1.32.7.7621-871adbd44](https://img.shields.io/badge/1.32.7.7621--871adbd44-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[plex-beta](https://github.com/tuxpeople/containers/pkgs/container/plex-beta) | beta | ghcr.io/tuxpeople/plex-beta |![1.32.8.7639-fb6452ebf](https://img.shields.io/badge/1.32.8.7639--fb6452ebf-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[postgres-init](https://github.com/tuxpeople/containers/pkgs/container/postgres-init) | stable | ghcr.io/tuxpeople/postgres-init |![14](https://img.shields.io/badge/14-blue?style=flat-square) ![14.9](https://img.shields.io/badge/14.9-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[prowlarr](https://github.com/tuxpeople/containers/pkgs/container/prowlarr) | master | ghcr.io/tuxpeople/prowlarr |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.9](https://img.shields.io/badge/1.9-blue?style=flat-square) ![1.9.4](https://img.shields.io/badge/1.9.4-blue?style=flat-square) ![1.9.4.4039](https://img.shields.io/badge/1.9.4.4039-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[prowlarr-develop](https://github.com/tuxpeople/containers/pkgs/container/prowlarr-develop) | develop | ghcr.io/tuxpeople/prowlarr-develop |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.10](https://img.shields.io/badge/1.10-blue?style=flat-square) ![1.10.1](https://img.shields.io/badge/1.10.1-blue?style=flat-square) ![1.10.1.4059](https://img.shields.io/badge/1.10.1.4059-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[prowlarr-nightly](https://github.com/tuxpeople/containers/pkgs/container/prowlarr-nightly) | nightly | ghcr.io/tuxpeople/prowlarr-nightly |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.10](https://img.shields.io/badge/1.10-blue?style=flat-square) ![1.10.3](https://img.shields.io/badge/1.10.3-blue?style=flat-square) ![1.10.3.4070](https://img.shields.io/badge/1.10.3.4070-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[qbittorrent](https://github.com/tuxpeople/containers/pkgs/container/qbittorrent) | stable | ghcr.io/tuxpeople/qbittorrent |![4](https://img.shields.io/badge/4-blue?style=flat-square) ![4.6](https://img.shields.io/badge/4.6-blue?style=flat-square) ![4.6.0](https://img.shields.io/badge/4.6.0-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[qbittorrent-beta](https://github.com/tuxpeople/containers/pkgs/container/qbittorrent-beta) | beta | ghcr.io/tuxpeople/qbittorrent-beta |![4](https://img.shields.io/badge/4-blue?style=flat-square) ![4.6](https://img.shields.io/badge/4.6-blue?style=flat-square) ![4.6.0](https://img.shields.io/badge/4.6.0-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[radarr](https://github.com/tuxpeople/containers/pkgs/container/radarr) | master | ghcr.io/tuxpeople/radarr |![5](https://img.shields.io/badge/5-blue?style=flat-square) ![5.0](https://img.shields.io/badge/5.0-blue?style=flat-square) ![5.0.3](https://img.shields.io/badge/5.0.3-blue?style=flat-square) ![5.0.3.8127](https://img.shields.io/badge/5.0.3.8127-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[radarr-develop](https://github.com/tuxpeople/containers/pkgs/container/radarr-develop) | develop | ghcr.io/tuxpeople/radarr-develop |![5](https://img.shields.io/badge/5-blue?style=flat-square) ![5.1](https://img.shields.io/badge/5.1-blue?style=flat-square) ![5.1.2](https://img.shields.io/badge/5.1.2-blue?style=flat-square) ![5.1.2.8207](https://img.shields.io/badge/5.1.2.8207-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[radarr-nightly](https://github.com/tuxpeople/containers/pkgs/container/radarr-nightly) | nightly | ghcr.io/tuxpeople/radarr-nightly |![5](https://img.shields.io/badge/5-blue?style=flat-square) ![5.1](https://img.shields.io/badge/5.1-blue?style=flat-square) ![5.1.3](https://img.shields.io/badge/5.1.3-blue?style=flat-square) ![5.1.3.8226](https://img.shields.io/badge/5.1.3.8226-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[readarr-develop](https://github.com/tuxpeople/containers/pkgs/container/readarr-develop) | develop | ghcr.io/tuxpeople/readarr-develop |![0](https://img.shields.io/badge/0-blue?style=flat-square) ![0.3](https://img.shields.io/badge/0.3-blue?style=flat-square) ![0.3.10](https://img.shields.io/badge/0.3.10-blue?style=flat-square) ![0.3.10.2287](https://img.shields.io/badge/0.3.10.2287-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[readarr-nightly](https://github.com/tuxpeople/containers/pkgs/container/readarr-nightly) | nightly | ghcr.io/tuxpeople/readarr-nightly |![0](https://img.shields.io/badge/0-blue?style=flat-square) ![0.3](https://img.shields.io/badge/0.3-blue?style=flat-square) ![0.3.10](https://img.shields.io/badge/0.3.10-blue?style=flat-square) ![0.3.10.2287](https://img.shields.io/badge/0.3.10.2287-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[sabnzbd](https://github.com/tuxpeople/containers/pkgs/container/sabnzbd) | stable | ghcr.io/tuxpeople/sabnzbd |![4](https://img.shields.io/badge/4-blue?style=flat-square) ![4.1](https://img.shields.io/badge/4.1-blue?style=flat-square) ![4.1.0](https://img.shields.io/badge/4.1.0-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[sonarr](https://github.com/tuxpeople/containers/pkgs/container/sonarr) | main | ghcr.io/tuxpeople/sonarr |![3](https://img.shields.io/badge/3-blue?style=flat-square) ![3.0](https://img.shields.io/badge/3.0-blue?style=flat-square) ![3.0.10](https://img.shields.io/badge/3.0.10-blue?style=flat-square) ![3.0.10.1567](https://img.shields.io/badge/3.0.10.1567-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[sonarr-develop](https://github.com/tuxpeople/containers/pkgs/container/sonarr-develop) | develop | ghcr.io/tuxpeople/sonarr-develop |![4](https://img.shields.io/badge/4-blue?style=flat-square) ![4.0](https://img.shields.io/badge/4.0-blue?style=flat-square) ![4.0.0](https://img.shields.io/badge/4.0.0-blue?style=flat-square) ![4.0.0.710](https://img.shields.io/badge/4.0.0.710-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[sqlite](https://github.com/tuxpeople/containers/pkgs/container/sqlite) | stable | ghcr.io/tuxpeople/sqlite |![3](https://img.shields.io/badge/3-blue?style=flat-square) ![3.41](https://img.shields.io/badge/3.41-blue?style=flat-square) ![3.41.2](https://img.shields.io/badge/3.41.2-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[tautulli](https://github.com/tuxpeople/containers/pkgs/container/tautulli) | master | ghcr.io/tuxpeople/tautulli |![2](https://img.shields.io/badge/2-blue?style=flat-square) ![2.13](https://img.shields.io/badge/2.13-blue?style=flat-square) ![2.13.2](https://img.shields.io/badge/2.13.2-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[theme-park](https://github.com/tuxpeople/containers/pkgs/container/theme-park) | stable | ghcr.io/tuxpeople/theme-park |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.14](https://img.shields.io/badge/1.14-blue?style=flat-square) ![1.14.1](https://img.shields.io/badge/1.14.1-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[transmission](https://github.com/tuxpeople/containers/pkgs/container/transmission) | stable | ghcr.io/tuxpeople/transmission |![4.0.4](https://img.shields.io/badge/4.0.4-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)
[udp-broadcast-relay-redux](https://github.com/tuxpeople/containers/pkgs/container/udp-broadcast-relay-redux) | stable | ghcr.io/tuxpeople/udp-broadcast-relay-redux |![1](https://img.shields.io/badge/1-blue?style=flat-square) ![1.0](https://img.shields.io/badge/1.0-blue?style=flat-square) ![1.0.27](https://img.shields.io/badge/1.0.27-blue?style=flat-square) ![rolling](https://img.shields.io/badge/rolling-blue?style=flat-square)


## Contributing

1. Install [Docker](https://docs.docker.com/get-docker/), [Taskfile](https://taskfile.dev/) & [Cuelang](https://cuelang.org/)
2. Get familiar with the structure of the repositroy
3. Find a similar application in the apps directory
4. Copy & Paste an application and update the directory name
5. Update `metadata.json`, `Dockerfile`, `ci/latest.sh`, `ci/goss.yaml` and make it suit the application build
6. Include any additional files if required
7. Use Taskfile to build and test your image

    ```ruby
    task APP=sonarr CHANNEL=main test
    ```

### Automated tags

Here's an example of how tags are created in the GitHub workflows, be careful with `metadata.json` as it does affect the outcome of how the tags will be created when the application is built.

| Application | Channel   | Stable  | Base    | Generated Tag               |
|-------------|-----------|---------|---------|-----------------------------|
| `ubuntu`    | `focal`   | `true`  | `true`  | `ubuntu:focal-rolling`      |
| `ubuntu`    | `focal`   | `true`  | `true`  | `ubuntu:focal-19880312`     |
| `alpine`    | `3.16`    | `true`  | `true`  | `alpine:rolling`            |
| `alpine`    | `3.16`    | `true`  | `true`  | `alpine:3.16.0`             |
| `sonarr`    | `develop` | `false` | `false` | `sonarr-develop:3.0.8.1538` |
| `sonarr`    | `develop` | `false` | `false` | `sonarr-develop:rolling`    |
| `sonarr`    | `main`    | `true`  | `false` | `sonarr:3.0.8.1507`         |
| `sonarr`    | `main`    | `true`  | `false` | `sonarr:rolling`            |

## Deprecations

Containers here can be **deprecated** at any point, this could be for any reason described below.

1. The upstream application is **no longer actively developed**
2. The upstream application has an **official upstream container** that follows closely to the mission statement described here
3. The upstream application has been **replaced with a better alternative**
4. The **maintenance burden** of keeping the container here **is too bothersome**

**Note**: Deprecated containers will remained published to this repo for 6 months after which they will be pruned.
## Credits

A lot of inspiration and ideas are thanks to the hard work of [hotio.dev](https://hotio.dev/) and [linuxserver.io](https://www.linuxserver.io/) contributors.
