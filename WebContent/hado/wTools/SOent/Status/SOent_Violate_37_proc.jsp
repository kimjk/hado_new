<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/*=======================================================*/
/* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업								   */
/* 프로그램명		: SOent_Violate_37.jsp																				   */
/* 프로그램설명	: 연도별 위반행위수 현황(원+수급사업자 응답) 통계자료 처리 페이지			*/
/* 프로그램버전	: 1.0.0-2015																				                        */
/* 최초작성일자	: 2015년 09월 01일																                            */
/* 작성 이력       :                                                                                                                           */
/*-------------------------------------------------------------------------------------------------------------- */
/*	작성일자		   작성자명				내용
/*-------------------------------------------------------------------------------------------------------------- */
/*	2015-09-01	강슬기       페이지 최신화(주석, 불필요한 코드 제거, 오래된 코드 수정)     */
/*=======================================================*/
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String tt = request.getParameter("tt")==null? "":request.getParameter("tt").trim();
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();
	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	String sSQLs = "";

	String[][] arrData = new String[50][16];
	float[] arrSum = new float[16];

	int nLoop = 1;
	float tmpSum = 0F;

	int sStartYear = 2000;

	java.util.Calendar cal = java.util.Calendar.getInstance();

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2 = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	String tmpYear = request.getParameter("cyear")==null? "":request.getParameter("cyear").trim();
	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
	}

	// 합계배열 초기화
	for(int i=1; i <=15; i++) { arrSum[i] = 0F; }

	if( tt.equals("start") ) {
		session.setAttribute("wgb","");
		session.setAttribute("cstatus","");
	}
	if( comm.equals("search") ) {
		session.setAttribute("wgb", request.getParameter("wgb")==null? "":request.getParameter("wgb").trim());
		session.setAttribute("cstatus", request.getParameter("cstatus")==null? "":request.getParameter("cstatus").trim());
	}

	int currentYear = st_Current_Year_n;
	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");

	int endCurrentYear = st_Current_Year_n;

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
		pstmt.setString(2, session.getAttribute("wgb").toString());
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
		sTmpSOentSQL+="      SELECT A.MNG_NO,A.CURRENT_YEAR,A.OENT_GB,A.OENT_TYPE, \n";

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
//System.out.println(sSOentSQL);

	if( !tt.equals("start") ) {

		/* 2012년 원사업자 관련 DB Table 분리 예외처리 시작 ============================================================> */
		/* 업데이트 일자 : 2012년 11월 13일
		   작성자 : 정광식
		   비고 : Database 성능향상을 위하여 2012년부터 원사업자 테이블 분리
				  HADO_TB_Oent --> HADO_TB_Oent_2012 */
		String currentOent = "HADO_TB_Oent";
		if( currentYear>2011 ) {
			currentOent = "HADO_TB_Oent_"+currentYear;
		}
		/* <============================================================== 2012년 원사업자 관련 DB Table 분리 예외처리 끝 */

		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();

			sSQLs="SELECT D.COMMON_CD||'('||D.COMMON_NM||')' TYPECD,C.* FROM ( \n";
			sSQLs+="  SELECT OENT_TYPE, COUNT(*) OENT_CNT, \n";
			sSQLs+="  SUM(CASE WHEN MONEY_TOTAL+BI_TOTAL>0 THEN 1 ELSE 0 END) SURVEY_CNT, \n";
			sSQLs+="  SUM(CASE WHEN MONEY_TOTAL+BI_TOTAL=1 THEN 1 ELSE 0 END) CNT1, \n";
			sSQLs+="  SUM(CASE WHEN MONEY_TOTAL+BI_TOTAL=2 THEN 1 ELSE 0 END) CNT2, \n";
			sSQLs+="  SUM(CASE WHEN MONEY_TOTAL+BI_TOTAL=3 THEN 1 ELSE 0 END) CNT3, \n";
			sSQLs+="  SUM(CASE WHEN MONEY_TOTAL+BI_TOTAL=4 THEN 1 ELSE 0 END) CNT4, \n";
			sSQLs+="  SUM(CASE WHEN MONEY_TOTAL+BI_TOTAL=5 THEN 1 ELSE 0 END) CNT5, \n";
			sSQLs+="  SUM(CASE WHEN MONEY_TOTAL+BI_TOTAL=6 THEN 1 ELSE 0 END) CNT6, \n";
			sSQLs+="  SUM(CASE WHEN MONEY_TOTAL+BI_TOTAL=7 THEN 1 ELSE 0 END) CNT7, \n";
			sSQLs+="  SUM(CASE WHEN MONEY_TOTAL+BI_TOTAL=8 THEN 1 ELSE 0 END) CNT8, \n";
			sSQLs+="  SUM(CASE WHEN MONEY_TOTAL+BI_TOTAL=9 THEN 1 ELSE 0 END) CNT9, \n";
			sSQLs+="  SUM(CASE WHEN MONEY_TOTAL+BI_TOTAL=10 THEN 1 ELSE 0 END) CNT10, \n";
			sSQLs+="  SUM(CASE WHEN MONEY_TOTAL+BI_TOTAL>10 THEN 1 ELSE 0 END) CNT11 FROM ( \n";

			/* 위반행위별 위반수 SQL문 자동 생성을 위해 위반table 참조 =================================================> */
			/* 1. 작성일자 : 2012년 11월 13일
		       2. 작성자 : (주)로티스아이 정광식
			   3. 상단 생성 쿼리 참조*/
			sSQLs+=sSOentSQL;
			/* <================================================= 위반행위별 위반수 SQL문 자동 생성을 위해 위반table 참조 */

			sSQLs+=" FROM ( \n";
			sSQLs+="        SELECT * FROM "+currentOent+" \n";
			sSQLs+="        WHERE OENT_GB='"+session.getAttribute("wgb")+"' AND CURRENT_YEAR='"+currentYear+"' \n";
			sSQLs+="        AND Oent_Status='1' AND Comp_Status='1' \n";
    		sSQLs+="        AND Subcon_Type<='2' AND Addr_Status IS NULL \n";
			sSQLs+="        AND SUBSTR(Mng_No,-7)<>'1234567' AND LENGTH(Mng_No)>4 \n";
			sSQLs+="      ) A LEFT JOIN ( \n";
			if( session.getAttribute("cstatus").equals("1") ) {
				sSQLs+="        SELECT * FROM HADO_TB_SURVEY_PRINT WHERE (D_T+SD_T)>0 \n";
			} else if( session.getAttribute("cstatus").equals("2") ) {
				sSQLs+="        SELECT * FROM HADO_TB_SURVEY_PRINT WHERE (D_T+SD_T)=0 AND (A_T+SA_T)>0 \n";
			} else {
				sSQLs+="        SELECT * FROM HADO_TB_SURVEY_PRINT WHERE (D_T+SD_T+A_T+SA_T)>0 \n";
			}
			sSQLs+="      ) B ON A.MNG_NO=B.MNG_NO AND A.CURRENT_YEAR=B.CURRENT_YEAR AND A.OENT_GB=B.OENT_GB \n";
			sSQLs+="    ) VT_TABLE \n";
			sSQLs+="  ) VTT_TABLE \n";
			sSQLs+="  GROUP BY OENT_TYPE \n";
			sSQLs+=") C LEFT JOIN COMMON_CD D \n";
			sSQLs+="ON C.OENT_TYPE=D.COMMON_CD AND D.ADDON_GB='"+session.getAttribute("wgb")+"' \n";
			sSQLs+="ORDER BY C.OENT_TYPE \n";
//out.println(sSQLs);

			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();

			nLoop = 1;
			while( rs.next() ) {
				// arrData[nLoop][1] = new String( StringUtil.checkNull(rs.getString("TYPECD")).trim().getBytes("ISO8859-1"), "utf-8" );
				arrData[nLoop][1] =  StringUtil.checkNull(rs.getString("TYPECD")).trim();
				arrData[nLoop][2] = rs.getString("Oent_Cnt");
				arrData[nLoop][3] = rs.getString("SURVEY_CNT");
				arrData[nLoop][4] = "" + (Float.parseFloat(arrData[nLoop][2])-Float.parseFloat(arrData[nLoop][3]));
				arrData[nLoop][5] = rs.getString("CNT1");
				arrData[nLoop][6] = rs.getString("CNT2");
				arrData[nLoop][7] = rs.getString("CNT3");
				arrData[nLoop][8] = rs.getString("CNT4");
				arrData[nLoop][9] = rs.getString("CNT5");
				arrData[nLoop][10] = rs.getString("CNT6");
				arrData[nLoop][11] = rs.getString("CNT7");
				arrData[nLoop][12] = rs.getString("CNT8");
				arrData[nLoop][13] = rs.getString("CNT9");
				arrData[nLoop][14] = rs.getString("CNT10");
				arrData[nLoop][15] = rs.getString("CNT11");

				for(int x=1; x<=14; x++) {
					arrSum[x] = arrSum[x] + Float.parseFloat(arrData[nLoop][x+1]);
				}

				nLoop++;
			}
			rs.close();
			nLoop--;

		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if(rs!=null)		try{rs.close();}	catch(Exception e){}
			if(pstmt!=null)		try{pstmt.close();}	catch(Exception e){}
			if(conn!=null)		try{conn.close();}	catch(Exception e){}
			if(resource!=null)	resource.release();
		}
	}

