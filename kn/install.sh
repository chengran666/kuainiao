#!/bin/sh
export KSROOT=/koolshare

cp -r /tmp/kn/* $KSROOT/
chmod a+x $KSROOT/scripts/kn_*
mac=`nvram get wan_hwaddr`
dbus set kn_wanhwaddr=$mac
#这个地方这样写的原因是 asp页面里面的nvram get wan_hwaddr 一直为空...


dbus set softcenter_module_kn_install=1
dbus set softcenter_module_kn_version=20171222
dbus set softcenter_module_kn_description="快鸟带上行提速二次修改版 20171222"