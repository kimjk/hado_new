<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
	ArrayList arrNo = new ArrayList();
	ConnectionResource resource = null;
	String sSQLs = "";
	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/*=================================== Record Selection Processing =====================================*/
		sSQLs ="SELECT BOARD_NO,TO_CHAR(BOARD_DATE,'yyyy-mm-dd') BOARD_DATE,BOARD_CLASS,BOARD_TYPE, \n";
		if(q_SearchClass!=null && (!q_SearchClass.equals("")) ) {
		}
		if(q_SearchType!=null && (!q_SearchType.equals("")) ) {
			sSQLs+="	AND (Board_Type='"+new String(q_SearchType.getBytes("EUC-KR"), "ISO8859-1" )+"' \n";
		}
		if(q_SearchText!=null && (!q_SearchText.equals("")) ) {
			sSQLs+="	AND (Board_Subject LIKE '%"+new String(q_SearchText.trim().getBytes("EUC-KR"), "ISO8859-1" )+"%' \n";
		}
		pstmt = conn.prepareStatement(sSQLs);
		while (rs.next()) {
	content = "";
	content+="<table id='divButton'>";
	<%if( arrNo.size()>0 ) {
	content+="<div id='divButton'>";
	top.document.getElementById("divResult").innerHTML = content;
</script>