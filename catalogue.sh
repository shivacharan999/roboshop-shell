source common.sh

print_head  " <<<<<<< Installing Nginx >>>>>>> "
curl -sL https:///rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log_file}
fi
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
if [ ! -d /app ]; then
  mkdir /app  &>>${log_file}
fi
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
rm -rf /app/* &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
cd /app &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
unzip /tmp/catalogue.zip &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
cd /app &>>${log_file}
 status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
npm install &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
systemctl daemon-reload &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
systemctl enable catalogue  &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
systemctl start catalogue &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
dnf install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
mongo --host 172.31.37.86 </app/schema/catalogue.js &>>${log_file}
status_check $?