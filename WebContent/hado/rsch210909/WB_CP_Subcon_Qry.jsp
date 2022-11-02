<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="/Include/WB_I_Global.jsp"%>
<%@ include file="/Include/WB_I_chkSession.jsp"%>

<%/* 페이지 인코딩 추가 */
request.setCharacterEncoding("euc-kr");
response.setContentType("text/html; charset=euc-kr;");
%>
<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. 프로젝트명 : 공정관리위원회 하도급거래 서면직권실태조사 민원인 홈페이지                         */
/*  2. 업체정보 :                                                                                      */
/*     - 업체명 : 공정관리위원회		            												   */
/*     - 담장자명 : 남기태 조사관				          											   */
/*     - 연락처 : T) 02-2023-4491  F) 02-2023-4500													   */
/*  3. 개발업체정보 :																				   */
/*     - 업체명 : (주)이꼬르																		   */
/*	   - Project Manamger : 정광식 부장 (pcxman99@naver.com)										   */
/*     - 연락처 : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  4. 일자 : 2009년 5월																			   */
/*  5. 저작권자 : 공정관리위원회 기업협력국															   */
/*  6. 저작권자의 동의 없이 배포 및 사용을 할수 없습니다.											   */
/*  7. 업데이트일자 : 																				   */
/*  8. 업데이트내용 (내용 / 일자)																	   */
/*  9. 비고																							   */
/*-----------------------------------------------------------------------------------------------------*/
/*---------------------------------------- Variable Difinition ----------------------------------------*/

	String[][] qs		= new String[35][40];
	int[] q				= new int[24];
	String sErrorMsg	= "";						//오류메시지
	String sReturnURL 	= "/index.jsp";				//이동URL(상대주소)
	String qType		= StringUtil.checkNull(request.getParameter("type"));
	String qStep		= StringUtil.checkNull(request.getParameter("step"));

	// 20110923 - KS Jung - 콜센터관리툴 관련 파라메터
	String sMngType		= ""+session.getAttribute("ckMngType");
	// 접속지IP 정보
	String sRemoteIp = request.getRemoteAddr();
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/	
	// Cookie Request
	String sMngNo		= ckMngNo;
	String sOentYYYY	= ckCurrentYear;
	String sOentGB		= ckOentGB;
	String sOentName	= ckOentName;
	String sSentNo		= ckSentNo;

	ConnectionResource resource = null;
	Connection conn				= null;
	PreparedStatement pstmt		= null;
	ResultSet rs				= null;

	ConnectionResource2 resource2 = null;
	Connection conn2			= null;

	String sSQLs		= "";
	String sqls1		= "";
	String sqls2		= "";
	String sqlsour1		= "";
	String sqlsour2		= "";
	String sTmp_Area	= "";
	String bexe			= "no";
	int updateCNT		= 0;

	if( ckMngNo.trim().length() > 8 ) {
		sMngNo = ckMngNo.substring(0,8);
	} else if( ckMngNo.trim().length() == 6 ) {
		sMngNo = ckMngNo.substring(0,5);
	} else if ( ckMngNo.trim().length() == 4 ) {
		sMngNo = ckMngNo.substring(0,3);
	}
