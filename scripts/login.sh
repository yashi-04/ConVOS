#!/bin/bash

# Simple login interface (without password validation)
while true; do
    echo -e "\nContainerized Virtual OS Login"
    read -p "Username: " username
    read -sp "Password: " password
    echo

    # Just check if user exists (since Alpine may not support su password auth)
    if id "$username" &>/dev/null; then
        echo -e "\nWelcome to Containerized Virtual OS, $username!"
        su - "$username"
        break
    else
        echo "Invalid username. Please try again."
    fi
done
