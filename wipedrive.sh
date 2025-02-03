#!/bin/bash

# List all available drives
echo "Available Drives:"
select DEVICE in /dev/sd*; do
    if [ -n "$DEVICE" ]; then
        echo "You selected $DEVICE."
        break
    else
        echo "Invalid selection, please try again."
    fi
done

# Confirm the wipe action
read -p "WARNING: This will erase all data on $DEVICE. Type 'YES' to proceed: " CONFIRM
if [ "$CONFIRM" != "YES" ]; then
    echo "Wipe Aborted."
    exit 1
fi

echo "Wiping $DEVICE..."
sleep 3

# Pass 1: Zero fill
echo "Pass 1/3: /dev/zero"
dd if=/dev/zero of="$DEVICE" bs=1M status=progress
sync

# Pass 2: Random data
echo "Pass 2/3: /dev/urandom"
dd if=/dev/urandom of="$DEVICE" bs=1M status=progress
sync

# Pass 3: Zero fill again
echo "Pass 3/3: /dev/zero..."
dd if=/dev/zero of="$DEVICE" bs=1M status=progress
sync

echo "Secure wipe complete!"
exit 0

#Key changes:
#List Drives: Instead of expecting the device as an argument, the script uses the select command to show available drives (/dev/sd*), which should match typical drive names on Linux. This allows the user to select the device by number.

#User Selection: The select loop waits for the user to pick a valid option (matching a drive) before continuing. If an invalid selection is made, it prompts again.

#Usage:
#Run the script.
#A list of available drives (like /dev/sda, /dev/sdb, etc.) will appear with numbered options.
#The user can type the number corresponding to the drive they wish to wipe.
#The script then asks for confirmation before proceeding with the secure wipe.
#This provides a much safer and more user-friendly method to select and wipe drives.