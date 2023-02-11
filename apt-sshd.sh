#!/bin/sh
set -e

echo 'root:root' |chpasswd
#passwd --expire root
apt-get install -y openssh-server
sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
mkdir /var/run/sshd
mkdir /root/.ssh