%>


<meta charset="utf-8">
<script type="text/javascript">
content = "";

content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th rowspan=2>구분</th>";
content+="		<th rowspan=2>대상업체수(A)</th>";
content+="		<th rowspan=2>위반업체수(B)</th>";
content+="		<th rowspan=2>미위반업체수(C)</th>";
content+="		<th colspan=2>비율(%)</th>";
content+="		<th colspan=11>업체별 위반행위수</th>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>B/A</th>";
content+="		<th>C/A</th>";
content+="		<th>1</th>";
content+="		<th>2</th>";
content+="		<th>3</th>";
content+="		<th>4</th>";
content+="		<th>5</th>";
content+="		<th>6</th>";
content+="		<th>7</th>";
content+="		<th>8</th>";
content+="		<th>9</th>";
content+="		<th>10</th>";
content+="		<th>10 초과</th>";
content+="	</tr>";

<%if( !tt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan=2>합계</th>";
content+="		<td rowspan=2><%=formater2.format(arrSum[1])%></td>";
content+="		<td rowspan=2><%=formater2.format(arrSum[2])%></td>";
content+="		<td rowspan=2><%=formater2.format(arrSum[3])%></td>";
content+="		<td rowspan=2><%if( arrSum[1]>0F ) {%><%=formater.format(arrSum[2] / arrSum[1] * 100)%><%} else {%>0.0<%}%>%</td>";
content+="		<td rowspan=2><%if( arrSum[1]>0F ) {%><%=formater.format(arrSum[3] / arrSum[1] * 100)%><%} else {%>0.0<%}%>%</td>";
	<%for(int x=4; x<=14; x++) {%>
content+="		<td><%=formater2.format(arrSum[x])%></td>";
	<%}%>
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for(int x=4; x<=14; x++) {
		tmpSum = 0F;%>
content+="		<td>";
		<%for(int y=x; y<=11; y++) {
			tmpSum = tmpSum + arrSum[y];
		}%>
		<%=formater2.format(tmpSum)%>
content+="		</td>";
	<%}%>
content+="	</tr>";
<%}%>

