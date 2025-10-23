vagrant-network:
	sudo virsh net-destroy vagrant-network || true
	sudo virsh net-undefine vagrant-network  || true
	sudo virsh net-define vagrant-network.xml 
	sudo virsh net-start vagrant-network 
	sudo virsh net-autostart vagrant-network
