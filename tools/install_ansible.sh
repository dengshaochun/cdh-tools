#!/usr/bin/env bash
# @desc: Centos主机安装ansible组件
# @auther: dengsc
# @date: 20180315


WORK_PATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd ${WORK_PATH}


# 日志打印函数
function Log(){
    date_str="$(date +"%Y-%m-%d %r")"
    if [ $# -ne 2 ];
    then
        echo -e "\033[31m ${date_str} | ERROR | Log 函数参数个数错误. 需求值 -> 3, 实际值 -> $#\033[0m"
    else
        log_type="${1}"
        log_msg="${2}"
        case "${log_type}" in
            "WARN")
                echo -e "\033[33m ${date_str} | WARN | ${log_msg} \033[0m"
            ;;
            "ERROR")
                echo -e "\033[31m ${date_str} | ERROR | ${log_msg} \033[0m"
            ;;
            "SUCCESSFUL")
                echo -e "\033[32m ${date_str} | SUCCESSFUL | ${log_msg} \033[0m"
            ;;
            *)
                echo -e "\033[37m ${date_str} | INFO | ${log_msg} \033[0m"
            ;;
        esac
    fi
}

# 检查脚本执行用户是否为root
function check_user(){
    Log "INFO" "Check current user"
    if [[ "$USER" != "root" ]];
    then
        Log "ERROR" "Please run Script as root user"
        exit -1
    else
        Log "SUCCESSFUL" "Check User successful. Current user: ${USER}"
    fi
}


# 检查python版本号是否合适
function check_python_version(){
    Log "INFO" "Check python version"
    cmd_out=$(python -V 2>&1)
    main_version=$(echo ${cmd_out} | awk '{print $NF}' | awk -F"." '{print $1}')
    middle_version=$(echo ${cmd_out} | awk '{print $NF}' | awk -F"." '{print $2}')
    if [[ "${main_version}" != "2" ]];
    then
        Log "ERROR" "Python Main version not equal 2"
        exit -1
    fi
    if [[ "${middle_version}" -lt 6 ]];
    then
        Log "ERROR" "Python Version must greater than 2.7"
        exit -1
    fi
    Log "SUCCESSFUL" "Python Version check successful!Current Version: ${cmd_out}"
}


# 安装必须的系统组件
function install_system_tools(){
    Log "INFO" "Install system tools"
    yum install -y wget net-tools unzip python sshpass
    if [[ $? -eq 0 ]];
    then
        Log "SUCCESSFUL" "Install system tools successful"
    else
        Log "ERROR" "Install system tools faild"
        exit -1
    fi
}


# 安装python 包管理工具 pip
function check_and_install_pip(){
    Log "INFO" "Check and install pip"
    cmd_out=$(pip -V 2>&1)
    if [ $? -eq 0 ];
    then
        Log "WARN" "Tool -> pip already installed! Version: ${cmd_out}"
        return
    fi
    wget https://pypi.python.org/packages/e0/02/2b14188e06ddf61e5b462e216b15d893e8472fca28b1b0c5d9272ad7e87c/setuptools-38.5.2.zip#md5=b4c7f29c8079bdf2f0f355cdcd999e69
    wget https://pypi.python.org/packages/ba/2c/743df41bd6b3298706dfe91b0c7ecdc47f2dc1a3104abeb6e9aa4a45fa5d/ez_setup-0.9.tar.gz
    if [[ -f setuptools-38.5.2.zip ]] && [[ -f ez_setup-0.9.tar.gz ]];
    then
        unzip setuptools-38.5.2.zip && cd setuptools-38.5.2 && python setup.py install && cd ..
        tar -zxf ez_setup-0.9.tar.gz && cd ez_setup-0.9 && python setup.py install && cd ..
        rm -r ez_setup-0.9.tar.gz setuptools-38.5.2.zip setuptools-38.5.2 ez_setup-0.9
    else
        Log "ERROR" "Missing Package [setuptools, ez_setup]"
        exit -1
    fi
    easy_install pip
    if [ $? -eq 0 ];
    then
        Log "SUCCESSFUL" "Install pip successful"
    else
        Log "ERROR" "Install pip faild"
    fi
}


# 安装ansible
function check_and_install_ansible(){
    Log "INFO" "Check and install ansible"
    cmd_out=$(ansible --version 2>&1)
    if [ $? -eq 0 ];
    then
        Log "WARN" "Tool -> ansible already installed. Version: ${cmd_out} "
        return
    else
        pip install ansible
        if [ $? -ne 0 ];
        then
            Log "ERROR" "Install ansible faild"
        else
            Log "SUCCESSFUL" "Install ansible successful"
        fi
    fi
}


# 函数主逻辑
function main(){
    Log "INFO" "Start Run Script"
    check_user
    install_system_tools
    check_python_version
    check_and_install_pip
    check_and_install_ansible
    Log "INFO" "End Run Script"
}


# 函数入口
main
