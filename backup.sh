#!/bin/bash

#source /envs
echo "starting sync"

# sync the world dir
/usr/local/bin/aws s3 sync --no-progress "/config/worlds_local/" "$S3_PATH"

echo "sync complete"