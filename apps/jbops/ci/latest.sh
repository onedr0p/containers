#!/usr/bin/env bash
git clone https://github.com/blacktwin/JBOPS.git /tmp/jbops > /dev/null 2>&1
pushd /tmp/jbops > /dev/null || exit
number_of_commits=$(git rev-list --count --first-parent HEAD)
popd > /dev/null || exit
rm -rf /tmp/jbops
printf "%d.%d.%d" "1" "0" "${number_of_commits}"
