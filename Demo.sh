# Demo1
# check if glusterd is running now

count=1
if pgrep -x "glusterd" > /dev/null 
then
    echo -e "glusterd has already running now !\n"
else 
	while (( $count <4 ))
	do
    /usr/sbin/glusterd -p /var/run/glusterd.pid --log-level INFO > /dev/null 2>&1
    if pgrep -x "glusterd" > /dev/null
	then 
		break
	else 
		let count++
		continue 
	fi
    done

	if [[ $count -ge 4 ]]
	then
		echo "Running glusterd failed!"
		exit
	else 
		echo "Running glusterd success!"
	fi
fi

# Demo2 
# check if probing peer <node5> is successful
cat /dev/null >demo2.log                # clear demo2.log

command1="gluster peer probe node5"
$command1 >> demo2.log 2>&1 
FIND_FILE="/demo2.log"

cat $FIND_FILE | while read line
do
if [[ $line =~ "success" ]];
then
   echo "Probing success!"	
   break
elif [[ $line =~ "not connected" ]];
then 
	echo "the endpoint is not connected! Please check the client glusterd!! "
	break
elif [[ $line =~ "list" ]]
then 
	echo "node5 is already in peer list!"
	break
fi
done 

#Demo 3
#check if volume creating is success                  
cat  /dev/null > demo3.log
command2="gluster volume create gv0 node4:/SE/gv force"
$command2 >> demo3.log 2>&1
FIND_FILE="/demo3.log"

cat $FIND_FILE | while read line
do
if [[ $line =~ "exists" ]];                  
then 
	echo "volume gv0 has already existed!"
    break
elif [[ $line =~ "success" ]];     
then 
    echo "gluster volume creating success!"	
fi                                                     
done

# Demo4
# check if volume started yet 
cat /dev/null > demo4.log

command3="gluster volume start gv0"    

$command3 > demo4.log 2>&1
FIND_FILE="/demo4.log"

 
cat $FIND_FILE |while read line 
do
if [[ $line =~ "already" ]];                         
then                                                   
	    echo "gluster volume gv0 has already started!"   
		break
elif [[ $line =~ "success" ]];       
then 
		echo "gluster volume gv0 start success!" 
		break
fi
done
