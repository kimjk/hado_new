<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<%@ include file="../Include/WB_Inc_chkSession.jsp"%>

<%

/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String sErrorMsg = "";	// 오류메시지
	String sReturnURL = "/index.jsp";	// 이동URL
/*-----------------------------------------------------------------------------------------------------*/

	String otype = "";
	String oname = "";
	String ocaptine = "";
	String zipcode = "";
	String zipcode1 = "";
	String zipcode2 = "";
	String oaddress = "";
	String otel = "";
	String ofax = "";
	String osale01 = "";
	String osale02 = "";
	String ossale = "";
	String oassets = "";
	String ocapa = "";
	String oconamt = "";
	String oempcnt = "";
	String ocogb = "";
	String ocono = "";
	String osano = "";
	String amail = "";
	String amail1 = "";
	String amail2 = "";
	String w = "";
	String worg = "";
	String wjikwi = "";
	String wtel = "";
	String wfax = "";
	String wdate = "";
	String mngno = "";
	String cstatus = "";
	String subcontype = "";
	String subconcnt = "";
	String ostatus = "";
	String compurl = "";
	String submitdate = "";
	
	int nCurrentYear = 0;
	
	java.util.Calendar cal = java.util.Calendar.getInstance();
	
	if( !ckCurrentYear.equals("") ) {
		nCurrentYear = Integer.parseInt(ckCurrentYear);
	}

	//DimpleDateFormat format = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");

	if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
		ConnectionResource resource = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sSQLs = "";

		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();

			sSQLs = "SELECT * FROM HADO_TB_OENT_" + nCurrentYear + " " +
					"WHERE (Mng_No = '" + ckMngNo + "') " +
					"AND (Current_Year = '" + ckCurrentYear + "') " +
					"AND (Oent_GB = '" + ckOentGB + "')";

			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				mngno 		= StringUtil.checkNull(rs.getString("mng_no"));
				otype 		= StringUtil.checkNull(rs.getString("oent_type"));
				oname 		= StringUtil.checkNull(rs.getString("oent_name"));
				ocaptine 	= StringUtil.checkNull(rs.getString("oent_captine"));
				zipcode 	= StringUtil.checkNull(rs.getString("zip_code"));
				//if ( zipcode.length() == 7 ) {
				//	zipcode1 	= zipcode.substring(0, 3);
				//	zipcode2 	= zipcode.substring(4, 7);
				//} else if ( zipcode.length() == 6 ) {
				//	zipcode1 	= zipcode.substring(0, 3);
				//	zipcode2 	= zipcode.substring(3, 6);
				//}
				oaddress 	= StringUtil.checkNull(rs.getString("oent_address"));
				otel 		= StringUtil.checkNull(rs.getString("oent_tel"));
				ofax 		= StringUtil.checkNull(rs.getString("oent_fax"));
				osale01 	= StringUtil.checkNull(rs.getString("oent_sale01"));
				osale02 	= StringUtil.checkNull(rs.getString("oent_sale02"));
				ossale 		= StringUtil.checkNull(rs.getString("oent_ssale"));
				oassets 	= StringUtil.checkNull(rs.getString("oent_assets"));
				//oconamt 	= StringUtil.checkNull(rs.getString("oent_con_amt"));
				ocapa		= StringUtil.checkNull(rs.getString("oent_capa"));
				
				oempcnt 	= StringUtil.checkNull(rs.getString("oent_emp_cnt"));
				ocogb 		= StringUtil.checkNull(rs.getString("oent_co_gb"));
				ocono 		= StringUtil.checkNull(rs.getString("oent_co_no"));
				osano 		= StringUtil.checkNull(rs.getString("oent_sa_no"));
				//compurl		= StringUtil.checkNull(rs.getString("Comp_URL"));
				amail 		= StringUtil.checkNull(rs.getString("assign_mail"));
				if ( (amail != null) && (!amail.equals("")) ) {
					if ( amail.indexOf("@") != -1 ) {
						amail1	= amail.substring(0, amail.indexOf("@"));
						amail2	= amail.substring(amail.indexOf("@") + 1, amail.length());
					}
				}
				w 			= StringUtil.checkNull(rs.getString("writer_name"));
				worg 		= StringUtil.checkNull(rs.getString("writer_org"));
				wjikwi 		= StringUtil.checkNull(rs.getString("writer_jikwi"));
				wtel 		= StringUtil.checkNull(rs.getString("writer_tel"));
				wfax 		= StringUtil.checkNull(rs.getString("writer_fax"));
				wdate		= StringUtil.checkNull(rs.getString("write_date"));

				cstatus 	= StringUtil.checkNull(rs.getString("comp_status"));
				subcontype 	= StringUtil.checkNull(rs.getString("subcon_type"));
				subconcnt 	= StringUtil.checkNull(rs.getString("subcon_cnt"));
				ostatus 	= StringUtil.checkNull(rs.getString("oent_status")).trim();
				submitdate  = StringUtil.checkNull(rs.getString("submit_date"));
				
			}
			rs.close();

		} catch(Exception e){
			e.printStackTrace();
		} finally {
			if ( rs != null ) try{rs.close();}catch(Exception e){}
			if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
			if ( conn != null ) try{conn.close();}catch(Exception e){}
			if ( resource != null ) resource.release();
		}
	}
