#! /bin/bash
# Note that this script may fail if there are multiple copies running at the same time
# Or if a person is logged into the device Web Management UI
# It should recover on future runs once the contention is released

export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# Default read only user/pass
export CPWUSER=device
export CPWPASS=cyber
# Default IP address
export UPSIP=192.168.105.38

# All HTTP headers are dumped, omit "-D -" to suppress
curl -D - "http://$UPSIP/login_pass.cgi?username=$CPWUSER&password=$CPWPASS&action=LOGIN"
curl -D - -c cookiejar.txt "http://$UPSIP/login_pass.html"
curl -b cookiejar.txt -D - "http://$UPSIP/login_counter.html?stap=1"
curl -b cookiejar.txt -D - "http://$UPSIP/login_counter.html?stap=2"
sleep 1  # This seems to occasionally help
curl -b cookiejar.txt -D - "http://$UPSIP/login_counter.html?stap=2"
curl -b cookiejar.txt -D - "http://$UPSIP/login.cgi?action=LOGIN"
# HTTP headers are written to the top of these files, omit "-D -" to suppress
curl -b cookiejar.txt -D - "http://$UPSIP/get_eventLog.cgi" > eventLog.txt
curl -b cookiejar.txt -D - "http://$UPSIP/get_dataRec.cgi" > dataLog.txt
# This is necessary or future auth attempts will be locked out until some timeout
curl -b cookiejar.txt -D - "http://$UPSIP/logout.html"
