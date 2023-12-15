code_dir=$(pwd)
log_file=/tmp/robodhop.log
rm -f ${log_file}

print_head() {
    echo -e "\e[36m$1\e[0m"
}


status_check() {
if [ $? -eq 0 ]; then
   echo SUCCESS
else
   echo FAILURE
   exit 1
fi
}
 
 systemd_setup() {
   print_head  " <<<<<<< cp ${component}.service to system >>>>>>> "
   cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
   status_check $?

   sed -i -e "s/ROBOSHOP_USER_PASSWORD/${roboshop_app_password}/" /etc/systemd/system/${component}.service &>>${log_file}
   
   print_head  " <<<<<<< demaon reload >>>>>>> "
   systemctl daemon-reload &>>${log_file}
   status_check $?

   print_head  " <<<<<<< enable ${component} >>>>>>> "
   systemctl enable ${component}  &>>${log_file}
   status_check $?

   print_head  " <<<<<<< restart ${component} >>>>>>> "
   systemctl restart ${component} &>>${log_file}
   status_check $?

 }

schema_setup() {

if [ ${schema_setup} == "mongo" ]; then
   print_head  " <<<<<<< cp mongodb.repo to system >>>>>>> "
   cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
   status_check $?


   print_head  " <<<<<<< Installing mongodb-org-shell >>>>>>> "
   dnf install mongodb-org-shell -y &>>${log_file}
   status_check $?

   print_head  " <<<<<<< Load Schema >>>>>>> "
   mongo --host mongodb-dev.devsig90.online </app/schema/${component}.js &>>${log_file}
   status_check $?

elif [ ${schema_setup} == "mysql" ]; then
   print_head " <<<<<<< Installing Mysql >>>>>>> "
   yum install mysql -y  &>>${log_file}
   status_check $?
    
   print_head " <<<<<<< Load Schema >>>>>>> "
   mysql -h mysql-dev.devsig90.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql 
   status_check $?

fi
}

app_prereq_setup() {
   print_head  " <<<<<<< useradd roboshop  >>>>>>> "
   id roboshop &>>${log_file}
   if [ $? -ne 0 ]; then
   useradd roboshop &>>${log_file}
   fi
   status_check $?

   print_head  " <<<<<<< mkdir /app  >>>>>>> "
   if [ ! -d /app ]; then
   mkdir /app  &>>${log_file}
   fi
   status_check $?

   print_head  " <<<<<<< rm -rf /app/* >>>>>>> "
   rm -rf /app/* &>>${log_file}
   status_check $?

   print_head  " <<<<<<< downloading ${component} content >>>>>>> "
   curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
   status_check $?

   print_head  " <<<<<<< cd /app >>>>>>> "
   cd /app &>>${log_file}
   status_check $?

   print_head  " <<<<<<< unzip /tmp/${component}.zip >>>>>>> "
   unzip /tmp/${component}.zip &>>${log_file}
   status_check $?
   
}

nodejs() {

   print_head  " <<<<<<< downloding nodejs >>>>>>> "
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

   print_head " <<<<<<< install Maven >>>>>>> "
   yum install maven -y &>>{log_file}
   status_check $?

   app_prereq_setup

   print_head " <<<<<<< download dependencies & Packages >>>>>>> "
   mvn clean package &>>{log_file}
   status_check $?

   print_head " <<<<<<< download dependencies & Packages >>>>>>> "
   mv target/${component}-1.0.jar ${component}.jar  &>>{log_file}
  status_check $?

   schema_setup

   systemd_setup
}



python() {

   print_head " <<<<<<< install python >>>>>>> "
   dnf install python36 gcc python3-devel -y &>>{log_file}
   status_check $?

   app_prereq_setup

   print_head " <<<<<<< download dependencies & Packages >>>>>>> "
   pip3.6 install -r requirements.txt &>>{log_file}
   status_check $?

   systemd_setup
}



