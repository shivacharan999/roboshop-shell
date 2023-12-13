echo -e "\e[35m <<<<<<< Installing >>>>>>> Nginx\e[0m"
dnf install nginx -y 

echo -e "\e[35m <<<<<<< Removing old content >>>>>>> \e[0m"
rm -rf /usr/share/nginx/html/* 

echo -e "\e[35m <<<<<<< downloading frontend package >>>>>>> \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 

echo -e "\e[35m <<<<<<< CD to html dir >>>>>>> \e[0m"
cd /usr/share/nginx/html 

echo -e "\e[35m <<<<<<< Unzipping the frontend content >>>>>>> \e[0m"
unzip /tmp/frontend.zip

echo -e "\e[35m <<<<<<< cp roboshop.conf file to system >>>>>>> \e[0m"
cp configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[35m <<<<<<< Enable and restart the nginx >>>>>>> \e[0m"
systemctl enable nginx 
systemctl restart nginx 