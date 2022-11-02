<%@ page session="true" language="java" contentType="application/vnd.ms-excel; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��	: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���	: Oent_Violate_18_Excel.jsp
* ���α׷�����	: ������� > �������м� > �ϵ��޾�ü �������
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

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
	String comm = request.getParameter("comm")==null ? "":request.getParameter("comm").trim();

	ConnectionResource resource = null;
	String sCYear = st_Current_Year;
	String[][] arrData = new String[51][9];
	int nLoop = 1;
	java.util.Calendar cal = java.util.Calendar.getInstance();
	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
/*=================================== Record Selection Processing =====================================*/
	String sTradeST=request.getParameter("tradest")==null ? "":request.getParameter("tradest").trim();

	if( !tmpYear.equals("") ) {
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

	String currentAnswer ;
	if( currentYear==2015 ) {
		currentAnswer = "HADO_TB_OENT_ANSWER_2015 \n";
	} else if( currentYear==2014 ) {
		currentAnswer = "HADO_TB_OENT_ANSWER_2014 \n";
	} else if( currentYear==2013 ) {
		currentAnswer = "HADO_TB_OENT_ANSWER_2013 \n";
	} else if( currentYear==2032 ) {
		currentAnswer = "HADO_TB_OENT_ANSWER_2012 \n";
	}  else {
		currentAnswer = "HADO_TB_OENT_ANSWER \n";
	}

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
		if( !session.getAttribute("wgb").equals("") ) {
		if( currentYear >= 2014 ) {
			sSQLs+="	SUM(CASE A.A WHEN '1' THEN 1 ELSE 0 END) AS Field01, \n";
			sSQLs+="	SUM(CASE A.B WHEN '1' THEN 1 ELSE 0 END) AS Field02, \n";
			sSQLs+="	SUM(CASE A.C WHEN '1' THEN 1 ELSE 0 END) AS Field03, \n";
			sSQLs+="	SUM(CASE A.D WHEN '1' THEN 1 ELSE 0 END) AS Field04, \n";
			sSQLs+="	SUM(CASE A.E WHEN '1' THEN 1 ELSE 0 END) AS Field05 FROM ( \n";
			sSQLs+="		SELECT * FROM "+currentTalbe+" \n";
			sSQLs+="	SUM(CASE A.A WHEN '1' THEN 1 ELSE 0 END) AS Field01, \n";
			sSQLs+="	SUM(CASE A.B WHEN '1' THEN 1 ELSE 0 END) AS Field02, \n";
			sSQLs+="	SUM(CASE A.C WHEN '1' THEN 1 ELSE 0 END) AS Field03, \n";
			sSQLs+="	SUM(CASE A.D WHEN '1' THEN 1 ELSE 0 END) AS Field04 FROM ( \n";
			sSQLs+="		SELECT * FROM "+currentTalbe+" \n";
			sSQLs+="		WHERE Current_Year='"+currentYear+"'  \n";
		}

		if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="			AND Oent_Q_CD=14 AND Oent_Q_GB=1  AND Oent_GB='1' \n";
			} else if( currentYear == 2003 ) {
		} else if( session.getAttribute("wgb").equals("2") ) {
				sSQLs+="			AND Oent_Q_CD=14 AND Oent_Q_GB=1  AND Oent_GB='2' \n";
			} else if( currentYear == 2003 ) {
		} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="			AND Oent_Q_CD=13 AND Oent_Q_GB=1  AND Oent_GB='2' \n";
			} else {
				sSQLs+="			AND Oent_Q_CD=11 AND Oent_Q_GB=1  AND Oent_GB='3' \n";
		} else {
				sSQLs+="			AND ( (Oent_Q_CD=14 AND Oent_Q_GB=1  AND Oent_GB='1') \n";
				sSQLs+="				OR (Oent_Q_CD=14 AND Oent_Q_GB=1  AND Oent_GB='2') \n";
				sSQLs+="				OR (Oent_Q_CD=13 AND Oent_Q_GB=1  AND Oent_GB='3') ) \n";
			} else if( currentYear == 2003 ) {
		if( currentYear>=2014 ) {
			sSQLs+="	AND LENGTH(Mng_No)>6 \n";
		} else {
			sSQLs+="	AND LENGTH(Mng_No)>4 \n";
			sSQLs+="	AND SUBSTR(Mng_No,-7)<>'1234567' \n";
		}
		if( !sTradeST.equals("") ) {
		if( !session.getAttribute("wgb").equals("") ) {
			if( currentYear>=2012 ) 
		} else {
		//out.println(sSQLs);
		nLoop = 1;
	if( currentYear>=2014 ) {
		while( rs.next() ) {
			arrData[nLoop][7] = rs.getString("Oent_Type");
			arrData[nLoop][8] = rs.getString("Common_NM")==null ? "":new String(rs.getString("Common_NM").trim().getBytes("ISO8859-1"), "EUC-KR" );
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
	} else {
		while( rs.next() ) {
			for(int i = 2; i <= 5; i++) {
			for(int i=1; i<=5; i++) {
		rs.close();
	} catch(Exception e) {
	<head>
		<title>�׼� </title>
		<meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=euc-kr" />
	</head>
	<body>
		<!-- ���� ��½� �׵θ��� ���⵵�� ����-->
		<table border='1'>
		<%if( currentYear>=2014 ) {%>
			<tr>
				<th rowspan='2'>����</th>
				<th rowspan='2'>�����</th>
				<th colspan='5'>�������</th>
		  </tr>
			<tr>
				<th>100% (���� ������)</th>
				<th>80 ~ 100% �̸�
				<th>50 ~ 80% �̸�</th>
				<th>50% �̸�</th>
				<th>0% (���� ���ǰ��)</th>
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
			</tr>

			<%for(int ni=1; ni<=nLoop; ni++) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<%if( !session.getAttribute("wgb").equals("") ) {%>	
				<th rowspan='2'><%=arrData[ni][7]%> (<%=arrData[ni][8]%>)</th>
				<%} else {%>
						<%if( arrData[ni][7].equals("1") ) {%>		
				<th rowspan='2'>����</th>
						<%} else if( arrData[ni][7].equals("2") ) {%>
				<th rowspan='2'>�Ǽ�</th>
						<%} else if( arrData[ni][7].equals("3") ) {%>								
				<th rowspan='2'>�뿪</th>
						<%}
				}%>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][1]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][2]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][3]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][4]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][5]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][6]))%></td>
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

		<%} else {%>

		<table border='1'>
			<tr>
				<th rowspan='2'>����</th>
				<th rowspan='2'>�����</th>
				<th colspan='4'>�������</th>
		  </tr>
			<tr>
				<th>������</th>
				<th>���ǰ��</th>
				<th>����� ���ǰ�� ����</th>
				<th>��������(~2004��)</th>
		  </tr>

		<%if( !stt.equals("start") ) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<th rowspan='2'>��</th>
				<td><%=formater2.format(arrSum[1])%></td>
				<td><%=formater2.format(arrSum[2])%></td>
				<td><%=formater2.format(arrSum[3])%></td>
				<td><%=formater2.format(arrSum[4])%></td>
				<td><%=formater2.format(arrSum[5])%></td>
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
			</tr>

			<%for(int ni=1; ni<=nLoop; ni++) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<%if( !session.getAttribute("wgb").equals("") ) {%>	
				<th rowspan='2'><%=arrData[ni][6]%> (<%=arrData[ni][7]%>)</th>
				<%} else {%>
						<%if( arrData[ni][6].equals("1") ) {%>		
				<th rowspan='2'>����</th>
						<%} else if( arrData[ni][6].equals("2") ) {%>
				<th rowspan='2'>�Ǽ�</th>
						<%} else if( arrData[ni][6].equals("3") ) {%>								
				<th rowspan='2'>�뿪</th>
						<%}
				}%>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][1]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][2]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][3]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][4]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][5]))%></td>
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
			</tr>
		<%}%>
		</table>
		<%}%>
	</body>
</html>