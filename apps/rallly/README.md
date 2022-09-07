# rallly

## Additional requirements
In your kubernetes manifest override CMD with `sh -c "yarn prisma migrate deploy --schema prisma/schema.prisma && yarn start"`.

This is due to rallly's choice to only support postgres as db provider which is unavailable in this repo's testing framework.
In order to verify the success of the build process the image's CMD had to be set to `sh -c "yarn start"`.
If left untouched the database will not be populated.
