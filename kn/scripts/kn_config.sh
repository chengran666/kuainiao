#!/bin/sh

eval `dbus export kn_`
KSROOT="/koolshare"
source $KSROOT/scripts/base.sh
version="0.4"
app_version="2.0.3.4"
protocolVersion=108
sdkVersion=17550

#双WAN判断
#wans_mode=$(nvram get wans_mode)

#二次修改 

case $kn_config_wan in
"1")
    wan_selected=$(nvram get wan_ipaddr)
    ;;
"2")
    wan_selected=$(nvram get wan2_ipaddr)
    ;;
"3")
    wan_selected=$(nvram get wan3_ipaddr)
    ;;
"4")
    wan_selected=$(nvram get wan4_ipaddr)
    ;;
  *)
	wan_selected=$(nvram get wan_ipaddr)
    ;;
esac


if [ "$wan_selected" != "0.0.0.0" ]; then
	bind_address=$wan_selected
else
	bind_address=""
fi
#定义请求函数
#bind_address='113.248.3.11'
if [ -n "$bind_address" ]; then
	HTTP_REQ="wget --bind-address=$bind_address --no-check-certificate -O - "
	POST_ARG="--post-data="
else
	HTTP_REQ="wget --no-check-certificate -O - "
	POST_ARG="--post-data="
fi
dbus set kn_HTTP_REQ=$HTTP_REQ
dbus set kn_POST_ARG=$POST_ARG

#数据mock
uname=$kn_config_uname
pwd=$kn_config_pwd
#pwd='702CFAF5824E4306516F488DEAFC2D24F76C82FA53BA3396F5615FDD32E4430E45B254E136056ED5F3C5B404A08E2178B51330999A4EC3C2D2989D554D7863BDE8F058F44808E6B65F4D071B5D5C7210210DA9ED8D729312CECA39E0F4516143E33C089F616ABE93E14D3224BEB311D3D6EF65A6CE265D3E4ABA285523F14320'
devicesign=$kn_device_sign
#verifyCode=$kuainiao_config_verifyCode
#verifyKey=$kuainiao_verifyKey

#获取用户真实MAC地址
#二次修改 依然增加默认选项
get_mac_addr(){
	if [ -n "$bind_address" ]; then
		case $kn_config_wan in
		"1")
    		nic=wan_hwaddr
    		;;
		"2")
    		nic=wan2_hwaddr
    		;;
		"3")
    		nic=wan3_hwaddr
    		;;
		"4")
    		nic=wan4_hwaddr
    		;;
		*)
    		nic=wan_hwaddr
    		;;
		esac
	else
		nic=wan_hwaddr
	fi
	peerid=$(nvram get $nic|awk 'gsub(/:/, "") {printf("%s", toupper($1))}')004V
	#peerid='000C29212478004V'
}
get_mac_addr

#nic=eth0
#peerid=$(ifconfig $nic|grep $nic|awk 'gsub(/:/, "") {print $5}')004V

#转存参数
dbus set kn_config_nic=$nic
dbus set kn_config_peerid=$peerid
dbus set kn_version=$version
dbus set kn_app_version=$app_version

