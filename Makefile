all:
	@echo make bootstrap
	@echo or 'make bootstrap-repo' and configure your VMs, hosts and group_vars manually

bootstrap: bootstrap-repo bootstrap-vagrant config config-proxy
	@echo Done.


bootstrap-repo:
	[ -d ansible-kubernetes-demo ] || git clone https://github.com/kskmori/ansible-kubernetes-demo
	(cd ansible-kubernetes-demo; git pull)
	[ -d ansible-pacemaker ] || git clone https://github.com/kskmori/ansible-pacemaker
	(cd ansible-pacemaker; git pull)
	[ -d ansible-bundle-demo ] || git clone https://github.com/kskmori/ansible-bundle-demo
	(cd ansible-bundle-demo; git pull)
	[ -d ansible-virtualbmc ] || git clone https://github.com/kskmori/ansible-virtualbmc
	(cd ansible-virtualbmc; git pull)

# prepare vagrant guests
#  sshfs can be omitted if you don't need to share the demo senario
#  between host and guests
bootstrap-vagrant:
	(cd vagrant ;\
	 vagrant plugin install vagrant-sshfs ;\
	 vagrant up \
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

clean:
	@rm -f *.retry
	@find . -name '*~' -exec rm {} \;
