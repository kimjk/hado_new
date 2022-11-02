<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
	String stt = StringUtil.checkNull(request.getParameter("tt"));
	String comm = StringUtil.checkNull(request.getParameter("comm"));
	
	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sSQLs = "";
	String sField = "";
	String tmpString = "";
	String tmpStr = "";

	String[] arrData = new String[36];
	// 위반행위명 배열
	String[] money_nm = new String[16];
	String[] money_cd = new String[16];
	String[] no_money_nm = new String[16];
	String[] no_money_cd = new String[16];

	int nLoop = 1;
	int i = 0;
	int j = 0;
	
	int money_cnt = 8;
	int no_money_cnt = 8;
	int field_cnt = 19;

	int sStartYear = 2007;

	java.util.Calendar cal = java.util.Calendar.getInstance();

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2 = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	String tmpYear = StringUtil.checkNull(request.getParameter("cyear")).trim();
	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
	}
	
	int currentYear = st_Current_Year_n;
	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");
	
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		
		if( currentYear>=2010 ) {
			// 위반혐의항목 세팅
			sSQLs ="SELECT Oent_Q_CDNM,RANK,('['||RTRIM(MIN(Oent_Q_CD))||'-'||RTRIM(MIN(Oent_Q_GB))||']') q_code,money_gb \n";
			sSQLs+="FROM HADO_TB_Oent_Question \n";
			sSQLs+="WHERE Oent_GB='2' \n";
			sSQLs+="	AND Current_Year='"+currentYear+"' \n";
			sSQLs+="	AND (Money_GB='1' OR Money_GB='2') \n";
			sSQLs+="GROUP BY Oent_Q_CDNM,Money_GB,RANK \n";
			sSQLs+="ORDER BY Money_GB,RANK \n";
			
			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();

			i = 1;
			j = 1;
			while( rs.next() ) {
				tmpStr = rs.getString("money_gb");
				if( tmpStr.trim().equals("1") ) {
					money_nm[i] = new String( StringUtil.checkNull(rs.getString("Oent_Q_CDNM")).trim().getBytes("ISO8859-1"), "utf-8" );
					money_cd[i] = StringUtil.checkNull(rs.getString("Q_Code")).trim();
					i++;
				} else {
					no_money_nm[j] = new String( StringUtil.checkNull(rs.getString("Oent_Q_CDNM")).trim().getBytes("ISO8859-1"), "utf-8" );
					no_money_cd[j] = StringUtil.checkNull(rs.getString("Q_Code")).trim();
					j++;
				}
			}
			rs.close();

			money_cnt = i - 1;
			no_money_cnt = j - 1;
			field_cnt = money_cnt + no_money_cnt + 3;
		} else {
			money_nm[1] = new String("선급금 미지급");
			money_cd[1] = new String("3-1");
			money_nm[2] = new String("하도급대금 부당감액");
			money_cd[2] = new String("5-1");
			money_nm[3] = new String("하도급대금 미지급");
			money_cd[3] = new String("7-1");
			money_nm[4] = new String("지연이자 미지급");
			money_cd[4] = new String("7-2");
			money_nm[5] = new String("어음할인료 미지급");
			money_cd[5] = new String("7-3");
			money_nm[6] = new String("어음대체결제 수수료 미지급");
			money_cd[6] = new String("7-4");
			money_nm[7] = new String("설계변경 미조정");
			money_cd[7] = new String("9-1");
			money_nm[8] = new String("물가변동 미조정");
			money_cd[8] = new String("9-2");
			no_money_nm[1] = new String("서면 미발급");
			no_money_cd[1] = new String("1-1");
			no_money_nm[2] = new String("부당한 하도급대금 결정");
			no_money_cd[2] = new String("2-1");
			no_money_nm[3] = new String("부당한 인수거부");
			no_money_cd[3] = new String("4-1");
			no_money_nm[4] = new String("부당한 발주취소");
			no_money_cd[4] = new String("4-2");
			no_money_nm[5] = new String("물품 구매강제 또는 물품구매대금 부당결제청구");
			no_money_cd[5] = new String("6-1");
			no_money_nm[6] = new String("하도급대금지급 미보증");
			no_money_cd[6] = new String("8-1");
			no_money_nm[7] = new String("부당한 대물변제");
			no_money_cd[7] = new String("10-1");
			no_money_nm[8] = new String("탈법행위");
			no_money_cd[8] = new String("11-1");
			no_money_nm[9] = new String("경제적이익의 부당요구");
			no_money_cd[9] = new String("12-1");

			money_cnt = 8;
			no_money_cnt = 9;
			field_cnt = money_cnt + no_money_cnt + 3;
		}

		if( !stt.equals("start") ) {

			sSQLs ="SELECT NVL(SUM(d_t+a_t),0), \n";
			for(i=1; i<=money_cnt; i++) {
				sSQLs+="	NVL(SUM(d"+i+"),0), \n";
			}
			sSQLs+="	NVL(SUM(d_t),0), \n";
			for(i=1; i<=no_money_cnt; i++) {
				sSQLs+="	NVL(SUM(a"+i+"),0), \n";
			}
			sSQLs+="	NVL(SUM(a_t),0) \n";
			sSQLs+="FROM HADO_TB_Survey_Print2 \n";
			sSQLs+="WHERE Current_Year='" + currentYear + "' \n";
			
			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();

			while( rs.next() ) {
				for(int ni=1; ni<=field_cnt; ni++) {
					arrData[ni] = rs.getString(ni);
				}
			}
			rs.close();
		}
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
%>

<script language="javascript">
content = "";

content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th rowspan=2>구분</th>";
content+="		<th rowspan=2>위반행위수</th>";
content+="		<th colspan=<%=money_cnt+1%>>대금관련 위반사항</th>";
content+="		<th colspan=<%=no_money_cnt+1%>>비대금관련 위반사항</th>";
content+="	</tr>";
content+="	<tr>";
<%for(j=1; j<=money_cnt; j++) {%>
content+="		<th><%=money_nm[j]%></th>";
<%}%>
content+="		<th>소계</th>";
<%for(j=1; j<=no_money_cnt; j++) {%>
content+="		<th><%=no_money_nm[j]%></th>";
<%}%>
content+="		<th>소계</th>";
content+="	</tr>";
<%if( !stt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan=2>건설</th>";
content+="		<td rowspan=2 style='text-align:right;'><%=formater2.format(Float.parseFloat(arrData[1]))%></td>";
	<%for( i=2; i<=field_cnt; i++) {%>
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrData[i]))%></td>";
	<%}%>
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for( i=2; i<=field_cnt; i++) {%>
content+="		<td style='text-align:right;'><%if( arrData[1].equals("0") ) {%>0<%} else {%><%=formater.format(Float.parseFloat(arrData[i]) / Float.parseFloat(arrData[1]) * 100)%><%}%>%</td>";
	<%}%>
content+="	</tr>";
<%} else {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for( i=1; i<=field_cnt; i++) {%>
content+="		<td style='text-align:right;'>&nbsp;</td>";
	<%}%>
content+="	</tr>";
<%}%>
content+="</table>";

top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>
