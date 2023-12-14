source common.sh
roboshop_app_password=$1

if [ -z "${roboshop_app_password}" ]
  echo -e "\e[31mNeed Mysql Root Password\e[0m"
  exit 1
fi


print_head "Setup Erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>{log_file}
status_check $?

print_head "Setup Rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>{log_file}
status_check $?

print_head "installing Rabbitmq"
dnf install rabbitmq-server -y  &>>{log_file}
status_check $?

print_head "Enable Rabbitmq"
systemctl enable rabbitmq-server  &>>{log_file}
status_check $?

print_head "start Rabbitmq service"
systemctl start rabbitmq-server &>>{log_file}
status_check $?

print_head "Add Application user"
rabbitmqctl add_user roboshop ${roboshop_app_password} &>>{log_file}
status_check $?

print_head "configuration permmistion for Appuser"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>{log_file}
status_check $?