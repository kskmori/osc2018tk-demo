all:
	@echo make bootstrap-vagrant
	@echo make bootstrap

bootstrap:
	[ -d ansible-kubernetes-demo ] || git clone https://github.com/kskmori/ansible-kubernetes-demo
	(cd ansible-kubernetes-demo; git pull)
	[ -d ansible-pacemaker ] || git clone https://github.com/kskmori/ansible-pacemaker
	(cd ansible-pacemaker; git pull)
	[ -d ansible-bundle-demo ] || git clone https://github.com/kskmori/ansible-bundle-demo
	(cd ansible-bundle-demo; git pull)

bootstrap-vagrant: bootstrap
	(cd vagrant; vagrant up)
	cp hosts.vagrant.sample hosts
	cat vagrant/.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory >> hosts
	cp ansible.cfg.vagrant.sample ansible.cfg
	echo "inventory = $$(pwd)/hosts" >> ansible.cfg
	cp group_vars/all.yml.sample group_vars/all.yml
	cp group_vars/hacluster.yml.sample group_vars/hacluster.yml

clean:
	@rm -f *.retry
	@find . -name '*~' -exec rm {} \;
