<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/**
프로젝트명		: 2015년 공정거래위원회 하도급거래 서면실태조사
프로그램명		: Add_Submit_Search.jsp	
프로그램설명	: 신규제도관련 설문조사 제출업체 검색 페이지
프로그램버전	: 1.0.0
최초작성일자	: 2015년 07월 22일
---------------------------------------------------------------------------------------
	작성일자		작성자명				내용	
---------------------------------------------------------------------------------------
	2014-07-22	강슬기	최초작성
*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/

	// 제조 업종배열
	ArrayList arrDCode = new ArrayList();
	ArrayList arrDName = new ArrayList();
	// 건설 업종배열
	ArrayList arrCCode = new ArrayList();
	ArrayList arrCName = new ArrayList();
	// 용역 업종배열
	ArrayList arrSrvCode = new ArrayList();
	ArrayList arrSrvName = new ArrayList();
	// 담당자 배열
	ArrayList arrDeptSeq = new ArrayList();
	ArrayList arrDeptCode = new ArrayList();
	ArrayList arrDamName = new ArrayList();


	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	int sStartYear = 2015;

	int i = 0;
	int gesu = 0;

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/

	int currentYear = st_Current_Year_n;
	
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		StringBuffer sbSQLs1 = new StringBuffer();

		sbSQLs1.append("SELECT COMMON_CD, COMMON_NM \n");
		sbSQLs1.append("FROM COMMON_CD \n");
		sbSQLs1.append("WHERE ADDON_GB=?");
		
		// 제조 업종 배열 생성
		pstmt = conn.prepareStatement(sbSQLs1.toString());
		pstmt.setString(1,"1");
		rs = pstmt.executeQuery();

		while (rs.next()) {
			arrDCode.add(StringUtil.checkNull(rs.getString("COMMON_CD")).trim());
			arrDName.add(new String( StringUtil.checkNull(rs.getString("COMMON_NM")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
		}
		rs.close();

		// 건설 업종 배열 생성
		pstmt = conn.prepareStatement(sbSQLs1.toString());
		pstmt.setString(1,"2");
		rs = pstmt.executeQuery(); 
		
		while (rs.next()) {
			arrCCode.add(StringUtil.checkNull(rs.getString("COMMON_CD")).trim());
			arrCName.add(new String( StringUtil.checkNull(rs.getString("COMMON_NM")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
		}
		rs.close();

		// 용역 업종 배열 생성
		pstmt = conn.prepareStatement(sbSQLs1.toString());
		pstmt.setString(1,"3");
		rs = pstmt.executeQuery();	  

		while (rs.next()) {
			arrSrvCode.add(StringUtil.checkNull(rs.getString("COMMON_CD")).trim());
			arrSrvName.add(new String(StringUtil.checkNull(rs.getString("COMMON_NM")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
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

	var dcd=new Array();
	var dnm=new Array();
	<%
	for(i=0; i<arrDCode.size(); i++) {
		out.print("dcd["+i+"]='"+arrDCode.get(i)+"';");
		out.print("dnm["+i+"]='"+arrDName.get(i)+"';");
	}
	%>	
	var ccd=new Array();
	var cnm=new Array();
	<%
	for(i=0; i<arrCCode.size(); i++) {
		out.print("ccd["+i+"]='"+arrCCode.get(i)+"';");
		out.print("cnm["+i+"]='"+arrCName.get(i)+"';");
	}
	%>	

	var srvcd=new Array();
	var srvnm=new Array();
	<%
	for(i=0; i<arrSrvCode.size(); i++) {
		out.print("srvcd["+i+"]='"+arrSrvCode.get(i)+"';");
		out.print("srvnm["+i+"]='"+arrSrvName.get(i)+"';");
	}
	%>	

	var dseq=new Array();
	var dcode=new Array();
	var dname=new Array();
	<%
	for(i=0; i<arrDeptSeq.size(); i++) {
		out.print("dseq["+i+"]='"+arrDeptSeq.get(i)+"';");
		out.print("dcode["+i+"]='"+arrDeptCode.get(i)+"';");
		out.print("dname["+i+"]='"+arrDamName.get(i)+"';");
	}
	%>

	function deptsel() {
		var obj1 = document.getElementById("mareacode");
		var obj2 = document.getElementById("mdeptname");

		initsel2();

		chval = obj1.options[obj1.selectedIndex].value;
		obj2.add(new Option("전체","",true,true));

		for(i=0; i<dseq.length; i++) {
			if( dcode[i]==chval ) obj2.add(new Option(dname[i],dseq[i],false,false));
		}
		
		obj2.reInitializeSelectBox();
	}

	function initsel2() {
		var obj = document.getElementById("mdeptname");
		for(i=0; i<100; i++) obj.options[0]=null;
	}
			
	function gbsel() {
		var obj1 = document.getElementById("wgb");
		var obj2 = document.getElementById("sgb");

		initsel();

		switch(obj1.selectedIndex) {
			case 1:
				obj2.add(new Option("전체","",true,true));
				for(i=0; i<dcd.length; i++) {
					obj2.add(new Option(dnm[i],dcd[i],false,false));
				}
				break;
			case 2:
				obj2.add(new Option("전체","",true,true));
				for(i=0; i<ccd.length; i++) {
					obj2.add(new Option(cnm[i],ccd[i],false,false));
				}
				break;
			case 3:
				obj2.add(new Option("전체","",true,true));
				for(i=0; i<srvcd.length; i++) {
					obj2.add(new Option(srvnm[i],srvcd[i],false,false));
				}
				break;
		}

		obj2.reInitializeSelectBox();
	}

	function initsel() {
		var obj = document.getElementById("sgb");

		for(i=0; i<100; i++) obj.options[0]=null;
	}

	function goSearch()
	{
		var frm = document.searchform;
		msg = "";

		if(nNowProcess == 0) {
			frm.target="procFrame";
			frm.action="Add_Submit_Search_proc.jsp?comm=search";
			frm.submit();
			nNowProcess = 1;
			bodyhidden();
		} else {
			alert("현재 프로세스가 실행중입니다.\n\n잠시 후 다시 실행해 주세요.");
		}
	}

	function pmove(val)
	{
		if(val!="") {
			var frm = document.searchform;

			frm.target="procFrame";
			frm.action=val;
			frm.submit();
			nNowProcess = 1;
			bodyhidden();
		}
	}

	function entsub(event,form) 
	{
		if (window.event && window.event.keyCode == 13)
		{
			goSearch();
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

	function view(mno,cyear,ogb)
	{
		window.open("/hado/hado/rsch150706/WB_VP_Subcon_Add.jsp?mno="+mno+"&cyear="+cyear+"&wgb="+ogb);
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
		<jsp:param value="08" name="sel"/>
		</jsp:include>
		<!-- End Main-menu -->

		<!-- Begin Contents -->
		<div id="wrapper">
			<div id="contents">
				<!-- Begin Left-menu -->
				<jsp:include page="/hado/wTools/inc/WB_I_poll_LMenu.jsp">
				<jsp:param value="005" name="sel"/>
				</jsp:include>
				<!-- End Left-menu -->

				<div id="divContent">
					<div id="searchContent">
						<li class="subtitle">신규제도관련 설문조사</li>
						<li class="whereiam">HOME > 기타 조사 > 신규제도관련 설문조사 > 응답업체조회</li>
						<p></p>
					</div>	
					<div class="searchbox" id="searchbox">
						<table class="searchboxtable">
						<form action="Add_Submit_Search.jsp?comm=search" method="post" name="searchform">
							<tr>
								<th>조사년도</th>
								<td>
									<select name="cyear">
										<option value="0">전체조사년도</option>
										<%for(int xx=2015; xx<=st_Current_Year_n; xx++) {
										String tmpCYear = ""+xx;%>
											<option value="<%=xx%>" <%if( xx==st_Current_Year_n ){%>selected<%}%>><%=xx%>년</option>
										<%}%>
									</select>
								</td>
								<th>수급사업자명</th>
								<td><input type="text" name="scomp" value="" size="25" onKeyPress="return entsub(event,this.form)" class="s_input"></td>
								<th>(수)관리번호</th>
								<td><input type="text" name="unitid" value="" size="10" onKeyPress="return entsub(event,this.form)" class="s_input"></td>
							</tr>
							<tr>
								<th>업종</th>
								<td>
									<select name="wgb" id="wgb" onchange="gbsel();">
										<option value="">전체</option>
										<option value="1">제조</option>
										<option value="2">건설</option>
										<option value="3">용역</option>
									</select>
								</td>
								<th>출력수</th>
								<td>
									<select name="mpagesize">
										<option value="10">10개씩 출력</option>
										<option value="20">20개씩 출력</option>
										<option value="30">30개씩 출력</option>
										<option value="40">40개씩 출력</option>
										<option value="50">50개씩 출력</option>
										<option value="100">100개씩 출력</option>
									</select>
								</td>
								<th>정렬방법</th>
								<td>
									<select name="ssort">
										<option value="">없음</option>
										<option value="1">사업자명</option>
										<!--<option value="2">시공액</option>-->
										<!--<option value="4">매출액</option>-->
										<option value="3">관리번호</option>
									</select>
								</td>
							</tr>
							</form>
						</table>
					</div>
					<div id="divButton">
						<ul class="lt">
							<li class="fr" id="divSrchWindow"><a href="javascript:divSearchWin();" class="sbutton">검색창 가리기</a></li>
							<li class="fr"><a href="javascript:document.searchform.reset();" class="sbutton">검색 초기화</a></li>
							<li class="fr"><a href="javascript:goSearch();" class="sbutton">검 색</a></li>
						</ul>
					</div>

					<div id="divResult">

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