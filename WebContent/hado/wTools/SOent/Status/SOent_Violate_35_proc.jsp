<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String tt = request.getParameter("tt")==null? "":request.getParameter("tt").trim();
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();

	ConnectionResource resource = null;
	String sSQLs = "";
	ArrayList otype = new ArrayList();
	String[] resp_cnt = new String[50];
	int nLoop = 1;
	java.util.Calendar cal = java.util.Calendar.getInstance();
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	if( !tmpYear.equals("") ) {
	if( tt.equals("start") ) {
		session.setAttribute("cstatus", request.getParameter("cstatus")==null? "":request.getParameter("cstatus").trim());
	int currentYear = st_Current_Year_n;
	/* 2012년 원사업자 관련 DB Table 분리 예외처리 시작 ============================================================> */
	if( currentYear>2011 ) {
	String wgb=session.getAttribute("wgb").toString();
	// 배열초기화
	for(int x=1; x<=29; x++) {
	for(int x=1; x<=49; x++) {
	/* 업종코드별 업종명 세팅 시작 =====================================================================================> */
				sSQLs+="	AND Common_CD <>'G45' AND Common_CD <>'G46' AND Common_CD <>'G47' AND Common_CD <>'M70' \n";
		} 
	} else if( currentYear >= 2009 && wgb.equals("1") ) {
	if( !session.getAttribute("wgb").equals("") ) {
	sSQLs+="ORDER BY Common_CD \n";
	try {
		otype_cnt=1;
		while( rs.next() ) {
		rs.close();
		otype_cnt--;
	} catch(Exception e) {
	/* 검색 조건 세팅 ==================================================================================================> */
			sSQLswhere+="	AND LENGTH(HADO_TB_Subcon_"+currentYear+".Mng_No) > 6 \n";
		} else {
			sSQLswhere+="	AND LENGTH(HADO_TB_Subcon_"+currentYear+".Mng_No) > 4 \n";
		sSQLswhere+="	AND SUBSTR(HADO_TB_Subcon_"+currentYear+".Mng_No,-7)<>'1234567' \n";
	/* 업종별 제출업체 수 세팅 =========================================================================================> */
	/* 주의사항 : 제출업체 수 차이가 발생될경우 전송인데 반송 처리된건이 있는 것이니 정보 수정 후 확인 요함 */
		if( currentYear == 2015 ) {
				sSQLs+="	AND Common_CD <>'G45' AND Common_CD <>'G46' AND Common_CD <>'G47' AND Common_CD <>'M70' \n";
		} 
	} else if( currentYear >= 2009 && wgb.equals("1") ) {
	/* 2015-09-15 / 강슬기 / 2015년도 조사제외대상 조건 추가 
	if( currentYear>=2015 ) {
		sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".sp_fld_03 IS NULL \n";
	}
	*/
	if( currentYear>=2015 ) {
		sSQLs+="		AND HADO_TB_Subcon_"+currentYear+".sp_fld_03 IS NULL \n";
	}
	sSQLs+=sSQLswhere;
//System.out.print(sSQLs);
		pstmt=conn.prepareStatement(sSQLs);
		while( rs.next() ) {
		rs.close();
	} catch(Exception e) {
	/* <========================================================================================= 업종별 제출업체 수 세팅 */
	/* 코드 미사용 =====================================================================================================>
//System.out.print(sSQLs);
		pstmt=conn.prepareStatement(sSQLs);
		while( rs.next() ) {
	if( !tt.equals("start") ) {
		   if( currentYear == 2015 ) {
				sSQLs+="	AND Common_CD <>'G45' AND Common_CD <>'G46' AND Common_CD <>'G47' AND Common_CD <>'M70' \n";
			} 
		} else if( currentYear >= 2009 && wgb.equals("1") ) {
		if( currentYear<2006) {
		sSQLs+="		CASE WHEN COUNT(C.Mng_No)>=1 THEN 1 ELSE 0 END c_cnt \n";
		/* 2015-09-15 / 강슬기 / 2015년도 조사제외대상 조건 추가 
		if( currentYear>=2015 ) {
			sSQLs+="		AND D.sp_fld_03 IS NULL \n";
		}
		*/
		if( currentYear>=2015 ) {
			sSQLs+="		AND D.sp_fld_03 IS NULL \n";
		}
		if( currentYear<2006) {
		sSQLs+="	) vi_temp GROUP BY oent_type \n";
System.out.print(sSQLs);
			pstmt=conn.prepareStatement(sSQLs);
			nLoop=1;
			while( rs.next() ) {
			rs.close();
		} catch(Exception e) {
		/* 2012년 수급사업자 관련 DB Table 분리 예외처리 시작 ==========================================================> */
		if( currentYear>1999 ) {
		cnt_col[1]="cnt_one";
		sSQLs="SELECT "+currentOent+".oent_type, HADO_TB_Subcon_"+currentYear+".Mng_No, HADO_TB_Subcon_"+currentYear+".sent_no, HADO_TB_Subcon_"+currentYear+".oent_gb, ";
		if( !session.getAttribute("cstatus").equals("") ) {
		sSQLs=sSQLs+sSQLswhere+group_sql+order_sql;
//System.out.print(sSQLs);
			i=0;
			while( rs.next() ) {
			typ_vio_cnt[i]=""+typ_vio;
<script type="text/javascript">
<%if( !tt.equals("start") ) {%>
top.document.getElementById("divResult").innerHTML = content;