#!/bin/bash

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" 2>/dev/null)

EC2_INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)

EC2_INSTANCE_REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/region/ 2>/dev/null)

EC2_INSTANCE_NAME=$(/usr/local/bin/aws ec2 describe-tags --region $EC2_INSTANCE_REGION --filters "Name=resource-id,Values=$EC2_INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)

echo "Collecting Tomcat metrics for instance name:$EC2_INSTANCE_NAME | id:$EC2_INSTANCE_ID | region:$EC2_INSTANCE_REGION"

HEAP_MEM_USED=$(curl --silent --user "tomcat-jmx:tomcat-jmx" "http://localhost:8080/manager/jmxproxy/?get=java.lang:type=Memory&att=HeapMemoryUsage&key=used" |  awk '{ print $12 }')
HEAP_MEM_MAX=$(curl --silent --user "tomcat-jmx:tomcat-jmx" "http://localhost:8080/manager/jmxproxy/?get=java.lang:type=Memory&att=HeapMemoryUsage&key=max" |  awk '{ print$12 }')
HEAP_MEM_USED_PERCENT=$((100* $HEAP_MEM_USED/$HEAP_MEM_MAX))

/usr/local/bin/aws cloudwatch put-metric-data --metric-name heap_mem_used --dimensions ResourceName=$EC2_INSTANCE_NAME,InstanceId=$EC2_INSTANCE_ID,Object="Tomcat" --namespace "Custom" --value $HEAP_MEM_USED --unit Bytes
/usr/local/bin/aws cloudwatch put-metric-data --metric-name heap_mem_max --dimensions ResourceName=$EC2_INSTANCE_NAME,InstanceId=$EC2_INSTANCE_ID,Object="Tomcat" --namespace "Custom" --value $HEAP_MEM_MAX --unit Bytes
/usr/local/bin/aws cloudwatch put-metric-data --metric-name heap_mem_used_percent --dimensions ResourceName=$EC2_INSTANCE_NAME,InstanceId=$EC2_INSTANCE_ID,Object="Tomcat" --namespace "Custom" --value $HEAP_MEM_USED_PERCENT --unit Percent

echo "Getting Java Heap mem used, max, used percent: $HEAP_MEM_USED, $HEAP_MEM_MAX, $HEAP_MEM_USED_PERCENT"