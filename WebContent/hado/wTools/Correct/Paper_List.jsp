<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. ������Ʈ�� : ������������ȸ �ϵ��ްŷ� �������ǽ�������					                       */
/*  2. ��ü���� :																					   */
/*     - ��ü�� : (��)��Ƽ������																	   */
/*	   - Project Manamger : ������ ���� (pcxman99@naver.com)										   */
/*     - ����ó : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  3. ���� : 2012�� 7��																			   */
/*  4. �����ۼ��� �� ���� : (��)��Ƽ������ ����ȣ / 2012-07-03										   */
/*  5. ������Ʈ���� (���� / ����)																	   */
/*-----------------------------------------------------------------------------------------------------*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/
	// ����Ʈ �迭
	ArrayList arrMngNo			= new ArrayList();
	ArrayList arrCYear			= new ArrayList();
	ArrayList arrOentGB			= new ArrayList();
	ArrayList arrOentName		= new ArrayList();
	ArrayList arrOentCaptine	= new ArrayList();
	ArrayList arrWriterName		= new ArrayList();
	ArrayList arrWriterTel		= new ArrayList();
	ArrayList arrWriterFax		= new ArrayList();
	ArrayList arrCenterCode		= new ArrayList();
	ArrayList arrCenterName		= new ArrayList();
	ArrayList arrDeptName		= new ArrayList();
	ArrayList arrUserName		= new ArrayList();
	ArrayList arrCVSNo			= new ArrayList();
	ArrayList arrPostNo			= new ArrayList();
	ArrayList arrCorrectType	= new ArrayList();

	String sSQLs		= "";
	String sSQLsCnt		= "";
	String sSQLsPage	= "";
	String tmpStr		= "";


	ConnectionResource resource		= null;
	Connection conn					= null;
	PreparedStatement pstmt			= null;
	ResultSet rs					= null;
	

	int sStartYear	= 2011;
	int currentYear = 2013;

	int recordCount = 0;
	int currentPage	= 0;
	int maxPages	= 0;
	int maxPagesI	= 0;


	String initPage		= "1";
	String initPageSize = "30";

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/	

	session.setAttribute("sgb",StringUtil.checkNull(request.getParameter("sgb")).trim());
	session.setAttribute("wgb",StringUtil.checkNull(request.getParameter("wgb")).trim());
	session.setAttribute("scomp",new String(StringUtil.checkNull(request.getParameter("scomp")).trim().getBytes("EUC-KR"), "ISO8859-1" ));
	session.setAttribute("ssort",StringUtil.checkNull(request.getParameter("ssort")).trim());
	session.setAttribute("csid",StringUtil.checkNull(request.getParameter("csid")).trim());
	session.setAttribute("ceid",StringUtil.checkNull(request.getParameter("ceid")).trim());
	session.setAttribute("oareacode",StringUtil.checkNull(request.getParameter("mareacode")).trim());
	session.setAttribute("odeptname",StringUtil.checkNull(request.getParameter("mdeptname")).trim());
	session.setAttribute("unitid",StringUtil.checkNull(request.getParameter("unitid")).trim());	
	session.setAttribute("surgb", StringUtil.checkNull(request.getParameter("surgb")).trim());
	session.setAttribute("insertf", StringUtil.checkNull(request.getParameter("insertf")).trim());

	// �⵵ �ʱⰪ
	if(request.getParameter("cyear")==null || request.getParameter("cyear").equals("") || request.getParameter("cyear").equals("null") ) {
		session.setAttribute("cyear", "2013");
	} else {
		session.setAttribute("cyear", StringUtil.checkNull(request.getParameter("cyear")).trim());
	}

	// ������ �ʱⰪ
	if(request.getParameter("page")==null || request.getParameter("page").equals("") || request.getParameter("page").equals("null") ) {
		session.setAttribute("page", initPage);
	} else {
		session.setAttribute("page", StringUtil.checkNull(request.getParameter("page")).trim());
	}

	// ������ ������ �ʱⰪ
	if(request.getParameter("mpagesize")==null || request.getParameter("mpagesize").equals("") || request.getParameter("mpagesize").equals("null")) {
		session.setAttribute("pagecnt", initPageSize);
	} else {
		session.setAttribute("pagecnt", StringUtil.checkNull(request.getParameter("mpagesize")).trim());
	}

	sSQLsCnt="SELECT COUNT(*) CNT FROM ( \n";

	sSQLsPage="SELECT * FROM ( \n";
	sSQLsPage+="	SELECT TT.*, FLOOR((ROWNUM-1)/"+session.getAttribute("pagecnt")+"+1) PAGE FROM ( \n";

//---------------------------------------------------------------------------------------
	sSQLs+="SELECT AA.*, BB.Correct_Typ FROM ( \n";
	sSQLs+="	SELECT A.Mng_No, A.Current_Year, A.Oent_GB, A.Oent_Name, \n";
	sSQLs+="	A.Oent_Captine, A.Oent_Address, A.Oent_Tel, B.POST_NO_03, \n";
	sSQLs+="	C.CVSNo, C.Center_Name, C.Dept_Name, C.User_Name, C.Phone_No FROM ( \n";
	sSQLs+="		SELECT * FROM HADO_TB_Survey_Print \n";
	sSQLs+="		WHERE (A1+SA1)>0 \n";
	sSQLs+="	) A LEFT JOIN HADO_TB_Oent_PostNo B \n";
	sSQLs+="		ON A.Mng_No=B.Mng_No AND A.Current_Year=B.Current_Year AND A.Oent_GB=B.Oent_GB \n";
	sSQLs+="	LEFT JOIN HADO_VT_Dept_History C \n";
	sSQLs+="		ON A.Mng_No=C.Mng_No AND A.Current_Year=C.Current_Year AND A.Oent_GB=C.Oent_GB \n";
	sSQLs+=") AA LEFT JOIN HADO_VT_Survey_CTX3 BB \n";
	sSQLs+="	ON AA.Mng_No=BB.Mng_No AND AA.Current_Year=BB.Current_Year AND AA.Oent_GB=BB.Oent_GB \n";
	sSQLs+="WHERE AA.Current_Year='"+session.getAttribute("cyear")+"' \n";

	if( session.getAttribute("insertf").equals("1") ) {
		sSQLs+="AND Correct_Typ IS NOT NULL \n";
	} else if( session.getAttribute("insertf").equals("0") ) {
		sSQLs+="AND Correct_Typ IS NULL \n";
	}
	if( !session.getAttribute("scomp").equals("") ) {
		sSQLs+="AND REPLACE(OENT_NAME,' ','') LIKE '%"+session.getAttribute("scomp")+"%' \n";
	}
	if( !session.getAttribute("unitid").equals("") ) {
		sSQLs+="AND AA.MNG_NO LIKE '%"+session.getAttribute("unitid")+"%' \n";
	}
	
	if( !session.getAttribute("wgb").equals("") ) {
		sSQLs+="AND AA.OENT_GB='"+session.getAttribute("wgb")+"' \n";
	}/*
	if( !session.getAttribute("sgb").equals("") ) {
		sSQLs+="AND OENT_TYPE='"+session.getAttribute("sgb")+"' \n";
	}*/
	if( !session.getAttribute("oareacode").equals("") ) {
		tmpStr=new String(selDeptName(session.getAttribute("oareacode")+"").getBytes("EUC-KR"),"ISO8859-1");

		if (session.getAttribute("oareacode").equals("C") || session.getAttribute("oareacode").equals("D") || session.getAttribute("oareacode").equals("E") ) {
			sSQLs+="AND Dept_Name LIKE '%"+tmpStr+"%' \n";
		} else {
			sSQLs+="AND Center_Name LIKE '%"+tmpStr+"%' \n";
		}
	}
	if( !session.getAttribute("odeptname").equals("") ) {
		sSQLs+="AND CVSNo='"+session.getAttribute("odeptname")+"' \n";
	}
	if( session.getAttribute("ssort").equals("1") ) {
		sSQLs+="ORDER BY REPLACE(OENT_NAME,'(','') \n";
	}
	if( session.getAttribute("ssort").equals("4") ) {
		sSQLs+="ORDER BY AA.MNG_NO \n";
	}
	if( session.getAttribute("ssort").equals("5") ) {
		sSQLs+="ORDER BY Center_Name,Dept_Name,User_Name \n";
	}
