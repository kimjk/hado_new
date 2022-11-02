<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 2014년 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_SP_Download_02.jsp
* 프로그램설명	: 회사개요-일반현황 증빙자료 다운로드
* 프로그램버전	: 3.0.0-2014
* 최초작성일자	: 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-14	정광식       최초작성
*	2015-05-08	강슬기       2015년도 문구 수정 및 다운로드 파일 디렉토리 추가
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_Inc_chkSession.jsp"%>

<%
ConnectionResource resource		= null;
Connection conn					= null;
PreparedStatement pstmt			= null;
ResultSet rs					= null;

String fileName			= "";
String sSQLs			= "";
String saveDirectory	= "";
String sFileSn = request.getParameter("sn")==null ? "": request.getParameter("sn").trim();
String sMngNo = request.getParameter("mno") == null ? "":request.getParameter("mno").trim();
String sCurrentYear = request.getParameter("cyear") == null ? "":request.getParameter("cyear").trim();
String sOentGB = request.getParameter("ogb") == null ? "":request.getParameter("ogb").trim();

/*매년 연도별 디렉토리 추가*/
if( ckCurrentYear.equals("2017") ) {
	saveDirectory = "/home1/ftc/hadoweb/upload/2017";
} else if( ckCurrentYear.equals("2016") ) {
	saveDirectory = "/home1/ftc/hadoweb/upload/2016";
} else if( ckCurrentYear.equals("2015") ) {
	saveDirectory = "/home1/ftc/hadoweb/upload/2015";
} else if( ckCurrentYear.equals("2014") ) {
	saveDirectory = "/home1/ftc/hadoweb/upload/2014";
} else if( ckCurrentYear.equals("2013") ) {
	saveDirectory = "/home1/ftc/hadoweb/upload/2013";
} else if( ckCurrentYear.equals("2012") ) {
	saveDirectory = "/home1/ftc/hadoweb/upload/2012";
} else if( ckCurrentYear.equals("2011") ) {
	saveDirectory = "/home1/ftc/hadoweb/upload/2011";
} else if( ckCurrentYear.equals("2010") ) {
	saveDirectory = "/home1/ftc/hadoweb/upload/2010";
} else {
	saveDirectory = "/home1/ftc/hadoweb/upload";
}

if( !sFileSn.equals("") && !ckMngNo.equals("") && !ckCurrentYear.equals("") && !ckOentGB.equals("") ) {
	sSQLs  = "SELECT file_name \n";
	sSQLs+= "FROM hado_tb_oent_attach_file \n";
	sSQLs+= "WHERE mng_no=? AND current_year=? AND oent_GB=? AND file_sn=? \n";

	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();

		pstmt		= conn.prepareStatement(sSQLs);
		pstmt.setString(1, ckMngNo);
		pstmt.setString(2, ckCurrentYear);
		pstmt.setString(3, ckOentGB);
		pstmt.setString(4, sFileSn);
		rs			= pstmt.executeQuery();

		if (rs.next()) {
			//fileName = new String( rs.getString("file_name").getBytes("ISO8859-1"), "EUC-KR" );
			fileName = rs.getString("file_name")==null ? "":rs.getString("file_name").trim();
		}

		rs.close();
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if ( rs != null )		try{rs.close();}	catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )		try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}

	if(fileName != null && (!fileName.equals("")) ) {
		File file	= new File(saveDirectory + "/" + fileName);
		byte b[]	= new byte[4096];
		response.setHeader("Content-Disposition", "attachment;filename="+fileName+";");

		if(file.isFile()) {
			BufferedInputStream fine	= new BufferedInputStream(new FileInputStream(file));
			BufferedOutputStream outs	= new BufferedOutputStream(response.getOutputStream());
			int read = 0;

			while ((read = fine.read(b)) != -1) {
				outs.write(b,0,read);
			}

			outs.close();
			fine.close();
		}
	}
}
%>