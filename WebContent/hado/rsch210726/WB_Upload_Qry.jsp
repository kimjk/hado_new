<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 2014년 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_Upload_Qry.jsp
* 프로그램설명	: 수급사업자명부 업로드 (변경전)
* 프로그램버전	: 3.0.0-2014
* 최초작성일자	: 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-14	정광식       최초작성
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
/*  1. 프로젝트명 : 공정관리위원회 하도급거래 서면직권실태조사 민원인 홈페이지                         */
/*  2. 업체정보 :                                                                                      */
/*     - 업체명 : 공정관리위원회		            												   */
/*     - 담장자명 : 남기태 조사관				          											   */
/*     - 연락처 : T) 02-2023-4491  F) 02-2023-4500													   */
/*  3. 개발업체정보 :																				   */
/*     - 업체명 : (주)이꼬르																		   */
/*	   - Project Manamger : 정광식 부장 (pcxman99@naver.com)										   */
/*     - 연락처 : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  4. 일자 : 2009년 5월																			   */
/*  5. 저작권자 : 공정관리위원회 기업협력국															   */
/*  6. 저작권자의 동의 없이 배포 및 사용을 할수 없습니다.											   */
/*  7. 업데이트일자 : 																				   */
/*  8. 업데이트내용 (내용 / 일자)																	   */
/*  9. 비고																							   */
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
	//디렉트로 오류로 강제 적용
	  saveDirectory = config.getServletContext().getRealPath("/upload/2021");
    //saveDirectory = "D:/WORKSPACE/hadoweb/WebContent/upload/2021";

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
			fileSize		= String.valueOf(fileObj.length());
		}
	}
	
	// 엑셀파일만 업로드를 허용한다.
	if( fileExtend.equals("XLS") || fileExtend.equals("XLSX") || fileExtend.equals("xls") || fileExtend.equals("xlsx") ) {
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
		if(fileName != null) {

			sSQLs="DELETE FROM HADO_TB_Oent_Subcon_File \n";
			sSQLs+="WHERE RTrim(Mng_No)='"+ckMngNo+"' \n";
			sSQLs+="AND Current_Year='"+ckCurrentYear+"' \n";
			sSQLs+="AND Oent_GB='"+ckOentGB+"' \n";

			try {
				resource2		= new ConnectionResource2();
				conn2			= resource2.getConnection();
				pstmt			= conn2.prepareStatement(sSQLs);
				int updateCNT	= pstmt.executeUpdate();
			} catch(Exception e){
				e.printStackTrace();
			} finally {
				if ( rs != null )		try{rs.close();}	catch(Exception e){}
				if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
				if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
				if ( resource2 != null ) resource2.release();
			}

			sSQLs1="Mng_No";
			sSQLs2="'"+ckMngNo+"'";
			sSQLs1+=", Current_Year";
			sSQLs2+=", '"+ckCurrentYear+"'";
			sSQLs1+=", oent_gb";
			sSQLs2+=", '"+ckOentGB+"'";
			sSQLs1+=", oent_file";
			//sSQLs2+=", '"+new String(fileName.getBytes("euc-kr"), "ISO8859-1")+"'";
			sSQLs2+=", '"+fileName+"'";
			sSQLs1+=", oent_file_size";
			sSQLs2+=","+fileSize;
			
			sSQLs="INSERT INTO HADO_TB_Oent_Subcon_File ("+sSQLs1+") VALUES ("+sSQLs2+")";
			
			try {
				resource2		= new ConnectionResource2();
				conn2			= resource2.getConnection();
				pstmt			= conn2.prepareStatement(sSQLs);
				int updateCNT	= pstmt.executeUpdate();
			} catch(Exception e){
				e.printStackTrace();
			} finally {
				if ( rs != null )		try{rs.close();}	catch(Exception e){}
				if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
				if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
				if ( resource2 != null ) resource2.release();
			}
		}
	}

	if( uploadAction.equals("T") ) {
		out.print("<script language=JavaScript>");
		out.print("parent.top.opener.location.reload();");
		out.print("self.close();");
		out.print("</script>");
	} else {
		out.print("<script language=JavaScript>");
		out.print("alert('허용하지 않는 파일형식입니다.');");
		//out.print("location.href = 'subcon_upload.jsp';");
		out.print("history.back();");
		out.print("</script>");
	}
%>
<html>
<head>
	<title>업로드</title>
	<link href="/Include/common.css" rel="stylesheet" type="text/css" />
</head>
<body>

</body>
</html>

