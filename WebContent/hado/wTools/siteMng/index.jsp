<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ page import="java.text.DecimalFormat"%>
	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
	String sReturnStr = "";
	if(str.equals("����繫��") || str.equals("���� �繫��") ) {
	} else if(str.equals("���ֻ繫��") || str.equals("���� �繫��")) {
	return sReturnStr ;
	<link rel="stylesheet" href="/hado/hado/wTools/style.css" type="text/css">
	<div id="container">
		<!-- Begin Main-menu -->
		<!-- Begin Contents -->
				<div id="divContent">
					<div id="divResult"></div>
		<!-- Begin Footer -->