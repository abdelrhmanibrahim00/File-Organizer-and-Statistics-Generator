# File-Organizer-and-Statistics-Generator

This repository contains a Bash script (copy.sh) that finds files created in the current year within a specified directory (public_html), organizes them by their creation month, and transfers them to a remote server. After transferring, the script creates a statistics.txt file in each month's directory, summarizing the number of files, their total size, and listing their names.
Features

    File Search and Organization: Finds files created in the current year and organizes them into subdirectories based on the month of creation.
    Remote Transfer: Uses ssh and scp to transfer the organized files to a remote server.
    Statistics Generation: Automatically creates a statistics.txt file in each month directory, detailing the number of files, total size, and their names.
    Automated Cleanup: Deletes old files on the remote server before transferring the new ones.

Prerequisites

To run this script, you need:

    Bash: A Bash shell environment.
    SSH Access: Access to a remote server using SSH.
    File Permissions: Proper read/write permissions on both local and remote directories.

How to Use

    Clone the Repository:

    bash

git clone https://github.com/your-username/file-organizer-stats.git

Navigate to the Repository:

bash

cd file-organizer-stats

Edit Configuration Variables:

    Update the following variables in copy.sh to match your environment:
        SRC_DIR: The local directory to search for files (e.g., /home/user/public_html).
        login: Your remote server login (e.g., user@server-ip).
        REMOTE_DIR: The target directory on the remote server (e.g., /home/user/root).

Make the Script Executable:

bash

chmod +x copy.sh

Run the Script:

bash

./copy.sh

Verify Transfer and Statistics:

    The script will prompt for your SSH password to log in and transfer the files. It will then generate a statistics.txt file in each month directory on the remote server.
