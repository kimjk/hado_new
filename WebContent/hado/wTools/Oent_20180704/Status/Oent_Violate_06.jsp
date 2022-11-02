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
	int sStartYear = 2005;

	String sGB = StringUtil.checkNull(request.getParameter("wgb")).trim();

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/

	int currentYear = st_Current_Year_n;
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
			frm.action="Oent_Violate_06_proc.jsp?comm=search";
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
		<jsp:param value="02" name="sel"/>
		</jsp:include>
		<!-- End Main-menu -->

		<!-- Begin Contents -->
		<div id="wrapper">
			<div id="contents">
				<!-- Begin Left-menu -->
				<jsp:include page="/hado/wTools/inc/WB_I_Oent_LMenu.jsp">
				<jsp:param value="037" name="sel"/>
				</jsp:include>
				<!-- End Left-menu -->

				<div id="divContent">
					<div id="searchContent">
						<li class="subtitle">배타적 거래</li>
						<li class="whereiam">HOME > 원사업자 > 조사결과분석 > 배타적 거래</li>
						<p></p>
					</div>	
					<div class="searchbox" id="searchbox">
						<table class="searchboxtable">
						<form action="won.jsp?comm=search" method="post" name="searchform">
							<tr>
								<th>조사년도</th>
								<td>
									<select name="cyear">
										<%for(int xx=sStartYear; xx<=st_Current_Year_n; xx++) {
										String tmpCYear = ""+xx;%>
											<option value="<%=xx%>" <%if( xx==st_Current_Year_n ){%>selected<%}%>><%=xx%>년</option>
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
								<th>거래차수</th>
								<td>
									<select name="tradest">
										<option value="">전체</option>
										<option value="0">원사업자</option>
										<option value="1">1차 협력사</option>
										<option value="2">2차 협력사</option>
										<option value="3">3차 협력사</option>
										<option value="4">거래단계모름</option>
									</select>
								</td>
							</tr>
							</form>
						</table>
						<table class="searchboxtable">
							<tr><td><font style="color:#FF9933;font-size:9pt;">* 거래차수는 2011년 부터 반영되었습니다.</font></td></tr>
						</table>
					</div>
					<div id="divButton">
						<ul class="lt">
							<li class="fr" id="divSrchWindow"><a href="javascript:divSearchWin();" class="sbutton">검색창 가리기</a></li>
							<li class="fr"><a href="javascript:goSearch();" class="sbutton">검 색</a></li>
						</ul>
					</div>

					<div id="divResult">

					</div>

					<div id="divView" onMouseDown="f_DragMDown(this)">
						
					</div>
				</div>
				<iframe src="about:blank" width="1" height="1" id="procFrame" name="procFrame"  style="display:none;"></iframe>
			</div>
		</div>
		<!-- End Contents -->

		<!-- Begin Footer -->
		<%@ include file="/hado/wTools/inc/WB_I_Copyright.jsp"%>
		<!-- End Footer -->
	</div>
</body>
</html>