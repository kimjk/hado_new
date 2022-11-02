<%@ page session="true" language="java" contentType="application/vnd.ms-excel; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��	: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���	: Oent_Violate_16_Excel.jsp
* ���α׷�����	: ������� > �������м� > ǥ���ϵ��ް�༭ ��뿩��
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

	String[][] arrData = new String[51][8];
	float[] arrSum = new float[6];

	int nLoop = 1;
	int sStartYear = 2000;

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
	for(int i=1; i <=3; i++) { 
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
		sSQLs+="	SUM(CASE A.C WHEN '1' THEN 1 ELSE 0 END) AS Field03 FROM ( \n";
		sSQLs+="		SELECT * FROM "+currentTalbe+" \n";
		sSQLs+="		WHERE Current_Year='"+currentYear+"'  \n";

		if( session.getAttribute("wgb").equals("1") ) {
			if( currentYear >= 2014 ) {
				sSQLs+="			AND Oent_Q_CD=15 AND Oent_Q_GB=1  AND Oent_GB='1' \n";
			} else if( currentYear == 2003 ) {
				sSQLs+="			AND Oent_Q_CD=9 AND Oent_Q_GB=1  AND Oent_GB='1' \n";
			} else if( currentYear <= 2002) {
				sSQLs+="			AND Oent_Q_CD=3 AND Oent_Q_GB=1  AND Oent_GB='1' \n";
			} else {
				sSQLs+="			AND Oent_Q_CD=10 AND Oent_Q_GB=1  AND Oent_GB='1' \n";
			}

		} else if( session.getAttribute("wgb").equals("2") ) {
			if( currentYear >= 2015 ) {
				sSQLs+="			AND Oent_Q_CD=16 AND Oent_Q_GB=1  AND Oent_GB='2' \n";
			} else if( currentYear >= 2014 ) {
				sSQLs+="			AND Oent_Q_CD=15 AND Oent_Q_GB=1  AND Oent_GB='2' \n";
			} else if( currentYear == 2010 ) {
				sSQLs+="			AND Oent_Q_CD=11 AND Oent_Q_GB=1  AND Oent_GB='2' \n";
			} else if( currentYear == 2003) {
				sSQLs+="			AND Oent_Q_CD=9 AND Oent_Q_GB=1  AND Oent_GB='2' \n";
			} else if( currentYear == 2002) {
				sSQLs+="			AND Oent_Q_CD=2 AND Oent_Q_GB=1  AND Oent_GB='2' \n";
			} else if( currentYear < 2002) {
				sSQLs+="			AND Oent_Q_CD=3 AND Oent_Q_GB=1  AND Oent_GB='2' \n";
			} else {
				sSQLs+="			AND Oent_Q_CD=10 AND Oent_Q_GB=1  AND Oent_GB='2' \n";
			}

		} else if( session.getAttribute("wgb").equals("3") ) {
			if( currentYear >= 2014 ) {
				sSQLs+="			AND Oent_Q_CD=14 AND Oent_Q_GB=1  AND Oent_GB='3' \n";
			} else if( currentYear == 2010 ) {
				sSQLs+="			AND Oent_Q_CD=9 AND Oent_Q_GB=1  AND Oent_GB='3' \n";
			} else {
				sSQLs+="			AND Oent_Q_CD=10 AND Oent_Q_GB=1  AND Oent_GB='3' \n";
			}

		} else {
			if( currentYear >= 2015 ) {
				sSQLs+="			AND ( (Oent_Q_CD=15 AND Oent_Q_GB=1  AND Oent_GB='1') \n";
				sSQLs+="				OR (Oent_Q_CD=16 AND Oent_Q_GB=1  AND Oent_GB='2') \n";
				sSQLs+="				OR (Oent_Q_CD=14 AND Oent_Q_GB=1  AND Oent_GB='3') ) \n";
			} else if( currentYear >= 2014 ) {
				sSQLs+="			AND ( (Oent_Q_CD=15 AND Oent_Q_GB=1  AND Oent_GB='1') \n";
				sSQLs+="				OR (Oent_Q_CD=15 AND Oent_Q_GB=1  AND Oent_GB='2') \n";
				sSQLs+="				OR (Oent_Q_CD=14 AND Oent_Q_GB=1  AND Oent_GB='3') ) \n";
			} else if( currentYear == 2012 ) {
				sSQLs+="			AND ( (Oent_Q_CD=10 AND Oent_Q_GB=1  AND Oent_GB='1') \n";
				sSQLs+="				OR (Oent_Q_CD=10 AND Oent_Q_GB=1  AND Oent_GB='2') \n";
				sSQLs+="				OR (Oent_Q_CD=9 AND Oent_Q_GB=1  AND Oent_GB='3') ) \n";
			} else if( currentYear == 2010 ) {
				sSQLs+="			AND ( (Oent_Q_CD=10 AND Oent_Q_GB=1  AND Oent_GB='1') \n";
				sSQLs+="				OR (Oent_Q_CD=11 AND Oent_Q_GB=1  AND Oent_GB='2') \n";
				sSQLs+="				OR (Oent_Q_CD=10 AND Oent_Q_GB=1  AND Oent_GB='3') ) \n";
			} else if( currentYear == 2003) {
				sSQLs+="			AND ( (Oent_Q_CD=9 AND Oent_Q_GB=1  AND Oent_GB='1') \n";
				sSQLs+="				OR (Oent_Q_CD=9 AND Oent_Q_GB=1  AND Oent_GB='2') \n";
				sSQLs+="				OR (Oent_Q_CD=9 AND Oent_Q_GB=1  AND Oent_GB='3') ) \n";
			} else if( currentYear <= 2002) {
				sSQLs+="			AND ( (Oent_Q_CD=3 AND Oent_Q_GB=1  AND Oent_GB='1') \n";
				sSQLs+="				OR (Oent_Q_CD=3 AND Oent_Q_GB=1  AND Oent_GB='2') \n";
				sSQLs+="				OR (Oent_Q_CD=3 AND Oent_Q_GB=1  AND Oent_GB='3') ) \n";
			} else {
				sSQLs+="			AND ( (Oent_Q_CD=10 AND Oent_Q_GB=1  AND Oent_GB='1') \n";
				sSQLs+="				OR (Oent_Q_CD=10 AND Oent_Q_GB=1  AND Oent_GB='2') \n";
				sSQLs+="				OR (Oent_Q_CD=10 AND Oent_Q_GB=1  AND Oent_GB='3') ) \n";
			}
		}
		sSQLs+="				AND Comp_Status='1' \n";
		sSQLs+="				AND Oent_Status='1' \n";
		sSQLs+="				AND Subcon_Type<='2' \n";
		sSQLs+="				AND Addr_Status IS NULL \n";

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
		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();
		
		nLoop = 1;

		while( rs.next() ) {

			arrData[nLoop][5] = rs.getString("Oent_Type");
			arrData[nLoop][6] = rs.getString("Common_NM")==null ? "":rs.getString("Common_NM").trim();
			arrData[nLoop][2] = rs.getString("Field01");
			arrData[nLoop][3] = rs.getString("Field02");
			arrData[nLoop][4] = rs.getString("Field03");
			arrData[nLoop][1] = "0";

			for(int i = 2; i <= 4; i++) {
				if( arrData[nLoop][i] != null && (!arrData[nLoop][i].equals("")) ) {
					arrData[nLoop][1] = "" + ( Long.parseLong(arrData[nLoop][1]) + Long.parseLong(arrData[nLoop][i]) );
				}
			}

			// ��� �Ұ�
			arrData[nLoop][7] = "0";

			if(arrData[nLoop][2] != null && (!arrData[nLoop][2].equals("")) ) {
				arrData[nLoop][7] = "" + ( Long.parseLong(arrData[nLoop][7]) + Long.parseLong(arrData[nLoop][2]) );
			}
			if(arrData[nLoop][3] != null && (!arrData[nLoop][3].equals("")) ) {
				arrData[nLoop][7] = "" + ( Long.parseLong(arrData[nLoop][7]) + Long.parseLong(arrData[nLoop][3]) );
			}

			for(int i=1; i<=4; i++) {
				arrSum[i] = arrSum[i] + Float.parseFloat(arrData[nLoop][i]);
			}

			// ��� �Ұ�
			arrSum[5] = arrSum[5] + Float.parseFloat(arrData[nLoop][7]);

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
				<th rowspan='2'>�����</th>
		<%if( currentYear == 2012 ) {%>
				<th colspan='2'>��뿩��</th>
		<%} else {%>
				<th colspan='4'>��뿩��</th>
		<%}%>
		  </tr>
			<tr>
		<%if( currentYear == 2012 ) {%>
				<th>�����</th>
				<th>������� ����</th>
		<%} else {%>
				<th>���λ��</th>
				<th>�Ϻλ��</th>
				<th>�Ұ�</th>
				<th>������� ����</th>
		<%}%>
		  </tr>

		<%if( !stt.equals("start") ) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<th rowspan='2'>��</th>
				<td><%=formater2.format(arrSum[1])%></td>
				<td><%=formater2.format(arrSum[2])%></td>
				<td><%=formater2.format(arrSum[3])%></td>
		<%if( currentYear != 2012 ) {%>
				<td><%=formater2.format(arrSum[5])%></td>
				<td><%=formater2.format(arrSum[4])%></td>
		<%}%>
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
		<%if( currentYear != 2012 ) {%>
			<%if( arrSum[1] > 0F) {%>
				<td><%=formater.format(arrSum[5] / arrSum[1] * 100F)%>%</td>
			<%} else {%>
				<td>0.0%</td>
			<%}%>
			<%if( arrSum[1] > 0F) {%>
				<td><%=formater.format(arrSum[4] / arrSum[1] * 100F)%>%</td>
			<%} else {%>
				<td>0.0%</td>
			<%}%>
		<%}%>
			</tr>

			<%for(int ni=1; ni<=nLoop; ni++) {%>
			<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
				<%if( !session.getAttribute("wgb").equals("") ) {%>	
				<th rowspan='2'><%=arrData[ni][5]%> (<%=arrData[ni][6]%>)</th>
				<%} else {%>
						<%if( arrData[ni][5].equals("1") ) {%>		
				<th rowspan='2'>����</th>
						<%} else if( arrData[ni][5].equals("2") ) {%>
				<th rowspan='2'>�Ǽ�</th>
						<%} else if( arrData[ni][5].equals("3") ) {%>								
				<th rowspan='2'>�뿪</th>
						<%}
				}%>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][1]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][2]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][3]))%></td>
		<%if( currentYear != 2012 ) {%>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][7]))%></td>
				<td><%=formater2.format(Float.parseFloat(arrData[ni][4]))%></td>
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
		<%if( currentYear != 2012 ) {%>
				<%if( arrData[ni][7] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][7]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
				<%if( arrData[ni][4] != null) {%>
				<td><%=formater.format(Float.parseFloat(arrData[ni][4]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>
				<%} else {%>
				<td>0.0%</td>
				<%}%>
		<%}%>			
			</tr>
			
		<%	}
		} else {%>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
		<%if( currentYear != 2012 ) {%>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
		<%}%>
			</tr>
		<%}%>
		</table>
	</body>
</html>