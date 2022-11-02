<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 2014년 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_SP_Upload_01.jsp
* 프로그램설명	: 회사개요-일반현황 증빙자료 첨부파일 처리
* 프로그램버전	: 3.0.0-2014
* 최초작성일자	: 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-14	정광식       최초작성
*	2015-05-08	강슬기       2015년도 문구 수정 및 업로드 파일 디렉토리 추가
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

int maxPostSize = 100 * 1024 * 1024;		// 파일사이즈 제한(100MBytes)
String sDenyExtend = "EXE BIN COM BAT REG JSP JAVA CLASS ASP PHP SH HTML XML HTM";	// 차단 확장자

String sSQLs = "";

String sDocuNm = "";		// 첨부문서명
String fileInput = "";	// 파일 엘레먼트
String fileName = "";	// 업로드 파일명
String type	 = "";	// 파일타입
File fileObj	 = null;	// 파일시스템오브젝트
String originFileName	= "";	// 업로드 실제파일명
String fileExtend = "";		// 파일확장자
String fileSize = "";	// 파일사이즈

String uploadAction = "F";		// 업로드실핸 선택변수 (T/F)
String saveDirectory = "";		// 저장폴더(경로)

/* 파일 저장 경로 설정 */
/*매년 연도별 디렉토리 추가*/
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
	* com.oreilly 라이브러리를 이용하여 업로드를 실행 (단일 파일 업로드)
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

// 확장자를 확인하여 허용되지 않는 파일을 차단하기 위해 변수에 처리여부를 저장
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

// 업로드가 완료되었다면...
if( uploadAction.equals("T") ) {
	int nNewSn = 1;	// 파일순번

	if( fileName!=null && !fileName.equals("") ) {
		/* 신규 순번 구하기 시작 */
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
		/* 신규 순번 구하기 끝 */

		/* 첨부파일정보 데이타베이스 저장 시작 */
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
	<title>업로드</title>
	<link href="/Include/common.css" rel="stylesheet" type="text/css" />
<%
if( uploadAction.equals("T") ) {
	out.print("<script language=JavaScript>");
	out.print("parent.top.rtnProcessResult();");
	out.print("</script>");
} else {
	out.print("<script language=JavaScript>");
	out.print("alert('허용하지 않는 파일형식입니다.');");
	out.print("</script>");
}
%>
</head>
<body>

</body>
</html>

