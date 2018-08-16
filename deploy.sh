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

