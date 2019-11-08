#!/bin/sh

###  项目配置  ####
ENV=prod
# 项目名
NAME=yunli
# 项目名
PROJECT_NAME=yunli
# 项目根目录
BASE_DIR=yunli
# 根目录
ROOT_PATH=/var/www
# 项目目录
PROJECT_PATH=${ROOT_PATH}/gitlab/${BASE_DIR}
# 部署目录
DEPLOY_PATH=${ROOT_PATH}/${BASE_DIR}
# 项目远程仓库地址
REMOTE_REP_URL=http://gitlab.innodev.cn:9001/innodev/iLive.git

####### 颜色代码 ########
## https://www.cnblogs.com/lr-ting/archive/2013/02/28/2936792.html ##
RED="31m"      # Error message
GREEN="32m"    # Success message
YELLOW="33m"   # Warning message
BLUE="36m"     # Info message

echoLog(){
	color="$1"
    echo -e "\033[${color} ${@:2} \033[0m"
}


echoSuccess(){
	echoLog ${GREEN} $1
}
echoWarning(){
    echoLog ${YELLOW} $1
}
echoInfo(){
    echoLog ${BLUE} $1
}
echoError(){
    echoLog ${RED} $1
}



useage(){
    echo -e "
Copyright @ yadong.zhang . Current Version : v1.0.0

使用方法:
    sh ${PROJECT_NAME}-cli.sh [options] [modules]
    [options]
        install                : 安装
        update                 : 更新
    [modules]
        admin                  : 后台程序(${PROJECT_NAME}-admin)
        api                    : api接口程序(${PROJECT_NAME}-api)
        all                    : 将会分别执行[admin|api]
示例:
    sh ${PROJECT_NAME}-cli.sh install admin
    sh ${PROJECT_NAME}-cli.sh update admin
"
	echoWarning "注：如果脚本无法执行（报异常），请使用dos2unix命令编译（yum install dos2unix）"
    echoWarning "----"
	echoWarning "注：本工具不支持一键安装MySQL. 需自行安装MySQL/MariaDB,并创建名为${PROJECT_NAME}的数据库"
    exit 1
}

install(){
	PROJECT_TYPE=$1
    echoInfo "接受参数： ${PROJECT_TYPE} "
	MODULE_NAME=${PROJECT_NAME}-${PROJECT_TYPE}

	echoWarning "注：本工具不支持一键安装MySQL. 需自行安装MySQL/MariaDB,并创建名为${PROJECT_NAME}的数据库"

	installMaven

	installJdk

	installGit

	# installMysql

	cloneSourceCode


	if  [ ! -n "$PROJECT_TYPE" && 'all' != "$PROJECT_TYPE" ] ;then
		build ${PROJECT_TYPE} ${MODULE_NAME}
	else
		build 'admin' "${PROJECT_NAME}-admin"
		build 'api' "${PROJECT_NAME}-api"
	fi



	echo -e "----------------------------------------------------"
	echoSuccess "Congratulations! \n ${NAME} 安装成功..."
	echoSuccess "使用systemctl start ${PROJECT_NAME}-[admin|api]启动"
	echoSuccess "使用systemctl enable ${PROJECT_NAME}-[admin|api]将${PROJECT_NAME}-[admin|api]加入开机启动"
	echo -e "----------------------------------------------------"
}

installMaven(){
	read -p '是否安装maven？[y/n]' maven
	if [ "${maven}" = "y" -o "${maven}" = "Y" ];then
		wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
		yum install -y -q apache-maven
		echoSuccess "Maven安装完成，版本为: `mvn --version | head -1`"
	fi
}

installJdk(){
	read -p '是否安装OpenJDK1.8？[y/n]' jdk
	if [ "${jdk}" = "y" -o "${jdk}" = "Y" ];then
		yum install -y -q java-1.8.0-openjdk  java-1.8.0-openjdk-devel
		echoSuccess "OpenJDK安装完成，版本为: `java -version | head -1`"
	fi
}

installGit(){
	read -p '是否安装Git？[y/n]' git
	if [ "${git}" = "y" -o "${git}" = "Y" ];then
		yum install -y -q git
		echoSuccess "Git安装完成，版本为: `git --version | head -1`"
	fi
}

cloneSourceCode(){
	if [[ -d ${PROJECT_PATH} ]]; then
        rm -rf ${PROJECT_PATH}
    fi
    echo -e "----------------------------------------------------"
    echoInfo "正在下载${NAME}..."
    echo -e "----------------------------------------------------"
    git clone ${REMOTE_REP_URL} ${PROJECT_PATH}
	STATUS=$?
	if [[ $STATUS == 0 ]]; then
		echoSuccess "账号认证成功！开始clone最新代码..."
	else
		echoError "账号认证失败！请确认git账号密码是否正确..."
		exit 1
	fi
}

installMysql(){
	rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
	yum repolist enabled | grep "mysql.*"
	yum -y install mysql-community-server
    echoSuccess "MySQL版本为: `mysql -V | head -1`"
}

