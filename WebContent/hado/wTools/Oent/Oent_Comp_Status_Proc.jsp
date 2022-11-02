<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: Oent_Comp_Status_Proc.jsp
* 프로그램설명	: 원사업자 증빙자료 조회/처리 페이지
* 프로그램버전	: 1.0.2
* 최초작성일자	: 2014년 09월 25일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-25	강슬기		최초작성
* 	2014-10-02	정광식		최적화를 위한 분리 테이블 코드 적용
*	2015-12-30	정광식		DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="/hado/Include/WB_I_Global.jsp"%>
<%@ include file="/hado/Include/WB_I_chkSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/**
* 입력정보 저장 변수 선언 및 초기화 시작
*/
ConnectionResource resource = null;
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String sSQLs		= "";

String sMngNo = request.getParameter("mno") == null ? "":request.getParameter("mno").trim();
String sCurrentYear = request.getParameter("cyear") == null ? "":request.getParameter("cyear").trim();
String sOentGB = request.getParameter("ogb") == null ? "":request.getParameter("ogb").trim();

String sOentName = "";	//회사명
String sOentCaptine	= "";	//대표자명
String sWriterOrg = "";	//부서명
String sWriterName = "";	//작성자명
String sWriterTel = "";	//전화번호
String sWriterEmail = "";	//이메일
String sCenterName	= "";	//사무소명
String sDeptName = "";	//과명
String sUserName = "";	//담당자명
String sPhoneNo = "";	//담당자전화번호
String sProcSN = "";	//처리순번

//첨부문서 배열 선언
ArrayList arrMngNo = new ArrayList();		//관리번호
ArrayList arrCYear = new ArrayList();			//조사년도
ArrayList arrOentGB = new ArrayList();		//업종구분
ArrayList arrFileSn = new ArrayList();			//파일순번
ArrayList arrFileNm = new ArrayList();		//문서명
ArrayList arrDocuNm = new ArrayList();	//파일명
ArrayList arrUpDt = new ArrayList();			//업로드일자
ArrayList arrProcSn = new ArrayList();		//처리순번
ArrayList arrCenterName = new ArrayList();	//사무소명
ArrayList arrDeptName = new ArrayList();	//과명
ArrayList arrUserName = new ArrayList();		//담당자명
ArrayList arrProcCD = new ArrayList();			//처리구분
ArrayList arrWriteDate = new ArrayList();		//처리일자
ArrayList arrConst = new ArrayList();				//비고

DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/**
* 입력정보 저장 변수 선언 및 초기화 끝
*/
if(sMngNo != null && sCurrentYear != null && sOentGB != null && (!sMngNo.equals("")) && (!sCurrentYear.equals("")) && (!sOentGB.equals("")) ) {
	//작성자 정보 가져오기
	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();

		sSQLs  = "SELECT oent_name,oent_captine,writer_org,writer_name,writer_tel,assign_mail \n";
		sSQLs+= "FROM hado_tb_oent_" +sCurrentYear+ " \n";
		sSQLs+= "WHERE mng_no = ? AND current_year = ? AND oent_gb = ? \n";
		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, sMngNo);
		pstmt.setString(2, sCurrentYear);
		pstmt.setString(3, sOentGB);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			/* 2015-12-30	정광식		DB변경으로 인한 인코딩 변경
			sOentName= rs.getString("oent_name")== null ? "":new String(rs.getString("oent_name").getBytes("ISO8859-1"), "EUC-KR");
			sOentCaptine	= rs.getString("oent_captine")== null ? "":new String(rs.getString("oent_captine").getBytes("ISO8859-1"), "EUC-KR");
			sWriterOrg	= rs.getString("writer_org")== null ? "":new String(rs.getString("writer_org").getBytes("ISO8859-1"), "EUC-KR");
			sWriterName	= rs.getString("writer_name")== null ? "":new String(rs.getString("writer_name").getBytes("ISO8859-1"), "EUC-KR");
			sWriterTel	= rs.getString("writer_tel")== null ? "":new String(rs.getString("writer_tel").getBytes("ISO8859-1"), "EUC-KR");
			sWriterEmail	= rs.getString("assign_mail")== null ? "":new String(rs.getString("assign_mail").getBytes("ISO8859-1"), "EUC-KR");
			*/
			sOentName= rs.getString("oent_name")== null ? "":rs.getString("oent_name").trim();
			sOentCaptine	= rs.getString("oent_captine")== null ? "":rs.getString("oent_captine").trim();
			sWriterOrg	= rs.getString("writer_org")== null ? "":rs.getString("writer_org").trim();
			sWriterName	= rs.getString("writer_name")== null ? "":rs.getString("writer_name").trim();
			sWriterTel	= rs.getString("writer_tel")== null ? "":rs.getString("writer_tel").trim();
			sWriterEmail	= rs.getString("assign_mail")== null ? "":rs.getString("assign_mail").trim();
		}
		rs.close();
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if ( rs != null )	try{rs.close();}		catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )		try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}
		// 증빙자료 가져오기
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		
		sSQLs  = "SELECT * \n";
		sSQLs+= "FROM hado_tb_oent_attach_file \n";
		sSQLs+= "WHERE mng_no=? AND current_year=? AND oent_gb=? \n";
		sSQLs+= "ORDER BY file_sn DESC \n";
		
		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, sMngNo);
		pstmt.setString(2, sCurrentYear);
		pstmt.setString(3, sOentGB);
		rs = pstmt.executeQuery();
		
		while (rs.next()) {
			/* 2015-12-30	정광식		DB변경으로 인한 인코딩 변경
			arrMngNo.add( new String( rs.getString("mng_no").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrCYear.add( new String( rs.getString("current_year").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrOentGB.add( new String( rs.getString("oent_gb").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrFileSn.add( rs.getString("file_sn") );
			arrFileNm.add( new String( rs.getString("file_name").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrDocuNm.add(new String( rs.getString("docu_name").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrUpDt.add( rs.getString("upload_dt") );
			*/
			arrMngNo.add( rs.getString("mng_no")==null ? "":rs.getString("mng_no").trim() );
			arrCYear.add( rs.getString("current_year")==null ? "":rs.getString("current_year").trim() );
			arrOentGB.add( rs.getString("oent_gb")==null ? "":rs.getString("oent_gb").trim() );
			arrFileSn.add( rs.getString("file_sn")==null ? "":rs.getString("file_sn").trim() );
			arrFileNm.add( rs.getString("file_name")==null ? "":rs.getString("file_name").trim() );
			arrDocuNm.add( rs.getString("docu_name")==null ? "":rs.getString("docu_name").trim() );
			arrUpDt.add( rs.getString("upload_dt")==null ? "":rs.getString("upload_dt").trim() );
		}
		rs.close();
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if ( rs != null )	try{rs.close();}		catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )		try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}

		// 처리상황 리스트  가져오기
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		
		sSQLs  = "SELECT * \n";
		sSQLs+="FROM hado_tb_comp_status_proc \n";
		sSQLs+= "WHERE mng_no=? AND current_year=? AND oent_gb=? \n";
		sSQLs+= "ORDER BY proc_sn DESC \n";
		
		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, sMngNo);
		pstmt.setString(2, sCurrentYear);
		pstmt.setString(3, sOentGB);
		rs = pstmt.executeQuery();
		
		while (rs.next()) {
			/* 2015-12-30	정광식		DB변경으로 인한 인코딩 변경
			arrCenterName.add( new String( rs.getString("center_name").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrDeptName.add(new String( rs.getString("dept_name").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrUserName.add(new String( rs.getString("user_name").getBytes("ISO8859-1"), "EUC-KR" ) );
			arrProcCD.add( rs.getString("proc_cd") );
			arrWriteDate.add( rs.getString("write_date") );
			// 예외처리 (비고가 입력이 안되면 out of bound inde 오류)
			String stmConst = rs.getString("const")==null ? "비고 내용 없음":new String( rs.getString("const").getBytes("ISO8859-1"), "EUC-KR" );
			arrConst.add( stmConst );
			*/
			arrCenterName.add( rs.getString("center_name").trim() );
			arrDeptName.add( rs.getString("dept_name").trim() );
			arrUserName.add( rs.getString("user_name").trim() );
			arrProcCD.add( rs.getString("proc_cd").trim() );
			arrWriteDate.add( rs.getString("write_date").trim() );
			arrConst.add( rs.getString("const")==null ? "비고 내용 없음":rs.getString("const").trim() );
		}
		rs.close();
	} catch(Exception e){
			e.printStackTrace();
	} finally {
			if ( rs != null )	try{rs.close();}		catch(Exception e){}
			if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
			if ( conn != null )		try{conn.close();}	catch(Exception e){}
			if ( resource != null ) resource.release();
	}
	//담당관 정보 가져오기
	try {
		resource	= new ConnectionResource();
		conn		= resource.getConnection();

		sSQLs  ="SELECT  center_name,dept_name,user_name,phone_no \n";
		sSQLs+="FROM hado_vt_dept_history_" +sCurrentYear+ " \n";	// 분리 테이블 적용  / 20141002 / 정광식
		sSQLs+= "WHERE mng_no = ? AND current_year = ? AND oent_gb = ? \n";
		pstmt = conn.prepareStatement(sSQLs);
		pstmt.setString(1, sMngNo);
		pstmt.setString(2, sCurrentYear);
		pstmt.setString(3, sOentGB);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			/* 2015-12-30	정광식		DB변경으로 인한 인코딩 변경
			sCenterName= rs.getString("center_name")== null ? "":new String(rs.getString("center_name").getBytes("ISO8859-1"), "EUC-KR");
			sDeptName	= rs.getString("dept_name")== null ? "":new String(rs.getString("dept_name").getBytes("ISO8859-1"), "EUC-KR");
			sUserName	= rs.getString("user_name")== null ? "":new String(rs.getString("user_name").getBytes("ISO8859-1"), "EUC-KR");
			sPhoneNo	= rs.getString("phone_no")== null ? "":new String(rs.getString("phone_no"));
			*/
			sCenterName= rs.getString("center_name")== null ? "":rs.getString("center_name").trim();
			sDeptName	= rs.getString("dept_name")== null ? "":rs.getString("dept_name").trim();
			sUserName	= rs.getString("user_name")== null ? "":rs.getString("user_name").trim();
			sPhoneNo	= rs.getString("phone_no")== null ? "":rs.getString("phone_no").trim();
		}
		rs.close();
	} catch(Exception e){
		e.printStackTrace();
	} finally {
		if ( rs != null )	try{rs.close();}		catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )		try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}
}
%>

