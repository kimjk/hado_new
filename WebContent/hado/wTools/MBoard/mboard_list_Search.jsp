<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
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
	String sGroup = (request.getParameter("group")==null)? "":request.getParameter("group");
	String sClass = (request.getParameter("class")==null)? "":request.getParameter("class");
	String sSrchType = (request.getParameter("srchType")==null)? "":request.getParameter("srchType");
	String sSrchText = (request.getParameter("srchText")==null)? "":request.getParameter("srchText");
		
	ArrayList arrGroup		= new ArrayList();
	ArrayList arrClass		= new ArrayList();
	ArrayList arrNo			= new ArrayList();
	ArrayList arrLevel		= new ArrayList();
	ArrayList arrDate		= new ArrayList();
	ArrayList arrCVSNo		= new ArrayList();
	ArrayList arrCenterName	= new ArrayList();
	ArrayList arrDeptName	= new ArrayList();
	ArrayList arrUserName	= new ArrayList();
	ArrayList arrSubject	= new ArrayList();
	ArrayList arrText		= new ArrayList();
	ArrayList arrCount		= new ArrayList();
	ArrayList arrIP			= new ArrayList();
	ArrayList arrVFlag		= new ArrayList();
	ArrayList arrMngFlag	= new ArrayList();

	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sSQLs = "";

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		
		sSQLs ="SELECT MBoard_Group,MBoard_Class,MBoard_No,MBoard_Level,MBoard_Sort,TO_CHAR(MBoard_Date,'yyyy-mm-dd hh:mi:ss') MBoard_Date, \n";
		sSQLs+="	CVSNo,Center_Name,Dept_Name,User_Name,Phone_No,MBoard_Count,MBoard_Subject,Mboard_Text,MBoard_IP,MBoard_VFlag,Mng_Flag \n";
		sSQLs+="FROM HADO_TB_MBoard \n";
		sSQLs+="WHERE 1=1 \n";
		if( !sGroup.equals("") ) {
			sSQLs+="	AND MBoard_Group='"+sGroup+"' \n";
		}
		if( !sClass.equals("") ) {
			sSQLs+="	AND MBoard_Class='"+sGroup+"' \n";
		}
		if( (!sSrchType.equals("")) && (!sSrchText.equals("")) ) {
			if( sSrchType.equals("Text") ) {
				sSQLs+="	AND DBMS_LOB.INSTR(MBoard_Text,'"+new String(sSrchText.trim().getBytes("EUC-KR"), "ISO8859-1" )+"')>0 \n";
			} else if( sSrchType.equals("Content") ) {
				sSQLs+="	AND (DBMS_LOB.INSTR(MBoard_Text,'"+new String(sSrchText.trim().getBytes("EUC-KR"), "ISO8859-1" )+"')>0 \n";
				sSQLs+="		OR MBoard_Subject LIKE '%"+new String(sSrchText.trim().getBytes("EUC-KR"), "ISO8859-1" )+"%') \n";
			} else if( sSrchType.equals("Writer") ) {
				sSQLs+="	AND (Center_Name LIKE '%"+new String(sSrchText.trim().getBytes("EUC-KR"), "ISO8859-1" )+"%' \n";
				sSQLs+="		OR Dept_Name LIKE '%"+new String(sSrchText.trim().getBytes("EUC-KR"), "ISO8859-1" )+"%' \n";
				sSQLs+="		OR User_Name LIKE '%"+new String(sSrchText.trim().getBytes("EUC-KR"), "ISO8859-1" )+"%') \n";
			} else {
				sSQLs+="	AND MBoard_Subject LIKE '%"+new String(sSrchText.trim().getBytes("EUC-KR"), "ISO8859-1" )+"%' \n";
			}
		}
		sSQLs+="ORDER BY MBoard_No DESC, MBoard_Level ASC \n";
			
		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();	  
		

		while (rs.next()) {
			arrGroup.add( StringUtil.checkNull(rs.getString("MBoard_Group")).trim() );
			arrClass.add( StringUtil.checkNull(rs.getString("MBoard_Class")).trim() );
			arrNo.add( StringUtil.checkNull(rs.getString("MBoard_No")).trim() );
			arrLevel.add( StringUtil.checkNull(rs.getString("MBoard_Level")).trim() );
			arrDate.add( StringUtil.checkNull(rs.getString("MBoard_Date")).trim() );
			arrCVSNo.add( StringUtil.checkNull(rs.getString("CVSNo")).trim() );
			arrCenterName.add(new String(StringUtil.checkNull(rs.getString("Center_Name")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			arrDeptName.add(new String(StringUtil.checkNull(rs.getString("Dept_Name")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			arrUserName.add(new String(StringUtil.checkNull(rs.getString("User_Name")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			arrSubject.add(new String(StringUtil.checkNull(rs.getString("MBoard_Subject")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			Reader input = rs.getCharacterStream("MBoard_Text");
			char[] buffer = new char[1024];
			int byteRead;
			StringBuffer sbOutput = new StringBuffer();
			while ((byteRead=input.read(buffer,0,1024))!=-1) {
				sbOutput.append(buffer,0,byteRead);
			}
			arrText.add(new String(sbOutput.toString().trim().getBytes("ISO8859-1"), "EUC-KR" ));
			arrCount.add( StringUtil.checkNull(rs.getString("MBoard_Count")).trim() );
			arrIP.add( StringUtil.checkNull(rs.getString("MBoard_IP")).trim() );
			arrVFlag.add( StringUtil.checkNull(rs.getString("MBoard_VFlag")).trim() );
			arrMngFlag.add( StringUtil.checkNull(rs.getString("Mng_Flag")).trim() );
		}
		rs.close();
	}
	catch(Exception e){
		e.printStackTrace();
	}
	finally {
		if ( rs != null ) try{rs.close();}catch(Exception e){}
		if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
		if ( conn != null ) try{conn.close();}catch(Exception e){}
		if ( resource != null ) resource.release();
	}
/*=====================================================================================================*/
%>

<script language="javascript">
content = "";

content+="<table class='resultTable'>";
content+="	<colsgroup>";
content+="		<col width='80'>";
content+="		<col width='410'>";
content+="		<col width='100'>";
content+="		<col width='100'>";
content+="		<col width='80'>";
content+="	</colsgroup>";
content+="	<thead>";
content+="		<tr>";
content+="			<th>순번</th>";
content+="			<th>제목</th>";
content+="			<th>작성자</th>";
content+="			<th>작성일</th>";
content+="			<th>조회</th>";
content+="		</tr>";
content+="	</thead>";

content+="	</tbody>";
<%if( arrNo.size()>0 ) {
	for(int ni=0;ni<arrNo.size();ni++) {%>
content+="		<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="			<td style='text-align:right;'><%=ni+1%></td>";
content+="			<td style='text-align:left;'><a href=javascript:top.view('<%=arrNo.get(ni)%>')><%=arrSubject.get(ni)%></a></td>";
content+="			<td><%=arrUserName.get(ni)%></td>";
content+="			<td><%=arrDate.get(ni)%></td>";
content+="			<td style='text-align:right;'><%=arrCount.get(ni)%></td>";
content+="		</tr>";
<%	}
}else {%>
content+="		<tr>";
content+="			<td colspan='5' class='noneResultset'>검색 결과가 없습니다</td>";
content+="		</tr>";
<%}%>
content+="	</tbody>";
content+="</table>";

content+="<div id='divButton'>";
content+="	<ul class='lt'>";
content+="		<li class='fr'><a href=javascript:top.view('new') class='sbutton'>게시물 등록</a></li>";
content+="	</ul>";
content+="</div>";

top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>