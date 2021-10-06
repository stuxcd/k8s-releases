#!/usr/bin/env bash

echo "${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY}" > /etc/passwd-s3fs
chmod 0400 /etc/passwd-s3fs

if [ -z "$(ls -A $MNT_POINT)" ]; then
     S3_EXTRAVARS=''
else
    S3_EXTRAVARS=',nonempty'
fi

/usr/local/bin/s3fs $S3_BUCKET $MNT_POINT -f -o url=${S3_ENDPOINT},allow_other,use_cache=/tmp,max_stat_cache_size=1000,stat_cache_expire=900,retries=5,connect_timeout=10${S3_EXTRAVARS}
