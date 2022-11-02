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
	String tt = StringUtil.checkNull(request.getParameter("tt"));
	String comm = StringUtil.checkNull(request.getParameter("comm"));
	
	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sSQLs = "";
	String sField = "";
	String tmpString = "";

	String[] arrData = new String[21];
	
	int nLoop = 1;

	int sStartYear = 2007;

	java.util.Calendar cal = java.util.Calendar.getInstance();

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2 = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	for(int i=1; i<=20; i++) {
		arrData[i]="0.0";
	}

	String tmpYear = StringUtil.checkNull(request.getParameter("cyear")).trim();
	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
	}
	
	if( tt.equals("start") ) {
		session.setAttribute("cstatus","");
	}
	if( comm.equals("search") ) {
		session.setAttribute("cstatus",StringUtil.checkNull(request.getParameter("cstatus")).trim());
	}

	int currentYear = st_Current_Year_n;
	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");
	
	if( !tt.equals("start") ) {
		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();
			
			// 수급사업자 누계
			sSQLs ="SELECT NVL(COUNT(*),0) Send_Total,NVL(SUM(CASE WHEN (Subcon_Type='2' OR Subcon_Type='3') THEN 1 ELSE 0 END),0) Subcon_Total \n";
			sSQLs+="FROM HADO_TB_Sent \n";
			sSQLs+="WHERE Sent_Status='1' \n";
			sSQLs+="	AND Addr_Status IS NULL \n";
			sSQLs+="	AND Current_Year='"+currentYear+"' \n";
			
			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();

			while( rs.next() ) {
				arrData[1] = rs.getString("Send_Total");	// 제출업체수(수급사업자)
				arrData[2] = rs.getString("Subcon_Total");	// 하도급거래업체수(수급사업자)
			}
			rs.close();
			
			// 원사업자 수
			sSQLs ="SELECT NVL(COUNT(*),0) RCNT \n";
			sSQLs+="FROM ( \n";
			sSQLs+="	SELECT Oent_Co_No \n";
			sSQLs+="	FROM HADO_TB_NOent \n";
			sSQLs+="	WHERE Current_Year='"+currentYear+"' \n";
			sSQLs+="	GROUP BY Oent_Co_No) C \n";
			
			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();

			while( rs.next() ) {
				arrData[3] = (rs.getString("RCNT")==null)? "0":rs.getString("RCNT");
			}
			rs.close();

			tmpString = ""+session.getAttribute("cstatus");
			if( tmpString.equals("1") ) {
				sField = "(D_T>0) AND (D_T+A_T)";
			} else if( tmpString.equals("2") ) {
				sField = "(D_T=0 AND A_T>0) AND (D_T+A_T)";
			} else {
				sField = "(D_T+A_T)";
			}
			sSQLs ="SELECT NVL(COUNT(*),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + ">0 THEN 1 ELSE 0 END),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + ">0 THEN 0 ELSE 1 END),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + "=1 THEN 1 ELSE 0 END),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + "=2 THEN 1 ELSE 0 END),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + "=3 THEN 1 ELSE 0 END),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + "=4 THEN 1 ELSE 0 END),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + "=5 THEN 1 ELSE 0 END),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + "=6 THEN 1 ELSE 0 END),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + "=7 THEN 1 ELSE 0 END),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + "=8 THEN 1 ELSE 0 END),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + "=9 THEN 1 ELSE 0 END),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + "=10 THEN 1 ELSE 0 END),0), \n";
			sSQLs+="	NVL(SUM(CASE WHEN " + sField + ">10 THEN 1 ELSE 0 END),0) \n";
			sSQLs+="FROM HADO_TB_Survey_Print2 \n";
			sSQLs+="WHERE Current_Year='"+currentYear+"' \n";
					
			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();
			
			while( rs.next() ) {
				//arrData[3] = rs.getString(1);	// 원사업자수
				arrData[4]=(rs.getString(2)==null)? "0":rs.getString(2);	// 위반원사업자수
				//arrData[5] = rs.getString(3);	// 미위반원사업자수
				arrData[5] = "" + (Integer.parseInt(arrData[3]) - Integer.parseInt(arrData[4]));
				if( !arrData[1].equals("0") ) {
					arrData[6] = formater.format(Float.parseFloat(arrData[2]) / Float.parseFloat(arrData[1]) * 100);
					arrData[7] = formater.format(Float.parseFloat(arrData[3]) / Float.parseFloat(arrData[1]) * 100);
				} else {
					arrData[6] = "0.0";
					arrData[7] = "0.0";
				}
				if( !arrData[3].equals("0") ) {
					arrData[8] = formater.format(Float.parseFloat(arrData[4]) / Float.parseFloat(arrData[3]) * 100);
					arrData[9] = formater.format(Float.parseFloat(arrData[5]) / Float.parseFloat(arrData[3]) * 100);
				} else {
					arrData[8] = "0.0";
					arrData[9] = "0.0";
				}
				for(int i=4; i<=14; i++) {
					arrData[i+6] = (rs.getString(i)==null)? "0":rs.getString(i);
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
	}
%>


<script language="javascript">
content = "";

content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th rowspan=3>구분</th>";
content+="		<th colspan=2>수급사업자</th>";
content+="		<th colspan=3>원사업자</th>";
content+="		<th colspan=4 rowspan=2>비율(%)</th>";
content+="		<th colspan=11 rowspan=2>위반행위 수 (원사업자기준)</th>";
content+="	</tr>";
content+="	<tr>";
content+="		<th rowspan=2>제출업체 수(A)</th>";
content+="		<th rowspan=2>하도급거래업체 수(B)</th>";
content+="		<th rowspan=2>응답업체 수(C)</th>";
content+="		<th rowspan=2>위반업체 수(D)</th>";
content+="		<th rowspan=2>미위반업체 수(E)</th>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>B/A</th>";
content+="		<th>C/A</th>";
content+="		<th>D/C</th>";
content+="		<th>E/C</th>";
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
content+="		<th>10초과</th>";
content+="	</tr>";
<%if( !tt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th>건설</th>";
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrData[1]))%></td>";
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrData[2]))%></td>";
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrData[3]))%></td>";
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrData[4]))%></td>";
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrData[5]))%></td>";
content+="		<td style='text-align:right;'><%=arrData[6]%>%</td>";
content+="		<td style='text-align:right;'><%=arrData[7]%>%</td>";
content+="		<td style='text-align:right;'><%=arrData[8]%>%</td>";
content+="		<td style='text-align:right;'><%=arrData[9]%>%</td>";
	<%for(int i=10; i<=20; i++) {%>
content+="		<td style='text-align:right;'><%=formater2.format(Float.parseFloat(arrData[i]))%></td>";
	<%}%>
content+="	</tr>";
<%}%>
content+="</table>";

top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>
