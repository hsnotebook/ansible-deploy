#!/bin/bash
deploy_home=`cd $(dirname $0); cd ..; pwd`
repo_base_dir=/var/www/html

backup_repos() {
    echo "Backup /etc/yum.repos.d to /root/yum.repos.d.bak"
    if [[ ! -d /root/yum.repos.d.bak ]]
    then
        mkdir -p /root/yum.repos.d.bak
    fi
    mv /etc/yum.repos.d/* /root/yum.repos.d.bak
}

copy_repo_files() {
    echo "copy repo files"
    local repo_dir=${deploy_home}/repos

    if [[ ! -d ${repo_base_dir} ]]
    then
        mkdir -p ${repo_base_dir}
    fi

    cp -r ${repo_dir}/* ${repo_base_dir}
    mkdir ${repo_base_dir}/iso
    mount -o loop,ro ${repo_base_dir}/AnolisOS-7.9-QU1-x86_64-dvd.iso ${repo_base_dir}/iso
    echo "${repo_base_dir}/AnolisOS-7.9-QU1-x86_64-dvd.iso ${repo_base_dir}/iso iso9660 loop 0 0" >> /etc/fstab
}

config_local_repo() {
    echo "Create local repo"
    cat << EOF > /etc/yum.repos.d/iso.repo
[iso]
async = 1
baseurl = file://${repo_base_dir}/iso
enabled = 1
gpgcheck = 0
name = ISO Repo
EOF
    cat << EOF > /etc/yum.repos.d/common.repo
[common]
async = 1
baseurl = file://${repo_base_dir}/common
enabled = 1
gpgcheck = 0
name = Common Repo
EOF
    yum -y makecache > /dev/null
}

install_httpd() {
    echo "Install httpd"
    yum install -y --disablerepo=* --enablerepo=iso httpd > /dev/null
    sed -i 's/Listen 80/Listen 30081/g' /etc/httpd/conf/httpd.conf

    systemctl start httpd > /dev/null
    systemctl enable httpd > /dev/null
    systemctl restart httpd > /dev/null
}

####################################
########## Repo Config #############
####################################
config_repo() {
    echo ""
    echo "########## Repo Config #############"
    backup_repos
    copy_repo_files
    config_local_repo
    install_httpd
}
clean_repo() {
    echo ""
    echo "########## Clean Repo #############"
    rm -f /etc/yum.repos.d/iso.repo
    rm -f /etc/yum.repos.d/common.repo
}

####################################
######### Ansible Setup ############
####################################
config_ansible() {
    echo ""
    echo "######### Ansible Setup ############"

    echo "Install ansible"
    yum install -y --disablerepo=* --enablerepo=common ansible > /dev/null

    echo "Install ansible collection"
    ansible-galaxy collection install ${deploy_home}/ansible/collections/ansible-posix-1.5.4.tar.gz > /dev/null
    ansible-galaxy collection install ${deploy_home}/ansible/collections/community-general-7.4.0.tar.gz > /dev/null
}

####################################
######### SSH key Setup ############
####################################
config_ssh() {
    echo ""
    echo "######### SSH Setup ############"
    echo "Install sshpass"
    yum install -y --disablerepo=* --enablerepo=common sshpass > /dev/null

    if [[ ! -f /root/.ssh/id_rsa.pub ]]
    then
        echo "Create ssh key"
        ssh-keygen -q -t rsa -N '' <<< $'\ny' >/dev/null 2>&1
    fi
    grep taso-deploy ~/.ssh/config > /dev/null 2>&1

    if [[ $? -ne 0 ]]
    then
        echo "Insert ${HOSTNAME} to /root/.ssh/config"
        cat << EOF >> /root/.ssh/config
Host ${HOSTNAME}
    Hostname ${IP}
    User root
    Port ${SSH_PORT}
EOF

        sshpass -p "${SSH_PASSWORD}" ssh-copy-id -o StrictHostKeyChecking=no ${HOSTNAME} > /dev/null
    fi

}

####################################
########## Install Application #####
####################################
execute_ansible() {
    echo ""
    cd ${deploy_home}/ansible/

    if [ "$1" = 'debug' ] ;then
        echo "########## Run ansible debug #####"
        ansible-playbook -i hosts debug.yml
        exit 0
    fi

    echo "########## Install Application #####"
    if [ -n "$1" ] ;then
        ansible-playbook -i hosts --tags=$1 site.yml
    else
        ansible-playbook -i hosts site.yml
    fi
}

####################################
######### disable selinux ##########
####################################
config_selinux() {
    echo ""
    echo "######### Disable selinux ############"

    echo "Disable selinux"
    setenforce 0
}

case "$1" in
    config)
        # config_selinux
        config_repo
        # config_ssh
        config_ansible
        clean_repo
        ;;
    ansible)
        execute_ansible $2
        ;;
    install)
        execute_ansible
        ;;
    *)
        echo "Usage:"
        echo "  $0 config"
        echo "  $1 install"
        echo "  $0 ansible debug"
        echo "  $0 ansible <tags>"
        ;;
esac
