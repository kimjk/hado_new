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
	String tt=StringUtil.checkNull(request.getParameter("tt"));
	String comm=StringUtil.checkNull(request.getParameter("comm"));
	
	ConnectionResource resource=null;
	Connection conn=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	
	String sSQLs="";
	String sField="";
	String tmpString="";

	String[][] arrData=new String[6][10];
	float[] arrSum=new float[10];

	String tmpStr="";
	String sTmpPMS=session.getAttribute("ckPermision")+"";
	
	int nLoop=1;
	int sStartYear=2007;

	java.util.Calendar cal=java.util.Calendar.getInstance();

	DecimalFormat formater=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	String tmpYear=StringUtil.checkNull(request.getParameter("cyear")).trim();
	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
	}
	
	int currentYear=st_Current_Year_n;
	currentYear=Integer.parseInt(session.getAttribute("cyear")+"");

	int endCurrentYear=st_Current_Year_n;

	// 합계배열 초기화
	for(int i=1; i <=8; i++) { arrSum[i]=0F; }

	
	try {
		resource=new ConnectionResource();
		conn=resource.getConnection();

		if( !tt.equals("start") ) {
			
			sSQLs="SELECT Sent_Type, Common_NM, NVL(COUNT(*),0) cnt, \n";
			sSQLs+="SUM(CASE Index_Value WHEN '1' THEN 1 ELSE 0 END) a, \n";
			sSQLs+="SUM(CASE Index_Value WHEN '2' THEN 1 ELSE 0 END) b, \n";
			sSQLs+="SUM(CASE Index_Value WHEN '3' THEN 1 ELSE 0 END) c, \n";
			sSQLs+="SUM(CASE Index_Value WHEN '4' THEN 1 ELSE 0 END) d, \n";
			sSQLs+="SUM(CASE Index_Value WHEN '5' THEN 1 ELSE 0 END) e, \n";
			sSQLs+="SUM(CASE Index_Value WHEN '6' THEN 1 ELSE 0 END) f, \n";
			sSQLs+="SUM(CASE Index_Value WHEN '7' THEN 1 ELSE 0 END) g FROM ( \n";
			sSQLs+="	SELECT b.Sent_Type, c.Common_NM, b.Comp_Status, b.Subcon_Type, \n";
			sSQLs+="	b.Sent_Status, b.Addr_Status, a.Index_Value FROM ( \n";
			sSQLs+="		SELECT * FROM HADO_TB_Sent_NAnswer \n";
			if( currentYear==2010 ) {
				sSQLs+="		WHERE Sent_Q_CD=15 AND Sent_Q_GB=1 AND Current_Year='"+currentYear+"' \n";
			} else {
				sSQLs+="		WHERE Sent_Q_CD=13 AND Sent_Q_GB=1 AND Current_Year='"+currentYear+"' \n";
					}
			sSQLs+="	) a LEFT JOIN HADO_TB_Sent b \n";
			sSQLs+="	ON a.Mng_No=b.Mng_No AND a.Current_Year=b.Current_Year \n";
			sSQLs+="	LEFT JOIN Common_CD c \n";
			sSQLs+="	ON b.Sent_Type=c.Common_CD AND c.Addon_GB='4' \n";
			sSQLs+="	WHERE Comp_Status='1' AND (Subcon_Type='2' OR Subcon_Type='3') \n";
			sSQLs+="	AND Sent_Status='1' AND Addr_Status IS NULL \n";
			sSQLs+=") CCC \n";
			sSQLs+="GROUP BY Sent_Type, Common_NM \n";
			sSQLs+="ORDER BY Sent_Type, Common_NM \n";

			pstmt=conn.prepareStatement(sSQLs);
			rs=pstmt.executeQuery();
			
			nLoop=1;
			while( rs.next() ) {
				arrData[nLoop][1]=rs.getString("Sent_Type")+"("+new String( StringUtil.checkNull(rs.getString("Common_NM")).trim().getBytes("ISO8859-1"), "utf-8" )+")";
				arrData[nLoop][2]=rs.getString("cnt");
				arrData[nLoop][3]=rs.getString("a");
				arrData[nLoop][4]=rs.getString("b");
				arrData[nLoop][5]=rs.getString("c");
				arrData[nLoop][6]=rs.getString("d");
				arrData[nLoop][7]=rs.getString("e");
				arrData[nLoop][8]=rs.getString("f");
				arrData[nLoop][9]=rs.getString("g");
				for(int i=2; i <= 9; i++) {
					if( arrData[nLoop][i] != null && (!arrData[nLoop][i].equals("")) ) {
						arrSum[i-1]=arrSum[i-1]+Float.parseFloat(arrData[nLoop][i]);
					}
				}
				nLoop++;
			}
			rs.close();
			nLoop--;
		}
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if(rs!=null)		try{rs.close();}	catch(Exception e){}
		if(pstmt!=null)		try{pstmt.close();}	catch(Exception e){}
		if(conn!=null)		try{conn.close();}	catch(Exception e){}
		if(resource!=null)	resource.release();
	}
