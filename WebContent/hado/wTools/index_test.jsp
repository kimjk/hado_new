<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명		: 2014년 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: index.jsp
* 프로그램설명	: 내부관리툴 홈
* 프로그램버전	: 3.0.1-2014
* 최초작성일자	: 2014년 09월 24일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-24	정광식       최초작성
*  2014-09-29  강슬기       처리구분 조건검색 추가
*  2015-05-07  강슬기       메인 페이지 증빙서류 처리결과 수정
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>

<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
int sStartYear = 2014;
int currentYear = st_Current_Year_n;
%>

<%
ConnectionResource resource = null;
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String sLoginING = "f";

String SSOcvno = StringUtil.checkNull(request.getParameter("cvno")).trim();

String sCenterName = "";
String sDeptName = "";
String sUserName = "";
String sPhoneNo = "";
String sPermision = "";

// 관리자 안내용 배열
ArrayList arrCenterName = new ArrayList();
ArrayList arrDeptName = new ArrayList();
ArrayList arrUserName = new ArrayList();
ArrayList arrPhoneNo = new ArrayList();

// 검색용 사무소 및 과명 배열
ArrayList arrCenterNm = new ArrayList();
ArrayList arrDeptNm = new ArrayList();

// 처리구분 배열
ArrayList arrCheckNm = new ArrayList();

if( SSOcvno == null || SSOcvno.equals("") ) {
	if( session.getAttribute("ckSSOcvno")!=null )
	{
		SSOcvno = ""+session.getAttribute("ckSSOcvno");
	}
}

if( SSOcvno != null && (!SSOcvno.equals("")) ) {
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		StringBuffer sbSQLs = new StringBuffer();
		
		sbSQLs.append("SELECT * \n");
		sbSQLs.append("FROM HADO_TB_FTC_USER \n");
		sbSQLs.append("WHERE CVSNO=?");

		pstmt = conn.prepareStatement(sbSQLs.toString());
		pstmt.setString(1,SSOcvno);
		rs = pstmt.executeQuery();

		while(rs.next()) {
			sCenterName = new String(StringUtil.checkNull(rs.getString("CENTER_NAME")).trim().getBytes("ISO8859-1"), "utf-8" );
			sDeptName = new String(StringUtil.checkNull(rs.getString("DEPT_NAME")).trim().getBytes("ISO8859-1"), "utf-8" );
			sUserName = new String(StringUtil.checkNull(rs.getString("USER_NAME")).trim().getBytes("ISO8859-1"), "utf-8" );
			sPhoneNo = StringUtil.checkNull(rs.getString("PHONE_NO")).trim();
			sPermision = StringUtil.checkNull(rs.getString("PERMISION")).trim();

			session.setAttribute("ckSSOcvno",SSOcvno+"");
			session.setAttribute("ckCenterName",sCenterName+"");
			session.setAttribute("ckDeptName",sDeptName+"");
			session.setAttribute("ckUserName",sUserName+"");
			session.setAttribute("ckPhoneNo",sPhoneNo+"");
			session.setAttribute("ckPermision",sPermision+"");

			sLoginING = "t";
		}
		rs.close();
	} catch(Exception e){
		e.printStackTrace();
	}
	finally {
		if ( rs != null ) try{rs.close();}catch(Exception e){}
		if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
		if ( conn != null ) try{conn.close();}catch(Exception e){}
		if ( resource != null ) resource.release();
	}

		// 로그인 실패시 담당자 정보 가져오기
	if( sLoginING.equals("f") ) {
		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();

			StringBuffer sbSQLs = new StringBuffer();
			
			sbSQLs.append("SELECT * \n");
			sbSQLs.append("FROM HADO_TB_FTC_USER \n");
			sbSQLs.append("WHERE Permision='M' \n");
			sbSQLs.append("ORDER BY CVSNO");

			pstmt = conn.prepareStatement(sbSQLs.toString());
			rs = pstmt.executeQuery();

			while( rs.next() ) {
				arrCenterName.add( new String( StringUtil.checkNull(rs.getString("Center_Name")).trim().getBytes("ISO8859-1"), "utf-8" ) );
				arrDeptName.add( new String( StringUtil.checkNull(rs.getString("Dept_Name")).trim().getBytes("ISO8859-1"), "utf-8" ) );
				arrUserName.add( new String( StringUtil.checkNull(rs.getString("User_Name")).trim().getBytes("ISO8859-1"), "utf-8" ) );
				arrPhoneNo.add( new String( StringUtil.checkNull(rs.getString("Phone_No")).trim().getBytes("ISO8859-1"), "utf-8" ) );
			}
			rs.close();
		} catch(Exception e){
			e.printStackTrace();
		}
		finally {
			if ( rs != null ) try{rs.close();}catch(Exception e){}
			if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
			if ( conn != null ) try{conn.close();}catch(Exception e){}
			if ( resource != null ) resource.release();
		}
	} else {	// 로그인 성공시에만 데이타 참조
		/* 검색에 필요한 담당사무소 및 담당과 배열 */
		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();

			StringBuffer sbSQLs = new StringBuffer();

			sbSQLs.append("SELECT center_name, dept_name \n");
			sbSQLs.append("FROM hado_tb_ftc_user \n");
			sbSQLs.append("GROUP BY center_name, dept_name \n");
			sbSQLs.append("ORDER BY center_name, dept_name \n");

			pstmt = conn.prepareStatement(sbSQLs.toString());
			rs = pstmt.executeQuery();

			while( rs.next() ) {
				arrCenterNm.add( new String( StringUtil.checkNull(rs.getString("center_name")).trim().getBytes("ISO8859-1"), "utf-8" ) );
				arrDeptNm.add( new String( StringUtil.checkNull(rs.getString("dept_name")).trim().getBytes("ISO8859-1"), "utf-8" ) );
			}
			rs.close();
		} catch(Exception e){
			e.printStackTrace();
		}
		finally {
			if ( rs != null ) try{rs.close();}catch(Exception e){}
			if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
			if ( conn != null ) try{conn.close();}catch(Exception e){}
			if ( resource != null ) resource.release();
		}
	}
} else {
	sLoginING = "f";
}
%>

