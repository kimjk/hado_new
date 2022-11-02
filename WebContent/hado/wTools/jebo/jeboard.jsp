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
/*  1. ������Ʈ�� : ������������ȸ ������ �ŷ� �������ǽ������� �ο��� Ȩ������                      */
/*  2. ��ü���� :                                                                                      */
/*     - ��ü�� : ������������ȸ		            												   */
/*     - �����ڸ� :  �輼�� �繫��				          											   */
/*     - ����ó : T) 02-2023-4526  F) 02-2023-4500													   */
/*  3. ���߾�ü���� :																				   */
/*     - ��ü�� : (��)��Ƽ������																	   */
/*	   - Project Manamger : ������ ���� (pcxman99@naver.com)										   */
/*     - ����ó : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  4. ���� : 2010�� 5��																			   */
/*  5. ���۱��� : ������������ȸ ������±�															   */
/*  6. ���۱����� ���� ���� ���� �� ����� �Ҽ� �����ϴ�.											   */
/*  7. ������Ʈ���� : 																				   */
/*  8. ������Ʈ���� (���� / ����)																	   */
/*  9. ���																							   */
/*-----------------------------------------------------------------------------------------------------*/
	String sID = (request.getParameter("qID")==null)? "":request.getParameter("qID");
	String sContent = (request.getParameter("qContent")==null)? "":request.getParameter("qContent");
	
	ArrayList arrID			= new ArrayList();
	ArrayList arrInDate		= new ArrayList();
	ArrayList arrContent	= new ArrayList();
	ArrayList arrFileName	= new ArrayList();
	ArrayList arrViewF		= new ArrayList();
	ArrayList arrViewDate	= new ArrayList();
	ArrayList arrWriteIP	= new ArrayList();
	ArrayList arrViewCount	= new ArrayList();

	ConnectionResource	resource= null;
	Connection			conn	= null;
	PreparedStatement	pstmt	= null;
	ResultSet			rs		= null;
	
	String sErrorMsg="";					//�����޽���
	String sReturnURL="jeboard.jsp";		//�̵�URL(����ּ�)
	String sSQLs="";
	String shortSubject="";

	int i=0;

	// Page
	int nPageSize = 20;
	String sTmpPageSize = (String)StringUtil.checkNull(request.getParameter("mpagesize")).trim();
	if( sTmpPageSize != null && (!sTmpPageSize.equals("")) ) {
		nPageSize = Integer.parseInt(sTmpPageSize);
		session.setAttribute("pagecnt",sTmpPageSize);
	} else {
		String sTmpPages = (String)session.getAttribute("pagecnt");
		if( sTmpPages != null && (!sTmpPages.equals("")) ) {
			nPageSize = Integer.parseInt(sTmpPages);
			session.setAttribute("pagecnt",sTmpPages);
		} else {
			nPageSize = 20;
		}
	}
	int nPage = 1;
	int nMaxPage = 1;
	int nRecordCount = 0;
	String sTmpPage = (String)StringUtil.checkNull(request.getParameter("page")).trim();
	if( sTmpPage != null && (!sTmpPage.equals("")) ) {
		nPage = Integer.parseInt(sTmpPage);
		session.setAttribute("page", sTmpPage);
	} else {
		String sTmpPages = (String)session.getAttribute("page");
		if( sTmpPages != null && (!sTmpPages.equals("")) ) {
			nPage = Integer.parseInt(sTmpPages);
			session.setAttribute("page", sTmpPages);
		} else {
			nPage = 1;
		}
	}
	int gesu = 0;
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/

	try {
		resource=new ConnectionResource();
		conn=resource.getConnection();
		
		//sSQLs="SELECT * FROM KFAIR_TB_NonFair \n";
		sSQLs="SELECT ID, TO_CHAR(InDate,'yyyy-mm-dd') dInDate, Content, ViewF FROM HADO_TB_NonFair \n" +
			  "ORDER BY ID DESC";

		pstmt=conn.prepareStatement(sSQLs);
		rs=pstmt.executeQuery();	  
		

		while (rs.next()) {
			arrID.add(StringUtil.checkNull(rs.getString("ID")).trim());
			arrInDate.add(StringUtil.checkNull(rs.getString("dInDate")).trim());	
			//arrFileName.add(new String(StringUtil.checkNull(rs.getString("FILENAME")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			//arrViewF.add(new String(StringUtil.checkNull(rs.getString("ViewF")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			arrViewF.add(rs.getString("ViewF")==null ? "N":rs.getString("ViewF"));
			//arrViewDate.add(new String(StringUtil.checkNull(rs.getString("VIEWDATE")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			//arrWriteIP.add(new String(StringUtil.checkNull(rs.getString("WRITEIP")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			//arrViewCount.add(new String(StringUtil.checkNull(rs.getString("VIEWCOUNT")).trim().getBytes("ISO8859-1"), "EUC-KR" ));

			Reader input = rs.getCharacterStream("Content");
			char[] buffer = new char[1024];
			int byteRead;
			StringBuffer sbOutput = new StringBuffer();
			while ((byteRead=input.read(buffer,0,1024))!=-1) {
				sbOutput.append(buffer,0,byteRead);
			}
			/* ��ũ��Ʈ ���� */
			String sContents = new String(sbOutput.toString().trim().getBytes("ISO8859-1"), "EUC-KR" );
			sContents = sContents.replace("<","&lt;").replace(">","&gt;");
			arrContent.add(sContents);
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

/*=====================================================================================================*/
%>
<%@ include file="../../Include/WB_I_Function.jsp"%>

<html>
<head>
	<title>�������� - ��Ϻ���</title>
	<link href="../../Include/common.css" rel="stylesheet" type="text/css" />
	<style type="text/css">
		h1 {margin:10px; padding-left:15px; background-color:#D0D7E5; color:#666; font:bold 18px/1.8 ����, Dotum;}

		a:link, a:visited {font-size:12px; font-family:'����',dotum,arial; color:dimgrey; text-decoration:none;}
		a:hover, a:active {font-size:12px; font-family:'����',dotum,arial; color:brown; text-decoration:underline;}

		.board_list, .board_list th, .board_list td {border:0; font-size:12px; font-family:'����',dotum,arial;}
		.board_list { margin:10px; border-bottom:1px solid #DDDEE2; text-align:center; border-collapse:collapse; table-layout:fixed;}
		.board_list th {padding:5px; border-top:1px solid #DDDEE2; background-color:#F1F1F3; color:#666; font-weight:bold;}
		.board_list td {padding:5px; border-top:1px solid #DDDEE2; line-height:20px;}
	</style>
</head>

<Script Language="JavaScript">
<%if (!sErrorMsg.equals("") ) {%>
	alert("<%= sErrorMsg%>");
	location.replace("<%= sReturnURL%>");
<%}%>
</Script>

<body>
<h1>��������</h1>
<table class="board_list" style="margin-top:-5px">
	<colgroup>
		<col style="width:15%;" />
		<col style="width:20%;" />
		<col style="width:15%;" />
		<col style="width:40%;" />
		<col style="width:10%;" />
	</colgroup>
	<thead>
		<tr>
		<form name="form" method="post" action="jeboard.jsp">
			<th scope="col">������ȣ</th>
			<th scope="col"><input type="text" name="qID" value="<%=sID%>" size="11"></th>
			<th scope="col">��������</th>
			<th scope="col"><input type="text" name="qContent" value="<%=sContent%>" size="30"></th>
			<th scope="col"><input type="submit" value="�˻�"></th>
		</form>
		</tr>
	</thead>
</table>
		
<table class="board_list" style="margin-top:-5px">
	<colgroup>
		<col style="width:10%;" />
		<col style="width:15%;" />
		<col style="width:20%;" />
		<col style="width:40%;" />
		<col style="width:15%;" />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">����</td>
			<th scope="col">������ȣ</td>
			<th scope="col">�ۼ���</td>
			<th scope="col">��������</td>
			<th scope="col">Ȯ�ο���</td>
		</tr>
	</thead>
	<tbody>
		<% for(int ni=0;ni<arrID.size();ni++) { 
				if(arrContent.get(ni).toString().length()>30) {
					shortSubject=arrContent.get(ni).toString().substring(0,29)+"..";
				} else {
					shortSubject=arrContent.get(ni).toString();
				}%>
			<tr>
				<td><%=ni+1%>&nbsp;</td>
				<td><%=arrID.get(ni)%></td>
				<td><%=arrInDate.get(ni)%></td>
				<td><a href="jeboview.jsp?no=<%=arrID.get(ni)%>&qID=<%=sID%>&qContent=<%=sContent%>"><%=shortSubject%></a></td>
				<td><%=arrViewF.get(ni)%></td>
			</tr>
		<%}%>
	</tbody>
</table>
<p />

</body>
</html>    