#获取迅雷用户uid
get_xunlei_uid(){
	ret=`$HTTP_REQ --header "User-Agent:android-async-http/xl-acc-sdk/version-1.6.1.177600" https://login.mobile.reg2t.sandai.net:443/ $POST_ARG"{\"userName\":\""$uname"\",\"businessType\":68,\"clientVersion\":\"$app_version\",\"appName\":\"ANDROID-com.xunlei.vip.swjsq\",\"isCompressed\":0,\"sequenceNo\":1000001,\"sessionID\":\"\",\"loginType\":0,\"rsaKey\":{\"e\":\"010001\",\"n\":\"AC69F5CCC8BDE47CD3D371603748378C9CFAD2938A6B021E0E191013975AD683F5CBF9ADE8BD7D46B4D2EC2D78AF146F1DD2D50DC51446BB8880B8CE88D476694DFC60594393BEEFAA16F5DBCEBE22F89D640F5336E42F587DC4AFEDEFEAC36CF007009CCCE5C1ACB4FF06FBA69802A8085C2C54BADD0597FC83E6870F1E36FD\"},\"cmdID\":1,\"verifyCode\":\"$verifyCode\",\"peerID\":\""$peerid"\",\"protocolVersion\":$protocolVersion,\"platformVersion\":1,\"passWord\":\""$pwd"\",\"extensionList\":\"\",\"verifyKey\":\"$verifyKey\",\"sdkVersion\":$sdkVersion,\"devicesign\":\""$devicesign"\"}"`
	#判断是否登陆成功
	#echo $ret >>test.txt
	session=`echo $ret|awk -F '"sessionID":' '{print $2}'|awk -F '[,}]' '{print $1}'|grep -oE "[A-F,0-9]{32}"`
	#vcode=`echo $ret|awk -F '"errorDescUrl":' '{print $2}'|awk -F '}' '{print $1}'`
	#vcode=`echo $vcode|sed 's/\\//g'`
	errcode=`echo $ret|awk -F '"errorCode":' '{print $2}'|awk -F '[,}]' '{print $1}'`

	if [ -z "$session" ]
	  then
	  	  if [ $errcode == 6 ];then
			#dbus set kuainiao_vcodeimg_url="$vcode"
			#dbus set kuainiao_verifyKey='F9F6FBE928911784D809EBF046ABE0A6A467583F3944507099EA54BC9B5DA7BD'
			dbus set kn_last_act="<font color=white>您的账号不安全，需要输入验证码! $(date "+%Y-%m-%d %H:%M:%S")</font>"
			
		  elif [ $errcode == 12 ];then
		  	#dbus set kuainiao_vcodeimg_url=""
			#dbus set kuainiao_verifyKey=''
		  	dbus set kn_last_act="<font color=white>登陆协议无效，请更新！$(date "+%Y-%m-%d %H:%M:%S")</font>"
			  
		  elif [ $errcode == 3 ];then
		  	#dbus set kuainiao_vcodeimg_url=""
			#dbus set kuainiao_verifyKey=''
		  	dbus set kn_last_act="<font color=white>用户名密码错误，请检查！$(date "+%Y-%m-%d %H:%M:%S")</font>"
			  
		  else
		  	#dbus set kuainiao_vcodeimg_url=""
			#dbus set kuainiao_verifyKey=''
		  	dbus set kn_last_act="<font color=white>迅雷账号登陆失败，请检查输入的用户名密码! $(date "+%Y-%m-%d %H:%M:%S")</font>"
			 
		  fi
		  #echo "迅雷账号登陆失败，请检查输入的用户名密码!"
	  else
		  uid=`echo $ret|awk -F '"userID":' '{print $2}'|awk -F '[,}]' '{print $1}'`
		  dbus set kn_config_uid=$uid
		  dbus set kn_config_session=$session
		  kn_config_session=$session
		  dbus set kn_last_act="<font color=white>迅雷快鸟已登陆成功!</font>"
	fi
}

#获取加速API
get_kuainiao_api(){
	portal=`$HTTP_REQ http://api.portal.swjsq.vip.xunlei.com:81/v2/queryportal`
	portal_ip=`echo $portal|grep -oE '([0-9]{1,3}[\.]){3}[0-9]{1,3}'`
	portal_port_temp=`echo $portal|grep -oE "port...[0-9]{1,5}"`
	portal_port=`echo $portal_port_temp|grep -oE '[0-9]{1,5}'`
	if [ -z "$portal_ip" ]
		then
			dbus set kn_down_state="迅雷快鸟下行API获取失败，请检查网络环境，或稍后再试!"
			#echo "迅雷快鸟服务API获取失败，请检查网络环境，或稍后再试!"
		else
			api_url="http://$portal_ip:$portal_port/v2"
			dbus set kn_config_api=$api_url
	fi
}

