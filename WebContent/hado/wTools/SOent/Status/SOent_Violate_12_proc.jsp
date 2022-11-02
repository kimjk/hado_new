<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();

	ConnectionResource resource=null;
	String sSQLs="";
	String[][] arrData = new String[31][12];
	String tmpStr="";
	int nLoop=1;
	java.util.Calendar cal=java.util.Calendar.getInstance();
	DecimalFormat formater=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	int currentYear=st_Current_Year_n;
	if( tt.equals("start") ) {
	int endCurrentYear=st_Current_Year_n;
	// 합계배열 초기화
	try {
		if( !tt.equals("start") ) {
			/* 2015-09-09 / 강슬기 / 2015년도 조사제외대상 조건 추가 
			if( currentYear>=2015 ) {
				sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".sp_fld_03 IS NULL \n";
			}
			*/
			if( currentYear>=2015 ) {
				sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".sp_fld_03 IS NULL \n";
			}
			sSQLs+="		AND "+currentOent+".Mng_No=HADO_TB_Subcon_"+currentYear+".Mng_No \n";
				if( currentYear>=2014 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=1 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=3 \n";
				} else if( currentYear>=2012 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=3 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=3 \n";
				}
			} else if( session.getAttribute("wgb").equals("3") ) {
				if( currentYear>=2014 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=1 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=3 \n";
				} else if( currentYear>=2012 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=3 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=3 \n";
				}
			} else {
				if( currentYear>=2014 ) {
					sSQLs+="		AND ( (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=1 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=3 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='1') \n";
					sSQLs+="			OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=1 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=3 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='3') ) \n";
				} else {
					sSQLs+="		AND ((HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=3 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=3 AND HADO_TB_Subcon_"+currentYear+".oent_gb='1') \n";
					sSQLs+="		OR ( HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=3  AND  HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=3 AND HADO_TB_Subcon_"+currentYear+".oent_gb='3')) \n";
				}
			}
			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".sent_no=HADO_TB_SOent_Answer_"+currentYear+".sent_no \n";
			if( !session.getAttribute("wgb").equals("") ) {
			pstmt=conn.prepareStatement(sSQLs);
			nLoop=1;
				for(int i=1; i<=9; i++) {
				nLoop++; 
top.document.getElementById("divResult").innerHTML=content;