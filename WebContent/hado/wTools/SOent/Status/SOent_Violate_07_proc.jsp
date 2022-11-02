<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String comm = request.getParameter("comm")==null? "":request.getParameter("comm").trim();

	ConnectionResource resource=null;
	String sSQLs="";
	String[][] arrData=new String[31][14];
	String tmpStr="";
	int nLoop=1;
	java.util.Calendar cal=java.util.Calendar.getInstance();
	DecimalFormat formater=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
/*=================================== Record Selection Processing =====================================*/

	if( tt.equals("start") ) {
	if( comm.equals("search") ) {
	}
	if( !tmpYear.equals("") ) {
	int currentYear=st_Current_Year_n;
	int endCurrentYear=st_Current_Year_n;
	// view table name
	// 합계배열 초기화
	try {
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
			} else if (currentYear==2013) {
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
			} else {

			if( !session.getAttribute("wgb").equals("") ) {
			sSQLs+="WHERE a.Current_Year='"+currentYear+"' AND a.Sent_Status='1' AND a.comp_status='1' \n";
			/* 2015-09-09 / 강슬기 / 2015년도 조사제외대상 조건 추가 
			if( currentYear>=2015 ) {
				sSQLs+="		AND a.sp_fld_03 IS NULL \n";
			}
			*/
			if( currentYear>=2015 ) {
				sSQLs+="		AND a.sp_fld_03 IS NULL \n";
			}

			if( !session.getAttribute("wgb").equals("") ) {
			//System.out.print(sSQLs);
			nLoop=1;
				for(int i=1; i<=10; i++) {
				nLoop++;
content+="	<tr>";
<%if( !tt.equals("start") ) {%>
	<%for(int ni=1; ni<=nLoop; ni++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%}%>
top.document.getElementById("divResult").innerHTML=content;