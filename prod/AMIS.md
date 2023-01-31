# AMIS

## IDS AMIS

The Amis are and are created and modified in the del-common account - 858599873024 and once modified or created they must be shared with the following accounts:

- 772838718480
- 771030194710
- 459208450119
- 601472654169

### PENULTIMATE

- RHEL-8.4.0-jboss-EWS-v11  - ami-001ab75ce86c79611
- RHEL-8.4.0-jboss-EAP-v9 - ami-0849bfbd70021e4d9

### LATEST

- RHEL-8.4.0-jboss-EWS-v12 - ami-067571912220154fb
- RHEL-8.4.0-jboss-EAP-v10 - ami-02afc147f1644e4f8

## AMIS CHARACTERISTICS TABLE

### JBOSS_EAP

| setting | Value |
|------|---------|
| Versión Java | openjdk version "1.8.0_312" |
| Versión Jboss | JBoss EAP 7.4.0.GA |
| Ruta instalación, variable JBOSS_HOME | /opt/jboss-eap-7.4 |
| Servicio | systemctl [stop/start/restart] jboss-eap-rhel |
| Puerto Servicio | 8080 |
| Valores Xms y Xmx | 4Gb |
| Modo arranque de Servicio | Standalone |
| Usuario Servicio | jboss-eap |
| Logs consola | /var/log/jboss-eap/console.log |
| Logs server | /opt/jboss-eap-7.4/standalone/log |
| Fichero que contiene los DataSources | /opt/jboss-eap-7.4/standalone/configuration/standalone.xml |
| Ruta despliegue aplicaciones | /opt/jboss-eap-7.4/standalone/deployments |
| Filesystem aplicativos | /wl_app con softlinks hacía de wl_intranet y wl_internet |

### JBOSS_EWS

| setting | Value |
|------|---------|
| Versión Java | openjdk version "1.8.0_312" |
| Versión Jboss | Apache Tomcat/9.0.50.redhat-00004 |
| Ruta instalación, variable JBOSS_HOME | /opt/jws-5.6/tomcat |
| Servicio | systemctl [stop/start/restart] jws5-tomcat |
| Puerto Servicio | 8080 |
| Valores Xms y Xmx | 4Gb |
| Logs | /opt/jws-5.6/tomcat/logs |
| Fichero que contiene los DataSources | /opt/jws-5.6/tomcat/conf/context.xml |
| Ruta despliegue aplicaciones | /opt/jws-5.6/tomcat/webapps |
| Filesystem aplicativos | /wl_app con softlinks hacía de wl_intranet y wl_internet |

## SCRIPTS CLOUDWATCH INSIDE AMIS

### SCRIPT TOMCAT (EWS):

``` hcl
#!/bin/bash
TOKEN=$(curl -s -X PUT " http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" 2>/dev/null)

EC2_INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)
EC2_INSTANCE_REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/region/ 2>/dev/null)
EC2_INSTANCE_NAME=$(/usr/local/bin/aws ec2 describe-tags --region $EC2_INSTANCE_REGION --filters "Name=resource-id,Values=$EC2_INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)
echo "Collecting Tomcat metrics for instance name:$EC2_INSTANCE_NAME | id:$EC2_INSTANCE_ID | region:$EC2_INSTANCE_REGION"
HEAP_MEM_USED=$(curl --silent --user "tomcat-jmx:tomcat-jmx" " http://localhost:8080/manager/jmxproxy/?get=java.lang:type=Memory&att=HeapMemoryUsage&key=used" |  awk '{ print $12 }')
HEAP_MEM_MAX=$(curl --silent --user "tomcat-jmx:tomcat-jmx" " http://localhost:8080/manager/jmxproxy/?get=java.lang:type=Memory&att=HeapMemoryUsage&key=max" |  awk '{ print$12 }')
HEAP_MEM_USED_PERCENT=$((100* $HEAP_MEM_USED/$HEAP_MEM_MAX))
/usr/local/bin/aws cloudwatch put-metric-data --metric-name heap_mem_used --dimensions ResourceName=$EC2_INSTANCE_NAME,InstanceId=$EC2_INSTANCE_ID,Object="Tomcat" --namespace "Custom" --value $HEAP_MEM_USED --unit Bytes
/usr/local/bin/aws cloudwatch put-metric-data --metric-name heap_mem_max --dimensions ResourceName=$EC2_INSTANCE_NAME,InstanceId=$EC2_INSTANCE_ID,Object="Tomcat" --namespace "Custom" --value $HEAP_MEM_MAX --unit Bytes
/usr/local/bin/aws cloudwatch put-metric-data --metric-name heap_mem_used_percent --dimensions ResourceName=$EC2_INSTANCE_NAME,InstanceId=$EC2_INSTANCE_ID,Object="Tomcat" --namespace "Custom" --value $HEAP_MEM_USED_PERCENT --unit Percent
echo "Getting Java Heap mem used, max, used percent: $HEAP_MEM_USED, $HEAP_MEM_MAX, $HEAP_MEM_USED_PERCENT"
```

