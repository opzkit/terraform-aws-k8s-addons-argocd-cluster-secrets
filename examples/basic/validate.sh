#!/usr/bin/env bash

set -Eeuo pipefail
echo "Checking secret labels"

grep -Fq "a/tag: dev" $1
