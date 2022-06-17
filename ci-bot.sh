#!/bin/bash -e
#
# Deploy your branch on VIP Go.
# 

set -ex # Change to `set -ex` to debug commands.

#
# If vip-go-ci-tools does not exist, get it in place.
# by fetching and running tools-init. If it does exist,
# run tools-init.sh anyway to check for updates.
#

if [ -d ~/vip-go-ci-tools ] ; then
	bash ~/vip-go-ci-tools/vip-go-ci/tools-init.sh
else
	wget https://raw.githubusercontent.com/Automattic/vip-go-ci/trunk/tools-init.sh -O tools-init.sh && \
	bash tools-init.sh && \
	rm -f tools-init.sh
fi


#
# Make sure to disable PHPCS-scanning by default
#

# PHPCS_ENABLED=${PHPCS_ENABLED:-false}
PHPCS_ENABLED=true
LINTING_ENABLED=false # TODO: 

#
# Actually run vip-go-ci
#

php ~/vip-go-ci-tools/vip-go-ci/vip-go-ci.php --repo-owner="$REPO_ORG" --repo-name="$REPO_NAME" --commit="$PR_HEAD_SHA"  --token="$REPO_TOKEN" --local-git-repo="$GITHUB_WORKSPACE" --phpcs="$PHPCS_ENABLED" --lint="$LINTING_ENABLED"  --phpcs-path="$HOME/vip-go-ci-tools/phpcs/bin/phpcs" --hashes-api=false --hashes-api-url="https://dummyapi.saucal.com" --hashes-oauth-token="aaa" --hashes-oauth-token-secret="aaa" --hashes-oauth-consumer-key="aaa" --hashes-oauth-consumer-secret="aaa" --autoapprove=true --autoapprove-label="hey" --autoapprove-filetypes="json" --informational-msg="this is the informational-msg" --phpcs-sniffs-exclude="WordPress.Files.FileName"
