<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="../../Include/WB_I_Global.jsp"%>
<%@ include file="../../Include/WB_I_chkSession.jsp"%>

<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. 프로젝트명 : 공정관리위원회 유통사업 거래 서면직권실태조사 민원인 홈페이지                      */
/*  2. 업체정보 :                                                                                      */
/*     - 업체명 : 공정관리위원회		            												   */
/*     - 담장자명 :  김세겸 사무관				          											   */
/*     - 연락처 : T) 02-2023-4526  F) 02-2023-4500													   */
/*  3. 개발업체정보 :																				   */
/*     - 업체명 : (주)로티스아이																	   */
/*	   - Project Manamger : 정광식 부장 (pcxman99@naver.com)										   */
/*     - 연락처 : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  4. 일자 : 2010년 5월																			   */
/*  5. 저작권자 : 공정관리위원회 기업협력국															   */
/*  6. 저작권자의 동의 없이 배포 및 사용을 할수 없습니다.											   */
/*  7. 업데이트일자 : 																				   */
/*  8. 업데이트내용 (내용 / 일자)																	   */
/*  9. 비고																							   */
/*-----------------------------------------------------------------------------------------------------*/
	String sNo = (request.getParameter("no")==null)? "":request.getParameter("no");
	String sID = (request.getParameter("qID")==null)? "":request.getParameter("qID");
	String sContent = (request.getParameter("qContent")==null)? "":request.getParameter("qContent");

	ConnectionResource	resource= null;
	Connection			conn	= null;
	PreparedStatement	pstmt	= null;
	ResultSet			rs		= null;
	
	String dID="";
	String dInDate="";
	String dFileName="";
	String dViewF="";
	String dViewDate="";
	String dWriteIP="";
	String dViewCount="";
	String dContent="";


	String sErrorMsg="";					//오류메시지
	String sReturnURL="jeboard.jsp";		//이동URL(상대주소)
	String sSQLs="";


/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	try {
		resource=new ConnectionResource();
		conn=resource.getConnection();
		
		sSQLs=" SELECT * FROM HADO_TB_NonFair ";
		sSQLs+=" WHERE ID=? ";

		pstmt=conn.prepareStatement(sSQLs);
		pstmt.setString(1, sNo);
		rs=pstmt.executeQuery();	  
		
		if (rs.next()) {
			dID =		StringUtil.checkNull(rs.getString("ID")).trim();
			dInDate =	StringUtil.checkNull(rs.getString("INDATE")).trim();	
			dFileName = new String(StringUtil.checkNull(rs.getString("FILENAME")).trim().getBytes("ISO8859-1"), "EUC-KR" );
			dViewF =	new String(StringUtil.checkNull(rs.getString("VIEWF")).trim().getBytes("ISO8859-1"), "EUC-KR" );
			dViewDate = new String(StringUtil.checkNull(rs.getString("VIEWDATE")).trim().getBytes("ISO8859-1"), "EUC-KR" );
			dWriteIP =	new String(StringUtil.checkNull(rs.getString("WRITEIP")).trim().getBytes("ISO8859-1"), "EUC-KR" );
			dViewCount = new String(StringUtil.checkNull(rs.getString("VIEWCOUNT")).trim().getBytes("ISO8859-1"), "EUC-KR" );

			Reader input = rs.getCharacterStream("CONTENT");
			char[] buffer = new char[1024];
			int byteRead;
			StringBuffer sbOutput = new StringBuffer();
			while ((byteRead=input.read(buffer,0,1024))!=-1) {
				sbOutput.append(buffer,0,byteRead);
			}
			dContent = new String(sbOutput.toString().trim().getBytes("ISO8859-1"), "EUC-KR" );

			dContent=dContent.replaceAll("\r\n","<br/>");
			dContent=dContent.replaceAll("\u0020","&nbsp;");
			dContent = dContent.replace("<","&lt;").replace(">","&gt;");
		}
		rs.close();
	
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn != null)	try{conn.close();}	catch(Exception e){}
		if (resource != null) resource.release();
	}
	
	/* 읽음 표시 */
	try {
		resource=new ConnectionResource();
		conn=resource.getConnection();
		
		sSQLs=" UPDATE HADO_TB_NonFair ";
		sSQLs+=" SET VIEWF='Y', VIEWDATE=SYSDATE, VIEWCOUNT=VIEWCOUNT+1 ";
		sSQLs+=" WHERE ID=? ";

		pstmt=conn.prepareStatement(sSQLs);
		pstmt.setString(1, sNo);
		int updateCNT = pstmt.executeUpdate();

	
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn != null)	try{conn.close();}	catch(Exception e){}
		if (resource != null) resource.release();
	}
/*=====================================================================================================*/
%>
<%@ include file="../../Include/WB_I_Function.jsp"%>

<html>
<head>
	<title>제보센터 - 내용보기</title>
	<link href="../../Include/common.css" rel="stylesheet" type="text/css" />
	<style type="text/css">
		h1 {margin:10px; padding-left:15px; background-color:#D0D7E5; color:#666; font:bold 18px/2 굴림, Dotum;}

		.board_view, .board_view th, .board_view td {border:0 font-family:'돋움', dotum; font-size:12px;}
		.board_view {width:598px; margin:10px; border-bottom:1px solid #DDDEE2; border-collapse:collapse; table-layout:fixed;}
		.board_view th {padding:8px 0 5px 20px; border-top:1px solid #DDDEE2; background-color:#F1F1F3; color:#666; font-weight:bold; text-align:left;}
		.board_view td {padding:8px 5px 5px 12px; border-top:1px solid #DDDEE2; line-height:20px; word-wrap:break-all;}
	</style>
</head>

<Script Language="JavaScript">
<%if (!sErrorMsg.equals("") ) {%>
	alert("<%= sErrorMsg%>");
	location.replace("<%= sReturnURL%>");
<%}%>
</Script>

<body>
<h1>제보센터</h1>
<table class="board_view">
	<colgroup>
		<col width="80"><col><col width="80"><col>
	</colgroup>
	<tbody>
		<tr>
			<th scope="row">제보번호</th>
			<td><%=dID%></td>
			<th scope="row">확인여부</th>
			<td><%=dViewF%></td>
		</tr>
		<tr>
			<th scope="row">작성일</th>
			<td><%=dInDate%></td>
			<th scope="row">확인일</th>
			<td><%=dViewDate%></td>
		</tr>
		<tr>
			<th scope="row">제보내용</th>
			<td colspan="3"><%=dContent%></td>
		</tr>
		<tr>
			<th scope="row">첨부파일</th>
			<td colspan="3"><a href="/hado/hado/upload/nonfair/<%=dFileName%>" target="_blank"><%=dFileName%></a></td>
		</tr>
		<tr>
			<th scope="row">작성자IP</th>
			<td colspan="3"><%=dWriteIP%></td>
		</tr>
	</tbody>
</table>
<p align="center" style="margin:20px"><a href="jeboard.jsp"><img src="images/notice_list.jpg" width="53" height="20" border="0"></a></p>

</body>
</html>    