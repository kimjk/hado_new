<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: Oent_Comp_Status_PList.jsp
* ���α׷�����	: ������� �������� ��Ȳ
* ���α׷�����	: 3.0.4
* �����ۼ�����	: 2014�� 09�� 24��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-09-24	������	�����ۼ�
*  	2014-09-29	������	ó����� �˻� �߰�
*  	2014-09-30	������	����/�ݷ�/��ó�� ����� ��� �߰�
*  	2014-10-02	������	����ȭ�� ���� �и� ���̺� �ڵ� ����
*	2015-12-30	������	DB�������� ���� ���ڵ� ����
*/
%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
ConnectionResource resource = null;
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

// ����Ʈ �迭
ArrayList arrMngNo = new ArrayList();
ArrayList arrCYear = new ArrayList();
ArrayList arrOentGB = new ArrayList();
ArrayList arrOentName = new ArrayList();
ArrayList arrCenterNm = new ArrayList();
ArrayList arrDeptNm = new ArrayList();
ArrayList arrUserNm = new ArrayList();
ArrayList arrProcCD = new ArrayList();

String sSQLs = "";

// Page
int nPageSize = 8;
int nPage = 1;
int nMaxPage = 1;
int nRecordCount = 0;
String sTmpPage = request.getParameter("page")==null ? "1":request.getParameter("page").trim();
if( sTmpPage != null && (!sTmpPage.equals("")) ) {
	nPage = Integer.parseInt(sTmpPage);
} else {
	String sTmpPages = (String)session.getAttribute("page");
	if( sTmpPages != null && (!sTmpPages.equals("")) ) {
		nPage = Integer.parseInt(sTmpPages);
	} else {
		nPage = 1;
	}
}
// ó������ Ȯ�� - 20140930 ������
int nProc01 = 0;
int nProc02 = 0;
int nProc03 = 0;

// request parameters
String sSearchYear = request.getParameter("currentYear")==null ? st_Current_Year:request.getParameter("currentYear").trim();
String sCenterNm = request.getParameter("mcenternm")==null ? "":request.getParameter("mcenternm").trim();
String sDeptNm = request.getParameter("mdeptname")==null ? "":request.getParameter("mdeptname").trim();
String sProcCD = request.getParameter("mproccd") == null ? "":request.getParameter("mproccd").trim();	// ���ο��� �˻�����

// ��ü ī��Ʈ - ����/�ݷ�/��ó�� ����� �߰� - 20140930 ������
try {
	resource = new ConnectionResource();
	conn = resource.getConnection();

	sSQLs  = "SELECT COUNT(*) AS rCnt, \n";
	sSQLs+="SUM(CASE proc_cd WHEN '1' THEN 1 ELSE 0 END) AS proc01, \n";
	sSQLs+="SUM(CASE proc_cd WHEN '2' THEN 1 ELSE 0 END) AS proc02, \n";
	sSQLs+="SUM(CASE proc_cd WHEN '3' THEN 1 ELSE 0 END) AS proc03 \n";
	sSQLs+="FROM (  \n";
	sSQLs+="    SELECT c.*, d.center_name, d.dept_name, d.user_name, NVL(e.proc_cd, '3') AS proc_cd \n";
	sSQLs+="    FROM (  \n";
	sSQLs+="        SELECT mng_no, current_year, oent_gb, oent_name \n";
	sSQLs+="        FROM hado_tb_oent_" + sSearchYear + " \n";
    sSQLs+="        WHERE current_year='" + sSearchYear + "' \n";
	sSQLs+="            AND LENGTH(mng_no)>6 \n";
	sSQLs+="            AND NOT comp_status='1' AND NOT comp_status='1' \n";
	sSQLs+="            AND oent_status='1' \n";
	sSQLs+="            AND addr_status IS NULL \n";
	sSQLs+="    ) c LEFT JOIN hado_vt_dept_history_" + sSearchYear + " d \n";		// �и� ���̺� ����  / 20141002 / ������
	sSQLs+="        ON c.current_year=d.current_year AND c.mng_no=d.mng_no AND c.oent_gb=d.oent_gb \n";
	sSQLs+="    LEFT JOIN hado_vt_comp_status_proc e \n";
	sSQLs+="        ON c.current_year=e.current_year AND c.mng_no=e.mng_no AND c.oent_gb=e.oent_gb \n";
	sSQLs+=") jTb \n";
	sSQLs+="WHERE mng_no IS NOT NULL \n";
	
	if( !sCenterNm.equals("") ) {
		/*	2015-12-30	������	DB�������� ���� ���ڵ� ����
		sSQLs+="	AND center_name='" + new String( sCenterNm.getBytes("EUC-KR"),"ISO8859-1" ) + "' \n";
		*/
		sSQLs+="	AND center_name='" + sCenterNm + "' \n";
	}
	if( !sDeptNm.equals("") ) {
		/*	2015-12-30	������	DB�������� ���� ���ڵ� ����
		sSQLs+="	AND dept_name='" + new String( sDeptNm.getBytes("EUC-KR"),"ISO8859-1" ) + "' \n";
		*/
		sSQLs+="	AND dept_name='" +  sDeptNm + "' \n";
	}
	// ó������ �˻����� �߰� - 20140929 - ������
	if( !sProcCD.equals("") ) {
		sSQLs+="	AND proc_cd='" + sProcCD + "' \n";
	}


	pstmt = conn.prepareStatement(sSQLs);
	rs = pstmt.executeQuery();	

	if( rs.next() ) {
		nRecordCount = rs.getInt("rCnt");
		nProc01 = rs.getInt("proc01");
		nProc02 = rs.getInt("proc02");
		nProc03 = rs.getInt("proc03");
	}
} catch(Exception e){
	e.printStackTrace();
}
finally {
	if ( rs != null ) try{rs.close();}catch(Exception e){}
	if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
	if ( conn != null ) try{conn.close();}catch(Exception e){}
	if ( resource != null ) resource.release();
}

