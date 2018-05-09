#!/bin/bash
case $1 in
clean )
rm softdir/* configuredir/* remotecomdir/* updatedir/*  -rf
rm -f logs/*.sh
echo "清理完成"
;;
commit )
if [[ $# -ne 2 ]]; then
    echo "commit时必须提交2个参数,且提交注释不能为空"
    exit
fi
msg=$2

if [[ ! -z `git status -s` ]]; then
    echo "开始提交git更新"   
    echo "git status -s"
    git status -s
    echo "git add ."
    git add .
    echo "git commit -m \"$msg\""
    git commit -m "$msg"
    echo "git push origin master"
    git push origin master
    echo "提交git更新完成" 
else
    echo "没有git更新代码"
fi




;;

* )
echo -e "Usage:\n $0 clean \n $0 commit '提交注释'"

;;
esac