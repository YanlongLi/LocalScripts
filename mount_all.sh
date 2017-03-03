#!/usr/bin/env bash

# case $1 in
#   -u )
#     sudo umount "$2"
#     ;;
#   * )
#     read -s -p "Enter Password for $user@microsoft.com: " pass
#     ;;
# esac

user=$USER
domain=fareast
shared=$1
mountpoint=$2
uid=`id -u`
gid=`id -g`
read -s -p "Enter Password for $user@microsoft.com: " pass

lst=(
//YANLL-WORK/d\$:/d 
# //suzhost-23/d\$/:/23 
  # //suzhost-23/d\$/users:/23users 
//suzhost-23/d\$/users/yanll/git:/git
  # //suzhost-23/d\$/users/yanll:/23 
# //suzhost-23/Threshold:/Threshold 
# //suzhost-16/LUManagerFilesRoot:/16 
# //STCVM-766/d\$/:/766 
# //suzhost-24/th/:/24 
)

for item in ${lst[@]}; do
  remote=${item%:*}
  point=${item#*:}
  mountpoint "$point" > /dev/null
  if [ $? -eq 0 ]; then
    echo "$remote is mounted at $point already"
  else
    sudo mount -t cifs -o user=$user,password=$pass,domain=$domain,uid=$uid,gid=$gid $remote $point
    [ $? -ne 0 ] && echo "failed for $remote"
  fi
done
