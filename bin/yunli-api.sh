#!/bin/bash

ROOT_DIR="/var/www/yunli/api/"
LOG_DIR="/var/www/log/yunli/api"
APP_NAME=yunli-api.jar

usage() {
    echo "用法: sh yunli-api.sh [start(启动)|stop(停止)|restart(重启)|status(状态)|log(实时监控日志)]"
    exit 1
}

cd $ROOT_DIR

is_exist(){
  pid=`ps -ef|grep $APP_NAME|grep -v grep|awk '{print $2}' `
  if [ -z "${pid}" ]; then
   return 1
  else
    return 0
  fi
}

start(){
  is_exist
  if [ $? -eq "0" ]; then
    echo "${APP_NAME} 正在运行。 pid=${pid} ."
  else
    nohup java -server -Xms256m -Xmx512m -jar $APP_NAME &
    echo "${APP_NAME}启动成功，请查看日志确保运行正常。"
    fi
}

stop(){
  is_exist
  if [ $? -eq "0" ]; then
    kill -9 $pid
    echo "${pid} 进程已被杀死，程序停止运行"
  else
    echo "${APP_NAME} 已经停止了！请确定是否认为操作"
  fi
}

status(){
  is_exist
  if [ $? -eq "0" ]; then
    echo "${APP_NAME} 正在运行。Pid is ${pid}"
  else
    echo "${APP_NAME} 已经停止了！请确定是否认为操作"
  fi
}

log(){
  LEVEL=$1
  echo ">>>> ${LEVEL}"
  if [[ ! ${LEVEL} ]]; then
    tail -f nohup.out
  else
    tail -f ${LOG_DIR}/${LEVEL}.log
  fi
}

restart(){
  stop
  start
  log
}

case "$1" in
  "start")
    start
    ;;
  "stop")
    stop
    ;;
  "status")
    status
    ;;
  "restart")
    restart
    ;;
  "log")
    log $2
    ;;
  *)
    usage
    ;;
esac
