<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: Oent_Comp_Status_Proc.jsp
* ���α׷�����	: ������� �����ڷ� ��ȸ/ó�� ������
* ���α׷�����	: 1.0.2
* �����ۼ�����	: 2014�� 09�� 25��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-09-25	������		�����ۼ�
* 	2014-10-02	������		����ȭ�� ���� �и� ���̺� �ڵ� ����
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

<%@ page import="java.text.DecimalFormat"%>

<%
/**
* �Է����� ���� ���� ���� �� �ʱ�ȭ ����
*/
ConnectionResource resource = null;
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String sSQLs		= "";

String sMngNo = request.getParameter("mno") == null ? "":request.getParameter("mno").trim();
String sCurrentYear = request.getParameter("cyear") == null ? "":request.getParameter("cyear").trim();
String sOentGB = request.getParameter("ogb") == null ? "":request.getParameter("ogb").trim();

String sOentName = "";	//ȸ���
String sOentCaptine	= "";	//��ǥ�ڸ�
String sWriterOrg = "";	//�μ���
String sWriterName = "";	//�ۼ��ڸ�
String sWriterTel = "";	//��ȭ��ȣ
String sWriterEmail = "";	//�̸���
String sCenterName	= "";	//�繫�Ҹ�
String sDeptName = "";	//����
String sUserName = "";	//����ڸ�
String sPhoneNo = "";	//�������ȭ��ȣ
String sProcSN = "";	//ó������

//÷�ι��� �迭 ����
ArrayList arrMngNo = new ArrayList();		//������ȣ
ArrayList arrCYear = new ArrayList();			//����⵵
ArrayList arrOentGB = new ArrayList();		//��������
ArrayList arrFileSn = new ArrayList();			//���ϼ���
ArrayList arrFileNm = new ArrayList();		//������
ArrayList arrDocuNm = new ArrayList();	//���ϸ�
ArrayList arrUpDt = new ArrayList();			//���ε�����
ArrayList arrProcSn = new ArrayList();		//ó������
ArrayList arrCenterName = new ArrayList();	//�繫�Ҹ�
ArrayList arrDeptName = new ArrayList();	//����
ArrayList arrUserName = new ArrayList();		//����ڸ�
ArrayList arrProcCD = new ArrayList();			//ó������
ArrayList arrWriteDate = new ArrayList();		//ó������
ArrayList arrConst = new ArrayList();				//���

DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/**
* �Է����� ���� ���� ���� �� �ʱ�ȭ ��
*/
if(sMngNo != null && sCurrentYear != null && sOentGB != null && (!sMngNo.equals("")) && (!sCurrentYear.equals("")) && (!sOentGB.equals("")) ) {
	//�ۼ��� ���� ��������
	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();

		sSQLs  = "SELECT oent_name,oent_captine,writer_org,writer_name,writer_tel,assign_mail \n";
		sSQLs+= "FROM hado_tb_oent_" +sCurrentYear+ " \n";
		sSQLs+= "WHERE mng_no = ? AND current_year = ? AND oent_gb = ? \n";
		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, sMngNo);
		pstmt.setString(2, sCurrentYear);
		pstmt.setString(3, sOentGB);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			/* 2015-12-30	������		DB�������� ���� ���ڵ� ����
			sOentName= rs.getString("oent_name")== null ? "":new String(rs.getString("oent_name").getBytes("ISO8859-1"), "EUC-KR");
			sOentCaptine	= rs.getString("oent_captine")== null ? "":new String(rs.getString("oent_captine").getBytes("ISO8859-1"), "EUC-KR");
			sWriterOrg	= rs.getString("writer_org")== null ? "":new String(rs.getString("writer_org").getBytes("ISO8859-1"), "EUC-KR");
			sWriterName	= rs.getString("writer_name")== null ? "":new String(rs.getString("writer_name").getBytes("ISO8859-1"), "EUC-KR");
			sWriterTel	= rs.getString("writer_tel")== null ? "":new String(rs.getString("writer_tel").getBytes("ISO8859-1"), "EUC-KR");
			sWriterEmail	= rs.getString("assign_mail")== null ? "":new String(rs.getString("assign_mail").getBytes("ISO8859-1"), "EUC-KR");
			*/
			sOentName= rs.getString("oent_name")== null ? "":rs.getString("oent_name").trim();
			sOentCaptine	= rs.getString("oent_captine")== null ? "":rs.getString("oent_captine").trim();
			sWriterOrg	= rs.getString("writer_org")== null ? "":rs.getString("writer_org").trim();
			sWriterName	= rs.getString("writer_name")== null ? "":rs.getString("writer_name").trim();
			sWriterTel	= rs.getString("writer_tel")== null ? "":rs.getString("writer_tel").trim();
			sWriterEmail	= rs.getString("assign_mail")== null ? "":rs.getString("assign_mail").trim();
		}
		rs.close();
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if ( rs != null )	try{rs.close();}		catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )		try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}
		// �����ڷ� ��������
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		
		sSQLs  = "SELECT * \n";
		sSQLs+= "FROM hado_tb_oent_attach_file \n";
		sSQLs+= "WHERE mng_no=? AND current_year=? AND oent_gb=? \n";
		sSQLs+= "ORDER BY file_sn DESC \n";
		
		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, sMngNo);
		pstmt.setString(2, sCurrentYear);
		pstmt.setString(3, sOentGB);
		rs = pstmt.executeQuery();
		
		while (rs.next()) {
			/* 2015-12-30	������		DB�������� ���� ���ڵ� ����
			arrMngNo.add( new String( rs.getString("mng_no").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrCYear.add( new String( rs.getString("current_year").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrOentGB.add( new String( rs.getString("oent_gb").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrFileSn.add( rs.getString("file_sn") );
			arrFileNm.add( new String( rs.getString("file_name").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrDocuNm.add(new String( rs.getString("docu_name").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrUpDt.add( rs.getString("upload_dt") );
			*/
			arrMngNo.add( rs.getString("mng_no")==null ? "":rs.getString("mng_no").trim() );
			arrCYear.add( rs.getString("current_year")==null ? "":rs.getString("current_year").trim() );
			arrOentGB.add( rs.getString("oent_gb")==null ? "":rs.getString("oent_gb").trim() );
			arrFileSn.add( rs.getString("file_sn")==null ? "":rs.getString("file_sn").trim() );
			arrFileNm.add( rs.getString("file_name")==null ? "":rs.getString("file_name").trim() );
			arrDocuNm.add( rs.getString("docu_name")==null ? "":rs.getString("docu_name").trim() );
			arrUpDt.add( rs.getString("upload_dt")==null ? "":rs.getString("upload_dt").trim() );
		}
		rs.close();
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if ( rs != null )	try{rs.close();}		catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )		try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}

		// ó����Ȳ ����Ʈ  ��������
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		
		sSQLs  = "SELECT * \n";
		sSQLs+="FROM hado_tb_comp_status_proc \n";
		sSQLs+= "WHERE mng_no=? AND current_year=? AND oent_gb=? \n";
		sSQLs+= "ORDER BY proc_sn DESC \n";
		
		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, sMngNo);
		pstmt.setString(2, sCurrentYear);
		pstmt.setString(3, sOentGB);
		rs = pstmt.executeQuery();
		
		while (rs.next()) {
			/* 2015-12-30	������		DB�������� ���� ���ڵ� ����
			arrCenterName.add( new String( rs.getString("center_name").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrDeptName.add(new String( rs.getString("dept_name").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrUserName.add(new String( rs.getString("user_name").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrProcCD.add( rs.getString("proc_cd") );
			arrWriteDate.add( rs.getString("write_date") );
			// ����ó�� (��� �Է��� �ȵǸ� out of bound inde ����)
			String stmConst = rs.getString("const")==null ? "��� ���� ����":new String( rs.getString("const").getBytes("ISO8859-1"), "EUC-KR" );
			arrConst.add( stmConst );
			*/
			arrCenterName.add( rs.getString("center_name").trim() );
			arrDeptName.add( rs.getString("dept_name").trim() );
			arrUserName.add( rs.getString("user_name").trim() );
			arrProcCD.add( rs.getString("proc_cd").trim() );
			arrWriteDate.add( rs.getString("write_date").trim() );
			arrConst.add( rs.getString("const")==null ? "��� ���� ����":rs.getString("const").trim() );
		}
		rs.close();
	} catch(Exception e){
			e.printStackTrace();
	} finally {
			if ( rs != null )	try{rs.close();}		catch(Exception e){}
			if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
			if ( conn != null )		try{conn.close();}	catch(Exception e){}
			if ( resource != null ) resource.release();
	}
	//���� ���� ��������
	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();

		sSQLs  ="SELECT  center_name,dept_name,user_name,phone_no \n";
		sSQLs+="FROM hado_vt_dept_history_" +sCurrentYear+ " \n";	// �и� ���̺� ����  / 20141002 / ������
		sSQLs+= "WHERE mng_no = ? AND current_year = ? AND oent_gb = ? \n";
		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, sMngNo);
		pstmt.setString(2, sCurrentYear);
		pstmt.setString(3, sOentGB);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			/* 2015-12-30	������		DB�������� ���� ���ڵ� ����
			sCenterName= rs.getString("center_name")== null ? "":new String(rs.getString("center_name").getBytes("ISO8859-1"), "EUC-KR");
			sDeptName	= rs.getString("dept_name")== null ? "":new String(rs.getString("dept_name").getBytes("ISO8859-1"), "EUC-KR");
			sUserName	= rs.getString("user_name")== null ? "":new String(rs.getString("user_name").getBytes("ISO8859-1"), "EUC-KR");
			sPhoneNo	= rs.getString("phone_no")== null ? "":new String(rs.getString("phone_no"));
			*/
			sCenterName= rs.getString("center_name")== null ? "":rs.getString("center_name").trim();
			sDeptName	= rs.getString("dept_name")== null ? "":rs.getString("dept_name").trim();
			sUserName	= rs.getString("user_name")== null ? "":rs.getString("user_name").trim();
			sPhoneNo	= rs.getString("phone_no")== null ? "":rs.getString("phone_no").trim();
		}
		rs.close();
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if ( rs != null )	try{rs.close();}		catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )		try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}
}
%>

