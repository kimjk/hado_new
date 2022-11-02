<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>

<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.http.*" %>

<%@ page import="org.apache.poi.poifs.filesystem.POIFSFileSystem" %>
<%@ page import="org.apache.poi.hssf.record.*" %>
<%@ page import="org.apache.poi.hssf.model.*" %>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.*" %>

<%@ page import="ftc.db.ConnectionResource" %>

<%!
public static final int SENT_NO = 0;
public static final int SENT_NAME = 1;
public static final int SENT_CO_NO = 2;
public static final int SENT_SA_NO = 3;
public static final int SENT_CAPTAIN = 4;
public static final int TOT_TRADE_MONEY = 5;
public static final int TRADE_MONEY = 6;
public static final int ZIP_CODE = 7;
public static final int SENT_ADDRESS = 8;
public static final int ASSIGN_MAIL = 9;
public static final int SENT_TEL = 10;
public static final int CONTEX = 11;

public class XlsVO {
    private String mngNo;
    private int sentNo;
    private String sentName;
    private String sentCoNo;
    private String sentSaNo;
    private String sentCaptain;
    private int totTradeMoney;
    private int tradeMoney;
    private String zipCode;
    private String sentAddress;
    private String assignMail;
    private String sentTel;
    private String contex;
    
    public String getMngNo() {
        return mngNo;
    }
    public void setMngNo(String mngNo) {
        this.mngNo = mngNo;
    }
    public int getSentNo() {
        return sentNo;
    }
    public void setSentNo(int sentNo) {
        this.sentNo = sentNo;
    }
    public String getSentName() {
        return sentName;
    }
    public void setSentName(String sentName) {
        this.sentName = sentName;
    }
    public String getSentCoNo() {
        return sentCoNo;
    }
    public void setSentCoNo(String sentCoNo) {
        this.sentCoNo = sentCoNo;
    }
    public String getSentSaNo() {
        return sentSaNo;
    }
    public void setSentSaNo(String sentSaNo) {
        this.sentSaNo = sentSaNo;
    }
    
    public String getSentCaptain() {
        return sentCaptain;
    }
    public void setSentCaptain(String sentCaptine) {
        this.sentCaptain = sentCaptine;
    }
    public int getTotTradeMoney() {
        return totTradeMoney;
    }
    public void setTotTradeMoney(int totTradeMoney) {
        this.totTradeMoney = totTradeMoney;
    }
    public int getTradeMoney() {
        return tradeMoney;
    }
    public void setTradeMoney(int tradeMoney) {
        this.tradeMoney = tradeMoney;
    }
    public String getZipCode() {
        return zipCode;
    }
    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }
    public String getSentAddress() {
        return sentAddress;
    }
    public void setSentAddress(String sentAddress) {
        this.sentAddress = sentAddress;
    }
    public String getAssignMail() {
        return assignMail;
    }
    public void setAssignMail(String assignMail) {
        this.assignMail = assignMail;
    }
    public String getSentTel() {
        return sentTel;
    }
    public void setSentTel(String sentTel) {
        this.sentTel = sentTel;
    }
    public String getContex() {
        return contex;
    }
    public void setContex(String contex) {
        this.contex = contex;
    }
    
}