<html>
<head>
	<title>【관리】하도급거래 서면실태조사</title>
	<link rel="stylesheet" href="/hado/hado/wTools/style.css" type="text/css">
	<script type="text/javascript">
		var arrCenterNm = new Array();
		var arrDeptNm = new Array();
		
		<%
		for(int i=0; i<arrCenterNm.size(); i++) {
			out.print("arrCenterNm[" + i + "] = \"" + arrCenterNm.get(i).toString() + "\";");
			out.print("arrDeptNm[" + i + "] = \"" + arrDeptNm.get(i).toString() + "\";");
		}%>

		function deptsel() {
		
			var obj1 = document.getElementById("mcenternm");
			var obj2 = document.getElementById("mdeptname");

			initDeptNm();

			chval = obj1.options[obj1.selectedIndex].value;
			obj2.add(new Option("전체","",true,true));

			for(i=0; i<arrCenterNm.length; i++) {
				if( arrCenterNm[i]==chval ) obj2.add(new Option(arrDeptNm[i],arrDeptNm[i],false,false));
			}
			
			obj2.reInitializeSelectBox();
		}

		function initDeptNm() {
			var obj = document.getElementById("mdeptname");
			for(i=0; i<100; i++) obj.options[0]=null;
		}

		function onDocument() {
			goSearch();
		}

		function goSearch() {
			document.searchform.target = "procFrame";
			document.searchform.action="Oent/Oent_Comp_Status_PList.jsp";
			document.searchform.submit();
		}

		function pmove(val)
		{
			if(val!="") {
				var frm = document.searchform;

				frm.target="procFrame";
				frm.action=val;
				frm.submit();
			}
		}

		function submitProc(mno, cyear, ogb) {
			if( mno!="" && cyear!="" && ogb!="" ) {
				url = "Oent/Oent_Comp_Status_Proc.jsp?mno=" + mno + "&cyear=" + cyear + "&ogb=" + ogb;
				HelpWindow2(url,600,650);
			} else {
				alert("오류 : 필수전달인수를 받지 못했습니다.");
			}
		}

		function HelpWindow2(url, w, h)
		{
			helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
			helpwindow.focus();
		}

	</script>
</head>

