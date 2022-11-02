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

	String[] arrData=new String[13];
	String OCnt = "0";

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
	
	try {
		resource=new ConnectionResource();
		conn=resource.getConnection();

		if( !tt.equals("start") ) {
			sSQLs="SELECT SUM(Cnt) Total, \n";
			sSQLs+="SUM(CASE WHEN Cnt>=1 AND Cnt<=2 THEN 1 ELSE 0 END) a1, \n";
			sSQLs+="SUM(CASE WHEN Cnt>=3 AND Cnt<=5 THEN 1 ELSE 0 END) a2, \n";
			sSQLs+="SUM(CASE WHEN Cnt>=6 AND Cnt<=10 THEN 1 ELSE 0 END) a3, \n";
			sSQLs+="SUM(CASE WHEN Cnt>=11 AND Cnt<=20 THEN 1 ELSE 0 END) a4, \n";
			sSQLs+="SUM(CASE WHEN Cnt>=21 AND Cnt<=30 THEN 1 ELSE 0 END) a5, \n";
			sSQLs+="SUM(CASE WHEN Cnt>=31 AND Cnt<=40 THEN 1 ELSE 0 END) a6, \n";
			sSQLs+="SUM(CASE WHEN Cnt>=41 AND Cnt<=50 THEN 1 ELSE 0 END) a7, \n";
			sSQLs+="SUM(CASE WHEN Cnt>=51 THEN 1 ELSE 0 END) a8 FROM ( \n";
			sSQLs+="	SELECT Oent_Co_No,COUNT(*) CNT FROM ( \n";
			sSQLs+="		SELECT A.Oent_Co_No, B.Mng_No FROM ( \n";
			sSQLs+="			SELECT Oent_Co_No FROM HADO_TB_Survey_Print2 WHERE Current_Year='"+currentYear+"' \n";
			sSQLs+="		) A LEFT JOIN ( \n";
			sSQLs+="			SELECT Mng_No,Index_Value FROM HADO_TB_Sent_NAnswer \n";
			sSQLs+="			WHERE Sent_Q_CD<13 GROUP BY Mng_No,Index_Value \n";
			sSQLs+="		) B ON A.Oent_Co_No=TO_CHAR(B.Index_Value) \n";
			sSQLs+="	) CCC \n";
			sSQLs+="	GROUP BY Oent_Co_No \n";
			sSQLs+=") DDD \n";
			
			pstmt=conn.prepareStatement(sSQLs);
			rs=pstmt.executeQuery();

			while( rs.next() ) {
				for(int i=1; i<=9; i++) {
					arrData[i] = rs.getString(i);
				}
			}
			rs.close();
			
			// 원사업자 수
			sSQLs="SELECT NVL(COUNT(*),0) FROM ( \n";
			sSQLs+="	SELECT Oent_Co_No FROM HADO_TB_NOent WHERE Current_Year='"+currentYear+"' \n";
			sSQLs+="	GROUP BY Oent_Co_No \n";
			sSQLs+=") C \n";
			
			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();

			while( rs.next() ) {
				OCnt = rs.getString(1);
			}
			rs.close();
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
content+="		<th rowspan='2'>원사업자 수</th>";
content+="		<th rowspan='2'>수급사업자수</th>";
content+="		<th colspan='8'>구간별 수급사업자 수</th>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>1-2</th>";
content+="		<th>3-5</th>";
content+="		<th>6-10</th>";
content+="		<th>11-20</th>";
content+="		<th>21-30</th>";
content+="		<th>31-40</th>";
content+="		<th>41-50</th>";
content+="		<th>51개이상</th>";
content+="	</tr>";
<%if( !tt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<td><%=formater2.format(Float.parseFloat(OCnt))%></td>";
	<%for(int ni=1; ni<=9; ni++) {%>
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni]))%></td>";
	<%}%>
content+="	</tr>";
<%}%>

content+="</table>";

top.document.getElementById("divResult").innerHTML=content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>