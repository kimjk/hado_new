<%@ page session="true" language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_VP_Intoroduction.jsp
* 프로그램설명	: 조사개요 안내
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2016년 04월 11일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-14	정광식       최초작성
*	2015-12-31	정광식		DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<%@ include file="../Include/WB_Inc_chkSession.jsp"%>

<%
ConnectionResource resource	= null;
Connection conn	 = null;
PreparedStatement pstmt	= null;
ResultSet rs	 = null;	

String sSQLs = "";
String sDeptString = "";
String sTmpCenterName	= ""; // 사무소명
String sTmpDeptName = ""; // 부서명
String sTmpUserName	= ""; // 담당자명
String sTmpPhoneNo = ""; // 전화번호

// 관리자를 위한 강제 세션
String sType = request.getParameter("type") == null ? "":request.getParameter("type").trim();
String sMng = request.getParameter("mng") == null ? "":request.getParameter("mng").trim();
if(sMng !=null && sMng.equals("y")) {
	ckOentGB = sType;
	ckOentName = "관리자툴 접근";
	if (sType.equals("1")) {
		session.setAttribute("ckMngNo", "HE0101");
		session.setAttribute("ckCurrentYear", "2021");
		session.setAttribute("ckOentGB", "1");
		session.setAttribute("ckOentName", "관리자툴 접근");
		session.setAttribute("ckSentNo", "");
		session.setAttribute("ckSentName", "");
		session.setAttribute("ckEntGB", "1");
		session.setAttribute("ckLoginGB", "N");
	}
	else if (sType.equals("2")) {
		session.setAttribute("ckMngNo", "HE0102");
		session.setAttribute("ckCurrentYear", "2021");
		session.setAttribute("ckOentGB", "2");
		session.setAttribute("ckOentName", "관리자툴 접근");
		session.setAttribute("ckSentNo", "");
		session.setAttribute("ckSentName", "");
		session.setAttribute("ckEntGB", "1");
		session.setAttribute("ckLoginGB", "N");
	}
	else if (sType.equals("3")) {
		session.setAttribute("ckMngNo", "HE0103");
		session.setAttribute("ckCurrentYear", "2021");
		session.setAttribute("ckOentGB", "3");
		session.setAttribute("ckOentName", "관리자툴 접근");
		session.setAttribute("ckSentNo", "");
		session.setAttribute("ckSentName", "");
		session.setAttribute("ckEntGB", "1");
		session.setAttribute("ckLoginGB", "N");
	}
}

if( !ckMngNo.equals("") && !ckCurrentYear.equals("") && !ckOentGB.equals("") ) {
	/* 임시 저장변수 선언*/
	String sTmp_CenterName = "";
	String sTmp_DeptName = "";
	String sTmp_UserName = "";
	String sTmp_PhoneNo = "";

	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();
		// 
		sSQLs   ="SELECT Center_Name, Dept_Name, User_Name, Phone_No \n";
		sSQLs+="FROM HADO_TB_DEPT_HISTORY_2021 \n";
		sSQLs+="WHERE mng_No = ? AND current_Year = ? AND oent_gb = ? \n";

		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, ckMngNo);
		pstmt.setString(2, ckCurrentYear);
		pstmt.setString(3, ckOentGB);
		rs = pstmt.executeQuery();

		if (rs.next()) { //레코드가 존재할 경우
			sTmp_CenterName = rs.getString("Center_Name") == null ? "":rs.getString("Center_Name").trim(); // 사무소명
			sTmp_DeptName = rs.getString("Dept_Name") == null ? "":rs.getString("Dept_Name").trim(); // 부서명
			sTmp_UserName = rs.getString("User_Name") == null ? "":rs.getString("User_Name").trim(); //  담당자명
			sTmp_PhoneNo = rs.getString("Phone_No") == null ? "":rs.getString("Phone_No").trim(); // 전화번호
		}
		rs.close();
		
		/* 담당자 정보 보정 */
		if ( (sTmp_CenterName != null) && (!sTmp_CenterName.equals("")) ) {
			sDeptString = sTmp_CenterName + " " + sTmp_DeptName + " / " +sTmp_UserName + " / " + sTmp_PhoneNo;
		} else {
			sDeptString	= "본부 기업거래정책국 기업거래정책과 / 이해중 조사관 / 044-200-4656";
		}
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn != null)	try{conn.close();}	catch(Exception e){}
		if (resource != null) resource.release();
	}

	if ( sDeptString.equals("") ) {
		sDeptString	= "본부 기업거래정책국 기업거래정책과 / 이해중 조사관 / 044-200-4656";
	}
}
/*=====================================================================================================*/
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

    <title>2021년도 하도급거래 서면실태 조사</title>
    
    <link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="euc-kr">
    <link href="style.css" rel="stylesheet" type="text/css" />

    <!-- // IE  // -->
	<!--[if IE]><script src="../js/html5.js"></script><![endif]-->
	<!--[if IE 7]>
	<script src="../js/ie7/IE7.js"  type="text/javascript"></script>
	<script src="../js/ie7/ie7-squish.js"  type="text/javascript"></script>
	<![endif]-->
    <script src="../js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript">jQuery.noConflict();</script>
    <script src="../js/mootools-core-1.3.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/mootools-more-1.3.1.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/simplemodal.js" type="text/javascript" charset="euc-kr"></script>
	<script src="../js/commonScript.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/login_2019.js" type="text/javascript" charset="euc-kr"></script>

