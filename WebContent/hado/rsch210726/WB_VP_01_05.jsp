<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_VP_01_05.jsp
* ���α׷�����	: ����ǥ ����
* ���α׷�����	: 3.0.1
* �����ۼ�����	: 2014�� 09�� 14��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-09-14	������       �����ۼ�
*  2015-05-29  ������       ������ڿ���� �ȵǴ� ��� ���� �� �ϵ��ްŷ���Ȳ �ۼ� ���ʿ� ���� (SP_FLD_02)
* 	2015-12-30	������		DB�������� ���� ���ڵ� ����
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<%@ include file="../Include/WB_Inc_chkSession.jsp"%>
<%
ConnectionResource resource = null;
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String sSQLs		= "";
/**
* �Է����� ���� ���� ���� �� �ʱ�ȭ ����
*/
String sOentSaNo = "";			// ������� ��Ϲ�ȣ
String sCompStatus	 = "";		// ȸ�翵������
//String sSubconType = "";		// �ϵ��ްŷ�����
String sIsNotOent = "";			// 2015-05-29 / ������ / ������ڿ�� �ȵ� ����
String f1	= "no";	// ȸ�簳��
String f2	= "no"; // ���������
String f3	= "no";	// ���޻���ڸ��
String f4	= "no"; // �ϵ��ްŷ���Ȳ
String fall	= "no"; // �������ܴ��

int subconTypeCnt = 0;

String stt = StringUtil.checkNull(request.getParameter("tt"));
String st = StringUtil.checkNull(request.getParameter("isEnded"));
String saveno = StringUtil.checkNull(request.getParameter("saveno"));

/* �׸�ǥ���� ���⵵ �׸� ǥ�� ����� ���� ����⵵ ������ ��ȯ */
int nCurrentYear = 0;
if( !ckCurrentYear.equals("") ) {
	nCurrentYear = Integer.parseInt(ckCurrentYear);
}
/**
* �Է����� ���� ���� ���� �� �ʱ�ȭ ��
*/

