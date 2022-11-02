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
/*  3. ���� : 2009�� 5��																			   */
/*  4. �����ۼ��� �� ���� : (��)��Ƽ������ ������ / 2011-10-18										   */
/*  5. ������Ʈ���� (���� / ����)																	   */
/*  6. ���																							   */
/*		1) �������� ������ / 2011-10-18																   */
/*-----------------------------------------------------------------------------------------------------*/
/*---------------------------------------- Variable Difinition ----------------------------------------*/
String sErrorMsg = "";	// �����޽���
String sReturnURL = "/index.jsp";	// �̵�URL

String tt = StringUtil.checkNull(request.getParameter("tt"));
String comm = StringUtil.checkNull(request.getParameter("comm"));

ConnectionResource resource = null;
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

ArrayList moneygbtext = new ArrayList();
ArrayList moneygb = new ArrayList();
ArrayList micd = new ArrayList();
ArrayList migb = new ArrayList();
ArrayList moneymoney = new ArrayList();
ArrayList nomoneygbtext = new ArrayList();
ArrayList nomoneygb = new ArrayList();
ArrayList nicd = new ArrayList();
ArrayList nigb = new ArrayList();
ArrayList nomoneymoney = new ArrayList();

String[] act = new String[12];

String sCYear = StringUtil.checkNull(request.getParameter("cyear"));
String sSQLs = "";
String omngno = "";
String ogb = "";
String oyyyy = "";
// �������
String mno = "";
String otype = "";
String oname = "";
String ocaptine = "";
String zipcode = "";
String address = "";
String w="";
String wjikwi = "";
String otel = "";
String ofax = "";
String sgb = "";
String smgb = "";
String postno01 = "";
String postno02 = "";
String postno03 = "";
String postno04 = "";
String postno05 = "";
String cvsno = "";
String centername = "";
String deptname = "";
String username = "";
String usertel = "";
String wdate="";
String submitdate="";

String tmpStr = "";
//String sTmpPMS = session.getAttribute("ckPermision") + "";
//String sTmpCName = session.getAttribute("ckCenterName") + "";
String sTmpPMS = ckPermision;
String sTmpCName = ckCenterName;
String sTmpDeptName = ckDeptName;		// 2014-03-05 : �ֺ�������� ��û (����üũ��) - ������

String old_cd = "";
String old_gb = "";
String otext = "";
String oicd = "";
String oigb = "";
String ostotal = "";
String omoney = "";
String omoneygb = "";

String ctype = "";
String camt = "0";
String dcamt = "0";
String pdate = "";
String samt = "0";
String scnt = "0";
String sconst = "";

String atype = "";
String tmpfname = "";

String bData = "F";

String sTmpStr1 = "";

int i = 0;
int moneygesu = 1;
int nomoneygesu = 1;

int nx = 0;
int ny = 0;
int nj = 0;
int nk = 0;

java.util.Calendar cal = java.util.Calendar.getInstance();

DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
DecimalFormat formater2 = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");

/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
if( !StringUtil.checkNull(request.getParameter("comm")).equals("") ) {
	omngno = StringUtil.checkNull(request.getParameter("mngno"));
	ogb = StringUtil.checkNull(request.getParameter("ogb"));
	session.setAttribute("sendtype","query");
} else {
	omngno = "" + session.getAttribute("omngno");
	ogb = "" + session.getAttribute("ogb");
}

String tmpYear = "";
String tmpYear1 = request.getParameter("cyear")==null ? "":request.getParameter("cyear").trim();
String tmpYear2 = request.getParameter("yyyy")==null ? "":request.getParameter("yyyy").trim();
if( !tmpYear1.equals("") ) tmpYear = tmpYear1;
else if( !tmpYear2.equals("") ) tmpYear = tmpYear2;
else tmpYear = st_Current_Year;
int currentYear = Integer.parseInt(tmpYear);

