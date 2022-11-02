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
String sPollId			= "20140701";		// 설문번호
String sReturnURL	= "Hado_Poll.jsp";	// 설문조사 이동시 페이지
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

String[][][] qa			= new String[33][5][21];	// 답변내역 저장
int nAnswerCnt		= 0;

// 배열 초기화
for (int ni = 0; ni < 33; ni++) {
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


		// 연계문항 선택 확인
		//--> 입력여부 확인 :: research3f(form-name, 연계문항대번호, 연계문항소번호, 개체타입(1:text,2:radio,3:checkbox), 보기개수(checkbox만 해당 아니면 0), 선선택(조건)문항대번호, 선선택(조건)문항소번호);
		if( main.q1_2_1[0].checked==true ) research3f(main, 2, 2, 2, 5, 2, 1); else initf(main, 2, 2, 2, 5);
		if( main.q1_4_1[1].checked==true ) research3f(main, 4, 2, 2, 7, 4, 1); else initf(main, 4, 2, 2, 7);
		if( main.q1_8_1[1].checked==true ) research3f(main, 8, 2, 2, 7, 8, 1); else initf(main, 8, 2, 2, 7);
		if( main.q1_12_1[1].checked==true ) research3f(main, 12, 2, 2, 7, 12, 1); else initf(main, 12, 2, 2, 7);
		if( main.q1_16_1[1].checked==true ) research3f(main, 16, 2, 2, 7, 16, 1); else initf(main, 16, 2, 2, 7);
		if( main.q1_18_1[0].checked==true ) research3f(main, 18, 2, 2, 4, 18, 1); else initf(main, 18, 2, 2, 4);
		if( main.q1_20_1[1].checked==true ) research3f(main, 20, 2, 2, 7, 20, 1); else initf(main, 20, 2, 2, 7);
		if( main.q1_21_1[0].checked==true ) research3f(main, 21, 2, 2, 5, 21, 1); else initf(main, 21, 2, 2, 5);
		if( main.q1_22_1[0].checked==true ) research3f(main, 22, 2, 2, 4, 22, 1); else initf(main, 22, 2, 2, 4);
		if( main.q1_22_1[0].checked==true ) research3f(main, 23, 1, 2, 3, 22, 1); else initf(main, 23, 1, 2, 3);
		if( main.q1_23_1[0].checked==true || main.q1_23_1[1].checked==true ) research3f(main, 23, 2, 2, 6, 23, 1); else initf(main, 23, 2, 2, 6);
		if( main.q1_23_1[2].checked==true ) research3f(main, 23, 3, 2, 6, 23, 1); else initf(main, 23, 3, 2, 6);
		if( main.q1_25_1[0].checked==true ) research3f(main, 25, 2, 3, 9, 25, 1); else initf(main, 25, 2, 3, 9);
		if( main.q1_26_1[0].checked==true ) research3f(main, 26, 2, 3, 9, 26, 1); else initf(main, 26, 2, 3, 9);
		if( main.q1_29_1[0].checked==true || main.q1_29_1[1].checked==true || main.q1_29_1[2].checked==true ) research3f(main, 29, 2, 2, 3, 29, 1); else initf(main, 29, 2, 2, 3);
		//if( main.q1_29_1[3].checked==true || main.q1_29_1[4].checked==true ) research3f(main, 29, 3, 1, 0, 29, 1); else initf(main, 29, 3, 1, 0);
		// 연계문항 끝

		if(msg=="") {
			if(confirm("[ 조사표내용을 저장합니다. ]\n\n접속자가 많을경우 다소 시간이 걸릴수도 있습니다.\n정상적으로 저장이 안될경우\n수십분후에 다시시도하여 주십시오.\n\n확인을 누르시면 저장합니다.")) {
				
				//document.getElementById("loadingImage").style.display="block";
				view_layer("loadingImage");

				main.target = "ProceFrame";
				main.action = "Hado_Poll_Query.jsp?cmd=submit";
				main.submit();
			}
		} else {
			alert(msg+"\n\n저장이 취소되었습니다.")
		}

	}

	function relationf(main) {
		msg = "";
		
		// 연계문항 선택 확인
		//--> 입력여부 확인 :: research3f(form-name, 연계문항대번호, 연계문항소번호, 개체타입(1:text,2:radio,3:checkbox), 보기개수(checkbox만 해당 아니면 0),
		//-->               선선택(조건)문항대번호, 선선택(조건)문항소번호);
		//--> 문항초기화 :: initf(form-name, 문항대번호, 문항소번호, 개체타입(2:radio,3:checkbox), 0보기개수(checkbox만 해당 아니면 0));
		if( main.q1_2_1[0].checked==true ) research3f(main, 2, 2, 2, 5, 2, 1); else initf(main, 2, 2, 2, 5);
		if( main.q1_4_1[1].checked==true ) research3f(main, 4, 2, 2, 7, 4, 1); else initf(main, 4, 2, 2, 7);
		if( main.q1_8_1[1].checked==true ) research3f(main, 8, 2, 2, 7, 8, 1); else initf(main, 8, 2, 2, 7);
		if( main.q1_12_1[1].checked==true ) research3f(main, 12, 2, 2, 7, 12, 1); else initf(main, 12, 2, 2, 7);
		if( main.q1_16_1[1].checked==true ) research3f(main, 16, 2, 2, 7, 16, 1); else initf(main, 16, 2, 2, 7);
		if( main.q1_18_1[0].checked==true ) research3f(main, 18, 2, 2, 4, 18, 1); else initf(main, 18, 2, 2, 4);
		if( main.q1_20_1[1].checked==true ) research3f(main, 20, 2, 2, 7, 20, 1); else initf(main, 20, 2, 2, 7);
		if( main.q1_21_1[0].checked==true ) research3f(main, 21, 2, 2, 5, 21, 1); else initf(main, 21, 2, 2, 5);
		if( main.q1_22_1[0].checked==true ) research3f(main, 22, 2, 2, 4, 22, 1); else initf(main, 22, 2, 2, 4);
		if( main.q1_22_1[0].checked==true ) research3f(main, 23, 1, 2, 3, 22, 1); else initf(main, 23, 1, 2, 3);
		if( main.q1_23_1[0].checked==true || main.q1_23_1[1].checked==true ) research3f(main, 23, 2, 2, 6, 23, 1); else initf(main, 23, 2, 2, 6);
		if( main.q1_23_1[2].checked==true ) research3f(main, 23, 3, 2, 6, 23, 1); else initf(main, 23, 3, 2, 6);
		if( main.q1_25_1[0].checked==true ) research3f(main, 25, 2, 3, 9, 25, 1); else initf(main, 25, 2, 3, 9);
		if( main.q1_26_1[0].checked==true ) research3f(main, 26, 2, 3, 9, 26, 1); else initf(main, 26, 2, 3, 9);
		if( main.q1_29_1[0].checked==true || main.q1_29_1[1].checked==true || main.q1_29_1[2].checked==true ) research3f(main, 29, 2, 2, 3, 29, 1); else initf(main, 29, 2, 2, 3);
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
				eval("msg=msg+'조사표의 "+fno+"번의 ("+sno+")번을 입력하여 주십시오.'");
			} else {
				eval("msg=msg+'조사표의 "+fno+"번의 ("+sno+")번을 선택하여 주십시오.'");
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
			<h1 class="contenttitle">신규 도입 제도 관련 하도급거래 설문조사</h1>
			<!-- title end -->
			
			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="width:920px;">
				<!--내부망 날짜 수정-->
					<li class="boxcontenttitle"><span>◇ </span>공정거래위원회는 원사업자(위탁을 한 사업자)의 불공정한 하도급거래 행위를 개선하고 수급사업자(위탁을 받은 사업자)를 보호하기 위해 최근 「하도급거래 공정화에 관한 법률」에 ①3개 손해배상제도 확대, ②중소기업 협동조합에 납품단가조정협의권 부여, ③부당한 특약을 금지하는 제도를 도입하여 시행 중에 있습니다.</li>
					<li class="boxcontenttitle"><span>◇ </span>공정위는 새로 도입된 제도가 현장에서 수급사업자에게 실제로 도움이 되고 있는지 여부를 파악하고, 필요한 경우 제도적 보완사항 등을 마련하기 위해 수급사업자(이하 ‘귀사’라 함)를 대상으로 본 설문조사를 실시하오니 바쁘시더라도 꼭 응답하여 주시기 바랍니다. </li>
					<li class="boxcontenttitle"><span>◇ </span>본 설문조사에 대한 응답은 귀사의 전반적인 현황을 잘 파악하고 계신 대표 또는 영업담당 부서의 임직원께서 입력하여 주시면 감사하겠습니다. 설문참여 방법은 설문문항이 있는 웹 사이트(<a href="http://hado.ftc.go.kr/poll/">http://hado.ftc.go.kr/poll/</a>)에 접속하셔서, <font color="#FF0066">2014.7.17.(목)</font>까지 입력 후 전송하여 주시면 됩니다.</li>
					<li class="boxcontenttitle">※ 참고로 본 설문조사는 우리 공정위가 매년 실시하고 있는 하도급거래 서면실태조사와는 다른 것임을 알려드립니다. (14년 하도급거래 서면실태조사는 올해 하반기에 별도 실시 예정)</li>
					<li class="boxcontenttitle"><span>◇ </span>귀사가 응답해 주신 내용은 통계법 제33조(비밀의 보호)에 따라 비밀이 보장되므로 안심하시고 작성하여 주시기 바랍니다. </li>
					<li class="boxcontenttitle"><span>◇ </span>본 설문과 관련하여 문의사항이 있을 경우에는 아래 담당자에게 연락하여 주시기 바랍니다.</li>
					<li class="boxcontenttitle">ㅇ (담당자) 공정위 기업거래정책과 송명현 사무관   (Tel) : 044-200-4588</li>
				</ul>
			</div>
			
			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">◆ 업체현황</a></li>
						</ul>
					</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">- 귀사의 현황</li>
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
										<th>사업기간</th>
										<td>약 <input type="text" name="oBussTerm" value="<%=sBussTerm%>"  maxlength="3" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';" style="width:100px;text-align:right;"> 년</td>
										<th>지역</th>
										<td>
											<input type="radio" name="oAreaCD" value="1" <%if(sAreaCD.equals("1")){out.print("checked");}%>>① 수도권(서울ㆍ경기ㆍ인천)<br/>
											<input type="radio" name="oAreaCD" value="2" <%if(sAreaCD.equals("2")){out.print("checked");}%>>② 비수도권
										</td>
									</tr>
									<tr>
										<th>업종</th>
										<td>
											<input type="radio" name="oSentType" value="1" <%if(sSentType.equals("1")){out.print("checked");}%>>① 제조업 (아래 세부업종 체크)<br/>
											<input type="radio" name="oSentType" value="2" <%if(sSentType.equals("2")){out.print("checked");}%>>② 건설업<br/>
											<input type="radio" name="oSentType" value="3" <%if(sSentType.equals("3")){out.print("checked");}%>>③ 용역업 (S/W, 광고 등)
										</td>
										<th>하도급<br/>거래단계</th>
										<td>
											<input type="radio" name="oSubconStep" value="1" <%if(sSubconStep.equals("1")){out.print("checked");}%>>① 1차 거래단계 (주로 1차 협력사인 경우)<br/>
											<input type="radio" name="oSubconStep" value="2" <%if(sSubconStep.equals("2")){out.print("checked");}%>>② 2차 거래단계 (주로 2차 협력사인 경우)<br/>
											<input type="radio" name="oSubconStep" value="3" <%if(sSubconStep.equals("3")){out.print("checked");}%>>③ 3차 이하 거래단계 (주로 3차 이하 협력사인 경우)<br/>
											<input type="radio" name="oSubconStep" value="4" <%if(sSubconStep.equals("4")){out.print("checked");}%>>④ 구분이 곤란한 경우
										</td>
									</tr>
									<tr>
										<th>세부업종<br/>(제조업)</th>
										<td colspan="3">
											<input type="radio" name="oDetailCD" value="1" <%if(sDetailCD.equals("1")){out.print("checked");}%>>① 기계ㆍ기계장비ㆍ금속&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="2" <%if(sDetailCD.equals("2")){out.print("checked");}%>>② 전기ㆍ전자ㆍ정밀&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="3" <%if(sDetailCD.equals("3")){out.print("checked");}%>>③ 석유화학ㆍ고무ㆍ플라스틱<br/>
											<input type="radio" name="oDetailCD" value="4" <%if(sDetailCD.equals("4")){out.print("checked");}%>>④ 섬유ㆍ의복ㆍ가죽&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="5" <%if(sDetailCD.equals("5")){out.print("checked");}%>>⑤ 목재·종이·인쇄&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="6" <%if(sDetailCD.equals("6")){out.print("checked");}%>>⑥ 식료품ㆍ음료<br/>
											<input type="radio" name="oDetailCD" value="7" <%if(sDetailCD.equals("7")){out.print("checked");}%>>⑦ 자동차ㆍ조선ㆍ기타 운송장비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="8" <%if(sDetailCD.equals("8")){out.print("checked");}%>>⑧ 비금속&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="9" <%if(sDetailCD.equals("9")){out.print("checked");}%>>⑨ 철강&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="10" <%if(sDetailCD.equals("10")){out.print("checked");}%>>⑩ 기타
										</td>
									</tr>	
									<tr>
										<th>매출액</th>
										<td>
											2013년도 <input type="text" name="oSentSale" value="<%=sSentSale%>"  maxlength="6" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"  onkeyup ="sukeyup(this);ohapf(this.form);" style="width:100px;text-align:right;"> <font color="#FF0066"><b>억원</b></font>
										</td>
										<th>상시<br/>종업원수</th>
										<td>
											2013년도 약 <input type="text" name="oEmpCnt" value="<%=sEmpCnt%>"  maxlength="6" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"  onkeyup ="sukeyup(this);ohapf(this.form);" style="width:100px;text-align:right;"> 명
										</td>
									</tr>
								</tbody>
							</table>
						</li>
					</ul>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_2"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">- (귀사가 거래하고 있는) 원사업자의 회사 규모</li>
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
										<th>원사업자의<br/>회사 규모</th>
										<td colspan="3">
											<input type="radio" name="oCapaCD" value="1" <%if(sCapaCD.equals("1")){out.print("checked");}%>>① 대기업 (귀사가 거래하고 있는 원사업자 중 대기업이 많은 경우)<br/>
											<input type="radio" name="oCapaCD" value="2" <%if(sCapaCD.equals("2")){out.print("checked");}%>>② 중견기업 (귀사가 거래하고 있는 원사업자 중 중견기업이 많은 경우)<br/>
											<input type="radio" name="oCapaCD" value="3" <%if(sCapaCD.equals("3")){out.print("checked");}%>>③ 중소기업 (귀사가 거래하고 있는 원사업자 중 중소기업이 많은 경우)
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
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">Ⅰ. 3배 손해배상제도 관련</a></li>
						</ul>
					</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="width:920px;">
					<li class="boxcontenttitle"><참고> 3배 손해배상제도 확대도입 (2013.11.29. 이후 발생하는 위반행위 부터 적용)</li>
					<li class="boxcontenttitle">: 대기업 등 원사업자의 불공정행위에 대한 억지력 제고와 중소기업 피해에 대한 충실한 보상을 위하여 3배 손해배상 적용대상을 확대</li>
					<li class="boxcontenttitle">&nbsp;&nbsp;&nbsp;&nbsp;※ (종전) 기술유용 → (개정) 부당한 하도급대금 결정, 부당감액, 부당한 발주취소, 부당반품, 기술유용</li>
				</ul>
			</div>
			
			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b><부당한 하도급대금(단가) 결정></b></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>1. </span>귀사는 3배 손해배상제도가 확대 도입(2013.11.29.)되기 전에, 원사업자가 귀사와 상호 합의 없이 부당하게 일반적으로 지급되는 대가보다 낮은 금액으로 하도급대금을 결정한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_1_1" value="<%=setHiddenValue(qa, 1, 1, 2)%>">
						<li><input type="radio" name="q1_1_1" value="1" <%if(qa[1][1][1]!=null && qa[1][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);">① 있었음</li>
						<li><input type="radio" name="q1_1_1" value="2" <%if(qa[1][1][2]!=null && qa[1][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>2. </span>귀사는 3배 손해배상제도가 확대 도입된 2013.11.29. 이후, 원사업자가 귀사와 상호 합의 없이 부당하게 일반적으로 지급되는 대가보다 낮은 금액으로 하도급대금을 결정한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_2_1" value="<%=setHiddenValue(qa, 2, 1, 2)%>">
						<li><input type="radio" name="q1_2_1" value="1" <%if(qa[2][1][1]!=null && qa[2][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);">① 있었음</li>
						<li><input type="radio" name="q1_2_1" value="2" <%if(qa[2][1][2]!=null && qa[2][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>2-1. </span><font color="blue"><문2에서 있었다(①)고 응답한 경우만 답변></font> 원사업자가 부당하게 하도급대금을 결정한 경우 평균 단가 인하율은 어느 정도 수준입니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_2_2" value="<%=setHiddenValue(qa, 2, 2, 5)%>">
						<li><input type="radio" name="q1_2_2" value="1" <%if(qa[2][2][1]!=null && qa[2][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(2,2);">① 5% 미만</li>
						<li><input type="radio" name="q1_2_2" value="2" <%if(qa[2][2][2]!=null && qa[2][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(2,2);">② 5～10% 미만</li>
						<li><input type="radio" name="q1_2_2" value="3" <%if(qa[2][2][3]!=null && qa[2][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(2,2);">③ 10～20% 미만</li>
						<li><input type="radio" name="q1_2_2" value="4" <%if(qa[2][2][4]!=null && qa[2][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(2,2);">④ 20～30% 미만</li>
						<li><input type="radio" name="q1_2_2" value="5" <%if(qa[2][2][5]!=null && qa[2][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(2,2);">⑤ 30% 이상</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>3. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후 그 전과 비교하여, 원사업자가 귀사와 상호 합의 없이 부당하게 하도급대금을 결정하는 불공정 행위가 어느 정도 개선되고 있다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_3_1" value="<%=setHiddenValue(qa, 3, 1, 5)%>">
						<li><input type="radio" name="q1_3_1" value="1" <%if(qa[3][1][1]!=null && qa[3][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);">① 많이 개선되고 있다</li>
						<li><input type="radio" name="q1_3_1" value="2" <%if(qa[3][1][2]!=null && qa[3][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);">② 약간 개선되고 있다</li>
						<li><input type="radio" name="q1_3_1" value="3" <%if(qa[3][1][3]!=null && qa[3][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);">③ 비슷하다</li>
						<li><input type="radio" name="q1_3_1" value="4" <%if(qa[3][1][4]!=null && qa[3][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);">④ 약간 악화되고 있다</li>
						<li><input type="radio" name="q1_3_1" value="5" <%if(qa[3][1][5]!=null && qa[3][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);">⑤ 매우 악화되고 있다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>		

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>4. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후 발생한 원사업자의 부당한 하도급 대금 결정 행위와 관련하여 원사업자를 상대로 하여 법원에 3배 손해배상 소송을 제기한 경험이 있으십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_4_1" value="<%=setHiddenValue(qa, 4, 1, 2)%>">
						<li><input type="radio" name="q1_4_1" value="1" <%if(qa[4][1][1]!=null && qa[4][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);">① 있었음</li>
						<li><input type="radio" name="q1_4_1" value="2" <%if(qa[4][1][2]!=null && qa[4][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>		

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>4-1. </span><font color="blue"><문4에서 없었다(②)고 응답한 경우만 답변></font> 귀사가 원사업자의 부당한 하도급대금 결정 행위에 대해 3배 손해배상 소송을 제기하지 않은 이유는 무엇입니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_4_2" value="<%=setHiddenValue(qa, 4, 2, 7)%>">
						<li><input type="radio" name="q1_4_2" value="1" <%if(qa[4][2][1]!=null && qa[4][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(4,2);">① 원사업자가 부당하게 하도급대금을 결정한 경우가 없기 때문</li>
						<li><input type="radio" name="q1_4_2" value="2" <%if(qa[4][2][2]!=null && qa[4][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(4,2);">② 3배 손해배상 소송을 제기할 만큼 피해가 크지 않기 때문</li>
						<li><input type="radio" name="q1_4_2" value="3" <%if(qa[4][2][3]!=null && qa[4][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(4,2);">③ 증거자료 부족 등으로 소송에서 승소할 가능성이 적기 때문</li>
						<li><input type="radio" name="q1_4_2" value="4" <%if(qa[4][2][4]!=null && qa[4][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(4,2);">④ 거래량 축소, 거래 단절 등 불이익이 우려되기 때문</li>
						<li><input type="radio" name="q1_4_2" value="5" <%if(qa[4][2][5]!=null && qa[4][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(4,2);">⑤ 3배 손해배상 소송을 위한 소송비용 등이 부담되기 때문</li>
						<li><input type="radio" name="q1_4_2" value="6" <%if(qa[4][2][6]!=null && qa[4][2][6].equals("1")){out.print("checked");}%> onclick="checkradio(4,2);">⑥ 현재 3배 손해배상 소송 제기 여부를 검토 중인 단계이기 때문</li>
						<li><input type="radio" name="q1_4_2" value="7" <%if(qa[4][2][7]!=null && qa[4][2][7].equals("1")){out.print("checked");}%> onclick="checkradio(4,2);">⑦ 기타 (
							<input type="text" name="q1_4_4" value="<%=qa[4][4][20]%>"  maxlength="50" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';" style="width:200px;text-align:right;"> )
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>


			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b><부당한 하도급대금(단가) 감액></b></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>


			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>5. </span>귀사는 3배 손해배상제도가 확대 도입(2013.11.29.)되기 전에, 정당한 사유가 없음에도 불구하고 원사업자로부터 위탁을 받았을 때 정했던 금액보다 적게 하도급대금을 지급받은 경우가 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_5_1" value="<%=setHiddenValue(qa, 5, 1, 2)%>">
						<li><input type="radio" name="q1_5_1" value="1" <%if(qa[5][1][1]!=null && qa[5][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);">① 있었음</li>
						<li><input type="radio" name="q1_5_1" value="2" <%if(qa[5][1][2]!=null && qa[5][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>	

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>6. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후, 정당한 사유가 없음에도 불구하고 원사업자로부터 위탁을 받았을 때 정했던 금액보다 적게 하도급대금을 지급받은 경우가 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_6_1" value="<%=setHiddenValue(qa, 6, 1, 2)%>">
						<li><input type="radio" name="q1_6_1" value="1" <%if(qa[6][1][1]!=null && qa[6][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(6,1);">① 있었음</li>
						<li><input type="radio" name="q1_6_1" value="2" <%if(qa[6][1][2]!=null && qa[6][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(6,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>	

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>7. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후 그 전과 비교하여, 원사업자가 정당한 사유가 없음에도 불구하고 위탁을 받았을 때 정했던 금액보다 적게 하도급대금을 지급하는 불공정 행위가 어느 정도 개선되고 있다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_7_1" value="<%=setHiddenValue(qa, 7, 1, 5)%>">
						<li><input type="radio" name="q1_7_1" value="1" <%if(qa[7][1][1]!=null && qa[7][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);">① 많이 개선되고 있다</li>
						<li><input type="radio" name="q1_7_1" value="2" <%if(qa[7][1][2]!=null && qa[7][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);">② 약간 개선되고 있다</li>
						<li><input type="radio" name="q1_7_1" value="3" <%if(qa[7][1][3]!=null && qa[7][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);">③ 비슷하다</li>
						<li><input type="radio" name="q1_7_1" value="4" <%if(qa[7][1][4]!=null && qa[7][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);">④ 약간 악화되고 있다</li>
						<li><input type="radio" name="q1_7_1" value="5" <%if(qa[7][1][5]!=null && qa[7][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);">⑤ 매우 악화되고 있다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>	

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>8. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후 발생한 원사업자의 부당한 하도급 대금 감액 행위와 관련하여 원사업자를 상대로 하여 법원에 3배 손해배상 소송을 제기한 경험이 있으십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_8_1" value="<%=setHiddenValue(qa, 8, 1, 2)%>">
						<li><input type="radio" name="q1_8_1" value="1" <%if(qa[8][1][1]!=null && qa[8][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);">① 있었음</li>
						<li><input type="radio" name="q1_8_1" value="2" <%if(qa[8][1][2]!=null && qa[8][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>	

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>8-1. </span><font color="blue"><문8에서 없었다(②)고 응답한 경우만 답변></font> 귀사가 원사업자의 부당한 하도급대금 감액 행위에 대해 3배 손해배상 소송을 제기하지 않은 이유는 무엇입니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_8_2" value="<%=setHiddenValue(qa, 8, 2, 7)%>">
						<li><input type="radio" name="q1_8_2" value="1" <%if(qa[8][2][1]!=null && qa[8][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(8,2);">① 원사업자가 부당하게 하도급대금을 감액한 경우가 없기 때문</li>
						<li><input type="radio" name="q1_8_2" value="2" <%if(qa[8][2][2]!=null && qa[8][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(8,2);">② 3배 손해배상 소송을 제기할 만큼 피해가 크지 않기 때문</li>
						<li><input type="radio" name="q1_8_2" value="3" <%if(qa[8][2][3]!=null && qa[8][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(8,2);">③ 증거자료 부족 등으로 소송에서 승소할 가능성이 적기 때문</li>
						<li><input type="radio" name="q1_8_2" value="4" <%if(qa[8][2][4]!=null && qa[8][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(8,2);">④ 거래량 축소, 거래 단절 등 불이익이 우려되기 때문</li>
						<li><input type="radio" name="q1_8_2" value="5" <%if(qa[8][2][5]!=null && qa[8][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(8,2);">⑤ 3배 손해배상 소송을 위한 소송비용 등이 부담되기 때문</li>
						<li><input type="radio" name="q1_8_2" value="6" <%if(qa[8][2][6]!=null && qa[8][2][6].equals("1")){out.print("checked");}%> onclick="checkradio(8,2);">⑥ 현재 3배 손해배상 소송 제기 여부를 검토 중인 단계이기 때문</li>
						<li><input type="radio" name="q1_8_2" value="7" <%if(qa[8][2][7]!=null && qa[8][2][7].equals("1")){out.print("checked");}%> onclick="checkradio(8,2);">⑦ 기타 (
							<input type="text" name="q1_8_4" value="<%=qa[8][4][20]%>"  maxlength="50" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';" style="width:200px;text-align:right;"> )
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b><부당한 발주취소(수령거부를 포함)></b></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>9. </span>귀사는 3배 손해배상제도가 확대 도입(2013.11.29.)되기 전에, 귀사의 귀책사유가 없음에도 불구하고 원사업자가 하도급 계약을 일방적으로 취소하거나 위탁한 목적물을 수령하지 않은 경우가 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_9_1" value="<%=setHiddenValue(qa, 9, 1, 2)%>">
						<li><input type="radio" name="q1_9_1" value="1" <%if(qa[9][1][1]!=null && qa[9][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);">① 있었음</li>
						<li><input type="radio" name="q1_9_1" value="2" <%if(qa[9][1][2]!=null && qa[9][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>	

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>10. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후, 귀사의 귀책사유가 없음에도 불구하고 원사업자가 일방적으로 하도급 계약을 취소하거나 위탁한 목적물을 수령하지 않은  경우가 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_10_1" value="<%=setHiddenValue(qa, 10, 1, 2)%>">
						<li><input type="radio" name="q1_10_1" value="1" <%if(qa[10][1][1]!=null && qa[10][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);">① 있었음</li>
						<li><input type="radio" name="q1_10_1" value="2" <%if(qa[10][1][2]!=null && qa[10][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후 그 전과 비교하여, 원사업자가 귀사의 귀책사유가 없음에도 불구하고 일방적으로 하도급 계약을 취소하거나 위탁한 목적물을 수령하지 않는 불공정 행위가 어느 정도 개선되고 있다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_11_1" value="<%=setHiddenValue(qa, 11, 1, 5)%>">
						<li><input type="radio" name="q1_11_1" value="1" <%if(qa[11][1][1]!=null && qa[11][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);">① 많이 개선되고 있다</li>
						<li><input type="radio" name="q1_11_1" value="2" <%if(qa[11][1][2]!=null && qa[11][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);">② 약간 개선되고 있다</li>
						<li><input type="radio" name="q1_11_1" value="3" <%if(qa[11][1][3]!=null && qa[11][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);">③ 비슷하다</li>
						<li><input type="radio" name="q1_11_1" value="4" <%if(qa[11][1][4]!=null && qa[11][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);">④ 약간 악화되고 있다</li>
						<li><input type="radio" name="q1_11_1" value="5" <%if(qa[11][1][5]!=null && qa[11][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);">⑤ 매우 악화되고 있다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>12. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후 발생한 원사업자의 부당한 발주취소(수령거부를 포함) 행위와 관련하여 원사업자를 상대로 하여 법원에 3배 손해배상 소송을 제기한 경험이 있으십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_12_1" value="<%=setHiddenValue(qa, 12, 1, 2)%>">
						<li><input type="radio" name="q1_12_1" value="1" <%if(qa[12][1][1]!=null && qa[12][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);">① 있었음</li>
						<li><input type="radio" name="q1_12_1" value="2" <%if(qa[12][1][2]!=null && qa[12][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>12-1. </span><font color="blue"><문12에서 없었다(②)고 응답한 경우만 답변></font> 귀사가 원사업자의 부당한 발주취소(수령거부를 포함) 행위에 대해 3배 손해배상 소송을 제기하지 않은 이유는 무엇입니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_12_2" value="<%=setHiddenValue(qa, 12, 2, 7)%>">
						<li><input type="radio" name="q1_12_2" value="1" <%if(qa[12][2][1]!=null && qa[12][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,2);">① 원사업자가 부당하게 발주를 취소한 경우가 없기 때문</li>
						<li><input type="radio" name="q1_12_2" value="2" <%if(qa[12][2][2]!=null && qa[12][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,2);">② 3배 손해배상 소송을 제기할 만큼 피해가 크지 않기 때문</li>
						<li><input type="radio" name="q1_12_2" value="3" <%if(qa[12][2][3]!=null && qa[12][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,2);">③ 증거자료 부족 등으로 소송에서 승소할 가능성이 적기 때문</li>
						<li><input type="radio" name="q1_12_2" value="4" <%if(qa[12][2][4]!=null && qa[12][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,2);">④ 거래량 축소, 거래 단절 등 불이익이 우려되기 때문</li>
						<li><input type="radio" name="q1_12_2" value="5" <%if(qa[12][2][5]!=null && qa[12][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,2);">⑤ 3배 손해배상 소송을 위한 소송비용 등이 부담되기 때문</li>
						<li><input type="radio" name="q1_12_2" value="6" <%if(qa[12][2][6]!=null && qa[12][2][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,2);">⑥ 현재 3배 손해배상 소송 제기 여부를 검토 중인 단계이기 때문</li>
						<li><input type="radio" name="q1_12_2" value="7" <%if(qa[12][2][7]!=null && qa[12][2][7].equals("1")){out.print("checked");}%> onclick="checkradio(12,2);">⑦ 기타 (
							<input type="text" name="q1_12_4" value="<%=qa[12][4][20]%>"  maxlength="50" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';" style="width:200px;text-align:right;"> )
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b><부당반품></b></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>13. </span>귀사는 3배 손해배상제도가 확대 도입(2013.11.29.)되기 전에, 귀사의 귀책사유가 없음에도 불구하고 원사업자가 목적물의 납품 등을 받은 후 반품한 경우가 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_13_1" value="<%=setHiddenValue(qa, 13, 1, 2)%>">
						<li><input type="radio" name="q1_13_1" value="1" <%if(qa[13][1][1]!=null && qa[13][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);">① 있었음</li>
						<li><input type="radio" name="q1_13_1" value="2" <%if(qa[13][1][2]!=null && qa[13][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>14. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후, 귀사의 귀책사유가 없음에도 불구하고 원사업자가 목적물의 납품 등을 받은 후 반품한 경우가 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_14_1" value="<%=setHiddenValue(qa, 14, 1, 2)%>">
						<li><input type="radio" name="q1_14_1" value="1" <%if(qa[14][1][1]!=null && qa[14][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);">① 있었음</li>
						<li><input type="radio" name="q1_14_1" value="2" <%if(qa[14][1][2]!=null && qa[14][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>15. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후 그 전과 비교하여, 원사업자가 귀사의 귀책사유가 없음에도 불구하고 목적물을 반품하는 불공정 행위가 어느 정도 개선되고 있다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_15_1" value="<%=setHiddenValue(qa, 15, 1, 5)%>">
						<li><input type="radio" name="q1_15_1" value="1" <%if(qa[15][1][1]!=null && qa[15][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);">① 많이 개선되고 있다</li>
						<li><input type="radio" name="q1_15_1" value="2" <%if(qa[15][1][2]!=null && qa[15][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);">② 약간 개선되고 있다</li>
						<li><input type="radio" name="q1_15_1" value="3" <%if(qa[15][1][3]!=null && qa[15][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);">③ 비슷하다</li>
						<li><input type="radio" name="q1_15_1" value="4" <%if(qa[15][1][4]!=null && qa[15][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);">④ 약간 악화되고 있다</li>
						<li><input type="radio" name="q1_15_1" value="5" <%if(qa[15][1][5]!=null && qa[15][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);">⑤ 매우 악화되고 있다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>16. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후 발생한 원사업자의 부당반품 행위와 관련하여 원사업자를 상대로 하여 법원에 3배 손해배상 소송을 제기한 경험이 있으십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_16_1" value="<%=setHiddenValue(qa, 16, 1, 2)%>">
						<li><input type="radio" name="q1_16_1" value="1" <%if(qa[16][1][1]!=null && qa[16][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);">① 있었음</li>
						<li><input type="radio" name="q1_16_1" value="2" <%if(qa[16][1][2]!=null && qa[16][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>16-1. </span><font color="blue"><문16에서 없었다(②)고 응답한 경우만 답변></font> 귀사가 원사업자의 부당반품 행위에 대해 3배 손해배상 소송을 제기하지 않은 이유는 무엇입니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_16_2" value="<%=setHiddenValue(qa, 16, 2, 7)%>">
						<li><input type="radio" name="q1_16_2" value="1" <%if(qa[16][2][1]!=null && qa[16][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,2);">① 원사업자가 부당하게 반품한 경우가 없기 때문</li>
						<li><input type="radio" name="q1_16_2" value="2" <%if(qa[16][2][2]!=null && qa[16][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,2);">② 3배 손해배상 소송을 제기할 만큼 피해가 크지 않기 때문</li>
						<li><input type="radio" name="q1_16_2" value="3" <%if(qa[16][2][3]!=null && qa[16][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(16,2);">③ 증거자료 부족 등으로 소송에서 승소할 가능성이 적기 때문</li>
						<li><input type="radio" name="q1_16_2" value="4" <%if(qa[16][2][4]!=null && qa[16][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(16,2);">④ 거래량 축소, 거래 단절 등 불이익이 우려되기 때문</li>
						<li><input type="radio" name="q1_16_2" value="5" <%if(qa[16][2][5]!=null && qa[16][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(16,2);">⑤ 3배 손해배상 소송을 위한 소송비용 등이 부담되기 때문</li>
						<li><input type="radio" name="q1_16_2" value="6" <%if(qa[16][2][6]!=null && qa[16][2][6].equals("1")){out.print("checked");}%> onclick="checkradio(16,2);">⑥ 현재 3배 손해배상 소송 제기 여부를 검토 중인 단계이기 때문</li>
						<li><input type="radio" name="q1_16_2" value="7" <%if(qa[16][2][7]!=null && qa[16][2][7].equals("1")){out.print("checked");}%> onclick="checkradio(16,2);">⑦ 기타 (
							<input type="text" name="q1_16_4" value="<%=qa[16][4][20]%>"  maxlength="50" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"  style="width:200px;text-align:right;"> )
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b><기술유용></b></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>17. </span>귀사는 3배 손해배상제도가 확대 도입(2013.11.29.)되기 전에, 원사업자가 귀사로부터 취득한 기술자료를 합의된 사용 범위를 벗어나 원사업자 또는 제3자의 이익을 위해 사용함으로써 귀사에게 손해가 발생한 경험이 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_17_1" value="<%=setHiddenValue(qa, 17, 1, 2)%>">
						<li><input type="radio" name="q1_17_1" value="1" <%if(qa[17][1][1]!=null && qa[17][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);">① 있었음</li>
						<li><input type="radio" name="q1_17_1" value="2" <%if(qa[17][1][2]!=null && qa[17][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후, 원사업자가 귀사로부터 취득한 기술자료를 합의된 사용 범위를 벗어나 원사업자 또는 제3자의 이익을 위해 사용함으로써 귀사에게 손해가 발생한 경험이 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_18_1" value="<%=setHiddenValue(qa, 18, 1, 2)%>">
						<li><input type="radio" name="q1_18_1" value="1" <%if(qa[18][1][1]!=null && qa[18][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);">① 있었음</li>
						<li><input type="radio" name="q1_18_1" value="2" <%if(qa[18][1][2]!=null && qa[18][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18-1. </span><font color="blue"><문18에서 있었다(①)고 응답한 경우만 답변></font> 원사업자가 귀사로부터 기술자료를 취득할 당시 요구목적, 비밀유지에 관한 사항, 권리귀속 관계, 기술자료의 대가 및 지급방법 등에 대해 귀사와 사전협의를 하고 그 내용이 기재된 서면을 귀사에게 주었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_18_2" value="<%=setHiddenValue(qa, 18, 2, 4)%>">
						<li><input type="radio" name="q1_18_2" value="1" <%if(qa[18][2][1]!=null && qa[18][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,2);">① 사전협의를 하고 요구 목적 등이 기재된 서면을 주었음</li>
						<li><input type="radio" name="q1_18_2" value="2" <%if(qa[18][2][2]!=null && qa[18][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,2);">② 사전협의를 하였으나 요구 목적 등이 기재된 서면은 주지 않았음</li>
						<li><input type="radio" name="q1_18_2" value="3" <%if(qa[18][2][3]!=null && qa[18][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(18,2);">③ 사전협의 없이 원사업자가 일방적으로 작성한 서면을 주었음</li>
						<li><input type="radio" name="q1_18_2" value="4" <%if(qa[18][2][4]!=null && qa[18][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(18,2);">④ 사전협의 없이 원사업자가 일방적으로 구두로 요구하고 서면도 주지 않았음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>19. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후 그 전과 비교하여, 원사업자가 귀사로부터 취득한 기술자료를 합의된 사용 범위를 벗어나 원사업자 또는 제3자의 이익을 위해 사용하는 불공정행위가 어느 정도 개선되고 있다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_19_1" value="<%=setHiddenValue(qa, 19, 1, 5)%>">
						<li><input type="radio" name="q1_19_1" value="1" <%if(qa[19][1][1]!=null && qa[19][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">① 많이 개선되고 있다</li>
						<li><input type="radio" name="q1_19_1" value="2" <%if(qa[19][1][2]!=null && qa[19][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">② 약간 개선되고 있다</li>
						<li><input type="radio" name="q1_19_1" value="3" <%if(qa[19][1][3]!=null && qa[19][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">③ 비슷하다</li>
						<li><input type="radio" name="q1_19_1" value="4" <%if(qa[19][1][4]!=null && qa[19][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">④ 약간 악화되고 있다</li>
						<li><input type="radio" name="q1_19_1" value="5" <%if(qa[19][1][5]!=null && qa[19][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">⑤ 매우 악화되고 있다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>20. </span>귀사는 3배 손해배상제도가 확대 시행된 2013.11.29. 이후 발생한 원사업자의 기술유용 행위와 관련하여 원사업자를 상대로 하여 법원에 3배 손해배상 소송을 제기한 경험이 있으십니까? </li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_20_1" value="<%=setHiddenValue(qa, 20, 1, 2)%>">
						<li><input type="radio" name="q1_20_1" value="1" <%if(qa[20][1][1]!=null && qa[20][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);">① 있었음</li>
						<li><input type="radio" name="q1_20_1" value="2" <%if(qa[20][1][2]!=null && qa[20][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>20-1. </span><font color="blue"><문20에서 없었다(②)고 응답한 경우만 답변></font> 귀사가 원사업자의 기술유용 행위에 대해 3배 손해배상 소송을 제기하지 않은 이유는 무엇입니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_20_2" value="<%=setHiddenValue(qa, 20, 2, 7)%>">
						<li><input type="radio" name="q1_20_2" value="1" <%if(qa[20][2][1]!=null && qa[20][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,2);">① 원사업자가 귀사의 기술을 유용한 경우가 없기 때문</li>
						<li><input type="radio" name="q1_20_2" value="2" <%if(qa[20][2][2]!=null && qa[20][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,2);">② 3배 손해배상 소송을 제기할 만큼 피해가 크지 않기 때문</li>
						<li><input type="radio" name="q1_20_2" value="3" <%if(qa[20][2][3]!=null && qa[20][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(20,2);">③ 증거자료 부족 등으로 소송에서 승소할 가능성이 적기 때문</li>
						<li><input type="radio" name="q1_20_2" value="4" <%if(qa[20][2][4]!=null && qa[20][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(20,2);">④ 거래량 축소, 거래 단절 등 불이익이 우려되기 때문</li>
						<li><input type="radio" name="q1_20_2" value="5" <%if(qa[20][2][5]!=null && qa[20][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(20,2);">⑤ 3배 손해배상 소송을 위한 소송비용 등이 부담되기 때문</li>
						<li><input type="radio" name="q1_20_2" value="6" <%if(qa[20][2][6]!=null && qa[20][2][6].equals("1")){out.print("checked");}%> onclick="checkradio(20,2);">⑥ 현재 3배 손해배상 소송 제기 여부를 검토 중인 단계이기 때문</li>
						<li><input type="radio" name="q1_20_2" value="7" <%if(qa[20][2][7]!=null && qa[20][2][7].equals("1")){out.print("checked");}%> onclick="checkradio(20,2);">⑦ 기타 (
							<input type="text" name="q1_20_4" value="<%=qa[20][4][20]%>"  maxlength="50" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';" style="width:200px;text-align:right;"> )
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">Ⅱ. 중기조합의 납품단가 조정협의권 관련</a></li>
						</ul>
					</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="width:920px;">
					<li class="boxcontenttitle"><참고> 중소기업 협동조합에 납품단가 조정협의권 부여 (2013.11.29 시행)</li>
					<li class="boxcontenttitle">: 원재료 가격 변동으로 인한 납품단가 조정의 실효성 제고 및 하도급대금의 적정성 확보를 위해 하도급대금 조정협의 권한을 중소기업 <br/>&nbsp;&nbsp;협동조합에 부여</li>
					<li class="boxcontenttitle">&nbsp;&nbsp;&nbsp;&nbsp;* (종전) 조합은 원사업자에게 단가조정 협의의 신청만을 할 수 있고 수급사업자가 원사업자와 협의<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;→  (개정) 조합이 원사업자에게 단가조정 협의의 신청을 하고 조합이 원사업자와 직접 협의</li>
				</ul>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>21. </span>귀사는 중소기업 협동조합에 납품단가 조정협의권이 부여된 2013.11.29. 이후 원사업자로부터 제조 등의 위탁을 받은 후 불가피하게 하도급대금의 인상이 필요한 요인이 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_21_1" value="<%=setHiddenValue(qa, 21, 1, 2)%>">
						<li><input type="radio" name="q1_21_1" value="1" <%if(qa[21][1][1]!=null && qa[21][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);">① 있었음</li>
						<li><input type="radio" name="q1_21_1" value="2" <%if(qa[21][1][2]!=null && qa[21][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>21-1. </span><font color="blue"><문21에서 있었다(①)고 응답한 경우만 답변></font> 귀사의 하도급대금 인상요인 중 가장 큰 요인은 다음 중 무엇입니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_21_2" value="<%=setHiddenValue(qa, 21, 2, 5)%>">
						<li><input type="radio" name="q1_21_2" value="1" <%if(qa[21][2][1]!=null && qa[21][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,2);">① 인건비 인상</li>
						<li><input type="radio" name="q1_21_2" value="2" <%if(qa[21][2][2]!=null && qa[21][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,2);">② 원자재 가격 인상</li>
						<li><input type="radio" name="q1_21_2" value="3" <%if(qa[21][2][3]!=null && qa[21][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,2);">③ 광고비, 홍보비 등 판매비 인상</li>
						<li><input type="radio" name="q1_21_2" value="4" <%if(qa[21][2][4]!=null && qa[21][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,2);">④ 은행 차입금 등 금융비용 증가</li>
						<li><input type="radio" name="q1_21_2" value="5" <%if(qa[21][2][5]!=null && qa[21][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,2);">⑤ 기타 (
							<input type="text" name="q1_21_4" value="<%=qa[21][4][20]%>"  maxlength="50" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';" style="width:200px;text-align:right;"> )
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>22. </span>귀사는 중소기업 협동조합에 납품단가 조정협의권이 부여된 2013.11.29. 이후 원사업자로부터 제조 등의 위탁을 받은 후 목적물의 제조 등에 필요한 원재료의 가격이 인상된 사실이 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_22_1" value="<%=setHiddenValue(qa, 22, 1, 2)%>">
						<li><input type="radio" name="q1_22_1" value="1" <%if(qa[22][1][1]!=null && qa[22][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(22,1);">① 있었음</li>
						<li><input type="radio" name="q1_22_1" value="2" <%if(qa[22][1][2]!=null && qa[22][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(22,1);">② 없었음 (비슷하거나 하락한 경우)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>22-1. </span><font color="blue"><문22에서 있었다(①)고 응답한 경우만 답변></font> 중소기업 협동조합에 납품단가 조정협의권이 부여된 2013.11.29. 이후 현재까지 원재료 가격의 상승폭은 어느 정도였습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_22_2" value="<%=setHiddenValue(qa, 22, 2, 4)%>">
						<li><input type="radio" name="q1_22_2" value="1" <%if(qa[22][2][1]!=null && qa[22][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);">① 5% 미만</li>
						<li><input type="radio" name="q1_22_2" value="2" <%if(qa[22][2][2]!=null && qa[22][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);">② 5~10% 미만</li>
						<li><input type="radio" name="q1_22_2" value="3" <%if(qa[22][2][3]!=null && qa[22][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);">③ 10~20% 미만</li>
						<li><input type="radio" name="q1_22_2" value="4" <%if(qa[22][2][4]!=null && qa[22][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);">④ 20% 이상</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>23. </span><font color="blue"><문22에서 있었다(①)고 응답한 경우만 답변></font> 귀사는 중소기업 협동조합에 납품단가 조정협의권이 부여된 2013.11.29. 이후 원사업자에게 원재료가격 인상을 이유로 하도급대금을 인상하여 줄 것을 요청한 경우가 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_23_1" value="<%=setHiddenValue(qa, 23, 1, 3)%>">
						<li><input type="radio" name="q1_23_1" value="1" <%if(qa[23][1][1]!=null && qa[23][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(23,1);">① 당사가 원사업자에게 직접 요청한 경우가 있었음</li>
						<li><input type="radio" name="q1_23_1" value="2" <%if(qa[23][1][2]!=null && qa[23][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(23,1);">② 당사가 소속된 중소기업협동조합을 통해 요청한 경우가 있었음</li>
						<li><input type="radio" name="q1_23_1" value="3" <%if(qa[23][1][3]!=null && qa[23][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(23,1);">③ 요청하지 않았음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>23-1. </span><font color="blue"><문23에서 요청한 경우가 있었다(① 또는 ②)고 응답한 경우만 답변></font> 원사업자가 귀사의 하도급대금 인상요청에 대하여 어느 정도 수용해 주었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_23_2" value="<%=setHiddenValue(qa, 23, 2, 6)%>">
						<li><input type="radio" name="q1_23_2" value="1" <%if(qa[23][2][1]!=null && qa[23][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(23,2);">① 100% (당사가 인상 요청한 비율을 원사업자가 그대로 수용해 준 경우)</li>
						<li><input type="radio" name="q1_23_2" value="2" <%if(qa[23][2][2]!=null && qa[23][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(23,2);">② 75~100% 미만</li>
						<li><input type="radio" name="q1_23_2" value="3" <%if(qa[23][2][3]!=null && qa[23][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(23,2);">③ 50~75% 미만</li>
						<li><input type="radio" name="q1_23_2" value="4" <%if(qa[23][2][4]!=null && qa[23][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(23,2);">④ 25~50% 미만</li>
						<li><input type="radio" name="q1_23_2" value="5" <%if(qa[23][2][5]!=null && qa[23][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(23,2);">⑤ 25% 미만</li>
						<li><input type="radio" name="q1_23_2" value="6" <%if(qa[23][2][6]!=null && qa[23][2][6].equals("1")){out.print("checked");}%> onclick="checkradio(23,2);">⑥ 전혀 수용해 주지 않았음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>23-2. </span><font color="blue"><문23에서 요청하지 않았다(③)고 응답한 경우만 답변></font> 원사업자에게 하도급대금을 인상하여 줄 것을 요청하지 않은 이유는 무엇입니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_23_3" value="<%=setHiddenValue(qa, 23, 3, 6)%>">
						<li><input type="radio" name="q1_23_3" value="1" <%if(qa[23][3][1]!=null && qa[23][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(23,3);">① 원재료 가격 상승폭과 비중이 미미하여 하도급대금 조정 필요성이 없기 때문</li>
						<li><input type="radio" name="q1_23_3" value="2" <%if(qa[23][3][2]!=null && qa[23][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(23,3);">② 원사업자가 이미 조정해 주었기 때문 (계약시 기 반영 포함)</li>
						<li><input type="radio" name="q1_23_3" value="3" <%if(qa[23][3][3]!=null && qa[23][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(23,3);">③ 가격경쟁력 약화로 인한 매출감소가 우려되기 때문</li>
						<li><input type="radio" name="q1_23_3" value="4" <%if(qa[23][3][4]!=null && qa[23][3][4].equals("1")){out.print("checked");}%> onclick="checkradio(23,3);">④ 신청해도 원사업자가 조정해 주지 않을 것 같기 때문</li>
						<li><input type="radio" name="q1_23_3" value="5" <%if(qa[23][3][5]!=null && qa[23][3][5].equals("1")){out.print("checked");}%> onclick="checkradio(23,3);">⑤ 거래량 축소, 거래 단절 등 원사업자로부터 보복이 우려되기 때문</li>
						<li><input type="radio" name="q1_23_3" value="6" <%if(qa[23][3][6]!=null && qa[23][3][6].equals("1")){out.print("checked");}%> onclick="checkradio(23,3);">⑥ 기타 (
							<input type="text" name="q1_23_4" value="<%=qa[23][4][20]%>"  maxlength="50" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';" style="width:200px;text-align:right;"> )
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>24. </span>귀사는 중소기업 협동조합에 납품단가 조정협의권이 부여된 2013.11.29. 이후 그 전과 비교하여, 원재료 가격인상으로 인해 납품단가 조정이 필요한 경우 원사업자가 반영 또는 수용하는 정도가 어느 정도 개선되고 있다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_24_1" value="<%=setHiddenValue(qa, 24, 1, 5)%>">
						<li><input type="radio" name="q1_24_1" value="1" <%if(qa[24][1][1]!=null && qa[24][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(24,1);">① 많이 개선되고 있다</li>
						<li><input type="radio" name="q1_24_1" value="2" <%if(qa[24][1][2]!=null && qa[24][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(24,1);">② 약간 개선되고 있다</li>
						<li><input type="radio" name="q1_24_1" value="3" <%if(qa[24][1][3]!=null && qa[24][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(24,1);">③ 비슷하다</li>
						<li><input type="radio" name="q1_24_1" value="4" <%if(qa[24][1][4]!=null && qa[24][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(24,1);">④ 약간 악화되고 있다</li>
						<li><input type="radio" name="q1_24_1" value="5" <%if(qa[24][1][5]!=null && qa[24][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(24,1);">⑤ 매우 악화되고 있다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">Ⅲ. 부당특약 관련</a></li>
						</ul>
					</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="width:920px;">
					<li class="boxcontenttitle"><참고> 부당한 특약 금지 (2014.2.14 이후 체결된 계약(기존 계약의 변경을 포함) 부터 적용)</li>
					<li class="boxcontenttitle">: 합의를 명분으로 수급사업자에게 비용을 전가하는 관행을 개선하기 위해 하도급계약에서의 부당한 특약을 금지하고 위반시 특약조항의 <br/>&nbsp;&nbsp;삭제ㆍ수정, 과징금 등의 제재를 부과</li>
				</ul>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>25. </span>귀사는 부당한 특약을 금지하는 제도가 도입(2014.2.14.) 되기 전에 원사업자가 귀사의 이익을 부당하게 침해하거나 제한하는 계약조건을 설정한 사실이 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_25_1" value="<%=setHiddenValue(qa, 25, 1, 2)%>">
						<li><input type="radio" name="q1_25_1" value="1" <%if(qa[25][1][1]!=null && qa[25][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,1);">① 있었음</li>
						<li><input type="radio" name="q1_25_1" value="2" <%if(qa[25][1][2]!=null && qa[25][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>25-1. </span><font color="blue"><문25에서 있었다(①)고 응답한 경우></font> 원사업자가 설정한 부당한 특약의 내용은 무엇입니까? <font color="#FF0066">* 해당항목에 모두 체크</font></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q1_25_2_1" value="1" <%if(qa[25][2][1]!=null && qa[25][2][1].equals("1")){out.print("checked");}%>>① 원사업자가 하도급 계약서에 기재되지 않은 사항을 요구함에 따라 발생된 비용을 당사에게 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_25_2_2" value="1" <%if(qa[25][2][2]!=null && qa[25][2][2].equals("1")){out.print("checked");}%>>② 원사업자가 부담하여야 할 민원처리, 산업재해 등과 관련된 비용을 당사에게 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_25_2_3" value="1" <%if(qa[25][2][3]!=null && qa[25][2][3].equals("1")){out.print("checked");}%>>③ 원사업자가 입찰내역에 없는 사항을 요구함에 따라 발생된 비용을 당사에게 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_25_2_4" value="1" <%if(qa[25][2][4]!=null && qa[25][2][4].equals("1")){out.print("checked");}%>>④ 관련 법령에 따라 원사업자의 의무사항으로 되어있는 인ㆍ허가, 환경ㆍ품질관리 등과 관련하여 발생되는 비용<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;을 당사에게 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_25_2_5" value="1" <%if(qa[25][2][5]!=null && qa[25][2][5].equals("1")){out.print("checked");}%>>⑤ 발주자 또는 원사업자의 설계ㆍ작업내용의 변경에 따라 발생하는 비용을 당사에게 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_25_2_6" value="1" <%if(qa[25][2][6]!=null && qa[25][2][6].equals("1")){out.print("checked");}%>>⑥ 원사업자의 지시에 따른 재작업, 추가작업 또는 보수작업으로 인하여 발생한 비용 중 당사의 책임없는 사유로 <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;발생한 비용을 당사에게 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_25_2_7" value="1" <%if(qa[25][2][7]!=null && qa[25][2][7].equals("1")){out.print("checked");}%>>⑦ 위탁시점에 원사업자와 당사가 예측할 수 없는 사항과 관련하여 당사에게 불합리하게 책임을 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_25_2_8" value="1" <%if(qa[25][2][8]!=null && qa[25][2][8].equals("1")){out.print("checked");}%>>⑧ 계약기간 중 당사가 하도급대금의 조정을 요청할 수 있는 권리를 제한하는 약정</li>
						<li><input type="checkbox" name="q1_25_2_9" value="1" <%if(qa[25][2][9]!=null && qa[25][2][9].equals("1")){out.print("checked");}%>>⑨ 기타 ( 
							<input type="text" name="q1_25_4" value="<%=qa[25][4][20]%>"  maxlength="50" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';" style="width:200px;text-align:right;"> )
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>26. </span>귀사는 부당한 특약을 금지하는 제도가 시행된 2014.2.14. 이후 원사업자가 귀사의 이익을 부당하게 침해하거나 제한하는 계약조건을 설정한 사실이 있습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_26_1" value="<%=setHiddenValue(qa, 26, 1, 2)%>">
						<li><input type="radio" name="q1_26_1" value="1" <%if(qa[26][1][1]!=null && qa[26][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(26,1);">① 있었음</li>
						<li><input type="radio" name="q1_26_1" value="2" <%if(qa[26][1][2]!=null && qa[26][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(26,1);">② 없었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>26-1. </span><font color="blue"><문26에서 있었다(①)고 응답한 경우></font> 원사업자가 설정한 부당한 특약의 내용은 무엇입니까? <font color="#FF0066">* 해당항목에 모두 체크</font></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q1_26_2_1" value="1" <%if(qa[26][2][1]!=null && qa[26][2][1].equals("1")){out.print("checked");}%>>① 원사업자가 하도급 계약서에 기재되지 않은 사항을 요구함에 따라 발생된 비용을 당사에게 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_26_2_2" value="1" <%if(qa[26][2][2]!=null && qa[26][2][2].equals("1")){out.print("checked");}%>>② 원사업자가 부담하여야 할 민원처리, 산업재해 등과 관련된 비용을 당사에게 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_26_2_3" value="1" <%if(qa[26][2][3]!=null && qa[26][2][3].equals("1")){out.print("checked");}%>>③ 원사업자가 입찰내역에 없는 사항을 요구함에 따라 발생된 비용을 당사에게 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_26_2_4" value="1" <%if(qa[26][2][4]!=null && qa[26][2][4].equals("1")){out.print("checked");}%>>④ 관련 법령에 따라 원사업자의 의무사항으로 되어있는 인ㆍ허가, 환경ㆍ품질관리 등과 관련하여 발생되는 비용<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;을 당사에게 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_26_2_5" value="1" <%if(qa[26][2][5]!=null && qa[26][2][5].equals("1")){out.print("checked");}%>>⑤ 발주자 또는 원사업자의 설계ㆍ작업내용의 변경에 따라 발생하는 비용을 당사에게 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_26_2_6" value="1" <%if(qa[26][2][6]!=null && qa[26][2][6].equals("1")){out.print("checked");}%>>⑥ 원사업자의 지시에 따른 재작업, 추가작업 또는 보수작업으로 인하여 발생한 비용 중 당사의 책임없는 사유로 <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;발생한 비용을 당사에게 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_26_2_7" value="1" <%if(qa[26][2][7]!=null && qa[26][2][7].equals("1")){out.print("checked");}%>>⑦ 위탁시점에 원사업자와 당사가 예측할 수 없는 사항과 관련하여 당사에게 불합리하게 책임을 부담시키는 약정</li>
						<li><input type="checkbox" name="q1_26_2_8" value="1" <%if(qa[26][2][8]!=null && qa[26][2][8].equals("1")){out.print("checked");}%>>⑧ 계약기간 중 당사가 하도급대금의 조정을 요청할 수 있는 권리를 제한하는 약정</li>
						<li><input type="checkbox" name="q1_26_2_9" value="1" <%if(qa[26][2][9]!=null && qa[26][2][9].equals("1")){out.print("checked");}%>>⑨ 기타 ( 
							<input type="text" name="q1_26_4" value="<%=qa[26][4][20]%>"  maxlength="50" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';" style="width:200px;text-align:right;"> )
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>27. </span>귀사는 부당한 특약을 금지하는 제도가 시행된 2014.2.14. 이후 그 전과 비교하여, 원사업자가 부당한 특약을 요구하거나 설정하는 불공정행위가 어느 정도 개선되고 있다고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_27_1" value="<%=setHiddenValue(qa, 27, 1, 5)%>">
						<li><input type="radio" name="q1_27_1" value="1" <%if(qa[27][1][1]!=null && qa[27][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(27,1);">① 많이 개선되고 있다</li>
						<li><input type="radio" name="q1_27_1" value="2" <%if(qa[27][1][2]!=null && qa[27][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(27,1);">② 약간 개선되고 있다</li>
						<li><input type="radio" name="q1_27_1" value="3" <%if(qa[27][1][3]!=null && qa[27][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(27,1);">③ 비슷하다</li>
						<li><input type="radio" name="q1_27_1" value="4" <%if(qa[27][1][4]!=null && qa[27][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(27,1);">④ 약간 악화되고 있다</li>
						<li><input type="radio" name="q1_27_1" value="5" <%if(qa[27][1][5]!=null && qa[27][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(27,1);">⑤ 매우 악화되고 있다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">Ⅳ. 새로 도입된 제도에 대한 인지도, 건의사항 등</a></li>
						</ul>
					</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>28. </span>최근 「하도급거래 공정화에 관한 법률」에 ① 3배 손해배상제도 확대(2013.11.29. 시행), ② 중소기업 협동조합에 납품단가 조정협의권 부여(2013.11.29. 시행), ③ 부당한 특약을 금지하는 제도(2014.2.14. 시행)가 도입되어 시행 중에 있습니다. 귀사는 위 제도의 도입 여부 및 주요 내용에 대해 어느 정도 알고 있습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_28_1" value="<%=setHiddenValue(qa, 28, 1, 5)%>">
						<li><input type="radio" name="q1_28_1" value="1" <%if(qa[28][1][1]!=null && qa[28][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(28,1);">① 매우 잘 알고 있다</li>
						<li><input type="radio" name="q1_28_1" value="2" <%if(qa[28][1][2]!=null && qa[28][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(28,1);">② 대체로 알고 있다</li>
						<li><input type="radio" name="q1_28_1" value="3" <%if(qa[28][1][3]!=null && qa[28][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(28,1);">③ 약간 알고 있다</li>
						<li><input type="radio" name="q1_28_1" value="4" <%if(qa[28][1][4]!=null && qa[28][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(28,1);">④ 잘 모른다</li>
						<li><input type="radio" name="q1_28_1" value="5" <%if(qa[28][1][5]!=null && qa[28][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(28,1);">⑤ 전혀 모른다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>29. </span>귀사는 새로 도입된 제도들이 전반적으로 불공정한 하도급 거래 관행을 시정하는데 어느 정도 도움이 되거나 효과가 있을 것이라고 생각하십니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_29_1" value="<%=setHiddenValue(qa, 29, 1, 5)%>">
						<li><input type="radio" name="q1_29_1" value="1" <%if(qa[29][1][1]!=null && qa[29][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,1);">① 많은 효과가 있을 것이다</li>
						<li><input type="radio" name="q1_29_1" value="2" <%if(qa[29][1][2]!=null && qa[29][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,1);">② 대체로 효과가 있을 것이다</li>
						<li><input type="radio" name="q1_29_1" value="3" <%if(qa[29][1][3]!=null && qa[29][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,1);">③ 약간 효과가 있을 것이다</li>
						<li><input type="radio" name="q1_29_1" value="4" <%if(qa[29][1][4]!=null && qa[29][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,1);">④ 거의 효과가 없을 것이다</li>
						<li><input type="radio" name="q1_29_1" value="5" <%if(qa[29][1][5]!=null && qa[29][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,1);">⑤ 전혀 효과가 없을 것이다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>29-1. </span><font color="blue"><문29에서 효과가 있다고 응답(①∼③)한 경우만 답변></font> 새로 도입된 제도 중 원사업자의 불공정한 하도급거래 행위를 시정하는데 가장 도움이 되거나 효과가 있을 것이라고 생각하는 제도는 무엇입니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_29_2" value="<%=setHiddenValue(qa, 29, 2, 3)%>">
						<li><input type="radio" name="q1_29_2" value="1" <%if(qa[29][2][1]!=null && qa[29][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,2);">① 3배 손해배상제도 확대 도입 (2013.11.29. 시행)</li>
						<li><input type="radio" name="q1_29_2" value="2" <%if(qa[29][2][2]!=null && qa[29][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,2);">② 중소기업협동조합에 납품단가조정협의권 부여 (2013.11.29. 시행)</li>
						<li><input type="radio" name="q1_29_2" value="3" <%if(qa[29][2][3]!=null && qa[29][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,2);">③ 부당한 특약 금지 (2014.2.14. 시행)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><span>29-2. </span><font color="blue"><문29에서 효과가 없다(④∼⑤)고 응답한 경우만 답변></font> 도움이 되지 않거나 효과가 없다고 생각한다면, 그 이유는 무엇이라고 생각하십니까? (간략하게 작성하여 주시기 바랍니다)</li>
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
					<ul class="lt"><textarea cols="80" rows="8" maxlength="600" name="q1_29_3" class="textarea01b" maxlength="600" onFocus="javascript:this.className='textarea01o';" onBlur="javascript:this.className='textarea01b';" onkeyup="byteLengCheck(this, 4000, this.name,'content_bytes21');"><%=qa[29][3][20]%></textarea></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>30. </span>3배 손해배상제도 확대, 중소기업 협동조합에 납품단가 조정협의권 부여 등이 도입된 2013.11.29. 이후 그 전과 비교하여, 귀사가 원사업자로부터 받은 하도급 대금 결제 수단 중 현금(내국 신용장 및 수표에 의한 결제금액 포함)으로 받은 비율은 어떻게 변화하였습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_30_1" value="<%=setHiddenValue(qa, 30, 1, 3)%>">
						<li><input type="radio" name="q1_30_1" value="1" <%if(qa[30][1][1]!=null && qa[30][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(30,1);">① 현금결제 비율이 높아졌다</li>
						<li><input type="radio" name="q1_30_1" value="2" <%if(qa[30][1][2]!=null && qa[30][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(30,1);">② 비슷하다</li>
						<li><input type="radio" name="q1_30_1" value="3" <%if(qa[30][1][3]!=null && qa[30][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(30,1);">③ 현금결제 비율이 낮아졌다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>31. </span>3배 손해배상제도 확대, 중소기업 협동조합에 납품단가 조정협의권 부여 등이 도입된 2013.11.29. 이후 그 전과 비교하여, 귀사가 원사업자에게 목적물을 납품, 인도 또는 제공하고 원사업자로부터 하도급 대금을 결제 받은 기간은 어떻게 변화하였습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_31_1" value="<%=setHiddenValue(qa, 31, 1, 3)%>">
						<li><input type="radio" name="q1_31_1" value="1" <%if(qa[31][1][1]!=null && qa[31][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(31,1);">① 결제기간이 짧아졌다</li>
						<li><input type="radio" name="q1_31_1" value="2" <%if(qa[31][1][2]!=null && qa[31][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(31,1);">② 비슷하다</li>
						<li><input type="radio" name="q1_31_1" value="3" <%if(qa[31][1][3]!=null && qa[31][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(31,1);">③ 결제기간이 길어졌다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><span>32. </span>귀사가 공정한 하도급거래 질서 조성을 위해 필요하다고 생각하시는 제도개선 건의사항, 애로사항 등이 있으시면 자유롭게 기재하여 주시기<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 바랍니다.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontentsubtitle"><p align="right" id="content_bytes22">0/4000byte</p></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><textarea cols="80" rows="8" maxlength="600" name="q1_32_1" class="textarea01b" maxlength="600" onFocus="javascript:this.className='textarea01o';" onBlur="javascript:this.className='textarea01b';" onkeyup="byteLengCheck(this, 4000, this.name,'content_bytes22');"><%=qa[32][1][20]%></textarea></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_20"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp lt">
					<li class="boxcontenttitle"><p align="center">지금까지 사실대로 조사표를 작성해 주신데 대하여 감사드립니다.</p></li>
				</ul>
			</div>

			<div class="fc pt_20"></div>

			<!-- 버튼 start -->
			<!--div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="#" onclick="savef(); return false;" onfocus="this.blur()" class="contentbutton2">전 송</a></li>
				</ul>
			</div-->

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