<body onLoad="onDocument();">
<%if(sLoginING.equals("t")) {%>
	<div id="container">
		<!-- Begin Header -->
		<%@ include file="/hado/wTools/inc/WB_I_pageTop.jsp"%>
		<!-- End Header -->
		
		<!-- Begin Main-menu -->
		<jsp:include page="/hado/wTools/inc/WB_I_topMenu.jsp">
		<jsp:param value="01" name="sel"/>
		</jsp:include>
		<!-- End Main-menu -->

		<!-- Begin Contents -->
		<div id="wrapper">
			<div id="contents">
			<%
			if( sLoginING.equals("t") ) { %>
				<div id="mcompstat">
					<!-- 2015-05-07 / 연도별 제목 수정 / 강슬기 -->
					<span class="subtitle" style="padding:5px;">○ 조사년도별 원사업자 증빙서류 처리 현황</span>
					<div class="searchbox_comp" id="searchbox">
						<table class="searchboxtable">
						<form action="Oent/Oent_Comp_Status_PList.jsp?page=1" method="post" name="searchform">
							<!-- 2015-05-07 / 조사년도 항목 추가 / 강슬기 -->
							<tr>
								<th>조사년도</th>
								<td>
									<%
									// 2015-05-08 / 정광식 / 전체검색 삭제 및 객체 name, id 변경
									%>
									<select name="currentYear" id="currentYear">
										<%
										for(int i=sStartYear; i<=st_Current_Year_n; i++) {
										%>
											<option value="<%=i%>" <%if( i==st_Current_Year_n ){%>selected<%}%>><%=i%>년</option>
										<%}%>
									</select>
								</td>
								<th>담당사무소</th>
								<td>
									<%
									if( sPermision.equals("T") || sPermision.equals("M") ) {%>
									<select name="mcenternm" id="mcenternm" onchange="deptsel();">
										<option value="">전체</option>
										<%
										String sTmpCenter = "";
										for(int i=0; i<arrCenterNm.size(); i++) { 
											if( !sTmpCenter.equals(arrCenterNm.get(i).toString()) ) {%>
										<option value="<%=arrCenterNm.get(i)%>" <%if( sCenterName.equals(arrCenterNm.get(i).toString()) ) {%>selected<%}%>><%=arrCenterNm.get(i)%></option>
										<%
												sTmpCenter = arrCenterNm.get(i).toString();
											}
										}
									} else { // 일반 담당자인 경우 해당 사무소만 출력%>
										<select name="mcenternm" id="mcenternm">
											<option value="<%=sCenterName%>"><%=sCenterName%></option>
										</select>
									<%
									}%>
									</select>
								</td>
							</tr>
							<tr>
								<th>담당과명</th>
								<td>
									<%
									if( sPermision.equals("T") || sPermision.equals("M") ) {%>
									<select name="mdeptname" id="mdeptname">
										<option value="">전체</option>
										<%
										for(int i=0; i<arrDeptNm.size(); i++) {
											if( sCenterName.equals(arrCenterNm.get(i).toString()) ) {%>
											<option value="<%=arrDeptNm.get(i).toString()%>" <%if( sDeptName.equals(arrDeptNm.get(i).toString()) ) {%>selected<%}%>><%=arrDeptNm.get(i).toString()%></option>
										<%
											}
										}%>
									</select>
									<%
									} else { // 일반 담당자인 경우 해당 과만 출력%>
										<select name="mdeptname" id="mdeptname">
											<option value="<%=sDeptName%>"><%=sDeptName%></option>
										</select>
									<%
									}%>
								</td>
								<th>처리구분</th>
								<td>
									<select name="mproccd" id="mproccd">
										<option value="">전체</option>
										<option value="1">승인</option>
										<option value="2">반려</option>
										<option value="3">미처리</option>
									</select>
								</td>
								<td>
									<ul class="lt">
										<li class="fr"><a href="javascript:goSearch();" class="sbutton">검 색</a></li>
									</ul>
								</td>
							</form>
						</table>
					</div>

					<div id="divResult">
						
					</div>
				</div>
			<%
			}%>
			</div>
		</div>
		<!-- End Contents -->

		<!-- Begin Footer -->
		<%@ include file="/hado/wTools/inc/WB_I_Copyright.jsp"%>
		<!-- End Footer -->
	</div>
<%} else {%>
	<div id="notLoginInfo">
		<ul class="oline4">
			<li class="errif">사용권한이 없습니다.</li>
			<li class="errif">하도급거래 서면실태조사 관리자에게 문의하세요.</li>
			<li class="errif">&nbsp;</li>
			<%if( arrCenterName.size()>0 ) {%>
				<li class="errifc">
					<ul>
			<%	for(int j=0; j<arrCenterName.size(); j++) {
					out.print( "<li class=errifc>"+arrCenterName.get(j)+"/"+arrDeptName.get(j)+" "+arrUserName.get(j)+" ("+arrPhoneNo.get(j)+")</li>");
				}
			%>
					</ul>
				</li>
				<li class="errif">&nbsp;</li>
			<%}%>
			<li class="errif"><a href="javascript:self.close();" class="closebutton" /></li>
		</ul>
	</div>
<%}%>

	<iframe src="about:blank" width="1" height="1" id="procFrame" name="procFrame" style="display:none;"></iframe>

</body>
</html>