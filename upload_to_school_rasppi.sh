#!/bin/bash

# Constants
SERVER_IP=""  # Replace with your server's IP address
USERNAME=""    # Replace with your server's login name

# Get the type of upload: file or folder
read -p "Are you uploading a file or folder? (file/folder): " upload_type

# Get the path of the file/folder
read -p "Enter the full path of the $upload_type you want to upload: " upload_path

# Get the remote directory where you want to upload
#read -p "Enter the remote directory on the server (e.g., /home/user/destination): " remote_dir

# Request password, redundant 
#read -sp "Enter the password for the server: " PASSWORD
echo

remote_dir = # Replace with the remote directory where you want to upload


# Check if the path exists
if [ ! -e "$upload_path" ]; then
    echo "The specified $upload_type does not exist."
    exit 1
fi

# Upload logic
if [ "$upload_type" == "file" ]; then
    echo "Uploading file..."
    scp "$upload_path" "$USERNAME@$SERVER_IP:$remote_dir"
elif [ "$upload_type" == "folder" ]; then
    echo "Uploading folder..."
    scp -r "$upload_path" "$USERNAME@$SERVER_IP:$remote_dir"
else
    echo "Invalid input. Please specify 'file' or 'folder'."
    exit 1
fi

# Check if the upload was successful
if [ $? -eq 0 ]; then
    echo "Upload successful."
else
    echo "Upload failed."
fi
