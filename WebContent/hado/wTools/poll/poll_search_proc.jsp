<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/*=======================================================*/
/* 프로젝트명		: 2014년 공정거래위원회 하도급거래 서면실태조사					      */
/* 프로그램명		: poll_search.jsp													  */
/* 프로그램설명	: 설문 집계 프로세스													  */
/* 프로그램버전	: 1.0.0																	  */
/* 최초작성일자	: 2014년 07월 07일													      */
/*--------------------------------------------------------------------------------------- */
/*	작성일자		작성자명				내용
/*--------------------------------------------------------------------------------------- */
/*	2014-07-07	강슬기	최초작성														  */			
/*=======================================================*/

/* Variable Difinition Start ======================================*/

// 리스트 배열

ArrayList arrPollID = new ArrayList();			// 설문번호
ArrayList arrAcceptNO = new ArrayList();		// 접수번호
ArrayList arrSentType = new ArrayList();		// 업종
ArrayList arrBussTermYear = new ArrayList();	// 사업기간
ArrayList arrAreaCD = new ArrayList();			// 지역구분
ArrayList arrSubconStep = new ArrayList();	// 거래단계
ArrayList arrDetailTypeCD = new ArrayList();	// 세부업종(제조)
ArrayList arrSentSale = new ArrayList();		// 매출액
ArrayList arrSentEmpCnt = new ArrayList();	// 상시종업원수
ArrayList arrSentCapaCD = new ArrayList();	// 기업규모

String sCmd = request.getParameter("cmd")==null ? "":request.getParameter("cmd").trim();

ConnectionResource resource = null;
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String sSQLs = "";
	
int nRowSizes = 70;

// Paging module
int nPageSize = 10;
String sTmpPageSize = request.getParameter("mpagesize")==null ? "10":request.getParameter("mpagesize").trim();
if( sTmpPageSize != null && (!sTmpPageSize.equals("")) ) {
	nPageSize = Integer.parseInt(sTmpPageSize);		session.setAttribute("pagecnt",sTmpPageSize);
} else {		String sTmpPages = session.getAttribute("pagecnt").toString();
	if( sTmpPages != null && (!sTmpPages.equals("")) ) {
		nPageSize = Integer.parseInt(sTmpPages);			session.setAttribute("pagecnt",sTmpPages);
	} else {
		nPageSize = 10;
	}
}
int nPage = 1;
int nMaxPage = 1;
int nRecordCount = 0;
String sTmpPage = request.getParameter("page")==null ? "1":request.getParameter("page").trim();
if( sTmpPage != null && (!sTmpPage.equals("")) ) {
	nPage = Integer.parseInt(sTmpPage);
	session.setAttribute("page", sTmpPage);
} else {
	String sTmpPages = session.getAttribute("page").toString();
	if( sTmpPages != null && (!sTmpPages.equals("")) ) {
		nPage = Integer.parseInt(sTmpPages);
		session.setAttribute("page", sTmpPages);
	} else {
		nPage = 1;
	}
}

// decimal formater
DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/* Variable Difinition End ========================================*/

/* Request Variable Start =========================================*/
String sPollId			= request.getParameter("oPollId")==null ? "20140701":request.getParameter("oPollId").trim();
String sSentType		= request.getParameter("oSentType")==null ? "":request.getParameter("oSentType").trim();
/* Request Variable End ==========================================*/

