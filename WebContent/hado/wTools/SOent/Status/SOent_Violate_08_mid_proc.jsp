<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%><%/*** 프로젝트명	 : 하도급거래 서면실태조사 지원을 위한 개발용역 사업* 프로그램명	 : SOent_Violate_08_proc.jsp* 프로그램설명	: 수급사업자 > 조사결과분석 > 어음의 평균결제기간* 프로그램버전	: 1.0.1* 최초작성일자	: 2015년 09월 01일* 작 성 이 력       :*=========================================================*	작성일자		작성자명				내용*=========================================================*	2015-09-01	강슬기       페이지 최신화(주석, 불필요한 코드 제거, 오래된 코드 수정)*   2015-09-09   강슬기        2015년도 조사제외대상 조건 추가*   2016-01-07   이용광        DB변경으로 인한 인코딩 변경*/%>
<%@ page import="java.sql.*"%><%@ page import="java.util.*"%><%@ page import="ftc.util.*"%><%@ page import="ftc.db.ConnectionResource"%><%@ page import="java.text.DecimalFormat"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%><%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>
<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/	String tt = request.getParameter("tt")==null? "":request.getParameter("tt").trim();
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();

	ConnectionResource resource=null;	Connection conn=null;	PreparedStatement pstmt=null;	ResultSet rs=null;
	String sSQLs="";	String sSQLJoinTable="";
	String[][] arrData=new String[31][12];	float[] arrSum=new float[12];
	String tmpStr="";	String sTmpPMS=session.getAttribute("ckPermision")+"";
	int nLoop=1;	int sStartYear=2000;
	java.util.Calendar cal=java.util.Calendar.getInstance();
	DecimalFormat formater=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");	DecimalFormat formater2=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/	String tmpYear=request.getParameter("cyear")==null? "":request.getParameter("cyear").trim();
	if( !tmpYear.equals("") ) {		session.setAttribute("cyear", tmpYear);	} else {		session.setAttribute("cyear", st_Current_Year);	}
	int currentYear=st_Current_Year_n;	currentYear=Integer.parseInt(session.getAttribute("cyear")+"");
	if( tt.equals("start") ) {		session.setAttribute("wgb", "1");	}
	if( comm.equals("search") ) {		session.setAttribute("wgb", request.getParameter("wgb")==null? "": request.getParameter("wgb").trim());
	}
	int endCurrentYear=st_Current_Year_n;
	// view table name	String currentOent = currentYear>=2012 ? "HADO_TB_Oent_"+tmpYear : "HADO_TB_Oent";
	// 합계배열 초기화	for(int i=1; i <=11; i++) {		arrSum[i]=0F;	}
	try {		resource=new ConnectionResource();		conn=resource.getConnection();
		if( !tt.equals("start") ) {			sSQLJoinTable="SELECT HADO_TB_SOent_Answer_"+currentYear+".Mng_No,HADO_TB_SOent_Answer_"+currentYear+".Current_Year,HADO_TB_SOent_Answer_"+currentYear+".Oent_GB, \n";			sSQLJoinTable+="HADO_TB_SOent_Answer_"+currentYear+".Sent_No,HADO_TB_SOent_Answer_"+currentYear+".SOENT_Q_CD, \n";			sSQLJoinTable+="HADO_TB_SOent_Answer_"+currentYear+".SOENT_Q_GB,HADO_TB_SOent_Answer_"+currentYear+".A, \n";			sSQLJoinTable+="HADO_TB_SOent_Answer_"+currentYear+".B,HADO_TB_SOent_Answer_"+currentYear+".C,HADO_TB_SOent_Answer_"+currentYear+".D, \n";			sSQLJoinTable+="HADO_TB_SOent_Answer_"+currentYear+".E,HADO_TB_SOent_Answer_"+currentYear+".F,HADO_TB_SOent_Answer_"+currentYear+".G, \n";			sSQLJoinTable+="HADO_TB_SOent_Answer_"+currentYear+".H,HADO_TB_SOent_Answer_"+currentYear+".I,HADO_TB_SOent_Answer_"+currentYear+".J, \n";			sSQLJoinTable+="HADO_TB_SOent_Answer_"+currentYear+".K,HADO_TB_Subcon_"+currentYear+".SUBCON_TYPE, \n";			sSQLJoinTable+="HADO_TB_Subcon_"+currentYear+".SENT_STATUS,HADO_TB_Subcon_"+currentYear+".ADDR_STATUS,"+currentOent+".OENT_TYPE, \n";			/* 2015-09-09 / 강슬기 / 2015년도 조사제외대상 조건 추가				if( currentYear>=2015 ) {
				sSQLJoinTable+="HADO_TB_Subcon_"+currentYear+".SP_FLD_03, \n";
			}			*/			if( currentYear>=2015 ) {
				sSQLJoinTable+="HADO_TB_Subcon_"+currentYear+".SP_FLD_03, \n";
			}
			sSQLJoinTable+=""+currentOent+".COMP_STATUS,HADO_TB_Subcon_"+currentYear+".RETURN_GB  \n";			sSQLJoinTable+="FROM (SELECT * FROM "+currentOent+" WHERE CURRENT_YEAR = "+currentYear+" AND SP_FLD_04 = 1 ) "+currentOent+" RIGHT JOIN HADO_TB_Subcon_"+currentYear+" ON "+currentOent+".OENT_GB=HADO_TB_Subcon_"+currentYear+".OENT_GB AND \n";			sSQLJoinTable+=""+currentOent+".Current_Year=HADO_TB_Subcon_"+currentYear+".Current_Year AND "+currentOent+".Mng_No=HADO_TB_Subcon_"+currentYear+".Mng_No \n";			sSQLJoinTable+="RIGHT JOIN HADO_TB_SOent_Answer_"+currentYear+" ON HADO_TB_Subcon_"+currentYear+".SENT_NO=HADO_TB_SOent_Answer_"+currentYear+".SENT_NO AND \n";			sSQLJoinTable+="HADO_TB_Subcon_"+currentYear+".OENT_GB=HADO_TB_SOent_Answer_"+currentYear+".OENT_GB AND HADO_TB_Subcon_"+currentYear+".Current_Year=HADO_TB_SOent_Answer_"+currentYear+".Current_Year AND \n";			sSQLJoinTable+="HADO_TB_Subcon_"+currentYear+".Child_Mng_No=HADO_TB_SOent_Answer_"+currentYear+".Mng_No \n";
			if( !session.getAttribute("wgb").equals("") ) {				sSQLs="SELECT a.Oent_Type,b.Common_NM,a.Field01,a.Field02,a.Field03,a.Field04,a.Field05,a.Field06, \n";				sSQLs+="a.Field07,a.Field08 FROM (SELECT jt.Oent_Type, \n";			} else {				sSQLs="SELECT Oent_GB Oent_Type,'' Common_NM,Field01,Field02,Field03,Field04,Field05,Field06, \n";				sSQLs+="Field07,Field08 FROM (SELECT jt.Oent_GB, \n";			}			sSQLs+="NVL(COUNT(jt.Mng_No),0) Field01, \n";			sSQLs+="SUM(CASE jt.a WHEN '1' THEN 1 ELSE 0 END) Field02, \n";			sSQLs+="SUM(CASE jt.b WHEN '1' THEN 1 ELSE 0 END) Field03, \n";			sSQLs+="SUM(CASE jt.c WHEN '1' THEN 1 ELSE 0 END) Field04, \n";			sSQLs+="SUM(CASE jt.d WHEN '1' THEN 1 ELSE 0 END) Field05, \n";			sSQLs+="SUM(CASE jt.b WHEN '1' THEN 1 ELSE 0 END)+SUM(CASE jt.c WHEN '1' THEN 1 ELSE 0 END)+ \n";			sSQLs+="SUM(CASE jt.d WHEN '1' THEN 1 ELSE 0 END) Field06, \n";			sSQLs+="SUM(CASE jt.a WHEN '1' THEN 1 ELSE 0 END)+SUM(CASE jt.b WHEN '1' THEN 1 ELSE 0 END)+ \n";			sSQLs+="SUM(CASE jt.c WHEN '1' THEN 1 ELSE 0 END)+SUM(CASE jt.d WHEN '1' THEN 1 ELSE 0 END) Field07, \n";			sSQLs+="SUM(CASE jt.e WHEN '1' THEN 1 ELSE 0 END) Field08 \n";			sSQLs+="FROM ("+sSQLJoinTable+") jt \n";			sSQLs+="WHERE jt.sent_status='1' AND jt.comp_status='1' \n";			sSQLs+="		AND jt.addr_status IS NULL \n";				/* 2015-09-09 / 강슬기 / 2015년도 조사제외대상 조건 추가				if( currentYear>=2015 ) {
				sSQLs+="		AND jt.sp_fld_03 IS NULL \n";
			}				*/				if( currentYear>=2015 ) {
				sSQLs+="		AND jt.sp_fld_03 IS NULL \n";
			}					if( session.getAttribute("wgb").equals("1") ) {				if( currentYear>=2012 ) {					sSQLs+="AND jt.SOent_Q_CD=8 AND jt.SOent_Q_GB=3 \n";				} else {					sSQLs+="AND jt.SOent_Q_CD=10 AND jt.SOent_Q_GB=3 \n";				}			} else if( session.getAttribute("wgb").equals("2") ) {				if( currentYear>=2015 ) {					sSQLs+="AND jt.SOent_Q_CD=10 AND jt.SOent_Q_GB=3 \n";				} else if( currentYear>=2012 ) {					sSQLs+="AND jt.SOent_Q_CD=9 AND jt.SOent_Q_GB=3 \n";				}			} else if( session.getAttribute("wgb").equals("3") ) {				sSQLs+="AND jt.SOent_Q_CD=8 AND jt.SOent_Q_GB=3 \n";			} else {				if( currentYear>=2015 ) {					sSQLs+="AND ( (jt.SOent_Q_CD=8 AND jt.SOent_Q_GB=3 AND jt.Oent_GB='1') \n";					sSQLs+="OR (jt.SOent_Q_CD=10 AND jt.SOent_Q_GB=3 AND jt.Oent_GB='2') \n";					sSQLs+="OR (jt.SOent_Q_CD=8 AND jt.SOent_Q_GB=3 AND jt.Oent_GB='3') ) \n";				} else if( currentYear>=2012 ) {					sSQLs+="AND ( (jt.SOent_Q_CD=8 AND jt.SOent_Q_GB=3 AND jt.Oent_GB='1') \n";					sSQLs+="OR (jt.SOent_Q_CD=9 AND jt.SOent_Q_GB=3 AND jt.Oent_GB='2') \n";					sSQLs+="OR (jt.SOent_Q_CD=8 AND jt.SOent_Q_GB=3 AND jt.Oent_GB='3') ) \n";				} else {					sSQLs+="AND ( (jt.SOent_Q_CD=10 AND jt.SOent_Q_GB=3 AND jt.Oent_GB='1') \n";					sSQLs+="OR (jt.SOent_Q_CD=8 AND jt.SOent_Q_GB=3 AND jt.Oent_GB='3') ) \n";				}			}
			if( !session.getAttribute("wgb").equals("") ) {				sSQLs+="AND jt.Oent_GB='"+session.getAttribute("wgb")+"' \n";			}			sSQLs+="AND jt.Current_Year='"+currentYear+"' \n";
			if( !session.getAttribute("wgb").equals("") ) {				sSQLs+="GROUP BY jt.Oent_Type) a \n";				sSQLs+="LEFT JOIN Common_CD b \n";				sSQLs+="ON b.Addon_GB='"+session.getAttribute("wgb")+"' \n";				sSQLs+="AND a.Oent_Type=b.Common_CD ORDER BY a.oent_type \n";			} else {				sSQLs+="GROUP BY jt.oent_gb) CCC ORDER BY Oent_Type \n";			}			//System.out.print("\n*********************************************\n");
			//System.out.print(sSQLs);			//System.out.print("\n*********************************************\n");			pstmt=conn.prepareStatement(sSQLs);			rs=pstmt.executeQuery();
			nLoop=1;			while( rs.next() ) {				arrData[nLoop][10]=rs.getString("Oent_Type");				arrData[nLoop][11]=StringUtil.checkNull(rs.getString("Common_NM")).trim();				arrData[nLoop][2]=rs.getString("Field01");				arrData[nLoop][3]=rs.getString("Field02");				arrData[nLoop][4]=rs.getString("Field03");				arrData[nLoop][5]=rs.getString("Field04");				arrData[nLoop][6]=rs.getString("Field05");				arrData[nLoop][7]=rs.getString("Field06");				arrData[nLoop][8]=rs.getString("Field07");				arrData[nLoop][9]=rs.getString("Field08");
				for(int i=1; i<=8; i++) {					arrSum[i]=arrSum[i]+Float.parseFloat(arrData[nLoop][i+1]);				}
				nLoop++;			}			rs.close();			nLoop--;		}	} catch(Exception e) {		e.printStackTrace();	} finally {		if(rs!=null)		try{rs.close();}	catch(Exception e){}		if(pstmt!=null)		try{pstmt.close();}	catch(Exception e){}		if(conn!=null)		try{conn.close();}	catch(Exception e){}		if(resource!=null)	resource.release();	}%><meta charset="utf-8">
