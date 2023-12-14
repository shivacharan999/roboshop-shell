source common.sh

mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then  ###RoboShop@1
   echo -e "\e[31m Need Mysql Root Password\e[0m"
   exit 1
fi

component=shipping
schema_setup="mysql"
java