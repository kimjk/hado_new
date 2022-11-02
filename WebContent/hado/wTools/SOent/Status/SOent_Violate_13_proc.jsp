<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%><%/*** 프로젝트명	 : 하도급거래 서면실태조사 지원을 위한 개발용역 사업								   * 프로그램명	 : SOent_Violate_13_proc.jsp																				   * 프로그램설명	: 수급사업자 > 조사결과분석 > 단가인하 방법* 프로그램버전	: 1.0.1																				                        * 최초작성일자	: 2015년 09월 01일																                            * 작 성 이 력       :                                                                                                                           *=========================================================*	작성일자		작성자명				내용*=========================================================*	2015-09-01	강슬기       페이지 최신화(주석, 불필요한 코드 제거, 오래된 코드 수정) *   2015-09-09   강슬기        2015년도 조사제외대상 조건 추가*   2016-01-06   이용광        DB변경으로 인한 인코딩 변경*/%>
<%@ page import="java.sql.*"%><%@ page import="java.util.*"%><%@ page import="ftc.util.*"%><%@ page import="ftc.db.ConnectionResource"%><%@ page import="java.text.DecimalFormat"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%><%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%><%
/*---------------------------------------- Variable Difinition ----------------------------------------*/	String tt = request.getParameter("tt")==null? "":request.getParameter("tt").trim();
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();

	ConnectionResource resource=null;	Connection conn=null;	PreparedStatement pstmt=null;	ResultSet rs=null;
	String sSQLs="";	String sSQLJoinTable="";
	String[][] arrData = new String[31][11];	float[] arrSum = new float[11];
	String tmpStr="";	String sTmpPMS=session.getAttribute("ckPermision")+"";
	int nLoop=1;	int sStartYear=2005;
	java.util.Calendar cal=java.util.Calendar.getInstance();
	DecimalFormat formater=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");	DecimalFormat formater2=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");/*-----------------------------------------------------------------------------------------------------*//*=================================== Record Selection Processing =====================================*/	String tmpYear=request.getParameter("cyear")==null? "":request.getParameter("cyear").trim();
	if( !tmpYear.equals("") ) {		session.setAttribute("cyear", tmpYear);	} else {		session.setAttribute("cyear", st_Current_Year);	}
	int currentYear=st_Current_Year_n;	currentYear=Integer.parseInt(session.getAttribute("cyear")+"");
	if( tt.equals("start") ) {		session.setAttribute("wgb", "1");	}	if( comm.equals("search") ) {		session.setAttribute("wgb", request.getParameter("wgb")==null? "": request.getParameter("wgb").trim());
	}
	int endCurrentYear=st_Current_Year_n;
	/* 2012년 원사업자 관련 DB Table 분리 예외처리 시작 ============================================================> */	/* 업데이트 일자 : 2012년 11월 13일	   작성자 : 정광식	   비고 : Database 성능향상을 위하여 2012년부터 원사업자 테이블 분리			  HADO_TB_Oent --> HADO_TB_Oent_2012 */	String currentOent = "HADO_TB_Oent";	if( currentYear>2011 ) {		currentOent = "HADO_TB_Oent_"+currentYear;	}	/* <============================================================== 2012년 원사업자 관련 DB Table 분리 예외처리 끝 */
	// 합계배열 초기화	for(int i=1; i <=10; i++) { 		arrSum[i] = 0F; 	}	try {		resource=new ConnectionResource();		conn=resource.getConnection();		if( !tt.equals("start") ) {			if( !session.getAttribute("wgb").equals("") ) {				sSQLs="SELECT a.Oent_Type,b.Common_NM,a.Field01,a.Field02,a.Field03,a.Field04,a.Field05, \n";				sSQLs+="a.Field06,a.Field07,a.Field08 FROM ( \n";				sSQLs+="	SELECT "+currentOent+".Oent_Type, \n";			} else {				sSQLs="SELECT Oent_GB Oent_Type,'' Common_NM,Field01,Field02,Field03,Field04,Field05, \n";				sSQLs+="Field06,Field07,Field08 FROM ( \n";				sSQLs+="	SELECT HADO_TB_Subcon_"+currentYear+".Oent_GB, \n";			}			sSQLs+="	NVL(COUNT(HADO_TB_Subcon_"+currentYear+".Mng_No),0) Field01, \n";			sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".a WHEN '1' THEN 1 ELSE 0 END) Field02, \n";			sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".b WHEN '1' THEN 1 ELSE 0 END) Field03, \n";			sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".c WHEN '1' THEN 1 ELSE 0 END) Field04, \n";			sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".d WHEN '1' THEN 1 ELSE 0 END) Field05, \n";			sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".e WHEN '1' THEN 1 ELSE 0 END) Field06, \n";			sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".f WHEN '1' THEN 1 ELSE 0 END) Field07, \n";			sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".g WHEN '1' THEN 1 ELSE 0 END) Field08  \n";			sSQLs+="	FROM "+currentOent+",HADO_TB_Subcon_"+currentYear+",HADO_TB_SOent_Answer_"+currentYear+" \n";			sSQLs+="	WHERE HADO_TB_Subcon_"+currentYear+".Oent_GB=HADO_TB_SOent_Answer_"+currentYear+".Oent_GB \n";			sSQLs+="		AND "+currentOent+".Current_Year=HADO_TB_Subcon_"+currentYear+".Current_Year \n";			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".Sent_Status='1' \n";			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".addr_status IS NULL \n";
			/* 2015-09-09 / 강슬기 / 2015년도 조사제외대상 조건 추가 
			if( currentYear>=2015 ) {
				sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".sp_fld_03 IS NULL \n";
			}
			*/
			if( currentYear>=2015 ) {
				sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".sp_fld_03 IS NULL \n";
			}
			sSQLs+="		AND "+currentOent+".Mng_No=HADO_TB_Subcon_"+currentYear+".Mng_No \n";			sSQLs+="		AND "+currentOent+".Oent_GB=HADO_TB_Subcon_"+currentYear+".Oent_GB \n";			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".Child_Mng_No=HADO_TB_SOent_Answer_"+currentYear+".Mng_No \n";			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".Current_Year=HADO_TB_SOent_Answer_"+currentYear+".Current_Year \n";
			if( session.getAttribute("wgb").equals("1") ) {
				if( currentYear>=2014 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=1 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=4 \n";
				} else if( currentYear>=2012 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=3 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=4 \n";
				}
			} else if( session.getAttribute("wgb").equals("3") ) {
				if( currentYear>=2014 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=1 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=4 \n";
				} else if( currentYear>=2012 ) {
					sSQLs+="		AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=3 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=4 \n";
				}
			} else {
				if( currentYear>=2014 ) {
					sSQLs+="		AND ( (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=1 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=4 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='1') \n";
					sSQLs+="			OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=1 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=4 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='3') ) \n";
				} else {
					sSQLs+="		AND ((HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=3 AND HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=4 AND HADO_TB_Subcon_"+currentYear+".oent_gb='1') \n";
					sSQLs+="		OR ( HADO_TB_SOent_Answer_"+currentYear+".soent_q_cd=3  AND  HADO_TB_SOent_Answer_"+currentYear+".soent_q_gb=4 AND HADO_TB_Subcon_"+currentYear+".oent_gb='3')) \n";
				}
			}
			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".sent_no=HADO_TB_SOent_Answer_"+currentYear+".sent_no \n";
			if( !session.getAttribute("wgb").equals("") ) {				sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".oent_gb='"+session.getAttribute("wgb")+"' \n";			}			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".Current_Year='"+currentYear+"' \n";			if( !session.getAttribute("wgb").equals("") ) {				sSQLs+="	GROUP BY "+currentOent+".Oent_Type \n";				sSQLs+=") a LEFT JOIN Common_CD b \n";				sSQLs+="ON b.Addon_GB='"+session.getAttribute("wgb")+"' \n";				sSQLs+="AND a.Oent_Type=b.Common_cd \n";				sSQLs+="ORDER BY oent_type \n";			} else {				sSQLs+="GROUP BY HADO_TB_Subcon_"+currentYear+".oent_gb) CCC ORDER BY Oent_Type \n";			}
			pstmt=conn.prepareStatement(sSQLs);			rs=pstmt.executeQuery();
			nLoop=1;			while( rs.next() ) {				arrData[nLoop][9] = rs.getString("Oent_Type");				arrData[nLoop][10] = StringUtil.checkNull(rs.getString("Common_NM")).trim();				arrData[nLoop][1] = rs.getString("Field01");				arrData[nLoop][2] = rs.getString("Field02");				arrData[nLoop][3] = rs.getString("Field03");				arrData[nLoop][4] = rs.getString("Field04");				arrData[nLoop][5] = rs.getString("Field05");				arrData[nLoop][6] = rs.getString("Field06");				arrData[nLoop][7] = rs.getString("Field07");				arrData[nLoop][8] = rs.getString("Field08");
				for(int i=1; i<=8; i++) {					arrSum[i] = arrSum[i] + Float.parseFloat(arrData[nLoop][i]);				}
				nLoop++;			}			rs.close();			nLoop--;		} 	} catch(Exception e) {		e.printStackTrace();	} finally {		if(rs!=null)		try{rs.close();}	catch(Exception e){}		if(pstmt!=null)		try{pstmt.close();}	catch(Exception e){}		if(conn!=null)		try{conn.close();}	catch(Exception e){}		if(resource!=null)	resource.release();	}%><meta charset="utf-8">
