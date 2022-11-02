<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명	: Oent_Edit.jsp
* 프로그램설명	: 원사업자 정보수정 화면
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2009년 05월
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2009-05-00	정광식       최초작성
*	2011-10-18	정광식		웹관리툴 리뉴얼
*	2015-12-30	정광식		DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>
<%@ page import="java.text.DecimalFormat"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>
<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String sMngNo = request.getParameter("no")==null ? "":request.getParameter("no").trim();
	String sCYear = request.getParameter("yyyy")==null ? "":request.getParameter("yyyy").trim();
	String sOentGB = request.getParameter("gb")==null ? "":request.getParameter("gb").trim();
	String sLoc = request.getParameter("loc")==null ? "":request.getParameter("loc").trim();
	String sMsg = request.getParameter("msg")==null ? "":request.getParameter("msg").trim();

	int sCYearNum = Integer.parseInt(sCYear);
	
	String otype = "";
	String oname = "";
	String ocaptine = "";
	String zipcode = "";
	String oaddress = "";
	String otel = "";
	String ofax = "";
	String oarea = "";
	String osale01 = "";
	String osale02 = "";
	String oassets = "";
	String oconamt = "";
	String oempcnt = "";
	String ocogb = "";
	String ocono = "";
	String ono = "";
	String assignmail = "";
	String w = "";
	String worg = "";
	String wjikwi = "";
	String wtel = "";
	String wfax = "";
	String wdate = "";
	String returngb = "";
	String resend = "";
	String compstatus = "";
	String subcontype = "";
	String subconcnt = "";
	String ostatus = "";
	String astatus = "";
	String deptseq = "";
	String submitdate = "";
	String cnm = "";
	String sOentRemake = "";

	// 해당 사무소 정보
	String sDCenterName = "";
	String sDDeptName = "";
	String sDUserName = "";
	String sDCVSNo = "";
	String sDPhoneNo = "";

	// 등기우편 발송번호
	String sPostNo1 = "";
	String sPostNo2 = "";
	String sPostNo3 = "";
	String sPostNo4 = "";
	String sPostNo5 = "";

	String sRrchFolder = "";

	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
	
	//2021
	String sOentIncorp = "";
	String sOentIncorp1 = "";
	String sOentIncorp2 = "";
	String osale = "0";
	String sOentAssets = "0";		// 자산총액
	String sOentAssets01 = "0";		// 자산총액
	String sOentAssets02 = "0";		// 자산총액
	String sOentOper01 = "0";
	String sOentOper02 = "0";
	String sOentOper03 = "0";
	String sOentEmpCnt = "0";	// 상시고용종업원 수
	String sOentEmpCnt01 = "0";	// 상시고용종업원 수
	String sOentEmpCnt02 = "0";	// 상시고용종업원 수
	
	String sOentConstAppr01 = "0";		// 시공능력평가액 (조사년도-3)
	String sOentConstAppr02 = "0";		// 시공능력평가액 (조사년도-2)
	String sOentConstAppr03 = "0";		// 시공능력평가액 (조사년도-1)
	//2021//
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	if(sMngNo != null && sCYear != null && sOentGB != null && (!sMngNo.equals("")) && (!sCYear.equals("")) && (!sOentGB.equals("")) ) {
		// 조사표 조회를 위한 세션정보 저장
		session.setAttribute("ckMngNo", sMngNo);
		session.setAttribute("ckCurrentYear", sCYear);
		session.setAttribute("ckOentGB", sOentGB);
		session.setAttribute("ckOentName", "");
		session.setAttribute("ckSentNo", "");
		session.setAttribute("ckSentName", "");
		session.setAttribute("ckEntGB", "1");
		session.setAttribute("ckLoginGB", "N");

		if( sCYear.equals("2009") ) { sRrchFolder = "/hado/hado/Research"; }
		else if( sCYear.equals("2010") ) { sRrchFolder = "/hado/hado/rsch0420"; }
		else if( sCYear.equals("2011") ) { sRrchFolder = "/hado/hado/rsch0614"; }
		else if( sCYear.equals("2012") ) { sRrchFolder = "/hado/hado/rsch0607"; }
		else if( sCYear.equals("2013") ) { sRrchFolder = "/hado/hado/rsch0923"; }
		else if( sCYear.equals("2014") ) { sRrchFolder = "/hado/hado/rsch140915"; }
		else if( sCYear.equals("2015") ) { sRrchFolder = "/hado/hado/rsch150427"; }
		else if( sCYear.equals("2016") ) { sRrchFolder = "/hado/hado/rsch160411"; }
		else if( sCYear.equals("2017") ) { sRrchFolder = "/hado/hado/rsch170602"; }
		else if( sCYear.equals("2018") ) { sRrchFolder = "/hado/hado/rsch180611"; }
		else if( sCYear.equals("2019") ) { sRrchFolder = "/hado/hado/rsch190604"; }
		else if( sCYear.equals("2020") ) { sRrchFolder = "/hado/hado/rsch200616"; }
		else if( sCYear.equals("2021") ) { sRrchFolder = "/hado/hado/rsch210726"; }
		else { sRrchFolder= ""; }

		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();

			StringBuffer sbSQLs = new StringBuffer();

			sbSQLs.append("SELECT * \n");
			if( Integer.parseInt(sCYear) >= 2012 ) {
				sbSQLs.append("FROM HADO_VT_OENT_SUBMIT_"+sCYear+" \n");
			} else {
				sbSQLs.append("FROM HADO_VT_OENT_SUBMIT \n");
			}
			sbSQLs.append("WHERE RTRIM(MNG_NO)=? \n");
			sbSQLs.append("    AND CURRENT_YEAR=? \n");
			sbSQLs.append("    AND OENT_GB=? \n");

			pstmt = conn.prepareStatement(sbSQLs.toString());
			pstmt.setString(1,sMngNo);
			pstmt.setString(2,sCYear);
			pstmt.setString(3,sOentGB);
			rs = pstmt.executeQuery();

			while(rs.next()) {
				otype = rs.getString("OENT_TYPE")==null ? "":rs.getString("OENT_TYPE").trim();
				oname = rs.getString("OENT_NAME")==null ? "":rs.getString("OENT_NAME").trim();
				ocaptine = rs.getString("OENT_CAPTINE")==null ? "":rs.getString("OENT_CAPTINE").trim();
				zipcode= rs.getString("ZIP_CODE")==null ? "":rs.getString("ZIP_CODE").trim();
				oaddress= rs.getString("OENT_ADDRESS")==null ? "":rs.getString("OENT_ADDRESS").trim();
				otel= rs.getString("OENT_TEL")==null ? "":rs.getString("OENT_TEL").trim();
				ofax= rs.getString("OENT_FAX")==null ? "":rs.getString("OENT_FAX").trim();
				oarea= rs.getString("OENT_AREA")==null ? "":rs.getString("OENT_AREA").trim();
				osale01= rs.getString("OENT_SALE01")==null ? "":rs.getString("OENT_SALE01").trim();
				osale02= rs.getString("OENT_SALE02")==null ? "":rs.getString("OENT_SALE02").trim();
				oassets= rs.getString("OENT_ASSETS")==null ? "":rs.getString("OENT_ASSETS").trim();
				oconamt= rs.getString("OENT_CON_AMT")==null ? "":rs.getString("OENT_CON_AMT").trim();
				oempcnt= rs.getString("OENT_EMP_CNT")==null ? "":rs.getString("OENT_EMP_CNT").trim();
				ocogb= rs.getString("OENT_CO_GB")==null ? "":rs.getString("OENT_CO_GB").trim();
				ocono= rs.getString("OENT_CO_NO")==null ? "":rs.getString("OENT_CO_NO").trim();
				ono= rs.getString("OENT_SA_NO")==null ? "":rs.getString("OENT_SA_NO").trim();
				assignmail= rs.getString("ASSIGN_MAIL")==null ? "":rs.getString("ASSIGN_MAIL").trim();
				w= rs.getString("WRITER_NAME")==null ? "":rs.getString("WRITER_NAME").trim();
				worg= rs.getString("WRITER_ORG")==null ? "":rs.getString("WRITER_ORG").trim();
				wjikwi= rs.getString("WRITER_JIKWI")==null ? "":rs.getString("WRITER_JIKWI").trim();
				wtel= rs.getString("WRITER_TEL")==null ? "":rs.getString("WRITER_TEL").trim();
				wfax= rs.getString("WRITER_FAX")==null ? "":rs.getString("WRITER_FAX").trim();
				wdate= rs.getString("WRITE_DATE")==null ? "":rs.getString("WRITE_DATE").trim();
				returngb= rs.getString("RETURN_GB")==null ? "":rs.getString("RETURN_GB").trim();
				resend= rs.getString("RE_SEND")==null ? "":rs.getString("RE_SEND").trim();
				compstatus= rs.getString("COMP_STATUS")==null ? "":rs.getString("COMP_STATUS").trim();
				subcontype= rs.getString("SUBCON_TYPE")==null ? "":rs.getString("SUBCON_TYPE").trim();
				subconcnt= rs.getString("SUBCON_CNT")==null ? "":rs.getString("SUBCON_CNT").trim();
				ostatus= rs.getString("OENT_STATUS")==null ? "":rs.getString("OENT_STATUS").trim();
				astatus= rs.getString("ADDR_STATUS")==null ? "":rs.getString("ADDR_STATUS").trim();
				submitdate= rs.getString("SUBMIT_DATE")==null ? "":rs.getString("SUBMIT_DATE").trim();
				cnm= rs.getString("COMMON_NM")==null ? "":rs.getString("COMMON_NM").trim();
				sOentRemake = rs.getString("oent_remake")==null ? "":rs.getString("oent_remake").trim();
			}
			rs.close();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if ( rs != null ) try{rs.close();}catch(Exception e){}
			if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
			if ( conn != null ) try{conn.close();}catch(Exception e){}
			if ( resource != null ) resource.release();
		}
		
		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();

			// 해당 사업자 담당사무소정보 가져오기
			StringBuffer sbSQLs2 = new StringBuffer();

			sbSQLs2.append("SELECT CVSNO,Center_Name,Dept_Name,User_Name,Phone_No \n");
			/*
			* 2014년 10월 02일 - 정광식
			* 데이타베이스 최적화를 위하여 2014년부터 담당관 정보 테이블 분리
			* 2014년 이전 : hado_vt_dept_history, 2014년~ : hado_vt_dept_hostory_2014
			*/
			int nTmpCYear = Integer.parseInt(sCYear);
			if( nTmpCYear>=2014 ) {
				sbSQLs2.append("FROM HADO_VT_Dept_History_" + sCYear + " \n");
			} else {
				sbSQLs2.append("FROM HADO_VT_Dept_History \n");
			}
			sbSQLs2.append("WHERE Mng_No=? \n");
			sbSQLs2.append("    AND CURRENT_YEAR=? \n");
			sbSQLs2.append("    AND OENT_GB=? \n");

			pstmt = conn.prepareStatement(sbSQLs2.toString());
			pstmt.setString(1,sMngNo);
			pstmt.setString(2,sCYear);
			pstmt.setString(3,sOentGB);
			rs = pstmt.executeQuery();

			while(rs.next()) {
				sDCVSNo = rs.getString("CVSNO")==null ? "":rs.getString("CVSNO").trim();
				sDCenterName = rs.getString("Center_Name")==null ? "":rs.getString("Center_Name").trim();
				sDDeptName = rs.getString("Dept_Name")==null ? "":rs.getString("Dept_Name").trim();
				sDUserName = rs.getString("User_Name")==null ? "":rs.getString("User_Name").trim();
				sDPhoneNo = rs.getString("Phone_No")==null ? "":rs.getString("Phone_No").trim();
			}
			rs.close();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if ( rs != null ) try{rs.close();}catch(Exception e){}
			if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
			if ( conn != null ) try{conn.close();}catch(Exception e){}
			if ( resource != null ) resource.release();
		}

		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();

			// 등기우편 발송 번호
			StringBuffer sbSQLs3 = new StringBuffer();

			sbSQLs3.append("SELECT * \n");
			/*
			* 2014년 10월 02일 - 정광식
			* 데이타베이스 최적화를 위하여 2014년부터 등기번호 정보 테이블 분리
			* 2014년 이전 : hado_tb_oent_postno, 2014년~ : hado_tb_oent_postno_2014
			*/
			int nTmpCYear = Integer.parseInt(sCYear);
			if( nTmpCYear>=2014 ) {
				sbSQLs3.append("FROM HADO_TB_Oent_PostNo_" + sCYear + " \n");
			} else {
				sbSQLs3.append("FROM HADO_TB_Oent_PostNo \n");
			}
			sbSQLs3.append("WHERE Mng_No=? \n");
			sbSQLs3.append("    AND CURRENT_YEAR=? \n");
			sbSQLs3.append("    AND OENT_GB=? \n");

			pstmt = conn.prepareStatement(sbSQLs3.toString());
			pstmt.setString(1,sMngNo);
			pstmt.setString(2,sCYear);
			pstmt.setString(3,sOentGB);
			rs = pstmt.executeQuery();

			while(rs.next()) {
				sPostNo1 = rs.getString("Post_No_01")==null ? "":rs.getString("Post_No_01").trim();
				sPostNo2 = rs.getString("Post_No_02")==null ? "":rs.getString("Post_No_02").trim();
				sPostNo3 = rs.getString("Post_No_03")==null ? "":rs.getString("Post_No_03").trim();
				sPostNo4 = rs.getString("Post_No_04")==null ? "":rs.getString("Post_No_04").trim();
				sPostNo5 = rs.getString("Post_No_05")==null ? "":rs.getString("Post_No_05").trim();
			}
			rs.close();
			
			
			//2021년도 추가사항 수정하기
			StringBuffer sbSQLs6 = new StringBuffer();
			
			sbSQLs6.append("SELECT * \n");
			sbSQLs6.append("FROM hado_tb_oent_" +sCYear+ " \n");
			sbSQLs6.append("WHERE mng_no = ? AND current_year = ? AND oent_gb = ? \n");
			
			pstmt = conn.prepareStatement(sbSQLs6.toString());
			pstmt.setString(1, sMngNo);
			pstmt.setString(2, sCYear);
			pstmt.setString(3, sOentGB);
			rs = pstmt.executeQuery();
			
			while ( rs.next() ) {
				sOentIncorp = rs.getString("oent_incorp")==null ? "":rs.getString("oent_incorp");
				osale = rs.getString("oent_ssale")==null ? "":rs.getString("oent_ssale");
				sOentOper01 = rs.getString("oent_oper01")==null ? "0":rs.getString("oent_oper01");
				sOentOper02 = rs.getString("oent_oper02")==null ? "0":rs.getString("oent_oper02");
				sOentOper03 = rs.getString("oent_oper03")==null ? "0":rs.getString("oent_oper03");
				sOentAssets = rs.getString("oent_assets")==null ? "0":rs.getString("oent_assets");
				sOentAssets01 = rs.getString("oent_assets01")==null ? "0":rs.getString("oent_assets01");
				sOentAssets02 = rs.getString("oent_assets02")==null ? "0":rs.getString("oent_assets02");
				sOentEmpCnt = rs.getString("oent_emp_cnt")==null ? "0":rs.getString("oent_emp_cnt");
				sOentEmpCnt01 = rs.getString("oent_emp_cnt01")==null ? "0":rs.getString("oent_emp_cnt01");
				sOentEmpCnt02 = rs.getString("oent_emp_cnt02")==null ? "0":rs.getString("oent_emp_cnt02");
				
				sOentConstAppr01 = rs.getString("oent_const_appr01")==null ? "0":rs.getString("oent_const_appr01");
				sOentConstAppr02 = rs.getString("oent_const_appr02")==null ? "0":rs.getString("oent_const_appr02");
				sOentConstAppr03 = rs.getString("oent_const_appr03")==null ? "0":rs.getString("oent_const_appr03");
			}
			rs.close();

			/* 설립연월 */
			String[] arrTmpIncorp = sOentIncorp.split("-");
			if( arrTmpIncorp.length==2 ) {
				sOentIncorp1 = arrTmpIncorp[0];
				sOentIncorp2 = arrTmpIncorp[1];
			}
			
			if(sCYearNum == 2021) {
				StringBuffer sbSQLs7 = new StringBuffer();
				sbSQLs7.append("SELECT A, B, C \n");
				sbSQLs7.append("FROM hado_tb_oent_answer_" +sCYear+ " \n");
				sbSQLs7.append("WHERE mng_no = ? AND current_year = ? AND oent_gb = ? \n");
				sbSQLs7.append("AND oent_q_cd = 5 AND oent_q_gb = 1 \n");
				
				pstmt = conn.prepareStatement(sbSQLs7.toString());
				pstmt.setString(1, sMngNo);
				pstmt.setString(2, sCYear);
				pstmt.setString(3, sOentGB);
				rs = pstmt.executeQuery();
				
				String a = "", b = "", c = "";
				while ( rs.next() ) {
					a = rs.getString("A")==null ? "":rs.getString("A");
					b = rs.getString("B")==null ? "":rs.getString("B");
					c = rs.getString("C")==null ? "":rs.getString("C");
				}
				rs.close();
				
				if(a != null && a.equals("1")) subcontype = "2";
				if(b != null && b.equals("1")) subcontype = "1";
				if(c != null && c.equals("1")) subcontype = "5";
			}
			//2021추가사항 끝
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if ( rs != null ) try{rs.close();}catch(Exception e){}
			if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
			if ( conn != null ) try{conn.close();}catch(Exception e){}
			if ( resource != null ) resource.release();
		}
	}
