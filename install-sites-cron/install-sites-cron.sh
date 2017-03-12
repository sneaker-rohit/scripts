#!/bin/bash
# Script to install a cronjob that runs the browser and opens the sites of interest to the user.

echo "Specify the user for which you need to install cron"
read user
echo "Enter the site names followed by a space between the names"
read sitenames
echo "Enter your browser"
read browser

# create a shell script for the cron
cat > run-sites.sh <<EOF
#!/bin/bash
$browser $sitenames
EOF
chmod +x run-sites.sh
# setting up the cron for the specified user
echo "@reboot /bin/sh $(pwd)/run-sites.sh" >> /var/spool/cron/crontabs/$user
