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

	String[] arrData=new String[5];

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
			// 수급사업자 누계
			sSQLs="SELECT NVL(COUNT(*),0) Send_Total, \n";
			sSQLs+="SUM(CASE WHEN (Subcon_Type='2' OR Subcon_Type='3') THEN 1 ELSE 0 END) Subcon_Total \n";
			sSQLs+="FROM HADO_TB_Sent \n";
			sSQLs+="WHERE Sent_Status='1' AND Addr_Status IS NULL AND Current_Year='"+currentYear+"' \n";

			pstmt=conn.prepareStatement(sSQLs);
			rs=pstmt.executeQuery();

			while( rs.next() ) {
				arrData[1]=rs.getString(1);
			}
			rs.close();

			// 원사업자 수
			sSQLs="SELECT NVL(COUNT(*),0) FROM ( \n";
			sSQLs+="	SELECT Oent_Co_No FROM HADO_TB_NOent \n";
			sSQLs+="	WHERE Current_Year='"+currentYear+"' \n";
			sSQLs+="	GROUP BY Oent_Co_No \n";
			sSQLs+=") C \n";

			pstmt=conn.prepareStatement(sSQLs);
			rs=pstmt.executeQuery();

			while( rs.next() ) {
				arrData[2]=rs.getString(1);
			}
			rs.close();

			
			sSQLs="SELECT COUNT(*) FROM ( \n";
			sSQLs+="	SELECT DISTINCT(Index_Value) Index_Value FROM ( \n";
			sSQLs+="		SELECT A.*, B.Mng_No FROM ( \n";
			sSQLs+="			SELECT * FROM HADO_TB_Sent_NAnswer \n";
			sSQLs+="			WHERE Sent_Q_CD=14 and Sent_Q_GB=1 AND Current_Year='"+currentYear+"' \n";
			sSQLs+="		) A LEFT JOIN HADO_TB_Survey_Print2 B \n";
			sSQLs+="		ON A.Index_Value=B.Oent_Co_No \n";
			sSQLs+="	) CCC \n";
			sSQLs+="	GROUP BY Index_Value \n";
			sSQLs+=") DDD \n";
			
			pstmt=conn.prepareStatement(sSQLs);
			rs=pstmt.executeQuery();

			while( rs.next() ) {
				arrData[4]=rs.getString(1);
				arrData[3]=""+(Integer.parseInt(arrData[2]) - Integer.parseInt(arrData[4]));
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
content+="		<th rowspan='2'>구분</th>";
content+="		<th rowspan='2'>응답업체수<br>(수급사업자수)</th>";
content+="		<th rowspan='2'>대상원사업자수</th>";
content+="		<th colspan='2'>사용여부</th>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>사용</th>";
content+="		<th>사용하지않음</th>";
content+="	</tr>";
<%if( !tt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<td rowspan='2'>건설</td>";
content+="		<td rowspan='2'><%=formater2.format(Float.parseFloat(arrData[1]))%></td>";
content+="		<td rowspan='2'><%=formater2.format(Float.parseFloat(arrData[2]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[3]))%></td>";
content+="		<td><%=formater2.format(Float.parseFloat(arrData[4]))%></td>";
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<td><%=formater.format(Float.parseFloat(arrData[3]) / Float.parseFloat(arrData[2]) * 100)%>%</td>";
content+="		<td><%=formater.format(Float.parseFloat(arrData[4]) / Float.parseFloat(arrData[2]) * 100)%>%</td>";
content+="	</tr>";
<%}%>
content+="</table>";

top.document.getElementById("divResult").innerHTML=content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>