code_dir=$(pwd)
log_file=/tmp/robodhop.log
rm-rf ${log_file}

echo -e "\e[35m <<<<<<< Installing Nginx >>>>>>> \e[0m"
dnf install nginx -y  &>>${log_file}

echo -e "\e[35m <<<<<<< Removing old content >>>>>>> \e[0m"
rm -rf /usr/share/nginx/html/*  &>>${log_file}

echo -e "\e[35m <<<<<<< Downloading frontend package >>>>>>> \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}


echo -e "\e[35m <<<<<<< Unzipping the frontend content >>>>>>> \e[0m"
cd /usr/share/nginx/html  &>>${log_file}
unzip /tmp/frontend.zip &>>${log_file}

echo -e "\e[35m <<<<<<< cp roboshop.conf file to system >>>>>>> \e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

echo -e "\e[35m <<<<<<< Enable the nginx >>>>>>> \e[0m"
systemctl enable nginx &>>${log_file}

echo -e "\e[35m <<<<<<< restart the nginx >>>>>>> \e[0m"
systemctl restart nginx &>>${log_file}