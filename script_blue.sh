#!/bin/bash
sudo dnf check-update
sudo dnf install -y httpd jq
sudo systemctl enable httpd
sudo systemctl start amazon-ssm-agent

echo "<h1>Blue Environment</h1>" > /var/www/html/index.html
sudo systemctl start httpd