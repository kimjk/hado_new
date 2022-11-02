<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: 2015�� ���޻���� �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_VP_Subcon_Add.jsp
* ���α׷�����	: ���޻���� > �⵵�� ����ǥ > 2015�� ������ ����ǥ > �ű��������� ��������
* ���α׷�����	: 3.0.1
* �����ۼ�����	: 2015�� 07�� 21��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2015-07-21	������       �����ۼ�
*	2016-01-12	�̿뱤		DB�������� ���� ���ڵ� ����
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_I_Global.jsp"%>
<%@ include file="../Include/WB_I_chkSession.jsp" %>

<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String sErrorMsg = "";	// �����޽���

	String q_Cmd		= StringUtil.checkNull(request.getParameter("mode"));

	String sentSaNo = "";
	String sentStatus = "";
	String sentReason = "";
	String sentCheck = "";

	String f2 = "";
	String f3 = "";
	String fall = "no";

	String stt = StringUtil.checkNull(request.getParameter("tt"));
	String st = StringUtil.checkNull(request.getParameter("st"));
	String saveno = StringUtil.checkNull(request.getParameter("saveno"));

	String sSQLs = "";

	// Cookie Request
	String sMngNo = ckMngNo;
	String sOentYYYY = ckCurrentYear;
	String sOentGB = ckOentGB;
	String sOentName = ckOentName;
	String sSentNo = ckSentNo;

/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/

	if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
		ConnectionResource resource	= null;
		Connection conn				= null;
		PreparedStatement pstmt		= null;
		ResultSet rs				= null;

		sSQLs="SELECT sent_sa_no, sent_status, sp_fld_03 FROM HADO_TB_Subcon_"+sOentYYYY+" \n";
		sSQLs+="WHERE Child_Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";
    
		try {
			resource	= new ConnectionResource();
			conn		= resource.getConnection();
			//System.out.println("sSQLs : "+sSQLs);

			pstmt		= conn.prepareStatement(sSQLs);
			rs			= pstmt.executeQuery();

			while (rs.next()) {
				sentSaNo = rs.getString("sent_sa_no");
				sentStatus = rs.getString("sent_status");
				sentCheck = rs.getString("sp_fld_03");
			}
			rs.close();


		} catch(Exception e){
			e.printStackTrace();
		} finally {
			if (rs != null)		try{rs.close();}	catch(Exception e){}
			if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
			if (conn != null)	try{conn.close();}	catch(Exception e){}
			if (resource != null) resource.release();
		}

		sentSaNo = StringUtil.checkNull(sentSaNo);
		sentStatus = StringUtil.checkNull(sentStatus);
        sentCheck = StringUtil.checkNull(sentCheck);
		
		f2 = "yes";

		int gesu = 0;

        // sentCheck ���ܴ�� ���� (sentCheck ���� ������ ���ܴ��)
		if ( f2.equals("yes") && (!sentCheck.equals("")) ) {
			f2 = "yes";
			fall = "yes";
		} else {
			gesu = 0;

			sSQLs="SELECT count(*) ansCnt FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
			sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
			sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
			sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
			sSQLs+="AND Sent_No="+sSentNo+" \n";

			try {
				resource	= new ConnectionResource();
				conn		= resource.getConnection();
				pstmt		= conn.prepareStatement(sSQLs);
				rs			= pstmt.executeQuery();

				while (rs.next()) {
					gesu = rs.getInt("ansCnt");
				}
				rs.close();
			} catch(Exception e){
				e.printStackTrace();
			} finally {
				if (rs != null)		try{rs.close();}	catch(Exception e){}
				if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
				if (conn != null)	try{conn.close();}	catch(Exception e){}
				if (resource != null) resource.release();
			}

			if (gesu == 0) {
				f3 = "no";
			} else {
				f3 = "yes";
			}
		}
	}

    // �߰� ���� ���� 
    // sentStatus ���ۿϷᰡ 1 �̰� , fall = no, f3 = yes
    String addTypeSatus = "";
    
    if("1".equals(sentStatus) && "no".equals(fall) && "yes".equals(f3)){
        addTypeSatus = "Y";
    }else{
        addTypeSatus = "N";
    }

