<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
	int sStartYear = 2011;
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
/*=====================================================================================================*/
	if(str1 != null && str2 != null && str1.equals(str2) ) {
<html>
	<div id="container">
		<!-- Begin Main-menu -->
		<!-- Begin Contents -->
				<div id="divContent">
					<div id="divResult" style="position:absolute;top:145px;z-index:59;background-color:#ffffff;">
					</div>
					<div id="divView" onMouseDown="f_DragMDown(this)" style="z-index:61;">
					</div>
		<!-- Begin Footer -->