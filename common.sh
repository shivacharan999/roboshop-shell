code_dir=$(pwd)
log_file=/tmp/robodhop.log
rm -f ${log_file}

print_head() {
    echo -e "\e[36m$1\e[0m"
}


status_check()
if { $? -eq 0}; then
   echo SUCESS
else
   echo FAILURE
   exit 1
fi
}
 
 systemd_setup() {
   print_head  " <<<<<<< Installing Nginx >>>>>>> "
   cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
   status_check $?

   print_head  " <<<<<<< Installing Nginx >>>>>>> "
   systemctl daemon-reload &>>${log_file}
   status_check $?

   print_head  " <<<<<<< Installing Nginx >>>>>>> "
   systemctl enable ${component}  &>>${log_file}
   status_check $?

   print_head  " <<<<<<< Installing Nginx >>>>>>> "
   systemctl restart ${component} &>>${log_file}
   status_check $?

 }

schema_setup() {

if [ "$(schema_setup)" == "mongo"]; then
   print_head  " <<<<<<< Installing Nginx >>>>>>> "
   cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
   status_check $?

   print_head  " <<<<<<< Installing Nginx >>>>>>> "
   dnf install mongodb-org-shell -y &>>${log_file}
   status_check $?

   print_head  " <<<<<<< Installing Nginx >>>>>>> "
   mongo --host 172.31.37.86 </app/schema/${component}.js &>>${log_file}
   status_check $?

elif [ "${schema_setup}" == "mysql" ]; then
   print_head "install Mysql client"
   yum install mysql -y  &>>${log_file}
   status_check $?
    
   print_head "Load schema"
   mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -p${mysql_root_password} < /app/schema/shipping.sql 
   status_check $?
}

app_prereq_setup() {
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
   curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
   status_check $?

   print_head  " <<<<<<< Installing Nginx >>>>>>> "
   cd /app &>>${log_file}
   status_check $?

   print_head  " <<<<<<< Installing Nginx >>>>>>> "
   unzip /tmp/${component}.zip &>>${log_file}
   status_check $?
   
}

nodejs() {

   print_head  " <<<<<<< Installing Nginx >>>>>>> "
   curl -sL https:///rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
   status_check $?

   print_head  " <<<<<<< Installing nodejs >>>>>>> "
   yum install nodejs -y &>>${log_file}
   status_check $?


   app_prereq_setup

   print_head  " <<<<<<< Installing nodejs dependencies >>>>>>> "
   npm install &>>${log_file}
   status_check $?

   schema_setup

   systemd_setup

}


java() {

   print_head "install Maven"
   yum install maven -y &>>{log_file}
   status_check $?

   app_prereq_setup

   print_head "download dependencies & Packages"
   mvn clean package &>>{log_file}
   &>>{log_file}

   print_head "download dependencies & Packages"
   mv target/${component}-1.0.jar ${component}.jar  &>>{log_file}
   &>>{log_file}

   schema_setup

   systemd_setup
}