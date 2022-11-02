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
/* ���α׷���		: poll_Submit_Total.jsp												  */
/* ���α׷�����	: ���� ���� ���μ���													  */
/* ���α׷�����	: 1.0.0																	  */
/* �����ۼ�����	: 2014�� 07�� 07��													      */
/*--------------------------------------------------------------------------------------- */
/*	�ۼ�����		�ۼ��ڸ�				����
/*--------------------------------------------------------------------------------------- */
/*	2014-07-07	������	�����ۼ�														  */			
/*=======================================================*/

/* Variable Difinition Start ======================================*/
/*
�ʱ� �ε�� ������� �Ѹ��� �ʰ�, ��ĸ� �ѷ���
cmd=start �϶� DB Ŀ�ؼ��� ���� Data ������
*/
String sCmd = request.getParameter("cmd")==null ? "":request.getParameter("cmd").trim();

ConnectionResource resource = null;	// DB Resource
Connection conn = null;	// DB Connection
PreparedStatement pstmt = null;	// PreparedStatment
ResultSet rs = null;	// Result recordset

String sSQLs = "";

int nLoop = 0;

// result value variable
int nTotCnt = 0;
int nType1Cnt = 0;
int nType2Cnt = 0;
int nType3Cnt = 0;

// decimal formater
DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
java.util.Calendar cal = java.util.Calendar.getInstance();
/* Variable Difinition End ========================================*/

/* Request Variable Start =========================================*/
String sPollId			= request.getParameter("oPollId")==null ? "20140701":request.getParameter("oPollId").trim();
/* Request Variable End ==========================================*/

/* Record Selection Processing Start =================================*/
if( sCmd.equals("start") ) {
	sSQLs = "SELECT NVL(SUM(rCnt),0) AS rCnt, NVL(SUM(cntType1),0) AS cntType1, NVL(SUM(cntType2),0) AS cntType2,  NVL(SUM(cntType3),0) AS cntType3 \n" +
				"FROM ( \n" +
				"	SELECT COUNT(*) AS rCnt, \n" +
				"		SUM(CASE sent_type WHEN '1' THEN 1 ELSE 0 END) AS cntType1, \n" +
				"		SUM(CASE sent_type WHEN '2' THEN 1 ELSE 0 END) AS cntType2, \n" +
				"		SUM(CASE sent_type WHEN '3' THEN 1 ELSE 0 END) AS cntType3 \n" +
				"	FROM hado_tb_poll_sent \n" +
				"	WHERE poll_id = ? \n" +
				"	GROUP BY sent_type \n" +
				") jTbl \n";
	//System.out.println(sSQLs);
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, sPollId);
		rs = pstmt.executeQuery();

		if( rs.next() ) {
			nTotCnt = rs.getInt("rCnt");
			nType1Cnt = rs.getInt("cntType1");
			nType2Cnt = rs.getInt("cntType2");
			nType3Cnt = rs.getInt("cntType3");
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
content+="		<td><%=cal.get(Calendar.YEAR)%>��<%=cal.get(Calendar.MONTH)+1%>��<%=cal.get(Calendar.DATE)%>��(����)</td>";
content+="	</tr>";
content+="</table>";

content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th>�����</th>";
content+="		<th>����</th>";
content+="		<th>�Ǽ�</th>";
content+="		<th>�뿪</th>";
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<td><%=formater.format((float)nTotCnt)%></td>";
content+="		<td><%=formater.format((float)nType1Cnt)%></td>";
content+="		<td><%=formater.format((float)nType2Cnt)%></td>";
content+="		<td><%=formater.format((float)nType3Cnt)%></td>";
content+="	</tr>";
content+="	</table>";

top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>