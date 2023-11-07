# transmission

## Custom environment configuration

This container support setting certain custom enviroment variables with the use of [drone/envsubst](https://github.com/drone/envsubst).

| Name                                         | Default                                          |
|----------------------------------------------|--------------------------------------------------|
| TRANSMISSION__ALT_SPEED_TIME_ENABLED         | `false`                                          |
| TRANSMISSION__ALT_SPEED_TIME_END             | `1020`                                           |
| TRANSMISSION__ALT_SPEED_UP                   | `50`                                             |
| TRANSMISSION__BIND_ADDRESS_IPV4              | `0.0.0.0`                                        |
| TRANSMISSION__BIND_ADDRESS_IPV6              | `::`                                             |
| TRANSMISSION__BLOCKLIST_ENABLED              | `true`                                           |
| TRANSMISSION__BLOCKLIST_URL                  | `http://john.bitsurge.net/public/biglist.p2p.gz` |
| TRANSMISSION__CACHE_SIZE_MB                  | `4`                                              |
| TRANSMISSION__DHT_ENABLED                    | `true`                                           |
| TRANSMISSION__DOWNLOAD_DIR                   | `/downloads/complete`                            |
| TRANSMISSION__DOWNLOAD_QUEUE_ENABLED         | `true`                                           |
| TRANSMISSION__DOWNLOAD_QUEUE_SIZE            | `5`                                              |
| TRANSMISSION__ENCRYPTION                     | `1`                                              |
| TRANSMISSION__IDLE_SEEDING_LIMIT             | `30`                                             |
| TRANSMISSION__IDLE_SEEDING_LIMIT_ENABLED     | `false`                                          |
| TRANSMISSION__INCOMPLETE_DIR                 | `/downloads/incomplete`                          |
| TRANSMISSION__INCOMPLETE_DIR_ENABLED         | `true`                                           |
| TRANSMISSION__LPD_ENABLED                    | `false`                                          |
| TRANSMISSION__MESSAGE_LEVEL                  | `2`                                              |
| TRANSMISSION__PEER_CONGESTION_ALGORITHM      |                                                  |
| TRANSMISSION__PEER_ID_TTL_HOURS              | `6`                                              |
| TRANSMISSION__PEER_LIMIT_GLOBAL              | `200`                                            |
| TRANSMISSION__PEER_LIMIT_PER_TORRENT         | `50`                                             |
| TRANSMISSION__PEER_PORT                      | `51413`                                          |
| TRANSMISSION__PEER_PORT_RANDOM_HIGH          | `65535`                                          |
| TRANSMISSION__PEER_PORT_RANDOM_LOW           | `49152`                                          |
| TRANSMISSION__PEER_PORT_RANDOM_ON_START      | `false`                                          |
| TRANSMISSION__PEER_SOCKET_TOS                | `default`                                        |
| TRANSMISSION__PEX_ENABLED                    | `true`                                           |
| TRANSMISSION__PORT_FORWARDING_ENABLED        | `false`                                          |
| TRANSMISSION__PREALLOCATION                  | `1`                                              |
| TRANSMISSION__PREFETCH_ENABLED               | `true`                                           |
| TRANSMISSION__QUEUE_STALLED_ENABLED          | `true`                                           |
| TRANSMISSION__QUEUE_STALLED_MINUTES          | `30`                                             |
| TRANSMISSION__RATIO_LIMIT                    | `2`                                              |
| TRANSMISSION__RATIO_LIMIT_ENABLED            | `false`                                          |
| TRANSMISSION__RENAME_PARTIAL_FILES           | `true`                                           |
| TRANSMISSION__RPC_AUTHENTICATION_REQUIRED    | `false`                                          |
| TRANSMISSION__RPC_BIND_ADDRESS               | `0.0.0.0`                                        |
| TRANSMISSION__RPC_ENABLED                    | `true`                                           |
| TRANSMISSION__RPC_HOST_WHITELIST             |                                                  |
| TRANSMISSION__RPC_HOST_WHITELIST_ENABLED     | `false`                                          |
| TRANSMISSION__RPC_PASSWORD                   |                                                  |
| TRANSMISSION__RPC_PORT                       | `9091`                                           |
| TRANSMISSION__RPC_URL                        | `/transmission/`                                 |
| TRANSMISSION__RPC_USERNAME                   |                                                  |
| TRANSMISSION__RPC_WHITELIST                  |                                                  |
| TRANSMISSION__RPC_WHITELIST_ENABLED          | `false`                                          |
| TRANSMISSION__SCRAPE_PAUSED_TORRENTS_ENABLED | `true`                                           |
| TRANSMISSION__SCRIPT_TORRENT_DONE_ENABLED    | `false`                                          |
| TRANSMISSION__SCRIPT_TORRENT_DONE_FILENAME   |                                                  |
| TRANSMISSION__SEED_QUEUE_ENABLED             | `false`                                          |
| TRANSMISSION__SEED_QUEUE_SIZE                | `10`                                             |
| TRANSMISSION__SPEED_LIMIT_DOWN               | `100`                                            |
| TRANSMISSION__SPEED_LIMIT_DOWN_ENABLED       | `false`                                          |
| TRANSMISSION__SPEED_LIMIT_UP                 | `100`                                            |
| TRANSMISSION__SPEED_LIMIT_UP_ENABLED         | `false`                                          |
| TRANSMISSION__START_ADDED_TORRENTS           | `true`                                           |
| TRANSMISSION__TRASH_ORIGINAL_TORRENT_FILES   | `false`                                          |
| TRANSMISSION__UMASK                          | `2`                                              |
| TRANSMISSION__UPLOAD_SLOTS_PER_TORRENT       | `14`                                             |
| TRANSMISSION__UTP_ENABLED                    | `true`                                           |
| TRANSMISSION__WATCH_DIR                      | `/watch`                                         |
| TRANSMISSION__WATCH_DIR_ENABLED              | `false`                                          |
| TRANSMISSION__WATCH_FORCE_GENERIC            | `false`                                          |
