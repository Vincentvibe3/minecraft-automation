# add InstanceServices chain
firewall-cmd --permanent --direct --add-chain ipv4 filter InstanceServices
# InstanceServices rules
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 0 -d 169.254.0.0/16 -j InstanceServices
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.0.2/32 -p tcp -m owner --uid-owner 0 -m tcp --dport 3260 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.2.0/24 -p tcp -m owner --uid-owner 0 -m tcp --dport 3260 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.4.0/24 -p tcp -m owner --uid-owner 0 -m tcp --dport 3260 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.5.0/24 -p tcp -m owner --uid-owner 0 -m tcp --dport 3260 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.0.2/32 -p tcp -m tcp --dport 80 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.169.254/32 -p udp -m udp --dport 53 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.169.254/32 -p tcp -m tcp --dport 53 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.0.3/32 -p tcp -m owner --uid-owner 0 -m tcp --dport 80 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.0.4/32 -p tcp -m tcp --dport 80 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.169.254/32 -p tcp -m tcp --dport 80 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.169.254/32 -p udp -m udp --dport 67 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.169.254/32 -p udp -m udp --dport 69 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.169.254/32 -p udp -m udp --dport 123 -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.0.0/16 -p tcp -m tcp -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j REJECT --reject-with tcp-reset
firewall-cmd --permanent --direct --add-rule ipv4 filter InstanceServices 0 -d 169.254.0.0/16 -p udp -m udp -m comment --comment "See the Oracle-Provided Images section in the Oracle Cloud Infrastructure documentation for security impact of modifying or removing this rule" -j REJECT --reject-with icmp-port-unreachable