#!/bin/sh
set -e
rm -f deploy.sh v2test config.json*
wget https://github.com/xiezhiyong/v2files/raw/main/deploy.sh
sh deploy.sh
sed 's/3000/PORT/g' config.json > config.json.tmp

cat > run <<EOF
#!/bin/sh
cd \$(dirname \$(readlink -f "\$0"))
sed "s/PORT/\$PORT/g" config.json.tmp > config.json
mkdir -p task
for i in task/*.sh ; do
    \$i
done
./v2test
EOF

cat > start <<EOF
#!/bin/sh
cd \$(dirname \$(readlink -f "\$0"))
while true;do
  ./run
done
EOF

chmod +x run start
