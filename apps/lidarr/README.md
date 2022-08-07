# lidarr

## Custom environment configuration

This container support setting certain custom enviroment variables with the use of [drone/envsubst](https://github.com/drone/envsubst).

| Name                            | Default             |
|---------------------------------|---------------------|
| LIDARR__ANALYTICS_ENABLED       | `False`             |
| LIDARR__API_KEY                 |                     |
| LIDARR__AUTHENTICATION_METHOD   | `None`              |
| LIDARR__AUTHENTICATION_REQUIRED |                     |
| LIDARR__BRANCH                  | _(current channel)_ |
| LIDARR__INSTANCE_NAME           | `Lidarr`            |
| LIDARR__LOG_LEVEL               | `info`              |
| LIDARR__PORT                    | `8686`              |
| LIDARR__POSTGRES_HOST           |                     |
| LIDARR__POSTGRES_MAIN_DB        |                     |
| LIDARR__POSTGRES_LOG_DB         |                     |
| LIDARR__POSTGRES_PASSWORD       |                     |
| LIDARR__POSTGRES_PORT           | `5432`              |
| LIDARR__POSTGRES_USER           |                     |
| LIDARR__URL_BASE                |                     |
