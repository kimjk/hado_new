<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명	 : 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명	 : SOent_Violate_40_proc.jsp
* 프로그램설명	: 수급사업자 > 조사결과분석 > 위반행위유형별 현황(원+수급사업자 응답)
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2015년 09월 01일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2015-09-01	강슬기       페이지 최신화(주석, 불필요한 코드 제거, 오래된 코드 수정)
*   2016-01-07   이용광        DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>
<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String tt = request.getParameter("tt")==null? "":request.getParameter("tt").trim();
	System.out.println("tt value = "+tt);
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();
	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String sSQLs = "";
	String sField = "";
	String tmpStr = "";
	// 위반항목 배열
	ArrayList money_nm = new ArrayList();
	ArrayList money_cd = new ArrayList();
	ArrayList no_money_nm = new ArrayList();
	ArrayList no_money_cd = new ArrayList();
	String[][] arrData = new String[50][50];
	float[] arrSum = new float[50];
	float[] rowSum = new float[50];
	int nLoop = 1;
	int i = 0;
	int j = 0;
	int nFieldCNTV = 0;
	int money_cnt = 0;
	int no_money_cnt = 0;
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
	if( tt.equals("start") ) {
		session.setAttribute("wgb", "1");
	}
	if( comm.equals("search") ) {
		session.setAttribute("wgb", request.getParameter("wgb")==null? "":request.getParameter("wgb").trim());
	}
	// 배열초기화
	for(int x=1; x<=41; x++) {
		arrSum[x] = 0F;
	}
	int currentYear = st_Current_Year_n;
	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");
	int endCurrentYear = st_Current_Year_n;
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		if( session.getAttribute("wgb").equals("1") ) {
			sSQLs = "SELECT oent_q_cdnm, rank,";
			sSQLs = sSQLs + "('[' || RTRIM(MIN(oent_q_cd)) || '-' || RTRIM(MIN(oent_q_gb)) || ']') q_code, ";
			sSQLs = sSQLs + "money_gb FROM HADO_TB_Oent_question WHERE oent_gb = '1' AND Current_Year='" + currentYear + "' AND (Money_GB='1' OR Money_GB='2') ";
			sSQLs = sSQLs + "group by oent_q_cdnm,money_gb, rank order by money_gb, rank ";
		} else if( session.getAttribute("wgb").equals("2") ) {
			sSQLs = "SELECT oent_q_cdnm, rank,";
			sSQLs = sSQLs + "('[' || RTRIM(MIN(oent_q_cd)) || '-' || RTRIM(MIN(oent_q_gb)) || ']') q_code, ";
			sSQLs = sSQLs + "money_gb FROM HADO_TB_Oent_question WHERE oent_gb = '2' AND Current_Year='" + currentYear + "' AND (Money_GB='1' OR Money_GB='2') ";
			sSQLs = sSQLs + "group by oent_q_cdnm,money_gb, rank order by money_gb, rank ";
		} else if( session.getAttribute("wgb").equals("3") ) {
			sSQLs = "SELECT oent_q_cdnm, rank,";
			sSQLs = sSQLs + "('[' || RTRIM(MIN(oent_q_cd)) || '-' || RTRIM(MIN(oent_q_gb)) || ']') q_code, ";
			sSQLs = sSQLs + "money_gb FROM HADO_TB_Oent_question WHERE oent_gb = '3' AND Current_Year='" + currentYear + "' AND (Money_GB='1' OR Money_GB='2') ";
			sSQLs = sSQLs + "group by oent_q_cdnm,money_gb, rank order by money_gb, rank ";
		}
		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();
		i = 1;
		j = 1;
		while( rs.next() ) {
			tmpStr = rs.getString("money_gb");
			if( tmpStr.trim().equals("1") ) {
				money_nm.add(StringUtil.checkNull(rs.getString("Oent_Q_CDNM")).trim());
				money_cd.add(StringUtil.checkNull(rs.getString("Q_Code")).trim());
				i++;
			} else {
				no_money_nm.add(StringUtil.checkNull(rs.getString("Oent_Q_CDNM")).trim());
				no_money_cd.add(StringUtil.checkNull(rs.getString("Q_Code")).trim());
				j++;
			}
		}
		rs.close();
	}
	catch(Exception e){
		e.printStackTrace();
	}
	finally {
		if ( rs != null ) try{rs.close();}catch(Exception e){}
		if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
		if ( conn != null ) try{conn.close();}catch(Exception e){}
		if ( resource != null ) resource.release();
	}
	money_cnt = i - 1;
	no_money_cnt = j - 1;
	nFieldCNTV = money_cnt + no_money_cnt;
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
		sSQLs = "SELECT * \n"+
				"FROM ( \n"+
				"	SELECT a.current_year,a.oent_gb,a.identity_q_cd,a.identity_q_gb, \n"+
				"		a.money_gb,a.rank,b.soent_q_cd \n"+
				"	FROM ( \n"+
				"		SELECT current_year,oent_gb,identity_q_cd,identity_q_gb, \n"+
				"			MIN(money_gb) AS money_gb,MIN(rank) AS rank, \n"+
				"			MIN(soent_q_cd) AS soent_q_cd,MIN(soent_q_gb) AS soent_q_gb \n"+
				"		FROM HADO_TB_Oent_Question \n"+
				"		GROUP BY current_year,oent_gb,identity_q_cd,identity_q_gb \n"+
				"	) a \n"+
				"	LEFT JOIN ( \n"+
				"		SELECT current_year,oent_gb,identity_q_cd,identity_q_gb, \n"+
				"			MIN(money_gb) AS money_gb,MIN(rank) AS rank, \n"+
				"			MIN(soent_q_cd) AS soent_q_cd,MIN(soent_q_gb) AS soent_q_gb \n"+
				"		FROM HADO_TB_SOent_Question \n"+
				"		GROUP BY current_year,oent_gb,identity_q_cd,identity_q_gb \n"+
				"	) b \n"+
				"	ON a.current_year=b.current_year AND a.oent_gb=b.oent_gb \n"+
				"		AND ((a.current_year>='2012' AND a.identity_q_cd=b.identity_q_cd AND a.identity_q_gb=b.identity_q_gb) \n"+
				"		OR (a.current_year<'2012' AND a.soent_q_cd=b.soent_q_cd AND a.soent_q_gb=b.soent_q_gb)) \n"+
				") JTable \n"+
				"WHERE current_year=? AND oent_gb=? AND (money_gb='1' OR money_gb='2') \n"+
				"ORDER BY money_gb,rank \n";
		int nOent = 1;
		int nSOent = 1;
		int nSurvey = 1;
		int nSurveyLoop = 1;
		int nMoneyCnt = 0;
		int nBiCnt = 0;
		String sSurvey = "D";
		String sPrevMoneyGB = "1";
		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();
			pstmt = conn.prepareStatement(sSQLs);
			pstmt.setString(1, currentYear+"");
			pstmt.setString(2, session.getAttribute("wgb").toString());
			rs = pstmt.executeQuery();
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
					sSOentSQL+="CASE WHEN A."+sSurvey+nOent+">0 THEN 1 ELSE 0 END "+sSurvey+nSurveyLoop;
					nOent++;
					nSurveyLoop++;
				} else {
					sSOentSQL+="CASE WHEN A."+sSurvey+nOent+"+A.S"+sSurvey+nSOent+">0 THEN 1 ELSE 0 END "+sSurvey+nSurveyLoop;
					nOent++;
					nSOent++;
					nSurveyLoop++;
				}
				if( tmpMoneyGB.equals("1") ) nMoneyCnt++;
				else nBiCnt++;
			}
			rs.close();
			String sTmpSOentSQL = "SELECT D.COMMON_CD||'('||D.COMMON_NM||')' TYPECD,C.* FROM ( \n";
			sTmpSOentSQL+="	SELECT OENT_TYPE,";
			for( int x=1;x<=nMoneyCnt;x++ ) {
				sTmpSOentSQL+="SUM(D"+x+")";
				sTmpSOentSQL+="+";
			}
			for( int x=1;x<=nBiCnt;x++ ) {
				sTmpSOentSQL+="SUM(A"+x+")";
				if( x<nBiCnt ) sTmpSOentSQL+="+";
			}
			sTmpSOentSQL+=" SURVEY_CNT, \n";
			for( int x=1;x<=nMoneyCnt;x++ ) {
				sTmpSOentSQL+="SUM(D"+x+") D"+x;
				sTmpSOentSQL+=",";
			}
			for( int x=1;x<=nBiCnt;x++ ) {
				sTmpSOentSQL+="SUM(A"+x+") A"+x;
				if( x<nBiCnt ) sTmpSOentSQL+=",";
			}
			sTmpSOentSQL+=" FROM ( \n";
			sTmpSOentSQL+=" SELECT A.MNG_NO,A.CURRENT_YEAR,A.OENT_GB,B.OENT_TYPE, \n";
			sSOentSQL = sTmpSOentSQL+sSOentSQL;
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			if ( rs != null ) try{rs.close();}catch(Exception e){}
			if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
			if ( conn != null ) try{conn.close();}catch(Exception e){}
			if ( resource != null ) resource.release();
		}
		/* <========================================================= 위반행위별 위반수 SQL문 자동 생성을 위해 위반table 참조 */
		/* 위반행위별 위반수 SQL문 자동 생성을 위해 위반table 참조 =================================================> */
		/* 1. 작성일자 : 2012년 11월 13일
		   2. 작성자 : (주)로티스아이 정광식
		   3. 상단 생성 쿼리 참조*/
		sSQLs = sSOentSQL;
		/* <================================================= 위반행위별 위반수 SQL문 자동 생성을 위해 위반table 참조 */
		if( currentYear >= 2012 ) {
			sSQLs+=" FROM \n" +
					"(SELECT * FROM HADO_TB_SURVEY_PRINT  \n" +
					"WHERE OENT_GB='" + session.getAttribute("wgb") + "' AND CURRENT_YEAR='" + currentYear + "') A \n" +
					"LEFT JOIN "+currentOent+" B ON A.MNG_NO=B.MNG_NO AND A.OENT_GB=B.OENT_GB AND A.CURRENT_YEAR=B.CURRENT_YEAR \n" +
					") VT_TABLE GROUP BY OENT_TYPE) C LEFT JOIN COMMON_CD D \n" +
					"ON C.OENT_TYPE=D.COMMON_CD AND D.Common_GB='010' ORDER BY C.OENT_TYPE \n";
		} else if( currentYear == 2011 ) {
			sSQLs+=" FROM " +
					"(SELECT * FROM HADO_TB_SURVEY_PRINT  " +
					"WHERE OENT_GB='" + session.getAttribute("wgb") + "' AND CURRENT_YEAR='" + currentYear + "') A " +
					"LEFT JOIN "+currentOent+" B ON A.MNG_NO=B.MNG_NO AND A.OENT_GB=B.OENT_GB AND A.CURRENT_YEAR=B.CURRENT_YEAR " +
					") VT_TABLE GROUP BY OENT_TYPE) C LEFT JOIN COMMON_CD D " +
					"ON C.OENT_TYPE=D.COMMON_CD AND D.ADDON_GB='" + session.getAttribute("wgb") + "' ORDER BY C.OENT_TYPE";
		} else {
			sSQLs+=" FROM " +
					"(SELECT * FROM HADO_TB_SURVEY_PRINT  " +
					"WHERE OENT_GB='" + session.getAttribute("wgb") + "' AND CURRENT_YEAR='" + currentYear + "') A " +
					"LEFT JOIN "+currentOent+" B ON A.MNG_NO=B.MNG_NO AND A.OENT_GB=B.OENT_GB AND A.CURRENT_YEAR=B.CURRENT_YEAR " +
					") VT_TABLE GROUP BY OENT_TYPE) C LEFT JOIN COMMON_CD D " +
					"ON C.OENT_TYPE=D.COMMON_CD AND D.ADDON_GB='" + session.getAttribute("wgb") + "' ORDER BY C.OENT_TYPE";
		}
		//System.out.println(sSQLs);
		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();
			out.println(sSQLs);
			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();
			nLoop = 1;
			while( rs.next() ) {
				arrData[nLoop][1] = StringUtil.checkNull(rs.getString("TYPECD")).trim();

				arrData[nLoop][2] = "0";
				for(int x=1; x<=nMoneyCnt; x++) {
					arrData[nLoop][x+2] = rs.getString("D"+x)==null ? "0":rs.getString("D"+x);
					arrData[nLoop][2] = "" + (Float.parseFloat(arrData[nLoop][2]) + Float.parseFloat(arrData[nLoop][x+2]));
				}
			//	System.out.println("arrData["+nLoop+"][2]"+arrData[nLoop][2]);
				arrData[nLoop][21] = "0";
				for(int x=1; x<=nBiCnt; x++) {
					arrData[nLoop][x+21] = rs.getString("A"+x)==null ? "0":rs.getString("A"+x);
					arrData[nLoop][21] = "" + (Float.parseFloat(arrData[nLoop][21]) + Float.parseFloat(arrData[nLoop][x+21]));
				}
			//	System.out.println("arrData["+nLoop+"][21]"+arrData[nLoop][21]);
				for(int x=2; x<=41; x++) {
					if( arrData[nLoop][x]==null || arrData[nLoop][x].equals("") ) arrData[nLoop][x]="0";
					arrSum[x] = arrSum[x] + Float.parseFloat(arrData[nLoop][x]);
				}
				nLoop++;
			}
			rs.close();
			nLoop--;
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			if ( rs != null ) try{rs.close();}catch(Exception e){}
			if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
			if ( conn != null ) try{conn.close();}catch(Exception e){}
			if ( resource != null ) resource.release();
		}
	}

