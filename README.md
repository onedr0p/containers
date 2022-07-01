# Container Images

Welcome to our container images, if looking for a container start by [browsing the container packages](https://github.com/onedr0p?tab=packages&repo_name=containers).

## Tag Immutability

The containers built here do not use immutable tags, as least not in the more common way you have seen from [linuxserver.io](https://fleet.linuxserver.io/) or [Bitnami](https://bitnami.com/stacks/containers). 

We take do take a similar approach but instead of appending a `-ls69` or `-r420` prefix to the tag we instead insist on pinning to the sha256 digest of the image, while this is not as pretty it is just as functional in making the images immutable.

| Example Tag                                        | Immutable |
|----------------------------------------------------|-----------|
| `ghcr.io/onedr0p/sonarr:rolling`                   | ❌         |
| `ghcr.io/onedr0p/sonarr:3.0.8.1507`                | ❌         |
| `ghcr.io/onedr0p/sonarr:rolling@sha256:8053...`    | ✅         |
| `ghcr.io/onedr0p/sonarr:3.0.8.1507@sha256:8053...` | ✅         |

_If pinning an image to the sha256 digest, [Renovate](https://github.com/renovatebot/renovate) also supports updating the container on a digest or application version change._

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

## Automated Tags

Here's and example of how tags are created in the GitHub workflows, be careful with `metadata.json` as it does affect the outcome of how the tags will be created when the application is built.

```bash
ubuntu:focal-rolling        # stable=true       # base=true
ubuntu:focal-19880312       # stable=true       # base=true
alpine:rolling              # stable=true       # base=true
alpine:3.16.0               # stable=true       # base=true
sonarr-develop:3.0.8.1538   # stable=false      # base=false
sonarr-develop:rolling      # stable=false      # base=false
sonarr:3.0.8.1507           # stable=true       # base=false
sonarr:rolling              # stable=true       # base=false
```