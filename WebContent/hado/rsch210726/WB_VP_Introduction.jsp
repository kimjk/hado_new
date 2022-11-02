<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_VP_Intoroduction.jsp
* ���α׷�����	: ���簳�� �ȳ�
* ���α׷�����	: 1.0.1
* �����ۼ�����	: 2016�� 04�� 11��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-09-14	������       �����ۼ�
*	2015-12-31	������		DB�������� ���� ���ڵ� ����
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<%@ include file="../Include/WB_Inc_chkSession.jsp"%>

<%
ConnectionResource resource	= null;
Connection conn	 = null;
PreparedStatement pstmt	= null;
ResultSet rs	 = null;	

String sSQLs = "";
String sDeptString = "";
String sTmpCenterName	= ""; // �繫�Ҹ�
String sTmpDeptName = ""; // �μ���
String sTmpUserName	= ""; // ����ڸ�
String sTmpPhoneNo = ""; // ��ȭ��ȣ

// �����ڸ� ���� ���� ����
String sType = request.getParameter("type") == null ? "":request.getParameter("type").trim();
String sMng = request.getParameter("mng") == null ? "":request.getParameter("mng").trim();
if(sMng !=null && sMng.equals("y")) {
	ckOentGB = sType;
	ckOentName = "�������� ����";
	if (sType.equals("1")) {
		session.setAttribute("ckMngNo", "HE0101");
		session.setAttribute("ckCurrentYear", "2021");
		session.setAttribute("ckOentGB", "1");
		session.setAttribute("ckOentName", "�������� ����");
		session.setAttribute("ckSentNo", "");
		session.setAttribute("ckSentName", "");
		session.setAttribute("ckEntGB", "1");
		session.setAttribute("ckLoginGB", "N");
	}
	else if (sType.equals("2")) {
		session.setAttribute("ckMngNo", "HE0102");
		session.setAttribute("ckCurrentYear", "2021");
		session.setAttribute("ckOentGB", "2");
		session.setAttribute("ckOentName", "�������� ����");
		session.setAttribute("ckSentNo", "");
		session.setAttribute("ckSentName", "");
		session.setAttribute("ckEntGB", "1");
		session.setAttribute("ckLoginGB", "N");
	}
	else if (sType.equals("3")) {
		session.setAttribute("ckMngNo", "HE0103");
		session.setAttribute("ckCurrentYear", "2021");
		session.setAttribute("ckOentGB", "3");
		session.setAttribute("ckOentName", "�������� ����");
		session.setAttribute("ckSentNo", "");
		session.setAttribute("ckSentName", "");
		session.setAttribute("ckEntGB", "1");
		session.setAttribute("ckLoginGB", "N");
	}
}

if( !ckMngNo.equals("") && !ckCurrentYear.equals("") && !ckOentGB.equals("") ) {
	/* �ӽ� ���庯�� ����*/
	String sTmp_CenterName = "";
	String sTmp_DeptName = "";
	String sTmp_UserName = "";
	String sTmp_PhoneNo = "";

	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();
		// 
		sSQLs   ="SELECT Center_Name, Dept_Name, User_Name, Phone_No \n";
		sSQLs+="FROM HADO_TB_DEPT_HISTORY_2021 \n";
		sSQLs+="WHERE mng_No = ? AND current_Year = ? AND oent_gb = ? \n";

		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, ckMngNo);
		pstmt.setString(2, ckCurrentYear);
		pstmt.setString(3, ckOentGB);
		rs = pstmt.executeQuery();

		if (rs.next()) { //���ڵ尡 ������ ���
			sTmp_CenterName = rs.getString("Center_Name") == null ? "":rs.getString("Center_Name").trim(); // �繫�Ҹ�
			sTmp_DeptName = rs.getString("Dept_Name") == null ? "":rs.getString("Dept_Name").trim(); // �μ���
			sTmp_UserName = rs.getString("User_Name") == null ? "":rs.getString("User_Name").trim(); //  ����ڸ�
			sTmp_PhoneNo = rs.getString("Phone_No") == null ? "":rs.getString("Phone_No").trim(); // ��ȭ��ȣ
		}
		rs.close();
		
		/* ����� ���� ���� */
		if ( (sTmp_CenterName != null) && (!sTmp_CenterName.equals("")) ) {
			sDeptString = sTmp_CenterName + " " + sTmp_DeptName + " / " +sTmp_UserName + " / " + sTmp_PhoneNo;
		} else {
			sDeptString	= "���� ����ŷ���å�� ����ŷ���å�� / ������ ����� / 044-200-4656";
		}
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn != null)	try{conn.close();}	catch(Exception e){}
		if (resource != null) resource.release();
	}

	if ( sDeptString.equals("") ) {
		sDeptString	= "���� ����ŷ���å�� ����ŷ���å�� / ������ ����� / 044-200-4656";
	}
}
/*=====================================================================================================*/
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

    <title>2021�⵵ �ϵ��ްŷ� ������� ����</title>
    
    <link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="euc-kr">
    <link href="style.css" rel="stylesheet" type="text/css" />

    <!-- // IE  // -->
	<!--[if IE]><script src="../js/html5.js"></script><![endif]-->
	<!--[if IE 7]>
	<script src="../js/ie7/IE7.js"  type="text/javascript"></script>
	<script src="../js/ie7/ie7-squish.js"  type="text/javascript"></script>
	<![endif]-->
    <script src="../js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript">jQuery.noConflict();</script>
    <script src="../js/mootools-core-1.3.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/mootools-more-1.3.1.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/simplemodal.js" type="text/javascript" charset="euc-kr"></script>
	<script src="../js/commonScript.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/login_2019.js" type="text/javascript" charset="euc-kr"></script>

