source common.sh

mysql_root_password=$1

if [ -z "${mysql_root_password}" ]
  echo -e "\e[31mNeed Mysql Root Password\e[0m"
  exit 1
fi


print_head  " <<<<<<< downloading Mysql >>>>>>> "
dnf module disable mysql -y  &>>${log_file}
status_check $?

print_head  " <<<<<<< copy mysql repo >>>>>>> "
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo  &>>${log_file}
status_check $?

print_head  " <<<<<<< install mysql  >>>>>>> "
dnf install mysql-community-server -y  &>>${log_file}
status_check $?

print_head  " <<<<<<< enable mysql >>>>>>> "
systemctl enable mysqld &>>${log_file}
status_check $?

print_head  " <<<<<<<start mysql service >>>>>>> "
systemctl start mysqld   &>>${log_file}
status_check $?

print_head  " <<<<<<<Reset Password >>>>>>> "
mysql_secure_installation --set-root-pass ${mysql_root_password}  &>>${log_file}
status_check $?