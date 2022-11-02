<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: Oent_Comp_Status_Proc.jsp
* 프로그램설명	: 원사업자 증빙자료 조회/처리 페이지
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2014년 09월 25일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-25	강슬기       최초작성
*	2015-12-30	정광식		DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="/hado/Include/WB_I_Global.jsp"%>
<%@ include file="/hado/Include/WB_I_chkSession.jsp"%>

<%
/**
* 입력정보 저장 변수 선언 및 초기화 시작
*/
ConnectionResource resource = null;
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String sMngNo = request.getParameter("mno") == null ? "":request.getParameter("mno").trim();
String sCurrentYear = request.getParameter("cyear") == null ? "":request.getParameter("cyear").trim();
String sOentGB = request.getParameter("ogb") == null ? "":request.getParameter("ogb").trim();
String sSQLs = "";
String sProcCD = request.getParameter("filecheck") == null ? "3":request.getParameter("filecheck").trim();	// 처리구분
/*	2015-12-30	정광식		DB변경으로 인한 인코딩 변경
String sConst = request.getParameter("fileconst") == null ? "": new String(request.getParameter("fileconst").trim().getBytes("euc-kr"), "ISO8859-1" );

String sCenterName = new String( ckCenterName.getBytes("euc-kr"), "ISO8859-1");
String sDeptName = new String( ckDeptName.getBytes("euc-kr"), "ISO8859-1");
String sUserName = new String( ckUserName.getBytes("euc-kr"), "ISO8859-1");
*/
String sConst = request.getParameter("fileconst") == null ? "": request.getParameter("fileconst").trim();			// 비고

String sCenterName = ckCenterName;
String sDeptName = ckDeptName;
String sUserName = ckUserName;

int nNewSn = 1;	// 파일순번

if( !sMngNo.equals("") && !sCurrentYear.equals("") && !sOentGB.equals("") ) {
	/* 신규 순번 구하기 시작 */
	sSQLs  = "SELECT NVL(MAX(proc_sn)+1,1) AS newSn \n";
	sSQLs+="FROM hado_tb_comp_status_proc \n";
	sSQLs+="WHERE mng_no=? AND current_year=? AND oent_gb=? \n";

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, sMngNo);
		pstmt.setString(2, sCurrentYear);
		pstmt.setString(3, sOentGB);
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
	sSQLs  = "INSERT INTO hado_tb_comp_status_proc \n";
	sSQLs +="		(mng_no, current_year, oent_gb, proc_sn, proc_cd, center_name, dept_name, user_name, const) \n";
	sSQLs +="VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?) \n";

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, sMngNo);
		pstmt.setString(2, sCurrentYear);
		pstmt.setString(3, sOentGB);
		pstmt.setInt(4, nNewSn);
		pstmt.setString(5, sProcCD);
		pstmt.setString(6, sCenterName);
		pstmt.setString(7, sDeptName);
		pstmt.setString(8, sUserName);
		pstmt.setString(9, sConst);

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
%>

<html>
<head>
	<title>【관리】하도급거래 서면실태조사</title>
	<meta charset="euc-kr">
	<link rel="stylesheet" href="/hado/hado/wTools/style.css" type="text/css">
	<script type="text/JavaScript">
	//<![CDATA[
		alert("등록이 완료되었습니다.");
		parent.location.replace(parent.location.href);
	//]]
	</script>
</head>

<body>
</body>
</html>