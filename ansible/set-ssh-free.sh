#!/bin/bash
while read host; do
	if [[ $host != \[* ]]; then
		if [[ "$host" == *"ansible_host"* ]]; then
			ip=`echo $host | cut -d ' ' -f2 | cut -d '=' -f2`
			port=`echo $host | cut -d ' ' -f3 | cut -d '=' -f2`
			user=`echo $host | cut -d ' ' -f4 | cut -d '=' -f2`
			password=`echo $host | cut -d ' ' -f5 | cut -d '=' -f2`
			sshpass -p "${password}" \
					ssh-copy-id -p ${port} \
					-o StrictHostKeyChecking=no \
					${user}@${ip}
		else
			sshpass -p 'ctfo@123' ssh-copy-id -o StrictHostKeyChecking=no root@$host
		fi
	fi
done < hosts

