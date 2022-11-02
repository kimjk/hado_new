<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명	 : 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명	 : SOent_Violate_59.jsp
* 프로그램설명	: 수급사업자 > 조사결과분석 > 하도급대금 감액 사유
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2015년 09월 01일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2015-09-01	강슬기       페이지 최신화(주석, 불필요한 코드 제거, 오래된 코드 수정)
*   2016-01-07   이용광        DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="java.text.DecimalFormat"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>
<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String tt = request.getParameter("tt")==null? "":request.getParameter("tt").trim();
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();
	String sGB = request.getParameter("wgb")==null ? "":request.getParameter("wgb").trim();

	int sStartYear=2014;
	int endCurrentYear=st_Current_Year_n;
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	String tmpYear = request.getParameter("cyear")==null? "":request.getParameter("cyear").trim();
	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
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
	<meta charset="utf-8">
	<script language="javascript" type="text/javascript" src="/hado/hado/wTools/inc/ajax_layer.js"></script>
	<script language="javascript" type="text/javascript" src="/hado/hado/wTools/inc/common_script.js"></script>
	<script type="text/javascript">
	//<![CDATA[
		nNowProcess = 0;

		function setNowProcessFalse() {
			nNowProcess = 0;
			bodyview();
		}

		function goSearch() {
			var frm = document.searchform;
			msg = "";

			if(nNowProcess == 0) {
				frm.target="procFrame";
				frm.action="SOent_Violate_59_proc.jsp?comm=search";
				frm.submit();
				nNowProcess = 1;
				bodyhidden();
			} else {
				alert("현재 프로세스가 실행중입니다.\n\n잠시 후 다시 실행해 주세요.");
			}
		}

		var sSearchWin = "0";
		function divSearchWin() {
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
	//]]
	</script>
</head>
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
				<jsp:param value="055" name="sel"/>
				</jsp:include>
				<!-- End Left-menu -->

				<div id="divContent">
					<div id="searchContent">
						<li class="subtitle">하도급대금 감액 사유</li>
						<li class="whereiam">HOME > 수급사업자 > 조사결과분석 > 하도급대금 감액 사유</li>
						<p></p>
					</div>
					<div class="searchbox" id="searchbox">
						<table class="searchboxtable">
						<form action="" method="post" name="searchform">
							<tr>
								<th>조사년도</th>
								<td>
									<select name="cyear">
										<%for(int xx=sStartYear; xx<=endCurrentYear; xx++) {
										String tmpCYear = ""+xx;%>
											<option value="<%=xx%>" <%if( xx==endCurrentYear ){%>selected<%}%>><%=xx%>년</option>
										<%}%>
									</select>
								</td>
								<th>원사업자구분</th>
								<td>
									<select name="wgb">
										<option value="">전체</option>
										<option value="1" <%=isselected("1",sGB)%>>제조</option>
										<option value="2" <%=isselected("2",sGB)%>>건설</option>
										<option value="3" <%=isselected("3",sGB)%>>용역</option>
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

					<div id="divView" onMouseDown="f_DragMDown(this)" style="z-index:61;">

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
