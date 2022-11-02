<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명	: Oent_Violate_382_proc.jsp
* 프로그램설명	: 원사업자 > 조사결과분석 > 목적물 인수 요인(건설)
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-14	정광식       최초작성
*	2015-06-10	강슬기       페이지 최신화(주석, 불필요한 코드 제거, 오래된 코드 수정)
*	2016-01-08	민현근		DB변경으로 인한 인코딩 변경
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
	String stt = request.getParameter("tt")==null ? "":request.getParameter("tt").trim();
	String comm = request.getParameter("comm")==null ? "":request.getParameter("comm").trim();

	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sCYear = st_Current_Year;
	String sSQLs = "";

	String[][] arrData = new String[51][9];
	float[] arrSum = new float[7];

	int nLoop = 1;
	int sStartYear = 2009;

	java.util.Calendar cal = java.util.Calendar.getInstance();

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2 = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	String tmpYear = request.getParameter("cyear")==null ? "":request.getParameter("cyear").trim();
	String sTradeST=request.getParameter("tradest")==null ? "":request.getParameter("tradest").trim();

	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
	}

	if( comm.equals("search") ) {
		session.setAttribute("wgb", request.getParameter("wgb")==null ? "":request.getParameter("wgb").trim());
	}
	
	// 합계배열 초기화
	for(int i=1; i <=6; i++) {
		arrSum[i] = 0F; 
	}
	
	int currentYear = st_Current_Year_n;
	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");

	int endCurrentYear = st_Current_Year_n;

	// view table name
	String currentTalbe = currentYear>=2012 ? "HADO_VT_Oent_Answer_ST_"+tmpYear : "HADO_VT_Oent_Answer_TradeST";

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		sSQLs="SELECT A.Oent_Type Oent_Type, B.Common_NM Common_NM, \n";
		sSQLs+="SUM(CASE A.A WHEN '1' THEN 1 ELSE 0 END) AS Field01, \n";
		sSQLs+="SUM(CASE A.B WHEN '1' THEN 1 ELSE 0 END) AS Field02, \n";
		sSQLs+="SUM(CASE A.C WHEN '1' THEN 1 ELSE 0 END) AS Field03, \n";
		sSQLs+="SUM(CASE A.D WHEN '1' THEN 1 ELSE 0 END) AS Field04, \n";
		sSQLs+="SUM(CASE A.E WHEN '1' THEN 1 ELSE 0 END) AS Field05 FROM ( \n";
		sSQLs+="	SELECT * FROM "+currentTalbe+" \n";
		sSQLs+="	WHERE Current_Year='"+currentYear+"'  \n";	
		// "하도급대금 결정방법(건설)" 
		if( currentYear >= 2014 ) {
			sSQLs+="	AND Oent_Q_CD=10 AND Oent_Q_GB=2 AND Oent_GB='2' \n";
		} else if( currentYear >= 2012 ) {
			sSQLs+="	AND Oent_Q_CD=13 AND Oent_Q_GB=2 AND Oent_GB='2' \n";
		} else {
			sSQLs+="	AND Oent_Q_CD=14 AND Oent_Q_GB=2 AND Oent_GB='2' \n";
		}
		sSQLs+="	AND Comp_Status='1' \n";
		sSQLs+="	AND Oent_Status='1' \n";
		sSQLs+="	AND Subcon_Type<='2' \n";
		sSQLs+="	AND Addr_Status IS NULL \n";
		if( currentYear>=2014 ) {
			sSQLs+="	AND LENGTH(Mng_No)>6 \n";
		} else {
			sSQLs+="	AND LENGTH(Mng_No)>4 \n";
			sSQLs+="	AND SUBSTR(Mng_No,-7)<>'1234567' \n";
		}
		if( !sTradeST.equals("") ) {
			sSQLs+="	AND TradeST='"+sTradeST+"' \n";
		}
		sSQLs+=") A LEFT JOIN ( \n";
		sSQLs+="	SELECT Common_CD, Common_NM, COMMON_GB \n";
		sSQLs+="	FROM COMMON_CD \n";
		sSQLs+="	WHERE Addon_GB='"+session.getAttribute("wgb")+"' \n";
		sSQLs+=") B ON Replace(A.Oent_Type,'i','I')=B.COMMON_CD  \n";
		if( currentYear>=2012 ) 
			sSQLs+="AND COMMON_GB='010' \n";
		sSQLs+="GROUP BY A.Oent_Type, B.Common_NM \n";
		sSQLs+="ORDER BY A.Oent_Type \n";
		
		//System.out.println(sSQLs);
		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();
		
		nLoop = 1;
		while( rs.next() ) {
			arrData[nLoop][7] = rs.getString("Oent_Type");
			arrData[nLoop][8] = rs.getString("Common_NM")==null ? "":rs.getString("Common_NM").trim();
			arrData[nLoop][2] = rs.getString("Field01");
			arrData[nLoop][3] = rs.getString("Field02");
			arrData[nLoop][4] = rs.getString("Field03");
			arrData[nLoop][5] = rs.getString("Field04");
			arrData[nLoop][6] = rs.getString("Field05");
			arrData[nLoop][1] = "0";
			for(int i = 2; i <= 6; i++) {
				if( arrData[nLoop][i] != null && (!arrData[nLoop][i].equals("")) ) {
					arrData[nLoop][1] = "" + ( Long.parseLong(arrData[nLoop][1]) + Long.parseLong(arrData[nLoop][i]) );
				}
			}
			for(int i=1; i<=6; i++) {
				arrSum[i] = arrSum[i] + Float.parseFloat(arrData[nLoop][i]);
			}

			nLoop++;
		}
		rs.close();
		nLoop--;
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e) {}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e) {}
		if (conn != null)	try{conn.close();}	catch(Exception e) {}
		if (resource != null) resource.release();}
