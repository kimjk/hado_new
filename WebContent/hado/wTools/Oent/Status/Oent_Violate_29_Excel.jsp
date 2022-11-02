<%@ page session="true" language="java" contentType="application/vnd.ms-excel; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��	: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���	: Oent_Violate_29_Excel.jsp
* ���α׷�����	: ������� > �������м� > �ϵ��޴ܰ� ������(���󿵾�+�ϵ��ްŷ� ��ü ����)
* ���α׷�����	: 1.0.1
* �����ۼ�����	: 2015�� 06�� 23��	
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2015-06-23	������       �����ۼ�
*	2016-01-08	������		DB�������� ���� ���ڵ� ����
*/
%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="java.text.DecimalFormat"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>
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

	String[][] arrData = new String[51][11];
	float[] arrSum = new float[9];

	int nLoop = 1;

	int sStartYear = 2004;

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

	if( stt.equals("start") ) {
		session.setAttribute("wgb", "1");
	}

	if( comm.equals("search") ) {
		session.setAttribute("wgb", request.getParameter("wgb")==null ? "":request.getParameter("wgb").trim());
	}
	
	// �հ�迭 �ʱ�ȭ
	for(int i=1; i <=8; i++) { 
		arrSum[i] = 0F; 
	}
	
	int currentYear = st_Current_Year_n;
	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");

	int endCurrentYear = st_Current_Year_n;

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

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		if( !session.getAttribute("wgb").equals("") ) {
			sSQLs="SELECT AA.*,BB.Oent_Cnt FROM ( \n";
			sSQLs+="	SELECT A.Oent_Type Oent_Type, B.Common_NM Common_NM, \n";
		} else {
			sSQLs="SELECT AA.*,BB.Oent_Cnt FROM ( \n";
			sSQLs+="	SELECT A.Oent_GB Oent_Type, '' Common_NM, \n";
		}

		sSQLs+="	SUM(CASE C.A WHEN '1' THEN 1 ELSE 0 END) AS Field01, \n";
		sSQLs+="	SUM(CASE C.B WHEN '1' THEN 1 ELSE 0 END) AS Field02, \n";
		sSQLs+="	SUM(CASE C.C WHEN '1' THEN 1 ELSE 0 END) AS Field03, \n";
		sSQLs+="	SUM(CASE C.D WHEN '1' THEN 1 ELSE 0 END) AS Field04, \n";
		sSQLs+="	SUM(CASE C.E WHEN '1' THEN 1 ELSE 0 END) AS Field05, \n";
		sSQLs+="	SUM(CASE C.F WHEN '1' THEN 1 ELSE 0 END) AS Field06 FROM ( \n";
		sSQLs+="		SELECT * FROM "+currentTalbe+" \n";
		sSQLs+="		WHERE Current_Year='"+currentYear+"'  \n";
		// ��������
		if( currentYear>=2014 ) {
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="		AND Oent_GB='1' AND Oent_Q_CD=9 AND Oent_Q_GB=1 AND A='1' \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="		AND Oent_GB='3' AND Oent_Q_CD=8 AND Oent_Q_GB=1 AND A='1' \n";
			} else {
				sSQLs+="		AND ( (Oent_GB='1' AND Oent_Q_CD=9 AND Oent_Q_GB=1 AND A='1') \n";
				sSQLs+="			OR (Oent_GB='3' AND Oent_Q_CD=8 AND Oent_Q_GB=1 AND A='1') ) \n";
			}
		} else if( currentYear>=2012 ) {
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="		AND Oent_GB='1' AND Oent_Q_CD=11 AND Oent_Q_GB=1 AND A='1' \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="		AND Oent_GB='3' AND Oent_Q_CD=10 AND Oent_Q_GB=1 AND A='1' \n";
			} else {
				sSQLs+="		AND ( (Oent_GB='1' AND Oent_Q_CD=11 AND Oent_Q_GB=1 AND A='1') \n";
				sSQLs+="			OR (Oent_GB='3' AND Oent_Q_CD=10 AND Oent_Q_GB=1 AND A='1') ) \n";
			}
		} else {
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="		AND Oent_GB='1' AND Oent_Q_CD=11 AND Oent_Q_GB=4 AND A='1' \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="		AND Oent_GB='3' AND Oent_Q_CD=11 AND Oent_Q_GB=4 AND A='1' \n";
			} else {
				sSQLs+="		AND ( (Oent_GB='1' AND Oent_Q_CD=11 AND Oent_Q_GB=4 AND A='1') \n";
				sSQLs+="			OR (Oent_GB='3' AND Oent_Q_CD=11 AND Oent_Q_GB=4 AND A='1') )  \n";
			}
		}		
		sSQLs+="		AND Comp_Status='1' \n";
		sSQLs+="		AND Oent_Status='1' \n";
		sSQLs+="		AND Subcon_Type<='2' \n";
		sSQLs+="		AND Addr_Status IS NULL \n";
		if( currentYear>=2014 ) {
			sSQLs+="	AND LENGTH(Mng_No)>6 \n";
		} else {
			sSQLs+="	AND LENGTH(Mng_No)>4 \n";
			sSQLs+="	AND SUBSTR(Mng_No,-7)<>'1234567' \n";
		}
		if( !sTradeST.equals("") ) {
			sSQLs+="		AND TradeST='"+sTradeST+"' \n";
		}
		sSQLs+="	) A LEFT JOIN ( \n";
		sSQLs+="		SELECT * FROM "+currentTalbe+" \n";
		sSQLs+="		WHERE Current_Year='"+currentYear+"' \n";
		//��������
		if( currentYear>=2014 ) {
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="		AND Oent_GB='1' AND Oent_Q_CD=9 AND Oent_Q_GB=2 \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="		AND Oent_GB='3' AND Oent_Q_CD=8 AND Oent_Q_GB=2 \n";
			} else {
				sSQLs+="		AND ( (Oent_GB='1' AND Oent_Q_CD=9 AND Oent_Q_GB=2) \n";
				sSQLs+="			OR (Oent_GB='3' AND Oent_Q_CD=8 AND Oent_Q_GB=2) ) \n";
			}
		} else if( currentYear>=2012 ) {
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="		AND Oent_GB='1' AND Oent_Q_CD=11 AND Oent_Q_GB=2 \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="		AND Oent_GB='3' AND Oent_Q_CD=10 AND Oent_Q_GB=2 \n";
			} else {
				sSQLs+="		AND ( (Oent_GB='1' AND Oent_Q_CD=11 AND Oent_Q_GB=2) \n";
				sSQLs+="			OR (Oent_GB='3' AND Oent_Q_CD=10 AND Oent_Q_GB=2) ) \n";
			}
		} else {
			sSQLs+="		AND Oent_Q_CD=11 AND Oent_Q_GB=5 \n";
		}							
		sSQLs+="	) C ON A.Mng_No=C.Mng_No AND A.Current_Year=C.Current_Year AND A.Oent_GB=C.Oent_GB \n";

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
		sSQLs+=") AA LEFT JOIN ( \n";

		if( !session.getAttribute("wgb").equals("") ) {
			sSQLs+="	SELECT Oent_Type, COUNT(*) Oent_CNT FROM "+currentOent+" \n";
			sSQLs+="	WHERE Oent_Status='1' AND Comp_Status='1' AND Addr_Status IS NULL AND Subcon_Type <= '2' \n";
			sSQLs+="	AND Oent_GB='"+session.getAttribute("wgb")+"' AND Current_Year='"+currentYear+"' \n";
			sSQLs+="	GROUP BY Oent_Type \n";
		} else {
			sSQLs+="	SELECT Oent_GB Oent_Type, COUNT(*) Oent_CNT FROM "+currentOent+" \n";
			sSQLs+="	WHERE Oent_Status='1' AND Comp_Status='1' AND Addr_Status IS NULL AND Subcon_Type <= '2' \n";
			sSQLs+="	AND Current_Year='"+currentYear+"' \n";
			sSQLs+="	GROUP BY Oent_GB \n";
		}
		sSQLs+=") BB ON AA.Oent_Type=BB.Oent_Type \n"; 
		sSQLs+="ORDER BY AA.Oent_Type \n";	

		//System.out.println(sSQLs);
				
		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();
		
		nLoop = 1;
		while( rs.next() ) {

			arrData[nLoop][8] = rs.getString("Oent_Type");
			arrData[nLoop][9] = rs.getString("Common_NM")==null ? "":rs.getString("Common_NM").trim();
			arrData[nLoop][2] = rs.getString("Field01");
			arrData[nLoop][3] = rs.getString("Field02");
			arrData[nLoop][4] = rs.getString("Field03");
			arrData[nLoop][5] = rs.getString("Field04");
			arrData[nLoop][6] = rs.getString("Field05");
			arrData[nLoop][7] = rs.getString("Field06");
			arrData[nLoop][10] = rs.getString("Oent_Cnt");
			arrData[nLoop][1] = "0";

			for(int i = 2; i <= 7; i++) {
				if( arrData[nLoop][i] != null && (!arrData[nLoop][i].equals("")) ) {
					arrData[nLoop][1] = "" + ( Long.parseLong(arrData[nLoop][1]) + Long.parseLong(arrData[nLoop][i]) );
				}
			}

			for(int i=1; i<=7; i++) {
				arrSum[i] = arrSum[i] + Float.parseFloat(arrData[nLoop][i]);
			}

			arrSum[8] = arrSum[8] + Float.parseFloat(arrData[nLoop][10]);

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
		<title>�׼� </title>
		<meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=euc-kr" />
	</head>
	<body>
		<!-- ���� ��½� �׵θ��� ���⵵�� ����-->
		<table border='1'>
			<tr>
				<th rowspan='2'>����</th>
				<th colspan='2'>���󿵾�<br />�ϵ��޾�ü</th>
				<th colspan='2'>3% �̸�</th>
				<th colspan='2'>3% ~ 5%</th>
				<th colspan='2'>5% ~ 10%</th>
				<th colspan='2'>10% ~ 20%</th>
				<th colspan='2'>20% ~ 30%</th>
				<th colspan='2'>30% �̻�</th>
			</tr>
			<tr>
				<th>��ü��</th><th>����</th>
				<th>�����</th><th>����</th>
				<th>�����</th><th>����</th>
				<th>�����</th><th>����</th>
				<th>�����</th><th>����</th>
				<th>�����</th><th>����</th>
				<th>�����</th><th>����</th>
		  </tr>

		<%if( !stt.equals("start") ) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<th>��</th>

				<td><%=formater2.format(arrSum[8])%></td>
				<td>100.0%</th>

				<td><%=formater2.format(arrSum[2])%></td>
				<td><%if( arrSum[8] > 0F) {%><%=formater.format(arrSum[2] / arrSum[8] * 100F)%><%} else {%>0.0%<%}%></td>
				<td><%=formater2.format(arrSum[3])%></td>
				<td><%if( arrSum[8] > 0F) {%><%=formater.format(arrSum[3] / arrSum[8] * 100F)%><%} else {%>0.0%<%}%></td>
				<td><%=formater2.format(arrSum[4])%></td>
				<td><%if( arrSum[8] > 0F) {%><%=formater.format(arrSum[4] / arrSum[8] * 100F)%><%} else {%>0.0%<%}%></td>
				<td><%=formater2.format(arrSum[5])%></td>
				<td><%if( arrSum[8] > 0F) {%><%=formater.format(arrSum[5] / arrSum[8] * 100F)%><%} else {%>0.0%<%}%></td>
				<td><%=formater2.format(arrSum[6])%></td>
				<td><%if( arrSum[8] > 0F) {%><%=formater.format(arrSum[6] / arrSum[8] * 100F)%><%} else {%>0.0%<%}%></td>
				<td><%=formater2.format(arrSum[7])%></td>
				<td><%if( arrSum[8] > 0F) {%><%=formater.format(arrSum[7] / arrSum[8] * 100F)%><%} else {%>0.0%<%}%></td>
			</tr>

			<%for(int ni=1; ni<=nLoop; ni++) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<%if( !session.getAttribute("wgb").equals("") ) {%>
				<th><%=arrData[ni][8]%><br>(<%=arrData[ni][9]%>)</th>
				<%} else {%>
					<%if( arrData[ni][8].equals("1") ) {%>
				<th>����</th> 
					<%} else {%>
				<th>�뿪</th> 
					<%}%>
				<%}%>

				<td><%=formater2.format(Float.parseFloat(arrData[ni][10]))%></td>

				<%if( !session.getAttribute("wgb").equals("") ) {%>
					<%if( arrSum[1] > 0F && arrData[ni][10] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][10]) / arrSum[8] * 100F)%>%</td>
					<%} else {%>
				<td>100%</td>
					<%}%>
				<%} else {%>
				<td>100.0%</td>
				<%}%>

				<td><%=formater2.format(Float.parseFloat(arrData[ni][2]))%></td>
				<td><%if( arrData[ni][2] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][2]) / Float.parseFloat(arrData[ni][10]) * 100F)%><%} else {%>0.0%<%}%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][3]))%></td>
				<td><%if( arrData[ni][3] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][3]) / Float.parseFloat(arrData[ni][1]) * 100F)%><%} else {%>0.0%<%}%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][4]))%></td>
				<td><%if( arrData[ni][4] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][4]) / Float.parseFloat(arrData[ni][1]) * 100F)%><%} else {%>0.0%<%}%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][5]))%></td>
				<td><%if( arrData[ni][5] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][5]) / Float.parseFloat(arrData[ni][1]) * 100F)%><%} else {%>0.0%<%}%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][6]))%></td>
				<td><%if( arrData[ni][6] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][6]) / Float.parseFloat(arrData[ni][1]) * 100F)%><%} else {%>0.0%<%}%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][7]))%></td>
				<td><%if( arrData[ni][7] != null) {%> <%=formater.format(Float.parseFloat(arrData[ni][7]) / Float.parseFloat(arrData[ni][1]) * 100F)%> <%} else {%> 0.0% <%}%></td>
			</tr>

			<%}
		} else {%>
			<tr>
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