<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();

	ConnectionResource resource=null;
	String sSQLs="";
	String[][] arrData = new String[31][11];
	String tmpStr="";
	int nLoop=1;
	java.util.Calendar cal=java.util.Calendar.getInstance();
	DecimalFormat formater=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
/*=================================== Record Selection Processing =====================================*/
	if( !tmpYear.equals("") ) {
	int currentYear=st_Current_Year_n;
	if( tt.equals("start") ) {
	if( comm.equals("search") ) {
	}
	int endCurrentYear=st_Current_Year_n;
	/* 2012년 원사업자 관련 DB Table 분리 예외처리 시작 ============================================================> */
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
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=15 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=5 \n";
				} else if( currentYear==2014 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=13 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=5 \n";
				} else if( currentYear>=2012 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=19 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=5 \n";
				} else if( currentYear==2014 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=16 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=5 \n";
				} else if( currentYear>=2012 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=15 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=5 \n";
				} else if( currentYear==2014 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=13 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=5 \n";
				} else if( currentYear>=2012 ) {
					sSQLs+="		AND ( (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=15 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=5 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='1') \n";
					sSQLs+="			OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=19 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=5 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='2') \n";
					sSQLs+="			OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=15 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=5 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='3') ) \n";
	
					sSQLs+="		AND ( (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=13 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=5 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='1') \n";
					sSQLs+="			OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=16 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=5 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='2') \n";
					sSQLs+="			OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=13 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=5 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='3') ) \n";
				} else if( currentYear>=2012 ) {
			if( !session.getAttribute("wgb").equals("") ) {
			pstmt=conn.prepareStatement(sSQLs);
			nLoop=1;
				for(int i=1; i<=8; i++) {
				nLoop++;
<script type="text/javascript">
<%if( !tt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for(int ni=1; ni<=nLoop; ni++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%}%>
top.document.getElementById("divResult").innerHTML=content;