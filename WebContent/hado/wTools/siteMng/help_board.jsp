<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>

	ArrayList arrTypeName = new ArrayList();
	String sSQLs = "";
	int i = 1;
/*=================================== Record Selection Processing =====================================*/
		sSQLs ="SELECT Board_Type \n";
		pstmt = conn.prepareStatement(sSQLs);
		while (rs.next()) {
	<div id="container">
		<!-- Begin Main-menu -->
		<!-- Begin Contents -->
				<div id="divContent">
					<div id="divResult"></div>
		<!-- Begin Footer -->