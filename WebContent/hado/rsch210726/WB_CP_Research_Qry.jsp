<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 2014년 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_CP_Research_Qry.jsp
* 프로그램설명	: 입력정보 등록
* 프로그램버전	: 3.0.1-2014
* 최초작성일자	: 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
* 2014-09-14		정광식       최초작성
* 2014-09-24		정광식	      오류수정 (답변 변경시 초기화 문항 적용)
* 2016-04-11		박원영	      페이지 인코딩 추가
* 2021-07-24        정용덕      조사제외 대상 항목 선택 추가
*/
/* 페이지 인코딩 추가 */
request.setCharacterEncoding("euc-kr");
response.setContentType("text/html; charset=euc-kr;");
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<%@ include file="../Include/WB_Inc_chkSession.jsp"%>

<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String[][] arrQS	= new String[41][51];
	String[][] arrTmp	= new String[5][15];
	String[][] arrType	= new String[4][9];
	String[][] arrTerm	= new String[4][9];

	String sErrorMsg	= "";						//오류메시지
	String sReturnURL 	= "/index.jsp";				//이동URL(상대주소)
	String qType		= StringUtil.checkNull(request.getParameter("type"));
	String qStep		= StringUtil.checkNull(request.getParameter("step"));

	// Cookie Request
	String sMngNo		= ckMngNo;
	String sCurrentYear	= ckCurrentYear;
	String sOentGB		= ckOentGB;

	ConnectionResource resource		= null;
	Connection conn					= null;
	PreparedStatement pstmt			= null;
	ResultSet rs					= null;
	ConnectionResource2 resource2	= null;
	Connection conn2				= null;

	String sSQLs		= "";
	String sTmp_Area	= "";
	String sTmpi		= "";
	String sTableName	= "";	// 임시저장 기능을 위한 테이블명 저장 / 20100507 / 정광식
	String sRemoteIp = request.getRemoteAddr();	// 접속지IP 정보
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/

