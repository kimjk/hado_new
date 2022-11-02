<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명	: SOent_Submit_Oent_report_proc.jsp
* 프로그램설명	: 수급사업자 > 제출현황 > 수급사업자가 제출한 원사업자 명부 제출현황 
* 프로그램버전	: 4.0.1
* 최초작성일자	: 2015년 07월
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*   2015-07-28   강슬기	    최초작성
*	2016-01-04	정광식		DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="java.text.DecimalFormat"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String sCmd = request.getParameter("cmd")==null ? "":request.getParameter("cmd").trim();
	int currentYear = st_Current_Year_n;
	
	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sSQLs = "";

	int nLoop = 0;

	int nTotCnt = 0;
	int nType1Cnt = 0;
	int nType2Cnt = 0;
	int nType3Cnt = 0;

	java.util.Calendar cal = java.util.Calendar.getInstance();

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
if( sCmd.equals("start") ) {
		session.setAttribute("cyear", StringUtil.checkNull(request.getParameter("cyear")).trim());
	
		sSQLs = "SELECT COUNT(oent_gb) AS rCnt, \n" +
							"SUM(CASE oent_gb WHEN '1' THEN 1 ELSE 0 END) AS cntType1, \n" +
							"SUM(CASE oent_gb WHEN '2' THEN 1 ELSE 0 END) AS cntType2, \n" +
							"SUM(CASE oent_gb WHEN '3' THEN 1 ELSE 0 END) AS cntType3 \n" +
							"FROM ( \n" +
							"SELECT mng_no,current_year,oent_gb,oent_file \n" +
							"FROM hado_tb_subcon_oent_file \n" +
							"WHERE current_year='"+session.getAttribute("cyear")+"' \n" +
							"GROUP BY mng_no,current_year,oent_gb \n" +
							") jTbl \n";
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

%>
<meta charset="utf-8">
<script type="text/javascript">
//<![CDATA[
content = "";

content+="<table id='divButton'>";
content+="	<tr>";
content+="		<td><%=cal.get(Calendar.YEAR)%>년<%=cal.get(Calendar.MONTH)+1%>월<%=cal.get(Calendar.DATE)%>일(현재)</td>";
content+="	</tr>";
content+="</table>";

content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th>업체수</th>";
content+="		<th>제조</th>";
content+="		<th>건설</th>";
content+="		<th>용역</th>";
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<td><%=formater.format(nTotCnt)%></td>";
content+="		<td><%=formater.format(nType1Cnt)%></td>";
content+="		<td><%=formater.format(nType2Cnt)%></td>";
content+="		<td><%=formater.format(nType3Cnt)%></td>";
content+="	</tr>";
content+="	</table>";

top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
//]]
</script>
<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>