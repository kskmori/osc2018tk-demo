all:
	@echo "make bootstrap"
	@echo "  Create Vagrant VMs and provisioning configuration."
	@echo "  or 'make bootstrap-repo' and configure your VMs, hosts and group_vars manually"
	@echo
	@echo "make build"
	@echo "  Provision the demo environment using the playbooks."
	@echo
	@echo "make restart"
	@echo "  Restart the demo after the host machine was rebooted."

bootstrap: bootstrap-repo bootstrap-vagrant config config-proxy
	@echo "Done."
	@echo "Next, run 'make build'"

bootstrap-repo:
	[ -d ansible-kubernetes-demo ] || git clone https://github.com/kskmori/ansible-kubernetes-demo
	(cd ansible-kubernetes-demo; git checkout osc2018tk-demo-20181027)
	[ -d ansible-pacemaker ] || git clone https://github.com/kskmori/ansible-pacemaker
	(cd ansible-pacemaker; git checkout branch-1.1.19-1.1)
	[ -d ansible-bundle-demo ] || git clone https://github.com/kskmori/ansible-bundle-demo
	(cd ansible-bundle-demo; git checkout osc2018tk-demo-20181027)
	[ -d ansible-virtualbmc ] || git clone https://github.com/kskmori/ansible-virtualbmc
	(cd ansible-virtualbmc; git checkout osc2018tk-demo-20181027)

# prepare vagrant guests
#  sshfs can be omitted if you don't need to share the demo senario
#  between host and guests
#  vagrant reload is to enable deffered synced_folder (see vagrant/Vagrantfile)
bootstrap-vagrant:
	(cd vagrant ;\
	 vagrant plugin install vagrant-sshfs ;\
	 vagrant up ;\
	 if [ "$$http_proxy" ]; then \
	   vagrant reload ;\
	 fi \
	)

config:
	cp hosts.vagrant.sample hosts
	cp ansible.cfg.vagrant.sample ansible.cfg
	cp group_vars/all.yml.sample group_vars/all.yml
	cp group_vars/hacluster.yml.sample group_vars/hacluster.yml

config-proxy:
	(cd group_vars; \
	  if [ "$$http_proxy" ]; then \
	    echo "USE_PROXY:" >> all.yml ; \
	    echo "  - http_proxy=$$http_proxy" >> all.yml ; \
	    echo "  - https_proxy=$$https_proxy" >> all.yml ; \
	    grep "^#  - no_proxy=" all.yml.sample | cut -c 2- >> all.yml ; \
	  fi \
	)

# add ssh config for Vagrant VMs if you prefer
config-ssh:
	[ -d $$HOME/.ssh ] && ! grep '^Host master' $$HOME/.ssh/config >/dev/null 2>/dev/null && (cd vagrant; vagrant ssh-config >>$$HOME/.ssh/config) || true


build:
	ansible-playbook 10-kubernetes.yml
	ansible-playbook 11-virtualbmc.yml
	ansible-playbook 12-pacemaker.yml --tags=init-cib,start-wait,all
	@echo Done.

restart:
	(cd vagrant; vagrant reload)
	ansible-playbook ./ansible-virtualbmc/20-vbmc-start.yml
	ansible-playbook ./ansible-pacemaker/20-pacemaker-start.yml


clean:
	@find . -name '*.retry' -exec rm {} \;
	@find . -name '*~' -exec rm {} \;
