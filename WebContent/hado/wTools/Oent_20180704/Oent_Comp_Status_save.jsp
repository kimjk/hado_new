<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: Oent_Comp_Status_Proc.jsp
* ���α׷�����	: ������� �����ڷ� ��ȸ/ó�� ������
* ���α׷�����	: 1.0.1
* �����ۼ�����	: 2014�� 09�� 25��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-09-25	������       �����ۼ�
*	2015-12-30	������		DB�������� ���� ���ڵ� ����
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
* �Է����� ���� ���� ���� �� �ʱ�ȭ ����
*/
ConnectionResource resource = null;
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String sMngNo = request.getParameter("mno") == null ? "":request.getParameter("mno").trim();
String sCurrentYear = request.getParameter("cyear") == null ? "":request.getParameter("cyear").trim();
String sOentGB = request.getParameter("ogb") == null ? "":request.getParameter("ogb").trim();
String sSQLs = "";
String sProcCD = request.getParameter("filecheck") == null ? "3":request.getParameter("filecheck").trim();	// ó������
/*	2015-12-30	������		DB�������� ���� ���ڵ� ����
String sConst = request.getParameter("fileconst") == null ? "": new String(request.getParameter("fileconst").trim().getBytes("euc-kr"), "ISO8859-1" );

String sCenterName = new String( ckCenterName.getBytes("euc-kr"), "ISO8859-1");
String sDeptName = new String( ckDeptName.getBytes("euc-kr"), "ISO8859-1");
String sUserName = new String( ckUserName.getBytes("euc-kr"), "ISO8859-1");
*/
String sConst = request.getParameter("fileconst") == null ? "": request.getParameter("fileconst").trim();			// ���

String sCenterName = ckCenterName;
String sDeptName = ckDeptName;
String sUserName = ckUserName;

int nNewSn = 1;	// ���ϼ���

if( !sMngNo.equals("") && !sCurrentYear.equals("") && !sOentGB.equals("") ) {
	/* �ű� ���� ���ϱ� ���� */
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
	/* �ű� ���� ���ϱ� �� */

	/* ÷���������� ����Ÿ���̽� ���� ���� */
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
	<title>���������ϵ��ްŷ� �����������</title>
	<meta charset="euc-kr">
	<link rel="stylesheet" href="/hado/hado/wTools/style.css" type="text/css">
	<script type="text/JavaScript">
	//<![CDATA[
		alert("����� �Ϸ�Ǿ����ϴ�.");
		parent.location.replace(parent.location.href);
	//]]
	</script>
</head>

<body>
</body>
</html>