for(int ni=1; ni<12; ni++) {
	act[ni] = "0";
}

	/* 2012�� ������� ���� DB Table �и� ����ó�� ���� ============================================================> */
	/* ������Ʈ ���� : 2012�� 11�� 13��
	   �ۼ��� : ������
	   ��� : Database ��������� ���Ͽ� 2012����� ������� ���� ���̺� �и�
			  HADO_TB_Oent_Answer --> HADO_TB_Oent_Answer_2012 */
	String currentAnswer = "HADO_TB_Oent_Answer";
	if( currentYear>2011 ) {
		currentAnswer = "HADO_TB_Oent_Answer_"+currentYear;
	}
	/* <============================================================== 2012�� ������� ���� DB Table �и� ����ó�� �� */



	// �������
	if( currentYear >= 2012 ) {
		sSQLs= "SELECT * \n";
		sSQLs+="FROM HADO_VT_Oent_"+currentYear+" \n";
		sSQLs+="WHERE Mng_No=? \n";
		sSQLs+="	AND Current_Year=? \n";
		sSQLs+="	AND Oent_GB=? \n";
	} else if( currentYear >= 2010 ) {
		sSQLs= "SELECT * \n";
		sSQLs+="FROM HADO_VT_Oent_2010 \n";
		sSQLs+="WHERE Mng_No=? \n";
		sSQLs+="	AND Current_Year=? \n";
		sSQLs+="	AND Oent_GB=? \n";
	}

