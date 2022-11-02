<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명	: SOent_Search.jsp
* 프로그램설명	: 수급사업자 > 제출현황 > 조사대상 업체
* 프로그램버전	: 3.1.1
* 최초작성일자	: 2009년 05월
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-24	정광식       최초작성
*   2015-07-22   정광식		조사제외대상 처리방법 변경 적용 (SP_FLD_03 필드에 제외사유)
*	2016-01-18	이용광		DB변경으로 인한 인코딩 변경
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

	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	int currentYear = st_Current_Year_n;
	currentYear = session.getAttribute("cyear") != null ? Integer.parseInt(session.getAttribute("cyear")+"") : 2013;

	String vTableName = "";

	String sSQLWhere = "";
	String sSQLs = "";
	String sSQLs1 = "";
	String sSQLs2 = "";

	String sTmpStr1="";
	String sTmpStr2="";

	String sErrorMsg = "";
	String sReturnURL = "";
	String stmpStr = "";

	int sStartYear = 2000;

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
		session.setAttribute("ssort", "1");
		session.setAttribute("astatus", "");
		session.setAttribute("ostatus", "");
		session.setAttribute("returngb", "");
		session.setAttribute("csid", "");
		session.setAttribute("ceid", "");
		session.setAttribute("olast", "");
		session.setAttribute("local", "");
		session.setAttribute("ctid", "");
		session.setAttribute("ctoid", "");
		session.setAttribute("pagecnt", "20");
		session.setAttribute("page", "1");
		session.setAttribute("selgb", "1");
		session.setAttribute("oareacode", "");
		session.setAttribute("odeptname", "");
	}

	if( sComm.equals("search") ) {
		session.setAttribute("cyear", StringUtil.checkNull(request.getParameter("cyear")).trim());
		session.setAttribute("ocomp",StringUtil.checkNull(request.getParameter("ocomp")).trim());
		session.setAttribute("wgb",StringUtil.checkNull(request.getParameter("wgb")).trim());
		session.setAttribute("sgb",StringUtil.checkNull(request.getParameter("sgb")).trim());
		session.setAttribute("scomp",StringUtil.checkNull(request.getParameter("scomp")).trim());
		session.setAttribute("ssort",StringUtil.checkNull(request.getParameter("ssort")).trim());
		session.setAttribute("ostatus",StringUtil.checkNull(request.getParameter("ostatus")).trim());
		session.setAttribute("astatus",StringUtil.checkNull(request.getParameter("astatus")).trim());
		session.setAttribute("returngb",StringUtil.checkNull(request.getParameter("returngb")).trim());
		session.setAttribute("csid",StringUtil.checkNull(request.getParameter("csid")).trim());
		session.setAttribute("ceid",StringUtil.checkNull(request.getParameter("ceid")).trim());
		session.setAttribute("olast",StringUtil.checkNull(request.getParameter("mlast")).trim());
		session.setAttribute("local",StringUtil.checkNull(request.getParameter("local")).trim());
		session.setAttribute("ctid",StringUtil.checkNull(request.getParameter("unitid")).trim());
		session.setAttribute("ctoid",StringUtil.checkNull(request.getParameter("unitoid")).trim());
		session.setAttribute("pagecnt", StringUtil.checkNull(request.getParameter("mpagesize")).trim());
		session.setAttribute("page", StringUtil.checkNull(request.getParameter("page")).trim());
		session.setAttribute("selgb", StringUtil.checkNull(request.getParameter("mselgb")).trim());
		session.setAttribute("oareacode",StringUtil.checkNull(request.getParameter("mareacode")).trim());
		session.setAttribute("odeptname",StringUtil.checkNull(request.getParameter("mdeptname")).trim());
	}

	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();

		if( !sTmpCmd.equals("start") ) {
			if( !session.getAttribute("cyear").equals("0") ) {
				vTableName = "HADO_VT_SOent_"+session.getAttribute("cyear");
			} else {
				vTableName = "HADO_VT_SOent";
			}

			sSQLs2 ="SELECT * FROM ( \n";
			sSQLs2+="SELECT TT.*, FLOOR((ROWNUM - 1) / "+ nPageSize + " + 1) PAGE FROM ( \n";

			sSQLs1+="SELECT COUNT(*) RECCNT \n";
			sSQLs1+="FROM "+vTableName+" \n";

			sSQLs ="SELECT * \n";
			sSQLs+="FROM "+vTableName+" \n";

			sSQLWhere = "";
			if( !session.getAttribute("wgb").equals("") ) {
				sSQLWhere+="	AND OENT_GB='"+session.getAttribute("wgb")+"' \n";
			}
			if( !session.getAttribute("sgb").equals("") ) {
				sSQLWhere+="	AND OENT_TYPE='"+session.getAttribute("sgb")+"' \n";
			}
			if( !session.getAttribute("scomp").equals("") ) {
				sSQLWhere+="	AND REPLACE(SENT_NAME,' ','') LIKE '%"+session.getAttribute("scomp")+"%' \n";
			}
			if( !session.getAttribute("ocomp").equals("") ) {
				sSQLWhere+="	AND REPLACE(OENT_NAME,' ','') LIKE '%"+session.getAttribute("ocomp")+"%' \n";
			}
			if( !session.getAttribute("returngb").equals("") ) {
				sSQLWhere+="	AND RETURN_GB='"+session.getAttribute("returngb")+"' \n";
			}
			if( !session.getAttribute("ostatus").equals("") ) {
				if( session.getAttribute("ostatus").equals("0") ) {
					sSQLWhere+="	AND (CASE WHEN SENT_STATUS='1' THEN '1' ELSE '0' END)='0' \n";
					sSQLWhere+="	AND (CASE WHEN ADDR_STATUS = '1' OR ADDR_STATUS = '2' OR ADDR_STATUS = '3' OR ADDR_STATUS = '9' OR ADDR_STATUS = '8' THEN ADDR_STATUS ELSE '0' END)='0' \n";
				} else if( session.getAttribute("ostatus").equals("2") ) {
					sSQLWhere+="	AND (CASE WHEN SENT_STATUS = '1' THEN '1' ELSE '0' END)='1' \n";
					sSQLWhere+="	AND (CASE ADDR_STATUS WHEN '2' THEN '1' ELSE '0' END)='0' \n";
				} else {
					sSQLWhere+="	AND (CASE SENT_STATUS WHEN '1' THEN '1' ELSE '0' END)='"+session.getAttribute("ostatus")+"' \n";
				}
			}
			if( !session.getAttribute("csid").equals("") ) {
				// 검색기능 보정 : Index Field 추가 :: 20100809 :: 정광식
				stmpStr = session.getAttribute("csid")+"";
				if( Integer.parseInt(session.getAttribute("cyear")+"")>=2012 ) {
					sSQLWhere+="	AND MNG_NO>='"+stmpStr.substring(0,8)+"' \n";
				} else if( Integer.parseInt(session.getAttribute("cyear")+"")>2010 ) {
					sSQLWhere+="	AND MNG_NO>='"+stmpStr.substring(0,9)+"' \n";
				} else {
					sSQLWhere+="	AND MNG_NO>='"+stmpStr.substring(0,10)+"' \n";
				}
				sSQLWhere+="	AND CHILD_MNG_NO>='"+stmpStr+"' \n";
			}
			if( !session.getAttribute("ceid").equals("") ) {
				// 검색기능 보정 : Index Field 추가 :: 20100809 :: 정광식
				stmpStr = session.getAttribute("ceid")+"";
				if ( Integer.parseInt(session.getAttribute("cyear")+"")>=2012 ) {
					sSQLWhere+="	AND MNG_NO>='"+stmpStr.substring(0,8)+"' \n";
				} else if( Integer.parseInt(session.getAttribute("cyear")+"")>2010 ) {
					sSQLWhere+="	AND MNG_NO>='"+stmpStr.substring(0,9)+"' \n";
				} else {
					sSQLWhere+="	AND MNG_NO>='"+stmpStr.substring(0,10)+"' \n";
				}
				sSQLWhere+="	AND CHILD_MNG_NO<='"+stmpStr+"' \n";
			}
			if( !session.getAttribute("ctid").equals("") ) {
				// 검색기능 보정 : Index Field 추가 :: 20100809 :: 정광식
				stmpStr = session.getAttribute("ctid")+"";
				if ( Integer.parseInt(session.getAttribute("cyear")+"")>=2012 ) {
					sSQLWhere+="	AND MNG_NO='"+stmpStr.substring(0,8)+"' \n";
				} else if ( Integer.parseInt(session.getAttribute("cyear")+"")>2010 ) {
					sSQLWhere+="	AND MNG_NO='"+stmpStr.substring(0,9)+"' \n";
				} else {
					sSQLWhere+="	AND MNG_NO='"+stmpStr.substring(0,10)+"' \n";
				}
				sSQLWhere+="	AND CHILD_MNG_NO='"+stmpStr+"' \n";
			}
			if( !session.getAttribute("ctoid").equals("") ) {
				sSQLWhere+="	AND MNG_NO='"+session.getAttribute("ctoid")+"' \n";
			}
			if( !session.getAttribute("selgb").equals("") ) {
				sSQLWhere+="	AND SEL_GB='"+session.getAttribute("selgb")+"' \n";
			}
			if( !session.getAttribute("astatus").equals("") ) {
				if( currentYear >= 2015 ) {
					/* 2015년도 조사제외대상 사유 기록시작 : SP_FLD_03
					* SP_FLD_03 = = '1' : 가. 귀사가 "하도급법상의 수급사업자" 요건에 해당되지 않는 경우
					* SP_FLD_03 = = '2' : 나. 하도급거래가 아닌 경우
					* SP_FLD_03 = = '3' : 다. 귀사가 하도급을 주기만 하는 경우
					* SP_FLD_03 = = '4' : 라. 하도급을 주지도 받지도 않는 경우(하도급거래 없음)
					*/
					sSQLWhere+="	AND (Addr_Status='"+session.getAttribute("astatus")+"' \n";
					if( session.getAttribute("astatus").equals("3") ) {
						sSQLWhere+="	OR sp_fld_03='1') \n";
					} else if( session.getAttribute("astatus").equals("2") )  {
						sSQLWhere+="	OR sp_fld_03='2' OR sp_fld_03='3' OR sp_fld_03='4') \n";
					} else {
						sSQLWhere+=") \n";
					}
				} else {
					sSQLWhere+="	AND Addr_Status='"+session.getAttribute("astatus")+"' \n";
				}
			}

			if( !session.getAttribute("oareacode").equals("") ) {
				sTmpStr1 = selDeptName(session.getAttribute("oareacode")+"");
				sSQLWhere += " AND Center_Name LIKE '" + sTmpStr1 + "%' \n";
			}


			// 2010년 담당자 세팅 방법 변경 (HADO_TB_DEPT_HISTORY)
			if( !session.getAttribute("odeptname").equals("") ) {
				sSQLWhere += " AND CVSNO = '" + session.getAttribute("odeptname") + "' \n";
			}

			String sTmpLocal = (String)session.getAttribute("local");

			if( sTmpLocal != null && (!sTmpLocal.equals("")) ) {
				switch( Integer.parseInt(sTmpLocal) ) {
					case 0 :
						sSQLWhere = sSQLWhere;
						break;
					case 1 :
						sTmpStr1 = "강원";
						sSQLWhere+="	AND SENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
						break;
					case 2 :
						sTmpStr1 = "경기";
						sSQLWhere+="	AND SENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
						break;
					case 3 :
						sTmpStr1 = "경상남도";
						sTmpStr2 = "경남";
						sSQLWhere+="	AND (SENT_ADDRESS LIKE '%"+sTmpStr1+"%' OR SENT_ADDRESS LIKE '%"+sTmpStr2+"%') \n";
						break;
					case 4 :
						sTmpStr1 = "경상북도";
						sTmpStr2 = "경북";
						sSQLWhere+="	AND (SENT_ADDRESS LIKE '%"+sTmpStr1+"%' OR SENT_ADDRESS LIKE '%"+sTmpStr2+"%') \n";
						break;
					case 5 :
						sTmpStr1 = "광주";
						sSQLWhere+="	AND SENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
						break;
					case 6 :
						sTmpStr1 = "대구";
						sSQLWhere+="	AND SENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
						break;
					case 7 :
						sTmpStr1 = "대전";
						sSQLWhere+="	AND SENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
						break;
					case 8 :
						sTmpStr1 = "부산";
						sSQLWhere+="	AND SENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
						break;
					case 9 :
						sTmpStr1 = "서울";
						sSQLWhere+="	AND SENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
						break;
					case 10 :
						sTmpStr1 = "울산";
						sSQLWhere+="	AND SENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
						break;
					case 11 :
						sTmpStr1 = "인천";
						sSQLWhere+="	AND SENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
						break;
					case 12 :
						sTmpStr1 = "전라남도";
						sTmpStr2 = "전남";
						sSQLWhere+="	AND (SENT_ADDRESS LIKE '%"+sTmpStr1+"%' OR SENT_ADDRESS LIKE '%"+sTmpStr2+"%') \n";
						break;
					case 13 :
						sTmpStr1 = "전라북도";
						sTmpStr2 = "전북";
						sSQLWhere+="	AND (SENT_ADDRESS LIKE '%"+sTmpStr1+"%' OR SENT_ADDRESS LIKE '%"+sTmpStr2+"%') \n";
						break;
					case 14 :
						sTmpStr1 = "제주";
						sSQLWhere+="	AND SENT_ADDRESS LIKE '%"+sTmpStr1+"%' \n";
						break;
					case 15 :
						sTmpStr1 = "충청남도";
						sTmpStr2 = "충남";
						sSQLWhere+="	AND (SENT_ADDRESS LIKE '%"+sTmpStr1+"%' OR SENT_ADDRESS LIKE '%"+sTmpStr2+"%') \n";
						break;
					case 16 :
						sTmpStr1 = "충청북도";
						sTmpStr2 = "충북";
						sSQLWhere+="	AND (SENT_ADDRESS LIKE '%"+sTmpStr1+"%' OR SENT_ADDRESS LIKE '%"+sTmpStr2+"%') \n";
						break;
				}
			}
			// 예시데이타는 관리번호 뒤에 1234567001 삽입했음 (예외처리 필요)
			sSQLs+="WHERE SUBSTR(MNG_NO,-7)<>'1234567' \n";
			if( !session.getAttribute("cyear").equals("0") ) {
				sSQLs+="	AND CURRENT_YEAR='"+session.getAttribute("cyear")+"' \n";
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
			sSQLs1+="WHERE SUBSTR(MNG_NO,-7)<>'1234567' \n";
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
			String sSQLs3 = "";
			//sSQLs3 += "SELECT * FROM HADO_TB_SUBCON_2016";
			sSQLs3 += "SELECT * FROM HADO_VT_SOent_2016";
			sSQLs3 += " where CURRENT_YEAR='2016'";
			sSQLs3 += " AND (CASE WHEN SENT_STATUS='1' THEN '1' ELSE '0' END)='0'";
			sSQLs3 += " AND (CASE WHEN ADDR_STATUS = '1' OR ADDR_STATUS = '2' OR ADDR_STATUS = '3' OR ADDR_STATUS = '9' OR ADDR_STATUS = '8' THEN ADDR_STATUS ELSE '0' END)='0'";
			sSQLs3 += " AND SEL_GB='1'";
			sSQLs3 += " and  return_gb is null";
			System.out.println(sSQLs3);
			pstmt = conn.prepareStatement(sSQLs3);
			rs = pstmt.executeQuery();
			int testVal = 0;
			while ( rs.next()) {
				testVal++;
				arrMngNo.add(StringUtil.checkNull(rs.getString("MNG_NO")).trim());
				arrCYear.add(StringUtil.checkNull(rs.getString("Current_Year")).trim());
				arrOentGB.add(StringUtil.checkNull(rs.getString("OENT_GB")).trim());
				arrSentNo.add(StringUtil.checkNull(rs.getString("Sent_No")).trim());
				arrChildMngNo.add(StringUtil.checkNull(rs.getString("CHILD_MNG_NO")).trim());
				arrOentName.add(StringUtil.checkNull(rs.getString("OENT_NAME")).trim());
				arrSentName.add(StringUtil.checkNull(rs.getString("SENT_NAME")).trim());
				arrSentCaptine.add(StringUtil.checkNull(rs.getString("SENT_CAPTINE")).trim());
				arrSentAmt.add(StringUtil.checkNull(rs.getString("SENT_AMT")).trim());
				arrSentZipCode.add(StringUtil.checkNull(rs.getString("ZIP_CODE")).trim());
				arrSentAddress.add(StringUtil.checkNull(rs.getString("SENT_ADDRESS")).trim());
				arrSentTel.add(StringUtil.checkNull(rs.getString("SENT_TEL")).trim());
				arrSentFax.add(StringUtil.checkNull(rs.getString("SENT_FAX")).trim());
				arrWriterName.add(StringUtil.checkNull(rs.getString("WRITER_NAME")).trim());
				arrWriterTel.add(StringUtil.checkNull(rs.getString("WRITER_TEL")).trim());
				arrWriterFax.add(StringUtil.checkNull(rs.getString("WRITER_FAX")).trim());
				if( rs.getString("SENT_SALE") != null && (!rs.getString("SENT_SALE").equals("")) ) {
					arrSentSale.add(StringUtil.checkNull(rs.getString("SENT_SALE")).trim());
				} else {
					arrSentSale.add("0");
				}
				if( rs.getString("SENT_EMP_CNT") != null && (!rs.getString("SENT_EMP_CNT").equals("")) ) {
					arrEmpCnt.add(StringUtil.checkNull(rs.getString("SENT_EMP_CNT")).trim());
				} else {
					arrEmpCnt.add("0");
				}
				arrSentReturnGB.add(StringUtil.checkNull(rs.getString("RETURN_GB")).trim());
				arrSentReSend.add(StringUtil.checkNull(rs.getString("RESEND_GB")).trim());
				arrAddrStatus.add(StringUtil.checkNull(rs.getString("ADDR_STATUS")).trim());
				arrSentStatus.add(StringUtil.checkNull(rs.getString("SENT_STATUS")).trim());
				if( currentYear >= 2015 ) {
					arrSpFld02.add(StringUtil.checkNull(rs.getString("sp_fld_03")).trim());
				}
				arrConnCode.add(StringUtil.checkNull(rs.getString("CONN_CODE")).trim());
				arrDontLogin.add(StringUtil.checkNull(rs.getString("DONT_LOGIN")).trim());
				arrCenterName.add(StringUtil.checkNull(rs.getString("Center_NAME")).trim());
			}
			System.out.println("총 크기는 : "+testVal);
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
<%!
	public String selDeptName(String str){
		String sReturnStr = "";

		if(str.equals("S") ){
			sReturnStr = "서울";
		}else if(str.equals("K")){
			sReturnStr = "대구";
		}else if(str.equals("J")){
			sReturnStr = "대전";
		}else if(str.equals("G")){
			sReturnStr = "광주";
		}else if(str.equals("B") ){
			sReturnStr = "부산";
		}else{
			sReturnStr = "본부";
		}

		return sReturnStr ;
	}
%>

<html>
<head>
	<title>미전송 / 미반송 리스트</title>
</head>


<table id='divButton'>
	<tr>
		<td>검색된 회사수 : <%=formater.format(nRecordCount)%>개</strong> (page. <%=formater.format(nPage)%> / <%=formater.format(nMaxPage)%>)&nbsp;&nbsp;* 예시자료 포함.</td>
	</tr>
</table>

<table class='resultTable'>
	<tr>
		<th>조사<br/>년도</th>
		<th>관리번호</th>
		<th>접속코드</th>
		<th>수급사업자명[원사업자명]</th>
		<th>대표자명</th>
		<th>소재지</th>
		<th>배정<br/>사무소</th>
		<th>접속차단</th>
		<th>소재불명여부</th>
		<th>전송여부</th>
	</tr>
<%if( arrMngNo.size()>0 ) {
	for(int j=0; j<arrOentName.size(); j++) {%>
	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>
		<td><%=arrCYear.get(j)%></td>
		<td><a href=javascript:view('<%=arrChildMngNo.get(j)%>','<%=arrCYear.get(j)%>','<%=arrOentGB.get(j)%>','<%=arrSentNo.get(j)%>');><%=arrChildMngNo.get(j)%></a></td>
		<td><%=arrConnCode.get(j)%></td>
		<td><%=arrSentName.get(j)%><br/><a href=javascript:fOentview('<%=arrMngNo.get(j)%>','<%=arrCYear.get(j)%>','<%=arrOentGB.get(j)%>');>[<%=arrOentName.get(j)%>]</a></td>
		<td><%=arrSentCaptine.get(j)%></td>
		<td>(<%=arrSentZipCode.get(j)%>) <%=arrSentAddress.get(j)%> [<%=arrSentTel.get(j)%>]</td>
		<td><%=arrCenterName.get(j)%></td>
		<td><%if( arrDontLogin.get(j).equals("Y") ) {%><font color='#FF0000'>접속차단</font><%} else {%><font color='#3300CC'>접속가능</font><%}%></td>
<% if( currentYear >= 2015 ) {%>
		<td><%if( arrAddrStatus.get(j).equals("1") ) { out.print("소재불명");} else if( arrAddrStatus.get(j).equals("2") || arrSpFld02.get(j).equals("2") || arrSpFld02.get(j).equals("3") || arrSpFld02.get(j).equals("4") ) { out.print("하도급거래없음");} else if( arrAddrStatus.get(j).equals("3") || arrSpFld02.get(j).equals("1") ) { out.print("수급사업자요건안됨");} else if( arrAddrStatus.get(j).equals("4") ) { out.print("중복업체");} else {%><%=StringUtil.astatusf((String)arrAddrStatus.get(j))%><%}%>&nbsp;</td>
<%} else {%>
		<td><%if( arrAddrStatus.get(j).equals("1") ) { out.print("소재불명");} else if( arrAddrStatus.get(j).equals("2") ) { out.print("하도급거래없음");} else if( arrAddrStatus.get(j).equals("3") ) { out.print("수급사업자요건안됨");} else if( arrAddrStatus.get(j).equals("4") ) { out.print("중복업체");} else {%><%=StringUtil.astatusf((String)arrAddrStatus.get(j))%><%}%>&nbsp;</td>
<%}%>
		<td><%=StringUtil.ostatusf((String)arrSentStatus.get(j))%>&nbsp;</td>
	</tr>
<%
	}
} else {%>
	<tr>
		<td colspan='10' class='noneResultset'>검색 결과가 없습니다</td>
	</tr>
<%
}
%>
</table>
</html>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>