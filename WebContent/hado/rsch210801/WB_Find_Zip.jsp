<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_Find_Zip.jsp
* 프로그램설명	: 회사개요 > 우편번호 찾기
* 프로그램버전	: 3.0.1
* 최초작성일자	: 2009년 05월
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
* 2009-05-00		정광식  	     최초작성
* 2016-01-27		민현근		DB변경으로 인한 인코딩 변경
*/
/* 페이지 인코딩 추가 */
request.setCharacterEncoding("utf-8");
response.setContentType("text/html; charset=utf-8;");
%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="../Include/WB_I_Global.jsp"%>
<%@ include file="../Include/WB_I_chkSession.jsp"%>

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

/*---------------------------------------- Variable Difinition ----------------------------------------*/
	ConnectionResource resource		= null;
	Connection conn					= null;
	PreparedStatement pstmt			= null;
	ResultSet rs					= null;

	String Item		= StringUtil.checkNull(request.getParameter("ITEM"));
	String sCmd		= StringUtil.checkNull(request.getParameter("cmd"));
	String sCase	= StringUtil.checkNull(request.getParameter("case"));
	String sType	= StringUtil.checkNull(request.getParameter("stype"));
	String sPart	= StringUtil.checkNull(request.getParameter("part"));
	String sno		= StringUtil.checkNull(request.getParameter("sno"));
	String city		= StringUtil.checkNull(request.getParameter("CityName" ));
	String city2	= StringUtil.checkNull(request.getParameter("CityName" ));
	String area	= StringUtil.checkNull(request.getParameter("Area" ));
	String type	= StringUtil.checkNull(request.getParameter("Type" ));

	if (type.equals("")||type=="") type = "2";
	//type = "2";


	String sSQLInjection = "f";
	String sSQLs		= "";

	/*
	String[] aZipCode	= new String[101];
	String[] aCity		= new String[101];
	String[] aGu		= new String[101];
	String[] aDong		= new String[101];
	String[] aDong1		= new String[101];
	String[] aBunji		= new String[101];
	*/
	String[] aSido		= new String[101];
	String[] aZipCode	= new String[101];
	String[] aSigun		= new String[101];
	String[] aRoadNm	= new String[101];
	String[] aBdMnum	= new String[101];
	String[] aBdSnum	= new String[101];
	String[] aDongNm	= new String[101];
	String[] aJibunMnum	= new String[101];
	String[] aJibunSnum	= new String[101];

	String[] aUbmyun	= new String[101];
	String[] aRi		= new String[101];



	int i = 0;

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