// 회사개요
if (qStep.equals("Basic") || qStep.equals("Expt")) {
	// 사업지 지역 우편번호에서 가져오기
	String sOentName = request.getParameter("rcomp")==null ? "":request.getParameter("rcomp").trim();
	String sOentCaptine = request.getParameter("rowner")==null ? "":request.getParameter("rowner").trim();
	//String sZipCode1 = request.getParameter("rpost1")==null ? "":request.getParameter("rpost1").trim();
	//String sZipCode2 = request.getParameter("rpost2")==null ? "":request.getParameter("rpost2").trim();
	String sZipCode = request.getParameter("rpost")==null ? "":request.getParameter("rpost").trim();
	String sEmail1 = request.getParameter("remail1")==null ? "":request.getParameter("remail1").trim().replaceAll("'", "''");
	String sEmail2 = request.getParameter("remail2")==null ? "":request.getParameter("remail2").trim().replaceAll("'", "''");
	String sTmp_ZipCode = "";
	String sTmp_mail = "";
	/*if( !sZipCode1.equals("") && !sZipCode2.equals("") ) sTmp_ZipCode = sZipCode1 + "-" + sZipCode2;*/
	if( !sEmail1.equals("")  && !sEmail2.equals("") ) sTmp_mail = sEmail1 + "@" + sEmail2;
	
	String sTmp_incorp = "";
	String sIncorp1 = request.getParameter("rincorp1")==null ? "":request.getParameter("rincorp1").trim().replaceAll("'", "''");
	String sIncorp2 = request.getParameter("rincorp2")==null ? "":request.getParameter("rincorp2").trim().replaceAll("'", "''");
	if( !sIncorp1.equals("")  && !sIncorp2.equals("") ) sTmp_incorp = sIncorp1 + "-" + sIncorp2;
  
    String rnoexptVal = request.getParameter("q0")==null ? "": request.getParameter("q0").trim();

  
	// 조사표(회사의 개요) 저장 : 정보 업데이트 (선정정보 DB 존재)
	sSQLs  ="UPDATE HADO_TB_Oent_"+sCurrentYear+" SET \n";
	sSQLs+="	Oent_Name='"+sOentName+"', \n";
	sSQLs+="	Oent_Type='"+request.getParameter("roenttype").trim().replaceAll("'", "''")+"', \n";
	sSQLs+="	Oent_Captine='"+sOentCaptine+"', \n";
	sSQLs+="	Zip_Code='"+sZipCode+"', \n";
	sSQLs+="	Assign_Mail='"+sTmp_mail+"', \n";
	sSQLs+="	Oent_Address='"+request.getParameter("raddr").trim().replaceAll("'", "''")+"', \n";
	sSQLs+="	Oent_Tel='"+request.getParameter("mtel01").trim().replaceAll("'", "''")+"', \n";
	sSQLs+="	Oent_Co_GB='"+request.getParameter("rcogb").trim().replaceAll("'", "''")+"', \n";
	sSQLs+="	Oent_Co_No='"+request.getParameter("rlawno").trim().replaceAll("'", "''")+"', \n";
	sSQLs+="	Oent_Sa_No='"+request.getParameter("rregno").trim().replaceAll("'", "''")+"', \n";
	sSQLs+="	Writer_name='"+request.getParameter("rname").trim().replaceAll("'", "''")+"', \n";
	sSQLs+="	Writer_Org='"+request.getParameter("rdept").trim().replaceAll("'", "''")+"', \n";
	sSQLs+="	Writer_Jikwi='"+request.getParameter("rposition").trim().replaceAll("'", "''")+"', \n";
	sSQLs+="	Writer_Tel='"+request.getParameter("rtel").trim().replaceAll("'", "''")+"', \n";
	sSQLs+="	Oent_Incorp='"+sTmp_incorp+"', \n"; // 2020년도 추가
	sSQLs+="	oent_mutual_name='"+request.getParameter("mutualName").trim()+"', \n";
	
	// 조사제외 대상 선택 항목 업데이트
//	sSQLs+="	sp_fld_02='"+request.getParameter("rnoexptVal").trim()+"', \n";
	sSQLs+="	sp_fld_02='"+rnoexptVal+"', \n";

	if(!qStep.equals("Expt")) {

		sSQLs+="	Comp_Status='"+request.getParameter("q1").trim()+"', \n";
		sSQLs+="	sp_fld_03='"+request.getParameter("q1Etc").trim()+"', \n";
	
		sSQLs+="	Oent_Capa='"+request.getParameter("q2").trim()+"', \n";
		//sSQLs+="	sp_fld_05='"+request.getParameter("q2Etc").trim()+"', \n";
	
		sSQLs+="	Oent_Sale01="+request.getParameter("q3_1").trim().replaceAll(",", "")+", \n";
		sSQLs+="	Oent_Sale02="+request.getParameter("q3_2").trim().replaceAll(",","")+", \n";
		sSQLs+="	Oent_SSale="+request.getParameter("q3_3").trim().replaceAll(",","")+", \n";
	
		sSQLs+="	Oent_Oper01="+request.getParameter("q3_4").trim().replaceAll(",", "")+", \n";
		sSQLs+="	Oent_Oper02="+request.getParameter("q3_5").trim().replaceAll(",","")+", \n";
		sSQLs+="	Oent_Oper03="+request.getParameter("q3_6").trim().replaceAll(",","")+", \n";
	
		sSQLs+="	Oent_Assets="+request.getParameter("q3_7").trim().replaceAll(",", "")+", \n";
		sSQLs+="	Oent_Assets01="+request.getParameter("q3_8").trim().replaceAll(",","")+", \n";
		sSQLs+="	Oent_Assets02="+request.getParameter("q3_9").trim().replaceAll(",","")+", \n";
	
		sSQLs+="	Oent_Emp_Cnt="+request.getParameter("q4").trim().replaceAll(",","")+", \n";
		sSQLs+="	Oent_Emp_Cnt01="+request.getParameter("q4_1").trim().replaceAll(",","")+", \n";
		sSQLs+="	Oent_Emp_Cnt02="+request.getParameter("q4_2").trim().replaceAll(",","")+", \n";
	
		/* 2020년도에 회사개요가 3개업종 전부 같아짐에 따라 쿼리 통일 */
		//if (qType.equals("Prod")) {
		//} else
		if (qType.equals("Const")) { //건설개요만 시공능력평가액 추가
			sSQLs+="	oent_const_appr01="+request.getParameter("q3_10").trim().replaceAll(",", "")+", \n";
			sSQLs+="	oent_const_appr02="+request.getParameter("q3_11").trim().replaceAll(",","")+", \n";
			sSQLs+="	oent_const_appr03="+request.getParameter("q3_12").trim().replaceAll(",","")+", \n";
		}
	//else if (qType.equals("Srv")) {
	//}
	}
	sSQLs+="  remote_ip='" + sRemoteIp + "', \n";
	sSQLs+="	Write_Date=SYSDATE \n";
	sSQLs+="WHERE Mng_No='"+sMngNo+"' \n";
	sSQLs+="	AND Current_Year='"+sCurrentYear+"' \n";
	sSQLs+="	AND Oent_GB='"+sOentGB+"' \n";

	try {
		resource		= new ConnectionResource();
		conn			= resource.getConnection();
		pstmt			= conn.prepareStatement(sSQLs);
		int updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if ( rs != null )		try{rs.close();}	catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )	try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}

	// 로그인정보 회사명 수정
	sSQLs="UPDATE HADO_TB_Security_"+sCurrentYear+" SET \n";
	sSQLs+="	Oent_Name='"+StringUtil.checkNull(request.getParameter("rcomp")).trim()+"' \n";
	sSQLs+="WHERE Mng_No='"+sMngNo+"' \n";
	sSQLs+="	AND Current_Year='"+sCurrentYear+"' \n";
	sSQLs+="	AND Oent_GB='"+sOentGB+"' \n";

	try {
		resource		= new ConnectionResource();
		conn			= resource.getConnection();
		pstmt			= conn.prepareStatement(sSQLs);
		int updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if ( rs != null )		try{rs.close();}	catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )	try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}
	sReturnURL	= "WB_VP_0" + sOentGB+"_02.jsp?isSaved=1";

