#!/usr/bin/env bash

KUBELET_BIN="/usr/local/bin/kubelet"
KUBELET_PID="$(pgrep -f $KUBELET_BIN)"

if [ -z "${KUBELET_PID}" ]; then
    echo "kubelet not found"
    exit 1
fi

# Enter namespaces and run commands
nsrun() {
    nsenter \
        --mount="/host/proc/${KUBELET_PID}/ns/mnt" \
        --net="/host/proc/${KUBELET_PID}/ns/net" \
        -- bash -c "$1"
}

# Trim filesystems
nsrun "grep -v 'kubelet\|tmpfs\|overlay' /proc/self/mountinfo | fstrim --verbose --quiet-unsupported --listed-in -"
