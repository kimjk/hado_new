<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
/*  1. 프로젝트명 : 공정관리위원회 하도급거래 서면직권실태조사					                       */
/*  2. 업체정보 :																					   */
/*     - 업체명 : (주)로티스아이																	   */
/*	   - Project Manamger : 정광식 부장 (pcxman99@naver.com)										   */
/*     - 연락처 : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  3. 일자 : 2009년 5월																			   */
/*  4. 최초작성자 및 일자 : (주)로티스아이 정광식 / 2011-10-18										   */
/*  5. 업데이트내용 (내용 / 일자)																	   */
/*  6. 비고																							   */
/*		1) 웹관리툴 리뉴얼 / 2011-10-18																   */
/*-----------------------------------------------------------------------------------------------------*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String tt = StringUtil.checkNull(request.getParameter("tt"));
	String comm = StringUtil.checkNull(request.getParameter("comm"));

	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	String sSQLs = "";

	// 건설 업종배열
	ArrayList arrCCode = new ArrayList();
	ArrayList arrCName = new ArrayList();

	int sStartYear = 2007;
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	String tmpYear = StringUtil.checkNull(request.getParameter("cyear")).trim();
	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
	}

	if( tt.equals("start") ) {
		session.setAttribute("sgb", "");
		session.setAttribute("wgb", "2");
		session.setAttribute("violatecomp", "");
		session.setAttribute("violatecompno", "");
	}
	if( comm.equals("search") ) {
		session.setAttribute("sgb", StringUtil.checkNull(request.getParameter("sgb")).trim());
		session.setAttribute("wgb", StringUtil.checkNull(request.getParameter("wgb")).trim());
		session.setAttribute("violatecomp", StringUtil.checkNull(request.getParameter("violatecomp")).trim());
		session.setAttribute("violatecompno", StringUtil.checkNull(request.getParameter("violatecompno")).trim());
	}

	int currentYear = st_Current_Year_n;
	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		// 건설 업종 배열 생성
		sSQLs ="SELECT COMMON_CD, COMMON_NM FROM COMMON_CD \n";
		sSQLs+="WHERE ADDON_GB='2' \n";
		sSQLs+="	AND Common_CD IS NOT NULL \n";

		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();

		while (rs.next()) {
			arrCCode.add(StringUtil.checkNull(rs.getString("COMMON_CD")).trim());
			arrCName.add(new String( StringUtil.checkNull(rs.getString("COMMON_NM")).trim().getBytes("ISO8859-1"), "utf-8" ));
		}
		rs.close();
	}
	catch(Exception e){
		e.printStackTrace();
	}
	finally {
		if ( rs != null ) try{rs.close();}catch(Exception e){}
		if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
		if ( conn != null ) try{conn.close();}catch(Exception e){}
		if ( resource != null ) resource.release();
	}
/*=====================================================================================================*/
%>
<%!
public String isselected(String str1, String str2){
	String sReturnStr = "";

	if(str1 != null && str2 != null && str1.equals(str2) ) {
		sReturnStr = " selected";
	}
	return sReturnStr;
}
%>

<html>
<head>
	<title>【관리】하도급거래 서면실태조사</title>
	<link rel="stylesheet" href="/hado/hado/wTools/style.css" type="text/css">
</head>
<script language="javascript" type="text/javascript" src="/hado/hado/wTools/inc/ajax_layer.js"></script>
<script language="javascript" type="text/javascript" src="/hado/hado/wTools/inc/common_script.js"></script>
<script language="JavaScript">
	nNowProcess = 0;

	function setNowProcessFalse()
	{
		nNowProcess = 0;
		bodyview();
	}

	function goSearch()
	{
		var frm = document.searchform;
		msg = "";

		if(nNowProcess == 0) {
			frm.target="procFrame";
			frm.action="SOent_Violate_29_proc.jsp?comm=search";
			frm.submit();
			nNowProcess = 1;
			bodyhidden();
		} else {
			alert("현재 프로세스가 실행중입니다.\n\n잠시 후 다시 실행해 주세요.");
		}
	}

	var sSearchWin = "0";
	function divSearchWin()
	{
		obj = document.getElementById("searchbox");
		wobj = document.getElementById("divSrchWindow");

		if( sSearchWin =="0" ) {
			obj.style.display = 'none';
			wobj.innerHTML = "<a href='javascript:divSearchWin();' class='sbutton'>검색창 펼치기</a>";
			sSearchWin = "1";
		} else {
			obj.style.display = '';
			wobj.innerHTML = "<a href='javascript:divSearchWin();' class='sbutton'>검색창 가리기</a>";
			sSearchWin = "0";
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
		<jsp:param value="03" name="sel"/>
		</jsp:include>
		<!-- End Main-menu -->

		<!-- Begin Contents -->
		<div id="wrapper">
			<div id="contents">
				<!-- Begin Left-menu -->
				<jsp:include page="/hado/wTools/inc/WB_I_SOent_LMenu.jsp">
				<jsp:param value="092" name="sel"/>
				</jsp:include>
				<!-- End Left-menu -->

				<div id="divContent">
					<div id="searchContent">
						<li class="subtitle">[단독]건설업 위반행위 유형별 현황</li>
						<li class="whereiam">HOME > 수급사업자 > 조사결과분석 > [단독]건설업 위반행위 유형별 현황</li>
						<p></p>
					</div>
					<div class="searchbox" id="searchbox">
						<table class="searchboxtable">
						<form action="" method="post" name="searchform">
							<tr>
								<th>조사년도</th>
								<td colspan="5">
									<select name="cyear">
										<%for(int xx=sStartYear; xx<=st_Current_Year_n; xx++) {
										String tmpCYear = ""+xx;%>
											<option value="<%=xx%>" <%if( xx==st_Current_Year_n ){%>selected<%}%>><%=xx%>년</option>
										<%}%>
									</select>
								</td>
							</tr>
							</form>
						</table>
					</div>
					<div id="divButton">
						<ul class="lt">
							<li class="fr" id="divSrchWindow"><a href="javascript:divSearchWin();" class="sbutton">검색창 가리기</a></li>
							<li class="fr"><a href="javascript:goSearch();" class="sbutton">검 색</a></li>
						</ul>
					</div>

					<div id="divResult" style="position:absolute;top:145px;z-index:59;background-color:#ffffff;">

					</div>

					<div id="divView" onMouseDown="f_DragMDown(this)">

					</div>
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
