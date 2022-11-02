<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/**
������Ʈ��		: 2015�� �����ŷ�����ȸ �ϵ��ްŷ� �����������
���α׷���		: Add_Submit_Total_proc.jsp
���α׷�����	: �ű��������� �������� ������Ȳ ���μ���
���α׷�����	: 1.0.0
�����ۼ�����	: 2015�� 07�� 22��
---------------------------------------------------------------------------------------
	�ۼ�����		�ۼ��ڸ�				����	
---------------------------------------------------------------------------------------
	2014-07-22	������	�����ۼ�
*/

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
String sPollId = request.getParameter("oPollId") == null ? "20150706":request.getParameter("oPollId").trim();
String sCurrentYear = request.getParameter("cyear") == null ? "":request.getParameter("cyear").trim();
/* Request Variable End ==========================================*/

/* Record Selection Processing Start =================================*/
if( sCmd.equals("start") ) {

	//20170804 �˻����ǰ� ���εǵ��� ����ó��
	sSQLs = "SELECT COUNT(oent_gb) AS rCnt, \n" +
		"SUM(CASE oent_gb WHEN '1' THEN 1 ELSE 0 END) AS cntType1, \n" +
		"SUM(CASE oent_gb WHEN '2' THEN 1 ELSE 0 END) AS cntType2, \n" +
		"SUM(CASE oent_gb WHEN '3' THEN 1 ELSE 0 END) AS cntType3 \n" +
		"FROM ( \n" +
		"SELECT mng_no,oent_gb,remote_ip,current_year \n" +
		" FROM hado_tb_soent_answer_add \n" +
		"GROUP BY mng_no,oent_gb,remote_ip,current_year \n" +
		") jTbl \n";  
		if(!sCurrentYear.equals("0")){
			sSQLs += "WHERE current_year = '"+sCurrentYear+"' \n";
		}
		
//System.out.println(sSQLs);
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		pstmt = conn.prepareStatement(sSQLs);
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
content+="		<th>��ü��</th>";
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