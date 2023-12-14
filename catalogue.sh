source common.sh

print_head  " <<<<<<< Installing Nginx >>>>>>> "
curl -sL https:///rpm.nodesource.com/setup_lts.x | bash

print_head  " <<<<<<< Installing Nginx >>>>>>> "
useradd roboshop

print_head  " <<<<<<< Installing Nginx >>>>>>> "
mkdir /app 

print_head  " <<<<<<< Installing Nginx >>>>>>> "
rm -rf /app/*

print_head  " <<<<<<< Installing Nginx >>>>>>> "
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip 

print_head  " <<<<<<< Installing Nginx >>>>>>> "
cd /app 

print_head  " <<<<<<< Installing Nginx >>>>>>> "
unzip /tmp/catalogue.zip

print_head  " <<<<<<< Installing Nginx >>>>>>> "
cd /app 

print_head  " <<<<<<< Installing Nginx >>>>>>> "
npm install 

print_head  " <<<<<<< Installing Nginx >>>>>>> "
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service

print_head  " <<<<<<< Installing Nginx >>>>>>> "
systemctl daemon-reload

print_head  " <<<<<<< Installing Nginx >>>>>>> "
systemctl enable catalogue 

print_head  " <<<<<<< Installing Nginx >>>>>>> "
systemctl start catalogue


print_head  " <<<<<<< Installing Nginx >>>>>>> "
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo


print_head  " <<<<<<< Installing Nginx >>>>>>> "
dnf install mongodb-org-shell -y


print_head  " <<<<<<< Installing Nginx >>>>>>> "
mongo --host 54.204.183.17 </app/schema/catalogue.js