build(){

	PROJECT_TYPE=$1
	MODULE_NAME=$2

    echoInfo "接受参数： ${PROJECT_TYPE}  ${MODULE_NAME}"
	echo -e "----------------------------------------------------"
	echoInfo "开始打包${MODULE_NAME}..."
	if [[ -d ${PROJECT_PATH} ]]; then
	    cd ${PROJECT_PATH}
	else
	    mkdir -p ${PROJECT_PATH}
	    cd ${PROJECT_PATH}
	fi
	# 打包工程
	#mvn -X clean package -Dmaven.test.skip=true
	mvn -X clean package -Dmaven.test.skip=true -P prod
    STATUS=$?
    if [[ $STATUS == 0 ]]; then

        echoSuccess "${MODULE_NAME}打包成功..."

        # 系统服务这块还有点问题，拉取完成后只能暂时通过/var/www/shell下的脚本执行启动
        mkdir -p ${DEPLOY_PATH}/${PROJECT_TYPE}
        cp -R ${MODULE_NAME}/target/${MODULE_NAME}.jar ${DEPLOY_PATH}/${PROJECT_TYPE}
        touch /etc/systemd/system/${MODULE_NAME}.service
		cat > /etc/systemd/system/${MODULE_NAME}.service << EOF
[Unit]
Description=${MODULE_NAME}
After=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/bin/java -server -Xms256m -Xmx512m -jar ${DEPLOY_PATH}/${PROJECT_TYPE}/${MODULE_NAME}.jar --spring.profiles.active=${ENV} > ${DEPLOY_PATH}/${PROJECT_TYPE}/${MODULE_NAME}.log
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
StandOutput=syslog

StandError=inherit

[Install]
WantedBy=multi-user.target
EOF
		systemctl daemon-reload
    else
        echoError "${MODULE_NAME}打包失败"
        exit 1
    fi
	echo -e "----------------------------------------------------"
}



update(){
    PROJECT_TYPE=$1
    echoInfo "update接受参数： ${PROJECT_TYPE}"
	MODULE_NAME=${PROJECT_NAME}-${PROJECT_TYPE}

    if [[ -d ${PROJECT_PATH} ]]; then
        cd ${PROJECT_PATH}
        git pull
		STATUS=$?
		if [[ $STATUS == 0 ]]; then
			echoSuccess "账号认证成功！开始获取最新代码..."
			#mvn clean package -Dmaven.test.skip=true
	        mvn -X clean package -Dmaven.test.skip=true -P prod
			STATUS=$?
			if [[ $STATUS == 0 ]]; then
				if  [[ -n "${PROJECT_TYPE}" && 'all' != "${PROJECT_TYPE}" ]] ;then
					package ${PROJECT_TYPE}
				elif [[ 'all' == "${PROJECT_TYPE}" ]] ;then
					package "admin"
					package "api"
				else
					echo -e "----------------------------------------------------"
					echoError "无效的参数"
					echo -e "----------------------------------------------------"
				fi
			else
				echo -e "----------------------------------------------------"
				echoError "${MODULE_NAME} 更新失败"
				echo -e "----------------------------------------------------"
				exit 1
			fi
		else
			echoError "账号认证失败！请确认git账号密码是否正确..."
			exit 1
		fi
    else
        echo -e "----------------------------------------------------"
        echoError "Sorry,貌似还未安装${NAME}哦,请先执行安装"
        echo -e "----------------------------------------------------"
        exit 1
    fi
}

package(){
    PROJECT_TYPE=$1
    echoInfo "接受参数： ${PROJECT_TYPE}"
	MODULE_NAME=${PROJECT_NAME}-${PROJECT_TYPE}
	REAL_JAR_PATH=${DEPLOY_PATH}/${PROJECT_TYPE}

    echoInfo "备份${REAL_JAR_PATH}/${MODULE_NAME}.jar..."
    cp ${REAL_JAR_PATH}/${MODULE_NAME}.jar-latest ${REAL_JAR_PATH}/${MODULE_NAME}.jar-`date "+%Y%m%d%H%M%S"`
    cp ${REAL_JAR_PATH}/${MODULE_NAME}.jar ${REAL_JAR_PATH}/${MODULE_NAME}.jar-latest

    echoInfo "部署${MODULE_NAME}/target/${MODULE_NAME}.jar到${REAL_JAR_PATH}..."
    cp -R ${MODULE_NAME}/target/${MODULE_NAME}.jar ${REAL_JAR_PATH}

    echo -e "----------------------------------------------------"
    echoSuccess "Congratulations! \n ${MODULE_NAME} 更新成功..."
    echoSuccess "使用systemctl restart ${MODULE_NAME}启动"
    echo -e "----------------------------------------------------"
}

if [[ $# == 2 ]]; then
	module=$2
    case $1 in
    "install")
        install ${module}
    ;;
    "update")
        update ${module}
    ;;
    *)
        useage
    ;;
    esac
else
    useage
fi
