source common.sh

print_head  " <<<<<<< cp configs/mongodb.repo >>>>>>> "
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?


print_head  " <<<<<<< install mongodb-org >>>>>>> "
yum install mongodb-org -y  &>>${log_file} 
status_check $?

print_head  " <<<<<<< Update mongodb listen Address >>>>>>> "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}
status_check $?


print_head  " <<<<<<< enable mongod  >>>>>>> "
systemctl enable mongod  &>>${log_file}
status_check $?


print_head  " <<<<<<< start mongod  >>>>>>> "
systemctl start mongod  &>>${log_file}
status_check $?
##Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf