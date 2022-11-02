<%@page import="org.apache.poi.xssf.usermodel.*"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="org.apache.poi.hssf.record.crypto.Biff8EncryptionKey"%>
<%@page import="org.apache.poi.ss.usermodel.Hyperlink"%>
<%@page import="org.apache.poi.hssf.usermodel.examples.CellTypes"%>
<%@page import="org.apache.poi.ss.usermodel.Cell"%>
<%@page import="org.apache.poi.ss.usermodel.Row"%>
<%@page import="org.apache.poi.ss.usermodel.Sheet"%>
<%@page import="org.apache.poi.ss.usermodel.Workbook"%>
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
public static String ckCurrentYear = "" + Calendar.getInstance().get(Calendar.YEAR);
//public static String ckCurrentYear = "2017";

public static final String TARGET_TABLE = "TMP_TB_MRG_SUBCON";
public static final String[] PWD_LIST = {"1111", "100%"};
//public static final int PWD_CNT = 2;

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

public String doProcessFile(HttpServletRequest request, HttpServletResponse resp, String mng_no, String sExcelFileName)  {
	String msg = "";
    HttpSession currentSession = request.getSession();
    String sExcelFilePath =  currentSession.getServletContext().getRealPath("/upload/"+ckCurrentYear);  // 엑셀파일 경로
    
    String sReturnMsg = "";
    
    int nStartRow = 0;
    int nTotDataCnt = 0;
    boolean bReadData = false;
    
    int cut_row = 6;
    
    int sent_no = 0;
    int sent_name = 1;
    int sent_co_no = 2;
    int sent_sa_no = 3;
    int sent_captain  = 4;
    int tot_trade_money  = 5;
    int trade_money = 6;
    int zip_code = 7;
    int sent_address = 8;
    int assign_mail = 9;
    int sent_tel = 10;
    int contex = 11;
    
    if( sExcelFileName!=null && !sExcelFileName.equals("") ) {
        String sFilePath = sExcelFilePath + "/" + sExcelFileName;       // 파일 전체 경로
        boolean bTrueExcel = false;
        
        String extension = sExcelFileName.substring(sExcelFileName.lastIndexOf(".") + 1).toLowerCase();
        Workbook workbook = null;
        Sheet sheet = null;
        Row row = null;
        Cell cell = null;
        POIFSFileSystem fs = null;
        InputStream is = null;
        
        try {
        	try {
                is = new FileInputStream(sFilePath);
                fs = new POIFSFileSystem(is);
                for (int i = 0; i < PWD_LIST.length; ++i) {
	                try {
	                	Biff8EncryptionKey.setCurrentUserPassword(PWD_LIST[i]);
		                workbook = new HSSFWorkbook(fs, true);
		                break;
	                }
	                catch (Exception e) {
	                	continue;
	                }
                }
                if (null == workbook) {
                	  workbook = new HSSFWorkbook(fs);
                }
        	} catch (Exception e) {
        		workbook = null;
        	} 
        	
        	if (null == workbook) {
        		if (null != is) {
        			is.close();
        		}
        		try {
        			is = new FileInputStream(sFilePath);
        			//FIXME
        			workbook = new XSSFWorkbook(is);	
        		} catch (Exception e1) {
        			e1.printStackTrace();
        			msg += "Excel File (" + sExcelFileName + ") : " + e1.getMessage() + "\n";
        		}
        	}
        	
        	if (null == workbook) {
        		msg += "doProcessFile (" + sExcelFileName + ") : No workbook. \n";
        		return msg;
        	}
        	
        	int cnt_sheet = workbook.getNumberOfSheets();
        	int nSheetNum = 0;
        	
        	if (cnt_sheet > 1) {
        		for (int i = 0; i < cnt_sheet; ++i) {
        			if (workbook.getSheetName(i).indexOf("수급") >= 0) {
        				nSheetNum = i;
        				break;
        			}
        		}
        	}
        	
            sheet = workbook.getSheetAt(nSheetNum);
            int rows = sheet.getPhysicalNumberOfRows();
            int cells = 0;
            
            String value = "";
            
            boolean isColFixed = false;
            
            for (int i = 0; i < rows; ++i) {
            	row = sheet.getRow(i);
            	if (null == row) {
            		continue;
            	}
            	
            	cells = row.getPhysicalNumberOfCells();
            	
            	for (int j = 0; j < cells; ++j) {
            		if (sheet.isColumnHidden(j)) {
            			continue;
            		}
            		
            		cell = row.getCell(j);
            		
            		if (null == cell) {
            			continue;
            		}
            		
            		value = getCellData(cell, cell.getCellType());
            		
            		if (null == value) {
            			continue;
            		}
            		
            		value = value.trim();
            		
            		if (value.startsWith("일련")) {
            			sent_no = j;
            		} else if (value.startsWith("수급")) {
            			sent_name = j;
            		} else if (value.startsWith("법인")) {
            			sent_co_no = j;
            		} else if (value.startsWith("사업자")) {
            			sent_sa_no = j;
            		} else if (value.startsWith("대표자")) {
            			sent_captain = j;
            		} else if (value.startsWith("" + (Calendar.getInstance().get(Calendar.YEAR) - 1))) {
            			if (value.indexOf("전체") >= 0) {
            				tot_trade_money = j;
            			} else if (value.indexOf("하반기") >= 0) {
            				trade_money = j;
            			}
            		} else if (value.startsWith("우편")) {
            			zip_code = j;
            		} else if (value.startsWith("소재지")) {
            			sent_address = j;
            		} else if (value.startsWith("E-mail")) {
            			assign_mail = j;
            		} else if (value.startsWith("전화")) {
            			sent_tel = j;
            		} else if (value.startsWith("위탁")) {
            			contex = j;
            			isColFixed = true;
            			cut_row = i;
            			break;
            		} else {
            			continue;
            		}
            	}
            	
            	if (isColFixed) {
            		break;
            	}
            }

            for (int j = cut_row; j< rows; j++) {
                // 시트에 대한 행을 하나씩 추출
                   row   = sheet.getRow(j);
                   
                   XlsVO xlsRow = new XlsVO();
                   
                   xlsRow.setMngNo(mng_no);

                    if (row != null) { 
                         cells = row.getPhysicalNumberOfCells();
                         for (int k = 0; k< cells; k++) {
                        	 if (sheet.isColumnHidden(k)) {
                                 continue;
                             }
                             // 행에 대한 셀을 하나씩 추출하여 셀 타입에 따라 처리
                             cell = row.getCell(k);

                             if (null == cell) {
                                 continue;
                             }
                             
                             value = getCellData(cell, cell.getCellType());
                             
                             try {
	                            if (k == sent_no) {
	                            	 value = value.trim().replaceAll("[^0-9]", "");
	                            	 int num = toInt(value, -1);
	                            	 xlsRow.setSentNo(num);
	                            } else if (k == sent_name) {
	                                 xlsRow.setSentName(value);
	                            } else if (k == sent_co_no) {
	                            	value = value.trim().replaceAll("[^0-9\\-]", ""); 
	                            	xlsRow.setSentCoNo(value);
	                            } else if (k == sent_sa_no) {
	                            	value = value.trim().replaceAll("[^0-9\\-]", "");
	                            	xlsRow.setSentSaNo(value);
	                            } else if (k == sent_captain) {
	                                value = cutString(value, 3, 50, ";,");
	                            	xlsRow.setSentCaptain(value);
	                            } else if (k == tot_trade_money) {
	                            	 value = value.trim().replaceAll("[^0-9]", "");
	                            	 int tot = toInt(value, 0);
	                            	 if (tot > 1000000) {
	                            		 tot /= 1000000;
	                            	 }
	                                 xlsRow.setTotTradeMoney(tot);
	                            } else if (k == trade_money) {
	                            	 value = value.trim().replaceAll("[^0-9]", "");
                                     int trade = toInt(value, 0);
                                     if (trade > 1000000) {
                                    	 trade /= 1000000;
                                     }
	                                 xlsRow.setTradeMoney(trade);
	                            } else if (k == zip_code) {
	                            	 final String ZIP_FMT = "###-###";
	                            	 final String ZIP_FMT1 = "#####";
	                            	 int zip_len = ZIP_FMT.length();
	                            	 int zip_len1 = ZIP_FMT1.length();
	                            	 value = value.trim().replaceAll("[^0-9\\-]", "");
	                            	 if (value.trim().length() > zip_len) {
                                         value = value.trim().substring(0, zip_len);
                                     }
	                            	 if (value.trim().length() > 0 && value.indexOf("-") < 0) {
	                            		 if (value.trim().length() > zip_len1) {
	                                         value = value.trim().substring(0, zip_len1);
	                                     }
	                            		 while (value.trim().length() < ZIP_FMT1.length()) {
	                            			 value = "0" + value;
	                            		 }
	                            	 }
	                            	 
	                                 xlsRow.setZipCode(value.trim());
	                            } else if (k == sent_address) {
	                                 xlsRow.setSentAddress(value);
	                            } else if (k == assign_mail) {
	                            	value = value.trim().replaceAll("\\s", ""); 
	                            	xlsRow.setAssignMail(value);
	                            } else if (k == sent_tel) {
	                            	 value = value.trim().replaceAll("[^0-9\\-,;]", "");
	                            	 value = cutString(value, 1, 30, ";, ");
	                                 xlsRow.setSentTel(value.trim());
	                            } else if (k == contex) {
	                                 xlsRow.setContex(value.trim());
	                            } 
                             }
                             catch (Exception e) {
                            	 msg += "XLS(" + mng_no + ", " + sExcelFileName + ") Data : " + e.getMessage() + "\n\n";
                            	 continue;
                             }
                            
                        } // for end 
                         
                         if (xlsRow.getSentNo() <= 0) {
                        	 continue;
                         }
                        
                         if (null == xlsRow.getSentName() || "".equals(xlsRow.getSentName().trim())) {
                             continue;
                         }
                         msg += doDBProcess(TARGET_TABLE, xlsRow);
                    } // if end 

            } // for end 
          } catch (RuntimeException re) {
        	  re.printStackTrace();
            	msg += "doProcessFile(" + mng_no + ", " + sExcelFileName + ") : " + re.getMessage() + "\n\n";
        } catch (Exception e) {
            System.out.println( e.getMessage() );
            e.printStackTrace();
            
            msg += "doProcessFile(" + mng_no + ", " + sExcelFileName + ") : " + e.getMessage() + "\n\n";
        } finally {
        	try {
	        	if (null != is) {
	        		is.close();
	        	}
        	} catch (Exception e) {
        		// DO NOTHING 
        	}
        }
    }
    return msg;
} // doProcessFile end
    
private String cutString(String value, int bytes, int limit, String chars) {
	int cut = -1;
	while (bytes * value.length() > limit) {
		for (int i = 0; i < chars.length(); ++i) {
			char filter = chars.charAt(i);
			cut = value.indexOf(filter);
			if (cut > 0) {
				break;
			}
		}
		if (cut < 0) {
			cut = limit / bytes;
		}
		value = value.substring(0, cut).trim();
	}
	return value.trim();
}

private int toInt(String value, int init) {
	int ret = init;
	try {
		ret = new Integer(value.trim()).intValue();
	} catch (NumberFormatException e) {
		ret = init;
	}
	return ret;
}

private String getCellData(Cell cell, int cell_type) {
	String value = "";
    switch (cell_type) {
     case Cell.CELL_TYPE_FORMULA :
         value = "" + cell.getCellFormula();
         value = getCellData(cell, cell.getCachedFormulaResultType());
         break;
     case Cell.CELL_TYPE_NUMERIC :
         value = "" + new Double(cell.getNumericCellValue()).longValue();
         break;
     case Cell.CELL_TYPE_STRING :
         value = "" + cell.getStringCellValue(); 
         break;
     case Cell.CELL_TYPE_BLANK :
         value = "";
         break;
     case Cell.CELL_TYPE_BOOLEAN :
         value = "" + cell.getBooleanCellValue(); 
         break;
     case Cell.CELL_TYPE_ERROR :
         value = "" + cell.getErrorCellValue();
         break;
     default :
    	 Hyperlink h = cell.getHyperlink();
    	 if (null != h) {
    		 value = "" + h.getLabel();
    	 }
    	 break;
  }
    
    return value;
}

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
        
        msg += "doDBProcess(" + xlsRow.getMngNo() + ") : " + e.getMessage() + "\n";
        msg += "{"
        	+ xlsRow.getMngNo() + " | "
        	+ xlsRow.getSentNo() + " | "
        	+ xlsRow.getSentName() + " | "
        	+ xlsRow.getSentCoNo() + " | "
        	+ xlsRow.getSentSaNo() + " | "
        	+ xlsRow.getSentCaptain() + " | "
        	+ xlsRow.getTotTradeMoney() + " | "
        	+ xlsRow.getTradeMoney() + " | "
        	+ xlsRow.getZipCode() + " | "
        	+ xlsRow.getSentAddress() + " | "
        	+ xlsRow.getAssignMail() + " | "
        	+ xlsRow.getSentTel() + " | "
        	+ xlsRow.getContex() + " "
        	+ "}\n\n";
    } finally {
        if ( rs != null )       try{rs.close();}    catch(Exception e){}
        if ( pstmt != null )    try{pstmt.close();} catch(Exception e){}
        if ( conn != null )     try{conn.close();}  catch(Exception e){}
        if ( resource != null ) resource.release();
    }
    return msg;
}
%>

