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

	String[][] arrData = new String[51][8];
	float[] arrSum = new float[6];

	int nLoop = 1;

	int sStartYear = 2007;

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

		sSQLs+="	SUM(CASE A.A WHEN '1' THEN 1 ELSE 0 END) AS Field01, \n";
		sSQLs+="	SUM(CASE A.B WHEN '1' THEN 1 ELSE 0 END) AS Field02, \n";
		sSQLs+="	SUM(CASE A.C WHEN '1' THEN 1 ELSE 0 END) AS Field03, \n";
		sSQLs+="	SUM(CASE A.D WHEN '1' THEN 1 ELSE 0 END) AS Field04 FROM ( \n";
		sSQLs+="		SELECT * FROM HADO_VT_Oent_Answer_TradeST A \n";
		sSQLs+="		WHERE Current_Year='"+currentYear+"'  \n";
		
		if( session.getAttribute("wgb").equals("1") ) {
			if( currentYear!=2007 && currentYear!=2008 ) {
				sSQLs+="			AND Oent_Q_CD=23 AND Oent_Q_GB=2  AND Oent_GB='1' \n";
			} else {
				sSQLs+="			AND Oent_Q_CD=24 AND Oent_Q_GB=2  AND Oent_GB='1' \n";
			}
			
		} else if( session.getAttribute("wgb").equals("2") ) {
			if( currentYear == 2010 ) {
				sSQLs+="			AND Oent_Q_CD=26 AND Oent_Q_GB=2  AND Oent_GB='2' \n";
			} 
		} else if( session.getAttribute("wgb").equals("3") ) {
			if( currentYear!=2007 && currentYear!=2008 ) {
				sSQLs+="			AND Oent_Q_CD=22 AND Oent_Q_GB=2  AND Oent_GB='3' \n";
			} else {
				sSQLs+="			AND Oent_Q_CD=23 AND Oent_Q_GB=2  AND Oent_GB='3' \n";
			}
		} else {
			if( currentYear!=2007 && currentYear!=2008 ) {
				sSQLs+="			AND ( (Oent_Q_CD=23 AND Oent_Q_GB=2  AND Oent_GB='1') \n";
				sSQLs+="				OR (Oent_Q_CD=26 AND Oent_Q_GB=2  AND Oent_GB='2') \n";
				sSQLs+="				OR (Oent_Q_CD=22 AND Oent_Q_GB=2  AND Oent_GB='3') ) \n";
			} else {
				sSQLs+="			AND ( (Oent_Q_CD=24 AND Oent_Q_GB=2 AND Oent_GB='1') \n";
				sSQLs+="				OR (Oent_Q_CD=23 AND Oent_Q_GB=2  AND Oent_GB='3') )  \n";
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
		sSQLs+=") A  \n";

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
			arrData[nLoop][6] = rs.getString("Oent_Type");
			arrData[nLoop][7] = new String( StringUtil.checkNull(rs.getString("Common_NM")).trim().getBytes("ISO8859-1"), "EUC-KR" );
			arrData[nLoop][2] = rs.getString("Field01");
			arrData[nLoop][3] = rs.getString("Field02");
			arrData[nLoop][4] = rs.getString("Field03");
			arrData[nLoop][5] = rs.getString("Field04");
			arrData[nLoop][1] = "0";
			for(int i = 2; i <= 5; i++) {
				if( arrData[nLoop][i] != null && (!arrData[nLoop][i].equals("")) ) {
					arrData[nLoop][1] = "" + ( Long.parseLong(arrData[nLoop][1]) + Long.parseLong(arrData[nLoop][i]) );
				}
			}
			for(int i=1; i<=5; i++) {
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
content+="		<th rowspan='2'>응답수</th>";
content+="		<th colspan='4'>미사용사유</th>";
content+="  </tr>";
content+="	<tr>";
content+="		<th>가이드라인에 대하여 잘 알고 있지 못하기 때문</th>";
content+="		<th>가이드라인에서 정한 사항이 너무 엄격하여 도입하기가 곤란하기 때문</th>";
content+="		<th>가이드라인 사용에 따른 인센티브가 충분치 못하기 때문</th>";
content+="		<th>기타</th>";
content+="  </tr>";

<%if( !stt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan='2'>계</th>";
content+="		<td><%=formater2.format(arrSum[1])%></td>";
content+="		<td><%=formater2.format(arrSum[2])%></td>";
content+="		<td><%=formater2.format(arrSum[3])%></td>";
content+="		<td><%=formater2.format(arrSum[4])%></td>";
content+="		<td><%=formater2.format(arrSum[5])%></td>";
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<td>100.0%</td>";
	<%if( arrSum[1] > 0F) {%>
content+="		<td><%=formater.format(arrSum[2] / arrSum[1] * 100F)%>%</td>";
	<%} else {%>
content+="		<td>0.0%</td>";
	<%}%>
	<%if( arrSum[1] > 0F) {%>
content+="		<td><%=formater.format(arrSum[3] / arrSum[1] * 100F)%>%</td>";
	<%} else {%>
content+="		<td>0.0%</td>";
	<%}%>
	<%if( arrSum[1] > 0F) {%>
content+="		<td><%=formater.format(arrSum[4] / arrSum[1] * 100F)%>%</td>";
	<%} else {%>
content+="		<td>0.0%</td>";
	<%}%>
	<%if( arrSum[1] > 0F) {%>
content+="		<td><%=formater.format(arrSum[5] / arrSum[1] * 100F)%>%</td>";
	<%} else {%>
content+="		<td>0.0%</td>";
	<%}%>
content+="	</tr>";

	<%for(int ni=1; ni<=nLoop; ni++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
		<%if( !session.getAttribute("wgb").equals("") ) {%>	
content+="		<th rowspan='2'><%=arrData[ni][6]%> (<%=arrData[ni][7]%>)</th>";
		<%} else {%>
				<%if( arrData[ni][6].equals("1") ) {%>		
content+="		<th rowspan='2'>제조</th>";
				<%} else if( arrData[ni][6].equals("2") ) {%>
content+="		<th rowspan='2'>건설</th>";
				<%} else if( arrData[ni][6].equals("3") ) {%>								
content+="		<th rowspan='2'>용역</th>";
				<%}
		}%>
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][1]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][2]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][3]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][4]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][5]))%></td>";
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
		<%if( !session.getAttribute("wgb").equals("") ) {%>	
			<%if( arrSum[1] > 0F && arrData[ni][1] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][1]) / arrSum[1] * 100F)%></td>";
			<%} else {%>
content+="		<td>0.0%</td>";
			<%}%>
		<%} else {%>
content+="		<td>100.0%</td>";
		<%}%>

		<%if( arrData[ni][2] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][2]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>";
		<%} else {%>
content+="		<td>0.0%</td>";
		<%}%>
		<%if( arrData[ni][3] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][3]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>";
		<%} else {%>
content+="		<td>0.0%</td>";
		<%}%>
		<%if( arrData[ni][4] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][4]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>";
		<%} else {%>
content+="		<td>0.0%</td>";
		<%}%>
		<%if( arrData[ni][5] != null) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][5]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>";
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
content+="	</tr>";
<%}%>
content+="</table>";

top.document.getElementById("divResult").innerHTML=content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>