/*=====================================================================================================*/
%>
<%!
public String subcontypef(String str){
	String sReturnStr = "";

	if(str!= null && str.equals("1")) {
		sReturnStr="하도급을 주기만 함";
	} else if(str!= null && str.equals("2")) {
		sReturnStr="하도급을 주기도 하고 받기도 함";
	} else if(str!= null && str.equals("3")) {
		sReturnStr="하도급을 받기만 함";
	} else if(str!= null && str.equals("4")) {
		sReturnStr="하도급을 주지도 않고 받지도 않음";
	} else if(str!= null && str.equals("5")){//2021추가
		sReturnStr="하도급거래를 하지 않음(받기만 하는 경우 포함)";
	} else {
		sReturnStr="&nbsp;";
	}	

	return sReturnStr ;
}

public String astatusf(String str) {
	String sReturnStr = "";

	if(str!= null && str.equals("1")) {
		sReturnStr="소재불명";
	} else if(str!= null && str.equals("2")) {
		sReturnStr="동일회사";
	} else if(str!= null && str.equals("3")) {
		sReturnStr="원사업자요건안됨";
	} else if(str!= null && str.equals("9")) {
		sReturnStr="해당년도 조사 중복업체";
	} else if(str!= null && str.equals("8")) {
		sReturnStr="조사면제업체";
	} else {
		sReturnStr="&nbsp;";
	}	

	return sReturnStr;
}

