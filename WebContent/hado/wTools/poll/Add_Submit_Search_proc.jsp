<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: SOent_Search.jsp
* 프로그램설명	: 내부관리툴 - 수급사업자 - 수급사업자 검색 프로세스
* 프로그램버전	: 3.1.0-2015
* 최초작성일자	: 2014년 09월 24일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-24	정광식       최초작성
*  2015-07-22  정광식		 조사제외대상 처리방법 변경 적용 (SP_FLD_03 필드에 제외사유)

/*---------------------------------------- Variable Difinition ----------------------------------------*/
	// 리스트 배열
	ArrayList arrMngNo = new ArrayList();
	ArrayList arrCYear = new ArrayList();
	ArrayList arrChildMngNo = new ArrayList();
	ArrayList arrOentGB = new ArrayList();
	ArrayList arrOentName = new ArrayList();
	ArrayList arrSentName = new ArrayList();
	ArrayList arrSentNo = new ArrayList();
	ArrayList arrSentCaptine = new ArrayList();
	ArrayList arrConnCode = new ArrayList();
	ArrayList arrSentZipCode = new ArrayList();
	ArrayList arrSentAddress = new ArrayList();
	ArrayList arrSentReturnGB = new ArrayList();
	ArrayList arrSentReSend = new ArrayList();
	ArrayList arrSentTel = new ArrayList();
	ArrayList arrSentFax = new ArrayList();
	ArrayList arrWriterName = new ArrayList();
	ArrayList arrWriterTel = new ArrayList();
	ArrayList arrWriterFax = new ArrayList();
	ArrayList arrSentSale = new ArrayList();
	ArrayList arrSentAmt = new ArrayList();
	ArrayList arrEmpCnt = new ArrayList();
	ArrayList arrSentStatus = new ArrayList();
	ArrayList arrAddrStatus = new ArrayList();
	ArrayList arrDontLogin = new ArrayList();
	ArrayList arrCenterName = new ArrayList();
	// 제조 업종배열
	ArrayList arrDCode = new ArrayList();
	ArrayList arrDName = new ArrayList();
	// 건설 업종배열
	ArrayList arrCCode = new ArrayList();
	ArrayList arrCName = new ArrayList();
	// 용역 업종배열
	ArrayList arrSrvCode = new ArrayList();
	ArrayList arrSrvName = new ArrayList();
	// 조사제외대상
	ArrayList arrSpFld02 = new ArrayList();
	
	String sTmpCmd = StringUtil.checkNull(request.getParameter("tt")).trim();
	String sComm = StringUtil.checkNull(request.getParameter("comm")).trim();

	String sMngNo = request.getParameter("smno") == null ? "":request.getParameter("smno").trim();
	String sCurrentYear = request.getParameter("scyear") == null ? "":request.getParameter("scyear").trim();
	String sOentGB = request.getParameter("sogb") == null ? "":request.getParameter("sogb").trim();

	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	int currentYear = st_Current_Year_n;
	currentYear = session.getAttribute("cyear") != null ? Integer.parseInt(session.getAttribute("cyear")+"") : 2015;

	String vTableName = "";
	
	String sSQLWhere = "";
	String sSQLs = "";
	String sSQLs1 = "";
	String sSQLs2 = "";

	String stmpStr = "";

	int sStartYear = 2015;
	
	// Page
	int nPageSize = 20;
	String sTmpPageSize = (String)StringUtil.checkNull(request.getParameter("mpagesize")).trim();
	if( sTmpPageSize != null && (!sTmpPageSize.equals("")) ) {
		nPageSize = Integer.parseInt(sTmpPageSize);
		session.setAttribute("pagecnt",sTmpPageSize);
	} else {
		String sTmpPages = (String)session.getAttribute("pagecnt");
		if( sTmpPages != null && (!sTmpPages.equals("")) ) {
			nPageSize = Integer.parseInt(sTmpPages);
			session.setAttribute("pagecnt",sTmpPages);
		} else {
			nPageSize = 20;
		}
	}
	int nPage = 1;
	int nMaxPage = 1;
	int nRecordCount = 0;
	String sTmpPage = (String)StringUtil.checkNull(request.getParameter("page")).trim();
	if( sTmpPage != null && (!sTmpPage.equals("")) ) {
		nPage = Integer.parseInt(sTmpPage);
		session.setAttribute("page", sTmpPage);
	} else {
		String sTmpPages = (String)session.getAttribute("page");
		if( sTmpPages != null && (!sTmpPages.equals("")) ) {
			nPage = Integer.parseInt(sTmpPages);
			session.setAttribute("page", sTmpPages);
		} else {
			nPage = 1;
		}
	}

	int i = 0;
	int gesu = 0;

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	if( sTmpCmd.equals("start") ) {
		session.setAttribute("cyear", st_Current_Year);
		session.setAttribute("wgb", "");
		session.setAttribute("sgb", "");
		session.setAttribute("scomp", "");
		session.setAttribute("ocomp", "");
		session.setAttribute("csid", "");
		session.setAttribute("ceid", "");
		session.setAttribute("olast", "");
		session.setAttribute("ctid", "");
		session.setAttribute("ctoid", "");
		session.setAttribute("ssort", "1");
		session.setAttribute("pagecnt", "20");
		session.setAttribute("page", "1");
		session.setAttribute("selgb", "1");
	}

	if( sComm.equals("search") ) {
		session.setAttribute("cyear", StringUtil.checkNull(request.getParameter("cyear")).trim());
		session.setAttribute("wgb",StringUtil.checkNull(request.getParameter("wgb")).trim());
		session.setAttribute("sgb",StringUtil.checkNull(request.getParameter("sgb")).trim());
		session.setAttribute("scomp",new String(StringUtil.checkNull(request.getParameter("scomp")).trim().getBytes("EUC-KR"), "ISO8859-1" ));
		session.setAttribute("ocomp",new String(StringUtil.checkNull(request.getParameter("ocomp")).trim().getBytes("EUC-KR"), "ISO8859-1" ));
		session.setAttribute("csid",StringUtil.checkNull(request.getParameter("csid")).trim());
		session.setAttribute("ceid",StringUtil.checkNull(request.getParameter("ceid")).trim());
		session.setAttribute("olast",StringUtil.checkNull(request.getParameter("mlast")).trim());
		session.setAttribute("ctid",StringUtil.checkNull(request.getParameter("unitid")).trim());
		session.setAttribute("ctoid",StringUtil.checkNull(request.getParameter("unitoid")).trim());
		session.setAttribute("ssort",StringUtil.checkNull(request.getParameter("ssort")).trim());
		session.setAttribute("pagecnt", StringUtil.checkNull(request.getParameter("mpagesize")).trim());
		session.setAttribute("page", StringUtil.checkNull(request.getParameter("page")).trim());
		session.setAttribute("selgb", StringUtil.checkNull(request.getParameter("mselgb")).trim());
	}

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		
		if( !sTmpCmd.equals("start") ) {

			sSQLs2="SELECT * FROM ( \n";
			sSQLs2+="SELECT TT.*, FLOOR( (ROWNUM-1)/"+nPageSize+"+1 ) AS PAGE FROM ( \n";

			sSQLs1+="SELECT COUNT(*) RECCNT FROM ( \n";
			sSQLs1+="	SELECT jT1.mng_no,jT1.current_year,jT1.oent_gb,jT1.sent_no,jT2.sent_name,jT2.sent_captine FROM ( \n";
			sSQLs1+="		SELECT mng_no,current_year,oent_gb,sent_no \n";
			sSQLs1+="		FROM hado_tb_soent_answer_add \n";
			sSQLs1+="		WHERE current_year='2015' \n";
			sSQLs1+="		GROUP BY mng_no,current_year,oent_gb,sent_no \n";
			sSQLs1+="	) jT1 LEFT JOIN ( \n";
			sSQLs1+="		SELECT child_mng_no,current_year,sent_no,sent_name,sent_captine \n";
			sSQLs1+="		FROM hado_tb_subcon_2015 \n";
			sSQLs1+="		WHERE sel_gb='1' \n";
			sSQLs1+="	) jT2 ON jT1.mng_no=jT2.child_mng_no AND jT1.current_year=jT2.current_year AND jT1.sent_no=jT2.sent_no \n";
			sSQLs1+=") \n";

			sSQLs="	SELECT jT1.mng_no,jT1.current_year,jT1.oent_gb,jT1.sent_no,jT2.sent_name,jT2.sent_captine FROM ( \n";
			sSQLs+="		SELECT mng_no,current_year,oent_gb,sent_no \n";
			sSQLs+="		FROM hado_tb_soent_answer_add \n";
			sSQLs+="		WHERE current_year='2015' \n";
			sSQLs+="		GROUP BY mng_no,current_year,oent_gb,sent_no \n";
			sSQLs+="	) jT1 LEFT JOIN ( \n";
			sSQLs+="		SELECT child_mng_no,current_year,sent_no,sent_name,sent_captine \n";
			sSQLs+="		FROM hado_tb_subcon_2015 \n";
			sSQLs+="		WHERE sel_gb='1' \n";
			sSQLs+="	) jT2 ON jT1.mng_no=jT2.child_mng_no AND jT1.current_year=jT2.current_year AND jT1.sent_no=jT2.sent_no \n";
			sSQLs+=" WHERE SUBSTR(jT1.MNG_NO,-7)<>'1234567' \n";

			sSQLWhere = "";
			if( !session.getAttribute("scomp").equals("") ) {
				sSQLWhere+="	AND REPLACE(SENT_NAME,' ','') LIKE '%"+session.getAttribute("scomp")+"%' \n";
			}
			if( !session.getAttribute("ocomp").equals("") ) {
				sSQLWhere+="	AND REPLACE(OENT_NAME,' ','') LIKE '%"+session.getAttribute("ocomp")+"%' \n";
			}
			if( !session.getAttribute("wgb").equals("") ) {
				sSQLWhere+="	AND OENT_GB='"+session.getAttribute("wgb")+"' \n";
			}
			if( !session.getAttribute("sgb").equals("") ) {
				sSQLWhere+="	AND OENT_TYPE='"+session.getAttribute("sgb")+"' \n";
			}
			if( !session.getAttribute("csid").equals("") ) {
				stmpStr = session.getAttribute("csid")+"";
				sSQLWhere+="	AND MNG_NO>='"+stmpStr+"' \n";
			}
			if( !session.getAttribute("ceid").equals("") ) {
				stmpStr = session.getAttribute("ceid")+"";
				sSQLWhere+="	AND MNG_NO<='"+stmpStr+"' \n";
			}
			if( !session.getAttribute("ctid").equals("") ) {
				stmpStr = session.getAttribute("ctid")+"";
				sSQLWhere+="	AND MNG_NO='"+stmpStr+"' \n";
			}
			if( !session.getAttribute("ctoid").equals("") ) {
				sSQLWhere+="	AND MNG_NO='"+session.getAttribute("ctoid")+"' \n";
			}
			if( !session.getAttribute("selgb").equals("") ) {
				sSQLWhere+="	AND SEL_GB='"+session.getAttribute("selgb")+"' \n";
			}
			sSQLs+=sSQLWhere;
			
			if( session.getAttribute("ssort").equals("1") ) {
				sSQLs+="ORDER BY REPLACE(SENT_NAME,'(','') \n";
			}
			if( session.getAttribute("ssort").equals("2") ) {
				sSQLs+="ORDER BY SENT_AMT DESC \n";
			}
			if( session.getAttribute("ssort").equals("3") ) {
				sSQLs+="ORDER BY CHILD_MNG_NO \n";
			}
			if( session.getAttribute("ssort").equals("4") ) {
				sSQLs+="ORDER BY SENT_SALE DESC \n";
			}
		
			// 전체 페이지 계산을 위해 레코드 카운트
			sSQLs1+=" WHERE SUBSTR(MNG_NO,-7)<>'1234567' \n";
			if( !session.getAttribute("cyear").equals("0") ) {
				sSQLs1+="	AND CURRENT_YEAR='"+session.getAttribute("cyear")+"' \n";
			}
			sSQLs1+=sSQLWhere;

			// 페이징 처리한 쿼리문
			sSQLs2+=sSQLs+") TT ) \n";
			sSQLs2+="WHERE PAGE=" + nPage + " \n";

			//System.out.println(sSQLs1);
			pstmt = conn.prepareStatement(sSQLs1);
			rs = pstmt.executeQuery();
			
			while( rs.next()) {
				nRecordCount = rs.getInt("RECCNT");
			}
			rs.close();
			
			// 페이지 수 계산
			if(nRecordCount > 0) {
				nMaxPage = (int)Math.round(nRecordCount / (float)nPageSize + 0.4999999F);
			}
			
			//System.out.println(sSQLs2);
			pstmt = conn.prepareStatement(sSQLs2);
			rs = pstmt.executeQuery();
			
			while ( rs.next()) {
				arrMngNo.add(new String( StringUtil.checkNull(rs.getString("MNG_NO")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
				arrCYear.add(StringUtil.checkNull(rs.getString("Current_Year")).trim());
				arrOentGB.add(StringUtil.checkNull(rs.getString("OENT_GB")).trim());
				arrSentNo.add(StringUtil.checkNull(rs.getString("Sent_No")).trim());
				arrSentName.add(new String( StringUtil.checkNull(rs.getString("SENT_NAME")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
				arrSentCaptine.add(new String( StringUtil.checkNull(rs.getString("SENT_CAPTINE")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
			}
			rs.close();
		}
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if ( rs != null )		try{rs.close();}	catch(Exception e){}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
		if ( conn != null )		try{conn.close();}	catch(Exception e){}
		if ( resource != null ) resource.release();
	}
/*=====================================================================================================*/
%>

<script language="javascript">
content = "";

content+="<table id='divButton'>";
content+="	<tr>";
content+="		<td>검색된 회사수 : <%=formater.format(nRecordCount)%>개</strong> (page. <%=formater.format(nPage)%> / <%=formater.format(nMaxPage)%>)&nbsp;&nbsp;* 예시자료 포함.</td>";
content+="	</tr>";
content+="</table>";

content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th>조사<br/>년도</th>";
content+="		<th>관리번호</th>";
content+="		<th>업종구분</th>";
content+="		<th>수급사업자명</th>";
content+="		<th>대표자명</th>";
content+="	</tr>";
<%if( arrMngNo.size()>0 ) {
	for(int j=0; j<arrMngNo.size(); j++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<td><%=arrCYear.get(j)%></td>";
content+="		<td><a href='/hado/hado/rsch150706/WB_VP_Subcon_Add.jsp?mno=<%=arrMngNo.get(j)%>&cyear=<%=arrCYear.get(j)%>&wgb=<%=arrOentGB.get(j)%>' target='_blank'><%=arrMngNo.get(j)%></a></td>";
content+="		<td><% if( arrOentGB.get(j).equals("1") ) { out.print("제조");} else if( arrOentGB.get(j).equals("2") ) { out.print("건설");} else if( arrOentGB.get(j).equals("3") ) { out.print("용역");} %> </td>";
content+="		<td><%=arrSentName.get(j)%></td>";
content+="		<td><%=arrSentCaptine.get(j)%></td>";
content+="	</tr>";
<%
	}
} else {%>
content+="	<tr>";
content+="		<td colspan='5' class='noneResultset'>검색 결과가 없습니다</td>";
content+="	</tr>";
<%
}
%>
content+="</table>";
content+="<div id='pageMove'>";
content+="<p align='center'><%=UF_PageMove_java(nPage, nMaxPage, "pmove('Add_Submit_Search_proc.jsp?page=")%></p>";
content+="</div>";

top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>