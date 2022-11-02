<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: 2014�� �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_SP_excelProcess_byPOI_02.jsp
* ���α׷�����	: ���޻���ڸ�� �������� ó�� (Step 2. ��Ʈ����)
* ���α׷�����	: 3.0.0-2014
* �����ۼ�����	: 2014�� 09�� 14��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-09-14	������       �����ۼ�
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

String sExcelFilePath =  config.getServletContext().getRealPath("/upload/"+ckCurrentYear);	// �������� ���
String sExcelFileName = "";
String sReturnMsg = "";

int nSheetNum = 0;
ArrayList arrSheetNm = new ArrayList();	// ��Ʈ�迭 ���� arraylist

/* �ش� ����� ���ε��� ���� ���ϸ� �������� ���� */
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
/* �ش� ����� ���ε��� ���� ���ϸ� �������� �� */

if( sExcelFileName!=null && !sExcelFileName.equals("") ) {
	String sFilePath = sExcelFilePath + "/" + sExcelFileName;		// ���� ��ü ���
	boolean bTrueExcel = false;

	try {
		POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(sFilePath));
		HSSFWorkbook workbook = new HSSFWorkbook(fs);	//Workbook ����
		HSSFSheet sheet = null;
		HSSFRow row = null;
		HSSFCell cell = null;

		nSheetNum = workbook.getNumberOfSheets();

		for( int i=0; i<nSheetNum; i++ ) {
			arrSheetNm.add( workbook.getSheetName(i).toString() ) ;
		}

	} catch (Exception e) {
		System.out.println( e.getMessage() );
		e.printStackTrace();
	}
}

/* ��Ʈ�̸��� ����ϰ� �ۼ��� ��Ʈ�� �����Ͽ� ��Ʈ��ȣ�� ��ȯ�޴´� */
%>
<div id="excelSheetList">
	<ul class="fl">
		<%
		for( int i=0; i<nSheetNum; i++ ) { %>
		<li><a href="WB_SP_excelProcess_byPOI_03.jsp?sn=<%=i%>"><%=i+1%>��° ��Ʈ�� : <%=arrSheetNm.get(i).toString()%></a></li>
		<%
		}%>
	</ul>
</div>