<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: SOent_Submit_Oent_List_proc.jsp
* 프로그램설명	: 수급사업자가 제출한 원사업자 명부 제출현황 프로세스
* 프로그램버전	: 4.0.0-2015
* 최초작성일자	: 2015년 07월
* 작 성 이 력       :
*=========================================================
*	작성일자			작성자명				내용
*=========================================================
* 2015-07-28   강슬기			최초작성
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="/hado/Include/WB_I_chkSession.jsp"%>

<%
ConnectionResource resource		= null;
Connection conn					= null;
PreparedStatement pstmt			= null;
ResultSet rs					= null;

String fileName			= "";
String sSQLs			= "";
String saveDirectory	= "";
String sMngNo = request.getParameter("mno") == null ? "":request.getParameter("mno").trim();
String sCurrentYear = request.getParameter("cyear") == null ? "":request.getParameter("cyear").trim();
String sOentGB = request.getParameter("ogb") == null ? "":request.getParameter("ogb").trim();

if( sCurrentYear.equals("2016") ) {
	saveDirectory = "/home1/ftc/hadoweb/upload/2016";
	} else {
	saveDirectory = "/home1/ftc/hadoweb/upload";
}

if( !sMngNo.equals("") && !sCurrentYear.equals("") && !sOentGB.equals("") ) {
	sSQLs  = "SELECT oent_file \n";
	sSQLs+= "FROM hado_tb_subcon_oent_file \n";
	sSQLs+= "WHERE mng_no=? AND current_year=? AND oent_GB=? \n";

	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();

		pstmt		= conn.prepareStatement(sSQLs);
		pstmt.setString(1, sMngNo);
		pstmt.setString(2, sCurrentYear);
		pstmt.setString(3, sOentGB);
		rs			= pstmt.executeQuery();

		if (rs.next()) {
			fileName = rs.getString("oent_file");
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