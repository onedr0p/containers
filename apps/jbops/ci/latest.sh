#!/usr/bin/env bash
git clone --quiet https://github.com/blacktwin/JBOPS.git /tmp/jbops
pushd /tmp/jbops > /dev/null || exit
number_of_commits=$(git rev-list --count --first-parent HEAD)
popd > /dev/null || exit
rm -rf /tmp/jbops
printf "1.0.%d" "${number_of_commits}"
