<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();

	ConnectionResource resource=null;
	String sSQLs="";
	String[][] arrData=new String[31][14];
	String tmpStr="";
	int nLoop=1;
	java.util.Calendar cal=java.util.Calendar.getInstance();
	DecimalFormat formater=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
/*=================================== Record Selection Processing =====================================*/

	if( tt.equals("start") ) {
	if( comm.equals("search") ) {
	}
	if( !tmpYear.equals("") ) {
	int currentYear=st_Current_Year_n;
	int endCurrentYear=st_Current_Year_n;
	// view table name
	// 합계배열 초기화
	try {
		if( !tt.equals("start") ) {
				sSQLJoinTable+="	LEFT JOIN HADO_TB_Subcon_"+currentYear+" A2 \n";

			if( !session.getAttribute("wgb").equals("") ) {
			sSQLs+="WHERE a.Current_Year='"+currentYear+"' AND a.Sent_Status='1' AND a.comp_status='1' \n";
			/* 2015-09-09 / 강슬기 / 2015년도 조사제외대상 조건 추가 
			if( currentYear>=2015 ) {
				sSQLs+="		AND a.sp_fld_03 IS NULL \n";
			}
			*/
			//System.out.print(sSQLs);
			nLoop=1;
				for(int i=1; i<=10; i++) {
				nLoop++;
content+="	<tr>";
<%if( !tt.equals("start") ) {%>
	<%for(int ni=1; ni<=nLoop; ni++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%}%>
top.document.getElementById("divResult").innerHTML=content;