<script language="javascript">
	function viewHadoInfo() {
		var SM = new SimpleModal({"hideFooter":true, "width":720});
		SM.show({
		  "title":"����ǥ �ۼ��� Ȯ��",
		  "model":"modal",
		  "contents":'<iframe src="./subPage03.jsp" width="690" height="560" frameborder="0" webkitAllowFullScreen allowFullScreen style="margin-bottom:20px"></iframe>'
		});
	}

	function goPrint() {
	/*url = "ProdStep_02_Print.jsp";
	w = 820;
	h = 600;
	HelpWindow2(url, w, h);*/
	print();
	}

	function HelpWindow2(url, w, h) {
		helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
		helpwindow.focus();
	}
</script>

<body>
	<div id="container">
	<div id="wrapper">

		<!-- Begin Header -->
		<div id="subheader">
			<ul class="lt">
				<li class="fl"><a href="#none" onfocus="this.blur()"><img src="img/logo.jpg" width="242" height="55"></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"><span class="orengetext">[
							<% if( ckOentGB.equals("1") ) {%>������
							<% } else if( ckOentGB.equals("2") ) {%>�Ǽ���
							<% } else if( ckOentGB.equals("3") ) {%>�뿪��<% } %>]</span>
							<%=ckOentName%>&nbsp;/&nbsp;<iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" align="center" frameborder="0"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="./WB_VP_Introduction.jsp" onfocus="this.blur()" class="mainmenuup">1. ���� �ȳ�</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. ȸ�簳��</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. �ϵ��� �ŷ���Ȳ</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon.jsp" onfocus="this.blur()" class="mainmenu">4. ���޻���� ���</a></li>
				<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="mainmenu">5. ����ǥ ����</a></li>
			</ul>
		</div>
		<!-- End Header -->

		<!-- Begin subcontent -->
		<div id="subcontent">

			<!-- title start -->
			<h1 class="contenttitle">1. ���� �ȳ�</h1>
			<!-- title end -->
				
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">�λ縻</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li>�����ŷ�����ȸ�� ������ �ϵ��ްŷ����� Ȯ���� ���Ͽ� �ϵ��ްŷ��� ���� ����������縦 �ǽ��ϰ�,
						�� �������� ��ǥ�ϰ� �ֽ��ϴ�. �� ����� <b><u>�ϵ��ްŷ� ����ȭ�� ���� ���� ��22����2</u></b>�� ���� ������, �ϵ��ްŷ��� ��Ȳ �ľ� �� �ϵ��ްŷ�
						����ȭ ��å ������ ���� �����ڷ�� Ȱ��˴ϴ�.<br/>���ϰ� �����Ͻ� ������ <u>���� ��33��</u>�� ���� ö���� ��ȣ�Ǹ�, ����ۼ� �� ������
						�ϵ��ްŷ����� Ȯ���� ���ؼ��� ���˴ϴ�. �ٻڽô��� ������ �߿� ��å������ ���� ���̿��� ������ �亯���ֽñ� �ٶ��ϴ�. ����� �� �������翡 �������� �ƴ��ϰų�
						������ �ۼ��ϴ� ���, �ϵ��޹� ��30����2 ������ �ǰ� ���·� ó���� �ް� �Ǹ� �ͻ��� �ϵ��ްŷ� ���ݿ� ���Ͽ� ���� Ȯ�����縦 �ǽ��� �� ������ �˷��帳�ϴ�.
						�����մϴ�.</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">���ǻ���</li>
						<li><br/></li>
						<li class="boxcontentsubtitle">
						  <a href="http://pf.kakao.com/_xjYjxfs/chat">
						    <img src="./img/qr_cord.png" alt="īī���� ����ϱ�"/>
						  </a>
						</li>
						<li><span>īī���� ����� ����</span></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><span>�� </span>����ǥ �Է� �� ���� ��� </li>
						<li><span>1.</span> �Ʒ� �ۼ� ������ ���� ����ǥ �ۼ�</li>
						<li>ȸ�� ����  �� �ϵ��� �ŷ���Ȳ  �� ���޻���� ����Է� �� �ۼ�</li>
						<li><span>2.</span> ����ǥ �Է��� �Ϸ�Ǹ�, �ݵ�� "����ǥ ����" �޴��� ���Ͽ� "����ǥ ���� ����"�� Ŭ�� </li>
						<li><strong>&lt;������ �Ϸ�Ǿ����ϴ�.&gt;</strong>�� ������ ����ǥ �ۼ� �� ������ �Ϸ�� ���Դϴ�.</li>
						<li><br/></li>
						<li><span>��</span> ����ǥ�� <strong>�����ۼ�(�Է�)</strong> �Ǵ�  <strong>�������</strong> ���ϵ��ްŷ� ����ȭ�� ���� ������(���� ���ϵ��޹����̶� ��)�� ����  <strong>ó��(���·� �ΰ�)</strong>�� ���� �� ������, �ͻ��� �ϵ��ްŷ� ���ݿ� ���Ͽ� ���� Ȯ�����簡 �̷���� �� ������ �˷��帳�ϴ�.
						</li>
						<li><br/></li>
						<li><span>��</span> ���� ����� ���� �ʴ� ���, <strong>��ȸ�� ���䡹�κб��� �Է�</strong>�ϰ�, �������� ������� ������ �� �ִ� <strong>�����ڷ�(PDF����)�� ����Ʈ�� ���ε�</strong>�Ͻ� ��, <strong>��3. �ϵ��ްŷ���Ȳ���� 5������(�ϵ��ްŷ�����)�� "��. �ϵ��ްŷ��� ���� ����"�� �����ϰ� ����</strong>, <strong>&lt;����ǥ ����&gt; �޴��� ����</strong>�Ͽ� �ֽñ� �ٶ��ϴ�.</li>
						<li><br/></li>
						<li><span>��</span> �Է¿Ϸ� �� �ݵ�� <strong> ��5. ����ǥ ���ۡ� </strong>ȭ�鿡�� <strong>���۹�ư�� Ŭ���Ͽ���</strong> ����ǥ ������ �Ϸ�˴ϴ�. <strong>����ǥ�� �����ϱ�</strong> �� �ݵ�� <strong>��ǥ�̻��� Ȯ��</strong>�� ��ģ �� �����Ͻñ� �ٶ��ϴ�.
						</li>
						<li><br/></li>
						<li><span>��</span> ����ǥ �ۼ� å���ڴ� �����ȸ �� Ȯ���� ���Ͽ� ������ ����ǥ ������ �ݵ�� <strong>����Ͽ� ����</strong>�Ͽ� �ֽʽÿ�.
						</li>
						<li><br/></li>
						<li><span>��</span> �ϵ��ްŷ� �������� ���� ���Ǵ� ���ջ�㼾��(1668-3476) �Ǵ� īī���� ��������� �����ֽñ� �ٶ��ϴ�.</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>  
			
			<div class="fc pt_20"></div>

			<!-- ��ư start -->
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">ȭ�� �μ��ϱ�</a></li>
					<li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="contentbutton2">2. ȸ�簳��� ����</a></li>
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
</body>
</html>
