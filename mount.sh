#! /bin/bash

count=5
while (( $count<10 )) 
do
  mount -t glusterfs node4:gv0 /gfg > mount.log 2>&1
  if mountpoint -q /gfg    # checking if /geeks is in mounting files
	 then 
		 echo "mounting success! "
	 exit 
  else 
  let count++
  sleep 2
  fi
done