<script type="text/javascript">//<![CDATA[content="";content+="<table class='resultTable'>";content+="	<tr>";content+="		<th rowspan='3'>구분</th>";content+="		<th rowspan='3'>응답업체수</th>";content+="		<th colspan='6'>어음의 평균결제기간</th>";content+="		<th rowspan='3'>전액현금(마)</th>";content+="  </tr>";content+="	<tr>";content+="		<th rowspan='2'>60일 이하(가)</th>";content+="		<th colspan='4'>60일 초과</th>";content+="		<th rowspan='2'>계</th>";content+="  </tr>";content+="	<tr>";content+="		<th>61일 ~ 90일 (나)</th>";content+="		<th>91일 ~ 120일 (다)</th>";content+="		<th>121일 이상 (라)</th>";content+="		<th>소계</th>";content+="  </tr>";
<%if( !tt.equals("start") ) {%>content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";content+="		<th rowspan='2'>계</th>";content+="		<th rowspan='2'><%=formater2.format(arrSum[1])%></th>";	<%for(int i=2; i<=8; i++) {%>content+="		<td><%=formater2.format(arrSum[i])%></td>";	<%}%>content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";	<%for(int i=2; i<=8; i++) {%>		<%if(i==8){%>			<%if( arrSum[1] > 0F) {%>content+="		<td><%=formater.format(arrSum[i] / arrSum[1] * 100F)%>%</td>";			<%} else {%>content+="		<td>0.0%</td>";			<%}%>		<%}else{%>			<%if( arrSum[7] > 0F) {%>content+="		<td><%=formater.format(arrSum[i] / arrSum[7] * 100F)%>%</td>";			<%} else {%>content+="		<td>0.0%</td>";			<%}%>		<%}%>	<%}%>content+="	</tr>";
	<%for(int ni=1; ni<=nLoop; ni++) {%>content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";		<%if( !session.getAttribute("wgb").equals("") ) {%>content+="		<th rowspan='2'><%=arrData[ni][10]%> (<%=arrData[ni][11]%>)</th>";		<%} else {%>				<%if( arrData[ni][10].equals("1") ) {%>content+="		<th rowspan='2'>제조</th>";				<%} else if( arrData[ni][10].equals("2") ) {%>content+="		<th rowspan='2'>건설</th>";				<%} else if( arrData[ni][10].equals("3") ) {%>content+="		<th rowspan='2'>용역</th>";				<%}		}%>content+="		<th rowspan='2'><%=formater2.format(Float.parseFloat(arrData[ni][2]) )%></th>";		<%for(int i=3; i<=9; i++) {%>content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][i]))%></td>";		<%}%>content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";		<%for(int i=3; i<=9; i++) {%>			<%if(i==9) {%>				<%if( Float.parseFloat(arrData[ni][2]) > 0F) {%>content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][i]) / Float.parseFloat(arrData[ni][2]) * 100F)%>%</td>";				<%} else {%>content+="		<td>0.0%</td>";				<%}%>			<%} else {%>				<%if( Float.parseFloat(arrData[ni][8]) > 0F) {%>content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][i]) / Float.parseFloat(arrData[ni][8]) * 100F)%>%</td>";				<%} else {%>content+="		<td>0.0%</td>";				<%}%>			<%}%>		<%}%>content+="	</tr>";
	<%}%><%} else {%>content+="	<tr>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="	</tr>";<%}%>content+="</table>";
top.document.getElementById("divResult").innerHTML=content;top.setNowProcessFalse();//]]</script><%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>