/*=====================================================================================================*/
%>

<meta charset="euc-kr">
<script type="text/javascript">
//<![CDATA[
content = "";

content+="<table id='divButton'>";
content+="	<tr>";
content+="		<th><a href='Oent_Violate_382_Excel.jsp' target='_blank'><img src='/hado/hado/wTools/img/img_forExcel.gif'></a></th>";
content+="	</tr>";
content+="</table>";

content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th>구분</th>";
content+="		<th>응답수</th>";
content+="		<th>목적물에 하자 발생</th>";
content+="		<th>발주서대로 시공되지 않음</th>";
content+="		<th>수급사업자의 책임</th>";
content+="		<th>발주자의 거래취소</th>";
content+="		<th>설계변경 등으로 추가공사금액이 미확정</th>";
content+="	</tr>";

<%if( !stt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan='2'>계</th>";
content+="		<td><%=formater2.format(arrSum[1])%></td>";
content+="		<td><%=formater2.format(arrSum[2])%></td>";
content+="		<td><%=formater2.format(arrSum[3])%></td>";
content+="		<td><%=formater2.format(arrSum[4])%></td>";
content+="		<td><%=formater2.format(arrSum[5])%></td>";
content+="		<td><%=formater2.format(arrSum[6])%></td>";
content+="	</tr>";

content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<td>100.0%</td>";
	<%if( arrSum[1] > 0F) {%>
content+="		<td><%=formater.format(arrSum[2] / arrSum[1] * 100F)%></td>";
	<%} else {%>
content+="		<td>0.0%</td>";
	<%}%>

	<%if( arrSum[1] > 0F) {%>
content+="		<td><%=formater.format(arrSum[3] / arrSum[1] * 100F)%></td>";
	<%} else {%>
content+="		<td>0.0%</td>";
	<%}%>

	<%if( arrSum[1] > 0F) {%>
content+="		<td><%=formater.format(arrSum[4] / arrSum[1] * 100F)%></td>";
	<%} else {%>
content+="		<td>0.0%</td>";
	<%}%>

	<%if( arrSum[1] > 0F) {%>
content+="		<td><%=formater.format(arrSum[5] / arrSum[1] * 100F)%></td>";
	<%} else {%>
content+="		<td>0.0%</td>";
	<%}%>

	<%if( arrSum[1] > 0F) {%>
content+="		<td><%=formater.format(arrSum[6] / arrSum[1] * 100F)%></td>";
	<%} else {%>
content+="		<td>0.0%</td>";
	<%}%>
content+="	</tr>";

	<%for(int ni=1; ni<=nLoop; ni++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
		<%if( !session.getAttribute("wgb").equals("") ) {%>
content+="		<th rowspan='2'><%=arrData[ni][7]%> (<%=arrData[ni][8]%>)</th>";
		<%} else {%>
			<%if( arrData[ni][7].equals("2") ) {%>
content+="		<th rowspan='2'>건설</th>";
			<%}%>
		<%}%>

content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][1]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][2]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][3]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][4]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][5]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][6]))%></td>";
content+="	</tr>";

content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
		<%if( !session.getAttribute("wgb").equals("") ) {%>
			<%if( arrSum[1] > 0F && arrData[ni][1] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][1]) / arrSum[1] * 100F)%>%</td>";
			<%} else {%>
content+="		<td>0.0%</td>";
			<%}%>
		<%} else {%>
content+="		<td>100.0%</td>";
		<%}%>

		<%if( !session.getAttribute("wgb").equals("") ) {%>
			<%if( arrSum[1] > 0F && arrData[ni][1] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][2]) / arrSum[1] * 100F)%>%</td>";
			<%} else {%>
content+="		<td>0.0%</td>";
			<%}%>
		<%} else {%>
content+="		<td>100.0%</td>";
		<%}%>

		<%if( !session.getAttribute("wgb").equals("") ) {%>
			<%if( arrSum[1] > 0F && arrData[ni][1] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][3]) / arrSum[1] * 100F)%>%</td>";
			<%} else {%>
content+="		<td>0.0%</td>";
			<%}%>
		<%} else {%>
content+="		<td>100.0%</td>";
		<%}%>

		<%if( !session.getAttribute("wgb").equals("") ) {%>
			<%if( arrSum[1] > 0F && arrData[ni][1] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][4]) / arrSum[1] * 100F)%>%</td>";
			<%} else {%>
content+="		<td>0.0%</td>";
			<%}%>
		<%} else {%>
content+="		<td>100.0%</td>";
		<%}%>

		<%if( !session.getAttribute("wgb").equals("") ) {%>
			<%if( arrSum[1] > 0F && arrData[ni][1] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][5]) / arrSum[1] * 100F)%>%</td>";
			<%} else {%>
content+="		<td>0.0%</td>";
			<%}%>
		<%} else {%>
content+="		<td>100.0%</td>";
		<%}%>
		<%if( !session.getAttribute("wgb").equals("") ) {%>
			<%if( arrSum[1] > 0F && arrData[ni][1] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][6]) / arrSum[1] * 100F)%>%</td>";
			<%} else {%>
content+="		<td>0.0%</td>";
			<%}%>
		<%} else {%>
content+="		<td>100.0%</td>";
		<%}%>

content+="	</tr>";
	<%}%>

<%} else {%>
content+="	<tr>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="	</tr>";
<%}%>
content+="</table>";

top.document.getElementById("divResult").innerHTML=content;
top.setNowProcessFalse();
//]]
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>