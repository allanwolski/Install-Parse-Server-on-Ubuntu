echo 'Wellcome to Parse Server and Dashboard on Ubuntu install script';
sleep 2;
cd ~
echo 'installing python-software-properties';
sleep 2;
apt-get install -y build-essential git python-software-properties

echo 'installing Node Js';
sleep 2;

curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt-get install -y nodejs
apt-get install -y build-essential

echo 'installing Mongo DB';
sleep 2;

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
sudo apt-get install gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt-get update
apt-get install -y mongodb-org
service mongod start

echo 'Installing Parse Server Dashboard and PM2';
sleep 2;

npm install -g parse-server parse-dashboard pm2@latest --no-optional --no-shrinkwrap
git clone https://github.com/ParsePlatform/parse-server-example.git parse-server
cd parse-server

echo
echo 'Downloading Parse Server Dashboard Configrtion Files';
sleep 2;

sudo curl https://raw.githubusercontent.com/allanwolski/Install-Parse-Server-on-Ubuntu/master/parse-dashboard-config.json > parse-dashboard-config.json
sudo curl https://raw.githubusercontent.com/allanwolski/Install-Parse-Server-on-Ubuntu/master/dashboard-running.json > dashboard-running.json
npm -g install
echo
echo 'Adding APP_ID and MASTER_KEY';
sleep 2;
sudo sed -i "s/appId: process.env.APP_ID || .*/appId: process.env.APP_ID || 'com.bsoft.emitapramim',/" /root/parse-server/index.js
sudo sed -i "s/masterKey: process.env.MASTER_KEY || .*/masterKey: process.env.MASTER_KEY || 'f63cdc1010d47cb96280b057ee0233ce5195bc518da3',/" /root/parse-server/index.js
echo 'Happy Ending';
echo
pm2 start index.js && pm2 startup
pm2 start dashboard-running.json && pm2 startup
pm2 status
