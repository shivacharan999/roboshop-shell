source common.sh

print_head  " <<<<<<< Installing Nginx >>>>>>> "
dnf install nginx -y  &>>${log_file}
status_check $?

print_head  " <<<<<<< Removing old content >>>>>>> "
rm -rf /usr/share/nginx/html/*  &>>${log_file}
status_check $?

print_head  " <<<<<<< Downloading frontend package >>>>>>> "
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
status_check $?


print_head " <<<<<<< Unzipping the frontend content >>>>>>> "
cd /usr/share/nginx/html  &>>${log_file}
unzip /tmp/frontend.zip &>>${log_file}
status_check $?

print_head " <<<<<<< cp roboshop.conf file to system >>>>>>> "
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
status_check $?

print_head  " <<<<<<< Enable the nginx >>>>>>> "
systemctl enable nginx &>>${log_file}
status_check $?

print_head  " <<<<<<< restart the nginx >>>>>>> "
systemctl restart nginx &>>${log_file}
status_check $?