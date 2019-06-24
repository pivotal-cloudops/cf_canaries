#!/usr/bin/env bash

set -euo pipefail

: ${ZERO_DOWNTIME_COUNT:?}
: ${INSTANCE_CANARY_COUNT:?}
: ${CANARY_APP_DOMAIN:?}
: ${CF_USERNAME:?}
: ${CF_PASSWORD:?}
: ${CANARY_ORG:?}
: ${CANARY_SPACE:?}

CF_API_ENDPOINT='api.run.pivotal.io'

cd canaries-repo

bundle

bundle exec rake spec

gem build cf_canaries.gemspec
gem install cf_canaries-0.1.3.gem

canaries --number-of-zero-downtime-apps="$ZERO_DOWNTIME_COUNT" \
           --number-of-instances-canary-instances="$INSTANCE_CANARY_COUNT" \
           --app-domain="$CANARY_APP_DOMAIN" \
           --target="$CF_API_ENDPOINT" \
           --username="$CF_USERNAME" \
           --password="$CF_PASSWORD" \
           --organization="$CANARY_ORG" \
           --space="$CANARY_SPACE"
