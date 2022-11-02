<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_I_Global.jsp"%>
<%@ include file="../Include/WB_I_chkSession.jsp"%>

<%

/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String sname = "";
	String scaptine = "";
	String zipcode = "";
//	String zipcode1 = "";
//	String zipcode2 = "";
	String saddress = "";
	String stel = "";
	String sfax = "";
	String scogb = "";
	String scono = "";
	String ssano = "";
	String amail = "";
	String amail1 = "";
	String amail2 = "";
	String wname = "";
	String worg = "";
	String wjikwi = "";
	String wtel = "";
	String wfax = "";
	String wdate = "";
	String ostatus = "";
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	// Cookie Request
	String sMngNo = ckMngNo;
	String sOentYYYY = ckCurrentYear;
	String sOentGB = ckOentGB;
	String sOentName = ckOentName;
	String sSentNo = ckSentNo;

	if( ckMngNo.trim().length() > 8 ) {
			sMngNo = ckMngNo.substring(0,11);
	} else if( ckMngNo.trim().length() == 6 ) {
		sMngNo = ckMngNo.substring(0,5);
	} else if ( ckMngNo.trim().length() == 4 ) {
		sMngNo = ckMngNo.substring(0,3);
	}

	java.util.Calendar cal = java.util.Calendar.getInstance();

	if ( sMngNo != null && !sMngNo.equals("") ) {
		ConnectionResource resource = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sSQLs = "";

		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();

			sSQLs="SELECT * FROM HADO_TB_SUBCON_"+sOentYYYY+"\n";
			sSQLs+="WHERE Child_Mng_No='"+ckMngNo+"' \n";
			sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
			sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
			sSQLs+="AND Sent_No="+sSentNo+" \n";


			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				sname 		= StringUtil.checkNull(rs.getString("sent_name"));
				scaptine 	= StringUtil.checkNull(rs.getString("sent_captine"));
				zipcode 	= StringUtil.checkNull(rs.getString("zip_code"));
				//if ( zipcode.length() == 7 ) {
				//	zipcode1 	= zipcode.substring(0, 3);
				//	zipcode2 	= zipcode.substring(4, 7);
				//} else if ( zipcode.length() == 6 ) {
				//	zipcode1 	= zipcode.substring(0, 3);
				//	zipcode2 	= zipcode.substring(3, 6);
				//}
				saddress 	= StringUtil.checkNull(rs.getString("sent_address"));
				stel 		= StringUtil.checkNull(rs.getString("sent_tel"));
				sfax 		= StringUtil.checkNull(rs.getString("sent_fax"));
				scogb 		= StringUtil.checkNull(rs.getString("comp_gb"));
				scono 		= StringUtil.checkNull(rs.getString("sent_co_no"));
				ssano 		= StringUtil.checkNull(rs.getString("sent_sa_no"));
				amail 		= StringUtil.checkNull(rs.getString("assign_mail"));
				if ( (amail != null) && (!amail.equals("")) ) {
					if ( amail.indexOf("@") != -1 ) {
						amail1	= amail.substring(0, amail.indexOf("@"));
						amail2	= amail.substring(amail.indexOf("@") + 1, amail.length());
					}
				}
				wname	= StringUtil.checkNull(rs.getString("writer_name"));
				worg 		= StringUtil.checkNull(rs.getString("writer_org"));
				wjikwi 		= StringUtil.checkNull(rs.getString("writer_jikwi"));
				wtel 		= StringUtil.checkNull(rs.getString("writer_tel"));
				wfax 		= StringUtil.checkNull(rs.getString("writer_fax"));
				wdate		= StringUtil.checkNull(rs.getString("writer_date"));
				ostatus 	= StringUtil.checkNull(rs.getString("sent_status")).trim();

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
			<td><%=sname%></td>
		</tr>
		<tr>
			<th scope="row">대표자명</th>
			<td><%=scaptine%></td>
		</tr>
		<tr>
			<th scope="row">우편번호</th>
			<td><%=zipcode%></td>
		</tr>
		<tr>
			<th scope="row">주소</th>
			<td><%=saddress%></td>
		</tr>
		<tr>
			<th scope="row">전화번호</th>
			<td><%=stel%></td>
		</tr>
		<tr>
			<th scope="row">팩스번호</th>
			<td><%=sfax%></td>
		</tr>
		<tr>
			<th scope="row">법인등록여부</th>
			<td><%if( scogb.equals("0") ) {out.print("개인 사업자");}else if( scogb.equals("1")) {out.print("법인 사업자");}%></td>
		</tr>
		<tr>
			<th scope="row">법인번호</th>
			<td><%=scono%></td>
		</tr>
		<tr>
			<th scope="row">사업자등록번호</th>
			<td><%=ssano%></td>
		</tr>
		<tr>
			<th scope="row">담당자 E-mail</th>
			<td><%=amail%></td>
		</tr>
		<tr>
			<th scope="row">작성자</th>
			<td><%=wname%></td>
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
		<tr>
			<th scope="row">작성일자</th>
			<td><%=wdate%></td>
		</tr>
		<tr>
			<th scope="row">전송여부</th>
			<td><font size="+1" color="#800080"><b><%if (ostatus.equals("1") ) {out.print("전송완료");}
					else {out.print("미전송");}%></b></font>&nbsp;(<%=cal.get(Calendar.YEAR)%>년 <%=cal.get(Calendar.MONTH)+1%>월 <%=cal.get(Calendar.DATE)%>일 현재)</td>
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