<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_VP_Subcn_03_04.jsp
* ���α׷�����	: ���޻���� > �⵵�� ����ǥ > 2015�� �뿪�� ����ǥ > ����ǥ ����
* ���α׷�����	: 1.0.1
* �����ۼ�����	: 2009�� 05��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����			�ۼ��ڸ�				����
*=========================================================
*	2009-05			������       �����ۼ�
*	2015-07-08	������       ����ǥ ���� �� �ڵ� ����(StringUtil)
*  2016-01-12		�̿뱤	     DB�������� ���� ���ڵ� ����
*/
%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_I_Global.jsp"%>
<%@ include file="../Include/WB_I_chkSession.jsp" %>

<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String sErrorMsg = "";	// �����޽���

	String q_Cmd		= StringUtil.checkNull(request.getParameter("mode"));

	String sentSaNo = "";
	String sentStatus = "";
	String sentReason = "";
	String sentCheck = "";

	String f2 = "";
	String f3 = "";
	String f4 = "";
	String fall = "no";
    String writerDate = "";

	String stt = StringUtil.checkNull(request.getParameter("tt"));
	String st = StringUtil.checkNull(request.getParameter("st"));
	String saveno = StringUtil.checkNull(request.getParameter("saveno"));

	String sSQLs = "";

	// Cookie Request
	String sMngNo = ckMngNo;
	String sOentYYYY = ckCurrentYear;
	String sOentGB = ckOentGB;
	String sOentName = ckOentName;
	String sSentNo = ckSentNo;

	// Cookie Request
	if( ckMngNo.trim().length() > 8 ) {
		sMngNo = ckMngNo.substring(0,8);
	} else if( ckMngNo.trim().length() == 6 ) {
		sMngNo = ckMngNo.substring(0,5);
	} else if ( ckMngNo.trim().length() == 4 ) {
		sMngNo = ckMngNo.substring(0,3);
	}
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/

	if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
		ConnectionResource resource	= null;
		Connection conn				= null;
		PreparedStatement pstmt		= null;
		ResultSet rs				= null;

		sSQLs="SELECT sent_sa_no, sent_status, sp_fld_03, WRITER_DATE FROM HADO_TB_Subcon_"+sOentYYYY+" \n";
		sSQLs+="WHERE Child_Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";

		try {
			resource	= new ConnectionResource();
			conn		= resource.getConnection();
			//System.out.println("sSQLs : "+sSQLs);

			pstmt		= conn.prepareStatement(sSQLs);
			rs			= pstmt.executeQuery();

			while (rs.next()) {
				sentSaNo = rs.getString("sent_sa_no");
				sentStatus = rs.getString("sent_status");
				sentCheck = rs.getString("sp_fld_03");
				writerDate = rs.getString("WRITER_DATE");
			}
			rs.close();


		} catch(Exception e){
			e.printStackTrace();
		} finally {
			if (rs != null)		try{rs.close();}	catch(Exception e){}
			if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
			if (conn != null)	try{conn.close();}	catch(Exception e){}
			if (resource != null) resource.release();
		}

		sentSaNo = StringUtil.checkNull(sentSaNo);
		sentStatus = StringUtil.checkNull(sentStatus);
		sentCheck = StringUtil.checkNull(sentCheck);
        writerDate = StringUtil.checkNull(writerDate);

		/* �ͻ��� �Ϲ���Ȳ �ʼ��׸� ���ŷ� ���� �� ó���ǵ��� ���� : 2015-07-23 :(������)
		if ( (!sentSaNo.equals("")) && (sentSaNo != null) ) {
			f2 = "yes";
		} else {
			f2 = "no";
		}
		*/
        if(!writerDate.equals("")){
            f2 = "yes";    
        } else {
            f2 = "no";
        }

		// �ϵ��޹��� ������� �ʴ� ����
		/*
		sSQLs="SELECT * FROM HADO_TB_Subcon_"+sOentYYYY+" \n";
		sSQLs+="WHERE Child_Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";
		*/

		// �ϵ��޹��� ������� �ʴ� ����
		/* sSQLs="SELECT SUBJ_ANS FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
		sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";
		sSQLs+="AND SOENT_Q_CD=30 AND SOENT_Q_GB=1 \n";

		try {
			resource	= new ConnectionResource();
			conn		= resource.getConnection();
			//System.out.println("sSQLs : "+sSQLs);

			pstmt		= conn.prepareStatement(sSQLs);
			rs			= pstmt.executeQuery();

			while (rs.next()) {
				//sentCheck = rs.getString("SP_FLD_03");
				sentCheck = rs.getString("SUBJ_ANS")==null ? "":rs.getString("SUBJ_ANS");
			}

		} catch(Exception e){
			e.printStackTrace();
		} finally {
			if (rs != null)		try{rs.close();}	catch(Exception e){}
			if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
			if (conn != null)	try{conn.close();}	catch(Exception e){}
			if (resource != null) resource.release();
		}

		sentCheck = StringUtil.checkNull(sentCheck); */

		int gesu = 0;

		if ( f2.equals("yes") && (!sentCheck.equals("")) ) {
			f2 = "yes";
			fall = "yes";
            f4 = "yes";
		} else {
			gesu = 0;

			sSQLs="SELECT count(*) ansCnt FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
			sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
			sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
			sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
			sSQLs+="AND Sent_No="+sSentNo+" \n";

			try {
				resource	= new ConnectionResource();
				conn		= resource.getConnection();
				pstmt		= conn.prepareStatement(sSQLs);
				rs			= pstmt.executeQuery();

				while (rs.next()) {
					gesu = rs.getInt("ansCnt");
				}
				rs.close();
			} catch(Exception e){
				e.printStackTrace();
			} finally {
				if (rs != null)		try{rs.close();}	catch(Exception e){}
				if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
				if (conn != null)	try{conn.close();}	catch(Exception e){}
				if (resource != null) resource.release();
			}

			if (gesu == 0) {
				f3 = "no";
			} else {
				f3 = "yes";
			}
		}
	}

    // �߰� ���� ���� 
    // sentStatus ���ۿϷᰡ 1 �̰� , fall = no, f3 = yes
    String addTypeSatus = "";
    
    if("1".equals(sentStatus) && "no".equals(fall) && "yes".equals(f4)){
        addTypeSatus = "N";
    }else{
        addTypeSatus = "Y";
    }
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--[if lt IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie6"><![endif]-->
<!--[if IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie7"><![endif]-->
<!--[if IE 8]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie8"><![endif]-->
<!--[if (gt IE 8)|!(IE)]><!-->
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko-KR" >
<!--<![endif]-->
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta http-equiv='Cache-Control' content='no-cache' />
    <meta http-equiv='Pragma' content='no-cache' />
    <title><%=st_Current_Year_n %>�⵵ �ϵ��ްŷ� ������� ����</title>

	<link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="euc-kr" />
	<% if (q_Cmd.equals("print")) { %>
	<link rel="stylesheet" href="style_print.css" type="text/css" />
	<% } else { %>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<% } %>


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
    <script src="../js/login_2019.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/credian_common_script.js" type="text/javascript"  charset="euc-kr"></script>
	<script type="text/javascript">
	//<![CDATA[
		function HelpWindow2(url, w, h) {
			helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
			helpwindow.focus();
		}

		function popup(furl, names, ws, hs, tps, lps) {
			if((furl != "") && (names != "") && (tps != "") && (lps != "")) {
				scookie = GetCookie(names);
				if(scookie == "") {
					objPopupWindow = window.open(furl,names,"toolbar=no,width="+ws+",height="+hs+",directories=no,status=no,scrollbars=no,resize=no,menubar=no,location=no,top="+tps+",left="+lps);
					if(objPopupWindow == null)
					{
						//alert("�˾�â�� ���ܵǾ� �ֽ��ϴ�.\n�˸�ǥ���ٿ��� �˾�â�� ����ϵ��� �����Ͻʽÿ�.")
					}
				}
			}

			return 1;
		}

		var msg="";
		var sStatus = "<%=sentStatus%>";
		//alert(sStatus);
		var f2 = "<%=f2%>";
		var f3 = "<%=f3%>";

		<%if ( f2.equals("no") ) {%>msg+="\n�ͻ��� �Ϲ���Ȳ�� �Է����ֽʽÿ�.";<%}%>
		<%if ( (!fall.equals("yes")) && f3.equals("no") ) {%>msg+="\n�ϵ��ްŷ���Ȳ�� �Է����ֽʽÿ�.";<%}%>

		<%if ( st.equals("ok") ) {%>alert("������ �Ϸ�Ǿ����ϴ�..\n������ �����ּż� �����մϴ�.");<%}%>

		function infoSubmit() {
			var main = document.info;

			if(confirm("[ �α��� ������ �����մϴ�. ]\n\n���� ���Ŀ��� ������ �Ұ����մϴ�.\nȮ���� �����ø� �α��� ������ �����մϴ�.")) {
				//document.getElementById("loadingImage").style.display="";
				processSystemStart("[1/1] �α��� ������ �����մϴ�.");

				main.target = "ProceFrame";
				main.action = "WB_CP_Subcon_Qry.jsp?type=Srv&step=Block";
				main.submit();
			}
		}

		function savef() {
			var smsg = "";
			var main = document.info;

			if ( msg=="" ) {
				if(confirm("[ ��ǥ�̻簡 �� ����ǥ ������ Ȯ������ ]\n\n����ǥ������ �Է��� �ּż� �����մϴ�.\n\n����ǥ �����Ŀ��� ������ �Ұ����մϴ�.\nȮ���� �����ø� ����ǥ�� �����մϴ�.")) {
					//document.getElementById("loadingImage").style.display="";
					processSystemStart("[1/1] ����ǥ�� �����մϴ�.");

					main.target = "ProceFrame";
					main.action = "WB_CP_Subcon_Qry.jsp?type=Srv&step=End";
					main.submit();
				}
			} else {
				smsg = "�� ������ ���� �Ʒ������� �Է��� �ּ���.\n\n"+msg;
				alert(smsg);
			}

		}

		function goPrint(){
			print();
		}

		// ����ǥ ���� Ȯ��
		function checkSubmit(){
			sTmp = "<%= ckMngNo%>";
			if(sTmp == "") {
				alert("�α��� �� �̿��Ͽ� �ֽʽÿ�.");
			} else {
				HelpWindow2("WB_Submit01.jsp", 600, 600);
			}
		}
		
		function message(){
		    var type = "<%=addTypeSatus%>";
		    if(type == 'N'){
		        alert("�� �߰� ������ �ϵ��ްŷ��� �ϰ� �ִ� ������� ������� ���� �ϰ� �ֽ��ϴ�. �ͻ�� �ϵ��ްŷ��� �ϰ� ���� �ʴٰ� ���� �ϼ̱� ������ �߰������� ���� �Ͻ� �� �����ϴ�. �����մϴ�.");
		    }
		}
	//]]
	</script>
</head>
<body>

<div id="container">
<div id="wrapper">

	<!-- Begin Header -->
		<div id="subheader">
			<ul class="lt">
				<li class="fl"><a href="#none" onfocus="this.blur()"><img src="img/logo.jpg" width="242" height="55" /></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"><font color="#FF6600">[
							<% if( ckOentGB.equals("1") ) {%>������
							<% } else if( ckOentGB.equals("2") ) {%>�Ǽ���
							<% } else if( ckOentGB.equals("3") ) {%>�뿪��<% } %>]</font>
							<%=ckOentName%>&nbsp;/&nbsp;<%=ckSentName%><iframe src="../Include/WB_FP_sessionClock.jsp" name="TimerArea" id="TimerArea" width="220" height="24" marginwidth="0" marginheight="0" frameborder="0" style="vertical-align: text-bottom;"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="./WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="mainmenu">1. ����ȳ�</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. �ͻ��� �Ϲ���Ȳ</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. �ϵ��� �ŷ� ��Ȳ</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="mainmenuup">4. ����ǥ ����</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_Add.jsp" onfocus="this.blur()" onClick="message();" class="mainmenu">5. �߰� ����</a></li>
			</ul>
		</div>
		<!-- End Header -->

	<!-- Begin subcontent -->
	<form action="" method="post" name="info">
	<div id="subcontent">

		<!-- title start -->
		<h1 class="contenttitle">4. ����ǥ ����</h1>
		<!-- title end -->

		<div class="boxcontent2">
			<ul class="boxcontenthelp lt text_list" style="margin-left:10px; margin-right:10px;">
				<li><span>��</span><font style="font-weight:bold;">"����ǥ ���� ����"</font> �� <font style="font-weight:bold;">"������ �Ϸ� �Ǿ����ϴ�."��� ������ "�α��� ����"</font> ��ư�� ������ ������ �Ϸ�� ���Դϴ�.</li>
				<li><span>��</span>�Ʒ� <font style="font-weight:bold;">"�α��� ����"</font> ����� �ͻ簡 ����ǥ�� �ۼ��� ��, �ͻ簡 ������ڵ�κ��� �з��� �޾� ����ǥ�� �����ϰ� �ǰų� ������ڵ��� ������ظ� �����ϱ� ���� ������<br/>�˷��帳�ϴ�. </li>
				<li><span>��</span><font style="font-weight:bold;">"�α��� ����"</font> ��ư�� �����Ͻ� ���, �ۼ��Ͻ� ������ <font style="font-weight:bold;">��ȸ �� ����</font>�� <font style="font-weight:bold;">�Ұ���</font>�����Ƿ� <font style="font-weight:bold;">������ ����</font>�Ͻ� �� �����Ͻñ� �ٶ��ϴ�.</li>
			</ul>
		</div>

		<div class="fc pt_10"></div>

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
									<td bgcolor="#D2E9FF" style="padding-left:5px;">1. ����ȳ�</td>
									<td>
										<ul class="lt">
											<li class="fl pr_2"><a href="WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="submiticon1">���ۼ�</a></li>
											<li class="fl pr_2"><a href="WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="submiticon1">�ۼ� �Ϸ�</a></li>
											<li class="fl pr_2"><a href="WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="submiticon2">�ۼ� ���ʿ�</a></li>
										</ul>
									</td>
								</tr>
								<tr>
									<td bgcolor="#D2E9FF" style="padding-left:5px;">2. �ͻ��� �Ϲ���Ȳ</td>
									<td>
										<ul class="lt">
											<li class="fl pr_2"><a href="WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="<% if(f2.equals("no")) {%>submiticon3<%} else {%>submiticon1<%}%>">���ۼ�</a></li>
											<li class="fl pr_2"><a href="WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="<% if(f2.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">�ۼ� �Ϸ�</a></li>
											<li class="fl pr_2"><a href="WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="submiticon1">�ۼ� ���ʿ�</a></li>
										</ul>
									</td>
								</tr>
								<tr>
									<td bgcolor="#D2E9FF" style="padding-left:5px;">3. �ϵ��� �ŷ� ��Ȳ</td>
									<td>
										<ul class="lt">
											<li class="fl pr_2"><a href="WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="<% if(f3.equals("no")) {%>submiticon3<%} else {%>submiticon1<%}%>">���ۼ�</a></li>
											<li class="fl pr_2"><a href="WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="<% if(f3.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">�ۼ� �Ϸ�</a></li>
											<li class="fl pr_2"><a href="WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="<% if(fall.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">�ۼ� ���ʿ�</a></li>
										</ul>
									</td>
								</tr>
							</tbody>
						</table>
					</li>
				</ul>
			</div>
			<div class="fc"></div>
		</div>

		<div class="fc pt_10"></div>

<!-- 		<h1 class="contenttitle"> -->
			<table width="100%" cellpadding="0" cellspacing="2" border="0">
				<colgroup>
					<col style="width:40%;" />
					<col style="width:60%;" />
				</colgroup>
				<tbody>
					<tr>
						<td></td>
						<td>
							<ul class="lt">
								<li class="fl pr_2"><h1 class="contenttitle"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">����ǥ ���� ����</a></h1></li>
								<li class="fl pr_2"><h1 class="contenttitle"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">ȭ�� �μ��ϱ�</a></h1></li>
								<li class="fl pr_2"><h1 class="contenttitle"><a href="javascript:checkSubmit();" onfocus="this.blur()" class="contentbutton2">����ǥ ���� Ȯ��</a></h1></li>
								<% if( (!sentStatus.equals("")) && (sentStatus != null) ) { %>
								<li class="fl pr_2"><h1 class="contenttitle"><a href="javascript:infoSubmit();" onfocus="this.blur()" class="contentbutton2">���� �� �α��� ����</a></h1></li>
								<% } %>
							</ul>
						</td>
					</tr>
				</tbody>
			</table>
<!-- 		</h1> -->

		<div class="fc pt_20"></div>

		<!-- <div class="boxcontent2">
			<ul class="boxcontenthelp lt text_list" style="margin-left:10px; margin-right:10px;">
				<li><span>��</span><font style="font-weight:bold;">���� �ϵ��޹� �ֿ� ���뿡 ���� �������縦 �ǽ��ϰ� �ֽ��ϴ�. <font color="#FF0066">�Ʒ� "�ű��������� ��������� �̵�"</font>��ư�� ���� �ֽʽÿ�.</font></li>
			</ul>
		</div>
		<div class="fc pt_20"></div> -->

		<!-- ��ư start -->
		<!-- <div class="fr">
			<ul class="lt">
				<li class="fl pr_2"><a href="./WB_VP_Subcon_Add.jsp" onfocus="this.blur()" class="contentbutton2">�ű��������� ��������� �̵�</a></li>
			</ul>
		</div> -->
		<!-- ��ư end -->



	</div>
	</form>
	<!-- End subcontent  -->

	<!-- Begin Footer -->
	<div id="subfooter"><img src="img/bottom.gif" /></div>
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

<script type="text/JavaScript">
//<![CDATA[
<% if ( StringUtil.checkNull(request.getParameter("isEnded")).equals("ok") ) { %>
	alert("������ �Ϸ� �Ǿ����ϴ�.")
<% } %>
//]]
</script>

</body>
</html>