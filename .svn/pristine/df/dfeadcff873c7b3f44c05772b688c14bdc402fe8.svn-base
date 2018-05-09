#!/bin/bash
cur_dir=$(cd `dirname $0`;pwd)
cd $cur_dir

if [[ $# > 2 ]]; then
    echo "input args too much"
    exit 1
fi

if [[ $# == 0 ]]; then
    python ../src/op_record_query.py
fi

if [[ $# == 1 ]]; then
    python ../src/op_record_query.py $1
fi

if [[ $# == 2 ]]; then
    python ../src/op_record_query.py $1 $2
fi