if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
	
	///////////////////////////////////////////////////////////////////2020�⵵ subconType ����ǥ�� �̵�
	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();

		sSQLs   = "SELECT count(*) fcnt \n";
		sSQLs+= "FROM hado_tb_oent_answer_" +ckCurrentYear+ " \n";
		sSQLs+= "WHERE mng_no = ? AND current_year = ? AND oent_gb = ? \n";
		sSQLs+= "AND oent_q_cd = 5 AND oent_q_gb = 1 AND c = 1 \n";
		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, ckMngNo);
		pstmt.setString(2, ckCurrentYear);
		pstmt.setString(3, ckOentGB);
		rs = pstmt.executeQuery();

		while (rs.next()) {
			subconTypeCnt	= rs.getInt("fcnt")==0 ? 0 : 1;
		}
		rs.close();

	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if ( rs != null )		try{rs.close();}	catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )		try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}
	//////////////////////////////////////////////////////////////

	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();

		sSQLs   = "SELECT * \n";
		sSQLs+= "FROM hado_tb_oent_" +ckCurrentYear+ " \n";
		sSQLs+= "WHERE mng_no = ? AND current_year = ? AND oent_gb = ? \n";
		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, ckMngNo);
		pstmt.setString(2, ckCurrentYear);
		pstmt.setString(3, ckOentGB);
		rs = pstmt.executeQuery();

		while (rs.next()) {
			sOentSaNo	= rs.getString("oent_sa_no")==null ? "": rs.getString("oent_sa_no");
			sCompStatus = rs.getString("comp_status")==null ? "": rs.getString("comp_status");
			//sSubconType	= rs.getString("subcon_type")==null ? "": rs.getString("subcon_type");
			sIsNotOent = rs.getString("sp_fld_02")==null ? "": rs.getString("sp_fld_02");	// 2015-05-29 / ������ / ������ڿ�� �ȵ� ����
		}
		rs.close();

	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if ( rs != null )		try{rs.close();}	catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )		try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}

	if ( (sCompStatus != null) && (!sCompStatus.equals("")) ) {
		f1 = "yes";
	} else {
		f1 = "no";
	}
	
	int gesu = 0;

	//if ( f1.equals("yes") && ( (!sCompStatus.equals("1")) || (sSubconType.equals("3")) || (sSubconType.equals("4")) ) ) {
	if ( f1.equals("yes") && !sCompStatus.equals("1") ) { // 2015-05-29 / ������ / ������ڿ�� �ȵ� ���� �߰�
		f2 = "yes";
		fall = "yes";
	} else {
		gesu = 0;

		//--- ����� ���� ���� �����Ƿ� ���� �������� ��� ��Ŵ
		f2 = "yes";
		//-----------------------------------------------------

		// �ϵ��ްŷ���Ȳ �Է¿��� Ȯ��
		gesu = 0;

		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();

			sSQLs  = "SELECT count(*) fcnt \n";
			sSQLs+="FROM HADO_TB_Oent_Answer_"+ckCurrentYear+" \n";
			sSQLs+= "WHERE mng_no = ? AND current_year = ? AND oent_gb = ? \n";
			pstmt = conn.prepareStatement(sSQLs);
			pstmt.setString(1, ckMngNo);
			pstmt.setString(2, ckCurrentYear);
			pstmt.setString(3, ckOentGB);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				gesu = rs.getInt("fcnt");
			}
			rs.close();
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			if ( rs != null )		try{rs.close();}	catch(Exception e){}
			if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
			if ( conn != null )		try{conn.close();}	catch(Exception e){}
			if ( resource != null ) resource.release();
		}

		if (gesu == 0) {
			f4 = "no";
		} else {
			f4 = "yes";
		}
	}


	if ( (!sCompStatus.equals("1")) || (!sIsNotOent.equals("")) ) { // 2015-05-29 / ������ / ������ڿ�� �ȵ� ���� �߰�
		f3 = "no";
	} else {
		gesu = 0;

		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();

			sSQLs  ="SELECT count(*) fcnt \n";
			sSQLs+="FROM HADO_TB_Subcon_"+ckCurrentYear+" \n";
			sSQLs+= "WHERE mng_no = ? AND current_year = ? AND oent_gb = ? \n";
			System.out.println("sSQLs>> "+sSQLs);
			pstmt = conn.prepareStatement(sSQLs);
			pstmt.setString(1, ckMngNo);
			pstmt.setString(2, ckCurrentYear);
			pstmt.setString(3, ckOentGB);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				gesu = rs.getInt("fcnt");
			}
			rs.close();
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			if ( rs != null )		try{rs.close();}	catch(Exception e){}
			if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
			if ( conn != null )		try{conn.close();}	catch(Exception e){}
			if ( resource != null ) resource.release();
		}


		if ( gesu == 0 ) {
			try {
				resource = new ConnectionResource();
				conn = resource.getConnection();

				sSQLs="SELECT count(*) fcnt FROM HADO_TB_Oent_Subcon_File \n";
				sSQLs+="WHERE (Mng_No='"+ckMngNo+"') \n";
				sSQLs+="AND (Current_Year='"+ckCurrentYear+"') \n";
				sSQLs+="AND (Oent_GB='"+ckOentGB+"') \n";
				System.out.println("sSQLs>> "+sSQLs);
				pstmt = conn.prepareStatement(sSQLs);
				rs = pstmt.executeQuery();
				
				while (rs.next()) {
					gesu = rs.getInt("fcnt");
				}
				rs.close();
			} catch(Exception e){
				e.printStackTrace();
			} finally {
				if ( rs != null )		try{rs.close();}	catch(Exception e){}
				if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
				if ( conn != null )		try{conn.close();}	catch(Exception e){}
				if ( resource != null ) resource.release();
			}

			if ( gesu == 0 ) {
				f3 = "no";
			} else {
				f3 = "yes";
			}
		} else {
			f3 = "yes";
		}
	}
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--[if lt IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie6"><![endif]-->
<!--[if IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie7"><![endif]-->
<!--[if IE 8]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie8"><![endif]-->
<!--[if (gt IE 8)|!(IE)]><!-->
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko-KR" class="no-js">
<!--<![endif]-->
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta http-equiv='Cache-Control' content='no-cache'>
    <meta http-equiv='Pragma' content='no-cache'>

    <title><%= nCurrentYear %>�⵵ �ϵ��ްŷ� ������� ����</title>
    
    <link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="euc-kr">
    <link href="style.css" rel="stylesheet" type="text/css" />

    <!-- // IE  // -->
	<!--[if IE]><script src="../js/html5.js"></script><![endif]-->
	<!--[if IE 7]>
	<script src="../js/ie7/IE7.js"  type="text/javascript"></script>
	<script src="../js/ie7/ie7-squish.js"  type="text/javascript"></script>
	<![endif]-->
    <script src="../js/jquery-1.7.min.js"></script>
    <script type="text/javascript">jQuery.noConflict();</script>
    <script src="../js/mootools-core-1.3.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/mootools-more-1.3.1.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/simplemodal.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/commonScript.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/login.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/credian_common_script.js" type="text/javascript"  charset="euc-kr"></script>
	<script language="javascript">
		function infoSubmit(){
			sTmp = "<%= ckMngNo%>";
			if(sTmp == "") {
				alert("�α��� �� �̿��Ͽ� �ֽʽÿ�.");
			} else {
				HelpWindow2("WB_Submit01.jsp", 600, 600);
			}
		}

		function goPrint() {
		/*url = "ProdStep_02_Print.jsp";
		w = 820;
		h = 600;
		HelpWindow2(url, w, h);*/
		print();
		}

		function infoSubmit2(){
			sTmp = "<%= ckMngNo%>";
			if(sTmp == "") {
				alert("�α��� �� �̿��Ͽ� �ֽʽÿ�.");
			} else {
				HelpWindow2("info_submit02.jsp", 600, 600)
			}
		}
		
		function HelpWindow2(url, w, h){
			helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
			helpwindow.focus();
		}
		
		function popup(furl, names, ws, hs, tps, lps){
			if((furl != "") && (names != "") && (tps != "") && (lps != "")) {
				scookie = GetCookie(names);
				if(scookie == "") {
					objPopupWindow = window.open(furl,names,"toolbar=no,width="+ws+",height="+hs+",directories=no,status=no,scrollbars=no,resize=no,menubar=no,location=no,top="+tps+",left="+lps);
					if(objPopupWindow == null) {	
						//alert("�˾�â�� ���ܵǾ� �ֽ��ϴ�.\n�˸�ǥ���ٿ��� �˾�â�� ����ϵ��� �����Ͻʽÿ�.")
					}
				}
			}		
			return 1;
		}

		var msg="";
		var sCompStatus = "<%=sCompStatus%>";
		<%-- var sSubconType = "<%=sSubconType%>"; --%>
		var subconTypeCnt = "<%=subconTypeCnt%>";
		var f1 = "<%=f1%>";
		var f2 = "<%=f2%>";
		var f3 = "<%=f3%>";
		var f4 = "<%=f4%>";

		<%if (f1.equals("no")) {%>msg+="\nȸ�簳�並 �Է����ֽʽÿ�.";<%}%>
		<%if ((!fall.equals("yes")) && f2.equals("no")) {%>msg+="\n���� �� ����� ��Ȳ�� �Է����ֽʽÿ�.";<%}%>
		<%if ((!fall.equals("yes")) && f3.equals("no") && subconTypeCnt == 0 ) {%>msg+="\n���޻���� ��θ� �Է����ֽʽÿ�.";<%}%>
		<%if ((!fall.equals("yes")) && f4.equals("no")) {%>msg+="\n�ϵ��ްŷ���Ȳ�� �Է����ֽʽÿ�.";<%}%>


		<%if ( st.equals("ok") ) {%>alert("������ �Ϸ�Ǿ����ϴ�..\n������ �����ּż� �����մϴ�.");<%}%>

		function savef(){
			var smsg = "";
			var main = document.info;

			if ( msg=="" ){
				if(confirm("[ ��ǥ�̻簡 �� ����ǥ ������ Ȯ������ ]\n\n����ǥ������ �Է��� �ּż� �����մϴ�.\n\n����ǥ �����Ŀ��� ������ �Ұ����մϴ�.\nȮ���� �����ø� ����ǥ�� �����մϴ�.")){
					document.getElementById("loadingImage").style.display="";

					main.target = "ProceFrame";
					main.action = "WB_CP_Research_Qry.jsp?type=Prod&step=End";
					main.submit();
				}
			} else {
				smsg = "�� ������ ���� �Ʒ������� �Է��� �ּ���.\n\n"+msg;
				alert(smsg);
			}
			
		}

		function onDocument(){
			//
		}
	</script>
</head>
<body onLoad="onDocument();">
	<div id="loadingImage" style="display:none;LEFT:220;TOP:100;POSITION:absolute;z-index:1">
		<img src="/img/2010img/loading.gif" border="0"/></div>

	<div id="container">
	<div id="wrapper">

		<!-- Begin Header -->
		<div id="subheader">
			<ul class="lt">
				<li class="fl"><a href="#none" onfocus="this.blur()"><img src="img/logo.jpg" width="242" height="55"></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"><font color="#FF6600">[������]</font>
							<%=ckOentName%>&nbsp;/&nbsp;<iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" align="center" frameborder="0"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="./WB_VP_Introduction.jsp" onfocus="this.blur()" class="mainmenu">1. ���� �ȳ�</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. ȸ�簳��</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. �ϵ��� �ŷ���Ȳ</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon.jsp" onfocus="this.blur()" class="mainmenu">4. ���޻���� ���</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="mainmenuup">5. ����ǥ ����</a></li>
			</ul>
		</div>
		<!-- End Header -->

		<!-- Begin subcontent -->
		<form action="" method="post" name="info">
		<div id="subcontent">

			<!-- title start -->
			<h1 class="contenttitle">5. ����ǥ ����</h1>
			<!-- title end -->
			

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">���� ����ǥ ����</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table width="100%" cellpadding="0" cellspacing="2" border="0">
								<colgroup>
									<col style="width:30%;" />
									<col style="width:70%;" />
								</colgroup>
								<tbody>
									<tr>
										<td bgcolor="#D2E9FF" style="padding-left:5px;">1. ���簳��</td>
										<td>
											<ul class="lt">
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="submiticon1">���ۼ�</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="submiticon1">�ۼ� �Ϸ�</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="submiticon2">�ۼ� ���ʿ�</a></li>
											</ul>
										</td>
									</tr>
									<tr>
										<td bgcolor="#D2E9FF" style="padding-left:5px;">2. ȸ�簳��</td>
										<td>
											<ul class="lt">
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if(f1.equals("no")) {%>submiticon3<%} else {%>submiticon1<%}%>">���ۼ�</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if(f1.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">�ۼ� �Ϸ�</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="submiticon1">�ۼ� ���ʿ�</a></li>
											</ul>
										</td>
									</tr>
									<tr>
										<td bgcolor="#D2E9FF" style="padding-left:5px;">3. �ϵ��� �ŷ� ��Ȳ</td>
										<td>
											<ul class="lt">
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if((!fall.equals("yes")) && f4.equals("no")) {%>submiticon3<%} else {%>submiticon1<%}%>">���ۼ�</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if((!fall.equals("yes")) && f4.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">�ۼ� �Ϸ�</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if(fall.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">�ۼ� ���ʿ�</a></li>
											</ul>
										</td>
									</tr>
									<tr>
										<td bgcolor="#D2E9FF" style="padding-left:5px;">4. ���޻���� ���</td>
										<td>
											<ul class="lt">
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if((!fall.equals("yes")) && f3.equals("no") && subconTypeCnt == 0) {%>submiticon3<%} else {%>submiticon1<%}%>">���ۼ�</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if((!fall.equals("yes")) && f3.equals("yes") && subconTypeCnt == 0) {%>submiticon2<%} else {%>submiticon1<%}%>">�ۼ� �Ϸ�</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if(subconTypeCnt == 1 || fall.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">�ۼ� ���ʿ�</a></li>
											</ul>
										</td>
									</tr>
								</tbody>
							</table></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<h1 class="contenttitle">
				<table width="100%" cellpadding="0" cellspacing="2" border="0">
					<colgroup>
						<col style="width:45%;" />
						<col style="width:20%;" />
						<col style="width:35%;" />
					</colgroup>
					<tbody>
						<tr>
							<td></td>
							<td>
							<%// ���縶������ ����ǥ ���� ��ư ���� / 20180716 / �躸��%>
								<ul class="lt">
									<li class="fl pr_2"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">����ǥ ���� ����</a></li>
								</ul>
							</td>
							<td></td>
						</tr>
					</tbody>
				</table>
			</h1>

			<div class="fc pt_20"></div>
			<div class="fc pt_10"></div>


			<div class="boxcontent2">
				<ul class="boxcontenthelp lt">
					<li class="boxcontenttitle">�������� �Ϸ� �Ǿ����ϴ�.����� ������ ������ ������ �Ϸ�� ����</li>
					<li class="boxcontenttitle">(����ǥ���� ������ �޴� �߿� ������ǥ ���� Ȯ�Ρ����� ���ۿ��� Ȯ�� ����)</li>
				</ul>
			</div>
			
			<div class="fc pt_20"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><p align="center"><img src="./img/img.gif" border="0"></p></li> 
				</ul>
			</div>

			<div class="fc pt_20"></div>

			<!-- ��ư start -->
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">ȭ�� �μ��ϱ�</a></li>
					<li class="fl pr_2"><a href="javascript:infoSubmit();" onfocus="this.blur()" class="contentbutton2">����ǥ ���� Ȯ��</a></li>
				</ul>
			</div>
			<!-- ��ư end -->

		</div>
		<form>
		<!-- End subcontent  -->

		<!-- Begin Footer -->
		<div id="subfooter"><img src="img/bottom.gif"></div>
		<!-- End Footer -->
	</div>
	</div>

	<%/*-----------------------------------------------------------------------------------------------
	2010�� 4�� 26�� / iframe �߰� / ������
	:: �ϵ��ްŷ���Ȳ (��������) ���� �� ���� �� �����߻����� �������� �ҽǵǴ� ��츦 �����ϱ� ���� 
	:: ���û����� iframe Ÿ������ submit ��Ŵ
	*/%>
	<iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
	<%/*-----------------------------------------------------------------------------------------------*/%>

<script language="JavaScript">
	<%if ( StringUtil.checkNull(request.getParameter("isSaved")).equals("1") ) {%>
		alert("������ �Ϸ�Ǿ����ϴ�.\n�������� '����ǥ ���� Ȯ��' �޴����� ���ۿ��θ� Ȯ�� �ٶ��ϴ�.\n������ �����ּż� �����մϴ�.")
	<%}%>
</script>

</body>
</html>
