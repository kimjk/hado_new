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
	String sSQLJoinTable="";

	String[][] arrData=new String[31][6];
	float[] arrSum=new float[6];

	String tmpStr="";
	String sTmpPMS=session.getAttribute("ckPermision")+"";
	
	int nLoop=1;
	int sStartYear=2005;

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

	if( tt.equals("start") ) {
		session.setAttribute("wgb", "1");
	}

	if( comm.equals("search") ) {
		session.setAttribute("wgb", StringUtil.checkNull(request.getParameter("wgb")).trim());
	}

	int endCurrentYear=st_Current_Year_n;

	// 합계배열 초기화
	for(int i=1; i <=5; i++) { arrSum[i]=0F; }
	
	try {
		resource=new ConnectionResource();
		conn=resource.getConnection();

		if( !tt.equals("start") ) {

			if( !session.getAttribute("wgb").equals("") ) {
				sSQLs="SELECT a.Oent_Type,b.Common_NM,a.Field01,a.Field02,a.Field03 FROM ( \n";
				sSQLs+="	SELECT HADO_TB_Oent.Oent_Type, \n";
			} else {
				sSQLs="SELECT Oent_GB Oent_Type,'' Common_NM,Field01,Field02,Field03 FROM ( \n";
				sSQLs+="	SELECT HADO_TB_Subcon_"+currentYear+".Oent_GB, \n";
			}
			sSQLs+="	NVL(COUNT(HADO_TB_Subcon_"+currentYear+".Mng_No),0) Field01, \n";
			sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".a WHEN '1' THEN 1 ELSE 0 END) Field02, \n";
			sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".b WHEN '1' THEN 1 ELSE 0 END) Field03  \n";
			sSQLs+="	FROM HADO_TB_Oent,HADO_TB_Subcon_"+currentYear+",HADO_TB_SOent_Answer_"+currentYear+" \n";
			sSQLs+="	WHERE HADO_TB_Subcon_"+currentYear+".Oent_GB=HADO_TB_SOent_Answer_"+currentYear+".Oent_GB \n";
			sSQLs+="		AND HADO_TB_Oent.Current_Year=HADO_TB_Subcon_"+currentYear+".Current_Year \n";
			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".Sent_Status='1' \n";
			sSQLs+="		AND HADO_TB_Oent.Mng_No=HADO_TB_Subcon_"+currentYear+".Mng_No \n";
			sSQLs+="		AND HADO_TB_Oent.Oent_GB=HADO_TB_Subcon_"+currentYear+".Oent_GB \n";
			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".Child_Mng_No=HADO_TB_SOent_Answer_"+currentYear+".Mng_No \n";
			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".Current_Year=HADO_TB_SOent_Answer_"+currentYear+".Current_Year \n";
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=17 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=6 \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=15 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=6 \n";
			} else {
				sSQLs+="		AND ((HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=17 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=6  AND HADO_TB_Subcon_"+currentYear+".oent_gb='1') \n";
				sSQLs+="		OR ( HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=15  AND  HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=6  AND HADO_TB_Subcon_"+currentYear+".oent_gb='3')) \n";
			}
			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".sent_no=HADO_TB_SOent_Answer_"+currentYear+".sent_no \n";

			if( !session.getAttribute("wgb").equals("") ) {
				sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".oent_gb='"+session.getAttribute("wgb")+"' \n";
			}
			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".Current_Year='"+currentYear+"' \n";
			if( !session.getAttribute("wgb").equals("") ) {
				sSQLs+="	GROUP BY HADO_TB_Oent.Oent_Type \n";
				sSQLs+=") a LEFT JOIN Common_CD b \n";
				sSQLs+="ON b.Addon_GB='"+session.getAttribute("wgb")+"' \n";
				sSQLs+="AND a.Oent_Type=b.Common_cd \n";
				sSQLs+="ORDER BY oent_type \n";
			} else {
				sSQLs+="GROUP BY HADO_TB_Subcon_"+currentYear+".oent_gb) CCC ORDER BY Oent_Type \n";
			}

			pstmt=conn.prepareStatement(sSQLs);
			rs=pstmt.executeQuery();
			
			nLoop=1;
			while( rs.next() ) {
				arrData[nLoop][4]=rs.getString("Oent_Type");
				arrData[nLoop][5]=new String( StringUtil.checkNull(rs.getString("Common_NM")).trim().getBytes("ISO8859-1"), "utf-8" );
				arrData[nLoop][1]=rs.getString("Field01");
				arrData[nLoop][2]=rs.getString("Field02");
				arrData[nLoop][3]=rs.getString("Field03");

				for(int i=1; i<=3; i++) {
					arrSum[i]=arrSum[i]+Float.parseFloat(arrData[nLoop][i]);
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
content+="		<th rowspan='2'>구분</th>";
content+="		<th rowspan='2'>응답업체수</th>";
content+="		<th colspan='2'>보복 여부</th>";
content+="  </tr>";
content+="	<tr>";
content+="		<th>있었음</th>";
content+="		<th>없었음</th>";
content+="  </tr>";

<%if( !tt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan='2'>계</th>";
content+="		<td rowspan='2'><%=arrSum[1]%></td>";
	<%for(int i=2; i<=3; i++) {%>
content+="		<td><%=formater2.format(arrSum[i])%></td>";
	<%}%>
content+="	</tr>";

content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for(int i=2; i<=3; i++) {%>	
		<%if( arrSum[1] > 0F) {%>
content+="		<td><%=formater.format(arrSum[i] / arrSum[1] * 100F)%>%</td>";
		<%} else {%>
content+="		<td>0.0%</td>";
		<%}%>
	<%}%>
content+="	</tr>";

	<%for(int ni=1; ni<=nLoop; ni++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
		<%if( !session.getAttribute("wgb").equals("") ) {%>	
content+="		<th rowspan='2'><%=arrData[ni][4]%> (<%=arrData[ni][5]%>)</th>";
		<%} else {%>
				<%if( arrData[ni][4].equals("1") ) {%>		
content+="		<th rowspan='2'>제조</th>";
				<%} else if( arrData[ni][4].equals("2") ) {%>
content+="		<th rowspan='2'>건설</th>";
				<%} else if( arrData[ni][4].equals("3") ) {%>								
content+="		<th rowspan='2'>용역</th>";
				<%}
		}%>
content+="		<td rowspan='2'><%=arrData[ni][1]%></td>";
		<%for(int i=2; i<=3; i++) {%>
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][i]))%></td>";
		<%}%>
content+="	</tr>";

content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
		<%for(int i=2; i<=3; i++) {%>
			<%if( Float.parseFloat(arrData[ni][1]) > 0F) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][i]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>";
			<%} else {%>
content+="		<td>0.0%</td>";
			<%}%>
		<%}%>
content+="	</tr>";

	<%}%>
<%} else {%>
content+="	<tr>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="	</tr>";
<%}%>
content+="</table>";

top.document.getElementById("divResult").innerHTML=content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>