// ������ �� ���
if(nRecordCount > 0) {
	nMaxPage = (int)Math.round(nRecordCount / (float)nPageSize + 0.4999999F);
}


// list �迭
try {
	resource = new ConnectionResource();
	conn = resource.getConnection();

	sSQLs  = "SELECT * \n";
	sSQLs+="FROM ( \n";
    sSQLs+="	SELECT jTb.*, FLOOR((ROWNUM - 1) / " + nPageSize + " + 1) AS page \n";
    sSQLs+="	FROM ( \n";
    sSQLs+="		SELECT c.*, d.center_name, d.dept_name, d.user_name \n";
    sSQLs+="		FROM ( \n";
    sSQLs+="			SELECT a.*, NVL(b.proc_cd, '3') AS proc_cd \n";
    sSQLs+="			FROM ( \n";
    sSQLs+="				SELECT mng_no, current_year, oent_gb, oent_name \n";
    sSQLs+="				FROM hado_tb_oent_" + sSearchYear + " \n";
    sSQLs+="				WHERE current_year='" + sSearchYear + "' \n";
    sSQLs+="					AND LENGTH(mng_no)>6 \n";
    sSQLs+="					AND NOT comp_status='1' AND NOT comp_status='1' \n";
    sSQLs+="					AND oent_status='1' \n";
    sSQLs+="					AND addr_status IS NULL \n";
    sSQLs+="			) a LEFT JOIN hado_vt_comp_status_proc b \n";
    sSQLs+="				ON a.current_year=b.current_year AND a.mng_no=b.mng_no AND a.oent_gb=b.oent_gb \n";
    sSQLs+="			) c LEFT JOIN hado_vt_dept_history_" + sSearchYear + " d \n";	// �и� ���̺� ����  / 20141002 / ������
    sSQLs+="				ON c.current_year=d.current_year AND c.mng_no=d.mng_no AND c.oent_gb=d.oent_gb \n";
	sSQLs+="		ORDER BY c.proc_cd DESC, c.mng_no \n";
    sSQLs+="	) jTb \n";
	sSQLs+="WHERE mng_no IS NOT NULL \n";
	
	if( !sCenterNm.equals("") ) {
		/*	2015-12-30	������	DB�������� ���� ���ڵ� ����
		sSQLs+="	AND center_name='" + new String( sCenterNm.getBytes("EUC-KR"),"ISO8859-1" ) + "' \n";
		*/
		sSQLs+="	AND center_name='" + sCenterNm + "' \n";
	}
	if( !sDeptNm.equals("") ) {
		/*	2015-12-30	������	DB�������� ���� ���ڵ� ����
		sSQLs+="	AND dept_name='" + new String( sDeptNm.getBytes("EUC-KR"),"ISO8859-1" ) + "' \n";
		*/
		sSQLs+="	AND dept_name='" +  sDeptNm + "' \n";
	}
	// ó������ �˻����� �߰� - 20140929 - ������
	if( !sProcCD.equals("") ) {
		if( sProcCD.equals("1") ) {
			sSQLs+="	AND (proc_cd='1' OR proc_cd='3') \n";
		} else {
			sSQLs+="	AND proc_cd='" + sProcCD + "' \n";
		}
	}
	
	sSQLs+=") pTb \n";
	sSQLs+="WHERE page=" + nPage + " \n";

	pstmt = conn.prepareStatement(sSQLs);

//	System.out.println(sSQLs);

	rs = pstmt.executeQuery();	

	while ( rs.next()) {
		arrMngNo.add( rs.getString("mng_no")==null ? "":rs.getString("mng_no").trim() );
		arrCYear.add( rs.getString("current_year")==null ? "":rs.getString("current_year").trim() );
		arrOentGB.add( rs.getString("oent_gb")==null ? "":rs.getString("oent_gb").trim() );
		/*	2015-12-30	������	DB�������� ���� ���ڵ� ����
		arrOentName.add( new String( StringUtil.checkNull(rs.getString("oent_name")).trim().getBytes("ISO8859-1"), "EUC-KR" ) );
		arrCenterNm.add( new String( StringUtil.checkNull(rs.getString("center_name")).trim().getBytes("ISO8859-1"), "EUC-KR" ) );
		arrDeptNm.add( new String( StringUtil.checkNull(rs.getString("dept_name")).trim().getBytes("ISO8859-1"), "EUC-KR" ) );
		arrUserNm.add( new String( StringUtil.checkNull(rs.getString("user_name")).trim().getBytes("ISO8859-1"), "EUC-KR" ) );
		*/
		arrOentName.add( rs.getString("oent_name")==null ? "":rs.getString("oent_name").trim() );
		arrCenterNm.add( rs.getString("center_name")==null ? "":rs.getString("center_name").trim() );
		arrDeptNm.add( rs.getString("dept_name")==null ? "":rs.getString("dept_name").trim() );
		arrUserNm.add( rs.getString("user_name")==null ? "":rs.getString("user_name").trim() );
		arrProcCD.add( rs.getString("proc_cd")==null ? "":rs.getString("proc_cd").trim() );
	}
	rs.close();

} catch(Exception e){
	e.printStackTrace();
}
finally {
	if ( rs != null ) try{rs.close();}catch(Exception e){}
	if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
	if ( conn != null ) try{conn.close();}catch(Exception e){}
	if ( resource != null ) resource.release();
}
%>
<script type="text/javascript">
//<![CDATA[
	content = "";
	
	content+="<table id='divButton'>";
	content+="	<tr>";
	//content+="		<td>�˻��� ȸ��� : <%=nRecordCount%>��, ���� :  <%=nProc01%>��, �ݷ� :  <%=nProc02%>��, ��ó�� :  <%=nProc03%>��, (page. <%=nPage%> / <%=nMaxPage%>)&nbsp;&nbsp;&nbsp;&nbsp;<font style='color:blue;'>* �Ҽ� ���� ������ ������ ����˴ϴ�. (������ ����)</font></td>";
	content+="		<td>�˻��� ȸ��� : <%=nRecordCount%>��, ó�� :  <%=nProc01+nProc03%>��, �ݷ� :  <%=nProc02%>��, (page. <%=nPage%> / <%=nMaxPage%>)&nbsp;&nbsp;&nbsp;&nbsp;<font style='color:blue;'>* �Ҽ� ���� ������ ������ ����˴ϴ�. (������ ����)</font></td>";
	content+="	</tr>";
	content+="</table>";
	
	content+="<table class='resultTable'>";
	content+="	<colgroup>";
	content+="			<col style='width:30px;' />";
	content+="			<col style='width:60px;' />";
	content+="			<col style='' />";
	content+="			<col style='width:115px;' />";
	content+="			<col style='width:120px;' />";
	content+="			<col style='width:50px;' />";
	content+="			<col style='width:40px;' />";
	content+="			<col style='width:40px;' />";
	content+="	</colgroup>";
	content+="	<tr>";
	content+="		<th>����</th>";
	content+="		<th>������ȣ</th>";
	content+="		<th>ȸ���</th>";
	content+="		<th>���繫�Ҹ�</th>";
	content+="		<th>������</th>";
	content+="		<th>����ڸ�</th>";
	content+="		<th>ó������</th>";
	content+="		<th>ó�����</th>";
	content+="	</tr>";
	<%if( arrMngNo.size()>0 ) {
		for(int j=0; j<arrMngNo.size(); j++) {%>
	content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	content+="		<td><%if( arrOentGB.get(j).equals("3") ) {%>�뿪<%} else if( arrOentGB.get(j).equals("2") ) {%>�Ǽ�<%} else {%>����<%}%></td>";
	content+="		<td><%=arrMngNo.get(j)%></td>";
	content+="		<td><%=arrOentName.get(j)%></td>";
	content+="		<td><%=arrCenterNm.get(j)%></td>";
	content+="		<td><%=arrDeptNm.get(j)%></td>";
	content+="		<td><%=arrUserNm.get(j)%></td>";
	//content+="		<td><%if( arrProcCD.get(j).equals("1") ) {%>����<%} else if( arrProcCD.get(j).equals("2") ) {%>�ݷ�<%} else {%>��ó��<%}%></td>";
	content+="		<td><%if( arrProcCD.get(j).equals("1") ) {%>ó��<%} else if( arrProcCD.get(j).equals("2") ) {%>�ݷ�<%} else {%>ó��<%}%></td>";
	content+="		<td><a href=javascript:submitProc('<%=arrMngNo.get(j)%>','<%=arrCYear.get(j)%>','<%=arrOentGB.get(j)%>'); class='sbutton'>��ȸ/���</a></td>";
	content+="	</tr>";
	<%
		}
	} else {%>
	content+="	<tr>";
	content+="		<td colspan='8' class='noneResultset'>�˻� ����� �����ϴ�</td>";
	content+="	</tr>";
	<%
	}
	%>
	content+="</table>";
	content+="<div id='pageMove'>";
	content+="<p align='center'><%=UF_PageMove_java(nPage, nMaxPage, "pmove('Oent/Oent_Comp_Status_PList.jsp?page=")%></p>";
	content+="</div>";
	
	parent.document.getElementById("divResult").innerHTML = content;
//]]
</script>
<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>