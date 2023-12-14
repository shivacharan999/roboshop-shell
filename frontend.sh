code_dir=$(pwd)
log_file=/tmp/robodhop.log
rm-rf ${log_file}

print_head() {
    echo -e "\e[36m$1\e[0m"
}

print_head  " <<<<<<< Installing Nginx >>>>>>> "
dnf install nginx -y  &>>${log_file}

print_head  " <<<<<<< Removing old content >>>>>>> "
rm -rf /usr/share/nginx/html/*  &>>${log_file}

print_head  " <<<<<<< Downloading frontend package >>>>>>> "
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}


print_head " <<<<<<< Unzipping the frontend content >>>>>>> "
cd /usr/share/nginx/html  &>>${log_file}
unzip /tmp/frontend.zip &>>${log_file}

print_head " <<<<<<< cp roboshop.conf file to system >>>>>>> "
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head  " <<<<<<< Enable the nginx >>>>>>> "
systemctl enable nginx &>>${log_file}

print_head  " <<<<<<< restart the nginx >>>>>>> "
systemctl restart nginx &>>${log_file}