/*=====================================================================================================*/
// 회사개요
if (qStep.equals("Basic")) {
	// 수정된 회사개요 업데이트
	sSQLs="UPDATE HADO_TB_Subcon_"+sOentYYYY+" SET \n";
	sSQLs+="sent_name='"+StringUtil.checkNull(request.getParameter("rcomp")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", comp_gb='"+StringUtil.checkNull(request.getParameter("rcogb")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", sent_co_no='"+StringUtil.checkNull(request.getParameter("rlawno")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", sent_sa_no='"+StringUtil.checkNull(request.getParameter("rregno")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", sent_captine='"+StringUtil.checkNull(request.getParameter("rowner")).trim().replaceAll("'","''")+"' \n";
	if( (!StringUtil.checkNull(request.getParameter("rpost")).trim().equals(""))) {
		sSQLs+=", zip_code='"+StringUtil.checkNull(request.getParameter("rpost")).trim().replaceAll("'","''")+"' \n";
	} else {
		sSQLs+=", zip_code=null \n";
	}
	sSQLs+=", sent_address='"+StringUtil.checkNull(request.getParameter("raddr")).trim().replaceAll("'","''")+"' \n";
	if( (!StringUtil.checkNull(request.getParameter("remail1")).trim().equals("")) && (!StringUtil.checkNull(request.getParameter("remail2")).trim().equals("")) ) {
		sSQLs+=", assign_mail='"+StringUtil.checkNull(request.getParameter("remail1")).trim().replaceAll("'","''")+"@"+StringUtil.checkNull(request.getParameter("remail2")).trim().replaceAll("'","''")+"' \n";
	} else {
		sSQLs+=", assign_mail=null \n";
	}
	sSQLs+=", writer_org='"+StringUtil.checkNull(request.getParameter("rdept")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", writer_jikwi='"+StringUtil.checkNull(request.getParameter("rposition")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", writer_name='"+StringUtil.checkNull(request.getParameter("rname")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", writer_tel='"+StringUtil.checkNull(request.getParameter("rtel")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", writer_fax='"+StringUtil.checkNull(request.getParameter("rfax")).trim().replaceAll("'","''")+"' \n";
	/* if( !StringUtil.checkNull(request.getParameter("rsale")).trim().equals("") ) {
		sSQLs+=", sent_sale="+StringUtil.checkNull(request.getParameter("rsale")).trim().replaceAll("'","''").replaceAll(",","")+" \n";
	} else {
		sSQLs+=", sent_sale=0 \n";
	} */
	/* if( !StringUtil.checkNull(request.getParameter("rasset")).trim().equals("") ) {
		sSQLs+=", sent_amt="+StringUtil.checkNull(request.getParameter("rasset")).trim().replaceAll("'","''").replaceAll(",","")+" \n";
	} else {
		sSQLs+=", sent_amt=0 \n";
	} */
	/* if( !StringUtil.checkNull(request.getParameter("rempcnt")).trim().equals("") ) {
		sSQLs+=", sent_emp_cnt="+StringUtil.checkNull(request.getParameter("rempcnt")).trim().replaceAll("'","''").replaceAll(",","")+" \n";
	} else {
		sSQLs+=", sent_emp_cnt=0 \n";
	} */
	/* if (qType.equals("Const")) {
		if( !StringUtil.checkNull(request.getParameter("rconamt")).trim().equals("") ) {
			sSQLs+=", sent_con_amt="+StringUtil.checkNull(request.getParameter("rconamt")).trim().replaceAll("'","''").replaceAll(",","")+" \n";
		} else {
			sSQLs+=", sent_con_amt=0 \n";
		}
		sSQLs+=", con_reg_gb='"+StringUtil.checkNull(request.getParameter("rreggb")).trim().replaceAll("'","''")+"' \n";
		sSQLs+=", con_reg_text='"+StringUtil.checkNull(request.getParameter("rregtext")).trim().replaceAll("'","''")+"' \n";
	} */
	sSQLs+=", remote_ip='" + sRemoteIp + "' \n";
	sSQLs+=", writer_date=sysdate \n";
	
    // 2015-07-15 / 조사제외대상여부 추가 / 강슬기
	//String sSentNoExcept = request.getParameter("rnoexpt")==null ? "":request.getParameter("rnoexpt");
    // 조사제외대상여부 설문내용 변경으로 인한 수정 20210915    
    String sSentNoExcept = request.getParameter("q0")==null ? "":request.getParameter("q0");
	if( !sSentNoExcept.equals("") ) {
		sSQLs+=",	SP_FLD_03='"+sSentNoExcept.trim()+"' \n";	// 조사제외대상여부
	} else {
		sSQLs+=",	SP_FLD_03=NULL \n";
	}
	// 조사제외대상에 기타문구 추가 20210915
	String sSentNoExceptEtc = request.getParameter("q0Etc")==null ? "":request.getParameter("q0Etc");
	if( !sSentNoExceptEtc.equals("") ) {
		sSQLs+=",	SP_FLD_03_ETC='"+sSentNoExceptEtc.trim()+"' \n";	// 조사제외대상 기타문구
	} else {
		sSQLs+=",	SP_FLD_03_ETC=NULL \n";
	}
  

	// 20110923 - KS Jung - 콜센터관리툴 관련 파라메터
	if( sMngType!=null && !sMngType.equals("")) {
		sSQLs+=", Admin_Insert_GB='1' \n";
		sSQLs+=", SP_FLD_02='"+sMngType+"' \n";
	}
	
	
	/* 2020년 추가 */
	String sTmp_incorp = "";
	String sIncorp1 = request.getParameter("rincorp1")==null ? "":request.getParameter("rincorp1").trim().replaceAll("'", "''");
	String sIncorp2 = request.getParameter("rincorp2")==null ? "":request.getParameter("rincorp2").trim().replaceAll("'", "''");
	if( !sIncorp1.equals("")  && !sIncorp2.equals("") ) sTmp_incorp = sIncorp1 + "-" + sIncorp2;
	sSQLs+=",	SENT_INCORP='"+sTmp_incorp+"' \n";	// 조사제외대상여부
	
	sSQLs+=",	COMP_STATUS='"+StringUtil.checkNull(request.getParameter("q1")).trim()+"' \n";
	sSQLs+=",	COMP_STATUS_ETC='"+StringUtil.checkNull(request.getParameter("q1Etc")).trim()+"' \n";
	
	sSQLs+=",	SENT_CAPA='"+StringUtil.checkNull(request.getParameter("q2")).trim()+"' \n";
	sSQLs+=",	SENT_CAPA_ETC='"+StringUtil.checkNull(request.getParameter("q2Etc")).trim()+"' \n";
	
	sSQLs+=",	SENT_SALE1='"+StringUtil.checkNull(request.getParameter("q3_1")).trim().replaceAll(",", "")+"' \n";
	sSQLs+=",	SENT_SALE2='"+StringUtil.checkNull(request.getParameter("q3_2")).trim().replaceAll(",","")+"' \n";
	sSQLs+=",	SENT_SALE='"+StringUtil.checkNull(request.getParameter("q3_3")).trim().replaceAll(",","")+"' \n";
	
	sSQLs+=",	SENT_OPER1='"+StringUtil.checkNull(request.getParameter("q3_4")).trim().replaceAll(",", "")+"' \n";
	sSQLs+=",	SENT_OPER2='"+StringUtil.checkNull(request.getParameter("q3_5")).trim().replaceAll(",","")+"' \n";
	sSQLs+=",	SENT_OPER='"+StringUtil.checkNull(request.getParameter("q3_6")).trim().replaceAll(",","")+"' \n";
	
	sSQLs+=",	SENT_AMT1='"+StringUtil.checkNull(request.getParameter("q3_7")).trim().replaceAll(",", "")+"' \n";
	sSQLs+=",	SENT_AMT2='"+StringUtil.checkNull(request.getParameter("q3_8")).trim().replaceAll(",","")+"' \n";
	sSQLs+=",	SENT_AMT='"+StringUtil.checkNull(request.getParameter("q3_9")).trim().replaceAll(",","")+"' \n";
	
	//if (qType.equals("Const")) {
    //20210923 건설업 시공능력평가액 저장 처리
    if(sOentGB.equals("2")) {
		sSQLs+=",	SENT_CON_AMT1='"+StringUtil.checkNull(request.getParameter("q3_10")).trim().replaceAll(",", "")+"' \n";
		sSQLs+=",	SENT_CON_AMT2='"+StringUtil.checkNull(request.getParameter("q3_11")).trim().replaceAll(",","")+"' \n";
		sSQLs+=",	SENT_CON_AMT='"+StringUtil.checkNull(request.getParameter("q3_12")).trim().replaceAll(",","")+"' \n";
	}
	
	sSQLs+=",	SENT_EMP_CNT='"+StringUtil.checkNull(request.getParameter("q4")).trim().replaceAll(",","")+"' \n";
	sSQLs+=",	SENT_EMP_CNT1='"+StringUtil.checkNull(request.getParameter("q4_1")).trim().replaceAll(",","")+"' \n";
	sSQLs+=",	SENT_EMP_CNT2='"+StringUtil.checkNull(request.getParameter("q4_2")).trim().replaceAll(",","")+"' \n";
	

	//sSQLs+=" WHERE Mng_No='"+sMngNo+"' \n";
	sSQLs+=" WHERE Child_Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";

System.out.println("회사개요 =====================>>> " + sSQLs);

	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
		System.out.println("is Error SQL : "+sSQLs);
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}

	// 하도급법이 적용되지 않는 사유 저장
	if(!StringUtil.checkNull(request.getParameter("reason")).trim().equals("")) {
		// 기존 답변 삭제
		sSQLs="DELETE FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
		sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";
		sSQLs+="AND SOENT_Q_CD=30 AND SOENT_Q_GB=1 \n";
	
		try {
			resource2	= new ConnectionResource2();
			conn2		= resource2.getConnection();
			//System.out.println("delete : "+sSQLs+ "\n");
			pstmt		= conn2.prepareStatement(sSQLs);
			updateCNT	= pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			System.out.println("is ORA-00942 at reason_delete1? : "+sSQLs);
		} finally {
			if (rs != null)		try{rs.close();}	catch(Exception e){}
			if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
			if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
			if (resource2 != null) resource2.release();
		}

		// 새 답변 저장
		String temp = StringUtil.checkNull(request.getParameter("reason")).trim().replaceAll("'","''");

		sSQLs="INSERT INTO HADO_TB_SOENT_ANSWER_"+sOentYYYY+" (  \n";
		sSQLs+="MNG_NO, CURRENT_YEAR, OENT_GB, SENT_NO,SOENT_Q_CD, SOENT_Q_GB, SUBJ_ANS ) VALUES ( \n";
		sSQLs+="'"+ckMngNo+"', '"+sOentYYYY+"', '"+sOentGB+"', "+sSentNo+", 30, 1, '"+temp+"') \n";
		//sSQLs="UPDATE HADO_TB_SOENT_ANSWER SET MNG_NO='"+ckMngNo+"', CURRENT_YEAR='"+sOentYYYY+
		//		"', OENT_GB='"+sOentGB+"', SENT_NO="+sSentNo+", SOENT_Q_CD=30, SOENT_Q_GB=1 "+
		//		", SUBJ_ANS='"+temp+"'";
			
		try {
			resource2	= new ConnectionResource2();
			conn2		= resource2.getConnection();
			//System.out.println("update : "+sSQLs+"\n");
			pstmt		= conn2.prepareStatement(sSQLs);
			updateCNT	= pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			System.out.println("is ORA-00942 at reason_save? : "+sSQLs);
		} finally {
			if (rs != null)		try{rs.close();}	catch(Exception e){}
			if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
			if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
			if (resource2 != null) resource2.release();
		}
	} else {
		// 기존 답변 삭제
		sSQLs="DELETE FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
		sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";
		sSQLs+="AND SOENT_Q_CD=30 AND SOENT_Q_GB=1 \n";
	
		try {
			resource2	= new ConnectionResource2();
			conn2		= resource2.getConnection();
			//System.out.println("delete : "+sSQLs+ "\n");
			pstmt		= conn2.prepareStatement(sSQLs);
			updateCNT	= pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			System.out.println("is ORA-00942 at reason_delete2? : "+sSQLs);
		} finally {
			if (rs != null)		try{rs.close();}	catch(Exception e){}
			if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
			if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
			if (resource2 != null) resource2.release();
		}
	}
	
	
	// 로그인정보 회사명 수정
	/*
	sSQLs="UPDATE HADO_TB_Security_"+sOentYYYY+" SET \n";
	sSQLs+="	Sent_Name='"+StringUtil.checkNull(request.getParameter("rcomp")).trim().replaceAll("'","''")+"' \n";
	sSQLs+="WHERE Mng_No='"+sMngNo+"' \n";
	sSQLs+="	AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="	AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";

	try {
		resource		= new ConnectionResource();
		conn			= resource.getConnection();
		pstmt			= conn.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if ( rs != null )		try{rs.close();}	catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )	try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}
	*/
	
	
	
	sReturnURL	= "WB_VP_Subcon_0" + sOentGB+"_02.jsp?isSaved=1";

/*=====================================================================================================*/	
// 하도급 거래현황
} else if (qStep.equals("Detail")) {
	// 기존 답변 삭제
	sSQLs="DELETE FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
	sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";
	sSQLs+="AND NOT (SOENT_Q_CD=30 AND SOENT_Q_GB=1) \n";	// 사유가 저장된 위치
	//System.out.println(sSQLs);
	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
		System.out.println("is ORA-00942 03_answer_delete? : "+sSQLs);
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}	
	// 배열 초기화
	for(int ni = 1; ni < 35; ni++) {
		for(int nj = 1; nj < 40; nj++) {
			qs[ni][nj] = "0";
		}
	}
	/* for(int ni = 0; ni < 24; ni++) {
		q[ni] = 0;
	} */
	
	// 조사표 문항별 속성 설정
	// 1 = 라디오 버튼
	// 2 = 체크박스
	// 3 = 주관식
	if (qType.equals("Prod")) {
		qs[5][1] = "1";
		
		qs[6][1] = "3";	qs[6][2] = "3";	qs[6][3] = "3";	qs[6][4] = "3";	qs[6][5] = "3";	qs[6][6] = "3";
		
		qs[7][1] = "3";	qs[7][2] = "3";	qs[7][3] = "3";	qs[7][4] = "3";
		
		qs[8][1] = "3";	qs[8][2] = "3";	qs[8][3] = "3";
		
		qs[9][1] = "1";
		
		qs[10][1] = "1";
		
		qs[11][1] = "1";	qs[11][21] = "3";	qs[11][2] = "1";	qs[11][3] = "1";	qs[11][22] = "3";	qs[11][23] = "3";	qs[11][24] = "3";
		qs[11][25] = "3";	qs[11][26] = "3";	qs[11][5] = "1";	qs[11][27] = "3";	qs[11][6] = "1";	qs[11][7] = "1";	qs[11][28] = "3";
		
		qs[12][1] = "1";	qs[12][11] = "1";	qs[12][12] = "1";	qs[12][13] = "1";	qs[12][14] = "1";	qs[12][15] = "1";	qs[12][16] = "1";
		qs[12][17] = "1";	qs[12][18] = "1";	qs[12][19] = "1";	qs[12][20] = "1";	qs[12][3] = "1";	qs[12][21] = "3";
		
		qs[13][1] = "1";	qs[13][2] = "2";	qs[13][11] = "3";
		
		qs[14][1] = "1";	qs[14][2] = "2";	qs[14][11] = "3";
		
		qs[15][1] = "1";	qs[15][2] = "2";	qs[15][11] = "3";
		
		qs[16][1] = "1";	qs[16][11] = "3";	qs[16][21] = "3";	qs[16][22] = "3";	qs[16][23] = "3";	qs[16][24] = "3";
		qs[16][25] = "3";	qs[16][26] = "3";	qs[16][27] = "3";	qs[16][28] = "3";	qs[16][29] = "3";	qs[16][30] = "3";	qs[16][3] = "1";
		qs[16][31] = "3";	qs[16][32] = "3";	qs[16][33] = "3";	qs[16][34] = "3";	qs[16][5] = "1";	qs[16][6] = "1";
		
		qs[17][1] = "1";	qs[17][2] = "1";	qs[17][11] = "3";	qs[17][12] = "3";	qs[17][13] = "3";	qs[17][14] = "3";	qs[17][4] = "1";
		qs[17][5] = "1";	qs[17][15] = "3";
		
		qs[18][1] = "1";	qs[18][11] = "3";	qs[18][2] = "1";	qs[18][12] = "3";	qs[18][3] = "1";	qs[18][13] = "3";
		qs[18][4] = "2";	qs[18][14] = "3";
		
		qs[19][1] = "3";	qs[19][2] = "3";	qs[19][3] = "3";	qs[19][4] = "3";	qs[19][5] = "3";	qs[19][6] = "3";	qs[19][7] = "3";
		
		qs[20][1] = "1";	qs[20][2] = "2";	qs[20][11] = "3";
		
		qs[21][1] = "1";	qs[21][2] = "2";	qs[21][11] = "3";	qs[21][3] = "1";	qs[21][21] = "3";	qs[21][22] = "3";	qs[21][23] = "3";
		qs[21][24] = "3";	qs[21][25] = "3";	qs[21][26] = "3";	qs[21][27] = "3";	qs[21][28] = "3";	qs[21][29] = "3";	qs[21][30] = "3";
		qs[21][5] = "2";	qs[21][12] = "3";	qs[21][13] = "3";	qs[21][14] = "3";	qs[21][7] = "1";	qs[21][15] = "3";	qs[21][31] = "3";
		qs[21][32] = "3";	qs[21][33] = "3";	qs[21][34] = "3";	qs[21][35] = "3";	qs[21][36] = "3";	qs[21][9] = "1";
		
		qs[22][1] = "1";	qs[22][2] = "1";	qs[22][3] = "1";	qs[22][4] = "1";	qs[22][11] = "3";
		
		qs[23][1] = "2";	qs[23][19] = "3";	qs[23][11] = "3";	qs[23][12] = "3";	qs[23][13] = "3";	qs[23][14] = "3";	qs[23][15] = "3";
		qs[23][16] = "3";
		
		qs[24][1] = "1";	qs[24][2] = "3";	qs[24][11] = "3";	qs[24][12] = "3";	qs[24][13] = "3";	qs[24][4] = "1";	qs[24][14] = "3";
		qs[24][5] = "2";	qs[24][15] = "3";	qs[24][6] = "2";	qs[24][16] = "3";
		
		qs[25][1] = "1";	qs[25][2] = "1";	qs[25][3] = "1";	qs[25][4] = "1";	qs[25][5] = "1";	qs[25][6] = "1";	qs[25][7] = "1";
		qs[25][8] = "1";	qs[25][9] = "1";	qs[25][10] = "1";	qs[25][11] = "1";	qs[25][12] = "1";	qs[25][14] = "1";
		qs[25][15] = "1";	qs[25][16] = "1";	qs[25][17] = "1";	qs[25][18] = "1";	qs[25][19] = "1";	qs[25][20] = "1";	qs[25][21] = "1";
		qs[25][22] = "1";	qs[25][23] = "1";	qs[25][24] = "1";	qs[25][25] = "1";	qs[25][26] = "1";	qs[25][27] = "1";	qs[25][28] = "1";
		
		qs[26][1] = "3";
		
	// 1 = 라디오 버튼 		// 2 = 체크박스 		// 3 = 주관식
	} else if (qType.equals("Const")) {
		qs[5][1] = "1";
		
		qs[6][1] = "3";	qs[6][2] = "3";	qs[6][3] = "3";	qs[6][4] = "3";	qs[6][5] = "3";	qs[6][6] = "3";
		
		qs[7][1] = "3";	qs[7][2] = "3";	qs[7][3] = "3";	qs[7][4] = "3";
		
		qs[8][1] = "3";	qs[8][2] = "3";	qs[8][3] = "3";
		
		qs[9][1] = "1";
		
		qs[10][1] = "1";
		
		qs[11][1] = "1";	qs[11][21] = "3";	qs[11][2] = "1";	qs[11][3] = "1";	qs[11][22] = "3";	qs[11][23] = "3";	qs[11][24] = "3";
		qs[11][25] = "3";	qs[11][26] = "3";	qs[11][5] = "1";	qs[11][27] = "3";	qs[11][6] = "1";	qs[11][7] = "1";	qs[11][28] = "3";
		
		qs[12][1] = "1";	qs[12][11] = "1";	qs[12][12] = "1";	qs[12][13] = "1";	qs[12][14] = "1";	qs[12][15] = "1";	qs[12][16] = "1";
		qs[12][17] = "1";	qs[12][18] = "1";	qs[12][3] = "1";	qs[12][21] = "3";	qs[12][4] = "1";	qs[12][22] = "3";	qs[12][5] = "1";
		qs[12][23] = "3";	qs[12][6] = "1";	qs[12][24] = "3";
		
		qs[13][1] = "1";	qs[13][2] = "1";	qs[13][11] = "3";
		
		qs[14][1] = "1";	qs[14][2] = "2";	qs[14][11] = "3";	qs[14][3] = "1";
		
		qs[15][1] = "1";	qs[15][2] = "2";	qs[15][11] = "3";
		
		qs[16][1] = "1";	qs[16][2] = "2";	qs[16][11] = "3";
		
		qs[17][1] = "1";	qs[17][2] = "1";	qs[17][11] = "3";
		
		qs[18][1] = "1";	qs[18][11] = "3";	qs[18][21] = "3";	qs[18][22] = "3";	qs[18][23] = "3";	qs[18][24] = "3";	qs[18][25] = "3";
		qs[18][26] = "3";	qs[18][27] = "3";	qs[18][28] = "3";	qs[18][29] = "3";	qs[18][30] = "3";	qs[18][20] = "3";	qs[18][3] = "1";
		qs[18][31] = "3";	qs[18][32] = "3";	qs[18][33] = "3";	qs[18][34] = "3";	qs[18][35] = "3";	qs[18][5] = "1";	qs[18][6] = "1";
		qs[18][7] = "1";	qs[18][12] = "3";
		
		qs[19][1] = "3";	qs[19][2] = "2";	qs[19][11] = "3";
		
		qs[20][1] = "1";	qs[20][2] = "1";	qs[20][11] = "3";	qs[20][12] = "3";	qs[20][13] = "3";	qs[20][14] = "3";	qs[20][4] = "1";
		qs[20][5] = "1";	qs[20][15] = "3";
		
		qs[21][1] = "1";	qs[21][11] = "3";	qs[21][2] = "1";	qs[21][12] = "3";	qs[21][3] = "1";	qs[21][13] = "3";
		qs[21][4] = "2";	qs[21][14] = "3";
		
		qs[22][1] = "1";	qs[22][2] = "1";	qs[22][3] = "1";	qs[22][4] = "1";	qs[22][5] = "1";	qs[22][6] = "3";
		
		qs[23][1] = "3";	qs[23][2] = "3";	qs[23][3] = "3";	qs[23][4] = "3";	qs[23][5] = "3";	qs[23][6] = "3";	qs[23][7] = "3";
		
		qs[24][1] = "1";	qs[24][2] = "2";	qs[24][11] = "3";
		
		qs[25][1] = "1";	qs[25][2] = "2";	qs[25][11] = "3";	qs[25][3] = "1";	qs[25][21] = "3";	qs[25][22] = "3";	qs[25][23] = "3";
		qs[25][24] = "3";	qs[25][25] = "3";	qs[25][26] = "3";	qs[25][27] = "3";	qs[25][28] = "3";	qs[25][29] = "3";	qs[25][30] = "3";
		qs[25][5] = "2";	qs[25][12] = "3";	qs[25][13] = "3";	qs[25][14] = "3";	qs[25][7] = "1";	qs[25][15] = "3";	qs[25][31] = "3";
		qs[25][32] = "3";	qs[25][33] = "3";	qs[25][34] = "3";	qs[25][35] = "3";	qs[25][36] = "3";	qs[25][9] = "1";
		
		qs[26][1] = "1";	qs[26][2] = "1";	qs[26][3] = "1";	qs[26][4] = "1";	qs[26][11] = "3";
		
		qs[27][1] = "2";	qs[27][19] = "3";	qs[27][11] = "3";	qs[27][12] = "3";	qs[27][13] = "3";	qs[27][14] = "3";	qs[27][15] = "3";
		qs[27][16] = "3";
		
		qs[28][1] = "1";	qs[28][2] = "3";	qs[28][11] = "3";	qs[28][12] = "3";	qs[28][13] = "3";	qs[28][4] = "1";	qs[28][14] = "3";
		qs[28][5] = "2";	qs[28][15] = "3";	qs[28][6] = "2";	qs[28][16] = "3";
		
		qs[29][1] = "1";	qs[29][2] = "1";	qs[29][3] = "1";	qs[29][4] = "1";	qs[29][5] = "1";	qs[29][6] = "1";	qs[29][7] = "1";
		qs[29][8] = "1";	qs[29][9] = "1";	qs[29][10] = "1";	qs[29][11] = "1";	qs[29][12] = "1";	qs[29][14] = "1";
		qs[29][15] = "1";	qs[29][16] = "1";	qs[29][17] = "1";	qs[29][18] = "1";	qs[29][19] = "1";	qs[29][20] = "1";	qs[29][21] = "1";
		qs[29][22] = "1";	qs[29][23] = "1";	qs[29][24] = "1";	qs[29][25] = "1";	qs[29][26] = "1";	qs[29][27] = "3";	qs[29][28] = "3";
		
		qs[31][1] = "3";
	}
	// 용역 항목 // 1 = 라디오 버튼 		// 2 = 체크박스 		// 3 = 주관식
	else if (qType.equals("Srv")) {
		qs[5][1] = "1";
		
		qs[6][1] = "3";	qs[6][2] = "3";	qs[6][3] = "3";	qs[6][4] = "3";	qs[6][5] = "3";	qs[6][6] = "3";
		
		qs[7][1] = "3";	qs[7][2] = "3";	qs[7][3] = "3";	qs[7][4] = "3";
		
		qs[8][1] = "3";	qs[8][2] = "3";	qs[8][3] = "3";
		
		qs[9][1] = "1";
		
		qs[10][1] = "1";
		
		qs[11][1] = "1";	qs[11][21] = "3";	qs[11][2] = "1";	qs[11][3] = "1";	qs[11][22] = "3";	qs[11][23] = "3";	qs[11][24] = "3";
		qs[11][25] = "3";	qs[11][26] = "3";	qs[11][5] = "1";	qs[11][27] = "3";	qs[11][6] = "1";	qs[11][7] = "1";	qs[11][28] = "3";
		
		qs[12][1] = "1";	qs[12][11] = "1";	qs[12][12] = "1";	qs[12][13] = "1";	qs[12][14] = "1";	qs[12][15] = "1";	qs[12][16] = "1";
		qs[12][17] = "1";	qs[12][18] = "1";	qs[12][19] = "1";	qs[12][20] = "1";	qs[12][3] = "1";	qs[12][21] = "3";
		
		qs[13][1] = "1";	qs[13][2] = "2";	qs[13][11] = "3";
		
		qs[14][1] = "1";	qs[14][2] = "2";	qs[14][11] = "3";
		
		qs[15][1] = "1";	qs[15][2] = "2";	qs[15][11] = "3";
		
		qs[16][1] = "1";	qs[16][11] = "3";	qs[16][21] = "3";	qs[16][22] = "3";	qs[16][23] = "3";	qs[16][24] = "3";
		qs[16][25] = "3";	qs[16][26] = "3";	qs[16][27] = "3";	qs[16][28] = "3";	qs[16][29] = "3";	qs[16][30] = "3";	qs[16][3] = "1";
		qs[16][31] = "3";	qs[16][32] = "3";	qs[16][33] = "3";	qs[16][34] = "3";	qs[16][5] = "1";	qs[16][6] = "1";
		
		qs[17][1] = "1";	qs[17][2] = "1";	qs[17][11] = "3";	qs[17][12] = "3";	qs[17][13] = "3";	qs[17][14] = "3";	qs[17][4] = "1";
		qs[17][5] = "1";	qs[17][15] = "3";
		
		qs[18][1] = "1";	qs[18][11] = "3";	qs[18][2] = "1";	qs[18][12] = "3";	qs[18][3] = "1";	qs[18][13] = "3";
		qs[18][4] = "2";	qs[18][14] = "3";
		
		qs[19][1] = "3";	qs[19][2] = "3";	qs[19][3] = "3";	qs[19][4] = "3";	qs[19][5] = "3";	qs[19][6] = "3";	qs[19][7] = "3";
		
		qs[20][1] = "1";	qs[20][2] = "2";	qs[20][11] = "3";
		
		qs[21][1] = "1";	qs[21][2] = "2";	qs[21][11] = "3";	qs[21][3] = "1";	qs[21][21] = "3";	qs[21][22] = "3";	qs[21][23] = "3";
		qs[21][24] = "3";	qs[21][25] = "3";	qs[21][26] = "3";	qs[21][27] = "3";	qs[21][28] = "3";	qs[21][29] = "3";	qs[21][30] = "3";
		qs[21][5] = "2";	qs[21][12] = "3";	qs[21][13] = "3";	qs[21][14] = "3";	qs[21][7] = "1";	qs[21][15] = "3";	qs[21][31] = "3";
		qs[21][32] = "3";	qs[21][33] = "3";	qs[21][34] = "3";	qs[21][35] = "3";	qs[21][36] = "3";	qs[21][9] = "1";
		
		qs[22][1] = "1";	qs[22][2] = "1";	qs[22][3] = "1";	qs[22][4] = "1";	qs[22][11] = "3";
		
		qs[23][1] = "2";	qs[23][19] = "3";	qs[23][11] = "3";	qs[23][12] = "3";	qs[23][13] = "3";	qs[23][14] = "3";	qs[23][15] = "3";
		qs[23][16] = "3";
		
		qs[24][1] = "1";	qs[24][2] = "3";	qs[24][11] = "3";	qs[24][12] = "3";	qs[24][13] = "3";	qs[24][4] = "1";	qs[24][14] = "3";
		qs[24][5] = "2";	qs[24][15] = "3";	qs[24][6] = "2";	qs[24][16] = "3";
		
		qs[25][1] = "1";	qs[25][2] = "1";	qs[25][3] = "1";	qs[25][4] = "1";	qs[25][5] = "1";	qs[25][6] = "1";	qs[25][7] = "1";
		qs[25][8] = "1";	qs[25][9] = "1";	qs[25][10] = "1";	qs[25][11] = "1";	qs[25][12] = "1";	qs[25][14] = "1";
		qs[25][15] = "1";	qs[25][16] = "1";	qs[25][17] = "1";	qs[25][18] = "1";	qs[25][19] = "1";	qs[25][20] = "1";	qs[25][21] = "1";
		qs[25][22] = "1";	qs[25][23] = "1";	qs[25][24] = "1";	qs[25][25] = "1";	qs[25][26] = "1";	qs[25][27] = "1";	qs[25][28] = "1";
		
		qs[26][1] = "3";
	}
	
	sqls1="";
	sqls2="";
	sqls1="mng_no";
	sqls2="'"+ckMngNo+"'";
	sqls1+=", current_year";
	sqls2+=", '"+sOentYYYY+"'";
	sqls1+=", oent_gb";
	sqls2+=", '"+sOentGB+"'";
	sqls1+=", sent_no";
	sqls2+=", "+sSentNo;
	sqlsour1=sqls1;
	sqlsour2=sqls2;	

	for(int i=1; i<35; i++) {
		for(int j=1; j < 40; j++) {
			sqls1=sqlsour1;
			sqls2=sqlsour2;
			
			bexe="no";
			sqls1+=", soent_q_cd";
			sqls2+=", "+i;
			sqls1+=", soent_q_gb";
			sqls2+=", "+j;
			if (null == qs[i][j]) {
				continue;
			}
			if( qs[i][j] != null && qs[i][j].equals("1") ) {
				if(!StringUtil.checkNull(request.getParameter("q2_"+i+"_"+j)).trim().equals("")) {
					bexe="yes";
					sqls1+=", "+abcf(request.getParameter("q2_"+i+"_"+j));
					sqls2+=", '1'";
				}
			} 
			if( qs[i][j] != null && qs[i][j].equals("2") ) {
				for(int l=1;l <= 23; l++) {
					if(!StringUtil.checkNull(request.getParameter("q2_"+i+"_"+j+"_"+l)).trim().equals("")) {
						bexe="yes";
						String abc = abcf(l+"");
						if ((abc + "").length() <= 0) {
							continue;
						}
						sqls1+=", "+abc;
						sqls2+=", '1'";
					}
				}
			} 
			if( qs[i][j] != null && qs[i][j].equals("3") ) {
				if(!StringUtil.checkNull(request.getParameter("q2_"+i+"_"+j)).trim().equals("")) {
					bexe="yes";
					sqls1+=", subj_ans";
					String temp = StringUtil.checkNull(request.getParameter("q2_"+i+"_"+j)).trim().replaceAll("'","''");
					String temp1 = temp;
					sqls2+=", '"+temp1+"'";
				}
			}			
			if( bexe.equals("yes") ) {
				sqls1+=", REG_DATE, remote_ip";
				sqls2+=", SYSDATE,'" + sRemoteIp +"'";

				sSQLs="INSERT INTO HADO_TB_SOENT_ANSWER_"+sOentYYYY+" ("+sqls1+") VALUES ("+sqls2+")";

				try {
					resource2	= new ConnectionResource2();
					conn2		= resource2.getConnection();
					pstmt		= conn2.prepareStatement(sSQLs);
					updateCNT	= pstmt.executeUpdate();
					
				} catch(Exception e) {
					e.printStackTrace();
					System.out.println("is ORA-00942 at 03_answer_save? : "+sSQLs);
				} finally {
					if (rs != null)		try{rs.close();}	catch(Exception e){}
					if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
					if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
					if (resource2 != null) resource2.release();
				}
				bexe = "no";
			}
		}
	}
				
	//2015-07-09 / 강슬기/ 조사표 작성 후에도 바로 전송처리되도록 변경 
	/*sSQLs="UPDATE HADO_TB_Subcon_"+sOentYYYY+" SET Sent_Status='1' \n";
	sSQLs+=", remote_ip='" + sRemoteIp + "' \n";
	sSQLs+=", writer_date=sysdate \n";
	// 20110923 - KS Jung - 콜센터관리툴 관련 파라메터
	if( sMngType!=null && sMngType!="") {
		sSQLs+=", Admin_Insert_GB='1' \n";
		sSQLs+=", SP_FLD_02='"+sMngType+"' \n";
	}
	sSQLs+=" WHERE Child_Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";
	
	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
		System.out.println("is ORA-00942 at End of state? : "+sSQLs);
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}*/
	
	sReturnURL	= "WB_VP_Subcon_0" + sOentGB+"_03.jsp?isSaved=1";

/*관리자화면에서 입력시******************************
if request("sql")="constinput" or request("sql")="prodinput" or request("sql")="serviceinput" then
	'if trim(request.cookies("uid"))="fair" then
	if sMngFlag = "manager" then
		sqls = sqls+", admin_insert_gb='1'"
	end if
end if
'************************************************/	
/*=====================================================================================================*/	
// 전송처리
} else if (qStep.equals("End")) {	
	sSQLs="UPDATE HADO_TB_Subcon_"+sOentYYYY+" SET Sent_Status='1' \n";
	sSQLs+=", remote_ip='" + sRemoteIp + "' \n";
	sSQLs+=", writer_date=sysdate \n";
	// 20110923 - KS Jung - 콜센터관리툴 관련 파라메터
	if( sMngType!=null && sMngType!="") {
		sSQLs+=", Admin_Insert_GB='1' \n";
		sSQLs+=", SP_FLD_02='"+sMngType+"' \n";
	}
	sSQLs+=" WHERE Child_Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";
	//System.out.println(sSQLs);
	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
		System.out.println("is ORA-00942 at End of state? : "+sSQLs);
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}

	// 20150713 / 강슬기 / 추가설문조사페이지로 페이지 리턴
	sReturnURL	= "WB_VP_Subcon_Add.jsp";
	//sReturnURL	= "WB_VP_Subcon_0" + sOentGB+"_04.jsp?isEnded=ok";

/*=====================================================================================================*/	
// 추가설문조사 전송처리
} else if (qStep.equals("Add")) {

	// 기존 답변 삭제
	sSQLs="DELETE FROM HADO_TB_SOENT_ANSWER_ADD \n";
	sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";
	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}	
	// 배열 초기화
	for(int ni = 1; ni < 31; ni++) {
		for(int nj = 1; nj < 12; nj++) {
			qs[ni][nj] = "0";
		}
	}
	for(int ni = 0; ni < 24; ni++) {
		q[ni] = 0;
	}
	
		// 조사표 문항별 속성 설정
		// 1 = 라디오 버튼
		// 2 = 체크박스
		// 3 = 주관식
		qs[1][1] = "1";
		qs[1][2] = "1";
		qs[1][3] = "1";
		qs[1][4] = "1";
		qs[1][5] = "1";
		qs[1][6] = "1";
		qs[1][7] = "1";
		qs[1][8] = "1";
		qs[1][9] = "1";
		qs[1][10] = "1";
		qs[1][11] = "1";
		qs[1][12] = "1";
		qs[1][13] = "1";
		qs[2][14] = "1";
		qs[2][15] = "1";
		qs[2][16] = "1";
		qs[2][17] = "1";
		qs[3][18] = "1";
		qs[3][19] = "1";
		qs[3][20] = "1";
		qs[3][21] = "1";
		
		sqls1="";
		sqls2="";
		sqls1="mng_no";
		sqls2="'"+ckMngNo+"'";
		sqls1+=", current_year";
		sqls2+=", '"+sOentYYYY+"'";
		sqls1+=", oent_gb";
		sqls2+=", '"+sOentGB+"'";
		sqls1+=", sent_no";
		sqls2+=", "+sSentNo;
		sqlsour1=sqls1;
		sqlsour2=sqls2;	

	for(int i=1; i< 31; i++) {
		for(int j=1; j < 30; j++) {
			if (null == qs[i][j]) {
				continue;
			}
			sqls1=sqlsour1;
			sqls2=sqlsour2;
			
			bexe="no";
			sqls1+=", soent_q_cd";
			sqls2+=", "+i;
			sqls1+=", soent_q_gb";
			sqls2+=", "+j;
			if( qs[i][j].equals("1") ) {
				if(!StringUtil.checkNull(request.getParameter("q"+i+"_"+j)).trim().equals("")) {
					bexe="yes";
					sqls1+=", "+abcf(request.getParameter("q"+i+"_"+j));
					sqls2+=", '1'";
				}
			} else if( qs[i][j].equals("2") ) {
				for(int l=1;l <= 23; l++) {
					if(!StringUtil.checkNull(request.getParameter("q"+i+"_"+j+"_"+l)).trim().equals("")) {
						bexe="yes";
						sqls1+=", "+abcf(l+"");
						sqls2+=", '1'";
					}
				}
			} else if( qs[i][j].equals("3") ) {
				if(!StringUtil.checkNull(request.getParameter("q"+i+"_"+j+"_20")).trim().equals("")) {
					bexe="yes";
					sqls1+=", subj_ans";
					String temp = StringUtil.checkNull(request.getParameter("q"+i+"_"+j+"_20")).trim().replaceAll("'","''");
					String temp1 = temp;
					sqls2+=", '"+temp1+"'";
				}
			}			
			if( bexe.equals("yes") ) {

				sqls1+=", REG_DATE, remote_ip";
				sqls2+=", SYSDATE,'" + sRemoteIp +"'";

				sSQLs="INSERT INTO HADO_TB_SOENT_ANSWER_ADD ("+sqls1+") VALUES ("+sqls2+")";

				try {
					resource2	= new ConnectionResource2();
					conn2		= resource2.getConnection();
					pstmt		= conn2.prepareStatement(sSQLs);
					updateCNT	= pstmt.executeUpdate();

				} catch(Exception e) {
					e.printStackTrace();
				} finally {
					if (rs != null)		try{rs.close();}	catch(Exception e){}
					if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
					if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
					if (resource2 != null) resource2.release();
				}
				bexe = "no";
			}
		}
	}

	sReturnURL	= "WB_VP_Subcon_Add.jsp?isSaved=1";
/*=====================================================================================================*/	
// 로그인차단
} else if (qStep.equals("Block")) {	
	sSQLs="UPDATE HADO_TB_Security_"+sOentYYYY+" SET Dont_Login='Y' \n";
	sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";
	sSQLs+="AND Ent_GB='2' \n";
	
	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();

	} catch(Exception e) {
		e.printStackTrace();
		System.out.println("is ORA-00942 at login_block? : "+sSQLs);
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}
//	sReturnURL	= "../index.jsp";

	sReturnURL	= "WB_VP_Subcon_Add.jsp";
}
 else if (qStep.equals("Block2")) {	

	sSQLs="UPDATE HADO_TB_Security_"+sOentYYYY+" SET Dont_Login='Y' \n";

	sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";
	sSQLs+="AND Ent_GB='2' \n";
	
	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();

	} catch(Exception e) {
		e.printStackTrace();
		System.out.println("is ORA-00942 at login_block? : "+sSQLs);
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}
	sReturnURL	= "../index.jsp";


}
%>

<html>
<head>
	<title>Untitled</title>
</head>
<body>
<%-- <%= "* 정보저장중입니다. (잠시만 기다려 주십시오) ==>"+sErrorMsg.replaceAll("\n", "<br>")%> --%>

<Script type="text/javascript">
//<![CDATA[
	<% if(!sErrorMsg.equals("")) { %>

		alert("<%= sErrorMsg%>");

	<% } %>
	<%if (qStep.equals("End")) {%>
		<% if(sErrorMsg.equals("")) { %>
			alert("조사표 전송이 완료 되었습니다.");
		<% } %>
	<%}%>
	this.parent.location.replace("<%= sReturnURL%>");
//]]
</Script>
</body>
</html>



<%@ include file="/Include/WB_I_Function.jsp"%>
