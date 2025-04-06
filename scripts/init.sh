#!/bin/bash

echo "Initializing Containerized Virtual OS..."

while read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    export "$line"
done < /vos/config/environment.conf

while IFS=: read -r username password uid gid groups; do
    [[ -z "$username" || "$username" =~ ^# ]] && continue
    adduser -D -u "$uid" -g "$gid" "$username"
    echo "$username:$password" | chpasswd
    if [[ -n "$groups" ]]; then
        usermod -aG "$groups" "$username"
    fi
    mkdir -p "/vos/fs/home/$username"
    chown "$username:$gid" "/vos/fs/home/$username"
done < /vos/config/users.conf

/vos/scripts/setup_environment.sh

echo -e "\nContainerized Virtual OS Ready!"
/vos/scripts/login.sh
