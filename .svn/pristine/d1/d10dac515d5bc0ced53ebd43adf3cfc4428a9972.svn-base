#!/bin/bash
# set env
cur_dir=$(cd `dirname $0`;pwd)
cd $cur_dir
my_python_lib=$cur_dir/dep/lib
export PYTHONPATH=$my_python_lib:$PYTHONPATH

# run cos sync

# check python env
which python &> /dev/null
if [ $? -ne 0 ]; then
    echo "python env is not ready!"
    exit 1
fi

python_version=`python --version 2>&1 | awk '{print $2}'`
python_major_version=${python_version:0:3}

if [[ $python_major_version != "2.7" ]]; then
    echo "only run in python 2.7.x"
    exit 1
fi

export LANG=en_US.utf8
python src/cos_sync.py
