#!/bin/bash

# This script creates a pull request in GitHub with updated PNGs.
#
# Warning: this script creates/deletes branches and creates a PR so modify with caution.
# Note: it should be run only using CI/CD. You should probably never run it on your own.

set -euo pipefail

BRANCH_NAME=$1
TARGET_BRANCH=$2
TITLE=$3
DESCRIPTION=$4
ASSIGNEE=$5
REVIEWER=$6
TOKEN=$7

# Creates a pull request from branch [BRANCH_NAME] to [TARGET_BRANCH] which is defined in
# script parameters. Uses curl to post the pull request into GitHub's REST API v3.
pullRequestBody="{
    \"title\": \"${TITLE}\",
    \"head\": \"${BRANCH_NAME}\",
    \"base\": \"${TARGET_BRANCH}\",
    \"body\": \"${DESCRIPTION}\",
    \"assignees\": [\"${ASSIGNEE}\"],
    \"reviewers\": [\"${REVIEWER}\"]
}"

githubApiUrl="https://api.github.com/repos/${{ github.repository }}/pulls"

# Create a pull request
curl -X POST "${githubApiUrl}" \
    --header "Authorization: token ${TOKEN}" \
    --header "Content-Type: application/json" \
    --data "${pullRequestBody}"

echo "Opened a new pull request: ${BRANCH_NAME} -> ${TARGET_BRANCH}."