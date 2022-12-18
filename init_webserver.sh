#!/bin/bash

# Create mount volume for logs
  sudo su - root
  mkfs.ext4 /dev/sdf
  mount -t ext4 /dev/sdf /var/log

# Install & Start nginx server
  yum search nginx
  amazon-linux-extras install nginx1 -y
  systemctl start nginx
  systemctl enable nginx

#Install AWS CLI
  FILE="./aws/install"

  if [ -f "$FILE" ];
  then
    echo "File $FILE exist."
  else
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
  fi

# Print the hostname which includes instance details on nginx homepage
  #sudo cp index.html > /usr/share/nginx/html/index.html
  sudo aws s3 cp s3://democode1988/index.html /usr/share/nginx/html/index.html