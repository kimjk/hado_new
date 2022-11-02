<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

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
/*  3. 일자 : 2012년 11월																			   */
/*  4. 최초작성자 및 일자 : (주)로티스아이 정광식 / 2012-11-15										   */
/*  5. 업데이트내용 (내용 / 일자)																	   */
/*  6. 비고																							   */
/*		1) 엑셀 위반항목표 [첨부1] 생성을 위해 원+수급사업자 위반항목표 SQL 참조를 위해 작성		   */
/*-----------------------------------------------------------------------------------------------------*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/
	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sSQLs = "";
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	/*String tmpYear = StringUtil.checkNull(request.getParameter("cyear")).trim();
	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
	}
	session.setAttribute("wgb", StringUtil.checkNull(request.getParameter("wgb")).trim() );

	int currentYear = st_Current_Year_n;
	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");*/

	int currentYear = request.getParameter("cyear")==null ? st_Current_Year_n:Integer.parseInt(request.getParameter("cyear").trim());
	String wgb = request.getParameter("wgb")==null ? "1":request.getParameter("wgb").trim();

	
	/* 위반행위별 위반수 SQL문 자동 생성을 위해 위반table 참조 =========================================================> */
	/* 1. 작성일자 : 2012년 11월 13일
	   2. 작성자 : (주)로티스아이 정광식
	   3. 비고 : 매년 변경되는 위반항목표를 유동적으로 적용하기 위하여 모듈 변경
	   4. 주의사항
	      - 2011년 까지는 원사업자 위반항목표와 수급사업자 위반항목표를 연결하는 필드는
		    SOent_Q_CD 와 SOent_Q_GB 였으나
		  - 2012년 부터는 Identity_Q_CD 와 Identity_Q_GB 필드로 변경하고 원사업자와 수급사업자
		    위반항목표 테이블 (HADO_TB_Oent_Question,HADO_TB_SOent_Question) 의 2개 필드값을
			일치하여 등록하여 준다. (*절대 HADO_TB_Oent_Question 테이블의 SOent_Q_CD 및 SOent_Q_GB 값을 세팅하지 말것!!) */
	String sSOentSQL = "";
	sSQLs="SELECT * FROM ( \n";
	sSQLs+="	SELECT a.current_year,a.oent_gb,a.identity_q_cd,a.identity_q_gb, \n";
	sSQLs+="		a.money_gb,a.rank,b.soent_q_cd FROM ( \n";
	sSQLs+="		SELECT current_year,oent_gb,identity_q_cd,identity_q_gb, \n";
	sSQLs+="			MIN(money_gb) AS money_gb,MIN(rank) AS rank, \n";
	sSQLs+="			MIN(soent_q_cd) AS soent_q_cd,MIN(soent_q_gb) AS soent_q_gb \n";
	sSQLs+="		FROM HADO_TB_Oent_Question \n";
	sSQLs+="		GROUP BY current_year,oent_gb,identity_q_cd,identity_q_gb \n";
	sSQLs+="	) a LEFT JOIN ( \n";
	sSQLs+="		SELECT current_year,oent_gb,identity_q_cd,identity_q_gb, \n";
	sSQLs+="			MIN(money_gb) AS money_gb,MIN(rank) AS rank, \n";
	sSQLs+="			MIN(soent_q_cd) AS soent_q_cd,MIN(soent_q_gb) AS soent_q_gb \n";
	sSQLs+="		FROM HADO_TB_SOent_Question \n";
	sSQLs+="		GROUP BY current_year,oent_gb,identity_q_cd,identity_q_gb \n";
	sSQLs+="	) b ON a.current_year=b.current_year AND a.oent_gb=b.oent_gb \n";
	sSQLs+="	AND ( (a.current_year>='2012' AND a.identity_q_cd=b.identity_q_cd AND a.identity_q_gb=b.identity_q_gb) \n";
	sSQLs+="		OR (a.current_year<'2012' AND a.soent_q_cd=b.soent_q_cd AND a.soent_q_gb=b.soent_q_gb) ) \n";
	sSQLs+=") JTable \n";
	sSQLs+="WHERE current_year=? AND oent_gb=? AND (money_gb='1' OR money_gb='2') \n";
	sSQLs+="ORDER BY money_gb,rank \n";
//System.out.println(sSQLs);

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, currentYear+"");
		pstmt.setString(2, wgb);
		rs = pstmt.executeQuery();
		int nOent = 1;
		int nSOent = 1;
		int nSurvey = 1;
		int nSurveyLoop = 1;
		int nMoneyCnt = 0;
		int nBiCnt = 0;
		String sSurvey = "D";
		String sPrevMoneyGB = "1";
		while( rs.next() ) {
			String tmpMoneyGB = rs.getString("money_gb");
			if( (!sPrevMoneyGB.equals(tmpMoneyGB)) && tmpMoneyGB.equals("2") ) {
				sSurvey = "A";
				nOent = 1;
				nSOent = 1;
				nSurveyLoop = 1;
				sSOentSQL+=" \n";
			}
			sPrevMoneyGB = tmpMoneyGB;
			if( !sSOentSQL.equals("") ) sSOentSQL+=", \n";
			String tmpSOentQCD = rs.getString("soent_q_cd")==null ? "":rs.getString("soent_q_cd");
			if( tmpSOentQCD.equals("") ) {
				sSOentSQL+="      CASE WHEN B."+sSurvey+nOent+">0 THEN 1 ELSE 0 END "+sSurvey+nSurveyLoop;
				nOent++;
				nSurveyLoop++;
			} else {
				sSOentSQL+="      CASE WHEN B."+sSurvey+nOent+"+B.S"+sSurvey+nSOent+">0 THEN 1 ELSE 0 END "+sSurvey+nSurveyLoop;
				nOent++;
				nSOent++;
				nSurveyLoop++;
			}
			if( tmpMoneyGB.equals("1") ) nMoneyCnt++;
			else nBiCnt++;
		}
		rs.close();

		String sTmpSOentSQL = "    SELECT MNG_NO,CURRENT_YEAR,OENT_GB,OENT_TYPE, \n";
		sTmpSOentSQL+="    (";
		for( int i=1;i<=nMoneyCnt;i++ ) {
			sTmpSOentSQL+="D"+i;
			if( i<nMoneyCnt ) sTmpSOentSQL+="+";
		}
		sTmpSOentSQL+=") MONEY_TOTAL, \n";
		sTmpSOentSQL+="    (";
		for( int i=1;i<=nBiCnt;i++ ) {
			sTmpSOentSQL+="A"+i;
			if( i<nBiCnt ) sTmpSOentSQL+="+";
		}
		sTmpSOentSQL+=") BI_TOTAL FROM ( \n";
		sTmpSOentSQL+="      SELECT A.MNG_NO,A.CURRENT_YEAR,A.OENT_GB,A.OENT_TYPE, \n\n";

		sSOentSQL = sTmpSOentSQL+sSOentSQL;

	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if(rs!=null)		try{rs.close();}	catch(Exception e){}
		if(pstmt!=null)		try{pstmt.close();}	catch(Exception e){}
		if(conn!=null)		try{conn.close();}	catch(Exception e){}
		if(resource!=null)	resource.release();
	}
	/* <========================================================= 위반행위별 위반수 SQL문 자동 생성을 위해 위반table 참조 */
	
	out.println(sSOentSQL.replace("\n","<br/>"));
%>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>
