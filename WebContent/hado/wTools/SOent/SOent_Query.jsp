<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
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
	String sCmd = StringUtil.checkNull(request.getParameter("sql")).trim();
	String sLoc = StringUtil.checkNull(request.getParameter("loc")).trim();
	String sMsg = StringUtil.checkNull(request.getParameter("msg")).trim();
	String sMngNo = StringUtil.checkNull(request.getParameter("no")).trim();
	String sCYear = StringUtil.checkNull(request.getParameter("yyyy")).trim();
	String sOentGB = StringUtil.checkNull(request.getParameter("gb")).trim();
	String sSentNo = StringUtil.checkNull(request.getParameter("sno")).trim();
	String sQ_CD = StringUtil.checkNull(request.getParameter("mqcd")).trim();
	String sQ_GB = StringUtil.checkNull(request.getParameter("mqgb")).trim();
	String sProc = StringUtil.checkNull(request.getParameter("proc")).trim();

	int CYear = Integer.parseInt(sCYear);
	int updateCNT = 0;
	
	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	ConnectionResource2 resource2 = null;
	Connection conn2 = null;

	String currentSecurity = "";

	String sSQLs = "";
	String sReturnURL = "/hado/hado/index3.jsp";
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	if( sCmd != null && sCmd.equals("edit") ) {
		if(sMngNo != null && sCYear != null && sOentGB != null && sSentNo != null && (!sMngNo.equals("")) && (!sCYear.equals("")) && (!sOentGB.equals("")) && (!sSentNo.equals("")) ) {
			
			sSQLs ="UPDATE HADO_TB_Subcon_"+sCYear+" SET \n";	
			sSQLs+="	Sent_Name='"+StringUtil.checkNull(request.getParameter("rcomp")).trim().replaceAll("'","''") +"' \n";
			sSQLs+="	,Sent_Captine='"+StringUtil.checkNull(request.getParameter("scaptine")).trim().replaceAll("'","''") +"'";
			sSQLs+="	,Comp_GB='"+StringUtil.checkNull(request.getParameter("scogb")).trim().replaceAll("'","''")+"' \n";
			sSQLs+="	,Sent_Co_No='"+StringUtil.checkNull(request.getParameter("scono")).trim().replaceAll("'","''")+"' \n";
			sSQLs+="	,Sent_Sa_No='"+StringUtil.checkNull(request.getParameter("ssano")).trim().replaceAll("'","''")+"' \n";
				
			//if( (!StringUtil.checkNull(request.getParameter("rpost1")).trim().equals("")) && (!StringUtil.checkNull(request.getParameter("rpost2")).trim().equals("")) ) {
			if( (!StringUtil.checkNull(request.getParameter("rpost")).trim().equals(""))) {
				//sSQLs+="	,Zip_Code='"+StringUtil.checkNull(request.getParameter("rpost1")).trim().replaceAll("'","''")+"-"+StringUtil.checkNull(request.getParameter("rpost2")).trim().replaceAll("'","''")+"' \n";
				sSQLs+="	,Zip_Code='"+StringUtil.checkNull(request.getParameter("rpost")).trim().replaceAll("'","''")+"' \n";
			} else {
				sSQLs+="	,Zip_Code=NULL \n";
			}
			sSQLs+="	,Sent_Address='"+StringUtil.checkNull(request.getParameter("raddr")).trim().replaceAll("'","''")+"' \n";
			sSQLs+="	,Writer_ORG='"+StringUtil.checkNull(request.getParameter("worg")).trim().replaceAll("'","''")+"' \n";
			sSQLs+="	,Writer_Jikwi='"+StringUtil.checkNull(request.getParameter("wjikwi")).trim().replaceAll("'","''")+"' \n";
			sSQLs+="	,Writer_Name='"+StringUtil.checkNull(request.getParameter("wname")).trim().replaceAll("'","''")+"' \n";
			sSQLs+="	,Writer_Tel='"+StringUtil.checkNull(request.getParameter("wtel")).trim().replaceAll("'","''")+"' \n";
			sSQLs+="	,Writer_Fax='"+StringUtil.checkNull(request.getParameter("wfax")).trim().replaceAll("'","''")+"' \n";

			if( (!StringUtil.checkNull(request.getParameter("semail")).trim().equals("")) ) {
				sSQLs+="	,Assign_Mail='"+StringUtil.checkNull(request.getParameter("semail")).trim().replaceAll("'","''")+"' \n";
			} else {
				sSQLs+="	,Assign_Mail=NULL \n";
			}
			if( !StringUtil.checkNull(request.getParameter("ssale")).trim().equals("") ) {
				sSQLs+="	,Sent_Sale="+StringUtil.checkNull(request.getParameter("ssale")).trim().replaceAll("'","''").replaceAll(",","")+" \n";
			} else {
				sSQLs+="	,Sent_Sale=0 \n";
			}
			if( !StringUtil.checkNull(request.getParameter("samt")).trim().equals("") ) {
				sSQLs+="	,Sent_AMT="+StringUtil.checkNull(request.getParameter("samt")).trim().replaceAll("'","''").replaceAll(",","")+" \n";
			} else {
				sSQLs+="	,Sent_AMT=0 \n";
			}
			if( !StringUtil.checkNull(request.getParameter("sempcnt")).trim().equals("") ) {
				sSQLs+="	,Sent_EMP_CNT="+StringUtil.checkNull(request.getParameter("sempcnt")).trim().replaceAll("'","''").replaceAll(",","")+" \n";
			} else {
				sSQLs+="	,Sent_EMP_CNT=0 \n";
			}
			if( !StringUtil.checkNull(request.getParameter("returngb")).trim().equals("") ) {
				sSQLs+="	,Return_GB='"+StringUtil.checkNull(request.getParameter("returngb")).trim()+"' \n";
			} else {
				sSQLs+="	,Return_GB=NULL \n";
			}
			if( !StringUtil.checkNull(request.getParameter("astatus")).trim().equals("") ) {
				sSQLs+="	,Addr_Status='"+StringUtil.checkNull(request.getParameter("astatus")).trim()+"' \n";
			} else {
				sSQLs+="	,Addr_Status=NULL \n";
			}
			if( !StringUtil.checkNull(request.getParameter("sstatus")).trim().equals("") ) {
				sSQLs+="	,Sent_Status='"+StringUtil.checkNull(request.getParameter("sstatus")).trim()+"' \n";
			} else {
				sSQLs+="	,Sent_Status=NULL \n";
			}

			if( Integer.parseInt(sCYear) > 2020) {
				sSQLs+="WHERE child_Mng_No='"+sMngNo+"' \n";
			} else if( Integer.parseInt(sCYear) >= 2012 && Integer.parseInt(sCYear) <= 2020) {
				sSQLs+="WHERE Mng_No='"+sMngNo.substring(0,8)+"' \n";
			} else if( Integer.parseInt(sCYear) > 2010 ) {
				sSQLs+="WHERE Mng_No='"+sMngNo.substring(0,9)+"' \n";
			} else {
				sSQLs+="WHERE Mng_No='"+sMngNo.substring(0,10)+"' \n";
			}
			sSQLs+="	AND Current_Year='"+sCYear+"' \n";
			sSQLs+="	AND Oent_GB='"+sOentGB+"' \n";
			sSQLs+="	AND Sent_No="+ sSentNo+" \n";

			try {
				resource2 = new ConnectionResource2();
				conn2 = resource2.getConnection();

System.out.print("업체정보수정 sSQLs ================>>>" + sSQLs);

				pstmt = conn2.prepareStatement(sSQLs);
				updateCNT = pstmt.executeUpdate();
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				if ( rs != null )		try{rs.close();}	catch(Exception e){}
				if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
				if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
				if ( resource2 != null ) resource2.release();
			}



			if(Integer.parseInt(sCYear) >= 2012) 
				currentSecurity = "HADO_TB_Security_"+sCYear;
			else 
				currentSecurity = "HADO_TB_Security";

			sSQLs ="UPDATE "+currentSecurity+" \n";
			sSQLs+="SET Dont_Login=? \n";
			sSQLs+="WHERE Mng_No=? \n";
			sSQLs+="	AND Current_Year=? \n";
			sSQLs+="	AND Oent_GB=? \n";
			sSQLs+="	AND Sent_No=? \n";

			try {
				resource2 = new ConnectionResource2();
				conn2 = resource2.getConnection();			
				pstmt = conn2.prepareStatement(sSQLs);
				pstmt.setString(1,StringUtil.checkNull(request.getParameter("dontlogin")).trim());
				pstmt.setString(2,sMngNo);
				pstmt.setString(3,sCYear);
				pstmt.setString(4,sOentGB);
				pstmt.setString(5,sSentNo);
				updateCNT = pstmt.executeUpdate();

			}
 catch(Exception e) {
				e.printStackTrace();
			}
 finally {
				if ( rs != null )		try{rs.close();}	catch(Exception e){}
				if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
				if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
				if ( resource2 != null ) resource2.release();
			}
		}
	}

	if( sCmd != null && sCmd.equals("answerinit") ) {
		if(sMngNo != null && sCYear != null && sOentGB != null && sSentNo != null && (!sMngNo.equals("")) && (!sCYear.equals("")) && (!sOentGB.equals("")) && (!sSentNo.equals("")) ) {

			sSQLs ="DELETE FROM HADO_TB_SOent_Answer_"+sCYear+" \n";
			sSQLs+="WHERE Mng_No=? \n";
			sSQLs+="	AND Current_Year=? \n";
			sSQLs+="	AND Oent_GB=? \n";
			sSQLs+="	AND Sent_No=? \n";
			
			System.out.println("**************응답내역 초기화************");
			System.out.println(sSQLs);
			System.out.println("**************응답내역 초기화************");

			try {
				resource2	= new ConnectionResource2();
				conn2		= resource2.getConnection();

				pstmt		= conn2.prepareStatement(sSQLs);
				pstmt.setString(1,sMngNo);
				pstmt.setString(2,sCYear);
				pstmt.setString(3,sOentGB);
				pstmt.setString(4,sSentNo);
				updateCNT	= pstmt.executeUpdate();
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				if ( rs != null )		try{rs.close();}	catch(Exception e){}
				if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
				if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
				if ( resource2 != null ) resource2.release();
			}

/*=====================================================================================================*/			
			
			if (Integer.parseInt(sCYear) >= 2012) {				
				sSQLs="UPDATE HADO_TB_Subcon_"+sCYear+" SET Sent_Status=NULL \n";
				//sSQLs+="WHERE MngNo='"+sMngNo.substring(0,8)+"' AND Current_Year='"+sCYear+"' \n";
				sSQLs+="WHERE Child_Mng_No='"+sMngNo+"' AND Current_Year='"+sCYear+"' \n";
				sSQLs+="AND Oent_GB='"+sOentGB+"' AND Sent_No="+sSentNo+" \n";
			} else if (sCmd.equals("2011")) {
				sSQLs="UPDATE HADO_TB_Subconn_"+sCYear+" SET Sent_Status=NULL \n";
				sSQLs+="WHERE Mng_No='"+sMngNo.substring(0,9)+"' AND Current_Year='"+sCYear+"' \n";
				sSQLs+="AND Oent_GB='"+sOentGB+"' AND Sent_No="+sSentNo+" \n";
			} else {
				sSQLs="UPDATE HADO_TB_Subcon SET Sent_Status=NULL \n";
				sSQLs+="WHERE Mng_No='"+sMngNo.substring(0,10)+"' AND Current_Year='"+sCYear+"' \n";
				sSQLs+="AND Oent_GB='"+sOentGB+"' AND Sent_No="+sSentNo+" \n";
			}

			try {
				resource2	= new ConnectionResource2();
				conn2		= resource2.getConnection();
				pstmt		= conn2.prepareStatement(sSQLs);
				updateCNT	= pstmt.executeUpdate();
				//System.out.println(sSQLs);
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				if ( rs != null )		try{rs.close();}	catch(Exception e){}
				if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
				if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
				if ( resource2 != null ) resource2.release();
			}
		}

		sReturnURL = "view_sent.jsp?no="+sMngNo+"&yyyy="+sCYear+"&gb="+sOentGB+"&sno="+sSentNo+"&msg=delok";
	}
	
	if( sCmd != null && sCmd.equals("dontlogin") ) {
		if(sMngNo != null && sCYear != null && sOentGB != null && sProc != null && sSentNo != null && (!sMngNo.equals("")) && (!sCYear.equals("")) && (!sOentGB.equals("")) && (!sSentNo.equals("")) ) {
				
			currentSecurity = Integer.parseInt(sCYear) >= 2012 ? "HADO_TB_Security_"+sCYear : "HADO_TB_Security";
			
			sSQLs ="UPDATE "+currentSecurity+" \n";
			if( sProc.equals("Y") ) {		
				sSQLs+="SET Dont_Login = 'Y' \n"; 
			} else if( sProc.equals("N") ) {
				sSQLs+="SET Dont_Login = 'N' \n";
			}
			sSQLs+="WHERE Mng_No=? \n";
			sSQLs+="	AND Current_Year=? \n";
			sSQLs+="	AND Oent_GB=? \n";
			sSQLs+="	AND Sent_No=? \n";
			
			//System.out.print("sCYear :"+sCYear+" currentSecurity :"+currentSecurity+" <br/>sSQLs :"+sSQLs);
			//System.out.print("sMngNo :"+sMngNo+", sCYear :"+sCYear+", sOentGB :"+sOentGB+", sSentNo :"+sSentNo);
			try {
				resource2	= new ConnectionResource2();
				conn2		= resource2.getConnection();			
				pstmt		= conn2.prepareStatement(sSQLs);
				pstmt.setString(1,sMngNo);
				pstmt.setString(2,sCYear);
				pstmt.setString(3,sOentGB);
				pstmt.setString(4,sSentNo);				
				System.out.print(pstmt.toString());
				updateCNT	= pstmt.executeUpdate();

			} catch(Exception e) {
				e.printStackTrace();
			} finally {
				if ( rs != null )		try{rs.close();}	catch(Exception e){}
				if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
				if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
				if ( resource2 != null ) resource2.release();
			}
		}
	}
/*=====================================================================================================*/
%>
<html>
<head>
	<title></title>
</head>

<body>

<script language="javascript">
	<%if( sCmd != null && sCmd.equals("dontlogin") ) {%>
	alert("수급사업자의 접속속성이 변경되었습니다.");
	top.setNowProcessFalse();
	top.view('<%=sMngNo%>','<%=sCYear%>','<%=sOentGB%>','<%=sSentNo%>');
	<%}%>

	<%if( sCmd != null && sCmd.equals("edit") ) {%>
	alert("수급사업자의 정보를 수정 하였습니다.");
	top.setNowProcessFalse();
	top.view('<%=sMngNo%>','<%=sCYear%>','<%=sOentGB%>','<%=sSentNo%>');
	<%}%>
	
	<%if( sCmd != null && sCmd.equals("answerinit") ) {%>
	alert("수급사업자 응답내역 초기화를 완료 하였습니다");
	top.setNowProcessFalse();
	<%}%>
</script>

</body>
</html>