<%
ConnectionResource resource     = null;
Connection conn                 = null;
PreparedStatement pstmt         = null;
ResultSet rs                    = null;

HttpSession currentSession = request.getSession();

currentSession.setMaxInactiveInterval(-1);

String paramYear = "" + (String)request.getParameter("year");
ckCurrentYear = paramYear.length() <= 0 ? ckCurrentYear : paramYear;
String qry = (String)request.getParameter("qry");

String sSQLs = "";
String sSQLs1 = "";

String sExcelFileName = "";
String mng_no = "";

String result = "";
String msg = "";
int cnt = 0;
int sum = 0;
int col_idx = 0;

/* 해당 사업자 업로드한 엑셀 파일명 가져오기 시작 */
sSQLs  = "SELECT A.mng_no, A.oent_file \n";
sSQLs+= "FROM hado_tb_oent_subcon_file A \n";
sSQLs += "LEFT JOIN HADO_TB_OENT_" + ckCurrentYear + " B ";
sSQLs += "ON (A.MNG_NO = B.MNG_NO) ";
sSQLs+="WHERE A.current_year=? \n";
sSQLs += "AND B.SUBCON_TYPE IN (1, 2) ";
sSQLs += "AND SUBSTR(A.MNG_NO, 1, 2) NOT IN ('HE') ";
if (null != qry && !"".equals(qry)) {
    sSQLs+= "AND A.MNG_NO LIKE ? ";
}
sSQLs += "ORDER BY A.MNG_NO ";

