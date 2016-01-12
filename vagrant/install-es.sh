#!/bin/sh

export VAGRANT_MNT="/vagrant"

echo "OO install elasticsearch"
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

echo "[elasticsearch-1.7]
name=Elasticsearch repository for 1.7.x packages
baseurl=http://packages.elastic.co/elasticsearch/1.7/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1" > /etc/yum.repos.d/elasticsearch.repo
yum -y install elasticsearch

export ES_HEAP_SIZE=512m
echo "export ES_HEAP_SIZE=512m" > /etc/profile.d/es.sh
sed -i -- 's/\#cluster\.name\: elasticsearch/cluster\.name\: oneops/g' /etc/elasticsearch/elasticsearch.yml
chkconfig --add elasticsearch
chkconfig elasticsearch on

service elasticsearch start

cp "$VAGRANT_MNT/search-consumer/init.d/search-consumer" /etc/init.d
chkconfig --add search-consumer
chkconfig search-consumer on


cp "$VAGRANT_MNT/search-consumer/cms_template.json" /tmp
cp "$VAGRANT_MNT/search-consumer/event_template.json" /tmp

curl http://localhost:9200
while [ $? != 0 ]; do
        sleep 1
        curl http://localhost:9200
done

curl -d @/tmp/cms_template.json -X PUT http://localhost:9200/_template/cms_template
curl -d @/tmp/event_template.json -X PUT http://localhost:9200/_template/event_template

echo "OO done with elasticsearch"



