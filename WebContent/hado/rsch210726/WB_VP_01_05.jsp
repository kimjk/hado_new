<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_VP_01_05.jsp
* 프로그램설명	: 조사표 전송
* 프로그램버전	: 3.0.1
* 최초작성일자	: 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-14	정광식       최초작성
*  2015-05-29  정광식       원사업자요건이 안되는 경우 응답 시 하도급거래상황 작성 미필요 적용 (SP_FLD_02)
* 	2015-12-30	정광식		DB변경으로 인한 인코딩 변경
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
* 입력정보 저장 변수 선언 및 초기화 시작
*/
String sOentSaNo = "";			// 원사업자 등록번호
String sCompStatus	 = "";		// 회사영업상태
//String sSubconType = "";		// 하도급거래형태
String sIsNotOent = "";			// 2015-05-29 / 정광식 / 원사업자요건 안됨 여부
String f1	= "no";	// 회사개요
String f2	= "no"; // 사업장정보
String f3	= "no";	// 수급사업자명부
String f4	= "no"; // 하도급거래현황
String fall	= "no"; // 조사제외대상

int subconTypeCnt = 0;

String stt = StringUtil.checkNull(request.getParameter("tt"));
String st = StringUtil.checkNull(request.getParameter("isEnded"));
String saveno = StringUtil.checkNull(request.getParameter("saveno"));

/* 항목표시중 과년도 항목 표시 계산을 위해 조사년도 정수형 변환 */
int nCurrentYear = 0;
if( !ckCurrentYear.equals("") ) {
	nCurrentYear = Integer.parseInt(ckCurrentYear);
}
/**
* 입력정보 저장 변수 선언 및 초기화 끝
*/