//---------------------------------------------------------------------------------------
	sSQLsCnt+=sSQLs;
	sSQLsCnt+="	) TT \n";

	sSQLsPage+=sSQLs;
	sSQLsPage+="	) TT \n";
	sSQLsPage+=") WHERE PAGE="+session.getAttribute("page")+" \n";

	try {
		resource = new ConnectionResource();
		conn	= resource.getConnection();
		pstmt	= conn.prepareStatement(sSQLsCnt);
		rs		= pstmt.executeQuery();

		while( rs.next()) {
			recordCount = rs.getInt("CNT");
		}

		rs.close();
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if(rs!=null)		try{rs.close();}	catch(Exception e){}
		if(pstmt!=null)		try{pstmt.close();}	catch(Exception e){}
		if(conn!=null)		try{conn.close();}	catch(Exception e){}
		if(resource!=null)	resource.release();
	}

	// calc MAX Pages
	if(recordCount > 0) {
		maxPages = (int)Math.round( (float)recordCount / Float.valueOf(session.getAttribute("pagecnt").toString() ).floatValue() );
	}

	
	try {
		resource = new ConnectionResource();
		conn	= resource.getConnection();
		pstmt	= conn.prepareStatement(sSQLsPage);
		rs		= pstmt.executeQuery();
		
		while ( rs.next() ) {
			arrMngNo.add(new String( StringUtil.checkNull(rs.getString("MNG_NO")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			arrCYear.add(StringUtil.checkNull(rs.getString("Current_Year")).trim());
			arrOentGB.add(StringUtil.checkNull(rs.getString("OENT_GB")).trim());
			arrOentName.add(new String( StringUtil.checkNull(rs.getString("OENT_NAME")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			arrOentCaptine.add(new String( StringUtil.checkNull(rs.getString("OENT_CAPTINE")).trim().getBytes("ISO8859-1"), "EUC-KR" ));

			arrCVSNo.add(StringUtil.checkNull(rs.getString("CVSNO")).trim());
			arrCenterName.add(new String( StringUtil.checkNull(rs.getString("Center_NAME")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			arrDeptName.add(new String( StringUtil.checkNull(rs.getString("Dept_NAME")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			arrUserName.add(new String( StringUtil.checkNull(rs.getString("User_NAME")).trim().getBytes("ISO8859-1"), "EUC-KR" ));

			arrPostNo.add(StringUtil.checkNull(rs.getString("POST_NO_03")).trim());
			arrCorrectType.add(StringUtil.checkNull(rs.getString("Correct_Typ")).trim());
		}

		rs.close();
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if(rs!=null)		try{rs.close();}	catch(Exception e){}
		if(pstmt!=null)		try{pstmt.close();}	catch(Exception e){}
		if(conn!=null)		try{conn.close();}	catch(Exception e){}
		if(resource!=null)	resource.release();
	}
/*=====================================================================================================*/
currentPage = Integer.parseInt(session.getAttribute("page").toString());
%>
<%!
	public String selDeptName(String str){
		String sReturnStr = "";
		
		if(str.equals("S") ) {
			sReturnStr = "����";
		} else if(str.equals("K")) {
			sReturnStr = "�뱸";
		} else if(str.equals("J")) {
			sReturnStr = "����";
		} else if(str.equals("G")) {
			sReturnStr = "����";
		} else if(str.equals("B")) {
			sReturnStr = "�λ�";
		} else if(str.equals("C")) {
			sReturnStr = "����ŷ���å��";
		} else if(str.equals("D")) {
			sReturnStr = "�����ϵ��ް�����";
		} else if(str.equals("E")) {
			sReturnStr = "�Ǽ��뿪�ϵ��ް�����";
		} else if(str.equals("H")) {
			sReturnStr = "������±�";
		} 
		
		return sReturnStr ;
	}

	public String selCorrectType(String str){
		String sReturnStr = "";
		
		if(str.equals("1") ) {
			sReturnStr = "���������Ϸ�";
		} else if(str.equals("2")) {
			sReturnStr = "�Ϻν���";
		} else if(str.equals("3")) {
			sReturnStr = "���ι̽���";
		} else if(str.equals("4")) {
			sReturnStr = "������";
		} else if(str.equals("51")) {
			sReturnStr = "�ε�";
		} else if(str.equals("52")) {
			sReturnStr = "���";
		} else if(str.equals("53")) {
			sReturnStr = "����Ҹ�";
		} else if(str.equals("54")) {
			sReturnStr = "ȸ������(��ũ�ƿ� ����)";
		} else if(str.equals("6")) {
			sReturnStr = "����+������";
		} else if(str.equals("9")) {
			sReturnStr = "�����ߺ�";
		} else if(str.equals("0")) {
			sReturnStr = "������";
		} else {
			sReturnStr = "<font style='color:#FF0000;'><b>���Է�</b></font>";
		}
		
		return sReturnStr ;
	}
%>

<script language="javascript">
content = "";

content+="<table id='divButton'>";
content+="	<tr>";
content+="		<td>�˻��� ȸ��� : <%=recordCount%> ��</strong> (page. <%=currentPage%> / <%=maxPages%> )</td>";
content+="	</tr>";
content+="</table>";

content+="<table class='resultTable'>";
content+="	<tr>";
content+="	<colgroup>";
content+="		<col width='5%' />";
content+="		<col width='5%' />";
content+="		<col width='10%' />";
content+="		<col width='20%' />";
content+="		<col width='15%' />";
content+="		<col width='17%' />";
content+="		<col width='7%' />";
content+="		<col width='20%' />";
content+="	</colgroup>";
content+="		<th>�⵵</th>";
content+="		<th>����</th>";
content+="		<th>������ȣ</th>";
content+="		<th>ȸ���</th>";
content+="		<th>���繫��</th>";
content+="		<th>����</th>";
content+="		<th>����</th>";
content+="		<th>��ġ����</th>";
content+="	</tr>";

<%if( arrMngNo.size() > 0 ) {
	for(int j=0; j<arrMngNo.size(); j++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<td><%=arrCYear.get(j)%></td>";
content+="		<td><%if( arrOentGB.get(j).equals("3") ) {%>�뿪<%} else if( arrOentGB.get(j).equals("2") ) {%>�Ǽ�<%} else if( arrOentGB.get(j).equals("1") ) {%>����<%}%></td>";
content+="		<td><a href=javascript:view('<%=arrMngNo.get(j)%>','<%=arrCYear.get(j)%>','<%=arrOentGB.get(j)%>');><%=arrMngNo.get(j)%></a></td>";
content+="		<td><%=arrOentName.get(j)%></td>";
content+="		<td><%=arrCenterName.get(j)%></td>";
content+="		<td><%=arrDeptName.get(j)%></td>";
content+="		<td><%=arrUserName.get(j)%></td>";
		<%	tmpStr = arrCorrectType.get(j).toString();
			tmpStr = selCorrectType(tmpStr); %>
content+="		<td><%=tmpStr%></td>";
content+="	</tr>";
	<%}%>
<%} else {%>
content+="	<tr>";
content+="		<td colspan='8' class='noneResultset'>�˻� ����� �����ϴ�</td>";
content+="	</tr>";
<%}%>
content+="</table>";
content+="<div id='pageMove'>";
content+="<p align='center'><%=UF_PageMove_java(currentPage, maxPages, "pmove('Paper_List.jsp?page=")%></p>";
content+="</div>";

top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>