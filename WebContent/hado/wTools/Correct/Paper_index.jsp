<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. ������Ʈ�� : ������������ȸ �ϵ��ްŷ� �������ǽ�������					                       */
/*  2. ��ü���� :																					   */
/*     - ��ü�� : (��)��Ƽ������																	   */
/*	   - Project Manamger : ������ ���� (pcxman99@naver.com)										   */
/*     - ����ó : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  3. ���� : 2009�� 5��																			   */
/*  4. �����ۼ��� �� ���� : (��)��Ƽ������ ������ / 2011-10-18										   */
/*  5. ������Ʈ���� (���� / ����)																	   */
/*  6. ���																							   */
/*		1) �������� ������ / 2011-10-18																   */
/*-----------------------------------------------------------------------------------------------------*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/
	
	// �������������߰� // 20100503 / ������
	ArrayList arrDamCenter = new ArrayList();
	ArrayList arrCVSNo = new ArrayList();
	ArrayList arrCenterCode = new ArrayList();
	ArrayList arrCenterName = new ArrayList();
	ArrayList arrDeptName = new ArrayList();
	ArrayList arrUserName = new ArrayList();

	// ���� �����迭
	ArrayList arrProdCode = new ArrayList();
	ArrayList arrProdName = new ArrayList();
	// �Ǽ� �����迭
	ArrayList arrConstCode = new ArrayList();
	ArrayList arrConstName = new ArrayList();
	// �뿪 �����迭
	ArrayList arrSrvCode = new ArrayList();
	ArrayList arrSrvName = new ArrayList();

	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	int sStartYear = 2000;

	int i = 0;
	int gesu = 0;

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/

	int currentYear = st_Current_Year_n;
	
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		
		// ���� ���� �迭 ����
		StringBuffer sbSQLs1 = new StringBuffer();

		sbSQLs1.append("SELECT COMMON_CD, COMMON_NM \n");
		sbSQLs1.append("FROM COMMON_CD \n");
		sbSQLs1.append("WHERE ADDON_GB=?");
		if(currentYear>=2012) {
			sbSQLs1.append("AND COMMON_GB='010'");
		}
		
		pstmt = conn.prepareStatement(sbSQLs1.toString());
		pstmt.setString(1,"1");
		rs = pstmt.executeQuery();

		while (rs.next()) {
			arrProdCode.add(StringUtil.checkNull(rs.getString("COMMON_CD")).trim());
			arrProdName.add(new String( StringUtil.checkNull(rs.getString("COMMON_NM")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
		}
		rs.close();


		// �Ǽ� ���� �迭 ����
		pstmt = conn.prepareStatement(sbSQLs1.toString());
		pstmt.setString(1,"2");
		rs = pstmt.executeQuery(); 
	
		while (rs.next()) {
			arrConstCode.add(StringUtil.checkNull(rs.getString("COMMON_CD")).trim());
			arrConstName.add(new String( StringUtil.checkNull(rs.getString("COMMON_NM")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
		}
		rs.close();

		// �뿪 ���� �迭 ����
		pstmt = conn.prepareStatement(sbSQLs1.toString());
		pstmt.setString(1,"3");
		rs = pstmt.executeQuery();	  

		while (rs.next()) {
			arrSrvCode.add(StringUtil.checkNull(rs.getString("COMMON_CD")).trim());
			arrSrvName.add(new String(StringUtil.checkNull(rs.getString("COMMON_NM")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
		}
		rs.close();


		// 2010�� ����� ���� ��� ���� (HADO_TB_DEPT_HISTORY)
		StringBuffer sbSQLs2 = new StringBuffer();
		if( st_Current_Year_n>= 2010) {
			sbSQLs2.append("SELECT CVSNO, SUBSTR(Mng_No, 1, 1) Center_Code, Center_Name, Dept_Name, User_Name \n");
			sbSQLs2.append("FROM HADO_VT_DEPT_HISTORY \n");
			sbSQLs2.append("WHERE Current_Year=? \n");
			sbSQLs2.append("GROUP BY CVSNO, SUBSTR(Mng_No, 1, 1), Center_Name, Dept_Name, User_Name \n");
			sbSQLs2.append("ORDER BY SUBSTR(Mng_No, 1, 1), Center_Name, Dept_Name, User_Name \n");
		} 

		pstmt = conn.prepareStatement(sbSQLs2.toString());
		pstmt.setString(1,st_Current_Year);
		rs = pstmt.executeQuery();

		while(rs.next()) {
			arrCVSNo.add(StringUtil.checkNull(rs.getString("CVSNO")).trim());
			arrCenterCode.add(StringUtil.checkNull(rs.getString("Center_Code")).trim());
			arrCenterName.add(new String( StringUtil.checkNull(rs.getString("Center_NAME")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			arrDeptName.add(new String( StringUtil.checkNull(rs.getString("Dept_NAME")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			arrUserName.add(new String( StringUtil.checkNull(rs.getString("User_NAME")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
		}
		rs.close();
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if(rs!=null)		try{rs.close();}	catch(Exception e){}
		if(pstmt!=null)		try{pstmt.close();}	catch(Exception e){}
		if(conn!=null)		try{conn.close();}	catch(Exception e){}
		if(resource!=null)	resource.release();
	}
/*=====================================================================================================*/
%>
<html>
<head>
	<title>���������ϵ��ްŷ� �����������</title>
	<link rel="stylesheet" href="/hado/hado/wTools/style.css" type="text/css">
