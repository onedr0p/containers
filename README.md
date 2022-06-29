# Container Images

## Development

1. Install [Docker](https://docs.docker.com/get-docker/), [Taskfile](https://taskfile.dev/) & [Cuelang](https://cuelang.org/)

2. Do things...

3. Use Taskfile to build and test your image

    ```ruby
    task APP=radarr CHANNEL=nightly test
    ```

## Example Tagging Strategies

```bash
ubuntu:focal-rolling        # stable=true       # base=true
ubuntu:focal-19880312       # stable=true       # base=true
alpine:rolling              # stable=true       # base=true
alpine:3.16.0               # stable=true       # base=true
sonarr-develop:0.1.0        # stable=false      # base=false
sonarr-develop:rolling      # stable=false      # base=false
sonarr:1.0.0                # stable=true       # base=false
sonarr:rolling              # stable=true       # base=false
```
