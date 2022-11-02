<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 2014년 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_SP_excelProcess_byPOI_02.jsp
* 프로그램설명	: 수급사업자명부 엑셀파일 처리 (Step 2. 쉬트선택)
* 프로그램버전	: 3.0.0-2014
* 최초작성일자	: 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-14	정광식       최초작성
*/
%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem" %>
<%@ page import="org.apache.poi.hssf.record.*" %>
<%@ page import="org.apache.poi.hssf.model.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.*" %>

<%@ include file="../Include/WB_Inc_chkSession.jsp"%>

<%
ConnectionResource resource		= null;
Connection conn					= null;
PreparedStatement pstmt			= null;
ResultSet rs					= null;

String sSQLs = "";

String sExcelFilePath =  config.getServletContext().getRealPath("/upload/"+ckCurrentYear);	// 엑셀파일 경로
String sExcelFileName = "";
String sReturnMsg = "";

String sSheetNum = request.getParameter("sn")==null ? "0":request.getParameter("sn").trim();
String[][] arrTitleTxt = new String[11][3];	// 필드검색 배열
/* 데이타 저장 배열 */
ArrayList arrName = new ArrayList();
ArrayList arrCoNo = new ArrayList();
ArrayList arrSaNo = new ArrayList();
ArrayList arrCaptine = new ArrayList();
ArrayList arrTotTradeM = new ArrayList();
ArrayList arrTradeM = new ArrayList();
ArrayList arrZipcode = new ArrayList();
ArrayList arrAddress = new ArrayList();
ArrayList arrEmail = new ArrayList();
ArrayList arrTel = new ArrayList();
ArrayList arrContex = new ArrayList();

int nStartRow = 0;
int nTotDataCnt = 0;
boolean bReadData = false;

/* 타이틀 배열 */
arrTitleTxt[0][0] = "수급사업자명 수급업자명 사업자명 수급자명 업체명 회사명";
arrTitleTxt[1][0] = "법인등록번호 법인번호";
arrTitleTxt[2][0] = "사업자등록번호 사업자번호";
arrTitleTxt[3][0] = "대표자명 대표자 대표이사명 대표이사";
arrTitleTxt[4][0] = "2013년도전체하도급거래금액(2013.1.1~12.31)(단위:백만원) 2013년도전체하도급거래금액 전체하도급거래금액 전체금액 전체하도급금액 전체거래금액";
arrTitleTxt[5][0] = "2013년도하반기하도급거래 금액(2013.7.1~12.31)(단위:백만원) 2013년도하도급거래금액 하반기하도급거래금액 하도급거래금액 거래금액 하도급거래금액(2012.7.1~12.31)(단위:백만원) 하도급거래금액(2012.7.1~12.31)";
arrTitleTxt[6][0] = "우편번호";
arrTitleTxt[7][0] = "소재지(주소) 소재지 주소";
arrTitleTxt[8][0] = "E-MAIL주소 EMAIL주소 MAIL주소 이메일 이메일주소";
arrTitleTxt[9][0] = "전화번호 연락처 TEL";
arrTitleTxt[10][0] = "위탁내용 위탁 내용 비고";
for( int t=0; t<11; t++ ) arrTitleTxt[t][1] = "";	// 초기화
arrTitleTxt[0][2] = "sent_name";
arrTitleTxt[1][2] = "sent_co_no";
arrTitleTxt[2][2] = "sent_sa_no";
arrTitleTxt[3][2] = "sent_captine";
arrTitleTxt[4][2] = "tot_trade_money";
arrTitleTxt[5][2] = "trade_money";
arrTitleTxt[6][2] = "zip_code";
arrTitleTxt[7][2] = "sent_address";
arrTitleTxt[8][2] = "assign_mail";
arrTitleTxt[9][2] = "sent_tel";
arrTitleTxt[10][2] = "contex";


/* 해당 사업자 업로드한 엑셀 파일명 가져오기 시작 */
sSQLs  = "SELECT oent_file \n";
sSQLs+= "FROM hado_tb_oent_subcon_file \n";
sSQLs+="WHERE mng_no=? AND current_year=? AND oent_gb=? \n";

