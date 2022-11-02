<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 2014년 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_SP_excelProcess_byPOI_01.jsp
* 프로그램설명	: 수급사업자명부 엑셀파일 처리 (Step 1. 엑셀읽기 가능 테스트)
* 프로그램버전	: 3.0.0-2014
* 최초작성일자	: 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-14	정광식       최초작성
*/
%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem" %>
<%@ page import="org.apache.poi.hssf.record.*" %>
<%@ page import="org.apache.poi.hssf.model.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.*" %>

<%@ include file="../Include/WB_Inc_chkSession.jsp"%>

<%
ConnectionResource resource		= null;
Connection conn					= null;
PreparedStatement pstmt			= null;
ResultSet rs					= null;

String sSQLs = "";

String sExcelFilePath =  config.getServletContext().getRealPath("/upload/"+ckCurrentYear);	// 엑셀파일 경로
String sExcelFileName = "";
String sReturnMsg = "";

/* 해당 사업자 업로드한 엑셀 파일명 가져오기 시작 */
sSQLs  = "SELECT oent_file \n";
sSQLs+= "FROM hado_tb_oent_subcon_file \n";
sSQLs+="WHERE mng_no=? AND current_year=? AND oent_gb=? \n";

try {
	resource	= new ConnectionResource();
	conn		= resource.getConnection();

	pstmt		= conn.prepareStatement(sSQLs);
	pstmt.setString(1, ckMngNo);
	pstmt.setString(2, ckCurrentYear);
	pstmt.setString(3, ckOentGB);
	rs			= pstmt.executeQuery();

	if( rs.next() ) {
		sExcelFileName = new String( rs.getString("oent_file").getBytes("ISO8859-1"), "EUC-KR" );
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
/* 해당 사업자 업로드한 엑셀 파일명 가져오기 끝 */

if( sExcelFileName!=null && !sExcelFileName.equals("") ) {
	String sFilePath = sExcelFilePath + "/" + sExcelFileName;		// 파일 전체 경로
	boolean bTrueExcel = false;

	try {
		POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(sFilePath));
		HSSFWorkbook workbook = new HSSFWorkbook(fs);	//Workbook 생성
		HSSFSheet sheet = null;
		HSSFRow row = null;
		HSSFCell cell = null;

       int sheetNum = workbook.getNumberOfSheets();

	   if( sheetNum>0 ) bTrueExcel = true;

	} catch (Exception e) {
		System.out.println( e.getMessage() );
		e.printStackTrace();
	}
	
	if( !bTrueExcel ) sReturnMsg = "엑셀파일을 읽을 수 없습니다. 보안문서(DRM)인 경우 보안을 해제하여 주시기 바랍니다.";
} else {
	sReturnMsg = "업로드한 수급사업자명부 엑셀파일을 찾을 수 없습니다.";
}
%>
[<%=sSQLs%>]
<script type="text/javascript">
	var msg = "<%=sReturnMsg%>";
	alert(msg);
</script>