<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%
/*=======================================================*/
/* 프로젝트명		: 2014년 공정거래위원회 신규도입제도관련 설문조사					*/
/* 프로그램명		: Hado_Poll.jsp																		*/
/* 프로그램설명	: 설문조사 입력 페이지															*/
/* 프로그램버전	: 1.0.0																				*/
/* 최초작성일자	: 2014년 07월 07일																*/
/*--------------------------------------------------------------------------------------- */
/*	작성일자		작성자명				내용
/*--------------------------------------------------------------------------------------- */
/*	2014-07-07	정광식	최초작성																*/			
/*=======================================================*/

/* Variable Difinition Start ======================================*/
String sPollId			= "20141110";		// 설문번호
String sReturnURL	= "Hado_Poll_20141110.jsp";	// 설문조사 이동시 페이지
String sSQLs			= "";						// SQL문

ConnectionResource resource		= null;	// Database Resource
Connection conn						= null;	// Database Connection
PreparedStatement pstmt			= null;	// PreparedStatument
ResultSet rs								= null;	// Result RecordSet

// 회사 기본정보
String sSentType		= "";	// 업종
String sBussTerm		= "";	// 사업기간
String sAreaCD		= "";  // 지역코드
String sSubconStep	= "";	// 원사업자와의 거래단계
String sDetailCD		= "";	// 세부업종구분
String sSentSale		= "";	// 매출액
String sEmpCnt		= "";	// 상시종업원수
String sCapaCD		= "";	// 기업규모구분

String[][][] qa			= new String[23][5][21];	// 답변내역 저장
int nAnswerCnt		= 0;

// 배열 초기화
for (int ni = 0; ni < 23; ni++) {
	for (int nj = 0; nj < 5; nj++) {
		for (int nk = 0; nk < 21; nk++) {
			qa[ni][nj][nk] = "";
		}
	}
}
/* Variable Difinition End ========================================*/

/* Request Variable Start =========================================*/
/*	- 입력내용 확인 및 수정을 위해 parameter 값을 참조한다.
	- 내부망 관리자가 입력내용 확인 시 필요항목
	   --> 수정기능이 없는 외부망에서는 해당 내용을 가려도 됨.
*/
String sCmd			= request.getParameter("cmd")==null ? "":request.getParameter("cmd").trim();
String sAcceptNo		= request.getParameter("accNo")==null ? "":request.getParameter("accNo").trim();
/* Request Variable End ==========================================*/