public String doProcessFile(HttpServletRequest request, HttpServletResponse resp, String mng_no, String sExcelFileName) {
	String msg = "";
    HttpSession currentSession = request.getSession();
    String ckCurrentYear = (String)currentSession.getAttribute("ckCurrentYear");
    String sExcelFilePath =  currentSession.getServletContext().getRealPath("/upload/"+ckCurrentYear);  // 엑셀파일 경로
    //String sExcelFilePath = "/home1/ftc/hadoweb/upload/2017";
    
    String sReturnMsg = "";
    
    String sSheetNum = request.getParameter("sn")==null ? "0":request.getParameter("sn").trim();
    String[][] arrTitleTxt = new String[11][3]; // 필드검색 배열
    
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
    for( int t=0; t<11; t++ ) arrTitleTxt[t][1] = "";   // 초기화
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

    int nStartRow = 0;
    int nTotDataCnt = 0;
    boolean bReadData = false;
    
    final int CUT_ROW = 6;
    
    if( sExcelFileName!=null && !sExcelFileName.equals("") ) {
        String sFilePath = sExcelFilePath + "/" + sExcelFileName;       // 파일 전체 경로
        boolean bTrueExcel = false;

        try {
            POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(sFilePath));
            HSSFWorkbook workbook = new HSSFWorkbook(fs);   //Workbook 생성
            HSSFSheet sheet = null;
            HSSFRow row = null;
            HSSFCell cell = null;

            int nSheetNum = Integer.parseInt( sSheetNum );
            sheet = workbook.getSheetAt(nSheetNum);
            int rows = sheet.getPhysicalNumberOfRows();

            for (int j = CUT_ROW; j< rows; j++) {
                // 시트에 대한 행을 하나씩 추출
                   row   = sheet.getRow(j);
                   
                   XlsVO xlsRow = new XlsVO();
                   
                   xlsRow.setMngNo(mng_no);

                    if (row != null) { 
                         int cells = row.getPhysicalNumberOfCells();


                         for (int k = 0; k< cells; k++) {
                             // 행에 대한 셀을 하나씩 추출하여 셀 타입에 따라 처리
                             cell = row.getCell(k);

                             if (null == cell) {
                                 continue;
                             }
                             
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
                             
                             try {
	                             switch (k) {
	                             case SENT_NO:
	                            	 xlsRow.setSentNo(new BigDecimal(value).intValue());
	                                 break;
	                             case SENT_NAME:
	                                 xlsRow.setSentName(value);
	                                 break;
	                             case SENT_CO_NO:
	                                 xlsRow.setSentCoNo(value);
	                                 break;
	                             case SENT_SA_NO:
	                                 xlsRow.setSentSaNo(value);
	                                 break;
	                             case SENT_CAPTAIN:
	                                 xlsRow.setSentCaptain(value);
	                                 break;
	                             case TOT_TRADE_MONEY:
	                                 xlsRow.setTotTradeMoney(new BigDecimal(value).intValue());
	                                 break;
	                             case TRADE_MONEY:
	                                 xlsRow.setTradeMoney(new BigDecimal(value).intValue());
	                                 break;
	                             case ZIP_CODE:
	                                 xlsRow.setZipCode(value.replace(".0", ""));
	                                 break;
	                             case SENT_ADDRESS:
	                                 xlsRow.setSentAddress(value);
	                                 break;
	                             case ASSIGN_MAIL:
	                                 xlsRow.setAssignMail(value);
	                                 break;
	                             case SENT_TEL:
	                                 xlsRow.setSentTel(value);
	                                 break;
	                             case CONTEX:
	                                 xlsRow.setContex(value);
	                             default:
	                                 break;
	                             }
                             }
                             catch (Exception e) {
                            	 msg += e.getMessage();
                            	 continue;
                             }
                            
                        } // for end 
                         
                         if (xlsRow.getSentNo() <= 0) {
                        	 continue;
                         }
                        
                        if (null == xlsRow.getSentName() || "".equals(xlsRow.getSentName())) {
                        	continue;
                        }
                        
                         msg += doDBProcess("TMP_TB_MRG_SUBCON", xlsRow);
                    } // if end 

            } // for end 
           
        } catch (Exception e) {
            System.out.println( e.getMessage() );
            e.printStackTrace();
            
            msg += "doProcessFile(" + sExcelFileName + ") : " + e.getMessage();
        }
    }
    
    //return "doProcessFile : " + msg + "\n\n";
    return msg;
} // doProcessFile end

