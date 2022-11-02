<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: 2014�� �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_SP_Upload_01.jsp
* ���α׷�����	: ȸ�簳��-�Ϲ���Ȳ �����ڷ� ÷������ ó��
* ���α׷�����	: 3.0.0-2014
* �����ۼ�����	: 2014�� 09�� 14��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-09-14	������       �����ۼ�
*	2015-05-08	������       2015�⵵ ���� ���� �� ���ε� ���� ���丮 �߰�
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<%@ include file="../Include/WB_Inc_chkSession.jsp"%>
<%
ConnectionResource resource		= null;
Connection conn					= null;
PreparedStatement pstmt			= null;
ResultSet rs					= null;

int maxPostSize = 100 * 1024 * 1024;		// ���ϻ����� ����(100MBytes)
String sDenyExtend = "EXE BIN COM BAT REG JSP JAVA CLASS ASP PHP SH HTML XML HTM";	// ���� Ȯ����

String sSQLs = "";

String sDocuNm = "";		// ÷�ι�����
String fileInput = "";	// ���� ������Ʈ
String fileName = "";	// ���ε� ���ϸ�
String type	 = "";	// ����Ÿ��
File fileObj	 = null;	// ���Ͻý��ۿ�����Ʈ
String originFileName	= "";	// ���ε� �������ϸ�
String fileExtend = "";		// ����Ȯ����
String fileSize = "";	// ���ϻ�����

String uploadAction = "F";		// ���ε���� ���ú��� (T/F)
String saveDirectory = "";		// ��������(���)

/* ���� ���� ��� ���� */
/*�ų� ������ ���丮 �߰�*/
if( ckCurrentYear.equals("2021") ) {
	saveDirectory = config.getServletContext().getRealPath("/home1/ftc/hadoweb/upload/2021");
} else if( ckCurrentYear.equals("2017") ) {
	saveDirectory = config.getServletContext().getRealPath("/home1/ftc/hadoweb/upload/2017");
} else if( ckCurrentYear.equals("2016") ) {
	saveDirectory = config.getServletContext().getRealPath("/home1/ftc/hadoweb/upload/2016");
} else if( ckCurrentYear.equals("2015") ) {
	saveDirectory = config.getServletContext().getRealPath("/home1/ftc/hadoweb/upload/2015");
} else if( ckCurrentYear.equals("2014") ) {
	saveDirectory = config.getServletContext().getRealPath("/upload/2014");
} else if( ckCurrentYear.equals("2013") ) {
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

try {
	MultipartRequest multi = new MultipartRequest(request, saveDirectory, maxPostSize, "euc-kr",new DefaultFileRenamePolicy());
	
	sDocuNm = multi.getParameter("mSubject");

	Enumeration formNames	= multi.getFileNames();

	/**
	* com.oreilly ���̺귯���� �̿��Ͽ� ���ε带 ���� (���� ���� ���ε�)
	*/
	if(formNames.hasMoreElements()) {
		fileInput	= (String)formNames.nextElement();
		fileName = multi.getFilesystemName(fileInput);
		if(fileName != null) {
			type = multi.getContentType(fileInput);
			fileObj = multi.getFile(fileInput);
			originFileName = multi.getOriginalFileName(fileInput);
			fileExtend = fileName.substring(fileName.lastIndexOf(".")+1);
			fileSize = String.valueOf(fileObj.length());
		}
	}
} catch(IOException ie) {
	System.out.println(ie);
} catch(Exception e) {
	System.out.println(e);
}

// Ȯ���ڸ� Ȯ���Ͽ� ������ �ʴ� ������ �����ϱ� ���� ������ ó�����θ� ����
if( sDenyExtend.indexOf(fileExtend)>-1 ) {
	if(fileName != null) {
		String filePath = saveDirectory + "/" + fileName;
		File f = new File(filePath);
		if( f.exists() ) 
			f.delete();
	}
} else {
	uploadAction = "T";	
}

// ���ε尡 �Ϸ�Ǿ��ٸ�...
if( uploadAction.equals("T") ) {
	int nNewSn = 1;	// ���ϼ���

	if( fileName!=null && !fileName.equals("") ) {
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
	out.print("parent.top.rtnProcessResult();");
	out.print("</script>");
} else {
	out.print("<script language=JavaScript>");
	out.print("alert('������� �ʴ� ���������Դϴ�.');");
	out.print("</script>");
}
%>
</head>
<body>

</body>
</html>

