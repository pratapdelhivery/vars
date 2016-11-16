#!/bin/bash
# Script is written to install zabbix on fresh new instance/host. You need to run the script as mentioned below
# /bin/bash zabbix_active-agent_installation.sh webserver facebook-app
# Where webserver is desired hostname or group/service it belongs to, then HostMetadata is AutoRegistration Action created under zabbix
# for your project/team

Hostname=$1
Hostmetadata=$2

if which lsb_release &>> /dev/null; then
    OS=`lsb_release -a | sed -n 's/.*\(Ubuntu\).*/\1/p; s/.*\(Amazon\).*/\1/p; s/.*\(Debian\).*/\1/p' | head -1`
elif [ -r /etc/issue ]; then
    OS=`cat /etc/issue | head -1 | awk {'print $1'}`
else
    echo "Oops!! Unknown OS"
fi

echo -e"Operation System ===> $OS\n"
echo -e "\nBegning Zabbix agent installation on OS -> $OS on host `ip r | tail -1 | awk {'print $NF'}`"
echo -e "\n============================================================================================\n"

case "$OS" in
"Ubuntu")
        URL='http://repo.zabbix.com/zabbix/3.0/ubuntu/pool/main/z/zabbix/zabbix-agent_3.0.2-1+trusty_amd64.deb'
        cd /tmp; apt-get  update; apt-get install wget telnet -y ; apt-get install libodbc1 libltdl7  libcurl3 -y ; wget $URL ; dpkg -i zabbix-agent_*.deb ; rand=`ip r| grep -v default |  awk '{print $NF}'` ; HOSTNAME=${Hostname} ; sed -i "s/Hostname=.*/Hostname=${HOSTNAME}-${rand}/g" /etc/zabbix/zabbix_agentd.conf; sed -i "s/Server=127.0.0.1/Server=zabbix.delhivery.com/g" /etc/zabbix/zabbix_agentd.conf; sed -i "s/ServerActive=127.0.0.1/ServerActive=zabbix.delhivery.com/g" /etc/zabbix/zabbix_agentd.conf; sed -i "/# HostMetadata=/aHostMetadata=${Hostmetadata}" /etc/zabbix/zabbix_agentd.conf; sed -i '/StartAgents=3/aStartAgents=0' /etc/zabbix/zabbix_agentd.conf; sed -i '/# ListenIP=0.0.0.0/a ListenIP=0.0.0.0' /etc/zabbix/zabbix_agentd.conf ; /etc/init.d/zabbix-agent restart; rm /tmp/zabbix-agent*;
;;

"Debian")
        URL='http://repo.zabbix.com/zabbix/3.0/debian/pool/main/z/zabbix/zabbix-agent_3.0.4-1+jessie_amd64.deb'
        cd /tmp; apt-get  update; apt-get install wget telnet -y ; apt-get install libodbc1 libltdl7  libcurl3 -y ; wget $URL ; dpkg -i zabbix-agent_*.deb; rand=`ip r| grep -v default |  awk '{print $NF}'` ; sed -i "s/Hostname=.*/Hostname=${Hostname}-${rand}/g" /etc/zabbix/zabbix_agentd.conf; sed -i "s/Server=127.0.0.1/Server=zabbix.delhivery.com/g" /etc/zabbix/zabbix_agentd.conf; sed -i "s/ServerActive=127.0.0.1/ServerActive=zabbix.delhivery.com/g" /etc/zabbix/zabbix_agentd.conf; sed -i "/# HostMetadata=/aHostMetadata=$Hostmetadata" /etc/zabbix/zabbix_agentd.conf; sed -i '/StartAgents=3/aStartAgents=0' /etc/zabbix/zabbix_agentd.conf; sed -i '/# ListenIP=0.0.0.0/a ListenIP=0.0.0.0' /etc/zabbix/zabbix_agentd.conf ;/etc/init.d/zabbix-agent start; rm /tmp/zabbix-agent*; /etc/init.d/zabbix-agent restart
;;

"Amazon")
        URL='http://repo.zabbix.com/zabbix/3.0/rhel/6/x86_64/zabbix-agent-3.0.0-2.el6.x86_64.rpm'

        yum update -y ; yum install unixODBC.x86_64  -y ; wget $URL; rpm -ivh zabbix-agent-*.rpm; rand=`ip r| grep -v default |  awk '{print $NF}' |grep -v eth` ; sed -i 's/Hostname=.*/Hostname=${Hostname}-${rand}/g' /etc/zabbix/zabbix_agentd.conf; sed -i "s/Server=127.0.0.1/Server=zabbix.delhivery.com/g" /etc/zabbix/zabbix_agentd.conf; sed -i "s/ServerActive=127.0.0.1/ServerActive=zabbix.delhivery.com/g" /etc/zabbix/zabbix_agentd.conf; sed -i '/# HostMetadata=/aHostMetadata=${HostMetaData}' /etc/zabbix/zabbix_agentd.conf; sed -i '/StartAgents=3/aStartAgents=0' /etc/zabbix/zabbix_agentd.conf; sed -i '/# ListenIP=0.0.0.0/a ListenIP=0.0.0.0' /etc/zabbix/zabbix_agentd.conf ; /etc/init.d/zabbix-agent restart; rm /tmp/zabbix-agent*;

esac