if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
	
	///////////////////////////////////////////////////////////////////2020년도 subconType 조사표로 이동
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
			sIsNotOent = rs.getString("sp_fld_02")==null ? "": rs.getString("sp_fld_02");	// 2015-05-29 / 정광식 / 원사업자요건 안됨 여부
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
	if ( f1.equals("yes") && !sCompStatus.equals("1") ) { // 2015-05-29 / 정광식 / 원사업자요건 안됨 여부 추가
		f2 = "yes";
		fall = "yes";
	} else {
		gesu = 0;

		//--- 사업장 정보 받지 않으므로 변수 세팅으로 통과 시킴
		f2 = "yes";
		//-----------------------------------------------------

		// 하도급거래상황 입력여부 확인
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


	if ( (!sCompStatus.equals("1")) || (!sIsNotOent.equals("")) ) { // 2015-05-29 / 정광식 / 원사업자요건 안됨 여부 추가
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

    <title><%= nCurrentYear %>년도 하도급거래 서면실태 조사</title>
    
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
				alert("로그인 후 이용하여 주십시오.");
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
				alert("로그인 후 이용하여 주십시오.");
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
						//alert("팝업창이 차단되어 있습니다.\n알림표시줄에서 팝업창을 허용하도록 선택하십시요.")
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

		<%if (f1.equals("no")) {%>msg+="\n회사개요를 입력해주십시오.";<%}%>
		<%if ((!fall.equals("yes")) && f2.equals("no")) {%>msg+="\n본사 및 사업소 현황을 입력해주십시오.";<%}%>
		<%if ((!fall.equals("yes")) && f3.equals("no") && subconTypeCnt == 0 ) {%>msg+="\n수급사업자 명부를 입력해주십시오.";<%}%>
		<%if ((!fall.equals("yes")) && f4.equals("no")) {%>msg+="\n하도급거래상황을 입력해주십시오.";<%}%>


		<%if ( st.equals("ok") ) {%>alert("전송이 완료되었습니다..\n설문에 응해주셔서 감사합니다.");<%}%>

		function savef(){
			var smsg = "";
			var main = document.info;

			if ( msg=="" ){
				if(confirm("[ 대표이사가 이 조사표 내용을 확인했음 ]\n\n조사표내용을 입력해 주셔서 감사합니다.\n\n조사표 전송후에는 수정이 불가능합니다.\n확인을 누르시면 조사표를 전송합니다.")){
					document.getElementById("loadingImage").style.display="";

					main.target = "ProceFrame";
					main.action = "WB_CP_Research_Qry.jsp?type=Prod&step=End";
					main.submit();
				}
			} else {
				smsg = "※ 전송을 위해 아래사항을 입력해 주세요.\n\n"+msg;
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
						<li class="pt_20"><font color="#FF6600">[제조업]</font>
							<%=ckOentName%>&nbsp;/&nbsp;<iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" align="center" frameborder="0"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="./WB_VP_Introduction.jsp" onfocus="this.blur()" class="mainmenu">1. 조사 안내</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. 회사개요</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. 하도급 거래현황</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon.jsp" onfocus="this.blur()" class="mainmenu">4. 수급사업자 명부</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="mainmenuup">5. 조사표 전송</a></li>
			</ul>
		</div>
		<!-- End Header -->

		<!-- Begin subcontent -->
		<form action="" method="post" name="info">
		<div id="subcontent">

			<!-- title start -->
			<h1 class="contenttitle">5. 조사표 전송</h1>
			<!-- title end -->
			

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
										<td bgcolor="#D2E9FF" style="padding-left:5px;">1. 조사개요</td>
										<td>
											<ul class="lt">
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="submiticon1">미작성</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="submiticon1">작성 완료</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="submiticon2">작성 불필요</a></li>
											</ul>
										</td>
									</tr>
									<tr>
										<td bgcolor="#D2E9FF" style="padding-left:5px;">2. 회사개요</td>
										<td>
											<ul class="lt">
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if(f1.equals("no")) {%>submiticon3<%} else {%>submiticon1<%}%>">미작성</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if(f1.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">작성 완료</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="submiticon1">작성 불필요</a></li>
											</ul>
										</td>
									</tr>
									<tr>
										<td bgcolor="#D2E9FF" style="padding-left:5px;">3. 하도급 거래 현황</td>
										<td>
											<ul class="lt">
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if((!fall.equals("yes")) && f4.equals("no")) {%>submiticon3<%} else {%>submiticon1<%}%>">미작성</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if((!fall.equals("yes")) && f4.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">작성 완료</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if(fall.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">작성 불필요</a></li>
											</ul>
										</td>
									</tr>
									<tr>
										<td bgcolor="#D2E9FF" style="padding-left:5px;">4. 수급사업자 명부</td>
										<td>
											<ul class="lt">
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if((!fall.equals("yes")) && f3.equals("no") && subconTypeCnt == 0) {%>submiticon3<%} else {%>submiticon1<%}%>">미작성</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if((!fall.equals("yes")) && f3.equals("yes") && subconTypeCnt == 0) {%>submiticon2<%} else {%>submiticon1<%}%>">작성 완료</a></li>
												<li class="fl pr_2"><a href="#" onfocus="this.blur()" class="<% if(subconTypeCnt == 1 || fall.equals("yes")) {%>submiticon2<%} else {%>submiticon1<%}%>">작성 불필요</a></li>
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
							<%// 조사마감으로 조사표 전송 버튼 가림 / 20180716 / 김보선%>
								<ul class="lt">
									<li class="fl pr_2"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">조사표 전송 실행</a></li>
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
					<li class="boxcontenttitle">“전송이 완료 되었습니다.”라는 문구가 나오면 전송이 완료된 것임</li>
					<li class="boxcontenttitle">(조사표전송 페이지 메뉴 중에 “조사표 전송 확인”에서 전송여부 확인 가능)</li>
				</ul>
			</div>
			
			<div class="fc pt_20"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><p align="center"><img src="./img/img.gif" border="0"></p></li> 
				</ul>
			</div>

			<div class="fc pt_20"></div>

			<!-- 버튼 start -->
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">화면 인쇄하기</a></li>
					<li class="fl pr_2"><a href="javascript:infoSubmit();" onfocus="this.blur()" class="contentbutton2">조사표 전송 확인</a></li>
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

<script language="JavaScript">
	<%if ( StringUtil.checkNull(request.getParameter("isSaved")).equals("1") ) {%>
		alert("전송이 완료되었습니다.\n페이지의 '조사표 전송 확인' 메뉴에서 전송여부를 확인 바랍니다.\n설문에 응해주셔서 감사합니다.")
	<%}%>
</script>

</body>
</html>
