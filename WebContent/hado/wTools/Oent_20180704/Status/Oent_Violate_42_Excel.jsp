<%@ page session="true" language="java" contentType="application/vnd.ms-excel; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��	: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���	: Oent_Violate_42_Excel.jsp
* ���α׷�����	: ������� > �������м� > �ϵ��޴�� ���� ����
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
	String[][] arrData = new String[51][16];
	// 2010�� �亯�׸� ���� ���濡 ���� ����ó���� ���� �迭 ���� / 20100716 / ������
	int nItemCount = 12; // �׸񰳼�
	java.util.Calendar cal = java.util.Calendar.getInstance();
	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
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
		sSQLs+="SUM(CASE C.F WHEN '1' THEN 1 ELSE 0 END) AS Field06, \n";
		sSQLs+="SUM(CASE C.G WHEN '1' THEN 1 ELSE 0 END) AS Field07, \n";
		sSQLs+="SUM(CASE C.H WHEN '1' THEN 1 ELSE 0 END) AS Field08, \n";
		sSQLs+="SUM(CASE C.I WHEN '1' THEN 1 ELSE 0 END) AS Field09, \n";
		sSQLs+="SUM(CASE C.J WHEN '1' THEN 1 ELSE 0 END) AS Field10, \n";
		sSQLs+="SUM(CASE C.K WHEN '1' THEN 1 ELSE 0 END) AS Field11, \n";
		sSQLs+="SUM(CASE C.L WHEN '1' THEN 1 ELSE 0 END) AS Field12 FROM ( \n";
		// ��������
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="	AND Oent_GB='1' AND Oent_Q_CD=12 AND Oent_Q_GB=1 AND A='1' \n";
			} else if( session.getAttribute("wgb").equals("2") ) {
				sSQLs+="	AND Oent_GB='2' AND Oent_Q_CD=12 AND Oent_Q_GB=1 AND A='1' \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="	AND Oent_GB='3' AND Oent_Q_CD=11 AND Oent_Q_GB=1 AND A='1' \n";
			} else {
				sSQLs+="	AND ( (Oent_GB='1' AND Oent_Q_CD=12 AND Oent_Q_GB=1 AND A='1') \n";
				sSQLs+="		OR (Oent_GB='2' AND Oent_Q_CD=12 AND Oent_Q_GB=1 AND A='1' ) \n";
				sSQLs+="		OR (Oent_GB='3' AND Oent_Q_CD=11 AND Oent_Q_GB=1 AND A='1') ) \n";
			}
		} else if( currentYear>=2012 ) {
				sSQLs+="	AND Oent_GB='2' AND Oent_Q_CD=15 AND Oent_Q_GB=1 AND A='1' \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="		OR (Oent_GB='3' AND Oent_Q_CD=13 AND Oent_Q_GB=1 AND A='1') ) \n";
				sSQLs+="	AND Oent_GB='2' AND Oent_Q_CD=15 AND Oent_Q_GB=1 AND A='1' \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="		OR (Oent_GB='3' AND Oent_Q_CD=14 AND Oent_Q_GB=1 AND A='1') )  \n";
		if( currentYear>=2014 ) {
			sSQLs+="	AND LENGTH(Mng_No)>6 \n";
		} else {
			sSQLs+="	AND LENGTH(Mng_No)>4 \n";
			sSQLs+="	AND SUBSTR(Mng_No,-7)<>'1234567' \n";
		}
		if( !sTradeST.equals("") ) {
		//��������
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="	AND Oent_GB='1' AND Oent_Q_CD=12 AND Oent_Q_GB=2 \n";
			} else if( session.getAttribute("wgb").equals("2") ) {
				sSQLs+="	AND Oent_GB='2' AND Oent_Q_CD=12 AND Oent_Q_GB=2 \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="	AND Oent_GB='3' AND Oent_Q_CD=11 AND Oent_Q_GB=2 \n";
			} else {
				sSQLs+="	AND ( (Oent_GB='1' AND Oent_Q_CD=12 AND Oent_Q_GB=2) \n";
				sSQLs+="		OR (Oent_GB='2' AND Oent_Q_CD=12 AND Oent_Q_GB=2 ) \n";
				sSQLs+="		OR (Oent_GB='3' AND Oent_Q_CD=11 AND Oent_Q_GB=2) ) \n";
			}
		} else if( currentYear>=2012 ) {
				sSQLs+="	AND Oent_GB='2' AND Oent_Q_CD=15 AND Oent_Q_GB=2 \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="		OR (Oent_GB='3' AND Oent_Q_CD=13 AND Oent_Q_GB=2) ) \n";
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="	AND Oent_GB='1' AND Oent_Q_CD=15 AND Oent_Q_GB=2 \n";
			} else if( session.getAttribute("wgb").equals("2") ) {
				sSQLs+="	AND Oent_GB='2' AND Oent_Q_CD=15 AND Oent_Q_GB=2 \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="	AND Oent_GB='3' AND Oent_Q_CD=14 AND Oent_Q_GB=2 \n";
			} else {
				sSQLs+="	AND ( (Oent_GB='1' AND Oent_Q_CD=15 AND Oent_Q_GB=2) \n";
				sSQLs+="		OR (Oent_GB='2' AND Oent_Q_CD=15 AND Oent_Q_GB=2)  \n";
				sSQLs+="		OR (Oent_GB='3' AND Oent_Q_CD=14 AND Oent_Q_GB=2) ) \n";
			}
		}
		sSQLs+=") C ON A.Mng_No=C.Mng_No AND A.Current_Year=C.Current_Year AND A.Oent_GB=C.Oent_GB \n";
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
			
		nLoop = 1;
		while( rs.next() ) {
			arrData[nLoop][2] = rs.getString("Field01");
			arrData[nLoop][8] = rs.getString("Field07");
			arrData[nLoop][9] = rs.getString("Field08");
			arrData[nLoop][10] = rs.getString("Field09");
			arrData[nLoop][11] = rs.getString("Field10");
			arrData[nLoop][12] = rs.getString("Field11");
			arrData[nLoop][13] = rs.getString("Field12");
			arrData[nLoop][1] = "0";
			for(int i = 2; i <= 13; i++) {
			for(int i=1; i<=13; i++) {
	} catch(Exception e) {
	/*--------- 20100716 / ������ : ���׳��� ���� ���� ó��----------*/
	arrItemText[1] = "���ּ���� �������� ����";
	arrItemText[2] = "������ �ֹ����";
	arrItemText[3] = "�Ǹź������� ���� ����д�";
	arrItemText[4] = "����������, �Ǹ������� ������ ����";
	arrItemText[5] = "�������� �Ǵ� �����Ǹ�";
	arrItemText[6] = "�ڱݻ���";
	arrItemText[7] = "ȯ������";
	arrItemText[8] = "���� �Ǵ� ���簡���� ��ǰ������ ���Ͽ� �϶�";
	arrItemText[9] = "��Ź��ǰ�� �ǸŰ��� ����";
	arrItemText[10] = "�����縦 �ϰ� �����Ͽ� �Ǹ��� �� ���尡�ݺ��� ��ΰ� �ϵ��޴�ݿ��� ����";
	arrItemText[11] = "��Ÿ";

	 if( session.getAttribute("wgb").equals("2") ) {
		arrItemText[0] = "���ڽð� �� ���޻������ å��";
		arrItemText[1] = "�������� �������";
		arrItemText[2] = "�ù漭��� �ð����� ����";
		arrItemText[3] = "���� ���޺����� �����ų�, ���ޱ��� ���� ����";
		arrItemText[4] = "���������Ⱓ�� ����";
		arrItemText[5] = "��������";
		arrItemText[6] = "�ڱݻ���";
		arrItemText[7] = "���� �Ǵ� ���簡���� ��ǰ������ ���Ͽ� �϶�";
		arrItemText[8] = "�������� �ϰ� �����Ͽ� �Ǹ��� �� ���尡�ݺ��� ��ΰ� �ϵ��޴�ݿ��� ����";
		arrItemText[9] = "��Ÿ";
		nItemCount = 10;
	} else if( session.getAttribute("wgb").equals("3") ) {
		arrItemText[0] = "�뿪���� ����";
		arrItemText[1] = "���ּ���� �뿪������� ����";
		arrItemText[2] = "������ �ֹ����";
		arrItemText[3] = "�����϶����� ���� ����д�";
		arrItemText[4] = "����������, �Ǹ������� ������ ����";
		arrItemText[5] = "��������";
		arrItemText[6] = "�ڱݻ���";
		arrItemText[7] = "ȯ������";
		arrItemText[8] = "���� �Ǵ� �ΰǺ� ��ǰ������ ���Ͽ� �϶�";
		arrItemText[9] = "��Ź�� ���Ĥ������������� �ǸŰ��� ����";
		arrItemText[10] = "�����縦 �ϰ� �����Ͽ� �Ǹ��� �� ���尡�ݺ��� ��ΰ� �ϵ��޴�ݿ��� ����";
		arrItemText[11] = "��Ÿ";
		nItemCount = 12;
	}
/*=====================================================================================================*/
	<head>
		<title>�׼� </title>
		<meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=euc-kr" />
	</head>
	<body>
		<!-- ���� ��½� �׵θ��� ���⵵�� ����-->
		<table border='1'>
		<%if( session.getAttribute("wgb").equals("1") ) {%>
		<colgroup>
			<col style='width:9%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
		</colgroup>
		<%} else if( session.getAttribute("wgb").equals("2") ) {%>
		<colgroup>
			<col style='width:12%;' />
			<col style='width:8%;' />
			<col style='width:8%;' />
			<col style='width:8%;' />
			<col style='width:8%;' />
			<col style='width:8%;' />
			<col style='width:8%;' />
			<col style='width:8%;' />
			<col style='width:8%;' />
			<col style='width:8%;' />
			<col style='width:8%;' />
			<col style='width:8%;' />
		</colgroup>
		<%} else if( session.getAttribute("wgb").equals("3") ) {%>
		<colgroup>
			<col style='width:9%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
			<col style='width:7%;' />
		</colgroup>
		<%}%>
		<tbody>
			<tr>
				<th>����</th>
				<th>�����</th>
		<%for( int ix=0; ix < nItemCount; ix++) {%>
				<th><%=arrItemText[ix]%></th>
		<%}%>
			</tr>

		<%if( !stt.equals("start") ) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<th rowspan='2'>��</th>

			<%for( int ix=0; ix <= nItemCount; ix++) {%>
				<td><%=formater2.format(arrSum[ix+1])%></td>
			<%}%>

			</tr>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<td>100.0%</td>

			<%for( int ix=0; ix < nItemCount; ix++) {%>
				<%if( arrSum[1] > 0F) {%>
				<td><%=formater.format(arrSum[ix+2] / arrSum[1] * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
			<%}%>

			</tr>

			<%for(int ni=1; ni<=nLoop; ni++) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<%if( !session.getAttribute("wgb").equals("") ) {%>
				<th rowspan='2'><%=arrData[ni][14]%> (<%=arrData[ni][15]%>)</th>
				<%} else {%>
					<%if( arrData[ni][14].equals("1") ) {%>
				<th rowspan='2'>����</th>
					<%} else if( arrData[ni][14].equals("2") ) {%>
				<th rowspan='2'>�Ǽ�</th>
					<%} else if( arrData[ni][14].equals("3") ) {%>
				<th rowspan='2'>�뿪</th>
					<%}%>
			<%}%>
			<%for( int ix=0; ix <= nItemCount; ix++) {%>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][ix+1]))%></td>
			<%}%>

			</tr>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
			<%if( !session.getAttribute("wgb").equals("") ) {%>
				<%if( arrSum[1] > 0F && arrData[ni][1] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][1]) / arrSum[1] * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
			<%} else {%>
				<td>100.0%</td>
			<%}%>

			<%for( int ix=1; ix <= nItemCount; ix++) {%>
				<%if( arrData[ni][ix+1] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][ix+1]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
			<%}%>
			</tr>
		<%}
		} else {%>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			<%for( int ix=1; ix <= nItemCount; ix++) {%>
				<td>&nbsp;</td>
			<%}%>
			</tr>
		<%}%>
		</tbody>
		</table>
	</body>
</html>