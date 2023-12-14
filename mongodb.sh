source common.sh

print_head  " <<<<<<< cp configs/mongodb.repo >>>>>>> "
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head  " <<<<<<< install mongodb-org >>>>>>> "
yum install mongodb-org -y  &>>${log_file}

print_head  " <<<<<<< enable mongod x >>>>>>> "
systemctl enable mongod  &>>${log_file}

print_head  " <<<<<<< start mongod  >>>>>>> "
systemctl start mongod  &>>${log_file}
##Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf