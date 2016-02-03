#!/usr/bin/env sh
for job_def in jenkins/jobs/*.xml; do
    job_id=$(basename $job_def |awk -F '.' '{print $1}')
    echo 'creating jenkins job: $job_id'
    cat $job_def |curl -v -XPOST -d @- -H 'Content-Type: application/xml' http://localhost:18080/createItem?name=$job_id
done