public String isselected(String str1, String str2) {
	String sReturnStr = "";

	if(str1 != null && str2 != null && str1.equals(str2) ) {
		sReturnStr = " selected";
	}

	return sReturnStr;
}
%>
<script language="javascript">
//<![CDATA[
	content = "";
	
	content+="<div id='viewWinTop'>";
	content+="	<ul class='lt'>";
	content+="		<li class='fr'><a href=javascript:closeViewWin('divView') class='sbutton'>창닫기</a></li>";
	content+="	</ul>";
	content+="</div>";
	
	content+="<div id='viewWinTitle'>원사업자 상세정보 수정</div>";
	
	content+="<table class='ViewResultTable' align='center'>";
	content+="<form method='post' name='info'>";
	content+="	<tr>";
	content+="		<th>조사년도</th>";
	content+="		<td>&nbsp;<%=sCYear%>년 [<%=sMngNo%>]";
	content+="			<input type='hidden' name='no' value='<%=sMngNo%>'><input type='hidden' name='yyyy' value='<%=sCYear%>'><input type='hidden' name='gb' value='<%=sOentGB%>'>";
	content+="		</td>";
	content+="		<th>구분</th>";
	content+="		<td>&nbsp;<%=StringUtil.gbf(sOentGB)%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>업종코드</th>";
	content+="		<td>";
	<%if( !sOentGB.equals("2") || sCYearNum == 2021 ){%>
	content+="			&nbsp;<%=otype%>(<%=cnm%>)";
	<%}else{%>
	content+="			<select>";
	content+="				<option value=''>업종선택</option>";
	content+="				<option value='C110' <%=isselected("C110",otype)%>>일반건설업</option>";
	content+="				<option value='C330' <%=isselected("C330",otype)%>>전문건설업</option>";
	content+="				<option value='C440' <%=isselected("C440",otype)%>>전기공사업</option>";
	content+="				<option value='C550' <%=isselected("C550",otype)%>>정보통신공사업</option>";
	content+="				<option value='C660' <%=isselected("C660",otype)%>>소방시설공사업</option>";
	content+="			</select><br/>";
	content+="			<font color='red'>* 건설업은 필히 수정!!</font>";
	<%}%>
	content+="		</td>";
	content+="		<th>회사명</th>";
	content+="		<td>&nbsp;<input type='text' name='oname' value='<%=oname%>' class='s_input'></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>법인등록여부</th>";
	content+="		<td>&nbsp;";
	content+="			<select name='ocogb'>";
	content+="				<option value=''></option>";
	content+="				<option value='0' <%=isselected(ocogb,"0")%>>개인 사업자</option>";
	content+="				<option value='1' <%=isselected(ocogb,"1")%>>법인 사업자</option>";
	content+="			</select>";
	content+="		</td>";
	content+="		<th>법인번호</th>";
	content+="		<td>&nbsp;<input type='text' name='ocono' value='<%=ocono%>' class='s_input'></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>설립연월</th>";
	content+="		<td>&nbsp;<input type='text' name='sOentIncorp' value='<%=sOentIncorp%>' class='s_input'></td>";
	content+="		<th>사업자등록번호</th>";
	content+="		<td>&nbsp;<input type='text' name='ono' value='<%=ono%>' class='s_input'></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>대표자명</th>";
	content+="		<td>&nbsp;<input type='text' name='ocaptine' value='<%=ocaptine%>' class='s_input'></td>";
	content+="		<th>우편번호</th>";
	content+="		<td>&nbsp;<input type='text' name='rpost' id='zipcode' value='<%=zipcode%>' maxlength='6' class='s_input' style='width:60px;'><a href=javascript:top.OpenPost_w('zipcode','oaddress') class='sbutton'>우편번호찾기</a></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>주소</th>";
	content+="		<td>&nbsp;<input type='text' name='raddr' value='<%=oaddress%>' id='oaddress' class='s_input'></td>";
	content+="		<th>전화번호</th>";
	content+="		<td>&nbsp;<input type='text' name='otel' value='<%=otel%>' class='s_input'></td>";
	content+="	</tr>";
	<%
	if( sCYearNum == 2021 ) {
	%>
		content+="	<tr>";
		content+="		<th><%=Integer.parseInt(sCYear)-3%>년 매출액</th>";
		content+="		<td>&nbsp;<input type='text' name='osale' value='<%=osale%>' class='s_input' style='width:100px;text-align:right;'> 백만원</td>";
		content+="		<th><%=Integer.parseInt(sCYear)-2%>년 매출액</th>";
		content+="		<td>&nbsp;<input type='text' name='osale01' value='<%=osale01%>' class='s_input' style='width:100px;text-align:right;'> 백만원</td>";
		content+="	</tr>";
		content+="	<tr>";
		content+="		<th><%=Integer.parseInt(sCYear)-1%>년 매출액</th>";
		content+="		<td colspan='3'>&nbsp;<input type='text' name='osale02' value='<%=osale02%>' class='s_input' style='width:100px;text-align:right;'> 백만원</td>";
		content+="	</tr>";
		content+="	<tr>";
		content+="		<th><%=Integer.parseInt(sCYear)-3%>년 영업비용</th>";
		content+="		<td>&nbsp;<input type='text' name='sOentOper01' value='<%=sOentOper01%>' class='s_input' style='width:100px;text-align:right;'> 백만원</td>";
		content+="		<th><%=Integer.parseInt(sCYear)-2%>년 영업비용</th>";
		content+="		<td>&nbsp;<input type='text' name='sOentOper02' value='<%=sOentOper02%>' class='s_input' style='width:100px;text-align:right;'> 백만원</td>";
		content+="	</tr>";
		content+="	<tr>";
		content+="		<th><%=Integer.parseInt(sCYear)-1%>년 영업비용</th>";
		content+="		<td colspan='3'>&nbsp;<input type='text' name='sOentOper03' value='<%=sOentOper03%>' class='s_input' style='width:100px;text-align:right;'> 백만원</td>";
		content+="	</tr>";
		content+="	<tr>";
		content+="		<th><%=Integer.parseInt(sCYear)-3%>년 자산총액</th>";
		content+="		<td>&nbsp;<input type='text' name='sOentAssets' value='<%=sOentAssets%>' class='s_input' style='width:100px;text-align:right;'> 백만원</td>";
		content+="		<th><%=Integer.parseInt(sCYear)-2%>년 자산총액</th>";
		content+="		<td>&nbsp;<input type='text' name='sOentAssets01' value='<%=sOentAssets01%>' class='s_input' style='width:100px;text-align:right;'> 백만원</td>";
		content+="	</tr>";
		content+="	<tr>";
		content+="		<th><%=Integer.parseInt(sCYear)-1%>년 자산총액</th>";
		content+="		<td colspan='3'>&nbsp;<input type='text' name='sOentAssets02' value='<%=sOentAssets02%>' class='s_input' style='width:100px;text-align:right;'> 백만원</td>";
		content+="	</tr>";
		<% if(sOentGB == "2") { %>
			content+="	<tr>";
			content+="		<th><%=Integer.parseInt(sCYear)-3%>년 시공능력평가액</th>";
			content+="		<td>&nbsp;<input type='text' name='sOentConstAppr01' value='<%=sOentConstAppr01%>' class='s_input' style='width:100px;text-align:right;'> 백만원</td>";
			content+="		<th><%=Integer.parseInt(sCYear)-2%>년 시공능력평가액</th>";
			content+="		<td>&nbsp;<input type='text' name='sOentConstAppr02' value='<%=sOentConstAppr02%>' class='s_input' style='width:100px;text-align:right;'> 백만원</td>";
			content+="	</tr>";
			content+="	<tr>";
			content+="		<th><%=Integer.parseInt(sCYear)-1%>년 시공능력평가액</th>";
			content+="		<td colspan='3'>&nbsp;<input type='text' name='sOentConstAppr03' value='<%=sOentConstAppr03%>' class='s_input' style='width:100px;text-align:right;'> 백만원</td>";
			content+="	</tr>";
		<% } %>
		content+="	<tr>";
		content+="		<th>총 근로자</th>";
		content+="		<td colspan='3'>&nbsp;<input type='text' name='oempcnt' value='<%=sOentEmpCnt%>' class='s_input' style='width:100px;text-align:right;'> 명</td>";
		content+="	</tr>";
		content+="	<tr>";
		content+="		<th>상용 근로자</th>";
		content+="		<td>&nbsp;<input type='text' name='sOentEmpCnt01' value='<%=sOentEmpCnt01%>' class='s_input' style='width:100px;text-align:right;'> 명</td>";
		content+="		<th>임시 및 일용 근로자</th>";
		content+="		<td>&nbsp;<input type='text' name='sOentEmpCnt02' value='<%=sOentEmpCnt02%>' class='s_input' style='width:100px;text-align:right;'> 명</td>";
		content+="	</tr>";
	<%
	} else {
	%>
		content+="	<tr>";
		content+="		<th>상시종업원수</th>";
		content+="		<td>&nbsp;<input type='text' name='oempcnt' value='<%=oempcnt%>' class='s_input' style='width:100px;text-align:right;'>명</td>";
		content+="		<th><%=Integer.parseInt(sCYear)-2%>년 매출액</th>";
		content+="		<td>&nbsp;<input type='text' name='osale01' value='<%=osale01%>' class='s_input' style='width:100px;text-align:right;'>백만원</td>";
		content+="	</tr>";
		content+="	<tr>";
		content+="		<th><%=Integer.parseInt(sCYear)-1%> 매출액</th>";
		content+="		<td>&nbsp;<input type='text' name='osale02' value='<%=osale02%>' class='s_input' style='width:100px;text-align:right;'>백만원</td>";
		content+="		<th>시공능력평가액</th>";
		content+="		<td>&nbsp;<input type='text' name='oconamt' value='<%=oconamt%>' class='s_input' style='width:100px;text-align:right;'>백만원</td>";
		content+="	</tr>";
	<%
	}
	%>
	content+="	<tr>";
	content+="		<th>담당자 E-mail</th>";
	content+="		<td>&nbsp;<input type='text' name='assignmail' value='<%=assignmail%>' class='s_input'></td>";
	content+="		<th>작성자소속</th>";
	content+="		<td>&nbsp;<input type='text' name='worg' value='<%=worg%>' class='s_input'></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>작성자</th>";
	content+="		<td>&nbsp;<input type='text' name='w' value='<%=w%>' class='s_input'></td>";
	content+="		<th>작성자직위</th>";
	content+="		<td>&nbsp;<input type='text' name='wjikwi' value='<%=wjikwi%>' class='s_input'></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>작성자전화</th>";
	content+="		<td>&nbsp;<input type='text' name='wtel' value='<%=wtel%>' class='s_input'></td>";
	content+="		<th>작성자팩스</th>";
	content+="		<td>&nbsp;<input type='text' name='wfax' value='<%=wfax%>' class='s_input'></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>작성일자</th>";
	content+="		<td>&nbsp;<%=wdate%></td>";
	content+="		<th>반송여부</th>";
	content+="		<td>&nbsp;";
	content+="			<select name='returngb'>";
	content+="				<option value=''></option>";
	content+="				<option value='1' <%=isselected(returngb,"1")%>>반 송</option>";
	content+="			</select>";
	content+="		</td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>재발송여부</th>";
	content+="		<td>&nbsp;";
	content+="			<select name='resend'>";
	content+="				<option value=''></option>";
	content+="				<option value='1' <%=isselected(resend,"1")%>>재발송</option>";
	content+="			</select>";
	content+="		</td>";
	content+="		<th>회사영업상태</th>";
	content+="		<td>&nbsp;";
	<%
	if( sCYearNum == 2021 ) {
	%>
	content+="			<select name='compstatus'>";
	content+="				<option value=''></option>";
	content+="				<option value='1' <%=isselected(compstatus,"1")%>>정상영업</option>";
	content+="				<option value='3' <%=isselected(compstatus,"3")%>>기업회생 절차 진행 중</option>";
	content+="				<option value='4' <%=isselected(compstatus,"4")%>>영업중단 중 또는 폐업준비 중</option>";
	content+="				<option value='5' <%=isselected(compstatus,"5")%>>다른 회사와 합병 진행 중</option>";
	content+="				<option value='6' <%=isselected(compstatus,"6")%>>기타</option>";
	content+="			</select>";
	<%
	} else {
	%>
	content+="			<select name='compstatus'>";
	content+="				<option value=''></option>";
	content+="				<option value='1' <%=isselected(compstatus,"1")%>>정상영업</option>";
	content+="				<option value='2' <%=isselected(compstatus,"2")%>>회사정리절차 진행중</option>";
	content+="				<option value='3' <%=isselected(compstatus,"3")%>>회생절차 진행중</option>";
	content+="				<option value='4' <%=isselected(compstatus,"4")%>>기업개선작업(work-out) 진행 중</option>";
	content+="				<option value='5' <%=isselected(compstatus,"5")%>>부도</option>";
	content+="				<option value='6' <%=isselected(compstatus,"6")%>>영업중단 또는 폐업</option>";
	content+="				<option value='7' <%=isselected(compstatus,"7")%>>다른회사에 흡수합병</option>";
	content+="			</select>";
	<%
	}
	%>
	content+="		</td>";
	content+="	</tr>";
	content+="	<tr>";
	<%
	if( sCYearNum == 2021 ) {
	%>
		<%-- content+="		<th>하도급거래형태</th>";
		content+="		<td>&nbsp;<%=subcontypef(subcontype)%></td>"; --%>
		
		content+="		<th>하도급거래형태</th>";
		content+="		<td>&nbsp;";
		content+="			<select name='subcontype_2021'>";
		content+="				<option value=''></option>";
		content+="				<option value='1' <%=isselected(subcontype,"2")%>>하도급을 주기도 하고 받기도 함</option>";
		content+="				<option value='2' <%=isselected(subcontype,"1")%>>하도급을 주기만 함</option>";
		content+="				<option value='3' <%=isselected(subcontype,"5")%>>하도급거래를 하지 않음(받기만 하는 경우 포함)</option>";
		content+="			</select>";
		content+="		</td>";
	<%
	} else {
	%>
		content+="		<th>하도급거래형태</th>";
		content+="		<td>&nbsp;";
		content+="			<select name='subcontype'>";
		content+="				<option value=''></option>";
		content+="				<option value='1' <%=isselected(subcontype,"1")%>>하도급을 주기만 함</option>";
		content+="				<option value='2' <%=isselected(subcontype,"2")%>>하도급을 주기도 하고 받기도 함</option>";
		content+="				<option value='3' <%=isselected(subcontype,"3")%>>하도급을 받기만 함</option>";
		content+="				<option value='4' <%=isselected(subcontype,"4")%>>하도급을 주지도 않고 받지도 않음</option>";
		content+="			</select>";
		content+="		</td>";
	<%
	}
	%>
	content+="		<th>전송여부</th>";
	content+="		<td>&nbsp;";
	content+="				<select name='ostatus'>";
	content+="					<option value=''>미 전 송</option>";
	content+="					<option value='1' <%=isselected(ostatus,"1")%>>전 송</option>";
	content+="				</select>";
	content+="		</td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>전송일자</th>";
	content+="		<td>&nbsp;<%=submitdate%></td>";
	content+="		<th>소재불명여부</th>";
	content+="		<td>&nbsp;";
	content+="			<select name='astatus'>";
	content+="				<option value=''></option>";
	content+="				<option value='1' <%=isselected(astatus,"1")%>>소재불명</option>";
	content+="				<option value='2' <%=isselected(astatus,"2")%>>동일회사</option>";
	content+="				<option value='3' <%=isselected(astatus,"3")%>>원사업자요건안됨</option>";
	content+="				<option value='9' <%=isselected(astatus,"9")%>>해당년도 조사 중복업체</option>";
	content+="				<option value='8' <%=isselected(astatus,"8")%>>조사면제업체</option>";
	content+="			</select>";
	content+="		</td>";
	content+="	</tr>";
	<%
	int nCurrentYear = Integer.parseInt(sCYear);
	if( nCurrentYear>=2013 ) {
	%>
	content+="	<tr>";
	content+="		<th>비고<br/>(사후조치등<br/>비고사항<br/>입력)</th>";
	content+="		<td colspan='3'>&nbsp;";
	content+="			<textarea id='oent_remake' name='oent_remake' rows=5 cols=65 class='s_textarea'><%=sOentRemake%></textarea>";
	content+="		</td>";
	content+="	</tr>";
	<%
	}%>
	content+="</form>";
	content+="</table>";
	
	content+="<div id='divViewWinbutton'>";
	content+="	<ul class='lt'>";
	content+="		<li class='fl'><a href=javascript:top.f_EditSubmit(document.info) class='sbutton'>정보수정실행</a></li>";
	content+="		<li class='fr'><a href=javascript:top.closeViewWin('divView') class='sbutton'>창닫기</a></li>";
	content+="	</ul>";
	content+="</div>";
	
	top.document.getElementById("divView").innerHTML = content;
	top.setNowProcessFalse();
//]]
</script>
<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>