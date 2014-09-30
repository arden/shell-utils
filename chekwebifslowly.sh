#!/bin/sh

host=邮箱SMTP服务器
sender=发送人邮箱
password=邮箱密码
receiver=邮件接收人地址，用逗号隔开

#echo "请输入你的网关地址"
#read sgateway
sgateway="tujiao.com"
echo "连接的的网关是$sgateway"
delay=400
echo "设置最大延迟不超过$delay毫秒"
nexttime=2
echo "每隔$nexttime秒进行一次检查"
echo "########################################"
#while :
#do
    network=`ping -c 1 $sgateway  |  awk 'NR==2 {print $8}' | sed "s/=/ /g"  | awk '{print $2}'`
    expr ${network} + 0 1>/dev/null 2>&1
    if [ $? -eq 0 ]; then
        #/etc/init.d/network restart
        echo "网络断了" 
        subject="tujiao.com down"
        content=$subject
       /app/java/bin/java -cp /cron/monitor:/cron/lib/* SendMails $host $sender $password "$subject" "$content" $receiver
    else
        value_n=`echo $network | sed "s/\.//g"`
        echo "$value_n"  
        if [ "$value_n" -gt "$delay" ];
        then
            #/etc/init.d/network restart
            echo "网络断了"                    
            subject="tujiao.com slowly"
            content=$subject
            /app/java/bin/java -cp /cron/monitor:/cron/lib/* SendMails $host $sender $password "$subject" "$content" $receiver
        else
            echo "检查结果为"                
            echo "网络通畅"                
            echo "网络延迟为$network秒"               
            echo "########################"             
        fi
    fi
    #sleep $nexttime
#done 