<script type="text/javascript">//<![CDATA[content="";content+="<table class='resultTable'>";content+="	<tr>";content+="		<th rowspan='2'>구분</th>";content+="		<th rowspan='2'>응답업체수</th>";content+="		<th colspan='7'>단가인하 방법 (중복응답)</th>";content+="  </tr>";content+="	<tr>";content+="		<th>상호합의</th>";content+="		<th>일방적 인하</th>";content+="		<th>거래조건 착오, 거짓견적</th>";content+="		<th>일정금액 할당후 감함</th>";content+="		<th>거래조건변경으로 과다하게</th>";content+="		<th>경제상황변동 등으로 낮게</th>";content+="		<th>경쟁입찰 금액보다 낮게</th>";content+="  </tr>";
<%if( !tt.equals("start") ) {%>content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";content+="		<th rowspan='2'>계</th>";content+="		<th rowspan='2'><%=formater2.format(arrSum[1])%></th>";	<%for(int i=2; i<=8; i++) {%>content+="		<td><%=formater2.format(arrSum[i])%></td>";	<%}%>content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";	<%for(int i=2; i<=8; i++) {%>			<%if( arrSum[1] > 0F) {%>content+="		<td><%=formater.format(arrSum[i] / arrSum[1] * 100F)%>%</td>";		<%} else {%>content+="		<td>0.0%</td>";		<%}%>	<%}%>content+="	</tr>";	<%for(int ni=1; ni<=nLoop; ni++) {%>content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";		<%if( !session.getAttribute("wgb").equals("") ) {%>	content+="		<th rowspan='2'><%=arrData[ni][9]%> (<%=arrData[ni][10]%>)</th>";		<%} else {%>				<%if( arrData[ni][9].equals("1") ) {%>		content+="		<th rowspan='2'>제조</th>";				<%} else if( arrData[ni][9].equals("2") ) {%>content+="		<th rowspan='2'>건설</th>";				<%} else if( arrData[ni][9].equals("3") ) {%>								content+="		<th rowspan='2'>용역</th>";				<%}		}%>content+="		<th rowspan='2'><%=formater2.format(Float.parseFloat(arrData[ni][1]) )%></th>";		<%for(int i=2; i<=8; i++) {%>content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][i]))%></td>";		<%}%>content+="	</tr>";content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";		<%for(int i=2; i<=8; i++) {%>			<%if( Float.parseFloat(arrData[ni][1]) > 0F) {%>content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][i]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>";			<%} else {%>content+="		<td>0.0%</td>";			<%}%>		<%}%>content+="	</tr>";	<%}%><%} else {%>content+="	<tr>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="	</tr>";<%}%>content+="</table>";
top.document.getElementById("divResult").innerHTML=content;top.setNowProcessFalse();//]]</script>
<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>