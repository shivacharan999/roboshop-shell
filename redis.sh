source common.sh


print_head  " <<<<<<< Installing Nginx >>>>>>> "
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
dnf install redis -y &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
sed -i -e 's/127.0.0.1/0.0.0.0/'  /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
status_check $?


print_head  " <<<<<<< Installing Nginx >>>>>>> "
systemctl enable redis  &>>${log_file}
status_check $?

print_head  " <<<<<<< Installing Nginx >>>>>>> "
systemctl restart redis  &>>${log_file}
status_check $?