#!/bin/bash
###
 docker pull redis:3.2.11
 docker pull mongoDB:2.8.0
 docker pull zookeeper:3.4.11
wget http://bkopen-10032816.file.myqcloud.com/cmdb/cmdb.tar.gz

#配置redis config
#导入redis.conf configMap
#kubectl delete configmap redisconfg -n prod 删除configMap
 kubectl create configmap redisconfg --from-file redis.conf -n prod
#配置redis AUTH
bind 0.0.0.0
requirepass password
###
##配置mongodb
##新建db与user
use cmdb
db.createUser({user: "cc",pwd: "cc",roles: [ { role: "readWrite", db: "cmdb" } ]})
###
###配置zooker####
##
###git clone https://github.com/Tencent/bk-cmdb.git 克隆代码
###下载zip文件安装报错，使用编译安装
###报错内容，为\x00错误，实际处理方法应该可以直接删除报错以.开头的隐藏文件。
参考issue：https://github.com/Tencent/bk-cmdb/issues/859

git clone https://github.com/Tencent/bk-cmdb.git
###编译安装安装依赖，运行没有报错
###
#golang >= 1.8
#python >= 2.7.5
#nodejs >= 4.0.0（编译过程中需要可以连公网下载依赖包）
yum -y install epel-release
yum -y install golang nodejs
###配置gopath
mkdir -p /data/abc/src
export GOPATH=/data/ab/src
cd $GOPATH
git clone https://github.com/Tencent/bk-cmdb  configcenter
cd $GOPATH/src/configcenter/src
make
##########build 成功后输出路径
/data/abc/src/configcenter/src/bin/build/oc-18.08.16
###
#初始化配置文件
python init.py --discovery 10.1.128.167:2181 --database cmdb --redis_ip 10.1.95.144  --redis_port 6379 --redis_pass my_redis --mongo_ip 10.1.19.148  --mongo_port 27017 --mongo_user cc --mongo_pass cc --blueking_cmdb_url http://0.0.0.0:8083 --listen_port 8083
#启动服务
./start.sh




