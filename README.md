# SSLDetective

A simple script to scan and test SSL/TLS configurations on a target server.

## Description

SSLDetective automates the process of checking SSL/TLS settings on a given target (hostname or IP address with port).  It utilizes `sslscan` and `testssl.sh` to gather information and identify potential vulnerabilities.

## Features

*   Checks enabled SSL/TLS protocols and cipher suites.
*   Identifies potential vulnerabilities (e.g., SWEET32, LUCKY13).
*   Validates certificate information.
*   Provides a summary of test results, highlighting issues found.

## Prerequisites

*   A Linux-based system (tested on Debian/Ubuntu).
*   `apt-get` package manager.
*   `git` (for installing `testssl.sh`).
*   Root or sudo privileges (for installing dependencies).

## Installation

1.  Clone the repository:

    ```
    git clone <repository_url>
    cd SSLDetective
    ```

2.  Make the script executable:

    ```
    chmod +x ssldetective.sh
    ```

## Usage

1.  Run the script with sudo or as root:

    ```
    sudo ./ssldetective.sh
    ```

2.  The script will prompt you to enter the target (e.g., example.com:443).

    ```
    Enter the target (e.g., example.com:443):
    ```

3.  The script will install necessary tools (if not already installed) and run the SSL/TLS tests.

4.  Review the output for a summary of results and any identified issues.

## Dependencies

The script relies on the following tools:

*   `sslscan`
*   `testssl.sh`
*   `hexdump`
*   `dig`
*   `host`
*   `nslookup`

These tools will be automatically installed if they are not already present on your system.

## Disclaimer

This script is provided as-is and should be used for informational purposes only. The authors are not responsible for any misuse or damage caused by this script.

## License

This project is dedicated to the public domain.  Feel free to use, modify, and distribute it as you wish, with no attribution required.

