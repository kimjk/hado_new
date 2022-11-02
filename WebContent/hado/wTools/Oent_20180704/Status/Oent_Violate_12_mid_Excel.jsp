<%@ page session="true" language="java" contentType="application/vnd.ms-excel; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��	: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���	: Oent_Violate_12_Excel.jsp
* ���α׷�����	: ������� > �������м� > �ϵ��޴�� ���޹��
* ���α׷�����	: 1.0.1
* �����ۼ�����	: 2015�� 06�� 23��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2015-06-23	������       �����ۼ�
*	2016-01-07	������		DB�������� ���� ���ڵ� ����
*/
%>
<%@ page import="java.sql.*"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
	String comm = request.getParameter("comm")==null ? "":request.getParameter("comm").trim();

	ConnectionResource resource = null;
	String sCYear = st_Current_Year;
	String[][] arrData = new String[51][12];
	int nLoop = 1;
	java.util.Calendar cal = java.util.Calendar.getInstance();
	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
/*=================================== Record Selection Processing =====================================*/
	String sTradeST=request.getParameter("tradest")==null ? "":request.getParameter("tradest").trim();

	if( stt.equals("start") ) {
	if( comm.equals("search") ) {
		session.setAttribute("wgb", request.getParameter("wgb")==null ? "":request.getParameter("wgb").trim());
	}

	// �հ�迭 �ʱ�ȭ
		arrSum[i] = 0F;
	}
	int currentYear = st_Current_Year_n;
	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");
	int endCurrentYear = st_Current_Year_n;
	// view table name
	if( currentYear==2016 ) {
		currentTalbe = "HADO_VT_OENT_ANSWER_ST_2016 \n";
	}else if( currentYear==2015 ) {
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
	String currentOent;
	if( currentYear==2016 ) {
		currentOent = "HADO_TB_OENT_2016 \n";
	}else if( currentYear==2015 ) {
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
	if( currentYear==2016 ) {
		currentPay = "HADO_TB_Rec_Pay_2016\n";
	}else if( currentYear==2015 ) {
		currentPay = "HADO_TB_Rec_Pay_2015\n";
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

		if( !session.getAttribute("wgb").equals("") ) {
			sSQLs="SELECT A.Oent_Type Oent_Type, B.Common_NM Common_NM, \n";
		} else {
			sSQLs="SELECT A.Oent_GB Oent_Type, '' Common_NM, \n";
		}

		sSQLs+="SUM(CASE Rec_Pay_GB WHEN '2' THEN C.Currency ELSE 0 END) Field01, \n";
		sSQLs+="SUM(CASE Rec_Pay_GB WHEN '2' THEN C.Ent_Card ELSE 0 END) Field02, \n";
		sSQLs+="SUM(CASE Rec_Pay_GB WHEN '2' THEN C.Ent_Loan ELSE 0 END) Field03, \n";
		sSQLs+="SUM(CASE Rec_Pay_GB WHEN '2' THEN C.Cred_Loan ELSE 0 END) Field04, \n";
		sSQLs+="SUM(CASE Rec_Pay_GB WHEN '2' THEN C.Buy_Loan ELSE 0 END) Field05, \n";
		sSQLs+="SUM(CASE Rec_Pay_GB WHEN '2' THEN C.Network_Loan ELSE 0 END) Field06, \n";
		sSQLs+="SUM(CASE Rec_Pay_GB WHEN '2' THEN C.Bill ELSE 0 END) Field07, \n";
		sSQLs+="SUM(CASE Rec_Pay_GB WHEN '2' THEN C.Etc ELSE 0 END) Field08 FROM ( \n";
		sSQLs+="    SELECT Mng_No, Current_Year, Oent_GB, Oent_Type, \n";
		sSQLs+="    NVL(CASE Subcon_Type WHEN '1' THEN '0' ELSE \n";
        sSQLs+="		CASE WHEN SP_FLD_01 IS NULL OR SP_FLD_01='NULL' THEN '4' ELSE SP_FLD_01 END \n";
        sSQLs+="    END, 0) TradeST FROM "+currentOent+" \n";
		sSQLs+="    WHERE Current_Year='"+currentYear+"' \n";
		sSQLs+="    and SP_FLD_04='1' \n";

		if( !session.getAttribute("wgb").equals("") ) {
			sSQLs+="		AND Oent_GB='"+session.getAttribute("wgb")+"' \n";
		}
		sSQLs+="		AND Comp_Status='1' \n";
		sSQLs+="		AND Oent_Status='1' \n";
		sSQLs+="		AND Subcon_Type<='2' \n";
		sSQLs+="		AND Addr_Status IS NULL \n";
		sSQLs+="		AND SUBSTR(Mng_No,-7)<>'1234567' \n";

		if(currentYear>=2014){
			sSQLs+="		AND LENGTH(Mng_No)>6 \n";
		} else{
			sSQLs+="		AND LENGTH(Mng_No)>4 \n";
		}
		sSQLs+=") A LEFT JOIN "+currentPay+" C \n";

		sSQLs+="ON A.Mng_No=C.Mng_No AND A.Current_Year=C.Current_Year AND A.Oent_GB=C.Oent_GB  \n";

		if( !session.getAttribute("wgb").equals("") ) {
			sSQLs+="LEFT JOIN ( \n";
			sSQLs+="	SELECT Common_CD, Common_NM, COMMON_GB \n";
			sSQLs+="	FROM COMMON_CD \n";
			sSQLs+="	WHERE Addon_GB='"+session.getAttribute("wgb")+"' \n";
			sSQLs+=") B ON Replace(A.Oent_Type,'i','I')=B.COMMON_CD  \n";
			if( currentYear>=2012 )
				sSQLs+="AND COMMON_GB='010' \n";
			if( !sTradeST.equals("") ) {
				sSQLs+="WHERE TradeST='"+sTradeST+"' \n";
			}
			sSQLs+="GROUP BY A.Oent_Type, B.Common_NM \n";
			sSQLs+="ORDER BY A.Oent_Type \n";

		} else {
			if( !sTradeST.equals("") ) {
				sSQLs+="WHERE TradeST='"+sTradeST+"' \n";
			}
			sSQLs+="GROUP BY A.Oent_GB \n";
			sSQLs+="ORDER BY A.Oent_GB \n";
		}

		System.out.println(sSQLs);

		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();

		nLoop = 1;

		while( rs.next() ) {
			arrData[nLoop][10] = rs.getString("Oent_Type");
			arrData[nLoop][11] = rs.getString("Common_NM")==null ? "":rs.getString("Common_NM").trim();
			arrData[nLoop][2] = rs.getString("Field01");
			arrData[nLoop][3] = rs.getString("Field02");
			arrData[nLoop][4] = rs.getString("Field03");
			arrData[nLoop][5] = rs.getString("Field04");
			arrData[nLoop][6] = rs.getString("Field05");
			arrData[nLoop][7] = rs.getString("Field06");
			arrData[nLoop][8] = rs.getString("Field07");
			arrData[nLoop][9] = rs.getString("Field08");
			arrData[nLoop][1] = "0";

			for(int i = 2; i <= 9; i++) {
				if( arrData[nLoop][i] != null && (!arrData[nLoop][i].equals("")) ) {
					arrData[nLoop][1] = "" + ( Double.parseDouble(arrData[nLoop][1]) + Double.parseDouble(arrData[nLoop][i]) );
				}
			}

			for(int i=1; i<=9; i++) {
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
	<head>
		<title>�׼� </title>
		<meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=euc-kr" />
	</head>
	<body>
		<!-- ���� ��½� �׵θ��� ���⵵�� ����-->
		<table border='1'>
			<tr>
				<th rowspan='2'>����</th>
				<th rowspan='2'>�հ�</th>
				<th colspan='8'>�ϵ��޴�� ���� (����: �鸸��)</th>
		  </tr>
			<tr>
				<th>����</th>
				<th>�������<br/>����ī��</th>
				<th>�������<br/>�ڱݴ���</th>
				<th>�ܻ����ä��<br/>�㺸����</th>
				<th>���ŷ�</th>
				<th>��Ʈ��ũ��</th>
				<th>����</th>
				<th>��Ÿ</th>
		  </tr>

		<%if( !stt.equals("start") ) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<th rowspan='2'>��</th>
				<td><%=formater2.format(arrSum[1])%></td>
				<td><%=formater2.format(arrSum[2])%></td>
				<td><%=formater2.format(arrSum[3])%></td>
				<td><%=formater2.format(arrSum[4])%></td>
				<td><%=formater2.format(arrSum[5])%></td>
				<td><%=formater2.format(arrSum[6])%></td>
				<td><%=formater2.format(arrSum[7])%></td>
				<td><%=formater2.format(arrSum[8])%></td>
				<td><%=formater2.format(arrSum[9])%></td>
			</tr>

			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<td>100.0%</td>
			<%if( arrSum[1] > 0F) {%>
				<td><%=formater.format(arrSum[2] / arrSum[1] * 100F)%>%</td>
			<%} else {%>
				<td>0.0%</td>
			<%}%>
			<%if( arrSum[1] > 0F) {%>
				<td><%=formater.format(arrSum[3] / arrSum[1] * 100F)%>%</td>
			<%} else {%>
				<td>0.0%</td>
			<%}%>
			<%if( arrSum[1] > 0F) {%>
				<td><%=formater.format(arrSum[4] / arrSum[1] * 100F)%>%</td>
			<%} else {%>
				<td>0.0%</td>
			<%}%>
			<%if( arrSum[1] > 0F) {%>
				<td><%=formater.format(arrSum[5] / arrSum[1] * 100F)%>%</td>
			<%} else {%>
				<td>0.0%</td>
			<%}%>
			<%if( arrSum[1] > 0F) {%>
				<td><%=formater.format(arrSum[6] / arrSum[1] * 100F)%>%</td>
			<%} else {%>
				<td>0.0%</td>
			<%}%>
			<%if( arrSum[1] > 0F) {%>
				<td><%=formater.format(arrSum[7] / arrSum[1] * 100F)%>%</td>
			<%} else {%>
				<td>0.0%</td>
			<%}%>
			<%if( arrSum[1] > 0F) {%>
				<td><%=formater.format(arrSum[8] / arrSum[1] * 100F)%>%</td>
			<%} else {%>
				<td>0.0%</td>
			<%}%>
			<%if( arrSum[1] > 0F) {%>
				<td><%=formater.format(arrSum[9] / arrSum[1] * 100F)%>%</td>
			<%} else {%>
				<td>0.0%</td>
			<%}%>
			</tr>

			<%for(int ni=1; ni<=nLoop; ni++) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<%if( !session.getAttribute("wgb").equals("") ) {%>
				<th rowspan='2'><%=arrData[ni][10]%> (<%=arrData[ni][11]%>)</th>
				<%} else {%>
						<%if( arrData[ni][10].equals("1") ) {%>
				<th rowspan='2'>����</th>
						<%} else if( arrData[ni][10].equals("2") ) {%>
				<th rowspan='2'>�Ǽ�</th>
						<%} else if( arrData[ni][10].equals("3") ) {%>
				<th rowspan='2'>�뿪</th>
						<%}
				}%>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][1]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][2]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][3]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][4]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][5]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][6]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][7]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][8]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][9]))%></td>
			</tr>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<%if( !session.getAttribute("wgb").equals("") ) {%>
					<%if( arrSum[1] > 0F && arrData[ni][1] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][1]) / arrSum[1] * 100F)%></td>
					<%} else {%>
				<td>0.0%</td>
					<%}%>
				<%} else {%>
				<td>100.0%</td>
				<%}%>

				<%if( arrData[ni][2] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][2]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
				<%if( arrData[ni][3] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][3]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
				<%if( arrData[ni][4] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][4]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
				<%if( arrData[ni][5] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][5]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
				<%if( arrData[ni][6] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][6]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
				<%if( arrData[ni][7] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][7]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
				<%if( arrData[ni][8] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][8]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
				<%if( arrData[ni][9] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][9]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
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
			</tr>
		<%}%>
		</table>
	</body>
</html>