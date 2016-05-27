#!/bin/bash
#����ʱ�����ɰ汾��
TAG=$JOB_NAME:`date +%y%m%d-%H-%M`
#ʹ��maven ������б��� ����� war �ļ� �������������ﻻ���������뾵��
docker run --rm --name mvn  -v /mnt/maven:/root/.m2 -v /mnt/jenkins/workspace/$JOB_NAME:/usr/src/mvn -w /usr/src/mvn/ maven:3.3.3-jdk-8 mvn clean install -Dmaven.test.skip=true
#ʹ�����Ǹղ�д�õ� ������Ŀ�����Dockerfile �ļ���� 
docker build -t  $TAG  /var/lib/jenkins/workspace/docker-hello-world/Dockerfile
#docker push   $TAG
#docker rmi $TAG
# �������ǰ���еİ汾��ɾ�� 
if docker ps -a | grep -i $JOB_NAME; then
	docker stop $JOB_NAME
	docker rm $JOB_NAME
fi
#���е���Ⱥ
docker run  -d  -p 8000:8080  --name $JOB_NAME  $TAG