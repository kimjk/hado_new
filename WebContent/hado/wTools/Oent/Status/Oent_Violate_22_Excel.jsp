<%@ page session="true" language="java" contentType="application/vnd.ms-excel; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명	: Oent_Violate_22_Excel.jsp
* 프로그램설명	: 원사업자 > 조사결과분석 > 업체별 현금지급 비율
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

	String[][] arrData = new String[10001][4];

	int nLoop = 1;
	int sStartYear = 2000;

	java.util.Calendar cal = java.util.Calendar.getInstance();

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2 = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	String tmpYear = request.getParameter("cyear")==null ? "":request.getParameter("cyear").trim();
	String sTradeST=request.getParameter("tradest")==null ? "":request.getParameter("tradest").trim();
	String sAlign = request.getParameter("wAlign")==null ? "":request.getParameter("wAlign");
	String sName = request.getParameter("mName")==null ? "":request.getParameter("mName");
	String sCnt = request.getParameter("saCnt")==null ? "":request.getParameter("saCnt");

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
	
	String currentPay;
	if( currentYear==2015 ) {
		currentPay = "HADO_TB_Rec_Pay_2015 \n";
	} else if( currentYear==2014 ) {
		currentPay = "HADO_TB_Rec_Pay_2014 \n";
	} else if( currentYear==2013 ) {
		currentPay = "HADO_TB_Rec_Pay_2013 \n";
	} else if( currentYear==2012 ) {
		currentPay = "HADO_TB_Rec_Pay_2012 \n";
	}  else {
		currentPay = "HADO_TB_Rec_Pay \n";
	}

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		sSQLs="SELECT * FROM ( \n";
		sSQLs+="	SELECT A.Mng_No, A.Oent_Name, \n";
		sSQLs+="	(SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.currency,0) ELSE 0 END)/ \n";
		sSQLs+="	(CASE \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.currency,0) ELSE 0 END)+ \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.ent_card,0) ELSE 0 END)+ \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.ent_loan,0) ELSE 0 END)+ \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.cred_loan,0) ELSE 0 END)+ \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.bill,0) ELSE 0 END)+ \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.etc,0) ELSE 0 END) \n";
		sSQLs+="	WHEN 0 THEN 1 ELSE \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.currency,0) ELSE 0 END)+ \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.ent_card,0) ELSE 0 END)+ \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.ent_loan,0) ELSE 0 END)+ \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.cred_loan,0) ELSE 0 END)+ \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.buy_loan,0) ELSE 0 END)+ \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.network_loan,0) ELSE 0 END)+ \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.bill,0) ELSE 0 END)+ \n";
		sSQLs+="		SUM(CASE WHEN Rec_Pay_GB='2' THEN NVL(B.etc,0) ELSE 0 END) END) \n";
		sSQLs+="	*100) dValue FROM ( \n";
		sSQLs+="		SELECT Mng_No, Current_Year, Oent_GB, Oent_Name, \n";
		sSQLs+="		Comp_Status, Oent_Status, Subcon_Type, Addr_Status, \n";
		sSQLs+="		NVL(CASE Subcon_Type WHEN '1' THEN '0' ELSE \n";
        sSQLs+="			CASE WHEN SP_FLD_01 IS NULL OR SP_FLD_01='NULL' THEN '4' ELSE SP_FLD_01 END \n";
        sSQLs+="		END, 0) TradeST FROM "+currentOent+"  \n";
		sSQLs+="	) A LEFT JOIN "+currentPay+" B \n";
		sSQLs+="	ON A.Mng_No=B.Mng_No AND A.Current_Year=B.Current_Year AND A.Oent_GB=B.Oent_GB \n";
		sSQLs+="	WHERE A.Current_Year='"+currentYear+"' \n";
		sSQLs+="		AND A.Subcon_Type<='2' \n";
		sSQLs+="		AND A.Comp_Status='1' \n";
		sSQLs+="		AND A.Addr_Status IS NULL \n";
		sSQLs+="		AND A.Oent_Status='1' \n";

		if( currentYear>=2014 ) {
		sSQLs+="		AND LENGTH(A.Mng_No)>6 \n";
		} else {
		sSQLs+="		AND SUBSTR(A.Mng_No,-7)<>'1234567' \n";
		sSQLs+="		AND LENGTH(A.Mng_No)>4  \n";
		}
		if( !sTradeST.equals("") ) {
			sSQLs+="		AND TradeST='"+sTradeST+"' \n";
		}
		if( !sName.equals("") ) { 
			sSQLs+="		AND REPLACE(A.Oent_Name,' ','') LIKE '%"+new String(sName.trim().getBytes("EUC-KR"), "ISO8859-1" )+"%' \n";
		}
		if( !session.getAttribute("wgb").equals("") ) {
			sSQLs+="		AND A.Oent_GB='"+session.getAttribute("wgb")+"' \n";
		}
		sSQLs+="	GROUP BY A.Mng_No, A.Oent_Name \n";
		sSQLs+=") CCC \n";
		sSQLs+="ORDER BY dValue ";

		if( sAlign.equals("1") || sAlign.equals("") ) {
			sSQLs+="DESC \n";
		} else {
			sSQLs+="ASC \n";
		}

		//System.out.println(sSQLs);
		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();

		nLoop = 1;

		while( rs.next() ) {
			arrData[nLoop][1] = rs.getString("Mng_No");
			arrData[nLoop][2] = rs.getString("Oent_Name")==null ? "":rs.getString("Oent_Name").trim();
			arrData[nLoop][3] = rs.getString("dValue");
			nLoop++;
		}
		rs.close();
		nLoop--;

		if(sCnt.equals("10") ) {
			if(nLoop > 10) nLoop = 10;
		} else if(sCnt.equals("50") ) {
			if(nLoop > 50) nLoop = 50;
		} else if(sCnt.equals("100") ) {
			if(nLoop > 100) nLoop = 100;
		}
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
		<table border='1'>
			<tr>
				<th>순번</th>
				<th>회사명</th>
				<th>관리번호</th>
				<th>현금지급비율</th>
			</tr>

		<%if( !stt.equals("start") ) {%>
			<%for(int ni = 1; ni<= nLoop; ni++) {%>
			<tr>
				<td><%=ni%></td>
				<td><%=arrData[ni][1]%></td>
				<td><%=arrData[ni][2]%></td>
				<td><%=formater.format(Float.parseFloat(arrData[ni][3]))%>%</td>
			</tr>
			<%}%>

		<%} else {%>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		<%}%>
		</table>
	</body>
</html>