%>
<meta charset="utf-8">
<script type="text/javascript">
//<![CDATA[
content = "";
content+="<input type='hidden' name='arrsum2' value='<%=arrSum[2]%>'>";
content+="<input type='hidden' name='arrsum21' value='<%=arrSum[21]%>'>";
content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th rowspan=3>구분</th>";
content+="		<th rowspan=3>위반행위수</th>";
content+="		<th colspan=<%=money_cnt+1%>>대금관련사항(<%=money_cnt%>)</th>";
content+="		<th colspan=<%=no_money_cnt+1%>>비대금관련사항(<%=no_money_cnt%>)</th>";
content+="	</tr>";
content+="	<tr>";
	<%for(int ni=1; ni<=money_cnt; ni++) {%>
content+="		<th><%=money_nm.get(ni-1)%></th>";
	<%}%>
content+="		<th rowspan=2>소계</th>";
	<%for(int ni=1; ni<=no_money_cnt; ni++) {%>
content+="		<th><%=no_money_nm.get(ni-1)%></th>";
	<%}%>
content+="		<th rowspan=2>소계</th>";
content+="	</tr>";
content+="	<tr>";
	<%for(int ni=1; ni<=money_cnt; ni++) {%>
content+="		<th><%=money_cd.get(ni-1)%></th>";
	<%}%>
	<%for(int ni=1; ni<=no_money_cnt; ni++) {%>
content+="		<th><%=no_money_cd.get(ni-1)%></th>";
	<%}%>