<html>
<head>
	<title>���������ϵ��ްŷ� �����������</title>
	<meta charset="euc-kr">
	<link rel="stylesheet" href="/hado/hado/wTools/style.css" type="text/css">
	<script type="text/javascript">
	//<![CDATA[
		function chksubmit() {
			var main	= document.info;

			main.target = "ProceFrame";
			main.action = "Oent_Comp_Status_save.jsp";
			main.method = "post";
			main.submit();
		}

		function viewConst(lyno) {
			var tobj = document.getElementById("lyList" + lyno);

			if( tobj ) {
				tobj.style.display = "block";
			}
		}

		function closeConst(lyno) {
			var tobj = document.getElementById("lyList" + lyno);

			if( tobj ) {
				tobj.style.display = "none";
			}
		}
	//]]
	</script>
</head>
<body>
<div id='viewWinTop' style="width:600px;">
	<ul class='lt'>
		<li class='fr'><a href="javascript:self.close()"; class='sbutton'>â�ݱ�</a></li>
	</ul>
</div>


<div id='viewWinTitle'>1. �ۼ��� ����</div>

<table class='ViewResultTable' align='center'>
	<tr>
		<th>ȸ���</th>
		<td>&nbsp;<%=sOentName%></td>
		<th>��ǥ�ڸ�</th>
		<td>&nbsp;<%=sOentCaptine%></td>
	</tr>
	<tr>
		<th>�ۼ��� �μ�</th>
		<td>&nbsp;<%=sWriterOrg%></td>
		<th>�ۼ��� �̸�</th>
		<td>&nbsp;<%=sWriterName%></td>
	</tr>
	<tr>
		<th>�ۼ��� ��ȭ��ȣ</th>
		<td>&nbsp;<%=sWriterTel%></td>
		<th>�ۼ��� e-mail</th>
		<td>&nbsp;<%=sWriterEmail%></td>
	</tr>
</table>

<div id='viewWinTitle'>2. ÷�ι���(�����ڷ�)</div>

