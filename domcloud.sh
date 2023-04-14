#!/bin/sh
set -e
rm -f v2test config.json*
wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip Xray-linux-64.zip xray
rm -f Xray-linux-64.zip
mv xray v2test
cat > config.json.tmp <<EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": PORT,
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
    },
    {
      "port": 50002,
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
        "network": "tcp"
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

cat > start <<EOF
#!/bin/sh
cd \$(dirname \$(readlink -f "\$0"))
true > log
if [ -d fff ];then
  for i in fff/*.ini ; do
    fff/fff -c \$i >> log 2>&1 &
  done
fi
sed "s/PORT/$PORT/g" config.json.tmp > config.json
./v2test >> log 2>&1
EOF
