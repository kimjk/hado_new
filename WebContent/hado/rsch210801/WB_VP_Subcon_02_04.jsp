<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_VP_Subcon_02_04.jsp
* 프로그램설명	: 수급사업자 > 년도별 조사표 > 2015년 건설업 조사표 > 조사표 전송
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2009년 05월
* 작 성 이 력       :
*=========================================================
*	작성일자			작성자명				내용
*=========================================================
*	2009-05			정광식       최초작성
*	2015-07-08	강슬기       조사표 문항 및 코드 정리(StringUtil)
*   2016-01-12	이용광		DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_I_Global.jsp"%>
<%@ include file="../Include/WB_I_chkSession.jsp"%>

<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String sErrorMsg = "";	// 오류메시지

	String q_Cmd		= StringUtil.checkNull(request.getParameter("mode"));

	String sentSaNo = "";
	String sentStatus = "";
	String sentReason = "";
	String sentCheck = "";

	String f2 = "";
	String f3 = "";
	String fall = "no";

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

		sSQLs="SELECT sent_sa_no, sent_status FROM HADO_TB_Subcon_"+sOentYYYY+" \n";
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

		/* 귀사의 일반현황 필수항목 제거로 전송 시 처리되도록 변경 : 2015-07-23 :(정광식)
		if ( (!sentSaNo.equals("")) && (sentSaNo != null) ) {
			f2 = "yes";
		} else {
			f2 = "no";
		}
		*/
		f2 = "yes";

		// 하도급법이 적용되지 않는 사유
		/*
		sSQLs="SELECT * FROM HADO_TB_Subcon_"+sOentYYYY+" \n";
		sSQLs+="WHERE Child_Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";
		*/

		// 하도급법이 적용되지 않는 사유
		sSQLs="SELECT SUBJ_ANS FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
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

		sentCheck = StringUtil.checkNull(sentCheck);

		int gesu = 0;

		if ( f2.equals("yes") && (!sentCheck.equals("")) ) {
			f2 = "yes";
			fall = "yes";
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
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv='Cache-Control' content='no-cache'>
    <meta http-equiv='Pragma' content='no-cache'>
	<meta charset="utf-8">
    <title><%=st_Current_Year_n %>년도 하도급거래 서면실태 조사</title>

	<link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="utf-8" />
	<% if (q_Cmd.equals("print")) { %>
	<link rel="stylesheet" href="style_print.css" type="text/css">
	<% } else { %>
	<link rel="stylesheet" href="style.css" type="text/css">
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
    <script src="../js/simplemodal.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/commonScript.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/login_2019.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/credian_common_script.js" type="text/javascript"  charset="utf-8"></script>
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
						//alert("팝업창이 차단되어 있습니다.\n알림표시줄에서 팝업창을 허용하도록 선택하십시요.")
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

		<%if ( f2.equals("no") ) {%>msg+="\n귀사의 일반현황을 입력해주십시오.";<%}%>
		<%if ( (!fall.equals("yes")) && f3.equals("no") ) {%>msg+="\n하도급거래상황을 입력해주십시오.";<%}%>

		<%if ( st.equals("ok") ) {%>alert("전송이 완료되었습니다..\n설문에 응해주셔서 감사합니다.");<%}%>

		function infoSubmit() {
			var main = document.info;

			if(confirm("[ 로그인 차단을 실행합니다. ]\n\n차단 이후에는 접속이 불가능합니다.\n확인을 누르시면 로그인 차단을 실행합니다.")) {
				//document.getElementById("loadingImage").style.display="";
				main.target = "ProceFrame";
				main.action = "WB_CP_Subcon_Qry.jsp?type=Const&step=Block";
				main.submit();
			}
		}

		function savef() {
			var smsg = "";
			var main = document.info;

			if ( msg=="" ) {
				if(confirm("[ 대표이사가 이 조사표 내용을 확인했음 ]\n\n조사표내용을 입력해 주셔서 감사합니다.\n\n조사표 전송후에는 수정이 불가능합니다.\n확인을 누르시면 조사표를 전송합니다.")) {
					//document.getElementById("loadingImage").style.display="";
					processSystemStart("[1/1] 조사표를 전송합니다.");
					main.target = "ProceFrame";
					main.action = "WB_CP_Subcon_Qry.jsp?type=Const&step=End";
					main.submit();
				}
			} else {
				smsg = "※ 전송을 위해 아래사항을 입력해 주세요.\n\n"+msg;
				alert(smsg);
			}

		}

		function goPrint(){
			print();
		}

		// 조사표 전송 확인
		function checkSubmit(){
			sTmp = "<%= ckMngNo%>";
			if(sTmp == "") {
				alert("로그인 후 이용하여 주십시오.");
			} else {
				HelpWindow2("WB_Submit01.jsp", 600, 600);
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
				<li class="fl"><a href="#none" onfocus="this.blur()"><img src="img/logo.jpg" width="242" height="55"></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"><font color="#FF6600">[
							<% if( ckOentGB.equals("1") ) {%>제조업
							<% } else if( ckOentGB.equals("2") ) {%>건설업
							<% } else if( ckOentGB.equals("3") ) {%>용역업<% } %>]</font>
							<%=ckOentName%>&nbsp;/&nbsp;<%=ckSentName%><iframe src="/Include/WB_FP_sessionClock.jsp" name="TimerArea" id="TimerArea" width="220" height="24" marginwidth="0" marginheight="0" align="center" frameborder="0"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="mainmenu">1. 조사안내</a></li>
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. 귀사의 일반현황</a></li>
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. 하도급 거래 현황</a></li>
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="mainmenuup">4. 조사표 전송</a></li>
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_Add.jsp" onfocus="this.blur()" class="mainmenu">5. 신규제도관련 설문조사</a></li>
			</ul>
		</div>
		<!-- End Header -->

	<!-- Begin subcontent -->
	<form action="" method="post" name="info">
	<div id="subcontent">

		<!-- title start -->
		<h1 class="contenttitle">4. 조사표 전송</h1>
		<!-- title end -->

		<div class="boxcontent2">
			<ul class="boxcontenthelp lt text_list" style="margin-left:10px; margin-right:10px;">
				<li><span>▣</span><font style="font-weight:bold;">"조사표 전송 실행"</font> 후 <font style="font-weight:bold;">"전송이 완료 되었습니다."라는 문구와 "로그인 차단"</font> 버튼이 나오면 전송이 완료된 것입니다.</li>
				<li><span>▣</span>아래 <font style="font-weight:bold;">"로그인 차단"</font> 기능은 귀사가 조사표를 작성한 후, 귀사가 원사업자들로부터 압력을 받아 조사표를 수정하게 되거나 원사업자들의 조사방해를 방지하기 위한 것임을<br>알려드립니다. </li>
				<li><span>▣</span><font style="font-weight:bold;">"로그인 차단"</font> 버튼을 실행하실 경우, 작성하신 내용의 <font style="font-weight:bold;">조회 및 수정</font>이 <font style="font-weight:bold;">불가능</font>해지므로 <font style="font-weight:bold;">신중히 검토</font>하신 후 실행하시기 바랍니다.</li>
			</ul>
		</div>

		<div class="fc pt_10"></div>

		<div class="boxcontent">
			<div class="boxcontentleft">
				<ul class="lt">
					<li class="boxcontenttitle">서면 조사표 구성</li>
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
									<td bgcolor="#D2E9FF" style="padding-left:5px;">1. 조사안내</td>
									<td>
										<ul class="lt">
											<li class="fl pr_2"><a href="WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="submiticon1">미작성</a></li>
											<li class="fl pr_2"><a href="WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="submiticon1">작성 완료</a></li>
											<li class="fl pr_2"><a href="WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="submiticon2">작성 불필요</a></li>
										</ul>
									</td>
								</tr>
								<tr>
									<td bgcolor="#D2E9FF" style="padding-left:5px;">2. 귀사의 일반현황</td>
									<td>
										<ul class="lt">
											<li class="fl pr_2"><a href="WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="<% if(f2.equals("no")) {%>submiticon3<%} else {%>submiticon1<%}%>">미작성</a></li>
											<li class="fl pr_2"><a href="WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="<% if(f2.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">작성 완료</a></li>
											<li class="fl pr_2"><a href="WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="submiticon1">작성 불필요</a></li>
										</ul>
									</td>
								</tr>
								<tr>
									<td bgcolor="#D2E9FF" style="padding-left:5px;">3. 하도급 거래 현황</td>
									<td>
										<ul class="lt">
											<li class="fl pr_2"><a href="WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="<% if(f3.equals("no")) {%>submiticon3<%} else {%>submiticon1<%}%>">미작성</a></li>
											<li class="fl pr_2"><a href="WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="<% if(f3.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">작성 완료</a></li>
											<li class="fl pr_2"><a href="WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="<% if(fall.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">작성 불필요</a></li>
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

		<h1 class="contenttitle">
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
								<li class="fl pr_2"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">조사표 전송 실행</a></li>
								<li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">화면 인쇄하기</a></li>
								<li class="fl pr_2"><a href="javascript:checkSubmit();" onfocus="this.blur()" class="contentbutton2">조사표 전송 확인</a></li>
								<% if( (!sentStatus.equals("")) && (sentStatus != null) ) { %>
								<li class="fl pr_2"><a href="javascript:infoSubmit();" onfocus="this.blur()" class="contentbutton2">저장 및 로그인 차단</a></li>
								<% } %>
							</ul>
						</td>
					</tr>
				</tbody>
			</table>
		</h1>

		<div class="fc pt_20"></div>

		<div class="boxcontent2">
			<ul class="boxcontenthelp lt text_list" style="margin-left:10px; margin-right:10px;">
				<li><span>▣</span><font style="font-weight:bold;">개정 하도급법 주요 내용에 대한 설문조사를 실시하고 있습니다. <font color="#FF0066">아래 "신규제도관련 설문조사로 이동"</font>버튼을 눌러 주십시오.</font></font></li>
			</ul>
		</div>
		<div class="fc pt_20"></div>

		<!-- 버튼 start -->
		<div class="fr">
			<ul class="lt">
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_Add.jsp" onfocus="this.blur()" class="contentbutton2">신규제도관련 설문조사로 이동</a></li>
			</ul>
		</div>
		<!-- 버튼 end -->



	</div>
	<form>
	<!-- End subcontent  -->

	<!-- Begin Footer -->
	<div id="subfooter"><img src="img/bottom.gif"></div>
	<!-- End Footer -->

</div>
</div>

<%/*-----------------------------------------------------------------------------------------------
2010년 4월 26일 / iframe 추가 / 정광식
:: 하도급거래상황 (설문문항) 선택 후 저장 시 오류발생으로 기존정보 소실되는 경우를 방지하기 위해
:: 선택사항을 iframe 타겟으로 submit 시킴
*/%>
<iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
<%/*-----------------------------------------------------------------------------------------------*/%>

<script type="text/JavaScript">
<% if ( StringUtil.checkNull(request.getParameter("isEnded")).equals("ok") ) { %>
	alert("전송이 완료 되었습니다.")
<% } %>
//]]
</script>

</body>
</html>