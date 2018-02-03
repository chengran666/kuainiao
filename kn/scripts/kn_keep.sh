#!/bin/sh

KSROOT="/koolshare"
source $KSROOT/scripts/base.sh
eval `dbus export kn`
#source ./kuainiao_config.sh
ex_time=`date "+%m-%d %H:%M:%S"`

keepalive_up(){
	up_ret=`$kn_HTTP_REQ  --header "User-Agent:android-async-http/xl-acc-sdk/version-1.0.0.1" "$kn_config_upapi/keepalive?peerid=$kn_config_peerid&userid=$kn_config_uid&client_type=android-uplink-2.3.3.9&client_version=andrioduplink-2.3.3.9&os=android-7.0.24DUK-AL20&sessionid=$kn_config_session&user_type=1&dial_account=$kn_dial_upaccount"`
	errcode=`echo $up_ret|awk -F '"errno":' '{print $2}'|awk -F '[,}"]' '{print $1}'`
	if [ "$errcode" != "0" ];then
		#dbus set kuainiao_run_upid=0
		dbus set kn_up_state="迅雷上行提速失效! $ex_time"
		dbus set kn_run_upstatus=0
	else
		#dbus set kuainiao_run_upid=$(expr $kuainiao_run_upid + 1)
		all_time=$(((`date +%s`-`dbus get kn_up_start_time`)/60))
		dbus set kn_up_state="您的上行带宽已从${kn_old_upstream}M提升到${kn_max_upstream}M $ex_time 自动续期成功<br>持续加速时间:${all_time}分钟"
		dbus set kn_run_upstatus=1
	fi
}

keepalive_down(){
	_ts=`date +%s`000
	ret=`$kn_HTTP_REQ "$kn_config_api/keepalive?peerid=$kn_config_peerid&userid=$kn_config_uid&user_type=1&sessionid=$kn_config_session&dial_account=$kn_dial_account&client_type=android-swjsq-$kn_app_version&client_version=androidswjsq-$kn_app_version&os=android-5.0.1.24SmallRice&time_and=$_ts"`
	errcode=`echo $ret|awk -F '"errno":' '{print $2}'|awk -F '[,}"]' '{print $1}'`
	if [ "$errcode" != "0" ];then
		#dbus set kuainiao_run_upid=0
		dbus set kn_down_state="迅雷下行提速失效！$ex_time"
		dbus set kn_run_status=0
	else
		#dbus set kuainiao_run_upid=$(expr $kuainiao_run_upid + 1)
		all_time=$(((`date +%s`-`dbus get kn_down_start_time`)/60))
		dbus set kn_down_state="您的下行带宽已从${kn_old_downstream}M提升到${kn_max_downstream}M $ex_time 自动续期成功<br>持续加速时间:${all_time}分钟"
		dbus set kn_run_status=1
	fi
}

add_kuainiao_cru(){
	cru_str=`cru l|grep kn`
	if [ -z "$cru_str" ];then
		cru a kn "*/4 * * * * /bin/sh $KSROOT/scripts/kn_keep.sh"
	fi
}

#echo $(date "+%Y-%m-%d %H:%M:%S") >>/koolshare/kn.text
if [ "$kn_enable" == "1" ]&&[ "$kn_can_upgrade" == "1" ];then
	keepalive_down
	add_kuainiao_cru
	if [ `dbus get kn_run_status` == 0 ];then
		/bin/sh /koolshare/scripts/kn_config.sh
  	fi
fi
if [ "$kn_upenable" == "1" ]&&[ "$kn_can_upupgrade" == "1" ];then
	keepalive_up
	add_kuainiao_cru
	if [ `dbus get kuainiao_run_upstatus` == 0 ];then
		/bin/sh /koolshare/scripts/kn_config.sh
  	fi
fi
