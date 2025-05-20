#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
echo "Initializing Containerized Virtual OS..."

# Load environment variables
echo "DEBUG: Loading environment variables from /vos/config/environment.conf"
while read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    export "$line"
    echo "DEBUG: Exported environment variable: $line"
done < /vos/config/environment.conf

# Define a function for error handling
handle_error() {
    if [ "$1" -ne 0 ]; then
        echo "ERROR: $2 failed with exit code $1"
        exit 1
    fi
}

echo "DEBUG: Processing users from /vos/config/users.conf"
# Process users with hashed passwords
while IFS=: read -r username password_hash uid gid groups; do
    [[ -z "$username" || "$username" =~ ^# ]] && continue

    echo "DEBUG: Creating user: $username with uid=$uid, gid=$gid, groups=$groups"
    # Create user without password
    adduser -D -u "$uid" -g "$gid" "$username"
    handle_error "$?" "adduser for $username"

    # Set pre-hashed password directly
    echo "DEBUG: Setting password for $username"
    echo "$username:$password_hash" | chpasswd -e
    handle_error "$?" "chpasswd for $username"

    # Handle groups
    if [[ -n "$groups" ]]; then
        echo "DEBUG: Adding $username to groups: $groups"
        usermod -aG "$groups" "$username"
        handle_error "$?" "usermod for $username"
    fi

    # Create home directory
    echo "DEBUG: Creating home directory for $username"
    mkdir -p "/vos/fs/home/$username"
    handle_error "$?" "mkdir for $username"
    echo "DEBUG: Setting ownership of home directory for $username"
    chown "$username:$gid" "/vos/fs/home/$username"
    handle_error "$?" "chown for $username"

    # Set shell and home directory
    usermod -s "$SHELL" -d "/vos/fs/home/$username" "$username"
    handle_error "$?" "usermod -s -d for $username"

done < /vos/config/users.conf

echo "DEBUG: Running /vos/scripts/setup_environment.sh"
/vos/scripts/setup_environment.sh
handle_error "$?" "/vos/scripts/setup_environment.sh"

echo -e "\nContainerized Virtual OS Ready!"
echo "DEBUG: Running /vos/scripts/login.sh"
/vos/scripts/login.sh
handle_error "$?" "/vos/scripts/login.sh"
