<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%
/*=======================================================*/
/* 프로젝트명		: 2015년 공정거래위원회 신규도입제도관련 설문조사					*/
/* 프로그램명		: Hado_Poll.jsp																		*/
/* 프로그램설명	: 설문조사 입력 페이지															*/
/* 프로그램버전	: 1.0.2																				*/
/* 최초작성일자	: 2014년 07월 07일																*/
/*--------------------------------------------------------------------------------------- */
/*	작성일자		작성자명				내용
/*--------------------------------------------------------------------------------------- */
/*	2014-07-07	정광식	최초작성																*/			
/*	2014-11-05	강슬기	내용수정																*/			
/*	2015-10-15	강슬기	내용수정																*/			
/*=======================================================*/

/* Variable Difinition Start ======================================*/

String sPollId			= "20151007";		// 설문번호
String sReturnURL	= "Hado_Poll.jsp";	// 설문조사 이동시 페이지
String sSQLs			= "";						// SQL문

ConnectionResource resource		= null;	// Database Resource
Connection conn						= null;	// Database Connection
PreparedStatement pstmt			= null;	// PreparedStatument
ResultSet rs								= null;	// Result RecordSet

// 회사 기본정보 (2015년도 무기명 조사로 인한 해당 변수 숨김)

String sSentType		= "";	// 업종
String sBussTerm		= "";	// 사업기간
String sAreaCD		= "";  // 지역코드
String sSubconStep	= "";	// 원사업자와의 거래단계
String sDetailCD		= "";	// 세부업종구분
String sSentSale		= "";	// 매출액
String sEmpCnt		= "";	// 상시종업원수
String sCapaCD		= "";	// 기업규모구분

