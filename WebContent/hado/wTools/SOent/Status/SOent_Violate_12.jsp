<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();
	String sGB = request.getParameter("wgb")==null ? "":request.getParameter("wgb").trim();

	//int sStartYear = 2005;
	int sStartYear = 2011;
	int endCurrentYear=st_Current_Year_n;
/*=================================== Record Selection Processing =====================================*/
	<link rel="stylesheet" href="/hado/hado/wTools/style.css" type="text/css">
</head>
	<div id="container">
		<!-- Begin Main-menu -->
		<!-- Begin Contents -->
				<div id="divContent">
										<option value="3" <%=isselected("3",sGB)%>>용역</option>
					<div id="divResult" style="position:absolute;top:145px;z-index:59;background-color:#ffffff;">
					</div>
					<div id="divView" onMouseDown="f_DragMDown(this)" style="z-index:61;">
					</div>