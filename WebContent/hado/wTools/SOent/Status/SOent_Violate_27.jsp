<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();
	// 제조 업종배열
	// 건설 업종배열
	// 용역 업종배열
	//int sStartYear = 2000;
/*-----------------------------------------------------------------------------------------------------*/
	String tmpYear = request.getParameter("cyear")==null? "":request.getParameter("cyear").trim();
	if( !tmpYear.equals("") ) {
	if( tt.equals("start") ) {
	if( comm.equals("search") ) {
		session.setAttribute("wgb", request.getParameter("wgb")==null? "":request.getParameter("wgb").trim());
		session.setAttribute("violatecomp", request.getParameter("violatecomp")==null? "":request.getParameter("violatecomp").trim());
		session.setAttribute("violatecompno", request.getParameter("violatecompno")==null? "":request.getParameter("violatecompno").trim());
	}
	int currentYear = st_Current_Year_n;
	try {
		// 제조 업종 배열 생성
		sbSQLs1.append("SELECT COMMON_CD, COMMON_NM \n");
		pstmt = conn.prepareStatement(sbSQLs1.toString());
		while (rs.next()) {
		// 건설 업종 배열 생성
		while (rs.next()) {
		// 용역 업종 배열 생성
		while (rs.next()) {
	if(str1 != null && str2 != null && str1.equals(str2) ) {
	<div id="container">
		<!-- Begin Main-menu -->
		<!-- Begin Contents -->
				<div id="divContent">
					<div id="divButton">
					<div id="divResult" style="position:absolute;top:145px;z-index:59;background-color:#ffffff;">
					</div>
					<div id="divView" onMouseDown="f_DragMDown(this)" style="z-index:61;">
					</div>
		<!-- Begin Footer -->