<script language="javascript">
	function viewHadoInfo() {
		var SM = new SimpleModal({"hideFooter":true, "width":720});
		SM.show({
		  "title":"조사표 작성전 확인",
		  "model":"modal",
		  "contents":'<iframe src="./subPage03.jsp" width="690" height="560" frameborder="0" webkitAllowFullScreen allowFullScreen style="margin-bottom:20px"></iframe>'
		});
	}

	function goPrint() {
	/*url = "ProdStep_02_Print.jsp";
	w = 820;
	h = 600;
	HelpWindow2(url, w, h);*/
	print();
	}

	function HelpWindow2(url, w, h) {
		helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
		helpwindow.focus();
	}
</script>

<body>
	<div id="container">
	<div id="wrapper">

		<!-- Begin Header -->
		<div id="subheader">
			<ul class="lt">
				<li class="fl"><a href="#none" onfocus="this.blur()"><img src="img/logo.jpg" width="242" height="55"></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"><span class="orengetext">[
							<% if( ckOentGB.equals("1") ) {%>제조업
							<% } else if( ckOentGB.equals("2") ) {%>건설업
							<% } else if( ckOentGB.equals("3") ) {%>용역업<% } %>]</span>
							<%=ckOentName%>&nbsp;/&nbsp;<iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" align="center" frameborder="0"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="./WB_VP_Introduction.jsp" onfocus="this.blur()" class="mainmenuup">1. 조사 안내</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. 회사개요</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. 하도급 거래현황</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon.jsp" onfocus="this.blur()" class="mainmenu">4. 수급사업자 명부</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="mainmenu">5. 조사표 전송</a></li>
			</ul>
		</div>
		<!-- End Header -->

		<!-- Begin subcontent -->
		<div id="subcontent">

			<!-- title start -->
			<h1 class="contenttitle">1. 조사 안내</h1>
			<!-- title end -->
				
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">인사말</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li>공정거래위원회는 공정한 하도급거래질서 확립을 위하여 하도급거래에 관한 서면실태조사를 실시하고,
						그 조사결과를 공표하고 있습니다. 이 조사는 <b><u>하도급거래 공정화에 관한 법률 제22조의2</u></b>에 따른 것으로, 하도급거래의 현황 파악 및 하도급거래
						공정화 정책 수립을 위한 기초자료로 활용됩니다.<br/>귀하가 응답하신 내용은 <u>통계법 제33조</u>에 의해 철저히 보호되며, 통계작성 및 공정한
						하도급거래질서 확립을 위해서만 사용됩니다. 바쁘시더라도 국가의 중요 정책결정을 위한 일이오니 성실히 답변해주시기 바랍니다. 참고로 본 실태조사에 응답하지 아니하거나
						허위로 작성하는 경우, 하도급법 제30조의2 규정에 의거 과태료 처분을 받게 되며 귀사의 하도급거래 전반에 대하여 현장 확인조사를 실시할 수 있음을 알려드립니다.
						감사합니다.</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">유의사항</li>
						<li class="boxcontentsubtitle"><img src="./img/qr_cord.png" alt="카카오톡 상담하기"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><span>▶ </span>조사표 입력 및 전송 방법 </li>
						<li><span>1.</span> 아래 작성 순서에 따라 조사표 작성</li>
						<li>회사 개요  → 하도급 거래현황  → 수급사업자 명부입력 및 작성</li>
						<li><span>2.</span> 조사표 입력이 완료되면, 반드시 "조사표 전송" 메뉴를 통하여 "조사표 전송 실행"을 클릭 </li>
						<li><strong>&lt;전송이 완료되었습니다.&gt;</strong>가 나오면 조사표 작성 및 전송이 완료된 것입니다.</li>
						<li><br/></li>
						<li><span>▶</span> 조사표를 <strong>허위작성(입력)</strong> 또는  <strong>미제출시</strong> ｢하도급거래 공정화에 관한 법률｣(이하 ‘하도급법’이라 함)에 의한  <strong>처분(과태료 부과)</strong>을 받을 수 있으며, 귀사의 하도급거래 전반에 대하여 현장 확인조사가 이루어질 수 있음을 알려드립니다.
						</li>
						<li><br/></li>
						<li><span>▶</span> 조사 대상이 되지 않는 경우, 『2. 회사개요』만 입력 후 조사 제외 대상임을 입증할 수 있는 자료를 제출 해 주셔야 합니다.</li>
						<li><br/></li>
						<li><span>▶</span> 입력완료 후 반드시 <strong> ｢5. 조사표 전송｣ </strong>화면에서 <strong>전송버튼을 클릭하여야</strong> 조사표 제출이 완료됩니다. <strong>조사표를 전송하기</strong> 전 반드시 <strong>대표이사의 확인</strong>을 거친 후 전송하시기 바랍니다.
						</li>
						<li><br/></li>
						<li><span>▶</span> 조사표 작성 책임자는 사실조회 및 확인을 위하여 전송한 조사표 내용을 반드시 <strong>출력하여 보관</strong>하여 주십시오.
						</li>
						<li><br/></li>
						<li><span>▶</span> 하도급거래 실태조사 관련 문의는 통합상담센터(1668-3476) 또는 카카오톡 상담톡으로 문의주시기 바랍니다.</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>  
			
			<div class="fc pt_20"></div>

			<!-- 버튼 start -->
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">화면 인쇄하기</a></li>
					<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="contentbutton2">2. 회사개요로 가기</a></li>
				</ul>
			</div>
			<!-- 버튼 end -->

		</div>
		<!-- End subcontent  -->

		<!-- Begin Footer -->
		<div id="subfooter"><img src="img/bottom.gif"></div>
		<!-- End Footer -->

	</div>
	</div>
</body>
</html>