#获取上行加速API
get_kuainiao_upapi(){
	upportal=`$HTTP_REQ http://api.upportal.swjsq.vip.xunlei.com/v2/queryportal`
	upportal_ip=`echo $upportal|grep -oE '([0-9]{1,3}[\.]){3}[0-9]{1,3}'`
	upportal_port_temp=`echo $upportal|grep -oE "port...[0-9]{1,5}"`
	upportal_port=`echo $upportal_port_temp|grep -oE '[0-9]{1,5}'`
	if [ -z "$upportal_ip" ]
		then
			dbus set kn_up_state="迅雷快鸟上行API获取失败，请检查网络环境，或稍后再试!"
			#echo "迅雷快鸟服务API获取失败，请检查网络环境，或稍后再试!"
		else
			upapi_url="http://$upportal_ip:$upportal_port/v2"
			dbus set kn_config_upapi=$upapi_url
	fi
}


#检测快鸟加速信息
get_bandwidth(){
	if [ -n "$api_url" ]; then
		band=$(bandwidth)
		can_upgrade=`echo $band|awk -F '"can_upgrade":' '{print $2}'|awk -F '[,}]' '{print $1}'`
		dbus set kn_can_upgrade=$can_upgrade
		kn_can_upgrade=$can_upgrade
		dial_account=`echo $band|awk -F '"dial_account":"' '{print $2}'|awk -F '[,}"]' '{print $1}'`
		dbus set kn_dial_account=$dial_account
		kn_dial_account=$dial_account
		#判断是否满足加速条件
		if [[ $can_upgrade -eq 1 ]]; then
			#echo "迅雷快鸟可以加速~~~愉快的开始加速吧~~"
			#获取加速详细信息
			old_downstream=`echo $band|awk -F '"bandwidth":' '{print $2}'|awk -F '"downstream":' '{print $2}'|awk -F '[,}]' '{print $1}'`
			max_downstream=`echo $band|awk -F '"max_bandwidth":' '{print $2}'|awk -F '"downstream":' '{print $2}'|awk -F '[,}]' '{print $1}'`
			down_state="下行可以加速"
			dbus set kn_old_downstream=$(expr $old_downstream / 1024)
			dbus set kn_max_downstream=$(expr $max_downstream / 1024)
			kn_old_downstream=$(expr $old_downstream / 1024)
			kn_max_downstream=$(expr $max_downstream / 1024)
		else
			down_state="下行不满足加速条件"
			#echo "T_T 不能加速啊，不满足加速条件哦~~"
		fi
		dbus set kn_down_state=$down_state
	fi
}

#检测快鸟上行加速信息
get_upbandwidth(){
	if [ -n "$upapi_url" ]; then
		band=$(upbandwidth)
		can_upgrade=`echo $band|awk -F '"can_upgrade":' '{print $2}'|awk -F '[,}]' '{print $1}'`
		dbus set kn_can_upupgrade=$can_upgrade
		kn_can_upupgrade=$can_upgrade
		updial_account=`echo $band|awk -F '"dial_account":"' '{print $2}'|awk -F '[,}"]' '{print $1}'`
		dbus set kn_dial_upaccount=$updial_account
		kn_dial_upaccount=$updial_account
		#判断是否满足加速条件
		if [[ $can_upgrade -eq 1 ]]; then
			#echo "迅雷快鸟可以加速~~~愉快的开始加速吧~~"
			#获取加速详细信息
			old_upstream=`echo $band|awk -F '"bandwidth":' '{print $2}'|awk -F '"upstream":' '{print $2}'|awk -F '[,}]' '{print $1}'`
			max_upstream=`echo $band|awk -F '"max_bandwidth":' '{print $2}'|awk -F '"upstream":' '{print $2}'|awk -F '[,}]' '{print $1}'`
			up_state="上行可以加速"
			dbus set kn_old_upstream=$(expr $old_upstream / 1024)
			dbus set kn_max_upstream=$(expr $max_upstream / 1024)
			kn_old_upstream=$(expr $old_upstream / 1024)
			kn_max_upstream=$(expr $max_upstream / 1024)
		else
			up_state="上行不满足加速条件"
			#echo "T_T 不能加速啊，不满足加速条件哦~~"
		fi
		dbus set kn_up_state=$up_state
	fi
}