%>

<script language="javascript">
content="";
content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th>구분</th>";
content+="		<th>응답수</th>";
content+="		<th>매우만족</th>";
content+="		<th>만족</th>";
content+="		<th>약간만족</th>";
content+="		<th>보통</th>";
content+="		<th>약간불만족</th>";
content+="		<th>불만족</th>";
content+="		<th>매우불만족</th>";
content+="	</tr>";
<%if( !tt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan='2'>계</th>";
content+="		<td><%=formater2.format(arrSum[1])%></td>";
content+="		<td><%=formater2.format(arrSum[2])%></td>";
content+="		<td><%=formater2.format(arrSum[3])%></td>";
content+="		<td><%=formater2.format(arrSum[4])%></td>";
content+="		<td><%=formater2.format(arrSum[5])%></td>";
content+="		<td><%=formater2.format(arrSum[6])%></td>";
content+="		<td><%=formater2.format(arrSum[7])%></td>";
content+="		<td><%=formater2.format(arrSum[8])%></td>";
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<td>100.0%</td>";
content+="		<td><%if( arrSum[1] > 0F) {%><%=formater.format(arrSum[2] / arrSum[1] * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrSum[1] > 0F) {%><%=formater.format(arrSum[3] / arrSum[1] * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrSum[1] > 0F) {%><%=formater.format(arrSum[4] / arrSum[1] * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrSum[1] > 0F) {%><%=formater.format(arrSum[5] / arrSum[1] * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrSum[1] > 0F) {%><%=formater.format(arrSum[6] / arrSum[1] * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrSum[1] > 0F) {%><%=formater.format(arrSum[7] / arrSum[1] * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrSum[1] > 0F) {%><%=formater.format(arrSum[8] / arrSum[1] * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="	</tr>";
	<%for(int ni=1; ni<=nLoop; ni++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan='2'><%=arrData[ni][1]%></th>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][2]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][3]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][4]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][5]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][6]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][7]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][8]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][9]))%></td>";
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<td><%if( arrSum[1] > 0F && arrData[ni][2] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][2]) / arrSum[1] * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrData[ni][3] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][3]) / Float.parseFloat(arrData[ni][2]) * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrData[ni][4] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][4]) / Float.parseFloat(arrData[ni][2]) * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrData[ni][5] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][5]) / Float.parseFloat(arrData[ni][2]) * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrData[ni][6] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][6]) / Float.parseFloat(arrData[ni][2]) * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrData[ni][7] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][7]) / Float.parseFloat(arrData[ni][2]) * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrData[ni][8] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][8]) / Float.parseFloat(arrData[ni][2]) * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="		<td><%if( arrData[ni][9] != null) {%><%=formater.format(Float.parseFloat(arrData[ni][9]) / Float.parseFloat(arrData[ni][2]) * 100F)%><%} else {%><%=0.0%><%}%>%</td>";
content+="	</tr>";
	<%}%>
<%}%>

content+="</table>";

top.document.getElementById("divResult").innerHTML=content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>