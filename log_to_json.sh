#!/bin/bash

# Get the current date and time
current_time=$(date +"%Y-%m-%d %H:%M:%S")

# Start the JSON output with the last update timestamp
echo '{ "last_update": "'"$current_time"'", "events": ['

# Initialize a flag to check if it's the first item
first_item=true

# Read the log file line by line
while read -r line; do
    # Check if the line is a timestamp (matches YYYY-MM-DD format)
    if [[ "$line" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
        # Print the message and timestamp if both are available
        if [[ -n "$message" ]]; then
            # Escape double quotes in the message
            message=$(echo "$message" | sed 's/"/\\"/g')

            # If it's not the first item, add a comma
            if [ "$first_item" = false ]; then
                echo ","
            fi

            # Print the JSON object for the event
            echo "{\"message\": \"$message\", \"timestamp\": \"$line\"}"

            # Set the first_item flag to false after printing the first event
            first_item=false
        fi
        # Reset the message for the next event
        message=""
    else
        # Append the line to the message
        if [[ -n "$message" ]]; then
            message="$message\n$line"
        else
            message="$line"
        fi
    fi
done < /config/www/event_log_user.txt

# Close the JSON array and object
echo ']}'
