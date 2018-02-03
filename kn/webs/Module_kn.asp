<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>快鸟加速 By 梅林</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<script type="text/javascript" src="/js/jquery.js"></script>
<script src="/state.js"></script>
<script src="/help.js"></script>
<script type="text/javascript" src="/res/rsa.js"></script>
	<script type="text/javascript" src="/res/md5.js"></script>
	<script type="text/javascript" src="/res/sha1.js"></script>
</head>
<body>
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<table class="content" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td width="17">&nbsp;</td>
        <td valign="top" width="202">
            <div id="mainMenu"></div>
            <div id="subMenu"></div>
        </td>
        <td valign="top">
            <div id="tabMenu" class="submenuBlock"></div>
			<!--=====Beginning of Main Content=====-->
            <table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" style="display: block;">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
                						<div style="float:left;" class="formfonttitle" style="padding-top: 12px">Kuainiao By Meilin-二次修改版</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="back" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>
										<div class="SimpleNote" id="head_illustrate"><i></i><em>快鸟</em>二次修改版，带上行 下行加速<a href='http://koolshare.cn/forum.php?mod=viewthread&tid=102574' target='_blank'><i>&nbsp;&nbsp;<u>论坛地址</u></i></a></div>
										<div class="SimpleNote" id="head_illustrate">因为某些原因，请在修改了WAN口的物理地址之后重新安装本插件!</div>
                						<table style="margin:20px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">快鸟二次修改版-设置</td>
											</tr>
											</thead>
											<tr id="switch_tr">
												<th>
													<label>开启下行加速</label>
												</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell">
														<label for="switch">
															<input id="kn_enable" name="kn_enable" class="switch" type="checkbox">
															
														</label>
													</div>
													<div id="koolproxy_install_show" style="padding-top:5px;margin-left:80px;margin-top:-30px;float: left;"></div>	
												</td>
											</tr>
											<tr id="switch_tr">
												<th>
													<label>开启上行加速</label>
												</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell">
														<label for="upswitch">
															<input id="kn_upenable" name="kn_upenable" class="upswitch" type="checkbox">
															
														</label>
													</div>
													<div id="koolproxy_install_show" style="padding-top:5px;margin-left:80px;margin-top:-30px;float: left;"></div>	
												</td>
											</tr>
                						    <tr id="last_act_tr">
                						        <th>运行状态</th>
                						        <td>
                						            <% dbus_get_def("kn_last_act", "--"); %>
                						        </td>
                						    </tr>
                						    <tr id="ak_tr">
                						        <th>迅雷用户名</th>
                						        <td>
                						            <input type="text" id="kn_config_uname" value="<% dbus_get_def("kn_config_uname", ""); %>" class="input_ss_table">
                						        </td>
                						    </tr>
                						    <tr id="sk_tr">
                						        <th>迅雷密码</th>
                						        <td><input type="password" id="kn_config_old_pwd" value="<% dbus_get_def("kn_config_old_pwd", ""); %>" class="input_ss_table"></td>
                						    </tr>
                						    <tr id="last_act_tr">
                						        <th>下行提速状态</th>
                						        <td>
                						            <% dbus_get_def("kn_down_state", "--"); %>
                						        </td>
                						    </tr>
											<tr id="last_act_tr">
                						        <th>上行提速状态</th>
                						        <td>
                						            <% dbus_get_def("kn_up_state", "--"); %>
                						        </td>
                						    </tr>
											<tr id="switch_tr">
												<th>
													<label>开机自启</label>
												</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell">
														<label for="autoswitch">
															<input id="kn_start" class="autoswitch" type="checkbox">
															
														</label>
													</div>
													<div id="koolproxy_install_show" style="padding-top:5px;margin-left:80px;margin-top:-30px;float: left;"></div>	
												</td>
											</tr>
											<tr id="ak_tr">
                						        <th>自启延时</th>
                						        <td>
                						            <input type="text" id="kn_time" name="kn_time" value="<% dbus_get_def("kn_time", "3"); %>" >&nbsp&nbsp秒
                						        </td>
                						    </tr>
											<tr id="ak_tr">
                						        <th>WAN口选择</th>
                						        <td>
													<select id="kn_config_wan" name="kn_config_wan">
														<option value="1">WAN1</option>
														<option value="2">WAN2</option>
													</select>
                						        </td>
                						    </tr>
                						</table>
                						<div class="apply_gen">
                						    <input class="button_gen" type="button" value="保存">
                						</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"/></div>
										<div class="KoolshareBottom" style="margin-top:540px;">
											论坛支持 <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
											Github <a href="https://github.com/koolshare/koolshare.github.io/tree/acelan_softcenter_ui" target="_blank"> <i><u>github.com/koolshare</u></i> </a> <br/>
											Shell by <i>kyrios</i> , Web by<i>kyrios</i>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
			<!--=====end of Main Content=====-->
        </td>
    </tr>
