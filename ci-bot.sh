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
PHPCS_ENABLED=${PHPCS_ENABLED:-false}
LINTING_ENABLED=${LINTING_ENABLED:-false}
REPO_ORG="${GITHUB_REPOSITORY_OWNER}"
REPO_NAME="${GITHUB_REPOSITORY#"${REPO_ORG}/"}"

#
# Actually run vip-go-ci
#
# TODO: remove
#   --hashes-api-url
#   --hashes-oauth-token
#   --hashes-oauth-token-secret
#   --hashes-oauth-consumer-key
#   --hashes-oauth-consumer-secret
# arguments
#
php ~/vip-go-ci-tools/vip-go-ci/vip-go-ci.php \
--repo-owner="$REPO_ORG" \
--repo-name="$REPO_NAME" \
--commit="$PR_HEAD_SHA"  \
--token="$REPO_TOKEN" \
--local-git-repo="$GITHUB_WORKSPACE" \
--phpcs="$PHPCS_ENABLED" \
--lint="$LINTING_ENABLED" \
--lint-modified-files-only=true \
--lint-php-version-paths=7.4:/usr/bin/php7.4,8.1:/usr/bin/php8.1 \
--lint-php-versions=7.4,8.1 \
--svg-checks=true \
--svg-scanner-path="$HOME/vip-go-ci-tools/vip-go-svg-sanitizer/svg-scanner.php" \
--phpcs-path="$HOME/vip-go-ci-tools/phpcs/bin/phpcs" \
--hashes-api=false \
--hashes-api-url="https://dummyapi.saucal.com" \
--hashes-oauth-token="aaa" \
--hashes-oauth-token-secret="aaa" \
--hashes-oauth-consumer-key="aaa" \
--hashes-oauth-consumer-secret="aaa" \
--autoapprove=true \
--autoapprove-filetypes="css,csv,eot,gif,gz,ico,ini,jpeg,jpg,json,less,map,md,mdown,mo,mp4,otf,pcss,pdf,po,pot,png,sass,scss,styl,ttf,txt,woff,woff2,yml" \
--autoapprove-php-nonfunctional-changes=true \
--autoapprove-label="auto-approved" \
--informational-msg="This bot provides automated PHP linting and PHPCS scanning." \
--phpcs-standard="WordPress-VIP-Go,PHPCompatibilityWP" \
--repo-options=true \
--repo-options-allowed="skip-execution,skip-draft-prs,lint-modified-files-only,phpcs,phpcs-severity,phpcs-sniffs-include,phpcs-sniffs-exclude,report-no-issues-found,review-comments-sort,review-comments-include-severity,post-generic-pr-support-comments,review-comments-sort,scan-details-msg-include,svg-checks,autoapprove,autoapprove-php-nonfunctional-changes,hashes-api"
