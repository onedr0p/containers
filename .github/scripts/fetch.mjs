#!/usr/bin/env zx

// Builds a JSON string what images and their channels to process
// [
//   {"app":"ubuntu", "channel": "focal"},
//   {"app"...
// ]

$.verbose = false
import { Published } from './published.mjs';

let output = []
for (const path of await glob(['apps/*/metadata.json'])) {
  let {app, channels} = await fs.readJson(path);

  for (const channel of channels) {
    let publishedVersion = await Published(app, channel.name, channel.stable)
    let upstreamVersion = await $`./.github/scripts/upstream.sh ${app} ${channel.name}`

    if (publishedVersion != upstreamVersion.stdout) {
      output.push({"app": app, "channel": channel.name})
    }
  }
}

console.log(`::set-output name=changes::${JSON.stringify(output)}`)
