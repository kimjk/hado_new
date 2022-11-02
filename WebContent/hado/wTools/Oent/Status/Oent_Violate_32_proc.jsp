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
	String stt = StringUtil.checkNull(request.getParameter("tt")).trim();
	String comm = StringUtil.checkNull(request.getParameter("comm")).trim();

	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sCYear = st_Current_Year;
	String sSQLs = "";
	String tmpStr = "";

	String[][] arrData = new String[51][7];
	float[] arrSum = new float[5];

	int nLoop = 1;

	int sStartYear = 2009;

	java.util.Calendar cal = java.util.Calendar.getInstance();

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2 = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	String tmpYear = StringUtil.checkNull(request.getParameter("cyear")).trim();
	String sTradeST=StringUtil.checkNull(request.getParameter("tradest")).trim();

	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
	}

	if( stt.equals("start") ) {
		session.setAttribute("wgb", "1");
	}

	if( comm.equals("search") ) {
		session.setAttribute("wgb", StringUtil.checkNull(request.getParameter("wgb")).trim());
	}
	
	// 합계배열 초기화
	for(int i=1; i <=3; i++) { arrSum[i] = 0F; }
	
	int currentYear = st_Current_Year_n;
	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");

	int endCurrentYear = st_Current_Year_n;

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		if( !session.getAttribute("wgb").equals("") ) {
			sSQLs="SELECT A.Oent_Type Oent_Type, B.Common_NM Common_NM, \n";
		} else {
			sSQLs="SELECT A.Oent_GB Oent_Type, '' Common_NM, \n";
		}

		sSQLs+="	SUM(CASE C.A WHEN '1' THEN 1 ELSE 0 END) AS Field01, \n";
		sSQLs+="	SUM(CASE C.B WHEN '1' THEN 1 ELSE 0 END) AS Field02, \n";
		sSQLs+="	SUM(CASE C.C WHEN '1' THEN 1 ELSE 0 END) AS Field03 FROM ( \n";
		sSQLs+="		SELECT * FROM HADO_VT_Oent_Answer_TradeST A \n";
		sSQLs+="		WHERE Current_Year='"+currentYear+"'  \n";
		// 업종별 해당문항의 연계항목
		if( session.getAttribute("wgb").equals("1") ) {
			sSQLs+="			AND Oent_Q_CD=11 AND Oent_Q_GB=9 AND A='1' AND Oent_GB='1' \n";	
		} else if( session.getAttribute("wgb").equals("2") ) {
			sSQLs+="			AND Oent_Q_CD=12 AND Oent_Q_GB=7 AND A='1' AND Oent_GB='2' \n";	
		} else if( session.getAttribute("wgb").equals("3") ) {
			sSQLs+="			AND Oent_Q_CD=11 AND Oent_Q_GB=9 AND A='1' AND Oent_GB='3' \n";	
		} else {
			if( currentYear == 2010 ) {
				sSQLs+="			AND ( (Oent_Q_CD=11 AND Oent_Q_GB=9 AND A='1' AND Oent_GB='1') \n";	
				sSQLs+="				OR (Oent_Q_CD=12 AND Oent_Q_GB=7 AND A='1' AND Oent_GB='2') \n";
				sSQLs+="				OR (Oent_Q_CD=11 AND Oent_Q_GB=9 AND A='1' AND Oent_GB='3') ) \n";	
			} else {
				sSQLs+="			AND Oent_Q_CD=11 AND Oent_Q_GB=9 AND A='1' \n";	
			}
		}
		sSQLs+="				AND Comp_Status='1' \n";
		sSQLs+="				AND Oent_Status='1' \n";
		sSQLs+="				AND Subcon_Type<='2' \n";
		sSQLs+="				AND Addr_Status IS NULL \n";
		sSQLs+="				AND SUBSTR(Mng_No,-7)<>'1234567' \n";
		sSQLs+="				AND LENGTH(Mng_No)>4 \n";

		if( !sTradeST.equals("") ) {
			sSQLs+="				AND TradeST='"+sTradeST+"' \n";
		}
		
		sSQLs+=") A LEFT JOIN ( \n";
		sSQLs+="	SELECT * FROM HADO_VT_Oent_Answer_TradeST A \n";
		sSQLs+="	WHERE Current_Year='"+currentYear+"'  \n";

		// 업종별 해당 문항 번호
		if( session.getAttribute("wgb").equals("1") ) {
			sSQLs+="			AND Oent_Q_CD=11 AND Oent_Q_GB=11 AND Oent_GB='1' \n";
		} else if( session.getAttribute("wgb").equals("2") ) {
			sSQLs+="			AND Oent_Q_CD=12 AND Oent_Q_GB=9 AND Oent_GB='2' \n";
		} else if( session.getAttribute("wgb").equals("3") ) {
			sSQLs+="			AND Oent_Q_CD=11 AND Oent_Q_GB=11 AND Oent_GB='3' \n";
		} else {
			if( currentYear == 2010 ) {
				sSQLs+="			AND ( (Oent_Q_CD=11 AND Oent_Q_GB=11 AND Oent_GB='1') \n";
				sSQLs+="				OR (Oent_Q_CD=12 AND Oent_Q_GB=9 AND Oent_GB='2') \n";
				sSQLs+="				OR (Oent_Q_CD=11 AND Oent_Q_GB=11 AND Oent_GB='3') ) \n";
			} else {
				sSQLs+="			AND Oent_Q_CD=11 AND Oent_Q_GB=11 \n";	
			}
		}
		sSQLs+=") C ON A.Mng_No=C.Mng_No AND A.Current_Year=C.Current_Year AND A.Oent_GB=C.Oent_GB \n";

		if( !session.getAttribute("wgb").equals("") ) {
			sSQLs+="LEFT JOIN ( \n";
			sSQLs+="	SELECT Common_CD,Common_NM \n";
			sSQLs+="	FROM COMMON_CD \n";
			sSQLs+="	WHERE Addon_GB='"+session.getAttribute("wgb")+"' \n";
			sSQLs+=") B ON Replace(A.Oent_Type,'i','I')=B.COMMON_CD  \n";
			sSQLs+="GROUP BY A.Oent_Type, B.Common_NM \n";
			sSQLs+="ORDER BY A.Oent_Type \n";

		} else {
			sSQLs+="GROUP BY A.Oent_GB \n";
			sSQLs+="ORDER BY A.Oent_GB \n";
		}

		//System.out.println(sSQLs);
				
		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();
		
		nLoop = 1;
		while( rs.next() ) {
			arrData[nLoop][5] = rs.getString("Oent_Type");
			arrData[nLoop][6] = new String( StringUtil.checkNull(rs.getString("Common_NM")).trim().getBytes("ISO8859-1"), "EUC-KR" );
			arrData[nLoop][2] = rs.getString("Field01");
			arrData[nLoop][3] = rs.getString("Field02");
			arrData[nLoop][4] = rs.getString("Field03");
			arrData[nLoop][1] = "0";
			for(int i = 2; i <= 4; i++) {
				if( arrData[nLoop][i] != null && (!arrData[nLoop][i].equals("")) ) {
					arrData[nLoop][1] = "" + ( Long.parseLong(arrData[nLoop][1]) + Long.parseLong(arrData[nLoop][i]) );
				}
			}
			for(int i=1; i<=4; i++) {
				arrSum[i] = arrSum[i] + Float.parseFloat(arrData[nLoop][i]);
			}

			nLoop++;
		}
		rs.close();
		nLoop--;
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn != null)	try{conn.close();}	catch(Exception e){}
		if (resource != null) resource.release();
	}
