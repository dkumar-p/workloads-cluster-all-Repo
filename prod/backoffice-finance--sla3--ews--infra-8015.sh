#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

### JBOSS_HOME

JBOSS_HOME=/opt/jws-5.6/tomcat
JWS5_HOME=/usr/lib/systemd/system

####REGISTER IN RH INSIGHTS####
subscription-manager register --org=3732146 --activationkey=insights --force
insights-client --register

### CONFIG FILE

CONFIG_FILE_NAME=config-app.sh
CONFIG_FILE_PATH=/wl_config

### INJECTION SCRIPT

echo "#!/bin/bash" >> /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME
echo "aws s3api get-object --bucket "'${1}'" --key "'${2}'" "'${3}'"" >> /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME
echo systemctl restart jws5-tomcat >> /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME
chmod +x /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME

### UPDATE FILE

UPDATE_FILE_NAME=update-file.sh
UPDATE_FILE_PATH=/wl_config

### INJECTION SCRIPT

echo "#!/bin/bash" >> /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME
echo "aws s3api get-object --bucket "'${1}'" --key "'${2}'" "'${3}'"" >> /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME
chmod +x /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME

### BUCKET

BUCKET_BACKOFFICE=iberia-configs-files-apps-production-backoffice

### CLUSTERNAME

CLUSTER_NAME=backoffice-finance--sla3--ews--infra-8015

### DATASOURCE

DATASOURCE_FILE_NAME=context.xml
DATASOURCE_CLUSTER=Datasource/$CLUSTER_NAME/$DATASOURCE_FILE_NAME

### PEOPLESOFT

PEOPLESOFT_CNX=cnx.properties
PEOPLESOFT_CONFIG=config_PeopleSoft.properties
PEOPLESOFT_PATH=/wl_internet/PeopleSoft/apli/config
PEOPLESOFT_FOLDER=Peoplesoft

### SWM

SWM_CONFIG=swm-config.xml
SWM_PATH=/wl_intranet/swm/apli/config
SWM_FOLDER=Swm

### CATALINA

CATALINA_FILE_NAME=catalina.sh
CATALINA_CLUSTER=Catalina/$CLUSTER_NAME/$CATALINA_FILE_NAME

### ETC

ETC_FILE_NAME=hosts
ETC_CLUSTER=Etc/$CLUSTER_NAME/$ETC_FILE_NAME

### CONF

CONF_FILE_NAME=server.xml
CONF_CLUSTER=Conf/$CLUSTER_NAME/$CONF_FILE_NAME
CONF_FILE_NAME2=jws5-tomcat.service
CONF_CLUSTER2=Conf/$CLUSTER_NAME/$CONF_FILE_NAME2

### DATASOURCE CALL SCRIPT

bash /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME $BUCKET_BACKOFFICE $DATASOURCE_CLUSTER $JBOSS_HOME/conf/$DATASOURCE_FILE_NAME

### PEOPLESOFT CALL SCRIPT

bash /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME $BUCKET_BACKOFFICE $PEOPLESOFT_FOLDER/$PEOPLESOFT_CNX $PEOPLESOFT_PATH/$PEOPLESOFT_CNX
bash /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME $BUCKET_BACKOFFICE $PEOPLESOFT_FOLDER/$PEOPLESOFT_CONFIG $PEOPLESOFT_PATH/$PEOPLESOFT_CONFIG

### SWM CALL SCRIPT

bash /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME $BUCKET_BACKOFFICE $SWM_FOLDER/$SWM_CONFIG $SWM_PATH/$SWM_CONFIG

### CATALINA CALL SCRIPT

bash /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME $BUCKET_BACKOFFICE $CATALINA_CLUSTER $JBOSS_HOME/bin/$CATALINA_FILE_NAME

### ETC CALL SCRIPT

bash /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME $BUCKET_BACKOFFICE $ETC_CLUSTER /etc/$ETC_FILE_NAME

### CONF CALL SCRIPT

bash /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME $BUCKET_BACKOFFICE $CONF_CLUSTER $JBOSS_HOME/conf/$CONF_FILE_NAME
bash /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME $BUCKET_BACKOFFICE $CONF_CLUSTER2 $JWS5_HOME/$CONF_FILE_NAME2
systemctl daemon-reload
systemctl restart jws5-tomcat