### SCRIPT JBOSS (EAP):

``` hcl
#!/bin/bash
TOKEN=$(curl -s -X PUT " http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" 2>/dev/null)

EC2_INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)

EC2_INSTANCE_REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/placement/region/ 2>/dev/null)

EC2_INSTANCE_NAME=$(/usr/local/bin/aws ec2 describe-tags --region $EC2_INSTANCE_REGION --filters "Name=resource-id,Values=$EC2_INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)

echo "Collecting JBoss metrics for instance name:$EC2_INSTANCE_NAME | id:$EC2_INSTANCE_ID | region:$EC2_INSTANCE_REGION"
/opt/jboss-eap-7.4/bin/jboss-cli.sh --connect --command="ls -l /subsystem=datasources/data-source" > /tmp/datasources.txt
while read -r line;
do
        RESULT=`/opt/jboss-eap-7.4/bin/jboss-cli.sh --connect --command="/subsystem=datasources/data-source=$line:test-connection-in-pool" | grep "outcome" | awk -F "\"" '{ print $4 }'`;
        if [[ $RESULT -eq "success" ]]
        then VALUE=0
        else VALUE=1
        fi
        /usr/local/bin/aws cloudwatch put-metric-data --metric-name datasource_status --dimensions ResourceName=$EC2_INSTANCE_NAME,InstanceId=$EC2_INSTANCE_ID,Object=${line} --namespace "Custom" --value $VALUE --unit Count;
done < /tmp/datasources.txt
HEAP_MEM_USED=`/opt/jboss-eap-7.4/bin/jboss-cli.sh --connect --command="/core-service=platform-mbean/type=memory/:read-attribute(name=heap-memory-usage)" | grep "used" | awk '{print $3}' | sed 's/L,//'`
HEAP_MEM_MAX=`/opt/jboss-eap-7.4/bin/jboss-cli.sh --connect --command="/core-service=platform-mbean/type=memory/:read-attribute(name=heap-memory-usage)" | grep "max" | awk '{print $3}' | sed 's/L//'`
HEAP_MEM_USED_PERCENT=$((100* $HEAP_MEM_USED/$HEAP_MEM_MAX))
/usr/local/bin/aws cloudwatch put-metric-data --metric-name heap_mem_used --dimensions ResourceName=$EC2_INSTANCE_NAME,InstanceId=$EC2_INSTANCE_ID,Object="JBoss" --namespace "Custom" --value $HEAP_MEM_USED --unit Bytes
/usr/local/bin/aws cloudwatch put-metric-data --metric-name heap_mem_max --dimensions ResourceName=$EC2_INSTANCE_NAME,InstanceId=$EC2_INSTANCE_ID,Object="JBoss" --namespace "Custom" --value $HEAP_MEM_MAX --unit Bytes
/usr/local/bin/aws cloudwatch put-metric-data --metric-name heap_mem_used_percent --dimensions ResourceName=$EC2_INSTANCE_NAME,InstanceId=$EC2_INSTANCE_ID,Object="JBoss" --namespace "Custom" --value $HEAP_MEM_USED_PERCENT --unit Percent
echo "Getting Java Heap mem used, max, used percent: $HEAP_MEM_USED, $HEAP_MEM_MAX, $HEAP_MEM_USED_PERCENT"
rm -rf /tmp/datasources.txt
```
