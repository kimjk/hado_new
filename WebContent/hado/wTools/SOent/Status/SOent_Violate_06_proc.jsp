<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명	 : 하도급거래 서면실태조사 지원을 위한 개발용역 사업								   
* 프로그램명	 : SOent_Violate_06_proc.jsp																				   
* 프로그램설명	: 수급사업자 > 조사결과분석 > 표준하도급계약서 사용여부 
* 프로그램버전	: 1.0.1																				                        
* 최초작성일자	: 2015년 09월 01일												                            
* 작 성 이 력       :                                                                                                                           
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2015-09-01	강슬기       페이지 최신화(주석, 불필요한 코드 제거, 오래된 코드 수정)
*   2015-09-09   강슬기        2015년도 조사제외대상 조건 추가
*   2016-01-07   이용광        DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="java.text.DecimalFormat"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>
<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String tt = request.getParameter("tt")==null? "":request.getParameter("tt").trim();
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();
	
	ConnectionResource resource=null;
	Connection conn=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	
	String sSQLs="";
	String sField="";
	String tmpString="";

	String[][] arrData=new String[31][8];
	float[] arrSum=new float[8];

	String tmpStr="";
	String sTmpPMS=session.getAttribute("ckPermision")+"";
	
	int nLoop=1;
	int sStartYear=2000;

	java.util.Calendar cal=java.util.Calendar.getInstance();

	DecimalFormat formater=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	String tmpYear=request.getParameter("cyear")==null? "":request.getParameter("cyear").trim();
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
		session.setAttribute("wgb", request.getParameter("wgb")==null? "": request.getParameter("wgb").trim());
	}

	int endCurrentYear=st_Current_Year_n;

	/* 2012년 원사업자 관련 DB Table 분리 예외처리 시작 ============================================================> */
		/* 업데이트 일자 : 2012년 11월 13일
		   작성자 : 정광식
		   비고 : Database 성능향상을 위하여 2012년부터 원사업자 테이블 분리
				  HADO_TB_Oent --> HADO_TB_Oent_2012 */
		String currentOent = "HADO_TB_Oent";
		if( currentYear>2011 ) {
			currentOent = "HADO_TB_Oent_"+currentYear;
		}
		/* <============================================================== 2012년 원사업자 관련 DB Table 분리 예외처리 끝 */

	// 합계배열 초기화
	for(int i=1; i <=6; i++) { 
		arrSum[i]=0F; 
	}
	
	try {
		resource=new ConnectionResource();
		conn=resource.getConnection();

		if( !tt.equals("start") ) {
			if( !session.getAttribute("wgb").equals("") ) {
				sSQLs="SELECT A.Oent_Type,B.Common_NM,A.Field01,A.Field02,A.Field03,A.Field04 FROM ( \n";
				sSQLs+="	SELECT " + currentOent + ".Oent_Type, NVL(COUNT(" + currentOent + ".Mng_No),0) Field01, \n";
				sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".A WHEN '1' THEN 1 ELSE 0 END) Field02, \n";
			} else {
				sSQLs="SELECT HADO_TB_Subcon_"+currentYear+".Oent_GB Oent_Type,'' Common_NM, \n";
				sSQLs+="	NVL(COUNT(" + currentOent + ".Mng_No),0) Field01, \n";
				sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".A WHEN '1' THEN 1 ELSE 0 END) Field02, \n";
			}
			sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".B WHEN '1' THEN 1 ELSE 0 END) Field03, \n";
			sSQLs+="	SUM(CASE HADO_TB_SOent_Answer_"+currentYear+".C WHEN '1' THEN 1 ELSE 0 END) Field04 \n";
			sSQLs+="	FROM HADO_TB_SOent_Answer_"+currentYear+", " + currentOent + ", HADO_TB_Subcon_"+currentYear+" \n";
			sSQLs+="	WHERE (HADO_TB_Subcon_"+currentYear+".Oent_GB=HADO_TB_SOent_Answer_"+currentYear+".Oent_GB) \n";
			sSQLs+="	AND (HADO_TB_Subcon_"+currentYear+".Child_Mng_No=HADO_TB_SOent_Answer_"+currentYear+".Mng_No) \n";
			sSQLs+="	AND HADO_TB_Subcon_"+currentYear+".Current_Year=HADO_TB_SOent_Answer_"+currentYear+".Current_Year \n";
			sSQLs+="	AND HADO_TB_Subcon_"+currentYear+".Sent_No=HADO_TB_SOent_Answer_"+currentYear+".Sent_No \n";
			sSQLs+="	AND " + currentOent + ".Mng_No=HADO_TB_Subcon_"+currentYear+".Mng_No \n";
			sSQLs+="	AND " + currentOent + ".Current_Year=HADO_TB_Subcon_"+currentYear+".Current_Year \n";
			sSQLs+="	AND " + currentOent + ".Oent_GB=HADO_TB_Subcon_"+currentYear+".Oent_GB \n";
			sSQLs+="	AND HADO_TB_Subcon_"+currentYear+".Sent_Status='1' \n";
			sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".addr_status IS NULL \n";
			/* 2015-09-09 / 강슬기 / 2015년도 조사제외대상 조건 추가 
			if( currentYear>=2015 ) {
				sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".sp_fld_03 IS NULL \n";
			}
			*/
			if( currentYear>=2015 ) {
				sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".sp_fld_03 IS NULL \n";
			}
			if( currentYear >= 2014 ) {
				sSQLs+="	AND LENGTH(HADO_TB_Subcon_"+currentYear+".mng_no)>6 \n";
			} else if( currentYear >= 2012 ) {
				sSQLs+="	AND LENGTH(HADO_TB_Subcon_"+currentYear+".mng_no)>4 \n";
			}
			sSQLs+="	AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB=HADO_TB_SOent_Answer_"+currentYear+".Oent_GB \n";
			sSQLs+="	AND HADO_TB_SOent_Answer_"+currentYear+".Current_Year=HADO_TB_SOent_Answer_"+currentYear+".Current_Year \n";
			
			/* 20140221 : 년도별 통계 세분화 - 정광식 */
			if( session.getAttribute("wgb").equals("1") ) {
				if( currentYear >= 2012 ) {
					sSQLs+="	AND (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=11 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='1') \n";
				} else if( currentYear < 2008 ) {
					sSQLs+="	AND (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=3 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='1') \n";
				} else {
					sSQLs+="	AND (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=14 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='1') \n";
				}
			} else if( session.getAttribute("wgb").equals("2") ) {
				if( currentYear >= 2015 ) {
					sSQLs+="	AND (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=15 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='2') \n";
				} else if( currentYear >= 2012 ) {
					sSQLs+="	AND (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=14 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='2') \n";
				} else if( currentYear < 2008 ) {
					sSQLs+="	AND (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=3 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='2') \n";
				} else {	// 건설 단독으로 통계없음 처리
					sSQLs+="	AND ( (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=999 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='2') \n";
				}
			} else if( session.getAttribute("wgb").equals("3") ) {
				if( currentYear >= 2012 ) {
					sSQLs+="	AND (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=11 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='3') \n";
				} else if( currentYear < 2008 ) {
					sSQLs+="	AND (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=3 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='3') \n";
				} else {
					sSQLs+="	AND (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=14 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='3') \n";
				}
			} else {
				if( currentYear >= 2015 ) {
					sSQLs+="	AND ( (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=11 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='1') \n";
					sSQLs+="	OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=15 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='2') \n";
					sSQLs+="	OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=11 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='3') ) \n";
				} else if( currentYear >= 2012 ) {
					sSQLs+="	AND ( (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=11 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='1') \n";
					sSQLs+="	OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=14 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='2') \n";
					sSQLs+="	OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=11 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='3') ) \n";
				} else if( currentYear < 2008 ) {
					sSQLs+="	AND ( (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=3 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='1') \n";
					sSQLs+="	OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=3 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='2') \n";
					sSQLs+="	OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=3 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='3') ) \n";
				} else {
					sSQLs+="	AND ( (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=14 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='1') \n";
					sSQLs+="	OR (HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_CD=12 AND HADO_TB_SOent_Answer_"+currentYear+".SOent_Q_GB=1 AND HADO_TB_SOent_Answer_"+currentYear+".Oent_GB='3') ) \n";
				}
			}

			if( !session.getAttribute("wgb").equals("") ) {
				sSQLs+="	AND HADO_TB_Subcon_"+currentYear+".Oent_GB='"+session.getAttribute("wgb")+"' \n";
			}
			sSQLs+="	AND HADO_TB_Subcon_"+currentYear+".Current_Year='"+currentYear+"' \n";
			if( !session.getAttribute("wgb").equals("") ) {
				sSQLs+="	GROUP BY " + currentOent + ".Oent_Type \n";
				sSQLs+=") A LEFT JOIN Common_CD B \n";
				sSQLs+="ON B.Addon_GB='"+session.getAttribute("wgb")+"' \n";
				sSQLs+="AND A.Oent_Type=B.Common_CD \n";
				sSQLs+="ORDER BY A.Oent_Type \n";
			} else {
				sSQLs+="GROUP BY HADO_TB_Subcon_"+currentYear+".Oent_GB \n";
				sSQLs+="ORDER BY HADO_TB_Subcon_"+currentYear+".Oent_GB \n";
			}

			//System.out.print(sSQLs);
		
			pstmt=conn.prepareStatement(sSQLs);
			rs=pstmt.executeQuery();
			
			nLoop=1;
			while( rs.next() ) {
				arrData[nLoop][5]=rs.getString("Oent_Type");
				arrData[nLoop][6]=StringUtil.checkNull(rs.getString("Common_NM")).trim();
				arrData[nLoop][1]=rs.getString("Field01");
				arrData[nLoop][2]=rs.getString("Field02");
				arrData[nLoop][3]=rs.getString("Field03");
				arrData[nLoop][4]=rs.getString("Field04");

				for(int i=1; i<=4; i++) {
					arrSum[i] = arrSum[i] + Float.parseFloat(arrData[nLoop][i]);
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
<meta charset="utf-8">
<script type="text/javascript">
//<![CDATA[
content="";
content+="<table class='resultTable'>";
<%
if( currentYear > 2001 ) {%>
content+="	<tr>";
content+="		<th rowspan='2'>구분</th>";
content+="		<th rowspan='2'>응답업체수</th>";
content+="		<th colspan='3'>표준하도급계약서 사용여부</th>";
content+="  </tr>";
content+="	<tr>";
content+="		<th>사용(가)</th>";
content+="		<th>미사용(나)</th>";
content+="		<th>잘모름(다)</th>";
content+="	</tr>";
<%
} else {%>
content+="	<tr>";
content+="		<th rowspan='2'>구분</th>";
content+="		<th rowspan='2'>응답업체수</th>";
content+="		<th colspan='3'>표준하도급계약서 사용여부</th>";
content+="  </tr>";
content+="	<tr>";
content+="		<th>전부사용(가)</th>";
content+="		<th>일부사용(나)</th>";
content+="		<th>미사용(다)</th>";
content+="	</tr>";
<%
}%>

<%if( !tt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan='2'>계</th>";
content+="		<th rowspan='2'><%=formater2.format(arrSum[1])%></th>";
	<%for(int i=2; i<=4; i++) {%>
content+="		<td><%=formater2.format(arrSum[i])%></td>";
	<%}%>
content+="	</tr>";

content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for(int i=2; i<=4; i++) {%>
		<%if( arrSum[1] > 0F ){%>
content+="		<td><%=formater.format(arrSum[i] / arrSum[1] * 100F)%>%</td>";
		<%} else {%>
content+="		<td>0.0%</td>";
		<%}%>
	<%}%>
content+="	</tr>";

	<%for(int ni=1; ni<=nLoop; ni++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
		<%if( !session.getAttribute("wgb").equals("") ) {%>	
content+="		<th rowspan='2'><%=arrData[ni][5]%> (<%=arrData[ni][6]%>)</th>";
		<%} else {%>
			<%if( arrData[ni][5].equals("1") ) {%>		
content+="		<th rowspan='2'>제조</th>";
			<%} else if( arrData[ni][5].equals("2") ) {%>								
content+="		<th rowspan='2'>건설</th>";
			<%} else if( arrData[ni][5].equals("3") ) {%>								
content+="		<th rowspan='2'>용역</th>";
			<%}%>
		<%}%>
content+="		<th rowspan='2'><%=formater2.format(Float.parseFloat(arrData[ni][1]) )%></th>";
		<%for(int i=2; i<=4; i++) {%>
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][i]))%></td>";
		<%}%>
content+="	</tr>";

content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
		<%for(int i=2; i<=4; i++) {%>
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
content+="		<td>&nbsp;</td>";
content+="	</tr>";
<%}%>
content+="</table>";

top.document.getElementById("divResult").innerHTML=content;
top.setNowProcessFalse();
//]]
</script>
<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>