/*=================================== Record Processing ===============================================*/

	if (Item.equals("S") && sSQLInjection.equals("f")) {
		if			(area.equals("01")) sSQLs="SELECT * FROM zip_addr_code_01 \n"; //서울
		else if 	(area.equals("02")) sSQLs="SELECT * FROM zip_addr_code_02 \n"; //부산
		else if 	(area.equals("03")) sSQLs="SELECT * FROM zip_addr_code_03 \n"; //대구
		else if 	(area.equals("04")) sSQLs="SELECT * FROM zip_addr_code_04 \n"; //인천
		else if 	(area.equals("05")) sSQLs="SELECT * FROM zip_addr_code_05 \n"; //광주
		else if 	(area.equals("06")) sSQLs="SELECT * FROM zip_addr_code_06 \n"; //대전
		else if 	(area.equals("07")) sSQLs="SELECT * FROM zip_addr_code_07 \n"; //울산
		else if 	(area.equals("08")) sSQLs="SELECT * FROM zip_addr_code_08 \n"; //세종
		else if 	(area.equals("09")) sSQLs="SELECT * FROM zip_addr_code_09 \n"; //강원도
		else if 	(area.equals("10")) sSQLs="SELECT * FROM zip_addr_code_10 \n"; //
		else if 	(area.equals("11")) sSQLs="SELECT * FROM zip_addr_code_11 \n"; //
		else if 	(area.equals("12")) sSQLs="SELECT * FROM zip_addr_code_12 \n"; //
		else if 	(area.equals("13")) sSQLs="SELECT * FROM zip_addr_code_13 \n"; //제주
		else if 	(area.equals("14")) sSQLs="SELECT * FROM zip_addr_code_14 \n"; //

		String[] sCity = city2.split("\\s+");
		String[] sCity2;

		if (type.equals("1")){ // 도로명 + 건물번호
			if (sCity.length == 1){
				sSQLs+="WHERE (ROAD_NM LIKE '%"+sCity[0].replaceAll("'","''")+"%' \n)";
			}else if (sCity.length >= 2){
				sCity2 = sCity[1].split("-");
				sSQLs+="WHERE (ROAD_NM LIKE '%"+sCity[0].replaceAll("'","''")+"%' \n";
				if (sCity2.length == 1){
					sSQLs+="	AND BD_MNUM LIKE '%"+sCity2[0].replaceAll("'","''")+"%' \n)";
				}else{
					sSQLs+="	AND BD_MNUM LIKE '%"+sCity2[0].replaceAll("'","''")+"%' \n";
					sSQLs+="	AND BD_SNUM LIKE '%"+sCity2[1].replaceAll("'","''")+"%' \n)";
				}
			}
		}else{						//동(읍/면/리)명 + 지번
			if (sCity.length == 1){
				sSQLs+="WHERE (DONG_NM LIKE '%"+sCity[0].replaceAll("'","''")+"%' \n)";
				sSQLs+="or (UBMYUN LIKE '%"+sCity[0].replaceAll("'","''")+"%' \n)";
				sSQLs+="or (RI LIKE '%"+sCity[0].replaceAll("'","''")+"%' \n)";
			}else if (sCity.length >= 2){
				sCity2 = sCity[1].split("-");
				sSQLs+="WHERE (DONG_NM LIKE '%"+sCity[0].replaceAll("'","''")+"%' \n";
				sSQLs+="or (UBMYUN LIKE '%"+sCity[0].replaceAll("'","''")+"%' \n)";
				sSQLs+="or (RI LIKE '%"+sCity[0].replaceAll("'","''")+"%' \n)";
				if (sCity2.length == 1){
					sSQLs+="	AND JIBUN_MNUM LIKE '%"+sCity2[0].replaceAll("'","''")+"%' \n)";
				}else{
					sSQLs+="	AND JIBUN_MNUM LIKE '%"+sCity2[0].replaceAll("'","''")+"%' \n";
					sSQLs+="	AND JIBUN_SNUM LIKE '%"+sCity2[1].replaceAll("'","''")+"%' \n)";
				}
			}
		}

		sSQLs+="AND ROWNUM <= 100 \n";


		/*sSQLs+="WHERE (ZIP_CODE LIKE '%"+city2.replaceAll("'","''")+"%' \n";
		sSQLs+="	OR SIDO LIKE '%"+city2.replaceAll("'","''")+"%' \n";
		sSQLs+="	OR SIGUN LIKE '%"+city2.replaceAll("'","''")+"%' \n";
		sSQLs+="	OR UBMYUN LIKE '%"+city2.replaceAll("'","''")+"%' \n";
		sSQLs+="	OR ROAD_NM LIKE '%"+city2.replaceAll("'","''")+"%' \n";
		sSQLs+="	OR SIGUN_BD_NM LIKE '%"+city2.replaceAll("'","''")+"%') \n";
		sSQLs+="AND ROWNUM <= 100 \n";
		*/
		/*
		sSQLs="SELECT * FROM HADO_TB_Zipcode \n";
		sSQLs+="WHERE (Zipcode LIKE '%"+city2.replaceAll("'","''")+"%' \n";
		sSQLs+="	OR Post_City LIKE '%"+city2.replaceAll("'","''")+"%' \n";
		sSQLs+="	OR Post_Gu LIKE '%"+city2.replaceAll("'","''")+"%' \n";
		sSQLs+="	OR Post_Dong LIKE '%"+city2.replaceAll("'","''")+"%' \n";
		sSQLs+="	OR Post_RI LIKE '%"+city2.replaceAll("'","''")+"%') \n";
		sSQLs+="AND ROWNUM <= 100 \n";
		*/

		try {
			resource	= new ConnectionResource();
			conn		= resource.getConnection();
			pstmt		= conn.prepareStatement(sSQLs);
			rs			= pstmt.executeQuery();

			while (rs.next()) {
				/*
				aZipCode[i]	= StringUtil.checkNull( rs.getString("zipcode") );
				aCity[i]	= StringUtil.checkNull( rs.getString("Post_City") );
				aGu[i]		= StringUtil.checkNull( rs.getString("Post_Gu") );
				aDong[i]	= StringUtil.checkNull( rs.getString("Post_Dong") );
				aDong1[i]	= StringUtil.checkNull( rs.getString("Post_RI") );
				aBunji[i]	= StringUtil.checkNull( rs.getString("Post_bunji") );
				*/
				aZipCode[i]		= StringUtil.checkNull( rs.getString("ZIP_CODE") );
				aSido[i]		= StringUtil.checkNull( rs.getString("SIDO") );
				aSigun[i]		= StringUtil.checkNull( rs.getString("SIGUN") );
				aRoadNm[i]		= StringUtil.checkNull( rs.getString("ROAD_NM") );
				aBdMnum[i]		= StringUtil.checkNull( rs.getString("BD_MNUM") );
				aBdSnum[i]		= StringUtil.checkNull( rs.getString("BD_SNUM") );
				aDongNm[i]		= StringUtil.checkNull( rs.getString("DONG_NM") );
				aJibunMnum[i]	= StringUtil.checkNull( rs.getString("JIBUN_MNUM") );
				aJibunSnum[i]	= StringUtil.checkNull( rs.getString("JIBUN_SNUM") );

				aUbmyun[i]		= StringUtil.checkNull( rs.getString("UBMYUN") );
				aRi[i]			= StringUtil.checkNull( rs.getString("RI") );

				i++;
			}
			rs.close();
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			if ( rs != null )		try{rs.close();}	catch(Exception e){}
			if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
			if ( conn != null )		try{conn.close();}	catch(Exception e){}
			if ( resource != null ) resource.release();
		}
	}
