<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();

	ConnectionResource resource=null;
	String sSQLs="";
	String[][] arrData=new String[31][12];
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
	// view table name
	// 합계배열 초기화
	try {
		if( !tt.equals("start") ) {
			if( currentYear>=2015 ) {
				sSQLJoinTable+="HADO_TB_Subcon_"+currentYear+".SP_FLD_03, \n";
			}
			*/
			if( currentYear>=2015 ) {
				sSQLJoinTable+="HADO_TB_Subcon_"+currentYear+".SP_FLD_03, \n";
			}
			sSQLJoinTable+=""+currentOent+".COMP_STATUS,HADO_TB_Subcon_"+currentYear+".RETURN_GB  \n";
			if( !session.getAttribute("wgb").equals("") ) {
			/* 2015-09-09 / 강슬기 / 2015년도 조사제외대상 조건 추가 
			if( currentYear>=2015 ) {
				sSQLs+="		AND jt.sp_fld_03 IS NULL \n";
			}
			*/
			if( currentYear>=2015 ) {
				sSQLs+="		AND jt.sp_fld_03 IS NULL \n";
			}
			if( session.getAttribute("wgb").equals("1") ) {
					sSQLs+="AND jt.SOent_Q_CD=10 AND jt.SOent_Q_GB=3 \n";
				} else if( currentYear>=2012 ) {
					sSQLs+="AND ( (jt.SOent_Q_CD=8 AND jt.SOent_Q_GB=3 AND jt.Oent_GB='1') \n";
					sSQLs+="OR (jt.SOent_Q_CD=10 AND jt.SOent_Q_GB=3 AND jt.Oent_GB='2') \n";
					sSQLs+="OR (jt.SOent_Q_CD=8 AND jt.SOent_Q_GB=3 AND jt.Oent_GB='3') ) \n";
				} else if( currentYear>=2012 ) {
			if( !session.getAttribute("wgb").equals("") ) {
			if( !session.getAttribute("wgb").equals("") ) {
			//System.out.print(sSQLs);
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