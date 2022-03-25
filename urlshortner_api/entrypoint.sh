#!/bin/sh
# docker entrypoint script that waits for the DB to be available and then
# sets up the DB before starting the URL Shortner API app.

# Wait until Postgres is ready
until pg_isready -q -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER
do
  >&2 echo "$(date) - waiting for database to start."
  sleep 1
done

print_db_name() {
  `PGPASSWORD=$DATABASE_PASS psql -h $DATABASE_HOST -U $DATABASE_USER -Atqc "\\list $DATABASE_NAME"`
}

# Wait until the database is created
while [[ -z print_db_name ]]
do
  >&2 echo "$(date) - waiting for $DATABASE_NAME database to be created."
  sleep 1
done

# Run Ecto migration
/app/bin/migrate

# Start the app by replacing this the current shell
exec "/app/bin/server"