#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read and write access to the repository
function list_users_with_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint")"

    # Display the list of collaborators with read (pull) access
    echo "Users with read (pull) access to ${REPO_OWNER}/${REPO_NAME}:"
    echo "$(echo "$collaborators" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with write (push) access
    echo "Users with write (push) access to ${REPO_OWNER}/${REPO_NAME}:"
    echo "$(echo "$collaborators" | jq -r '.[] | select(.permissions.push == true) | .login')"
}

# Main script
echo "Listing users with read and write access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_access
