# sudo snap install microk8s --classic --channel=1.30
# sudo usermod -a -G microk8s $USER
# mkdir -p ~/.kube
# chmod 0700 ~/.kube

# microk8s enable dns
# microk8s enable registry

firewall-cmd --direct --permanent --add-rule -P INPUT ACCEPT
firewall-cmd --direct --permanent --add-rule -P FORWARD ACCEPT
firewall-cmd --direct --permanent --add-rule -P OUTPUT ACCEPT
firewall-cmd --direct --permanent --add-rule -N InstanceServices
firewall-cmd --direct --permanent --add-rule -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A INPUT -p icmp -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A INPUT -i lo -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A INPUT -p udp -m udp --sport 123 -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A INPUT -j REJECT --reject-with icmp-host-prohibited
firewall-cmd --direct --permanent --add-rule -A FORWARD -j REJECT --reject-with icmp-host-prohibited
firewall-cmd --direct --permanent --add-rule -A OUTPUT -d 169.254.0.0/16 -j InstanceServices
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.0.2/32 -p tcp -m owner --uid-owner 0 -m tcp --dport 3260 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.2.0/24 -p tcp -m owner --uid-owner 0 -m tcp --dport 3260 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.4.0/24 -p tcp -m owner --uid-owner 0 -m tcp --dport 3260 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.5.0/24 -p tcp -m owner --uid-owner 0 -m tcp --dport 3260 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.0.2/32 -p tcp -m tcp --dport 80 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.169.254/32 -p udp -m udp --dport 53 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.169.254/32 -p tcp -m tcp --dport 53 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.0.3/32 -p tcp -m owner --uid-owner 0 -m tcp --dport 80 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.0.4/32 -p tcp -m tcp --dport 80 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.169.254/32 -p tcp -m tcp --dport 80 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.169.254/32 -p udp -m udp --dport 67 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.169.254/32 -p udp -m udp --dport 69 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.169.254/32 -p udp -m udp --dport 123 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.0.0/16 -p tcp -m tcp -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j REJECT --reject-with tcp-reset
firewall-cmd --direct --permanent --add-rule -A InstanceServices -d 169.254.0.0/16 -p udp -m udp -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j REJECT --reject-with icmp-port-unreachable


firewall-cmd --permanent --add-port=6443/tcp #apiserver
firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16 #pods
firewall-cmd --permanent --zone=trusted --add-source=10.43.0.0/16 #services

firewall-cmd --permanent --zone=trusted --add-interface="cali+"
firewall-cmd --permanent --zone=trusted --add-interface="vxlan.calico"

#https://askubuntu.com/questions/864958/how-can-we-replace-iptables-with-firewalld-in-ubuntu-16-04

#allow ssh
firewall-cmd --permanent --add-port=22/tcp #apiserver
#allow https
firewall-cmd --permanent --add-port=443/tcp #apiserver
#allow mc nodeport
firewall-cmd --permanent --add-port=30000/tcp #apiserver
firewall-cmd --reload