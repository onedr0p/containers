# whisparr

## Custom environment configuration

This container support setting certain custom enviroment variables with the use of [drone/envsubst](https://github.com/drone/envsubst).

| Name                            | Default             |
|---------------------------------|---------------------|
| WHISPARR__ANALYTICS_ENABLED       | `False`             |
| WHISPARR__API_KEY                 |                     |
| WHISPARR__AUTHENTICATION_METHOD   | `None`              |
| WHISPARR__AUTHENTICATION_REQUIRED |                     |
| WHISPARR__BRANCH                  | _(current channel)_ |
| WHISPARR__INSTANCE_NAME           | `whisparr`            |
| WHISPARR__LOG_LEVEL               | `info`              |
| WHISPARR__PORT                    | `8989`              |
| WHISPARR__POSTGRES_HOST           |                     |
| WHISPARR__POSTGRES_MAIN_DB        |                     |
| WHISPARR__POSTGRES_LOG_DB         |                     |
| WHISPARR__POSTGRES_PASSWORD       |                     |
| WHISPARR__POSTGRES_PORT           | `5432`              |
| WHISPARR__POSTGRES_USER           |                     |
| WHISPARR__URL_BASE                |                     |
