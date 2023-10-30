#!/bin/bash

set -e

rabbitmq-server -detached
/usr/local/bin/wait-for-it.sh localhost:5672 --timeout=60 --strict -- echo "Server started"

# Function to handle command errors
handle_error() {
    exit_code=$?
    echo "An error occurred with exit code: $exit_code"
    echo "Continuing execution..."
}

# Trap command errors and continue execution
trap handle_error ERR

# Create additional users
for user in $(echo $RABBITMQ_USERS | tr "," " "); do
    username=$(echo $user | cut -d: -f1)
    password=$(echo $user | cut -d: -f2)

    # Try executing each command and continue execution even if there are errors
    rabbitmqctl add_user $username $password || true
    rabbitmqctl set_user_tags $username administrator || true
    rabbitmqctl set_permissions -p $RABBITMQ_DEFAULT_VHOST $username ".*" ".*" ".*" || true

    echo "User $username created."
done

# Keep the script running in the foreground
# tail -f /dev/null
rabbitmqctl stop
rabbitmq-server
