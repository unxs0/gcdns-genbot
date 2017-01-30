#!/bin/sh
/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file=/var/local/dockprox/gc-credentials.json;
if [ $? != 0 ];then
	exit 2;
fi
if [ "$cGCDNSProject" != "" ];then
	/google-cloud-sdk/bin/gcloud config set project $cGCDNSProject;
	if [ $? != 0 ];then
		exit 1;
	fi
else
	echo "No cGCDNSProject set";
	exit 3;
fi
exit 0;
