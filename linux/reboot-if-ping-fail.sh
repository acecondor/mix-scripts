#!/bin/bash
#cron: /10 * * * * /var/scripts/ping_reboot.sh >> /var/scripts/ping_reboot_cron.log 2>&1

# redirect stdout/stderr to a file
exec >/var/scripts/ping_reboot.log 2>&1 #replace 'exec >' with 'exec >>' for append all events

echo '- - - - - - - - - - - - - - - - - - - - - -'
echo $(date '+%Y-%m-%d %H:%M:%S')' >>> Start script'

generate_ping_reboot_script() {
    #Define the hosts to ping
    HOSTS=("192.168.1.1" "192.168.1.10" "192.168.1.100") #You can modify these hosts

    # Initialize a variable to check ping success
    all_failed=true

    # Loop through each host and ping
    for HOST in "${HOSTS[@]}"; do
        if ping -c 1 "$HOST" &> /dev/null; then
            echo "Ping to $HOST succeeded."
            all_failed=false
            break # Exit loop if at least one ping succeeds
        else
            echo "Ping to $HOST failed."
        fi
        sleep 2
    done

    # Reboot if all pings failed
    if [ "$all_failed" = true ]; then
        echo "All pings failed. Rebooting the system..."
        # Uncomment the next line to enable reboot
        #sudo reboot
    else
        echo "At least one host is reachable. No action needed."
    fi
}

# Call the function to execute
generate_ping_reboot_script