<%if( !tt.equals("start") ) {
for(int k=1; k<=nLoop; k++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan=2 style='text-align:left;'><%=arrData[k][1]%></th>";
content+="		<td rowspan=2><%=formater2.format(Float.parseFloat(arrData[k][2]))%></td>";
content+="		<td rowspan=2><%=formater2.format(Float.parseFloat(arrData[k][3]))%></td>";
content+="		<td rowspan=2><%=formater2.format(Float.parseFloat(arrData[k][4]))%></td>";
content+="		<td rowspan=2><%if( Float.parseFloat(arrData[k][2])>0F ) {%><%=formater.format(Float.parseFloat(arrData[k][3]) / Float.parseFloat(arrData[k][2]) * 100)%><%} else {%>0.0<%}%>%</td>";
content+="		<td rowspan=2><%if( Float.parseFloat(arrData[k][2])>0F ) {%><%=formater.format(Float.parseFloat(arrData[k][4]) / Float.parseFloat(arrData[k][2]) * 100)%><%} else {%>0.0<%}%>%</td>";
	<%for(int x=5; x<=15; x++) {%>
content+="		<td><%=formater2.format(Float.parseFloat(arrData[k][x]))%></td>";
	<%}%>
content+="	</tr>";

content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for(int x=5; x<=15; x++) {
		tmpSum = 0F;%>
content+="		<td>";
		<%for(int y=x; y<=11; y++) {
			tmpSum = tmpSum + Float.parseFloat(arrData[k][y]);
		}%>
		<%=formater2.format(tmpSum)%>
content+="		</td>";
	<%}%>
content+="	</tr>";
<%}%>

<%}%>
content+="</table>";

top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>
