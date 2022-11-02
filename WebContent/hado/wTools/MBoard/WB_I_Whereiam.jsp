<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. 프로젝트명 : 공정관리위원회 하도급거래 서면직권실태조사					                       */
/*  2. 업체정보 :																					   */
/*     - 업체명 : (주)로티스아이																	   */
/*	   - Project Manamger : 정광식 부장 (pcxman99@naver.com)										   */
/*     - 연락처 : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  3. 일자 : 2009년 5월																			   */
/*  4. 최초작성자 및 일자 : (주)로티스아이 정광식 / 2011-10-18										   */
/*  5. 업데이트내용 (내용 / 일자)																	   */
/*  6. 비고																							   */
/*		1) 웹관리툴 리뉴얼 / 2011-10-18																   */
/*-----------------------------------------------------------------------------------------------------*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/
String sGroup = (request.getParameter("group")==null)? "":request.getParameter("group");
String sClass = (request.getParameter("class")==null)? "":request.getParameter("class");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/

/*=====================================================================================================*/
%>
					<div id="searchContent">
						<li class="subtitle"><%if( sGroup.equals("notice") ) {%>공지사항
							<%} else {%>전체 게시물<%}%>
						</li>
						<li class="whereiam">HOME > 커뮤니티 > <%if( sGroup.equals("notice") ) {%>공지사항
							<%} else {%>전체<%}%> > 
							<%if( sClass.equals("notice") ) {%>공지사항
							<%} else {%>전체 게시물<%}%>
						</li>
						<p></p>
					</div>