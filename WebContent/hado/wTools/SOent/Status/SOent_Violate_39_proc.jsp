<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%><%/*** 프로젝트명	 : 하도급거래 서면실태조사 지원을 위한 개발용역 사업								   * 프로그램명	 : SOent_Violate_39_proc.jsp																				   * 프로그램설명	: 수급사업자 > 조사결과분석 > 위반행위유형별 현황(원사업자별 수급사업자 응답) * 프로그램버전	: 1.0.1																				                        * 최초작성일자	: 2015년 09월 01일																                            * 작 성 이 력       :                                                                                                                           *=========================================================*	작성일자		작성자명				내용*=========================================================*	2015-09-01	강슬기       페이지 최신화(주석, 불필요한 코드 제거, 오래된 코드 수정)*	2015-10-01   정광식       비대금 위반혐의항목이 밀려서 출력되는 문제로 방식변경*	2016-01-07   이용광       DB변경으로 인한 인코딩 변경*/%>
<%@ page import="java.sql.*"%><%@ page import="java.util.*"%><%@ page import="ftc.util.*"%><%@ page import="ftc.db.ConnectionResource"%><%@ page import="java.text.DecimalFormat"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%><%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>
<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/	String tt = request.getParameter("tt")==null? "":request.getParameter("tt").trim();
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();
	String sCapa=request.getParameter("wcapa")==null? "":request.getParameter("wcapa").trim();
	ConnectionResource resource = null;	Connection conn = null;	PreparedStatement pstmt = null;	ResultSet rs = null;
	String sSQLs = "";	String sField = "";	String tmpStr = "";
	// 위반항목 배열	ArrayList money_nm = new ArrayList();	ArrayList money_cd = new ArrayList();	ArrayList no_money_nm = new ArrayList();	ArrayList no_money_cd = new ArrayList();
	/* 기존 대금/비대금 구분없이 저장하던 배열 대금과 비대금으로 분리 / 2015-10-01 / 정광식 */
	//String[][] arrData = new String[50][41];
	String[][] arrMoney = new String[50][22];
	String[][] arrNoMoney = new String[50][32];
	float[] arrSum = new float[60];
		int nLoop = 1;	int i = 0;	int j = 0;	int nFieldCNTV = 0;	int money_cnt = 0;	int no_money_cnt = 0;
	float tmpSum = 0F;	float fMoneySum = 0F;
	float fNoMoneySum = 0F;

	int sStartYear = 2000;
	java.util.Calendar cal = java.util.Calendar.getInstance();
	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");	DecimalFormat formater2 = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");/*-----------------------------------------------------------------------------------------------------*//*=================================== Record Selection Processing =====================================*/
	String tmpYear = request.getParameter("cyear")==null? "":request.getParameter("cyear").trim();
	if( !tmpYear.equals("") ) {		session.setAttribute("cyear", tmpYear);	} else {		session.setAttribute("cyear", st_Current_Year);	}
	if( tt.equals("start") ) {		session.setAttribute("wgb", "1");	}	if( comm.equals("search") ) {		session.setAttribute("wgb", request.getParameter("wgb")==null? "":request.getParameter("wgb").trim());
	}
	// 배열초기화	for(int x=1; x<=54; x++) {		arrSum[x] = 0F;	}
	int currentYear = st_Current_Year_n;	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");	//System.out.print("\n currentYear : " + currentYear + "\n\n");
	int endCurrentYear = st_Current_Year_n;
	try {		resource = new ConnectionResource();		conn = resource.getConnection();
		/* 기존 업종별로 조건문으로 따로 SQL 생성하던 것을 하나로 통합 / 2015-10-01 / 정광식 */
		sSQLs="SELECT SOent_Q_CDNM, rank, money_gb, \n";
		sSQLs+="('[' || RTRIM(MIN(soent_q_cd)) || '-' || RTRIM(MIN(soent_q_gb)) || ']') Q_Code \n";
		sSQLs+="FROM HADO_TB_SOent_question \n";
		sSQLs+="WHERE oent_gb = '"+session.getAttribute("wgb")+"' AND Current_Year='"+currentYear+"' AND (Money_GB='1' OR Money_GB='2') \n";
		sSQLs+="GROUP BY soent_q_cdnm,money_gb, rank \n";
		sSQLs+="ORDER BY money_gb, rank \n";

		//System.out.print(sSQLs);		pstmt = conn.prepareStatement(sSQLs);		rs = pstmt.executeQuery();
		i = 1;		j = 1;		while( rs.next() ) {			tmpStr = rs.getString("money_gb");			if( tmpStr.trim().equals("1") ) {				money_nm.add(StringUtil.checkNull(rs.getString("SOent_Q_CDNM")).trim());				money_cd.add(StringUtil.checkNull(rs.getString("Q_Code")).trim());				i++;			} else {				no_money_nm.add(StringUtil.checkNull(rs.getString("SOent_Q_CDNM")).trim());				no_money_cd.add(StringUtil.checkNull(rs.getString("Q_Code")).trim());				j++;			}		}		rs.close();	}	catch(Exception e){		e.printStackTrace();	}	finally {		if ( rs != null ) try{rs.close();}catch(Exception e){}		if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}		if ( conn != null ) try{conn.close();}catch(Exception e){}		if ( resource != null ) resource.release();	}	money_cnt = i - 1;	no_money_cnt = j - 1;	nFieldCNTV = money_cnt + no_money_cnt;	if( !tt.equals("start") ) {		/* 2012년 원사업자 관련 DB Table 분리 예외처리 시작 ============================================================> */		/* 업데이트 일자 : 2012년 11월 13일		   작성자 : 정광식		   비고 : Database 성능향상을 위하여 2012년부터 원사업자 테이블 분리				  HADO_TB_Oent --> HADO_TB_Oent_2012 */		String currentOent = "HADO_TB_Oent";		if( currentYear>2011 ) {			currentOent = "HADO_TB_Oent_"+currentYear;		}		/* <============================================================== 2012년 원사업자 관련 DB Table 분리 예외처리 끝 */		try {			resource = new ConnectionResource();			conn = resource.getConnection();
			sSQLs = "SELECT D.COMMON_CD||'('||D.COMMON_NM||')' TYPECD,C.* \n";
			sSQLs+="FROM ( \n";
			sSQLs+="	SELECT OENT_TYPE,SUM(D1)+SUM(D2)+SUM(D3)+SUM(D4)+SUM(D5)+SUM(D6)+SUM(D7)+SUM(D8)+SUM(D9)+SUM(D10)+SUM(D11)+ \n" ;
			sSQLs+="		SUM(D12)+SUM(D13)+SUM(D14)+SUM(D15)+SUM(D16)+SUM(A1)+SUM(A2)+SUM(A3)+SUM(A4)+SUM(A5)+SUM(A6)+SUM(A7)+ \n";
			sSQLs+="		SUM(A8)+SUM(A9)+SUM(A10)+SUM(A11)+SUM(A12)+SUM(A13)+SUM(A14)+SUM(A15)+SUM(A16)+SUM(A17)+SUM(A18)+SUM(A19)+ \n";
			sSQLs+="		SUM(A20)+SUM(A21)+SUM(A22)+SUM(A23)+SUM(A24)+SUM(A25)+SUM(A26) AS SURVEY_CNT, \n";
			sSQLs+="		SUM(D1) D1,SUM(D2) D2,SUM(D3) D3,SUM(D4) D4,SUM(D5) D5,SUM(D6) D6,SUM(D7) D7,SUM(D8) D8,SUM(D9) D9,SUM(D10) D10, \n";
			sSQLs+="		SUM(D11) D11,SUM(D12) D12,SUM(D13) D13,SUM(D14) D14,SUM(D15) D15,SUM(D16) D16, \n";
			sSQLs+="		SUM(A1) A1,SUM(A2) A2,SUM(A3) A3,SUM(A4) A4,SUM(A5) A5,SUM(A6) A6,SUM(A7) A7,SUM(A8) A8,SUM(A9) A9,SUM(A10) A10,SUM(A11) A11, \n";
			sSQLs+="		SUM(A12) A12,SUM(A13) A13,SUM(A14) A14,SUM(A15) A15,SUM(A16) A16,SUM(A17) A17,SUM(A18) A18,SUM(A19) A19,SUM(A20) A20, \n";			sSQLs+="		SUM(A21) A21,SUM(A22) A22,SUM(A23) A23,SUM(A24) A24,SUM(A25) A25,SUM(A26) A26 \n";
			sSQLs+="	FROM ( \n";
			sSQLs+="		SELECT * \n";
			sSQLs+="		FROM ( \n";
			sSQLs+="			SELECT A.*,B.OENT_TYPE,B.oent_capa \n";
			sSQLs+="			FROM  ( \n";
			sSQLs+="				SELECT SUBSTR(MNG_NO,1,8) MNG_NO,CURRENT_YEAR,OENT_GB, \n";
			sSQLs+="					CASE WHEN SUM(D1)>0 THEN 1 ELSE 0 END D1, \n";
			sSQLs+="					CASE WHEN SUM(D2)>0 THEN 1 ELSE 0 END D2, \n";
			sSQLs+="					CASE WHEN SUM(D3)>0 THEN 1 ELSE 0 END D3, \n";
			sSQLs+="					CASE WHEN SUM(D4)>0 THEN 1 ELSE 0 END D4, \n";
			sSQLs+="					CASE WHEN SUM(D5)>0 THEN 1 ELSE 0 END D5, \n";
			sSQLs+="					CASE WHEN SUM(D6)>0 THEN 1 ELSE 0 END D6, \n";
			sSQLs+="					CASE WHEN SUM(D7)>0 THEN 1 ELSE 0 END D7, \n";
			sSQLs+="					CASE WHEN SUM(D8)>0 THEN 1 ELSE 0 END D8, \n";
			sSQLs+="					CASE WHEN SUM(D9)>0 THEN 1 ELSE 0 END D9, \n";
			sSQLs+="					CASE WHEN SUM(D10)>0 THEN 1 ELSE 0 END D10, \n";
			sSQLs+="					CASE WHEN SUM(D11)>0 THEN 1 ELSE 0 END D11, \n";
			sSQLs+="					CASE WHEN SUM(D12)>0 THEN 1 ELSE 0 END D12, \n";
			sSQLs+="					CASE WHEN SUM(D13)>0 THEN 1 ELSE 0 END D13, \n";
			sSQLs+="					CASE WHEN SUM(D14)>0 THEN 1 ELSE 0 END D14, \n";
			sSQLs+="					CASE WHEN SUM(D15)>0 THEN 1 ELSE 0 END D15, \n";
			sSQLs+="					CASE WHEN SUM(D16)>0 THEN 1 ELSE 0 END D16, \n";
			sSQLs+="					CASE WHEN SUM(A1)>0 THEN 1 ELSE 0 END A1, \n";
			sSQLs+="					CASE WHEN SUM(A2)>0 THEN 1 ELSE 0 END A2, \n";
			sSQLs+="					CASE WHEN SUM(A3)>0 THEN 1 ELSE 0 END A3, \n";
			sSQLs+="					CASE WHEN SUM(A4)>0 THEN 1 ELSE 0 END A4, \n";
			sSQLs+="					CASE WHEN SUM(A5)>0 THEN 1 ELSE 0 END A5, \n";
			sSQLs+="					CASE WHEN SUM(A6)>0 THEN 1 ELSE 0 END A6, \n";
			sSQLs+="					CASE WHEN SUM(A7)>0 THEN 1 ELSE 0 END A7, \n";
			sSQLs+="					CASE WHEN SUM(A8)>0 THEN 1 ELSE 0 END A8, \n";
			sSQLs+="					CASE WHEN SUM(A9)>0 THEN 1 ELSE 0 END A9, \n";
			sSQLs+="					CASE WHEN SUM(A10)>0 THEN 1 ELSE 0 END A10, \n";
			sSQLs+="					CASE WHEN SUM(A11)>0 THEN 1 ELSE 0 END A11, \n";
			sSQLs+="					CASE WHEN SUM(A12)>0 THEN 1 ELSE 0 END A12, \n";
			sSQLs+="					CASE WHEN SUM(A13)>0 THEN 1 ELSE 0 END A13, \n";
			sSQLs+="					CASE WHEN SUM(A14)>0 THEN 1 ELSE 0 END A14, \n";
			sSQLs+="					CASE WHEN SUM(A15)>0 THEN 1 ELSE 0 END A15, \n";
			sSQLs+="					CASE WHEN SUM(A16)>0 THEN 1 ELSE 0 END A16, \n";
			sSQLs+="					CASE WHEN SUM(A17)>0 THEN 1 ELSE 0 END A17, \n";
			sSQLs+="					CASE WHEN SUM(A18)>0 THEN 1 ELSE 0 END A18, \n";
			sSQLs+="					CASE WHEN SUM(A19)>0 THEN 1 ELSE 0 END A19, \n";
			sSQLs+="					CASE WHEN SUM(A20)>0 THEN 1 ELSE 0 END A20, \n";			sSQLs+="					CASE WHEN SUM(A21)>0 THEN 1 ELSE 0 END A21, \n";			sSQLs+="					CASE WHEN SUM(A22)>0 THEN 1 ELSE 0 END A22, \n";			sSQLs+="					CASE WHEN SUM(A23)>0 THEN 1 ELSE 0 END A23, \n";			sSQLs+="					CASE WHEN SUM(A24)>0 THEN 1 ELSE 0 END A24, \n";			sSQLs+="					CASE WHEN SUM(A25)>0 THEN 1 ELSE 0 END A25, \n";			sSQLs+="					CASE WHEN SUM(A26)>0 THEN 1 ELSE 0 END A26 \n";			sSQLs+="				FROM ( \n";
			sSQLs+="					SELECT * \n";
			sSQLs+="					FROM HADO_TB_SOENT_SURVEY_RESULT \n";
			sSQLs+="					WHERE OENT_GB='" + session.getAttribute("wgb") + "' \n";
			sSQLs+="						AND CURRENT_YEAR='" + currentYear + "' \n";
			if( currentYear >= 2012 ) {
				sSQLs+="						AND LENGTH(mng_no)>=8 \n";
				sSQLs+="				) CC \n";
				sSQLs+="				GROUP BY SUBSTR(MNG_NO,1,8),CURRENT_YEAR,OENT_GB \n";
			} else if( currentYear == 2011 ) {
				sSQLs+="						AND LENGTH(mng_no)>=9 \n";
				sSQLs+="				) CC \n";
				sSQLs+="				GROUP BY SUBSTR(MNG_NO,1,9),CURRENT_YEAR,OENT_GB \n";
			} else {
				sSQLs+="						AND LENGTH(mng_no)>=10 \n";
				sSQLs+="				) CC \n";
				sSQLs+="				GROUP BY SUBSTR(MNG_NO,1,10),CURRENT_YEAR,OENT_GB \n";
			}
			sSQLs+="			) A LEFT JOIN "+currentOent+" B ON A.CURRENT_YEAR=B.CURRENT_YEAR \n";
			sSQLs+="				AND A.OENT_GB=B.OENT_GB \n";
			sSQLs+="				AND A.MNG_NO=B.MNG_NO \n";
			sSQLs+="		) mT1 \n";
			if( !sCapa.equals("") ) {
				if( currentYear>=2015 ) {
					// 2015년 부터 1:대기업, 2:중견기업, 3:중소기업으로 사용됨.
					if( sCapa.equals("1") ) {
						sSQLs+="		WHERE (Oent_Capa='1' OR Oent_Capa='2') \n";
					} else {
						sSQLs+="		WHERE Oent_Capa='3' \n";
					}
				}  else {
					sSQLs+="		WHERE Oent_Capa='"+sCapa+"' \n";
				}
			}
			sSQLs+="	) VT_TABLE \n";
			sSQLs+="	GROUP BY OENT_TYPE \n";
			if( currentYear >= 2012 ) {
				sSQLs+=") C LEFT JOIN COMMON_CD D ON C.OENT_TYPE=D.COMMON_CD \n";
				sSQLs+="	AND D.Common_GB='010' \n";
				sSQLs+="ORDER BY C.OENT_TYPE \n";
			} else {
				sSQLs+=") C LEFT JOIN COMMON_CD D ON C.OENT_TYPE=D.COMMON_CD \n";
				sSQLs+="	D.ADDON_GB='" + session.getAttribute("wgb") + "' \n";
				sSQLs+="ORDER BY C.OENT_TYPE \n";
			}
			//System.out.println(sSQLs);
			pstmt = conn.prepareStatement(sSQLs);			rs = pstmt.executeQuery();
			nLoop = 1;
			while( rs.next() ) {
				/* 기존 대금/비대금 구분없이 저장하던 배열 대금과 비대금으로 분리 / 2015-10-01 / 정광식
					arrMoney[][]의 arrMoney[nLoop][0] 은 업종명을 저장하고 나머지는 대금관련 위반혐의내역 저장
					arrNoMoney[][] 비대금 위반혐의내역 저장;
					각 [nLoop][21]번째에는 해당업종 합계 저장
				*/
				arrMoney[nLoop][0] = StringUtil.checkNull(rs.getString("TYPECD")).trim();
				arrMoney[nLoop][21] = "0";
				arrNoMoney[nLoop][31] = "0";
				for( int x=1; x<=26; x++ ) {
					// 대금관련은 16개까지만 존재
					if( x<=16 ) { 
						arrMoney[nLoop][x] =  rs.getString("D"+x)==null ? "0":rs.getString("D"+x);
						arrMoney[nLoop][21] = "" + (Float.parseFloat(arrMoney[nLoop][21]) + Float.parseFloat(arrMoney[nLoop][x]));
						arrSum[x] = arrSum[x] + Float.parseFloat(arrMoney[nLoop][x]);
						fMoneySum = fMoneySum + Float.parseFloat(arrMoney[nLoop][x]);					}
					arrNoMoney[nLoop][x] =  rs.getString("A"+x)==null ? "0":rs.getString("A"+x);;
					arrNoMoney[nLoop][31] = "" + (Float.parseFloat(arrNoMoney[nLoop][31]) + Float.parseFloat(arrNoMoney[nLoop][x]));
					arrSum[x+31] = arrSum[x+31] + Float.parseFloat(arrNoMoney[nLoop][x]);
					fNoMoneySum = fNoMoneySum + Float.parseFloat(arrNoMoney[nLoop][x]);
				}
				nLoop++;
			}
			rs.close();
			nLoop--;
		}		catch(Exception e){			e.printStackTrace();		}		finally {			if ( rs != null ) try{rs.close();}catch(Exception e){}			if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}			if ( conn != null ) try{conn.close();}catch(Exception e){}			if ( resource != null ) resource.release();		}	}%><meta charset="utf-8">
