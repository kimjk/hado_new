<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();
	String sGB = request.getParameter("wgb")==null ? "":request.getParameter("wgb").trim();

	//int sStartYear = 2005;
	int sStartYear = 2011;
	int endCurrentYear=st_Current_Year_n;
/*=================================== Record Selection Processing =====================================*/
	if( !tmpYear.equals("") ) {
	if(str1 != null && str2 != null && str1.equals(str2) ) {
	<div id="container">
		<!-- Begin Main-menu -->
		<!-- Begin Contents -->
				<div id="divContent">
					</div>
		<!-- Begin Footer -->