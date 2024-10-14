#!/bin/bash

# Function to install pdftotext
install_pdftotext() {
    # Detect the package manager and install accordingly
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get update
        sudo apt-get install -y poppler-utils
    elif [ -x "$(command -v yum)" ]; then
        sudo yum install -y poppler-utils
    elif [ -x "$(command -v brew)" ]; then
        brew install poppler
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf install -y poppler-utils
    else
        echo "Package manager not supported. Please install pdftotext manually."
        exit 1
    fi
}

# Check if pdftotext is installed
if ! command -v pdftotext &> /dev/null
then
    echo "pdftotext is not installed. Installing..."
    install_pdftotext
    # Check if the installation was successful
    if ! command -v pdftotext &> /dev/null
    then
        echo "Installation failed. Please install pdftotext manually."
        exit 1
    fi
fi

# Check if a file was passed as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 filename.pdf"
    exit 1
fi

# Extract the first line of the PDF text
first_line=$(pdftotext "$1" - | head -n 1)

# Check if the first line is not empty
if [ -z "$first_line" ]; then
    echo "No text found in the PDF."
    exit 1
fi

# Clean the first line to make it filename-safe (remove/replace spaces and special characters)
safe_name=$(echo "$first_line" | tr -dc '[:alnum:]\n\r' | sed 's/ /_/g')

# Check if the safe name is not empty
if [ -z "$safe_name" ]; then
    echo "Could not create a valid file name."
    exit 1
fi

# Rename the file
new_name="${safe_name}.pdf"
mv "$1" "$new_name"

echo "File renamed to: $new_name"