<script type="text/javascript">//<![CDATA[
content = "";
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
	tmpSum = fMoneySum + fNoMoneySum;
%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan=2>계</th>";
content+="		<td rowspan=2 style='text-align:right;'><%=formater2.format(tmpSum)%></td>";
	<%for(int x=1; x<=money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater2.format(arrSum[x])%></td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater2.format(fMoneySum)%></td>";
	<%for(int x=1; x<=no_money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater2.format(arrSum[x+31])%></td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater2.format(fNoMoneySum)%></td>";
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for(int x=1; x<=money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater.format(arrSum[x] / tmpSum * 100)%>%</td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater.format(fMoneySum / tmpSum * 100)%>%</td>";
	<%for(int x=1; x<=no_money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater.format(arrSum[x+31] / tmpSum * 100)%>%</td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater.format(fNoMoneySum / tmpSum * 100)%>%</td>";
content+="	</tr>";
<%for(i=1; i<=nLoop; i++) {
	tmpSum = Float.parseFloat(arrMoney[i][21])+Float.parseFloat(arrNoMoney[i][31]);%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan=2><%=arrMoney[i][0]%></th>";
content+="		<td rowspan=2 style='text-align:right;'><%=formater2.format(tmpSum)%></td>";
	<%for(int x=1; x<=money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrMoney[i][x]))%></td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrMoney[i][21]))%></td>";
	<%for(int x=1; x<=no_money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrNoMoney[i][x]))%></td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrNoMoney[i][31]))%></td>";
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for(int x=1; x<=money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater.format(Float.parseFloat(arrMoney[i][x]) / tmpSum * 100)%>%</td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater.format(Float.parseFloat(arrMoney[i][21]) / tmpSum * 100)%>%</td>";
	<%for(int x=1; x<=no_money_cnt; x++) {%>
content+="		<td style='text-align:right;'><%=formater.format(Float.parseFloat(arrNoMoney[i][x]) / tmpSum * 100)%>%</td>";
	<%}%>
content+="		<td style='text-align:right;'><%=formater.format(Float.parseFloat(arrNoMoney[i][31]) / tmpSum * 100)%>%</td>";
content+="	</tr>";
<%}%>
<%}%>
content+="</table>";
top.document.getElementById("divResult").innerHTML = content;top.setNowProcessFalse();//]]</script>
<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>