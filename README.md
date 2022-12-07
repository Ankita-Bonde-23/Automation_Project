# Automation_Project

This script performs the following tasks :-
1] Updates required packages 
2] Checks Apache2 installed or not , else installs it .
3] Checks Apache2 service status , and runs it.
4] Enables Apache service , if it is Disabled.
5] Archives the apache2-httpd logs 
6] Uploades the archived file in the S3 Bucket.
7] Initializes the required inventory file variables
8] Creates inventory.html if not present
9] creates a cron job file 

#Make the script executible

chmod  +x  /root/Automation_Project/automation.sh

#switch to root user with sudo su

sudo  su

./root/Automation_Project/automation.sh

# or run with sudo privileges
sudo ./root/Automation_Project/automation.sh

