<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
	String sErrorMsg = "";
	int nNewNo = 0;
	String q_No = request.getParameter("no")==null ? "":request.getParameter("no").trim();
	ConnectionResource resource = null;
	String d_Class = "";
/*=================================== Record Selection Processing =====================================*/
			sSQLs ="SELECT * \n";
			pstmt = conn.prepareStatement(sSQLs);
			while (rs.next()) {
		sSQLs ="SELECT Board_Type \n";
		while (rs.next()) {
<script type="text/javascript">
content+="<div id='viewWinTop'>";
content+="<div id='viewWinTitle'>���� �Խù� ���</div>";
content+="<table class='ViewResultTable' align='center'>";
content+="<div id='divViewWinbutton'>";
top.document.getElementById("divView").innerHTML = content;
top.boardTextreplace();
<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>