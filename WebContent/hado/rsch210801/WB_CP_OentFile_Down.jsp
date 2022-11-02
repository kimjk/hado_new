<%@ page session="true" language="java" contentType="application;" pageEncoding="utf-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<%@ include file="../Include/WB_Inc_chkSession.jsp"%>

<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_CP_OentFile_Down.jsp
* 프로그램설명		: 원사업자명부 업로드
* 프로그램버전		: 1.0.0-2015
* 최초작성일자		: 2015년 07월 23일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2015-07-23	정광식       최초작성
*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/

	ConnectionResource resource		= null;
	Connection conn					= null;
	PreparedStatement pstmt			= null;
	ResultSet rs					= null;

	String fileName			= "";
	String sSQLs			= "";
	String saveDirectory	= "";
	
	//2015-05-08 조사년도별 업로드 파일 추가 / 강슬기
	if( ckCurrentYear.equals("2016") ) {
		saveDirectory = config.getServletContext().getRealPath("/upload/2016");
	} else if( ckCurrentYear.equals("2015") ) {
		saveDirectory = config.getServletContext().getRealPath("/upload/2015");
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

/*=================================== Record Processing ===============================================*/
	sSQLs = "SELECT oent_file FROM hado_tb_subcon_oent_file \n";
	sSQLs+="WHERE Mng_No=? \n";
	sSQLs+="	AND Current_Year=? \n";
	sSQLs+="	AND Oent_GB=? \n";

	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();

		pstmt		= conn.prepareStatement(sSQLs);
		pstmt.setString(1, ckMngNo);
		pstmt.setString(2, ckCurrentYear);
		pstmt.setString(3, ckOentGB);

		rs			= pstmt.executeQuery();

		while (rs.next()) {
			fileName = StringUtil.checkNull(rs.getString("oent_file")).trim();
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
%>