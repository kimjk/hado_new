<%@ page session="true" language="java" contentType="application/vnd.ms-excel; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명	: Oent_Violate_33_Excel.jsp
* 프로그램설명	: 원사업자 > 조사결과분석 > 법위반이 없는 현금성결제내역 제출업체 리스트
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2015년 06월 23일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2015-06-23	강슬기       최초작성
*	2016-01-07	민현근		DB변경으로 인한 인코딩 변경
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
	String tmpStr = "";

	String[][] arrData = new String[10001][14];

	int nLoop = 1;
	int sStartYear = 2003;

	java.util.Calendar cal = java.util.Calendar.getInstance();

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2 = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	String tmpYear = request.getParameter("cyear")==null ? "":request.getParameter("cyear").trim();
	String sTradeST=request.getParameter("tradest")==null ? "":request.getParameter("tradest").trim();
	String sAlign = request.getParameter("wAlign")==null ? "":request.getParameter("wAlign");
	String sName = request.getParameter("mName")==null ? "":request.getParameter("mName");

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

	int currentYear = st_Current_Year_n;

	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");

	int endCurrentYear = st_Current_Year_n;

	// view table name
	String currentOent;
	if( currentYear==2015 ) {
		currentOent = "HADO_TB_OENT_2015 \n";
	} else if( currentYear==2014 ) {
		currentOent = "HADO_TB_OENT_2014 \n";
	} else if( currentYear==2013 ) {
		currentOent = "HADO_TB_OENT_2013 \n";
	} else if( currentYear==2012 ) {
		currentOent = "HADO_TB_OENT_2012 \n";
	}  else {
		currentOent = "HADO_TB_OENT \n";
	}
	String currentCash = "";
	if( currentYear==2015 ) {
		currentCash = "HADO_TB_REC_PAY_2015 \n";
	} else if( currentYear==2014 ) {
		currentCash = "HADO_TB_REC_PAY_2014 \n";
	} else if( currentYear==2013 ) {
		currentCash = "HADO_TB_OENT_CASH_PAYTYPE_2013 \n";
	} else if( currentYear==2012 ) {
		currentCash = "HADO_TB_OENT_CASH_PAYTYPE_2012 \n";
	}  else {
		currentCash = "HADO_TB_OENT_CASH_PAYTYPE \n";
	}
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

	if(currentYear>=2014) {
		sSQLs="SELECT * FROM ( \n";
		sSQLs+="	SELECT AA.*,NVL((BB.Survey_Money_Total+BB.Survey_Bi_Total),0) Survey_Total FROM ( \n";
		sSQLs+="		SELECT * FROM ( \n";
		sSQLs+="			SELECT B.Mng_no, B.Oent_GB, C.Oent_Name, C.Oent_Captine, \n";
		sSQLs+="			(B.CURRENCY + B.BILL + B.ETC + B.ENTCard + B.ENTLOAN + B.CREDLOAN + B.BUYLOAN + B.NETWORKLOAN) PaySum,  \n";
		sSQLs+="			B.CURRENCY, B.BILL, B.ETC, B.ENTCard, B.ENTLOAN, B.CREDLOAN, B.BUYLOAN, B.NETWORKLOAN, \n"; 
		sSQLs+="			C.Comp_Status, C.Subcon_Type, C.Addr_Status, C.Oent_Status FROM ( \n";
		sSQLs+="				SELECT Mng_No, Current_Year, Oent_GB, SUM(NVL(CURRENCY,0)) CURRENCY, SUM(NVL(BILL,0)) BILL, \n";
		sSQLs+="				SUM(NVL(ETC,0)) ETC, SUM(NVL(ENT_CARD,0)) ENTCard, SUM(NVL(ENT_LOAN,0)) ENTLOAN, SUM(NVL(CRED_LOAN,0)) CREDLOAN,  \n";
		sSQLs+="				SUM(NVL(BUY_LOAN,0)) BUYLOAN, SUM(NVL(NETWORK_LOAN,0)) NETWORKLOAN FROM ( \n";
		sSQLs+="					SELECT * FROM "+currentCash+" \n";
		sSQLs+="					WHERE Current_Year='"+currentYear+"' \n";
		sSQLs+="				) A \n";
		sSQLs+="				GROUP BY Mng_No, OENT_GB, Current_Year \n";
		sSQLs+="			) B LEFT JOIN "+currentOent+" C \n";
		sSQLs+="			ON B.Mng_No=C.Mng_No AND B.Current_Year=C.Current_Year AND B.Oent_GB=C.Oent_GB \n";
		sSQLs+="			WHERE SUBSTR(B.Mng_No,-7)<>'1234567' AND LENGTH(B.Mng_No)>6  \n";
		sSQLs+="			AND BILL=0 AND ETC=0 \n";

		if( !session.getAttribute("wgb").equals("") ) {
			sSQLs+="		AND B.Oent_GB='"+session.getAttribute("wgb")+"' \n";
		}
		sSQLs+="		) CCC \n";
		sSQLs+="		WHERE  Oent_Status='1' AND Subcon_Type<='2' AND Comp_Status='1' AND Addr_Status IS NULL\n";
		if( !sName.equals("") ) { 
		sSQLs+="		AND REPLACE(Oent_Name,' ','') LIKE '%"+new String(sName.trim().getBytes("EUC-KR"), "ISO8859-1" )+"%' \n";
		}
		sSQLs+="	) AA LEFT JOIN HADO_TB_Oent_Survey_Result BB \n";
		sSQLs+="	ON AA.Mng_No=BB.Mng_No AND AA.Oent_GB=BB.Oent_GB  \n";
		sSQLs+=") DDD \n";
		sSQLs+="WHERE Survey_Total = 0 ";
		if( sAlign.equals("2") ) {
		sSQLs+="ORDER BY REPLACE(Oent_Name,'(','')";
		} else {
		sSQLs+="ORDER BY Mng_No";
		}

	} else if(currentYear>=2012) {
		sSQLs="SELECT * FROM ( \n";
		sSQLs+="	SELECT AA.*,NVL((BB.Survey_Money_Total+BB.Survey_Bi_Total),0) Survey_Total FROM ( \n";
		sSQLs+="		SELECT * FROM ( \n";
		sSQLs+="			SELECT B.Mng_no, B.OENT_GB, C.OENT_NAME, C.OENT_CAPTINE, \n";
		sSQLs+="			(B.Cash + B.LC + B.BCard + B.BBlend + B.CreditLend + B.Buy + B.Network) PaySum, \n";
		sSQLs+="			B.Cash, B.LC, B.BCard, B.BBlend, B.CreditLend, B.Buy, B.Network, B.Current_Year, \n";
		sSQLs+="			C.Comp_Status, C.Subcon_Type, C.Addr_Status, C.Oent_Status FROM ( \n";
		sSQLs+="				SELECT Mng_No, OENT_GB, SUM(TYPE_CASH) Cash, SUM(TYPE_LOCALLC) LC, \n";
		sSQLs+="				SUM(TYPE_BCARD) BCard, SUM(TYPE_BBLEND) BBlend, SUM(TYPE_CREDITLEND) CreditLend, \n";
		sSQLs+="				SUM(Type_Buy) Buy, SUM(Type_Network) Network, Current_Year FROM ( \n";
		sSQLs+="					SELECT * FROM "+currentCash+" \n";
		sSQLs+="					WHERE Current_Year='"+currentYear+"' \n";
		sSQLs+="				) A \n";
		sSQLs+="				GROUP BY Mng_No, OENT_GB, Current_Year \n";
		sSQLs+="			) B LEFT JOIN "+currentOent+" C \n";
		sSQLs+="			ON B.Mng_No=C.Mng_No AND B.Current_Year=C.Current_Year AND B.Oent_GB=C.Oent_GB \n";
		sSQLs+="			WHERE SUBSTR(B.Mng_No,-7)<>'1234567' AND LENGTH(B.Mng_No)>4  \n";
				
		if( !session.getAttribute("wgb").equals("") ) {
			sSQLs+="			AND B.Oent_GB='"+session.getAttribute("wgb")+"' \n";
		}
		sSQLs+="		) CCC \n";
		sSQLs+="		WHERE  Oent_Status='1' AND Subcon_Type<='2' AND Comp_Status='1' AND Addr_Status IS NULL\n";
		if( !sName.equals("") ) { 
			sSQLs+="		AND REPLACE(Oent_Name,' ','') LIKE '%"+new String(sName.trim().getBytes("EUC-KR"), "ISO8859-1" )+"%' \n";
		}
		sSQLs+="	) AA LEFT JOIN HADO_TB_Oent_Survey_Result BB \n";
		sSQLs+="	ON AA.Mng_No=BB.Mng_No AND AA.Oent_GB=BB.Oent_GB AND AA.Current_Year=BB.Current_Year \n";
		sSQLs+=") DDD \n";
		sSQLs+="WHERE Survey_Total = 0 ";
		if( sAlign.equals("2") ) {
			sSQLs+="ORDER BY REPLACE(Oent_Name,'(','')";
		} else {
			sSQLs+="ORDER BY Mng_No";
		}
	}

		//System.out.println(sSQLs);
		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();

		nLoop = 1;

		while( rs.next() ) {
			arrData[nLoop][1] = rs.getString("Mng_No");
			arrData[nLoop][2] = rs.getString("Oent_GB");
			arrData[nLoop][3] = rs.getString("Oent_Name")==null ? "":rs.getString("Oent_Name").trim();
			arrData[nLoop][4] = rs.getString("Oent_Captine")==null ? "":rs.getString("Oent_Captine").trim();
			arrData[nLoop][5] = rs.getString("PaySum");
			if(currentYear>=2014) {
			arrData[nLoop][6] = rs.getString("CURRENCY");
			arrData[nLoop][7] = rs.getString("BILL");
			arrData[nLoop][8] = rs.getString("ETC");
			arrData[nLoop][9] = rs.getString("ENTCard");
			arrData[nLoop][10] = rs.getString("ENTLOAN");
			arrData[nLoop][11] = rs.getString("CREDLOAN");
			arrData[nLoop][12] = rs.getString("BUYLOAN");
			arrData[nLoop][13] = rs.getString("NETWORKLOAN");
			} else if(currentYear>=2012) {
			arrData[nLoop][6] = rs.getString("Cash");
			arrData[nLoop][7] = rs.getString("LC");
			arrData[nLoop][8] = rs.getString("BCard");
			arrData[nLoop][9] = rs.getString("BBlend");
			arrData[nLoop][10] = rs.getString("CreditLend");
			arrData[nLoop][11] = rs.getString("Buy");
			arrData[nLoop][12] = rs.getString("Network");
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
<html>
	<head>
		<title>액셀 </title>
		<meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=euc-kr" />
	</head>
	<body>
		<!-- 엑셀 출력시 테두리가 생기도록 설정-->
		<%if( currentYear>=2014) {%>
		<table border='1'>
			<tr>
				<th rowspan='2'>순번</th>
				<th rowspan='2'>원사업자명</th>
				<th rowspan='2'>관리번호</th>
				<th rowspan='2'>대표자</th>
				<th colspan='9'>결제금액</th>
			</tr>
			<tr>
				<th>계</th>
				<th>현금</th>
				<th>어음</th>
				<th>기타</th>
				<th>기업구매전용카드</th>
				<th>기업구매자금대출</th>
				<th>외상매출채권</th>
				<th>구매론</th>
				<th>네트워크론</th>
			</tr>

		<%if( !stt.equals("start") ) {%>
			<%for(int ni = 1; ni<= nLoop; ni++) {%>
			<tr>
				<td><%=ni%></td>
				<td><%=arrData[ni][3]%></td>
				<td><%=arrData[ni][1]%></td>
				<td><%=arrData[ni][4]%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][5]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][6]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][7]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][8]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][9]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][10]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][11]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][12]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][13]))%></td>
			</tr>
			<%}%>

		<%} else {%>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
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

		<%} else if( currentYear>=2012) {%>
		<table border='1'>
			<tr>
				<th rowspan='2'>순번</th>
				<th rowspan='2'>원사업자명</th>
				<th rowspan='2'>관리번호</th>
				<th rowspan='2'>대표자</th>
				<th colspan='8'>결제금액</th>
			</tr>
			<tr>
				<th>계</th>
				<th>현금,수표</th>
				<th>내국신용장</th>
				<th>기업구매전용카드</th>
				<th>기업구매자금대출</th>
				<th>상환청구권 없는 외상매출채권</th>
				<th>구매론</th>
				<th>상환청구권 없는 네트워크론</th>
			</tr>

		<%if( !stt.equals("start") ) {%>
			<%for(int ni = 1; ni<= nLoop; ni++) {%>
			<tr>
				<td><%=ni%></td>
				<td><%=arrData[ni][3]%></td>
				<td><%=arrData[ni][1]%></td>
				<td><%=arrData[ni][4]%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][5]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][6]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][7]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][8]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][9]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][10]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][11]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][12]))%></td>
			</tr>
			<%}%>

		<%} else {%>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
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
		<%}%>
	</body>
</html>