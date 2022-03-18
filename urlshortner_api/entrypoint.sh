#!/bin/sh
# docker entrypoint script that sets up the DB before starting the URL Shortner API app.

# Run Ecto migration
/app/bin/migrate

# Start the app by replacing this the current shell
exec "/app/bin/server"