// 20141105 / 강슬기 / 답변내역 저장
// [대문항],[소문항],[보기개수]
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
					/*
					sBussTerm		= rs.getString("buss_term_year");
					sAreaCD			= rs.getString("area_cd");
					sSubconStep	= rs.getString("subcon_step");
					sDetailCD		= rs.getString("detail_type_cd");
					sSentSale		= rs.getString("sent_sale");
					sEmpCnt		= rs.getString("sent_emp_cnt");
					sCapaCD		= rs.getString("sent_capa_cd");
					*/
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
}
/* Record Selection Processing End =================================*/
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
	<title>공정거래위원회 신규제도관련 설문조사</title>
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

		researchf(main.oSentType, 2, "업종을 선택하여 주십시오.");
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
		research2f(info, 20, 1, 2, 0);
		research2f(info, 21, 1, 2, 0);

		// 연계문항 선택 확인
		//--> 입력여부 확인 :: research3f(form-name, 연계문항대번호, 연계문항소번호, 개체타입(1:text,2:radio,3:checkbox), 보기개수(checkbox만 해당 아니면 0), 선선택(조건)문항대번호, 선선택(조건)문항소번호);

		//if( main.q1_5_1[3].checked==true || main.q1_5_1[4].checked==true || main.q1_8_1[3].checked==true || main.q1_8_1[4].checked==true || main.q1_11_1[3].checked==true || main.q1_11_1[4].checked==true || main.q1_14_1[3].checked==true || main.q1_14_1[4].checked==true || main.q1_17_1[3].checked==true || main.q1_17_1[4].checked==true ) research3f(main, 18, 1, 1, 0, 18, 1); else initf(main, 18, 1, 1, 0);
		// 연계문항 끝

		if(msg=="") {
			if(confirm("[ 조사표내용을 전송합니다. ]\n\n접속자가 많을경우 다소 시간이 걸릴수도 있습니다.\n정상적으로 전송이 안될경우\n수십분후에 다시시도하여 주십시오.\n\n확인을 누르시면 전송합니다.")) {
				
				//document.getElementById("loadingImage").style.display="block";
				//view_layer("loadingImage");

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

		//if( main.q1_5_1[3].checked==true || main.q1_5_1[4].checked==true || main.q1_8_1[3].checked==true || main.q1_8_1[4].checked==true || main.q1_11_1[3].checked==true || main.q1_11_1[4].checked==true || main.q1_14_1[3].checked==true || main.q1_14_1[4].checked==true || main.q1_17_1[3].checked==true || main.q1_17_1[4].checked==true ) research3f(main, 18, 1, 1, 0, 18, 1); else initf(main, 18, 1, 1, 0);
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
			} else if (fno=="22") {
				eval("msg=msg+'협동조합을 체크하여 주십시오.'");
				//eval("msg=msg+'조사표의 "+fno+"번의 ("+sno+")번을 입력하여 주십시오.'");
			}else {
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
				eval("msg=msg+'조사표의 "+ofno+"번 문항을 입력하여 주십시오.'");
				//eval("msg=msg+'조사표의 "+ofno+"번의 ("+osno+")번의 연계문항 "+fno+"번의 ("+sno+")번을 입력하여 주십시오.'");
			} else {
				eval("msg=msg+'조사표의 "+ofno+"번 문항을 선택하여 주십시오.'");
				//eval("msg=msg+'조사표의 "+ofno+"번의 ("+osno+")번의 연계문항 "+fno+"번의 ("+sno+")번을 선택하여 주십시오.'");
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
			<h1 class="contenttitle">신규제도관련 설문조사</h1>
			<!-- title end -->
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">◇ 조사목적</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><span>ㅇ</span>공정거래위원회는 하도급거래에서 원사업자의 불공정한 행위로부터 수급사업자를 보호하고 수급사업자의 권리를 강화하기 위해 <font style="font-weight:bold;">①3배 손해배상제 적용대상을 확대</font>하고, <font style="font-weight:bold;">②부당특약을 금지하는 제도</font>를 「하도급거래 공정화에 관한 법률」에 도입하였습니다.</li>
						<li><span>ㅇ</span>이에 새로 도입된 제도가 수급사업자에게 실제로 도움이 되고 있는지 여부를 파악하고, 필요한 제도 보완사항을 마련하기 위한 자료로 활용하기 위해 본 조사를 실시하고자 하오니, 사업으로 바쁘시겠지만 잠시 시간을 할애하시어 본 조사에 적극적으로 응하여 주시기 바랍니다.</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">◇ 참고사항</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><span>ㅇ</span>본 조사는 무기명으로 진행되며, 귀사가 조사표에 기재한 내용은「하도급거래 공정화에 관한 법률」 제27조 제3항에 따라 철저히 비밀이 보장되고, 통계 목적 이외의 다른 용도로는 사용되지 않음을 약속드립니다.</li>
						<li><span>ㅇ</span>설문조사 담당부서는 공정거래위원회 기업거래정책과이며, 문의사항이 있으시면 아래 전화로 연락주시기 바랍니다.</li>
						<li><span></span>☏ 044-200-4588, 044-200-4593</li>
					</ul>
				</div>
				<div class="fc"></div>
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
				<table class="tbl_blue">
					<tr>
						<th>업종</th>
						<td colspan="3">
							<input type="radio" name="oSentType" value="1" <%if(sSentType.equals("1")){out.print("checked");}%>>① 제조업
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="oSentType" value="2" <%if(sSentType.equals("2")){out.print("checked");}%>>② 건설업
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="oSentType" value="3" <%if(sSentType.equals("3")){out.print("checked");}%>>③ 용역업
						</td>
					</tr>
				</table>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">Ⅰ. 3배 손해배상 제도의 적용범위 확대ㆍ시행 관련</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span>▣</span>대기업 등의 불공정한 행위를 억제하고 피해를 입은 중소기업의 권리를 강화하기 위하여 3배 손해배상제 적용대상을 <font style="font-weight:bold;">'기술유용행위'에서 '부당한<br/>하도급대금결정ㆍ감액, 부당위탁 취소 및 부당반품'으로 확대(하도급법 개정, 2013.11.29. 시행)</font>하였습니다. 대기업 등이 위 불공정행위를 한 경우<br/>시정명령, 과징금, 벌금 등이 부과될 뿐만 아니라, <font style="font-weight:bold;">피해를 입은 중소기업은 법원에 손해배상 청구를 하여 손해액의 3배까지 배상을 받을 수 있게<br/>되었습니다.</font></li>
				</ul>
			</div>	

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>1. </span> 공정거래위원회는 <font style="font-weight:bold;">3배 손해배상 제도의 적용범위</font>를 당초 기술유용에서 부당한 <font style="font-weight:bold;">하도급대금 결정ㆍ감액 행위, 부당한 위탁취소 및 부당반품 행위까지 확대하여 시행</font>하고 있습니다. 귀사는 이러한 제도가 시행되고 있는 것을 알고 있습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_1_1" value="<%=setHiddenValue(qa, 1, 1, 5)%>">
						<li><input type="Radio" name="q1_1_1" value="1" <%if(qa[1][1][1]!=null && qa[1][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);"> 가. 잘 알고 있음</li>
						<li><input type="Radio" name="q1_1_1" value="2" <%if(qa[1][1][2]!=null && qa[1][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);"> 나. 대체로 알고 있음</li>
						<li><input type="Radio" name="q1_1_1" value="3" <%if(qa[1][1][3]!=null && qa[1][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);"> 다. 약간 알고 있음</li>
						<li><input type="Radio" name="q1_1_1" value="4" <%if(qa[1][1][4]!=null && qa[1][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);"> 라. 잘 모름</li>
						<li><input type="Radio" name="q1_1_1" value="5" <%if(qa[1][1][5]!=null && qa[1][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);"> 마. 전혀 모름</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span></span>3배 손해배상제 적용대상 중 <font style="font-weight:bold;">부당한 하도급 대금결정ㆍ감액 관련</font>입니다. 원사업자가 <font style="font-weight:bold;">부당하게 하도급대금을 결정하거나, 정당한 사유가 없음에도<br/>위탁 당시 정했던 금액보다 적게 하도급대금을 지급하는 행위</font>에 대해 아래 2~4번 문항에 응답하여 주시기 바랍니다.</li>
				</ul>
			</div>	

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>2. </span> <font style="font-weight:bold;">2014년도 상반기(2014.1.1.∼2014.6.30.)</font>동안 원사업자가 부당하게 하도급대금을 결정하거나 감액한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_2_1" value="<%=setHiddenValue(qa, 2, 1, 2)%>">
						<li><input type="Radio" name="q1_2_1" value="1" <%if(qa[2][1][1]!=null && qa[2][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);"> 가. 없었음</li>
						<li><input type="Radio" name="q1_2_1" value="2" <%if(qa[2][1][2]!=null && qa[2][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);"> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>3. </span> <font style="font-weight:bold;">2015년도 상반기(2015.1.1.∼2015.6.30.)</font>동안 원사업자가 부당하게 하도급대금을 결정하거나 감액한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_3_1" value="<%=setHiddenValue(qa, 3, 1, 2)%>">
						<li><input type="Radio" name="q1_3_1" value="1" <%if(qa[3][1][1]!=null && qa[3][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);"> 가. 없었음</li>
						<li><input type="Radio" name="q1_3_1" value="2" <%if(qa[3][1][2]!=null && qa[3][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);"> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>4. </span> 원사업자의 부당한 하도급대금 결정ㆍ감액 행위는 2014년도 상반기와 비교하여 2015년도 상반기에 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_4_1" value="<%=setHiddenValue(qa, 4, 1, 5)%>">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_4_1" value="1" <%if(qa[4][1][1]!=null && qa[4][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);"> 5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_4_1" value="2" <%if(qa[4][1][2]!=null && qa[4][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);"> 4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_4_1" value="3" <%if(qa[4][1][3]!=null && qa[4][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);"> 3점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_4_1" value="4" <%if(qa[4][1][4]!=null && qa[4][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);"> 2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_4_1" value="5" <%if(qa[4][1][5]!=null && qa[4][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);"> 1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선되고 있음 ◀────────────────────▶전혀 개선되지 않고 있음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span></span>3배 손해배상제 적용대상 중 <font style="font-weight:bold;">부당한 위탁취소 관련</font>입니다. 원사업자가 <font style="font-weight:bold;">하도급 계약을 일방적으로 취소하는 행위</font>에 대해 아래 5~7번 문항에<br/>응답하여 주시기 바랍니다.</li>
				</ul>
			</div>	

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>5. </span> <font style="font-weight:bold;">2014년도 상반기(2014.1.1.∼2014.6.30.)</font>동안 귀사의 귀책사유가 없음에도 불구하고 원사업자가 하도급 계약을 일방적으로 취소한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_5_1" value="<%=setHiddenValue(qa, 5, 1, 2)%>">
						<li><input type="Radio" name="q1_5_1" value="1" <%if(qa[5][1][1]!=null && qa[5][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"> 가. 없었음</li>
						<li><input type="Radio" name="q1_5_1" value="2" <%if(qa[5][1][2]!=null && qa[5][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>6. </span> <font style="font-weight:bold;">2015년도 상반기(2015.1.1.∼2015.6.30.)</font>동안 귀사의 귀책사유가 없음에도 불구하고 원사업자가 하도급 계약을 일방적으로 취소한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_6_1" value="<%=setHiddenValue(qa, 6, 1, 2)%>">
						<li><input type="Radio" name="q1_6_1" value="1" <%if(qa[6][1][1]!=null && qa[6][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(6,1);"> 가. 없었음</li>
						<li><input type="Radio" name="q1_6_1" value="2" <%if(qa[6][1][2]!=null && qa[6][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(6,1);"> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>7. </span> 원사업자의 부당한 위탁취소 행위는 2014년도 상반기와 비교하여 2015년도 상반기에 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_7_1" value="<%=setHiddenValue(qa, 7, 1, 5)%>">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_7_1" value="1" <%if(qa[7][1][1]!=null && qa[7][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);"> 5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_7_1" value="2" <%if(qa[7][1][2]!=null && qa[7][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);"> 4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_7_1" value="3" <%if(qa[7][1][3]!=null && qa[7][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);"> 3점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_7_1" value="4" <%if(qa[7][1][4]!=null && qa[7][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);"> 2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_7_1" value="5" <%if(qa[7][1][5]!=null && qa[7][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);"> 1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선되고 있음 ◀────────────────────▶전혀 개선되지 않고 있음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span></span>3배 손해배상제 적용대상 중 <font style="font-weight:bold;">부당반품 관련</font>입니다. 원사업자가 <font style="font-weight:bold;">목적물의 납품 등을 받은 후 일방적으로 반품하는 행위</font>에 대해 아래 8~10번 문항에<br>응답하여 주시기 바랍니다.</li>
				</ul>
			</div>	

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>8. </span> <font style="font-weight:bold;">2014년도 상반기(2014.1.1.∼2014.6.30.)</font>동안 귀사의 귀책사유가 없음에도 불구하고 원사업자가 목적물의 납품 등을 받은 후 반품한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_8_1" value="<%=setHiddenValue(qa, 8, 1, 2)%>">
						<li><input type="Radio" name="q1_8_1" value="1" <%if(qa[8][1][1]!=null && qa[8][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"> 가. 없었음</li>
						<li><input type="Radio" name="q1_8_1" value="2" <%if(qa[8][1][2]!=null && qa[8][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>9. </span> <font style="font-weight:bold;">2015년도 상반기(2015.1.1.∼2015.6.30.)</font>동안 귀사의 귀책사유가 없음에도 불구하고 원사업자가 목적물의 납품 등을 받은 후 반품한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_9_1" value="<%=setHiddenValue(qa, 9, 1, 2)%>">
						<li><input type="Radio" name="q1_9_1" value="1" <%if(qa[9][1][1]!=null && qa[9][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);"> 가. 없었음</li>
						<li><input type="Radio" name="q1_9_1" value="2" <%if(qa[9][1][2]!=null && qa[9][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);"> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>10. </span> 원사업자의 부당반품 행위는 2014년도 상반기와 비교하여 2015년도 상반기에 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_10_1" value="<%=setHiddenValue(qa, 10, 1, 5)%>">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_10_1" value="1" <%if(qa[10][1][1]!=null && qa[10][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_10_1" value="2" <%if(qa[10][1][2]!=null && qa[10][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_10_1" value="3" <%if(qa[10][1][3]!=null && qa[10][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 3점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_10_1" value="4" <%if(qa[10][1][4]!=null && qa[10][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_10_1" value="5" <%if(qa[10][1][5]!=null && qa[10][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선되고 있음 ◀────────────────────▶전혀 개선되지 않고 있음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span></span>3배 손해배상제 적용대상 중 <font style="font-weight:bold;">기술유용 관련</font>입니다. 원사업자의 <font style="font-weight:bold;">기술유용 행위</font>에 대해 아래 11~13번 문항에 응답하여 주시기 바랍니다.</li>
				</ul>
			</div>	

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>11. </span> <font style="font-weight:bold;">2014년도 상반기(2014.1.1.∼2014.6.30.)</font>동안 원사업자가 귀사로부터 취득한 기술자료를 원사업자 또는 제3자의 이익을 위해 사용함으로써 귀사에게 손해가 발생한 경험이 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_11_1" value="<%=setHiddenValue(qa, 11, 1, 2)%>">
						<li><input type="Radio" name="q1_11_1" value="1" <%if(qa[11][1][1]!=null && qa[11][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);"> 가. 없었음</li>
						<li><input type="Radio" name="q1_11_1" value="2" <%if(qa[11][1][2]!=null && qa[11][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);"> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>12. </span> <font style="font-weight:bold;">2015년도 상반기(2015.1.1.∼2015.6.30.)</font>동안 원사업자가 귀사로부터 취득한 기술자료를 원사업자 또는 제3자의 이익을 위해 사용함으로써 귀사에게 손해가 발생한 경험이 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_12_1" value="<%=setHiddenValue(qa, 12, 1, 2)%>">
						<li><input type="Radio" name="q1_12_1" value="1" <%if(qa[12][1][1]!=null && qa[12][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"> 가. 없었음</li>
						<li><input type="Radio" name="q1_12_1" value="2" <%if(qa[12][1][2]!=null && qa[12][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>13. </span> 원사업자의 기술유용 행위는 2014년도 상반기와 비교하여 2015년도 상반기에 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_13_1" value="<%=setHiddenValue(qa, 13, 1, 5)%>">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_13_1" value="1" <%if(qa[13][1][1]!=null && qa[13][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"> 5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_13_1" value="2" <%if(qa[13][1][2]!=null && qa[13][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"> 4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_13_1" value="3" <%if(qa[13][1][3]!=null && qa[13][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"> 3점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_13_1" value="4" <%if(qa[13][1][4]!=null && qa[13][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"> 2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_13_1" value="5" <%if(qa[13][1][5]!=null && qa[13][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"> 1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선되고 있음 ◀────────────────────▶전혀 개선되지 않고 있음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">Ⅱ. 부당특약 금지제도 시행 관련</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span>▣</span>합의(특약)를 명분으로 <font style="font-weight:bold;">대기업 등이 부담해야 할 각종 비용(예:민원처리 비용 등)을 중소기업에게 전가하는 관행을 개선</font>하기 위해 하도급계약에서<br><font style="font-weight:bold;">부당한 특약의 설정을 금지(하도급법 개정, 2014.2.14.시행)</font>하였습니다. 대기업 등이 부당특약을 설정한 경우 특약조항의 삭제ㆍ수정 등 시정명령,<br>과징금, 벌금 등이 부과됩니다.</font></li>
				</ul>
			</div>	

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>14. </span> 공정거래위원회는 원사업자가 부담해야 할 각종 비용을 전가하는 관행을 개선하기 위해 <font style="font-weight:bold;"><u>수급사업자의 이익을 부당하게 침해하거나 제한하는 계약조건을 설정하지 못하도록 하는 부당특약금지제도를 도입하여 시행</u></font>하고 있습니다. 귀사는 이러한 제도가 시행되고 있는 것을 알고 있습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_14_1" value="<%=setHiddenValue(qa, 14, 1, 5)%>">
						<li><input type="Radio" name="q1_14_1" value="1" <%if(qa[14][1][1]!=null && qa[14][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"> 가. 잘 알고 있음</li>
						<li><input type="Radio" name="q1_14_1" value="2" <%if(qa[14][1][2]!=null && qa[14][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"> 나. 대체로 알고 있음</li>
						<li><input type="Radio" name="q1_14_1" value="3" <%if(qa[14][1][3]!=null && qa[14][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"> 다. 약간 알고 있음</li>
						<li><input type="Radio" name="q1_14_1" value="4" <%if(qa[14][1][4]!=null && qa[14][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"> 라. 잘 모름</li>
						<li><input type="Radio" name="q1_14_1" value="5" <%if(qa[14][1][5]!=null && qa[14][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"> 마. 전혀 모름</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>15. </span> <font style="font-weight:bold;">2014년도 상반기(2014.1.1.∼2014.6.30.)</font>동안 귀사가 원사업자와 체결한 하도급계약에 원사업자가 귀사의 이익을 부당하게 침해하거나 제한하는 계약조건을 설정한 사실이 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_15_1" value="<%=setHiddenValue(qa, 15, 1, 2)%>">
						<li><input type="Radio" name="q1_15_1" value="1" <%if(qa[15][1][1]!=null && qa[15][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"> 가. 없었음</li>
						<li><input type="Radio" name="q1_15_1" value="2" <%if(qa[15][1][2]!=null && qa[15][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>16. </span> <font style="font-weight:bold;">2015년도 상반기(2015.1.1.∼2015.6.30.)</font>동안 귀사가 원사업자와 체결한 하도급계약에 원사업자가 귀사의 이익을 부당하게 침해하거나 제한하는 계약조건을 설정한 사실이 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_16_1" value="<%=setHiddenValue(qa, 16, 1, 2)%>">
						<li><input type="Radio" name="q1_16_1" value="1" <%if(qa[16][1][1]!=null && qa[16][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"> 가. 없었음</li>
						<li><input type="Radio" name="q1_16_1" value="2" <%if(qa[16][1][2]!=null && qa[16][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>17. </span> 원사업자가 부당한 특약을 설정하는 불공정행위가 2014년도 상반기와 비교하여 2015년도 상반기에 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_17_1" value="<%=setHiddenValue(qa, 17, 1, 5)%>">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="1" <%if(qa[17][1][1]!=null && qa[17][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"> 5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="2" <%if(qa[17][1][2]!=null && qa[17][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"> 4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="3" <%if(qa[17][1][3]!=null && qa[17][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"> 3점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="4" <%if(qa[17][1][4]!=null && qa[17][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"> 2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="5" <%if(qa[17][1][5]!=null && qa[17][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"> 1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선되고 있음 ◀────────────────────▶전혀 개선되지 않고 있음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">Ⅲ. 하도급대금 지급실태 관련</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span>▣</span>공정거래위원회는 2014.7월 이후 하도급대금 지급 관련 불공정행위에 초점을 맞추어 현장조사를 하고 있으며, 특히 <font style="font-weight:bold;">2015년 3월부터 의류, 선박,<br>자동차, 건설, 기계 업종 등의 하도급대금 관련 민원이 빈발하는 업종에 대해 하도급대금 미지급ㆍ지연지급, 어음할인료 미지급, 현금결제 비율<br>미준수</font> 등 하도급대금 지급 관련 <font style="font-weight:bold;">현장조사를 집중적으로 실시</font>하고 있습니다.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>18. </span> 2014년도 상반기(2014.1.1 ~ 2014.6.30.)동안 원사업자가 하도급대금을 미지급하거나, 지연이자를 미지급한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_18_1" value="<%=setHiddenValue(qa, 18, 1, 2)%>">
						<li><input type="Radio" name="q1_18_1" value="1" <%if(qa[18][1][1]!=null && qa[18][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"> 가. 없었음</li>
						<li><input type="Radio" name="q1_18_1" value="2" <%if(qa[18][1][2]!=null && qa[18][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>19. </span> 2015년도 상반기(2015.1.1 ~ 2015.6.30.)동안 원사업자가 하도급대금을 미지급하거나, 지연이자를 미지급한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="1_19_1" value="<%=setHiddenValue(qa, 19, 1, 2)%>">
						<li><input type="Radio" name="q1_19_1" value="1" <%if(qa[19][1][1]!=null && qa[19][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);"> 가. 없었음</li>
						<li><input type="Radio" name="q1_19_1" value="2" <%if(qa[19][1][2]!=null && qa[19][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);"> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>20. </span> 하도급대금 지급 관련 불공정행위가 2014년도 상반기와 비교하여 <font style="font-weight:bold;">공정위가 하도급대금 관련 민원빈발 업종에 대한 현장조사를 집중적으로 시작한 2015년 상반기에</font> 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_20_1" value="<%=setHiddenValue(qa, 20, 1, 5)%>">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_20_1" value="1" <%if(qa[20][1][1]!=null && qa[20][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"> 5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_20_1" value="2" <%if(qa[20][1][2]!=null && qa[20][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"> 4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_20_1" value="3" <%if(qa[20][1][3]!=null && qa[20][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"> 3점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_20_1" value="4" <%if(qa[20][1][4]!=null && qa[20][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"> 2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_20_1" value="5" <%if(qa[20][1][5]!=null && qa[20][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"> 1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선되고 있음 ◀────────────────────▶전혀 개선되지 않고 있음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>21. </span> 귀사는 위와 같은 지속적인 하도급대금 지급 관련 현장조사가 하도급대금 관련 불공정행위를 개선하는데 어느 정도 도움이 되거나 효과가 있을 것이라고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_21_1" value="<%=setHiddenValue(qa, 21, 1, 5)%>">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_21_1" value="1" <%if(qa[21][1][1]!=null && qa[21][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"> 5점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_21_1" value="2" <%if(qa[21][1][2]!=null && qa[21][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"> 4점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_21_1" value="3" <%if(qa[21][1][3]!=null && qa[21][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"> 3점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_21_1" value="4" <%if(qa[21][1][4]!=null && qa[21][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"> 2점
						&nbsp;&nbsp;──&nbsp;&nbsp;<input type="radio" name="q1_21_1" value="5" <%if(qa[21][1][5]!=null && qa[21][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"> 1점&nbsp;&nbsp; ──┤</li>
						<li>많은 효과가 있을 것임 ◀───────────────────▶전혀 효과가 없을 것임</li>
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
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="#" onclick="savef(); return false;" onfocus="this.blur()" class="contentbutton2">전 송</a></li>
				</ul>
			</div>

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