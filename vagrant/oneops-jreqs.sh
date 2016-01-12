#!/bin/sh

now=$(date +"%T")
echo "Starting at : $now"

export VAGRANT_MNT="/vagrant"

echo '127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 search api antenna opsmq daq opsdb sysdb kloopzappdb kloopzcmsdb cmsapi sensor activitidb kloopzmq searchmq' > /etc/hosts
echo '::1         localhost localhost.localdomain localhost6 localhost6.localdomain6' >> /etc/hosts

#java 
echo "OO installing open jdk 1.8"
yum -y install java-1.8.0-openjdk-devel
yum -y install vim-common
yum -y install perl-Digest-SHA

#postgres
echo "OO install postgres 9.2"
yum -y install http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm
yum -y install postgresql92-server postgresql92-contrib
yum -y install postgresql-devel

service postgresql-9.2 initdb
chkconfig --add postgresql-9.2
chkconfig postgresql-9.2 on

echo "OO changing postgres config to allow local connections"

cp "$VAGRANT_MNT/pgsql/9.2/pg_hba.conf" /var/lib/pgsql/9.2/data
chown postgres:postgres /var/lib/pgsql/9.2/data/pg_hba.conf

echo "OO starting postgres db"
service postgresql-9.2 start
echo "OO done with postgres"

apache_mirror="http://www.us.apache.org/dist"

echo "OO install activemq 5.10.2"
cd /opt
wget -nv $apache_mirror/activemq/5.10.2/apache-activemq-5.10.2-bin.tar.gz
if [ ! -e "/opt/apache-activemq-5.10.2-bin.tar.gz" ]; then
	echo "Can not get Activemq distribution! "
	exit 1
fi
tar -xzvf apache-activemq-5.10.2-bin.tar.gz 
ln -s ./apache-activemq-5.10.2 activemq
cp "$VAGRANT_MNT/amq/5.10/init.d/activemq" /etc/init.d
cp "$VAGRANT_MNT/amq/credentials.properties" /opt/activemq/conf/
chown root:root /etc/init.d/activemq
chmod +x /etc/init.d/activemq
chkconfig --add activemq
chkconfig activemq on 
service activemq start
echo "OO done with activemq"

echo "OO install cassandra 2.1.12"
cd /opt
wget -nv $apache_mirror/cassandra/2.1.12/apache-cassandra-2.1.12-bin.tar.gz
if [ ! -e "/opt/apache-cassandra-2.1.12-bin.tar.gz" ]; then
	echo "Can not get Cassandra distribution! "
	exit 1
fi
tar -xzvf apache-cassandra-2.1.12-bin.tar.gz
ln -sf apache-cassandra-2.1.12 cassandra
mkdir /opt/cassandra/log
cp "$VAGRANT_MNT/cassandra/2.1/init.d/cassandra" /etc/init.d

chown root:root /etc/init.d/cassandra
chmod +x /etc/init.d/cassandra
chkconfig --add cassandra
chkconfig cassandra on
service cassandra start
echo "OO done with cassandra"

echo "OO install tomcat 7"
cd /opt
wget -nv $apache_mirror/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz
if [ ! -e "/opt/apache-tomcat-7.0.67.tar.gz" ]; then
	echo "Can not get Tomcat distribution! "
	exit 1
fi
tar -xzvf apache-tomcat-7.0.67.tar.gz 
mv apache-tomcat-7.0.67 /usr/local/tomcat7
useradd -M -d /usr/local/tomcat7 tomcat7 
chown -R tomcat7 /usr/local/tomcat7
cp "$VAGRANT_MNT/tomcat/7.0/init.d/tomcat7" /etc/init.d
chown root:root /etc/init.d/tomcat7
chmod 755 /etc/init.d/tomcat7 
chkconfig --add tomcat7
chkconfig tomcat7 on
service tomcat7 start
echo "OO done with tomcat 7"

echo "OO install maven 3.33"
cd /opt
wget -nv $apache_mirror/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
if [ ! -e "/opt/apache-maven-3.3.3-bin.tar.gz" ]; then
	echo "Can not get Maven distribution! "
	exit 1
fi
tar -xzvf apache-maven-3.3.3-bin.tar.gz -C /usr/local
cd /usr/local
ln -s apache-maven-3.3.3 maven
touch /etc/profile.d/maven.sh 
echo 'export M2_HOME=/usr/local/maven' >> /etc/profile.d/maven.sh 
echo 'export PATH=${M2_HOME}/bin:${PATH}' >> /etc/profile.d/maven.sh
echo "OO done with maven"

echo "OO install git"
yum -y install git
#this is for gecgit only
mkdir -p /root/.ssh
cp "$VAGRANT_MNT/git_ssh/config" /root/.ssh
chown root:root /root/.ssh/config
chmod 600 /root/.ssh/config
cp "$VAGRANT_MNT/git_ssh/git_rsa" /root/.ssh
chown root:root /root/.ssh/git_rsa
chmod 600 /root/.ssh/git_rsa
echo "OO done with git"

echo "OO generate des file"
mkdir -p /usr/local/oneops/certs
cd /usr/local/oneops/certs
if [ ! -e oo.key ]; then
dd if=/dev/urandom count=24 bs=1 | xxd -ps > oo.key
##truncate newline at the end
truncate -s -1 oo.key
fi
echo "OO Done with des file"

