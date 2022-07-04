# rtorrent

## Custom environment configuration

This container support setting certain custom enviroment variables with the use of [drone/envsubst](https://github.com/drone/envsubst).

| Name                     | Default               |
|--------------------------|-----------------------|
| RTORRENT__BT_PORT        | `50415`               |
| RTORRENT__CONFIG_FILE    | `/config/rtorrent.rc` |
| RTORRENT__DEFAULT_CONFIG | `true`                |
| RTORRENT__SOCKET         | `/sock/rtorrent.sock` |
