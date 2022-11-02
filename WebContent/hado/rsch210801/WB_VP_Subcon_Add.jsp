<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명		: 2015년 수급사업자 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_VP_Subcon_Add.jsp
* 프로그램설명	: 수급사업자 > 년도별 조사표 > 2015년 업종별 조사표 > 신규제도관련 설문조사
* 프로그램버전	: 3.0.1
* 최초작성일자	: 2015년 07월 21일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2015-07-21	강슬기       최초작성
*	2016-01-12	이용광		DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_I_Global.jsp"%>
<%@ include file="../Include/WB_I_chkSession.jsp"%>

<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String[][][] qa = new String[31][22][21];
	String[][] sloan = new String[3][9];

	String sErrorMsg = "";	// 오류메시지

	String q_Cmd		= StringUtil.checkNull(request.getParameter("mode"));

	// Cookie Request
	String sMngNo = ckMngNo;
	String sOentYYYY = ckCurrentYear;
	String sOentGB = ckOentGB;
	String sOentName = ckOentName;
	String sSentNo = ckSentNo;

	String sSQLs = "";

	java.util.Calendar cal = java.util.Calendar.getInstance();
	
	String sentStatus = "";
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection processing =====================================*/
	if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
		ConnectionResource resource = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		// 배열 초기화
		for (int ni = 1; ni < 31; ni++) {
			for (int nj = 1; nj < 22; nj++) {
				for (int nk = 1; nk < 21; nk++) {
					qa[ni][nj][nk] = "";
				}
			}
		}
		for (int ni = 0; ni < 3; ni ++) {
			for (int nj = 0; nj < 9; nj++) {
				sloan[ni][nj] = "0";
			}
		}

		// 해당사업자 정보 가져오기
		sSQLs = "SELECT * FROM HADO_TB_SOENT_ANSWER_ADD \n";
		sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";
		sSQLs+="ORDER BY SOENT_Q_CD, SOENT_Q_GB \n";
		try {
			resource= new ConnectionResource();
			conn	= resource.getConnection();
			pstmt	= conn.prepareStatement(sSQLs);
			rs		= pstmt.executeQuery();

			int qcd = 0;
			int qgb = 0;
			while (rs.next()) {
				qcd = rs.getInt("soent_q_cd");
				qgb = rs.getInt("soent_q_gb");
				qa[qcd][qgb][1] = rs.getString("A")==null ? "":rs.getString("A");
				qa[qcd][qgb][2] = rs.getString("B")==null ? "":rs.getString("B");
				qa[qcd][qgb][3] = rs.getString("C")==null ? "":rs.getString("C");
				qa[qcd][qgb][4] = rs.getString("D")==null ? "":rs.getString("D");
				qa[qcd][qgb][5] = rs.getString("E")==null ? "":rs.getString("E");
				qa[qcd][qgb][6] = rs.getString("F")==null ? "":rs.getString("F");
				qa[qcd][qgb][7] = rs.getString("G")==null ? "":rs.getString("G");
				qa[qcd][qgb][8] = rs.getString("H")==null ? "":rs.getString("H");
				qa[qcd][qgb][9] = rs.getString("I")==null ? "":rs.getString("I");
				qa[qcd][qgb][10] = rs.getString("J")==null ? "":rs.getString("J");
				qa[qcd][qgb][11] = rs.getString("K")==null ? "":rs.getString("K");
				qa[qcd][qgb][12] = rs.getString("L")==null ? "":rs.getString("L");
				qa[qcd][qgb][13] = rs.getString("M")==null ? "":rs.getString("M");
				qa[qcd][qgb][14] = rs.getString("N")==null ? "":rs.getString("N");
				qa[qcd][qgb][15] = rs.getString("O")==null ? "":rs.getString("O");
				qa[qcd][qgb][16] = rs.getString("p")==null ? "":rs.getString("p");
				qa[qcd][qgb][17] = rs.getString("Q")==null ? "":rs.getString("Q");
				qa[qcd][qgb][18] = rs.getString("R")==null ? "":rs.getString("R");
				qa[qcd][qgb][19] = rs.getString("S")==null ? "":rs.getString("S");
				qa[qcd][qgb][20] = rs.getString("SUBJ_ANS")==null ? "":rs.getString("SUBJ_ANS");
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
		
		// 전송여부 확인 
		
		
		sSQLs="SELECT sent_sa_no, sent_status FROM HADO_TB_Subcon_"+sOentYYYY+" \n";
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
				sentStatus = rs.getString("sent_status");
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

		sentStatus = StringUtil.checkNull(sentStatus);
	}
/*=====================================================================================================*/
%>
<%!
public String setHiddenValue(String[][][] arrVal,int ni, int nx, int gesu)
{
	String retValue = "";
	if ( ni > 0 && nx > 0 && gesu > 0 )
	{
		for(int np=1; np<=gesu; np++) {
			if( arrVal[ni][nx][np]!=null && arrVal[ni][nx][np].equals("1") ) {
				retValue = np+"";
			}
		}
	}
	return retValue;
}
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
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv='Cache-Control' content='no-cache' />
    <meta http-equiv='Pragma' content='no-cache' />
    <title><%=st_Current_Year_n %>년도 하도급거래 서면실태 조사</title>

	<link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="utf-8" />
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
    <script src="../js/simplemodal.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/commonScript.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/login_2019.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/credian_common_script.js" type="text/javascript"  charset="utf-8"></script>
	<script type="text/javascript">
	//<![CDATA[
		ns4 = (document.layers)? true:false
		ie4 = (document.all)? true:false

		var msg = "";
		var radiof = false;

		function infoSubmit() {
			var main = document.info;

			if(confirm("[ 로그인 차단을 실행합니다. ]\n\n차단 이후에는 접속이 불가능합니다.\n확인을 누르시면 로그인 차단을 실행합니다.")) {
				//document.getElementById("loadingImage").style.display="";
				main.target = "ProceFrame";
				main.action = "WB_CP_Subcon_Qry.jsp?step=Block2";
				main.submit();
			}
		}

		function savef(){
			var main = document.info;

			msg = "";

			relationf(main);

			//----> 하도급대금지급 (18번) :: researchf( object(개체이름까지작성), 개체타입(1:text,2:radio,3:checkbox), 선택없을 시 출력메시지);
			//research2f(main, 1, 18, 2, 0);

			// 연계문항 선택 확인
			//--> 입력여부 확인 :: research3f(form-name, 연계문항대번호, 연계문항소번호, 개체타입(1:text,2:radio,3:checkbox), 보기개수(checkbox만 해당 아니면 0), 선선택(조건)문항대번호, 선선택(조건)문항소번호);
			//--> 문항초기화 :: initf(form-name, 문항대번호, 문항소번호, 개체타입(2:radio,3:checkbox), 0보기개수(checkbox만 해당 아니면 0));


			if(msg=="") {
				if(confirm("[ 설문조사 응답내역을 전송합니다. ]")) {

					//document.getElementById("loadingImage").style.display="";
					processSystemStart("[1/1] 입력한 응답내역을 저장합니다.");

					main.target = "proceFrame";
					main.action = "WB_CP_Subcon_Qry.jsp?step=Add";
					main.submit();
				}
			} else {
				alert(msg+"\n\n전송이 취소되었습니다.")
			}

		}

		function relationf(main){
			msg = "";
			
			// 필수 입력문항 체크 :: research2f( form-name, 대번호, 소번호, 개체타입(1:text,2:radio,3:checkbox),보기개수(checkbox만 해당 아니면 0) );
			research2f(main, 1, 1, 2, 0);
			research2f(main, 1, 2, 2, 0);
			research2f(main, 1, 3, 2, 0);
			research2f(main, 1, 4, 2, 0);
			//if( (main.q1_2[1].checked==true) || (main.q1_3[1].checked==true) ) { research3f(main, 1, 4, 2, 0, 1, 2); research3f(main, 1, 4, 2, 0, 1, 3); } else initf(main, 1, 4, 2, 0);
			//if( main.q1_2[1].checked==true ) { research3f(main, 1, 4, 2, 0, 1, 2); } else initf(main, 1, 4, 2, 0);
			//if( main.q1_3[1].checked==true ) { research3f(main, 1, 4, 2, 0, 1, 3); } else initf(main, 1, 4, 2, 0);
			research2f(main, 1, 5, 2, 0);
			research2f(main, 1, 6, 2, 0);
			research2f(main, 1, 7, 2, 0);
			//if( (main.q1_5[1].checked==true) || (main.q1_6[1].checked==true) ) { research3f(main, 1, 7, 2, 0, 1, 5); research3f(main, 1, 7, 2, 0, 1, 6); } else initf(main, 1, 7, 2, 0);
			research2f(main, 1, 8, 2, 0);
			research2f(main, 1, 9, 2, 0);
			research2f(main, 1, 10, 2, 0);
			//if( (main.q1_8[1].checked==true) || (main.q1_9[1].checked==true) ) { research3f(main, 1, 10, 2, 0, 1, 8); research3f(main, 1, 10, 2, 0, 1, 9); } else initf(main, 1, 10, 2, 0);
			research2f(main, 1, 11, 2, 0);
			research2f(main, 1, 12, 2, 0);
			research2f(main, 1, 13, 2, 0);
			//if( (main.q1_11[1].checked==true) || (main.q1_12[1].checked==true) ) { research3f(main, 1, 13, 2, 0, 1, 11); research3f(main, 1, 13, 2, 0, 1, 12); } else initf(main, 1, 13, 2, 0);
			research2f(main, 2, 14, 2, 0);
			research2f(main, 2, 15, 2, 0);
			research2f(main, 2, 16, 2, 0);
			research2f(main, 2, 17, 2, 0);
			//if( (main.q2_15[1].checked==true) || (main.q2_16[1].checked==true) ) { research3f(main, 2, 17, 2, 0, 2, 15); research3f(main, 2, 17, 2, 0, 2, 16); } else initf(main, 2, 17, 2, 0);
			research2f(main, 3, 18, 2, 0);
			research2f(main, 3, 19, 2, 0);
			research2f(main, 3, 20, 2, 0);
			//if( (main.q3_18[1].checked==true) || (main.q3_19[1].checked==true) ) { research3f(main, 3, 20, 2, 0, 3, 18); research3f(main, 3, 20, 2, 0, 3, 19); } else initf(main, 3, 20, 2, 0);
			research2f(main, 3, 21, 2, 0);

			// 연계문항 선택 확인
			//--> 입력여부 확인 :: research3f(form-name, 연계문항대번호, 연계문항소번호, 개체타입(1:text,2:radio,3:checkbox), 보기개수(checkbox만 해당 아니면 0),
			//-->                             선선택(조건)문항대번호, 선선택(조건)문항소번호);
			//--> 문항초기화 :: initf(form-name, 문항대번호, 문항소번호, 개체타입(2:radio,3:checkbox), 0보기개수(checkbox만 해당 아니면 0));
			// 연계문항 끝

			
		}

		function checkradio(ni, nx){
			eval("oldValue = document.info.c"+ni+"_"+nx+".value");
			eval("obj = document.info.q"+ni+"_"+nx);
			selValue = "";

			for(i=0; i<obj.length; i++) {
				if(obj[i].checked==true) {
					selValue = (i+1)+"";
					break;
				}
			}

			if(selValue != "") {
				if(selValue == oldValue) {
					eval("document.info.c"+ni+"_"+nx+".value = ''");
					initf(document.info, ni, nx, 2, 0);
					relationf(document.info);
				} else {
					eval("document.info.c"+ni+"_"+nx+".value = selValue");
					relationf(document.info);
				}
			}
		}

		function initf(obj,fno,sno,type,gesu){
			switch(type){
				case 2:
					eval("for(i=0;i<obj.q"+fno+"_"+sno+".length;i++) obj.q"+fno+"_"+sno+"[i].checked=false")
					break;
				case 3:
					for(i=1;i<=gesu;i++)
						eval("obj.q"+fno+"_"+sno+"_"+i+".checked=false")
					break;
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

		//-- 필수항목 선택여부 확인 --//
			function research2f(obj,fno,sno,type,gesu) {
				var ccheck="no", i;
				switch (type) {
					case 1:	// text
						ccheck="yes";
						eval("if(obj.q"+fno+"_"+sno+".value=='') ccheck='no'");
						break;
					case 2:	// Radio
						eval("for(i=0;i<obj.q"+fno+"_"+sno+".length;i++) if(obj.q"+fno+"_"+sno+"[i].checked==true) ccheck='yes'");
						break;
					case 3:	// checkbox
						for(i=1;i<=gesu;i++)
							eval("if(obj.q"+fno+"_"+sno+"_"+i+".checked==true) ccheck='yes'");
						break;
				}

				if(ccheck=="no") {
					msg=msg+"\n";
					if( type=="1" ) {
						eval("msg=msg+'[ "+toRoman(fno)+" ]의 "+sno+"번을 입력하여 주십시오.'");
					} else {
						eval("msg=msg+'[ "+toRoman(fno)+" ]의 "+sno+"번을 선택하여 주십시오.'");
					}
				}
			}

		//-- 연계항목 선택여부 확인 --//
		function research3f(obj,fno,sno,type,gesu,ofno,osno){
			var ccheck="no", i
			switch (type){
				case 1:	// text
					ccheck="yes"
					eval("if(obj.q"+fno+"_"+sno+".value=='') ccheck='no'");
					break;
				case 2:	// Radio
					eval("for(i=0;i<obj.q"+fno+"_"+sno+".length;i++) if(obj.q"+fno+"_"+sno+"[i].checked==true) ccheck='yes'")
					break;
				case 3:	// checkbox
					for(i=1;i<=gesu;i++)
						eval("if(obj.q"+fno+"_"+sno+"_"+i+".checked==true) ccheck='yes'")
					break;
			}

			if(ccheck=="no"){
				msg=msg+"\n"
				if( type=="1") {
					eval("msg=msg+'[ "+toRoman(ofno)+" ]의 "+osno+"번의 연계문항 [ "+toRoman(fno)+" ]의 "+sno+"번을 입력하여 주십시오.'");
				} else {
					eval("msg=msg+'[ "+toRoman(ofno)+" ]의 "+osno+"번의 연계문항 [ "+toRoman(fno)+" ]의 "+sno+"번을 선택하여 주십시오.'");
				}
			}
		}
		
		function toRoman(num) {
			var result = '';
			var decimal = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
			var roman = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];
			for (var i = 0; i <= decimal.length; ++i) {
			// looping over every element of our arrays
				while (num%decimal[i] < num) {
				// kepp trying the same number until it won't fit anymore.
					result += roman[i];
					// add the matching roman number to our result string
					num -= decimal[i];
					// remove the decimal value of the roman number from our number
				}
			}
			return result;
		}

		function noanswerf(obj,fno,sno,tno,type,gesu,ft1,ft2){
			var ccheck="no"
			if(fno==9&&sno==3){
				if(ft1!="z")
					eval("if(obj.q"+fno+"_"+sno+"_"+ft1+".checked==false&&obj.q"+fno+"_"+sno+"_"+ft2+".checked==false) ccheck='yes'")
			} else {
				if(ft1!="z")
					eval("if(obj.q"+fno+"_"+sno+"["+ft1+"].checked==true) ccheck='yes'")
				if(ft2!="z")
					eval("if(obj.q"+fno+"_"+sno+"["+ft2+"].checked==true) ccheck='yes'")
			}

			if(ccheck=="yes"){
				eval("alert('응답오류 : "+fno+"번의 ("+sno+")번 응답확인 요망 ')")
				switch(type){
					case 2:
						eval("for(i=0;i<obj.q"+fno+"_"+tno+".length;i++) obj.q"+fno+"_"+tno+"[i].checked=false")
						break;
					case 3:
						for(i=1;i<=gesu;i++)
							eval("obj.q"+fno+"_"+tno+"_"+i+".checked=false")
						break;
				}

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

		function view_layer(obj){
			var listDiv = eval("document.getElementById('"+obj+"')");
			var topx = 50;
			var leftx = 60;

			if(NS4) {
				//var e = window.event;
				//listDiv.style.top = e.clientY+document.body.scrollTop+document.documentElement.scrollTop - topx;
				listDiv.style.top = document.body.scrollTop+document.documentElement.scrollTop+topx;
				//listDiv.style.left = e.clientX+document.body.scrollLeft+document.documentElement.scrollLeft - leftx;
				listDiv.style.left = document.body.scrollLeft+document.documentElement.scrollLeft+leftx;
			} else {
				//listDiv.style.posTop = event.y+document.body.scrollTop - topx;
				listDiv.style.posTop = document.body.scrollTop+topx;
				//listDiv.style.posLeft = event.x+document.body.scrollLeft - leftx;
				listDiv.style.posLeft = document.body.scrollLeft+leftx;
			}
		}

		function ShowInfo(str){
			vTime = 5;

			infoLayerText.innerHTML = "<font color='#006633'>"+str+"</font>";

			goShowInfo();
			infotimer = setInterval(goShowInfo,1000)
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
		function ohapf(main){
			main.thalf1.value=Cnum(main.rcurrency1.value)+Cnum(main.rbill1.value)+Cnum(main.retc1.value)+Cnum(main.rcard1.value)+Cnum(main.rloan1.value)+Cnum(main.rcred1.value)+Cnum(main.rbuy1.value)+Cnum(main.rnetwork1.value)

			main.thalf1.value=suwithcomma(main.thalf1.value)

			main.percurrency.value=Cnum(Math.round(Cnum(main.rcurrency1.value)/Cnum(main.thalf1.value)*100))
			main.percard.value=Cnum(Math.round(Cnum(main.rcard1.value)/Cnum(main.thalf1.value)*100))
			main.perloan.value=Cnum(Math.round(Cnum(main.rloan1.value)/Cnum(main.thalf1.value)*100))
			main.percred.value=Cnum(Math.round(Cnum(main.rcred1.value)/Cnum(main.thalf1.value)*100))
			main.perbill.value=Cnum(Math.round(Cnum(main.rbill1.value)/Cnum(main.thalf1.value)*100))
			main.perbuy.value=Cnum(Math.round(Cnum(main.rbuy1.value)/Cnum(main.thalf1.value)*100))
			main.pernetwork.value=Cnum(Math.round(Cnum(main.rnetwork1.value)/Cnum(main.thalf1.value)*100))
			main.peretc.value=Cnum(Math.round(Cnum(main.retc1.value)/Cnum(main.thalf1.value)*100))
			main.tper.value=100

		}

		function Openpost(){
			MsgWindow = window.open("srchzipcode.jsp?ITEM=F&stype=prod3","_postSerch","toolbar=no,width=430,height=320,directories=no,status=yes,scrollbars=yes,resize=no,menubar=no");
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

		function Cnum(aa){
			bb=aa+"";
			while (bb.indexOf(",") != -1)
			{
				bb=bb.replace(",","") ;
			}
			if(isNaN(bb)||bb==''||bb==null)
				return 0
			else
				return Number(bb);
		}

		function sumf(main){
		}

		// 크레디앙 커몬 스크립트..
		var SU_COMMA = ',';

		// 문자열 치환
		function kreplace(str,str1,str2) {

			if (str == "" || str == null) return str;

			while (str.indexOf(str1) != -1) {
				str = str.replace(str1,str2);
			}
			return str;
		//	if (isNaN(str)) return str;
		//
		//	if (isFloat(str))
		//		return parseFloat(str);
		//	else
		//		return parseInt(str);
		}

		// 실수인지를 확인한다.
		function isFloat(str) {
			return (str.indexOf('.') != -1);
		}

		// 숫자에 컴마를 삽입한다.
		function suwithcomma(su) {

			su = kreplace(su,',','');

			var rtn = '';
			var fd = false;
			// 입력된 값을 검사하여 숫자가 아닌 경우 0을 돌려준다.
			// 숫자인 경우에는 문자열로 바꾼다.
			if (isNaN(su)) {
				alert("숫자를 입력하셔야 합니다.");
				return 0;
			} else {
				su = new String(su);
			}

			n = su.indexOf('.');
			if (n<0) {
				n = parseInt(su.length);
			} else {
				fd = true;
			}

			while (su.indexOf('0') == 0 ) {
				if (!fd) {
					su = su.substring(1,su.length);
				} else {
					if (n > 1) {
						su = su.substring(1, su.length);
						n --;
					} else {
						return su;
					}
				}
			}
			cnt = parseInt(n / 3);
		//	alert(cnt);
			mod = parseInt(n % 3);
		//	alert(mod);
			if (mod>0) {
				rtn = su.substring(0,mod);
				if (cnt > 0) rtn = rtn+SU_COMMA;
			}
			for (i = 0; i < cnt ; i++) {
				idx = i*3+mod;
				if (idx == 0) {
					rtn = su.substring(idx,idx+3);
					if (cnt > 1) rtn = rtn+SU_COMMA;
				} else {
					rtn = rtn+su.substring(idx,idx+3);
					if (idx < n - 3) rtn = rtn+SU_COMMA;
				}

			}
			if (fd) rtn = rtn+su.substring(n,su.length);
			return rtn;
		}

		// 숫자값, "."인지를 체크한다.
		function checkStringValid(src){
			var len = src.value.length;

			for(var i=0;i<len;i++){
				if ((!isDecimal(src.value.charAt(i)) || src.value.charAt(i)==" ") && src.value.charAt(i)!="." ){
					assortString(src,i);
					i=0;
				}
			}

		}

		// 숫자를 조립한다.
		function assortString(source,index){
			var len = source.value.length;
			var temp1 = source.value.substring(0,index);
			var temp2 = source.value.substring(index+1,len);
			source.value = temp1+temp2;
		}

		// 10진수값을 가지고 있는지 확인한다.
		function isDecimal(number){
			if (number>=0 && number<=9)  return true;
			else return false;
		}

		// 소수점이 두개 이상입력되면 마지막 점은 삭제한다.
		function ispoint(src) {
			if ((p1 = src.value.indexOf('.')) != -1) {
				if ((p2 = src.value.indexOf('.',p1+1)) != -1) {
					src.value = src.value.substring(0,p2);
					return true;
				}
			}
			return false;
		}

		// 키코드를 검사하고 콘트롤의 값에 컴마를 삽입한다.
		function sukeyup(src) {

			if (sukeyup_n(src)) {
				src.value = suwithcomma(src.value);
				return true;
			}
			return false;
		}
		// 입력값을 검사한다.
		function sukeyup_n(src) {

			keycode = window.event.keyCode;
			//alert(isArrowKey(keycode));
			if (isArrowKey(keycode) || keycode == 13 || ispoint(src)) {
				return false;
			}
			checkStringValid(src);

			if (src.value == '' || src.value == '0') {
				src.value = 0;
				return false;
			}

			if (src.value == '.' || src.value == '0.') {
				src.value = '0.';
				return false;
			}

			if(!isNaN(src.value)) {

				if (src.value.indexOf('.') == 1) return false;
				if (src.value.length <= 3) {
					if (src.value.indexOf('0') == 0)
						src.value = src.value.substring(1,src.value.length);
					return false;
				}

			}
			return true;
		}

		// 누른 키가 화살표인지를 확인한다.
		function isArrowKey(key){
			if(key>=37 && key<=40) return true;
			else return false;
		}

		// 숫자 최대값 보다 큰 경우 최대값을 입력한다.
		// vmax : 최대값
		function isMax(src,vmax) {

			var sv = src.value;
			var smax = suwithcomma(new String(vmax));
			sv = parseFloat(kreplace(sv,',',''));

			if (sv > vmax) {
				alert('최대값('+smax+')보다 큰 값이 입력 되었습니다.');
				src.value = smax;
				return false;
			}
			return true;
		}
		//
		//function suMax(src,vmax) {
		//	isMax(src,vmax);
		//	sukeyup(src);
		//}
		function suwithdec(src,dec) {
			sukeyup(src);
			wpoint(src,dec);
		}

		//
		function isMonth(src) {

			onlyNumeric(src);
			v = parseInt(src.value);
			if ((v < 1) || (v > 12)) {
				alert("월을 입력 하셔야 합니다.");
				src.value = new Date().getMonth();
				return false;
			}
			return true;

		}

		// 숫자값만을 입력받는다.
		function onlyNumeric(src){
			var len = src.value.length;

			for(var i=0;i<len;i++){
				if (!isDecimal(src.value.charAt(i)) || src.value.charAt(i)==" ") {
					assortString(src,i);
					i=0;
				}
			}

		}

		// 지정된 소수점 이하의 수는 버린다.
		function wpoint(src,dec) {
			if ((p = src.value.indexOf('.')) != -1) {
				if (src.value.length > p+dec+1) {
					src.value = src.value.substring(0,p+dec+1);
				}
			}
		}

		function onDocumentInit(){
			ohapf(document.info);
			sumf(document.info);
			// 초기 로드 시 체크박스 비활성화
			/*
			var cbox = 12;	// 체크박스 개수
			for (var z=1; z<=cbox; z++){
				var obj = document.getElementById("chbox"+z).getElementsByTagName("input");
				for (var i=0; i<obj.length; i++){
					obj[i].disabled = true;
				}
			}
			*/
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

		function goPrint(){
			print();
		}

		function moveNext(url){
			if(confirm("다음단계로의 이동을 선택하셨습니다.\n\n선택하신 기능은 최후 저장 후 변경한 내용을\n저장하지 않고 이동합니다.\n변경한 내용이 있을경우 저장 후 선택하십시오.\n\n확인을 누르시면 이동합니다.")) {
				location.href = url;
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
							<% if( ckOentGB.equals("1") ) {%>제조업
							<% } else if( ckOentGB.equals("2") ) {%>건설업
							<% } else if( ckOentGB.equals("3") ) {%>용역업<% } %>]</font>
							<%=ckOentName%>&nbsp;/&nbsp;<%=ckSentName%><iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" style="vertical-align: text-bottom;" frameborder="0"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="./WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="mainmenu">1. 조사안내</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. 귀사의 일반현황</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. 하도급 거래 현황</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="mainmenu">4. 조사표 전송</a></li>
				<li class="fl pr_2"><a href="./WB_VP_Subcon_Add.jsp" onfocus="this.blur()" class="mainmenuup">5. 신규제도관련 설문조사</a></li>
			</ul>
		</div>
		<!-- End Header -->

		<form action="" method="post" name="info">
		<!-- Begin subcontent -->
		<div id="subcontent">
			<!-- title start -->
			<h1 class="contenttitle">5. 신규제도관련 설문조사</h1>
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
						<li><span>ㅇ</span>이에 새로 도입된 제도가 수급사업자에게 실제로 도움이 되고 있는지 여부를 파악하고, 필요한 제도 보완사항을 마련하기 위한 자료로 활용하기 위해 본 조사를 실시하고자 하오니, <font style="font-weight:bold;" color="#3333CC">사업으로 바쁘시겠지만 잠시 시간을 할애하시어 본 조사에 적극적으로 응하여 주시기 바랍니다.</font></li>
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
						<li><span></span>☏ 044-200-4595, 044-200-4592~4, 044-200-4585~7, 044-200-4589</li>
					</ul>
				</div>
				<div class="fc"></div>
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
					<li style="width:95%; " class="boxcontenttitle"><span>▣</span>대기업 등의 불공정한 행위를 억제하고 피해를 입은 중소기업의 권리를 강화하기 위하여 3배 손해배상제 적용대상을 <font style="font-weight:bold;"><font style="text-decoration: underline; ">'기술유용행위'</font>에서 <font style="text-decoration: underline;">'부당한 하도급 대금결정ㆍ감액, 부당위탁 취소 및 부당반품'으로 확대<font >(하도급법 개정, 2013.11.29. 시행)</font></font></font>하였습니다. 대기업 등이 위 불공정행위를 한 경우 시정명령, 과징금, 벌금 등이 부과될 뿐만 아니라, 피해를 입은 <font style="font-weight:bold; ">중소기업은 법원에 손해배상 청구를 하여 손해액의 3배까지 배상을 받을 수 있게 되었습니다.</font></li>
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
				<input type="hidden" name="c1_1" value="<%=setHiddenValue(qa, 1, 1, 5)%>" />
					<ul class="lt">
						<li><input type="radio" name="q1_1" value="1" <%if(qa[1][1][1]!=null && qa[1][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 1);" /> 가. 잘 알고 있음</li>
						<li><input type="radio" name="q1_1" value="2" <%if(qa[1][1][2]!=null && qa[1][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 1);" /> 나. 대체로 알고 있음</li>
						<li><input type="radio" name="q1_1" value="3" <%if(qa[1][1][3]!=null && qa[1][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(1, 1);" /> 다. 약간 알고 있음</li>
						<li><input type="radio" name="q1_1" value="4" <%if(qa[1][1][4]!=null && qa[1][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(1, 1);" /> 라. 잘 모름</li>
						<li><input type="radio" name="q1_1" value="5" <%if(qa[1][1][5]!=null && qa[1][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(1, 1);" /> 마. 전혀 모름</li>
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
						<li class="boxcontenttitle"><span>2. </span> <font style="font-weight:bold;"><%=st_Current_Year_n-1%>년도 상반기(<%=st_Current_Year_n-1%>.1.1.∼<%=st_Current_Year_n-1%>.6.30.)</font>동안 원사업자가 부당하게 하도급대금을 결정하거나 감액한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c1_2" value="<%=setHiddenValue(qa, 1, 2, 2)%>" />
					<ul class="lt">
						<li><input type="radio" name="q1_2" value="1" <%if(qa[1][2][1]!=null && qa[1][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 2);" /> 가. 없었음</li>
						<li><input type="radio" name="q1_2" value="2" <%if(qa[1][2][2]!=null && qa[1][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 2);"  /> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>3. </span> <font style="font-weight:bold;"><%=st_Current_Year_n%>년도 상반기(<%=st_Current_Year_n%>.1.1.∼<%=st_Current_Year_n%>.6.30.)</font>동안 원사업자가 부당하게 하도급대금을 결정하거나 감액한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c1_3" value="<%=setHiddenValue(qa, 1, 3, 2)%>" />
					<ul class="lt">
						<li><input type="radio" name="q1_3" value="1" <%if(qa[1][3][1]!=null && qa[1][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 3);" /> 가. 없었음</li>
						<li><input type="radio" name="q1_3" value="2" <%if(qa[1][3][2]!=null && qa[1][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 3);" /> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>4. </span> 원사업자의 부당한 하도급대금 결정ㆍ감액 행위는 <%=st_Current_Year_n-1%>년도 상반기와 비교하여 <%=st_Current_Year_n%>년도 상반기에 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c1_4" value="<%=setHiddenValue(qa, 1, 4, 5)%>" />
					<ul class="lt">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_4" value="1" <%if(qa[1][4][1]!=null && qa[1][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 4);" /> 5점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_4" value="2" <%if(qa[1][4][2]!=null && qa[1][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 4);" /> 4점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_4" value="3" <%if(qa[1][4][3]!=null && qa[1][4][3].equals("1")){out.print("checked");}%> onclick="checkradio(1, 4);" /> 3점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_4" value="4" <%if(qa[1][4][4]!=null && qa[1][4][4].equals("1")){out.print("checked");}%> onclick="checkradio(1, 4);" /> 2점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_4" value="5" <%if(qa[1][4][5]!=null && qa[1][4][5].equals("1")){out.print("checked");}%> onclick="checkradio(1, 4);" /> 1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선되고 있음 ◀────────────────────────▶전혀 개선되지 않고 있음</li>
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
						<li class="boxcontenttitle"><span>5. </span> <font style="font-weight:bold;"><%=st_Current_Year_n-1%>년도 상반기(<%=st_Current_Year_n-1%>.1.1.∼<%=st_Current_Year_n-1%>.6.30.)</font>동안 귀사의 귀책사유가 없음에도 불구하고 원사업자가 하도급 계약을 일방적으로 취소한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c1_5" value="<%=setHiddenValue(qa, 1, 5, 2)%>" />
					<ul class="lt">
						<li><input type="radio" name="q1_5" value="1" <%if(qa[1][5][1]!=null && qa[1][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 5);" /> 가. 없었음</li>
						<li><input type="radio" name="q1_5" value="2" <%if(qa[1][5][2]!=null && qa[1][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 5);"  /> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>6. </span> <font style="font-weight:bold;"><%=st_Current_Year_n%>년도 상반기(<%=st_Current_Year_n%>.1.1.∼<%=st_Current_Year_n%>.6.30.)</font>동안 귀사의 귀책사유가 없음에도 불구하고 원사업자가 하도급 계약을 일방적으로 취소한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c1_6" value="<%=setHiddenValue(qa, 1, 6, 2)%>" />
					<ul class="lt">
						<li><input type="radio" name="q1_6" value="1" <%if(qa[1][6][1]!=null && qa[1][6][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 6);" /> 가. 없었음</li>
						<li><input type="radio" name="q1_6" value="2" <%if(qa[1][6][2]!=null && qa[1][6][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 6);" /> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>7. </span> 원사업자의 부당한 위탁취소 행위는 <%=st_Current_Year_n-1%>년도 상반기와 비교하여 <%=st_Current_Year_n%>년도 상반기에 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c1_7" value="<%=setHiddenValue(qa, 1, 7, 5)%>" />
					<ul class="lt">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_7" value="1" <%if(qa[1][7][1]!=null && qa[1][7][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 7);" /> 5점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_7" value="2" <%if(qa[1][7][2]!=null && qa[1][7][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 7);" /> 4점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_7" value="3" <%if(qa[1][7][3]!=null && qa[1][7][3].equals("1")){out.print("checked");}%> onclick="checkradio(1, 7);" /> 3점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_7" value="4" <%if(qa[1][7][4]!=null && qa[1][7][4].equals("1")){out.print("checked");}%> onclick="checkradio(1, 7);" /> 2점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_7" value="5" <%if(qa[1][7][5]!=null && qa[1][7][5].equals("1")){out.print("checked");}%> onclick="checkradio(1, 7);" /> 1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선되고 있음 ◀────────────────────────▶전혀 개선되지 않고 있음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span></span>3배 손해배상제 적용대상 중 <font style="font-weight:bold;">부당반품 관련</font>입니다. 원사업자가 <font style="font-weight:bold;">목적물의 납품 등을 받은 후 일방적으로 반품하는 행위</font>에 대해 아래 8~10번 문항에<br/>응답하여 주시기 바랍니다.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>8. </span> <font style="font-weight:bold;"><%=st_Current_Year_n-1%>년도 상반기(<%=st_Current_Year_n-1%>.1.1.∼<%=st_Current_Year_n-1%>.6.30.)</font>동안 귀사의 귀책사유가 없음에도 불구하고 원사업자가 목적물의 납품 등을 받은 후 반품한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c1_8" value="<%=setHiddenValue(qa, 1, 8, 2)%>" />
					<ul class="lt">
						<li><input type="radio" name="q1_8" value="1" <%if(qa[1][8][1]!=null && qa[1][8][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 8);" /> 가. 없었음</li>
						<li><input type="radio" name="q1_8" value="2" <%if(qa[1][8][2]!=null && qa[1][8][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 8);" /> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>9. </span> <font style="font-weight:bold;"><%=st_Current_Year_n%>년도 상반기(<%=st_Current_Year_n%>.1.1.∼<%=st_Current_Year_n%>.6.30.)</font>동안 귀사의 귀책사유가 없음에도 불구하고 원사업자가 목적물의 납품 등을 받은 후 반품한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c1_9" value="<%=setHiddenValue(qa, 1, 9, 2)%>" />
					<ul class="lt">
						<li><input type="radio" name="q1_9" value="1" <%if(qa[1][9][1]!=null && qa[1][9][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 9);" /> 가. 없었음</li>
						<li><input type="radio" name="q1_9" value="2" <%if(qa[1][9][2]!=null && qa[1][9][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 9);" /> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>10. </span> 원사업자의 부당반품 행위는 <%=st_Current_Year_n-1%>년도 상반기와 비교하여 <%=st_Current_Year_n%>년도 상반기에 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c1_10" value="<%=setHiddenValue(qa, 1, 10, 5)%>" />
					<ul class="lt">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_10" value="1" <%if(qa[1][10][1]!=null && qa[1][10][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 10);" /> 5점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_10" value="2" <%if(qa[1][10][2]!=null && qa[1][10][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 10);" /> 4점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_10" value="3" <%if(qa[1][10][3]!=null && qa[1][10][3].equals("1")){out.print("checked");}%> onclick="checkradio(1, 10);" /> 3점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_10" value="4" <%if(qa[1][10][4]!=null && qa[1][10][4].equals("1")){out.print("checked");}%> onclick="checkradio(1, 10);" /> 2점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_10" value="5" <%if(qa[1][10][5]!=null && qa[1][10][5].equals("1")){out.print("checked");}%> onclick="checkradio(1, 10);" /> 1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선되고 있음 ◀────────────────────────▶전혀 개선되지 않고 있음</li>
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
						<li class="boxcontenttitle"><span>11. </span> <font style="font-weight:bold;"><%=st_Current_Year_n-1%>년도 상반기(<%=st_Current_Year_n-1%>.1.1.∼<%=st_Current_Year_n-1%>.6.30.)</font>동안 원사업자가 귀사로부터 취득한 기술자료를 원사업자 또는 제3자의 이익을 위해 사용함으로써 귀사에게 손해가 발생한 경험이 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c1_11" value="<%=setHiddenValue(qa, 1, 11, 2)%>" />
					<ul class="lt">
						<li><input type="radio" name="q1_11" value="1" <%if(qa[1][11][1]!=null && qa[1][11][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 11);" /> 가. 없었음</li>
						<li><input type="radio" name="q1_11" value="2" <%if(qa[1][11][2]!=null && qa[1][11][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 11);" /> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>12. </span> <font style="font-weight:bold;"><%=st_Current_Year_n%>년도 상반기(<%=st_Current_Year_n%>.1.1.∼<%=st_Current_Year_n%>.6.30.)</font>동안 원사업자가 귀사로부터 취득한 기술자료를 원사업자 또는 제3자의 이익을 위해 사용함으로써 귀사에게 손해가 발생한 경험이 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c1_12" value="<%=setHiddenValue(qa, 1, 12, 2)%>" />
					<ul class="lt">
						<li><input type="radio" name="q1_12" value="1" <%if(qa[1][12][1]!=null && qa[1][12][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 12);" /> 가. 없었음</li>
						<li><input type="radio" name="q1_12" value="2" <%if(qa[1][12][2]!=null && qa[1][12][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 12);" /> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>13. </span> 원사업자의 기술유용 행위는 <%=st_Current_Year_n-1%>년도 상반기와 비교하여 <%=st_Current_Year_n%>년도 상반기에 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c1_13" value="<%=setHiddenValue(qa, 1, 13, 5)%>" />
					<ul class="lt">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q1_13" value="1" <%if(qa[1][13][1]!=null && qa[1][13][1].equals("1")){out.print("checked");}%> onclick="checkradio(1, 13);" /> 5점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_13" value="2" <%if(qa[1][13][2]!=null && qa[1][13][2].equals("1")){out.print("checked");}%> onclick="checkradio(1, 13);" /> 4점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_13" value="3" <%if(qa[1][13][3]!=null && qa[1][13][3].equals("1")){out.print("checked");}%> onclick="checkradio(1, 13);" /> 3점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_13" value="4" <%if(qa[1][13][4]!=null && qa[1][13][4].equals("1")){out.print("checked");}%> onclick="checkradio(1, 13);" /> 2점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q1_13" value="5" <%if(qa[1][13][5]!=null && qa[1][13][5].equals("1")){out.print("checked");}%> onclick="checkradio(1, 13);" /> 1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선되고 있음 ◀────────────────────────▶전혀 개선되지 않고 있음</li>
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
					<li class="boxcontenttitle"><span>▣</span>합의(특약)를 명분으로 <font style="font-weight:bold;">대기업 등이 부담해야 할 각종 비용(예:민원처리 비용 등)을 중소기업에게 전가하는 관행을 개선</font>하기 위해 하도급계약에서<br/><font style="font-weight:bold;">부당한 특약의 설정을 금지(하도급법 개정, 2014.2.14.시행)</font>하였습니다. 대기업 등이 부당특약을 설정한 경우 특약조항의 삭제ㆍ수정 등 시정명령,<br/>과징금, 벌금 등이 부과됩니다.</li>
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
				<input type="hidden" name="c2_14" value="<%=setHiddenValue(qa, 2, 14, 5)%>" />
					<ul class="lt">
						<li><input type="radio" name="q2_14" value="1" <%if(qa[2][14][1]!=null && qa[2][14][1].equals("1")){out.print("checked");}%> onclick="checkradio(2, 14);" /> 가. 잘 알고 있음</li>
						<li><input type="radio" name="q2_14" value="2" <%if(qa[2][14][2]!=null && qa[2][14][2].equals("1")){out.print("checked");}%> onclick="checkradio(2, 14);" /> 나. 대체로 알고 있음</li>
						<li><input type="radio" name="q2_14" value="3" <%if(qa[2][14][3]!=null && qa[2][14][3].equals("1")){out.print("checked");}%> onclick="checkradio(2, 14);" /> 다. 약간 알고 있음</li>
						<li><input type="radio" name="q2_14" value="4" <%if(qa[2][14][4]!=null && qa[2][14][4].equals("1")){out.print("checked");}%> onclick="checkradio(2, 14);" /> 라. 잘 모름</li>
						<li><input type="radio" name="q2_14" value="5" <%if(qa[2][14][5]!=null && qa[2][14][5].equals("1")){out.print("checked");}%> onclick="checkradio(2, 14);" /> 마. 전혀 모름</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>15. </span> <font style="font-weight:bold;"><%=st_Current_Year_n-1%>년도 상반기(<%=st_Current_Year_n-1%>.1.1.∼<%=st_Current_Year_n-1%>.6.30.)</font>동안 귀사가 원사업자와 체결한 하도급계약에 원사업자가 귀사의 이익을 부당하게 침해하거나 제한하는 계약조건을 설정한 사실이 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c2_15" value="<%=setHiddenValue(qa, 2, 15, 2)%>" />
					<ul class="lt">
						<li><input type="radio" name="q2_15" value="1" <%if(qa[2][15][1]!=null && qa[2][15][1].equals("1")){out.print("checked");}%> onclick="checkradio(2, 15);" /> 가. 없었음</li>
						<li><input type="radio" name="q2_15" value="2" <%if(qa[2][15][2]!=null && qa[2][15][2].equals("1")){out.print("checked");}%> onclick="checkradio(2, 15);" /> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>16. </span> <font style="font-weight:bold;"><%=st_Current_Year_n%>년도 상반기(<%=st_Current_Year_n%>.1.1.∼<%=st_Current_Year_n%>.6.30.)</font>동안 귀사가 원사업자와 체결한 하도급계약에 원사업자가 귀사의 이익을 부당하게 침해하거나 제한하는 계약조건을 설정한 사실이 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c2_16" value="<%=setHiddenValue(qa, 2, 16, 2)%>" />
					<ul class="lt">
						<li><input type="radio" name="q2_16" value="1" <%if(qa[2][16][1]!=null && qa[2][16][1].equals("1")){out.print("checked");}%> onclick="checkradio(2, 16);" /> 가. 없었음</li>
						<li><input type="radio" name="q2_16" value="2" <%if(qa[2][16][2]!=null && qa[2][16][2].equals("1")){out.print("checked");}%> onclick="checkradio(2, 16);" /> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>17. </span> 원사업자가 부당한 특약을 설정하는 불공정행위가 <%=st_Current_Year_n-1%>년도 상반기와 비교하여 <%=st_Current_Year_n%>년도 상반기에 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c2_17" value="<%=setHiddenValue(qa, 2, 17, 5)%>" />
					<ul class="lt">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q2_17" value="1" <%if(qa[2][17][1]!=null && qa[2][17][1].equals("1")){out.print("checked");}%> onclick="checkradio(2, 17);" /> 5점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q2_17" value="2" <%if(qa[2][17][2]!=null && qa[2][17][2].equals("1")){out.print("checked");}%> onclick="checkradio(2, 17);" /> 4점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q2_17" value="3" <%if(qa[2][17][3]!=null && qa[2][17][3].equals("1")){out.print("checked");}%> onclick="checkradio(2, 17);" /> 3점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q2_17" value="4" <%if(qa[2][17][4]!=null && qa[2][17][4].equals("1")){out.print("checked");}%> onclick="checkradio(2, 17);" /> 2점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q2_17" value="5" <%if(qa[2][17][5]!=null && qa[2][17][5].equals("1")){out.print("checked");}%> onclick="checkradio(2, 17);" /> 1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선되고 있음 ◀────────────────────────▶전혀 개선되지 않고 있음</li>
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
					<li class="boxcontenttitle"><span>▣</span>공정거래위원회는 2014.7월부터 하도급대금 미지급 관련 불공정행위에 초점을 맞추어 현장조사를 하고 있으며, 특히 <font style="font-weight:bold;">하도급대금 관련 민원이 빈발<br/>하는 업종에 대해 하도급대금 미지급·지연지급, 어음할인료 미지급, 현금결제 비율 미준수</font> 등 하도급대금 지급 관련 <font style="font-weight:bold;">현장조사를 집중적으로 실시</font>하<br/>고 있습니다.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>18. </span> <%=st_Current_Year_n-1%>년도 상반기(<%=st_Current_Year_n-1%>.1.1 ~ <%=st_Current_Year_n-1%>.6.30.)동안 원사업자가 하도급대금을 미지급하거나, 지연이자를 미지급한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c3_18" value="<%=setHiddenValue(qa, 3, 18, 2)%>" />
					<ul class="lt">
						<li><input type="radio" name="q3_18" value="1" <%if(qa[3][18][1]!=null && qa[3][18][1].equals("1")){out.print("checked");}%> onclick="checkradio(3, 18);" /> 가. 없었음</li>
						<li><input type="radio" name="q3_18" value="2" <%if(qa[3][18][2]!=null && qa[3][18][2].equals("1")){out.print("checked");}%> onclick="checkradio(3, 18);" /> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>19. </span> <%=st_Current_Year_n%>년도 상반기(<%=st_Current_Year_n%>.1.1 ~ <%=st_Current_Year_n%>.6.30.)동안 원사업자가 하도급대금을 미지급하거나, 지연이자를 미지급한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c3_19" value="<%=setHiddenValue(qa, 3, 19, 2)%>" />
					<ul class="lt">
						<li><input type="radio" name="q3_19" value="1" <%if(qa[3][19][1]!=null && qa[3][19][1].equals("1")){out.print("checked");}%> onclick="checkradio(3, 19);" /> 가. 없었음</li>
						<li><input type="radio" name="q3_19" value="2" <%if(qa[3][19][2]!=null && qa[3][19][2].equals("1")){out.print("checked");}%> onclick="checkradio(3, 19);" /> 나. 있었음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>20. </span> 하도급대금 지급 관련 불공정행위가 <%=st_Current_Year_n-1%>년도 상반기와 비교하여 <font style="font-weight:bold;"><%=st_Current_Year_n%>년 상반기에</font> 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
				<input type="hidden" name="c3_20" value="<%=setHiddenValue(qa, 3, 20, 5)%>" />
					<ul class="lt">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q3_20" value="1" <%if(qa[3][20][1]!=null && qa[3][20][1].equals("1")){out.print("checked");}%> onclick="checkradio(3, 20);" /> 5점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q3_20" value="2" <%if(qa[3][20][2]!=null && qa[3][20][2].equals("1")){out.print("checked");}%> onclick="checkradio(3, 20);" /> 4점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q3_20" value="3" <%if(qa[3][20][3]!=null && qa[3][20][3].equals("1")){out.print("checked");}%> onclick="checkradio(3, 20);" /> 3점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q3_20" value="4" <%if(qa[3][20][4]!=null && qa[3][20][4].equals("1")){out.print("checked");}%> onclick="checkradio(3, 20);" /> 2점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q3_20" value="5" <%if(qa[3][20][5]!=null && qa[3][20][5].equals("1")){out.print("checked");}%> onclick="checkradio(3, 20);" /> 1점&nbsp;&nbsp; ──┤</li>
						<li>매우 개선되고 있음 ◀────────────────────────▶전혀 개선되지 않고 있음</li>
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
				<input type="hidden" name="c3_21" value="<%=setHiddenValue(qa, 3, 21, 5)%>" />
					<ul class="lt">
						<li class="boxcontenttitle">├──&nbsp;&nbsp;<input type="radio" name="q3_21" value="1" <%if(qa[3][21][1]!=null && qa[3][21][1].equals("1")){out.print("checked");}%> onclick="checkradio(3, 21);" /> 5점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q3_21" value="2" <%if(qa[3][21][2]!=null && qa[3][21][2].equals("1")){out.print("checked");}%> onclick="checkradio(3, 21);" /> 4점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q3_21" value="3" <%if(qa[3][21][3]!=null && qa[3][21][3].equals("1")){out.print("checked");}%> onclick="checkradio(3, 21);" /> 3점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q3_21" value="4" <%if(qa[3][21][4]!=null && qa[3][21][4].equals("1")){out.print("checked");}%> onclick="checkradio(3, 21);" /> 2점
						&nbsp;&nbsp;─┼─&nbsp;&nbsp;<input type="radio" name="q3_21" value="5" <%if(qa[3][21][5]!=null && qa[3][21][5].equals("1")){out.print("checked");}%> onclick="checkradio(3, 21);" /> 1점&nbsp;&nbsp; ──┤</li>
						<li>많은 효과가 있을 것임 ◀───────────────────────▶전혀 효과가 없을 것임</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_20"></div>

			<!-- 버튼 start -->
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">응답내역 전송</a></li>
					<% if( (!sentStatus.equals("")) && (sentStatus != null) ) { %>
					<li class="fl pr_2"><a href="javascript:infoSubmit();" onfocus="this.blur()" class="contentbutton2">로그인 차단</a></li>
					<% } %>
				</ul>
			</div>
			<!-- 버튼 end -->

			<div class="fc pt_20"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle" style="font-size:x-large;"><center>- 바쁘신 중에도 설문에 성실히 응답하여 주셔서 감사합니다. -</center></li>
				</ul>
			</div>
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

	<%/*-----------------------------------------------------------------------------------------------
	2010년 4월 26일 / iframe 추가 / 정광식
	:: 하도급거래상황 (설문문항) 선택 후 저장 시 오류발생으로 기존정보 소실되는 경우를 방지하기 위해
	:: 선택사항을 iframe 타겟으로 submit 시킴
	*/%>
	<iframe src="/blank.jsp" name="proceFrame" id="proceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
	<%/*-----------------------------------------------------------------------------------------------*/%>
	<script type="text/JavaScript">
	//<![CDATA[
	<%if ( StringUtil.checkNull(request.getParameter("isSaved")).equals("1") ) {%>
		alert("전송이 완료 되었습니다.")
	<%}%>
	//]]
	</script>
</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>