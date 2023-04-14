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
sed "s/PORT/\$PORT/g" config.json.tmp > config.json
./v2test &
while true;do
  if [ -f task ]; then
    cat task | sh &
    rm -f task
  fi
  sleep 5s
done
EOF
