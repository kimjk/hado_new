<%@ page session="true" language="java" contentType="application/vnd.ms-excel; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명	: Correct_Search_Excel.jsp
* 프로그램설명	: 자진시정 사업자 검색 엑셀 내보내기
* 프로그램버전	: 2.0.1
* 최초작성일자	: 2009년 05월
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2009-05-00	정광식       최초작성
*	2011-10-18	정광식		웹관리툴 리뉴얼
* 	2015-09-15	정광식       불필요한 SQL 제거 (쓸때없이 여러개의 View 를 참조)
*	2015-12-30	정광식		DB변경으로 인한 인코딩 변경
*/
%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>
<%@ page import="java.text.DecimalFormat"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>
<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	// 리스트 배열
	ArrayList arrMngNo = new ArrayList();
	ArrayList arrCYear = new ArrayList();
	ArrayList arrOentGB = new ArrayList();
	ArrayList arrOentName = new ArrayList();
	ArrayList arrOentCaptine = new ArrayList();
	ArrayList arrWriterName = new ArrayList();
	ArrayList arrWriterTel = new ArrayList();
	ArrayList arrWriterFax = new ArrayList();
	ArrayList arrSubconCnt = new ArrayList();
	ArrayList arrPostNo1 = new ArrayList();
	ArrayList arrPostNo2 = new ArrayList();
	ArrayList arrPostNo3 = new ArrayList();
	ArrayList arrPostNo4 = new ArrayList();
	ArrayList arrPostNo5 = new ArrayList();
	ArrayList arrSurveyGB = new ArrayList();
	ArrayList arrSurveyMoneyGB = new ArrayList();
	// 담당조사관정보추가 // 20100503 / 정광식
	ArrayList arrDamCenter = new ArrayList();
	ArrayList arrUserName = new ArrayList();
	ArrayList arrDeptName = new ArrayList();
	ArrayList arrCVSNo = new ArrayList();
	ArrayList arrInsertF = new ArrayList();

	String sComm = request.getParameter("comm")==null ? "":request.getParameter("comm").trim();
	String sTComm = request.getParameter("tt")==null ? "":request.getParameter("tt").trim();

	String sSQLWhere = "";
	String sSQLs = "";
	String sSQLs1 = "";
	String sSQLs2 = "";
	String sTmpStr="";
	String sTmpStr1="";
	String sTmpStr2="";

	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	int sStartYear = 2000;
	int nRowSizes = 70;
	int currentYear = 0;

	// Page
	int nPageSize = 10;
	String sTmpPageSize = request.getParameter("mpagesize")==null ? "":(String)request.getParameter("mpagesize").trim();
	if( sTmpPageSize != null && (!sTmpPageSize.equals("")) ) {
		nPageSize = Integer.parseInt(sTmpPageSize);
		session.setAttribute("pagecnt",sTmpPageSize);
	} else {
		String sTmpPages = (String)session.getAttribute("pagecnt");
		if( sTmpPages != null && (!sTmpPages.equals("")) ) {
			nPageSize = Integer.parseInt(sTmpPages);
			session.setAttribute("pagecnt",sTmpPages);
		} else {
			nPageSize = 10;
		}
	}
	int nPage = 1;
	int nMaxPage = 1;
	int nRecordCount = 0;
	String sTmpPage = request.getParameter("page")==null ? "":(String)request.getParameter("page").trim();
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
	/*
	if( sTComm.equals("start") ) {
		session.setAttribute("cyear", st_Current_Year);
		session.setAttribute("wgb", "");
		session.setAttribute("sgb", "");
		session.setAttribute("scomp", "");
		session.setAttribute("ssort", "1");
		session.setAttribute("csid", "");
		session.setAttribute("ceid", "");
		session.setAttribute("oareacode", "");
		session.setAttribute("odeptname", "");
		session.setAttribute("unitid", "");
		session.setAttribute("pagecnt", "10");
		session.setAttribute("page", "1");
		session.setAttribute("surgb","");
		session.setAttribute("insertf","");
	}

	if( sComm.equals("search") ) {
		session.setAttribute("cyear", request.getParameter("cyear")==null ? "":request.getParameter("cyear").trim());
		session.setAttribute("sgb",request.getParameter("sgb")==null ? "":request.getParameter("sgb").trim());
		session.setAttribute("wgb",request.getParameter("wgb")==null ? "":request.getParameter("wgb").trim());
		session.setAttribute("scomp",request.getParameter("scomp")==null ? "":request.getParameter("scomp").trim());
		session.setAttribute("ssort",request.getParameter("ssort")==null ? "":request.getParameter("ssort").trim());
		session.setAttribute("csid",request.getParameter("csid")==null ? "":request.getParameter("csid").trim());
		session.setAttribute("ceid",request.getParameter("ceid")==null ? "":request.getParameter("ceid").trim());
		session.setAttribute("oareacode",request.getParameter("mareacode")==null ? "":request.getParameter("mareacode").trim());
		session.setAttribute("odeptname",request.getParameter("mdeptname")==null ? "":request.getParameter("mdeptname").trim());
		session.setAttribute("unitid",request.getParameter("unitid")==null ? "":request.getParameter("unitid").trim());
		session.setAttribute("pagecnt",request.getParameter("mpagesize")==null ? "":request.getParameter("mpagesize").trim());
		session.setAttribute("page", request.getParameter("page")==null ? "":request.getParameter("page").trim());
		session.setAttribute("surgb", request.getParameter("surgb")==null ? "":request.getParameter("surgb").trim());
		session.setAttribute("insertf", request.getParameter("insertf")==null ? "":request.getParameter("insertf").trim());
	}
	*/
	if( !session.getAttribute("cyear").equals("") ) {
		currentYear = Integer.parseInt(session.getAttribute("cyear").toString());
	} else {
		currentYear = 0;
	}

	// view table name
	String currentSurveyList = currentYear>=2012 ? "HADO_VT_Survey_List_"+currentYear : "HADO_VT_Survey_List";

	sSQLs2="SELECT * FROM ( \n";
	sSQLs2+="SELECT TT.*, FLOOR( (ROWNUM-1)/"+nPageSize+"+1 ) AS PAGE FROM ( \n";

	sTmpStr=session.getAttribute("cyear")+"";

	if( (currentYear>=2012) ) {
	    /* 2015-09-15 / 정광식 / 불필요한 SQL 제거 (쓸때없이 여러개의 View 를 참조)
		sSQLs1= "SELECT COUNT(*) RECCNT FROM ( \n";
		sSQLs1+="	SELECT A1.*,A2.Insert_F \n";
		sSQLs1+="	FROM HADO_VT_OENT_"+currentYear+" A1 \n";
		sSQLs1+="	LEFT JOIN "+currentSurveyList+" A2 \n";
		sSQLs1+="	ON A1.Mng_No=A2.Mng_No \n";
		sSQLs1+="		AND A1.Current_Year=A2.Current_Year \n";
		sSQLs1+="		AND A1.Oent_GB=A2.Oent_GB ) \n";
		sSQLs= "SELECT * FROM ( \n";
		sSQLs+="	SELECT A1.*,A2.Insert_F \n";
		sSQLs+="	FROM HADO_VT_OENT_"+currentYear+" A1 \n";
		sSQLs+="	LEFT JOIN "+currentSurveyList+" A2 \n";
		sSQLs+="	ON A1.Mng_No=A2.Mng_No \n";
		sSQLs+="		AND A1.Current_Year=A2.Current_Year \n";
		sSQLs+="		AND A1.Oent_GB=A2.Oent_GB ) \n";
		*/
		sSQLs1= "SELECT COUNT(*) RECCNT \n";
		sSQLs1+="FROM ( \n";
		sSQLs1+="	SELECT A.*,B.POST_NO_01,B.POST_NO_02,B.POST_NO_03,B.POST_NO_04,B.POST_NO_05 \n";
		sSQLs1+="	FROM HADO_VT_Survey_List_"+currentYear+" A \n";
		sSQLs1+="	LEFT JOIN HADO_TB_OENT_POSTNO_"+currentYear+" B \n";
		sSQLs1+="	ON A.MNG_NO=B.MNG_NO AND A.CURRENT_YEAR=B.CURRENT_YEAR AND A.OENT_GB=B.OENT_GB \n";
		sSQLs1+=") jT \n";

		sSQLs= "SELECT * \n";
		sSQLs+="FROM ( \n";
		sSQLs+="	SELECT A.*,B.POST_NO_01,B.POST_NO_02,B.POST_NO_03,B.POST_NO_04,B.POST_NO_05 \n";
		sSQLs+="	FROM HADO_VT_Survey_List_"+currentYear+" A \n";
		sSQLs+="	LEFT JOIN HADO_TB_OENT_POSTNO_"+currentYear+" B \n";
		sSQLs+="	ON A.MNG_NO=B.MNG_NO AND A.CURRENT_YEAR=B.CURRENT_YEAR AND A.OENT_GB=B.OENT_GB \n";
		sSQLs+=") jT \n";
	} else if( (currentYear>=2010) ) {
		sSQLs1= "SELECT COUNT(*) RECCNT FROM ( \n";
		sSQLs1+="	SELECT A1.*,A2.Insert_F \n";
		sSQLs1+="	FROM HADO_VT_OENT_2010 A1 \n";
		sSQLs1+="	LEFT JOIN "+currentSurveyList+" A2 \n";
		sSQLs1+="	ON A1.Mng_No=A2.Mng_No \n";
		sSQLs1+="		AND A1.Current_Year=A2.Current_Year \n";
		sSQLs1+="		AND A1.Oent_GB=A2.Oent_GB ) \n";
		sSQLs= "SELECT * FROM ( \n";
		sSQLs+="	SELECT A1.*,A2.Insert_F \n";
		sSQLs+="	FROM HADO_VT_OENT_2010 A1 \n";
		sSQLs+="	LEFT JOIN "+currentSurveyList+" A2 \n";
		sSQLs+="	ON A1.Mng_No=A2.Mng_No \n";
		sSQLs+="		AND A1.Current_Year=A2.Current_Year \n";
		sSQLs+="		AND A1.Oent_GB=A2.Oent_GB ) \n";
	} else {
		sSQLs1= "SELECT COUNT(*) RECCNT FROM ( \n";
		sSQLs1+="	SELECT A1.*,A2.Insert_F \n";
		sSQLs1+="	FROM HADO_VT_OENT A1 \n";
		sSQLs1+="	LEFT JOIN "+currentSurveyList+" A2 \n";
		sSQLs1+="	ON A1.Mng_No=A2.Mng_No \n";
		sSQLs1+="		AND A1.Current_Year=A2.Current_Year \n";
		sSQLs1+="		AND A1.Oent_GB=A2.Oent_GB ) \n";
		sSQLs= "SELECT * FROM ( \n";
		sSQLs+="	SELECT A1.*,A2.Insert_F \n";
		sSQLs+="	FROM HADO_VT_OENT_2010 A1 \n";
		sSQLs+="	LEFT JOIN "+currentSurveyList+" A2 \n";
		sSQLs+="	ON A1.Mng_No=A2.Mng_No \n";
		sSQLs+="		AND A1.Current_Year=A2.Current_Year \n";
		sSQLs+="		AND A1.Oent_GB=A2.Oent_GB ) \n";
	}

	sSQLWhere="";
	if( !session.getAttribute("wgb").toString().equals("") ) {
		sSQLWhere+="AND OENT_GB='"+session.getAttribute("wgb")+"' \n";
	} else {
		if( currentYear>=2010 ) {
			sSQLWhere+="AND (OENT_GB='1' OR Oent_GB='2' OR OENT_GB='3') \n";
		} else {
			if( currentYear>=2006 ) {
				sSQLWhere+="AND (OENT_GB='1' OR OENT_GB='3') \n";
			}
		}
	}
	if( !session.getAttribute("sgb").toString().equals("") ) {
		sSQLWhere+="AND OENT_TYPE='"+session.getAttribute("sgb")+"' \n";
	}
	if( !session.getAttribute("scomp").toString().equals("") ) {
		sSQLWhere+="AND REPLACE(OENT_NAME,' ','') LIKE '%"+session.getAttribute("scomp")+"%' \n";
	}
	if( !session.getAttribute("csid").toString().equals("") ) {
		String tmpStr=session.getAttribute("csid")+"";
		sSQLWhere+="AND MNG_NO>='"+tmpStr.toUpperCase()+"' \n";
	}
	if( !session.getAttribute("ceid").toString().equals("") ) {
		String tmpStr=session.getAttribute("ceid")+"";
		sSQLWhere+="AND MNG_NO<='"+tmpStr.toUpperCase()+"' \n";
	}
	if( !session.getAttribute("unitid").toString().equals("") ) {
		String tmpStr=session.getAttribute("unitid")+"";
		sSQLWhere+="AND MNG_NO='"+tmpStr.toUpperCase()+"' \n";
	}
	if( !session.getAttribute("oareacode").toString().equals("") ) {
		//sTmpStr1=new String(selDeptName(session.getAttribute("oareacode")+"").getBytes("EUC-KR"),"ISO8859-1");
		sTmpStr1=selDeptName(session.getAttribute("oareacode")+"");
		sSQLWhere+="AND Center_Name LIKE '"+sTmpStr1+"%' \n";
	}
	// 시정조치 입력여부 추가 - 정광식
	if( !session.getAttribute("insertf").toString().equals("") ) {
		sSQLWhere+="AND Insert_F='"+session.getAttribute("insertf")+"' \n";
	}
	// 2010년 담당자 세팅 방법 변경 (HADO_TB_DEPT_HISTORY)
	if( currentYear>=2010) {
		if( !session.getAttribute("odeptname").toString().equals("") ) {
			sSQLWhere+="AND CVSNO='"+session.getAttribute("odeptname")+"' \n";
		}
	} else {
		if( !session.getAttribute("odeptname").toString().equals("") ) {
			sSQLWhere+="AND DEPT_SEQ="+session.getAttribute("odeptname")+" \n";
		}
	}
	if( !session.getAttribute("surgb").toString().equals("") ) {
		if( session.getAttribute("surgb").toString().equals("21") ) {
			sSQLWhere+="AND Survey_GB='2' \n";
			sSQLWhere+="AND Survey_Money_GB='1' \n";
		} else if( session.getAttribute("surgb").toString().equals("20") ) {
			sSQLWhere+="AND Survey_GB='2' \n";
			if( currentYear>=2014) {
				sSQLWhere+="AND Survey_Money_GB='2' \n";
			} else {
				sSQLWhere+="AND Survey_Money_GB IS NULL \n";
			}
		} else {
			sSQLWhere+="AND Survey_GB='"+session.getAttribute("surgb")+"' \n";
		}
	} else {
		sSQLWhere+="AND Survey_GB IS NOT NULL \n";
	}

	// 예시데이타는 관리번호 뒤에 1234567 삽입했음 (예외처리 필요)
	//sSQLs1+=" WHERE SUBSTR(MNG_NO,-7) <> '1234567'";
	sSQLs+="WHERE MNG_NO IS NOT NULL \n";
	if( currentYear > 0 ) {
		sSQLs+="AND CURRENT_YEAR='"+currentYear+"' \n";
	}
	sSQLs+=sSQLWhere;

	if( session.getAttribute("ssort").toString().equals("1") ) {
		sSQLs+="ORDER BY REPLACE(OENT_NAME,'(','') \n";
	}
	if( session.getAttribute("ssort").toString().equals("2") ) {
		sSQLs+="ORDER BY OENT_ASSETS DESC \n";
	}

	if( session.getAttribute("ssort").toString().equals("3") ) {
		sSQLs+="ORDER BY OENT_SALE02 DESC \n";
	}
	if( session.getAttribute("ssort").toString().equals("4") ) {
		sSQLs+="ORDER BY MNG_NO \n";
	}
	if( session.getAttribute("ssort").toString().equals("5") ) {
		sSQLs+="ORDER BY Center_Name,Dept_Name,User_Name \n";
	}
	if( session.getAttribute("ssort").toString().equals("") && currentYear==0 ) {
		sSQLs+="ORDER BY Current_Year \n";
	}
	if( session.getAttribute("ssort").toString().equals("") ) {
		sSQLs+="ORDER BY center_name,dept_name,user_name \n";
	}
	// 전체 페이지 계산을 위해 레코드 카운트
	//sSQLs1+=" WHERE SUBSTR(MNG_NO,-7) <> '1234567'";
	sSQLs1+="WHERE MNG_NO IS NOT NULL \n";
	if( (currentYear>2010) ) {
		sSQLs1+="AND LENGTH(Mng_No)>4 \n";
	} else {
		sSQLs1+="AND SUBSTR(Mng_No,-5) <> '12345' \n";
	}
	if( currentYear > 0 ) {
		sSQLs1+="AND CURRENT_YEAR='"+currentYear+"' "+sSQLWhere+" \n";
	}
	// 페이징 처리한 쿼리문
	sSQLs2+=sSQLs+") TT ) \n";
	//sSQLs2+="WHERE PAGE="+nPage+" \n";

	//System.out.println(sSQLs1); // 페이지 계산 쿼리

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		pstmt=conn.prepareStatement(sSQLs1);
		rs=pstmt.executeQuery();

		while( rs.next()) {
			nRecordCount=rs.getInt("RECCNT");
		}
		rs.close();

		// 페이지 수 계산
		if(nRecordCount > 0) {
			nMaxPage=(int)Math.round(nRecordCount / (float)nPageSize + 0.4999999F);
		}
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if ( rs != null ) try{rs.close();}catch(Exception e){}
		if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
		if ( conn != null ) try{conn.close();}catch(Exception e){}
		if ( resource != null ) resource.release();
	}

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		//System.out.println(sSQLs2); // 검색 데이터 쿼리
		//out.println(sSQLs2);

		pstmt = conn.prepareStatement(sSQLs2);
		rs = pstmt.executeQuery();

		while ( rs.next()) {
			arrMngNo.add( rs.getString("MNG_NO")==null ? "":rs.getString("MNG_NO").trim() );
			arrCYear.add( rs.getString("Current_Year")==null ? "":rs.getString("Current_Year").trim() );
			arrOentGB.add( rs.getString("OENT_GB")==null ? "":rs.getString("OENT_GB").trim() );
			arrOentName.add( rs.getString("OENT_NAME")==null ? "":rs.getString("OENT_NAME").trim() );
			arrOentCaptine.add( rs.getString("OENT_CAPTINE")==null ? "":rs.getString("OENT_CAPTINE").trim() );
			arrWriterName.add( rs.getString("WRITER_NAME")==null ? "":rs.getString("WRITER_NAME").trim() );
			arrWriterTel.add( rs.getString("WRITER_TEL")==null ? "":rs.getString("WRITER_TEL").trim() );
			arrWriterFax.add( rs.getString("WRITER_FAX")==null ? "":rs.getString("WRITER_FAX").trim() );
			if( (currentYear>=2010) ) {
				arrCVSNo.add( rs.getString("CVSNO")==null ? "":rs.getString("CVSNO").trim() );
				arrDamCenter.add( rs.getString("Center_NAME")==null ? "":rs.getString("Center_NAME").trim() );
				arrDeptName.add( rs.getString("Dept_NAME")==null ? "":rs.getString("Dept_NAME").trim() );
				arrUserName.add( rs.getString("User_NAME")==null ? "":rs.getString("User_NAME").trim() );
			} else {
				arrCVSNo.add("");
				arrDamCenter.add("");
				arrDeptName.add("");
				arrUserName.add("");
			}
			arrSurveyGB.add( rs.getString("Survey_GB")==null ? "":rs.getString("Survey_GB").trim() );
			arrSurveyMoneyGB.add( rs.getString("Survey_Money_GB")==null ? "":rs.getString("Survey_Money_GB").trim() );
			arrPostNo1.add( rs.getString("POST_NO_01")==null ? "":rs.getString("POST_NO_01").trim() );
			arrPostNo2.add( rs.getString("POST_NO_02")==null ? "":rs.getString("POST_NO_02").trim() );
			arrPostNo3.add( rs.getString("POST_NO_03")==null ? "":rs.getString("POST_NO_03").trim() );
			arrPostNo4.add( rs.getString("POST_NO_04")==null ? "":rs.getString("POST_NO_04").trim() );
			arrPostNo5.add( rs.getString("POST_NO_05")==null ? "":rs.getString("POST_NO_05").trim() );
			arrInsertF.add( rs.getString("Insert_F")==null ? "":rs.getString("Insert_F").trim() );
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
/*=====================================================================================================*/
%>
<%!
	public String selDeptName(String str) {
		String sReturnStr = "";

		if(str.equals("S") ) {
			sReturnStr = "서울";
		} else if(str.equals("K")) {
			sReturnStr = "대구";
		} else if(str.equals("J")) {
			sReturnStr = "대전";
		} else if(str.equals("G")) {
			sReturnStr = "광주";
		} else if(str.equals("B") ) {
			sReturnStr = "부산";
		} else {
			sReturnStr = "본부";
		}

		return sReturnStr ;
	}

	public String selCorrectGB(String str) {
		String sReturnStr="";
		if( str.equals("20") ) {
			sReturnStr = "비대금";
		} else if( str.equals("21") ) {
			sReturnStr = "대금";
		} else if( str.equals("1") ) {
			sReturnStr = "미제출";
		} else if( str.equals("3") ) {
			sReturnStr = "하도급부인";
		} else if( str.equals("5") ) {
			sReturnStr = "미제출(2)";
		} else if( str.equals("6") ) {
			sReturnStr = "불인정";
		} else if( str.equals("7") ) {
			sReturnStr = "미시정";
		} else {
			sReturnStr = "정보없음";
		}

		return sReturnStr ;
	}
%>
<html>
<head>
	<title>시정조치 검색내역</title>
	<meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=euc-kr" />
</head>

<body>
	<table class="resultTable">
		<tr>
			<th>년도</th>
			<th>조치구분</th>
			<th>업종</th>
			<th>관리번호</th>
			<th>회사명</th>
			<th>대표자명</th>
			<th>작성자</th>
			<th>조사담당</th>
			<th>등기번호</th>
			<th>시정조치</th>
		</tr>
	<%if( arrMngNo.size()>0 ) {
		for(int j=0; j<arrMngNo.size(); j++) {%>
		<tr>
			<td><%=arrCYear.get(j)%></td>
<%
sTmpStr1 = arrSurveyGB.get(j)+"";
if( sTmpStr1.equals("2") ) {
	sTmpStr1 = arrSurveyMoneyGB.get(j)+"";
	if( sTmpStr1.equals("1") ) {
		sTmpStr1 = "21";
	} else {
		sTmpStr1 = "20";
	}
} else {
	sTmpStr1 = arrSurveyGB.get(j)+"";
}
sTmpStr1 = "<font style='color:#FF9933;'>"+selCorrectGB(sTmpStr1)+"</font>";
%>
			<td><%=sTmpStr1%></td>
			<td><%if( arrOentGB.get(j).equals("3") ) {%>용역
				<%} else if( arrOentGB.get(j).equals("2") ) {%>건설
				<%} else {%>제조<%}%>
			</td>
			<td><%=arrMngNo.get(j)%></td>
			<td><%=arrOentName.get(j)%></td>
			<td><%=arrOentCaptine.get(j)%></td>
			<td><%=arrWriterName.get(j)%>&nbsp;
				T)<%=arrWriterTel.get(j)%>&nbsp;
				F)<%=arrWriterFax.get(j)%>
			</td>
			<td><%=arrDamCenter.get(j)%>&nbsp;
				<%=arrDeptName.get(j)%>&nbsp;
				<%=arrUserName.get(j)%>
			</td>
			<td><%=arrPostNo3.get(j)%>&nbsp;
				<%=arrPostNo4.get(j)%>
			</td>
			<td><%if( arrInsertF.get(j).equals("1") ) {%>
					<font style="color:#FF9933;">입력</font>
				<%} else {%>
					<font style="color:#FF0000;">미입력</font>
				<%}%>
			</td>
		</tr>
	<%
		}
	} else {%>
		<tr>
			<td colspan="9" class="noneResultset">검색 결과가 없습니다</td>
		</tr>
	<%
	}
	%>
	</table>
</div>
</body>
</html>