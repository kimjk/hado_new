<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_VP_Subcon_01_03.jsp
* 프로그램설명	: 수급사업자 > 년도별 조사표 > 2015년 제조업 조사표 > 하도급 거래 현황
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2009년 05월
* 작 성 이 력       :
*=========================================================
*	작성일자			작성자명				내용
*=========================================================
*	2009-05			정광식       최초작성
*	2015-07-08	강슬기       조사표 문항 및 코드 정리(StringUtil)
*  2015-07-23  	정광식		원사업자 명부 작성 추가
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

	String[][][] qa = new String[35][40][30];

	String sErrorMsg = "";	// 오류메시지

	String q_Cmd = StringUtil.checkNull(request.getParameter("mode"));

	// Cookie Request
	String sMngNo = ckMngNo;
	String sOentYYYY = ckCurrentYear;
	String sOentGB = ckOentGB;
	String sOentName = ckOentName;
	String sSentNo = ckSentNo;

	String sSQLs = "";

	// 원사업자 명부 파일
	String sOentFileName = "";

	java.util.Calendar cal = java.util.Calendar.getInstance();

/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection processing =====================================*/

	if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
		ConnectionResource resource = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;


		// 배열 초기화
		for (int ni = 1; ni < 35; ni++) {
			for (int nj = 1; nj < 40; nj++) {
				for (int nk = 1; nk < 30; nk++) {
					qa[ni][nj][nk] = "";
				}
			}
		}

		// 해당사업자 정보 가져오기
		sSQLs = "SELECT * FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
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

		/* 원사업자 명부 파일 - 정광식 2015-07-23 */
		sSQLs = "SELECT oent_file FROM hado_tb_subcon_oent_file \n";
		sSQLs+="WHERE Mng_No=? \n";
		sSQLs+="	AND Current_Year=? \n";
		sSQLs+="	AND Oent_GB=? \n";

		try {
			resource	= new ConnectionResource();
			conn		= resource.getConnection();

			pstmt		= conn.prepareStatement(sSQLs);
			pstmt.setString(1, ckMngNo);
			pstmt.setString(2, sOentYYYY);
			pstmt.setString(3, sOentGB);

			rs			= pstmt.executeQuery();

			while (rs.next()) {
				sOentFileName = StringUtil.checkNull(rs.getString("oent_file")).trim();
			}

			rs.close();
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			if ( rs != null )		try{rs.close();}	catch(Exception e){}
			if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
			if ( conn != null )		try{conn.close();}	catch(Exception e){}
			if ( resource != null ) resource.release();
		}

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
    <script type="text/JavaScript">
	//<![CDATA[
		ns4 = (document.layers)? true:false
		ie4 = (document.all)? true:false

		var msg = "";
		var radiof = false;
		
		var ckSave = 1;

		function savef(){
			var main = document.info;

			msg = "";
			ckSave = 0;
			// 연계문항 선택 확인
			//--> 입력여부 확인 :: research3f(form-name, 연계문항대번호, 연계문항소번호, 개체타입(1:text,2:radio,3:checkbox), 보기개수(checkbox만 해당 아니면 0), 선선택(조건)문항대번호, 선선택(조건)문항소번호);
			//--> 문항초기화 :: initf(form-name, 문항대번호, 문항소번호, 개체타입(2:radio,3:checkbox), 0보기개수(checkbox만 해당 아니면 0));
			relationf(main);

			if(msg=="") {
				if(confirm("[ 조사표내용을 저장합니다. ]\n\n접속자가 많을경우 다소 시간이 걸릴수도 있습니다.\n정상적으로 저장이 안될경우\n수십분후에 다시시도하여 주십시오.\n\n서버의 부하로 저장에 실패할경우\n응답하신 조사내용을 복구할 수 없습니다.\n응답하신 조사표를 인쇄하여 보관하시고\n오류페이지에서 마우스오른쪽 버튼을 눌러\n새로고침을 선택하여 재저장을 시도하십시오.\n\n확인을 누르시면 저장합니다.")) {
					processSystemStart("[1/1] 입력한 하도급거래현황을 저장합니다.");

					main.target = "ProceFrame";
					main.action = "WB_CP_Subcon_Qry.jsp?type=Const&step=Detail";
					main.submit();
				}
			} else {
				ckSave = 1;
				alert(msg+"\n\n저장이 취소되었습니다.")
			}

		}

		function savef2(main){
			var main = document.info;

			if( confirm("[임시저장] 기능은 여러번 나누어서 응답하기 위한 기능입니다.\n\n조사표를 마무리 하기 위해서는 꼭 [저 장] 기능을 이용하셔야 하며,\n[저 장] 기능을 사용하지 않을 경우 [조사표 전송]이 안되오니\n조사표 응답을 완료할때는 필히 [저 장] 기능을 이용하셔야 합니다.\n\n확인을 누르시면 [임시저장] 기능을 실행합니다.") ) {
				main.target = "ProceFrame";
				main.action = "WB_CP_Subcon_Qry.jsp?type=Const&step=Temp";
				main.submit();
			}
		}

		function relationf(main){
			msg = "";

			// 연계문항 선택 확인
			//--> 입력여부 확인 :: research3f(form-name, 연계문항대번호, 연계문항소번호, 개체타입(1:text,2:radio,3:checkbox), 보기개수(checkbox만 해당 아니면 0),
			//-->                             선선택(조건)문항대번호, 선선택(조건)문항소번호);
			//--> 문항초기화 :: initf(form-name, 문항대번호, 문항소번호, 개체타입(2:radio,3:checkbox), 0보기개수(checkbox만 해당 아니면 0));
			if( main.q2_5_1[0].checked==true ) {research4f(main, 6, 2, 5, 1);initf(main, 6, 1, 1, 0); initf(main, 6, 2, 1, 0); initf(main, 6, 3, 1, 0);}
			if( main.q2_5_1[1].checked==true ) {research4f(main, 6, 1, 5, 1); research4f(main, 6, 2, 5, 1);}
			
			if( main.q2_11_2[0].checked==true ) {
				initf(main, 11, 3, 2, 0); initf(main, 11, 22, 1, 0); initf(main, 11, 23, 1, 0); initf(main, 11, 24, 1, 0); initf(main, 11, 25, 1, 0); initf(main, 11, 26, 1, 0);
				initf(main, 11, 5, 2, 0); initf(main, 11, 27, 1, 0); research3f(main, 11, 6, 2, 0, 11, 2);
			}
			if( main.q2_11_2[1].checked==true || main.q2_11_2[2].checked==true || main.q2_11_2[3].checked==true || main.q2_11_2[4].checked==true ) {
				research3f(main, 11, 3, 2, 0, 11, 2);
				if(ckSave == 1) {research3f(main, 11, 22, 1, 0, 11, 2);}
				
				if( main.q2_11_3[0].checked==true ) {
					research4f(main, 11, 4, 11, 2); research3f(main, 11, 5, 2, 0, 11, 2); research3f(main, 11, 6, 2, 0, 11, 2);
					if(ckSave == 1) {research3f(main, 11, 27, 1, 0, 11, 2);}
				}
				if( main.q2_11_3[1].checked==true ) {
					initf(main, 11, 23, 1, 0); initf(main, 11, 24, 1, 0); initf(main, 11, 25, 1, 0); initf(main, 11, 26, 1, 0);
					initf(main, 11, 5, 2, 0); initf(main, 11, 27, 1, 0); research3f(main, 11, 6, 2, 0, 11, 2);
				}
			}
			if( main.q2_11_6[0].checked==true ) {
				initf(main, 11, 7, 2, 0); initf(main, 11, 28, 1, 0);
			}
			if( main.q2_11_6[1].checked==true || main.q2_11_6[2].checked==true || main.q2_11_6[3].checked==true || main.q2_11_6[4].checked==true ) {
				research3f(main, 11, 7, 2, 0, 11, 6);
				if(ckSave == 1) {research3f(main, 11, 28, 1, 0, 11, 6);}
			}
			if( main.q2_13_1[0].checked==true || main.q2_13_1[1].checked==true ) {
				initf(main, 13, 2, 2, 0); initf(main, 13, 11, 1, 0);
			}
			if( main.q2_13_1[2].checked==true || main.q2_13_1[3].checked==true || main.q2_13_1[4].checked==true || main.q2_13_1[5].checked==true ) {
				research3f(main, 13, 2, 2, 0, 13, 1);
				if(ckSave == 1) {research3f(main, 13, 11, 1, 0, 13, 1);}
			}
			if( main.q2_14_1[0].checked==true ) {
				initf(main, 14, 2, 3, 7); initf(main, 14, 11, 1, 0); initf(main, 14, 3, 2, 0);
			}
			if( main.q2_14_1[1].checked==true || main.q2_14_1[2].checked==true || main.q2_14_1[3].checked==true || main.q2_14_1[4].checked==true ) {
				research3f(main, 14, 2, 3, 7, 14, 1); research3f(main, 14, 3, 2, 0, 14, 1);
				if(ckSave == 1) {research3f(main, 14, 11, 1, 0, 14, 1);}
			}
			if( main.q2_15_1[0].checked==true ) {
				initf(main, 15, 2, 3, 6); initf(main, 15, 11, 1, 0);
			}
			if( main.q2_15_1[1].checked==true || main.q2_15_1[2].checked==true || main.q2_15_1[3].checked==true || main.q2_15_1[4].checked==true ) {
				research3f(main, 15, 2, 3, 6, 15, 1);
				if(ckSave == 1) {research3f(main, 15, 11, 1, 0, 15, 1);}
			}
			if( main.q2_16_1[0].checked==true ) {
				initf(main, 16, 2, 3, 9); initf(main, 16, 11, 1, 0);
			}
			if( main.q2_16_1[1].checked==true || main.q2_16_1[2].checked==true || main.q2_16_1[3].checked==true || main.q2_16_1[4].checked==true ) {
				research3f(main, 16, 2, 3, 9, 16, 1);
				if(ckSave == 1) {research3f(main, 16, 11, 1, 0, 16, 1);}
			}
			if( main.q2_17_1[0].checked==true || main.q2_17_1[5].checked==true ) {
				initf(main, 17, 2, 3, 6); initf(main, 17, 11, 1, 0);
			}
			if( main.q2_17_1[1].checked==true || main.q2_17_1[2].checked==true || main.q2_17_1[3].checked==true || main.q2_17_1[4].checked==true ) {
				research3f(main, 17, 2, 3, 6, 17, 1);
				if(ckSave == 1) {research3f(main, 17, 11, 1, 0, 17, 1);}
			}
			if( main.q2_18_3[0].checked==true ) {
				initf(main, 18, 31, 1, 0); initf(main, 18, 32, 1, 0); initf(main, 18, 33, 1, 0); initf(main, 18, 34, 1, 0); initf(main, 18, 35, 1, 0);
				initf(main, 18, 5, 2, 0); initf(main, 18, 6, 2, 0); initf(main, 18, 7, 2, 0); initf(main, 18, 12, 1, 0);
			}
			if( main.q2_18_3[1].checked==true || main.q2_18_3[2].checked==true || main.q2_18_3[3].checked==true ) {
				research4f(main, 18, 4, 18, 3); research3f(main, 18, 5, 2, 0, 18, 3); research3f(main, 18, 6, 2, 0, 18, 3); research3f(main, 18, 7, 2, 0, 18, 3);
				if(ckSave == 1) {research3f(main, 18, 12, 1, 0, 18, 1);}
			}
			if( main.q2_20_2[1].checked==true ) {
				initf(main, 20, 11, 1, 0); initf(main, 20, 12, 1, 0); initf(main, 20, 13, 1, 0); initf(main, 20, 14, 1, 0);
				initf(main, 20, 4, 2, 0); research3f(main, 20, 5, 2, 0, 20, 2);
			}
			if( main.q2_20_2[0].checked==true ) {
				research4f(main, 20, 3, 20, 2); research3f(main, 20, 4, 2, 0, 20, 2); research3f(main, 20, 5, 2, 0, 20, 2);
			}
			if( main.q2_21_2[1].checked==true ) {
				initf(main, 21, 3, 2, 0); initf(main, 21, 4, 3, 3); initf(main, 21, 13, 1, 0); initf(main, 21, 14, 1, 0);
			}
			if( main.q2_21_2[0].checked==true ) {
				research3f(main, 21, 3, 2, 0, 21, 2); research3f(main, 21, 4, 3, 3, 21, 2);
				if(ckSave == 1) {research3f(main, 21, 13, 1, 0, 21, 2); research3f(main, 21, 14, 1, 0, 21, 2);}
			}
			if( main.q2_22_1[0].checked==true ) {
				initf(main, 22, 2, 2, 0); initf(main, 22, 3, 2, 0); initf(main, 22, 4, 2, 0); initf(main, 22, 5, 2, 0); initf(main, 22, 6, 1, 0);
			}
			if( main.q2_22_1[1].checked==true || main.q2_22_1[2].checked==true || main.q2_22_1[3].checked==true ) {
				research3f(main, 22, 2, 2, 0, 22, 1); research3f(main, 22, 3, 2, 0, 22, 1);
				if( main.q2_22_3[0].checked==true ) {
					initf(main, 22, 4, 2, 0); initf(main, 22, 5, 2, 0); initf(main, 22, 6, 1, 0);
				}
				if( main.q2_22_3[1].checked==true || main.q2_22_3[2].checked==true || main.q2_22_3[3].checked==true ) {
					research3f(main, 22, 4, 2, 0, 22, 3); research3f(main, 22, 5, 2, 0, 22, 3);
					if(ckSave == 1) {research3f(main, 22, 6, 1, 0, 22, 3);}
				}
			}
			if( main.q2_24_1[1].checked==true ) {
				initf(main, 24, 2, 3, 6); initf(main, 24, 11, 1, 0);
			}
			if( main.q2_24_1[0].checked==true ) {
				research3f(main, 24, 2, 3, 6, 24, 1);
				if(ckSave == 1) {research3f(main, 24, 11, 1, 0, 24, 1);}
			}
			if( main.q2_25_1[1].checked==true ) {
				initf(main, 25, 2, 3, 5); initf(main, 25, 11, 1, 0); initf(main, 25, 3, 2, 0); initf(main, 25, 21, 1, 0); initf(main, 25, 22, 1, 0);
				initf(main, 25, 23, 1, 0); initf(main, 25, 24, 1, 0); initf(main, 25, 25, 1, 0); initf(main, 25, 26, 1, 0); initf(main, 25, 27, 1, 0);
				initf(main, 25, 28, 1, 0); initf(main, 25, 29, 1, 0); initf(main, 25, 30, 1, 0); initf(main, 25, 5, 3, 4);
				initf(main, 25, 12, 1, 0); initf(main, 25, 13, 1, 0); initf(main, 25, 14, 1, 0); initf(main, 25, 7, 2, 0); initf(main, 25, 15, 1, 0);
				initf(main, 25, 31, 1, 0); initf(main, 25, 32, 1, 0); initf(main, 25, 33, 1, 0);
				initf(main, 25, 34, 1, 0); initf(main, 25, 35, 1, 0); initf(main, 25, 36, 1, 0); research3f(main, 25, 9, 2, 0, 25, 1);
			}
			if( main.q2_25_1[0].checked==true ) {
				research3f(main, 25, 2, 3, 5, 25, 1); research3f(main, 25, 3, 2, 0, 25, 1);
				if(ckSave == 1) {research3f(main, 25, 11, 1, 0, 25, 1);}
				
				if( main.q2_25_3[2].checked==true ) {
					initf(main, 25, 21, 1, 0); initf(main, 25, 22, 1, 0);
					initf(main, 25, 23, 1, 0); initf(main, 25, 24, 1, 0); initf(main, 25, 25, 1, 0); initf(main, 25, 26, 1, 0); initf(main, 25, 27, 1, 0);
					initf(main, 25, 28, 1, 0); initf(main, 25, 29, 1, 0); initf(main, 25, 30, 1, 0); initf(main, 25, 5, 3, 4);
					initf(main, 25, 12, 1, 0); initf(main, 25, 13, 1, 0); initf(main, 25, 14, 1, 0); initf(main, 25, 7, 2, 0); initf(main, 25, 15, 1, 0);
					initf(main, 25, 31, 1, 0); initf(main, 25, 32, 1, 0); initf(main, 25, 33, 1, 0);
					initf(main, 25, 34, 1, 0); initf(main, 25, 35, 1, 0); initf(main, 25, 36, 1, 0); initf(main, 25, 9, 2, 0);
				}
				if( main.q2_25_3[0].checked==true || main.q2_25_3[1].checked==true ) {
					research4f(main, 25, 4, 25, 3); research3f(main, 25, 5, 3, 4, 25, 3); research4f(main, 25, 6, 25, 3); research4f(main, 25, 8, 25, 3);
					research3f(main, 25, 7, 2, 0, 25, 3); research3f(main, 25, 9, 2, 0, 25, 3);
					if(ckSave == 1) {research3f(main, 25, 15, 1, 0, 25, 3);}
				}
			}
			if( main.q2_26_1[1].checked==true ) {
				initf(main, 26, 2, 2, 0); initf(main, 26, 3, 2, 0); initf(main, 26, 4, 2, 0); initf(main, 26, 11, 1, 0);
			}
			if( main.q2_26_1[0].checked==true ) {
				research3f(main, 26, 2, 2, 0, 26, 1);
				
				if( main.q2_26_2[1].checked==true ) {
					initf(main, 26, 3, 2, 0); initf(main, 26, 4, 2, 0); initf(main, 26, 11, 1, 0);
				}
				if( main.q2_26_2[0].checked==true || main.q2_26_2[2].checked==true || main.q2_26_2[3].checked==true ) {
					research3f(main, 26, 3, 2, 0, 26, 2);
					
					if( main.q2_26_3[0].checked==true ) {
						initf(main, 26, 4, 2, 0); initf(main, 26, 11, 1, 0);
					}
					if( main.q2_26_3[1].checked==true ) {
						research3f(main, 26, 4, 2, 0, 26, 3);
						if(ckSave == 1) {research3f(main, 26, 11, 1, 0, 26, 1);}
					}
				}
			}
			if( main.q2_28_1[1].checked==true ) {
				initf(main, 28, 2, 1, 0); initf(main, 28, 11, 1, 0); initf(main, 28, 12, 1, 0); initf(main, 28, 13, 1, 0);
				initf(main, 28, 4, 2, 0); initf(main, 28, 14, 1, 0);
				initf(main, 28, 5, 3, 5); initf(main, 28, 15, 1, 0);
				initf(main, 28, 6, 3, 10); initf(main, 28, 16, 1, 0);
			}
			if( main.q2_28_1[0].checked==true ) {
				research3f(main, 28, 2, 1, 0, 28, 1);
				research4f(main, 28, 3, 28, 1);
				research3f(main, 28, 4, 2, 0, 28, 1);
				research3f(main, 28, 5, 3, 5, 28, 1);
				research3f(main, 28, 6, 3, 10, 28, 1);
				if(ckSave == 1) {research3f(main, 28, 14, 1, 0, 28, 1); research3f(main, 28, 15, 1, 0, 28, 1); research3f(main, 28, 16, 1, 0, 28, 1);}
			}
			
		}

		function checkradio(ni, nx){

			eval("oldValue = document.info.c2_"+ni+"_"+nx+".value");
			eval("obj = document.info.q2_"+ni+"_"+nx);
			selValue = "";

			for(i=0; i<obj.length; i++) {
				if(obj[i].checked==true) {
					selValue = (i+1)+"";
					break;
				}
			}

			if(selValue != "") {
				if(selValue == oldValue) {
					eval("document.info.c2_"+ni+"_"+nx+".value = ''");
					initf(document.info, ni, nx, 2, 0);
					relationf(document.info);
				} else {
					eval("document.info.c2_"+ni+"_"+nx+".value = selValue");
					relationf(document.info);
				}
			}

		}

		function initf(obj,fno,sno,type,gesu){
			switch(type){
				case 1:
					eval("obj.q2_"+fno+"_"+sno+".value=''");
					break;
				case 2:
					eval("for(i=0;i<obj.q2_"+fno+"_"+sno+".length;i++) obj.q2_"+fno+"_"+sno+"[i].checked=false");
					break;
				case 3:
					for(i=1;i<=gesu;i++)
						eval("obj.q2_"+fno+"_"+sno+"_"+i+".checked=false");
					break;
			}
			// 연계문항 시 맨 오른쪽 변수 1 : 활성화 , 2 : 비활성화
			chBoxDisplay(obj, fno, sno, type, gesu, 1);
		}

		// 체크박스 활성화 / 비활성화
		function chBoxDisplay(obj,fno,sno,type,gesu,view) {
			//alert("값:"+obj+"/"+fno+"/"+sno+"타입:"+type);
			switch (type) {
			case 1:
				eval("obj.q2_"+fno+"_"+sno+".disabled=" + (view == 1 ? "true" : "false"));
				break;
			case 2:
				for(i=0;i<eval("obj.q2_"+fno+"_"+sno+".length");i++)
				break;
			case 3:
				for(i=1;i<=gesu;i++)
					eval("obj.q2_"+fno+"_"+sno+"_"+i+".disabled=" + (view == 1 ? "true" : "false"));
				break;
			}
		}

		//-- 연계항목 선택여부 확인 --//
		function research3f(obj,fno,sno,type,gesu,ofno,osno){

			var ccheck="no", i
			switch (type){
				case 1:	// text
					ccheck="yes";
					eval("if(obj.q2_"+fno+"_"+sno+".value=='') ccheck='no'"  );
					break;
				case 2:	// Radio
					eval("for(i=0;i<obj.q2_"+fno+"_"+sno+".length;i++) if(obj.q2_"+fno+"_"+sno+"[i].checked==true) ccheck='yes'");
					break;
				case 3:	// checkbox
					for(i=1;i<=gesu;i++)
						eval("if(obj.q2_"+fno+"_"+sno+"_"+i+".checked==true) ccheck='yes'");
					break;
			}

			// 연계문항 시 맨 오른쪽 변수 1 : 활성화 , 2 : 비활성화
			chBoxDisplay(obj, fno, sno, type, gesu, 2);

			if(ccheck=="no"){
				msg=msg+"\n";

				if( type=="1") {
					eval("msg=msg+'하도급거래상황의 "+ofno+"-"+osno+"번의 연계문항 "+fno+"-"+sno+"번을 입력하여 주십시오.'");
				} else {
					eval("msg=msg+'하도급거래상황의 "+ofno+"-"+osno+"번의 연계문항 "+fno+"-"+sno+"번을 선택하여 주십시오.'");
				}
			}
		}
		
		function research4f(obj,fno,sno,ofno,osno){

			var ccheck="no", i
			if(fno==6 && sno==1) {
				ccheck="yes";
				eval("if(obj.q2_6_1.value=='' && obj.q2_6_2.value=='' && obj.q2_6_3.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 6, 1, 1, 0, 2);
				chBoxDisplay(obj, 6, 2, 1, 0, 2);
				chBoxDisplay(obj, 6, 3, 1, 0, 2);
			}
			if(fno==6 && sno==2) {
				ccheck="yes";
				eval("if(obj.q2_6_4.value=='' && obj.q2_6_5.value=='' && obj.q2_6_6.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 6, 4, 1, 0, 2);
				chBoxDisplay(obj, 6, 5, 1, 0, 2);
				chBoxDisplay(obj, 6, 6, 1, 0, 2);
			}
			if(fno==11 && sno==4) {
				ccheck="yes";
				eval("if(obj.q2_11_23.value=='' && obj.q2_11_24.value=='' && obj.q2_11_25.value=='' && obj.q2_11_26.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 11, 23, 1, 0, 2);
				chBoxDisplay(obj, 11, 24, 1, 0, 2);
				chBoxDisplay(obj, 11, 25, 1, 0, 2);
				chBoxDisplay(obj, 11, 26, 1, 0, 2);
			}
			if(fno==18 && sno==4) {
				ccheck="yes";
				eval("if(obj.q2_18_31.value=='' && obj.q2_18_32.value=='' && obj.q2_18_33.value=='' && obj.q2_18_34.value=='' && obj.q2_18_35.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 18, 31, 1, 0, 2);
				chBoxDisplay(obj, 18, 32, 1, 0, 2);
				chBoxDisplay(obj, 18, 33, 1, 0, 2);
				chBoxDisplay(obj, 18, 34, 1, 0, 2);
				chBoxDisplay(obj, 18, 35, 1, 0, 2);
			}
			if(fno==20 && sno==3) {
				ccheck="yes";
				eval("if(obj.q2_20_11.value=='' && obj.q2_20_12.value=='' && obj.q2_20_13.value=='' && obj.q2_20_14.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 20, 11, 1, 0, 2);
				chBoxDisplay(obj, 20, 12, 1, 0, 2);
				chBoxDisplay(obj, 20, 13, 1, 0, 2);
				chBoxDisplay(obj, 20, 14, 1, 0, 2);
			}
			if(fno==25 && sno==4) {
				ccheck="yes";
				eval("if(obj.q2_25_21.value=='' && obj.q2_25_22.value=='' && obj.q2_25_23.value=='' && obj.q2_25_24.value=='' && obj.q2_25_25.value=='' && obj.q2_25_26.value=='' && obj.q2_25_27.value=='' && obj.q2_25_28.value=='' && obj.q2_25_29.value=='' && obj.q2_25_30.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 25, 21, 1, 0, 2);
				chBoxDisplay(obj, 25, 22, 1, 0, 2);
				chBoxDisplay(obj, 25, 23, 1, 0, 2);
				chBoxDisplay(obj, 25, 24, 1, 0, 2);
				chBoxDisplay(obj, 25, 25, 1, 0, 2);
				chBoxDisplay(obj, 25, 26, 1, 0, 2);
				chBoxDisplay(obj, 25, 27, 1, 0, 2);
				chBoxDisplay(obj, 25, 28, 1, 0, 2);
				chBoxDisplay(obj, 25, 29, 1, 0, 2);
				chBoxDisplay(obj, 25, 30, 1, 0, 2);
			}
			if(fno==25 && sno==6) {
				ccheck="yes";
				eval("if(obj.q2_25_12.value=='' && obj.q2_25_13.value=='' && obj.q2_25_14.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 25, 12, 1, 0, 2);
				chBoxDisplay(obj, 25, 13, 1, 0, 2);
				chBoxDisplay(obj, 25, 14, 1, 0, 2);
			}
			if(fno==25 && sno==8) {
				ccheck="yes";
				eval("if(obj.q2_25_31.value=='' && obj.q2_25_32.value=='' && obj.q2_25_33.value=='' && obj.q2_25_34.value=='' && obj.q2_25_35.value=='' && obj.q2_25_36.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 25, 31, 1, 0, 2);
				chBoxDisplay(obj, 25, 32, 1, 0, 2);
				chBoxDisplay(obj, 25, 33, 1, 0, 2);
				chBoxDisplay(obj, 25, 34, 1, 0, 2);
				chBoxDisplay(obj, 25, 35, 1, 0, 2);
				chBoxDisplay(obj, 25, 36, 1, 0, 2);
			}
			if(fno==28 && sno==3) {
				ccheck="yes";
				eval("if(obj.q2_28_11.value=='' && obj.q2_28_12.value=='' && obj.q2_28_13.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 28, 11, 1, 0, 2);
				chBoxDisplay(obj, 28, 12, 1, 0, 2);
				chBoxDisplay(obj, 28, 13, 1, 0, 2);
			}
			
			if(ccheck=="no"){
				msg=msg+"\n";
				eval("msg=msg+'하도급거래상황의 "+ofno+"-"+osno+"번의 연계문항 "+fno+"-"+sno+"번을 입력하여 주십시오.'");
			}
		}
		
		function fn_hap18_2(main) {
			main.allSum18_2.value
			=Math.round(Cnum(main.q2_18_21.value)
			+Cnum(main.q2_18_22.value)
			+Cnum(main.q2_18_23.value)
			+Cnum(main.q2_18_24.value)
			+Cnum(main.q2_18_25.value)
			+Cnum(main.q2_18_26.value)
			+Cnum(main.q2_18_27.value)
			+Cnum(main.q2_18_28.value)
			+Cnum(main.q2_18_29.value)
			+Cnum(main.q2_18_30.value)
			+Cnum(main.q2_18_20.value));
		}
		function fn_hap18_4(main) {
			main.allSum18_4.value
			=Math.round(Cnum(main.q2_18_31.value)
			+Cnum(main.q2_18_32.value)
			+Cnum(main.q2_18_33.value)
			+Cnum(main.q2_18_34.value)
			+Cnum(main.q2_18_35.value));
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
				listDiv.style.top = document.body.scrollTop+document.documentElement.scrollTop+topx;
				listDiv.style.left = document.body.scrollLeft+document.documentElement.scrollLeft+leftx;
			} else {
				listDiv.style.posTop = document.body.scrollTop+topx;
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

		function HelpWindow2(url, w, h){
			helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
			helpwindow.focus();
		}

		function Cnum(aa)
		{
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


		// 크레디앙 커몬 스크립트..
		var SU_COMMA = ',';

		// 문자열 치환
		function kreplace(str,str1,str2) {

			if (str == "" || str == null) return str;

			while (str.indexOf(str1) != -1) {
				str = str.replace(str1,str2);
			}
			return str;
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

		// 초기 로드시 실행
		function onDocumentInit(){
			fn_hap18_2(document.info);
			fn_hap18_4(document.info);

			relationf(document.info);
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


	//2015-07-18 /강슬기/화면 인쇄시 새 창에서 출력
		function goPrint(){
			url = "WB_VP_Subcon_02_03.jsp?mode=print";
			w = 1024;
			h = 768;

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
				<li class="fl"><a href="/" onfocus="this.blur()" name="#mokcha"><img src="img/logo.jpg" width="242" height="55"></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"><font color="#FF6600">[
							<% if( ckOentGB.equals("1") ) {%>제조업
							<% } else if( ckOentGB.equals("2") ) {%>건설업
							<% } else if( ckOentGB.equals("3") ) {%>용역업<% } %>]</font>
							<%=ckOentName%>&nbsp;/&nbsp;<%=ckSentName%><iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="24" marginwidth="0" marginheight="0" align="center" frameborder="0"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="mainmenu">1. 조사안내</a></li>
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. 귀사의 일반현황</a></li>
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenuup">3. 하도급 거래 현황</a></li>
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="mainmenu">4. 조사표 전송</a></li>
				<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_Add.jsp" onfocus="this.blur()" class="mainmenu">5. 신규제도관련 설문조사</a></li>
			</ul>
		</div>
		<!-- End Header -->

		<form action="" method="post" name="info">
		<!-- Begin subcontent -->
		<div id="subcontent">
			<!-- title start -->
			<h1 class="contenttitle">3. 하도급 거래 현황</h1>
			<!-- title end -->

			<div class="fc pt_10"></div>

			<!--2015075 / 강슬기 / 목차-->
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle"><a name="mokcha">목 차</a></li>
						<li class="boxcontentsubtitle">(클릭하시면 해당 목차로 이동합니다.)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><a href="#mokcha0" class="contentbutton3">하도급거래 기본사항</a></li>
						<li><a href="#mokcha1" class="contentbutton3">11. 수급사업자 선정방식 및 계약방법</a></li>
						<li><a href="#mokcha2" class="contentbutton3">12. 하도급 계약 체결 시, 하도급 거래 단가(대금)의 결정</a></li>
						<li><a href="#mokcha3" class="contentbutton3">13. 하도급대금 지급보증</a></li>
						<li><a href="#mokcha4" class="contentbutton3">14. 건설 위탁의 취소 및 변경</a></li>
						<li><a href="#mokcha5" class="contentbutton3">15. 목적물 인도</a></li>
						<li><a href="#mokcha6" class="contentbutton3">16. 계약체결 후, 하도급대금 감액</a></li>
						<li><a href="#mokcha7" class="contentbutton3">17. 선급금 수령</a></li>
						<li><a href="#mokcha8" class="contentbutton3">18. 하도급대금 수령</a></li>
						<li><a href="#mokcha9" class="contentbutton3">19. 설계변경 또는 경제상황의 변동(물가상승)에 따른 공사대금 증액조정</a></li>
						<li><a href="#mokcha10" class="contentbutton3">20. 공급원가(재료비, 노무비, 경비 등) 변동에 따른 하도급대금 조정 신청</a></li>
						<li><a href="#mokcha11" class="contentbutton3">21. 하도급법 위반</a></li>
						<li><a href="#mokcha12" class="contentbutton3">22. 하자보수 보증</a></li>
						<li><a href="#mokcha13" class="contentbutton3">23. 협력관계</a></li>
						<li><a href="#mokcha14" class="contentbutton3">24. 특약</a></li>
						<li><a href="#mokcha15" class="contentbutton3">25. 조사대상 원사업자의 기술자료 요구</a></li>
						<li><a href="#mokcha16" class="contentbutton3">26. 안전관리비 부담</a></li>
						<li><a href="#mokcha17" class="contentbutton3">27. 조사대상 원사업자의 경영간섭</a></li>
						<li><a href="#mokcha18" class="contentbutton3">28. 전속거래</a></li>
						<li><a href="#mokcha19" class="contentbutton3">29. 하도급 거래와 하도급 정책에 대한 귀사의 만족도</a></li>
					</ul>
				<div class="fc"></div>
			</div>

			<div class="fc pt_30"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">작성안내</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><span>※&nbsp;</span>본 조사의 대상이 되는 하도급거래는 <font style="font-weight:bold;" color="#3333CC">목적물 납품일(통상 세금계산서 발행일)이 <%=st_Current_Year_n-1%>.1.1.~ <%=st_Current_Year_n-1%>.12.31.기간에 속하는 거래</font>입니다.</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<h2 class="contenttitle">하도급거래 기본사항</h2>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha0">하도급거래 기본사항에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>5. </span>귀사의 지난 <%=st_Current_Year_n-1%>년 하도급거래 형태는 어떠합니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_5_1" value="<%=setHiddenValue(qa, 5, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_5_1" value="1" <%if(qa[5][1][1]!=null && qa[5][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"></input> 가. 하도급을 받기만 함<span class="boxcontentsubtitle">6-2번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_5_1" value="2" <%if(qa[5][1][2]!=null && qa[5][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"></input> 나. 하도급을 받기도 하고 주기도 함<span class="boxcontentsubtitle">6-1번 문항으로 이동</span></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>6-1. </span>귀사가 지난 3년간 '전체 수급사업자'에게 '하도급을 준' 금액은 얼마입니까?</li>
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
									<tr>
										<th>구분</th>
										<th>전체 수급(하위) 사업자에게 하도급을 준 금액<br/>[VAT 포함 금액]</th>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-3%>년도</th>
										<td>
											<input type="text" name="q2_6_1" value="<%=qa[6][1][20]%>" onkeyup="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 백만원
										</td>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-2%>년도</th>
										<td>
											<input type="text" name="q2_6_2" value="<%=qa[6][2][20]%>" onKeyUp="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 백만원
										</td>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-1%>년도</th>
										<td>
											<input type="text" name="q2_6_3" value="<%=qa[6][3][20]%>" onkeyup="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 백만원
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
						<li class="boxcontenttitle"><span>6-2. </span>귀사가 지난 3년간 '전체 원사업자들'로부터 '하도급을 받은' 금액은 얼마입니까?</li>
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
									<tr>
										<th>구분</th>
										<th>전체 원(상위) 사업자들로부터 하도급을 받은 금액<br/>[VAT 포함 금액]</th>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-3%>년도</th>
										<td>
											<input type="text" name="q2_6_4" value="<%=qa[6][4][20]%>" onkeyup ="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
										</td>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-2%>년도</th>
										<td>
											<input type="text" name="q2_6_5" value="<%=qa[6][5][20]%>" onKeyUp="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
										</td>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-1%>년도</th>
										<td>
											<input type="text" name="q2_6_6" value="<%=qa[6][6][20]%>" onkeyup ="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
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
						<li class="boxcontenttitle"><span>7. </span>귀사가 <%= st_Current_Year_n-1%>년도에 거래한 전체 원사업자, 수급사업자 수는 몇 개사입니까?</li>
						<li class="boxcontentsubtitle">* 총 매입(매출) 사업자는 <%= st_Current_Year_n-1%>년도 매입처별(매출처별) 세금계산서 합계표에 포함된 사업자들로서 하도급이 아닌 거래를 맺은 사업자들을 포함함.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:60%;" />
									<col style="width:40%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>구분</th>
										<th>사업자 수</th>
									</tr>
									<tr>
										<th>총 매출 사업자</th>
										<td>
											<input type="text" name="q2_7_1" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[7][1][20]%>"></input> 개사
										</td>
									</tr>
									<tr>
										<th>귀사에게 하도급을 준 원사업자</th>
										<td>
											<input type="text" name="q2_7_2" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[7][2][20]%>"></input> 개사
										</td>
									</tr>
									<tr>
										<th>총 매입 사업자</th>
										<td>
											<input type="text" name="q2_7_3" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[7][3][20]%>"></input> 개사
										</td>
									</tr>
									<tr>
										<th>귀사가 하도급을 준 수급사업자</th>
										<td>
											<input type="text" name="q2_7_4" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[7][4][20]%>"></input> 개사
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
					<ul class="clt">
						<li class="boxcontenttitle"><span>8. </span>귀사가 지난 3년간 '조사대상 원사업자'로부터 '하도급을 받은' 금액은 얼마입니까?</li>
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
									<tr>
										<th>구분</th>
										<th>조사대상 원(상위) 사업자와의 하도급 거래 금액<br/>[VAT 포함 금액]</th>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-3%>년도</th>
										<td>
											<input type="text" name="q2_8_1" value="<%=qa[8][1][20]%>" onkeyup ="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
										</td>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-2%>년도</th>
										<td>
											<input type="text" name="q2_8_2" value="<%=qa[8][2][20]%>" onKeyUp="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
										</td>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-1%>년도</th>
										<td>
											<input type="text" name="q2_8_3" value="<%=qa[8][3][20]%>" onkeyup ="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
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
						<li class="boxcontenttitle"><span>9. </span> <%=st_Current_Year_n-1%>년도 하도급거래 규모(금액)면에서 '조사대상 원사업자'는 귀사가 하도급거래를 맺은 '전체 원사업자들' 중 몇 번째로 큰 거래선에 해당합니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c2_9_1" value="<%=setHiddenValue(qa, 9, 1, 4)%>"/>
						<li><input type="radio" name="q2_9_1" value="1" <%if(qa[9][1][1]!=null && qa[9][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);"> 가. 1위</li>
						<li><input type="radio" name="q2_9_1" value="2" <%if(qa[9][1][2]!=null && qa[9][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);"> 나. 2위</li>
						<li><input type="radio" name="q2_9_1" value="3" <%if(qa[9][1][3]!=null && qa[9][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);"> 다. 3위</li>
						<li><input type="radio" name="q2_9_1" value="4" <%if(qa[9][1][4]!=null && qa[9][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);"> 라. 4위 이하</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>10. </span> 귀사가 <%=st_Current_Year_n-1%>년도에 '조사대상 원사업자'로 부터 받은 하도급거래는 아래 보기에서 어느 단계에 해당합니까?</li>
						<li class="boxcontentsubtitle">[보기] 원청 시공업체 -> 1차 협력업체 -> 2차 협력업체 -> 3차 협력업체 -> 4차 협력업체 등</li>
						<li class="boxcontentsubtitle">* 귀사가 원청 시공업체로부터 하도급을 받은 경우 귀사는 1차 협력업체에 해당</li>
						<li class="boxcontentsubtitle">* 귀사가 1차 협력업체로부터 하도급을 받은 경우 귀사는 2차 협력업체에 해당</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c2_10_1" value="<%=setHiddenValue(qa, 10, 1, 5)%>"/>
						<li><input type="radio" name="q2_10_1" value="1" <%if(qa[10][1][1]!=null && qa[10][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 가. 귀사가 1차 협력업체</li>
						<li><input type="radio" name="q2_10_1" value="2" <%if(qa[10][1][2]!=null && qa[10][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 나. 귀사가 2차 협력업체</li>
						<li><input type="radio" name="q2_10_1" value="3" <%if(qa[10][1][3]!=null && qa[10][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 다. 귀사가 3차 협력업체</li>
						<li><input type="radio" name="q2_10_1" value="4" <%if(qa[10][1][4]!=null && qa[10][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 라. 귀사가 4차 협력업체</li>
						<li><input type="radio" name="q2_10_1" value="5" <%if(qa[10][1][5]!=null && qa[10][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 마. 잘 모름</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent2">
				<ul class="boxcontenthelp lt">
					<li class="boxcontenttitle"><p align="center">아래 문항들에 대해서는 귀사가 <%=st_Current_Year_n-1%>년도에 귀사의 원사업자[<%=ckOentName%>]와 맺은 하도급거래를 기준으로 응답하여 주십시오.</p></li>
				</ul>
			</div>

			<div class="fc pt_10"></div>
			
			<h2 class="contenttitle">하도급거래 세부사항 1 : 거래 제반</h2>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha1">11. 수급사업자 선정방식 및 계약 방법</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11-1. </span> 귀사가 <%= st_Current_Year_n-1%>년도에 조사대상 원사업자의 수급사업자로 선정된 방식은 어떠하였습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_11_1" value="<%=setHiddenValue(qa, 11, 1, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_11_1" value="1" <%if(qa[11][1][1]!=null && qa[11][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);"></input> 가. 전부 수의계약 방식</li>
						<li><input type="radio" name="q2_11_1" value="2" <%if(qa[11][1][2]!=null && qa[11][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);"></input> 나. 일부 수의계약, 일부 경쟁입찰 방식</li>
						<li><input type="radio" name="q2_11_1" value="3" <%if(qa[11][1][3]!=null && qa[11][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);"></input> 다. 전부 경쟁입찰 방식</li>
						<li><input type="radio" name="q2_11_1" value="4" <%if(qa[11][1][4]!=null && qa[11][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);"></input> 라. 기타(<input type="text" name="q2_11_21" value="<%=qa[11][21][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11-2. </span> 귀사가 <%= st_Current_Year_n-1%>년도에 조사대상 원사업자와 하도급계약을 체결할 시 서면계약서(전자문서 포함)를 작성한 비율은 어떻게 됩니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_11_2" value="<%=setHiddenValue(qa, 11, 2, 5)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_11_2" value="1" <%if(qa[11][2][1]!=null && qa[11][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,2);"></input> 가. 100% (전체 서면계약)<span class="boxcontentsubtitle">11-6번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_11_2" value="2" <%if(qa[11][2][2]!=null && qa[11][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,2);"></input> 나. 95% ~ 100% 미만 (예외적 경우 제외한 전체 서면계약)</li>
						<li><input type="radio" name="q2_11_2" value="3" <%if(qa[11][2][3]!=null && qa[11][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,2);"></input> 다. 75% ~ 95% 미만</li>
						<li><input type="radio" name="q2_11_2" value="4" <%if(qa[11][2][4]!=null && qa[11][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,2);"></input> 라. 50% ~ 75% 미만</li>
						<li><input type="radio" name="q2_11_2" value="5" <%if(qa[11][2][5]!=null && qa[11][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,2);"></input> 마. 50% 미만</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle" ><span>11-3. </span> 귀사가 <%= st_Current_Year_n-1%>년도 조사대상 원사업자와의 위탁 계약을 구두로 맺은 경우, 귀사가 해당 원사업자에게 계약 내용의 확인을 요청하는 서면(이메일,전자문서 포함)을 발송한 경우가 몇 건 있습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_11_3" value="<%=setHiddenValue(qa, 11, 3, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_11_3" value="1" <%if(qa[11][3][1]!=null && qa[11][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,3);"></input> 가. 있다(<input type="text" name="q2_11_22" value="<%=qa[11][22][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="radio" name="q2_11_3" value="2" <%if(qa[11][3][2]!=null && qa[11][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,3);"></input> 나. 없다<span class="boxcontentsubtitle">11-6번 문항으로 이동</span></li>
					</ul>
					<div class="fc pt_50"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11-4. </span> 귀사가 조사대상 원사업자에게 계약 내용의 확인을 요청하는 서면을 발송한 이후, 해당 원사업자가 15일 이내에 회신한 건수와 그 방법은 어떠하였습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:60%;" />
									<col style="width:40%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>구분</th>
										<th>건수</th>
									</tr>
									<tr>
										<th>15일 이내 총 회신</th>
										<td><input type="text" name="q2_11_23" value="<%=qa[11][23][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 건</td>
									</tr>
									<tr>
										<th>서면 회신</th>
										<td><input type="text" name="q2_11_24" value="<%=qa[11][24][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 건</td>
									</tr>
									<tr>
										<th>구두 회신</th>
										<td><input type="text" name="q2_11_25" value="<%=qa[11][25][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 건</td>
									</tr>
									<tr>
										<th>15일 이후 회신 또는 회신하지 않음</th>
										<td><input type="text" name="q2_11_26" value="<%=qa[11][26][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 건</td>
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
					<ul class="elt">
						<li class="boxcontenttitle" ><span>11-5. </span> 귀사가 조사대상 원사업자로부터 15일 이내에 서면 또는 구두로 회신 받지 못한 상황에서 계약을 취소당한 경우가 있었습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_11_5" value="<%=setHiddenValue(qa, 11, 5, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_11_5" value="1" <%if(qa[11][5][1]!=null && qa[11][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,5);"></input> 가. 있다(<input type="text" name="q2_11_27" value="<%=qa[11][27][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>건)</li>
						<li><input type="radio" name="q2_11_5" value="2" <%if(qa[11][5][2]!=null && qa[11][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,5);"></input> 나. 없다</li>
					</ul>
					<div class="fc pt_50"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11-6. </span> 귀사가 <%= st_Current_Year_n-1%>년도에 조사대상 원사업자와 하도급계약을 체결할 시 표준하도급계약서를 사용한 비율은 어떻게 됩니까?</li>
						<li class="boxcontentsubtitle">* 최신 표준하도급계약서가 아닌 기존 표준하도급계약서를 사용한 경우나 업종·기업 특성을 고려하여 표준하도급계약서를 수정하여 사용한 경우에도 표준하도급계약서를 사용한 것으로 간주함. 단, 수급사업자에게 불리한 내용이 포함되지 않은다는 조건에 한함.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_11_6" value="<%=setHiddenValue(qa, 11, 6, 5)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_11_6" value="1" <%if(qa[11][6][1]!=null && qa[11][6][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,6);"></input> 가. 100% (전체 사용)<span class="boxcontentsubtitle">12-1번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_11_6" value="2" <%if(qa[11][6][2]!=null && qa[11][6][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,6);"></input> 나. 95% ~ 100% 미만 (예외적 경우 제외한 전체 사용)</li>
						<li><input type="radio" name="q2_11_6" value="3" <%if(qa[11][6][3]!=null && qa[11][6][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,6);"></input> 다. 75% ~ 95% 미만</li>
						<li><input type="radio" name="q2_11_6" value="4" <%if(qa[11][6][4]!=null && qa[11][6][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,6);"></input> 라. 50% ~ 75% 미만</li>
						<li><input type="radio" name="q2_11_6" value="5" <%if(qa[11][6][5]!=null && qa[11][6][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,6);"></input> 마. 50% 미만</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11-7. </span> 서면계약 시 표준하도급계약서를 사용하지 않았다면 주된 그 이유는 무엇입니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_11_7" value="<%=setHiddenValue(qa, 11, 7, 6)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_11_7" value="1" <%if(qa[11][7][1]!=null && qa[11][7][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,7);"></input> 가. 원사업자가 기존 계약서 양식을 사용하길 원했기 때문</li>
						<li><input type="radio" name="q2_11_7" value="2" <%if(qa[11][7][2]!=null && qa[11][7][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,7);"></input> 나. 기존 계약서 양식 변경 시 업무 부담이 증가하기 때문</li>
						<li><input type="radio" name="q2_11_7" value="3" <%if(qa[11][7][3]!=null && qa[11][7][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,7);"></input> 다. 우리 업종에는 표준하도급계약서 양식이 존재하지 않기 때문</li>
						<li><input type="radio" name="q2_11_7" value="4" <%if(qa[11][7][4]!=null && qa[11][7][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,7);"></input> 라. 표준하도급계약서 내용이 업무 현실과 맞지 않기 때문</li>
						<li><input type="radio" name="q2_11_7" value="5" <%if(qa[11][7][5]!=null && qa[11][7][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,7);"></input> 마. 표준하도급계약서가 있는지 몰랐기 때문</li>
						<li><input type="radio" name="q2_11_7" value="6" <%if(qa[11][7][6]!=null && qa[11][7][6].equals("1")){out.print("checked");}%> onclick="checkradio(11,7);"></input> 바. 기타(<input type="text" name="q2_11_28" value="<%=qa[11][28][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha2">12. 하도급 계약 체결 시, 하도급 거래 단가(대금)의 결정</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>12-1. </span> <%= st_Current_Year_n-1%>년도에 귀사가 조사대상 원사업자와 맺은 하도급 거래 단가는 <%= st_Current_Year_n-2%>년도 단가에 비해 평균적으로 어느 정도 변동되었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_12_1" value="<%=setHiddenValue(qa, 12, 1, 7)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_12_1" value="1" <%if(qa[12][1][1]!=null && qa[12][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> 가. 10% 이상 인하</li>
						<li><input type="radio" name="q2_12_1" value="2" <%if(qa[12][1][2]!=null && qa[12][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> 나. 5~10% 미만 인하</li>
						<li><input type="radio" name="q2_12_1" value="3" <%if(qa[12][1][3]!=null && qa[12][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> 다. 0~5% 미만 인하</li>
						<li><input type="radio" name="q2_12_1" value="4" <%if(qa[12][1][4]!=null && qa[12][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> 라. 변화 없음</li>
						<li><input type="radio" name="q2_12_1" value="5" <%if(qa[12][1][5]!=null && qa[12][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> 마. 0~5% 미만 인상</li>
						<li><input type="radio" name="q2_12_1" value="6" <%if(qa[12][1][6]!=null && qa[12][1][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> 바. 5~10% 미만 인상</li>
						<li><input type="radio" name="q2_12_1" value="7" <%if(qa[12][1][7]!=null && qa[12][1][7].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> 사. 10% 이상 인상</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>12-2. </span> 하도급 단가 결정에 아래 요인들을 어느정도로 고려하였습니까?</li>
						<li class="boxcontentsubtitle"></li>

					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:38%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:12%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>항목</th>
										<th>전혀 고려 안함</th>
										<th>별로 고려 안함</th>
										<th>보통</th>
										<th>약간 고려</th>
										<th>매우 고려</th>
										<th>해당사항없음</th>
									</tr>
									<tr>
										<th style="text-align: left;">1) 원사업자의 인건비 변화</th>
										<td>
											<input type="hidden" name="c2_12_11" value="<%=setHiddenValue(qa, 12, 11, 6)%>"></input>
											<input type="radio" name="q2_12_11" value="1" <%if(qa[12][11][1]!=null && qa[12][11][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,11);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_11" value="2" <%if(qa[12][11][2]!=null && qa[12][11][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,11);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_11" value="3" <%if(qa[12][11][3]!=null && qa[12][11][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,11);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_11" value="4" <%if(qa[12][11][4]!=null && qa[12][11][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,11);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_11" value="5" <%if(qa[12][11][5]!=null && qa[12][11][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,11);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_11" value="6" <%if(qa[12][11][6]!=null && qa[12][11][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,11);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">2) 원사업자가 구입한 원자재 가격 변화</th>
										<td>
											<input type="hidden" name="c2_12_12" value="<%=setHiddenValue(qa, 12, 12, 6)%>"></input>
											<input type="radio" name="q2_12_12" value="1" <%if(qa[12][12][1]!=null && qa[12][12][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,12);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_12" value="2" <%if(qa[12][12][2]!=null && qa[12][12][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,12);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_12" value="3" <%if(qa[12][12][3]!=null && qa[12][12][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,12);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_12" value="4" <%if(qa[12][12][4]!=null && qa[12][12][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,12);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_12" value="5" <%if(qa[12][12][5]!=null && qa[12][12][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,12);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_12" value="6" <%if(qa[12][12][6]!=null && qa[12][12][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,12);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">3) 귀사의 생산성 변화</th>
										<td>
											<input type="hidden" name="c2_12_13" value="<%=setHiddenValue(qa, 12, 13, 6)%>"></input>
											<input type="radio" name="q2_12_13" value="1" <%if(qa[12][13][1]!=null && qa[12][13][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,13);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_13" value="2" <%if(qa[12][13][2]!=null && qa[12][13][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,13);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_13" value="3" <%if(qa[12][13][3]!=null && qa[12][13][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,13);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_13" value="4" <%if(qa[12][13][4]!=null && qa[12][13][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,13);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_13" value="5" <%if(qa[12][13][5]!=null && qa[12][13][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,13);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_13" value="6" <%if(qa[12][13][6]!=null && qa[12][13][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,13);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">4) 귀사의 인건비 변화</th>
										<td>
											<input type="hidden" name="c2_12_14" value="<%=setHiddenValue(qa, 12, 14, 6)%>"></input>
											<input type="radio" name="q2_12_14" value="1" <%if(qa[12][14][1]!=null && qa[12][14][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,14);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_14" value="2" <%if(qa[12][14][2]!=null && qa[12][14][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,14);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_14" value="3" <%if(qa[12][14][3]!=null && qa[12][14][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,14);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_14" value="4" <%if(qa[12][14][4]!=null && qa[12][14][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,14);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_14" value="5" <%if(qa[12][14][5]!=null && qa[12][14][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,14);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_14" value="6" <%if(qa[12][14][6]!=null && qa[12][14][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,14);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">5) 귀사가 구입한 원자재 가격 변화</th>
										<td>
											<input type="hidden" name="c2_12_15" value="<%=setHiddenValue(qa, 12, 15, 6)%>"></input>
											<input type="radio" name="q2_12_15" value="1" <%if(qa[12][15][1]!=null && qa[12][15][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,15);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_15" value="2" <%if(qa[12][15][2]!=null && qa[12][15][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,15);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_15" value="3" <%if(qa[12][15][3]!=null && qa[12][15][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,15);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_15" value="4" <%if(qa[12][15][4]!=null && qa[12][15][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,15);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_15" value="5" <%if(qa[12][15][5]!=null && qa[12][15][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,15);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_15" value="6" <%if(qa[12][15][6]!=null && qa[12][15][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,15);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">6) 발주한 물량 변화(다량발주 등)</th>
										<td>
											<input type="hidden" name="c2_12_16" value="<%=setHiddenValue(qa, 12, 16, 6)%>"></input>
											<input type="radio" name="q2_12_16" value="1" <%if(qa[12][16][1]!=null && qa[12][16][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,16);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_16" value="2" <%if(qa[12][16][2]!=null && qa[12][16][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,16);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_16" value="3" <%if(qa[12][16][3]!=null && qa[12][16][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,16);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_16" value="4" <%if(qa[12][16][4]!=null && qa[12][16][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,16);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_16" value="5" <%if(qa[12][16][5]!=null && qa[12][16][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,16);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_16" value="6" <%if(qa[12][16][6]!=null && qa[12][16][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,16);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">7) 원사업자의 자금 또는 예산사정 변화</th>
										<td>
											<input type="hidden" name="c2_12_17" value="<%=setHiddenValue(qa, 12, 17, 6)%>"></input>
											<input type="radio" name="q2_12_17" value="1" <%if(qa[12][17][1]!=null && qa[12][17][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,17);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_17" value="2" <%if(qa[12][17][2]!=null && qa[12][17][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,17);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_17" value="3" <%if(qa[12][17][3]!=null && qa[12][17][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,17);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_17" value="4" <%if(qa[12][17][4]!=null && qa[12][17][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,17);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_17" value="5" <%if(qa[12][17][5]!=null && qa[12][17][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,17);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_17" value="6" <%if(qa[12][17][6]!=null && qa[12][17][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,17);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">8) 기타</th>
										<td>
											<input type="hidden" name="c2_12_18" value="<%=setHiddenValue(qa, 12, 18, 6)%>"></input>
											<input type="radio" name="q2_12_18" value="1" <%if(qa[12][18][1]!=null && qa[12][18][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,18);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_18" value="2" <%if(qa[12][18][2]!=null && qa[12][18][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,18);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_18" value="3" <%if(qa[12][18][3]!=null && qa[12][18][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,18);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_18" value="4" <%if(qa[12][18][4]!=null && qa[12][18][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,18);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_18" value="5" <%if(qa[12][18][5]!=null && qa[12][18][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,18);"></input>
										</td>
										<td>
											<input type="radio" name="q2_12_18" value="6" <%if(qa[12][18][6]!=null && qa[12][18][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,18);"></input>
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
					<ul class="elt">
						<li class="boxcontenttitle"><span>12-3. </span> 하도급 단가 결정은 어떻게 이루어졌습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_12_3" value="<%=setHiddenValue(qa, 12, 3, 5)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_12_3" value="1" <%if(qa[12][3][1]!=null && qa[12][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,3);"></input> 가. 원사업자의 일방적 결정</li>
						<li><input type="radio" name="q2_12_3" value="2" <%if(qa[12][3][2]!=null && qa[12][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,3);"></input> 나. 원사업자의 제안과 귀사의 수용</li>
						<li><input type="radio" name="q2_12_3" value="3" <%if(qa[12][3][3]!=null && qa[12][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,3);"></input> 다. 귀사의 제안과 원사업자의 수용</li>
						<li><input type="radio" name="q2_12_3" value="4" <%if(qa[12][3][4]!=null && qa[12][3][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,3);"></input> 라. 수차례 협의를 통해 결정</li>
						<li><input type="radio" name="q2_12_3" value="5" <%if(qa[12][3][5]!=null && qa[12][3][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,3);"></input> 마. 기타(<input type="text" name="q2_12_21" value="<%=qa[12][21][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>12-4. </span> <%= st_Current_Year_n-1%>년도 하도급 공사 대금을 결정함에 있어 조사대상 원사업자는 자신이 발주자와 체결한 원도급계약의 물량내역서를 수정(원도급내역의 직접공사비 항목을 통합하거나 규격, 수량을 축소)하는 방식으로 직접공사비 항목의 값을 합한 금액보다 낮은 금액으로 하도급대금을 결정한 사실이 있습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_12_4" value="<%=setHiddenValue(qa, 12, 4, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_12_4" value="1" <%if(qa[12][4][1]!=null && qa[12][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,4);"></input> 가. 있다(<input type="text" name="q2_12_22" value="<%=qa[12][21][22]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="radio" name="q2_12_4" value="2" <%if(qa[12][4][2]!=null && qa[12][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,4);"></input> 나. 없다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>12-5. </span> <%= st_Current_Year_n-1%>년도 하도급공사금액을 결정함에 있어 조사대상 원사업자가 재입찰을 실시하면서 정당한 사유 없이 최저가로 입찰한 금액보다 낮은 수준으로 하도급대금을 결정한 사실이 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_12_5" value="<%=setHiddenValue(qa, 12, 5, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_12_5" value="1" <%if(qa[12][5][1]!=null && qa[12][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,5);"></input> 가. 있다(<input type="text" name="q2_12_23" value="<%=qa[12][21][23]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="radio" name="q2_12_5" value="2" <%if(qa[12][5][2]!=null && qa[12][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,5);"></input> 나. 없다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>12-6. </span> <%= st_Current_Year_n-1%>년도 조사대상 원사업자가 수의 계약으로 하도급계약을 체결하면서 정당한 사유 없이 도급내역서상 직접공사비 항목(재료비, 직접노무비, 경비)의 값을 합한 금액보다 낮은 금액으로 하도급대금을 결정한 사실이 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_12_6" value="<%=setHiddenValue(qa, 12, 6, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_12_6" value="1" <%if(qa[12][6][1]!=null && qa[12][6][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,6);"></input> 가. 있다(<input type="text" name="q2_12_24" value="<%=qa[12][21][24]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="radio" name="q2_12_6" value="2" <%if(qa[12][6][2]!=null && qa[12][6][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,6);"></input> 나. 없다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha3">13. 하도급대금 지급보증</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>13-1. </span> 귀사가 <%= st_Current_Year_n-1%>년도에 원사업자와 체결한 건설 하도급거래에서 지급보증을 받은 비율은 어떻게 됩니까? 계약건수를 기준으로 응답하여 주시고, 면제대상인 계약들은 계산에서 제외하여 주십시오.</li>
						<li class="boxcontentsubtitle">* 하도급대금 지급보증 면제대상</li>
						<li class="boxcontentsubtitle">&nbsp;&nbsp;- 2개 이상의 신용평가전문기관 회사채평가에서 A0이상의 등급을 받은 업체의 경우</li>
						<li class="boxcontentsubtitle">&nbsp;&nbsp;- 개별 공사금액이 4,000만원 이하인 경우</li>
						<li class="boxcontentsubtitle">&nbsp;&nbsp;- 발주자가 수급사업자에게 하도급대금을 직접 지급하는 경우</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_13_1" value="<%=setHiddenValue(qa, 13, 1, 6)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_13_1" value="1" <%if(qa[13][1][1]!=null && qa[13][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> 가. 원사업자가 지급보증 면제대상임<span class="boxcontentsubtitle">14-1번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_13_1" value="2" <%if(qa[13][1][2]!=null && qa[13][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> 나. 100% (전체 지급보증)<span class="boxcontentsubtitle">14-1번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_13_1" value="3" <%if(qa[13][1][3]!=null && qa[13][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> 다. 95% ~ 100% 미만 (예외적 경우 제외한 전체 지급보증)</li>
						<li><input type="radio" name="q2_13_1" value="4" <%if(qa[13][1][4]!=null && qa[13][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> 라. 75% ~ 95% 미만</li>
						<li><input type="radio" name="q2_13_1" value="5" <%if(qa[13][1][5]!=null && qa[13][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> 마. 50% ~ 75% 미만</li>
						<li><input type="radio" name="q2_13_1" value="6" <%if(qa[13][1][6]!=null && qa[13][1][6].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> 바. 50% 미만</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>13-2. </span> 면제대상이 아닌 계약에 대하여 원사업자가 귀사에게 하도급대금 지급보증을 해주지 않은 주된 이유는 무엇입니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_13_2" value="<%=setHiddenValue(qa, 13, 2, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_13_2" value="1" <%if(qa[13][2][1]!=null && qa[13][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(13,2);"></input> 가. 원사업자와의 합의에 따라</li>
						<li><input type="radio" name="q2_13_2" value="2" <%if(qa[13][2][2]!=null && qa[13][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(13,2);"></input> 나. 원사업자가 보증수수료 부담을 고려함</li>
						<li><input type="radio" name="q2_13_2" value="3" <%if(qa[13][2][3]!=null && qa[13][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(13,2);"></input> 다. 보증기관에서 보증서 발급을 회피함</li>
						<li><input type="radio" name="q2_13_2" value="4" <%if(qa[13][2][4]!=null && qa[13][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(13,2);"></input> 라. 기타(<input type="text" name="q2_13_11" value="<%=qa[13][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha4">14. 건설 위탁의 취소 및 변경</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>14-1. </span> <%= st_Current_Year_n-1%>년도에 조사대상 원사업자로부터 건설 위탁을 받은 후, 임의로 위탁이 취소되거나 변경되지 않고 본래의 계약대로 이행된 계약건수의 비율은 어떻게 됩니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_14_1" value="<%=setHiddenValue(qa, 14, 1, 5)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_14_1" value="1" <%if(qa[14][1][1]!=null && qa[14][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> 가. 100% (전체이행)<span class="boxcontentsubtitle">15-1번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_14_1" value="2" <%if(qa[14][1][2]!=null && qa[14][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> 나. 95% ~ 100% 미만 (예외적 경우 제외한 전체이행)</li>
						<li><input type="radio" name="q2_14_1" value="3" <%if(qa[14][1][3]!=null && qa[14][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> 다. 75% ~ 95% 미만</li>
						<li><input type="radio" name="q2_14_1" value="4" <%if(qa[14][1][4]!=null && qa[14][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> 라. 50% ~ 75% 미만</li>
						<li><input type="radio" name="q2_14_1" value="5" <%if(qa[14][1][5]!=null && qa[14][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> 마. 50% 미만</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>14-2. </span> 조사대상 원사업자가 건설 위탁을 취소하거나 변경한 이유는 무엇입니까?</li>
						<li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_14_2_1" value="1" <%if(qa[14][2][1]!=null && qa[14][2][1].equals("1")){out.print("checked");}%>></input> 가. 발주자의 주문취소</li>
						<li><input type="checkbox" name="q2_14_2_2" value="1" <%if(qa[14][2][2]!=null && qa[14][2][2].equals("1")){out.print("checked");}%>></input> 나. 원사업자의 경영악화</li>
						<li><input type="checkbox" name="q2_14_2_3" value="1" <%if(qa[14][2][3]!=null && qa[14][2][3].equals("1")){out.print("checked");}%>></input> 다. 귀사의 부도발생</li>
						<li><input type="checkbox" name="q2_14_2_4" value="1" <%if(qa[14][2][4]!=null && qa[14][2][4].equals("1")){out.print("checked");}%>></input> 라. 귀사의 계약불이행</li>
						<li><input type="checkbox" name="q2_14_2_5" value="1" <%if(qa[14][2][5]!=null && qa[14][2][5].equals("1")){out.print("checked");}%>></input> 마. 귀사의 시공능력 부족</li>
						<li><input type="checkbox" name="q2_14_2_6" value="1" <%if(qa[14][2][6]!=null && qa[14][2][6].equals("1")){out.print("checked");}%>></input> 바. 타 수급사업자가 더 양호한 조건을 제시</li>
						<li><input type="checkbox" name="q2_14_2_7" value="1" <%if(qa[14][2][7]!=null && qa[14][2][7].equals("1")){out.print("checked");}%>></input> 사. 기타 (<input type="text" name="q2_14_11" value="<%=qa[14][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>14-3. </span> 귀사가 <%= st_Current_Year_n-1%>년 중 당초 건설 위탁받은 하도급계약에 일부 계약내용이 추가 또는 변경되어 추가비용이 발생한 경우가 있다면, 그 계약건 수의 비율은 어떻게 됩니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_14_3" value="<%=setHiddenValue(qa, 14, 3, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_14_3" value="1" <%if(qa[14][3][1]!=null && qa[14][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(14,3);"></input> 가. 추가비용 발생한 경우 없음</li>
						<li><input type="radio" name="q2_14_3" value="2" <%if(qa[14][3][2]!=null && qa[14][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(14,3);"></input> 나. 30% 미만</li>
						<li><input type="radio" name="q2_14_3" value="3" <%if(qa[14][3][3]!=null && qa[14][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(14,3);"></input> 다. 30% ~ 50% 미만</li>
						<li><input type="radio" name="q2_14_3" value="4" <%if(qa[14][3][4]!=null && qa[14][3][4].equals("1")){out.print("checked");}%> onclick="checkradio(14,3);"></input> 라. 50% 이상</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha5">15. 물품 수령</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>15-1. </span> 조사대상 원사업자가 <%= st_Current_Year_n-1%>년도에 귀사에게 물품을 건설 위탁한 후, 그것을 수령한 비율은 어떻게 됩니까?</li>
						<li class="boxcontentsubtitle">* 수령 비율 = 100*(인수한 물량/건설위탁한 물량)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_15_1" value="<%=setHiddenValue(qa, 15, 1, 5)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_15_1" value="1" <%if(qa[15][1][1]!=null && qa[15][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"></input> 가. 100% (전체수령)<span class="boxcontentsubtitle">16-1번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_15_1" value="2" <%if(qa[15][1][2]!=null && qa[15][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"></input> 나. 95% ~ 100% 미만 (예외적 경우 제외한 전체수령)</li>
						<li><input type="radio" name="q2_15_1" value="3" <%if(qa[15][1][3]!=null && qa[15][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"></input> 다. 75% ~ 95% 미만</li>
						<li><input type="radio" name="q2_15_1" value="4" <%if(qa[15][1][4]!=null && qa[15][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"></input> 라. 50% ~ 75% 미만</li>
						<li><input type="radio" name="q2_15_1" value="5" <%if(qa[15][1][5]!=null && qa[15][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"></input> 마. 50% 미만</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>15-2. </span> 조사대상 원사업자가 건설 위탁한 물품을 수령하지 않은 이유는 무엇입니까?</li>
						<li class="boxcontentsubtitle">(해당 항목에 모두 선택)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_15_2_1" value="1" <%if(qa[15][2][1]!=null && qa[15][2][1].equals("1")){out.print("checked");}%>></input> 가. 발주자가 거래를 취소하여서</li>
						<li><input type="checkbox" name="q2_15_2_2" value="1" <%if(qa[15][2][2]!=null && qa[15][2][2].equals("1")){out.print("checked");}%>></input> 나. 시방서 또는 발주서대로 시공되지 않아서</li>
						<li><input type="checkbox" name="q2_15_2_3" value="1" <%if(qa[15][2][3]!=null && qa[15][2][3].equals("1")){out.print("checked");}%>></input> 다. 목적물에 하자가 존재해서</li>
						<li><input type="checkbox" name="q2_15_2_4" value="1" <%if(qa[15][2][4]!=null && qa[15][2][4].equals("1")){out.print("checked");}%>></input> 라. 귀사 책임으로 약정기한까지 시공되지 않아서</li>
						<li><input type="checkbox" name="q2_15_2_5" value="1" <%if(qa[15][2][5]!=null && qa[15][2][5].equals("1")){out.print("checked");}%>></input> 마. 설계변경 등으로 추가공사금액이 확정되지 않아서</li>
						<li><input type="checkbox" name="q2_15_2_6" value="1" <%if(qa[15][2][6]!=null && qa[15][2][6].equals("1")){out.print("checked");}%>></input> 바. 기타 (<input type="text" name="q2_15_11" value="<%=qa[15][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha6">16. 계약체결 후, 하도급대금 감액</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>16-1. </span> <%= st_Current_Year_n-1%>년도에 귀사가 조사대상 원사업자와 당초 계약할 때 정했던 금액대로 하도급대금(단가)을 지급받은 비율은 어떻게 됩니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_16_1" value="<%=setHiddenValue(qa, 16, 1, 5)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_16_1" value="1" <%if(qa[16][1][1]!=null && qa[16][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> 가. 100% (전체지급)<span class="boxcontentsubtitle">17-1번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_16_1" value="2" <%if(qa[16][1][2]!=null && qa[16][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> 나. 95% ~ 100% 미만 (예외적 경우 제외한 전체지급)</li>
						<li><input type="radio" name="q2_16_1" value="3" <%if(qa[16][1][3]!=null && qa[16][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> 다. 75% ~ 95% 미만</li>
						<li><input type="radio" name="q2_16_1" value="4" <%if(qa[16][1][4]!=null && qa[16][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> 라. 50% ~ 75% 미만</li>
						<li><input type="radio" name="q2_16_1" value="5" <%if(qa[16][1][5]!=null && qa[16][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> 마. 50% 미만</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>16-2. </span> 귀사가 당초 계약할 때 정했던 금액보다 조사대상 원사업자로부터 하도급대금(단가)을 적게 지급받은 이유는 무엇입니까?</li>
						<li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_16_2_1" value="1" <%if(qa[16][2][1]!=null && qa[16][2][1].equals("1")){out.print("checked");}%>></input> 가. 하자시공 등 귀사의 책임</li>
						<li><input type="checkbox" name="q2_16_2_2" value="1" <%if(qa[16][2][2]!=null && qa[16][2][2].equals("1")){out.print("checked");}%>></input> 나. 귀사가 시방서대로 시공하지 않음</li>
						<li><input type="checkbox" name="q2_16_2_3" value="1" <%if(qa[16][2][3]!=null && qa[16][2][3].equals("1")){out.print("checked");}%>></input> 다. 발주자의 주문 변경(발주취소, 물량감소 등)</li>
						<li><input type="checkbox" name="q2_16_2_4" value="1" <%if(qa[16][2][4]!=null && qa[16][2][4].equals("1")){out.print("checked");}%>></input> 라. 원사업자가 저가로 수주하였기 때문</li>
						<li><input type="checkbox" name="q2_16_2_5" value="1" <%if(qa[16][2][5]!=null && qa[16][2][5].equals("1")){out.print("checked");}%>></input> 마. 원사업자의 자금사정 때문</li>
						<li><input type="checkbox" name="q2_16_2_6" value="1" <%if(qa[16][2][6]!=null && qa[16][2][6].equals("1")){out.print("checked");}%>></input> 바. 대금 지급시점의 원자재 가격이 하락했기 때문</li>
						<li><input type="checkbox" name="q2_16_2_7" value="1" <%if(qa[16][2][7]!=null && qa[16][2][7].equals("1")){out.print("checked");}%>></input> 사. 지급수단 조정(현금 지급비율 조정 등) 때문</li>
						<li><input type="checkbox" name="q2_16_2_8" value="1" <%if(qa[16][2][8]!=null && qa[16][2][8].equals("1")){out.print("checked");}%>></input> 아. 지급기일 조정(어음결제기간 조정 등) 때문</li>
						<li><input type="checkbox" name="q2_16_2_9" value="1" <%if(qa[16][2][9]!=null && qa[16][2][9].equals("1")){out.print("checked");}%>></input> 자. 기타 (<input type="text" name="q2_16_11" value="<%=qa[16][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha7">17. 선급금 수령</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>17-1. </span> 조사대상 원사업자가 <%= st_Current_Year_n-1%>년도에 발주자로부터 선급금을 지급받은 후, 지급받은 내용과 비율에 따라 선급금을 귀사에게 15일 이내에 지급한 비율은 어떻게 됩니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_17_1" value="<%=setHiddenValue(qa, 17, 1, 6)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_17_1" value="1" <%if(qa[17][1][1]!=null && qa[17][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"></input> 가. 100% (전체지급)<span class="boxcontentsubtitle">18-1번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_17_1" value="2" <%if(qa[17][1][2]!=null && qa[17][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"></input> 나. 95% ~ 100% 미만 (예외적 경우 제외한 전체지급)</li>
						<li><input type="radio" name="q2_17_1" value="3" <%if(qa[17][1][3]!=null && qa[17][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"></input> 다. 75% ~ 95% 미만</li>
						<li><input type="radio" name="q2_17_1" value="4" <%if(qa[17][1][4]!=null && qa[17][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"></input> 라. 50% ~ 75% 미만</li>
						<li><input type="radio" name="q2_17_1" value="5" <%if(qa[17][1][5]!=null && qa[17][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"></input> 마. 50% 미만</li>
						<li><input type="radio" name="q2_17_1" value="6" <%if(qa[17][1][6]!=null && qa[17][1][6].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"></input> 바. 선급금을 지급받은 적 없음<span class="boxcontentsubtitle">18-1번 문항으로 이동</span></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>17-2. </span> 조사대상 원사업자가 <%= st_Current_Year_n-1%>년도에 발주자로부터 받은 선급금을 내용과 비율에 따라 귀사에게 지급하지 못한 경우가 있다면 이유는 무엇입니까?</li>
						<li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_17_2_1" value="1" <%if(qa[17][2][1]!=null && qa[17][2][1].equals("1")){out.print("checked");}%>></input> 가. 귀사가 선급금 수령을 포기하거나 유예를 요청함</li>
						<li><input type="checkbox" name="q2_17_2_2" value="1" <%if(qa[17][2][2]!=null && qa[17][2][2].equals("1")){out.print("checked");}%>></input> 나. 원사업자와 선급금을 지급받지 않기로 하도급계약을 맺음</li>
						<li><input type="checkbox" name="q2_17_2_3" value="1" <%if(qa[17][2][3]!=null && qa[17][2][3].equals("1")){out.print("checked");}%>></input> 다. 귀사가 선급금지급 이행보증서 미제출</li>
						<li><input type="checkbox" name="q2_17_2_4" value="1" <%if(qa[17][2][4]!=null && qa[17][2][4].equals("1")){out.print("checked");}%>></input> 라. 공사금액이 소액이고 공사기간이 짧았음</li>
						<li><input type="checkbox" name="q2_17_2_5" value="1" <%if(qa[17][2][5]!=null && qa[17][2][5].equals("1")){out.print("checked");}%>></input> 마. 원사업자의 자금사정 등으로 지급받지 못함</li>
						<li><input type="checkbox" name="q2_17_2_6" value="1" <%if(qa[17][2][6]!=null && qa[17][2][6].equals("1")){out.print("checked");}%>></input> 바. 기타 (<input type="text" name="q2_17_11" value="<%=qa[17][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha8">18. 하도급대금 수령</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18-1. </span> 귀사가 목적물을 정상 인도하였음에도 <%= st_Current_Year_n-1%>년 12월 말까지 조사대상 원사업자로부터 하도급 대금을 지급받지 못한 건이 있습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_18_1" value="<%=setHiddenValue(qa, 18, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_18_1" value="1" <%if(qa[18][1][1]!=null && qa[18][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"></input> 가. 있다(<input type="text" name="q2_18_11" value="<%=qa[18][11][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>건)</li>
						<li><input type="radio" name="q2_18_1" value="2" <%if(qa[18][1][2]!=null && qa[18][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"></input> 나. 없다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18-2. </span> 귀사가 <%= st_Current_Year_n-1%>년도에 조사대상 원사업자로부터 받은 하도급대금의 수령 수단별 비중은 어떻게 됩니까?</li>
						<li class="boxcontentsubtitle">* 어음대체 결제수단 : 기업구매전용카드, 외상매출채권담보대출, 구매론 등 상환청구권이 없는 건을 기재</li>
						<li class="boxcontentsubtitle">* 어음 : 어음법에 의한 실물어음(종이어음) 이외에 "전자어음의 발행 및 유통에 관한 법률"에 따라 발행된 전자어음도 포함하여 작성</li>
						<li class="boxcontentsubtitle">* 기타 : 그 밖의 다른 수단으로 지급한 경우 기재</li>
						<li class="boxcontentsubtitle">&nbsp;</li>
						<li class="boxcontentsubtitle">* 지급한 비율이 없다면 0을 입력해주세요.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:60%;" />
									<col style="width:40%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>구분</th>
										<th>비중</th>
									</tr>
									<tr>
										<th>현금(수표 포함)</th>
										<td><input type="text" name="q2_18_21" value="<%=qa[18][21][20]%>" onKeyUp="sukeyup(this); fn_hap18_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>외상매출채권 담보대출(만기 1일 이하, 상환청구권 無)</th>
										<td><input type="text" name="q2_18_22" value="<%=qa[18][22][20]%>" onKeyUp="sukeyup(this); fn_hap18_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>기업구매전용카드(만기 1일 이하)</th>
										<td><input type="text" name="q2_18_23" value="<%=qa[18][23][20]%>" onKeyUp="sukeyup(this); fn_hap18_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>구매론(만기 1일 이하)</th>
										<td><input type="text" name="q2_18_24" value="<%=qa[18][24][20]%>" onKeyUp="sukeyup(this); fn_hap18_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>상생결제 시스템(만기 1일 이하)</th>
										<td><input type="text" name="q2_18_25" value="<%=qa[18][25][20]%>" onKeyUp="sukeyup(this); fn_hap18_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>위 어음대체결제수단(단, 만기 1일 초과)</th>
										<td><input type="text" name="q2_18_26" value="<%=qa[18][26][20]%>" onKeyUp="sukeyup(this); fn_hap18_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>어음(만기 60일 이하)</th>
										<td><input type="text" name="q2_18_27" value="<%=qa[18][27][20]%>" onKeyUp="sukeyup(this); fn_hap18_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>어음(하도급 거래 한정. 만기 61일~120일)</th>
										<td><input type="text" name="q2_18_28" value="<%=qa[18][28][20]%>" onKeyUp="sukeyup(this); fn_hap18_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>어음(하도급 거래 한정. 만기 121일 초과)</th>
										<td><input type="text" name="q2_18_29" value="<%=qa[18][29][20]%>" onKeyUp="sukeyup(this); fn_hap18_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>대물변제</th>
										<td><input type="text" name="q2_18_30" value="<%=qa[18][30][20]%>" onKeyUp="sukeyup(this); fn_hap18_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>기타</th>
										<td><input type="text" name="q2_18_20" value="<%=qa[18][20][20]%>" onKeyUp="sukeyup(this); fn_hap18_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>합계</th>
										<td><input type="text" readonly="readonly" name="allSum18_2" value="" size="30" class="text03b"></input> %</td>
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
					<ul class="elt">
						<li class="boxcontenttitle"><span>18-3 </span> 귀사가 조사대상 원사업자로부터 하도급 대금을 수령함에 있어, 목적물 인수일로부터 60일을 초과하여 대금을 수령한 비율은 어떻게 됩니까?</li>
						<li class="boxcontentsubtitle">* 목적물 인수일은 통상 세금계산서 발행일을 기준으로 함.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_18_3" value="<%=setHiddenValue(qa, 18, 3, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_18_3" value="1" <%if(qa[18][3][1]!=null && qa[18][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,3);"></input> 가. 없음<span class="boxcontentsubtitle">19-1번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_18_3" value="2" <%if(qa[18][3][2]!=null && qa[18][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,3);"></input> 나. 30% 미만</li>
						<li><input type="radio" name="q2_18_3" value="3" <%if(qa[18][3][3]!=null && qa[18][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(18,3);"></input> 다. 30% ~ 50% 미만</li>
						<li><input type="radio" name="q2_18_3" value="4" <%if(qa[18][3][4]!=null && qa[18][3][4].equals("1")){out.print("checked");}%> onclick="checkradio(18,3);"></input> 라. 50% 이상</li>
					</ul>
					<div class="fc pt_10"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18-4 </span> 60일을 초과하여 하도급대금을 수령한 경우가 있다면, 그 경우의 지급받은 수단별 비중은 어떻게 됩니까?</li>
						<li class="boxcontentsubtitle">* 어음대체 결제수단 : 기업구매전용카드, 외상매출채권담보대출, 구매론 등 상환청구권이 없는 건을 기재</li>
						<li class="boxcontentsubtitle">* 어음 : 어음법에 의한 실물어음(종이어음) 이외에 "전자어음의 발행 및 유통에 관한 법률"에 따라 발행된 전자어음도 포함하여 작성</li>
						<li class="boxcontentsubtitle">* 기타 : 그 밖의 다른 수단으로 지급한 경우 기재</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:60%;" />
									<col style="width:40%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>구분</th>
										<th>비중</th>
									</tr>
									<tr>
										<th>현금(수표 포함)</th>
										<td><input type="text" name="q2_18_31" value="<%=qa[18][31][20]%>" onKeyUp="sukeyup(this); fn_hap18_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>어음대체 결제수단</th>
										<td><input type="text" name="q2_18_32" value="<%=qa[18][32][20]%>" onKeyUp="sukeyup(this); fn_hap18_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>어음</th>
										<td><input type="text" name="q2_18_33" value="<%=qa[18][33][20]%>" onKeyUp="sukeyup(this); fn_hap18_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>기타</th>
										<td><input type="text" name="q2_18_34" value="<%=qa[18][34][20]%>" onKeyUp="sukeyup(this); fn_hap18_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>대물변제</th>
										<td><input type="text" name="q2_18_35" value="<%=qa[18][35][20]%>" onKeyUp="sukeyup(this); fn_hap18_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>합계</th>
										<td><input type="text" readonly="readonly" name="allSum18_4" value="" size="30" class="text03b"></input> %</td>
									</tr>
								</tbody>
							</table>
						</li>
					</ul>
					<div class="fc pt_50"></div>
					<div class="fc pt_50"></div>
					<div class="fc pt_50"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18-5. </span> 60일을 초과하여 하도급대금을 수령한 경우, 지연이자·어음할인료·금융기관 약정수수료 등도 수령하였습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_18_5" value="<%=setHiddenValue(qa, 18, 5, 3)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_18_5" value="1" <%if(qa[18][5][1]!=null && qa[18][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,5);"></input> 가. 전부 수령</li>
						<li><input type="radio" name="q2_18_5" value="2" <%if(qa[18][5][2]!=null && qa[18][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,5);"></input> 나. 일부 수령(일부 미수령)</li>
						<li><input type="radio" name="q2_18_5" value="3" <%if(qa[18][5][3]!=null && qa[18][5][3].equals("1")){out.print("checked");}%> onclick="checkradio(18,5);"></input> 다. 전부 미수령</li>
					</ul>
					<div class="fc pt_30"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18-6. </span> 조사대상 원사업자가 지연이자·어음할인료·금융기관 약정수수료 등을 일단 귀사에 지급한 후, 다시 회수해가거나 그 비율만큼 하도급대금을 감액한 사실이 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_18_6" value="<%=setHiddenValue(qa, 18, 6, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_18_6" value="1" <%if(qa[18][6][1]!=null && qa[18][6][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"></input> 가. 있다</li>
						<li><input type="radio" name="q2_18_6" value="2" <%if(qa[18][6][2]!=null && qa[18][6][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"></input> 나. 없다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18-7. </span> <%= st_Current_Year_n-1%>년도에 귀사가 원사업자로부터 하도급대금을 물품으로 지급받은 대물변제의 경험이 있다면, 아래 보기 중 어느 유형에 해당합니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_18_7" value="<%=setHiddenValue(qa, 18, 7, 5)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_18_7" value="1" <%if(qa[18][7][1]!=null && qa[18][7][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,7);"></input> 가. 귀사의 의사에 반하여 대물변제를 강요받음</li>
						<li><input type="radio" name="q2_18_7" value="2" <%if(qa[18][7][2]!=null && qa[18][7][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,7);"></input> 나. 원사업자와 귀사의 합의에 따라 하도급대금을 물품으로 지급받음</li>
						<li><input type="radio" name="q2_18_7" value="3" <%if(qa[18][7][3]!=null && qa[18][7][3].equals("1")){out.print("checked");}%> onclick="checkradio(18,7);"></input> 다. 귀사의 의사에 의하여 하도급대금을 물품으로 지급받음</li>
						<li><input type="radio" name="q2_18_7" value="4" <%if(qa[18][7][4]!=null && qa[18][7][4].equals("1")){out.print("checked");}%> onclick="checkradio(18,7);"></input> 라. 기타(<input type="text" name="q2_18_12" value="<%=qa[18][12][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="radio" name="q2_18_7" value="5" <%if(qa[18][7][5]!=null && qa[18][7][5].equals("1")){out.print("checked");}%> onclick="checkradio(18,7);"></input> 마. 물품으로 지급받은 적이 없음</li>
					</ul>
					<div class="fc pt_30"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha9">19. 설계변경 또는 경제상황의 변동(물가상승)에 따른 공사대금 증액조정</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>19-1. </span> <%= st_Current_Year_n-1%>년도에 원사업자가 발주자로부터 설계변경 또는 경제상황의 변동(물가상승) 등에 따른 공사대금의 증액 조정을 받은 대로 귀사에게 공사대금의 증액 조정을 해준 경우가 몇 건 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="text" name="q2_19_1" value="<%=qa[19][1][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>건</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>19-2. </span> 조사대상 원사업자가 <%= st_Current_Year_n-1%>년도에 발주자로부터 받은 선급금을 내용과 비율에 따라 귀사에게 지급하지 못한 경우가 있다면 이유는 무엇입니까?</li>
						<li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_19_2_1" value="1" <%if(qa[19][2][1]!=null && qa[19][2][1].equals("1")){out.print("checked");}%>></input> 가. 하도급계약서에 ESC(물가변동으로 인한 계약 금액 조정)를 적용하지 않기로 함</li>
						<li><input type="checkbox" name="q2_19_2_2" value="1" <%if(qa[19][2][2]!=null && qa[19][2][2].equals("1")){out.print("checked");}%>></input> 나. 계약체결 후 90일이 경과되지 아니함</li>
						<li><input type="checkbox" name="q2_19_2_3" value="1" <%if(qa[19][2][3]!=null && qa[19][2][3].equals("1")){out.print("checked");}%>></input> 다. 물가상승률이 3% 미만임을 고려함</li>
						<li><input type="checkbox" name="q2_19_2_4" value="1" <%if(qa[19][2][4]!=null && qa[19][2][4].equals("1")){out.print("checked");}%>></input> 라. 기타 (<input type="text" name="q2_19_11" value="<%=qa[19][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="checkbox" name="q2_19_2_5" value="1" <%if(qa[19][2][5]!=null && qa[19][2][5].equals("1")){out.print("checked");}%>></input> 마. 공사대금의 증액 조정을 해주지 못한 경우가 없음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha10">20. 공급원가(재료비, 노무비, 경비 등) 변동에 따른 하도급대금 조정 신청</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>20-1. </span> 귀사는 납품단가조정협의 의무제에 대해 알고 있습니까?</li>
						<li class="boxcontentsubtitle">* 납품단가조정협의 의무제 : 공급원가(재료비, 노무비, 경비 등) 변동으로 하도급대금의 조정이 불가피한 경우, 수급사업자 또는 수급사업자가 속한 중소기업협동조합은 원사업자에게 하도급대금 조정신청을 할 수 있음. 원사업자는 10일 이내 협의를 개시하여야 하고, 정당한 이유없이 협의를 거부하거나 게을리 하여서는 아니 됨.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_20_1" value="<%=setHiddenValue(qa, 20, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_20_1" value="1" <%if(qa[20][1][1]!=null && qa[20][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"></input> 가. 알고 있음</li>
						<li><input type="radio" name="q2_20_1" value="2" <%if(qa[20][1][2]!=null && qa[20][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"></input> 나. 잘 모름</li>
					</ul>
					<div class="fc pt_50"></div>
					<div class="fc pt_50"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>20-2. </span> <%= st_Current_Year_n-1%>년도에 공급원가 상승을 이유로 조사대상 원사업자에게 하도급대금 조정을 귀사가 직접 신청하거나, 중소기업협동조합을 통해 신청한 적이 있습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_20_2" value="<%=setHiddenValue(qa, 20, 2, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_20_2" value="1" <%if(qa[20][2][1]!=null && qa[20][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,2);"></input> 가. 있다</li>
						<li><input type="radio" name="q2_20_2" value="2" <%if(qa[20][2][2]!=null && qa[20][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,2);"></input> 나. 없다<span class="boxcontentsubtitle">20-5번 문항으로 이동</span></li>
					</ul>
					<div class="fc pt_50"></div>
					<div class="fc pt_50"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>20-3. </span> 귀사가 하도급대금 조정 신청을 한 건수와 신청 후 10일 이내에 조사대상 원사업자가 협의를 개시한 건수는 몇 건입니까?</li>
						<li class="boxcontentsubtitle">* 하도급대금 조정 신청(A)을 한 후 동일 건에 대하여 중소기업협동조합을 통하여 대금 조정을 재신청(B)한 경우는, 후자(B)의 조정신청 건수로만 계산</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:40%;" />
									<col style="width:30%;" />
									<col style="width:30%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>구분</th>
										<th>신청 건수</th>
										<th>10일 이내 협의를 개시한 건 수</th>
									</tr>
									<tr>
										<th>직접 하도급대금 조정신청</th>
										<td>
											<input type="text" name="q2_20_11" value="<%=qa[20][11][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 개사
										</td>
										<td>
											<input type="text" name="q2_20_12" value="<%=qa[20][12][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 개사
										</td>
									</tr>
									<tr>
										<th>중소기업협동조합을 통해 조정신청</th>
										<td>
											<input type="text" name="q2_20_13" value="<%=qa[20][13][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 개사
										</td>
										<td>
											<input type="text" name="q2_20_14" value="<%=qa[20][14][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 개사
										</td>
									</tr>
								</tbody>
							</table>
						</li>
					</ul>
					<div class="fc pt_50"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>20-4. </span> 귀사가 직접 또는 중소기업협동조합을 통해 하도급대금 인상 요청을 한 경우에 대하여, 조사대상 원사업자가 요청사항을 <u>일부 또는 전적으로</u> 수용한 비율은 어떻게 됩니까? 건수를 기준으로 응답하여 주십시오.</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_20_4" value="<%=setHiddenValue(qa, 20, 4, 6)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_20_4" value="1" <%if(qa[20][4][1]!=null && qa[20][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,4);"></input> 가. 100% (전체 수용)</li>
						<li><input type="radio" name="q2_20_4" value="2" <%if(qa[20][4][2]!=null && qa[20][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,4);"></input> 나. 75% ~ 100% 미만</li>
						<li><input type="radio" name="q2_20_4" value="3" <%if(qa[20][4][3]!=null && qa[20][4][3].equals("1")){out.print("checked");}%> onclick="checkradio(20,4);"></input> 다. 50% ~ 75% 미만</li>
						<li><input type="radio" name="q2_20_4" value="4" <%if(qa[20][4][4]!=null && qa[20][4][4].equals("1")){out.print("checked");}%> onclick="checkradio(20,4);"></input> 라. 25% ~ 50% 미만</li>
						<li><input type="radio" name="q2_20_4" value="5" <%if(qa[20][4][5]!=null && qa[20][4][5].equals("1")){out.print("checked");}%> onclick="checkradio(20,4);"></input> 마. 25% 미만</li>
						<li><input type="radio" name="q2_20_4" value="6" <%if(qa[20][4][6]!=null && qa[20][4][6].equals("1")){out.print("checked");}%> onclick="checkradio(20,4);"></input> 바. 0% (전체 미수용)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>20-5. </span> 귀사의 공급원가가 인상되었음에도 불구하고, 조사대상 원사업자에게 하도급대금 인상을 요청하지 않은 경우가 있었다면 그 이유는 무엇입니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_20_5" value="<%=setHiddenValue(qa, 20, 5, 7)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_20_5" value="1" <%if(qa[20][5][1]!=null && qa[20][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,5);"></input> 가. 공급원가 상승폭이 미미해서</li>
						<li><input type="radio" name="q2_20_5" value="2" <%if(qa[20][5][2]!=null && qa[20][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,5);"></input> 나. 원사업자가 하도급대금을 이미 조정해서</li>
						<li><input type="radio" name="q2_20_5" value="3" <%if(qa[20][5][3]!=null && qa[20][5][3].equals("1")){out.print("checked");}%> onclick="checkradio(20,5);"></input> 다. 다음 납품가격에 반영하기로 합의해서</li>
						<li><input type="radio" name="q2_20_5" value="4" <%if(qa[20][5][4]!=null && qa[20][5][4].equals("1")){out.print("checked");}%> onclick="checkradio(20,5);"></input> 라. 신청해도 원사업자가 수용할 것 같지 않아서</li>
						<li><input type="radio" name="q2_20_5" value="5" <%if(qa[20][5][5]!=null && qa[20][5][5].equals("1")){out.print("checked");}%> onclick="checkradio(20,5);"></input> 마. 거래량 축소, 거래 단절 등 원사업자의 보복이 두려워서</li>
						<li><input type="radio" name="q2_20_5" value="6" <%if(qa[20][5][6]!=null && qa[20][5][6].equals("1")){out.print("checked");}%> onclick="checkradio(20,5);"></input> 바. 기타(<input type="text" name="q2_20_15" value="<%=qa[20][15][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="radio" name="q2_20_5" value="7" <%if(qa[20][5][7]!=null && qa[20][5][7].equals("1")){out.print("checked");}%> onclick="checkradio(20,5);"></input> 사. 해당사항 없음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha11">21. 하도급법 위반</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>21-1. </span> 귀사 또는 귀사가 소속된 조합은 <%= st_Current_Year_n-1%>년 동안 공정위 등 관계 기관에 조사대상 원사업자와의 하도급법 위반을 신고한 경우가 몇 건 있습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_21_1" value="<%=setHiddenValue(qa, 21, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_21_1" value="1" <%if(qa[21][1][1]!=null && qa[21][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"></input> 가. 있다(<input type="text" name="q2_21_11" value="<%=qa[21][11][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>건)</li>
						<li><input type="radio" name="q2_21_1" value="2" <%if(qa[21][1][2]!=null && qa[21][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"></input> 나. 없다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>21-2. </span> <%= st_Current_Year_n-1%>년 동안 귀사 또는 귀사 조합은 (하도급 서면실태조사 응답 내용에 대한 후속 조사 차원에서) 조사대상 원사업자와의 하도급 거래에 관한 증빙자료를 공정위에 제출한 경우가 몇 건 있습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_21_2" value="<%=setHiddenValue(qa, 21, 2, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_21_2" value="1" <%if(qa[21][2][1]!=null && qa[21][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,2);"></input> 가. 있다(<input type="text" name="q2_21_12" value="<%=qa[21][12][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>건)</li>
						<li><input type="radio" name="q2_21_2" value="2" <%if(qa[21][2][2]!=null && qa[21][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,2);"></input> 나. 없다<span class="boxcontentsubtitle">22-1번 문항으로 이동</span></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>21-3. </span> 귀사는  <%= st_Current_Year_n-1%>년 동안 신고나 조정신청 또는 서면실태조사에 따른 증빙자료를 제출하였다는 이유로 조사대상 원사업자로부터 불이익을 받은 경우가 몇 건 있습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_21_3" value="<%=setHiddenValue(qa, 21, 3, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_21_3" value="1" <%if(qa[21][3][1]!=null && qa[21][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,3);"></input> 가. 있다(<input type="text" name="q2_21_13" value="<%=qa[21][13][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>건)</li>
						<li><input type="radio" name="q2_21_3" value="2" <%if(qa[21][3][2]!=null && qa[21][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,3);"></input> 나. 없다</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>21-4. </span> 귀사가 조사대상 원사업자로부터 불이익을 받은 사실이 있다면, 아래의 해당항목을 모두 선택하여 주십시오.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_21_4_1" value="1" <%if(qa[21][4][1]!=null && qa[21][4][1].equals("1")){out.print("checked");}%>></input> 가. 수주기회 제한</li>
						<li><input type="checkbox" name="q2_21_4_2" value="1" <%if(qa[21][4][2]!=null && qa[21][4][2].equals("1")){out.print("checked");}%>></input> 나. 거래 중단</li>
						<li><input type="checkbox" name="q2_21_4_3" value="1" <%if(qa[21][4][3]!=null && qa[21][4][3].equals("1")){out.print("checked");}%>></input> 다. 기타 (<input type="text" name="q2_21_14" value="<%=qa[21][14][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha12">22. 하자보수 보증</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>22-1. </span> <%= st_Current_Year_n-1%>년도에 원사업자가 귀사에게 하자보수 보증에 관한 사항을 요구하였다면, 그 비율은 어떻게 됩니까? 계약건수를 기준으로 응답하여 주십시오.</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_22_1" value="<%=setHiddenValue(qa, 22, 1, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_22_1" value="1" <%if(qa[22][1][1]!=null && qa[22][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(22,1);"></input> 가. 하자보증 이행 요구 사실 없음<span class="boxcontentsubtitle">23-1번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_22_1" value="2" <%if(qa[22][1][2]!=null && qa[22][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(22,1);"></input> 나. 30% 미만</li>
						<li><input type="radio" name="q2_22_1" value="3" <%if(qa[22][1][3]!=null && qa[22][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(22,1);"></input> 다. 30~50% 미만</li>
						<li><input type="radio" name="q2_22_1" value="4" <%if(qa[22][1][4]!=null && qa[22][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(22,1);"></input> 라. 50% 이상</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>22-2. </span> <%= st_Current_Year_n-1%>년도에 원사업자가 하자담보책임을 위한 하자보수보증금율을 계약서에 설정하였다면, 그 평균적인 비율은 어떻게 됩니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_22_2" value="<%=setHiddenValue(qa, 22, 2, 6)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_22_2" value="1" <%if(qa[22][2][1]!=null && qa[22][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);"></input> 가. 계약서에 하자보수보증금율 미설정</li>
						<li><input type="radio" name="q2_22_2" value="2" <%if(qa[22][2][2]!=null && qa[22][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);"></input> 나. 0~5% 미만</li>
						<li><input type="radio" name="q2_22_2" value="3" <%if(qa[22][2][3]!=null && qa[22][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);"></input> 다. 5~10% 미만</li>
						<li><input type="radio" name="q2_22_2" value="4" <%if(qa[22][2][4]!=null && qa[22][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);"></input> 라. 10~15% 미만</li>
						<li><input type="radio" name="q2_22_2" value="5" <%if(qa[22][2][5]!=null && qa[22][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);"></input> 마. 15~20% 미만</li>
						<li><input type="radio" name="q2_22_2" value="6" <%if(qa[22][2][6]!=null && qa[22][2][6].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);"></input> 바. 20% 이상</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>22-3. </span> <%= st_Current_Year_n-1%>년도에 원사업자가 하자보증 이행을 위해 귀사에게 유보금 설정을 요구하였다면, 유보금을 설정한 계약 건수의 비율은 어떻게 됩니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_22_3" value="<%=setHiddenValue(qa, 22, 3, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_22_3" value="1" <%if(qa[22][3][1]!=null && qa[22][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(22,3);"></input> 가. 유보금 설정 사례 없음<span class="boxcontentsubtitle">23-1번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_22_3" value="2" <%if(qa[22][3][2]!=null && qa[22][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(22,3);"></input> 나. 30% 미만</li>
						<li><input type="radio" name="q2_22_3" value="3" <%if(qa[22][3][3]!=null && qa[22][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(22,3);"></input> 다. 30~50% 미만</li>
						<li><input type="radio" name="q2_22_3" value="4" <%if(qa[22][3][4]!=null && qa[22][3][4].equals("1")){out.print("checked");}%> onclick="checkradio(22,3);"></input> 라. 50% 이상</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>22-4. </span> <%= st_Current_Year_n-1%>년도에 원사업자가 실제 유보금으로 설정한 금액은 하도급대금의 몇 % 정도 입니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_22_4" value="<%=setHiddenValue(qa, 22, 4, 5)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_22_4" value="1" <%if(qa[22][4][1]!=null && qa[22][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(22,4);"></input> 가. 0~5% 미만</li>
						<li><input type="radio" name="q2_22_4" value="2" <%if(qa[22][4][2]!=null && qa[22][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(22,4);"></input> 나. 5~10% 미만</li>
						<li><input type="radio" name="q2_22_4" value="3" <%if(qa[22][4][3]!=null && qa[22][4][3].equals("1")){out.print("checked");}%> onclick="checkradio(22,4);"></input> 다. 10~15% 미만</li>
						<li><input type="radio" name="q2_22_4" value="4" <%if(qa[22][4][4]!=null && qa[22][4][4].equals("1")){out.print("checked");}%> onclick="checkradio(22,4);"></input> 라. 15~20% 미만</li>
						<li><input type="radio" name="q2_22_4" value="5" <%if(qa[22][4][5]!=null && qa[22][4][5].equals("1")){out.print("checked");}%> onclick="checkradio(22,4);"></input> 마. 20% 이상</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>22-5. </span> <%= st_Current_Year_n-1%>년도에 원사업자는 설정 유보금을 귀사에게 통상 언제 지급하였습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_22_5" value="<%=setHiddenValue(qa, 22, 5, 7)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_22_5" value="1" <%if(qa[22][5][1]!=null && qa[22][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(22,5);"></input> 가. 이행기간 만료일 이후 1개월 이내</li>
						<li><input type="radio" name="q2_22_5" value="2" <%if(qa[22][5][2]!=null && qa[22][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(22,5);"></input> 나. 이행기간 만료일 이후 1개월 ~ 5개월 이내</li>
						<li><input type="radio" name="q2_22_5" value="3" <%if(qa[22][5][3]!=null && qa[22][5][3].equals("1")){out.print("checked");}%> onclick="checkradio(22,5);"></input> 다. 이행기간 만료일 이후 5개월 ~ 1년 이내</li>
						<li><input type="radio" name="q2_22_5" value="4" <%if(qa[22][5][4]!=null && qa[22][5][4].equals("1")){out.print("checked");}%> onclick="checkradio(22,5);"></input> 라. 이행기간 만료일 이후 1년 ~ 2년 이내</li>
						<li><input type="radio" name="q2_22_5" value="5" <%if(qa[22][5][5]!=null && qa[22][5][5].equals("1")){out.print("checked");}%> onclick="checkradio(22,5);"></input> 마. 이행기간 만료일 이후 2년 ~ 3년 이내</li>
						<li><input type="radio" name="q2_22_5" value="6" <%if(qa[22][5][6]!=null && qa[22][5][6].equals("1")){out.print("checked");}%> onclick="checkradio(22,5);"></input> 바. 이행기간 만료일 이후 3년 이상</li>
						<li><input type="radio" name="q2_22_5" value="7" <%if(qa[22][5][7]!=null && qa[22][5][7].equals("1")){out.print("checked");}%> onclick="checkradio(22,5);"></input> 사. 미지급</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>22-6. </span> 유보금 설정 경위 및 내용에 관해 추가로 기술할 내용이 있는 경우, 자유롭게 기술하여 주시기 바랍니다.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><textarea cols="80" rows="8" maxlength="600" name="q2_22_6" class="textarea01b" maxlength="600" onFocus="javascript:this.className='textarea01o';" onBlur="javascript:this.className='textarea01b';" onkeyup="byteLengCheck(this, 4000, this.name,'content_bytes25_1');"><%=qa[22][6][20]%></textarea></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha13">23. 협력관계</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>23-1. </span> <%= st_Current_Year_n-1%>년도에 조사대상 원사업자가 귀사와의 협력관계 증진을 위해 다음의 사항을 유상 또는 무상으로 지원한 경우가 몇 건 있습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:50%;" />
									<col style="width:50%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>구분</th>
										<th>업체 수</th>
									</tr>
									<tr>
										<th>자금(출자·융자) 지원</th>
										<td><input type="text" name="q2_23_1" value="<%=qa[23][1][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 건</td>
									</tr>
									<tr>
										<th>물자(원자재·설비) 지원</th>
										<td><input type="text" name="q2_23_2" value="<%=qa[23][2][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 건</td>
									</tr>
									<tr>
										<th>인력(교육) 지원</th>
										<td><input type="text" name="q2_23_3" value="<%=qa[23][3][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 건</td>
									</tr>
									<tr>
										<th>기술(설계) 지원</th>
										<td><input type="text" name="q2_23_4" value="<%=qa[23][4][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 건</td>
									</tr>
									<tr>
										<th>경영(컨설팅·정보화) 지원</th>
										<td><input type="text" name="q2_23_5" value="<%=qa[23][5][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 건</td>
									</tr>
									<tr>
										<th>판로(내수·수출) 지원</th>
										<td><input type="text" name="q2_23_6" value="<%=qa[23][6][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 건</td>
									</tr>
									<tr>
										<th>기타 지원</th>
										<td><input type="text" name="q2_23_7" value="<%=qa[23][7][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 건</td>
									</tr>
								</tbody>
							</table>
						</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<h2 class="contenttitle">하도급거래 세부사항 2 : 특약·기술자료</h2>
			
			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha14">24. 특약</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>24-1. </span> 귀사가 <%= st_Current_Year_n-1%>년도에 조사대상 원사업자와와 하도급계약 등을 체결하면서 계약서 등에 특약 내용을 포함하여 작성한 적이 있습니까?</li>
						<li class="boxcontentsubtitle">* 특약은 하도급 본 계약서뿐만 아니라 클레임 약정서 등 계약상 권리·의무 관계를 기재한 서면 일체를 포함</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_24_1" value="<%=setHiddenValue(qa, 24, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_24_1" value="1" <%if(qa[24][1][1]!=null && qa[24][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(24,1);"></input> 가. 있다</li>
						<li><input type="radio" name="q2_24_1" value="2" <%if(qa[24][1][2]!=null && qa[24][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(24,1);"></input> 나. 없다<span class="boxcontentsubtitle">25-1번 문항으로 이동</span></li>
					</ul>
					<div class="fc pt_50"></div>
					<div class="fc pt_20"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>24-2. </span> 귀사가 <%= st_Current_Year_n-1%>년도에 조사대상 원사업자와 체결한 하도급계약서 등에 포함된 특약내용은 무엇입니까?</li>
						<li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_24_2_1" value="1" <%if(qa[24][2][1]!=null && qa[24][2][1].equals("1")){out.print("checked");}%>></input> 가. 계약시점에 논의되지 않거나 예측할 수 없는 사항으로 인한 비용을 귀사가 부담·분담</li>
						<li><input type="checkbox" name="q2_24_2_2" value="1" <%if(qa[24][2][2]!=null && qa[24][2][2].equals("1")){out.print("checked");}%>></input> 나. 민원처리, 인·허가, 환경관리, 품질관리 등에 따른 비용을 수급사업자와 분담하기 위해</li>
						<li><input type="checkbox" name="q2_24_2_3" value="1" <%if(qa[24][2][3]!=null && qa[24][2][3].equals("1")){out.print("checked");}%>></input> 다. 설계 및 작업내용 변경으로 발생한 비용을 귀사가 부담·분담</li>
						<li><input type="checkbox" name="q2_24_2_4" value="1" <%if(qa[24][2][4]!=null && qa[24][2][4].equals("1")){out.print("checked");}%>></input> 라. 하자담보책임 또는 손해배상책임 이행에 따른 비용을 귀사가 부담·분담</li>
						<li><input type="checkbox" name="q2_24_2_5" value="1" <%if(qa[24][2][5]!=null && qa[24][2][5].equals("1")){out.print("checked");}%>></input> 마. 원사업자의 요구로 생긴 재작업, 보수작업 시 발생하는 비용을 귀사가 부담·분담</li>
						<li><input type="checkbox" name="q2_24_2_6" value="1" <%if(qa[24][2][6]!=null && qa[24][2][6].equals("1")){out.print("checked");}%>></input> 바. 기타 (<input type="text" name="q2_24_11" value="<%=qa[24][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha15">25. 조사대상 원사업자의 기술자료 요구</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>
			
			<div class="boxcontent2">
				<ul class="boxcontenthelp lt">
					<li class="boxcontenttitle">"기술자료"는 수급사업자의 상당한 노력에 의하여 만들어져 현재 비밀로 유지되고 있는 기술상 또는 경영상의 정보로서 아래 항목 중 하나에 해당하는 정보·자료를 말함.</li>
					<li class="boxcontenttitle">&nbsp;</li>
					<li class="boxcontenttitle">가. 제조·수리·시공 또는 용역수행 방법에 관한 정보·자료.</li>
					<li class="boxcontenttitle">나. 특허권, 실용신안권, 디자인권, 저작권 등의 지식재산권과 관련된 기술정보·자료로서 수급사업자의 기술개발(R&D)·생산·영업활동에 유용하고 독립된 경제적 가치가 있는 것.</li>
					<li class="boxcontenttitle">다. 시공프로세스 메뉴얼, 장비 제원, 설계도면, 생산 원가 내역서, 매출 정보 등 가목 또는 나목에 포함되지 않는 기타 사업자의 기술상 또는 경영상의 정보·자료로서 수급사업자의 기술개발(R&D)·생산·영업활동에 유용하고 독립된 경제적 가치가 있는 것.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>25-1. </span> 귀사는  <%= st_Current_Year_n-1%>년도에 조사대상 원사업자로부터 기술자료 제공을 요청받은 적이 있습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_25_1" value="<%=setHiddenValue(qa, 25, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_25_1" value="1" <%if(qa[25][1][1]!=null && qa[25][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,1);"></input> 가. 있다</li>
						<li><input type="radio" name="q2_25_1" value="2" <%if(qa[25][1][2]!=null && qa[25][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,1);"></input> 나. 없다<span class="boxcontentsubtitle">25-9번 문항으로 이동</span></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>25-2. </span> 조사대상 원사업자가 귀사에게 기술자료를 요구한 이유는 무엇입니까?</li>
						<li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_25_2_1" value="1" <%if(qa[25][2][1]!=null && qa[25][2][1].equals("1")){out.print("checked");}%>></input> 가. 공동 특허 개발</li>
						<li><input type="checkbox" name="q2_25_2_2" value="1" <%if(qa[25][2][2]!=null && qa[25][2][2].equals("1")){out.print("checked");}%>></input> 나. 공동 기술개발 약정 체결</li>
						<li><input type="checkbox" name="q2_25_2_3" value="1" <%if(qa[25][2][3]!=null && qa[25][2][3].equals("1")){out.print("checked");}%>></input> 다. 제품 하자의 원인규명</li>
						<li><input type="checkbox" name="q2_25_2_4" value="1" <%if(qa[25][2][4]!=null && qa[25][2][4].equals("1")){out.print("checked");}%>></input> 라. 기타 (<input type="text" name="q2_25_11" value="<%=qa[25][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="checkbox" name="q2_25_2_5" value="1" <%if(qa[25][2][5]!=null && qa[25][2][5].equals("1")){out.print("checked");}%>></input> 마. 이유를 잘 모름</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>25-3. </span> 귀사는 조사대상 원사업자의 요청에 따라 기술자료를 제공하였습니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_25_3" value="<%=setHiddenValue(qa, 25, 3, 3)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_25_3" value="1" <%if(qa[25][3][1]!=null && qa[25][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,3);"></input> 가. 모두 제공함</li>
						<li><input type="radio" name="q2_25_3" value="2" <%if(qa[25][3][2]!=null && qa[25][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,3);"></input> 나. 일부 제공함</li>
						<li><input type="radio" name="q2_25_3" value="3" <%if(qa[25][3][3]!=null && qa[25][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,3);"></input> 다. 제공하지 않음<span class="boxcontentsubtitle">26-1번 문항으로 이동</span></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>25-4. </span> 조사대상 원사업자가 귀사에게 요청한 기술자료의 명칭과 귀사의 제공여부를 기재하여 주십시오.</li>
						<li class="boxcontentsubtitle">* 제공여부에는 '제공' 또는 '미제공'으로 기입</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:20%;" />
									<col style="width:50%;" />
									<col style="width:30%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>구분</th>
										<th>조사대상 원사업자가 요청한 기술자료 명칭</th>
										<th>제공여부</th>
									</tr>
									<tr>
										<th>1</th>
										<td>
											<input type="text" name="q2_25_21" value="<%=qa[25][21][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_25_26" value="<%=qa[25][26][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>2</th>
										<td>
											<input type="text" name="q2_25_22" value="<%=qa[25][22][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_25_27" value="<%=qa[25][27][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>3</th>
										<td>
											<input type="text" name="q2_25_23" value="<%=qa[25][23][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_25_28" value="<%=qa[25][28][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>4</th>
										<td>
											<input type="text" name="q2_25_24" value="<%=qa[25][24][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_25_29" value="<%=qa[25][29][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>5</th>
										<td>
											<input type="text" name="q2_25_25" value="<%=qa[25][25][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_25_30" value="<%=qa[25][30][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
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
					<ul class="elt">
						<li class="boxcontenttitle"><span>25-5. </span> 조사대상 원사업자는 귀사로부터 취득한 기술자료를 어떻게 활용하였습니까?</li>
						<li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_25_5_1" value="1" <%if(qa[25][5][1]!=null && qa[25][5][1].equals("1")){out.print("checked");}%>></input> 가. 공동특허, 공동 기술개발 약정 체결, 제품하자의 원인규명에 한정하여 사용</li>
						<li><input type="checkbox" name="q2_25_5_2" value="1" <%if(qa[25][5][2]!=null && qa[25][5][2].equals("1")){out.print("checked");}%>></input> 나. 공동특허, 공동 기술개발 약정 체결, 제품하자의 원인규명 이외 목적으로 원사업자 자실을 위해 사용</li>
						<li><input type="checkbox" name="q2_25_5_3" value="1" <%if(qa[25][5][3]!=null && qa[25][5][3].equals("1")){out.print("checked");}%>></input> 다. 공동특허, 공동 기술개발 약정 체결, 제품하자의 원인규명 이외 목적으로 제3자를 위해 사용</li>
						<li><input type="checkbox" name="q2_25_5_4" value="1" <%if(qa[25][5][4]!=null && qa[25][5][4].equals("1")){out.print("checked");}%>></input> 라. 공동특허, 공동 기술개발 약정 체결, 제품하자의 원인규명 이외 목적으로 제3자에게 제공</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>25-6. </span> 귀사는  <%= st_Current_Year_n-1%>년도에 조사대상 원사업자로부터 기술자료 요청을 어떠한 양식으로 받았습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:60%;" />
									<col style="width:40%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>구분</th>
										<th>요청 건수</th>
									</tr>
									<tr>
										<th>전체</th>
										<td><input type="text" name="q2_25_12" value="<%=qa[25][12][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 건</td>
									</tr>
									<tr>
										<th>서면 요청</th>
										<td><input type="text" name="q2_25_13" value="<%=qa[25][13][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 건</td>
									</tr>
									<tr>
										<th>구두 요청</th>
										<td><input type="text" name="q2_25_14" value="<%=qa[25][14][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 건</td>
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
					<ul class="elt">
						<li class="boxcontenttitle"><span>25-7. </span> 조사대상 원사업자가 기술자료 요청 시에 사용한 서면자료 양식은 무엇입니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_25_7" value="<%=setHiddenValue(qa, 25, 7, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_25_7" value="1" <%if(qa[25][7][1]!=null && qa[25][7][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,7);"></input> 가. 자체양식</li>
						<li><input type="radio" name="q2_25_7" value="2" <%if(qa[25][7][2]!=null && qa[25][7][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,7);"></input> 나. 기술자료 요구서(공정위 예규 제263호 서식1)</li>
						<li><input type="radio" name="q2_25_7" value="3" <%if(qa[25][7][3]!=null && qa[25][7][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,7);"></input> 다. 기타(<input type="text" name="q2_25_15" value="<%=qa[25][15][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="radio" name="q2_25_7" value="4" <%if(qa[25][7][4]!=null && qa[25][7][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,7);"></input> 라. 해당사항 없음(구두로만 요청)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>25-8. </span> 조사대상 원사업자가 귀사로부터 취득한 기술자료로 인해 귀사가 재산상 손해를 입게 된 경우가 있었다면, 그 기술자료의 명칭과 손해액은 어떻게 됩니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:20%;" />
									<col style="width:50%;" />
									<col style="width:30%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>구분</th>
										<th>조사대상 원사업자가 요청한 기술자료 명칭</th>
										<th>손해발생액</th>
									</tr>
									<tr>
										<th>1</th>
										<td>
											<input type="text" name="q2_25_31" value="<%=qa[25][31][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_25_34" value="<%=qa[25][34][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>백만 원
										</td>
									</tr>
									<tr>
										<th>2</th>
										<td>
											<input type="text" name="q2_25_32" value="<%=qa[25][32][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_25_35" value="<%=qa[25][35][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>백만 원
										</td>
									</tr>
									<tr>
										<th>3</th>
										<td>
											<input type="text" name="q2_25_33" value="<%=qa[25][33][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_25_36" value="<%=qa[25][36][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>백만 원
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
					<ul class="elt">
						<li class="boxcontenttitle"><span>25-9. </span> 귀사는 기술자료 임치제, 기술자료 입증제, 원본증명제 등 기술자료 등록제도에 대해 알고 있습니까?</li>
						<li class="boxcontentsubtitle">* 기술자료 등록제는 수급사업자가 보유하고 있는 기술자료를 관련법에서 정한 제3의 기관(대중소기업협력재단, 한국특허정보원)에 등록하면 법적 분쟁시 동 기술자료를 수급사업자가 보유하고있음을 인증해 주는 제도를 말함. 현재 대중소기업협력재단에서 운용하는 기술자료 임치제, 기술자료 입증제와 한국특허정보원에서 운용하는 원본증명제 등이 있음.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_25_9" value="<%=setHiddenValue(qa, 25, 9, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_25_9" value="1" <%if(qa[25][9][1]!=null && qa[25][9][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,9);"></input> 가. 들어본 적 없음</li>
						<li><input type="radio" name="q2_25_9" value="2" <%if(qa[25][9][2]!=null && qa[25][9][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,9);"></input> 나. 들어본 적은 있지만 내용을 전혀 모름</li>
						<li><input type="radio" name="q2_25_9" value="3" <%if(qa[25][9][3]!=null && qa[25][9][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,9);"></input> 다. 내용을 대략적으로 알고 있음</li>
						<li><input type="radio" name="q2_25_9" value="4" <%if(qa[25][9][4]!=null && qa[25][9][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,9);"></input> 라. 내용을 구체적으로 알고 있음</li>
						<li><input type="radio" name="q2_25_9" value="5" <%if(qa[25][9][5]!=null && qa[25][9][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,9);"></input> 마. 내용을 완벽히 알고 있음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<h2 class="contenttitle">하도급거래 세부사항 3 : 안전관리·경영간섭</h2>
			
			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha16">26. 안전관리비 부담</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>26-1. </span> <%= st_Current_Year_n-1%>년도에 귀사가 조사대상 원사업자로부터 위탁받은 공사 기간 중 "원사업자가 수행해야 할" 사업장 안전관리업무 중의 일부를 귀사가 직접 수행한 사실이 있었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_26_1" value="<%=setHiddenValue(qa, 26, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_26_1" value="1" <%if(qa[26][1][1]!=null && qa[26][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(26,1);"></input> 가. 있다</li>
						<li><input type="radio" name="q2_26_1" value="2" <%if(qa[26][1][2]!=null && qa[26][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(26,1);"></input> 나. 없다<span class="boxcontentsubtitle">27-1번 문항으로 이동</span></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>26-2. </span> 귀사는 사업장 안전관리 수행으로 발생된 비용을 어떻게 부담하였나요?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_26_2" value="<%=setHiddenValue(qa, 26, 2, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_26_2" value="1" <%if(qa[26][2][1]!=null && qa[26][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(26,2);"></input> 가. 귀사가 부담</li>
						<li><input type="radio" name="q2_26_2" value="2" <%if(qa[26][2][2]!=null && qa[26][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(26,2);"></input> 나. 원사업자가 부담<span class="boxcontentsubtitle">27-1번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_26_2" value="3" <%if(qa[26][2][3]!=null && qa[26][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(26,2);"></input> 다. 귀사와 원사업자가 공정하게 부담</li>
						<li><input type="radio" name="q2_26_2" value="4" <%if(qa[26][2][4]!=null && qa[26][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(26,2);"></input> 라. 같이 부담하였으나 불공정함</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>26-3. </span> 귀사가 안전관리비용을 부담하였다면, 조사대상 원사업자가 귀사에게 부담분에 해당하는 비용을 지급하였나요?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_26_3" value="<%=setHiddenValue(qa, 26, 3, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_26_3" value="1" <%if(qa[26][3][1]!=null && qa[26][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(26,3);"></input> 가. 지급하였음<span class="boxcontentsubtitle">27-1번 문항으로 이동</span></li>
						<li><input type="radio" name="q2_26_3" value="2" <%if(qa[26][3][2]!=null && qa[26][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(26,3);"></input> 나. 지급하지 않음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>26-4. </span> 조사대상 원사업자가 안전관리 비용을 지급하지 아니하였다면, 그 사유는 무엇인가요?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_26_4" value="<%=setHiddenValue(qa, 26, 4, 3)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_26_4" value="1" <%if(qa[26][4][1]!=null && qa[26][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(26,4);"></input> 가. 원사업자가 안전관리비 부담 약정을 불이행함</li>
						<li><input type="radio" name="q2_26_4" value="2" <%if(qa[26][4][2]!=null && qa[26][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(26,4);"></input> 나. 귀사가 부담한다는 계약조건을 체결함</li>
						<li><input type="radio" name="q2_26_4" value="3" <%if(qa[26][4][3]!=null && qa[26][4][3].equals("1")){out.print("checked");}%> onclick="checkradio(26,4);"></input> 다. 기타(<input type="text" name="q2_26_11" value="<%=qa[26][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha17">27. 조사대상 원사업자의 경영간섭</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>27-1. </span> <%= st_Current_Year_n-1%>년도에 조사대상 원사업자가 귀사에게 정당한 사유 없이 아래의 경영간섭 행위를 한 경우가 있었습니까?</li>
						<li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_27_1_1" value="1" <%if(qa[27][1][1]!=null && qa[27][1][1].equals("1")){out.print("checked");}%>></input> 가. 특정 사업자와만 거래하도록 구속</li>
						<li><input type="checkbox" name="q2_27_1_2" value="1" <%if(qa[27][1][2]!=null && qa[27][1][2].equals("1")){out.print("checked");}%>></input> 나. 귀사의 임직원 선임·해임에 원사업자가 관여</li>
						<li><input type="checkbox" name="q2_27_1_3" value="1" <%if(qa[27][1][3]!=null && qa[27][1][3].equals("1")){out.print("checked");}%>></input> 다. 귀사의 생산품목·수량 등을 조절</li>
						<li><input type="checkbox" name="q2_27_1_4" value="1" <%if(qa[27][1][4]!=null && qa[27][1][4].equals("1")){out.print("checked");}%>></input> 라. 귀사의 경영상 정보를 요구</li>
						<li><input type="checkbox" name="q2_27_1_5" value="1" <%if(qa[27][1][5]!=null && qa[27][1][5].equals("1")){out.print("checked");}%>></input> 마. 귀사 기술자료의 해외 수출에 관여</li>
						<li><input type="checkbox" name="q2_27_1_6" value="1" <%if(qa[27][1][6]!=null && qa[27][1][6].equals("1")){out.print("checked");}%>></input> 바. 기타 (<input type="text" name="q2_27_19" value="<%=qa[27][19][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>27-2. </span> <%= st_Current_Year_n-1%>년도에 조사대상 원사업자가 귀사에게 경영상의 정보를 요구했다면, 요청한 경영정보와 요구 목적은 무엇입니까?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:10%;" />
									<col style="width:50%;" />
									<col style="width:40%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>구분</th>
										<th>조사대상 원사업자가 요청한 경영정보 명칭</th>
										<th>조사대상 원사업자의 요구 목적</th>
									</tr>
									<tr>
										<th>예시</th>
										<td>A제품 관련 세부원가내역서</td>
										<td>단가 인하에 활용</td>
									</tr>
									<tr>
										<th>1</th>
										<td>
											<input type="text" name="q2_27_11" value="<%=qa[27][11][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_27_14" value="<%=qa[27][14][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>2</th>
										<td>
											<input type="text" name="q2_27_12" value="<%=qa[27][12][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_27_15" value="<%=qa[27][15][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>3</th>
										<td>
											<input type="text" name="q2_27_13" value="<%=qa[27][13][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_27_16" value="<%=qa[27][16][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
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
			
			<h2 class="contenttitle">하도급거래 세부사항 4 : 전속거래</h2>
			
			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha18">28. 전속거래</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>28-1. </span> 귀사는 <%= st_Current_Year_n-1%>년에 조사대상 원사업자와 하도급 전속거래를 맺은 적이 있습니까?</li>
						<li class="boxcontentsubtitle">* 전속거래란 수급사업자로 하여금 원사업자인 '자기' 또는 '자기가 지정하는 사업자'와만 거래하도록 하는 것을 의미함.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_28_1" value="<%=setHiddenValue(qa, 28, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_28_1" value="1" <%if(qa[28][1][1]!=null && qa[28][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(28,1);"></input> 가. 있다</li>
						<li><input type="radio" name="q2_28_1" value="2" <%if(qa[28][1][2]!=null && qa[28][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(28,1);"></input> 나. 없다<span class="boxcontentsubtitle">29-1번 문항으로 이동</span></li>
					</ul>
					<div class="fc pt_50"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>28-2. </span> <%= st_Current_Year_n-1%>년도 귀사의 매출액에서 조사대상 원사업자와의 하도급 전속거래로 발생한 매출액은 얼마입니까?</li>
						<li class="boxcontentsubtitle"></li>
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
									<tr>
										<th>구분</th>
										<th>위 원 사업자와의 하도급 전속거래 매출액</th>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-1%>년도</th>
										<td><input type="text" name="q2_28_2" value="<%=qa[28][2][20]%>" onKeyUp="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 백만원</td>
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
					<ul class="elt">
						<li class="boxcontenttitle"><span>28-3. </span> <%= st_Current_Year_n-1%>년도에 귀사가 하도급 전속거래를 체결한 전체 업체 수, 매출액, 평균 거래 지속기간은 어떻게 됩니까? 조사대상 원사업자를 포함하여 전체 원사업자들과 체결한 전속거래를 대상으로 응답하여 주십시오.</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:60%;" />
									<col style="width:40%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>구분</th>
										<th>내용</th>
									</tr>
									<tr>
										<th>전속거래 업체 수</th>
										<td><input type="text" name="q2_28_11" value="<%=qa[28][11][20]%>" onKeyUp="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>전속거래를 통한 매출액</th>
										<td><input type="text" name="q2_28_12" value="<%=qa[28][12][20]%>" onKeyUp="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>평균 전속거래 기간</th>
										<td><input type="text" name="q2_28_13" value="<%=qa[28][13][20]%>" onKeyUp="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 개월</td>
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
					<ul class="elt">
						<li class="boxcontenttitle"><span>28-4. </span> 귀사는 어떠한 경로를 통해 조사대상 원사업자와 전속거래를 하게 되었습니까?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_28_4" value="<%=setHiddenValue(qa, 28, 4, 7)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_28_4" value="1" <%if(qa[28][4][1]!=null && qa[28][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(28,4);"></input> 가. 원사업자와의 협의를 통해 계약체결</li>
						<li><input type="radio" name="q2_28_4" value="1" <%if(qa[28][4][2]!=null && qa[28][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(28,4);"></input> 나. 원사업자의 전속거래 요구에 의해 계약체결</li>
						<li><input type="radio" name="q2_28_4" value="1" <%if(qa[28][4][3]!=null && qa[28][4][3].equals("1")){out.print("checked");}%> onclick="checkradio(28,4);"></input> 다. 원사업자에서 임원 영입을 통해 계약체결</li>
						<li><input type="radio" name="q2_28_4" value="1" <%if(qa[28][4][4]!=null && qa[28][4][4].equals("1")){out.print("checked");}%> onclick="checkradio(28,4);"></input> 라. 공동기술개발을 통해 계약체결</li>
						<li><input type="radio" name="q2_28_4" value="1" <%if(qa[28][4][5]!=null && qa[28][4][5].equals("1")){out.print("checked");}%> onclick="checkradio(28,4);"></input> 마. 공개경쟁입찰에 참여한 후 계약체결</li>
						<li><input type="radio" name="q2_28_4" value="1" <%if(qa[28][4][6]!=null && qa[28][4][6].equals("1")){out.print("checked");}%> onclick="checkradio(28,4);"></input> 바. 귀사는 원사업자와 분리되어 설립된 계열사로 그러한 특수관계에 의해 계약체결</li>
						<li><input type="radio" name="q2_28_4" value="1" <%if(qa[28][4][7]!=null && qa[28][4][7].equals("1")){out.print("checked");}%> onclick="checkradio(28,4);"></input> 사. 기타(<input type="text" name="q2_28_14" value="<%=qa[28][14][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
					<div class="fc pt_50"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>28-5. </span> 귀사가 조사대상 원사업자와의 전속거래를 통하여 달성(개선)하게 된 것은 무엇입니까?</li>
						<li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_28_5_1" value="1" <%if(qa[28][5][1]!=null && qa[28][5][1].equals("1")){out.print("checked");}%>></input> 가. 품질향상</li>
						<li><input type="checkbox" name="q2_28_5_2" value="1" <%if(qa[28][5][2]!=null && qa[28][5][2].equals("1")){out.print("checked");}%>></input> 나. R&D 등 비용 절감</li>
						<li><input type="checkbox" name="q2_28_5_3" value="1" <%if(qa[28][5][3]!=null && qa[28][5][3].equals("1")){out.print("checked");}%>></input> 다. 기술개선</li>
						<li><input type="checkbox" name="q2_28_5_4" value="1" <%if(qa[28][5][4]!=null && qa[28][5][4].equals("1")){out.print("checked");}%>></input> 라. 안정적 수요처 확보</li>
						<li><input type="checkbox" name="q2_28_5_5" value="1" <%if(qa[28][5][5]!=null && qa[28][5][5].equals("1")){out.print("checked");}%>></input> 마. 기타(<input type="text" name="q2_28_15" value="<%=qa[28][15][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>28-6. </span> 조사대상 원사업자와의 전속거래 이후, 귀사의 거래여건이 악화된 경우가 있다면, 아래 중 어느 사항에 해당합니까?</li>
						<li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_28_6_1" value="1" <%if(qa[28][6][1]!=null && qa[28][6][1].equals("1")){out.print("checked");}%>></input> 가. 단가 인하에 따른 수익성 악화</li>
						<li><input type="checkbox" name="q2_28_6_2" value="1" <%if(qa[28][6][2]!=null && qa[28][6][2].equals("1")){out.print("checked");}%>></input> 나. 일방적인 물량 취소 및 변경으로 매출감소</li>
						<li><input type="checkbox" name="q2_28_6_3" value="1" <%if(qa[28][6][3]!=null && qa[28][6][3].equals("1")){out.print("checked");}%>></input> 다. 귀사의 공급선 또는 기술협력 확대 제약</li>
						<li><input type="checkbox" name="q2_28_6_4" value="1" <%if(qa[28][6][4]!=null && qa[28][6][4].equals("1")){out.print("checked");}%>></input> 라. 기술 정보의 유출</li>
						<li><input type="checkbox" name="q2_28_6_5" value="1" <%if(qa[28][6][5]!=null && qa[28][6][5].equals("1")){out.print("checked");}%>></input> 마. 특정업체의 원·부자재 구매 요구</li>
						<li><input type="checkbox" name="q2_28_6_6" value="1" <%if(qa[28][6][6]!=null && qa[28][6][6].equals("1")){out.print("checked");}%>></input> 바. 하도급대금 지급 지연</li>
						<li><input type="checkbox" name="q2_28_6_7" value="1" <%if(qa[28][6][7]!=null && qa[28][6][7].equals("1")){out.print("checked");}%>></input> 사. 무리한 품질 수준 요구 및 부당한 반품</li>
						<li><input type="checkbox" name="q2_28_6_8" value="1" <%if(qa[28][6][8]!=null && qa[28][6][8].equals("1")){out.print("checked");}%>></input> 아. 일방적인 납기일 단축 요구 및 물품수령 거부</li>
						<li><input type="checkbox" name="q2_28_6_9" value="1" <%if(qa[28][6][9]!=null && qa[28][6][9].equals("1")){out.print("checked");}%>></input> 자. 기타 (<input type="text" name="q2_28_16" value="<%=qa[28][16][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="checkbox" name="q2_28_6_10" value="1" <%if(qa[28][6][10]!=null && qa[28][6][10].equals("1")){out.print("checked");}%>></input> 차. 해당사항 없음</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<h2 class="contenttitle">만족도 조사</h2>
			
			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha19">29. 하도급 거래와 하도급 정책에 대한 귀사의 만족도 조사</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>29-1. </span> 귀사는 조사대상 원사업자와의 하도급거래 전반과 세부항목에 대하여 어느 정도 만족하고 있습니까?</li>
						<li class="boxcontentsubtitle"></li>

					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:30%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>세부항목</th>
										<th>매우 만족</th>
										<th>만족</th>
										<th>약간 만족</th>
										<th>보통</th>
										<th>약간 불만족</th>
										<th>불만족</th>
										<th>매우 불만족</th>
									</tr>
									<tr>
										<th style="text-align: left;">거래 전반에 대한 만족도</th>
										<td>
											<input type="hidden" name="c2_29_1" value="<%=setHiddenValue(qa, 29, 1, 7)%>"></input>
											<input type="radio" name="q2_29_1" value="1" <%if(qa[29][1][1]!=null && qa[29][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,1);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_1" value="2" <%if(qa[29][1][2]!=null && qa[29][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,1);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_1" value="3" <%if(qa[29][1][3]!=null && qa[29][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,1);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_1" value="4" <%if(qa[29][1][4]!=null && qa[29][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,1);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_1" value="5" <%if(qa[29][1][5]!=null && qa[29][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,1);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_1" value="6" <%if(qa[29][1][6]!=null && qa[29][1][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,1);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_1" value="7" <%if(qa[29][1][7]!=null && qa[29][1][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,1);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">1) 업체 선정 방식</th>
										<td>
											<input type="hidden" name="c2_29_2" value="<%=setHiddenValue(qa, 29, 2, 7)%>"></input>
											<input type="radio" name="q2_29_2" value="1" <%if(qa[29][2][1]!=null && qa[29][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,2);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_2" value="2" <%if(qa[29][2][2]!=null && qa[29][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,2);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_2" value="3" <%if(qa[29][2][3]!=null && qa[29][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,2);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_2" value="4" <%if(qa[29][2][4]!=null && qa[29][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,2);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_2" value="5" <%if(qa[29][2][5]!=null && qa[29][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,2);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_2" value="6" <%if(qa[29][2][6]!=null && qa[29][2][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,2);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_2" value="7" <%if(qa[29][2][7]!=null && qa[29][2][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,2);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">2) 계약 체결 과정</th>
										<td>
											<input type="hidden" name="c2_29_3" value="<%=setHiddenValue(qa, 29, 3, 7)%>"></input>
											<input type="radio" name="q2_29_3" value="1" <%if(qa[29][3][1]!=null && qa[29][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,3);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_3" value="2" <%if(qa[29][3][2]!=null && qa[29][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,3);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_3" value="3" <%if(qa[29][3][3]!=null && qa[29][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,3);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_3" value="4" <%if(qa[29][3][4]!=null && qa[29][3][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,3);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_3" value="5" <%if(qa[29][3][5]!=null && qa[29][3][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,3);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_3" value="6" <%if(qa[29][3][6]!=null && qa[29][3][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,3);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_3" value="7" <%if(qa[29][3][7]!=null && qa[29][3][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,3);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">3) 거래 단가 결정</th>
										<td>
											<input type="hidden" name="c2_29_4" value="<%=setHiddenValue(qa, 29, 4, 7)%>"></input>
											<input type="radio" name="q2_29_4" value="1" <%if(qa[29][4][1]!=null && qa[29][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,4);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_4" value="2" <%if(qa[29][4][2]!=null && qa[29][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,4);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_4" value="3" <%if(qa[29][4][3]!=null && qa[29][4][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,4);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_4" value="4" <%if(qa[29][4][4]!=null && qa[29][4][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,4);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_4" value="5" <%if(qa[29][4][5]!=null && qa[29][4][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,4);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_4" value="6" <%if(qa[29][4][6]!=null && qa[29][4][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,4);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_4" value="7" <%if(qa[29][4][7]!=null && qa[29][4][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,4);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">4) 위탁 취소 및 변경 절차</th>
										<td>
											<input type="hidden" name="c2_29_5" value="<%=setHiddenValue(qa, 29, 5, 7)%>"></input>
											<input type="radio" name="q2_29_5" value="1" <%if(qa[29][5][1]!=null && qa[29][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,5);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_5" value="2" <%if(qa[29][5][2]!=null && qa[29][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,5);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_5" value="3" <%if(qa[29][5][3]!=null && qa[29][5][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,5);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_5" value="4" <%if(qa[29][5][4]!=null && qa[29][5][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,5);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_5" value="5" <%if(qa[29][5][5]!=null && qa[29][5][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,5);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_5" value="6" <%if(qa[29][5][6]!=null && qa[29][5][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,5);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_5" value="7" <%if(qa[29][5][7]!=null && qa[29][5][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,5);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">5) 물품 수령 과정</th>
										<td>
											<input type="hidden" name="c2_29_6" value="<%=setHiddenValue(qa, 29, 6, 7)%>"></input>
											<input type="radio" name="q2_29_6" value="1" <%if(qa[29][6][1]!=null && qa[29][6][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,6);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_6" value="2" <%if(qa[29][6][2]!=null && qa[29][6][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,6);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_6" value="3" <%if(qa[29][6][3]!=null && qa[29][6][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,6);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_6" value="4" <%if(qa[29][6][4]!=null && qa[29][6][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,6);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_6" value="5" <%if(qa[29][6][5]!=null && qa[29][6][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,6);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_6" value="6" <%if(qa[29][6][6]!=null && qa[29][6][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,6);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_6" value="7" <%if(qa[29][6][7]!=null && qa[29][6][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,6);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">6) 계약 후 단가조정</th>
										<td>
											<input type="hidden" name="c2_29_7" value="<%=setHiddenValue(qa, 29, 7, 7)%>"></input>
											<input type="radio" name="q2_29_7" value="1" <%if(qa[29][7][1]!=null && qa[29][7][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,7);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_7" value="2" <%if(qa[29][7][2]!=null && qa[29][7][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,7);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_7" value="3" <%if(qa[29][7][3]!=null && qa[29][7][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,7);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_7" value="4" <%if(qa[29][7][4]!=null && qa[29][7][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,7);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_7" value="5" <%if(qa[29][7][5]!=null && qa[29][7][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,7);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_7" value="6" <%if(qa[29][7][6]!=null && qa[29][7][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,7);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_7" value="7" <%if(qa[29][7][7]!=null && qa[29][7][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,7);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">7) 하도급대금 수령</th>
										<td>
											<input type="hidden" name="c2_29_8" value="<%=setHiddenValue(qa, 29, 8, 7)%>"></input>
											<input type="radio" name="q2_29_8" value="1" <%if(qa[29][8][1]!=null && qa[29][8][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,8);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_8" value="2" <%if(qa[29][8][2]!=null && qa[29][8][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,8);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_8" value="3" <%if(qa[29][8][3]!=null && qa[29][8][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,8);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_8" value="4" <%if(qa[29][8][4]!=null && qa[29][8][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,8);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_8" value="5" <%if(qa[29][8][5]!=null && qa[29][8][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,8);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_8" value="6" <%if(qa[29][8][6]!=null && qa[29][8][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,8);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_8" value="7" <%if(qa[29][8][7]!=null && qa[29][8][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,8);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">8) 원사업자와의 협력관계</th>
										<td>
											<input type="hidden" name="c2_29_9" value="<%=setHiddenValue(qa, 29, 9, 7)%>"></input>
											<input type="radio" name="q2_29_9" value="1" <%if(qa[29][9][1]!=null && qa[29][9][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,9);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_9" value="2" <%if(qa[29][9][2]!=null && qa[29][9][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,9);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_9" value="3" <%if(qa[29][9][3]!=null && qa[29][9][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,9);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_9" value="4" <%if(qa[29][9][4]!=null && qa[29][9][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,9);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_9" value="5" <%if(qa[29][9][5]!=null && qa[29][9][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,9);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_9" value="6" <%if(qa[29][9][6]!=null && qa[29][9][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,9);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_9" value="7" <%if(qa[29][9][7]!=null && qa[29][9][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,9);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">9) 원사업자의 경영간섭</th>
										<td>
											<input type="hidden" name="c2_29_10" value="<%=setHiddenValue(qa, 29, 10, 7)%>"></input>
											<input type="radio" name="q2_29_10" value="1" <%if(qa[29][10][1]!=null && qa[29][10][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,10);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_10" value="2" <%if(qa[29][10][2]!=null && qa[29][10][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,10);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_10" value="3" <%if(qa[29][10][3]!=null && qa[29][10][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,10);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_10" value="4" <%if(qa[29][10][4]!=null && qa[29][10][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,10);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_10" value="5" <%if(qa[29][10][5]!=null && qa[29][10][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,10);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_10" value="6" <%if(qa[29][10][6]!=null && qa[29][10][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,10);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_10" value="7" <%if(qa[29][10][7]!=null && qa[29][10][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,10);"></input>
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
					<ul class="elt">
						<li class="boxcontenttitle"><span>29-2. </span> 귀사는 공정거래위원회가 수행하고 있는 하도급 관련 정책에 어느 정도 만족하고 있습니까?</li>
						<li class="boxcontentsubtitle"></li>

					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:30%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>정책</th>
										<th>매우 만족</th>
										<th>만족</th>
										<th>약간 만족</th>
										<th>보통</th>
										<th>약간 불만족</th>
										<th>불만족</th>
										<th>매우 불만족</th>
									</tr>
									<tr>
										<th style="text-align: left;">정책 전반에 대한 만족도</th>
										<td>
											<input type="hidden" name="c2_29_11" value="<%=setHiddenValue(qa, 29, 11, 7)%>"></input>
											<input type="radio" name="q2_29_11" value="1" <%if(qa[29][11][1]!=null && qa[29][11][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,11);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_11" value="2" <%if(qa[29][11][2]!=null && qa[29][11][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,11);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_11" value="3" <%if(qa[29][11][3]!=null && qa[29][11][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,11);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_11" value="4" <%if(qa[29][11][4]!=null && qa[29][11][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,11);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_11" value="5" <%if(qa[29][11][5]!=null && qa[29][11][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,11);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_11" value="6" <%if(qa[29][11][6]!=null && qa[29][11][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,11);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_11" value="7" <%if(qa[29][11][7]!=null && qa[29][11][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,11);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">1) 하도급 법제개선</th>
										<td>
											<input type="hidden" name="c2_29_12" value="<%=setHiddenValue(qa, 29, 12, 7)%>"></input>
											<input type="radio" name="q2_29_12" value="1" <%if(qa[29][12][1]!=null && qa[29][12][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,12);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_12" value="2" <%if(qa[29][12][2]!=null && qa[29][12][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,12);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_12" value="3" <%if(qa[29][12][3]!=null && qa[29][12][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,12);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_12" value="4" <%if(qa[29][12][4]!=null && qa[29][12][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,12);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_12" value="5" <%if(qa[29][12][5]!=null && qa[29][12][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,12);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_12" value="6" <%if(qa[29][12][6]!=null && qa[29][12][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,12);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_12" value="7" <%if(qa[29][12][7]!=null && qa[29][12][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,12);"></input>
										</td>
									</tr>
									
									<tr>
										<th style="text-align: left;">2) 공정거래 및 동반성장 협약 확산</th>
										<td>
											<input type="hidden" name="c2_29_14" value="<%=setHiddenValue(qa, 29, 14, 7)%>"></input>
											<input type="radio" name="q2_29_14" value="1" <%if(qa[29][14][1]!=null && qa[29][14][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,14);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_14" value="2" <%if(qa[29][14][2]!=null && qa[29][14][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,14);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_14" value="3" <%if(qa[29][14][3]!=null && qa[29][14][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,14);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_14" value="4" <%if(qa[29][14][4]!=null && qa[29][14][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,14);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_14" value="5" <%if(qa[29][14][5]!=null && qa[29][14][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,14);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_14" value="6" <%if(qa[29][14][6]!=null && qa[29][14][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,14);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_14" value="7" <%if(qa[29][14][7]!=null && qa[29][14][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,14);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">3) 현장 직권조사 강화</th>
										<td>
											<input type="hidden" name="c2_29_15" value="<%=setHiddenValue(qa, 29, 15, 7)%>"></input>
											<input type="radio" name="q2_29_15" value="1" <%if(qa[29][15][1]!=null && qa[29][15][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,15);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_15" value="2" <%if(qa[29][15][2]!=null && qa[29][15][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,15);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_15" value="3" <%if(qa[29][15][3]!=null && qa[29][15][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,15);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_15" value="4" <%if(qa[29][15][4]!=null && qa[29][15][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,15);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_15" value="5" <%if(qa[29][15][5]!=null && qa[29][15][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,15);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_15" value="6" <%if(qa[29][15][6]!=null && qa[29][15][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,15);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_15" value="7" <%if(qa[29][15][7]!=null && qa[29][15][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,15);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">4) 불공정 하도급 신고센터 운영</th>
										<td>
											<input type="hidden" name="c2_29_16" value="<%=setHiddenValue(qa, 29, 16, 7)%>"></input>
											<input type="radio" name="q2_29_16" value="1" <%if(qa[29][16][1]!=null && qa[29][16][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,16);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_16" value="2" <%if(qa[29][16][2]!=null && qa[29][16][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,16);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_16" value="3" <%if(qa[29][16][3]!=null && qa[29][16][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,16);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_16" value="4" <%if(qa[29][16][4]!=null && qa[29][16][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,16);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_16" value="5" <%if(qa[29][16][5]!=null && qa[29][16][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,16);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_16" value="6" <%if(qa[29][16][6]!=null && qa[29][16][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,16);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_16" value="7" <%if(qa[29][16][7]!=null && qa[29][16][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,16);"></input>
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
					<ul class="elt">
						<li class="boxcontenttitle"><span>29-3. </span> 귀사가 <%= st_Current_Year_n-1%>년에 경험한 하도급거래는 불공정성 측면에서 <%= st_Current_Year_n-2%>년에 비하여 어느 정도 개선되었다고 생각하십니까?</li>
						<li class="boxcontentsubtitle">* 10)부당한 경영간섭과 11)보복조치 항목은 시스템 문제로 인하여 매우개선(1) 개선(2) ~ 미미(6) 매우미미(7) 의 순번을 숫자로 입력해주세요</li>

					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:30%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>세부항목</th>
										<th>매우 개선</th>
										<th>개선</th>
										<th>약간 개선</th>
										<th>보통</th>
										<th>약간 미미</th>
										<th>미미</th>
										<th>매우 미미</th>
									</tr>
									<tr>
										<th style="text-align: left;">불공정 거래의 전반적인 개선도</th>
										<td>
											<input type="hidden" name="c2_29_17" value="<%=setHiddenValue(qa, 29, 17, 7)%>"></input>
											<input type="radio" name="q2_29_17" value="1" <%if(qa[29][17][1]!=null && qa[29][17][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,17);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_17" value="2" <%if(qa[29][17][2]!=null && qa[29][17][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,17);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_17" value="3" <%if(qa[29][17][3]!=null && qa[29][17][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,17);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_17" value="4" <%if(qa[29][17][4]!=null && qa[29][17][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,17);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_17" value="5" <%if(qa[29][17][5]!=null && qa[29][17][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,17);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_17" value="6" <%if(qa[29][17][6]!=null && qa[29][17][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,17);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_17" value="7" <%if(qa[29][17][7]!=null && qa[29][17][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,17);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">1) 서류 미발급 및 미보전</th>
										<td>
											<input type="hidden" name="c2_29_18" value="<%=setHiddenValue(qa, 29, 18, 7)%>"></input>
											<input type="radio" name="q2_29_18" value="1" <%if(qa[29][18][1]!=null && qa[29][18][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,18);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_18" value="2" <%if(qa[29][18][2]!=null && qa[29][18][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,18);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_18" value="3" <%if(qa[29][18][3]!=null && qa[29][18][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,18);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_18" value="4" <%if(qa[29][18][4]!=null && qa[29][18][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,18);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_18" value="5" <%if(qa[29][18][5]!=null && qa[29][18][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,18);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_18" value="6" <%if(qa[29][18][6]!=null && qa[29][18][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,18);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_18" value="7" <%if(qa[29][18][7]!=null && qa[29][18][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,18);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">2) 부당한 특약</th>
										<td>
											<input type="hidden" name="c2_29_19" value="<%=setHiddenValue(qa, 29, 19, 7)%>"></input>
											<input type="radio" name="q2_29_19" value="1" <%if(qa[29][19][1]!=null && qa[29][19][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,19);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_19" value="2" <%if(qa[29][19][2]!=null && qa[29][19][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,19);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_19" value="3" <%if(qa[29][19][3]!=null && qa[29][19][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,19);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_19" value="4" <%if(qa[29][19][4]!=null && qa[29][19][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,19);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_19" value="5" <%if(qa[29][19][5]!=null && qa[29][19][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,19);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_19" value="6" <%if(qa[29][19][6]!=null && qa[29][19][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,19);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_19" value="7" <%if(qa[29][19][7]!=null && qa[29][19][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,19);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">3) 부당한 하도급 대금 결정</th>
										<td>
											<input type="hidden" name="c2_29_20" value="<%=setHiddenValue(qa, 29, 20, 7)%>"></input>
											<input type="radio" name="q2_29_20" value="1" <%if(qa[29][20][1]!=null && qa[29][20][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,20);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_20" value="2" <%if(qa[29][20][2]!=null && qa[29][20][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,20);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_20" value="3" <%if(qa[29][20][3]!=null && qa[29][20][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,20);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_20" value="4" <%if(qa[29][20][4]!=null && qa[29][20][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,20);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_20" value="5" <%if(qa[29][20][5]!=null && qa[29][20][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,20);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_20" value="6" <%if(qa[29][20][6]!=null && qa[29][20][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,20);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_20" value="7" <%if(qa[29][20][7]!=null && qa[29][20][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,20);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">4) 부당한 위탁 취소</th>
										<td>
											<input type="hidden" name="c2_29_21" value="<%=setHiddenValue(qa, 29, 21, 7)%>"></input>
											<input type="radio" name="q2_29_21" value="1" <%if(qa[29][21][1]!=null && qa[29][21][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,21);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_21" value="2" <%if(qa[29][21][2]!=null && qa[29][21][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,21);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_21" value="3" <%if(qa[29][21][3]!=null && qa[29][21][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,21);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_21" value="4" <%if(qa[29][21][4]!=null && qa[29][21][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,21);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_21" value="5" <%if(qa[29][21][5]!=null && qa[29][21][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,21);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_21" value="6" <%if(qa[29][21][6]!=null && qa[29][21][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,21);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_21" value="7" <%if(qa[29][21][7]!=null && qa[29][21][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,21);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">5) 부당한 반품</th>
										<td>
											<input type="hidden" name="c2_29_22" value="<%=setHiddenValue(qa, 29, 22, 7)%>"></input>
											<input type="radio" name="q2_29_22" value="1" <%if(qa[29][22][1]!=null && qa[29][22][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,22);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_22" value="2" <%if(qa[29][22][2]!=null && qa[29][22][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,22);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_22" value="3" <%if(qa[29][22][3]!=null && qa[29][22][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,22);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_22" value="4" <%if(qa[29][22][4]!=null && qa[29][22][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,22);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_22" value="5" <%if(qa[29][22][5]!=null && qa[29][22][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,22);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_22" value="6" <%if(qa[29][22][6]!=null && qa[29][22][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,22);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_22" value="7" <%if(qa[29][22][7]!=null && qa[29][22][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,22);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">6) 부당한 대금 감액</th>
										<td>
											<input type="hidden" name="c2_29_23" value="<%=setHiddenValue(qa, 29, 23, 7)%>"></input>
											<input type="radio" name="q2_29_23" value="1" <%if(qa[29][23][1]!=null && qa[29][23][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,23);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_23" value="2" <%if(qa[29][23][2]!=null && qa[29][23][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,23);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_23" value="3" <%if(qa[29][23][3]!=null && qa[29][23][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,23);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_23" value="4" <%if(qa[29][23][4]!=null && qa[29][23][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,23);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_23" value="5" <%if(qa[29][23][5]!=null && qa[29][23][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,23);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_23" value="6" <%if(qa[29][23][6]!=null && qa[29][23][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,23);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_23" value="7" <%if(qa[29][23][7]!=null && qa[29][23][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,23);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">7) 부당한 경제적 이익 제공 요구</th>
										<td>
											<input type="hidden" name="c2_29_24" value="<%=setHiddenValue(qa, 29, 24, 7)%>"></input>
											<input type="radio" name="q2_29_24" value="1" <%if(qa[29][24][1]!=null && qa[29][24][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,24);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_24" value="2" <%if(qa[29][24][2]!=null && qa[29][24][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,24);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_24" value="3" <%if(qa[29][24][3]!=null && qa[29][24][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,24);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_24" value="4" <%if(qa[29][24][4]!=null && qa[29][24][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,24);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_24" value="5" <%if(qa[29][24][5]!=null && qa[29][24][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,24);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_24" value="6" <%if(qa[29][24][6]!=null && qa[29][24][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,24);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_24" value="7" <%if(qa[29][24][7]!=null && qa[29][24][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,24);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">8) 부당한 기술자료 제공 요구</th>
										<td>
											<input type="hidden" name="c2_29_25" value="<%=setHiddenValue(qa, 29, 25, 7)%>"></input>
											<input type="radio" name="q2_29_25" value="1" <%if(qa[29][25][1]!=null && qa[29][25][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,25);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_25" value="2" <%if(qa[29][25][2]!=null && qa[29][25][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,25);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_25" value="3" <%if(qa[29][25][3]!=null && qa[29][25][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,25);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_25" value="4" <%if(qa[29][25][4]!=null && qa[29][25][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,25);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_25" value="5" <%if(qa[29][25][5]!=null && qa[29][25][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,25);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_25" value="6" <%if(qa[29][25][6]!=null && qa[29][25][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,25);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_25" value="7" <%if(qa[29][25][7]!=null && qa[29][25][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,25);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">9) 부당한 대금 지급 지연</th>
										<td>
											<input type="hidden" name="c2_29_26" value="<%=setHiddenValue(qa, 29, 26, 7)%>"></input>
											<input type="radio" name="q2_29_26" value="1" <%if(qa[29][26][1]!=null && qa[29][26][1].equals("1")){out.print("checked");}%> onclick="checkradio(29,26);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_26" value="2" <%if(qa[29][26][2]!=null && qa[29][26][2].equals("1")){out.print("checked");}%> onclick="checkradio(29,26);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_26" value="3" <%if(qa[29][26][3]!=null && qa[29][26][3].equals("1")){out.print("checked");}%> onclick="checkradio(29,26);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_26" value="4" <%if(qa[29][26][4]!=null && qa[29][26][4].equals("1")){out.print("checked");}%> onclick="checkradio(29,26);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_26" value="5" <%if(qa[29][26][5]!=null && qa[29][26][5].equals("1")){out.print("checked");}%> onclick="checkradio(29,26);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_26" value="6" <%if(qa[29][26][6]!=null && qa[29][26][6].equals("1")){out.print("checked");}%> onclick="checkradio(29,26);"></input>
										</td>
										<td>
											<input type="radio" name="q2_29_26" value="7" <%if(qa[29][26][7]!=null && qa[29][26][7].equals("1")){out.print("checked");}%> onclick="checkradio(29,26);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">10) 부당한 경영 간섭</th>
										<td colspan="7">
											<input type="text" name="q2_29_27" value="<%=qa[29][27][20]%>" onKeyUp="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">11) 보복조치</th>
										<td colspan="7">
											<input type="text" name="q2_29_28" value="<%=qa[29][28][20]%>" onKeyUp="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
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
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"> 30. 하도급 정책 개선 또는 원사업자-수급사업자 간 수평적 협력관계 증진을 위하여 건의하실 사항이 있으면 자유롭게 기재하여 주시기 바랍니다.<a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontentsubtitle"><p align="right" id="content_bytes25_1"> 0/4000byte</p></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><textarea cols="80" rows="8" maxlength="600" name="q2_31_1" class="textarea01b" maxlength="600" onFocus="javascript:this.className='textarea01o';" onBlur="javascript:this.className='textarea01b';" onkeyup="byteLengCheck(this, 4000, this.name,'content_bytes25_1');"><%=qa[31][1][20]%></textarea>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_20"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="padding-left:20px;">
					<li class="boxcontenttitle"><span>*</span>다음 단계로 넘어가기 전에 하단의 <font style="font-weight:bold;">「저장」</font>버튼을 눌러 저장하시고 다음 단계를 진행하시기 바랍니다. </li>
				</ul>
			</div>

			<div class="fc pt_20"></div>

			<!-- 버튼 start -->
			<div class="fr">
				<ul class="lt">
					<!--<li class="fl pr_2"><a href="javascript:savef2()" onfocus="this.blur()" class="contentbutton2">임시저장</a></li>-->
					<li class="fl pr_2"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">저 장</a></li>
					<li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">화면 인쇄하기</a></li>
					<li class="fl pr_2"><a href="../rsch200801/WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="contentbutton2">4. 조사표 전송하기</a></li>
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
		alert("하도급 거래상황 정상적으로 저장되었습니다.")
	<%}%>
	//]]
	</script>
</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>