// 하도급거래현황
} else if (qStep.equals("Detail") || qStep.equals("Temp")) {
    
	// 대상 테이블 세팅
	if( qStep.equals("Temp") )	sTableName = "HADO_TMP_Oent_Answer_"+sCurrentYear+"";
	else sTableName = "HADO_TB_Oent_Answer_"+sCurrentYear+"";

	// 조사표 저장전 기존 정보 삭제
	sSQLs="DELETE FROM "+sTableName+" \n";
	sSQLs+="WHERE Mng_No='"+sMngNo+"' \n";
	sSQLs+="	AND Current_Year='"+sCurrentYear+"' \n";
	sSQLs+="	AND Oent_GB='"+sOentGB+"' \n";

	try {
		resource2		= new ConnectionResource2();
		conn2			= resource2.getConnection();
		pstmt			= conn2.prepareStatement(sSQLs);
		int updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if ( rs != null )		try{rs.close();}	catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
		if ( resource2 != null ) resource2.release();
	}
	// 배열 초기화
	for(int ni = 1; ni <= 40; ni++) {
		for(int nx = 1; nx <= 50; nx++) {
			arrQS[ni][nx] = "0";
		}
	}

	// 조사표 문항별 속성 설정
	// 1 = 라디오 버튼
	// 2 = 체크박스
	// 3 = 주관식
	if (qType.equals("Prod")) {		// 제조
		arrQS[5][1]	= "1";
	
		arrQS[6][1]	= "3";	arrQS[6][2]	= "3";	arrQS[6][3]	= "3";
		
		arrQS[7][1]	= "3";	arrQS[7][2]	= "3";	arrQS[7][3]	= "3";
		
		arrQS[8][1]	= "1";	
		
		arrQS[9][1]	= "3";	arrQS[9][2]	= "3";	arrQS[9][3]	= "3";	arrQS[9][4]	= "3";
		
		arrQS[10][1]	= "1";	arrQS[10][2]	= "1";	arrQS[10][3]	= "1";	arrQS[10][18]	= "3";	arrQS[10][11]	= "3";
		arrQS[10][12]	= "3";	arrQS[10][13]	= "3";	arrQS[10][14]	= "3";	arrQS[10][5]	= "1";	arrQS[10][6]	= "1";
		arrQS[10][19]	= "3";
		
		arrQS[11][11]	= "3";	arrQS[11][12]	= "3";	arrQS[11][13]	= "3";	arrQS[11][14]	= "3";	arrQS[11][15]	= "3";
		arrQS[11][16]	= "3";	arrQS[11][17]	= "3";	arrQS[11][20]	= "1";	arrQS[11][21]	= "1";	arrQS[11][22]	= "1";
		arrQS[11][23]	= "1";	arrQS[11][24]	= "1";	arrQS[11][25]	= "1";	arrQS[11][26]	= "1";	arrQS[11][27]	= "1";
		arrQS[11][28]	= "1";	arrQS[11][3]	= "1";
		
		arrQS[12][1]	= "1";	arrQS[12][2]	= "2";	arrQS[12][29]	= "3";
		
		arrQS[13][1]	= "1";	arrQS[13][2]	= "2";	arrQS[13][29]	= "3";
		
		arrQS[14][1]	= "1";	arrQS[14][2]	= "2";	arrQS[14][29]	= "3";
		
		arrQS[15][11]	= "3";	arrQS[15][12]	= "3";	arrQS[15][13]	= "3";	arrQS[15][14]	= "3";	arrQS[15][15]	= "3";
		arrQS[15][16]	= "3";	arrQS[15][17]	= "3";	arrQS[15][18]	= "3";	arrQS[15][19]	= "3";	arrQS[15][20]	= "3";
		arrQS[15][21]	= "3";	arrQS[15][22]	= "3";	arrQS[15][23]	= "3";	arrQS[15][24]	= "3";	arrQS[15][25]	= "3";
		arrQS[15][26]	= "3";	arrQS[15][27]	= "3";	arrQS[15][28]	= "3";	arrQS[15][29]	= "3";	arrQS[15][30]	= "3";
		arrQS[15][2]	= "1";	arrQS[15][31]	= "3";	arrQS[15][32]	= "3";	arrQS[15][33]	= "3";	arrQS[15][34]	= "3";
		arrQS[15][41]	= "3";	arrQS[15][42]	= "3";	arrQS[15][43]	= "3";	arrQS[15][44]	= "3";	arrQS[15][4]	= "1";
		
		arrQS[16][1]	= "1";	arrQS[16][11]	= "3";	arrQS[16][12]	= "3";	arrQS[16][13]	= "3";	arrQS[16][14]	= "3";
		arrQS[16][3]	= "1";
		
		arrQS[17][1]	= "3";	arrQS[17][2]	= "3";	arrQS[17][3]	= "3";	arrQS[17][4]	= "3";	arrQS[17][5]	= "3";
		arrQS[17][6]	= "3";	arrQS[17][7]	= "3";
		
		arrQS[18][1]	= "1";	arrQS[18][2]	= "2";	arrQS[18][29]	= "3";
		
		arrQS[19][1]	= "1";	arrQS[19][2]	= "2";	arrQS[19][11]	= "3";	arrQS[19][3]	= "2";	arrQS[19][4]	= "1";
		arrQS[19][12]	= "3";	arrQS[19][5]	= "1";	arrQS[19][6]	= "1";	arrQS[19][13]	= "3";	arrQS[19][7]	= "1";
		
		arrQS[20][1]	= "1";	arrQS[20][21]	= "3";	arrQS[20][22]	= "3";	arrQS[20][23]	= "3";	arrQS[20][3]	= "2";
		arrQS[20][39]	= "3";	arrQS[20][41]	= "1";	arrQS[20][42]	= "1";	arrQS[20][43]	= "1";	arrQS[20][44]	= "1";
		arrQS[20][45]	= "1";
		
		arrQS[21][1]	= "2";	arrQS[21][19]	= "3";	arrQS[21][2]	= "1";	arrQS[21][21]	= "3";	arrQS[21][22]	= "3";
		arrQS[21][23]	= "3";	arrQS[21][24]	= "3";	arrQS[21][25]	= "3";	arrQS[21][26]	= "3";	arrQS[21][27]	= "3";
		arrQS[21][28]	= "3";	arrQS[21][31]	= "3";	arrQS[21][32]	= "3";	arrQS[21][33]	= "3";	arrQS[21][34]	= "3";
		arrQS[21][35]	= "3";	arrQS[21][36]	= "3";	arrQS[21][37]	= "3";	arrQS[21][41]	= "1";	arrQS[21][42]	= "1";
		arrQS[21][43]	= "1";	arrQS[21][44]	= "1";	arrQS[21][45]	= "1";	arrQS[21][46]	= "1";	arrQS[21][47]	= "1";
		arrQS[21][48]	= "1";	arrQS[21][49]	= "1";	arrQS[21][7]	= "1";	arrQS[21][8]	= "1";	arrQS[21][9]	= "2";
		arrQS[21][18]	= "3";	arrQS[21][10]	= "1";	arrQS[21][11]	= "2";	arrQS[21][17]	= "3";	arrQS[21][12]	= "1";
		arrQS[21][13]	= "2";	arrQS[21][16]	= "3";
		
		arrQS[22][1]	= "3";	arrQS[22][2]	= "3";	arrQS[22][3]	= "3";	arrQS[22][4]	= "3";	arrQS[22][5]	= "3";
		arrQS[22][6]	= "3";	arrQS[22][7]	= "3";	arrQS[22][8]	= "3";	arrQS[22][9]	= "3";	arrQS[22][10]	= "3";
		arrQS[22][11]	= "3";  arrQS[22][20]   = "1";  arrQS[22][21]   = "1";  arrQS[22][22]   = "1";  arrQS[22][23]   = "1";
        arrQS[22][24]   = "1";  arrQS[22][25]   = "1";  arrQS[22][26]   = "1";  arrQS[22][27]   = "1";  arrQS[22][28]   = "1";
        arrQS[22][29]   = "1";  arrQS[22][30]   = "1";
		
		arrQS[23][1]	= "3";

	} else if (qType.equals("Const")) {	// 건설
		arrQS[5][1]	= "1";
	
		arrQS[6][1]	= "3";	arrQS[6][2]	= "3";	arrQS[6][3]	= "3";
		
		arrQS[7][1]	= "3";	arrQS[7][2]	= "3";	arrQS[7][3]	= "3";
		
		arrQS[8][1]	= "1";	
		
		arrQS[9][1]	= "3";	arrQS[9][2]	= "3";	arrQS[9][3]	= "3";	arrQS[9][4]	= "3";
		
		arrQS[10][1]	= "1";	arrQS[10][2]	= "1";	arrQS[10][3]	= "1";	arrQS[10][18]	= "3";	arrQS[10][11]	= "3";
		arrQS[10][12]	= "3";	arrQS[10][13]	= "3";	arrQS[10][14]	= "3";	arrQS[10][5]	= "1";	arrQS[10][6]	= "1";
		arrQS[10][19]	= "3";
		
		arrQS[11][20]	= "1";	arrQS[11][21]	= "1";	arrQS[11][22]	= "1";	arrQS[11][23]	= "1";	arrQS[11][24]	= "1";
		arrQS[11][25]	= "1";	arrQS[11][26]	= "1";	arrQS[11][27]	= "1";	arrQS[11][28]	= "1";
		
		arrQS[12][1]	= "1";	arrQS[12][2]	= "1";	arrQS[12][19]	= "3";
		
		arrQS[13][1]	= "1";	arrQS[13][2]	= "2";	arrQS[13][29]	= "3";	arrQS[13][3]	= "1";
		
		arrQS[14][1]	= "1";	arrQS[14][2]	= "2";	arrQS[14][19]	= "3";
		
		arrQS[15][1]	= "1";	arrQS[15][2]	= "2";	arrQS[15][19]	= "3";
		
		arrQS[16][1]	= "1";	arrQS[16][2]	= "1";	arrQS[16][19]	= "3";
		
		arrQS[17][11]	= "3";	arrQS[17][12]	= "3";	arrQS[17][13]	= "3";	arrQS[17][14]	= "3";	arrQS[17][15]	= "3";
		arrQS[17][16]	= "3";	arrQS[17][17]	= "3";	arrQS[17][18]	= "3";	arrQS[17][19]	= "3";	arrQS[17][20]	= "3";
		arrQS[17][21]	= "3";	arrQS[17][22]	= "3";	arrQS[17][23]	= "3";	arrQS[17][24]	= "3";	arrQS[17][25]	= "3";
		arrQS[17][26]	= "3";	arrQS[17][27]	= "3";	arrQS[17][28]	= "3";	arrQS[17][29]	= "3";	arrQS[17][30]	= "3";
		arrQS[17][2]	= "1";	arrQS[17][31]	= "3";	arrQS[17][32]	= "3";	arrQS[17][33]	= "3";	arrQS[17][34]	= "3";
		arrQS[17][41]	= "3";	arrQS[17][42]	= "3";	arrQS[17][43]	= "3";	arrQS[17][44]	= "3";	arrQS[17][4]	= "1";
		
		arrQS[18][1]	= "3";	arrQS[18][2]	= "3";	arrQS[18][3]	= "2";	arrQS[18][19]	= "3";
		
		arrQS[19][1]	= "1";	arrQS[19][11]	= "3";	arrQS[19][12]	= "3";	arrQS[19][13]	= "3";	arrQS[19][14]	= "3";
		arrQS[19][3]	= "1";
		
		arrQS[20][1]	= "1";	arrQS[20][2]	= "1";	arrQS[20][3]	= "1";	arrQS[20][4]	= "1";	arrQS[20][5]	= "1";
		arrQS[20][6]	= "3";
		
		arrQS[21][1]	= "3";	arrQS[21][2]	= "3";	arrQS[21][3]	= "3";	arrQS[21][4]	= "3";	arrQS[21][5]	= "3";
		arrQS[21][6]	= "3";	arrQS[21][7]	= "3";
		
		arrQS[22][1]	= "1";	arrQS[22][2]	= "2";	arrQS[22][19]	= "3";
		
		arrQS[23][1]	= "1";	arrQS[23][2]	= "2";	arrQS[23][11]	= "3";	arrQS[23][3]	= "2";	arrQS[23][4]	= "1";
		arrQS[23][12]	= "3";	arrQS[23][5]	= "1";	arrQS[23][6]	= "1";	arrQS[23][13]	= "3";	arrQS[23][7]	= "1";
		
		arrQS[24][1]	= "1";	arrQS[24][21]	= "3";	arrQS[24][22]	= "3";	arrQS[24][23]	= "3";	arrQS[24][3]	= "2";
		arrQS[24][39]	= "3";	arrQS[24][41]	= "1";	arrQS[24][42]	= "1";	arrQS[24][43]	= "1";	arrQS[24][44]	= "1";
		arrQS[24][45]	= "1";
		
		arrQS[25][1]	= "1";	arrQS[25][2]	= "1";	arrQS[25][3]	= "1";	arrQS[25][4]	= "1";	arrQS[25][5]	= "1";
		arrQS[25][6]	= "1";	arrQS[25][7]	= "1";	arrQS[25][8]	= "1";	arrQS[25][9]	= "1";	arrQS[25][10]	= "1";
		arrQS[25][11]	= "1";  arrQS[25][20]   = "1";  arrQS[25][21]   = "1";  arrQS[25][22]   = "1";  arrQS[25][23]   = "1";
        arrQS[25][24]   = "1";  arrQS[25][25]   = "1";  arrQS[25][26]   = "1";  arrQS[25][27]   = "1";  arrQS[25][28]   = "1";
        arrQS[25][29]   = "1";  arrQS[25][30]   = "1";
		
		arrQS[26][1]	= "3";

    } else if (qType.equals("Srv")) { // 용역
		arrQS[5][1]	= "1";
    
    	arrQS[6][1]	= "3";	arrQS[6][2]	= "3";	arrQS[6][3]	= "3";
		
		arrQS[7][1]	= "3";	arrQS[7][2]	= "3";	arrQS[7][3]	= "3";
		
		arrQS[8][1]	= "1";
		
		arrQS[9][1]	= "3";	arrQS[9][2]	= "3";	arrQS[9][3]	= "3";	arrQS[9][4]	= "3";
		
		arrQS[10][1]	= "1";	arrQS[10][2]	= "1";	arrQS[10][3]	= "1";	arrQS[10][18]	= "3";	arrQS[10][11]	= "3";
		arrQS[10][12]	= "3";	arrQS[10][13]	= "3";	arrQS[10][14]	= "3";	arrQS[10][5]	= "1";	arrQS[10][6]	= "1";
		arrQS[10][19]	= "3";
		
		arrQS[11][11]	= "3";	arrQS[11][12]	= "3";	arrQS[11][13]	= "3";	arrQS[11][14]	= "3";	arrQS[11][15]	= "3";
		arrQS[11][16]	= "3";	arrQS[11][17]	= "3";	arrQS[11][20]	= "1";	arrQS[11][21]	= "1";	arrQS[11][22]	= "1";
		arrQS[11][23]	= "1";	arrQS[11][24]	= "1";	arrQS[11][25]	= "1";	arrQS[11][26]	= "1";	arrQS[11][27]	= "1";
		arrQS[11][28]	= "1";	arrQS[11][3]	= "1";
		
		arrQS[12][1]	= "1";	arrQS[12][2]	= "2";	arrQS[12][29]	= "3";
		
		arrQS[13][1]	= "1";	arrQS[13][2]	= "2";	arrQS[13][29]	= "3";
		
		arrQS[14][1]	= "1";	arrQS[14][2]	= "2";	arrQS[14][29]	= "3";
		
		arrQS[15][11]	= "3";	arrQS[15][12]	= "3";	arrQS[15][13]	= "3";	arrQS[15][14]	= "3";	arrQS[15][15]	= "3";
		arrQS[15][16]	= "3";	arrQS[15][17]	= "3";	arrQS[15][18]	= "3";	arrQS[15][19]	= "3";	arrQS[15][20]	= "3";
		arrQS[15][21]	= "3";	arrQS[15][22]	= "3";	arrQS[15][23]	= "3";	arrQS[15][24]	= "3";	arrQS[15][25]	= "3";
		arrQS[15][26]	= "3";	arrQS[15][27]	= "3";	arrQS[15][28]	= "3";	arrQS[15][29]	= "3";	arrQS[15][30]	= "3";
		arrQS[15][2]	= "1";	arrQS[15][31]	= "3";	arrQS[15][32]	= "3";	arrQS[15][33]	= "3";	arrQS[15][34]	= "3";
		arrQS[15][41]	= "3";	arrQS[15][42]	= "3";	arrQS[15][43]	= "3";	arrQS[15][44]	= "3";	arrQS[15][4]	= "1";
		
		arrQS[16][1]	= "1";	arrQS[16][11]	= "3";	arrQS[16][12]	= "3";	arrQS[16][13]	= "3";	arrQS[16][14]	= "3";
		arrQS[16][3]	= "1";
		
		arrQS[17][1]	= "3";	arrQS[17][2]	= "3";	arrQS[17][3]	= "3";	arrQS[17][4]	= "3";	arrQS[17][5]	= "3";
		arrQS[17][6]	= "3";	arrQS[17][7]	= "3";
		
		arrQS[18][1]	= "1";	arrQS[18][2]	= "2";	arrQS[18][29]	= "3";
		
		arrQS[19][1]	= "1";	arrQS[19][2]	= "2";	arrQS[19][11]	= "3";	arrQS[19][3]	= "2";	arrQS[19][4]	= "1";
		arrQS[19][12]	= "3";	arrQS[19][5]	= "1";	arrQS[19][6]	= "1";	arrQS[19][13]	= "3";	arrQS[19][7]	= "1";
		
		arrQS[20][1]	= "1";	arrQS[20][21]	= "3";	arrQS[20][22]	= "3";	arrQS[20][23]	= "3";	arrQS[20][3]	= "2";
		arrQS[20][39]	= "3";	arrQS[20][41]	= "1";	arrQS[20][42]	= "1";	arrQS[20][43]	= "1";	arrQS[20][44]	= "1";
		arrQS[20][45]	= "1";
		
		arrQS[21][1]	= "3";	arrQS[21][2]	= "3";	arrQS[21][3]	= "3";	arrQS[21][4]	= "3";	arrQS[21][5]	= "3";
		arrQS[21][6]	= "3";	arrQS[21][7]	= "3";	arrQS[21][8]	= "3";	arrQS[21][9]	= "3";	arrQS[21][10]	= "3";
		arrQS[21][11]	= "3";  arrQS[21][20]   = "1";  arrQS[21][21]   = "1";  arrQS[21][22]   = "1";  arrQS[21][23]   = "1";
		arrQS[21][24]   = "1";  arrQS[21][25]   = "1";  arrQS[21][26]   = "1";  arrQS[21][27]   = "1";  arrQS[21][28]   = "1";
        arrQS[21][29]   = "1";  arrQS[21][30]   = "1";
    
		arrQS[22][1]	= "3";
	} 

	// 조사표 저장
	for(int ni = 5; ni <= 40; ni++) {
		for(int nx = 1; nx <= 50; nx++) {
			
			// 라디오
			if(arrQS[ni][nx] != null && arrQS[ni][nx].equals("1")) {
				if(!StringUtil.checkNull(request.getParameter("q2_" + ni + "_" + nx)).trim().equals("")) {
					String sTmp_FieldName = abcf(StringUtil.checkNull(request.getParameter("q2_" + ni + "_" + nx)).trim());

					sSQLs="INSERT INTO "+sTableName+" ( \n";
					sSQLs+="	Mng_No, Current_Year, Oent_GB, Oent_Q_CD, Oent_Q_GB, "+sTmp_FieldName+", Reg_Date, remote_ip \n";
					sSQLs+=") VALUES ( \n";
					sSQLs+="	'"+sMngNo+"', '"+sCurrentYear+"', '"+sOentGB+"', "+ni+", "+nx+", '1', SYSDATE, '"+sRemoteIp+"' \n";
					sSQLs+=") \n";

					try {
						resource2		= new ConnectionResource2();
						conn2			= resource2.getConnection();
						pstmt			= conn2.prepareStatement(sSQLs);
						int updateCNT	= pstmt.executeUpdate();
					} catch(Exception e) {
						e.printStackTrace();
					} finally {
						if ( rs != null )		try{rs.close();}	catch(Exception e){}
						if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
						if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
						if ( resource2 != null ) resource2.release();
					}
				}
			// 체크박스
			} else if(arrQS[ni][nx] != null && arrQS[ni][nx].equals("2")) {
				int nTmp_Cnt = 0;

				for(int np = 1; np <= 14; np++) {
					if(!StringUtil.checkNull(request.getParameter("q2_" + ni + "_" + nx + "_" + np)).trim().equals("")) {
						nTmp_Cnt++;
						arrTmp[1][nTmp_Cnt]	= abcf(""+np);
					}
				}

				if(nTmp_Cnt > 0) {
					sSQLs="INSERT INTO "+sTableName+" ( \n";
					sSQLs+="	Mng_No, Current_YEAR, Oent_GB, Oent_Q_CD, Oent_Q_GB \n";
					sSQLs+="	";
					for(int np = 1; np <= nTmp_Cnt; np++) {
						sSQLs+=", "+arrTmp[1][np];
					}
					sSQLs+="\n	, Reg_Date, remote_ip \n";
					sSQLs+=") VALUES ( \n";
					sSQLs+="	'"+sMngNo+"', '"+sCurrentYear+"', '"+sOentGB+"', " +ni+", "+nx+"\n";
					sSQLs+="	";
					for(int np = 1; np <= nTmp_Cnt; np++) {
							sSQLs+=", '1'";
					}
					sSQLs+="\n	, SYSDATE, '"+sRemoteIp+"') \n";

					try {
						resource2		= new ConnectionResource2();
						conn2			= resource2.getConnection();
						pstmt			= conn2.prepareStatement(sSQLs);
						int updateCNT	= pstmt.executeUpdate();
					} catch(Exception e) {
						e.printStackTrace();
					} finally {
						if ( rs != null )		try{rs.close();}	catch(Exception e){}
						if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
						if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
						if ( resource2 != null ) resource2.release();
					}
				}
			// 주관식
			} else if(arrQS[ni][nx] != null && arrQS[ni][nx].equals("3")) {
				
				if(!StringUtil.checkNull(request.getParameter("q2_" + ni + "_" + nx)).trim().equals("")) {
					String sTmp_FieldText	= StringUtil.checkNull(request.getParameter("q2_" + ni + "_" + nx)).trim().replaceAll("'", "''");

					sSQLs="INSERT INTO "+sTableName+" ( \n";
					sSQLs+="	Mng_No, Current_Year, Oent_GB, Oent_Q_CD, Oent_Q_GB, Subj_Ans, Reg_Date, remote_ip \n";
					sSQLs+=") VALUES ( \n";
					sSQLs+="	'"+sMngNo+"', '"+sCurrentYear+"', '"+sOentGB+"', "+ni+", "+nx+", \n";
					//sSQLs+="	'"+new String(sTmp_FieldText.getBytes("EUC-KR"), "ISO8859-1" )+"', SYSDATE, '"+sRemoteIp+"' \n";
					sSQLs+="	'"+sTmp_FieldText+"', SYSDATE, '"+sRemoteIp+"' \n";
					sSQLs+=") \n";

					try {
						resource2		= new ConnectionResource2();
						conn2			= resource2.getConnection();
						pstmt			= conn2.prepareStatement(sSQLs);
						int updateCNT	= pstmt.executeUpdate();
					} catch(Exception e){
						e.printStackTrace();
					} finally {
						if ( rs != null )		try{rs.close();}	catch(Exception e){}
						if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
						if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
						if ( resource2 != null ) resource2.release();
					}
				}
			}
		}
	}
	
/* 2020년도 실태조사에서 조사표 변경에 따른 금액 저장 안함
	// 하도급 대금 지급 저장
		// 저장전 기존저장정보 삭제 (중복첵크 프로세스 생략)
		sSQLs="DELETE FROM HADO_TB_Rec_Pay_"+sCurrentYear+" \n";
		sSQLs+="	WHERE Mng_No='"+sMngNo+"' AND Current_Year='"+sCurrentYear+"' \n";
		sSQLs+="	AND Oent_GB='"+sOentGB+"' \n";
		try {
			resource2		= new ConnectionResource2();
			conn2			= resource2.getConnection();

			pstmt			= conn2.prepareStatement(sSQLs);
			int updateCNT	= pstmt.executeUpdate();

			//System.out.println("updateCNT="+updateCNT);
			//rs.close();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if ( rs != null )		try{rs.close();}	catch(Exception e){}
			if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
			if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
			if ( resource2 != null ) resource2.release();
		}

		// 하도급대금 지급 내역
		for(int ni = 1; ni <= 4; ni++) {
			for(int nx = 1; nx <= 8; nx++) {
				arrTmp[ni][nx]	= StringUtil.checkNull(request.getParameter("q2_100_" + ni + "_" + nx)).trim().replaceAll(",", "");
				if( arrTmp[ni][nx] == null || arrTmp[ni][nx].equals("") ) arrTmp[ni][nx] = "0";
			}
			if((!arrTmp[ni][1].equals("")) || (!arrTmp[ni][2].equals("")) || (!arrTmp[ni][3].equals("")) || (!arrTmp[ni][4].equals("")) || (!arrTmp[ni][5].equals("")) || (!arrTmp[ni][6].equals("")) || (!arrTmp[ni][7].equals("")) || (!arrTmp[ni][8].equals("")) ) {
				sSQLs="INSERT INTO HADO_TB_Rec_Pay_"+sCurrentYear+" ( \n";
				sSQLs+="	Mng_No, Current_Year, Oent_GB, Oent_Q_CD, Oent_Q_GB, Rec_Pay_GB, Half_GB,  \n";
				sSQLs+="	Currency, Bill, Etc, Ent_Card, Ent_Loan, Cred_Loan, Buy_Loan, Network_Loan \n";
				sSQLs+=") VALUES ( \n";
				sSQLs+="	'"+sMngNo+"', '"+sCurrentYear+"', '"+sOentGB+"', 16, 1";
					if(ni == 1) sSQLs+=", '1', '1' \n";
					else if(ni == 2) sSQLs+=", '1', '2' \n";
					else if(ni == 3) sSQLs+=", '2', '1' \n";
					else if(ni == 4) sSQLs+=", '2', '2' \n";
				sSQLs+="	";
					sSQLs+=", "+arrTmp[ni][1];
					sSQLs+=", "+arrTmp[ni][7];
					sSQLs+=", "+arrTmp[ni][8];
					sSQLs+=", "+arrTmp[ni][2];
					sSQLs+=", "+arrTmp[ni][3];
					sSQLs+=", "+arrTmp[ni][4];
					sSQLs+=", "+arrTmp[ni][5];
					sSQLs+=", "+arrTmp[ni][6]+"\n";
				sSQLs+=") \n";
				try {
					resource2		= new ConnectionResource2();
					conn2			= resource2.getConnection();

					pstmt			= conn2.prepareStatement(sSQLs);
					int updateCNT	= pstmt.executeUpdate();

					//System.out.println("updateCNT="+updateCNT);

					//rs.close();
				} catch(Exception e) {
					e.printStackTrace();
				} finally {
					if ( rs != null )		try{rs.close();}	catch(Exception e){}
					if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
					if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
					if ( resource2 != null ) resource2.release();
				}
			}
		}
*/

		/* 2014년도에 해당 항목 조사하지 않음에 따른 주석 처리
		// 현급성 결제내역
		for(int ni = 1; ni <= 2; ni++) {
			// 결제수단별
			arrType[ni][1]	= ni+ "";
			arrType[ni][2]	= StringUtil.checkNull(request.getParameter("mA" + ni)).trim().replaceAll(",", "");
			arrType[ni][3]	= StringUtil.checkNull(request.getParameter("mB" + ni)).trim().replaceAll(",", "");
			arrType[ni][4]	= StringUtil.checkNull(request.getParameter("mC" + ni)).trim().replaceAll(",", "");
			arrType[ni][5]	= StringUtil.checkNull(request.getParameter("mD" + ni)).trim().replaceAll(",", "");
			arrType[ni][6]	= StringUtil.checkNull(request.getParameter("mE" + ni)).trim().replaceAll(",", "");
			arrType[ni][7]	= StringUtil.checkNull(request.getParameter("mF" + ni)).trim().replaceAll(",", "");
			arrType[ni][8]	= StringUtil.checkNull(request.getParameter("mG" + ni)).trim().replaceAll(",", "");

			// 보정
			if(arrType[ni][2]==null || arrType[ni][2].equals("")) arrType[ni][2] = "0";
			if(arrType[ni][3]==null || arrType[ni][3].equals("")) arrType[ni][2] = "0";
			if(arrType[ni][4]==null || arrType[ni][4].equals("")) arrType[ni][2] = "0";
			if(arrType[ni][5]==null || arrType[ni][5].equals("")) arrType[ni][2] = "0";
			if(arrType[ni][6]==null || arrType[ni][6].equals("")) arrType[ni][2] = "0";
			if(arrType[ni][7]==null || arrType[ni][7].equals("")) arrType[ni][2] = "0";
			if(arrType[ni][8]==null || arrType[ni][8].equals("")) arrType[ni][2] = "0";
		}
		// 하도급대금의 현금성 결제내역 : <표1> 결제수단별 내역 저장
		// 기존 저장정보가 있는(없어도 실행)경우 삭제후 저장 : 중복처리 프로세스 줄이기위해 선택
		try {
			resource2 = new ConnectionResource2();
			conn2 = resource2.getConnection();

			// 저장전 기존 정보 삭제
			sSQLs="DELETE FROM HADO_TB_Oent_Cash_PayType_"+sCurrentYear+" \n";
			sSQLs+="	WHERE Mng_No='"+sMngNo+"' AND Current_Year='"+sCurrentYear+"' \n";
			sSQLs+="	AND Oent_GB='"+sOentGB+"' \n";

			pstmt = conn2.prepareStatement(sSQLs);
			int updateCNT = pstmt.executeUpdate();

			//System.out.println("updateCNT="+updateCNT);

			//rs.close();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if ( rs != null )		try{rs.close();}	catch(Exception e){}
			if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
			if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
			if ( resource2 != null ) resource2.release();
		}


		for(int ni = 1; ni <= 2; ni++) {
			try {
				resource2 = new ConnectionResource2();
				conn2 = resource2.getConnection();

				sSQLs="INSERT INTO HADO_TB_Oent_Cash_PayType_"+sCurrentYear+" ( \n";
				sSQLs+="	Mng_No, Current_Year, Oent_GB, Cash_MM, \n";
				sSQLs+="	Type_Cash, Type_LocalLC, Type_BBLend, Type_BCard, Type_CreditLend, Type_Buy, Type_Network \n";
				sSQLs+=") VALUES ( \n";
				sSQLs+="	'"+ckMngNo+"', '"+ckCurrentYear+"', '"+ckOentGB+"', \n";
				sSQLs+="	"+arrType[ni][1]+", "+arrType[ni][2]+", "+arrType[ni][3]+", "+arrType[ni][4]+", \n";
				sSQLs+="	"+arrType[ni][5]+", "+arrType[ni][6]+", "+arrType[ni][7]+", "+arrType[ni][8] + "\n";
				sSQLs+=") \n";

				pstmt = conn2.prepareStatement(sSQLs);
				int updateCNT = pstmt.executeUpdate();

				//System.out.println("updateCNT="+updateCNT);

				//rs.close();
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				if ( rs != null )		try{rs.close();}	catch(Exception e){}
				if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
				if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
				if ( resource2 != null ) resource2.release();
			}
		}
		*/

	/*if (qType.equals("Prod")) {
		sReturnURL	= "ProdStep_03.jsp?isSaved=1";
	} else if (qType.equals("Const")) {
		sReturnURL	= "ConstStep_03.jsp?isSaved=1";
	} else if (qType.equals("Srv")) {
		sReturnURL	= "SrvStep_03.jsp?isSaved=1";
	}*/
	sReturnURL	= "WB_VP_0" + ckOentGB + "_03.jsp?isSaved=1";

// 조사완료
} else if (qStep.equals("End")) {
	sSQLs="UPDATE HADO_TB_Oent_"+sCurrentYear+" SET Oent_Status='1', Submit_Date=SYSDATE \n";
	sSQLs+="WHERE Mng_No='"+sMngNo+"' \n";
	sSQLs+="	AND Current_Year='"+sCurrentYear+"' \n";
	sSQLs+="	AND Oent_GB='"+sOentGB+"' \n";
//System.out.println("END>>>>"+sMngNo);
//System.out.println("END>>>>"+sCurrentYear);
//System.out.println("END>>>>"+sOentGB);
//System.out.println("END>>>>"+sSQLs);
	try {
		resource2		= new ConnectionResource2();
		conn2			= resource2.getConnection();
		pstmt			= conn2.prepareStatement(sSQLs);
		int updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if ( rs != null )		try{rs.close();}	catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
		if ( resource2 != null ) resource2.release();
	}

	/*if (qType.equals("Prod")) {
		sReturnURL	= "ProdStep_05.jsp?isEnded=ok";
	} else if (qType.equals("Const")) {
		sReturnURL	= "ConstStep_05.jsp?isEnded=ok";
	} else if (qType.equals("Srv")) {
		sReturnURL	= "SrvStep_05.jsp?isEnded=ok";
	}*/
	sReturnURL	= "WB_VP_0" + ckOentGB + "_05.jsp?isSaved=1";
}
/*=====================================================================================================*/

%>
<html>
<head>
	<title>Untitled</title>
</head>

<body>
	<%= "* 정보저장중입니다. (잠시만 기다려 주십시오) ==>"/*  + sErrorMsg.replaceAll("\n", "<br>") */%>
</body>
</html>
<Script Language="JavaScript">
<%if(!"".equals(sErrorMsg)) {%>
	alert("<%= sErrorMsg%>");
<%}%>
this.parent.location.replace("<%= sReturnURL%>");
</Script>

<%@ include file="../Include/WB_I_Function.jsp"%>