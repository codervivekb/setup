#!/bin/sh

export VAGRANT_MNT="/vagrant"

echo "OO install logstash"

echo "[logstash-2.1]
name=Logstash repository for 2.1.x packages
baseurl=http://packages.elastic.co/logstash/2.1/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1" > /etc/yum.repos.d/logstash.repo

yum -y install logstash

chkconfig --add logstash
chkconfig logstash on

#Setup certs for collector and forwarder

echo '127.0.0.1 vagrant.oo.com' >> /etc/hosts

mkdir -p /etc/pki/tls/logstash/certs
mkdir -p /etc/pki/tls/logstash/private

cd /etc/pki/tls/logstash 
openssl req -x509 -batch -nodes -days 3650 -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt -subj '/CN=*.oo.com/'


cp "$VAGRANT_MNT/logstash/logstash.conf" /etc/logstash/conf.d/logstash.conf