content+="	</tr>";
<%if( !tt.equals("start") ) {
	tmpSum = arrSum[2]+arrSum[21];
%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)' class='<%=tmpSum%>'>";
content+="		<th rowspan=2>계</th>";

content+="		<td rowspan=2 style='text-align:right;'><%=formater2.format(tmpSum)%></td>";
	<%for(int x=1; x<=money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater2.format(arrSum[x+2])%></td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater2.format(arrSum[2])%></td>";
	<%for(int x=1; x<=no_money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater2.format(arrSum[x+21])%></td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater2.format(arrSum[21])%></td>";
content+="	</tr>";

content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for(int x=1; x<=money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater.format(arrSum[x+2] / tmpSum * 100)%>%</td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater.format(arrSum[2] / tmpSum * 100)%>%</td>";
	<%for(int x=1; x<=no_money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater.format(arrSum[x+21] / tmpSum * 100)%>%</td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater.format(arrSum[21] / tmpSum * 100)%>%</td>";
content+="	</tr>";
<%for(i=1; i<=nLoop; i++) {
		tmpSum = Float.parseFloat(arrData[i][2])+Float.parseFloat(arrData[i][21]);
	%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan=2><%=arrData[i][1]%></th>";
content+="		<td rowspan=2 style='text-align:right;'><%=formater2.format(tmpSum)%></td>";
	<%for(int x=1; x<=money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrData[i][x+2]))%></td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrData[i][2]))%></td>";
	<%for(int x=1; x<=no_money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrData[i][x+21]))%></td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrData[i][21]))%></td>";
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for(int x=1; x<=money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater.format(Float.parseFloat(arrData[i][x+2]) / tmpSum * 100)%>%</td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater.format(Float.parseFloat(arrData[i][2]) / tmpSum * 100)%>%</td>";
	<%for(int x=1; x<=no_money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater.format(Float.parseFloat(arrData[i][x+21]) / tmpSum * 100)%>%</td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater.format(Float.parseFloat(arrData[i][21]) / tmpSum * 100)%>%</td>";
content+="	</tr>";
<%}%>
<%}%>
content+="</table>";
top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
//]]
</script>
<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>