overview
=====

This is a local OneOps instance using Vagrant without metrics collections.  It's a simplified design deployed from bash scripts.  

For a full-deployment of OneOps with metrics (back loop) use the core assembly within this vagrant image.

prerequisites
=======

install VirtualBox and Vagrant

(until public) add your public ssh key to your account at github.com


install
=======

Once you have these installed run: 

```bash
git clone https://github.com/oneops/setup
cd setup/vagrant
# (until public) copy your ssh key - or use a different key you setup in github
cp ~/.ssh/id_rsa git_ssh/git_rsa
vagrant up 
```

installation takes about 20 min, depending on your internet connection.
After it is up hit http://localhost:9090

Setup your organization cloud with private location in OneOps 
 
	Add new cloud for your organization (Eg: my-cloud)
	Choose the Management location as Custom from drop down list
	Provide an authorization key (Eg: mycloudsecret)
	Add a new compute service (Eg: openstack-ctf)
         Note down the Management location path and authorization key for your cloud
         Eg:  /platform-dev/_clouds/my-cloud & mycloudsecret
         
Create local inductor:
	
	cd /opt/oneops ; inductor create ; cd inductor ; inductor add

It will ask a series of questions 

```bash
[root@localhost inductor]# inductor add
What message queue host (if empty defaults to localhost)? 
Manage dns? (on or off - defaults to off) on
Debug mode? (keeps ssh keys and doesn't terminate compute on compute::add failure. on or off - defaults to off) on
Metrics collections? (if empty defaults to false)? 
What compute attribute to use for the ip to connect (if empty defaults to private_ip)? public_ip
Queue location? /public/oneops/clouds/aws
URL to the UI? http://localhost:9090
Logstash cert file location ? (If empty defaults to local cloud cert) 
Comma seperated list of logstash host:port ? (if empty defaults to localhost:5000) 
Max Consumers? 10
Max Local Consumers (ones for iaas)? 10
What is the authorization key? awssecretkey
Any additional java args to default (If empty uses deault.)? 
      create  clouds-available/public.oneops.clouds.aws
      create  clouds-available/public.oneops.clouds.aws/bin/inductor_agent.sh
      create  clouds-available/public.oneops.clouds.aws/conf/chef/chef.rb.local
      create  clouds-available/public.oneops.clouds.aws/conf/chef/chef.rb.remote
      create  clouds-available/public.oneops.clouds.aws/conf/inductor.properties
      create  clouds-available/public.oneops.clouds.aws/conf/log4j.xml
      create  clouds-available/public.oneops.clouds.aws/conf/vmargs
      create  clouds-available/public.oneops.clouds.aws/logstash-forwarder/cert/logstash-forwarder.crt
      create  clouds-available/public.oneops.clouds.aws/logstash-forwarder/conf/logstash-forwarder.conf
      create  clouds-available/public.oneops.clouds.aws/logstash-forwarder/log/output.log
      create  clouds-available/public.oneops.clouds.aws/sandbox
      create  clouds-available/public.oneops.clouds.aws/cache
      create  clouds-available/public.oneops.clouds.aws/backup
      create  clouds-available/public.oneops.clouds.aws/data
      create  clouds-available/public.oneops.clouds.aws/retry
      enable  clouds-enabled/public.oneops.clouds.aws
     success  Next Step: inductor start ; inductor tail
[root@localhost inductor]# inductor start ; inductor tail
       start  public.oneops.clouds.aws
```

you should see a line like:

```
2016-01-22 18:38:25,462  INFO   FailoverTransport:1065  Successfully connected to ssl://localhost:61617?keepAlive=true
```

Now you can use the cloud in an Environment.

