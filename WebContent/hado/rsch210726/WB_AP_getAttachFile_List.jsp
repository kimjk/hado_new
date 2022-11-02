<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 2014년 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_AP_getAttachFile_List.jsp
* 프로그램설명	: 증빙자료첨부 파일 리스트
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
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_Inc_chkSession.jsp"%>

<%
ConnectionResource resource = null;
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String sSQLs = "";

ArrayList arrFileSn = new ArrayList();
ArrayList arrFileNm = new ArrayList();
ArrayList arrDocuNm = new ArrayList();
ArrayList arrUpDt = new ArrayList();

/* 업로드 파일리스트 생성 시작 */
try {
	resource = new ConnectionResource();
	conn = resource.getConnection();
	
	sSQLs  = "SELECT * \n";
	sSQLs+= "FROM hado_tb_oent_attach_file \n";
	sSQLs+= "WHERE mng_no=? AND current_year=? AND oent_gb=? \n";
	sSQLs+= "ORDER BY file_sn DESC \n";
	
	pstmt = conn.prepareStatement(sSQLs);
	pstmt.setString(1, ckMngNo);
	pstmt.setString(2, ckCurrentYear);
	pstmt.setString(3, ckOentGB);
	rs = pstmt.executeQuery();

	while (rs.next()) {
		arrFileSn.add( rs.getString("file_sn") );
		arrFileNm.add( new String( rs.getString("file_name").getBytes("ISO8859-1"), "EUC-KR" ) );
		arrDocuNm.add(new String( rs.getString("docu_name").getBytes("ISO8859-1"), "EUC-KR" ) );
		arrUpDt.add( rs.getString("upload_dt") );
	}
	rs.close();
}
catch(Exception e){
	e.printStackTrace();
}
finally {
	if ( rs != null ) try{rs.close();}catch(Exception e){}
	if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
	if ( conn != null ) try{conn.close();}catch(Exception e){}
	if ( resource != null ) resource.release();
}
/* 업로드 파일리스트 생성 끝 */

for( int i=0; i<arrFileNm.size(); i++ ) {
%>
<tr>
	<td><%=arrFileNm.size() - i%></td>
	<td><%=arrDocuNm.get(i)%></td>
	<td><a href="WB_SP_Download_01.jsp?sn=<%=arrFileSn.get(i)%>" target="ProceFrame"><%=arrFileNm.get(i)%></a></td>
	<td><%=arrUpDt.get(i).toString().substring(0,10)%></td>
</tr>
<%
}%>