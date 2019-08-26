# OSC2018 Tokyo/Fall Seminar demo

## Seminar ##
 * Slides
   * https://www.slideshare.net/ksk_ha/pacemakerhakubernetes-121194991
 * Introduction
   * https://www.ospn.jp/osc2018-fall/modules/eguide/event.php?eid=21

## Building demo environment

### Host requirements

* Hardware
  * Memory: 8GB or more free space.
* Software
  * CentOS 7.5.1804
  * VirtualBox-5.2-5.2.20_125813_el7-1.x86_64
  * vagrant_2.1.5_x86_64
  * ansible-2.6.4-1 (EPEL)
  * git-1.8.3.1-11 (CentOS bundled)
  * python-virtualenv-15.1.0-2 (CentOS bundled)

### Host installation

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


### Build demo environment

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
make build
```

 * Allow ssh login directly (instead of vagrant ssh)
```
make config-ssh
```

## Related Repositories

 * Kubernetes installation
   * https://github.com/kskmori/ansible-kubernetes-demo
 * Pacemaker installation
   * https://github.com/kskmori/ansible-pacemaker
 * Pacemaker bundle sample configurations
   * https://github.com/kskmori/ansible-bundle-demo
 * virtualbmc installation
   * https://github.com/kskmori/ansible-virtualbmc
 * virtualbmc (patched version) - IPMI fencing for VirtualBox VMs
   * https://github.com/kskmori/virtualbmc/tree/devel-vbox-1.1.0

## Presentation Scenario

### Preparation before start ###
 * restart the demo environment (if not started yet)
```
## on the host node
make restart
```
 * open terminal windows
   * ex. 4 terminals
     * T1. Pacemaker status terminal : Demo 2
     * T2. Kubernetes status terminal : Demo 1 & Demo 2
     * T3. operation terminal : Demo 1 & Demo 2
     * T4. operation terminal on the host node
     * (terminal T3. & T4. can be placed with overwrapped, minimum lines)
   * login to the master node and become root on terminal T1., T2. & T3.
```
## T1: T2: T3:
ssh master
sudo -s
cd /osc2018tk-demo/
```
 * make sure all Pacemaker resources are running (location does not matter here)
```
## T1:
./demo-scenario/pm-crm_mon-worker1.sh
```
 * make sure all Kubernetes Pods are running (location does not matter here)
```
## T2:
./demo-scenario/kube-watch.sh
```
 * for Demo 1: stop Pacemaker
```
## T3:
./demo-scenario/pm-stop.sh
```
 * for Demo 1: reset Kubernetes Pods location
```
## T3:
./demo-scenario/kube-reset-location.sh
```

### Demo 1 ###
 * show the Kubernetes configuration (p.17, p.18)
```
## T2:
./demo-scenario/kube-config.sh
```
 * start watching Kubernetes status
```
## T2:
./demo-scenario/kube-watch.sh
```
 * disconnect the both network cables via VirtualBox GUI (p.19)
   * alternatively, via the command line:
```
## T4: on the host node
./demo-scenario/vm-nw-disconnect.sh
```

### Restore after Demo 1 ###
 * reconnect the network cables via VirtualBox GUI
   * alternatively, via the command line:
```
## T4: on the host node
./demo-scenario/vm-nw-connect.sh
```
 * reset Kubernetes Pods location
```
## T3:
./demo-scenario/kube-move-to-worker1-httpd.sh
```

### Demo 2 ###
 * make sure the "Restore after Demo 1" steps has been done before proceeds
 * show the Pacemaker status on **worker1** (p.43)
```
## T1:
./demo-scenario/pm-crm_mon-worker1.sh
```
 * start Pacemaker one by one
```
## T3:
./demo-scenario/pm-start.sh
```
 * show the Pacemaker status on **worker2** (p.43, p.47): *DO NOT FORGET THIS!*
```
## T1:
Press Ctrl-C (to stop crm_mon on worker1)
./demo-scenario/pm-crm_mon-worker2.sh
```
 * start watching Kubernetes status (p.44, p.48)
```
## T2:
./demo-scenario/kube-watch.sh
```
 * disconnect the both network cables via VirtualBox GUI (p.45)
   * alternatively, via the command line:
```
## T4: on the host node
./demo-scenario/vm-nw-disconnect.sh
```

### Restore after Demo 2 ###
 * reconnect the network cables via VirtualBox GUI
   * alternatively, via the command line:
```
## T4: on the host node
./demo-scenario/vm-nw-connect.sh
```
 * power on worker1
   * IMPORTANT: the network cables must be reconnected *before* power on
```
## T4: on the host node
(cd ./vagrant; vagrant reload worker1)
```
 * reset Pacemaker resources location
```
## T3:
./demo-scenario/pm-move-to-worker1.sh
```
 * reset Kubernetes Pods location
```
## T3:
./demo-scenario/kube-move-to-worker1-httpd.sh
```

### Shutdown the demo environment ###
```
## T4: on the host node
(cd ./vagrant; vagrant destroy)
```

### Trouble shooting ###
 * postgres-0 pod stucks at ContainerCreating status when restoring after the demo.
   * It could happen when the node was booted up without network connectivity, so the OS gave up to mount the NFS storage.
   * Solution: make sure the all network cables being connected properly, and restart the node (`vagrant reload worker1`) or mount it manually (`mount /mnt/nfs`).
