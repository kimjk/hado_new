<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%><%/*** 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업* 프로그램명	: Member_Regist.jsp* 프로그램설명	: 내부관리툴 사용자 등록* 프로그램버전	: 1.0.1* 최초작성일자	: 2009년 05월* 작 성 이 력       :*=========================================================*	작성일자		작성자명				내용*=========================================================*	2009-05-00	정광식       최초작성*	2015-12-30	정광식		DB변경으로 인한 인코딩 변경*/%><%@ page import="java.sql.*"%><%@ page import="java.util.*"%><%@ page import="ftc.util.*"%><%@ page import="ftc.db.ConnectionResource"%><%@ page import="ftc.db.ConnectionResource2"%><%@ page import="java.text.DecimalFormat"%><%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%><%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%><%/*---------------------------------------- Variable Difinition ----------------------------------------*/	String sTableName = "";	String sErrorMsg = "";	String sSQLs = "";	int nNewNo = 0;	String q_No = request.getParameter("no")==null ? "":request.getParameter("no").trim();	String sLink = "cmd=insert";	if(q_No != null && (!q_No.equals("new")) ) {		sLink = "cmd=edit";	}	ConnectionResource resource = null;	Connection conn = null;	PreparedStatement pstmt = null;	ResultSet rs = null;	String d_ID = "";	String d_Center_Name = "본부";	String d_Dept_Name = "";	String d_User_Name = "";	String d_Phone_No = "";	String d_Permision = "";	String d_Const = "";/*-----------------------------------------------------------------------------------------------------*//*=================================== Record Selection Processing =====================================*/	if(q_No != null && (!q_No.equals("new")) ) {		try {			resource = new ConnectionResource();			conn = resource.getConnection();			sSQLs ="SELECT * \n";			sSQLs+="FROM HADO_TB_FTC_User \n";			sSQLs+="WHERE Dept_Seq=? \n";			pstmt = conn.prepareStatement(sSQLs);			pstmt.setString(1,q_No);			rs = pstmt.executeQuery();			while( rs.next() ) {				d_ID = rs.getString("CVSNO").trim()==null ? "":rs.getString("CVSNO").trim();				/* 2015-12-30	정광식		DB변경으로 인한 인코딩 변경				d_Center_Name = new String(StringUtil.checkNull(rs.getString("Center_Name")).trim().getBytes("ISO8859-1"), "EUC-KR" );				d_Dept_Name = new String(StringUtil.checkNull(rs.getString("Dept_Name")).trim().getBytes("ISO8859-1"), "EUC-KR" );				d_User_Name = new String(StringUtil.checkNull(rs.getString("User_Name")).trim().getBytes("ISO8859-1"), "EUC-KR" );				d_Phone_No = new String(StringUtil.checkNull(rs.getString("Phone_No")).trim().getBytes("ISO8859-1"), "EUC-KR" );				d_Const = new String(StringUtil.checkNull(rs.getString("Const")).trim().getBytes("ISO8859-1"), "EUC-KR" );				*/				d_Center_Name = rs.getString("Center_Name")==null ? "":rs.getString("Center_Name").trim();				d_Dept_Name = rs.getString("Dept_Name")==null ? "":rs.getString("Dept_Name").trim();				d_User_Name = rs.getString("User_Name")==null ? "":rs.getString("User_Name").trim();				d_Phone_No = rs.getString("Phone_No")==null ? "":rs.getString("Phone_No").trim();				d_Const = rs.getString("Const")==null ? "":rs.getString("Const").trim().replace("\r\n", ",  ");				d_Permision = rs.getString("Permision").trim()==null ? "":rs.getString("Permision").trim();			}			rs.close();		} catch(Exception e) {			e.printStackTrace();		} finally {			if ( rs != null ) try{rs.close();}catch(Exception e){}			if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}			if ( conn != null ) try{conn.close();}catch(Exception e){}			if ( resource != null ) resource.release();		}	}/*=====================================================================================================*/%><script type="text/javascript">//<![CDATA[	content = "";		content+="<div id='viewWinTop'>";	content+="	<ul class='lt'>";	content+="		<li class='fr'><a href=javascript:closeViewWin('divView') class='sbutton'>창닫기</a></li>";	content+="	</ul>";	content+="</div>";		content+="<div id='viewWinTitle'>사용자 정보 등록</div>";		content+="<table class='ViewResultTable' align='center'>";	content+="<form action='Member_Query.jsp?<%=sLink%>' method='post' name='MemberInform' target='procFrame'>";	content+="	<tr>";	content+="		<th>사용자번호</th>";	content+="		<td><input type='text' name='mID' value='<%=d_ID%>' class='s_input'>";	content+="			<br/>";	content+="			※ 사용자 번호는 ThinkFair의 사용자 번호를 입력하세요.<br/>";	content+="			※ ThinkFair의 사용자번호는 직원검색시 이름옆의 () 안에 번호입니다.<br/>";	content+="			&nbsp;&nbsp;&nbsp;예) 정광식(<B>g022</B>) : 사용자번호 = g022";	content+="			<input type='hidden' name='mNo' value='<%=q_No%>'>";	content+="		</td>";	content+="	</tr>";	content+="	<tr>";	content+="		<th>사무소명</th>";	content+="		<td><select name='mCenterName'>";	content+="				<option value='본부 기업거래정책국' <%if(d_Center_Name!=null && d_Center_Name.substring(0,2).equals("본부")){%>selected<%}%>>본부 기업거래정책국</option>";	content+="				<option value='서울 사무소' <%if(d_Center_Name!=null && d_Center_Name.substring(0,2).equals("서울")){%>selected<%}%>>서울 사무소</option>";	content+="				<option value='부산 사무소' <%if(d_Center_Name!=null && d_Center_Name.substring(0,2).equals("부산")){%>selected<%}%>>부산 사무소</option>";	content+="				<option value='광주 사무소' <%if(d_Center_Name!=null && d_Center_Name.substring(0,2).equals("광주")){%>selected<%}%>>광주 사무소</option>";	content+="				<option value='대전 사무소' <%if(d_Center_Name!=null && d_Center_Name.substring(0,2).equals("대전")){%>selected<%}%>>대전 사무소</option>";	content+="				<option value='대구 사무소' <%if(d_Center_Name!=null && d_Center_Name.substring(0,2).equals("대구")){%>selected<%}%>>대구 사무소</option>";	content+="			</select>";	content+="		</td>";	content+="	</tr>";	content+="	<tr>";	content+="		<th>과명</th>";	content+="		<td><input type='text' name='mDeptName' value='<%=d_Dept_Name%>' class='s_input'></td>";			content+="	</tr>";	content+="	<tr>";	content+="		<th>사용자명</th>";	content+="		<td><input type='text' name='mUserName' value='<%=d_User_Name%>' class='s_input'></td>";			content+="	</tr>";	content+="	<tr>";	content+="		<th>전화번호</th>";	content+="		<td><input type='text' name='mPhoneNo' value='<%=d_Phone_No%>' class='s_input'></td>";			content+="	</tr>";	content+="	<tr>";	content+="		<th>관리권한</th>";	content+="		<td><select name='mPermision'>";	content+="				<option value='P' <%if(d_Permision!=null && d_Permision.equals("P")){%>selected<%}%>>일반등급</option>";	content+="				<option value='V' <%if(d_Permision!=null && d_Permision.equals("V")){%>selected<%}%>>조회등급</option>";	content+="				<option value='M' <%if(d_Permision!=null && d_Permision.equals("M")){%>selected<%}%>>관리등급</option>";	content+="				<option value='T' <%if(d_Permision!=null && d_Permision.equals("T")){%>selected<%}%>>시스템관리등급</option>";	content+="			</select>";	content+="		</td>";	content+="	</tr>";	content+="	<tr>";	content+="		<th>비고</th>";	content+="		<td><textarea name='mConst' class='s_textarea'><%=d_Const%></textarea></td>";	content+="	</tr>";	content+="</form>";	content+="</table>";		content+="<div id='divViewWinbutton'>";	content+="	<ul class='lt'>";	content+="		<li class='fl'><a href=javascript:top.savef(document.MemberInform) class='sbutton'>정보등록</a></li>";	content+="		<li class='fl'><a href=javascript:top.deluserf(document.MemberInform) class='sbutton'>정보삭제</a></li>";	content+="		<li class='fr'><a href=javascript:top.closeViewWin('divView') class='sbutton'>창닫기</a></li>";	content+="	</ul>";	content+="</div>";		top.document.getElementById("divView").innerHTML = content;	top.setNowProcessFalse();//]]</script><%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>