#!/usr/bin/env bash

jq --raw-output '.changed_files' <<< '{
    "changed": "true",
    "changed_count": "1",
    "changed_files": "[\"apps/lidarr/metadata.json5\",\"apps/lidarr/Dockerfile\",\"apps/readarr/Dockerfile\"]",
    "changes": "[\"changed\"]"
}' | jq --raw-output '.[] | rtrimstr("/Dockerfile") | rtrimstr("/metadata.json5")' | jo -a | jq '. | unique'
