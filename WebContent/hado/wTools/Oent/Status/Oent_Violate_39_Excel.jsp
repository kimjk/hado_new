<%@ page session="true" language="java" contentType="application/vnd.ms-excel; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명	: Oent_Violate_39_Excel.jsp
* 프로그램설명	: 원사업자 > 조사결과분석 > 위탁의 취소ㆍ변경 여부 
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2015년 06월 23일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2015-06-23	강슬기       최초작성
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

	ConnectionResource resource=null;
	Connection conn=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	
	String sCYear=st_Current_Year;
	String sSQLs="";
	String tmpStr="";

	String[][] arrData=new String[51][6];
	float[] arrSum=new float[4];

	int nLoop=1;
	int sStartYear=2009;

	java.util.Calendar cal=java.util.Calendar.getInstance();

	DecimalFormat formater=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	String tmpYear = request.getParameter("cyear")==null ? "":request.getParameter("cyear").trim();
	String sTradeST=request.getParameter("tradest")==null ? "":request.getParameter("tradest").trim();

	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
	}

	if( stt.equals("start") ) {
		session.setAttribute("wgb", "1");
	}

	if( comm.equals("search") ) {
		session.setAttribute("wgb", request.getParameter("wgb")==null ? "":request.getParameter("wgb").trim());
	}
	
	// 합계배열 초기화
	for(int i=1; i <=3; i++) {
		arrSum[i]=0F; 
	}
	
	int currentYear=st_Current_Year_n;
	currentYear=Integer.parseInt(session.getAttribute("cyear")+"");

	int endCurrentYear=st_Current_Year_n;

	// view table name
	String currentTalbe;
	if( currentYear==2015 ) {
		currentTalbe = "HADO_VT_OENT_ANSWER_ST_2015 \n";
	} else if( currentYear==2014 ) {
		currentTalbe = "HADO_VT_OENT_ANSWER_ST_2014 \n";
	} else if( currentYear==2013 ) {
		currentTalbe = "HADO_VT_OENT_ANSWER_ST_2013 \n";
	} else if( currentYear==2012 ) {
		currentTalbe = "HADO_VT_OENT_ANSWER_ST_2012 \n";
	}  else {
		currentTalbe = "HADO_VT_OENT_ANSWER_TRADEST \n";
	}

	try {
		resource=new ConnectionResource();
		conn=resource.getConnection();

		if( !session.getAttribute("wgb").equals("") ) {
			sSQLs="SELECT A.Oent_Type Oent_Type, B.Common_NM Common_NM, \n";
		} else {
			sSQLs="SELECT A.Oent_GB Oent_Type, '' Common_NM, \n";
		}	
		sSQLs+="SUM(CASE A.A WHEN '1' THEN 1 ELSE 0 END) AS Field01, \n";
		sSQLs+="SUM(CASE A.B WHEN '1' THEN 1 ELSE 0 END) AS Field02 FROM ( \n";
		sSQLs+="	SELECT * FROM "+currentTalbe+" \n";
		sSQLs+="	WHERE Current_Year='"+currentYear+"'  \n";

		if( currentYear>=2014 ) {
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="	AND Oent_GB='1' AND Oent_Q_CD=11 AND Oent_Q_GB=1 \n";	
			} else if( session.getAttribute("wgb").equals("2") ) {
				sSQLs+="	AND Oent_GB='2' AND Oent_Q_CD=11 AND Oent_Q_GB=1 \n";	
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="	AND Oent_GB='3' AND Oent_Q_CD=10 AND Oent_Q_GB=1 \n";	
			} else {
				sSQLs+="	AND ( (Oent_GB='1' AND Oent_Q_CD=11 AND Oent_Q_GB=1) \n";
				sSQLs+="		OR (Oent_GB='2' AND Oent_Q_CD=11 AND Oent_Q_GB=1 ) \n";
				sSQLs+="		OR (Oent_GB='3' AND Oent_Q_CD=10 AND Oent_Q_GB=1) ) \n";
			}
		} else if( currentYear>=2012 ) {
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="	AND Oent_GB='1' AND Oent_Q_CD=13 AND Oent_Q_GB=1 \n";	
			} else if( session.getAttribute("wgb").equals("2") ) {
				sSQLs+="	AND Oent_GB='2' AND Oent_Q_CD=14 AND Oent_Q_GB=1 \n";	
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="	AND Oent_GB='3' AND Oent_Q_CD=12 AND Oent_Q_GB=1 \n";	
			} else {
				sSQLs+="	AND ( (Oent_GB='1' AND Oent_Q_CD=13 AND Oent_Q_GB=1) \n";
				sSQLs+="		OR (Oent_GB='2' AND Oent_Q_CD=14 AND Oent_Q_GB=1 ) \n";
				sSQLs+="		OR (Oent_GB='3' AND Oent_Q_CD=12 AND Oent_Q_GB=1) ) \n";
			}
		} else {
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="	AND Oent_GB='1' AND Oent_Q_CD=13 AND Oent_Q_GB=3 \n";
			} else if( session.getAttribute("wgb").equals("2") ) {
				sSQLs+="	AND Oent_GB='2' AND Oent_Q_CD=14 AND Oent_Q_GB=3 \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="	AND Oent_GB='3' AND Oent_Q_CD=12 AND Oent_Q_GB=3 \n";
			} else {
				sSQLs+="	AND ( (Oent_GB='1' AND Oent_Q_CD=13 AND Oent_Q_GB=3) \n";
				sSQLs+="		OR (Oent_GB='2' AND Oent_Q_CD=14 AND Oent_Q_GB=3 )  \n";
				sSQLs+="		OR (Oent_GB='3' AND Oent_Q_CD=12 AND Oent_Q_GB=3) )  \n";
			}
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
			sSQLs+="				AND TradeST='"+sTradeST+"' \n";
		}
		sSQLs+=") A  \n";

		if( !session.getAttribute("wgb").equals("") ) {
			sSQLs+="LEFT JOIN ( \n";
			sSQLs+="	SELECT Common_CD, Common_NM, COMMON_GB \n";
			sSQLs+="	FROM COMMON_CD \n";
			sSQLs+="	WHERE Addon_GB='"+session.getAttribute("wgb")+"' \n";
			sSQLs+=") B ON Replace(A.Oent_Type,'i','I')=B.COMMON_CD  \n";
			if( currentYear>=2012 ) 
			sSQLs+="AND COMMON_GB='010' \n";
			sSQLs+="GROUP BY A.Oent_Type, B.Common_NM \n";
			sSQLs+="ORDER BY A.Oent_Type \n";

		} else {
			sSQLs+="GROUP BY A.Oent_GB \n";
			sSQLs+="ORDER BY A.Oent_GB \n";
		}

		//System.out.println(sSQLs);
		pstmt=conn.prepareStatement(sSQLs);
		rs=pstmt.executeQuery();
		
		nLoop=1;
		while( rs.next() ) {
			arrData[nLoop][4]=rs.getString("Oent_Type");
			arrData[nLoop][5] = rs.getString("Common_NM")==null ? "":rs.getString("Common_NM").trim();
			arrData[nLoop][2]=rs.getString("Field01");
			arrData[nLoop][3]=rs.getString("Field02");
			arrData[nLoop][1]="0";
			for(int i=2; i <= 3; i++) {
				if( arrData[nLoop][i] != null && (!arrData[nLoop][i].equals("")) ) {
					arrData[nLoop][1]="" + ( Long.parseLong(arrData[nLoop][1]) + Long.parseLong(arrData[nLoop][i]) );
				}
			}
			for(int i=1; i<=3; i++) {
				arrSum[i]=arrSum[i] + Float.parseFloat(arrData[nLoop][i]);
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
<html>
	<head>
		<title>액셀 </title>
		<meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=euc-kr" />
	</head>
	<body>
		<!-- 엑셀 출력시 테두리가 생기도록 설정-->
		<table border='1'>
			<tr>
				<th rowspan='2'>구분</th>
				<th colspan='2'>응답 업체수</th>
				<th colspan='2'>있었음</th>
				<th colspan='2'>없었음</th>
			</tr>
			<tr>
				<th>업체수</th><th>비율</th>
				<th>응답수</th><th>비율</th>
				<th>응답수</th><th>비율</th>
		  </tr>
		<%if( !stt.equals("start") ) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<th>계</th>
				<td><%=formater2.format(arrSum[1])%></td>
				<td>100.0%</td>
				<td><%=formater2.format(arrSum[2])%></td>
			<%if( arrSum[1] > 0F) {%>	
				<td><%=formater.format(arrSum[2] / arrSum[1] * 100F)%>%</td>
			<%} else {%>				
				<td>0.0%</td>
			<%}%>
				<td><%=formater2.format(arrSum[3])%></td>
			<%if( arrSum[1] > 0F) {%>	
				<td><%=formater.format(arrSum[3] / arrSum[1] * 100F)%>%</td>
			<%} else {%>				
				<td>0.0%</td>
			<%}%>
			</tr>

			<%for(int ni=1; ni<=nLoop; ni++) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<%if( !session.getAttribute("wgb").equals("") ) {%>	
				<th><%=arrData[ni][4]%> (<%=arrData[ni][5]%>)</th>
				<%} else {%>
					<%if( arrData[ni][4].equals("1") ) {%>
				<th>제조</th> 
					<%} else if( arrData[ni][4].equals("2") ) {%>
				<th>건설</th> 
					<%} else if( arrData[ni][4].equals("3") ) {%>
				<th>용역</th> 
					<%}
				}%>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][1]))%></td>
				<%if( !session.getAttribute("wgb").equals("") ) {%>
					<%if( arrSum[1] > 0F && arrData[ni][1] != null ){%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][1]) / arrSum[1] * 100F)%>%</td>
					<%} else {%>
				<td>0.0%</td>
					<%}%>
				<%} else {%>
				<td>100.0%</td>
				<%}%>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][2]))%></td>
				<%if( Integer.parseInt(arrData[ni][1]) > 0 && arrData[ni][2] != null  ){%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][2]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][3]))%></td>
				<%if( Integer.parseInt(arrData[ni][1]) > 0 && arrData[ni][3] != null  ) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][3]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
			</tr>
		<%	}
		} else {%>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		<%}%>
		</table>
	</body>
</html>