sSQLs1 += "TRUNCATE TABLE " + TARGET_TABLE + " ";

try {
    resource    = new ConnectionResource();
    conn        = resource.getConnection();
    
    conn.setAutoCommit(false);
    
    pstmt       = conn.prepareStatement(sSQLs1);
    pstmt.executeUpdate();
    
    pstmt.close();

    pstmt       = conn.prepareStatement(sSQLs);
    pstmt.setString(++col_idx, ckCurrentYear);
    if (null != qry && !"".equals(qry)) {
    	pstmt.setString(++col_idx, qry.toUpperCase() + "%");
    }
    rs          = pstmt.executeQuery();

    while( rs.next() ) {
        mng_no = rs.getString("mng_no");
        sExcelFileName = rs.getString("oent_file");
        
        msg = doProcessFile(request, response, mng_no, sExcelFileName);
        
        if ("".equals(msg.trim())) {
        	++cnt;
        }
        ++sum;
        
        result += msg;
    }
    
    conn.commit();
    result += cnt + "/" + sum + "개 추출 완료";
    
    rs.close();
} catch(Exception e){
    e.printStackTrace();
    result += "Main : " + e.getMessage();
} finally {
    if ( rs != null )       try{rs.close();}    catch(Exception e){}
    if ( pstmt != null )    try{pstmt.close();} catch(Exception e){}
    if ( conn != null )     try{conn.close();}  catch(Exception e){}
    if ( resource != null ) resource.release();
}
/*
request.setAttribute("result", result.replace("\n", "<br>"));
RequestDispatcher view = request.getRequestDispatcher("CollectResult.jsp");
view.forward(request, response);
*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>추출 결과</title>
</head>
<body>
<%= result.replaceAll("\n", "<br>") %>
</body>
</html>