/*=====================================================================================================*/
%>
<% st_Current_Year_n = Integer.parseInt(sOentYYYY); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--[if lt IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie6"><![endif]-->
<!--[if IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie7"><![endif]-->
<!--[if IE 8]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie8"><![endif]-->
<!--[if (gt IE 8)|!(IE)]><!-->
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko-KR" >
<!--<![endif]-->
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta http-equiv='Cache-Control' content='no-cache' />
    <meta http-equiv='Pragma' content='no-cache' />
    <title><%=st_Current_Year_n %>�⵵ �ϵ��ްŷ� ������� ����</title>

	<link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="euc-kr" />
	<% if (q_Cmd.equals("print")) { %>
	<link rel="stylesheet" href="style_print.css" type="text/css"/>
	<% } else { %>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<% } %>


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
    <script src="../js/login_2019.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/credian_common_script.js" type="text/javascript"  charset="euc-kr"></script>
	<script type="text/javascript">
	//<![CDATA[
		function savef(type, id){
		    if(type == 'N'){
		        alert("�ͻ�� �ռ� �ϵ��ްŷ� ���������� ����ǥ ���۱���\n�Ϸ����ּž� �ش� ������ ���� ���� �մϴ�. \n�Ϲ���Ȳ �� �ϵ��ްŷ� ��Ȳ�� �ش�Ǵ� �������� \n���� ������ �ֽñ� �ٶ��ϴ�.");
		    }else{
		        var url = "https://isurvey.panel.co.kr/?Alias=7544256404&panel_id="+ id
		    	window.open(url); 
		    }
		    
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
				<li class="fl"><a href="/" onfocus="this.blur()"><img src="img/logo.jpg" width="242" height="55" /></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"><font color="#FF6600">[
							<% if( ckOentGB.equals("1") ) {%>������
							<% } else if( ckOentGB.equals("2") ) {%>�Ǽ���
							<% } else if( ckOentGB.equals("3") ) {%>�뿪��<% } %>]</font>
							<%=ckOentName%>&nbsp;/&nbsp;<%=ckSentName%><iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" style="vertical-align: text-bottom;" frameborder="0"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="./WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="mainmenu">1. ����ȳ�</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. �ͻ��� �Ϲ���Ȳ</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. �ϵ��� �ŷ� ��Ȳ</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="mainmenu">4. ����ǥ ����</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_Add.jsp" onfocus="this.blur()" class="mainmenuup">5. �߰� ����</a></li>
			</ul>
		</div>
		<!-- End Header -->

		<form action="" method="post" name="info">
		<!-- Begin subcontent -->
		<div id="subcontent">
			<!-- title start -->
			<h1 class="contenttitle">5. �߰� ����</h1>
			<!-- title end -->

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">�� ��ǰ�ܰ� �ݿ� ���� ����</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li>�ֱ� ������ ���� ������� ���� �߼ұ������ �ַλ����� �ľ��ϰ� �ϵ��޾�ü���� �������� ��ǰ�ܰ� �������� ��ȸ�� �����ϱ� ���� ��� ���� 
                            <strong><u>��ǰ�ܰ��������������� ��ȿ�� �� ���ϴ�å</u></strong>�� �����ϱ� ���� ���� �ڷ�� Ȱ���ϰ��� ����ǰ�ܰ� �ݿ����� �� �ַλ��� ���硹�� �ǽ��Ϸ��� �մϴ�. �� ������ ������ <strong><u>���������� ���� ��������ڷ�μ��� Ȱ��</u></strong>�� ��ȹ���� �˷��帮���� �������� ������ ��Ź�帳�ϴ�.</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_2"></div>
      
            <div class="boxcontent2">
              <ul class="boxcontenthelp lt" style="padding-left:20px;">
                  <li class="boxcontenttitle"><img src="./img/event_20210915.jpg" border="0" style="width:930px; height:650px;"/></li>
              </ul>
            </div>

			<!-- ��ư start -->
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="javascript:savef('<%=addTypeSatus %>', '<%=ckMngNo %>');" onfocus="this.blur()" class="contentbutton2">�߰� ����  �����ϱ�</a></li>
				</ul>
			</div>
			<!-- ��ư end -->

			<div class="fc pt_20"></div>
			
			<div class="boxcontent3" >
				<ul class="boxcontenthelp2 lt" style="display:none;">
					<li class="noneboxcontenttitle"><p align="center"><img src="/img/img.gif" border="0" /></p></li>
				</ul>
			</div>

		</div>
		</form>
		<!-- End subcontent  -->

		<!-- Begin Footer -->
		<div id="subfooter"><img src="img/bottom.gif" /></div>
		<!-- End Footer -->

	</div>
</div>
</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>