#检测试用加速信息
query_try_info(){
	info=`$HTTP_REQ "$api_url/query_try_info?peerid=$peerid&userid=$uid&user_type=1&sessionid=$session"`
	echo $info
}
##{"errno":0,"message":"","number_of_try":0,"richmessage":"","sequence":0,"timestamp":1455936922,"try_duration":10}

query_try_upinfo(){
	info=`$HTTP_REQ "$upapi_url/query_try_info?peerid=$peerid&userid=$uid&client_type=android-uplink-2.3.3.9&client_version=andrioduplink-2.3.3.9&os=android-7.0.24DUK-AL20&sessionid=$session"`
	echo $info
}
##{"errno":0,"exp_day_len":0,"is_exp_day":0,"message":"","number_of_try":1,"richmessage":"","sequence":268435461,"timestamp":1493469390,"try_duration":10}

get_upgrade_down(){
	_ts=`date +%s`000
	ret=`$HTTP_REQ "$api_url/upgrade?peerid=$peerid&userid=$uid&user_type=1&sessionid=$kn_config_session&dial_account=$dial_account&client_type=android-swjsq-$app_version&client_version=androidswjsq-$app_version&os=android-5.0.1.24SmallRice&time_and=$_ts"`
	errcode=`echo $ret|awk -F '"errno":' '{print $2}'|awk -F '[,}"]' '{print $1}'`
	if [ "$errcode" == "0" ];then
		dbus set kn_down_start_time=`date +%s`
		down_state="$down_state （您的下行带宽已从$kn_old_downstream Mb提升到$kn_max_downstream Mb） 第一次运行成功"
	else
		down_state="$down_state 下行带宽提升失败，请检查宽带账号是否绑定正确"
	fi
	dbus set kn_down_state=$down_state
}

get_upgrade_up(){
	_ts=`date +%s`000
	up_ret=`$HTTP_REQ  --header "User-Agent:android-async-http/xl-acc-sdk/version-1.0.0.1" "$upapi_url/upgrade?peerid=$peerid&userid=$uid&client_type=android-uplink-2.3.3.9&client_version=andrioduplink-2.3.3.9&os=android-7.0.24DUK-AL20&sessionid=$session&user_type=1&dial_account=$updial_account"`
	errcode=`echo $up_ret|awk -F '"errno":' '{print $2}'|awk -F '[,}"]' '{print $1}'`
	if [ "$errcode" == "0" ] || [ "$errcode" == "812" ];then
		dbus set kn_up_start_time=`date +%s`
		up_state="$up_state （您的上行带宽已从$kn_old_upstream Mb提升到$kn_max_upstream Mb）第一次运行成功"
	else
		up_state="$up_state 上行带宽提升失败，请检查宽带账号是否绑定正确"
	fi
	dbus set kn_up_state=$up_state
}

keepalive_up(){
	_ts=`date +%s`000
	up_ret=`$HTTP_REQ  --header "User-Agent:android-async-http/xl-acc-sdk/version-1.0.0.1" "$upapi_url/keepalive?peerid=$peerid&userid=$uid&client_type=android-uplink-2.3.3.9&client_version=andrioduplink-2.3.3.9&os=android-7.0.24DUK-AL20&sessionid=$session&user_type=1&dial_account=$kn_dial_upaccount"`
	errcode=`echo $up_ret|awk -F '"errno":' '{print $2}'|awk -F '[,}"]' '{print $1}'`
	if [ "$errcode" != "0" ];then
		#dbus set kuainiao_run_upid=0
		#dbus set kuainiao_up_state="迅雷上行提速失效！$(date '+%Y-%m-%d %H:%M:%S')"
		dbus set kn_run_upstatus=0
	else
		#dbus set kuainiao_run_upid=$(expr $kuainiao_run_upid + 1)
		dbus set kn_up_state="您的上行带宽已从${kn_old_upstream}Mbit提升到${kn_max_upstream}Mbit  $(date '+%Y-%m-%d %H:%M:%S')"
		dbus set kn_run_upstatus=1
	fi
}