<html>
<head>
	<title>【관리】하도급거래 서면실태조사</title>
	<meta charset="euc-kr">
	<link rel="stylesheet" href="/hado/hado/wTools/style.css" type="text/css">
	<script type="text/javascript">
	//<![CDATA[
		function chksubmit() {
			var main	= document.info;

			main.target = "ProceFrame";
			main.action = "Oent_Comp_Status_save.jsp";
			main.method = "post";
			main.submit();
		}

		function viewConst(lyno) {
			var tobj = document.getElementById("lyList" + lyno);

			if( tobj ) {
				tobj.style.display = "block";
			}
		}

		function closeConst(lyno) {
			var tobj = document.getElementById("lyList" + lyno);

			if( tobj ) {
				tobj.style.display = "none";
			}
		}
	//]]
	</script>
</head>
<body>
<div id='viewWinTop' style="width:600px;">
	<ul class='lt'>
		<li class='fr'><a href="javascript:self.close()"; class='sbutton'>창닫기</a></li>
	</ul>
</div>


<div id='viewWinTitle'>1. 작성자 정보</div>

<table class='ViewResultTable' align='center'>
	<tr>
		<th>회사명</th>
		<td>&nbsp;<%=sOentName%></td>
		<th>대표자명</th>
		<td>&nbsp;<%=sOentCaptine%></td>
	</tr>
	<tr>
		<th>작성자 부서</th>
		<td>&nbsp;<%=sWriterOrg%></td>
		<th>작성자 이름</th>
		<td>&nbsp;<%=sWriterName%></td>
	</tr>
	<tr>
		<th>작성자 전화번호</th>
		<td>&nbsp;<%=sWriterTel%></td>
		<th>작성자 e-mail</th>
		<td>&nbsp;<%=sWriterEmail%></td>
	</tr>
</table>

<div id='viewWinTitle'>2. 첨부문서(증빙자료)</div>

