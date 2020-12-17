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

read -r -p "Are you sure you want to proceed with install (Y/N)? "  response
response=$(tr [A-Z] [a-z] <<< ${response})
#response=${response,,}
if [[ $response =~ ^(yes|y)$ ]]
then
	    echo -e "${green}Starting the deployment...${nc}"
    else
	        echo -e "${red}Aborting. Fix your configuration and try again.${nc}"
		    exit -1
fi


kubectl create ns apps
sleep 10 && kapp deploy -n apps -a cert-manager -f ${HOMEPREFIX}/cert-manager.v1.0.3.yaml -y
sleep 15 && kapp deploy -n apps -a kpack -f ${HOMEPREFIX}/kpack-v0.0.9.yaml -y
sleep 15 && kapp deploy -n apps -a riff-builders -f ${HOMEPREFIX}/${HOMEPREFIX}-riff-builders.yaml -y
sleep 15 && kapp deploy -n apps -a riff-build -f ${HOMEPREFIX}/${HOMEPREFIX}-riff-build.yaml -y
sleep 15 && kapp deploy -n apps -a riff-knative-runtime -f ${HOMEPREFIX}/${HOMEPREFIX}-riff-knative-runtime.yaml -y  
sleep 15 && kapp deploy -n apps -a keda -f ${HOMEPREFIX}/keda-2.0.0-1.5.1.yaml -y
sleep 15 && kapp deploy -n apps -a riff-streaming-runtime -f ${HOMEPREFIX}/${HOMEPREFIX}-riff-streaming-runtime.yaml -y

helm repo add incubator https://storage.googleapis.com/kubernetes-charts-incubator
kubectl create namespace kafka
helm install kafka --namespace kafka incubator/kafka --set replicas=1 --set zookeeper.replicaCount=1 --wait
