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
	String stt = StringUtil.checkNull(request.getParameter("tt")).trim();

	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sSQLs = "";
	int i = 0;
	int j = 0;
	int m = 0;

	String[] status_cd = new String[9];
	String[] status_col = new String[9];
	String[] type_cd = new String[38];
	String[] type_row = new String[38];
	String[] temp_col = new String[3];

	Long[][] table_sum = new Long[30][12];
	Long[] s_total = new Long[30];
	Long[] e_total = new Long[12];
	Long[] n_total = new Long[30];
	Float[] rate1 = new Float[30]; 
	Float[] rate2 = new Float[30];
	Float[] rate3 = new Float[30];
	Float[] rate4 = new Float[30];

	float tot_rate1 = 0F;
	float tot_rate2 = 0F;
	float tot_rate3 = 0F;
	float tot_rate4 = 0F;

	long total = 0;
	long tot_s_total = 0;

	String ls = "";
	int cnt = 0;
	int col_cnt = 0;
	int row_cnt = 0;
	int e_tot_cnt = 0;

	int sStartYear = 2007;

	

	java.util.Calendar cal = java.util.Calendar.getInstance();

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.00");
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
	
	String currentOent = currentYear>=2012 ? "HADO_TB_Oent_"+currentYear : "HADO_TB_Oent";
	
	
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		
		sSQLs ="SELECT COMMON_CD, COMMON_NM \n";
		sSQLs+="FROM COMMON_CD \n";
		sSQLs+="WHERE COMMON_GB = '005' \n";
		sSQLs+="ORDER BY COMMON_CD \n";

		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();
		
		i = 1;
		while( rs.next() ) {
			//status_col[i] = new String( StringUtil.checkNull(rs.getString("COMMON_NM")).trim().getBytes("ISO8859-1"), "utf-8" );
			status_col[i] = StringUtil.checkNull(rs.getString("COMMON_NM")).trim();
			status_cd[i]  = StringUtil.checkNull(rs.getString("COMMON_CD")).trim();
			i++;
		}
		rs.close();
		i--;

		if( !stt.equals("start") ) {
			sSQLs ="SELECT COMMON_CD, COMMON_CD||'('||COMMON_NM ||')' AS_TYPE \n";
			sSQLs+="FROM COMMON_CD \n";
			sSQLs+="WHERE COMMON_GB = '002' \n";
			sSQLs+="AND ADDON_GB='4' \n";

			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();

			j = 1;
			while( rs.next() ) {
				type_cd[j] = StringUtil.checkNull(rs.getString("COMMON_CD")).trim();
				type_row[j] = new String( StringUtil.checkNull(rs.getString("AS_TYPE")).trim().getBytes("ISO8859-1"), "utf-8" );
				j++;
			}
			rs.close();
			j--;

			sSQLs ="SELECT COUNT(SENT_TYPE) TYP_CNT, \n";
			for(int nx = 1; nx <= i-1; nx++) {
				sSQLs+="	SUM(CASE WHEN COMP_STATUS='"+status_cd[nx]+"' THEN \n";
				sSQLs+="		CASE SENT_STATUS WHEN '1' THEN \n";
				sSQLs+="			CASE WHEN (CASE WHEN ADDR_STATUS IS NULL THEN '0' ELSE '1' END)='0' THEN 1 ELSE 0 END \n";
				sSQLs+="		ELSE 0 END \n";
				sSQLs+="	ELSE 0 END) D"+status_cd[nx]+", \n";
			}
			sSQLs+="	SUM(CASE COMP_STATUS WHEN '1' THEN \n";
			sSQLs+="		CASE WHEN SUBCON_TYPE = '1' OR SUBCON_TYPE = '4' THEN \n";
			sSQLs+="			CASE SENT_STATUS WHEN '1' THEN 1 ELSE 0 END \n";
			sSQLs+="		ELSE 0 END \n";
			sSQLs+="	ELSE 0 END ) SUBCON, \n";
			sSQLs+="	SUM(CASE WHEN ADDR_STATUS IS NULL THEN 0 ELSE 1 END) MIS_ADDR \n";
			sSQLs+="FROM HADO_TB_SENT \n";
			sSQLs+="WHERE OENT_GB='2' \n";
			sSQLs+="	AND CURRENT_YEAR='"+currentYear+"' \n";
			sSQLs+="	AND SUBSTR(MNG_NO,-5)<>'99999' \n";
			sSQLs+="	AND LENGTH(Mng_No)>4 \n";
			sSQLs+="GROUP BY SENT_TYPE \n";
			sSQLs+="ORDER BY SENT_TYPE \n";
			
			//System.out.println(sSQLs);	
			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();
			
			m = 1;

			e_total[1] = new Long(0);

			while( rs.next() ) {
				s_total[m] = new Long(0);
				table_sum[m][1] =  rs.getLong("TYP_CNT");
				total += table_sum[m][1];
				
				for(int n = 1; n <= i-1; n++) {
					ls = "d" + status_cd[n];
					cnt = n + 1;
					table_sum[m][cnt] =  rs.getLong(ls);
					s_total[m] = s_total[m] + table_sum[m][cnt];
				}
				rate1[m] = (s_total[m] / (float)table_sum[m][1]) * 100F;
				e_total[1] = e_total[1] + s_total[m];
				tot_s_total = tot_s_total + s_total[m];
				
				table_sum[m][cnt+1] =  rs.getLong("SUBCON");
				rate2[m] = (table_sum[m][cnt+1] / (float)table_sum[m][1]) * 100F;
				table_sum[m][cnt+2] =  rs.getLong("MIS_ADDR");
				table_sum[m][cnt+3] = table_sum[m][1] - s_total[m];
				rate3[m] = (table_sum[m][cnt+2] / (float)table_sum[m][1]) * 100F;
				rate4[m] = (table_sum[m][cnt+3] / (float)table_sum[m][1]) * 100F;
				
				m++;
			}
			rs.close();
			m--;
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

	if( !stt.equals("start") ) {
		for(col_cnt = 2; col_cnt <= cnt+2; col_cnt++) {
			e_total[col_cnt] = new Long(0);
			for(row_cnt = 1; row_cnt <= m; row_cnt++) {
				e_total[col_cnt] = e_total[col_cnt] + table_sum[row_cnt][col_cnt];
			}
		}

		e_total[cnt+3] = total - e_total[1];

		if( total > 0) {
			if(e_total[1] != null) {tot_rate1 = (e_total[1]/(float)total)*100F;}
			if(e_total[9] != null) {tot_rate2 = (e_total[9]/(float)total)*100F;}
			if(e_total[10] != null) {tot_rate3 = (e_total[10]/(float)total)*100F;}
			if(e_total[11] != null) {tot_rate4 = (e_total[11]/(float)total)*100F;}
		} else {
			tot_rate1 = 0;
			tot_rate2 = 0;
			tot_rate3 = 0;
			tot_rate4 = 0;
		}
	}
/*=====================================================================================================*/
%>
<meta charset="utf-8">
<script type="text/javascript">
//<![CDATA[
content = "";

content+="<table id='divButton'>";
content+="	<tr>";
content+="		<td><%=cal.get(Calendar.YEAR)%>년<%=cal.get(Calendar.MONTH)+1%>월<%=cal.get(Calendar.DATE)%>일(현재)</td>";
content+="	</tr>";
content+="</table>";

content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th rowspan='3' width='90px' height='80px'>업종별</th>";
content+="		<th rowspan='3' height='150px'>조사대상업체(A)</th>";
content+="		<th height='20px' colspan='<%=i+1%>'>제출</th>";
content+="		<th height='20px' colspan='2'>미제출</th>";
content+="		<th height='40px' colspan='4'>비율</th>";
content+="	</tr>";
content+="	<tr>";
content+="		<th height='20px' colspan='<%=i%>'>회사영업상태</th>";
content+="		<th rowspan=2 height=30px><font color=red>정상영업중 하도급거래없음(C)</font></th>";
content+="		<th rowspan=2>소계(D)</th>";
content+="		<th rowspan=2>소재불명등(E)</th>";
content+="		<th rowspan=2 height=50px>B/A</th>";
content+="		<th rowspan=2>C/A</th>";
content+="		<th rowspan=2>D/A</th>";
content+="		<th rowspan=2>E/A</th>";
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th height=40px>소계(B)</th>";
<%for(int x=1 ; x <= i-1; x++) {%>
content+="		<th><%=status_col[x]%></th>";
<%}%>
content+="	</tr>";
content+="	<tr>";
content+="		<th height=30px>계</th>";
content+="		<td align=right><%=StringUtil.formatNumber(total)%></td>";
	<%for (e_tot_cnt =1; e_tot_cnt <= col_cnt-2; e_tot_cnt++) {%>
content+="		<td align=right><%if (e_tot_cnt==9 ) {%><font color=red><%}%><%=StringUtil.formatNumber(e_total[e_tot_cnt])%><%if (e_tot_cnt==9) {%></font><%}%></td>";
	<%}%>
content+="		<td align=right><%=StringUtil.formatNumber(e_total[e_tot_cnt+1])%></td>";
content+="		<td align=right><%=StringUtil.formatNumber(e_total[e_tot_cnt])%></td>";
content+="		<td><%=formater.format(tot_rate1)%>%</td>";
content+="		<td><%=formater.format(tot_rate2)%>%</td>";
content+="		<td><%=formater.format(tot_rate4)%>%</td>";
content+="		<td><%=formater.format(tot_rate3)%>%</td>";
content+="	</tr>";
<%for(int y=1; y <= m; y++) {%>
content+="	<tr>";
content+="		<th height=25px><%=type_row[y]%></th>";
content+="		<td align=right><%=StringUtil.formatNumber(table_sum[y][1])%></td>";
content+="		<td align=right><%=StringUtil.formatNumber(s_total[y])%></td>";
	<%for(int z=2; z<= i+1;z++) {%>
content+="		<td align=right><%if (z==9 ) {%><font color=red><%}%><%=StringUtil.formatNumber(table_sum[y][z])%><%if (z==9) {%></font><%}%></td>";
	<%}%>
content+="		<td align=right><%=StringUtil.formatNumber(table_sum[y][i+3])%></td>";
content+="		<td align=right><%=StringUtil.formatNumber(table_sum[y][i+2])%></td>";
content+="		<td align=right><%=formater.format(rate1[y])%>%</td>";
content+="		<td align=right><%=formater.format(rate2[y])%>%</td>";
content+="		<td align=right><%=formater.format(rate4[y])%>%</td>";
content+="		<td align=right><%=formater.format(rate3[y])%>%</td>";
content+="	</tr>";
<%}%>
content+="	</table>";

top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
//]]
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>