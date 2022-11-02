<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 2015년 수급사업자 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_VP_Subcon_Add.jsp
* 프로그램설명	: 수급사업자 > 년도별 조사표 > 2015년 업종별 조사표 > 신규제도관련 설문조사
* 프로그램버전	: 3.0.1
* 최초작성일자	: 2015년 07월 21일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2015-07-21	강슬기       최초작성
*	2016-01-12	이용광		DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_I_Global.jsp"%>
<%@ include file="../Include/WB_I_chkSession.jsp" %>

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

/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/

	if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
		ConnectionResource resource	= null;
		Connection conn				= null;
		PreparedStatement pstmt		= null;
		ResultSet rs				= null;

		sSQLs="SELECT sent_sa_no, sent_status, sp_fld_03 FROM HADO_TB_Subcon_"+sOentYYYY+" \n";
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
		
		f2 = "yes";

		int gesu = 0;

        // sentCheck 제외대상 여부 (sentCheck 값이 있으면 제외대상)
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

    // 추가 설문 조건 
    // sentStatus 전송완료가 1 이고 , fall = no, f3 = yes
    String addTypeSatus = "";
    
    if("1".equals(sentStatus) && "no".equals(fall) && "yes".equals(f3)){
        addTypeSatus = "Y";
    }else{
        addTypeSatus = "N";
    }

/*=====================================================================================================*/
%>
<% st_Current_Year_n = Integer.parseInt(sOentYYYY); %>
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
    <title><%=st_Current_Year_n %>년도 하도급거래 서면실태 조사</title>

	<link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="euc-kr" />
	<% if (q_Cmd.equals("print")) { %>
	<link rel="stylesheet" href="style_print.css" type="text/css"/>
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
		function savef(type, id){
		    if(type == 'N'){
		        alert("귀사는 앞선 하도급거래 실태조사의 조사표 전송까지\n완료해주셔야 해당 설문에 참여 가능 합니다. \n일반현황 및 하도급거래 현황에 해당되는 실태조사 \n먼저 참여해 주시기 바랍니다.");
		    }else{
		        var url = "https://isurvey.panel.co.kr/?Alias=7544256404&panel_id="+ id
		    	window.open(url); 
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
				<li class="fl"><a href="/" onfocus="this.blur()"><img src="img/logo.jpg" width="242" height="55" /></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"><font color="#FF6600">[
							<% if( ckOentGB.equals("1") ) {%>제조업
							<% } else if( ckOentGB.equals("2") ) {%>건설업
							<% } else if( ckOentGB.equals("3") ) {%>용역업<% } %>]</font>
							<%=ckOentName%>&nbsp;/&nbsp;<%=ckSentName%><iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" style="vertical-align: text-bottom;" frameborder="0"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="./WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="mainmenu">1. 조사안내</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. 귀사의 일반현황</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. 하도급 거래 현황</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="mainmenu">4. 조사표 전송</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_Add.jsp" onfocus="this.blur()" class="mainmenuup">5. 추가 설문</a></li>
			</ul>
		</div>
		<!-- End Header -->

		<form action="" method="post" name="info">
		<!-- Begin subcontent -->
		<div id="subcontent">
			<!-- title start -->
			<h1 class="contenttitle">5. 추가 설문</h1>
			<!-- title end -->

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">◇ 납품단가 반영 실태 조사</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li>최근 원자재 가격 상승으로 인한 중소기업계의 애로사항을 파악하고 하도급업체에게 실질적인 납품단가 조정협의 기회를 보장하기 위해 운용 중인 
                            <strong><u>납품단가조정협의제도의 실효성 및 보완대책</u></strong>을 마련하기 위한 기초 자료로 활용하고자 「납품단가 반영실태 및 애로사항 조사」를 실시하려고 합니다. 본 설문의 내용은 <strong><u>제도개선을 위한 조사통계자료로서만 활용</u></strong>할 계획임을 알려드리오니 적극적인 협조를 부탁드립니다.</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_2"></div>
      
            <div class="boxcontent2">
              <ul class="boxcontenthelp lt" style="padding-left:20px;">
                  <li class="boxcontenttitle"><img src="./img/event_20210915.jpg" border="0" style="width:930px; height:650px;"/></li>
              </ul>
            </div>

			<!-- 버튼 start -->
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="javascript:savef('<%=addTypeSatus %>', '<%=ckMngNo %>');" onfocus="this.blur()" class="contentbutton2">추가 설문  참여하기</a></li>
				</ul>
			</div>
			<!-- 버튼 end -->

			<div class="fc pt_20"></div>
			
			<div class="boxcontent3" >
				<ul class="boxcontenthelp2 lt" style="display:none;">
					<li class="noneboxcontenttitle"><p align="center"><img src="/img/img.gif" border="0" /></p></li>
				</ul>
			</div>

		</div>
		</form>
		<!-- End subcontent  -->

		<!-- Begin Footer -->
		<div id="subfooter"><img src="img/bottom.gif" /></div>
		<!-- End Footer -->

	</div>
</div>
</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>