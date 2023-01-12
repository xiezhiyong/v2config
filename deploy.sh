#!/bin/sh
set -e

#apt-get update
apt-get install -y openssh-server
mkdir /var/run/sshd
echo 'root:root' |chpasswd
#passwd --expire root
sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
mkdir /root/.ssh
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

cd /opt
wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip /opt/Xray-linux-64.zip xray
rm -f /opt/Xray-linux-64.zip
mv /opt/xray /opt/v2test
cat > /opt/config.json <<EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": 3000,
      "listen": "0.0.0.0",
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "b831381d-6324-4d53-ad4f-8cda48b30811",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/ws"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF

cat > /opt/start.sh <<EOF
/usr/sbin/sshd
/opt/v2test
EOF
