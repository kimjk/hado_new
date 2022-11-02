<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/*=======================================================*/
/* ������Ʈ��		: 2014�� �����ŷ�����ȸ �ϵ��ްŷ� �����������					 */
/* ���α׷���		: poll_search.jsp																	*/
/* ���α׷�����	: �����ü �˻� ������															*/
/* ���α׷�����	: 1.0.0																				*/
/* �����ۼ�����	: 2014�� 07�� 08��																*/
/*--------------------------------------------------------------------------------------- */
/*	�ۼ�����		�ۼ��ڸ�				����
/*--------------------------------------------------------------------------------------- */
/*	2014-07-08	������	�����ۼ�																*/			
/*=======================================================*/

/* Variable Difinition Start ======================================*/
// Decimal formater
DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/* Variable Difinition End ========================================*/

/* Request Variable Start =========================================*/
//None
/* Request Variable End ==========================================*/

/* Record Selection Processing Start =================================*/
//None
//* Record Selection Processing End =================================*/

/* Other Bussines Processing Start ==================================*/
//None
/* Other Bussines Processing End ===================================*/

%>

<html>
<head>
	<title>���������ϵ��ްŷ� �����������</title>
	<link rel="stylesheet" href="/hado/hado/wTools/style.css" type="text/css">
</head>
<script language="javascript" type="text/javascript" src="/hado/hado/wTools/inc/ajax_layer.js"></script>
<script language="javascript" type="text/javascript" src="/hado/hado/wTools/inc/common_script.js"></script>
<script language="JavaScript">
	nNowProcess = 0;

	function setNowProcessFalse()
	{
		nNowProcess = 0;
		bodyview();
	}

	function goSearch()
	{
		var frm = document.searchform;
		msg = "";

		if(nNowProcess == 0) {
			frm.target="procFrame";
			frm.action="poll_search_proc.jsp?cmd=start";
			frm.submit();
			nNowProcess = 1;
			bodyhidden();
		} else {
			alert("���� ���μ����� �������Դϴ�.\n\n��� �� �ٽ� ������ �ּ���.");
		}
	}

	var sSearchWin = "0";
	function divSearchWin()
	{
		obj = document.getElementById("searchbox");
		wobj = document.getElementById("divSrchWindow");
		
		if( sSearchWin =="0" ) {
			obj.style.display = 'none';
			wobj.innerHTML = "<a href='javascript:divSearchWin();' class='sbutton'>�˻�â ��ġ��</a>";
			sSearchWin = "1";
		} else {
			obj.style.display = '';
			wobj.innerHTML = "<a href='javascript:divSearchWin();' class='sbutton'>�˻�â ������</a>";
			sSearchWin = "0";
		}
	}
	
	function view(pid,ano)
	{
		if( pid!="" && ano!="" && pid =="20151007" ) {
			window.open("Hado_Poll_20151007.jsp?cmd=mngvw&accNo=" + ano);	//2015�� 10�� 07�� ����ǥ ȣ��
		} else if( pid!="" && ano!="" && pid =="20141110" ) {
			window.open("Hado_Poll_20141110.jsp?cmd=mngvw&accNo=" + ano);	//2014�� 11�� 10�� ����ǥ ȣ��
		} else {
			window.open("Hado_Poll.jsp?cmd=mngvw&accNo=" + ano);	//2014�� 7�� 1�� ����ǥ ȣ��
		}
	}

	function pmove(val)
	{
		if(val!="") {
			var frm = document.searchform;

			frm.target="procFrame";
			frm.action=val;
			frm.submit();
			nNowProcess = 1;
			bodyhidden();
		}
	}

</script>
<body>
	<div id="ajax_ready" style="position:absolute;top:1px;left:1px;width:60px;height:60px;display:none;z-index:99;"><img src="/hado/hado/wTools/img/ajax_ani.gif" border="0"></div>
	<div id="ajax_bg" style="position:absolute;top:1px;left:1px;display:none;background:url(/hado/hado/wTools/img/ajax_bg.gif);z-index:51;"></div>

	<div id="container">
		<!-- Begin Header -->
		<%@ include file="/hado/wTools/inc/WB_I_pageTop.jsp"%>
		<!-- End Header -->
		
		<!-- Begin Main-menu -->
		<jsp:include page="/hado/wTools/inc/WB_I_topMenu.jsp">
		<jsp:param value="08" name="sel"/>
		</jsp:include>
		<!-- End Main-menu -->

		<!-- Begin Contents -->
		<div id="wrapper">
			<div id="contents">
				<!-- Begin Left-menu -->
				<jsp:include page="/hado/wTools/inc/WB_I_poll_LMenu.jsp">
				<jsp:param value="02" name="sel"/>
				</jsp:include>
				<!-- End Left-menu -->

				<div id="divContent">
					<div id="searchContent">
						<li class="subtitle">�����ü ��ȸ</li>
						<li class="whereiam">HOME > ��Ÿ ���� > �űԵ������� > �����ü ��ȸ</li>
						<p></p>
					</div>	
					<div class="searchbox" id="searchbox">
						<table class="searchboxtable">
						<form action="poll_search_proc.jsp?cmd=start" method="post" name=searchform>
							<tr>
								<th>������ȣ</th>
								<td>
									<select name="oPollId">
										<option value="20140701">20140701</option>
										<option value="20141110">20141110</option>
										<option value="20151007">20151007</option>
									</select>
								</td>
								<th>����</th>
								<td>
									<select name="oSentType">
										<option value="">��ü</option>
										<option value="1">����</option>
										<option value="2">�Ǽ�</option>
										<option value="3">�뿪</option>
									</select>
								</td>
							</tr>
							</form>
						</table>
					</div>
					<div id="divButton">
						<ul class="lt">
							<li class="fr" id="divSrchWindow"><a href="javascript:divSearchWin();" class="sbutton">�˻�â ������</a></li>
							<li class="fr"><a href="javascript:goSearch();" class="sbutton">�� ��</a></li>
						</ul>
					</div>

					<div id="divResult">

					</div>

					<div id="divView" onMouseDown="f_DragMDown(this)">
						
					</div>
				</div>
				<iframe src="about:blank" width="1" height="1" id="procFrame" name="procFrame" style="display:none;"></iframe>
			</div>
		</div>
		<!-- End Contents -->

		<!-- Begin Footer -->
		<%@ include file="/hado/wTools/inc/WB_I_Copyright.jsp"%>
		<!-- End Footer -->
	</div>
</body>
</html>