</head>
<script language="javascript" type="text/javascript" src="/hado/hado/wTools/inc/ajax_layer.js"></script>
<script language="javascript" type="text/javascript" src="/hado/hado/wTools/inc/common_script.js"></script>
<script language="JavaScript">
	nNowProcess = 0;

	function setNowProcessFalse() {
		nNowProcess = 0;
		bodyview();
	}

	var dcd=new Array();
	var dnm=new Array();
	<%
	for(i=0; i<arrProdCode.size(); i++) {
		out.print("dcd["+i+"]='"+arrProdCode.get(i)+"';");
		out.print("dnm["+i+"]='"+arrProdName.get(i)+"';");
	}
	%>	
	var ccd=new Array();
	var cnm=new Array();
	<%
	for(i=0; i<arrConstCode.size(); i++) {
		out.print("ccd["+i+"]='"+arrConstCode.get(i)+"';");
		out.print("cnm["+i+"]='"+arrConstName.get(i)+"';");
	}
	%>	

	var srvcd=new Array();
	var srvnm=new Array();
	<%
	for(i=0; i<arrSrvCode.size(); i++) {
		out.print("srvcd["+i+"]='"+arrSrvCode.get(i)+"';");
		out.print("srvnm["+i+"]='"+arrSrvName.get(i)+"';");
	}
	%>	

	var aCVSNo=new Array();
	var aCenterCode=new Array();
	var aCenterName=new Array();
	var aDeptName=new Array();
	var aUserName=new Array();
	<%
	for(i=0; i<arrCVSNo.size(); i++) {
		out.print("aCVSNo["+i+"]='"+arrCVSNo.get(i)+"';");
		out.print("aCenterCode["+i+"]='"+arrCenterCode.get(i)+"';");
		out.print("aCenterName["+i+"]='"+arrCenterName.get(i)+"';");
		out.print("aDeptName["+i+"]='"+arrDeptName.get(i)+"';");
		out.print("aUserName["+i+"]='"+arrUserName.get(i)+"';");
	}
	%>

	function deptsel() {
		var obj1 = document.getElementById("mareacode");
		var obj2 = document.getElementById("mdeptname");

		initsel2();

		chval = obj1.options[obj1.selectedIndex].value;
		obj2.add(new Option("��ü","",true,true));

		for(i=0; i<aCVSNo.length; i++) {
			if( aCenterCode[i]==chval )
				obj2.add(new Option(aUserName[i],aCVSNo[i],false,false));
		}
		
		obj2.reInitializeSelectBox();
	}

	function initsel2() {
		var obj = document.getElementById("mdeptname");
		for(i=0; i<100; i++) obj.options[0]=null;
	}
			
	function gbsel() {
		var obj1 = document.getElementById("wgb");
		var obj2 = document.getElementById("sgb");

		initsel();

		switch(obj1.selectedIndex) {
			case 1:
				obj2.add(new Option("��ü","",true,true));
				for(i=0; i<dcd.length; i++) {
					obj2.add(new Option(dnm[i],dcd[i],false,false));
				}
				break;
			case 2:
				obj2.add(new Option("��ü","",true,true));
				for(i=0; i<ccd.length; i++) {
					obj2.add(new Option(cnm[i],ccd[i],false,false));
				}
				break;
			case 3:
				obj2.add(new Option("��ü","",true,true));
				for(i=0; i<srvcd.length; i++) {
					obj2.add(new Option(srvnm[i],srvcd[i],false,false));
				}
				break;
		}

		obj2.reInitializeSelectBox();
	}

	function initsel() {
		var obj = document.getElementById("sgb");

		for(i=0; i<100; i++) obj.options[0]=null;
	}

	function goSearch() {
		var frm = document.searchform;
		msg = "";

		if(nNowProcess == 0) {
			frm.target="procFrame";
			frm.action="/hado/hado/wTools/Correct/Paper_List.jsp?comm=search&page=1";
			frm.submit();
			nNowProcess = 1;
			bodyhidden();
		} else {
			alert("���� ���μ����� �������Դϴ�.\n\n��� �� �ٽ� ������ �ּ���.");
		}
	}

	function pmove(val) {
		if(val!="") {
			var frm = document.searchform;

			frm.target="procFrame";
			frm.action=val;
			frm.submit();
			nNowProcess = 1;
			bodyhidden();
		}
	}

	function entsub(event,form)  {
		if (window.event && window.event.keyCode == 13)
		{
			goSearch();
		}
	}
	
	
	function HelpWindow2(url, w, h) {
		helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
		helpwindow.focus();
	}

	var sSearchWin = "0";
	function divSearchWin() {
		obj = document.getElementById("searchbox");
		wobj = document.getElementById("divSrchWindow");
		
		if( sSearchWin =="0" ) {
			obj.style.display = 'none';
			wobj.innerHTML = "<a href='javascript:divSearchWin();' class='sbutton'>�˻�â ��ġ��</a>";
			sSearchWin = "1";
		} else {
			obj.style.display = '';
			wobj.innerHTML = "<a href='javascript:divSearchWin();' class='sbutton'>�˻�â ������</a>";
			sSearchWin = "0";
		}
	}

	function view(mno,cyear,ogb) {
		var lyView=document.getElementById("divView");
		
		if(nNowProcess == 0) {
			document.procFrame.location.replace("Paper_Input.jsp?comm=view&mngno="+mno+"&cyear="+cyear+"&ogb="+ogb);
			nNowProcess = 1;
			bodyhidden();
			lyView.style.top=Math.round(getVerticalScroll())+"px";
			lyView.style.display="block";
		} else {
			alert("���� ���μ����� �������Դϴ�.\n\n��� �� �ٽ� ������ �ּ���.");
		}
	}


	function calcu(gesu) {
		var tot=0;
		var temp=0;
		var obj=null;
		for(i=1;i<=gesu;i++)
		{
			obj=document.getElementById("smoney"+i);
			temp = eval("Number(clearstring(obj.value))");
			if (temp==null) temp=0;
			tot += temp;
		}

		obj=document.getElementById("smoneytot");
		if(formatmoney(tot)==null)
			obj.value="0 ";
		else
			obj.value=formatmoney(tot+"");
	}

	function CtxCal() {
		var obj1=document.getElementById("ctxmoney1");
		var obj2=document.getElementById("ctxmoney2");
		var obj3=document.getElementById("smoneytot");

		if(Number(clearstring(obj3.value))<Number(clearstring(obj1.value)))
		{
			alert("�����ݾ��� ���ݱݾ׺��� Ů�ϴ�.. Ȯ���� �ֽñ� �ٶ��ϴ�.")
			obj1.value=obj3.value;
			obj2.value=0;
		}
		else
		{
			obj2.value=formatmoney((Number(clearstring(obj3.value))-Number(clearstring(obj1.value)))+"");
		}
		
	}	

	function formatmoney(m) {
		var money, pmoney, mlength, z, textsize, i
		textsize=20
		pmoney=""
		z=0
		money=m
		money=clearstring(money)
		money=Number(money)
		money=money+""
		for(i=money.length-1;i>=0;i--)
		{
			z=z+1
			if(z%3==0) 
			{
				pmoney=money.substr(i,1)+pmoney
				if(i!=0)	pmoney=","+pmoney
			}
			else pmoney=money.substr(i,1)+pmoney
		}
		return pmoney
	}

	function clearstring(s) {
		var pstr, sstr, iz
		sstr=s
		pstr=""
		for(iz=0;iz<sstr.length;iz++)
		{
			if(!isNaN(sstr.substr(iz,1))||sstr.substr(iz,1)==".") pstr=pstr+sstr.substr(iz,1)
		}
		return pstr
	}

	function conf() {
		var obj1=null;
		var obj2=null;

		obj1=document.getElementById("sctx").form.sctx;
		obj2=document.getElementById("h_sctx");
		for(i=0; i<12; i++) {
			if(obj1[i].checked==true) {
				obj2.value=obj1[i].value;
				break;
			}
		}
		obj1=document.getElementById("ctxsu2");
		obj2=document.getElementById("h_ctxsu2");
		obj2.value=obj1.value;
				
		nNowProcess = 1;
		bodyhidden();

		main=obj2.form;
		main.target="procFrame";
		main.action="Paper_Query.jsp?cmd=surveyinput";
		main.submit();

	}

	function goDelete() {
		var obj=null;
		obj=document.getElementById("h_sctx");

		main=obj.form;
		main.target="procFrame";
		main.action="Paper_Query.jsp?cmd=surveyDelete";
		main.submit();
	}
		
	function SendMoney() {
		var obj1=document.getElementById("ctxmoney1");
		var obj2=document.getElementById("smoneytot");

		obj1.value = obj2.value;
	}
