#!/bin/bash

while true; do
    echo -e "\nContainerized Virtual OS Login"
    read -p "Username: " username
    read -sp "Password: " password
    echo

    if id "$username" &>/dev/null; then
        # Debug: Show stored hash (SECURITY RISK - DEBUG ONLY)
        stored_hash=$(sudo grep "^$username:" /etc/shadow | cut -d: -f2)
        
        # Generate input hash
        salt=$(echo "$stored_hash" | cut -d'$' -f3)
        input_hash=$(openssl passwd -6 -salt "$salt" "$password")
        
        if [ "$stored_hash" = "$input_hash" ]; then
            echo -e "\nWelcome to Containerized Virtual OS, $username!"
            su - "$username"
            break
        else
            echo "Invalid password. Please try again."
        fi
    else
        echo "Invalid username. Please try again."
    fi
done

