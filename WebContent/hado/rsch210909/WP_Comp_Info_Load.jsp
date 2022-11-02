<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 2014년 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_Comp_Info_Load.jsp
* 프로그램설명	: 회사개요_일반현황_불러오기
* 프로그램버전	: 1.0.0-2014
* 최초작성일자	: 2014년 11월 17일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-11-17	강슬기       최초작성
* 2014-11-27   정광식       관리번호,접속코드 대문자 변경 기능 추가
*/

/*====================== Variable Difinition======================*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="/Include/WB_I_Global.jsp"%>
<%@ include file="/Include/WB_I_chkSession.jsp"%>
<%@ include file="/Include/WB_I_Function.jsp"%>

<%
	ConnectionResource resource	= null;
	Connection conn	 = null;
	PreparedStatement pstmt	 = null;
	ResultSet rs = null;

	String sSQLs		= "";

	String sErrorMsg	= "";	// 오류메시지
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

	//String sconamt = "0";
	//String ssale	= "0";
	//String samt		= "0";
	//String sempcnt	= "0";
	String sreggb = "";
	String sregtext = "";
	String zipcode	= "";
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
	
	
	/* 2020년도 추가 */
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
	
	String oentgb = "";
	

	java.util.Calendar cal = java.util.Calendar.getInstance();

	String sLoadMngNo		= request.getParameter("loadmngno")==null ? "":request.getParameter("loadmngno").trim();		//불러들일 관리번호
	String sLoadConnCode	= request.getParameter("loadconncode")==null ? "":request.getParameter("loadconncode").trim();	//불러들일 접속코드

	boolean bCheckMngNo = false;	//관리번호, 접속코드가 일치하지 않는다는 전제 하에 시작(맞을 경우 true)

	/*=========================================================*/
