<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_VP_Subcon.jsp
* 프로그램설명	: 수급사업자명부 등록
* 프로그램버전	: 3.0.1
* 최초작성일자	: 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-14	정광식       최초작성
*	2015-05-18	정광식       내부관리툴에서 파일 업로드 제한
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
ConnectionResource resource	= null;
Connection conn				= null;
PreparedStatement pstmt		= null;
ResultSet rs				= null;

String sErrorMsg	= "";					// 오류메시지
String sReturnURL	= "";	// 이동URL
String sfile		= "";
String ssize		= "";
String sSQLs		= "";

// Cookie Request
String sMngNo		= ckMngNo;
String sOentYYYY	= ckCurrentYear;
String sCurrentYear = ckCurrentYear;
String sOentGB		= ckOentGB;

/* 항목표시중 과년도 항목 표시 계산을 위해 조사년도 정수형 변환 */
int nCurrentYear = 0;
if( !ckCurrentYear.equals("") ) {
	nCurrentYear = Integer.parseInt(ckCurrentYear);
}

if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
	// 해당사업자 정보 가져오기
	sSQLs="SELECT * FROM HADO_TB_Oent_SubCon_File \n";
	sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+ckCurrentYear+"' \n";
	sSQLs+="AND Oent_GB='"+ckOentGB+"' \n";

	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();
		pstmt		= conn.prepareStatement(sSQLs);
		rs			= pstmt.executeQuery();

		while (rs.next()) {
			sfile	= rs.getString("oent_file")==null ? "":rs.getString("oent_file").trim();
			ssize	= rs.getString("oent_file_size")==null ? "":rs.getString("oent_file_size").trim();
		}
		rs.close();
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if ( rs != null )	try{rs.close();}		catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )		try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
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

    <title>2020년도 하도급거래 서면실태 조사</title>
    
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
	<script type="text/JavaScript">
	//<![CDATA[
		function sfileup(){
			window.open("WB_File_Up.jsp","_blank","toolbar=no,width=450,height=420,directories=no,status=no,scrollbars=Yes,resize=no,menubar=no");
		}

		function HelpWindow2(url, w, h){
			helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
			helpwindow.focus();
		}

		function goPrint(){
			/*url = "ProdStep_04_Print.jsp";
			w = 820;
			h = 600;
			if(confirm("화면 인쇄는 조사표 저장 후에 가능합니다.\n\n인쇄하시겠습니까?\n[확인]을 누르시면 인쇄됩니다."))
				HelpWindow2(url, w, h);*/
			print();
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
				<li class="fl pr_2"><a href="./WB_VP_Subcon.jsp" onfocus="this.blur()" class="mainmenuup">4. 수급사업자 명부</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="mainmenu">5. 조사표 전송</a></li>
			</ul>
		</div>
		<!-- End Header -->

		<!-- Begin subcontent -->
		<div id="subcontent">
			<!-- title start -->
			<h1 class="contenttitle">4. 수급사업자 명부</h1>
			<!-- title end -->
			

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">수급사업자 명부 입력 안내</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><span>▣ </span>귀사의 본사 및 생산공장이 <font color="#FF0000"><%= nCurrentYear-1%>.1.1 ~ <%= nCurrentYear-1%>.12.31</font> 기간동안 실제로 거래한 수급사업자를 빠짐없이 입력하여 주시기 바랍니다. (단, 여기서 수급사업자란 하도급법상 수급사업자를 말함)</li>
						<li><span>▣ </span>아래 [수급사업자명부 양식 다운받기]에서 파일을 <font color="#FF0000">다운받아 “반드시 저장”한 후 작성</font>하시기 바라며, <br/>작성 완료 후 [수급사업자명부 업로드하기]를 눌러 해당 파일을 전송해 주시기 바랍니다.</li>
						<li><span>※ </span>파일은 반드시 아래에서 다운받은 양식을 사용해야 하며, 귀사에서 임의로 만든 파일양식을 사용하지 말 것<br/> <font color="#FF0000">(자체 파일 업로드시 오류발생)</font></li>
						<li><span>※ </span>업로드 하실 때, 파일명은 "귀사의 회사명.xls"로 해주십시오.(예: 가나다 주식회사.xls,  가나다.xls)</b></li>
						<!--
						<li><span>※ </span><b><font color="#FF0000">수급사업자명부 엑셀파일 내용이 현재 2014년 기준으로 되어있어 현재 수정중이오니 파일을 다운로드 받으신 기업에서는 2015년 기준으로 수정하여 내용을 작성해주시기 바랍니다.</font></b></li>
						<li><span>※ </span><b><font color="#FF0000">빠른 시간내에 업데이트 완료 하겠습니다.</font></b></li>
						-->
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">수급사업자 명부 입력</li>
						<li class="boxcontentsubtitle">* 우측 순서에 따라 작성 하세요.</li>
						<li class="boxcontentsubtitle"">* 올리신 파일을 변경하고자 하실때에는 새로 작성한<br/>
						&nbsp;&nbsp;&nbsp;파일을 다시 "업로드"하시면 자동 변경됩니다.</li>
						<li class="boxcontentsubtitle">* 확장자명은 XLS, XLSX, xls, xlsx<br/>
						&nbsp;&nbsp;&nbsp;네가지만 업로드 하실 수 있습니다.</li>

					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><font style="font-family:nanum,dotum; font-size:14px; font-weight:bold;">Step 1.</font> 수급사업자 명부 Excel 양식 다운로드</li>
						<li><p style="padding-left:60px; width:200px;"><a href="/rsch210726/subcon2021.xls" target="ProceFrame" onfocus="this.blur()" class="contentbutton2">수급사업자 양식 다운로드 받기</a></p></li>
						<li class="fc pt_10"></li>
						<%// 조사마감으로 업로드 버튼 가림 / 20180716 / 김보선%>
						<li><font style="font-family:nanum,dotum; font-size:14px; font-weight:bold;">Step 2.</font> 작성한 수급사업자 명부 업로드</li>
						<li><p style="padding-left:60px; width:200px;"><a href="javascript:sfileup('2')" onfocus="this.blur()" class="contentbutton2">수급사업자 명부 업로드 하기</a></p></li>						 
						<li class="fc pt_10"></li>
						<li><font style="font-family:nanum,dotum; font-size:14px; font-weight:bold;">Step 3.</font> 등록(업로드)한 수급사업자 명부 확인</li>
						<li><p style="padding-left:60px;"><a href="WB_File_Down.jsp"><%=sfile%></a></p></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_20"></div>

			<!-- 버튼 start -->
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">화면 인쇄하기</a></li>
					<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="contentbutton2">5. 조사표 전송으로 가기</a></li>
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

	<%/*-----------------------------------------------------------------------------------------------
	2010년 4월 26일 / iframe 추가 / 정광식
	:: 하도급거래상황 (설문문항) 선택 후 저장 시 오류발생으로 기존정보 소실되는 경우를 방지하기 위해 
	:: 선택사항을 iframe 타겟으로 submit 시킴
	*/%>
	<iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
	<%/*-----------------------------------------------------------------------------------------------*/%>
</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>