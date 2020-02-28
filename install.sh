#!/bin/sh
sudo apt update
sudo apt install -y apache2 apache2-bin apache2-utils
sudo systemctl enable apache2
sudo systemctl start apache2
echo "<html><h1>Hello from Pavan Created the Webserver for Interview</h2></html>" > /var/www/html/index.html
