<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%><%/*** 프로젝트명	 : 하도급거래 서면실태조사 지원을 위한 개발용역 사업								   * 프로그램명	 : SOent_Violate_07_proc.jsp																				   * 프로그램설명	: 수급사업자 > 조사결과분석 > 하도급대금 수령 현황 * 프로그램버전	: 1.0.1																				                        * 최초작성일자	: 2015년 09월 01일																                            * 작 성 이 력       :                                                                                                                           *=========================================================*	작성일자		작성자명				내용*=========================================================*	2015-09-01	강슬기       페이지 최신화(주석, 불필요한 코드 제거, 오래된 코드 수정)*   2015-09-09   강슬기        2015년도 조사제외대상 조건 추가 *   2016-01-07   이용광        DB변경으로 인한 인코딩 변경*/%>
<%@ page import="java.sql.*"%><%@ page import="java.util.*"%><%@ page import="ftc.util.*"%><%@ page import="ftc.db.ConnectionResource"%><%@ page import="java.text.DecimalFormat"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%><%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%><%
/*---------------------------------------- Variable Difinition ----------------------------------------*/	String tt = request.getParameter("tt")==null? "":request.getParameter("tt").trim();
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();

	ConnectionResource resource=null;	Connection conn=null;	PreparedStatement pstmt=null;	ResultSet rs=null;
	String sSQLs="";	String sSQLJoinTable="";
	String[][] arrData=new String[31][14];	float[] arrSum=new float[14];
	String tmpStr="";	String sTmpPMS=session.getAttribute("ckPermision")+"";
	int nLoop=1;	int sStartYear=2000;
	java.util.Calendar cal=java.util.Calendar.getInstance();
	DecimalFormat formater=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");	DecimalFormat formater2=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/	String tmpYear=request.getParameter("cyear")==null? "":request.getParameter("cyear").trim();

	if( tt.equals("start") ) {		session.setAttribute("wgb", "1");	}
	if( comm.equals("search") ) {		session.setAttribute("wgb", request.getParameter("wgb")==null? "": request.getParameter("wgb").trim());
	}
	if( !tmpYear.equals("") ) {		session.setAttribute("cyear", tmpYear);	} else {		session.setAttribute("cyear", st_Current_Year);	}
	int currentYear=st_Current_Year_n;	currentYear=Integer.parseInt(session.getAttribute("cyear")+"");
	int endCurrentYear=st_Current_Year_n;
	// view table name	String currentOent = currentYear>=2012 ? "HADO_TB_Oent_"+tmpYear : "HADO_TB_Oent";
	// 합계배열 초기화	for(int i=1; i <=13; i++) { 		arrSum[i]=0F; 	}
	try {		resource=new ConnectionResource();		conn=resource.getConnection();
		if( !tt.equals("start") ) {
			if (currentYear>=2015) {
				sSQLJoinTable="SELECT HADO_TB_Rec_Loan.Mng_No,HADO_TB_Rec_Loan.Current_Year,HADO_TB_Rec_Loan.OENT_GB, \n";			sSQLJoinTable+="HADO_TB_Rec_Loan.SENT_NO,HADO_TB_Rec_Loan.HALF_GB,HADO_TB_Rec_Loan.CURRENCY, \n";
				sSQLJoinTable+="HADO_TB_Rec_Loan.BILL,HADO_TB_Rec_Loan.ETC,HADO_TB_Rec_Loan.Ent_Card,HADO_TB_Rec_Loan.Ent_Loan, \n";
				sSQLJoinTable+="HADO_TB_Rec_Loan.Cred_Loan,HADO_TB_Rec_Loan.buy_loan,HADO_TB_Rec_Loan.network_loan,"+currentOent+".OENT_TYPE, \n";
				sSQLJoinTable+="HADO_TB_Subcon_"+currentYear+".RETURN_GB,"+currentOent+".COMP_STATUS,"+currentOent+".SUBCON_TYPE,HADO_TB_Subcon_"+currentYear+".SENT_STATUS,HADO_TB_Subcon_"+currentYear+".ADDR_STATUS,HADO_TB_Subcon_"+currentYear+".SP_FLD_03 \n";
				sSQLJoinTable+="FROM HADO_TB_Rec_Loan LEFT JOIN HADO_TB_Subcon_"+currentYear+" ON HADO_TB_Rec_Loan.Mng_No=HADO_TB_Subcon_"+currentYear+".Child_Mng_No \n";
				sSQLJoinTable+="AND HADO_TB_Rec_Loan.Current_Year=HADO_TB_Subcon_"+currentYear+".Current_year \n";
				sSQLJoinTable+="AND HADO_TB_Rec_Loan.OENT_GB=HADO_TB_Subcon_"+currentYear+".OENT_GB \n";
				sSQLJoinTable+="AND HADO_TB_Rec_Loan.SENT_NO=HADO_TB_Subcon_"+currentYear+".SENT_NO \n";
				sSQLJoinTable+="LEFT JOIN "+currentOent+" ON HADO_TB_Subcon_"+currentYear+".Mng_No="+currentOent+".Mng_No \n";
				sSQLJoinTable+="AND HADO_TB_Subcon_"+currentYear+".Current_Year="+currentOent+".Current_Year \n";
				sSQLJoinTable+="AND HADO_TB_Subcon_"+currentYear+".OENT_GB="+currentOent+".OENT_GB \n";
			} else if (currentYear==2013) {				// 2014-02-14 2013 reason 반영
				sSQLJoinTable="SELECT * FROM ( \n";
				sSQLJoinTable+="	SELECT A1.*,A2.sent_status,A2.addr_status,A2.return_GB, \n";
				sSQLJoinTable+="	A3.comp_status,A3.oent_type,A3.subcon_type,	\n";
				sSQLJoinTable+="	CASE WHEN subj_ans IS NULL THEN 'N' ELSE 'Y' END reasonF FROM ( \n";
				sSQLJoinTable+="		SELECT * FROM HADO_TB_Rec_Loan WHERE current_year='"+currentYear+"' \n";
				sSQLJoinTable+="	) A1 \n";
				sSQLJoinTable+="	LEFT JOIN HADO_TB_Subcon_"+currentYear+" A2 \n";
				sSQLJoinTable+="		ON A1.Mng_No=A2.Child_Mng_No AND A1.Current_Year=A2.Current_year \n";
				sSQLJoinTable+="		AND A1.OENT_GB=A2.OENT_GB AND A1.SENT_NO=A2.SENT_NO \n";
				sSQLJoinTable+="	LEFT JOIN "+currentOent+" A3 \n";
				sSQLJoinTable+="		ON A2.Mng_No=A3.Mng_No AND A2.Current_Year=A3.Current_Year AND A2.OENT_GB=A3.OENT_GB \n";
				sSQLJoinTable+="	LEFT JOIN hado_tb_soent_answer_"+currentYear+" A4 \n";
				sSQLJoinTable+="		ON A2.child_mng_no=A4.mng_no \n";
				sSQLJoinTable+="		AND A2.oent_gb=A4.oent_gb \n";
				sSQLJoinTable+="		AND A2.current_year=A4.current_year \n";
				sSQLJoinTable+="		AND A4.soent_q_cd=30 AND A4.soent_q_gb=1 \n";
				sSQLJoinTable+=") aJTbl WHERE reasonF='N' \n";
			} else {				sSQLJoinTable="SELECT HADO_TB_Rec_Loan.Mng_No,HADO_TB_Rec_Loan.Current_Year,HADO_TB_Rec_Loan.OENT_GB, \n";			sSQLJoinTable+="HADO_TB_Rec_Loan.SENT_NO,HADO_TB_Rec_Loan.HALF_GB,HADO_TB_Rec_Loan.CURRENCY, \n";				sSQLJoinTable+="HADO_TB_Rec_Loan.BILL,HADO_TB_Rec_Loan.ETC,HADO_TB_Rec_Loan.Ent_Card,HADO_TB_Rec_Loan.Ent_Loan, \n";				sSQLJoinTable+="HADO_TB_Rec_Loan.Cred_Loan,HADO_TB_Rec_Loan.buy_loan,HADO_TB_Rec_Loan.network_loan,"+currentOent+".OENT_TYPE, \n";				sSQLJoinTable+="HADO_TB_Subcon_"+currentYear+".RETURN_GB,"+currentOent+".COMP_STATUS,"+currentOent+".SUBCON_TYPE,HADO_TB_Subcon_"+currentYear+".SENT_STATUS,HADO_TB_Subcon_"+currentYear+".ADDR_STATUS \n";				sSQLJoinTable+="FROM HADO_TB_Rec_Loan LEFT JOIN HADO_TB_Subcon_"+currentYear+" ON HADO_TB_Rec_Loan.Mng_No=HADO_TB_Subcon_"+currentYear+".Child_Mng_No \n";				sSQLJoinTable+="AND HADO_TB_Rec_Loan.Current_Year=HADO_TB_Subcon_"+currentYear+".Current_year \n";				sSQLJoinTable+="AND HADO_TB_Rec_Loan.OENT_GB=HADO_TB_Subcon_"+currentYear+".OENT_GB \n";				sSQLJoinTable+="AND HADO_TB_Rec_Loan.SENT_NO=HADO_TB_Subcon_"+currentYear+".SENT_NO \n";				sSQLJoinTable+="LEFT JOIN "+currentOent+" ON HADO_TB_Subcon_"+currentYear+".Mng_No="+currentOent+".Mng_No \n";				sSQLJoinTable+="AND HADO_TB_Subcon_"+currentYear+".Current_Year="+currentOent+".Current_Year \n";				sSQLJoinTable+="AND HADO_TB_Subcon_"+currentYear+".OENT_GB="+currentOent+".OENT_GB \n";			}

			if( !session.getAttribute("wgb").equals("") ) {				sSQLs="SELECT b.Oent_Type,c.Common_NM,b.Field01,b.Field02,b.Field03,b.Field04,b.Field05,b.Field06,b.Field07,b.Field08, \n";				sSQLs+="b.Field09,b.Field10 FROM (SELECT a.Oent_Type, \n";			} else {				sSQLs="SELECT Oent_GB Oent_Type,'' Common_NM,Field01,Field02,Field03,Field04,Field05,Field06,Field07,Field08, \n";				sSQLs+="Field09,Field10 FROM (SELECT a.Oent_GB, \n";			}			sSQLs+="NVL(COUNT(DISTINCT a.Mng_No),0) Field01, \n";			sSQLs+="SUM(CASE a.Currency WHEN null THEN 0 ELSE a.Currency END) Field02, \n";			sSQLs+="SUM(CASE a.Bill WHEN null THEN 0 ELSE a.Bill END) Field03, \n";			sSQLs+="SUM(CASE a.Ent_Card WHEN null THEN 0 ELSE a.Ent_Card END) Field04, \n";			sSQLs+="SUM(CASE a.Ent_Loan WHEN null THEN 0 ELSE a.Ent_Loan END) Field05, \n";			sSQLs+="SUM(CASE a.Cred_Loan WHEN null THEN 0  ELSE a.Cred_Loan END) Field06, \n";			sSQLs+="SUM(CASE a.Buy_Loan WHEN null THEN 0 ELSE a.Buy_Loan END) Field07, \n";			sSQLs+="SUM(CASE a.network_loan WHEN null THEN 0 ELSE a.Network_Loan END) Field08, \n";			sSQLs+="SUM(CASE a.ETC WHEN null THEN 0 ELSE a.ETC END) Field09, \n";			sSQLs+="SUM(CASE a.Currency WHEN null THEN 0 ELSE a.currency END)+SUM(CASE a.bill WHEN null THEN 0 ELSE a.bill END)+ \n";			sSQLs+="SUM(CASE a.ent_card WHEN null THEN 0 ELSE a.ent_card END)+SUM(CASE a.ent_loan WHEN null THEN 0 ELSE a.ent_loan END)+ \n";			sSQLs+="SUM(CASE a.etc WHEN null THEN 0 ELSE a.etc END)+SUM(CASE a.cred_loan WHEN null THEN 0 ELSE a.cred_loan END)+ \n";			sSQLs+="SUM(CASE a.buy_loan WHEN null THEN 0 ELSE a.buy_loan END)+SUM(CASE a.network_loan WHEN null THEN 0 ELSE a.network_loan END) Field10 \n";			sSQLs+="FROM ("+sSQLJoinTable+") a \n";
			sSQLs+="WHERE a.Current_Year='"+currentYear+"' AND a.Sent_Status='1' AND a.comp_status='1' \n";			sSQLs+="		AND a.addr_status IS NULL \n";
			/* 2015-09-09 / 강슬기 / 2015년도 조사제외대상 조건 추가 
			if( currentYear>=2015 ) {
				sSQLs+="		AND a.sp_fld_03 IS NULL \n";
			}
			*/
			if( currentYear>=2015 ) {
				sSQLs+="		AND a.sp_fld_03 IS NULL \n";
			}

			if( !session.getAttribute("wgb").equals("") ) {				sSQLs+="AND a.Oent_GB='"+session.getAttribute("wgb")+"' \n";			}			if( !session.getAttribute("wgb").equals("") ) {				sSQLs+="GROUP BY a.oent_type) b \n";				sSQLs+="LEFT JOIN COMMON_CD c \n";				sSQLs+="ON c.Addon_GB='"+session.getAttribute("wgb")+"' \n";				sSQLs+="AND b.Oent_Type=c.Common_CD ORDER BY b.oent_type \n";			} else {				sSQLs+="GROUP BY a.oent_gb) CCC ORDER BY oent_gb \n";			}			
			//System.out.print(sSQLs);			pstmt=conn.prepareStatement(sSQLs);			rs=pstmt.executeQuery();
			nLoop=1;			while( rs.next() ) {				arrData[nLoop][12]=rs.getString("Oent_Type");				arrData[nLoop][13]=StringUtil.checkNull(rs.getString("Common_NM")).trim();				arrData[nLoop][2]=rs.getString("Field01");				arrData[nLoop][3]=rs.getString("Field02");				arrData[nLoop][4]=rs.getString("Field03");				arrData[nLoop][5]=rs.getString("Field04");				arrData[nLoop][6]=rs.getString("Field05");				arrData[nLoop][7]=rs.getString("Field06");				arrData[nLoop][8]=rs.getString("Field07");				arrData[nLoop][9]=rs.getString("Field08");				arrData[nLoop][10]=rs.getString("Field09");				arrData[nLoop][11]=rs.getString("Field10");
				for(int i=1; i<=10; i++) {					arrSum[i]=arrSum[i]+Float.parseFloat(arrData[nLoop][i+1]);				}
				nLoop++;			}			rs.close();			nLoop--;		}	} catch(Exception e) {		e.printStackTrace();	} finally {		if(rs!=null)		try{rs.close();}	catch(Exception e){}		if(pstmt!=null)		try{pstmt.close();}	catch(Exception e){}		if(conn!=null)		try{conn.close();}	catch(Exception e){}		if(resource!=null)	resource.release();	}%><meta charset="utf-8"><script type="text/javascript">//<![CDATA[content="";content+="<table class='resultTable'>";content+="	<tr>";content+="		<th rowspan='2'>구분</th>";content+="		<th rowspan='2'>응답업체수</th>";content+="		<th colspan='9'>하도급대금 결제방식 (단위: 백만원)</th>";content+="  </tr>";