</script>

<SCRIPT LANGUAGE=javascript>
// ũ����� Ŀ�� ��ũ��Ʈ..

var SU_COMMA = ',';

// ���ڿ� ġȯ
function kreplace(str,str1,str2) {
	
	if (str == "" || str == null) return str;

	while (str.indexOf(str1) != -1) {
		str = str.replace(str1,str2);
	}
	return str;
//	if (isNaN(str)) return str;
//
//	if (isFloat(str))
//		return parseFloat(str);
//	else
//		return parseInt(str);
}

// �Ǽ������� Ȯ���Ѵ�.
function isFloat(str) {
	return (str.indexOf('.') != -1);
}

// ���ڿ� �ĸ��� �����Ѵ�.
function suwithcomma(su) {
	
	su = kreplace(su,',','');
	
	var rtn = '';
	var fd = false;
	// �Էµ� ���� �˻��Ͽ� ���ڰ� �ƴ� ��� 0�� �����ش�.
	// ������ ��쿡�� ���ڿ��� �ٲ۴�.
	if (isNaN(su)) {
		alert("���ڸ� �Է��ϼž� �մϴ�.");
		return 0;
	} else {
		su = new String(su);
	}
	
	n = su.indexOf('.');
	if (n<0) {
		n = parseInt(su.length);
	} else {
		fd = true;
	}
	
	while (su.indexOf('0') == 0 ) {
		if (!fd) {
			su = su.substring(1,su.length);
		} else {
			if (n > 1) {
				su = su.substring(1, su.length);
				n --;
			} else {
				return su;
			}
		}
	}
	cnt = parseInt(n / 3);
//	alert(cnt);
	mod = parseInt(n % 3);
//	alert(mod);
	if (mod>0) {
		rtn = su.substring(0,mod);
		if (cnt > 0) rtn = rtn + SU_COMMA;
	}
	for (i = 0; i < cnt ; i++) {
		idx = i*3 + mod;
		if (idx == 0) {
			rtn = su.substring(idx,idx + 3);
			if (cnt > 1) rtn = rtn + SU_COMMA;
		} else {
			rtn = rtn + su.substring(idx,idx + 3);
			if (idx < n - 3) rtn = rtn + SU_COMMA;
		}
		
	}
	if (fd) rtn = rtn + su.substring(n,su.length);
	return rtn;
}

