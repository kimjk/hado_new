<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="/Include/WB_I_Global.jsp"%>
<%@ include file="/Include/WB_I_chkSession.jsp"%>

<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. 프로젝트명 : 공정관리위원회 하도급거래 서면직권실태조사 민원인 홈페이지                         */
/*  2. 업체정보 :                                                                                      */
/*     - 업체명 : 공정관리위원회		            												   */
/*     - 담장자명 : 남기태 조사관				          											   */
/*     - 연락처 : T) 02-2023-4491  F) 02-2023-4500													   */
/*  3. 개발업체정보 :																				   */
/*     - 업체명 : (주)이꼬르																		   */
/*	   - Project Manamger : 정광식 부장 (pcxman99@naver.com)										   */
/*     - 연락처 : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  4. 일자 : 2009년 5월																			   */
/*  5. 저작권자 : 공정관리위원회 기업협력국															   */
/*  6. 저작권자의 동의 없이 배포 및 사용을 할수 없습니다.											   */
/*  7. 업데이트일자 : 																				   */
/*  8. 업데이트내용 (내용 / 일자)																	   */
/*  9. 비고																							   */
/*-----------------------------------------------------------------------------------------------------*/
	
	String Item = StringUtil.checkNull(request.getParameter("ITEM"));
	String sCmd = StringUtil.checkNull(request.getParameter("cmd"));
	String sCase = StringUtil.checkNull(request.getParameter("case"));
	String sType = StringUtil.checkNull(request.getParameter("stype"));
	String sPart = StringUtil.checkNull(request.getParameter("part"));
	String sno = StringUtil.checkNull(request.getParameter("sno"));
	String city = StringUtil.checkNull(request.getParameter("CityName" ));
	String city2 = new String(StringUtil.checkNull(request.getParameter("CityName" )).getBytes("EUC-KR"), "ISO8859-1" );

	String sSQLInjection = "f";

	// SQL-Injection 처리
	if (Item != null)
		sSQLInjection = UF_chkSQLInjection(Item);
	if ((sSQLInjection.equals("f")) && (sCmd != null) )
		sSQLInjection = UF_chkSQLInjection(sCmd);
	if ((sSQLInjection.equals("f")) && (sCase != null) )
		sSQLInjection = UF_chkSQLInjection(sCase);
	if ((sSQLInjection.equals("f")) && (sType != null) )
		sSQLInjection = UF_chkSQLInjection(sType);
	if ((sSQLInjection.equals("f")) && (sPart != null) )
		sSQLInjection = UF_chkSQLInjection(sPart);
	if ((sSQLInjection.equals("f")) && (sno != null) )
		sSQLInjection = UF_chkSQLInjection(sno);
	if ((sSQLInjection.equals("f")) && (city != null) )
		sSQLInjection = UF_chkSQLInjection(city);
	if ((sSQLInjection.equals("f")) && (city2 != null) )
		sSQLInjection = UF_chkSQLInjection(city2);
	
	String[] aZipCode = new String[101];
	String[] aCity = new String[101];
	String[] aGu = new String[101];
	String[] aDong = new String[101];
	String[] aDong1 = new String[101];
	String[] aBunji = new String[101];
	
	int i = 0;

	if (Item.equals("S") && sSQLInjection.equals("f")) {
		String sSQLs = "";
		
		
		ConnectionResource resource = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();

			sSQLs = "SELECT * FROM HADO_TB_Zipcode " +
					"WHERE (Zipcode LIKE '%" + city2.replaceAll("'","''") + "%' " +
					"OR Post_City LIKE '%" + city2.replaceAll("'","''") + "%' " +
					"OR Post_Gu LIKE '%" + city2.replaceAll("'","''") + "%' " +
					"OR Post_Dong LIKE '%" + city2.replaceAll("'","''") + "%' " +
					"OR Post_RI LIKE '%" + city2.replaceAll("'","''") + "%') " +
					"AND ROWNUM <= 100";

			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				aZipCode[i] = StringUtil.checkNull( rs.getString("zipcode") );
				aCity[i] = new String( StringUtil.checkNull( rs.getString("Post_City") ).getBytes("ISO8859-1"), "EUC-KR" );
				aGu[i] = new String( StringUtil.checkNull( rs.getString("Post_Gu") ).getBytes("ISO8859-1"), "EUC-KR" );
				aDong[i] = new String( StringUtil.checkNull( rs.getString("Post_Dong") ).getBytes("ISO8859-1"), "EUC-KR" );
				aDong1[i] = new String( StringUtil.checkNull( rs.getString("Post_RI") ).getBytes("ISO8859-1"), "EUC-KR" );
				aBunji[i] = new String( StringUtil.checkNull( rs.getString("Post_bunji") ).getBytes("ISO8859-1"), "EUC-KR" );

				i++;
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
	<title>주소검색</title>
	<%= st_MetaString%>
	<link href="/Include/common.css" rel="stylesheet" type="text/css" />
</head>

<Script Language="JavaScript">
<%if ( sSQLInjection.equals("t") ) {%>
	alert("허용하지 않는 문자가 포함되어 있습니다.");
	self.close();
<%}%>
</Script>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<center>
<script language="javascript">		
	function SelectPost(val1,val2)
	{
	<%if ( sType.equals("papp") ) {%>
			parent.opener.document.info.hdpost<%=sno%>_1.value = val1.substr(0,3);
			parent.opener.document.info.hdpost<%=sno%>_2.value = val1.substr(4,3);
			parent.opener.document.info.hdaddr<%=sno%>.value = val2;
	<%} else if (sType.equals("prod3")) {%>
			parent.opener.document.info.rpost1.value = val1.substr(0,3);
			parent.opener.document.info.rpost2.value = val1.substr(4,3);
			parent.opener.document.info.raddr.value = val2;
	<%} else if (sType.equals("sent") ) {%>
			parent.opener.document.info.rzip1.value = val1.substr(0,3);
			parent.opener.document.info.rzip2.value = val1.substr(4,3);
			parent.opener.document.info.raddress.value = val2;
	<%} else if (sType.equals("constapp")) {%>	
			parent.opener.document.inform.spost1.value = val1.substr(0,3);
			parent.opener.document.inform.spost2.value = val1.substr(4,3);
			parent.opener.document.inform.saddress.value = val2;
	<%} else {%>	
			parent.opener.document.info.spost1.value = val1.substr(0,3);
			parent.opener.document.info.spost2.value = val1.substr(4,3);
			parent.opener.document.info.saddr.value = val2;
	<%}%>
	window.close();
	}
</script>
<table border="0" width="400" cellpadding="0" cellspacing="0" valign="top" align="center">
	<tr>
		<td width="400" valign="top">
   			<table border="0" width="400" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td width="400" height="28" ><img src="/img/post01.jpg" width="400" height="59" border="0"></td>
				</tr>	
				<tr>
					<% if ( Item.equals("F") ) { %>
					<td width="400" height="84" valign="top"><img src="/img/post05.jpg" width="400" height="83" border="0"></td>
				</tr>
				<tr>
					<td width="400" align="center" valign="top">
						<table width="316" cellpadding="0" cellspacing="0" border="0" background="/img/idbg.jpg">
							<tr>
								<td width="316" height="135" valign="top" align="center">
									<table width="316" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td width="316" height="35" colspan="3"><img src="/img/post02.jpg" width="316" height="34" border="0" alt=""></td>
										 </tr>
											<form action="srchzipcode.jsp?ITEM=S&cmd=<%=sCmd%>&part=<%=sPart %>&case=<%=sCase%>&stype=<%=sType%>&sno=<%=sno%>" method="POST" name="InFrom">
												<tr>
													<td width="250" height="45" align="right" valign="middle"><input type="Text" name="CityName" value="<%= city %>" size="20" style="border:1 solid black; border-color:#7C7C7C;height:22;ime-mode:active"></td>
													<td width="11" height="45"></td>
													<td width="55" height="45"  align="left" valign="middle"><a href="JavaScript:document.InFrom.submit();"><img src="/img/post04.jpg" width="34" height="19" border="0" alt=""></a></td>
												</tr>
												<tr>
													<td width="316"colspan="3" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;예) 서울특별시 강남구 청남동 => 청담동<br>
																										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;예) 서울특별시 성북구 돈암2동 => 돈암2동</td>
												</tr>
											
											</form>
									</table>
								</td>
							</tr>
							<tr>
								<td width="316" height="4" align="center" colspan="3"><img src="/img/idbot.jpg" width="316" height="3" border="0" alt=""></td>
							</tr>
						</table>
					</td>
				</tr>
				
				<tr>
					<td width="400" align="center">		
						<% } %>			
						<% if (Item.equals("S")) { %>
						<table width="400" border="0" cellspacing="0" cellpadding="0" align="center">
						<form action="srchzipcode.jsp?ITEM=S&cmd=<%=sCmd%>&part=<%=sPart %>&case=<%=sCase%>&stype=<%=sType%>&sno=<%=sno%>" method="POST" name="InFrom">
							<tr>
								<td width="200" height="50" bgcolor="#79A3FA" align="CENTER" class="tabletext02">&nbsp;&nbsp;검색어<br>(우편번호 / 동 / 면 / 읍)&nbsp;&nbsp;</td>		
								<td width="150" bgcolor="#F4F4F4" align="CENTER">
									<input type="Text" name="CityName" value="<%= city %>" size="20" style="border:1 solid black; border-color:#7C7C7C;height:25;ime-mode:active">
								</td>
								<td width="50" bgcolor="#F4F4F4" align="CENTER"><a href="JavaScript:document.InFrom.submit();"><img src="/img/post04.jpg" width="34" height="19" border="0" alt=""></a></td>
							</tr>
							<tr>
							    <td width="400"  colspan="3" align="center"><br>* 조회 후 검색결과 중 해당 주소를 클릭하시면 자동입력됩니다.</td>
							</tr>
						</form>
						</table>
					</td>
				</tr>
				<tr>
					<td width="400" align="center">
						<table width="400" border="0" cellspacing="1" cellpadding="0" bgcolor="#2C63DD">
						<form>			
							<tr>
								<td width="70" height="25" valign="center" align="CENTER" bgcolor="#4F7CDF" class="tabletext02">
									<b>우편번호</b>
								</td>
								<td width="330" height="25" align="CENTER" bgcolor="#4F7CDF" class="tabletext02">
									<center><b>주  소</b></center>
								</td>
							</tr>
							
							<% for (int z = 1;z < i;z++){ %>
								<tr>
									<td width="70" height="23" align="center" bgcolor="#ffffff">
										<%=aZipCode[z]%>
									</td>
									<td height="23" bgcolor="#ffffff">&nbsp;&nbsp;
										<a href="javascript:SelectPost('<%= aZipCode[z] %>', '<%= aCity[z] %>' + ' ' + '<%= aGu[z] %>' + ' ' + '<%= aDong[z] %>' + ' ' + '<%= aDong1[z] %>')" class="law"><% if (aCity[z].length() > 16) { %>
											<%= aCity[z].substring(0,13) %>...
										<%} else {%>
											<%= aCity[z] %>
										<%}%>
										<% if (aGu[z].length() > 16) { %>
											<%= aGu[z].substring(0,13) %>...
										<%} else {%>
											<%= aGu[z] %>
										<%}%>
										<%if (aDong[z].length() > 20 ) { %>
											<%= aDong[z].substring(0,17) %>...
										<%} else {%>
											<%= aDong[z] %>
										<%}%>
										<%if (aDong1[z].length()>0) { %>
											&nbsp;<%= aDong1[z] %>
										<%}%>
										<%if (aBunji[z].length()>0) { %>
											&nbsp;<%= aBunji[z] %>
										<%}%></a>
									</td>
								</tr>
							<% } %>
							</form>
						</table>
						<% } %>
					</td>
				</tr> 		
			</table>
		</td>
	</tr>
	
	
	 <!--tr>
		<td width="218" height="45" align="center" colspan="4"><a href="#"><img src="/img/id_icon01.gif" width="45" height="26" border="0"></a></td>
	</tr//-->  
</table>
</center>
</body>
</html>
<%@ include file="/Include/WB_I_Function.jsp"%>