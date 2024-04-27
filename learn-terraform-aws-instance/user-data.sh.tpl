#!/bin/bash

apt -y update && apt -y upgrade

echo "Creating file /home/ubuntu/${f_name} with content ${f_content}."
echo "${f_content}" > /home/ubuntu/${f_name}
cat /home/ubuntu/${f_name}