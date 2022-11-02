<%@ page session="true" language="java" contentType="application/vnd.ms-excel; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명	: Oent_Search.jsp
* 프로그램설명	: 원사업자 검색결과 엑셀 내보내기
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2009년 05월
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2009-05-00	정광식       최초작성
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
	ArrayList arrConnCode = new ArrayList();
	ArrayList arrOentZipCode = new ArrayList();
	ArrayList arrOentAddress = new ArrayList();
	ArrayList arrCompStatus = new ArrayList();
	ArrayList arrOentReturnGB = new ArrayList();
	ArrayList arrOentReSend = new ArrayList();
	ArrayList arrOentTel = new ArrayList();
	ArrayList arrOentFax = new ArrayList();
	ArrayList arrWriterName = new ArrayList();
	ArrayList arrWriterTel = new ArrayList();
	ArrayList arrWriterFax = new ArrayList();
	ArrayList arrOentSale01 = new ArrayList();
	ArrayList arrOentSale02 = new ArrayList();
	ArrayList arrEmpCnt = new ArrayList();
	ArrayList arrSubconCnt = new ArrayList();
	ArrayList arrOentConAmt = new ArrayList();
	ArrayList arrOentStatus = new ArrayList();
	ArrayList arrAddrStatus = new ArrayList();
	ArrayList arrPostNo1 = new ArrayList();
	ArrayList arrPostNo2 = new ArrayList();
	ArrayList arrPostNo3 = new ArrayList();
	ArrayList arrPostNo4 = new ArrayList();
	ArrayList arrPostNo5 = new ArrayList();
	// 담당조사관정보추가 // 20100503 / 정광식
	ArrayList arrDamCenter = new ArrayList();
	ArrayList arrUserName = new ArrayList();
	ArrayList arrDeptName = new ArrayList();
	ArrayList arrCVSNo = new ArrayList();

	// 제조 업종배열
	ArrayList arrDCode = new ArrayList();
	ArrayList arrDName = new ArrayList();
	// 건설 업종배열
	ArrayList arrCCode = new ArrayList();
	ArrayList arrCName = new ArrayList();
	// 용역 업종배열
	ArrayList arrSrvCode = new ArrayList();
	ArrayList arrSrvName = new ArrayList();
	// 담당자 배열
	ArrayList arrDeptSeq = new ArrayList();
	ArrayList arrDeptCode = new ArrayList();
	ArrayList arrDamName = new ArrayList();

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
	if( sTComm.equals("start") ) {
		session.setAttribute("cyear", st_Current_Year);
		session.setAttribute("wgb", "");
		session.setAttribute("sgb", "");
		session.setAttribute("scomp", "");
		session.setAttribute("ssort", "1");
		session.setAttribute("cstatus", "");
		session.setAttribute("astatus", "");
		session.setAttribute("returngb", "");
		session.setAttribute("ostatus", "");
		session.setAttribute("csid", "");
		session.setAttribute("ceid", "");
		session.setAttribute("local", "");
		session.setAttribute("stype", "");
		session.setAttribute("olast", "");
		session.setAttribute("oareacode", "");
		session.setAttribute("odeptname", "");
		session.setAttribute("unitid", "");
		session.setAttribute("pagecnt", "10");
		session.setAttribute("page", "1");
	}

	/*
	if( sComm.equals("search") ) {
		session.setAttribute("cyear", request.getParameter("cyear")==null ? "":request.getParameter("cyear").trim() );
		session.setAttribute("sgb",request.getParameter("sgb")==null ? "":request.getParameter("sgb").trim() );
		session.setAttribute("wgb",request.getParameter("wgb")==null ? "":request.getParameter("wgb").trim() );
		session.setAttribute("scomp",request.getParameter("scomp")==null ? "":request.getParameter("scomp").trim() );
		session.setAttribute("ssort",request.getParameter("ssort")==null ? "":request.getParameter("ssort").trim() );
		session.setAttribute("cstatus",request.getParameter("cstatus")==null ? "":request.getParameter("cstatus").trim() );
		session.setAttribute("astatus",request.getParameter("astatus")==null ? "":request.getParameter("astatus").trim() );
		session.setAttribute("returngb",request.getParameter("returngb")==null ? "":request.getParameter("returngb").trim() );
		session.setAttribute("ostatus",request.getParameter("ostatus")==null ? "":request.getParameter("ostatus").trim() );
		session.setAttribute("csid",request.getParameter("csid")==null ? "":request.getParameter("csid").trim() );
		session.setAttribute("ceid",request.getParameter("ceid")==null ? "":request.getParameter("ceid").trim() );
		session.setAttribute("local",request.getParameter("local")==null ? "":request.getParameter("local").trim() );
		session.setAttribute("stype",request.getParameter("stype")==null ? "":request.getParameter("stype").trim() );
		session.setAttribute("olast",request.getParameter("mlast")==null ? "":request.getParameter("mlast").trim() );
		session.setAttribute("oareacode",request.getParameter("mareacode")==null ? "":request.getParameter("mareacode").trim() );
		session.setAttribute("odeptname",request.getParameter("mdeptname")==null ? "":request.getParameter("mdeptname").trim() );
		session.setAttribute("unitid",request.getParameter("unitid")==null ? "":request.getParameter("unitid").trim() );
		session.setAttribute("pagecnt",request.getParameter("mpagesize")==null ? "":request.getParameter("mpagesize").trim() );
		session.setAttribute("page", request.getParameter("page")==null ? "":request.getParameter("page").trim() );
	}
	*/
	if( !session.getAttribute("cyear").equals("") ) {
		currentYear = Integer.parseInt(session.getAttribute("cyear").toString());
	} else {
		currentYear = 0;
	}

	sSQLs2 = "SELECT * FROM (\n";
	sSQLs2 += "SELECT TT.*, FLOOR((ROWNUM - 1) / "+ nPageSize + " + 1) PAGE FROM (\n";

	sTmpStr=session.getAttribute("cyear").toString();

	// 2012년도 별도 테이블 생성으로 조건 변경 - 정광식
	if(currentYear >= 2019) {
		sSQLs1 += "SELECT COUNT(*) RECCNT FROM HADO_VT_OENT_"+sTmpStr+" \n";
		sSQLs = "SELECT * FROM HADO_VT_OENT_"+sTmpStr+" \n";
	}
	else if( currentYear==2016 ) {
		sSQLs1 += "SELECT COUNT(*) RECCNT FROM HADO_VT_OENT_2016 \n";
		sSQLs = "SELECT * FROM HADO_VT_OENT_2016 \n";
	} else if( currentYear==2015 ) {
		sSQLs1 += "SELECT COUNT(*) RECCNT FROM HADO_VT_OENT_2015 \n";
		sSQLs = "SELECT * FROM HADO_VT_OENT_2015 \n";
	} else if( currentYear==2014 ) {
		sSQLs1 += "SELECT COUNT(*) RECCNT FROM HADO_VT_OENT_2014 \n";
		sSQLs = "SELECT * FROM HADO_VT_OENT_2014 \n";
	} else if( currentYear==2013 ) {
		sSQLs1 += "SELECT COUNT(*) RECCNT FROM HADO_VT_OENT_2013 \n";
		sSQLs = "SELECT * FROM HADO_VT_OENT_2013 \n";
	} else if( currentYear==2012 ) {
		sSQLs1 += "SELECT COUNT(*) RECCNT FROM HADO_VT_OENT_2012 \n";
		sSQLs = "SELECT * FROM HADO_VT_OENT_2012 \n";
	} else if( (currentYear>=2010) ) {
		sSQLs1 += "SELECT COUNT(*) RECCNT FROM HADO_VT_OENT_2010 \n";
		sSQLs = "SELECT * FROM HADO_VT_OENT_2010 \n";
	} else {
		sSQLs1 += "SELECT COUNT(*) RECCNT FROM HADO_VT_OENT \n";
		sSQLs = "SELECT * FROM HADO_VT_OENT \n";
	}

	sSQLWhere = "";
	if( !session.getAttribute("wgb").equals("") ) {
		sSQLWhere += " AND OENT_GB = '" + session.getAttribute("wgb") + "' \n";
	} else {
		if( currentYear>=2010 ) {
			sSQLWhere += " AND (OENT_GB = '1' OR Oent_GB='2' OR OENT_GB = '3') \n";
			sSQLWhere += " AND LENGTH(MNG_NO) >6 \n";
			sSQLWhere += " AND MNG_NO NOT LIKE 'HE%' \n";
		} else {
			if( currentYear>=2006 ) {
				sSQLWhere += " AND (OENT_GB = '1' OR OENT_GB = '3') \n";
			}
		}
	}
	if( !session.getAttribute("sgb").equals("") ) {
		sSQLWhere += " AND OENT_TYPE = '" + session.getAttribute("sgb") + "' \n";
	}
	if( !session.getAttribute("scomp").equals("") ) {
		sSQLWhere += " AND REPLACE(OENT_NAME,' ','') LIKE '%" + session.getAttribute("scomp") + "%' \n";
	}
	if( !session.getAttribute("cstatus").equals("") ) {
		sSQLWhere += " AND COMP_STATUS = '" + session.getAttribute("cstatus") + "' \n";
	}
	if( !session.getAttribute("astatus").equals("") ) {
		sSQLWhere += " AND ADDR_STATUS = '" + session.getAttribute("astatus") + "' \n";
	}		
	if( !session.getAttribute("returngb").equals("") ) {
		sSQLWhere += " AND RETURN_GB = '" + session.getAttribute("returngb") + "' \n";
	}
	//2018.06.18 김보선 재발송 검색 추가
	if( !session.getAttribute("resend").equals("") ) {
		sSQLWhere += " AND RE_SEND = '" + session.getAttribute("resend") + "' \n";
	}
	if( !session.getAttribute("ostatus").equals("") ) {
		if( session.getAttribute("ostatus").equals("0") ) {
			sSQLWhere += " AND (CASE WHEN OENT_STATUS = '1' THEN '1' ELSE '0' END) = '0' \n";
			sSQLWhere += " AND (CASE WHEN ADDR_STATUS = '1' OR ADDR_STATUS = '2' OR ADDR_STATUS = '3' OR ADDR_STATUS = '9' OR ADDR_STATUS = '8' THEN ADDR_STATUS ELSE '0' END) = '0' \n";
		} else if( session.getAttribute("ostatus").equals("2") ) {
			sSQLWhere += " AND (CASE WHEN OENT_STATUS = '1' THEN '1' ELSE '0' END) = '1' \n";
			sSQLWhere += " AND (CASE ADDR_STATUS WHEN '2' THEN '1' ELSE '0' END) = '0' \n";
		} else if( session.getAttribute("ostatus").equals("3") ) {
			sSQLWhere += " AND (CASE WHEN OENT_STATUS = '1' THEN '1' ELSE '0' END) = '0' \n";
		} else {
			sSQLWhere += " AND (CASE OENT_STATUS WHEN '1' THEN '1' ELSE '0' END) = '" + session.getAttribute("ostatus") + "' \n";
		}
	}
	if( !session.getAttribute("csid").equals("") ) {
		String tmpStr = session.getAttribute("csid") + "";
		sSQLWhere += " AND MNG_NO >= '" + tmpStr.toUpperCase() + "' \n";
	}
	if( !session.getAttribute("ceid").equals("") ) {
		String tmpStr = session.getAttribute("ceid") + "";
		sSQLWhere += " AND MNG_NO <= '" + tmpStr.toUpperCase() + "' \n";
	}
	if( !session.getAttribute("unitid").equals("") ) {
		String tmpStr = session.getAttribute("unitid")+"";
		sSQLWhere += " AND MNG_NO = '" + tmpStr.toUpperCase() + "' \n";
	}
	if( !session.getAttribute("stype").equals("") ) {
		sSQLWhere += " AND SUBCON_TYPE = '" + session.getAttribute("stype") + "' \n";
	}

	String sTmpLocal = (String)session.getAttribute("local");

	if( sTmpLocal != null && (!sTmpLocal.equals("")) ) {
		switch( Integer.parseInt(sTmpLocal) ) {
			case 0 :
				sSQLWhere = sSQLWhere;
				break;
			case 1 :
				sTmpStr1 = "강원";
				sSQLWhere += " AND OENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
				break;
			case 2 :
				sTmpStr1 = "경기";
				sSQLWhere += " AND OENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
				break;
			case 3 :
				sTmpStr1 = "경상남도";
				sTmpStr2 = "경남";
				sSQLWhere += " AND (OENT_ADDRESS LIKE '%"+sTmpStr1+"%' OR OENT_ADDRESS LIKE '%"+sTmpStr2+"%') \n";
				break;
			case 4 :
				sTmpStr1 = "경상북도";
				sTmpStr2 = "경북";
				sSQLWhere += " AND (OENT_ADDRESS LIKE '%"+sTmpStr1+"%' OR OENT_ADDRESS LIKE '%"+sTmpStr2+"%') \n";
				break;
			case 5 :
				sTmpStr1 = "광주";
				sSQLWhere += " AND OENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
				break;
			case 6 :
				sTmpStr1 = "대구";
				sSQLWhere += " AND OENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
				break;
			case 7 :
				sTmpStr1 = "대전";
				sSQLWhere += " AND OENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
				break;
			case 8 :
				sTmpStr1 = "부산";
				sSQLWhere += " AND OENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
				break;
			case 9 :
				sTmpStr1 = "서울";
				sSQLWhere += " AND OENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
				break;
			case 10 :
				sTmpStr1 = "울산";
				sSQLWhere += " AND OENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
				break;
			case 11 :
				sTmpStr1 = "인천";
				sSQLWhere += " AND OENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
				break;
			case 12 :
				sTmpStr1 = "전라남도";
				sTmpStr2 = "전남";
				sSQLWhere += " AND (OENT_ADDRESS LIKE '%"+sTmpStr1+"%' OR OENT_ADDRESS LIKE '%"+sTmpStr2+"%') \n";
				break;
			case 13 :
				sTmpStr1 = "전라북도";
				sTmpStr2 = "전북";
				sSQLWhere += " AND (OENT_ADDRESS LIKE '%"+sTmpStr1+"%' OR OENT_ADDRESS LIKE '%"+sTmpStr2+"%') \n";
				break;
			case 14 :
				sTmpStr1 = "제주";
				sSQLWhere += " AND OENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
				break;
			case 15 : 
				sTmpStr1 = "충청남도";
				sTmpStr2 = "충남";
				sSQLWhere += " AND (OENT_ADDRESS LIKE '%"+sTmpStr1+"%' OR OENT_ADDRESS LIKE '%"+sTmpStr2+"%') \n";
				break;
			case 16 :
				sTmpStr1 = "충청북도";
				sTmpStr2 = "충북";
				sSQLWhere += " AND (OENT_ADDRESS LIKE '%"+sTmpStr1+"%' OR OENT_ADDRESS LIKE '%"+sTmpStr2+"%') \n";
				break;
		}
	}
	if( !session.getAttribute("olast").equals("") ) {
		sSQLWhere += " AND SUBSTR(MNG_NO,-1) = '" + session.getAttribute("olast") + "' \n";
	}
	if( !session.getAttribute("oareacode").equals("") ) {
		sTmpStr1 = selDeptName( session.getAttribute("oareacode").toString() );
		sSQLWhere += " AND Center_Name LIKE '" + sTmpStr1 + "%' \n";
		
		String areaCode = session.getAttribute("oareacode").toString();
		if(areaCode.length() == 2) {
			//if(areaCode.indexOf("H") > -1) sSQLWhere += " AND Center_Name LIKE '본부%' \n";
			if("H1".equals(areaCode)) sSQLWhere += " AND DEPT_NAME LIKE '기업%' \n";
			if("H2".equals(areaCode)) sSQLWhere += " AND DEPT_NAME LIKE '제조%' \n";
			if("H3".equals(areaCode)) sSQLWhere += " AND DEPT_NAME LIKE '건설%' \n";
			
			//if(areaCode.indexOf("S") > -1) sSQLWhere += " AND Center_Name LIKE '서울%' \n";
			if("S1".equals(areaCode)) sSQLWhere += " AND DEPT_NAME LIKE '건설%' \n";
			if("S2".equals(areaCode)) sSQLWhere += " AND DEPT_NAME LIKE '제조%' \n";
		}
	}

	// 2010년 담당자 세팅 방법 변경 (HADO_TB_DEPT_HISTORY)
	if( currentYear>=2010) {
		if( !session.getAttribute("odeptname").equals("") ) {
			sSQLWhere += " AND CVSNO = '" + session.getAttribute("odeptname") + "' \n";
		}
	} else {
		if( !session.getAttribute("odeptname").equals("") ) {
			sSQLWhere += " AND DEPT_SEQ = " + session.getAttribute("odeptname") + " \n";
		}
	}
	// 예시데이타는 관리번호 뒤에 1234567 삽입했음 (예외처리 필요)
	//sSQLs1 += " WHERE SUBSTR(MNG_NO,-7) <> '1234567'";
	sSQLs += " WHERE MNG_NO IS NOT NULL \n";
	if( currentYear > 0 ) {
		sSQLs += " AND CURRENT_YEAR = '" + currentYear + "' \n";
	}
	sSQLs =  sSQLs + sSQLWhere;

	if( session.getAttribute("ssort").equals("1") ) {
		sSQLs += " ORDER BY REPLACE(OENT_NAME,'(','') \n";
	}
	if( session.getAttribute("ssort").equals("2") ) {
		sSQLs += " ORDER BY OENT_ASSETS DESC \n";
	}
	if( session.getAttribute("ssort").equals("3") ) {
		sSQLs += " ORDER BY OENT_SALE02 DESC \n";
	}
	if( session.getAttribute("ssort").equals("4") ) {
		sSQLs += " ORDER BY MNG_NO \n";
	}
	if( session.getAttribute("ssort").equals("") && currentYear==0 ) {
		sSQLs += " ORDER BY Current_Year \n";
	}

	// 전체 페이지 계산을 위해 레코드 카운트
	//sSQLs1 += " WHERE SUBSTR(MNG_NO,-7) <> '1234567'";
	sSQLs1 += " WHERE MNG_NO IS NOT NULL \n";
	if( currentYear > 0 ) {
		sSQLs1 += " AND CURRENT_YEAR = '" + currentYear + "' " + sSQLWhere + " \n";
	}
	// 페이징 처리한 쿼리문
	sSQLs2 = sSQLs2 + sSQLs + ") TT ) \n";
	//sSQLs2 += "WHERE PAGE = " + nPage + " \n";
	//System.out.println(sSQLs1);
	
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		
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
		
		pstmt = conn.prepareStatement(sSQLs2);
		rs = pstmt.executeQuery();	

		//System.out.println(sSQLs2);

		while ( rs.next()) {
			arrMngNo.add( rs.getString("MNG_NO")==null ? "":rs.getString("MNG_NO").trim() );
			arrCYear.add( rs.getString("Current_Year")==null ? "":rs.getString("Current_Year").trim() );
			arrOentGB.add( rs.getString("OENT_GB")==null ? "":rs.getString("OENT_GB").trim() );
			arrOentName.add( rs.getString("OENT_NAME")==null ? "":rs.getString("OENT_NAME").trim() );
			arrOentCaptine.add( rs.getString("OENT_CAPTINE")==null ? "":rs.getString("OENT_CAPTINE").trim() );
			arrOentZipCode.add( rs.getString("ZIP_CODE")==null ? "":rs.getString("ZIP_CODE").trim() );
			String sTmpAddress = "";
			sTmpAddress = rs.getString("OENT_ADDRESS")==null ? "":rs.getString("OENT_ADDRESS").trim() ;
			if( sTmpAddress!=null) sTmpAddress=sTmpAddress.replaceAll("\r\n"," ");
			arrOentAddress.add( sTmpAddress );

			arrOentTel.add( rs.getString("OENT_TEL")==null ? "":rs.getString("OENT_TEL").trim() );
			arrOentFax.add( rs.getString("OENT_FAX")==null ? "":rs.getString("OENT_FAX").trim() );
			if( rs.getString("OENT_SALE01") != null && (!rs.getString("OENT_SALE01").equals("")) ) {
				arrOentSale01.add( rs.getString("OENT_SALE01").trim() );
			} else {
				arrOentSale01.add("0");
			}
			if( rs.getString("OENT_SALE02") != null && (!rs.getString("OENT_SALE02").equals("")) ) {
				arrOentSale02.add( rs.getString("OENT_SALE02").trim() );
			} else {
				arrOentSale02.add("0");
			}
			if( rs.getString("OENT_CON_AMT") != null && (!rs.getString("OENT_CON_AMT").equals("")) ) {
				arrOentConAmt.add( rs.getString("OENT_CON_AMT").trim() );
			} else {
				arrOentConAmt.add("0");
			}
			if( rs.getString("OENT_EMP_CNT") != null && (!rs.getString("OENT_EMP_CNT").equals("")) ) {
				arrEmpCnt.add( rs.getString("OENT_EMP_CNT").trim() );
			} else {
				arrEmpCnt.add("0");
			}
			arrWriterName.add( rs.getString("WRITER_NAME")==null ? "":rs.getString("WRITER_NAME").trim() );
			arrWriterTel.add( rs.getString("WRITER_TEL")==null ? "":rs.getString("WRITER_TEL").trim() );
			arrWriterFax.add( rs.getString("WRITER_FAX")==null ? "":rs.getString("WRITER_FAX").trim() );
			arrOentReturnGB.add( rs.getString("RETURN_GB")==null ? "":rs.getString("RETURN_GB").trim() );
			arrOentReSend.add( rs.getString("RE_SEND")==null ? "":rs.getString("RE_SEND").trim() );
			arrCompStatus.add( rs.getString("COMP_STATUS")==null ? "":rs.getString("COMP_STATUS").trim() );
			if( rs.getString("SUBCON_CNT") != null && (!rs.getString("SUBCON_CNT").equals("")) ) {
				arrSubconCnt.add( rs.getString("SUBCON_CNT").trim() );
			} else {
				arrSubconCnt.add("0");
			}
			arrOentStatus.add( rs.getString("OENT_STATUS")==null ? "":rs.getString("OENT_STATUS").trim() );
			arrAddrStatus.add( rs.getString("ADDR_STATUS")==null ? "":rs.getString("ADDR_STATUS").trim() );
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
			arrConnCode.add( rs.getString("CONN_CODE")==null ? "":rs.getString("CONN_CODE").trim() );
			arrPostNo1.add( rs.getString("POST_NO_01")==null ? "":rs.getString("POST_NO_01").trim() );
			arrPostNo2.add( rs.getString("POST_NO_02")==null ? "":rs.getString("POST_NO_02").trim() );
			arrPostNo3.add( rs.getString("POST_NO_03")==null ? "":rs.getString("POST_NO_03").trim() );
			arrPostNo4.add( rs.getString("POST_NO_04")==null ? "":rs.getString("POST_NO_04").trim() );
			arrPostNo5.add( rs.getString("POST_NO_05")==null ? "":rs.getString("POST_NO_05").trim() );
		}
		rs.close();
	} catch(Exception e) {
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

	if(str.equals("S1") || str.equals("S2")) {
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
public String statusf_2021(String str){
	String sReturnStr = "";
	
	if(str!= null && str.equals("1")){
		sReturnStr="정상영업";
	} else if(str!= null && str.equals("3")){
		sReturnStr="기업회생 절차 진행 중";
	} else if(str!= null && str.equals("4")){
		sReturnStr="영업중단 중 또는 폐업준비 중";
	} else if(str!= null && str.equals("5")){
		sReturnStr="다른 회사와 합병 진행 중";
	} else if(str!= null && str.equals("6")){
		sReturnStr="기타";
	}else{
		sReturnStr="&nbsp;";
	}	
	return sReturnStr;
}
%>
<html>
<head>
	<title>시정조치 검색내역</title>
	<meta charset="utf-8">
	<meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=utf-8" />
</head>

<body>
	<table border="1">
		<tr>
			<th>조사년도</th>
			<th>업종</th>
			<th>관리번호</th>
			<th>접속코드</th>
			<th>회사명</th>
			<th>대표자명</th>
			<th>소재지</th>
			<th>배정사무소</th>
			<th>영업상태</th>
			<th>소재불명여부</th>
			<th>전송여부</th>
		</tr>
	<%if( arrMngNo.size()>0 ) {
		for(int j=0; j<arrMngNo.size(); j++) {%>
		<tr>
			<td><%=arrCYear.get(j)%></td>
			<td><%if( arrOentGB.get(j).equals("3") ) {%>용역
				<%} else if( arrOentGB.get(j).equals("2") ) {%>건설
				<%} else {%>제조<%}%></td>
			<td><%=arrMngNo.get(j)%></td>
			<td><%=arrConnCode.get(j)%></td>
			<td><%=arrOentName.get(j)%></td>
			<td><%=arrOentCaptine.get(j)%></td>
			<td>(<%=arrOentZipCode.get(j)%>) <%=arrOentAddress.get(j)%> [<%=arrOentTel.get(j)%>]</td>
			<td><%=arrDamCenter.get(j)%></td>
			<%
			if( currentYear == 2021 ) {
			%>
			<td><%=statusf_2021((String)arrCompStatus.get(j))%>&nbsp;</td>
			<%
			} else {
			%>
			<td><%if( arrCompStatus.get(j).equals("3") && arrCYear.get(j).equals("2010") ) { out.print("회생절차 진행중"); } else {%><%=StringUtil.statusf((String)arrCompStatus.get(j))%><%}%>&nbsp;</td>
			<%
			}
			%>
			<td><%if( arrAddrStatus.get(j).equals("1") ) { out.print("소재불명");} 
			else if( arrAddrStatus.get(j).equals("8") ) { out.print("조사면제");} 
			else if( arrAddrStatus.get(j).equals("9") ) { out.print("해당년도 조사중복");} 
			else {%><%=StringUtil.astatusf((String)arrAddrStatus.get(j))%><%}%>&nbsp;</td>
			<td><%=StringUtil.ostatusf((String)arrOentStatus.get(j))%>&nbsp;</td>
		</tr>
	<%
		}
	} else {%>
		<tr>
			<td colspan="10" class="noneResultset">검색 결과가 없습니다</td>
		</tr>
	<%
	}
	%>
	</table>

</body>
</html>