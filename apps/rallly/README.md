# rallly

## Custom environment configuration

This container support setting certain custom enviroment variables with the use of [drone/envsubst](https://github.com/drone/envsubst).

| Name                 | Default                                          |
|----------------------|--------------------------------------------------|
| NEXT_PUBLIC_BASE_URL | `http://localhost:3000`                          |
| DATABASE_URL         | `postgres://postgres:postgres@localhost:5432/db` |
| SECRET_PASSWORD      | `minimum-32-characters`                          |
| SUPPORT_EMAIL        | `foo@yourdomain.com`                             |
| SMTP_HOST            | `your-smtp-server`                               |
| SMTP_PORT            | `587`                                            |
| SMTP_SECURE          | `false`                                          |
| SMTP_USER            | `your-smtp-user`                                 |
| SMTP_PWD             | `your-smtp-password`                             |

## Additional requirements
In your kubernetes manifest override CMD with `sh -c "yarn prisma migrate deploy --schema prisma/schema.prisma && yarn start"`.

This is due to rallly's choice to only support postgres as db provider which is unavailable in this repo's testing framework.
In order to verify the success of the build process the image's CMD had to be set to `sh -c "yarn start"`.
If left untouched the database will not be populated.