<table class='ViewResultTable' align='center'>
	<colgroup>
		<col style='width:10%;' />
		<col style='width:40%;' />
		<col style='width:30%;' />
		<col style='width:20%;' />
	</colgroup>
	<tr>
		<th>����</th>
		<th>÷�ι�����</th>
		<th>÷�����ϸ�</th>
		<th>���ε�����</th>
	</tr>
	<tr>
	<%for( int i=0; i<arrFileNm.size(); i++ ) {%>
		<td>&nbsp;<%=arrFileNm.size() - i%></td>
		<td>&nbsp;<%=arrDocuNm.get(i)%></td>
		<td>&nbsp;<a href='/hado/hado/wTools/Oent/Oent_Comp_Status_Proc_File_Down.jsp?sn=<%=arrFileSn.get(i)%>&mno=<%=arrMngNo.get(i)%>&cyear=<%=arrCYear.get(i)%>&ogb=<%=arrOentGB.get(i)%>'><%=arrFileNm.get(i)%></a></td>
		<td>&nbsp;<%=arrUpDt.get(i).toString().substring(0,10)%></td>
	</tr>
	<%}%>
</table>

<div id='viewWinTitle'>3. ó�� ��Ȳ</div>

<table class='ViewResultTable' align='center'>
	<colgroup>
		<col style='width:27%;' />
		<col style='width:25%;' />
		<col style='width:15%;' />
		<col style='width:10%;' />
		<col style='width:20%;' />
		<col style='width:3%;' />
	</colgroup>
	<tr>
		<th>�繫�Ҹ�</th>
		<th>����</th>
		<th>������</th>
		<th>����</th>
		<th>ó������</th>
		<th>�����</th>
	</tr>
	<%
	if( arrProcCD.size()>0 ) {
		for( int i=0; i<arrProcCD.size(); i++ ) {%>
	<tr>
		<td>&nbsp;<%=arrCenterName.get(i).toString()%></td>
		<td>&nbsp;<%=arrDeptName.get(i).toString()%></td>
		<td>&nbsp;<%=arrUserName.get(i).toString()%></td>
		<%
		String sTmpProcCD = arrProcCD.get(i).toString();
		if( sTmpProcCD.equals("1") ) sTmpProcCD = "<font style='color:blue;'>����</font>";
		else if( sTmpProcCD.equals("2") ) sTmpProcCD = "<font style='color:red;'>�ݷ�</font>";
		else sTmpProcCD = "��ó��";
		%>
		<td>&nbsp;<%=sTmpProcCD%></td>
		<td>&nbsp;<%=arrWriteDate.get(i).toString().substring(0,10)%></td>
		<td><li class="fr"><a href="javascript:viewConst('<%=i%>');" class="sbutton">�����</a></li></td>
	</tr>
	<tr id="lyList<%=i%>" style="display:none;">
		<td colspan="6">
			<%=arrConst.get(i)%>
			<li class="fr"><a href="javascript:closeConst('<%=i%>');" class="sbutton">���ݱ�</a></li>
		</td>
	</tr>
	<%
		}
	} else {%>
	<tr>
		<td colspan="6" align="center">
			��ϵ� ó������� �����ϴ�.
		</td>
	</tr>
	<%
	}%>
</table>

<div id='viewWinTitle'>4. ��������</div>

<table class='ViewResultTable' align='center'>
	<tr>
		<th>�繫�Ҹ�</th>
		<td>&nbsp;<%=sCenterName%></td>
		<th>����</th>
		<td>&nbsp;<%=sDeptName%></td>
	</tr>
	<tr>
		<th>������</th>
		<td>&nbsp;<%=sUserName%></td>
		<th>��ȭ��ȣ</th>
		<td>&nbsp;<%=sPhoneNo%></td>
	</tr>
</table>

<div id='viewWinTitle'>5. ó�����</div>

<table class='ViewResultTable' align='center'>
	<form action="" method="post" name="info">
		<tr>
			<th>ó������
				<input type="hidden" name="mno" value="<%=sMngNo%>"/>
				<input type="hidden" name="cyear" value="<%=sCurrentYear%>"/>
				<input type="hidden" name="ogb" value="<%=sOentGB%>"/>
			</th>
			<td><input type="radio" name="filecheck" value="1" checked> ����
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="filecheck" value="2"> �ݷ�</td>
		</tr>
		<tr>
			<th>���</th>
			<td><textarea cols="70" rows="4" maxlength="1000" name="fileconst" class="textarea01b" ></textarea>
			</td>
		</tr>
	</form>
</table>

<li class='fr'><a href='javascript:chksubmit()'class='sbutton'>���</a></li>

<iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
</body>
</html>