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

It will ask a series of questions and then you can run:

	inductor start ; inductor tail

The `inductor tail` will show you the logs from any deployment.