</table>
<div id="footer"></div>
<script>
$(function () {
function myrefresh() 
{ 
window.location.reload(); 
} 
setTimeout('myrefresh()',240000); //指定4分钟刷新一次 
var wan_mac = '<% dbus_get_def("kn_wanhwaddr", "--"); %>';
		//var wan_mac = '00:0C:29:21:24:78';
		var fake_device_id = md5(wan_mac);
		var device_sign = "div100."+fake_device_id+md5(hex_sha1(fake_device_id+"com.xunlei.vip.swjsq68700d1872b772946a6940e4b51827e8af"));

		var kn = '00AC69F5CCC8BDE47CD3D371603748378C9CFAD2938A6B021E0E191013975AD683F5CBF9ADE8BD7D46B4D2EC2D78AF146F1DD2D50DC51446BB8880B8CE88D476694DFC60594393BEEFAA16F5DBCEBE22F89D640F5336E42F587DC4AFEDEFEAC36CF007009CCCE5C1ACB4FF06FBA69802A8085C2C54BADD0597FC83E6870F1E36FD';
		var ke = '010001';

		var rsa = new RSAKey();

		rsa.setPublic(kn, ke);
		
		
    show_menu(menu_hook);
 
	var kuainiao_enable = "<% dbus_get_def("kn_enable", "0"); %>";
	var kuainiao_upenable = "<% dbus_get_def("kn_upenable", "0"); %>";
	var kuainiao_start = "<% dbus_get_def("kn_start", "0"); %>";
    $('#kn_enable').prop('checked', kuainiao_enable === "1");
	$('#kn_upenable').prop('checked', kuainiao_upenable === "1");
  $('#kn_start').prop('checked', kuainiao_start === "1");
  
  var kuainiao_config_wan="<% dbus_get_def("kn_config_wan", "1"); %>";
  $("#kn_config_wan").val(kuainiao_config_wan);
  
    var posting = false;
	var inputs = ['enable','upenable','config_uname', 'config_old_pwd', 'start', 'time','config_wan'];
    $('.button_gen').click(function () {
        if(posting) return;
        posting = true; // save
		var data = {
			kuainiao_enable: $('#switch').prop('checked') | 0,
			action_mode: ' Refresh ',
			current_page: 'Module_kn.asp',
			next_page: 'Module_kn.asp',
			SystemCmd: 'kn_config.sh'
		};
		for(var i = 0; i< inputs.length; i++) {
			var key = 'kn' + inputs[i];
			data['kn_' + inputs[i]] = $('#kn_' + inputs[i]).val()
		}
		
		var encrypted_pwd = rsa.encrypt(md5(data['kn_config_old_pwd']));
		data['kn_config_pwd']=encrypted_pwd.toUpperCase();
		
		data['kn_enable']=$('#kn_enable').prop('checked')===true?1:0;
		data['kn_upenable']=$('#kn_upenable').prop('checked')===true?1:0;
		data['kn_start']=$('#kn_start').prop('checked')===true?1:0;
		
		data['kn_device_sign']=device_sign;
		
        $.ajax({
            type: 'POST',
            url: 'applydb.cgi?p=kn_',
            data: $.param(data)
        }).then(function () {
            posting = false;
            alert('提交成功！5秒后刷新');
        }, function () {
            posting = false;
           alert('提交错误！'); 
        })
		setTimeout("reload()",5500)
		
    })
})

var enable_ss = "<% nvram_get("enable_ss"); %>";
var enable_soft = "<% nvram_get("enable_soft"); %>";
function menu_hook(title, tab) {
	if(enable_ss == "1" && enable_soft == "1"){
		tabtitle[17] = new Array("", "kuainiao");
		tablink[17] = new Array("", "Module_kuainiao.asp");
	}else{
		tabtitle[16] = new Array("", "kuainiao");
		tablink[16] = new Array("", "Module_kuainiao.asp");
	}
}
function reload(){
location.href = "/Module_kn.asp";
}
function reload_Soft_Center(){
	location.href = "/Main_Soft_center.asp";
}


</script>
</body>
</html>

