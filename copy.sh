#!/bin/bash

# Directory to search for files
SRC_DIR="/home/E2982/public_html"
# Remote user and server information
login="E2982@158.129.0.29"
REMOTE_DIR="/home/E2982/root"

# Create a temporary directory for organizing files
TEMP_DIR=$(mktemp -d)

# Find files created this year (2024) and organize them into months
find "$SRC_DIR" -type f -newermt "2024-01-01" ! -newermt "2025-01-01" | while read -r file; do
    # Get the month of the file's modification time
    month=$(date -r "$file" +%m)

    # Create the month directory in the temporary location
    mkdir -p "$TEMP_DIR/$month"

    # Copy the file to the corresponding month directory
    cp "$file" "$TEMP_DIR/$month/"
done

# Notify user about server login for creating the root directory
echo "Connecting to the server to create the root directory..."
ssh "$login" "mkdir -p '$REMOTE_DIR'"

# Notify user about server login for deleting existing files and directories
echo "Connecting to the server to delete existing files and directories in the root directory..."
ssh "$login" "rm -rf '$REMOTE_DIR/'* '$REMOTE_DIR'/.* 2>/dev/null"

# Notify user about server login for copying files
echo "Connecting to the server to copy files..."
scp -r "$TEMP_DIR/"* "$login":"$REMOTE_DIR/"

# Notify user that password is needed for creating statistics files
echo "Password needed to create statistics files on the server."

# Create statistics.txt in each month directory on the remote server
ssh "$login" bash <<EOF
for month_dir in "$REMOTE_DIR/"*/; do
    # Get the month number (directory name)
    month=\$(basename "\$month_dir")

    # Get the list of files in the month directory
    files=( "\$month_dir"* )
    
    # Count the number of files
    num_files=\${#files[@]}

    # Calculate the total size of files in bytes
    total_size=0
    for file in "\${files[@]}"; do
        total_size=\$((total_size + \$(stat -c %s "\$file")))
    done

    # Create statistics.txt in the month directory
    {
        echo "Number of files : \$num_files"
        echo "File Space : \$total_size bytes."
        echo ""
        echo "Files:"
        for file in "\${files[@]}"; do
            echo "\$(basename "\$file")"
        done
    } > "\$month_dir/statistics.txt"
done
EOF

# Clean up: remove the temporary directory
rm -rf "$TEMP_DIR"
