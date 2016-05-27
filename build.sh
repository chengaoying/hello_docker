#!/bin/bash
#根据时间生成版本号
REG_URL='web3:5000'
TAG=$REG_URL/$JOB_NAME:`date +%y%m%d-%H-%M`
#使用maven 镜像进行编译 打包出 war 文件 （其他语言这里换成其他编译镜像）
docker run --rm --name mvn  -v /mnt/maven:/root/.m2 -v /mnt/jenkins_home/workspace/$JOB_NAME:/usr/src/mvn -w /usr/src/mvn/ maven:3.3.3-jdk-8 mvn clean install -Dmaven.test.skip=true
#使用我们刚才写好的 放在项目下面的Dockerfile 文件打包 
docker build -t  $TAG  $WORKSPACE/.
#docker push   $TAG
#docker rmi $TAG
# 如果有以前运行的版本就删了 
if docker ps -a | grep -i $JOB_NAME; then
	docker stop $JOB_NAME
	docker rm $JOB_NAME
fi
#运行到集群
docker run  -d  -p 8000:8080  --name $JOB_NAME  $TAG