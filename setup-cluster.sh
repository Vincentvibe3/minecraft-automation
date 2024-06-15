sudo snap install microk8s --classic --channel=1.30
sudo usermod -a -G microk8s $USER
mkdir -p ~/.kube
chmod 0700 ~/.kube

sudo firewall-cmd --permanent --add-port=6443/tcp #apiserver
sudo firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16 #pods
sudo firewall-cmd --permanent --zone=trusted --add-source=10.43.0.0/16 #services

# interfaces
sudo firewall-cmd --permanent --zone=trusted --add-interface="cali+"
sudo firewall-cmd --permanent --zone=trusted --add-interface="vxlan.calico"

#https://askubuntu.com/questions/864958/how-can-we-replace-iptables-with-firewalld-in-ubuntu-16-04

#allow ssh
sudo firewall-cmd --permanent --add-port=22/tcp #apiserver
#allow https
sudo firewall-cmd --permanent --add-port=443/tcp #apiserver
#allow mc nodeport
sudo firewall-cmd --permanent --add-port=30000/tcp #apiserver
sudo firewall-cmd --reload