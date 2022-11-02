<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: 2014�� �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_Upload_Qry.jsp
* ���α׷�����	: ���޻���ڸ�� ���ε� (������)
* ���α׷�����	: 3.0.0-2014
* �����ۼ�����	: 2014�� 09�� 14��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-09-14	������       �����ۼ�
*/
%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<%@ include file="../Include/WB_Inc_chkSession.jsp"%>

<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. ������Ʈ�� : ������������ȸ �ϵ��ްŷ� �������ǽ������� �ο��� Ȩ������                         */
/*  2. ��ü���� :                                                                                      */
/*     - ��ü�� : ������������ȸ		            												   */
/*     - �����ڸ� : ������ �����				          											   */
/*     - ����ó : T) 02-2023-4491  F) 02-2023-4500													   */
/*  3. ���߾�ü���� :																				   */
/*     - ��ü�� : (��)�̲���																		   */
/*	   - Project Manamger : ������ ���� (pcxman99@naver.com)										   */
/*     - ����ó : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  4. ���� : 2009�� 5��																			   */
/*  5. ���۱��� : ������������ȸ ������±�															   */
/*  6. ���۱����� ���� ���� ���� �� ����� �Ҽ� �����ϴ�.											   */
/*  7. ������Ʈ���� : 																				   */
/*  8. ������Ʈ���� (���� / ����)																	   */
/*  9. ���																							   */
/*-----------------------------------------------------------------------------------------------------*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/

	int maxPostSize = 100 * 1024 * 1024;

	ConnectionResource resource		= null;
	Connection conn					= null;
	PreparedStatement pstmt			= null;
	ResultSet rs					= null;
	ConnectionResource2 resource2	= null;
	Connection conn2				= null;
	
	

	String fileInput		= "";
	String fileName			= "";
	String sDocuNm          = "";
	String type				= "";
	File fileObj			= null;
	String originFileName	= "";
	String fileExtend		= "";
	String fileSize			= "";
	String sSQLs			= "";
	String sSQLs1			= "";
	String sSQLs2			= "";
	String uploadAction		= "F";
	String saveDirectory	= "";
	
	/*
	if( ckCurrentYear.equals("2014") ) {
		saveDirectory = config.getServletContext().getRealPath("/upload/2014");
	} if( ckCurrentYear.equals("2013") ) {
		saveDirectory = config.getServletContext().getRealPath("/upload/2013");
	} else if( ckCurrentYear.equals("2012") ) {
		saveDirectory = config.getServletContext().getRealPath("/upload/2012");
	} else if( ckCurrentYear.equals("2011") ) {
		saveDirectory = config.getServletContext().getRealPath("/upload/2011");
	} else if( ckCurrentYear.equals("2010") ) {
		saveDirectory = config.getServletContext().getRealPath("/upload/2010");
	} else {
		saveDirectory = config.getServletContext().getRealPath("/upload");
	}
    */
	//��Ʈ�� ������ ���� ����
	//saveDirectory = application.getRealPath("/home1/ftc/hadoweb/upload/2021");
    saveDirectory = "/home1/ftc/hadoweb/upload/2021";

	MultipartRequest multi = new MultipartRequest(request, saveDirectory, maxPostSize, "euc-kr",new DefaultFileRenamePolicy());
	Enumeration formNames	= multi.getFileNames();

/*=================================== Record Processing ===============================================*/
	while(formNames.hasMoreElements()) {
		fileInput	= (String)formNames.nextElement();
		fileName	= multi.getFilesystemName(fileInput);
		if(fileName != null) {
			type			= multi.getContentType(fileInput);
			fileObj			= multi.getFile(fileInput);
			originFileName	= multi.getOriginalFileName(fileInput);
			fileExtend		= fileName.substring(fileName.lastIndexOf(".")+1);
			sDocuNm         = fileName.substring(0, fileName.lastIndexOf("."));
			fileSize		= String.valueOf(fileObj.length());
		}
	}
	
	// pdf���ϸ� ���ε带 ����Ѵ�.
	if( fileExtend.equals("PDF") || fileExtend.equals("pdf") ) {
		uploadAction = "T";
	} else {
		if(fileName != null) {
			String filePath = saveDirectory + "/" + fileName;
			File f			= new File(filePath);
			if( f.exists() )  {
				f.delete();
			}
		}
	}

	if( uploadAction.equals("T") ) {
		int nNewSn = 1;	// ���ϼ���
		
		
		if(fileName != null) {
			/* �ű� ���� ���ϱ� ���� */
			sSQLs  = "SELECT NVL(MAX(file_sn)+1,1) AS newSn \n";
			sSQLs+="FROM hado_tb_oent_attach_file \n";
			sSQLs+="WHERE mng_no=? AND current_year=? AND oent_gb=? \n";

			try {
				resource = new ConnectionResource();
				conn = resource.getConnection();

				pstmt = conn.prepareStatement(sSQLs);
				pstmt.setString(1, ckMngNo);
				pstmt.setString(2, ckCurrentYear);
				pstmt.setString(3, ckOentGB);
				rs = pstmt.executeQuery();

				if( rs.next() ) {
					nNewSn = rs.getInt("newSn");
				}
				rs.close();
			} catch(Exception e){
				e.printStackTrace();
			} finally {
				if ( rs != null )		try{rs.close();}	catch(Exception e){}
				if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
				if ( conn != null )	try{conn.close();}	catch(Exception e){}
				if ( resource != null ) resource.release();
			}
			/* �ű� ���� ���ϱ� �� */

			/* ÷���������� ����Ÿ���̽� ���� ���� */
			sSQLs  ="INSERT INTO hado_tb_oent_attach_file \n";
			sSQLs+="	(mng_no, current_year, oent_gb, file_sn, docu_name, file_name, file_size) \n";
			sSQLs+="VALUES(?, ?, ?, ?, ?, ?, ?) \n";

			try {
				resource = new ConnectionResource();
				conn = resource.getConnection();

				pstmt = conn.prepareStatement(sSQLs);
				pstmt.setString(1, ckMngNo);
				pstmt.setString(2, ckCurrentYear);
				pstmt.setString(3, ckOentGB);
				pstmt.setInt(4, nNewSn);
				//pstmt.setString(5, new String(sDocuNm.getBytes("euc-kr"), "ISO8859-1"));
				//pstmt.setString(6, new String(fileName.getBytes("euc-kr"), "ISO8859-1"));
				pstmt.setString(5, sDocuNm);
				pstmt.setString(6, fileName);
				pstmt.setString(7, fileSize);

				int updateCNT	= pstmt.executeUpdate();
			} catch(Exception e){
				e.printStackTrace();
			} finally {
				if ( rs != null )		try{rs.close();}	catch(Exception e){}
				if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
				if ( conn != null )	try{conn.close();}	catch(Exception e){}
				if ( resource != null ) resource.release();
			}
		}
	}
	%>
<html>
<head>
	<title>���ε�</title>
	<link href="/Include/common.css" rel="stylesheet" type="text/css" />
<%
if( uploadAction.equals("T") ) {
	out.print("<script language=JavaScript>");
	out.print("parent.top.opener.location.reload();");
	out.print("alert('�����ڷᰡ ���ε�Ǿ����ϴ�!');");
	out.print("self.close();");
	out.print("</script>");
} else {
	out.print("<script language=JavaScript>");
	out.print("parent.top.opener.location.reload();");
	out.print("alert('������� �ʴ� ���������Դϴ�.');");
	out.print("self.close();");
	out.print("</script>");
}
%>
</head>
<body>

</body>
</html>

