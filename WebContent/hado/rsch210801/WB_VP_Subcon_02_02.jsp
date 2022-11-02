<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_VP_Subcon_02_02.jsp
* 프로그램설명	: 수급사업자 > 년도별 조사표 > 2015년 건설업 조사표 > 귀사의 일반현황
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2009년 05월
* 작 성 이 력       :
*=========================================================
*	작성일자			작성자명				내용
*=========================================================
*	2009-05			정광식       최초작성
*   2010-07-20   정광식	    숫자형 기본값(0) 세팅
*	2015-07-08	강슬기       조사표 문항 및 코드 정리(StringUtil)
*   2016-01-12	이용광		DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_I_Global.jsp"%>
<%@ include file="../Include/WB_I_chkSession.jsp"%>

<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String sErrorMsg = "";	// 오류메시지

	String q_Cmd	= StringUtil.checkNull(request.getParameter("mode"));

	String sname	= "";
	String scompgb	= "";
	String scono	= "";
	String scono1	= "";
	String scono2	= "";
	String ssano	= "";
	String ssano1	= "";
	String ssano2	= "";
	String ssano3	= "";
	String scaptine = "";

	String sreggb = "";
	String sregtext = "";
	String zipcode	= "";
//	String zipcode1 = "";
//	String zipcode2 = "";
	String address	= "";
	String semail	= "";
	String semail1	= "";
	String semail2	= "";

	String worg		= "";
	String wjikwi	= "";
	String wname	= "";
	String wtel		= "";
	String wfax		= "";
	String wdate	= "";

	String reason	= "";
	//2015-07-15 / 조사제외대상여부 변수 설정 / 강슬기
	String sSentNoExcept = "";			// 조사제외대상여부
	
	/* 2021년도 추가 */
	String sIncorp = "";		//설립연월
	String sIncorp1 = "";		//설립연
	String sIncorp2 = "";		//설립월
	
	String sCompStatus = "";		// 회사영업상태
	String sQ1Etc = "";				// 회사영업상태 기타답변
	
	String sSentCapa = "";		// 회사규모
	String sSentCapaTxt = "";	// 회사규모기타
	
	String ssale1	= "0";		// 매출액  -3년
	String ssale2	= "0";		// -2
	String ssale	= "0";		// -1
	
	String soper1 = "0"; // 영업비용
	String soper2 = "0";
	String soper = "0";
	
	String samt1		= "0";		// 자산총액
	String samt2		= "0";		// 
	String samt		= "0";		//
	
	String sconamt = "0";
	String sconamt1 = "0";
	String sconamt2 = "0";
	
	String sEmpCnt = "0";	// 상시고용종업원 수
	String sEmpCnt1 = "0";	// 상시고용종업원 수
	String sEmpCnt2 = "0";	// 상시고용종업원 수

	// Cookie Request
	String sMngNo = "";
	if( ckMngNo.trim().length() > 8 ) {
		sMngNo = ckMngNo.substring(0,8);
	} else if( ckMngNo.trim().length() == 6 ) {
		sMngNo = ckMngNo.substring(0,5);
	} else if ( ckMngNo.trim().length() == 4 ) {
		sMngNo = ckMngNo.substring(0,3);
	}
	String sOentYYYY = ckCurrentYear;
	String sOentGB = ckOentGB;
	String sOentName = ckOentName;
	String sSentNo = ckSentNo;
	String sSQLs = "";

	/* 작성일자 표시를 위해 java 캘린더 라이브러리 참조 */
	java.util.Calendar cal = java.util.Calendar.getInstance();

	String loadMngNo		= request.getParameter("loadmngno")==null ? "":request.getParameter("loadmngno").trim();	//관리번호
	String loadConnCode		= request.getParameter("loadconncode")==null ? "":request.getParameter("loadconncode").trim();	//접속코드
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
		ConnectionResource resource = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		// 수급 사업자 정보 가져오기
		sSQLs="SELECT * FROM HADO_TB_SUBCON_"+sOentYYYY+" \n";
		sSQLs+="WHERE Child_Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";
		try {
			resource= new ConnectionResource();
			conn	= resource.getConnection();
			//System.out.println(sSQLs);
			pstmt	= conn.prepareStatement(sSQLs);
			rs		= pstmt.executeQuery();

			while (rs.next()) {
				sname		= rs.getString("Sent_Name")==null ? "":rs.getString("Sent_Name");
				scaptine		= rs.getString("Sent_Captine")==null ? "":rs.getString("Sent_Captine");
				/* 20100720 - 정광식 / NULL 인경우 0으로 기본값 세팅 */
				if( rs.getString("Sent_Amt") != null ) {
					samt	= rs.getString("Sent_Amt")==null ? "":rs.getString("Sent_Amt");
				}
				zipcode		= rs.getString("Zip_Code")==null ? "":rs.getString("Zip_Code");
				/*
				if ( zipcode.length() == 7 ) {
					zipcode1 = zipcode.substring(0, 3);
					zipcode2 = zipcode.substring(4, 7);
				} else if ( zipcode.length() == 6 ) {
					zipcode1 = zipcode.substring(0, 3);
					zipcode2 = zipcode.substring(3, 6);
				}
				*/
				address		= rs.getString("Sent_Address")==null ? "":rs.getString("Sent_Address");
				semail		= rs.getString("Assign_Mail")==null ? "":rs.getString("Assign_Mail");
				if ( (semail != null) && (!semail.equals("")) ) {
					if ( semail.indexOf("@") != -1 ) {
						semail1	= semail.substring(0, semail.indexOf("@"));
						semail2	= semail.substring(semail.indexOf("@")+1, semail.length());
					}
				}
				scompgb		= rs.getString("Comp_GB")==null ? "":rs.getString("Comp_GB");
				scono		= rs.getString("Sent_Co_No")==null ? "":rs.getString("Sent_Co_No");
				scono = scono.replaceAll("-", "");
				if( scono.length() == 13 ) {
					scono1	= scono.substring(0,6);
					scono2	= scono.substring(6,13);
				}
				ssano		= rs.getString("Sent_Sa_No")==null ? "":rs.getString("Sent_Sa_No");
				ssano = ssano.replaceAll("-", "");
				if( ssano.length() == 10) {
					ssano1	= ssano.substring(0,3);
					ssano2	= ssano.substring(3,5);
					ssano3	= ssano.substring(5,10);
				}
				/* if( rs.getString("Sent_Con_Amt") != null ) {
					sconamt	= rs.getString("Sent_Con_Amt")==null ? "":rs.getString("Sent_Con_Amt");
				} */
				/* /* 20100720 - 정광식 / NULL 인경우 0으로 기본값 세팅 * /
				if( rs.getString("Sent_Sale") != null ) {
					ssale	= rs.getString("Sent_Sale")==null ? "":rs.getString("Sent_Sale");
				}
				/* 20100720 - 정광식 / NULL 인경우 0으로 기본값 세팅 * /
				if( rs.getString("Sent_Emp_Cnt") != null ) {
					sempcnt	= rs.getString("Sent_Emp_Cnt")==null ? "":rs.getString("Sent_Emp_Cnt");
				} */
				sreggb		= rs.getString("Con_Reg_GB")==null ? "":rs.getString("Con_Reg_GB");
				sregtext		= rs.getString("Con_Reg_Text")==null ? "":rs.getString("Con_Reg_Text");
				wname		= rs.getString("Writer_Name")==null ? "":rs.getString("Writer_Name");
				worg		= rs.getString("Writer_ORG")==null ? "":rs.getString("Writer_ORG");
				wjikwi		= rs.getString("Writer_Jikwi")==null ? "":rs.getString("Writer_Jikwi");
				wtel		= rs.getString("Writer_Tel")==null ? "":rs.getString("Writer_Tel");
				wfax		= rs.getString("Writer_Fax")==null ? "":rs.getString("Writer_Fax");
				wdate		= rs.getString("Writer_Date")==null ? "":rs.getString("Writer_Date");
				/* 20140715 - 강슬기 / 조사제외대상 구분문항 변수값 세팅 */
				sSentNoExcept = rs.getString("SP_FLD_03")==null ? "":rs.getString("SP_FLD_03");
				
				/* 2021년 추가 */
				sIncorp		= rs.getString("Sent_Incorp")==null ? "":rs.getString("Sent_Incorp");
				sCompStatus = rs.getString("comp_status")==null ? "":rs.getString("comp_status");
				sQ1Etc = rs.getString("comp_status_etc")==null ? "":rs.getString("comp_status_etc");
				sSentCapa = rs.getString("sent_capa")==null ? "":rs.getString("sent_capa");
				sSentCapaTxt = rs.getString("sent_capa_etc")==null ? "":rs.getString("sent_capa_etc");
				
				ssale1	= rs.getString("Sent_Sale1")==null ? "":rs.getString("Sent_Sale1");
				ssale2	= rs.getString("Sent_Sale2")==null ? "":rs.getString("Sent_Sale2");
				ssale	= rs.getString("Sent_Sale")==null ? "":rs.getString("Sent_Sale");
				
				soper1	= rs.getString("Sent_Oper1")==null ? "":rs.getString("Sent_Oper1");
				soper2	= rs.getString("Sent_Oper2")==null ? "":rs.getString("Sent_Oper2");
				soper	= rs.getString("Sent_Oper")==null ? "":rs.getString("Sent_Oper");
				
				samt1	= rs.getString("Sent_Amt1")==null ? "":rs.getString("Sent_Amt1");
				samt2	= rs.getString("Sent_Amt2")==null ? "":rs.getString("Sent_Amt2");
				samt	= rs.getString("Sent_Amt")==null ? "":rs.getString("Sent_Amt");
				
				sconamt1	= rs.getString("SENT_CON_AMT1")==null ? "":rs.getString("SENT_CON_AMT1");
				sconamt2	= rs.getString("SENT_CON_AMT2")==null ? "":rs.getString("SENT_CON_AMT2");
				sconamt	= rs.getString("SENT_CON_AMT")==null ? "":rs.getString("SENT_CON_AMT");
				
				sEmpCnt	= rs.getString("Sent_Emp_Cnt")==null ? "":rs.getString("Sent_Emp_Cnt");
				sEmpCnt1	= rs.getString("Sent_Emp_Cnt1")==null ? "":rs.getString("Sent_Emp_Cnt1");
				sEmpCnt2	= rs.getString("Sent_Emp_Cnt2")==null ? "":rs.getString("Sent_Emp_Cnt2");
				
				/* 설립연월 */
				String[] arrTmpIncorp = sIncorp.split("-");
				if( arrTmpIncorp.length==2 ) {
					sIncorp1 = arrTmpIncorp[0];
					sIncorp2 = arrTmpIncorp[1];
				}
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

		// 하도급법이 적용되지 않는 사유 - 15년도부터 조사제외대상 문구로 변경
		sSQLs="SELECT SUBJ_ANS FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
		sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";
		sSQLs+="AND SOENT_Q_CD=30 AND SOENT_Q_GB=1 \n";
		try {
			resource= new ConnectionResource();
			conn	= resource.getConnection();
			pstmt	= conn.prepareStatement(sSQLs);
			rs		= pstmt.executeQuery();

			while (rs.next()) {
				reason = rs.getString("SUBJ_ANS")==null ? "":rs.getString("SUBJ_ANS");
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
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv='Cache-Control' content='no-cache'>
    <meta http-equiv='Pragma' content='no-cache'>
	<meta charset="utf-8">
	<title><%=st_Current_Year_n %>년도 하도급거래 서면실태 조사</title>

	<link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="utf-8" />
	<link rel="stylesheet" href="style.css" type="text/css">
	<script src="../js/jquery-1.7.min.js"></script>
    <script type="text/javascript">jQuery.noConflict();</script>
    <script src="../js/mootools-core-1.3.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/mootools-more-1.3.1.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/simplemodal.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/commonScript.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/login_2019.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/credian_common_script.js" type="text/javascript"  charset="utf-8"></script>

	<script type="text/JavaScript">
	//<![CDATA[
		ns4 = (document.layers)? true:false
		ie4 = (document.all)? true:false

		var msg = "";

		// Radio object 재선택시 초기화
		function checkradioUnit(valObj,radioObj) {
			eval("oldValue = document.info."+valObj+".value");
			eval("obj = document.info."+radioObj);
			selValue = "";

			for(i=0; i<obj.length; i++) {
				if(obj[i].checked==true) {
					selValue = obj[i].value;
					if( selValue==oldValue ) {
						obj[i].checked = false;
						eval("document.info."+valObj+".value=''");
					} else {
						eval("document.info."+valObj+".value='"+selValue+"'");
					}
					break;
				}
			}
		}

		//일반현황 불러오기 함수
		function loadf(){
			msg="";
			var main = document.info;

			if(main.loadmngno.value=="") msg=msg+"\n관리번호를 입력해 주세요.";
			if(main.loadconncode.value=="") msg=msg+"\n접속코드를 입력해 주세요.";

			if(msg!="") msg=msg+"\n";

			if(msg=="") {
				if(confirm("일반현황 정보를 불러옵니다.")) {
					//document.getElementById("loadingImage").style.display="";

					main.target = "ProceFrame";
					main.action = "WP_Comp_Info_Load.jsp";
					main.submit();
				}
			} else {
				alert(msg+"\n\n가져오기를 중단합니다.")
			}
		}

		function savef(){
			msg="";
			var main = document.info;

			// 설문 체크.
			if(main.rcomp.value=="") msg=msg+"\n회사명을 입력해 주세요.";
			//if(main.rcogb[0].checked!=true&&main.rcogb[1].checked!=true) {
				// 수급사업자 필수 항목 제거
				<%
				//msg=msg+"\n법인등록여부를 입력해주세요.";
				%>
			//} else{
				//if(main.rcogb[0].checked==true){
					if(main.rlawno1.value=="" || main.rlawno2.value=="") {
						// 수급사업자 필수 항목 제거
						<%
						//msg=msg+"\n법인등록번호를 입력해 주세요.";
						%>
					} else {
						main.rlawno.value = main.rlawno1.value+"-"+main.rlawno2.value;
					}
				//}
			//}

			if(main.rregno1.value=="" || main.rregno2.value=="" || main.rregno3.value=="") {
				// 수급사업자 필수 항목 제거
				<%
				//msg=msg+"\n사업자등록번호를 입력해 주세요.";
				%>
			} else {
				main.rregno.value = main.rregno1.value+"-"+main.rregno2.value+"-"+main.rregno3.value;
			}

			<%
			/* 수급사업자 필수 항목 제거
			if(main.rowner.value=="")		msg=msg+"\n대표자 성명을 입력해주세요.";
			
			if(main.rsale.value=="")		msg=msg+"\n연간 매출액을 입력해주세요.";
			if(main.rasset.value=="")		msg=msg+"\n자산총액을 입력해주세요.";
			if(main.rempcnt.value=="")	msg=msg+"\n상시종업원수를 입력해주세요.";
			if(main.raddr.value=="")		msg=msg+"\n본사 소재지를 입력해 주세요.";

			if(main.rposition.value=="")	msg=msg+"\n작성책임자 직위를 입력해 주세요.";
			if(main.rname.value=="")		msg=msg+"\n작성책임자 성명을 입력해 주세요.";
			if(main.rtel.value=="")			msg=msg+"\n작성책임자 전화번호를 입력해 주세요.";
			if(main.remail1.value=="" || main.remail2.value=="") msg=msg+"\n작성책임자 E-mail주소를 입력해 주세요.";
			*/%>

			if(msg!="") msg=msg+"\n";

			if(msg=="") {
				if(confirm("[ 귀사의 일반현황을 저장합니다. ]\n\n접속자가 많을경우 다소 시간이 걸릴수도 있습니다.\n정상적으로 저장이 안될경우\n수십분후에 다시시도하여 주십시오.\n\n서버의 부하로 저장에 실패할경우\n응답하신 조사내용을 복구할 수 없습니다.\n응답하신 조사표를 인쇄하여 보관하시고\n오류페이지에서 마우스오른쪽 버튼을 눌러\n새로고침을 선택하여 재저장을 시도하십시오.\n\n확인을 누르시면 저장합니다.")) {
					//document.getElementById("loadingImage").style.display="";
					processSystemStart("[1/1] 입력한 회사개요를 저장합니다.");

					//main.target = "ProceFrame";
					main.action = "WB_CP_Subcon_Qry.jsp?type=Const&step=Basic";
					main.submit();
				}
			} else {
				alert(msg+"\n\n저장이 취소되었습니다.")
			}
		}

		function researchf(obj,type,mm){
			var ccheck="no", i
			switch (type){
				case 1:
					if(obj.value=="") msg=msg+"\n"+mm
					break;
				case 2:
					for(i=0;i<obj.length;i++)
						if(obj[i].checked==true) ccheck="yes";

					if(ccheck=="no") msg=msg+"\n"+mm;
					break;
				}

		}

		function formatmoney(m){
			var money, pmoney, mlength, z, textsize, i
			textsize=20
			pmoney=""
			z=0
			money=m
			money=clearstring(money)
			money=Number(money)
			money=money+""

			for(i=money.length-1;i>=0;i--){
				z=z+1
				if(z%3==0) {
					pmoney=money.substr(i,1)+pmoney
					if(i!=0)	pmoney=","+pmoney
				}
	 else pmoney=money.substr(i,1)+pmoney
			}
			return pmoney
		}

		function clearstring(s){
			var pstr, sstr, iz
			sstr=s
			pstr=""
			for(iz=0;iz<sstr.length;iz++){
				if(!isNaN(sstr.substr(iz,1))||sstr.substr(iz,1)==".") pstr=pstr+sstr.substr(iz,1)
			}
			return pstr
		}


		function HelpWindow(url, w, h){
			helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=no,scrollbars=no,resize=no,menubar=no,location=no");
			helpwindow.focus();
		}

		function HelpWindow2(url, w, h){
			helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
			helpwindow.focus();
		}

		function fMoveTo(url){
			if(confirm("다음단계로의 이동을 선택하셨습니다.\n\n선택하신 기능은 최후 저장 후 변경한 내용을\n저장하지 않고 이동합니다.\n변경한 내용이 있을경우 저장 후 선택하십시오.\n\n확인을 누르시면 이동합니다.")) {
				location.href = url;
			}
		}

		function fSubmitFile(url){
			if(confirm("조사표 전송으로 이동합니다.\n\n선택하신 기능은 최후 저장 후 변경한 내용을\n저장하지 않고 이동합니다.\n변경한 내용이 있을경우 저장 후 선택하십시오.\n\n확인을 누르시면 이동합니다.")) {
				location.href = url;
			}
		}

		function OpenPost(){
			MsgWindow = window.open("WB_Find_Zip.jsp?ITEM=F&stype=nomr","_PostSerch","toolbar=no,width=430,height=320,directories=no,status=yes,scrollbars=yes,resize=no,menubar=no");
		}

		function byteLengCheck(frmobj, maxlength, objname, divname){
			var nbyte = 0;
			var nlen = 0;

			for(i = 0; i < frmobj.value.length; i++) {
				if(escape(frmobj.value.charAt(i)).length > 4) {
					nbyte += 2;
				} else {
					nbyte++;
				}

				if(nbyte <= maxlength) {
					nlen = i+1;
				}
			}

			obj = document.getElementById(divname);
			obj.innerText = nbyte+"/"+maxlength+"byte";

			if(nbyte > maxlength) {
				alert("최대 글자 입력수를 초과 하였습니다.");
				frmobj.value = frmobj.value.substr(0,nlen);
				obj.innerText = maxlength+"/"+maxlength+"byte";
			}

			frmobj.focus();
		}


		function erase8(){
			main = document.info;
			for(ni=0;ni<4;ni++) {
				document.info.q8[ni].checked = false;
			}
		}

		function check7(){
			main = document.info;
			if( main.q7[0].checked == true || main.q7[3].checked == true ) {
				alert("7. 귀사의 하도급거래 형태 응답을 확인 해 주세요");
				for(ni=0;ni<4;ni++) {
					erase8();
				}
			}
		}

		//2015-07-18 /강슬기/화면 인쇄시 새 창에서 출력
		function goPrint(){
			url = "WB_VP_Subcon_02_02.jsp?mode=print";
			w = 1024;
			h = 768;
			//HelpWindow2(url, w, h);

			if(confirm("화면 인쇄는 조사표 저장 후에 가능합니다.\n\n인쇄하시겠습니까?\n[확인]을 누르시면 인쇄됩니다."));{
				HelpWindow2(url, w, h);
			}
		}

		function doPrint(){
			print();
		}

		function moveNext(url){
			if(confirm("다음단계로의 이동을 선택하셨습니다.\n\n선택하신 기능은 최후 저장 후 변경한 내용을\n저장하지 않고 이동합니다.\n변경한 내용이 있을경우 저장 후 선택하십시오.\n\n확인을 누르시면 이동합니다.")) {
				location.href = url;
			}
		}

		function onDocumentInit() {
			//
		}
		//]]
	</script>
</head>

<% if (q_Cmd.equals("print")) { %>
<body onload="doPrint();">
<% } else { %>
<body onLoad="onDocumentInit();">
<% } %>

<div id="container">
	<div id="wrapper">

		<!-- Begin Header -->
		<div id="subheader">
			<ul class="lt">
				<li class="fl"><a href="/" onfocus="this.blur()"><img src="img/logo.jpg" width="242" height="55"></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"><font color="#FF6600">[
							<% if( ckOentGB.equals("1") ) {%>제조업
							<% } else if( ckOentGB.equals("2") ) {%>건설업
							<% } else if( ckOentGB.equals("3") ) {%>용역업<% } %>]</font>
							<%=ckOentName%>&nbsp;/&nbsp;<%=ckSentName%><iframe src="/Include/WB_FP_sessionClock.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" align="center" frameborder="0"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="mainmenu">1. 조사안내</a></li>
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenuup">2. 귀사의 일반현황</a></li>
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. 하도급 거래 현황</a></li>
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="mainmenu">4. 조사표 전송</a></li>
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_Add.jsp" onfocus="this.blur()" class="mainmenu">5. 신규제도관련 설문조사</a></li>
			</ul>
		</div>
		<!-- End Header -->

		<form action="" method="post" name="info">
		<!-- Begin subcontent -->
		<div id="subcontent">
			<!-- title start -->
			<h1 class="contenttitle">2. 귀사의 일반현황</h1>
			<!-- title end -->

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle"><font color="#999999">조사표를 2개 이상 작성하시는 경우 Tip</font></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt clt">
						<li><font style="font-weight:bold;" color="#ff6600">조사대상 원사업자가 2개 이상인 경우</font>에는 이미 <font style="font-weight:bold;" color="#ff6600">입력하신 귀사 일반현황 정보를 복사</font>하실 수 있습니다. 이미 입력하신 정보가 있는 경우 <font style="font-weight:bold;" color="#ff6600">정보를 입력하신 관리번호 및 접속코드(뒤4자리)를 입력</font> 후 <b>[일반현황 정보 가져오기]</b> 버튼을 클릭하십시오.</li>
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="" />
									<col style="" />
									<col style="" />
								</colgroup>
								<tbody>
								<tr>
									<td>관리번호 :
									    <input type="text" name="loadmngno" value="<%=loadMngNo%>" maxlength="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></td>
									<td>접속코드 :
									    <font style="font-weight:bold;">******</font><input type="password" name="loadconncode" value="<%=loadConnCode%>" maxlength="4" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';"></td>
									<td><a href="javascript:loadf();" onfocus="this.blur()" class="contentbutton2">일반현황 정보 가져오기</a></li>
								</tr>
								</tbody>
							</table>
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">회사개요</li>
						<li class="boxcontentsubtitle">* 회사명은 공백없이 입력<br>
						&nbsp;&nbsp;&nbsp;- 입력예시) (주) 회 사 명 <font color="red">(X)</font> --> (주)회사명 <font color="red">(0)</font><br>
						* 사업자등록증에 명시된 회사명(한글/영문)으로 기입.</li>
						<li class="boxcontentsubtitle">* 전화번호 입력 예: 02-123-4567 (대표전화 1개 입력)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:15%;" />
									<col style="width:30%;" />
									<col style="width:15%;" />
									<col style="width:40%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>관리번호</th>
										<td><strong><%=sMngNo%></strong></td>
										<th>회 사 명</th>
										<td><input type="text" name="rcomp" value="<%=sname%>" maxlength="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input></td>
									</tr>
									<tr>
										<th>법인여부</th>
										<td>
											<input type="radio" name="rcogb" value="1" <%if(scompgb!=null && scompgb.equals("1")){out.print("checked");}%>></input>법인
											<input type="radio" name="rcogb" value="0" <%if(scompgb!=null && scompgb.equals("0")){out.print("checked");}%>></input>개인사업자
										</td>
										<th>법인등록번호</th>
										<td><input type="hidden" name="rlawno" value="<%=scono%>"></input>
											<input type="text" name="rlawno1" value="<%=scono1%>" maxlength="6" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rlawno1',6,'rlawno2');"></input>-
											<input type="text" name="rlawno2" value="<%=scono2%>" maxlength="7" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';"></input>
										</td>
									</tr>
									<tr>
										<th>설립연월</th>
										<td><input type="hidden" name="rincorp" value="<%=sIncorp%>"></input>
											<input type="text" name="rincorp1" value="<%=sIncorp1%>" maxlength="6" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rincorp1',4,'rincorp2');"></input>년
											<input type="text" name="rincorp2" value="<%=sIncorp2%>" maxlength="7" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';"></input>월
										</td>
										<th>사업자등록번호</th>
										<td><input type="hidden" name="rregno" value="<%=ssano%>"></input>
											<input type="text" name="rregno1" value="<%=ssano1%>" maxlength="3" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rregno1',3,'rregno2');"></input>-
											<input type="text" name="rregno2" value="<%=ssano2%>" maxlength="2" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rregno2',2,'rregno3');"></input>-
											<input type="text" name="rregno3" value="<%=ssano3%>" maxlength="5" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';"></input>
										</td>
									</tr>
									<tr>
										<th>대표자</th>
										<td colspan="3">
											<input type="text" name="rowner" value="<%=scaptine%>" maxlength="16" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
											<%-- <input type="hidden" name="roenttype" value="<%=sOentType%>"/> --%>
										</td>
										<%-- <th>산업분류코드</th>
										<td>
											<input type="text" name="roenttype" value="<%=sOentType%>" maxlength="5" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td> --%>
									</tr>
									<tr>
										<th rowspan="3">본사</th>
										<td colspan="3">우편번호 : <input type="text" name="rpost" value="<%=zipcode%>" class="text03b"></input>&nbsp;&nbsp;<a href="javascript:OpenPost();"><img src="img/btn_post.gif" border="0" alt="우편번호 찾기" align="absmiddle"></img></a></td>
									</tr>
									<tr>
										<td colspan="3">소  재  지 : <input type="text" name="raddr" value="<%=address%>" maxlength="76" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
									</tr>
									<tr>
										<td colspan="3">전화번호(지역번호 포함) : <input type="text" name="rtel" value="<%=wtel%>" maxlength="20" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input></td>
									</tr>
									<tr>
										<th>조사표작성일</th>
										<td colspan="3">
											<%if ( wdate==null || wdate.equals("") ) {%>
												<%=cal.get(Calendar.YEAR)%>년 <%=cal.get(Calendar.MONTH)+1%>월 <%=cal.get(Calendar.DATE)%>일
											<%} else {%><%=wdate%><%}%>
										</td>
									</tr>
								</tbody>
							</table>
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>1. </span>귀사의 <%=st_Current_Year_n-1%>년도 12월 말 기준 영업 상태는 어떠합니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="radio" name="q1" value="1" <%if(sCompStatus!=null && sCompStatus.equals("1")){out.print("checked");}%> onclick="chkCompStatus();"></input> 1. 정상영업</li>
						<li><input type="radio" name="q1" value="2" <%if(sCompStatus!=null && sCompStatus.equals("2")){out.print("checked");}%> onclick="chkCompStatus();"></input> 2. 기업회생 절차 진행 중</li>
						<li><input type="radio" name="q1" value="3" <%if(sCompStatus!=null && sCompStatus.equals("3")){out.print("checked");}%> onclick="chkCompStatus();"></input> 3. 영업중단 중 또는 폐업 진행 중</li>
						<li><input type="radio" name="q1" value="4" <%if(sCompStatus!=null && sCompStatus.equals("4")){out.print("checked");}%> onclick="chkCompStatus();"></input> 4. 다른 회사와 합병 진행 중</li>
						<li><input type="radio" name="q1" value="5" <%if(sCompStatus!=null && sCompStatus.equals("5")){out.print("checked");}%> onclick="chkCompStatus();"></input> 5. 기타(<input type="text" name="q1Etc" value="<%=sQ1Etc%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>2. </span>귀사의 <%=st_Current_Year_n-1%>년도 12월 말 기준 회사규모는 무엇입니까?</li>
						<li class="boxcontentsubtitle">※ 중견기업은 중견기업법 제2조제1호의 규정에 해당하는 회사임</li>
						<li class="boxcontentsubtitle">※ 중소기업은 중소기업기본법 제2조의 규정에 해당하는 회사임</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<input type="radio" name="q2" value="1" <%if(sSentCapa!=null && sSentCapa.equals("1")){out.print("checked");}%>></input> 1. (매출액 2조원 초과) 대규모 중견기업<br/>
							<input type="radio" name="q2" value="2" <%if(sSentCapa!=null && sSentCapa.equals("2")){out.print("checked");}%>></input> 2. (매출액 3,000억원~2조원 미만) 중견기업<br/>
							<input type="radio" name="q2" value="3" <%if(sSentCapa!=null && sSentCapa.equals("3")){out.print("checked");}%>></input> 3. (매출액 800~3,000억원 미만) 소규모 중견기업<br/>
							<input type="radio" name="q2" value="4" <%if(sSentCapa!=null && sSentCapa.equals("4")){out.print("checked");}%>></input> 4. 중소기업(중기업·소기업·소상공인)<br/>
							<input type="radio" name="q2" value="5" <%if(sSentCapa!=null && sSentCapa.equals("5")){out.print("checked");}%>></input> 5. 기타(<input type="text" name="q2Etc" value="<%=sSentCapaTxt%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						</li>
						<div class="fc pt_30"></div>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>3. </span>귀사의 지난 3년간(<%=st_Current_Year_n-3%>년~<%=st_Current_Year_n-1%>년) 매출액, 영업비용, 자산총액을 응답해주십시오.</li>
						<li class="boxcontentsubtitle">* 영업비용: 손익계산서 상 매출원가, 판매비, 관리비의 합. (매출원가, 인건비, 임차료, 세금, 공과금, 감가상각비 등 생산활동에 소요된 비용을 가리킴)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:30%;" />
									<col style="width:70%;" />
								</colgroup>
								<tbody>
									<tr align="center">
										<th colspan="2">매출액</th>
									</tr>
									<tr align="center">
										<th><%= st_Current_Year_n-3%>년도</th>
										<td height="40" valign="top"><input type="text" name="q3_1" value="<%=ssale1%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount003');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
											<div id="hanAmount003" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
										</td>
									</tr>
									<tr align="center">
										<th><%= st_Current_Year_n-2%>년도</th>
										<td height="40" valign="top"><input type="text" name="q3_2" value="<%=ssale2%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount001');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
											<div id="hanAmount001" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
										</td>
									</tr>
									<tr align="center">
										<th><%= st_Current_Year_n-1%>년도</th>
										<td height="40" valign="top"><input type="text" name="q3_3" value="<%=ssale%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount002');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
											<div id="hanAmount002" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
										</td>
									</tr>
								</tbody>
							</table>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:30%;" />
									<col style="width:70%;" />
								</colgroup>
								<tbody>
									<tr align="center">
										<th colspan="2">영업비용</th>
									</tr>
									<tr align="center">
										<th><%= st_Current_Year_n-3%>년도</th>
										<td height="40" valign="top"><input type="text" name="q3_4" value="<%=soper1%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount004');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
											<div id="hanAmount004" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
										</td>
									</tr>
									<tr align="center">
										<th><%= st_Current_Year_n-2%>년도</th>
										<td height="40" valign="top"><input type="text" name="q3_5" value="<%=soper2%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount005');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
											<div id="hanAmount005" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
										</td>
									</tr>
									<tr align="center">
										<th><%= st_Current_Year_n-1%>년도</th>
										<td height="40" valign="top"><input type="text" name="q3_6" value="<%=soper%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount006');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
											<div id="hanAmount006" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
										</td>
									</tr>
								</tbody>
							</table>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:30%;" />
									<col style="width:70%;" />
								</colgroup>
								<tbody>
									<tr align="center">
										<th colspan="2">자산총액</th>
									</tr>
									<tr align="center">
										<th><%= st_Current_Year_n-3%>년도</th>
										<td height="40" valign="top"><input type="text" name="q3_7" value="<%=samt1%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount007');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
											<div id="hanAmount007" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
										</td>
									</tr>
									<tr align="center">
										<th><%= st_Current_Year_n-2%>년도</th>
										<td height="40" valign="top"><input type="text" name="q3_8" value="<%=samt2%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount008');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
											<div id="hanAmount008" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
										</td>
									</tr>
									<tr align="center">
										<th><%= st_Current_Year_n-1%>년도</th>
										<td height="40" valign="top"><input type="text" name="q3_9" value="<%=samt%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount009');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
											<div id="hanAmount009" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
										</td>
									</tr>
								</tbody>
							</table>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:30%;" />
									<col style="width:70%;" />
								</colgroup>
								<tbody>
									<tr align="center">
										<th colspan="2">시공능력평가액</th>
									</tr>
									<tr align="center">
										<th><%= st_Current_Year_n-3%>년도</th>
										<td height="40" valign="top"><input type="text" name="q3_10" value="<%=sconamt1%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount0010');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
											<div id="hanAmount0010" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
										</td>
									</tr>
									<tr align="center">
										<th><%= st_Current_Year_n-2%>년도</th>
										<td height="40" valign="top"><input type="text" name="q3_11" value="<%=sconamt2%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount0011');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
											<div id="hanAmount0011" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
										</td>
									</tr>
									<tr align="center">
										<th><%= st_Current_Year_n-1%>년도</th>
										<td height="40" valign="top"><input type="text" name="q3_12" value="<%=sconamt%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount0012');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
											<div id="hanAmount0012" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
										</td>
									</tr>
								</tbody>
							</table>
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>4. </span><%= st_Current_Year_n-1%>년 12월 말 기준, 귀사의 고용종업원 수를 응답해 주십시오.</li>
						<li class="boxcontentsubtitle">* 상용 근로자 : 계약기간이 1년 이상 또는 무기 계약 중인 근로자로서 원천징수 이행상황 신고서상의 근로소득 같이세액(A01)의 총인원</li>
						<li class="boxcontentsubtitle">* 임시 및 일용 근로자 : 계약기간이 1년 미만인 근로자</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:30%;" />
									<col style="width:70%;" />
								</colgroup>
								<tbody>
									<tr align="center">
										<th>구분</th>
										<th>근로자 수</th>
									</tr>
									<tr align="center">
										<th>총 근로자</th>
										<td>
											<input type="text" name="q4" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=sEmpCnt%>" size="6"></input> 명
										</td>
									</tr>
									<tr align="center">
										<th>상용 근로자</th>
										<td>
											<input type="text" name="q4_1" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=sEmpCnt1%>" size="6"></input> 명
										</td>
									</tr>
									<tr align="center">
										<th>임시 및 일용 근로자</th>
										<td>
											<input type="text" name="q4_2" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=sEmpCnt2%>" size="6"></input> 명
										</td>
									</tr>
								</tbody>
							</table>
						</li>
						<div class="fc pt_10"></div>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">조사제외 안내</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><span>▣</span>만일 귀사와 위 원사업자와의 거래관계가 <font style="font-weight:bold;">아래 사유</font>에 <font style="font-weight:bold;">해당</font>될 경우는 <font style="font-weight:bold;">조사 제외대상에 해당</font>됩니다.</li>
						<div class="fc pt_5"></div>
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:40%;" />
									<col style="width:60%;" />
								</colgroup>
								<thead>
									<tr>
										<th>조사 제외 대상</th>
										<th>구체적 사례</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>① 귀사가 "하도급법상의 수급사업자" <br/>&nbsp;&nbsp;&nbsp;
										요건에 해당되지 않는 경우</td>
										<td>ㆍ귀사가 공정거래법상의 <font style="font-weight:bold;">대기업</font>인 경우<br/>
										ㆍ귀사가 중소기업이고, 귀사의 시공능력평가액(<%=st_Current_Year_n-1%>년 기준)이<br/>&nbsp;&nbsp;&nbsp;위 원사업자의 시공능력평가액에 비해 큰 경우</font></td>
									</tr>
									<tr>
										<td>② 하도급거래가 아닌 경우</td>
										<td>ㆍ목적물을 판매하는 단순 <font style="font-weight:bold;">매매행위</font><br/>
										ㆍ원사업자로부터 위탁받은 목적물을 제조하지 않고 <br/>&nbsp;&nbsp;
										<font style="font-weight:bold;">단순구매</font>하여 <font style="font-weight:bold;">납품</font>하는 경우 등</td>
									</tr>
									<tr>
										<td>③ 귀사가 하도급을 주기만 하는 경우</td>
										<td>ㆍ하도급을 주기만하는 경우는 원사업자에 해당되므로,<br/>&nbsp;&nbsp;&nbsp;수급사업자로 볼 수 없음</td>
									</tr>
									<tr>
										<td>④ 하도급을 주지도 받지도 않는 경우<br/>&nbsp;&nbsp;&nbsp;(하도급거래 없음)</td>
										<td>ㆍ하도급거래가 없는 경우이므로 하도급법이 적용되지 않음</td>
									</tr>
								</tbody>
							</table>
						</li>
						<div class="fc pt_10"></div>
						<!--2015-05-07 / 조사제외대상여부 확인 문항 추가 / 강슬기 -->
						<li><span>※ </span>귀사가 <font color="#FF0066">위 사유에 해당</font>된다고 판단되실 경우에는, 아래에 그 사유를 간단하게 입력하여 주시고, 저장하신 후 <br/><font style="font-weight:bold;">「4. 조사표 전송」</font>란으로 가셔서 조사표 전송 버튼을 실행해 주시기 바랍니다.</li>
						<div class="fc pt_10"></div>
						<li><font color="#FF0000">＊ 단, 하도급법이 적용되지 않는 사유를 기재</font>(예: 수급사업자 요건 안됨, 단순 구매행위, 하도급거래 없음 등)</li>
						<ul class="lt"><input type="hidden" name="rnoexptVal" value="<%=sSentNoExcept%>"/>
							<!-- <li><input type="radio" name="rnoexpt" value="1" <%if( sSentNoExcept.equals("1")){out.print("checked");}%> onclick="checkradioUnit('rnoexptVal','rnoexpt');"> 가. 귀사가 "하도급법상의 수급사업자" 요건에 해당되지 않는 경우</li>
							<li><input type="radio" name="rnoexpt" value="2" <%if( sSentNoExcept.equals("2")){out.print("checked");}%> onclick="checkradioUnit('rnoexptVal','rnoexpt');"> 나. 하도급거래가 아닌 경우</li>
							<li><input type="radio" name="rnoexpt" value="3" <%if( sSentNoExcept.equals("3")){out.print("checked");}%> onclick="checkradioUnit('rnoexptVal','rnoexpt');"> 다. 귀사가 하도급을 주기만 하는 경우</li>
							<li><input type="radio" name="rnoexpt" value="4" <%if( sSentNoExcept.equals("4")){out.print("checked");}%> onclick="checkradioUnit('rnoexptVal','rnoexpt');"> 라. 하도급을 주지도 받지도 않는 경우(하도급거래 없음)</li> -->
							<li><textarea cols="80" rows="4" maxlength="600" name="reason" class="textarea01b" maxlength="600" onFocus="javascript:this.className='textarea01o';" onBlur="javascript:this.className='textarea01b';" onkeyup="byteLengCheck(this, 600, this.name,'content_bytes1');"><%=StringUtil.checkNull(reason)%></textarea></li>
							<li class="fr"><p align="right" style="margin-right:40px;"><span id="content_bytes1">0/600 byte</span></p></td></li>
						</ul>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="padding-left:20px;">
					<li class="boxcontenttitle"><span>▣</span>귀사가 위 조사 제외 대상이 아닐 경우에는 다음 단계인 <font style="font-weight:bold;">「3. 하도급거래 현황」</font>으로 가셔서 질문내용에 대해 작성(입력)하여 주시기 바랍니다.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<!-- 버튼 start -->
			<div class="fr">
				<ul class="lt">
					<%if ((ckMngNo.equals("HF0101")) || (ckMngNo.equals("HF0102")) || (ckMngNo.equals("HF0103")) ){%>
					<li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">화면 인쇄하기 테스트</a></li>
					<%}%>
					<li class="fl pr_2"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">저 장</a></li>
					<li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">화면 인쇄하기</a></li>
					<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="contentbutton2">3. 하도급 거래 현황으로 가기</a></li>
					<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="contentbutton2">4. 조사표 전송으로 가기</a></li>
				</ul>
			</div>
			<!-- 버튼 end -->

		</div>
		</form>
		<!-- End subcontent  -->

		<!-- Begin Footer -->
		<div id="subfooter"><img src="img/bottom.gif"></div>
		<!-- End Footer -->

	</div>
</div>

	<%
	/*-----------------------------------------------------------------------------------------------
	2011년 4월 26일 / iframe 추가 / 정광식
	:: 하도급거래상황 (설문문항) 선택 후 저장 시 오류발생으로 기존정보 소실되는 경우를 방지하기 위해
	:: 선택사항을 iframe 타겟으로 submit 시킴
	*/
	%>
	<iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
	<%/*-----------------------------------------------------------------------------------------------*/%>
	<script type="text/JavaScript">
	//<![CDATA[
	<%if ( StringUtil.checkNull(request.getParameter("isSaved")).equals("1") ) {%>
		alert("회사개요가 저장되었습니다.")
	<%}%>
	//]]
	</script>
</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>