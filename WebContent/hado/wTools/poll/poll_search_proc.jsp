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
/* ������Ʈ��		: 2014�� �����ŷ�����ȸ �ϵ��ްŷ� �����������					      */
/* ���α׷���		: poll_search.jsp													  */
/* ���α׷�����	: ���� ���� ���μ���													  */
/* ���α׷�����	: 1.0.0																	  */
/* �����ۼ�����	: 2014�� 07�� 07��													      */
/*--------------------------------------------------------------------------------------- */
/*	�ۼ�����		�ۼ��ڸ�				����
/*--------------------------------------------------------------------------------------- */
/*	2014-07-07	������	�����ۼ�														  */			
/*=======================================================*/

/* Variable Difinition Start ======================================*/

// ����Ʈ �迭

ArrayList arrPollID = new ArrayList();			// ������ȣ
ArrayList arrAcceptNO = new ArrayList();		// ������ȣ
ArrayList arrSentType = new ArrayList();		// ����
ArrayList arrBussTermYear = new ArrayList();	// ����Ⱓ
ArrayList arrAreaCD = new ArrayList();			// ��������
ArrayList arrSubconStep = new ArrayList();	// �ŷ��ܰ�
ArrayList arrDetailTypeCD = new ArrayList();	// ���ξ���(����)
ArrayList arrSentSale = new ArrayList();		// �����
ArrayList arrSentEmpCnt = new ArrayList();	// �����������
ArrayList arrSentCapaCD = new ArrayList();	// ����Ը�

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
		int pstmtPoint = 1;	// ����ó���� preparedStatement ÷�� ������ ���� ����
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

	// ������ �� ���
	if(nRecordCount > 0) {
		nMaxPage = (int)Math.round(nRecordCount / (float)nPageSize + 0.4999999F);
	}

	// SQL ���� ���ڵ�ѹ�(rownum)�� �̿��Ͽ� ������ ����� �̸��Ѵ�.
	// ���� : FLOOR( (���ڵ��ȣ - 1) / ������������ + 1)
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
		int pstmtPoint = 1;	// ����ó���� preparedStatement ÷�� ������ ���� ����
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
content+="		<td>�˻��� ȸ��� : <%=formater.format(nRecordCount)%>�� (page. <%=formater.format(nPage)%> / <%=formater.format(nMaxPage)%>) </td>";
content+="	</tr>";
content+="</table>";

<%if( arrPollID.get(0).equals("20151007") ) {%>
content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th>������ȣ</th>";
content+="		<th>�����ȣ</th>";
content+="		<th>����</th>";
content+="	</tr>";
<%if( arrPollID.size()>0 ) {
	for(int j=0; j<arrPollID.size(); j++) {%>
content+="	 <tr>";
content+="		<td><%=arrPollID.get(j)%></td>";
content+="		<td><a href=javascript:view('<%=arrPollID.get(j)%>','<%=arrAcceptNO.get(j)%>');><%=arrAcceptNO.get(j)%></a></td>";
content+="		<td><%if( arrSentType.get(j).equals("1") ) {%>����<%} else if( arrSentType.get(j).equals("2") ) {%>�Ǽ�<%} else if( arrSentType.get(j).equals("3") ) {%>�뿪<%} %></td>";
content+="	</tr>";
<%
	}
} else {%>
content+="	<tr>";
content+="		<td colspan='3' class='noneResultset'>�˻� ����� �����ϴ�</td>";
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
content+="		<th>������ȣ</th>";
content+="		<th>�����ȣ</th>";
content+="		<th>����</th>";
content+="		<th>�����</th>";
content+="		<th>�ϵ��� �ŷ��ܰ�</th>";
content+="	</tr>";
<%if( arrPollID.size()>0 ) {
	for(int j=0; j<arrPollID.size(); j++) {%>
content+="	 <tr>";
content+="		<td><%=arrPollID.get(j)%></td>";
content+="		<td><a href=javascript:view('<%=arrPollID.get(j)%>','<%=arrAcceptNO.get(j)%>');><%=arrAcceptNO.get(j)%></a></td>";
content+="		<td><%if( arrSentType.get(j).equals("1") ) {%>����<%} else if( arrSentType.get(j).equals("2") ) {%>�Ǽ�<%} %></td>";
content+="		<td><%=arrSentSale.get(j)%></td>";
content+="		<td><%if( arrSubconStep.get(j).equals("1") ) {%>1��<%} else if( arrSubconStep.get(j).equals("2") ) {%>2��<%} else if( arrSubconStep.get(j).equals("3") ) {%>3�� ����<%} else {%>���� ���<%}%></td>";
content+="	</tr>";
<%
	}
} else {%>
content+="	<tr>";
content+="		<td colspan='5' class='noneResultset'>�˻� ����� �����ϴ�</td>";
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
content+="		<th>������ȣ</th>";
content+="		<th>�����ȣ</th>";
content+="		<th>����Ⱓ</th>";
content+="		<th>����</th>";
content+="		<th>����</th>";
content+="		<th>�ϵ��� �ŷ��ܰ�</th>";
content+="		<th>�����</th>";
content+="		<th>�����������</th>";
content+="		<th>�������<br>ȸ��Ը�</th>";
content+="	</tr>";
<%if( arrPollID.size()>0 ) {
	for(int j=0; j<arrPollID.size(); j++) {%>
content+="	 <tr>";
content+="		<td><%=arrPollID.get(j)%></td>";
content+="		<td><a href=javascript:view('<%=arrPollID.get(j)%>','<%=arrAcceptNO.get(j)%>');><%=arrAcceptNO.get(j)%></a></td>";
content+="		<td><%=arrBussTermYear.get(j)%></td>";
content+="		<td><%if( arrAreaCD.get(j).equals("1") ) {%>������<%} else {%>�������<%}%></td>";
content+="		<td><%if( arrSentType.get(j).equals("1") ) {%>����<%} else if( arrSentType.get(j).equals("2") ) {%>�Ǽ�<%} else {%>�뿪<%}%></td>";
content+="		<td><%if( arrSubconStep.get(j).equals("1") ) {%>1��<%} else if( arrSubconStep.get(j).equals("2") ) {%>2��<%} else if( arrSubconStep.get(j).equals("3") ) {%>3�� ����<%} else {%>���� ���<%}%></td>";
content+="		<td><%=arrSentSale.get(j)%></td>";
content+="		<td><%=arrSentEmpCnt.get(j)%></td>";
content+="		<td><%if( arrSentCapaCD.get(j).equals("1") ) {%>����<%} else if( arrSentCapaCD.get(j).equals("2") ) {%>�߰߱��<%} else {%>�߼ұ��<%}%></td>";
content+="	</tr>";
<%
	}
} else {%>
content+="	<tr>";
content+="		<td colspan='9' class='noneResultset'>�˻� ����� �����ϴ�</td>";
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