<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%><%/*** 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업* 프로그램명	: Oent_Submit_Total_proc.jsp* 프로그램설명	: 원사업자 > 제출현황 > 전체 제출현황* 프로그램버전	: 1.0.1* 최초작성일자	: 2009년 05월* 작 성 이 력       :*=========================================================*	작성일자		작성자명				내용*=========================================================*	2009-05-00	정광식       최초작성*	2015-07-21	강슬기       업종별 제출현황 출력 시 업종 순서 별로 출력되도록 SQL문 수정*	2016-01-08	민현근		DB변경으로 인한 인코딩 변경*/%><%@ page import="java.sql.*"%><%@ page import="java.util.*"%><%@ page import="ftc.util.*"%><%@ page import="ftc.db.ConnectionResource"%><%@ page import="ftc.db.ConnectionResource2"%><%@ page import="java.text.DecimalFormat"%><%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%><%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%><%/*---------------------------------------- Variable Difinition ----------------------------------------*/	String stt = StringUtil.checkNull(request.getParameter("tt")).trim();	String comm = StringUtil.checkNull(request.getParameter("comm")).trim();	ConnectionResource resource = null;	Connection conn = null;	PreparedStatement pstmt = null;	ResultSet rs = null;	String sCYear = st_Current_Year;	String sSQLs = "";	String oentgb = "";	String oentgbVal = "";    String oentType  = "";    String asType  = "";    String typCnt = "";     String totalB = "";     String totalD = "";     String subCon = "";     String ba = "";     String ca = "";     String da = "";     String ea = "";     String d1 = "";     String d2 = "";     String d3 = "";     String d4 = "";     String d5 = "";     String d6 = "";     String d7 = "";     String d8 = "";         String result = "";  	java.util.Calendar cal = java.util.Calendar.getInstance();	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.00");/*-----------------------------------------------------------------------------------------------------*//*=================================== Record Selection Processing =====================================*/	String tmpYear = StringUtil.checkNull(request.getParameter("cyear")).trim();	String tmpStr  = StringUtil.checkNull(request.getParameter("wgb")).trim();	if( !tmpYear.equals("") ) {		session.setAttribute("cyear", tmpYear);	} else {		session.setAttribute("cyear", st_Current_Year);	}  	if( tmpStr != null && !tmpStr.equals("") ) {		session.setAttribute("wgb", tmpStr);	}	int currentYear = st_Current_Year_n;	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");    try {		resource = new ConnectionResource();		conn = resource.getConnection();            		    sSQLs =  "  SELECT                                                                                                                          \n";            sSQLs += "         '' OENT_TYPE                                                                                                             \n";            sSQLs += "        ,'' AS_TYPE                                                                                                               \n";            sSQLs += "        ,SUM(AA.TYP_CNT) TYP_CNT                                                                                                  \n";            sSQLs += "        ,SUM(AA.TOTALB)  TOTALB                                                                                                   \n";            sSQLs += "        ,SUM(AA.TOTALD)  TOTALD                                                                                                   \n";            sSQLs += "        ,SUM(AA.SUBCON)  SUBCON                                                                                                   \n";            sSQLs += "        ,SUM(AA.D1) D1                                                                                                            \n";            sSQLs += "        ,SUM(AA.D2) D2                                                                                                            \n";            sSQLs += "        ,SUM(AA.D3) D3                                                                                                            \n";            sSQLs += "        ,SUM(AA.D4) D4                                                                                                            \n";            sSQLs += "        ,SUM(AA.D5) D5                                                                                                            \n";            sSQLs += "        ,SUM(AA.D6) D6                                                                                                            \n";            sSQLs += "        ,SUM(AA.D7) D7                                                                                                            \n";            sSQLs += "        ,SUM(AA.D8) D8                                                                                                            \n";            sSQLs += "        ,TO_CHAR(TRUNC((SUM(TOTALB)/SUM(TYP_CNT)*100), 2), 'FM999990.00') BA                                                      \n";            sSQLs += "        ,TO_CHAR(TRUNC((SUM(SUBCON)/SUM(TYP_CNT)*100), 2), 'FM999990.00') CA                                                      \n";            sSQLs += "        ,TO_CHAR(TRUNC((SUM(TOTALD)/SUM(TYP_CNT)*100), 2), 'FM999990.00') DA                                                      \n";            sSQLs += "        ,TO_CHAR(TRUNC((SUM(D8)/SUM(TYP_CNT)*100), 2), 'FM999990.00') EA                                                          \n";            sSQLs += "  FROM (                                                                                                                          \n";            sSQLs += "  SELECT                                                                                                                          \n";            sSQLs += "      A.OENT_TYPE,                                                                                                                \n";            sSQLs += "      C.COMMON_CD||'('||C.COMMON_NM ||')' AS_TYPE,                                                                                \n";            sSQLs += "      COUNT(OENT_TYPE) TYP_CNT,                                                                                                   \n";            sSQLs += "      SUM(CASE OENT_STATUS WHEN '1' THEN 1 ELSE 0 END ) TOTALB,                                                                   \n";            sSQLs += "      SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                          \n";            sSQLs += "          CASE WHEN SP_FLD_02 IS NULL THEN                                                                                        \n";            sSQLs += "              CASE WHEN (CASE WHEN COMP_STATUS = '1' THEN '0' ELSE '1' END) = '0' THEN 1 ELSE 0 END                               \n";            sSQLs += "          ELSE 0 END                                                                                                              \n";            sSQLs += "      ELSE 0 END) D1,                                                                                                             \n";            sSQLs += "      SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                          \n";            sSQLs += "              CASE WHEN SP_FLD_02 IS NULL THEN                                                                                    \n";            sSQLs += "                  CASE WHEN (SELECT TO_NUMBER(C) FROM HADO_TB_OENT_ANSWER_2021                                                    \n";            sSQLs += "                             WHERE MNG_NO = A.MNG_NO AND CURRENT_YEAR = A.CURRENT_YEAR AND OENT_GB = A.OENT_GB                    \n";            sSQLs += "                              AND OENT_Q_CD = 5 AND OENT_Q_GB = 1) = 1                                                            \n";            sSQLs += "                             THEN 1 ELSE 0 END                                                                                    \n";            sSQLs += "          ELSE 0 END                                                                                                              \n";            sSQLs += "      ELSE 0 END ) SUBCON,                                                                                                        \n";            sSQLs += "      SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                          \n";            sSQLs += "          CASE WHEN SP_FLD_02 IS NOT NULL THEN 1 ELSE 0 END                                                                       \n";            sSQLs += "      ELSE 0 END) D2,                                                                                                             \n";            sSQLs += "      SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                          \n";            sSQLs += "          CASE WHEN SP_FLD_02 IS NOT NULL THEN                                                                                    \n";            sSQLs += "              CASE WHEN (CASE WHEN COMP_STATUS = '1' THEN '0' ELSE '1' END) = '0' THEN 1 ELSE 0 END                               \n";            sSQLs += "          ELSE 0 END                                                                                                              \n";            sSQLs += "      ELSE 0 END) D3,                                                                                                             \n";            sSQLs += "      SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                          \n";            sSQLs += "          CASE WHEN SP_FLD_02 IS NOT NULL THEN                                                                                    \n";            sSQLs += "              CASE WHEN (CASE WHEN COMP_STATUS = '2' THEN '0' ELSE '1' END) = '0' THEN 1 ELSE 0 END                               \n";            sSQLs += "          ELSE 0 END                                                                                                              \n";            sSQLs += "      ELSE 0 END) D4,                                                                                                             \n";            sSQLs += "      SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                          \n";            sSQLs += "          CASE WHEN SP_FLD_02 IS NOT NULL THEN                                                                                    \n";            sSQLs += "              CASE WHEN (CASE WHEN COMP_STATUS = '3' THEN '0' ELSE '1' END) = '0' THEN 1 ELSE 0 END                               \n";            sSQLs += "          ELSE 0 END                                                                                                              \n";            sSQLs += "      ELSE 0 END) D5,                                                                                                             \n";            sSQLs += "      SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                          \n";            sSQLs += "          CASE WHEN SP_FLD_02 IS NOT NULL THEN                                                                                    \n";            sSQLs += "              CASE WHEN (CASE WHEN COMP_STATUS = '4' THEN '0' ELSE '1' END) = '0' THEN 1 ELSE 0 END                               \n";            sSQLs += "          ELSE 0 END                                                                                                              \n";            sSQLs += "      ELSE 0 END) D6,                                                                                                             \n";            sSQLs += "      SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                          \n";            sSQLs += "                    CASE WHEN SP_FLD_02 IS NOT NULL THEN                                                                          \n";            sSQLs += "                        CASE WHEN (CASE WHEN COMP_STATUS = '5' THEN '0' ELSE '1' END) = '0' THEN 1 ELSE 0 END                     \n";            sSQLs += "                    ELSE 0 END                                                                                                    \n";            sSQLs += "                ELSE 0 END) D7,                                                                                                   \n";            sSQLs += "                SUM(CASE WHEN OENT_STATUS IS NULL THEN 1 ELSE 0 END ) TOTALD,                                                     \n";            sSQLs += "                SUM(CASE WHEN OENT_STATUS IS NULL THEN                                                                            \n";            sSQLs += "                        CASE WHEN ADDR_STATUS = '1' OR ADDR_STATUS = '2' THEN 1 ELSE 0 END                                        \n";            sSQLs += "                ELSE 0 END ) D8                                                                                                   \n";            sSQLs += "            FROM HADO_TB_OENT_2021 A, COMMON_CD C                                                                                 \n";            sSQLs += "            WHERE A.OENT_TYPE = C.COMMON_CD                                                                                       \n";            sSQLs += "                AND C.COMMON_GB='010'                                                                                             \n";            sSQLs += "                AND C.COMMON_CD !='I56'                                                                                           \n";            sSQLs += "                AND C.ADDON_GB='"+tmpStr+"'                                                                                                \n";            sSQLs += "                AND A.OENT_GB ='"+tmpStr+"'                                                                                               \n";            sSQLs += "                AND CURRENT_YEAR='2021'                                                                                           \n";            sSQLs += "                AND SUBSTR(MNG_NO,-7)<>'1234567'                                                                                  \n";            sSQLs += "                AND LENGTH(Mng_No)>6                                                                                              \n";            sSQLs += "            GROUP BY A.OENT_TYPE, c.COMMON_CD, c.COMMON_NM                                                                        \n";            sSQLs += "            ORDER BY A.OENT_TYPE ) AA                                                                                             \n";            sSQLs += "            UNION ALL                                                                                                             \n";            sSQLs += "            SELECT                                                                                                                \n";            sSQLs += "                   AA.*                                                                                                           \n";            sSQLs += "                  ,to_char(TRUNC((TOTALB/TYP_CNT*100), 2), 'FM999990.00') BA                                                      \n";            sSQLs += "                  ,to_char(TRUNC((SUBCON/TYP_CNT*100), 2), 'FM999990.00') CA                                                      \n";            sSQLs += "                  ,to_char(TRUNC((TOTALD/TYP_CNT*100), 2), 'FM999990.00') DA                                                      \n";            sSQLs += "                  ,to_char(TRUNC((D8/TYP_CNT*100), 2), 'FM999990.00') EA                                                          \n";            sSQLs += "            FROM (                                                                                                                \n";            sSQLs += "            SELECT                                                                                                                \n";            sSQLs += "                A.OENT_TYPE,                                                                                                      \n";            sSQLs += "                C.COMMON_CD||'('||C.COMMON_NM ||')' AS_TYPE,                                                                      \n";            sSQLs += "                COUNT(OENT_TYPE) TYP_CNT,                                                                                         \n";            sSQLs += "                SUM(CASE OENT_STATUS WHEN '1' THEN 1 ELSE 0 END ) TOTALB,                                                         \n";            sSQLs += "                SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                \n";            sSQLs += "                    CASE WHEN SP_FLD_02 IS NULL THEN                                                                              \n";            sSQLs += "                        CASE WHEN (CASE WHEN COMP_STATUS = '1' THEN '0' ELSE '1' END) = '0' THEN 1 ELSE 0 END                     \n";            sSQLs += "                    ELSE 0 END                                                                                                    \n";            sSQLs += "                ELSE 0 END) D1,                                                                                                   \n";            sSQLs += "                SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                \n";            sSQLs += "                        CASE WHEN SP_FLD_02 IS NULL THEN                                                                          \n";            sSQLs += "                            CASE WHEN (SELECT TO_NUMBER(C) FROM HADO_TB_OENT_ANSWER_2021                                          \n";            sSQLs += "                                       WHERE MNG_NO = A.MNG_NO AND CURRENT_YEAR = A.CURRENT_YEAR AND OENT_GB = A.OENT_GB          \n";            sSQLs += "                                       AND OENT_Q_CD = 5 AND OENT_Q_GB = 1) = 1                                                   \n";            sSQLs += "                                       THEN 1 ELSE 0 END                                                                          \n";            sSQLs += "                    ELSE 0 END                                                                                                    \n";            sSQLs += "                ELSE 0 END ) SUBCON,                                                                                              \n";            sSQLs += "                SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                \n";            sSQLs += "                    CASE WHEN SP_FLD_02 IS NOT NULL THEN 1 ELSE 0 END                                                             \n";            sSQLs += "                ELSE 0 END) D2,                                                                                                   \n";            sSQLs += "                SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                \n";            sSQLs += "                    CASE WHEN SP_FLD_02 IS NOT NULL THEN                                                                          \n";            sSQLs += "                        CASE WHEN (CASE WHEN COMP_STATUS = '1' THEN '0' ELSE '1' END) = '0' THEN 1 ELSE 0 END                     \n";            sSQLs += "                    ELSE 0 END                                                                                                    \n";            sSQLs += "                ELSE 0 END) D3,                                                                                                   \n";            sSQLs += "                SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                \n";            sSQLs += "                    CASE WHEN SP_FLD_02 IS NOT NULL THEN                                                                          \n";            sSQLs += "                        CASE WHEN (CASE WHEN COMP_STATUS = '2' THEN '0' ELSE '1' END) = '0' THEN 1 ELSE 0 END                     \n";            sSQLs += "                    ELSE 0 END                                                                                                    \n";            sSQLs += "                ELSE 0 END) D4,                                                                                                   \n";            sSQLs += "                SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                \n";            sSQLs += "                    CASE WHEN SP_FLD_02 IS NOT NULL THEN                                                                          \n";            sSQLs += "                        CASE WHEN (CASE WHEN COMP_STATUS = '3' THEN '0' ELSE '1' END) = '0' THEN 1 ELSE 0 END                     \n";            sSQLs += "                    ELSE 0 END                                                                                                    \n";            sSQLs += "                ELSE 0 END) D5,                                                                                                   \n";            sSQLs += "                SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                \n";            sSQLs += "                    CASE WHEN SP_FLD_02 IS NOT NULL THEN                                                                          \n";            sSQLs += "                        CASE WHEN (CASE WHEN COMP_STATUS = '4' THEN '0' ELSE '1' END) = '0' THEN 1 ELSE 0 END                     \n";            sSQLs += "                    ELSE 0 END                                                                                                    \n";            sSQLs += "                ELSE 0 END) D6,                                                                                                   \n";            sSQLs += "                SUM(CASE OENT_STATUS WHEN '1' THEN                                                                                \n";            sSQLs += "                    CASE WHEN SP_FLD_02 IS NOT NULL THEN                                                                          \n";            sSQLs += "                        CASE WHEN (CASE WHEN COMP_STATUS = '5' THEN '0' ELSE '1' END) = '0' THEN 1 ELSE 0 END                     \n";            sSQLs += "                    ELSE 0 END                                                                                                    \n";            sSQLs += "                ELSE 0 END) D7,                                                                                                   \n";            sSQLs += "                SUM(CASE WHEN OENT_STATUS IS NULL THEN 1 ELSE 0 END ) TOTALD,                                                     \n";            sSQLs += "                SUM(CASE WHEN OENT_STATUS IS NULL THEN                                                                            \n";            sSQLs += "                        CASE WHEN ADDR_STATUS = '1' OR ADDR_STATUS = '2' THEN 1 ELSE 0 END                                        \n";            sSQLs += "                ELSE 0 END ) D8                                                                                                   \n";            sSQLs += "            FROM HADO_TB_OENT_2021 A, COMMON_CD C                                                                                 \n";            sSQLs += "            WHERE A.OENT_TYPE = C.COMMON_CD                                                                                       \n";            sSQLs += "                AND C.COMMON_GB='010'                                                                                             \n";            sSQLs += "                AND C.COMMON_CD !='I56'                                                                                           \n";            sSQLs += "                AND C.ADDON_GB='"+tmpStr+"'                                                                                                \n";            sSQLs += "                AND A.OENT_GB ='"+tmpStr+"'                                                                                               \n";            sSQLs += "                AND CURRENT_YEAR='2021'                                                                                           \n";            sSQLs += "                AND SUBSTR(MNG_NO,-7)<>'1234567'                                                                                  \n";            sSQLs += "                AND LENGTH(Mng_No)>6                                                                                              \n";            sSQLs += "            GROUP BY A.OENT_TYPE, c.COMMON_CD, c.COMMON_NM                                                                        \n";            sSQLs += "            ORDER BY A.OENT_TYPE ) AA                                                                                             \n";            			System.out.println(sSQLs);				pstmt = conn.prepareStatement(sSQLs);			rs = pstmt.executeQuery();			while( rs.next() ) {			    oentType = rs.getString("OENT_TYPE")==null ? "":rs.getString("OENT_TYPE").trim();			    asType = rs.getString("AS_TYPE")==null ? "":rs.getString("AS_TYPE").trim();			    typCnt = rs.getString("TYP_CNT")==null ? "":rs.getString("TYP_CNT").trim();                totalB = rs.getString("TOTALB")==null ? "":rs.getString("TOTALB").trim();                totalD = rs.getString("TOTALD")==null ? "":rs.getString("TOTALD").trim();                subCon = rs.getString("SUBCON")==null ? "":rs.getString("SUBCON").trim();                ba     = rs.getString("BA")==null ? "":rs.getString("BA").trim();                    ca     = rs.getString("CA")==null ? "":rs.getString("CA").trim();                    da     = rs.getString("DA")==null ? "":rs.getString("DA").trim();                    ea     = rs.getString("EA")==null ? "":rs.getString("EA").trim();                    d1     = rs.getString("D1")==null ? "":rs.getString("D1").trim();                    d2     = rs.getString("D2")==null ? "":rs.getString("D2").trim();                    d3     = rs.getString("D3")==null ? "":rs.getString("D3").trim();                    d4     = rs.getString("D4")==null ? "":rs.getString("D4").trim();                    d5     = rs.getString("D5")==null ? "":rs.getString("D5").trim();                    d6     = rs.getString("D6")==null ? "":rs.getString("D6").trim();                    d7     = rs.getString("D7")==null ? "":rs.getString("D7").trim();                    d8     = rs.getString("D8")==null ? "":rs.getString("D8").trim();                                if ("".equals(oentType)) {                    oentgbVal = "전체";                }  else {                    oentgbVal = asType;                }                                result += "<tr>";                result += "<td>"+oentgbVal+"</td>";                result += "<td>"+typCnt.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"</td>";                result += "<td>"+totalB.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"</td>";                result += "<td>"+d1.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"</td>";                result += "<td>"+subCon.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"</td>";                result += "<td>"+d2.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"</td>";                result += "<td>"+d3.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"</td>";                result += "<td>"+d4.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"</td>";                result += "<td>"+d5.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"</td>";                result += "<td>"+d6.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"</td>";                result += "<td>"+d7.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"</td>";                result += "<td>"+totalD.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"</td>";                result += "<td>"+d8.replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",")+"</td>";                result += "<td>"+ba+"%</td>";                result += "<td>"+ca+"%</td>";                result += "<td>"+da+"%</td>";                result += "<td>"+ea+"%</td>";                result +="</tr>";			}     //  System.out.println("result ==> " + result);			rs.close();	}catch(Exception e){		e.printStackTrace();	}finally {		if ( rs != null ) try{rs.close();}catch(Exception e){}		if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}		if ( conn != null ) try{conn.close();}catch(Exception e){}		if ( resource != null ) resource.release();	}/*=====================================================================================================*/%><meta charset="utf-8"><script type="text/javascript">//<![CDATA[content = "";content+="<table id='divButton'>";content+="	<tr>";content+="		<td><%=cal.get(Calendar.YEAR)%>년<%=cal.get(Calendar.MONTH)+1%>월<%=cal.get(Calendar.DATE)%>일(현재)</td>";content+="	</tr>";content+="</table>";content+="<table class='resultTable'>";content+="	<tr>";content+="		<th rowspan=3 height=240px width=80px>업종별</th>";content+="		<th rowspan=3>조사대상업체(A)</th>";content+="		<th colspan=9>제출</th>";content+="		<th colspan=2>미제출</th>";content+="		<th colspan=4>비율</th>";content+="	</tr>";content+="	<tr>";content+="		<th rowspan= 2>소계(B)</th>";content+="		<th colspan= 2>대상됨</th>";content+="		<th colspan= 6>대상아님</th>";content+="		<th rowspan= 2>소계(D)</th>";content+="		<th rowspan= 2>소재불명등, 폐업 등(E)</th>";content+="		<th rowspan= 2>B/A</th>";content+="		<th rowspan= 2>C/A</th>";content+="		<th rowspan= 2>D/A</th>";content+="		<th rowspan= 2>E/A</th>";content+="	</tr>";content+="	<tr>";content+="		<th>정상영업</th>";content+="		<th>하도급거래없음(C)</th>";content+="		<th>소계</th>";content+="		<th>정상영업</th>";content+="		<th>기업회생절차 진행 중</th>";content+="		<th>영업중단 또는 폐업 준비 중</th>";content+="		<th>다른회사와 합병 진행 중</th>";content+="		<th>기타</th>";content+="	</tr>";content+="<%=result%>"; content+="</table>";top.document.getElementById("divResult").innerHTML = content;top.setNowProcessFalse();//]]</script><%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>