if(!ckMngNo.equals("")) {	//로그인 일때만 실행

	//불러들일 관리번호를 DB에서 SELECT한다
	if ( !sLoadMngNo.equals("") && !sLoadConnCode.equals("") ) {
		/*
			입력된 관리번호 및 접속코드를 일괄 대문자 변환
			2014-11-27 / 정광식 기능 추가
		*/
		if ( !sLoadMngNo.equals("") ) 	sLoadMngNo = sLoadMngNo.toUpperCase();
		if ( !sLoadConnCode.equals("") ) sLoadConnCode = sLoadConnCode.toUpperCase();

		/* 관리번호, 접속코드 검증 */
		try {
			resource= new ConnectionResource();
			conn	= resource.getConnection();

			sSQLs = "SELECT mng_no \n";
			sSQLs+="FROM hado_tb_security_" +ckCurrentYear+ " \n";
			sSQLs+="WHERE mng_no= ? AND SUBSTR(conn_code,-4)= ? AND ent_gb= ? \n";
			pstmt = conn.prepareStatement(sSQLs);
			pstmt.setString(1, sLoadMngNo);
			pstmt.setString(2, sLoadConnCode);
			pstmt.setString(3, ckEntGB);
			rs = pstmt.executeQuery();

			if( rs.next() ) {
				bCheckMngNo = true;
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

		if( bCheckMngNo ) {	// 관리번호, 접속코드가 일치할때만 실행
			try {
				resource= new ConnectionResource();
				conn	= resource.getConnection();

				sSQLs   = "SELECT * \n";
				sSQLs+= "FROM hado_tb_subcon_" +ckCurrentYear+ " \n";
				sSQLs+= "WHERE child_mng_no = ? AND current_year = ? \n";
				pstmt = conn.prepareStatement(sSQLs);
				pstmt.setString(1, sLoadMngNo);
				pstmt.setString(2, ckCurrentYear);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					oentgb = rs.getString("OENT_GB")==null ? "": rs.getString("OENT_GB");
					sname = rs.getString("Sent_Name")==null ? "": rs.getString("Sent_Name");
					scaptine	= rs.getString("Sent_Captine")==null ? "": rs.getString("Sent_Captine");
					//ssale = rs.getString("Sent_Sale")==null ? "":  rs.getString("Sent_Sale");
					//samt = rs.getString("Sent_Amt")==null ? "": rs.getString("Sent_Amt");
					//sconamt = rs.getString("Sent_Con_Amt")==null ? "":  rs.getString("Sent_Con_Amt");
					zipcode = rs.getString("Zip_Code")==null ? "": rs.getString("Zip_Code");
					address = rs.getString("Sent_Address")==null ? "": rs.getString("Sent_Address");
					semail = rs.getString("Assign_Mail")==null ? "": rs.getString("Assign_Mail");
					if ( semail.indexOf("@") != -1 ) {
						semail1	= semail.substring(0, semail.indexOf("@"));
						semail2	= semail.substring(semail.indexOf("@")+1, semail.length());
					}
					scompgb = rs.getString("Comp_GB")==null ? "":  rs.getString("Comp_GB");
					scono = rs.getString("Sent_Co_No")==null ? "":  rs.getString("Sent_Co_No");
					if( scono.length() == 14 ) {
						scono1	= scono.substring(0,6);
						scono2	= scono.substring(7,14);
					}
					ssano		= rs.getString("Sent_Sa_No")==null ? "":  rs.getString("Sent_Sa_No");
					if( ssano.length() == 12) {
						ssano1	= ssano.substring(0,3);
						ssano2	= ssano.substring(4,6);
						ssano3	= ssano.substring(7,12);
					}
					//sempcnt	= rs.getString("Sent_Emp_Cnt")==null ? "":  rs.getString("Sent_Emp_Cnt");
					sreggb = rs.getString("Con_Reg_GB")==null ? "":  rs.getString("Con_Reg_GB");
					sregtext = rs.getString("Con_Reg_Text")==null ? "":  rs.getString("Con_Reg_Text");
					wname = rs.getString("Writer_Name")==null ? "":  rs.getString("Writer_Name");
					worg = rs.getString("Writer_ORG")==null ? "":  rs.getString("Writer_ORG");
					wjikwi	 = rs.getString("Writer_Jikwi")==null ? "":  rs.getString("Writer_Jikwi");
					wtel = rs.getString("Writer_Tel")==null ? "":  rs.getString("Writer_Tel");
					wfax = rs.getString("Writer_Fax")==null ? "":  rs.getString("Writer_Fax");
					wdate	 = rs.getString("Writer_Date")==null ? "":  rs.getString("Writer_Date");
					
					/* 2020년 추가 */
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
		}	else { // 관리번호, 접속코드가 일치할때만 실행 끝
			sErrorMsg = "일치하는 정보를 찾을 수 없습니다. 관리번호 또는 접속코드를 확인해 주세요.";
		}
	}
} else { // 로그인 세션이 없는 경우
	sErrorMsg = "로그인 정보가 소멸되었거나, 정상적인 접근이 아닙니다. 작업이 취소되었습니다.";
}
%>

<html>
<head>
	<title>수급사업자 일반현황 가져오기</title>
	<script type="text/javascript">
		var sErrorMsg = "<%=sErrorMsg%>";

		if( sErrorMsg!="") {
			alert(sErrorMsg);
		} else {
		    
			parent.document.info.rcomp.value =  "<%=sname%>";
			parent.document.info.rcogb.value = "<%=scompgb%>";
			parent.document.info.rlawno1.value = "<%=scono1%>";
			parent.document.info.rlawno2.value = "<%=scono2%>";
			parent.document.info.rincorp1.value = "<%=sIncorp1%>";
			parent.document.info.rincorp2.value = "<%=sIncorp2%>";
			parent.document.info.rregno1.value = "<%=ssano1%>";
			parent.document.info.rregno2.value = "<%=ssano2%>";
			parent.document.info.rregno3.value = "<%=ssano3%>";
			parent.document.info.rowner.value = "<%=scaptine%>";
			parent.document.info.rpost.value = "<%=zipcode%>";
			parent.document.info.raddr.value = "<%=address%>";
			parent.document.info.rtel.value = "<%=wtel%>";
			
			<%-- parent.document.info.q1.value = "<%=sCompStatus%>"; --%>
			var q1Obj = parent.document.info.q1;
			for(var i = 0; i < q1Obj.length; i++) {
				if(q1Obj[i].value == "<%=sCompStatus%>") q1Obj[i].checked = true;
				else q1Obj[i].checked = false;
			}
			parent.document.info.q1Etc.value = "<%=sQ1Etc%>";
			
			<%-- parent.document.info.q2.value = "<%=sSentCapa%>"; --%>
			var q2Obj = parent.document.info.q2;
			for(var i = 0; i < q2Obj.length; i++) {
				if(q2Obj[i].value == "<%=sSentCapa%>") q2Obj[i].checked = true;
				else q2Obj[i].checked = false;
			}
			<%-- parent.document.info.q2Etc.value = "<%=sSentCapaTxt%>"; --%>
			
			parent.document.info.q3_1.value = "<%=ssale1%>";
			parent.document.info.q3_2.value = "<%=ssale2%>";
			parent.document.info.q3_3.value = "<%=ssale%>";
			parent.document.info.q3_4.value = "<%=soper1%>";
			parent.document.info.q3_5.value = "<%=soper2%>";
			parent.document.info.q3_6.value = "<%=soper%>";
			parent.document.info.q3_7.value = "<%=samt1%>";
			parent.document.info.q3_8.value = "<%=samt2%>";
			parent.document.info.q3_9.value = "<%=samt%>";
			<% if(ckOentGB != null && ckOentGB.equals("2")) { %>
			parent.document.info.q3_10.value = "<%=sconamt1%>";
			parent.document.info.q3_11.value = "<%=sconamt2%>";
			parent.document.info.q3_12.value = "<%=sconamt%>";
			<% } %>
			parent.document.info.q4.value = "<%=sEmpCnt%>";
			parent.document.info.q4_1.value = "<%=sEmpCnt1%>";
			parent.document.info.q4_2.value = "<%=sEmpCnt2%>";
			
			alert("정보가져오기를 완료하였습니다. 입력된 정보를 확인 후 다음 단계를 진행해 주세요.");
		}
	</script>
</head>
<body>
	<p>sname : <%=sname%></p>
	<p>scaptine : <%=scaptine%></p>
	<%-- <p>ssale : <%=ssale%></p>
	<p>samt : <%=samt%></p>
	<p>sempcnt	: <%=sempcnt%></p> --%>
	<p>wname : <%=wname%></p>
	<p>worg : <%=worg%></p>
	<p>wjikwi : <%=wjikwi%></p>
	<p>zipcode : <%=zipcode%></p>
	<p>address : <%=address%></p>
	<p>wtel : <%=wtel%></p>
	<p>wfax : <%=wfax%></p>
	<p>semail1 : <%=semail1%></p>
	<p>semail2 : <%=semail2%></p>
	<p>scompgb : <%=scompgb%></p>
	<p>scono1 : <%=scono1%></p>
	<p>scono2 : <%=scono2%></p>
	<p>ssano1 : <%=ssano1%></p>
	<p>ssano2 : <%=ssano2%></p>
	<p>ssano3 : <%=ssano3%></p>
	<p>sconamt : <%=sconamt%></p>
	<p>sreggb	: <%=sreggb%></p>
	<p>sregtext	: <%=sregtext%></p>
	<p>wdate : <%=wdate%></p>
	
</body>
</html>