// ���ڰ�, "."������ üũ�Ѵ�.
function checkStringValid(src){
	var len = src.value.length;

	for(var i=0;i<len;i++){
		if ((!isDecimal(src.value.charAt(i)) || src.value.charAt(i)==" ") && src.value.charAt(i)!="." ){
			assortString(src,i);	
			i=0;
		}
	}

}

// ���ڸ� �����Ѵ�.
function assortString(source,index){
	var len = source.value.length;
	var temp1 = source.value.substring(0,index);
	var temp2 = source.value.substring(index+1,len);
	source.value = temp1 + temp2;
}

// 10�������� ������ �ִ��� Ȯ���Ѵ�.
function isDecimal(number){
	if (number>=0 && number<=9)  return true;
	else return false;
}

// �Ҽ����� �ΰ� �̻��ԷµǸ� ������ ���� �����Ѵ�.
function isPoint(src) {
	if ((p1 = src.value.indexOf('.')) != -1) {
		if ((p2 = src.value.indexOf('.',p1+1)) != -1) {
			src.value = src.value.substring(0,p2);
			return true;
		}
	}
	return false;
}

// Ű�ڵ带 �˻��ϰ� ��Ʈ���� ���� �ĸ��� �����Ѵ�.
function sukeyup(src) {

	if (sukeyup_n(src)) {
		src.value = suwithcomma(src.value);
		return true;
	}
	return false;
}
// �Է°��� �˻��Ѵ�.
function sukeyup_n(src) {

	keycode = window.event.keyCode;
	//alert(isArrowKey(keycode));
	if (isArrowKey(keycode) || keycode == 13 || isPoint(src)) {
		return false;
	}
	checkStringValid(src);

	if (src.value == '' || src.value == '0') {
		src.value = 0;
		return false;
	}

	if (src.value == '.' || src.value == '0.') {
		src.value = '0.';
		return false;
	}

	if(!isNaN(src.value)) {

		if (src.value.indexOf('.') == 1) return false;
		if (src.value.length <= 3) {
			if (src.value.indexOf('0') == 0) 
				src.value = src.value.substring(1,src.value.length);
			return false;
		}

	}
	return true;
}