/*=====================================================================================================*/
%>
<script language="javascript">
content="";
content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th rowspan='2'>구분</th>";
content+="		<th colspan='2'>응답 업체수</th>";
content+="		<th colspan='2'>전부 수용</th>";
content+="		<th colspan='2'>일부 수용</th>";
content+="		<th colspan='2'>수용하지 않음</th>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>업체수</th><th>비율</th>";
content+="		<th>응답수</th><th>비율</th>";
content+="		<th>응답수</th><th>비율</th>";
content+="		<th>응답수</th><th>비율</th>";
content+="  </tr>";
<%if( !stt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th>계</th>";
content+="		<td><%=formater2.format(arrSum[1])%></td>";
content+="		<td>100.0%</td>";
content+="		<td><%=formater2.format(arrSum[2])%></td>";
	<%if( arrSum[1] > 0F) {%>	
content+="		<td><%=formater.format(arrSum[2] / arrSum[1] * 100F)%>%</td>";
	<%} else {%>				
content+="		<td>0.0%</td>";
	<%}%>
content+="		<td><%=formater2.format(arrSum[3])%></td>";
	<%if( arrSum[1] > 0F) {%>	
content+="		<td><%=formater.format(arrSum[3] / arrSum[1] * 100F)%>%</td>";
	<%} else {%>				
content+="		<td>0.0%</td>";
	<%}%>
	content+="		<td><%=formater2.format(arrSum[4])%></td>";
	<%if( arrSum[1] > 0F) {%>	
content+="		<td><%=formater.format(arrSum[4] / arrSum[1] * 100F)%>%</td>";
	<%} else {%>				
content+="		<td>0.0%</td>";
	<%}%>
content+="	</tr>";

	<%for(int ni=1; ni<=nLoop; ni++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
		<%if( !session.getAttribute("wgb").equals("") ) {%>	
content+="		<th><%=arrData[ni][5]%> (<%=arrData[ni][6]%>)</th>";
		<%} else {%>
				<%if( arrData[ni][5].equals("1") ) {%>		
content+="		<th>제조</th>";
				<%} else if( arrData[ni][5].equals("2") ) {%>
content+="		<th>건설</th>";
				<%} else if( arrData[ni][5].equals("3") ) {%>								
content+="		<th>용역</th>";
				<%}
		}%>
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][1]))%></td>";

		<%if( !session.getAttribute("wgb").equals("") ) {%>
			<%if( arrSum[1] > 0F && arrData[ni][1] != null ){%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][1]) / arrSum[1] * 100F)%>%</td>";
			<%} else {%>
content+="		<td>0.0%</td>";
			<%}
		} else {%>
content+="		<td>100.0%</td>";
		<%}%>

content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][2]))%></td>";

		<%if( arrData[ni][2] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][2]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>";
		<%} else {%>
content+="		<td>0.0%</td>";
		<%}%>

content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][3]))%></td>";
		<%if( arrData[ni][3] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][3]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>";
		<%} else {%>
content+="		<td>0.0%</td>";
		<%}%>
		
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][4]))%></td>";
		<%if( arrData[ni][4] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][4]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>";
		<%} else {%>
content+="		<td>0.0%</td>";
		<%}%>
content+="	</tr>";

	
<%	}
} else {%>
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
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>