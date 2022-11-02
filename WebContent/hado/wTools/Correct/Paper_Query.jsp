<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. 프로젝트명 : 공정관리위원회 하도급거래 서면직권실태조사					                       */
/*  2. 업체정보 :																					   */
/*     - 업체명 : (주)로티스아이																	   */
/*	   - Project Manamger : 정광식 부장 (pcxman99@naver.com)										   */
/*     - 연락처 : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  3. 일자 : 2009년 5월																			   */
/*  4. 최초작성자 및 일자 : (주)로티스아이 정광식 / 2011-10-18										   */
/*  5. 업데이트내용 (내용 / 일자)																	   */
/*  6. 비고																							   */
/*		1) 웹관리툴 리뉴얼 / 2011-10-18																   */
/*-----------------------------------------------------------------------------------------------------*/
/*---------------------------------------- Variable Difinition ----------------------------------------*/

	String cmd = StringUtil.checkNull(request.getParameter("cmd"));
	
	ConnectionResource resource		= null;
	Connection conn					= null;
	PreparedStatement pstmt			= null;
	ResultSet rs					= null;
	ConnectionResource2 resource2	= null;
	Connection conn2				= null;

	String sCYear		= st_Current_Year;
	String sSQLs		= "";
	String sSQLs1		= "";
	String sSQLs2		= "";
	String sReturnURL	= "";
	String tmpStr		= "";
	String sMsg			= "";

	String ltype		= "";
	String lsu			= "";
	String lmngno		= "";
	String lyyyy		= "";
	String lgb			= "";
	int isu				= 0;

	String nregsn		= "0";
	String nactno		= "0";

	String bAction		= "T";

	int i				= 0;
	int nx				= 0;
	int updateCNT		= 0;

	ckSSOcvno			= ""+session.getAttribute("ckSSOcvno");
	ckCenterName		= ""+session.getAttribute("ckCenterName");
	ckDeptName			= ""+session.getAttribute("ckDeptName");
	ckUserName			= ""+session.getAttribute("ckUserName");
	ckPhoneNo			= ""+session.getAttribute("ckPhoneNo");
	ckPermision			= ""+session.getAttribute("ckPermision");

	java.util.Calendar cal = java.util.Calendar.getInstance();

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2 = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	if( cmd.equals("surveyDelete") ) {
		lmngno	= StringUtil.checkNull(request.getParameter("sur_omngno"));
		lyyyy	= StringUtil.checkNull(request.getParameter("sur_oyyyy"));
		lgb		= StringUtil.checkNull(request.getParameter("sur_ogb"));

		sSQLs ="DELETE FROM HADO_TB_Survey_CTX3 \n";
		sSQLs+="WHERE mng_no=? AND current_year=? AND oent_gb=? \n"; 

		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();

			pstmt = conn.prepareStatement(sSQLs);
			pstmt.setString(1,lmngno);
			pstmt.setString(2,lyyyy);
			pstmt.setString(3,lgb);
			updateCNT = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(rs!=null)		try{rs.close();}	catch(Exception e){}
			if(pstmt!=null)		try{pstmt.close();}	catch(Exception e){}
			if(conn!=null)		try{conn.close();}	catch(Exception e){}
			if(resource!=null)	resource.release();
		}

	} else if( cmd.equals("surveyinput") ) {
		lmngno	= StringUtil.checkNull(request.getParameter("sur_omngno"));
		lyyyy	= StringUtil.checkNull(request.getParameter("sur_oyyyy"));
		lgb		= StringUtil.checkNull(request.getParameter("sur_ogb"));
		ltype	= StringUtil.checkNull(request.getParameter("h_sctx"));
		lsu		= StringUtil.checkNull(request.getParameter("h_ctxsu2"));
		isu		= Integer.parseInt(lsu);


		// 등록코드 관리자 권한여부 확인
		if( tmpStr.equals("0") && ckPermision.equals("P") ) {
			bAction = "F";
			sMsg = "시정여부의 [시정대상 편성 오류]는 관리자이상만 등록할 수 있습니다.";
		}

		if( bAction.equals("T") ) {
			try {
				resource	= new ConnectionResource();
				conn		= resource.getConnection();
				resource2	= new ConnectionResource2();
				conn2		= resource2.getConnection();
				
				// 조치결과 등록순번 구하기
				sSQLs="SELECT NVL(MAX(REG_SN)+1,1) MAXSN FROM HADO_TB_Survey_CTX3 \n";
				sSQLs+="WHERE Mng_No='"+lmngno+"' AND Current_Year='"+lyyyy+"' \n";
				sSQLs+="AND Oent_GB='"+lgb+"' \n";

				pstmt = conn.prepareStatement(sSQLs);
				rs = pstmt.executeQuery();

				while( rs.next() ) {
					nregsn = StringUtil.checkNull(rs.getString("MAXSN")).trim();
				}
				rs.close();
				
				sSQLs1 = "Mng_no";				sSQLs2 = "'"+lmngno+"'";
				sSQLs1+= ", Current_Year";		sSQLs2+= ", '"+lyyyy+"'";
				sSQLs1+= ", Oent_GB";			sSQLs2+= ", '"+lgb+"'";
				sSQLs1+= ", REG_SN";			sSQLs2+= ", "+nregsn;
				sSQLs1+= ", Correct_Typ";		sSQLs2+= ", '"+ltype+"'";
				sSQLs1+= ", Subcon_Cnt";		sSQLs2+= ", "+isu;
				// 등록자정보
				sSQLs1+= ", REG_Date";			sSQLs2+= ", SYSDATE";
				sSQLs1+= ", REG_CVSNo";			sSQLs2+= ", '"+ckSSOcvno+"'";
				sSQLs1+= ", REG_Center_Name";	sSQLs2+= ", '"+new String(ckCenterName.getBytes("EUC-KR"), "ISO8859-1" )+"'";
				sSQLs1+= ", REG_User_Name";		sSQLs2+= ", '"+new String(ckUserName.getBytes("EUC-KR"), "ISO8859-1" )+"'";

				sSQLs = "INSERT INTO HADO_TB_Survey_CTX3 ("+sSQLs1+") VALUES ("+sSQLs2+")";
				
				pstmt = conn2.prepareStatement(sSQLs);
				updateCNT = pstmt.executeUpdate();
				
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				if(rs!=null)		try{rs.close();}	catch(Exception e){}
				if(pstmt!=null)		try{pstmt.close();}	catch(Exception e){}
				if(conn!=null)		try{conn.close();}	catch(Exception e){}
				if(resource!=null)	resource.release();
				if(conn2!=null)		try{conn2.close();}	catch(Exception e){}
				if(resource2!=null)	resource2.release();
			}
		}
	}
%>
<html>
<head>
	<title></title>
</head>

<body>

<script language="javascript">
	<%if( cmd.equals("surveyinput") && bAction.equals("T") ) {%>
	alert("서면미발급 정보를 저장 하였습니다.");
	top.setNowProcessFalse();
	top.document.getElementById("divView").style.top="50px";
	<%} else if(cmd.equals("surveyDelete") && bAction.equals("T") ) {%>
	alert("서면미발급 정보를 삭제 하였습니다.");
	top.setNowProcessFalse();
	top.view('<%=lmngno%>','<%=lyyyy%>','<%=lgb%>');
	top.document.getElementById("divView").style.top="50px";
	<%} else {%>
	top.setNowProcessFalse();
	alert("정보등록이 취소되었습니다.");
	<%}%>
</script>

</body>
</html>