<table class='ViewResultTable' align='center'>
	<colgroup>
		<col style='width:10%;' />
		<col style='width:40%;' />
		<col style='width:30%;' />
		<col style='width:20%;' />
	</colgroup>
	<tr>
		<th>순번</th>
		<th>첨부문서명</th>
		<th>첨부파일명</th>
		<th>업로드일자</th>
	</tr>
	<tr>
	<%for( int i=0; i<arrFileNm.size(); i++ ) {%>
		<td>&nbsp;<%=arrFileNm.size() - i%></td>
		<td>&nbsp;<%=arrDocuNm.get(i)%></td>
		<td>&nbsp;<a href='/hado/hado/wTools/Oent/Oent_Comp_Status_Proc_File_Down.jsp?sn=<%=arrFileSn.get(i)%>&mno=<%=arrMngNo.get(i)%>&cyear=<%=arrCYear.get(i)%>&ogb=<%=arrOentGB.get(i)%>'><%=arrFileNm.get(i)%></a></td>
		<td>&nbsp;<%=arrUpDt.get(i).toString().substring(0,10)%></td>
	</tr>
	<%}%>
</table>

<div id='viewWinTitle'>3. 처리 상황</div>

<table class='ViewResultTable' align='center'>
	<colgroup>
		<col style='width:27%;' />
		<col style='width:25%;' />
		<col style='width:15%;' />
		<col style='width:10%;' />
		<col style='width:20%;' />
		<col style='width:3%;' />
	</colgroup>
	<tr>
		<th>사무소명</th>
		<th>과명</th>
		<th>담당관명</th>
		<th>구분</th>
		<th>처리일자</th>
		<th>비고보기</th>
	</tr>
	<%
	if( arrProcCD.size()>0 ) {
		for( int i=0; i<arrProcCD.size(); i++ ) {%>
	<tr>
		<td>&nbsp;<%=arrCenterName.get(i).toString()%></td>
		<td>&nbsp;<%=arrDeptName.get(i).toString()%></td>
		<td>&nbsp;<%=arrUserName.get(i).toString()%></td>
		<%
		String sTmpProcCD = arrProcCD.get(i).toString();
		if( sTmpProcCD.equals("1") ) sTmpProcCD = "<font style='color:blue;'>승인</font>";
		else if( sTmpProcCD.equals("2") ) sTmpProcCD = "<font style='color:red;'>반려</font>";
		else sTmpProcCD = "미처리";
		%>
		<td>&nbsp;<%=sTmpProcCD%></td>
		<td>&nbsp;<%=arrWriteDate.get(i).toString().substring(0,10)%></td>
		<td><li class="fr"><a href="javascript:viewConst('<%=i%>');" class="sbutton">비고보기</a></li></td>
	</tr>
	<tr id="lyList<%=i%>" style="display:none;">
		<td colspan="6">
			<%=arrConst.get(i)%>
			<li class="fr"><a href="javascript:closeConst('<%=i%>');" class="sbutton">비고닫기</a></li>
		</td>
	</tr>
	<%
		}
	} else {%>
	<tr>
		<td colspan="6" align="center">
			등록된 처리결과가 없습니다.
		</td>
	</tr>
	<%
	}%>
</table>

<div id='viewWinTitle'>4. 담당관정보</div>

<table class='ViewResultTable' align='center'>
	<tr>
		<th>사무소명</th>
		<td>&nbsp;<%=sCenterName%></td>
		<th>과명</th>
		<td>&nbsp;<%=sDeptName%></td>
	</tr>
	<tr>
		<th>담당관명</th>
		<td>&nbsp;<%=sUserName%></td>
		<th>전화번호</th>
		<td>&nbsp;<%=sPhoneNo%></td>
	</tr>
</table>

<div id='viewWinTitle'>5. 처리결과</div>

<table class='ViewResultTable' align='center'>
	<form action="" method="post" name="info">
		<tr>
			<th>처리구분
				<input type="hidden" name="mno" value="<%=sMngNo%>"/>
				<input type="hidden" name="cyear" value="<%=sCurrentYear%>"/>
				<input type="hidden" name="ogb" value="<%=sOentGB%>"/>
			</th>
			<td><input type="radio" name="filecheck" value="1" checked> 승인
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="filecheck" value="2"> 반려</td>
		</tr>
		<tr>
			<th>비고</th>
			<td><textarea cols="70" rows="4" maxlength="1000" name="fileconst" class="textarea01b" ></textarea>
			</td>
		</tr>
	</form>
</table>

<li class='fr'><a href='javascript:chksubmit()'class='sbutton'>등록</a></li>

<iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
</body>
</html>