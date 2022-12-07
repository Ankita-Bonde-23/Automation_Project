#!/bin/bash

my_name=Ankita
timestamp=$(date '+%d%m%Y-%H%M%S')
s3_bucket=upgrad-ankita

#updating the required packages
echo "updating packages";
sudo apt update -y
echo "Completed Updating"

#checking apache2 installed or not if not then installing it.
if echo dpkg --get-selections | grep -q "apache2"
then 
	echo "Apache2 is already installed";
else 
	echo "Apache2 is not installed, so Installing Apache2";
	sudo apt install apache2
	echo "Apache2 Installation completed";	
fi

#checking status of apache2
if systemctl is-active apache2
then
	echo "Apache2 server is already running";
else
	echo "Apache2 server is not running, Starting Apache2 server";
	sudo systemctl start apache2
	echo "Apache2 server is now started";
fi

#checking apache service is enabled or not,else enabling it
if systemctl is-enabled apache2
then
	echo "Apache2 service is already enable";
else
	echo "Apache2 service is disable, Enabling Apache2 service";
	sudo systemctl enable apache2
	echo "Apache2 service is now ebnable";	
fi

#creating archive files of log files
echo "Creating archieve file of log files";
tar -cvf ${my_name}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log
mv ${my_name}-httpd-logs-${timestamp}.tar /tmp/
echo "Archive file ${my_name}-httpd-logs-${timestamp}.tar created on folder /tmp/"


#Copying archive file to S3 bucket
echo "Copying archive file to S3 bucket";
aws s3 cp /tmp/Ankita-httpd-logs-${timestamp}.tar s3://${s3_bucket}


#Task3

#initializing the required variable
inventoryFile=/var/www/html/inventory.html
logType="httpd-logs"
filename=${my_name}-httpd-logs-${timestamp}.tar
type=${filename##*.}
size=$(ls -lh /tmp/${filename}| cut -d " " -f5)

#checking inventory.html file prsesnt or not,else creating it
if ! test -f "$inventoryFile";
then
        echo "Inventory File is not available, creating a Inventory file";
        touch ${inventoryFile}
        echo "<b>Log Type&nbsp;&nbsp;&nbsp;&nbsp;Time Created&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Type&nbsp;&nbsp;Size</b$
fi
        echo "<br>${logType}&nbsp;&nbsp;&nbsp;&nbsp;${timestamp}&nbsp;&nbsp;&nbsp;&nbsp;${type}&nbsp;&nbsp;&nbsp;&nbsp;${size}">>${inventoryFile}
        echo "Inventory file has been updated";

#checking cronfile present or not else creating cronfile
cronFile=/etc/cron.d/automation
if test -f "$cronFile";
then
        echo "Cron Job file is already available";
else
        echo "Cron Job is not available, creating a Cron job file";
        touch ${cronFile}
        echo '1
 * * * * root /root/Automation_Project/automation.sh'>${cronFile}
        echo "Cron Job file has been created";
fi

