: '
Add a startup script named startJenkinsDocker.sh that starts the Jenkins container
Add a shutdown script named stopJenkinsDocker.sh that stops the Jenkins container
'

: '
FROM jenkins/jenkins:2.452.2-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
'

WORK_DIR=/opt/containers/jenkins
CONTAINER_TAG=fafnir:jenkins
CONTAINER_NAME=fafnir-jenkins

if [ -z "$(docker images -q $CONTAINER_TAG 2> /dev/null)" ]; then
  	# create the network
   	docker network create jenkins
    	#build the image
	docker build -t $CONTAINER_TAG $WORK_DIR
fi

docker run \
  --name $CONTAINER_NAME \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8004:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  $CONTAINER_TAG 
