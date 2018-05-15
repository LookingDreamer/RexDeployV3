#!/bin/bash
localdir=./
svndir=../svn/
differ=`diff -rbq $localdir  $svndir |grep -v "\.git" |grep -v "\.svn"`

echo -e "$differ\n"  
modifysrc=`echo "$differ"  |grep differ |awk '{print $2}'`
echo -e "修改的文件:\n $modifysrc"
echo "$differ"  |grep differ > /tmp/differ.txt
if [[ $1 -eq 1 ]]; then

     while read file
     do
         src=`echo "$file" |awk '{print $2}'`           
         des=`echo "$file" |awk '{print $4 }'`           
         echo "\cp $src $des"   
         \cp $src $des
     done  < /tmp/differ.txt  
     echo "覆盖完成"   
fi

if [[ "$2"  != "" ]]; then
    cd $svndir
    svn commit -m "$2"
    echo "svn提交完成"
fi