%>
<html>
<head>
	<title>조사표 전송 확인</title>
	<link rel="stylesheet" href="style.css" type="text/css">
	<style type="text/css">
		h1 {margin:10px; padding-left:15px; background-color:#D0D7E5; color:#666; font:bold 18px/2 굴림, Dotum;}
		th { padding:5px; background-color:#D2E9FF; font:bold 12px/1.4 굴림, Dotum; color:#3D3E02;}
		td { padding:5px; padding-left:20px; background-color:#FFFFFF; font:12px/1.4 굴림, Dotum;}

	</style>
</head>

<body>
<h1 style="margin:10px; padding-left:15px; background-color:#D0D7E5; color:#666;">조사표 전송 확인</h1>

<table width="96%" cellspacing="1" cellpadding="2" bgcolor="#C0C0C0" style="margin:10px;">
	<colgroup>
		<col style="width:30%;" />
		<col style="width:70%;" />
	</colgroup>
	<tbody>
		<tr>
			<th scope="row">회사명</th>
			<td><%=oname%></td>
		</tr>
		<tr>
			<th scope="row">원사업자 대표자명</th>
			<td><%=ocaptine%></td>
		</tr>
		<tr>
			<th scope="row">우편번호</th>
			<td><%=zipcode%></td>
		</tr>
		<tr>
			<th scope="row">원사업자 주소</th>
			<td><%=oaddress%></td>
		</tr>
		<tr>
			<th scope="row">원사업자 전화번호</th>
			<td><%=otel%></td>
		</tr>
		<tr>
			<th scope="row">원사업자 팩스번호</th>
			<td><%=ofax%></td>
		</tr>
		<tr>
			<th scope="row">법인등록여부</th>
			<td><%if( ocogb.equals("0") ) {out.print("개인 사업자");}else if( ocogb.equals("1")) {out.print("법인 사업자");}%></td>
		</tr>
		<tr>
			<th scope="row">법인번호</th>
			<td><%=ocono%></td>
		</tr>
		<tr>
			<th scope="row">사업자등록번호</th>
			<td><%=osano%></td>
		</tr>
		<tr>
			<th scope="row">담당자 E-mail</th>
			<td><%=amail%></td>
		</tr>
		<tr>
			<th scope="row">작성자</th>
			<td><%=w%></td>
		</tr>
		<tr>
			<th scope="row">작성자직위</th>
			<td><%=wjikwi%></td>
		</tr>
		<tr>
			<th scope="row">작성자전화</th>
			<td><%=wtel%></td>
		</tr>
		<tr>
			<th scope="row">작성자팩스</th>
			<td><%=wfax%></td>
		</tr>
		<!--
		<tr>
			<th scope="row">작성일자</th>
			<td><%=wdate%></td>
		</tr>
		-->
		<tr>
			<th scope="row">전송여부</th>
			<td><font size="+1" color="#800080"><b><%if (ostatus.equals("1") ) {out.print("전송완료");}
					else {out.print("미전송");}%></b></font>&nbsp;(<%=cal.get(Calendar.YEAR)%>년 <%=cal.get(Calendar.MONTH)+1%>월 <%=cal.get(Calendar.DATE)%>일 현재)</td>
		</tr>
		<tr>
			<th scope="row">전송일자</th>
			<td><%=submitdate%></td>
		</tr>
	</tbody>
</table>

	
<p>
<div class="fr" style="margin:10px;">
	<ul class="lt">			
		<li class="fl pr_2"><a href="javascript:print();" onfocus="this.blur()" class="contentbutton2" style="padding-right:3px; float:left;">화면 인쇄하기</a></li>
		<li class="fl pr_2"><a href="javascript:self.close();" onfocus="this.blur()" class="contentbutton2"  style="padding-right:3px; float:left;">확인</a></li>
	</ul>
</div></p>

</body>
</html>