%>
<html>
<head>
	<title>주소검색</title>
	<%= st_MetaString%>
	<link href="../Include/common.css" rel="stylesheet" type="text/css" />
</head>

<Script Language="JavaScript">
<%if ( sSQLInjection.equals("t") ) {%>
	alert("허용하지 않는 문자가 포함되어 있습니다.");
	self.close();
<% } %>
</Script>
<script type="text/javascript" src="../js/jquery.js"></script>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<center>
<script language="javascript">
	function SelectPost(val1,val2) {
	<%if ( sType.equals("papp") ) {%>
		parent.opener.document.info.hdpost<%=sno%>_1.value = val1.substr(0,3);
		parent.opener.document.info.hdpost<%=sno%>_2.value = val1.substr(4,3);
		parent.opener.document.info.hdaddr<%=sno%>.value = val2;
	<%} else if (sType.equals("nomr")) {%>
		//parent.opener.document.info.rpost1.value = val1.substr(0,3);
		//parent.opener.document.info.rpost2.value = val1.substr(4,3);
		//parent.opener.document.info.rpost.value = val1.substr(0,3)+val1.substr(4,3);
		parent.opener.document.info.rpost.value = val1;
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
	function viewEx(val){
		if(val == 1){
			$('.type1').show();
			$('.type2').hide();
		}else{
			$('.type1').hide();
			$('.type2').show();
		}
	}
	$(document).ready(function(){
		$("input:radio[name='Type']:radio[value='<%=type%>']").attr("checked",true);
		viewEx('<%=type%>');
	});
</script>
<table border="0" width="400" cellpadding="0" cellspacing="0" valign="top" align="center">
	<tr>
		<td width="400" valign="top">
   			<table border="0" width="400" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td width="400" height="28" ><img src="../img/post01.jpg" width="400" height="59" border="0"></td>
				</tr>
				<tr>
					<% if ( Item.equals("F") ) { %>
					<!-- <td width="400" height="84" valign="top"><img src="../img/post05.jpg" width="400" height="83" border="0"></td> -->
				</tr>
				<tr>
					<td width="400" align="center" valign="top">
						<table width="316" cellpadding="0" cellspacing="0" border="0" background="../img/idbg.jpg">
							<tr>
								<td width="316" height="135" valign="top" align="center">
									<table width="316" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td width="316" height="35" colspan="3"><img src="../img/post02.jpg" width="316" height="34" border="0" alt=""></td>
										 </tr>
											<form action="WB_Find_Zip.jsp?ITEM=S&cmd=<%=sCmd%>&part=<%=sPart %>&case=<%=sCase%>&stype=<%=sType%>&sno=<%=sno%>" method="POST" name="InFrom">
												<tr>
													<td colspan="3" width="400"  align="LEFT" class="tabletext02">
														<input type="radio" name="Type"  value="1"  onclick="viewEx(this.value)" >도로명+건물번호
														<input type="radio" name="Type"  value="2"  onclick="viewEx(this.value)" >동(읍/면/리)명 + 지번
													</td>
												</tr>
												<tr>
													<td width="330" height="45" align="right" valign="middle">
														<select name="Area" id="area">
															<option value="01" >서울특별시</option>
															<option value="02" >부산광역시</option>
															<option value="03" >대구광역시</option>
															<option value="04" >인천광역시</option>
															<option value="05" >광주광역시</option>
															<option value="06" >대전광역시</option>
															<option value="07" >울산광역시</option>
															<option value="08" >세종특별자치시</option>
															<option value="09" >강원도</option>
															<option value="10" >경기도</option>
															<option value="11" >경상남북도</option>
															<option value="12" >전라남북도</option>
															<option value="13" >제주특별자치도</option>
															<option value="14" >충청남북도</option>
														</select>
														<input type="Text" name="CityName" value="<%= city %>" size="17" style="border:1 solid black; border-color:#7C7C7C;height:22;ime-mode:active">
													</td>
													<td width="11" height="45"></td>
													<td width="30" height="45"  align="left" valign="middle"><a href="JavaScript:document.InFrom.submit();"><img src="../img/post04.jpg" width="34" height="19" border="0" alt=""></a></td>
												</tr>
												<tr>
													<td colspan="3" width="400"  align="LEFT" class="tabletext02">
														<div class="type1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;검색방법 : 서울시 중구 소공로 70  <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;예) '소공로(도로명) 70(건물번호)'</div>
														<div class="type2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;검색방법 : 서울시 중구 충무로1가 21-1  <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;예) '충무로1가(동명) 21-1(지번)'</div>
													</td>
												</tr>
											</form>
									</table>
								</td>
							</tr>
							<tr>
								<td width="316" height="4" align="center" colspan="3"><img src="../img/idbot.jpg" width="316" height="3" border="0" alt=""></td>
							</tr>
						</table>
					</td>
				</tr>

				<tr>
					<td width="400" align="center">
						<% } %>
						<% if (Item.equals("S")) { %>
						<table width="400" border="0" cellspacing="0" cellpadding="0" align="center">
						<form action="WB_Find_Zip.jsp?ITEM=S&cmd=<%=sCmd%>&part=<%=sPart %>&case=<%=sCase%>&stype=<%=sType%>&sno=<%=sno%>" method="POST" name="InFrom">
							<tr>
								<td colspan="3" width="400"  align="LEFT" class="tabletext02">
									<input type="radio" name="Type"   value="1"  onclick="viewEx(this.value)" >도로명+건물번호
									<input type="radio" name="Type"   value="2"  onclick="viewEx(this.value)" >동(읍/면/리)명 + 지번
								</td>
							</tr>
							<tr>
								<td width="350" bgcolor="#F4F4F4" align="CENTER">
									<select name="Area" id="Area">
										<option value="01" <% if (area.equals("01")) {%>selected<%}%> >서울특별시</option>
										<option value="02" <% if (area.equals("02")) {%>selected<%}%> >부산광역시</option>
										<option value="03" <% if (area.equals("03")) {%>selected<%}%> >대구광역시</option>
										<option value="04" <% if (area.equals("04")) {%>selected<%}%> >인천광역시</option>
										<option value="05" <% if (area.equals("05")) {%>selected<%}%> >광주광역시</option>
										<option value="06" <% if (area.equals("06")) {%>selected<%}%> >대전광역시</option>
										<option value="07" <% if (area.equals("07")) {%>selected<%}%> >울산광역시</option>
										<option value="08" <% if (area.equals("08")) {%>selected<%}%> >세종특별자치시</option>
										<option value="09" <% if (area.equals("09")) {%>selected<%}%> >강원도</option>
										<option value="10" <% if (area.equals("10")) {%>selected<%}%> >경기도</option>
										<option value="11" <% if (area.equals("11")) {%>selected<%}%> >경상남북도</option>
										<option value="12" <% if (area.equals("12")) {%>selected<%}%> >전라남북도</option>
										<option value="13" <% if (area.equals("13")) {%>selected<%}%> >제주특별자치도</option>
										<option value="14" <% if (area.equals("14")) {%>selected<%}%> >충청남북도</option>
									</select>
									<input type="Text" name="CityName" value="<%= city %>" size="20" style="border:1 solid black; border-color:#7C7C7C;height:25;ime-mode:active">
								</td>
								<td width="50" bgcolor="#F4F4F4" align="CENTER"><a href="JavaScript:document.InFrom.submit();"><img src="../img/post04.jpg" width="34" height="19" border="0" alt=""></a></td>
							</tr>
							<tr>
								<td colspan="3" width="400"  bgcolor="#79A3FA" align="LEFT" class="tabletext02" align="center">
										<div class="type1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;검색방법 : 서울시 중구 소공로 70  <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;예) '소공로(도로명) 70(건물번호)'</div>
										<div class="type2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;검색방법 : 서울시 중구 충무로1가 21-1  <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;예) '충무로1가(동명) 21-1(지번)'</div>
								</td>
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

							<% for (int z = 0;z < i;z++){ %>
								<tr>
									<td width="70" height="23" align="center" bgcolor="#ffffff">
										<%=aZipCode[z]%>
									</td>
									<td height="23" bgcolor="#ffffff">&nbsp;&nbsp;
										<a href="javascript:SelectPost('<%= aZipCode[z] %>', '<%= aSido[z] %>' + ' ' + '<%= aSigun[z] %>' + ' ' + '<%= aRoadNm[z] %>' + ' ' + '<%= aBdMnum[z] %>'+<%if (!aBdSnum[z].equals("0")) { %>'-'+'<%= aBdSnum[z] %>'<%}else{%>''<%} %>+' (' +'<%= aDongNm[z] %>'+')')" class="law">
										<% if (aSido[z].length() > 16) { %>
											<%= aSido[z].substring(0,13) %>...
										<%} else {%>
											<%= aSido[z] %>
										<%}%>
										<% if (aSigun[z].length() > 16) { %>
											<%= aSigun[z].substring(0,13) %>...
										<%} else {%>
											<%= aSigun[z] %>
										<%}%>
										<%if (aRoadNm[z].length() > 20 ) { %>
											<%= aRoadNm[z].substring(0,17) %>...
										<%} else {%>
											<%= aRoadNm[z] %>
										<%}%>
										<%if (aBdMnum[z].length()+aBdSnum[z].length()>0) { %>
											<%= aBdMnum[z] %><%if (!aBdSnum[z].equals("0")) {%>-<%= aBdSnum[z] %><%} %>
										<%}%>
										<%if (aDongNm[z].length()>0) { %>
											(<%= aDongNm[z] %>)
										<%}%></a>
										<br>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										<% if (aSido[z].length() > 16) { %>
											<%= aSido[z].substring(0,13) %>...
										<%} else {%>
											<%= aSido[z] %>
										<%}%>
										<% if (aSigun[z].length() > 16) { %>
											<%= aSigun[z].substring(0,13) %>...
										<%} else {%>
											<%= aSigun[z] %>
										<%}%>
										<%if (aDongNm[z].length()>0) { %>
											<%= aDongNm[z] %>
										<%}%>
										<%if (aUbmyun[z].length()>0) { %>
											<%= aUbmyun[z] %>
										<%}%>
										<%if (aRi[z].length()>0) { %>
											<%= aRi[z] %>
										<%}%>
										<%if (aJibunMnum[z].length()+aJibunSnum[z].length()>0) { %>
											<%= aJibunMnum[z] %><%if(!aJibunSnum[z].equals("0")) {%>-<%= aJibunSnum[z] %><%} %>
										<%}%>
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
</table>
</center>
</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>