#检测提速带宽
bandwidth(){
	_ts=`date +%s`000
	width=`$HTTP_REQ "$api_url/bandwidth?peerid=$peerid&userid=$uid&user_type=1&sessionid=$session&dial_account=$dial_account&client_type=android-swjsq-$app_version&client_version=androidswjsq-$app_version&os=android-5.0.1.24SmallRice&time_and=$_ts"`
	echo $width
}
##{"bandwidth":{"downstream":51200,"upstream":0},"can_upgrade":1,"dial_account":"100001318645","errno":0,"max_bandwidth":{"downstream":102400,"upstream":0},"message":"","province":"bei_jing","province_name":"北京","richmessage":"","sequence":0,"sp":"cnc","sp_name":"联通","timestamp":1455936922}

upbandwidth(){
	_ts=`date +%s`000
	width=`$HTTP_REQ "$upapi_url/bandwidth?peerid=$peerid&userid=$uid&user_type=1&sessionid=$session&dial_account=$dial_account&client_type=android-swjsq-$app_version&client_version=androidswjsq-$app_version&os=android-5.0.1.24SmallRice&time_and=$_ts"`
	echo $width
}


#迅雷快鸟加速心跳
keepalive_down(){
	_ts=`date +%s`000
	ret=`$HTTP_REQ "$api_url/keepalive?peerid=$peerid&userid=$uid&user_type=1&sessionid=$session&dial_account=$dial_account&client_type=android-swjsq-$app_version&client_version=androidswjsq-$app_version&os=android-5.0.1.24SmallRice&time_and=$_ts"`
	errcode=`echo $ret|awk -F '"errno":' '{print $2}'|awk -F '[,}"]' '{print $1}'`
	if [ "$errcode" != "0" ];then
		#dbus set kuainiao_run_upid=0
		#dbus set kuainiao_down_state="迅雷下行提速失效！"$(date "+%Y-%m-%d %H:%M:%S")
		dbus set kn_run_status=0
	else
		#dbus set kuainiao_run_upid=$(expr $kuainiao_run_upid + 1)
		dbus set kn_down_state="您的下行带宽已从${kn_old_downstream}M提升到${kn_max_downstream}M $(date '+%Y-%m-%d %H:%M:%S')"
		dbus set kn_run_status=1
	fi
}

#快鸟加速注销
kuainiao_recover(){
	_ts=`date +%s`000
	recover=`$HTTP_REQ "$api_url/recover?peerid=$peerid&userid=$uid&user_type=1&sessionid=$session&dial_account=$dial_account&client_type=android-swjsq-$app_version&client_version=androidswjsq-$app_version&os=android-5.0.1.24SmallRice&time_and=$_ts"`
	echo $recover
}

kuainiao_uprecover(){
	_ts=`date +%s`000
	recover=`$HTTP_REQ "$upapi_url/recover?peerid=$peerid&userid=$uid&client_type=android-uplink-2.3.3.9&client_version=andrioduplink-2.3.3.9&os=android-7.0.24DUK-AL20&sessionid=$session&user_type=1&dial_account=$updial_account"`
	echo $recover
}


#将执行脚本写入crontab定时运行
add_kuainiao_cru(){
	cru d kn
	if [ "$kn_can_upgrade" == "1" ]||[ "$kn_can_upupgrade" == "1" ];then
		cru a kn "*/4 * * * * /bin/sh $KSROOT/scripts/kn_keep.sh"
	fi
}

