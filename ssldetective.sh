#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install tools if they are not present
install_tool() {
    if ! command_exists "$1"; then
        echo -e "\n\e[33mInstalling $1...\e[0m"
        apt-get update && apt-get install -y "$2"
    else
        echo -e "\n\e[32m$1 is already installed.\e[0m"
    fi
}

# Function to run commands with pretty output
run_command() {
    echo -e "\n\e[36mRunning $1:\e[0m"
    echo -e "\e[34m--------------------------------------------------\e[0m"
    $1 2>&1 | sed 's/^/\t/'
    echo -e "\e[34m--------------------------------------------------\e[0m"
}

# Counter for successful tests
successful_tests=0
total_tests=0

# Array to store issues
declare -a issues

# Ensure the system is updated
echo -e "\e[33mUpdating package lists...\e[0m"
apt-get update -qq

# Install required tools
install_tool sslscan sslscan
((total_tests++))

if ! command_exists testssl.sh; then
    echo -e "\n\e[33mInstalling testssl.sh...\e[0m"
    git clone --depth 1 https://github.com/drwetter/testssl.sh.git /opt/testssl.sh
    ln -s /opt/testssl.sh/testssl.sh /usr/local/bin/testssl.sh
else
    echo -e "\n\e[32mtestssl.sh is already installed.\e[0m"
fi
((total_tests++))

install_tool hexdump bsdmainutils
((total_tests++))

install_tool dig dnsutils
((total_tests++))
install_tool host bind9-host
((total_tests++))
install_tool nslookup dnsutils
((total_tests++))

# Prompt for target
read -p "Enter the target (e.g., example.com:443): " TARGET

# Run sslscan
if run_command "sslscan $TARGET"; then
    ((successful_tests++))
else
    issues+=("sslscan failed to run successfully")
fi
((total_tests++))

# Run testssl.sh
output=$(run_command "testssl.sh $TARGET")
if [ $? -eq 0 ]; then
    ((successful_tests++))
else
    issues+=("testssl.sh failed to run successfully")
fi
((total_tests++))

# Parse testssl.sh output for vulnerabilities
if echo "$output" | grep -q "VULNERABLE"; then
    vulnerabilities=$(echo "$output" | grep "VULNERABLE" | awk -F',' '{print $1}')
    for vuln in $vulnerabilities; do
        issues+=("Vulnerability found: $vuln")
    done
fi

# Check for certificate issues in testssl.sh output
if echo "$output" | grep -q "NOT ok"; then
    cert_issues=$(echo "$output" | grep "NOT ok")
    issues+=("$cert_issues")
fi

# Display results summary
echo -e "\n\e[32mTest Results Summary:\e[0m"
echo -e "\e[32mTotal tests run: $total_tests\e[0m"
echo -e "\e[32mSuccessful tests: $successful_tests\e[0m"
echo -e "\e[32mFailed tests: $((total_tests - successful_tests))\e[0m"

# List all issues
if [ ${#issues[@]} -gt 0 ]; then
    echo -e "\n\e[31mIssues/Problems Found:\e[0m"
    for issue in "${issues[@]}"; do
        echo -e "\e[31m- $issue\e[0m"
    done
else
    echo -e "\n\e[32mNo issues or problems were found.\e[0m"
fi

echo -e "\n\e[32mAll tests completed.\e[0m"