try {
	resource = new ConnectionResource();
	conn = resource.getConnection();

	//System.out.print(sSQLs+"\n\n");
	pstmt = conn.prepareStatement(sSQLs);
	pstmt.setString(1,omngno);
	pstmt.setString(2,currentYear+"");
	pstmt.setString(3,ogb);
	rs = pstmt.executeQuery();
	
	while( rs.next() ) {
		mno = StringUtil.checkNull(rs.getString("Mng_No"));
		otype = StringUtil.checkNull(rs.getString("Oent_Type"));
		oname = new String( StringUtil.checkNull(rs.getString("Oent_Name")).trim().getBytes("ISO8859-1"), "EUC-KR" );
		ocaptine = new String( StringUtil.checkNull(rs.getString("Oent_Captine")).trim().getBytes("ISO8859-1"), "EUC-KR" );
		zipcode = StringUtil.checkNull(rs.getString("Zip_Code"));
		address = new String( StringUtil.checkNull(rs.getString("Oent_Address")).trim().getBytes("ISO8859-1"), "EUC-KR" );
		w = new String( StringUtil.checkNull(rs.getString("Writer_Name")).trim().getBytes("ISO8859-1"), "EUC-KR" );
		wjikwi = new String( StringUtil.checkNull(rs.getString("Writer_Jikwi")).trim().getBytes("ISO8859-1"), "EUC-KR" );
		otel = StringUtil.checkNull(rs.getString("Writer_Tel"));
		ofax = StringUtil.checkNull(rs.getString("Writer_Fax"));
		wdate = StringUtil.checkNull(rs.getString("Write_Date"));
		sgb = StringUtil.checkNull(rs.getString("Survey_GB"));
		smgb = StringUtil.checkNull(rs.getString("Survey_Money_GB"));
		postno01 = StringUtil.checkNull(rs.getString("Post_No_01"));
		postno02 = StringUtil.checkNull(rs.getString("Post_No_02"));
		postno03 = StringUtil.checkNull(rs.getString("Post_No_03"));
		postno04 = StringUtil.checkNull(rs.getString("Post_No_04"));
		postno05 = StringUtil.checkNull(rs.getString("Post_No_05"));
		cvsno = StringUtil.checkNull(rs.getString("CVSNo"));
		centername = new String( StringUtil.checkNull(rs.getString("Center_Name")).trim().getBytes("ISO8859-1"), "EUC-KR" );
		deptname = new String( StringUtil.checkNull(rs.getString("Dept_Name")).trim().getBytes("ISO8859-1"), "EUC-KR" );
		username = new String( StringUtil.checkNull(rs.getString("User_Name")).trim().getBytes("ISO8859-1"), "EUC-KR" );
		usertel = StringUtil.checkNull(rs.getString("Phone_No"));
		submitdate = StringUtil.checkNull(rs.getString("Submit_Date"));
	}
	rs.close();

	sSQLs="SELECT * FROM HADO_TB_Survey_CTX3 \n";
	sSQLs+="WHERE RTRIM(Mng_No)='"+omngno+"' AND Current_Year='"+currentYear+"' AND Oent_GB='"+ogb+"' \n";
	sSQLs+="ORDER BY Reg_Sn \n";
	
	//out.print(sSQLs+"\n\n");
	pstmt = conn.prepareStatement(sSQLs);
	rs = pstmt.executeQuery();

	while( rs.next() ) {
		ctype = StringUtil.checkNull(rs.getString("Correct_Typ")).trim();
		camt = StringUtil.checkNull(rs.getString("Correct_AMT")).trim();
		dcamt = StringUtil.checkNull(rs.getString("DivCorr_AMT")).trim();
		pdate = StringUtil.checkNull(rs.getString("Pay_Date")).trim();
		samt = StringUtil.checkNull(rs.getString("Subcon_AMT")).trim();
		scnt = StringUtil.checkNull(rs.getString("Subcon_Cnt")).trim();
		sconst = new String( StringUtil.checkNull(rs.getString("Survey_Const")).trim().getBytes("ISO8859-1"), "EUC-KR" );
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
%>

<%!
public String UF_getNowDate()
{
	String strNDate = "";
	// �ų� 1�� 1�� -------------------------------------------------------------------------------
	try {
		
		Calendar cal = Calendar.getInstance();

		String year = Integer.toString(cal.get(Calendar.YEAR));
		
		strNDate = year;
		strNDate += "12";
		strNDate += "31";
	}
	catch ( Exception e )
	{
		strNDate = "";
	}

	return strNDate;
	//------------------------------------------------------------------------------------------------
}
%>

<%!
	public String selCorrectGB(String str) {
		String sReturnStr="";
		if( str.equals("20") ) {
			sReturnStr = "���ݰ�����������";
		} else if( str.equals("21") ) {
			sReturnStr = "��ݰ�����������";
		} else if( str.equals("1") ) {
			sReturnStr = "����ǥ ������";
		} else if( str.equals("3") ) {
			sReturnStr = "�ϵ��޺��� ��";
		} else if( str.equals("5") ) {
			sReturnStr = "����ǥ ������(2)";
		} else if( str.equals("6") ) {
			sReturnStr = "������";
		} else if( str.equals("7") ) {
			sReturnStr = "�̽���";
		} else {
			sReturnStr = "��������";
		}

		return sReturnStr ;
	}
%>

<script language="javascript">
content = "";

content+="<div id='viewWinTop'>";
content+="	<ul class='lt'>";
content+="		<li class='fr'><a href=javascript:closeViewWin('divView') class='sbutton'>â�ݱ�</a></li>";
content+="	</ul>";
content+="</div>";


content+="<div id='viewWinTitle' style='margin-left:-20px;'><li class='lt'><ul class='fl'>������ġ ����ȸ �� �Է�</ul><ul class='fr' id='ulBasicInfoView'><a href=javascript:hidContent('divBasicInfo','ulBasicInfoView','�⺻����'); class='sbutton'>�⺻���� ������</a></ul></li></div>";

content+="<div id='divBasicInfo'>";
content+="<table class='ViewResultTable2' align='center'>";
content+="	<tr>";
content+="		<th>���繫��</th>";
content+="		<td>&nbsp;<%=centername%></td>";
content+="		<th>������</th>";
content+="		<td>&nbsp;<%=deptname%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>������</th>";
content+="		<td>&nbsp;<%=username%></td>";
content+="		<th>��翬��ó</th>";
content+="		<td>&nbsp;<%=usertel%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>�������ȣ</th>";
content+="		<td colspan='3'>&nbsp;��<%=postno01%> / ��<%=postno02%><br/>&nbsp;��<%=postno03%> / ��<%=postno04%> / ��<%=postno05%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>��������</th>";
<%
sTmpStr1 = sgb+"";
if( sTmpStr1.equals("2") ) {
	sTmpStr1 = smgb+"";
	if( sTmpStr1.equals("1") ) {
		sTmpStr1 = "21";
	} else {
		sTmpStr1 = "20";
	}
} else {
	sTmpStr1 = sgb+"";
}
sTmpStr1 = "<font style='color:#FF9933;'>"+selCorrectGB(sTmpStr1)+"</font>";
%>
content+="		<td colspan='3'><%=sTmpStr1%></td>";
content+="	</tr>";
content+="</table>";
content+="</div>";

content+="<div id='viewWinTitle2' style='margin-left:-20px;'><li class='lt'><ul class='fl'>��� ������� �Ϲ���Ȳ</ul><ul class='fr' id='ulOentInfoView'><a href=javascript:hidContent('divOentView','ulOentInfoView','�Ϲ���Ȳ'); class='sbutton'>�Ϲ���Ȳ ������</a></ul></li></div>";

content+="<div id='divOentView'>";
content+="<table class='ViewResultTable2' align='center'>";
content+="	<tr>";
content+="		<th>����⵵</th>";
content+="		<td>&nbsp;<%=currentYear%>�� [<%=omngno%>]</td>";
content+="		<th>����</th>";
content+="		<td>&nbsp;<%=StringUtil.gbf(ogb)%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>�����ڵ�</th>";
content+="		<td>&nbsp;<%=otype%></td>";
content+="		<th>ȸ���</th>";
content+="		<td>&nbsp;<%=oname%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>��ǥ�ڸ�</th>";
content+="		<td>&nbsp;<%=ocaptine%></td>";
content+="		<th>������</th>";
content+="		<td>&nbsp;(<%=zipcode%>) <%=address%></td>";
content+="	</tr>";
content+="		<th>�ۼ���</th>";
content+="		<td>&nbsp;<%=w%></td>";
content+="		<th>�ۼ�������</th>";
content+="		<td>&nbsp;<%=wjikwi%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>�ۼ�����ȭ</th>";
content+="		<td>&nbsp;<%=otel%></td>";
content+="		<th>�ۼ����ѽ�</th>";
content+="		<td>&nbsp;<%=ofax%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>�ۼ�����</th>";
content+="		<td>&nbsp;<%=wdate%></td>";
content+="		<th>��������</th>";
content+="		<td>&nbsp;<%=submitdate%></td>";
content+="	</tr>";
content+="</table>";
content+="</div>";


content+="<div id='viewWinTitle2' style='margin-left:-20px;'><li class='lt'><ul class='fl'>����̹߱� ��������</ul><ul class='fr' id='ulCorrectView'><a href=javascript:hidContent('divCorrectView','ulCorrectView','��������'); class='sbutton'>�������� ������</a></ul></li></div>";

content+="<div id='divCorrectView'>";
content+="<table class='ViewResultTable2' align='center'>";
content+="<form action='' method='post' name='sform1'>";
content+="			<input type='hidden' name='sur_omngno' value='<%=omngno%>'>";
content+="			<input type='hidden' name='sur_oyyyy' value='<%=currentYear%>'>";
content+="			<input type='hidden' name='sur_ogb' value='<%=ogb%>'>";
content+="			<input type='hidden' name='h_sctx' id='h_sctx' value=''>";
content+="			<input type='hidden' name='h_ctxsu2' id='h_ctxsu2' value=''>";
content+="</form>";
content+="<form action='' method='post' name='sform2'>";
content+="	<tr>";
content+="		<th>��������</th>";
content+="		<td>";
content+="			<input type='radio' name='sctx' id='sctx' value='1' <%if( ctype.equals("1") ) {%>checked<%}%>>�������� �Ϸ�";
<%if( sgb.equals("2") ) {%>
content+="			<input type='radio' name='sctx' id='sctx' value='6' <%if( ctype.equals("6") ) {%>checked<%}%>>����+������";
<%}%>
content+="			<input type='radio' name='sctx' id='sctx' value='2' <%if( ctype.equals("2") ) {%>checked<%}%>>�Ϻν���";
content+="			<input type='radio' name='sctx' id='sctx' value='3' <%if( ctype.equals("3") ) {%>checked<%}%>>���� �̽���";
content+="			<input type='radio' name='sctx' id='sctx' value='4' <%if( ctype.equals("4") ) {%>checked<%}%>>������";
content+="			<input type='radio' name='sctx' id='sctx' value='51' <%if( ctype.equals("51") ) {%>checked<%}%>>�ε�";
content+="			<input type='radio' name='sctx' id='sctx' value='52' <%if( ctype.equals("52") ) {%>checked<%}%>>���";
content+="			<input type='radio' name='sctx' id='sctx' value='53' <%if( ctype.equals("53") ) {%>checked<%}%>>����Ҹ�";
content+="			<input type='radio' name='sctx' id='sctx' value='54' <%if( ctype.equals("54") ) {%>checked<%}%>>ȸ������ ������ (��ũ�ƿ� ����)";
content+="			<br/><input type='radio' name='sctx' id='sctx' value='9' <%if( ctype.equals("9") ) {%>checked<%}%>>�ش�⵵ ���� �ߺ���ü";
content+="			<br/><input type='radio' name='sctx' id='sctx' value='0' <%if( ctype.equals("0") ) {%>checked<%}%>><I>������� �� ����</I> (<font style='color:#FF6600;'><U>�Ѱ����� �̻� ��ϰ���</U></font>)";
content+="		</td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>����<br/>���޻���� ��</th>";
content+="		<td colspan='2'><input type='text' name='ctxsu2' id='ctxsu2' onkeyup='top.sukeyup(this)' class='s_input' style='width:100px;text-align:right;'  value='<%=scnt%>'>��</td>";
content+="	</tr>";
content+="</form>";
content+="</table>";
content+="</div>";

content+="<div id='divViewWinbutton'>";
content+="	<ul class='lt'>";
<%
/* 2014-03-05 : �ֺ�������� ��û���� ���ٱ��� ������ ���� - ������ */
/* 2014-10-30 : ������ġ ��� ���� ó�� - ������ */
/* 2014-11-13 : �ֺ��� ����� ������ġ ���� ���� ������ ���� �ӽ� ���� */
/* 2014-11-26 : �ֺ��� ����� ������ġ ���� ���� ���� */
/* 2014-12-11 : �ֺ��� ����� ������ġ ���� ���� ������ ���� �ӽ� ���� */
/* 2014-12-12 : �ֺ��� ����� ������ġ ���� ���� ���� */
/* 2015-03-02 : �ֺ��� ����� ������ġ ���� ���� ������ ���� �ӽ� ���� */
/* 2015-03-18 : �ֺ��� ����� ������ġ ���� ���� ���� */
%>
<%//if( currentYear>=2012 && (centername.substring(0,2).equals(sTmpCName.substring(0,2)) || sTmpPMS.equals("T") || sTmpPMS.equals("M")) ) {%>
<%//if( currentYear>=2012 && centername.substring(0,2).equals(sTmpCName.substring(0,2)) && deptname.equals(sTmpDeptName) || sTmpPMS.equals("T") || sTmpPMS.equals("M") ) {%>
<%if( sTmpPMS.equals("T") ) {%>
<%//if(  sTmpPMS.equals("T") || ckSSOcvno.equals("1004") ) {%>
content+="		<li class='fl'><a href=javascript:top.conf() class='sbutton'>������ġ ���</a></li>";
content+="		<li class='fl'><a href=javascript:top.goDelete() class='sbutton'>�Է³��� ����</a></li>";

<%}%>
content+="		<li class='fr'><a href=javascript:top.closeViewWin('divView') class='sbutton'>â�ݱ�</a></li>";
content+="	</ul>";
content+="</div>";

top.document.getElementById("divView").innerHTML = content;
top.document.getElementById("divView").className = "dragLayer";
top.setNowProcessFalse();

</script>