<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. 프로젝트명 : 공정관리위원회 하도급거래 서면직권실태조사					                       */
/*  2. 업체정보 :																					   */
/*     - 업체명 : (주)로티스아이																	   */
/*	   - Project Manamger : 정광식 부장 (pcxman99@naver.com)										   */
/*     - 연락처 : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  3. 일자 : 2009년 5월																			   */
/*  4. 최초작성자 및 일자 : (주)로티스아이 정광식 / 2011-10-18										   */
/*  5. 업데이트내용 (내용 / 일자)																	   */
/*  6. 비고																							   */
/*		1) 웹관리툴 리뉴얼 / 2011-10-18																   */
/*-----------------------------------------------------------------------------------------------------*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/
String sGroup = (request.getParameter("group")==null)? "":request.getParameter("group");
String sClass = (request.getParameter("class")==null)? "":request.getParameter("class");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/

/*=====================================================================================================*/
%>
<html>
<html>
<head>
	<title>【관리】하도급거래 서면실태조사</title>
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
			frm.action="/hado/hado/wTools/MBoard/mboard_list_Search.jsp?group=<%=sGroup%>&class=<%=sClass%>";
			frm.submit();
			nNowProcess = 1;
			bodyhidden();
		} else {
			alert("현재 프로세스가 실행중입니다.\n\n잠시 후 다시 실행해 주세요.");
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

	function entsub(event,form) 
	{
		if (window.event && window.event.keyCode == 13)
		{
			goSearch();
		}
	}
	
	
	function HelpWindow2(url, w, h)
	{
		helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
		helpwindow.focus();
	}

	var sSearchWin = "0";
	function divSearchWin()
	{
		obj = document.getElementById("searchbox");
		wobj = document.getElementById("divSrchWindow");
		
		if( sSearchWin =="0" ) {
			obj.style.display = 'none';
			wobj.innerHTML = "<a href='javascript:divSearchWin();' class='sbutton'>검색창 펼치기</a>";
			sSearchWin = "1";
		} else {
			obj.style.display = '';
			wobj.innerHTML = "<a href='javascript:divSearchWin();' class='sbutton'>검색창 가리기</a>";
			sSearchWin = "0";
		}
	}

	function view(sno)
	{
		var lyView=document.getElementById("divView");
		
		if(nNowProcess == 0) {
			document.procFrame.location.replace("help_board_view.jsp?no="+sno);
			nNowProcess = 1;
			bodyhidden();
			lyView.style.top=Math.round(getVerticalScroll())+"px";
			lyView.style.display="block";
		} else {
			alert("현재 프로세스가 실행중입니다.\n\n잠시 후 다시 실행해 주세요.");
		}
	}

	function savef(main)
	{
		msg = "";
		
		if(main.mID.value == "") msg += "접속 ID를 입력하여 주십시오.\n";
		if(main.mDeptName.value == "") msg += "과명을 입력하여 주십시오.\n";
		if(main.mUserName.value == "") msg += "사용자명을 입력하여 주십시오.\n";
		if(main.mPhoneNo.value == "") msg += "전화번호를 입력하여 주십시오.\n";
		
		if(msg == "") {
			nNowProcess = 1;
			bodyhidden();
			main.target="procFrame";
			main.submit();
		}
		else {
			alert(msg);
		}
	}

	function deluserf(main)
	{
		if(confirm("사용자 정보 삭제를 선택하셨습니다.\n\n삭제를 진행하시려면 [확인]버튼을 누르세요")) {
			nNowProcess = 1;
			bodyhidden();
			main.target="procFrame";
			main.action="Member_Query.jsp?cmd=delUser";
			main.submit();
		}
		else {
			alert("삭제가 취소되었습니다");
		}
	}

	function boardTextreplace()
	{
		var txtBox1=document.getElementById("mQuestion");
		var txtBox2=document.getElementById("mAnswer");

		if( txtBox1 ) { txtBox1.value=all_replace(txtBox1.value,"<br/> ","\n"); }
		if( txtBox2 ) { txtBox2.value=all_replace(txtBox2.value,"<br/> ","\n"); }
	}
</script>
<body onload="goSearch();">
	<div id="ajax_ready" style="position:absolute;top:1px;left:1px;width:60px;height:60px;display:none;z-index:99;"><img src="/hado/hado/wTools/img/ajax_ani.gif" border="0"></div>
	<div id="ajax_bg" style="position:absolute;top:1px;left:1px;display:none;background:url(/hado/hado/wTools/img/ajax_bg.gif);z-index:51;"></div>

	<div id="container">
		<!-- Begin Header -->
		<%@ include file="/hado/wTools/inc/WB_I_pageTop.jsp"%>
		<!-- End Header -->
		
		<!-- Begin Main-menu -->
		<jsp:include page="/hado/wTools/inc/WB_I_topMenu.jsp">
		<jsp:param value="06" name="sel"/>
		</jsp:include>
		<!-- End Main-menu -->

		<!-- Begin Contents -->
		<div id="wrapper">
			<div id="contents">
				<!-- Begin Left-menu -->
				<jsp:include page="/hado/wTools/inc/WB_I_MBoard_LMenu.jsp">
				<jsp:param value="001" name="sel"/>
				</jsp:include>
				<!-- End Left-menu -->

				<div id="divContent">
					<!-- Begin Where I Am -->
					<jsp:include page="/hado/wTools/MBoard/WB_I_Whereiam.jsp">
					<jsp:param value="<%=sGroup%>" name="group"/>
					<jsp:param value="<%=sClass%>" name="class"/>
					</jsp:include>
					<!-- End Where I Am -->	
					
					<div id="divResult"></div>
					<div id="divView" onMouseDown="f_DragMDown(this)"></div>
					<div id="divViewInfo1" onMouseDown="f_DragMDown(this)"></div>
					<div id="divViewInfo2" onMouseDown="f_DragMDown(this)"></div>
					<div id="divViewInfo3" onMouseDown="f_DragMDown(this)"></div>

					
					<div id="divButton">
					<form action="" method="post" name="searchform">
						<ul class="lt">
							<li class="fl">
								<select name="srchType">
									<option value="Subject">제목</option>
									<option value="Text">내용</option>
									<option value="Content">제목+내용</option>
									<option value="Writer">작성자</option>
								</select>
							</li>
							<li class="fl">
								<input type="text" name="srchText" class="mb_srch_input">
							</li>
							<li class="fl"><a href="javascript:goSearch();" class="sbutton">검 색</a></li>
						</ul>
					</form>
					</div>
				</div>
				<iframe src="about:blank" width="1" height="1" id="procFrame" name="procFrame" style="display:hide;"></iframe>
			</div>
		</div>
		<!-- End Contents -->

		<!-- Begin Footer -->
		<%@ include file="/hado/wTools/inc/WB_I_Copyright.jsp"%>
		<!-- End Footer -->
	</div>
</body>
</html>
