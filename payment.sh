source common.sh

roboshop_app_password=$1

if [ -z "${roboshop_app_password}" ]; then ## roboshop123
  echo -e "\e[31mNeed Mysql Root Password\e[0m"
  exit 1
fi

component=payment
python