/* Record Selection Processing Start =================================*/
//if( false ) {
	if( !sPollId.equals("") && sCmd.equals("mngvw") && !sAcceptNo.equals("") ) {
		/* 기업 기본정보 */
		sSQLs = "SELECT * \n" +
					"FROM hado_tb_poll_sent \n" +
					"WHERE poll_id = ? \n" +
					"	AND accept_no = ? \n";
		try {		
				resource	= new ConnectionResource();
				conn		= resource.getConnection();
				pstmt		= conn.prepareStatement(sSQLs);
				pstmt.setString(1, sPollId);
				pstmt.setInt(2, Integer.parseInt(sAcceptNo));
				rs			= pstmt.executeQuery();

				if( rs.next() ) {
					sSentType		= rs.getString("sent_type")==null ? "":rs.getString("sent_type");
					sBussTerm		= rs.getString("buss_term_year")==null ? "":rs.getString("buss_term_year");
					sAreaCD			= rs.getString("area_cd")==null ? "":rs.getString("area_cd");
					sSubconStep	= rs.getString("subcon_step")==null ? "":rs.getString("subcon_step");
					sDetailCD		= rs.getString("detail_type_cd")==null ? "":rs.getString("detail_type_cd");
					sSentSale		= rs.getString("sent_sale")==null ? "":rs.getString("sent_sale");
					sEmpCnt		= rs.getString("sent_emp_cnt")==null ? "":rs.getString("sent_emp_cnt");
					sCapaCD		= rs.getString("sent_capa_cd")==null ? "":rs.getString("sent_capa_cd");
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
		/* 조사표 응답정보 */
		sSQLs = "SELECT * \n" +
					"FROM hado_tb_poll_sent_answer \n" +
					"WHERE poll_id = ? \n" +
					"	AND accept_no = ? \n" +
					"ORDER BY sent_q_cd, sent_q_gb \n";
		try {		
				resource	= new ConnectionResource();
				conn		= resource.getConnection();
				pstmt		= conn.prepareStatement(sSQLs);
				pstmt.setString(1, sPollId);
				pstmt.setInt(2, Integer.parseInt(sAcceptNo));
				rs			= pstmt.executeQuery();
				
				int qcd = 0;
				int qgb = 0;
				
				nAnswerCnt = 0;

				while( rs.next() ) {
					qcd						= rs.getInt("sent_q_cd");
					qgb						= rs.getInt("sent_q_gb");
					qa[qcd][qgb][1]		= rs.getString("A");
					qa[qcd][qgb][2]		= rs.getString("B");
					qa[qcd][qgb][3]		= rs.getString("C");
					qa[qcd][qgb][4]		= rs.getString("D");
					qa[qcd][qgb][5]		= rs.getString("E");
					qa[qcd][qgb][6]		= rs.getString("F");
					qa[qcd][qgb][7]		= rs.getString("G");
					qa[qcd][qgb][8]		= rs.getString("H");
					qa[qcd][qgb][9]		= rs.getString("I");
					qa[qcd][qgb][10]		= rs.getString("J");
					qa[qcd][qgb][11]		= rs.getString("K");
					qa[qcd][qgb][12]		= rs.getString("L");
					qa[qcd][qgb][13]		= rs.getString("M");
					qa[qcd][qgb][14]		= rs.getString("N");
					qa[qcd][qgb][15]		= rs.getString("O");
					qa[qcd][qgb][16]		= rs.getString("P");
					qa[qcd][qgb][17]		= rs.getString("Q");
					qa[qcd][qgb][18]		= rs.getString("R");
					qa[qcd][qgb][19]		= rs.getString("S");
					qa[qcd][qgb][20]		= rs.getString("Subj_Ans")==null ? "":new String( rs.getString("Subj_Ans").getBytes("ISO8859-1"), "EUC-KR" );

					nAnswerCnt++;
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
	}
//}
/* Record Selection Processing End =================================*/

/* Other Bussines Processing Start ==================================*/
//None
/* Other Bussines Processing End ===================================*/
%>
<%!
public String setHiddenValue(String[][][] arrVal,int ni, int nx, int gesu)
{
	String retValue = "";
	if ( ni > 0 && nx > 0 && gesu > 0 ) {
		for(int np=1; np<=gesu; np++) {
			if( arrVal[ni][nx][np]!=null && arrVal[ni][nx][np].equals("1") ) {
				retValue = np+"";
			}
		}
	}
	return retValue;
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
	<title>공정거래위원회 신규도입제도관련 설문조사</title>
	<link rel="stylesheet" href="style.css" type="text/css">
	<script language="javascript" type="text/javascript" src="../js/credian_common_script.js"></script>
</head>

<script language="JavaScript">
	ns4 = (document.layers)? true:false;
	ie4 = (document.all)? true:false;
	
	var msg		= "";
	var radiof	= false;

	function savef() {
		var cchekc	="no";
		var main	= document.info;

		msg = "";

		
		// 필수 입력문항 체크 :: research2f( form-name, 대번호, 소번호, 개체타입(1:text,2:radio,3:checkbox),보기개수(checkbox만 해당 아니면 0) );		
		//research2f(main, 9, 1, 2, 0);

		researchf(main.oSentType, 2, "업종을 선택하여 주십시오.");
		if(main.oSentType[0].checked==true) researchf(main.oDetailCD, 2, "세부업종을 선택하여 주십시오.");
		researchf(main.oSubconStep, 2, "거래형태를 선택하여 주십시오.");
		researchf(main.oSentSale, 1, "매출액을 입력하여 주십시오.");

		research2f(info, 22, 1, 3, 12);
		research2f(info, 1, 1, 2, 0);
		research2f(info, 2, 1, 2, 0);
		research2f(info, 3, 1, 2, 0);
		research2f(info, 4, 1, 2, 0);
		research2f(info, 5, 1, 2, 0);
		research2f(info, 6, 1, 2, 0);
		research2f(info, 7, 1, 2, 0);
		research2f(info, 8, 1, 2, 0);
		research2f(info, 9, 1, 2, 0);
		research2f(info, 10, 1, 2, 0);
		research2f(info, 11, 1, 2, 0);
		research2f(info, 12, 1, 2, 0);
		research2f(info, 13, 1, 2, 0);
		research2f(info, 14, 1, 2, 0);
		research2f(info, 15, 1, 2, 0);
		research2f(info, 16, 1, 2, 0);
		research2f(info, 17, 1, 2, 0);
		research2f(info, 18, 1, 2, 0);
		research2f(info, 19, 1, 2, 0);


		// 연계문항 선택 확인
		//--> 입력여부 확인 :: research3f(form-name, 연계문항대번호, 연계문항소번호, 개체타입(1:text,2:radio,3:checkbox), 보기개수(checkbox만 해당 아니면 0), 선선택(조건)문항대번호, 선선택(조건)문항소번호);
		//if( main.q1_29_1[3].checked==true || main.q1_29_1[4].checked==true ) research3f(main, 29, 3, 1, 0, 29, 1); else initf(main, 29, 3, 1, 0);
		// 연계문항 끝

		if(msg=="") {
			if(confirm("[ 조사표내용을 전송합니다. ]\n\n접속자가 많을경우 다소 시간이 걸릴수도 있습니다.\n정상적으로 전송이 안될경우\n수십분후에 다시시도하여 주십시오.\n\n확인을 누르시면 전송합니다.")) {
				
				//document.getElementById("loadingImage").style.display="block";
				view_layer("loadingImage");

				main.target = "ProceFrame";
				main.action = "Hado_Poll_Query.jsp?cmd=submit";
				main.submit();
			}
		} else {
			alert(msg+"\n\n전송이 취소되었습니다.")
		}

	}

	function relationf(main) {
		msg = "";
		
		// 연계문항 선택 확인
		//--> 입력여부 확인 :: research3f(form-name, 연계문항대번호, 연계문항소번호, 개체타입(1:text,2:radio,3:checkbox), 보기개수(checkbox만 해당 아니면 0),
		//-->               선선택(조건)문항대번호, 선선택(조건)문항소번호);
		//--> 문항초기화 :: initf(form-name, 문항대번호, 문항소번호, 개체타입(2:radio,3:checkbox), 0보기개수(checkbox만 해당 아니면 0));
		//if( main.q1_29_1[3].checked==true || main.q1_29_1[4].checked==true ) research3f(main, 29, 3, 1, 0, 29, 1); else initf(main, 29, 3, 1, 0);

	}

	// Radio object 재선택시 초기화
	function checkradio(ni, nx) {
		eval("oldValue = document.info.c1_"+ni+"_"+nx+".value");
		eval("obj = document.info.q1_"+ni+"_"+nx);
		selValue = "";

		for(i=0; i<obj.length; i++) {
			if(obj[i].checked==true) {
				selValue = (i+1)+"";
				break;
			}
		}

		if(selValue != "") {
			if(selValue == oldValue) {
				eval("document.info.c1_"+ni+"_"+nx+".value = ''");
				initf(document.info, ni, nx, 2, 0);
				relationf(document.info);
			} else {
				eval("document.info.c1_"+ni+"_"+nx+".value = selValue");
				relationf(document.info);
			}
		}
	}

	function researchf(obj,type,mm) {
		var ccheck="no", i;
		switch (type) {
			case 1:
				if(obj.value=="") msg=msg+"\n"+mm;
				break;
			case 2:
				for(i=0;i<obj.length;i++)
					if(obj[i].checked==true) ccheck="yes";
				if(ccheck=="no") msg=msg+"\n"+mm;
				break;
		}
	
	}

	//-- 필수항목 선택여부 확인 --//
	function research2f(obj,fno,sno,type,gesu) {
		var ccheck="no", i;

		switch (type) {
			case 1:	// text
				ccheck="yes";
				eval("if(obj.q1_"+fno+"_"+sno+".value=='') ccheck='no'");
				break;
			case 2:	// Radio
				eval("for(i=0;i<obj.q1_"+fno+"_"+sno+".length;i++) if(obj.q1_"+fno+"_"+sno+"[i].checked==true) ccheck='yes'");
				break;
			case 3:	// checkbox
				for(i=1;i<=gesu;i++)
					eval("if(obj.q1_"+fno+"_"+sno+"_"+i+".checked==true) ccheck='yes'");
				break;
		}

		if(ccheck=="no") {
			msg=msg+"\n";

			if( type=="1" ) {
				eval("msg=msg+'조사표의 "+fno+"번 문항을 입력하여 주십시오.'");
				//eval("msg=msg+'조사표의 "+fno+"번의 ("+sno+")번을 입력하여 주십시오.'");
			} else {
				eval("msg=msg+'조사표의 "+fno+"번 문항을 선택하여 주십시오.'");
				//eval("msg=msg+'조사표의 "+fno+"번의 ("+sno+")번을 입력하여 주십시오.'");
			}
		}
	}

	//-- 연계항목 선택여부 확인 --//
	function research3f(obj,fno,sno,type,gesu,ofno,osno) {
		var ccheck="no", i;

		switch (type) {
			case 1:	// text
				ccheck="yes";
				eval("if(obj.q1_"+fno+"_"+sno+".value=='') ccheck='no'");
				break;
			case 2:	// Radio
				eval("for(i=0;i<obj.q1_"+fno+"_"+sno+".length;i++) if(obj.q1_"+fno+"_"+sno+"[i].checked==true) ccheck='yes'");
				break;
			case 3:	// checkbox
				for(i=1;i<=gesu;i++)
					eval("if(obj.q1_"+fno+"_"+sno+"_"+i+".checked==true) ccheck='yes'");
				break;
		}

		if(ccheck=="no") {
			msg=msg+"\n";

			if( type=="1") {
				eval("msg=msg+'조사표의 "+ofno+"번의 ("+osno+")번의 연계문항 "+fno+"번의 ("+sno+")번을 입력하여 주십시오.'");
			} else {
				eval("msg=msg+'조사표의 "+ofno+"번의 ("+osno+")번의 연계문항 "+fno+"번의 ("+sno+")번을 선택하여 주십시오.'");
			}
		}
	}

	function noanswerf(obj,fno,sno,tno,type,gesu,ft1,ft2) {
		var ccheck="no";

		if(fno==9&&sno==3) {
			if(ft1!="z")
				eval("if(obj.q1_"+fno+"_"+sno+"_"+ft1+".checked==false&&obj.q1_"+fno+"_"+sno+"_"+ft2+".checked==false) ccheck='yes'");
		} else {
			if(ft1!="z")
				eval("if(obj.q1_"+fno+"_"+sno+"["+ft1+"].checked==true) ccheck='yes'");
			if(ft2!="z")
				eval("if(obj.q1_"+fno+"_"+sno+"["+ft2+"].checked==true) ccheck='yes'");
		}

		if(ccheck=="yes") {
			eval("alert('응답오류 : "+fno+"번의 ("+sno+")번 응답확인 요망 ')");

			switch(type) {
				case 2:
					eval("for(i=0;i<obj.q1_"+fno+"_"+tno+".length;i++) obj.q1_"+fno+"_"+tno+"[i].checked=false");
					break;
				case 3:
					for(i=1;i<=gesu;i++)
						eval("obj.q1_"+fno+"_"+tno+"_"+i+".checked=false");
					break;
			}
		
		}
	}
	
	// 문항 초기화 function
	function initf(obj,fno,sno,type,gesu) {
		switch(type) {
			case 1:
				eval("obj.q1_"+fno+"_"+sno+".value=''");
				break;
			case 2:
				eval("for(i=0;i<obj.q1_"+fno+"_"+sno+".length;i++) obj.q1_"+fno+"_"+sno+"[i].checked=false");
				break;
			case 3:
				for(i=1;i<=gesu;i++)
					eval("obj.q1_"+fno+"_"+sno+"_"+i+".checked=false");
				break;
		}
	}

	//--------------------------------------------------------------------------------------------------------
	var bName = navigator.appName;
	var bVer = parseInt(navigator.appVersion);
	var NS4 = (bName == "Netscape" && bVer >= 4);
	var IE4 = (bName == "Microsoft Internet Explore" && bVer >= 4);
	var NS3 = (bName == "Netscape" && bVer < 4);
	var IE3 = (bName == "Microsoft Internet Explore" && bVer < 4);

	var vTime = 5;

	function view_layer(obj) {
		var listDiv	= eval("document.getElementById('" + obj + "')");
		var topx	= 50;
		var leftx	= 60;

		if(NS4) {
			//var e = window.event;
			//listDiv.style.top = e.clientY + document.body.scrollTop + document.documentElement.scrollTop - topx;
			listDiv.style.top = document.body.scrollTop + document.documentElement.scrollTop + topx;
			//listDiv.style.left = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft - leftx;
			listDiv.style.left = document.body.scrollLeft + document.documentElement.scrollLeft + leftx;
		} else {
			//listDiv.style.posTop = event.y + document.body.scrollTop - topx;
			listDiv.style.posTop = document.body.scrollTop + topx;
			//listDiv.style.posLeft = event.x + document.body.scrollLeft - leftx;
			listDiv.style.posLeft = document.body.scrollLeft + leftx;
		}
	}

	function ShowInfo(str) {
		vTime = 5;

		infoLayerText.innerHTML = "<font color='#006633'>" + str + "</font>";
		
		goShowInfo();
		infotimer = setInterval(goShowInfo,1000);
	}

	function goShowInfo() {
		if(vTime > 0) {
			document.getElementById("infoLayer").style.visibility = '';
			vTime = vTime - 1;
			view_layer("infoLayer");
		} else {
			document.getElementById("infoLayer").style.visibility='hidden';
			clearInterval(infotimer);
		}
	}

	//--------------------------------------------------------------------------------------------------------	
	function ohapf(main) {
		main.qhap16.value=Cnum(main.q1_100_3_1.value)+Cnum(main.q1_100_3_2.value)+Cnum(main.q1_100_3_3.value)+Cnum(main.q1_100_3_4.value)+Cnum(main.q1_100_3_5.value)+Cnum(main.q1_100_3_6.value)+Cnum(main.q1_100_3_7.value)+Cnum(main.q1_100_3_8.value);
		
		main.qper7.value=Cnum(Math.round(Cnum(main.q1_100_3_1.value)/Cnum(main.qhap16.value)*100));
		main.qper8.value=Cnum(Math.round(Cnum(main.q1_100_3_2.value)/Cnum(main.qhap16.value)*100));
		main.qper9.value=Cnum(Math.round(Cnum(main.q1_100_3_3.value)/Cnum(main.qhap16.value)*100));
		main.qper10.value=Cnum(Math.round(Cnum(main.q1_100_3_4.value)/Cnum(main.qhap16.value)*100));
		main.qper11.value=Cnum(Math.round(Cnum(main.q1_100_3_5.value)/Cnum(main.qhap16.value)*100));
		main.qper12.value=Cnum(Math.round(Cnum(main.q1_100_3_6.value)/Cnum(main.qhap16.value)*100));
		main.qper13.value=Cnum(Math.round(Cnum(main.q1_100_3_7.value)/Cnum(main.qhap16.value)*100));
		main.qper14.value=Cnum(Math.round(Cnum(main.q1_100_3_8.value)/Cnum(main.qhap16.value)*100));
	}

	function OpenPost() {
		MsgWindow = window.open("WB_Find_Zip.jsp?ITEM=F&stype=prod3","_PostSerch","toolbar=no,width=430,height=320,directories=no,status=yes,scrollbars=yes,resize=no,menubar=no");
	}
	
	function formatmoney(m) {
		var money, pmoney, mlength, z, textsize, i;
		textsize= 20;
		pmoney	= "";
		z		= 0;
		money	= m;
		money	= clearstring(money);
		money	= Number(money);
		money	= money + "";

		for(i=money.length-1;i>=0;i--) {
			z=z+1;

			if(z%3==0) {
				pmoney=money.substr(i,1)+pmoney;
				if(i!=0)	pmoney=","+pmoney;
			}
			else pmoney=money.substr(i,1)+pmoney;
		}

		return pmoney;
	}

	function clearstring(s) {
		var pstr, sstr, iz;
		sstr	= s;
		pstr	= "";

		for(iz=0;iz<sstr.length;iz++) {
			if(!isNaN(sstr.substr(iz,1))||sstr.substr(iz,1)==".") pstr=pstr+sstr.substr(iz,1);
		}

		return pstr;
	}

	
	function HelpWindow(url, w, h) {
		helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=no,scrollbars=no,resize=no,menubar=no,location=no");
		helpwindow.focus();
	}
	
	function HelpWindow2(url, w, h) {
		helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
		helpwindow.focus();
	}
	
	function fMoveTo(url) {
		if(confirm("다음단계로의 이동을 선택하셨습니다.\n\n선택하신 기능은 최후 저장 후 변경한 내용을\n저장하지 않고 이동합니다.\n변경한 내용이 있을경우 저장 후 선택하십시오.\n\n확인을 누르시면 이동합니다.")) {
			location.href = url;
		}
	}
	
	function chkDiv() {
		inform = document.info;
		val1 = "";
		for(ni = 0; ni < inform.q1.length; ni++) {
			if(inform.q1[ni].checked == true) {
				val1 = inform.q1[ni].value;
				break;
			}
		}
		val2 = "";
		for(ni = 0; ni < inform.q7.length; ni++) {
			if(inform.q7[ni].checked == true) {
				val2 = inform.q7[ni].value;
				break;
			}
		}

		if(val1=="1" && (val2=="1" || val2=="2")) {
			if(ie4) {
				document.all["divResearch1"].style.visibility = "hidden";
				document.all["divResearch2"].style.visibility = "visible";
			} else {
				document.layers["divResearch1"].visibility = "hide";
				document.layers["divResearch2"].visibility = "show";
			}
		} else {
			if(ie4) {
				document.all["divResearch1"].style.visibility = "visible";
				document.all["divResearch2"].style.visibility = "hidden";
			} else {
				document.layers["divResearch1"].visibility = "show";
				document.layers["divResearch2"].visibility = "hide";
			}
		}
		
		if(val1=="2" || val1=="3" || val1=="4") HelpWindow('/help/help2.jsp',405,220);
		if(val1=="5" || val1=="6")				HelpWindow('/help/help3.jsp',405,220);
		if(val1=="7")							HelpWindow('/help/help4.jsp',405,220);
		if(val2=="3" || val2=="4")				HelpWindow('/help/help1.jsp',405,220);
	}

	function Cnum(aa) {
		bb	= aa + "";

		while (bb.indexOf(",") != -1)
		{
			bb=bb.replace(",","") ;
		}

		if(isNaN(bb)||bb==''||bb==null)	return 0
		else							return Number(bb);
	}	
	
	function sumf(main) {
		// 현금성 기간별
		main.mA3.value = 0;
		main.mB3.value = 0;
		main.mC3.value = 0;
		main.mD3.value = 0;
		main.mE3.value = 0;
		main.mF3.value = 0;
		main.mG3.value = 0;
		for(i=1 ; i<3; i++) eval("main.mA3.value = Cnum(main.mA3.value) + Cnum(main.mA"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.mB3.value = Cnum(main.mB3.value) + Cnum(main.mB"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.mC3.value = Cnum(main.mC3.value) + Cnum(main.mC"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.mD3.value = Cnum(main.mD3.value) + Cnum(main.mD"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.mE3.value = Cnum(main.mE3.value) + Cnum(main.mE"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.mF3.value = Cnum(main.mF3.value) + Cnum(main.mF"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.mG3.value = Cnum(main.mG3.value) + Cnum(main.mG"+i+".value)");
		for(i=1 ; i<4; i++) {
			eval("main.mSubSum"+i+".value = Cnum(main.mA"+i+".value)+Cnum(main.mB"+i+".value)+Cnum(main.mC"+i+".value)+Cnum(main.mD"+i+".value)+Cnum(main.mE"+i+".value)+Cnum(main.mF"+i+".value)+Cnum(main.mG"+i+".value)");
		}
		/*
		main.m2A3.value = 0;
		main.m2B3.value = 0;
		main.m2C3.value = 0;
		main.m2D3.value = 0;
		main.m2E3.value = 0;
		main.m2F3.value = 0;
		main.m2G3.value = 0;
		for(i=1 ; i<3; i++) eval("main.m2A3.value = Cnum(main.m2A3.value) + Cnum(main.m2A"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.m2B3.value = Cnum(main.m2B3.value) + Cnum(main.m2B"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.m2C3.value = Cnum(main.m2C3.value) + Cnum(main.m2C"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.m2D3.value = Cnum(main.m2D3.value) + Cnum(main.m2D"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.m2E3.value = Cnum(main.m2E3.value) + Cnum(main.m2E"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.m2F3.value = Cnum(main.m2F3.value) + Cnum(main.m2F"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.m2G3.value = Cnum(main.m2G3.value) + Cnum(main.m2G"+i+".value)");
		for(i=1 ; i<4; i++) {
			eval("main.m2SubSum"+i+".value = Cnum(main.m2A"+i+".value)+Cnum(main.m2B"+i+".value)+Cnum(main.m2C"+i+".value)+Cnum(main.m2D"+i+".value)+Cnum(main.m2E"+i+".value)+Cnum(main.m2F"+i+".value)+Cnum(main.m2G"+i+".value)");
		}
		*/
	}

	function onDocument() {
		ohapf(document.info);
		sumf(document.info);
	}

	function byteLengCheck(frmobj, maxlength, objname, divname) {
		var nbyte = 0;
		var nlen = 0;

		for(i = 0; i < frmobj.value.length; i++) {
			if(escape(frmobj.value.charAt(i)).length > 4) {
				nbyte += 2;
			} else {
				nbyte++;
			}

			if(nbyte <= maxlength) 
				nlen = i + 1;
		}

		obj = document.getElementById(divname);
		obj.innerText = nbyte + "/" + maxlength + "byte";

		if(nbyte > maxlength) {
			alert("최대 글자 입력수를 초과 하였습니다.");
			frmobj.value = frmobj.value.substr(0,nlen);
			obj.innerText = maxlength+"/"+maxlength+"byte";
		}

		frmobj.focus();
	}

	function goPrint() {
		url	= "ProdStep_03_Print.jsp";
		w	= 820;
		h	= 600;

		if(confirm("화면 인쇄는 조사표 저장 후에 가능합니다.\n\n인쇄하시겠습니까?\n[확인]을 누르시면 인쇄됩니다.")) {
			HelpWindow2(url, w, h);
		}
	}

</script>

<body>
	
	<div id="loadingImage" style="display:none;left:1;top:1;position:absolute;z-index:1000;">
		<br/><br/><br/><br/><br/>
		<img src="../img/system_loding.gif" border="0"/>
	</div>

	<div id="container">
	<div id="wrapper">
		<!-- Begin Header -->
		<div id="subheader">
			<ul class="lt">
				<li class="fl"><a href="/" onfocus="this.blur()"><img src="img/logo.gif" ></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			
		</div>
		<!-- End Header -->

		<form action="" method="post" name="info">
		<!-- Begin subcontent -->
		<div id="subcontent">
			<!-- title start -->
			<h1 class="contenttitle" align="center"><b>하도급분야 설문조사</b><br>
			(3배 손해배상 제도 및 부당특약금지 제도 관련)</h1>
			<!-- title end -->
			
			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="width:920px;">
				<!--내부망 날짜 수정-->
					<li class="boxcontenttitle"><font color="#FF0066">◇ 조사목적</font></li>
					<li class="boxcontenttitle"><span>ㅇ </span>공정거래위원회는 하도급거래에서 원사업자의 불공정한 행위로부터 수급사업자를 보호하고 수급사업자의 권리를 강화하기 위해 「하도급거래 공정화에 관한 법률」에 ①3배 손해배상제 적용대상 확대 및 ②부당특약을 금지하는 제도를 도입하였습니다.</li>
					<li class="boxcontenttitle"><span>ㅇ </span>이에 새로 도입된 제도가 수급사업자에게 실제로 도움이 되고 있는지 여부를 파악하고,  필요한 제도 보완사항을 마련하기 위한 자료로 활용하기 위해 중소기업을 대상으로 본 조사를 실시하고자 하오니, 바쁘시더라도 조사에 꼭 응하여 주시기를 부탁드립니다. </li>
					<!--
					<li class="boxcontenttitle"><span>※ </span>설문참여 방법은 설문문항이 있는 웹 사이트(<a href="http://hado.ftc.go.kr/poll/">http://hado.ftc.go.kr/poll/</a>)에 접속하셔서, <font color="#FF0066">2014.11.21.(금)</font>까지 입력 후 전송하여 주시면 됩니다.</li>
					-->
					<li class="boxcontenttitle"><font color="#FF0066">◇ 참고사항</font></li>
					<li class="boxcontenttitle"><span>ㅇ </span>본 조사는 무기명으로 진행되며, 귀사가 조사표에 기재한 내용은 통계법 제33조에 따라 비밀이 보장되고, 통계 목적 이외에는 사용되지 않음을 약속드립니다.  </li>
					<li class="boxcontenttitle"><span>ㅇ </span>본 조사는 공정거래위원회와 중소사업자단체(중소기업중앙회 및 전문건설협회)가 공동으로 실시하는 것임을 알려드립니다.</li>
					<li class="boxcontenttitle"><span>ㅇ </span>조사표에 대한 문의사항은 아래 담당자에게 연락주시기 바랍니다.</li>
					<li class="boxcontenttitle">- 공정거래위원회 기업거래정책과 : 송명현 사무관  (전화번호 : 044-200-4588)</li>
				</ul>
			</div>
			
			<div class="fc pt_10"></div>
			
			<h2 class="contenttitle">◆ 업체현황</h2>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">  해당란에 기입하거나 체크하여 주십시오.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:15%;" />
									<col style="width:35%;" />
									<col style="width:15%;" />
									<col style="width:35%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>업종</th>
										<td colspan="3">
											<input type="radio" name="oSentType" value="1" <%if(sSentType.equals("1")){out.print("checked");}%>>① 제조업 (아래 세부업종 체크)
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oSentType" value="2" <%if(sSentType.equals("2")){out.print("checked");}%>>② 건설업<br/>
										</td>
									</tr>
									<tr>
										<th>세부업종<br/>(제조업)</th>
										<td colspan="3">
											<input type="radio" name="oDetailCD" value="1" <%if(sDetailCD.equals("1")){out.print("checked");}%>>① 기계ㆍ기계장비ㆍ금속&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="2" <%if(sDetailCD.equals("2")){out.print("checked");}%>>② 전기ㆍ전자ㆍ정밀&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="3" <%if(sDetailCD.equals("3")){out.print("checked");}%>>③ 석유화학ㆍ고무ㆍ플라스틱<br/>
											<input type="radio" name="oDetailCD" value="4" <%if(sDetailCD.equals("4")){out.print("checked");}%>>④ 섬유ㆍ의복ㆍ가죽&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="5" <%if(sDetailCD.equals("5")){out.print("checked");}%>>⑤ 목재ㆍ종이ㆍ인쇄&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="6" <%if(sDetailCD.equals("6")){out.print("checked");}%>>⑥ 식료품ㆍ음료<br/>
											<input type="radio" name="oDetailCD" value="7" <%if(sDetailCD.equals("7")){out.print("checked");}%>>⑦ 자동차ㆍ조선ㆍ기타 운송장비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="8" <%if(sDetailCD.equals("8")){out.print("checked");}%>>⑧ 비금속&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="9" <%if(sDetailCD.equals("9")){out.print("checked");}%>>⑨ 철강&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="10" <%if(sDetailCD.equals("10")){out.print("checked");}%>>⑩ 기타
										</td>
									</tr>	
									<tr>
										<th>매출액</th>
										<td>
											2013년도 <font color="#FF0066"><b>약</b>  <input type="text" name="oSentSale" value="<%=sSentSale%>"  maxlength="6" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"  onkeyup ="sukeyup(this);ohapf(this.form);" style="width:100px;text-align:right;"><b>억원</b></font>
										</td>
										<th>하도급<br/>거래단계</th>
										<td>
											<input type="radio" name="oSubconStep" value="1" <%if(sSubconStep.equals("1")){out.print("checked");}%>>① 1차&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oSubconStep" value="2" <%if(sSubconStep.equals("2")){out.print("checked");}%>>② 2차&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oSubconStep" value="3" <%if(sSubconStep.equals("3")){out.print("checked");}%>>③ 3차 이하<br/>
											<input type="radio" name="oSubconStep" value="4" <%if(sSubconStep.equals("4")){out.print("checked");}%>>④ 구분이 곤란한 경우
										</td>
									</tr>
								</tbody>
							</table>
						</li>
					</ul>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">  귀사가 속한 협동조합을 체크하여 주십시오. (최대 3개까지 체크 가능)</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
					<ul class="lt"><input type="hidden" name="c1_22_1" value="<%=setHiddenValue(qa, 22, 1, 12)%>">
						<li>
							<table class="tbl_blue">
								<tr>
									<td><input type="checkbox" name="q1_22_1_1" value="1" <%if(qa[22][1][1]!=null && qa[22][1][1].equals("1")){out.print("checked");}%>>
									① 한국전선공업협동조합</td>
									<td><input type="checkbox" name="q1_22_1_2" value="2" <%if(qa[22][1][2]!=null && qa[22][1][2].equals("1")){out.print("checked");}%>>
									② 한국피복공업협동조합</td>
									<td><input type="checkbox" name="q1_22_1_3" value="3" <%if(qa[22][1][3]!=null && qa[22][1][3].equals("1")){out.print("checked");}%>>
									③ 한국조선해양기자재공업협동조합</td>
								</tr>
								<tr>
									<td><input type="checkbox" name="q1_22_1_4" value="4" <%if(qa[22][1][5]!=null && qa[22][1][4].equals("1")){out.print("checked");}%>>
									④ 한국금속울타리공업협동조합</td>
									<td><input type="checkbox" name="q1_22_1_5" value="5" <%if(qa[22][1][5]!=null && qa[22][1][5].equals("1")){out.print("checked");}%>>
									⑤ 한국산업로공업협동조합</td>
									<td><input type="checkbox" name="q1_22_1_6" value="6" <%if(qa[22][1][6]!=null && qa[22][1][6].equals("1")){out.print("checked");}%>>
									⑥ 한국프라스틱공업협동조합연합</td>
								</tr>
								<tr>
									<td><input type="checkbox" name="q1_22_1_7" value="7" <%if(qa[22][1][7]!=null && qa[22][1][7].equals("1")){out.print("checked");}%>>
									⑦ 한국전기공업협동조합</td>
									<td><input type="checkbox" name="q1_22_1_8" value="8" <%if(qa[22][1][8]!=null && qa[22][1][8].equals("1")){out.print("checked");}%>>
									⑧ 한국단조공업협동조합</td>
									<td><input type="checkbox" name="q1_22_1_9" value="9" <%if(qa[22][1][9]!=null && qa[22][1][9].equals("1")){out.print("checked");}%>>
									⑨ 한국박스산업협동조합</td>
								</tr>
								<tr>
									<td><input type="checkbox" name="q1_22_1_10" value="10" <%if(qa[22][1][10]!=null && qa[22][1][10].equals("1")){out.print("checked");}%>>
									⑩ 한국금형공업협동조합</td>
									<td><input type="checkbox" name="q1_22_1_11" value="11" <%if(qa[22][1][11]!=null && qa[22][1][11].equals("1")){out.print("checked");}%>>
									⑪ 한국철근가공업협동조합</td>
									<td><input type="checkbox" name="q1_22_1_12" value="12" <%if(qa[22][1][12]!=null && qa[22][1][12].equals("1")){out.print("checked");}%>>
									⑫ 대한전문건설협회</td>
								</tr>
							</table>
						</li>
					</ul>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">Ⅰ.제도에 대한 인지도</a></li>
						</ul>
					</li>
				</ul>
			</div>
			
			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b>※ <font color="#FF0066">1번 및 2번 문항</font>은 최근<font color="#FF0066">「하도급거래 공정화에 관한 법률」</font>에 도입된 ①<font color="#FF0066">3배 손해배상제 적용대상 확대</font>, ②<font color="#FF0066">부당특약 금지 제도</font>에 대한 <font color="#FF0066">귀사의 인지도</font>를 파악하기 위한 질문입니다.</b></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>1. </span>귀사는 하도급거래에서 대기업 등의 불공정한 행위를 억제하고 중소기업의 권리를 강화하기 위해 <font color="#FF0066">3배 손해배상제도의 적용대상</font>이 중소기업에 피해를 크게 입히는 불공정행위인 <font color="#FF0066">부당한 하도급대금 결정ㆍ감액 행위, 부당위탁취소, 부당반품</font>으로 <font color="#FF0066">확대된 사실</font>을 알고 계십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_1_1" value="<%=setHiddenValue(qa, 1, 1, 5)%>">
						<li><input type="radio" name="q1_1_1" value="1" <%if(qa[1][1][1]!=null && qa[1][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);">① 잘 알고 있다</li>
						<li><input type="radio" name="q1_1_1" value="2" <%if(qa[1][1][2]!=null && qa[1][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);">② 대체로 알고 있다</li>
						<li><input type="radio" name="q1_1_1" value="3" <%if(qa[1][1][3]!=null && qa[1][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);">③ 약간 알고 있다</li>
						<li><input type="radio" name="q1_1_1" value="4" <%if(qa[1][1][4]!=null && qa[1][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);">④ 잘 모른다</li>
						<li><input type="radio" name="q1_1_1" value="5" <%if(qa[1][1][5]!=null && qa[1][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);">⑤ 전혀 모른다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>2. </span>귀사는 하도급거래에서 합의(특약)를 명분으로 대기업 등이 부담해야 할 각종 비용을 중소기업에게 전가하는 관행을 개선하기 위해 <font color="#FF0066">원사업자가 수급사업자의 이익을 부당하게 침해하거나 제한하는 계약조건을 설정하는 행위</font>가 <font color="#FF0066">금지된 사실</font>을 알고 계십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_2_1" value="<%=setHiddenValue(qa, 2, 1, 5)%>">
						<li><input type="radio" name="q1_2_1" value="1" <%if(qa[2][1][1]!=null && qa[2][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);">① 잘 알고 있다</li>
						<li><input type="radio" name="q1_2_1" value="2" <%if(qa[2][1][2]!=null && qa[2][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);">② 대체로 알고 있다</li>
						<li><input type="radio" name="q1_2_1" value="3" <%if(qa[2][1][3]!=null && qa[2][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);">③ 약간 알고 있다</li>
						<li><input type="radio" name="q1_2_1" value="4" <%if(qa[2][1][4]!=null && qa[2][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);">④ 잘 모른다</li>
						<li><input type="radio" name="q1_2_1" value="5" <%if(qa[2][1][5]!=null && qa[2][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);">⑤ 전혀 모른다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">Ⅱ.3배 손해배상제 적용대상 확대 (2013.11.29. 시행)</a></li>
						</ul>
					</li>
				</ul>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="width:920px;">
					<li class="boxcontenttitle">대기업 등의 불공정한 행위를 억제하고 피해를 입은 중소기업의 권리를 강화하기 위하여 3배 손해배상제 적용대상을'<font color="#FF0066">기술유용행위</font>에서 <font color="#FF0066">부당한 하도급대금결정ㆍ감액, 부당위탁 취소 및 부당반품</font>'으로 확대하였습니다. 대기업 등이 위 불공정행위를 한 경우 시정명령, 과징금, 벌금 등이 부과될 뿐만 아니라, 피해를 입은 중소기업은 법원에 손해배상 청구를 하여 손해액의 3배까지 배상을 받을 수 있게 되었습니다.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b>※ <font color="#FF0066">3번 문항부터 14번 문항</font>까지는 3배 손해배상제도가 <font color="#FF0066">확대 시행되기 전 기간</font>과 <font color="#FF0066">확대 시행된 후의 기간 별로 귀사의 불공정행위 경험 유무 및 거래관행 개선정도</font>를 파악하기 위한 질문입니다.</b></li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><font color="#FF0066">(부당한 하도급대금 결정ㆍ감액 관련)</font></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>3. </span>3배 손해배상제도가 <font color="#FF0066">확대 시행되기 전</font> 10개월간(2013.1.1.~2013.10.31.) <font color="#FF0066">원사업자가</font> 귀사와 상호 합의 없이 <font color="#FF0066">부당하게 하도급대금을 결정</font>하거나, 정당한 사유가 없음에도 <font color="#FF0066">위탁을 했을 때 정했던 금액보다 적게 하도급대금을 지급한 경우</font>가 있었습니까 ?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_3_1" value="<%=setHiddenValue(qa, 3, 1, 2)%>">
						<li><input type="radio" name="q1_3_1" value="1" <%if(qa[3][1][1]!=null && qa[3][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);">① 없었음</li>
						<li><input type="radio" name="q1_3_1" value="2" <%if(qa[3][1][2]!=null && qa[3][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);">② 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>	

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>4. </span>3배 손해배상제도가 <font color="#FF0066">확대 시행된 이후</font> 10개월간(2014.1.1.~2014.10.31.) <font color="#FF0066">원사업자가</font> 귀사와 상호 합의 없이 <font color="#FF0066">부당하게 하도급대금을 결정</font>하거나, 정당한 사유가 없음에도 <font color="#FF0066">위탁을 했을 때 정했던 금액보다 적게 하도급대금을 지급한 경우</font>가 있었습니까 ?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_4_1" value="<%=setHiddenValue(qa, 4, 1, 2)%>">
						<li><input type="radio" name="q1_4_1" value="1" <%if(qa[4][1][1]!=null && qa[4][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);">① 없었음</li>
						<li><input type="radio" name="q1_4_1" value="2" <%if(qa[4][1][2]!=null && qa[4][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);">② 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>5. </span><font color="#FF0066">3배 손해배상제도가 본격적으로 확대 시행된 2014.1.1. 이후</font>, 1년 전과 비교하여, 귀사는  <font color="#FF0066">원사업자의 부당한 하도급대금 결정ㆍ감액 행위</font>가 <font color="#FF0066">어느 정도 개선</font>되었다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_5_1" value="<%=setHiddenValue(qa, 5, 1, 5)%>">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_5_1" value="1" <%if(qa[5][1][1]!=null && qa[5][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);">5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_5_1" value="2" <%if(qa[5][1][2]!=null && qa[5][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(5,2);">4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_5_1" value="3" <%if(qa[5][1][3]!=null && qa[5][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(5,3);">3점
						&nbsp;&nbsp; ──&nbsp;&nbsp;<input type="radio" name="q1_5_1" value="4" <%if(qa[5][1][4]!=null && qa[5][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(5,4);">2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_5_1" value="5" <%if(qa[5][1][5]!=null && qa[5][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(5,5);">1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선됨 ← ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ→전혀 개선되지 않음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><font color="#FF0066">(부당한 위탁취소 관련)</font></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>6. </span>3배 손해배상제도가 <font color="#FF0066">확대 시행되기 전</font> 10개월간(2013.1.1.~2013.10.31.) 귀사의 귀책사유가 없음에도 불구하고 <font color="#FF0066">원사업자가 하도급 계약을 일방적으로 취소한 경우</font>가 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_6_1" value="<%=setHiddenValue(qa, 6, 1, 2)%>">
						<li><input type="radio" name="q1_6_1" value="1" <%if(qa[6][1][1]!=null && qa[6][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(6,1);">① 없었음</li>
						<li><input type="radio" name="q1_6_1" value="2" <%if(qa[6][1][2]!=null && qa[6][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(6,1);">② 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>7. </span>3배 손해배상제도가 <font color="#FF0066">확대 시행된 이후</font> 10개월간(2014.1.1.~2014.10.31.) 귀사의 귀책사유가 없음에도 불구하고 <font color="#FF0066">원사업자가 하도급 계약을 일방적으로 취소한 경우</font>가 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_7_1" value="<%=setHiddenValue(qa, 7, 1, 2)%>">
						<li><input type="radio" name="q1_7_1" value="1" <%if(qa[7][1][1]!=null && qa[7][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);">① 없었음</li>
						<li><input type="radio" name="q1_7_1" value="2" <%if(qa[7][1][2]!=null && qa[7][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);">② 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>8. </span><font color="#FF0066">3배 손해배상제도가 본격적으로 확대 시행된 2014.1.1. 이후</font>, 1년 전과 비교하여, <font color="#FF0066">귀사는  원사업자의 부당한 위탁취소 행위</font>가 <font color="#FF0066">어느 정도 개선</font>되었다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_8_1" value="1" <%if(qa[8][1][1]!=null && qa[8][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);">5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_8_1" value="2" <%if(qa[8][1][2]!=null && qa[8][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(8,2);">4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_8_1" value="3" <%if(qa[8][1][3]!=null && qa[8][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(8,3);">3점
						&nbsp;&nbsp; ──&nbsp;&nbsp;<input type="radio" name="q1_8_1" value="4" <%if(qa[8][1][4]!=null && qa[8][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(8,4);">2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_8_1" value="5" <%if(qa[8][1][5]!=null && qa[8][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(8,5);">1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선됨 ← ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ→전혀 개선되지 않음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><font color="#FF0066">(부당반품 관련)</font></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>9. </span>3배 손해배상제도가 <font color="#FF0066">확대 시행되기 전</font> 10개월간(2013.1.1.~2013.10.31.) 귀사의 귀책사유가 없음에도 불구하고 <font color="#FF0066">원사업자가 목적물의 납품 등을 받은 후 반품한 경우</font>가 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_9_1" value="<%=setHiddenValue(qa, 9, 1, 2)%>">
						<li><input type="radio" name="q1_9_1" value="1" <%if(qa[9][1][1]!=null && qa[9][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);">① 없었음</li>
						<li><input type="radio" name="q1_9_1" value="2" <%if(qa[9][1][2]!=null && qa[9][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);">② 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>	

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>10. </span>3배 손해배상제도가 <font color="#FF0066">확대 시행된 이후</font> 10개월간(2014.1.1.~2014.10.31.) 귀사의 귀책사유가 없음에도 불구하고 <font color="#FF0066">원사업자가 목적물의 납품 등을 받은 후 반품한 경우</font>가 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_10_1" value="<%=setHiddenValue(qa, 10, 1, 2)%>">
						<li><input type="radio" name="q1_10_1" value="1" <%if(qa[10][1][1]!=null && qa[10][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);">① 없었음</li>
						<li><input type="radio" name="q1_10_1" value="2" <%if(qa[10][1][2]!=null && qa[10][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);">② 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11. </span><font color="#FF0066">3배 손해배상제도가 본격적으로 확대 시행된 2014.1.1. 이후</font>, 1년 전과 비교하여, 귀사는 <font color="#FF0066">원사업자의 부당반품 행위</font>가 <font color="#FF0066">어느 정도 개선</font>되었다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_11_1" value="1" <%if(qa[11][1][1]!=null && qa[11][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);">5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_11_1" value="2" <%if(qa[11][1][2]!=null && qa[11][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,2);">4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_11_1" value="3" <%if(qa[11][1][3]!=null && qa[11][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,3);">3점
						&nbsp;&nbsp; ──&nbsp;&nbsp;<input type="radio" name="q1_11_1" value="4" <%if(qa[11][1][4]!=null && qa[11][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,4);">2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_11_1" value="5" <%if(qa[11][1][5]!=null && qa[11][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,5);">1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선됨 ← ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ→전혀 개선되지 않음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><font color="#FF0066">(기술유용 관련)</font></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>12. </span>3배 손해배상제도가 <font color="#FF0066">확대 시행되기 전</font> 10개월간(2013.1.1.~2013.10.31.) <font color="#FF0066">원사업자가 귀사로부터 취득한 기술자료를</font> 원사업자 또는 제3자의 이익을 위해 <font color="#FF0066">사용함으로써 귀사에게 손해가 발생한 경험</font>이 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_12_1" value="<%=setHiddenValue(qa, 12, 1, 2)%>">
						<li><input type="radio" name="q1_12_1" value="1" <%if(qa[12][1][1]!=null && qa[12][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);">① 없었음</li>
						<li><input type="radio" name="q1_12_1" value="2" <%if(qa[12][1][2]!=null && qa[12][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);">② 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>13. </span>3배 손해배상제도가 <font color="#FF0066">확대 시행된 이후</font> 10개월간(2014.1.1.~2014.10.31.) <font color="#FF0066">원사업자가 귀사로부터 취득한 기술자료를</font> 원사업자 또는 제3자의 이익을 위해 <font color="#FF0066">사용함으로써 귀사에게 손해가 발생한 경험</font>이 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_13_1" value="<%=setHiddenValue(qa, 13, 1, 2)%>">
						<li><input type="radio" name="q1_13_1" value="1" <%if(qa[13][1][1]!=null && qa[13][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);">① 없었음</li>
						<li><input type="radio" name="q1_13_1" value="2" <%if(qa[13][1][2]!=null && qa[13][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);">② 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>14. </span><font color="#FF0066">3배 손해배상제도가 본격적으로 확대 시행된 2014.1.1. 이후</font>, 1년 전과 비교하여, 귀사는 <font color="#FF0066">원사업자의 기술유용 행위</font>가 <font color="#FF0066">어느 정도 개선</font>되었다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_14_1" value="1" <%if(qa[14][1][1]!=null && qa[14][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);">5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_14_1" value="2" <%if(qa[14][1][2]!=null && qa[14][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(14,2);">4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_14_1" value="3" <%if(qa[14][1][3]!=null && qa[14][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(14,3);">3점
						&nbsp;&nbsp; ──&nbsp;&nbsp;<input type="radio" name="q1_14_1" value="4" <%if(qa[14][1][4]!=null && qa[14][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(14,4);">2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_14_1" value="5" <%if(qa[14][1][5]!=null && qa[14][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(14,5);">1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선됨 ← ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ→전혀 개선되지 않음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">Ⅲ. 부당특약 금지 제도 (2014.2.14. 시행)</a></li>
						</ul>
					</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="width:920px;">
					<li class="boxcontenttitle">합의(특약)를 명분으로 대기업 등이 부담해야 할 각종 비용(예:민원처리 비용 등)을 중소기업에게 전가하는 관행을 개선하기 위해 하도급계약에서 부당한 특약의 설정을 금지하였습니다. 대기업 등이 부당특약을 설정한 경우 특약조항의 삭제ㆍ수정 등 시정명령, 과징금, 벌금 등이 부과됩니다.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b>※ <font color="#FF0066">15번 문항부터 17번 문항</font>까지는 <font color="#FF0066">부당특약을 금지하는 제도</font>가 <font color="#FF0066">시행되기 전 기간</font>과 <font color="#FF0066">확대 시행된 후의 기간 별로 귀사의 불공정행위 경험 유무 및 거래관행 개선정도</font>를 파악하기 위한 질문입니다.</b></li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>15. </span>부당한 특약을 금지하는 제도가 <font color="#FF0066">시행되기 전</font> 약 8개월 기간 동안 (2013.2.14.~2013.10.31.) 귀사가 원사업자와 체결한 하도급계약에 <font color="#FF0066">원사업자가 귀사의 이익을 부당하게 침해하거나 제한하는 계약조건을 설정한 사실</font>이 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_15_1" value="<%=setHiddenValue(qa, 15, 1, 2)%>">
						<li><input type="radio" name="q1_15_1" value="1" <%if(qa[15][1][1]!=null && qa[15][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);">① 없었음</li>
						<li><input type="radio" name="q1_15_1" value="2" <%if(qa[15][1][2]!=null && qa[15][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);">② 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>16. </span>부당한 특약을 금지하는 제도가 <font color="#FF0066">시행된 이후</font> 약 8개월 기간 동안 (2014.2.14.~2014.10.31.) 귀사가 원사업자와 체결한 하도급계약에 <font color="#FF0066">원사업자가 귀사의 이익을 부당하게 침해하거나 제한하는 계약조건을 설정한 사실</font>이 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_16_1" value="<%=setHiddenValue(qa, 16, 1, 2)%>">
						<li><input type="radio" name="q1_16_1" value="1" <%if(qa[16][1][1]!=null && qa[16][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);">① 없었음</li>
						<li><input type="radio" name="q1_16_1" value="2" <%if(qa[16][1][2]!=null && qa[16][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);">② 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>17. </span><font color="#FF0066">부당한 특약을 금지하는 제도가 시행된 2014.2.14. 이후</font>, 1년 전과 비교하여, 귀사는 <font color="#FF0066">원사업자가 부당한 특약을 설정하는 불공정행위</font>가 <font color="#FF0066">어느정도 개선</font>되었다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="1" <%if(qa[17][1][1]!=null && qa[17][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);">5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="2" <%if(qa[17][1][2]!=null && qa[17][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(17,2);">4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="3" <%if(qa[17][1][3]!=null && qa[17][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(17,3);">3점
						&nbsp;&nbsp; ──&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="4" <%if(qa[17][1][4]!=null && qa[17][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(17,4);">2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="5" <%if(qa[17][1][5]!=null && qa[17][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(17,5);">1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선됨 ← ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ→전혀 개선되지 않음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">Ⅳ. 하도급대금 지급실태 관련</a></li>
						</ul>
					</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="width:920px;">
					<li class="boxcontenttitle">공정거래위원회는 매년 서면실태조사 등을 통해 하도급대금 지급실태를 조사하고 있으며, 특히 2014.7월 이후에는 현금결제 비율 미준수, 어음할인료 미지급, 하도급대금 지연지급 등 하도급대금 관련 현장조사를 집중적으로 실시하고 있습니다. 1차 현장조사는 건설업종을 대상으로 7~8월에 실시하였고, 2차 현장조사는 제조 및 용역업종을 대상으로 11월에 실시 중이며, 12월에도 全 업종을 대상으로 3차 현장조사를 실시할 예정입니다.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b>※ <font color="#FF0066">18번 및 19번 문항</font>은 하도급대금 지급실태 관련 현장조사를 집중적으로 시작한 이후 <font color="#FF0066">거래관행 개선정도 및 향후 효과 정도</font>를 파악하기 위한 질문입니다.</b></li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18. </span>공정위가 <font color="#FF0066">하도급대금 지급실태에 대한 현장조사를 집중적으로 시작한 2014.7월 이후,</font> 1년 전과 비교하여, 귀사는 <font color="#FF0066">현금결제 비율 미준수, 어음할인료 미지급, 하도급대금 지연지급 등 원사업자의 대금지급 관련 불공정행위</font>가 <font color="#FF0066">어느 정도 개선</font>되었다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_18_1" value="1" <%if(qa[18][1][1]!=null && qa[18][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);">5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_18_1" value="2" <%if(qa[18][1][2]!=null && qa[18][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,2);">4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_18_1" value="3" <%if(qa[18][1][3]!=null && qa[18][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(18,3);">3점
						&nbsp;&nbsp; ──&nbsp;&nbsp;<input type="radio" name="q1_18_1" value="4" <%if(qa[18][1][4]!=null && qa[18][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(18,4);">2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_18_1" value="5" <%if(qa[18][1][5]!=null && qa[18][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(18,5);">1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선됨 ← ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ ㅡ→전혀 개선되지 않음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>19. </span>귀사는 위와같은 <font color="#FF0066">지속적인 하도급대금 관련 현장 실태조사</font>가 <font color="#FF0066">하도급대금 지급 관련 불공정 행위를 개선</font>하는데 <font color="#FF0066">어느 정도 도움이 되거나 효과가 있을 것</font>이라고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_19_1" value="<%=setHiddenValue(qa, 19, 1, 5)%>">
						<li><input type="radio" name="q1_19_1" value="1" <%if(qa[19][1][1]!=null && qa[19][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">① 많은 효과가 있을 것이다</li>
						<li><input type="radio" name="q1_19_1" value="2" <%if(qa[19][1][2]!=null && qa[19][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">② 대체로 효과가 있을 것이다</li>
						<li><input type="radio" name="q1_19_1" value="3" <%if(qa[19][1][3]!=null && qa[19][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">③ 약간 효과가 있을 것이다</li>
						<li><input type="radio" name="q1_19_1" value="4" <%if(qa[19][1][4]!=null && qa[19][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">④ 거의 효과가 없을 것이다</li>
						<li><input type="radio" name="q1_19_1" value="5" <%if(qa[19][1][5]!=null && qa[19][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">⑤ 전혀 효과가 없을 것이다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">Ⅴ. 기타</a></li>
						</ul>
					</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><span>20. </span>귀사가 문5(부당한 하도급대금 결정ㆍ감액), 문8(부당한 위탁취소) 문11(부당반품), 문14(기술유용), 문17번(부당특약) 또는 문18번(하도급대금 지급실태)과 관련하여 <font color="#FF0066">거래관행 개선정도에 대해 1점 또는 2점이라고 응답한 경우 거래관행이 개선되지 않는 주요 원인은 무엇</font>이라고 생각하는지 간략하게 기재하여 주시기 바랍니다.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontentsubtitle"><p align="right" id="content_bytes20">0/4000byte</p></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><textarea cols="80" rows="8" maxlength="600" name="q1_20_1" class="textarea01b" maxlength="600" onFocus="javascript:this.className='textarea01o';" onBlur="javascript:this.className='textarea01b';" onkeyup="byteLengCheck(this, 4000, this.name,'content_bytes20');"><%=qa[20][1][20]%></textarea></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><span>21. </span>귀사가 공정한 하도급거래 질서 조성을 위해 필요하다고 생각하시는 <font color="#FF0066">건의사항</font> 또는 <font color="#FF0066">원사업자와 하도급거래를 하면서 경험한 불공정행위</font> 등을 자유롭게 기재하여 주시기 바랍니다.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontentsubtitle"><p align="right" id="content_bytes21">0/4000byte</p></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><textarea cols="80" rows="8" maxlength="600" name="q1_21_1" class="textarea01b" maxlength="600" onFocus="javascript:this.className='textarea01o';" onBlur="javascript:this.className='textarea01b';" onkeyup="byteLengCheck(this, 4000, this.name,'content_bytes21');"><%=qa[21][1][20]%></textarea></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_20"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp lt">
					<li class="boxcontenttitle"><p align="center">바쁘신 중에도 설문에 성실히 응답하여 주셔서 감사합니다.</p></li>
				</ul>
			</div>

			<div class="fc pt_20"></div>

			<!-- 버튼 start -->
			<!--
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="#" onclick="savef(); return false;" onfocus="this.blur()" class="contentbutton2">전 송</a></li>
				</ul>
			</div>
			-->

			<!-- 버튼 end -->

		</div>
		</form>
		<!-- End subcontent -->

		<!-- Begin Footer -->
		<div id="subfooter"><img src="img/bottom.gif"></div>
		<!-- End Footer -->

	</div>
	</div>

	<%/*-----------------------------------------------------------------------------------------------
	2010년 4월 26일 / iframe 추가 / 정광식
	:: 하도급거래상황 (설문문항) 선택 후 저장 시 오류발생으로 기존정보 소실되는 경우를 방지하기 위해 
	:: 선택사항을 iframe 타겟으로 submit 시킴
	*/%>
	<iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
	<%/*-----------------------------------------------------------------------------------------------*/%>
	<!--div id="infoLayer" style="position: absolute; visibility:'hidden' ; z-index:100; top:1; left:1;">
		<table width="550" cellpadding="2" cellspacing="4" border="0">
			<tr><td bgcolor="#FF9900" align="center" valign="top" height="40">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td width="5">
						<td bgcolor="#FFFFCC" valign="middle" height="40"><div id="infoLayerText" name="infoLayerText"></div></td>
					</tr>
				</table>
			</td></tr>
		</table>
	</div-->

<script language="JavaScript">
	<%if ( StringUtil.checkNull(request.getParameter("isSaved")).equals("1") ) {%>
		alert("정상적으로 전송되었습니다.\참여해 주셔서 감사합니다.")
	<%}%>
</script>

</body>
</html>
<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>