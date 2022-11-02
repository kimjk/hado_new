<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: 2014�� �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_FP_sessionClock.jsp
* ���α׷�����	: �α��������ð� Ÿ�̸� (iframe ���� ����)
* ���α׷�����	: 3.0.0-2014
* �����ۼ�����	: 2014�� 09�� 14��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-09-14	������       �����ۼ�
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Date"%>

<%@ page import="ftc.util.*"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%
Date now = new Date();
%>
<HTML>
<HEAD>
	<TITLE> Timer </TITLE>
	<style>
		.TimeValue{
			width: 60px; 
			height: 18px;
			background-color: white;
			font-family:nanum,dotum;
			color: #CC6600;
			font-size : 9pt;
			font-weight : none;
		}
	</style>
	<script language="javascript">
		targetTime = 29*60;	// 29 ��
		
		bAutoLogin = true;		// �α��� �����ð� �ڵ����� ����

		function startTimer()
		{
			logtimer = setInterval(goTimer,1000)
		}

		function goTimer() {
			timer_layer = document.getElementById("TimeValue");

			targetTime -= 1;
			temp = Math.floor(targetTime / 60);

			if( Math.floor(targetTime / 60) < 10)
				temp = "0" + Math.floor(targetTime / 60);
		
			temp += "�� ";

			if( (targetTime % 60) < 10 ) 
				temp += "0";
				

			temp += (targetTime%60);
			temp += "��";

			timer_layer.innerHTML = temp;

			if( Math.floor(targetTime / 60) < 1 ) {
				if( bAutoLogin ) {	// �����ð� �ڵ�����
					refreshTime();
				} else {	// �����ð� �ڵ����� ����
					if(targetTime < 0) {
						stopTimer();
					}
				}
			}
		}

		function stopTimer() {
			clearInterval(logtimer);
			closeSession();
		}

		function logout() {
			parent.top.actionLogout();
		}

		function closeSession() {
			parent.location.href = "/index.jsp?rtnType=E001";
		}

		function refreshTime()
		{
			location.replace("/hado/wTools/inc/WB_FP_sessionClock.jsp?<%=now%>");
		}

		startTimer();
	</script>
</HEAD>

<BODY>
	<table align="center" width="100%" cellpadding="0" cellspacing="0">
	<form>
		<tr>
			<td align="center"><div id="TimeValue" class="TimeValue">29�� 00��</div></td>
			<td align="center"><a href="#" onclick="refreshTime();"><img src="/rsch0614/img/btn_log_ing.gif" onmouseover="this.src='/rsch0614/img/btn_log_ing_on.gif'" onmouseout="this.src='/rsch0614/img/btn_log_ing.gif'" align="absmiddle" alt="�α��� ����"></a></td>
			<td align="center">
				<a href="#" onclick="logout();"><img src="/rsch0614/img/btn_logout.gif" onmouseover="this.src='/rsch0614/img/btn_logout_on.gif'" onmouseout="this.src='/rsch0614/img/btn_logout.gif'" align="absmiddle" alt="�α׾ƿ�"></a>
			</td>
		</tr>
	</form>
	</table>
</BODY>
</HTML>
