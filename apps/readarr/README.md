# readarr

## Custom environment configuration

This container support setting certain custom enviroment variables with the use of [drone/envsubst](https://github.com/drone/envsubst).

| Name                             | Default             |
|----------------------------------|---------------------|
| READARR__ANALYTICS_ENABLED       | `False`             |
| READARR__API_KEY                 |                     |
| READARR__AUTHENTICATION_METHOD   | `None`              |
| READARR__AUTHENTICATION_REQUIRED |                     |
| READARR__BRANCH                  | _(current channel)_ |
| READARR__INSTANCE_NAME           | `Readarr`           |
| READARR__LOG_LEVEL               | `info`              |
| READARR__PORT                    | `8787`              |
| READARR__POSTGRES_HOST           |                     |
| READARR__POSTGRES_MAIN_DB        |                     |
| READARR__POSTGRES_LOG_DB         |                     |
| READARR__POSTGRES_CACHE_DB       |                     |
| READARR__POSTGRES_PASSWORD       |                     |
| READARR__POSTGRES_PORT           | `5432`              |
| READARR__POSTGRES_USER           |                     |
| READARR__URL_BASE                |                     |
