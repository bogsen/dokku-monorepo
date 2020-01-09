#! /usr/bin/env bash

set -e

APP=$1

while IFS="=" read -u 10 -a line || [[ -n $line ]]; do
  [[ "${line[0]}" == "#"* || "${line[1]}" == "" ]] && continue
  [[ $APP != *"${line[0]}"* ]] && continue

  app_subdir="${line[1]}"
  dockerfile_path="./${app_subdir}/Dockerfile"

  [[ ! -e $dockerfile_path ]] && \
    dokku_log_info2 "The application $APP is missing a Dockerfile at $app_subdir/Dockerfile" && \
    exit 1

  echo "Building using Dockerfile from ./$app_subdir"
  DOCKER_BUILDKIT=1 docker build --file $dockerfile_path .

  exit
done 10<"./.dokku-monorepo"

echo "The application $APP is not defined in .dokku-monorepo!"
exit 1