/* Record Selection Processing Start =================================*/
if( sCmd.equals("start") ) {
	// recordcount
	sSQLs = "SELECT COUNT(*) AS rCnt \n" +
				"FROM hado_tb_poll_sent \n" +
				"WHERE poll_id = ? \n";
	if( !sSentType.equals("") ) {
		sSQLs += "		AND sent_type = ? \n";
	} 
	//System.out.println(sSQLs);
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		pstmt = conn.prepareStatement(sSQLs);
		int pstmtPoint = 1;	// 예외처리된 preparedStatement 첨자 증가를 위한 변수
		pstmt.setString(pstmtPoint, sPollId);	pstmtPoint++;
		if( !sSentType.equals("") ) {
			pstmt.setString(pstmtPoint, sSentType);	pstmtPoint++;
		}
		rs = pstmt.executeQuery();

		if( rs.next() ) {
			nRecordCount = rs.getInt("rCnt");
		}
		rs.close();
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if ( rs != null ) try{rs.close();}catch(Exception e){}
		if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
		if ( conn != null ) try{conn.close();}catch(Exception e){}
		if ( resource != null ) resource.release();
	}

	// 페이지 수 계산
	if(nRecordCount > 0) {
		nMaxPage = (int)Math.round(nRecordCount / (float)nPageSize + 0.4999999F);
	}

	// SQL 문은 레코드넘버(rownum)을 이용하여 페이지 계산을 미리한다.
	// 공식 : FLOOR( (레코드번호 - 1) / 페이지사이즈 + 1)
	sSQLs = "SELECT * \n" +
				"	FROM ( \n" +
				"		SELECT FLOOR((rownum-1)/" + nPageSize + "+1) AS page,a.* \n" +
				"		FROM ( \n" +
				"			SELECT * \n" +
				"			FROM hado_tb_poll_sent \n" +
				"			WHERE poll_id = ? \n";
	if( !sSentType.equals("") ) {
		sSQLs += "				AND sent_type = ? \n";
	}
	sSQLs += "			ORDER BY poll_id,accept_no \n" +
				"		) a \n" +
				"	) pgTbl \n" +
				"	WHERE page = ? \n";
	//System.out.println(sSQLs);
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		pstmt = conn.prepareStatement(sSQLs);
		int pstmtPoint = 1;	// 예외처리된 preparedStatement 첨자 증가를 위한 변수
		pstmt.setString(pstmtPoint, sPollId);	pstmtPoint++;
		if( !sSentType.equals("") ) {
			pstmt.setString(pstmtPoint, sSentType);	pstmtPoint++;
		}
		pstmt.setInt(pstmtPoint, nPage);
		rs = pstmt.executeQuery();

		while( rs.next() ) {
			arrPollID.add( rs.getString("poll_id") );
			arrAcceptNO.add( rs.getString("accept_no") );
			arrSentType.add( rs.getString("sent_type")==null ? "":rs.getString("sent_type") );
			arrBussTermYear.add( rs.getString("buss_term_year") );
			arrAreaCD.add( rs.getString("area_cd")==null ? "":rs.getString("area_cd") );
			arrSubconStep.add( rs.getString("subcon_step")==null ? "":rs.getString("subcon_step") );
			arrSentSale.add( rs.getString("sent_sale") );
			arrSentEmpCnt.add(  rs.getString("sent_emp_cnt") );
			arrSentCapaCD.add( rs.getString("sent_capa_cd")==null ? "":rs.getString("sent_capa_cd") );
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
}
/* Record Selection Processing End =================================*/

/* Other Bussines Processing Start ==================================*/
//None
/* Other Bussines Processing End ===================================*/
%>
<script language="javascript">
content = "";

content+="<table id='divButton'>";
content+="	<tr>";
content+="		<td>검색된 회사수 : <%=formater.format(nRecordCount)%>개 (page. <%=formater.format(nPage)%> / <%=formater.format(nMaxPage)%>) </td>";
content+="	</tr>";
content+="</table>";