// ���� Ű�� ȭ��ǥ������ Ȯ���Ѵ�.
function isArrowKey(key){
	if(key>=37 && key<=40) return true;
	else return false;
}

// ���� �ִ밪 ���� ū ��� �ִ밪�� �Է��Ѵ�.
// vmax : �ִ밪
function isMax(src,vmax) {
	
	var sv = src.value;
	var smax = suwithcomma(new String(vmax));
	sv = parseFloat(kreplace(sv,',',''));
	
	if (sv > vmax) {
		alert('�ִ밪(' + smax + ')���� ū ���� �Է� �Ǿ����ϴ�.');
		src.value = smax;
		return false;
	}
	return true;
}
//
//function suMax(src,vmax) {
//	isMax(src,vmax);
//	sukeyup(src);
//}
function suwithdec(src,dec) {
	sukeyup(src);
	wPoint(src,dec);
}

//
function isMonth(src) {

	onlyNumeric(src);
	v = parseInt(src.value);
	if ((v < 1) || (v > 12)) {
		alert("���� �Է� �ϼž� �մϴ�.");
		src.value = new Date().getMonth();
		return false;
	}
	return true;
	
}

// ���ڰ����� �Է¹޴´�.
function onlyNumeric(src){
	var len = src.value.length;

	for(var i=0;i<len;i++){
		if (!isDecimal(src.value.charAt(i)) || src.value.charAt(i)==" ") {
			assortString(src,i);	
			i=0;
		}
	}

}