private String doDBProcess(String targetTable, XlsVO xlsRow) {
	String msg = "";
    ConnectionResource resource     = null;
    Connection conn                 = null;
    PreparedStatement pstmt         = null;
    ResultSet rs                    = null;
    
    String sSQLs = "";
    String sSQLs1 = "";
    
    String sExcelFileName = "";
    String mng_no = "";
    
    sSQLs = "DELETE " + targetTable;
    
    int colidx = 0;
    
    /* 해당 사업자 업로드한 엑셀 파일명 가져오기 시작 */
    sSQLs1 = "INSERT INTO " + targetTable + " (";
    sSQLs1 += "MNG_NO, ";
    sSQLs1 += "SENT_NO, ";
    sSQLs1 += "SENT_NAME, ";
    sSQLs1 += "SENT_CO_NO, ";
    sSQLs1 += "SENT_SA_NO, ";
    sSQLs1 += "SENT_CAPTAIN, ";
    sSQLs1 += "TOT_TRADE_MONEY, ";
    sSQLs1 += "TRADE_MONEY, ";
    sSQLs1 += "ZIP_CODE, ";
    sSQLs1 += "SENT_ADDRESS, ";
    sSQLs1 += "ASSIGN_MAIL, ";
    sSQLs1 += "SENT_TEL, ";
    sSQLs1 += "CONTEX ";
    sSQLs1 += ") VALUES ( ";
    sSQLs1 += "?, ?, ?, ?, ";
    sSQLs1 += "?, ?, ?, ?, ";
    sSQLs1 += "?, ?, ?, ?, ";
    sSQLs1 += "? ) ";
    

    try {
        resource    = new ConnectionResource();
        conn        = resource.getConnection();

        //pstmt       = conn.prepareStatement(sSQLs);
        //pstmt.executeUpdate();
        
        //pstmt.close();
        
        pstmt       = conn.prepareStatement(sSQLs1);
        pstmt.setString(++colidx, xlsRow.getMngNo());
        pstmt.setInt(++colidx, xlsRow.getSentNo());
        pstmt.setString(++colidx, xlsRow.getSentName());
        pstmt.setString(++colidx, xlsRow.getSentCoNo());
        pstmt.setString(++colidx, xlsRow.getSentSaNo());
        pstmt.setString(++colidx, xlsRow.getSentCaptain());
        pstmt.setInt(++colidx, xlsRow.getTotTradeMoney());
        pstmt.setInt(++colidx, xlsRow.getTradeMoney());
        pstmt.setString(++colidx, xlsRow.getZipCode());
        pstmt.setString(++colidx, xlsRow.getSentAddress());
        pstmt.setString(++colidx, xlsRow.getAssignMail());
        pstmt.setString(++colidx, xlsRow.getSentTel());
        pstmt.setString(++colidx, xlsRow.getContex());
        pstmt.executeUpdate();
    } catch(Exception e){
        e.printStackTrace();
        
        msg += "doDBProcess : " + e.getMessage();
    } finally {
        if ( rs != null )       try{rs.close();}    catch(Exception e){}
        if ( pstmt != null )    try{pstmt.close();} catch(Exception e){}
        if ( conn != null )     try{conn.close();}  catch(Exception e){}
        if ( resource != null ) resource.release();
    }
    
    //return "doDBProcess : " + msg + "\n\n";
    return msg;
}
%>

<%
ConnectionResource resource     = null;
Connection conn                 = null;
PreparedStatement pstmt         = null;
ResultSet rs                    = null;

HttpSession currentSession = request.getSession();

String ckCurrentYear = (String)currentSession.getAttribute("ckCurrentYear");

String sSQLs = "";
String sSQLs1 = "";

String sExcelFileName = "";
String mng_no = "";

String result = "";
String msg = "";
int cnt = 0;

String targetTable = "TMP_TB_MRG_SUBCON";

/* 해당 사업자 업로드한 엑셀 파일명 가져오기 시작 */
sSQLs  = "SELECT mng_no, oent_file \n";
sSQLs+= "FROM hado_tb_oent_subcon_file \n";
sSQLs+="WHERE current_year=? \n";
sSQLs += "AND SUBSTR(MNG_NO, 1, 2) NOT IN ('HE') ";
//sSQLs+= "AND MNG_NO = 'HE0101' ";
//sSQLs+= "AND MNG_NO = 'BC100001' ";

sSQLs1 += "DELETE " + targetTable + "";

try {
    resource    = new ConnectionResource();
    conn        = resource.getConnection();
    
    conn.setAutoCommit(false);
    
    pstmt       = conn.prepareStatement(sSQLs1);
    pstmt.executeUpdate();
    
    pstmt.close();

    pstmt       = conn.prepareStatement(sSQLs);
    pstmt.setString(1, ckCurrentYear);
    rs          = pstmt.executeQuery();

    while( rs.next() ) {
        mng_no = rs.getString("mng_no");
        //sExcelFileName = new String( rs.getString("oent_file").getBytes("ISO8859-1"), "EUC-KR" );
        sExcelFileName = rs.getString("oent_file");
        
        msg = doProcessFile(request, response, mng_no, sExcelFileName);
        
        if ("".equals(msg.trim())) {
        	++cnt;
        }
        
        result += msg;
    }
    
    conn.commit();
    result += cnt + "개 추출 완료";
    
    rs.close();
} catch(Exception e){
    e.printStackTrace();
    conn.rollback();
} finally {
    if ( rs != null )       try{rs.close();}    catch(Exception e){}
    if ( pstmt != null )    try{pstmt.close();} catch(Exception e){}
    if ( conn != null )     try{conn.close();}  catch(Exception e){}
    if ( resource != null ) resource.release();
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>추출 결과</title>
</head>
<body>
<%= result.replace("\n", "<br>") %>
</body>
</html>