#!/bin/bash

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found"
    exit 1
fi

# Load environmental variables
source .env

# Convert TARGET_DATABASES to an array
IFS=',' read -ra DATABASES <<< "$TARGET_DATABASES"

# Loop through each database
for DB in "${DATABASES[@]}"; do
    # Assign filename variable
    DATE=$(date +"%m-%d-%Y")
    FILENAME="$DB-$DATE.sql"

    # Check and delete oldest backups if needed
    BACKUPS=$(ls -1t $OUTPUTDIR/$DB-* 2>/dev/null | wc -l)
    if [ $BACKUPS -ge $MAX_BACKUPS ]; then
        OLDEST=$(ls -1t $OUTPUTDIR/$DB-* | tail -n 1)
        rm "$OLDEST"
    fi

    # Execute pg_dump command
    pg_dump -h "$POSTGRESQL_HOST" -p "$POSTGRESQL_PORT" -d "$DB" -U "$POSTGRESQL_ADMIN_ACCOUNT" -W "$POSTGRESQL_ADMIN_PASSWORD" > "$OUTPUTDIR/$FILENAME"

    # Check if pg_dump was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to backup $DB"
        exit 1
    fi

    # Log backup message
    TIMESTAMP=$(date +"%m/%d/%Y %H:%M:%S")
    logger "Backed up $DB from $POSTGRESQL_HOST to $OUTPUTDIR on $TIMESTAMP"
done

exit 0
