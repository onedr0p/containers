export async function Published(app, channel, stable) {
  let headers = {}
  if (process.env.TOKEN) {
    headers = {
      Accept: 'application/vnd.github.v3+json',
      Authorization: `token ${process.env.TOKEN}`
    }
  }
  app = (stable ? app : `${app}-${channel}`)
  let res = await fetch(`https://api.github.com/users/onedr0p/packages/container/${app}/versions`, { headers })
  let data = await res.json()
  try {
    // Assume first image found and first tag found is the most recent pushed tag
    return data[0].metadata.container.tags[0];
  } catch {
    console.log(`Error finding published version for ${app}`)
  }
}
