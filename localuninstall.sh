#!/bin/bash
HOMEPREFIX=${1:-.}
if [[ $# < 1 ]]
then
    echo -e "${red}Aborting. Need folder for yaml files.${nc}"
    exit -1
fi

echo "HOMEPREFIX={"${HOMEPREFIX}"}"

for i in `ls -1 ${HOMEPREFIX}/*.yaml`
do
	echo $i
done

read -r -p "Are you sure you want to proceed with removal (Y/N)? "  response
response=$(tr [A-Z] [a-z] <<< ${response})
#response=${response,,}
if [[ $response =~ ^(yes|y)$ ]]
then
	    echo -e "${green}Starting the removal...${nc}"
    else
	        echo -e "${red}Aborting. Fix your configuration and try again.${nc}"
		    exit -1
fi


helm uninstall kafka --namespace kafka
kubectl delete ns kafka

sleep 10 && kapp delete -n apps -a riff-streaming-runtime -y
sleep 15 && kapp delete -n apps -a keda -y
sleep 15 && kapp delete -n apps -a riff-knative-runtime -y
sleep 15 && kapp delete -n apps -a riff-build -y
sleep 15 && kapp delete -n apps -a riff-builders -y
sleep 15 && kapp delete -n apps -a kpack -y
sleep 15 && kapp delete -n apps -a cert-manager -y

sleep 15 && kubectl delete ns apps