#加入开机自动运行
auto_start(){
	if [ -L "$KSROOT/init.d/S95Kn.sh" ]; then 
		rm -rf $KSROOT/init.d/S95Kn.sh
	fi
	if [ "$kn_start" == "1" ]; then
		ln -sf $KSROOT/scripts/kn_keep.sh $KSROOT/init.d/S95Kn.sh
	fi
}

#停止快鸟服务
stop_kuainiao(){
	#停掉cru里的任务
	cru d kn
	#停止自启动
	if [ -L "$KSROOT/init.d/S95Kn.sh" ]; then 
		rm -rf $KSROOT/init.d/S95Kn.sh
	fi
	#清理运行环境临时变量
	dbus remove kn_run_id
	dbus remove kn_run_upid
	dbus remove kn_run_status
	dbus remove kn_run_upstatus
	dbus remove kn_config_session
	dbus remove kn_can_upgrade
	dbus remove kn_can_upupgrade
	dbus remove kn_down_state
	dbus remove kn_up_state
	dbus remove kn_down_start_time
	dbus remove kn_up_start_time
	dbus set kn_last_act="<font color=white>服务未开启</font>"
}

##主逻辑
#执行初始化
kuainiao_init(){
	
	dbus set kn_last_act=""
	dbus set kn_can_upgrade=0
	dbus set kn_can_upupgrade=0
	dbus set kn_down_state=""
	dbus set kn_up_state=""
}

case $ACTION in
start)
	kuainiao_init
	if [ "$kn_enable" == "1" ] || [ "$kn_upenable" == "1" ]; then
	sleep $kn_time
	#登陆迅雷获取uid
	get_xunlei_uid
	#判断是否登陆成功
	if [ -n "$uid" ]; then
	  if [ "$kn_enable" == "1" ];then
		get_kuainiao_api
		get_bandwidth
		dbus set kn_config_downstream=$(expr $old_downstream / 1024)
		dbus set kn_config_max_downstream=$(expr $max_downstream / 1024)
		if [ "$kn_can_upgrade" == "1" ];then
			get_upgrade_down
			sleep 1
			#keepalive_down
		fi
	  fi
	  if [ "$kn_upenable" == "1" ];then
	  	get_kuainiao_upapi
		get_upbandwidth
		dbus set kn_config_upstream=$(expr $old_upstream / 1024)
		dbus set kn_config_max_upstream=$(expr $max_upstream / 1024)
		if [ $kn_can_upupgrade == 1 ];then
			get_upgrade_up
			sleep 1
			#keepalive_up
		fi
	  fi
	fi
	add_kuainiao_cru
	fi
	;;
stop)
	stop_kuainiao
	;;
*)
	kuainiao_init
	if [ "$kn_enable" == "1" ] || [ "$kn_upenable" == "1" ]; then
	sleep $kn_time
	#登陆迅雷获取uid
	get_xunlei_uid
	#判断是否登陆成功
	if [ -n "$uid" ]; then
	  if [ "$kn_enable" == "1" ];then
		get_kuainiao_api
		get_bandwidth
		dbus set kn_config_downstream=$(expr $old_downstream / 1024)
		dbus set kn_config_max_downstream=$(expr $max_downstream / 1024)
		if [ "$kn_can_upgrade" == "1" ];then
			get_upgrade_down
			sleep 1
			keepalive_down
		fi
	  fi
	  if [ "$kn_upenable" == "1" ];then
	  	get_kuainiao_upapi
		get_upbandwidth
		dbus set kn_config_upstream=$(expr $old_upstream / 1024)
		dbus set kn_config_max_upstream=$(expr $max_upstream / 1024)
		if [ $kn_can_upupgrade == 1 ];then
			get_upgrade_up
			sleep 1
			keepalive_up
		fi
	  fi
	fi
	add_kuainiao_cru
	auto_start
	else
		stop_kuainiao
	fi
	;;
esac
