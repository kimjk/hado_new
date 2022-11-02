<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: 2014�� �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_AP_getAttachFile_List.jsp
* ���α׷�����	: �����ڷ�÷�� ���� ����Ʈ
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

/* ���ε� ���ϸ���Ʈ ���� ���� */
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
/* ���ε� ���ϸ���Ʈ ���� �� */

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