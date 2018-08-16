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
##bash ./init_db 初始化db失败
#bash ./init_db.sh 
#{"result":false,"bk_error_code":1105000,"bk_error_msg":"迁移数据失败","data":null
#日志报错，实际是连接到了mongodb 创建这个文件失败了。
E0816 12:58:40.191454    3477 migrate.go:39] db upgrade error: couldn't create file /data/db/cmdb.ns
###mongo 日志
#2018-08-16T04:58:42.868+0000 W STORAGE  [conn14] database /data/db cmdb could not be opened due to DBException 18825: couldn't create file /data/db/cmdb.ns
##出错的原因是因为权限不够无法创建文件，解决方案是admin库创建一个管理员角色的用户，并登陆使用admin库。新建cmdb需要链接库的用户
###
#use admin

#db.createUser(
#{
#user: "cc",
#pwd: "cc",
#roles: [
#{ role: "readWrite", db: "cmdb" }
#]
#})