try {
	resource	= new ConnectionResource();
	conn		= resource.getConnection();

	pstmt		= conn.prepareStatement(sSQLs);
	pstmt.setString(1, ckMngNo);
	pstmt.setString(2, ckCurrentYear);
	pstmt.setString(3, ckOentGB);
	rs			= pstmt.executeQuery();

	if( rs.next() ) {
		sExcelFileName = new String( rs.getString("oent_file").getBytes("ISO8859-1"), "EUC-KR" );
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
/* 해당 사업자 업로드한 엑셀 파일명 가져오기 끝 */

if( sExcelFileName!=null && !sExcelFileName.equals("") ) {
	String sFilePath = sExcelFilePath + "/" + sExcelFileName;		// 파일 전체 경로
	boolean bTrueExcel = false;

	try {
		POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(sFilePath));
		HSSFWorkbook workbook = new HSSFWorkbook(fs);	//Workbook 생성
		HSSFSheet sheet = null;
		HSSFRow row = null;
		HSSFCell cell = null;

		int nSheetNum = Integer.parseInt( sSheetNum );
		sheet = workbook.getSheetAt(nSheetNum);
        int rows = sheet.getPhysicalNumberOfRows();

		for (int j = 0; j< rows; j++) {
			// 시트에 대한 행을 하나씩 추출
               row   = sheet.getRow(j);

                if (row != null) { 
                     int cells = row.getPhysicalNumberOfCells();

                     //out.print("ROW " + row.getRowNum() + " " + cells);

                     for (short k = 0; k< cells; k++) {
                         // 행에 대한 셀을 하나씩 추출하여 셀 타입에 따라 처리
                         cell = row.getCell(k);

                         if (cell != null) { 
                              String value = "";
                              switch (cell.getCellType()) {
                                case HSSFCell.CELL_TYPE_FORMULA :
									//value = "FORMULA value=" + cell.getCellFormula();
									value = "" + cell.getCellFormula();
									break;
                                case HSSFCell.CELL_TYPE_NUMERIC :
									//value = "NUMERIC value=" + cell.getNumericCellValue();
									value = "" + cell.getNumericCellValue();
									break;
                                case HSSFCell.CELL_TYPE_STRING :
									//value = "STRING value=" + cell.getStringCellValue(); 
									value = "" + cell.getStringCellValue(); 
									break;
                                case HSSFCell.CELL_TYPE_BLANK :
									value = "";
									break;
                                case HSSFCell.CELL_TYPE_BOOLEAN :
									//value = "BOOLEAN value=" + cell.getBooleanCellValue(); 
									value = "" + cell.getBooleanCellValue(); 
									break;
                                case HSSFCell.CELL_TYPE_ERROR :
									//value = "ERROR value=" + cell.getErrorCellValue();
									value = "" + cell.getErrorCellValue();
									break;
                                default :
                             }
							
							if( !bReadData ) {		// 타이틀 검색
								if( !value.equals("") ) {
									String tmpStr = value.toUpperCase();
									tmpStr = tmpStr.replaceAll("\\n\\s\\n", "");
									tmpStr = tmpStr.replaceAll("\\p{Space}", "");
									for( int t=0; t<11; t++ ) {
										if( arrTitleTxt[t][0].indexOf(tmpStr)>-1 ) {
											arrTitleTxt[t][1] = ""+cell.getCellNum();
											nStartRow = row.getRowNum();
										}
									}
								}
							} else {	// 데이타
								String sTmpCol = "" + cell.getCellNum();
								if( arrTitleTxt[0][1].equals(sTmpCol) ) arrName.add(value);
								else if( arrTitleTxt[1][1].equals(sTmpCol) ) arrCoNo.add(value);
								else if( arrTitleTxt[2][1].equals(sTmpCol) ) arrSaNo.add(value);
								else if( arrTitleTxt[3][1].equals(sTmpCol) ) arrCaptine.add(value);
								else if( arrTitleTxt[4][1].equals(sTmpCol) ) arrTotTradeM.add(value);
								else if( arrTitleTxt[5][1].equals(sTmpCol) ) arrTradeM.add(value);
								else if( arrTitleTxt[6][1].equals(sTmpCol) ) arrZipcode.add(value);
								else if( arrTitleTxt[7][1].equals(sTmpCol) ) arrAddress.add(value);
								else if( arrTitleTxt[8][1].equals(sTmpCol) ) arrEmail.add(value);
								else if( arrTitleTxt[9][1].equals(sTmpCol) ) arrTel.add(value);
								else if( arrTitleTxt[10][1].equals(sTmpCol) ) arrContex.add(value);
							}

							//out.print("CELL col=" + cell.getCellNum() + " VALUE=" + value + "<br/>");
						}
					}
				}

				if( bReadData) nTotDataCnt++;
				if( nStartRow>0 ) bReadData = true;
		}
		
		out.print("Title-RowNum : " + nStartRow + " / Data-length : " + arrName.size() + "<br/>");
		out.print("============== Field Search Result ===================<br/>");
		for( int t=0; t<11; t++ ) {
			out.print("Field Name : " + arrTitleTxt[t][2] + " => " + arrTitleTxt[t][1] + " Column<br/>");
		}
		out.print("===============================================<br/><br/>");

		out.print("================= Result Data======================<br/>");
		out.print("<table border='1' style='border-style:1px solid black;'><tr><th>일련번호</th><th>수급사업자명</th><th>법인등록번호</th><th>사업자등록번호</th><th>대표자명</th><th>전체 하도급거래금액</th><th>하반기 하도급거래금액</th><th>우편번호</th><th>주소</th><th>이메일</th><th>전화번호</th><th>위탁내용</th></tr>");
		for( int t=0; t<arrName.size(); t++ ) {
			out.print("<tr>");
			out.print("<td>" + (t+1) +"</td>");
			out.print("<td>" + arrName.get(t) + "</td>");
			if( arrCoNo.size()>t && arrCoNo.get(t)!=null ) { out.print("<td>" + arrCoNo.get(t) + "</td>");} else {out.print("<td>&nbsp;</td>");}
			if( arrSaNo.size()>t && arrSaNo.get(t)!=null ) { out.print("<td>" + arrSaNo.get(t) + "</td>");} else {out.print("<td>&nbsp;</td>");}
			if( arrCaptine.size()>t && arrCaptine.get(t)!=null ) { out.print("<td>" + arrCaptine.get(t) + "</td>");} else {out.print("<td>&nbsp;</td>");}
			if( arrTotTradeM.size()>t && arrTotTradeM.get(t)!=null ) { out.print("<td>" + arrTotTradeM.get(t) + "</td>");} else {out.print("<td>&nbsp;</td>");}
			if( arrTradeM.size()>t && arrTradeM.get(t)!=null ) { out.print("<td>" + arrTradeM.get(t) + "</td>");} else {out.print("<td>&nbsp;</td>");}
			if( arrZipcode.size()>t && arrZipcode.get(t)!=null ) { out.print("<td>" + arrZipcode.get(t) + "</td>");} else {out.print("<td>&nbsp;</td>");}
			if( arrAddress.size()>t && arrAddress.get(t)!=null ) { out.print("<td>" + arrAddress.get(t) + "</td>");} else {out.print("<td>&nbsp;</td>");}
			if( arrEmail.size()>t && arrEmail.get(t)!=null ) { out.print("<td>" + arrEmail.get(t) + "</td>");} else {out.print("<td>&nbsp;</td>");}
			if( arrTel.size()>t && arrTel.get(t)!=null ) { out.print("<td>" + arrTel.get(t) + "</td>");} else {out.print("<td>&nbsp;</td>");}
			if( arrContex.size()>t && arrContex.get(t)!=null ) { out.print("<td>" + arrContex.get(t) + "</td>");} else {out.print("<td>&nbsp;</td>");}
			out.print("</tr>");
		}
		out.print("<table>");
		out.print("===============================================<br/>");

	} catch (Exception e) {
		System.out.println( e.getMessage() );
		e.printStackTrace();
	}
}

%>