<%if( arrPollID.get(0).equals("20151007") ) {%>
content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th>설문번호</th>";
content+="		<th>조사번호</th>";
content+="		<th>업종</th>";
content+="	</tr>";
<%if( arrPollID.size()>0 ) {
	for(int j=0; j<arrPollID.size(); j++) {%>
content+="	 <tr>";
content+="		<td><%=arrPollID.get(j)%></td>";
content+="		<td><a href=javascript:view('<%=arrPollID.get(j)%>','<%=arrAcceptNO.get(j)%>');><%=arrAcceptNO.get(j)%></a></td>";
content+="		<td><%if( arrSentType.get(j).equals("1") ) {%>제조<%} else if( arrSentType.get(j).equals("2") ) {%>건설<%} else if( arrSentType.get(j).equals("3") ) {%>용역<%} %></td>";
content+="	</tr>";
<%
	}
} else {%>
content+="	<tr>";
content+="		<td colspan='3' class='noneResultset'>검색 결과가 없습니다</td>";
content+="	</tr>";
<%
}
%>
content+="</table>";
content+="<div id='pageMove'>";
content+="<p align='center'><%=UF_PageMove_java(nPage, nMaxPage, "pmove('poll_search_proc.jsp?cmd=start&page=")%></p>";
content+="</div>";

<%} else if( arrPollID.get(0).equals("20141110") ) {%>
content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th>설문번호</th>";
content+="		<th>조사번호</th>";
content+="		<th>업종</th>";
content+="		<th>매출액</th>";
content+="		<th>하도급 거래단계</th>";
content+="	</tr>";
<%if( arrPollID.size()>0 ) {
	for(int j=0; j<arrPollID.size(); j++) {%>
content+="	 <tr>";
content+="		<td><%=arrPollID.get(j)%></td>";
content+="		<td><a href=javascript:view('<%=arrPollID.get(j)%>','<%=arrAcceptNO.get(j)%>');><%=arrAcceptNO.get(j)%></a></td>";
content+="		<td><%if( arrSentType.get(j).equals("1") ) {%>제조<%} else if( arrSentType.get(j).equals("2") ) {%>건설<%} %></td>";
content+="		<td><%=arrSentSale.get(j)%></td>";
content+="		<td><%if( arrSubconStep.get(j).equals("1") ) {%>1차<%} else if( arrSubconStep.get(j).equals("2") ) {%>2차<%} else if( arrSubconStep.get(j).equals("3") ) {%>3차 이하<%} else {%>구분 곤란<%}%></td>";
content+="	</tr>";
<%
	}
} else {%>
content+="	<tr>";
content+="		<td colspan='5' class='noneResultset'>검색 결과가 없습니다</td>";
content+="	</tr>";
<%
}
%>
content+="</table>";
content+="<div id='pageMove'>";
content+="<p align='center'><%=UF_PageMove_java(nPage, nMaxPage, "pmove('poll_search_proc.jsp?cmd=start&page=")%></p>";
content+="</div>";

<%} else {%>
content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th>설문번호</th>";
content+="		<th>조사번호</th>";
content+="		<th>사업기간</th>";
content+="		<th>지역</th>";
content+="		<th>업종</th>";
content+="		<th>하도급 거래단계</th>";
content+="		<th>매출액</th>";
content+="		<th>상시종업원수</th>";
content+="		<th>원사업자<br>회사규모</th>";
content+="	</tr>";
<%if( arrPollID.size()>0 ) {
	for(int j=0; j<arrPollID.size(); j++) {%>
content+="	 <tr>";
content+="		<td><%=arrPollID.get(j)%></td>";
content+="		<td><a href=javascript:view('<%=arrPollID.get(j)%>','<%=arrAcceptNO.get(j)%>');><%=arrAcceptNO.get(j)%></a></td>";
content+="		<td><%=arrBussTermYear.get(j)%></td>";
content+="		<td><%if( arrAreaCD.get(j).equals("1") ) {%>수도권<%} else {%>비수도권<%}%></td>";
content+="		<td><%if( arrSentType.get(j).equals("1") ) {%>제조<%} else if( arrSentType.get(j).equals("2") ) {%>건설<%} else {%>용역<%}%></td>";
content+="		<td><%if( arrSubconStep.get(j).equals("1") ) {%>1차<%} else if( arrSubconStep.get(j).equals("2") ) {%>2차<%} else if( arrSubconStep.get(j).equals("3") ) {%>3차 이하<%} else {%>구분 곤란<%}%></td>";
content+="		<td><%=arrSentSale.get(j)%></td>";
content+="		<td><%=arrSentEmpCnt.get(j)%></td>";
content+="		<td><%if( arrSentCapaCD.get(j).equals("1") ) {%>대기업<%} else if( arrSentCapaCD.get(j).equals("2") ) {%>중견기업<%} else {%>중소기업<%}%></td>";
content+="	</tr>";
<%
	}
} else {%>
content+="	<tr>";
content+="		<td colspan='9' class='noneResultset'>검색 결과가 없습니다</td>";
content+="	</tr>";
<%
}
%>
content+="</table>";
content+="<div id='pageMove'>";
content+="<p align='center'><%=UF_PageMove_java(nPage, nMaxPage, "pmove('poll_search_proc.jsp?cmd=start&page=")%></p>";
content+="</div>";
<%}%>

top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>