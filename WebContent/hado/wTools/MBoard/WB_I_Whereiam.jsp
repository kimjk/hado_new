<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. ������Ʈ�� : ������������ȸ �ϵ��ްŷ� �������ǽ�������					                       */
/*  2. ��ü���� :																					   */
/*     - ��ü�� : (��)��Ƽ������																	   */
/*	   - Project Manamger : ������ ���� (pcxman99@naver.com)										   */
/*     - ����ó : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  3. ���� : 2009�� 5��																			   */
/*  4. �����ۼ��� �� ���� : (��)��Ƽ������ ������ / 2011-10-18										   */
/*  5. ������Ʈ���� (���� / ����)																	   */
/*  6. ���																							   */
/*		1) �������� ������ / 2011-10-18																   */
/*-----------------------------------------------------------------------------------------------------*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/
String sGroup = (request.getParameter("group")==null)? "":request.getParameter("group");
String sClass = (request.getParameter("class")==null)? "":request.getParameter("class");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/

/*=====================================================================================================*/
%>
					<div id="searchContent">
						<li class="subtitle"><%if( sGroup.equals("notice") ) {%>��������
							<%} else {%>��ü �Խù�<%}%>
						</li>
						<li class="whereiam">HOME > Ŀ�´�Ƽ > <%if( sGroup.equals("notice") ) {%>��������
							<%} else {%>��ü<%}%> > 
							<%if( sClass.equals("notice") ) {%>��������
							<%} else {%>��ü �Խù�<%}%>
						</li>
						<p></p>
					</div>