content+="	<tr>";content+="		<th>현금</th>";content+="		<th>어음</th>";content+="		<th>기업구매<br/>전용카드</th>";content+="		<th>기업구매<br/>자금대출</th>";content+="		<th>외상매출채권<br/>담보대출</th>";content+="		<th>구매론</th>";content+="		<th>네트워크론</th>";content+="		<th>기타</th>";content+="		<th>계</th>";content+="  </tr>";
<%if( !tt.equals("start") ) {%>content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";content+="		<th rowspan='2'>계</th>";content+="		<th rowspan='2'><%=formater2.format(arrSum[1])%></th>";	<%for(int i=2; i<=10; i++) {%>content+="		<td><%=formater2.format(arrSum[i])%></td>";	<%}%>content+="	</tr>";content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";	<%for(int i=2; i<=10; i++) {%>			<%if( arrSum[10] > 0F) {%>content+="		<td><%=formater.format(arrSum[i] / arrSum[10] * 100F)%>%</td>";		<%} else {%>content+="		<td>0.0%</td>";		<%}%>	<%}%>content+="	</tr>";
	<%for(int ni=1; ni<=nLoop; ni++) {%>content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";		<%if( !session.getAttribute("wgb").equals("") ) {%>	content+="		<th rowspan='2'><%=arrData[ni][12]%> (<%=arrData[ni][13]%>)</th>";		<%} else {%>				<%if( arrData[ni][12].equals("1") ) {%>		content+="		<th rowspan='2'>제조</th>";				<%} else if( arrData[ni][12].equals("2") ) {%>content+="		<th rowspan='2'>건설</th>";				<%} else if( arrData[ni][12].equals("3") ) {%>								content+="		<th rowspan='2'>용역</th>";				<%}		}%>content+="		<th rowspan='2'><%=formater2.format(Float.parseFloat(arrData[ni][2]) )%></th>";		<%for(int i=3; i<=11; i++) {%>content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][i]) )%></td>";		<%}%>content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";		<%for(int i=3; i<=11; i++) {%>			<%if( Float.parseFloat(arrData[ni][11]) > 0F) {%>content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][i]) / Float.parseFloat(arrData[ni][11]) * 100F)%>%</td>";			<%} else {%>content+="		<td>0.0%</td>";			<%}%>		<%}%>content+="	</tr>";
	<%}%><%} else {%>content+="	<tr>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="		<td>&nbsp;</td>";content+="	</tr>";<%}%>content+="</table>";
top.document.getElementById("divResult").innerHTML=content;top.setNowProcessFalse();//]]</script><%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>