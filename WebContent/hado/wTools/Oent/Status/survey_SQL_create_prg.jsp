<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="/hado/Include/WB_I_Global.jsp"%>
<%@ include file="/hado/Include/WB_I_chkSession.jsp"%>
<%@ page import="java.text.DecimalFormat"%>
<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. ������Ʈ�� : ������������ȸ �ϵ��ްŷ� �������ǽ������� �ο��� Ȩ������                         */
/*  2. ��ü���� :                                                                                      */
/*     - ��ü�� : ������������ȸ		            												   */
/*     - �����ڸ� : ������ �����				          											   */
/*     - ����ó : T) 02-2023-4491  F) 02-2023-4500													   */
/*  3. ���߾�ü���� :																				   */
/*     - ��ü�� : (��)�̲���																		   */
/*	   - Project Manamger : ������ ���� (pcxman99@naver.com)										   */
/*     - ����ó : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  4. ���� : 2009�� 5��																			   */
/*  5. ���۱��� : ������������ȸ ������±�															   */
/*  6. ���۱����� ���� ���� ���� �� ����� �Ҽ� �����ϴ�.											   */
/*  7. ������Ʈ���� : 																				   */
/*  8. ������Ʈ���� (���� / ����)																	   */
/*  9. ���																							   */
/*-----------------------------------------------------------------------------------------------------*/
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String sErrorMsg = "";	// �����޽���
	String sReturnURL = "/index.jsp";	// �̵�URL
	
	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sCYear = st_Current_Year;
	String sSQLs = "";

	// ���� ���� ������ ���� �迭
	//==> ���
	ArrayList arrQCD1 = new ArrayList();
	ArrayList arrQGB1 = new ArrayList();
	ArrayList arrCDNM1 = new ArrayList();
	ArrayList arrMoneyGB1 = new ArrayList();
	ArrayList arrIDT_QCD1 = new ArrayList();
	ArrayList arrIDT_QGB1 = new ArrayList();
	//==> ����
	ArrayList arrQCD2 = new ArrayList();
	ArrayList arrQGB2 = new ArrayList();
	ArrayList arrCDNM2 = new ArrayList();
	ArrayList arrMoneyGB2 = new ArrayList();
	ArrayList arrIDT_QCD2 = new ArrayList();
	ArrayList arrIDT_QGB2 = new ArrayList();

	// ���� ���� �迭
	String sAllSurveySQL="";
	String sAllSumSQL="";
	String sMoneySumSQL="";
	String sBiSumSQL="";
	String sSurveySQL="";
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	//int currentYear = st_Current_Year_n;
	//currentYear = Integer.parseInt(session.getAttribute("cyear")+"");
	//currentYear=2011;
	int currentYear = request.getParameter("cyear")==null ? st_Current_Year_n:Integer.parseInt(request.getParameter("cyear").trim());

	//String wgb = request.getAttribute("wgb")+"";
	String wgb = request.getParameter("wgb")==null ? "1":request.getParameter("wgb").trim();

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		sSQLs ="SELECT Oent_Q_CD,Oent_Q_GB,Oent_Q_CDNM,Money_GB,IDentity_Q_CD,IDentity_Q_GB \n";
		sSQLs+="FROM HADO_TB_Oent_Question \n";
		sSQLs+="WHERE Current_Year='"+currentYear+"' \n";
		//sSQLs+="WHERE Current_Year='2011' \n";
		sSQLs+="	AND Oent_GB='"+wgb+"' \n";
		//sSQLs+="	AND Oent_GB='1' \n";
		sSQLs+="	AND (Money_GB='1' OR Money_GB='2') \n";
		sSQLs+="ORDER BY Money_GB,Rank \n";

		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();
		
		while( rs.next() ) {
			String tmp_MoneyGB = rs.getString("Money_GB").trim();
		
			if( tmp_MoneyGB.equals("1") ) {
				arrQCD1.add(rs.getString("Oent_Q_CD"));
				arrQGB1.add(rs.getString("Oent_Q_GB"));
				arrCDNM1.add(new String(rs.getString("Oent_Q_CDNM").trim().getBytes("ISO8859-1"), "EUC-KR"));
				arrMoneyGB1.add(tmp_MoneyGB);
				arrIDT_QCD1.add(rs.getString("Identity_Q_CD"));
				arrIDT_QGB1.add(rs.getString("Identity_Q_GB"));
			} else {
				arrQCD2.add(rs.getString("Oent_Q_CD"));
				arrQGB2.add(rs.getString("Oent_Q_GB"));
				arrCDNM2.add(new String(rs.getString("Oent_Q_CDNM").trim().getBytes("ISO8859-1"), "EUC-KR"));
				arrMoneyGB2.add(tmp_MoneyGB);
				arrIDT_QCD2.add(rs.getString("Identity_Q_CD"));
				arrIDT_QGB2.add(rs.getString("Identity_Q_GB"));
			}
		}
		rs.close();

		/* ���� ���� ���� */
		String tmp_IDT_QCD = "";
		String tmp_IDT_QGB = "";
		String prev_QCD = "";
		String prev_QGB = "";
		String tmp_Duble = "F";
		int nWriteCnt = 0;
		for(int i=0; i<arrQCD1.size(); i++) {
			if( !(tmp_IDT_QCD.equals(arrIDT_QCD1.get(i)+"") && tmp_IDT_QGB.equals(arrIDT_QGB1.get(i)+"")) ) {
				if( !sAllSumSQL.equals("") ) { 
					sAllSumSQL+="+";
					sMoneySumSQL+="+";
					sAllSurveySQL+=", ";
				}
				sAllSumSQL+="SUM(NVL(cnt_"+arrQCD1.get(i)+arrQGB1.get(i)+",0))";
				sMoneySumSQL+="SUM(NVL(cnt_"+arrQCD1.get(i)+arrQGB1.get(i)+",0))";
				sAllSurveySQL+="SUM(NVL(cnt_"+arrQCD1.get(i)+arrQGB1.get(i)+",0))";

				nWriteCnt++;
			} else {
				tmp_Duble="T";
				nWriteCnt=0;
			}

			if( tmp_Duble.equals("T") ) {
				if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; }
				sSurveySQL+="CASE SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE WHEN Oent_Q_GB IN ("+prev_QGB+","+arrQGB1.get(i)+") THEN 1 ELSE 0 END ELSE 0 END) WHEN 2 THEN 1 WHEN 1 THEN 1 ELSE 0 END cnt_"+prev_QCD+prev_QGB;
				tmp_Duble="F";
			} else if( nWriteCnt==2 ) {
				if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; }
				sSurveySQL+="SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE Oent_Q_GB WHEN "+prev_QGB+" THEN 1 ELSE 0 END ELSE 0 END) cnt_"+prev_QCD+prev_QGB;
				nWriteCnt=1;
			}

			tmp_IDT_QCD=arrIDT_QCD1.get(i)+"";
			tmp_IDT_QGB=arrIDT_QGB1.get(i)+"";
			prev_QCD=arrQCD1.get(i)+"";
			prev_QGB=arrQGB1.get(i)+"";
		}
		if( tmp_Duble.equals("T") ) {
			if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; }
			sSurveySQL+="CASE SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE WHEN Oent_Q_GB IN ("+prev_QGB+","+arrQGB1.get(arrQCD1.size()-1)+") THEN 1 ELSE 0 END ELSE 0 END) WHEN 2 THEN 1 WHEN 1 THEN 1 ELSE 0 END cnt_"+prev_QCD+prev_QGB;
		} else {
			if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; }
			sSurveySQL+="SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE Oent_Q_GB WHEN "+prev_QGB+" THEN 1 ELSE 0 END ELSE 0 END) cnt_"+prev_QCD+prev_QGB;
		}
		
		prev_QCD="";
		prev_QGB="";
		tmp_Duble="F";
		nWriteCnt=0;
		for(int i=0; i<arrQCD2.size(); i++) {
			if( !(tmp_IDT_QCD.equals(arrIDT_QCD2.get(i)+"") && tmp_IDT_QGB.equals(arrIDT_QGB2.get(i)+"")) ) {
				if( !sAllSumSQL.equals("") ) { sAllSumSQL+="+"; sAllSurveySQL+=", ";  }
				if( !sBiSumSQL.equals("") ) { sBiSumSQL+="+"; }
				sAllSumSQL+="SUM(NVL(cnt_"+arrQCD2.get(i)+arrQGB2.get(i)+",0))";
				sBiSumSQL+="SUM(NVL(cnt_"+arrQCD2.get(i)+arrQGB2.get(i)+",0))";
				sAllSurveySQL+="SUM(NVL(cnt_"+arrQCD2.get(i)+arrQGB2.get(i)+",0))";
				nWriteCnt++;
			} else {
				tmp_Duble="T";
				nWriteCnt=0;
			}
			
			if( tmp_Duble.equals("T") ) {
				if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; }
				sSurveySQL+="CASE SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE WHEN Oent_Q_GB IN ("+prev_QGB+","+arrQGB2.get(i)+") THEN 1 ELSE 0 END ELSE 0 END) WHEN 2 THEN 1 WHEN 1 THEN 1 ELSE 0 END cnt_"+prev_QCD+prev_QGB;
				tmp_Duble="F";
			} else if( nWriteCnt==2 ) {
				if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; }
				sSurveySQL+="SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE Oent_Q_GB WHEN "+prev_QGB+" THEN 1 ELSE 0 END ELSE 0 END) cnt_"+prev_QCD+prev_QGB;
				nWriteCnt=1;
			}

			tmp_IDT_QCD=arrIDT_QCD2.get(i)+"";
			tmp_IDT_QGB=arrIDT_QGB2.get(i)+"";
			prev_QCD=arrQCD2.get(i)+"";
			prev_QGB=arrQGB2.get(i)+"";
		}
		if( tmp_Duble.equals("T") ) {
			if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; }
			sSurveySQL+="CASE SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE WHEN Oent_Q_GB IN ("+prev_QGB+","+arrQGB2.get(arrQCD2.size()-1)+") THEN 1 ELSE 0 END ELSE 0 END) WHEN 2 THEN 1 WHEN 1 THEN 1 ELSE 0 END cnt_"+prev_QCD+prev_QGB;
		} else {
			if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; }
			sSurveySQL+="SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE Oent_Q_GB WHEN "+prev_QGB+" THEN 1 ELSE 0 END ELSE 0 END) cnt_"+prev_QCD+prev_QGB;
		}
		/* ���� ���� �� */
	}
	catch(Exception e){
		e.printStackTrace();
	}
	finally {
		if ( rs != null ) try{rs.close();}catch(Exception e){}
		if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
		if ( conn != null ) try{conn.close();}catch(Exception e){}
		if ( resource != null ) resource.release();
	}
%>
<html>
<head>
	<title></title>
</head>
<body>
	��ü �հ� ���� (sAllSumSQL) : <br/><%=sAllSumSQL.replace("\n","<br/>")%><br/><br/>
	��� �հ� ���� (sMoneySumSQL) : <br/><%=sMoneySumSQL.replace("\n","<br/>")%><br/><br/>
	���� �հ� ���� (sBiSumSQL) : <br/><%=sBiSumSQL.replace("\n","<br/>")%><br/><br/>
	�׸� ���� (sSurveySQL) : <br/><%=sSurveySQL.replace("\n","<br/>")%><br/><br/>
	�׸� �հ� ���� (sAllSurveySQL) : <br/><%=sAllSurveySQL.replace("\n","<br/>")%>
</body>
</html>