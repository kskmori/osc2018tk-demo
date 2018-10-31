# OSC2018 Tokyo/Fall Seminar demo

## Host requirements

* Hardware
  * Memory: 8GB or more.
* Software
  * CentOS 7.5.1804
  * VirtualBox-5.2-5.2.20_125813_el7-1.x86_64
  * vagrant_2.1.5_x86_64
  * ansible-2.6.4-1 (EPEL)
  * git-1.8.3.1-11 (CentOS bundled)
  * python-virtualenv-15.1.0-2 (CentOS bundled)

## Host installation

 * Install VirtualBox package
   * https://www.virtualbox.org/wiki/Downloads
```
rpm -ivh VirtualBox-5.2-5.2.20_125813_el7-1.x86_64.rpm
```
 * Install Vagrant package
   * https://www.vagrantup.com/downloads.html
```
rpm -ivh vagrant_2.1.5_x86_64.rpm
```
 * Install ansible from EPEL
```
yum install epel-release
yum install ansible
```

 * Install other utils
```
yum install git
yum install python-virtualenv
```


## Build demo environment

 * checkout demo repo.
```
git clone https://github.com/kskmori/osc2018tk-demo
cd osc2018tk-demo
```

 * Create Vagrant VMs and configurations
```
make bootstrap
```

 * Build the demo using the playbooks
```
ansible-playbook 10-kubernetes.yml
ansible-playbook 11-virtualbmc.yml
ansible-playbook 12-pacemaker.yml
```