// ������ �Ҽ��� ������ ���� ������.
function wPoint(src,dec) {
	if ((p = src.value.indexOf('.')) != -1) {
		if (src.value.length > p + dec + 1) {
			src.value = src.value.substring(0,p+dec+1);
		}
	}
}
</script>
<body>
	<div id="ajax_ready" style="position:absolute;top:1px;left:1px;width:60px;height:60px;display:none;z-index:99;"><img src="/hado/hado/wTools/img/ajax_ani.gif" border="0"></div>
	<div id="ajax_bg" style="position:absolute;top:1px;left:1px;display:none;background:url(/hado/hado/wTools/img/ajax_bg.gif);z-index:51;"></div>

	<div id="container">
		<!-- Begin Header -->
		<%@ include file="/hado/wTools/inc/WB_I_pageTop.jsp"%>
		<!-- End Header -->
		
		<!-- Begin Main-menu -->
		<jsp:include page="/hado/wTools/inc/WB_I_topMenu.jsp">
		<jsp:param value="04" name="sel"/>
		</jsp:include>
		<!-- End Main-menu -->

		<!-- Begin Contents -->
		<div id="wrapper">
			<div id="contents">
				<!-- Begin Left-menu -->
				<jsp:include page="/hado/wTools/inc/WB_I_Correct_LMenu.jsp">
				<jsp:param value="005" name="sel"/>
				</jsp:include>
				<!-- End Left-menu -->

				<div id="divContent">
					<div id="searchContent">
						<li class="subtitle">����̹߱� ����ü</li>
						<li class="whereiam">HOME > ������ġ > ������ġ ����ü > ����̹߱� ����ü</li>
						<p></p>
					</div>	
					<div class="searchbox" id="searchbox">
						<table class="searchboxtable">
						<form action="" method="post" name="searchform">
							<tr>
								<th>����⵵</th>
								<td><%
									if( ckPermision.equals("T") || ckPermision.equals("M") ) {%>
									<select name="cyear">
										<%for(int xx=2011; xx<=st_Current_Year_n; xx++) {
										String tmpCYear = ""+xx;%>
											<option value="<%=xx%>" <%if( xx==st_Current_Year_n ){%>selected<%}%>><%=xx%>��</option>
										<%}%>
									</select>
									<%} else {%>
									<select name="cyear">
										<%for(int xx=st_Current_Year_n-1; xx<=st_Current_Year_n; xx++) {
										String tmpCYear = ""+xx;%>
											<option value="<%=xx%>" <%if( xx==st_Current_Year_n ){%>selected<%}%>><%=xx%>��</option>
										<%}%>
									</select>
									<%}%>
								</td>
								<th>ȸ���</th>
								<td><input type="text" name="scomp" value="" size="25" onKeyPress="return entsub(event,this.form)" class="s_input"></td>
								<th>������ȣ</th>
								<td><input type="text" name="unitid" value="" size="10" onKeyPress="return entsub(event,this.form)" class="s_input"></td>
							</tr>
							<!--tr>	
								<th>���ξ���</th>
								<td colspan="3">
									<select name="sgb">
										<option value="">��ü</option>
									</select>
								</td>
							</tr-->
							<tr>
								<th>����</th>
								<td>
									<select name="wgb" onchange="gbsel();">
										<option value="">��ü</option>
										<option value="1">����</option>
										<option value="2">�Ǽ�</option>
										<option value="3">�뿪</option>
									</select>
								</td>
								<th>���繫��</th>
								<td>
									<select name="mareacode" id="mareacode" onchange="deptsel();">
										<option value="">��ü</option>
										<!--option value="H">���� ������±�</option-->
										<option value="C">����ŷ���å��</option>
										<option value="D">�����ϵ��ް�����</option>
										<option value="E">�Ǽ��뿪�ϵ��ް�����</option>
										<option value="S">����繫��</option>
										<option value="B">�λ�繫��</option>
										<option value="G">���ֻ繫��</option>
										<option value="J">�����繫��</option>
										<option value="K">�뱸�繫��</option>
									</select>
								</td>
								<th>����</th>
								<td>
									<select name="mdeptname" id="mdeptname">
										<option value="">��ü</option>
									</select>
								</td>
								
							</tr>
							<tr>
								<th>���Ĺ��</th>
								<td>
									<select name="ssort">
										<option value="">����</option>
										<option value="1">����ڸ�</option>
										<option value="4">������ȣ</option>
										<option value="5">����</option>
									</select>
								</td>
								<th>��¼�</th>
								<td>
									<select name="mpagesize">
										<option value="30">30���� ���</option>
										<option value="50">50���� ���</option>
										<option value="100">100���� ���</option>
									</select>
								</td>

								<th><font style="color:#FF9933;font-weight:bold;">�Է¿���</font></th>
								<td>
									<select name="insertf">
										<option value="">��ü</option>
										<option value="1">�Է�</option>
										<option value="0">���Է�</option>
									</select>
								</td>

							</tr>
							</form>
						</table>
					</div>
					<div id="divButton">
						<ul class="lt">
							<li class="fr" id="divSrchWindow"><a href="javascript:divSearchWin();" class="sbutton">�˻�â ������</a></li>
							<li class="fr"><a href="javascript:document.searchform.reset();" class="sbutton">�˻� �ʱ�ȭ</a></li>
							<li class="fr"><a href="javascript:goSearch();" class="sbutton">�� ��</a></li>
						</ul>
					</div>

					<div id="divResult"></div>
					<div id="divView" onMouseDown="f_DragMDown(this)"></div>
					<div id="divViewInfo1" onMouseDown="f_DragMDown(this)"></div>
					<div id="divViewInfo2" onMouseDown="f_DragMDown(this)"></div>
					<div id="divViewInfo3" onMouseDown="f_DragMDown(this)"></div>
				</div>
				<iframe src="about:blank" width="1" height="1" id="procFrame" name="procFrame" style="display:none;"></iframe>
			</div>
		</div>
		<!-- End Contents -->

		<!-- Begin Footer -->
		<%@ include file="/hado/wTools/inc/WB_I_Copyright.jsp"%>
		<!-- End Footer -->
	</div>
</body>
</html>