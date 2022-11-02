<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_VP_Subcon.jsp
* ���α׷�����	: ���޻���ڸ�� ���
* ���α׷�����	: 3.0.1
* �����ۼ�����	: 2014�� 09�� 14��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-09-14	������       �����ۼ�
*	2015-05-18	������       ���ΰ��������� ���� ���ε� ����
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<%@ include file="../Include/WB_Inc_chkSession.jsp"%>
<%
ConnectionResource resource	= null;
Connection conn				= null;
PreparedStatement pstmt		= null;
ResultSet rs				= null;

String sErrorMsg	= "";					// �����޽���
String sReturnURL	= "";	// �̵�URL
String sfile		= "";
String ssize		= "";
String sSQLs		= "";

// Cookie Request
String sMngNo		= ckMngNo;
String sOentYYYY	= ckCurrentYear;
String sCurrentYear = ckCurrentYear;
String sOentGB		= ckOentGB;

/* �׸�ǥ���� ���⵵ �׸� ǥ�� ����� ���� ����⵵ ������ ��ȯ */
int nCurrentYear = 0;
if( !ckCurrentYear.equals("") ) {
	nCurrentYear = Integer.parseInt(ckCurrentYear);
}

if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
	// �ش����� ���� ��������
	sSQLs="SELECT * FROM HADO_TB_Oent_SubCon_File \n";
	sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+ckCurrentYear+"' \n";
	sSQLs+="AND Oent_GB='"+ckOentGB+"' \n";

	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();
		pstmt		= conn.prepareStatement(sSQLs);
		rs			= pstmt.executeQuery();

		while (rs.next()) {
			sfile	= rs.getString("oent_file")==null ? "":rs.getString("oent_file").trim();
			ssize	= rs.getString("oent_file_size")==null ? "":rs.getString("oent_file_size").trim();
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--[if lt IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie6"><![endif]-->
<!--[if IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie7"><![endif]-->
<!--[if IE 8]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie8"><![endif]-->
<!--[if (gt IE 8)|!(IE)]><!-->
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko-KR" class="no-js">
<!--<![endif]-->
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta http-equiv='Cache-Control' content='no-cache'>
    <meta http-equiv='Pragma' content='no-cache'>

    <title>2020�⵵ �ϵ��ްŷ� ������� ����</title>
    
    <link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="euc-kr">
    <link href="style.css" rel="stylesheet" type="text/css" />

    <!-- // IE  // -->
	<!--[if IE]><script src="../js/html5.js"></script><![endif]-->
	<!--[if IE 7]>
	<script src="../js/ie7/IE7.js"  type="text/javascript"></script>
	<script src="../js/ie7/ie7-squish.js"  type="text/javascript"></script>
	<![endif]-->
    <script src="../js/jquery-1.7.min.js"></script>
    <script type="text/javascript">jQuery.noConflict();</script>
    <script src="../js/mootools-core-1.3.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/mootools-more-1.3.1.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/simplemodal.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/commonScript.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/login.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/credian_common_script.js" type="text/javascript"  charset="euc-kr"></script>
	<script type="text/JavaScript">
	//<![CDATA[
		function sfileup(){
			window.open("WB_File_Up.jsp","_blank","toolbar=no,width=450,height=420,directories=no,status=no,scrollbars=Yes,resize=no,menubar=no");
		}

		function HelpWindow2(url, w, h){
			helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
			helpwindow.focus();
		}

		function goPrint(){
			/*url = "ProdStep_04_Print.jsp";
			w = 820;
			h = 600;
			if(confirm("ȭ�� �μ�� ����ǥ ���� �Ŀ� �����մϴ�.\n\n�μ��Ͻðڽ��ϱ�?\n[Ȯ��]�� �����ø� �μ�˴ϴ�."))
				HelpWindow2(url, w, h);*/
			print();
		}
	//]]
	</script>
</head>
<body>
	<div id="container">
	<div id="wrapper">

		<!-- Begin Header -->
		<div id="subheader">
			<ul class="lt">
				<li class="fl"><a href="#none" onfocus="this.blur()"><img src="img/logo.jpg" width="242" height="55"></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"><font color="#FF6600">[
							<% if( ckOentGB.equals("1") ) {%>������
							<% } else if( ckOentGB.equals("2") ) {%>�Ǽ���
							<% } else if( ckOentGB.equals("3") ) {%>�뿪��<% } %>]</font>
							<%=ckOentName%>&nbsp;/&nbsp;<iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" align="center" frameborder="0"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="./WB_VP_Introduction.jsp" onfocus="this.blur()" class="mainmenu">1. ���� �ȳ�</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. ȸ�簳��</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. �ϵ��� �ŷ���Ȳ</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon.jsp" onfocus="this.blur()" class="mainmenuup">4. ���޻���� ���</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="mainmenu">5. ����ǥ ����</a></li>
			</ul>
		</div>
		<!-- End Header -->

		<!-- Begin subcontent -->
		<div id="subcontent">
			<!-- title start -->
			<h1 class="contenttitle">4. ���޻���� ���</h1>
			<!-- title end -->
			

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">���޻���� ��� �Է� �ȳ�</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><span>�� </span>�ͻ��� ���� �� ��������� <font color="#FF0000"><%= nCurrentYear-1%>.1.1 ~ <%= nCurrentYear-1%>.12.31</font> �Ⱓ���� ������ �ŷ��� ���޻���ڸ� �������� �Է��Ͽ� �ֽñ� �ٶ��ϴ�. (��, ���⼭ ���޻���ڶ� �ϵ��޹��� ���޻���ڸ� ����)</li>
						<li><span>�� </span>�Ʒ� [���޻���ڸ�� ��� �ٿ�ޱ�]���� ������ <font color="#FF0000">�ٿ�޾� ���ݵ�� ���塱�� �� �ۼ�</font>�Ͻñ� �ٶ��, <br/>�ۼ� �Ϸ� �� [���޻���ڸ�� ���ε��ϱ�]�� ���� �ش� ������ ������ �ֽñ� �ٶ��ϴ�.</li>
						<li><span>�� </span>������ �ݵ�� �Ʒ����� �ٿ���� ����� ����ؾ� �ϸ�, �ͻ翡�� ���Ƿ� ���� ���Ͼ���� ������� �� ��<br/> <font color="#FF0000">(��ü ���� ���ε�� �����߻�)</font></li>
						<li><span>�� </span>���ε� �Ͻ� ��, ���ϸ��� "�ͻ��� ȸ���.xls"�� ���ֽʽÿ�.(��: ������ �ֽ�ȸ��.xls,  ������.xls)</b></li>
						<!--
						<li><span>�� </span><b><font color="#FF0000">���޻���ڸ�� �������� ������ ���� 2014�� �������� �Ǿ��־� ���� �������̿��� ������ �ٿ�ε� ������ ��������� 2015�� �������� �����Ͽ� ������ �ۼ����ֽñ� �ٶ��ϴ�.</font></b></li>
						<li><span>�� </span><b><font color="#FF0000">���� �ð����� ������Ʈ �Ϸ� �ϰڽ��ϴ�.</font></b></li>
						-->
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">���޻���� ��� �Է�</li>
						<li class="boxcontentsubtitle">* ���� ������ ���� �ۼ� �ϼ���.</li>
						<li class="boxcontentsubtitle"">* �ø��� ������ �����ϰ��� �ϽǶ����� ���� �ۼ���<br/>
						&nbsp;&nbsp;&nbsp;������ �ٽ� "���ε�"�Ͻø� �ڵ� ����˴ϴ�.</li>
						<li class="boxcontentsubtitle">* Ȯ���ڸ��� XLS, XLSX, xls, xlsx<br/>
						&nbsp;&nbsp;&nbsp;�װ����� ���ε� �Ͻ� �� �ֽ��ϴ�.</li>

					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><font style="font-family:nanum,dotum; font-size:14px; font-weight:bold;">Step 1.</font> ���޻���� ��� Excel ��� �ٿ�ε�</li>
						<li><p style="padding-left:60px; width:200px;"><a href="/rsch210726/subcon2021.xls" target="ProceFrame" onfocus="this.blur()" class="contentbutton2">���޻���� ��� �ٿ�ε� �ޱ�</a></p></li>
						<li class="fc pt_10"></li>
						<%// ���縶������ ���ε� ��ư ���� / 20180716 / �躸��%>
						<li><font style="font-family:nanum,dotum; font-size:14px; font-weight:bold;">Step 2.</font> �ۼ��� ���޻���� ��� ���ε�</li>
						<li><p style="padding-left:60px; width:200px;"><a href="javascript:sfileup('2')" onfocus="this.blur()" class="contentbutton2">���޻���� ��� ���ε� �ϱ�</a></p></li>						 
						<li class="fc pt_10"></li>
						<li><font style="font-family:nanum,dotum; font-size:14px; font-weight:bold;">Step 3.</font> ���(���ε�)�� ���޻���� ��� Ȯ��</li>
						<li><p style="padding-left:60px;"><a href="WB_File_Down.jsp"><%=sfile%></a></p></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_20"></div>

			<!-- ��ư start -->
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">ȭ�� �μ��ϱ�</a></li>
					<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="contentbutton2">5. ����ǥ �������� ����</a></li>
				</ul>
			</div>
			<!-- ��ư end -->

		</div>
		<!-- End subcontent  -->

		<!-- Begin Footer -->
		<div id="subfooter"><img src="img/bottom.gif"></div>
		<!-- End Footer -->

	</div>
	</div>

	<%/*-----------------------------------------------------------------------------------------------
	2010�� 4�� 26�� / iframe �߰� / ������
	:: �ϵ��ްŷ���Ȳ (��������) ���� �� ���� �� �����߻����� �������� �ҽǵǴ� ��츦 �����ϱ� ���� 
	:: ���û����� iframe Ÿ������ submit ��Ŵ
	*/%>
	<iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
	<%/*-----------------------------------------------------------------------------------------------*/%>
</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>