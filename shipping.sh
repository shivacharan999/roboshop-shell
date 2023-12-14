source common.sh

mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
echo -e "\e[31m Need Mysql Root Password\e[0m"
exit 1

component=shipping
schema_setup="mysql"
java