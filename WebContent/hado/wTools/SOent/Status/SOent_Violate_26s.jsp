<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
	ConnectionResource resource = null;
	String sSQLs = "";
	String OentInfo_TbNm = "HADO_TB_Oent";
	try {
		sSQLs ="SELECT REPLACE(Oent_Name,' ','_') Oent_Name, Mng_No, Oent_GB \n";
//System.out.println(sSQLs);
		pstmt = conn.prepareStatement(sSQLs);
		while (rs.next()) {
	content+="<table class='ViewResultTable' align='center'>";
	content+="<table class='ViewResultTable' align='center'>";
	content+="<div id='divViewWinbutton'>";
	top.document.getElementById("divView").innerHTML = content;