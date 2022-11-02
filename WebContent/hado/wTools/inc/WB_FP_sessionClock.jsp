<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 2014년 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_FP_sessionClock.jsp
* 프로그램설명	: 로그인유지시간 타이머 (iframe 실행 전용)
* 프로그램버전	: 3.0.0-2014
* 최초작성일자	: 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-14	정광식       최초작성
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
		targetTime = 29*60;	// 29 분
		
		bAutoLogin = true;		// 로그인 유지시간 자동연장 여부

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
		
			temp += "분 ";

			if( (targetTime % 60) < 10 ) 
				temp += "0";
				

			temp += (targetTime%60);
			temp += "초";

			timer_layer.innerHTML = temp;

			if( Math.floor(targetTime / 60) < 1 ) {
				if( bAutoLogin ) {	// 유지시간 자동연장
					refreshTime();
				} else {	// 유지시간 자동연장 안함
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
			<td align="center"><div id="TimeValue" class="TimeValue">29분 00초</div></td>
			<td align="center"><a href="#" onclick="refreshTime();"><img src="/rsch0614/img/btn_log_ing.gif" onmouseover="this.src='/rsch0614/img/btn_log_ing_on.gif'" onmouseout="this.src='/rsch0614/img/btn_log_ing.gif'" align="absmiddle" alt="로그인 연장"></a></td>
			<td align="center">
				<a href="#" onclick="logout();"><img src="/rsch0614/img/btn_logout.gif" onmouseover="this.src='/rsch0614/img/btn_logout_on.gif'" onmouseout="this.src='/rsch0614/img/btn_logout.gif'" align="absmiddle" alt="로그아웃"></a>
			</td>
		</tr>
	</form>
	</table>
</BODY>
</HTML>
