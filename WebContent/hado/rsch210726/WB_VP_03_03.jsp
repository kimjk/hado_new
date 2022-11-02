<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명     : 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명     : WB_VP_03_03.jsp
* 프로그램설명    : 하도급 거래현황 등록
* 프로그램버전    : 3.0.1
* 최초작성일자    : 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
*   작성일자        작성자명                내용
*=========================================================
*   2014-09-14  정광식    최초작성
*   2015-12-30  정광식     DB변경으로 인한 인코딩 변경
*   2016-04-12  박원영     조사표 변경 및 오류 수정
*   2016-04-14  박원영     연계문항 시 체크박스 해당 없는 항목 비활성화 추가
*   2018-06-22  김보선   fn_TotalPayCheck 안내 문구 추가
*   2018-06-26  김보선   research2f, research3f 체크시 문항의 -1, -2가 붙은 문항 예외처리
*   2018-06-28  김보선   연계문항 오류 수정
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<%@ include file="../Include/WB_Inc_chkSession.jsp"%>
<%
ConnectionResource resource = null;
Connection conn  = null;
PreparedStatement pstmt  = null;
ResultSet rs = null;

String sSQLs    = "";
/**
* 입력정보 저장 변수 선언 및 초기화 시작
*/
String[][][] qa   = new String[30][50][30];
String[][][] opay = new String[3][3][9];
String[][] arrType  = new String[4][9];
String[][] arrTerm  = new String[4][9];

String sSubconType  = ""; // 하도급거래형태
String sOentStatus    = ""; // 전송여부
String sCompStatus    = ""; // 회사영업상태
String sOentSsale = "0";        // 하도급 거래금액

// Cookie Request
String sMngNo   = ckMngNo;
String sOentYYYY  = ckCurrentYear;
String sCurrentYear = ckCurrentYear;
String sOentGB    = ckOentGB;

int np = 0;
int nAnswerCnt = 0;

/* 항목표시중 과년도 항목 표시 계산을 위해 조사년도 정수형 변환 */
int nCurrentYear = 0;
if( !ckCurrentYear.equals("") ) {
  nCurrentYear = Integer.parseInt(ckCurrentYear);
}


/**
* 입력정보 저장 변수 선언 및 초기화 끝
*/

if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
  // 배열 초기화
  String tmpAns = "";
  for (int ni = 0; ni < 30; ni++) {
    for (int nj = 0; nj < 50; nj++) {
      for (int nk = 0; nk < 30; nk++) {
        
        if(
          (ni == 6 && nk == 20) ||
          (ni == 7 && nk == 20) ||
          (ni == 8 && nk == 20) ||
          (ni == 9 && nk == 20) ||
          (ni == 10 && (nj == 11 || nj == 12 || nj == 13 || nj == 14) && nk == 20) ||
          (ni == 11 && nk == 20) ||
          (ni == 15 && nk == 20) ||
          (ni == 16 && nk == 20) ||
          (ni == 17 && nk == 20) ||
          (ni == 20 && (nj == 21 || nj == 22 || nj == 23) && nk == 20)
        ) tmpAns = "0";
        else tmpAns = "";
        
        
        
        qa[ni][nj][nk] = tmpAns;
      }
    }
  }
  for (int ni = 0; ni < 3; ni++) {
    for (int nj = 0; nj < 3; nj++) {
      for (int nk = 0; nk < 9; nk++) {
        opay[ni][nj][nk] = "0";
      }
    }
  }

  for(int ni = 1; ni < 4; ni++) {
    for(int nx = 1; nx < 9; nx++) {
      arrType[ni][nx] = "0";
      arrTerm[ni][nx] = "0";
    }
  }

  try {
    resource  = new ConnectionResource();
    conn    = resource.getConnection();

    // 해당업체 전송여부 가져오기
    // Subcon_Type : 하도급거래형태 (1:주기만함, 2:주기도하고받기도함, 3:받기만함, 4:받지도주지도않음)
    // Comp_Status : 영업상태 (1: 정상영업 <-- 통계반영)
    // Oent_Status : 전송여부 (1: 전송)
        // Oent_Ssale : 전체 하도급거래금액[VAT 포함 금액]
    sSQLs  ="SELECT Subcon_Type, Comp_Status, Oent_Status, Oent_Ssale \n";
    sSQLs+="FROM HADO_TB_Oent_"+ckCurrentYear+" \n";
    sSQLs+= "WHERE Mng_No = ? AND Current_Year = ? AND Oent_Gb = ? \n";

    pstmt = conn.prepareStatement(sSQLs);
    pstmt.setString(1, sMngNo);
    pstmt.setString(2, sCurrentYear);
    pstmt.setString(3, sOentGB);

    //System.out.println("쿼리1 = "+sSQLs);

    rs = pstmt.executeQuery();

    if (rs.next()) {
      sSubconType = rs.getString("Subcon_Type")== null ? "":rs.getString("Subcon_Type").trim();
      sCompStatus = rs.getString("Comp_Status")== null ? "":rs.getString("Comp_Status").trim();
      sOentStatus = rs.getString("Oent_Status")== null ? "":rs.getString("Oent_Status").trim();
            sOentSsale = rs.getString("Oent_Ssale")==null ? "0":rs.getString("Oent_Ssale").trim();
    }
    //System.out.println("값 : "+sOentStatus);
    rs.close();

    int qcd = 0;
    int qgb = 0;

    // 해당업체 응답내역 가져오기
    sSQLs  ="SELECT * \n";
    sSQLs+="FROM HADO_TB_Oent_Answer_"+ckCurrentYear+" \n";
    sSQLs+= "WHERE Mng_No = ? AND Current_Year = ? AND Oent_Gb = ? \n";

    pstmt = conn.prepareStatement(sSQLs);
    pstmt.setString(1, sMngNo);
    pstmt.setString(2, sCurrentYear);
    pstmt.setString(3, sOentGB);

    //System.out.println("쿼리2 = "+sSQLs);

    rs = pstmt.executeQuery();

    nAnswerCnt = 0;

    while (rs.next()) {
      qcd               = rs.getInt("Oent_q_cd");
      qgb               = rs.getInt("Oent_q_gb");
      qa[qcd][qgb][1]   = rs.getString("A")== null ? "":new String( rs.getString("A"));
      qa[qcd][qgb][2]   = rs.getString("B")== null ? "":new String( rs.getString("B"));
      qa[qcd][qgb][3]   = rs.getString("C")== null ? "":new String( rs.getString("C"));
      qa[qcd][qgb][4]   = rs.getString("D")== null ? "":new String( rs.getString("D"));
      qa[qcd][qgb][5]   = rs.getString("E")== null ? "":new String( rs.getString("E"));
      qa[qcd][qgb][6]   = rs.getString("F")== null ? "":new String( rs.getString("F"));
      qa[qcd][qgb][7]   = rs.getString("G")== null ? "":new String( rs.getString("G"));
      qa[qcd][qgb][8]   = rs.getString("H")== null ? "":new String( rs.getString("H"));
      qa[qcd][qgb][9]   = rs.getString("I")== null ? "":new String( rs.getString("I"));
      qa[qcd][qgb][10]    = rs.getString("J")== null ? "":new String( rs.getString("J"));
      qa[qcd][qgb][11]    = rs.getString("K")== null ? "":new String( rs.getString("K"));
      qa[qcd][qgb][12]    = rs.getString("L")== null ? "":new String( rs.getString("L"));
      qa[qcd][qgb][13]    = rs.getString("M")== null ? "":new String( rs.getString("M"));
      qa[qcd][qgb][14]    = rs.getString("N")== null ? "":new String( rs.getString("N"));
      qa[qcd][qgb][20]    = rs.getString("Subj_Ans")== null ? "":rs.getString("Subj_Ans").trim();

      nAnswerCnt++;
    }
    rs.close();

    if( nAnswerCnt <= 0 ) {
      // 응답내역이 없는 경우 임시테이블에 임시저장한 정보가 있는지 확인
      sSQLs  ="SELECT * \n";
      sSQLs+="FROM HADO_TMP_OENT_ANSWER_"+ckCurrentYear+" \n";
      sSQLs+="WHERE Mng_No = ? AND Current_Year = ? AND Oent_Gb = ? \n";
      sSQLs+="ORDER BY Oent_Q_CD, Oent_Q_GB \n";

      pstmt = conn.prepareStatement(sSQLs);
      pstmt.setString(1, sMngNo);
      pstmt.setString(2, sCurrentYear);
      pstmt.setString(3, sOentGB);

      //System.out.println("쿼리3 = "+sSQLs);

      rs = pstmt.executeQuery();

      while (rs.next()) {
      qcd               = rs.getInt("Oent_q_cd");
      qgb               = rs.getInt("Oent_q_gb");
      qa[qcd][qgb][1]   = rs.getString("A")== null ? "":new String( rs.getString("A"));
      qa[qcd][qgb][2]   = rs.getString("B")== null ? "":new String( rs.getString("B"));
      qa[qcd][qgb][3]   = rs.getString("C")== null ? "":new String( rs.getString("C"));
      qa[qcd][qgb][4]   = rs.getString("D")== null ? "":new String( rs.getString("D"));
      qa[qcd][qgb][5]   = rs.getString("E")== null ? "":new String( rs.getString("E"));
      qa[qcd][qgb][6]   = rs.getString("F")== null ? "":new String( rs.getString("F"));
      qa[qcd][qgb][7]   = rs.getString("G")== null ? "":new String( rs.getString("G"));
      qa[qcd][qgb][8]   = rs.getString("H")== null ? "":new String( rs.getString("H"));
      qa[qcd][qgb][9]   = rs.getString("I")== null ? "":new String( rs.getString("I"));
      qa[qcd][qgb][10]    = rs.getString("J")== null ? "":new String( rs.getString("J"));
      qa[qcd][qgb][11]    = rs.getString("K")== null ? "":new String( rs.getString("K"));
      qa[qcd][qgb][12]    = rs.getString("L")== null ? "":new String( rs.getString("L"));
      qa[qcd][qgb][13]    = rs.getString("M")== null ? "":new String( rs.getString("M"));
      qa[qcd][qgb][14]    = rs.getString("N")== null ? "":new String( rs.getString("N"));
      qa[qcd][qgb][20]    = rs.getString("Subj_Ans")== null ? "":rs.getString("Subj_Ans").trim();
      }
      rs.close();
    }

    /* int rpg = 0;
    int hg = 0;

    // 하도급대금 지급 대하여
    sSQLs  ="SELECT * \n";
    sSQLs+="FROM HADO_TB_Rec_Pay_"+ckCurrentYear+" \n";
    sSQLs+="WHERE Mng_No = ? AND Current_Year = ? AND Oent_Gb = ? \n";
    sSQLs+="Order By Oent_Q_CD, Oent_Q_GB, Rec_Pay_GB \n";

    pstmt = conn.prepareStatement(sSQLs);
    pstmt.setString(1, sMngNo);
    pstmt.setString(2, sCurrentYear);
    pstmt.setString(3, sOentGB);

    //System.out.println("쿼리4 = "+sSQLs);

    rs = pstmt.executeQuery();

    while (rs.next()) {
      rpg             = rs.getInt("Rec_Pay_GB");
      hg              = rs.getInt("Half_GB"); // 상,하반기 구분 (2005년부터 하반기만 받고 있음 : Half_gb='1')
      opay[rpg][hg][1]  = rs.getString("Currency")== null ? "":new String(rs.getString("Currency"));  // 현금
      opay[rpg][hg][2]  = rs.getString("Ent_Card")== null ? "":new String(rs.getString("Ent_Card"));  // 기업구매전용카드
      opay[rpg][hg][3]  = rs.getString("Ent_Loan")== null ? "":new String(rs.getString("Ent_Loan"));  // 기업구매자금대출
      opay[rpg][hg][4]  = rs.getString("Cred_Loan")== null ? "":new String(rs.getString("Cred_Loan"));  // 외상매출채권담보대츨
      opay[rpg][hg][5]  = rs.getString("Buy_Loan")== null ? "":new String(rs.getString("Buy_Loan"));  // 구매론
      opay[rpg][hg][6]  = rs.getString("Network_Loan")== null ? "":new String(rs.getString("Network_Loan"));  // 네트워크론
      opay[rpg][hg][7]  = rs.getString("Bill")== null ? "":new String(rs.getString("Bill"));  // 어음
      opay[rpg][hg][8]  = rs.getString("Etc")== null ? "":new String(rs.getString("Etc"));  // 기타
    }
    rs.close(); */

  } catch(Exception e){
    e.printStackTrace();
  } finally {
    if ( rs != null ) try{rs.close();}    catch(Exception e){}
    if ( pstmt != null )  try{pstmt.close();} catch(Exception e){}
    if ( conn != null )   try{conn.close();}  catch(Exception e){}
    if ( resource != null ) resource.release();
  }
}
/*=====================================================================================================*/
%>
<%!
public String setHiddenValue(String[][][] arrVal,int ni, int nx, int gesu)
{
    String retValue = "";
    if ( ni > 0 && nx > 0 && gesu > 0 ) {
        for(int np=1; np<=gesu; np++) {
            if( arrVal[ni][nx][np]!=null && arrVal[ni][nx][np].equals("1") ) {
                retValue = np+"";
            }
        }
    }
    return retValue;
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--[if lt IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie6"><![endif]-->
<!--[if IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie7"><![endif]-->
<!--[if IE 8]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie8"><![endif]-->
<!--[if (gt IE 8)|!(IE)]><!-->
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko-KR" class="no-js">
<!--<![endif]-->
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta http-equiv='Cache-Control' content='no-cache'/>
    <meta http-equiv='Pragma' content='no-cache'/>

    <title><%= nCurrentYear %>년도 하도급거래 서면실태 조사</title>
    
    <link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="euc-kr" />
    <link href="style.css" rel="stylesheet" type="text/css" />

    <!-- // IE  // -->
    <!--[if IE]><script src="../js/html5.js"></script><![endif]-->
    <!--[if IE 7]>
    <script src="../js/ie7/IE7.js"  type="text/javascript"></script>
    <script src="../js/ie7/ie7-squish.js"  type="text/javascript"></script>
    <![endif]-->
    <script src="../js/jquery-1.7.min.js"></script>
    <script type="text/javascript">jQuery.noConflict();</script>
    <script src="../js/mootools-core-1.3.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/mootools-more-1.3.1.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/simplemodal.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/commonScript.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/login.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/credian_common_script.js" type="text/javascript"  charset="euc-kr"></script>
    <script type="text/javascript">

        var msg     = "";
        var radiof  = false;

        jQuery(function() {
            onDocument();
        });

        function savef() {
            var cchekc  ="no";
            var stype   = "<%=sSubconType%>";
            var sCompStatus = "<%=sCompStatus%>";
            var main    = document.info;
            var totalPayCheck = Cnum("<%=sOentSsale %>");
            msg = "";

          // 정상영업 + 하도급거래있음(주기만함[1],주기도하고받기만함[2]) 일경우 체크
      //if( (stype == "1" || stype=="2") && sCompStatus == "1" ) {
      // 하도급거래있음(주기만함[1],주기도하고받기만함[2]) 일경우 체크
      research2f(main, 5, 1, 2, 0);
      if( main.q2_5_1[2].checked==true ) {
        
        initf(main, 6, 1, 1, 0);  initf(main, 6, 2, 1, 0);  initf(main, 6, 3, 1, 0); 
        
        initf(main, 7, 1, 1, 0);  initf(main, 7, 2, 1, 0);  initf(main, 7, 3, 1, 0);
        
        initf(main, 8, 1, 2, 0);  
        
        initf(main, 9, 1, 1, 0);  initf(main, 9, 2, 1, 0);  initf(main, 9, 3, 1, 0);  initf(main, 9, 4, 1, 0);
        
        initf(main, 10, 1, 2, 0); initf(main, 10, 2, 2, 0); initf(main, 10, 3, 2, 0); initf(main, 10, 18, 1, 0);
        initf(main, 10, 11, 1, 0);  initf(main, 10, 12, 1, 0);  initf(main, 10, 13, 1, 0);  initf(main, 10, 14, 1, 0);
        initf(main, 10, 5, 2, 0); initf(main, 10, 6, 2, 0); initf(main, 10, 19, 1, 0);
        
        initf(main, 11, 11, 1, 0);  initf(main, 11, 12, 1, 0);  initf(main, 11, 13, 1, 0);  initf(main, 11, 14, 1, 0);
        initf(main, 11, 15, 1, 0);  initf(main, 11, 16, 1, 0);  initf(main, 11, 17, 1, 0);  initf(main, 11, 20, 2, 0);
        initf(main, 11, 21, 2, 0);  initf(main, 11, 22, 2, 0);  initf(main, 11, 23, 2, 0);  initf(main, 11, 24, 2, 0);
        initf(main, 11, 25, 2, 0);  initf(main, 11, 26, 2, 0);  initf(main, 11, 27, 2, 0);  initf(main, 11, 28, 2, 0);
        initf(main, 11, 3, 2, 0);
        
        initf(main, 12, 1, 2, 0); initf(main, 12, 2, 3, 6); initf(main, 12, 29, 1, 0);
        
        initf(main, 13, 1, 2, 0); initf(main, 13, 2, 3, 8); initf(main, 13, 29, 1, 0);
        
        initf(main, 14, 1, 2, 0); initf(main, 14, 2, 3, 11);  initf(main, 14, 29, 1, 0);
        
        initf(main, 15, 11, 1, 0);  initf(main, 15, 12, 1, 0);  initf(main, 15, 13, 1, 0);  initf(main, 15, 14, 1, 0);
        initf(main, 15, 15, 1, 0);  initf(main, 15, 16, 1, 0);  initf(main, 15, 17, 1, 0);  initf(main, 15, 18, 1, 0);
        initf(main, 15, 19, 1, 0);  initf(main, 15, 20, 1, 0);  initf(main, 15, 21, 1, 0);  initf(main, 15, 22, 1, 0);
        initf(main, 15, 23, 1, 0);  initf(main, 15, 24, 1, 0);  initf(main, 15, 25, 1, 0);  initf(main, 15, 26, 1, 0);
        initf(main, 15, 27, 1, 0);  initf(main, 15, 28, 1, 0);  initf(main, 15, 29, 1, 0);  initf(main, 15, 30, 1, 0);
        initf(main, 15, 2, 2, 0); initf(main, 15, 31, 1, 0);  initf(main, 15, 32, 1, 0);  initf(main, 15, 33, 1, 0);
        initf(main, 15, 34, 1, 0);  initf(main, 15, 41, 1, 0);  initf(main, 15, 42, 1, 0);  initf(main, 15, 43, 1, 0);
        initf(main, 15, 44, 1, 0);  initf(main, 15, 4, 2, 0);
        
        initf(main, 16, 1, 2, 0); initf(main, 16, 11, 1, 0);  initf(main, 16, 12, 1, 0);  initf(main, 16, 13, 1, 0);
        initf(main, 16, 14, 1, 0);  initf(main, 16, 3, 2, 0);
        
        initf(main, 17, 1, 1, 0); initf(main, 17, 2, 1, 0); initf(main, 17, 3, 1, 0); initf(main, 17, 4, 1, 0);
        initf(main, 17, 5, 1, 0); initf(main, 17, 6, 1, 0); initf(main, 17, 7, 1, 0);
        
        initf(main, 18, 1, 2, 0); initf(main, 18, 2, 3, 5); initf(main, 18, 29, 1, 0);
        
        initf(main, 19, 1, 2, 0); initf(main, 19, 2, 3, 4); initf(main, 19, 11, 1, 0);  initf(main, 19, 3, 3, 4);
        initf(main, 19, 4, 2, 0); initf(main, 19, 12, 1, 0);  initf(main, 19, 5, 2, 0); initf(main, 19, 6, 2, 0);
        initf(main, 19, 13, 1, 0);  initf(main, 19, 7, 2, 0);
        
        initf(main, 20, 1, 2, 0); initf(main, 20, 21, 1, 0);  initf(main, 20, 22, 1, 0);  initf(main, 20, 23, 1, 0);
        initf(main, 20, 3, 3, 5); initf(main, 20, 39, 1, 0);  initf(main, 20, 41, 2, 0);  initf(main, 20, 42, 2, 0);
        initf(main, 20, 43, 2, 0);  initf(main, 20, 44, 2, 0);  initf(main, 20, 45, 2, 0);
      
      }
      else {
        
        research2f_txt(main, 7, 1, 1, 0, '2018년도 하도급을 준 금액');
        research2f_txt(main, 7, 2, 1, 0, '2019년도 하도급을 준 금액');
        research2f_txt(main, 7, 3, 1, 0, '2020년도 하도급을 준 금액');
        research2f_txt(main, 9, 1, 1, 0, '총 매출 사업자 수');
        research2f_txt(main, 9, 2, 1, 0, '귀사에게 하도급을 준 원사업자 수');
        research2f_txt(main, 9, 3, 1, 0, '총 매입 사업자 수');
        research2f_txt(main, 9, 4, 1, 0, '귀사가 하도급을 준 수급사업자 수');
        
        research2f(main, 8, 1, 2, 0);
        research2f(main, 10, 1, 2, 0);
        research2f(main, 10, 2, 2, 0);
        research2f(main, 10, 5, 2, 0);
        research2f_txt(main, 11, 20, 2, 0, '(2)항목의 1)귀사의 인건비 변화');
        research2f_txt(main, 11, 21, 2, 0, '(2)항목의 2)귀사가 구입한 원자재 가격 변화');
        research2f_txt(main, 11, 22, 2, 0, '(2)항목의 3)수급사업자의 생산성 변화');
        research2f_txt(main, 11, 23, 2, 0, '(2)항목의 4)수급사업자의 인건비 변화');
        research2f_txt(main, 11, 24, 2, 0, '(2)항목의 5)수급사업자가 구입한 원자재 가격 변화');
        research2f_txt(main, 11, 25, 2, 0, '(2)항목의 6)발주(구매)한 물량 변화');
        research2f_txt(main, 11, 26, 2, 0, '(2)항목의 7)환율 변화');
        research2f_txt(main, 11, 27, 2, 0, '(2)항목의 8)시장 가격경쟁 정도 변화');
        research2f_txt(main, 11, 28, 2, 0, '(2)항목의 9)기타');
        research2f(main, 11, 3, 2, 0);
        research2f(main, 12, 1, 2, 0);
        research2f(main, 13, 1, 2, 0);
        research2f(main, 14, 1, 2, 0);
        research2f_txt(main, 15, 11, 1, 0, '(1)항목의 중소기업 수급사업자에게 현금 지급한 비율');
        research2f_txt(main, 15, 12, 1, 0, '(1)항목의 중소기업 수급사업자에게 외상매출채권 담보대출 지급한 비율');
        research2f_txt(main, 15, 13, 1, 0, '(1)항목의 중소기업 수급사업자에게 기업구매전용카드 지급한 비율');
        research2f_txt(main, 15, 14, 1, 0, '(1)항목의 중소기업 수급사업자에게 구매론 지급한 비율');
        research2f_txt(main, 15, 15, 1, 0, '(1)항목의 중소기업 수급사업자에게 상생결제 시스템 지급한 비율');
        research2f_txt(main, 15, 16, 1, 0, '(1)항목의 중소기업 수급사업자에게 위 어음대체결제수단 지급한 비율');
        research2f_txt(main, 15, 17, 1, 0, '(1)항목의 중소기업 수급사업자에게 어음(만기 60일 이하) 지급한 비율');
        research2f_txt(main, 15, 18, 1, 0, '(1)항목의 중소기업 수급사업자에게 어음(만기 61~120일) 지급한 비율');
        research2f_txt(main, 15, 19, 1, 0, '(1)항목의 중소기업 수급사업자에게 어음(만기 121일 초과) 지급한 비율');
        research2f_txt(main, 15, 20, 1, 0, '(1)항목의 중소기업 수급사업자에게 기타 지급한 비율');
        research2f_txt(main, 15, 21, 1, 0, '(1)항목의 중견기업 수급사업자에게 현금 지급한 비율');
        research2f_txt(main, 15, 22, 1, 0, '(1)항목의 중견기업 수급사업자에게 외상매출채권 담보대출 지급한 비율');
        research2f_txt(main, 15, 23, 1, 0, '(1)항목의 중견기업 수급사업자에게 기업구매전용카드 지급한 비율');
        research2f_txt(main, 15, 24, 1, 0, '(1)항목의 중견기업 수급사업자에게 구매론 지급한 비율');
        research2f_txt(main, 15, 25, 1, 0, '(1)항목의 중견기업 수급사업자에게 상생결제 시스템 지급한 비율');
        research2f_txt(main, 15, 26, 1, 0, '(1)항목의 중견기업 수급사업자에게 위 어음대체결제수단 지급한 비율');
        research2f_txt(main, 15, 27, 1, 0, '(1)항목의 중견기업 수급사업자에게 어음(만기 60일 이하) 지급한 비율');
        research2f_txt(main, 15, 28, 1, 0, '(1)항목의 중견기업 수급사업자에게 어음(만기 61~120일) 지급한 비율');
        research2f_txt(main, 15, 29, 1, 0, '(1)항목의 중견기업 수급사업자에게 어음(만기 121일 초과) 지급한 비율');
        research2f_txt(main, 15, 30, 1, 0, '(1)항목의 중견기업 수급사업자에게 기타 지급한 비율');
        research2f(main, 15, 2, 2, 0);
        research2f(main, 16, 1, 2, 0);
        research2f_txt(main, 17, 1, 1, 0, '(1)자금 지원 업체 수');
        research2f_txt(main, 17, 2, 1, 0, '(1)물자 지원 업체 수');
        research2f_txt(main, 17, 3, 1, 0, '(1)인력 지원 업체 수');
        research2f_txt(main, 17, 4, 1, 0, '(1)기술 지원 업체 수');
        research2f_txt(main, 17, 5, 1, 0, '(1)경영 지원 업체 수');
        research2f_txt(main, 17, 6, 1, 0, '(1)판로 지원 업체 수');
        research2f_txt(main, 17, 7, 1, 0, '(1)기타 지원 업체 수');
        research2f(main, 18, 1, 2, 0);
        research2f(main, 19, 1, 2, 0);
        research2f(main, 20, 1, 2, 0);
        research2f_txt(main, 21, 20, 2, 0, '(1) 3배 손해배상제 적용대상 확대');
        research2f_txt(main, 21, 21, 2, 0, '(2) 부당특약 금지');
        research2f_txt(main, 21, 22, 2, 0, '(3) 하도급대금 지급보증 제도 보완 ');
        research2f_txt(main, 21, 23, 2, 0, '(4) 중소기업협동조합에 납품단가조정협의권을 부여');
        research2f_txt(main, 21, 24, 2, 0, '(5) 조사개시 전 법위반 행위 자진시정 시 제재 면제');
        research2f_txt(main, 21, 25, 2, 0, '(6) 중견기업의 수급사업자 보호대상 포함');
        research2f_txt(main, 21, 26, 2, 0, '(7) 신고포상금 지급');
        research2f_txt(main, 21, 27, 2, 0, '(8) 조사개시 후 대금 미지급 자진시정 시 벌점 부과 면제');
        research2f_txt(main, 21, 28, 2, 0, '(9) 단순기술 유출도 위법행위로 인정');
        research2f_txt(main, 21, 29, 2, 0, '(10) 기술탈취 행위에 대한 조사시효를 3년에서 7년으로 연장 답');
        research2f_txt(main, 21, 30, 2, 0, '(11) 경영정보 요구 금지, 특정 사업자와 거래유도 금지, 기술 수출 제한 행위 금지');

        if( main.q2_5_1[1].checked==true ) {
          initf(main, 6, 1, 1, 0);  initf(main, 6, 2, 1, 0);  initf(main, 6, 2, 1, 0);
        }
        else {
          research3f_txt(main, 6, 1, 1, 0, 5, 1, '(1)문항의 2017년도 하도급을 받은 금액');
          research3f_txt(main, 6, 2, 1, 0, 5, 1, '(1)문항의 2018년도 하도급을 받은 금액');
          research3f_txt(main, 6, 3, 1, 0, 5, 1, '(1)문항의 2019년도 하도급을 받은 금액');
        }
        
        if( main.q2_10_2[0].checked==true ) {
          initf(main, 10, 3, 2, 0); initf(main, 10, 18, 1, 0);  initf(main, 10, 11, 1, 0);  initf(main, 10, 12, 1, 0);
          initf(main, 10, 13, 1, 0);  initf(main, 10, 14, 1, 0);
        }
        else {
          research3f(main, 10, 3, 2, 0, 10, 2);
          
          if( main.q2_10_3[1].checked==true ) {
            initf(main, 10, 11, 1, 0);
            initf(main, 10, 12, 1, 0);
            initf(main, 10, 13, 1, 0);
            initf(main, 10, 14, 1, 0);
          }
          else {
            research3f_txt(main, 10, 11, 1, 0, 10, 2, '(4)문항의 15일 이내 총 회신 건수');
            research3f_txt(main, 10, 12, 1, 0, 10, 2, '(4)문항의 서면 회신 건수');
            research3f_txt(main, 10, 13, 1, 0, 10, 2, '(4)문항의 구두 회신 건수');
            research3f_txt(main, 10, 14, 1, 0, 10, 2, '(4)문항의 15일 이후 회신 또는 회신하지 않은 건수');
          }
        }
        
        
        if( main.q2_10_5[0].checked==true ) initf(main, 10, 6, 2, 0); else research3f(main, 10, 6, 2, 0, 10, 5);
        
        if( main.q2_12_1[0].checked==true ) initf(main, 12, 2, 3, 6); else research3f(main, 12, 2, 3, 6, 12, 1);
        
        if( main.q2_13_1[0].checked==true ) initf(main, 13, 2, 3, 8); else research3f(main, 13, 2, 3, 8, 13, 1);
        
        if( main.q2_14_1[0].checked==true ) initf(main, 14, 2, 3, 11); else research3f(main, 14, 2, 3, 11, 14, 1);
        
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 31, 1, 0); else research3f_txt(main, 15, 31, 1, 0, 15, 2, '(3)문항의  중소기업 수급사업자에게 현금 지급한 비율');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 32, 1, 0); else research3f_txt(main, 15, 32, 1, 0, 15, 2, '(3)문항의  중소기업 수급사업자에게 어음대체 결제수단 지급한 비율');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 33, 1, 0); else research3f_txt(main, 15, 33, 1, 0, 15, 2, '(3)문항의  중소기업 수급사업자에게 어음 지급한 비율');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 34, 1, 0); else research3f_txt(main, 15, 34, 1, 0, 15, 2, '(3)문항의  중소기업 수급사업자에게 기타 지급한 비율');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 41, 1, 0); else research3f_txt(main, 15, 41, 1, 0, 15, 2, '(3)문항의  중견기업 수급사업자에게 현금 지급한 비율');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 42, 1, 0); else research3f_txt(main, 15, 42, 1, 0, 15, 2, '(3)문항의  중견기업 수급사업자에게 어음대체 결제수단 지급한 비율');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 43, 1, 0); else research3f_txt(main, 15, 43, 1, 0, 15, 2, '(3)문항의  중견기업 수급사업자에게 어음 지급한 비율');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 44, 1, 0); else research3f_txt(main, 15, 44, 1, 0, 15, 2, '(3)문항의  중견기업 수급사업자에게 기타 지급한 비율');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 4, 2, 0); else research3f(main, 15, 4, 2, 0, 15, 2);
        
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 11, 1, 0); else research3f_txt(main, 16, 11, 1, 0, 16, 1, '(2)문항의  직접 하도급대금 조정신청한 수급사업자 수');
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 12, 1, 0); else research3f_txt(main, 16, 12, 1, 0, 16, 1, '(2)문항의  직접 하도급대금 조정신청한 수급사업자와 10일 이내에 협의를 개시한 업체 수');
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 13, 1, 0); else research3f_txt(main, 16, 13, 1, 0, 16, 1, '(2)문항의  중소기업협동조합을 통해 조정신청한 수급사업자 수');
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 14, 1, 0); else research3f_txt(main, 16, 14, 1, 0, 16, 1, '(2)문항의  중소기업협동조합을 통해 조정신청한 수급사업자와 10일 이내에 협의를 개시한 업체 수');
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 3, 2, 0); else research3f(main, 16, 3, 2, 0, 16, 1);
        
        if( main.q2_18_1[1].checked==true ) initf(main, 18, 2, 3, 5); else research3f(main, 18, 2, 3, 5, 18, 1);
        
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 2, 3, 4); else research3f(main, 19, 2, 3, 4, 19, 1);
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 3, 3, 4); else research3f(main, 19, 3, 3, 4, 19, 1);
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 4, 2, 0); else research3f(main, 19, 4, 2, 0, 19, 1);
        if( main.q2_19_1[1].checked==true ) {
          initf(main, 19, 5, 2, 0);
        }
        else {
          if( main.q2_19_4[1].checked==true ) initf(main, 19, 5, 2, 0); else research3f(main, 19, 5, 2, 0, 19, 1);
        }
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 6, 2, 0); else research3f(main, 19, 6, 2, 0, 19, 1);
        if( main.q2_19_1[1].checked==true ) {
          initf(main, 19, 7, 2, 0);
        }
        else {
          if( main.q2_19_6[1].checked==true ) initf(main, 19, 7, 2, 0); else research3f(main, 19, 7, 2, 0, 19, 1);
        }
        
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 21, 1, 0); else research3f_txt(main, 20, 21, 1, 0, 20, 1, '(2)문항의 전속거래 업체 수 비중');//
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 22, 1, 0); else research3f_txt(main, 20, 22, 1, 0, 20, 1, '(2)문항의 전속거래로부터 구매 비중');//
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 23, 1, 0); else research3f_txt(main, 20, 23, 1, 0, 20, 1, '(2)문항의 전속거래 평균 기간');//
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 3, 3, 5);  else research3f(main, 20, 3, 3, 5, 20, 1);
        /*
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 41, 2, 0); else research3f_txt(main, 20, 41, 2, 0, 20, 1, '(3)문항의 1)품질 유지');
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 42, 2, 0); else research3f_txt(main, 20, 42, 2, 0, 20, 1, '(3)문항의 2)원가 경쟁력 유지');
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 43, 2, 0); else research3f_txt(main, 20, 43, 2, 0, 20, 1, '(3)문항의 3)기술유출 방지');
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 44, 2, 0); else research3f_txt(main, 20, 44, 2, 0, 20, 1, '(3)문항의 4)안정적 물량 조달');
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 45, 2, 0); else research3f_txt(main, 20, 45, 2, 0, 20, 1, '(3)문항의 5)기타');
          */
      }
            //} else {
                //msg = "하도급거래가 없거나 받기만하는 경우\n[하도급거래상황]은 작성하지 않습니다.\n\n해당 도움말을 참조하여 주십시오.";
            //}

            if(msg=="") {
                if(confirm("[ 조사표내용을 저장합니다. ]\n\n접속자가 많을경우 다소 시간이 걸릴수도 있습니다.\n정상적으로 저장이 안될경우\n수십분후에 다시시도하여 주십시오.\n\n서버의 부하로 저장에 실패할경우\n응답하신 조사내용을 복구할 수 없습니다.\n응답하신 조사표를 인쇄하여 보관하시고\n오류페이지에서 마우스오른쪽 버튼을 눌러\n새로고침을 선택하여 재저장을 시도하십시오.\n\n확인을 누르시면 저장합니다.")) {
                    
                    processSystemStart("[1/1] 입력한 하도급거래현황을 저장합니다.");

                    main.target = "ProceFrame";
                    main.action = "WB_CP_Research_Qry.jsp?type=Srv&step=Detail";
                    main.submit();
                }
            } else {
                alert(msg+"\n\n저장이 취소되었습니다.")
            }

        }
        
        /**
         * 2. 회사개요 탭의 전체 하도급거래금액[VAT 포함 금액]이
         * 하도급 대금 지급사항의 합계(중소기업 + 중견기업)보다 
         * 적을경우 저장제한
         * @param: total (2번 회사개요탭의 전체 하도급거래금액)
         * @param: main (form객체)
         */
        function fn_TotalPayCheck(total, main) {
            var qhap16 = Cnum(main.qhap16.value);
            var qhap25 = Cnum(main.qhap25.value);
            if(total < (qhap16 + qhap25)) {
                msg += '\n\n[안내사항]\n본 하도급대금 지급항목의 금액 입력 단위는 "백만원, 부가가치세포함"\n이므로, 금액단위를 다시 확인 후 입력하여 주시기 바랍니다.';
                <%//2018-06-22 김보선 안내 메시지 추가%>
                msg += ' 또한, \n"2.회사개요"에서 작성 한 <%= nCurrentYear-1 %>년도 전체 하도급거래금액보다 \n"3.하도급 거래상황"에서 작성 한 하도급대금지급 금액이 클 경우 저장되지 않습니다. 다시 확인 후 입력하여 주시기 바랍니다.';
            }
        }

        function savef2(main) {
            var main = document.info;

            if( confirm("[임시저장] 기능은 여러번 나누어서 응답하기 위한 기능입니다.\n\n조사표를 마무리 하기 위해서는 꼭 [저 장] 기능을 이용하셔야 하며,\n[저 장] 기능을 사용하지 않을 경우 [조사표 전송]이 안되오니\n조사표 응답을 완료할때는 필히 [저 장] 기능을 이용하셔야 합니다.\n\n확인을 누르시면 [임시저장] 기능을 실행합니다.") ) {
                
                processSystemStart("[1/1] 입력한 하도급거래현황을 임시저장합니다.");

                main.target = "ProceFrame";
                main.action = "WB_CP_Research_Qry.jsp?type=Srv&step=Temp";
                main.submit();
            }
        }

        function relationf(main) {
            msg = "";
            
      if( main.q2_5_1[2].checked==true ) {
        
        initf(main, 6, 1, 1, 0);  initf(main, 6, 2, 1, 0);  initf(main, 6, 3, 1, 0);
        
        initf(main, 7, 1, 1, 0);  initf(main, 7, 2, 1, 0);  initf(main, 7, 3, 1, 0);
        
        initf(main, 8, 1, 2, 0);
        
        initf(main, 9, 1, 1, 0);  initf(main, 9, 2, 1, 0);  initf(main, 9, 3, 1, 0);  initf(main, 9, 4, 1, 0);
        
        initf(main, 10, 1, 2, 0); initf(main, 10, 2, 2, 0); initf(main, 10, 3, 2, 0); initf(main, 10, 18, 1, 0);
        initf(main, 10, 11, 1, 0);  initf(main, 10, 12, 1, 0);  initf(main, 10, 13, 1, 0);  initf(main, 10, 14, 1, 0);
        initf(main, 10, 5, 2, 0); initf(main, 10, 6, 2, 0); initf(main, 10, 19, 1, 0);
        
        initf(main, 11, 11, 1, 0);  initf(main, 11, 12, 1, 0);  initf(main, 11, 13, 1, 0);  initf(main, 11, 14, 1, 0);
        initf(main, 11, 15, 1, 0);  initf(main, 11, 16, 1, 0);  initf(main, 11, 17, 1, 0);  initf(main, 11, 20, 2, 0);
        initf(main, 11, 21, 2, 0);  initf(main, 11, 22, 2, 0);  initf(main, 11, 23, 2, 0);  initf(main, 11, 24, 2, 0);
        initf(main, 11, 25, 2, 0);  initf(main, 11, 26, 2, 0);  initf(main, 11, 27, 2, 0);  initf(main, 11, 28, 2, 0);
        initf(main, 11, 3, 2, 0);
        
        initf(main, 12, 1, 2, 0); initf(main, 12, 2, 3, 6); initf(main, 12, 29, 1, 0);
        
        initf(main, 13, 1, 2, 0); initf(main, 13, 2, 3, 8); initf(main, 13, 29, 1, 0);
        
        initf(main, 14, 1, 2, 0); initf(main, 14, 2, 3, 11);  initf(main, 14, 29, 1, 0);
        
        initf(main, 15, 11, 1, 0);  initf(main, 15, 12, 1, 0);  initf(main, 15, 13, 1, 0);  initf(main, 15, 14, 1, 0);
        initf(main, 15, 15, 1, 0);  initf(main, 15, 16, 1, 0);  initf(main, 15, 17, 1, 0);  initf(main, 15, 18, 1, 0);
        initf(main, 15, 19, 1, 0);  initf(main, 15, 20, 1, 0);  initf(main, 15, 21, 1, 0);  initf(main, 15, 22, 1, 0);
        initf(main, 15, 23, 1, 0);  initf(main, 15, 24, 1, 0);  initf(main, 15, 25, 1, 0);  initf(main, 15, 26, 1, 0);
        initf(main, 15, 27, 1, 0);  initf(main, 15, 28, 1, 0);  initf(main, 15, 29, 1, 0);  initf(main, 15, 30, 1, 0);
        initf(main, 15, 2, 2, 0); initf(main, 15, 31, 1, 0);  initf(main, 15, 32, 1, 0);  initf(main, 15, 33, 1, 0);
        initf(main, 15, 34, 1, 0);  initf(main, 15, 41, 1, 0);  initf(main, 15, 42, 1, 0);  initf(main, 15, 43, 1, 0);
        initf(main, 15, 44, 1, 0);  initf(main, 15, 4, 2, 0);
        
        initf(main, 16, 1, 2, 0); initf(main, 16, 11, 1, 0);  initf(main, 16, 12, 1, 0);  initf(main, 16, 13, 1, 0);
        initf(main, 16, 14, 1, 0);  initf(main, 16, 3, 2, 0);
        
        initf(main, 17, 1, 1, 0); initf(main, 17, 2, 1, 0); initf(main, 17, 3, 1, 0); initf(main, 17, 4, 1, 0);
        initf(main, 17, 5, 1, 0); initf(main, 17, 6, 1, 0); initf(main, 17, 7, 1, 0);
        
        initf(main, 18, 1, 2, 0); initf(main, 18, 2, 3, 5); initf(main, 18, 29, 1, 0);
        
        initf(main, 19, 1, 2, 0); initf(main, 19, 2, 3, 4); initf(main, 19, 11, 1, 0);  initf(main, 19, 3, 3, 4);
        initf(main, 19, 4, 2, 0); initf(main, 19, 12, 1, 0);  initf(main, 19, 5, 2, 0); initf(main, 19, 6, 2, 0);
        initf(main, 19, 13, 1, 0);  initf(main, 19, 7, 2, 0);
        
        initf(main, 20, 1, 2, 0); initf(main, 20, 21, 1, 0);  initf(main, 20, 22, 1, 0);  initf(main, 20, 23, 1, 0);
        initf(main, 20, 3, 3, 5); initf(main, 20, 39, 1, 0);  initf(main, 20, 41, 2, 0);  initf(main, 20, 42, 2, 0);
        initf(main, 20, 43, 2, 0);  initf(main, 20, 44, 2, 0);  initf(main, 20, 45, 2, 0);
      
      }
      else {
        
        research3f(main, 6, 1, 1, 0, 5, 1); research3f(main, 6, 2, 1, 0, 5, 1); research3f(main, 6, 3, 1, 0, 5, 1);
        
        research3f(main, 7, 1, 1, 0, 5, 1); research3f(main, 7, 2, 1, 0, 5, 1); research3f(main, 7, 3, 1, 0, 5, 1);
        
        research3f(main, 8, 1, 2, 0, 5, 1);
        
        research3f(main, 9, 1, 1, 0, 5, 1); research3f(main, 9, 2, 1, 0, 5, 1); research3f(main, 9, 3, 1, 0, 5, 1); research3f(main, 9, 4, 1, 0, 5, 1);
        
        research3f(main, 10, 1, 2, 0, 5, 1);  research3f(main, 10, 2, 2, 0, 5, 1);  research3f(main, 10, 3, 2, 0, 5, 1);  research3f(main, 10, 18, 1, 0, 5, 1);
        research3f(main, 10, 11, 1, 0, 5, 1); research3f(main, 10, 12, 1, 0, 5, 1); research3f(main, 10, 13, 1, 0, 5, 1); research3f(main, 10, 14, 1, 0, 5, 1);
        research3f(main, 10, 5, 2, 0, 5, 1);  research3f(main, 10, 6, 2, 0, 5, 1);  research3f(main, 10, 19, 1, 0, 5, 1);
        
        research3f(main, 11, 11, 1, 0, 5, 1); research3f(main, 11, 12, 1, 0, 5, 1); research3f(main, 11, 13, 1, 0, 5, 1); research3f(main, 11, 14, 1, 0, 5, 1);
        research3f(main, 11, 15, 1, 0, 5, 1); research3f(main, 11, 16, 1, 0, 5, 1); research3f(main, 11, 17, 1, 0, 5, 1); research3f(main, 11, 20, 2, 0, 5, 1);
        research3f(main, 11, 21, 2, 0, 5, 1); research3f(main, 11, 22, 2, 0, 5, 1); research3f(main, 11, 23, 2, 0, 5, 1); research3f(main, 11, 24, 2, 0, 5, 1);
        research3f(main, 11, 25, 2, 0, 5, 1); research3f(main, 11, 26, 2, 0, 5, 1); research3f(main, 11, 27, 2, 0, 5, 1); research3f(main, 11, 28, 2, 0, 5, 1);
        research3f(main, 11, 3, 2, 0, 5, 1);
        
        research3f(main, 12, 1, 2, 0, 5, 1);  research3f(main, 12, 2, 3, 6, 5, 1);  research3f(main, 12, 29, 1, 0, 5, 1);
        
        research3f(main, 13, 1, 2, 0, 5, 1);  research3f(main, 13, 2, 3, 8, 5, 1);  research3f(main, 13, 29, 1, 0, 5, 1);
        
        research3f(main, 14, 1, 2, 0, 5, 1);  research3f(main, 14, 2, 3, 11, 5, 1); research3f(main, 14, 29, 1, 0, 5, 1);
        
        research3f(main, 15, 11, 1, 0, 5, 1); research3f(main, 15, 12, 1, 0, 5, 1); research3f(main, 15, 13, 1, 0, 5, 1); research3f(main, 15, 14, 1, 0, 5, 1);
        research3f(main, 15, 15, 1, 0, 5, 1); research3f(main, 15, 16, 1, 0, 5, 1); research3f(main, 15, 17, 1, 0, 5, 1); research3f(main, 15, 18, 1, 0, 5, 1);
        research3f(main, 15, 19, 1, 0, 5, 1); research3f(main, 15, 20, 1, 0, 5, 1); research3f(main, 15, 21, 1, 0, 5, 1); research3f(main, 15, 22, 1, 0, 5, 1);
        research3f(main, 15, 23, 1, 0, 5, 1); research3f(main, 15, 24, 1, 0, 5, 1); research3f(main, 15, 25, 1, 0, 5, 1); research3f(main, 15, 26, 1, 0, 5, 1);
        research3f(main, 15, 27, 1, 0, 5, 1); research3f(main, 15, 28, 1, 0, 5, 1); research3f(main, 15, 29, 1, 0, 5, 1); research3f(main, 15, 30, 1, 0, 5, 1);
        research3f(main, 15, 2, 2, 0, 5, 1);  research3f(main, 15, 31, 1, 0, 5, 1); research3f(main, 15, 32, 1, 0, 5, 1); research3f(main, 15, 33, 1, 0, 5, 1);
        research3f(main, 15, 34, 1, 0, 5, 1); research3f(main, 15, 41, 1, 0, 5, 1); research3f(main, 15, 42, 1, 0, 5, 1); research3f(main, 15, 43, 1, 0, 5, 1);
        research3f(main, 15, 44, 1, 0, 5, 1); research3f(main, 15, 4, 2, 0, 5, 1);
        
        research3f(main, 16, 1, 2, 0, 5, 1);  research3f(main, 16, 11, 1, 0, 5, 1); research3f(main, 16, 12, 1, 0, 5, 1); research3f(main, 16, 13, 1, 0, 5, 1);
        research3f(main, 16, 14, 1, 0, 5, 1); research3f(main, 16, 3, 2, 0, 5, 1);
        
        research3f(main, 17, 1, 1, 0, 5, 1);  research3f(main, 17, 2, 1, 0, 5, 1);  research3f(main, 17, 3, 1, 0, 5, 1);  research3f(main, 17, 4, 1, 0, 5, 1);
        research3f(main, 17, 5, 1, 0, 5, 1);  research3f(main, 17, 6, 1, 0, 5, 1);  research3f(main, 17, 7, 1, 0, 5, 1);
        
        research3f(main, 18, 1, 2, 0, 5, 1);  research3f(main, 18, 2, 3, 5, 5, 1);  research3f(main, 18, 29, 1, 0, 5, 1);
        
        research3f(main, 19, 1, 2, 0, 5, 1);  research3f(main, 19, 2, 3, 4, 5, 1);  research3f(main, 19, 11, 1, 0, 5, 1); research3f(main, 19, 3, 3, 4, 5, 1);
        research3f(main, 19, 4, 2, 0, 5, 1);  research3f(main, 19, 12, 1, 0, 5, 1); research3f(main, 19, 5, 2, 0, 5, 1);  research3f(main, 19, 6, 2, 0, 5, 1);
        research3f(main, 19, 13, 1, 0, 5, 1); research3f(main, 19, 7, 2, 0, 5, 1);
        
        research3f(main, 20, 1, 2, 0, 5, 1);  research3f(main, 20, 21, 1, 0, 5, 1); research3f(main, 20, 22, 1, 0, 5, 1); research3f(main, 20, 23, 1, 0, 5, 1);
        research3f(main, 20, 3, 3, 5, 5, 1);  research3f(main, 20, 39, 1, 0, 5, 1); research3f(main, 20, 41, 2, 0, 5, 1); research3f(main, 20, 42, 2, 0, 5, 1);
        research3f(main, 20, 43, 2, 0, 5, 1); research3f(main, 20, 44, 2, 0, 5, 1); research3f(main, 20, 45, 2, 0, 5, 1);
        
        if( main.q2_5_1[1].checked==true ) initf(main, 6, 1, 1, 0); else research3f(main, 6, 1, 1, 0, 5, 1);
        if( main.q2_5_1[1].checked==true ) initf(main, 6, 2, 1, 0); else research3f(main, 6, 2, 1, 0, 5, 1);
        if( main.q2_5_1[1].checked==true ) initf(main, 6, 3, 1, 0); else research3f(main, 6, 3, 1, 0, 5, 1);
        
        if( main.q2_10_2[0].checked==true ) {
          initf(main, 10, 3, 2, 0); initf(main, 10, 18, 1, 0);  initf(main, 10, 11, 1, 0);  initf(main, 10, 12, 1, 0);
          initf(main, 10, 13, 1, 0);  initf(main, 10, 14, 1, 0);
        }
        else {
          research3f(main, 10, 3, 2, 0, 10, 2); research3f(main, 10, 11, 1, 0, 10, 2);  research3f(main, 10, 12, 1, 0, 10, 2);  research3f(main, 10, 13, 1, 0, 10, 2);
          research3f(main, 10, 14, 1, 0, 10, 2);
          
          if( main.q2_10_3[1].checked==true ) initf(main, 10, 11, 1, 0); else research3f(main, 10, 11, 1, 0, 10, 3);
          if( main.q2_10_3[1].checked==true ) initf(main, 10, 12, 1, 0); else research3f(main, 10, 12, 1, 0, 10, 3);
          if( main.q2_10_3[1].checked==true ) initf(main, 10, 13, 1, 0); else research3f(main, 10, 13, 1, 0, 10, 3);
          if( main.q2_10_3[1].checked==true ) initf(main, 10, 14, 1, 0); else research3f(main, 10, 14, 1, 0, 10, 3);
        }
        
        
        if( main.q2_10_5[0].checked==true ) initf(main, 10, 6, 2, 0); else research3f(main, 10, 6, 2, 0, 10, 5);
        if( main.q2_10_5[0].checked==true ) initf(main, 10, 19, 1, 0); else research3f(main, 10, 19, 1, 0, 10, 5);//저장시 에는 체크안함
        
        if( main.q2_12_1[0].checked==true ) initf(main, 12, 2, 3, 6); else research3f(main, 12, 2, 3, 6, 12, 1);
        if( main.q2_12_1[0].checked==true ) initf(main, 12, 29, 1, 0); else research3f(main, 12, 29, 1, 0, 12, 1);//저장시 에는 체크안함
        
        if( main.q2_13_1[0].checked==true ) initf(main, 13, 2, 3, 8); else research3f(main, 13, 2, 3, 8, 13, 1);
        if( main.q2_13_1[0].checked==true ) initf(main, 13, 29, 1, 0); else research3f(main, 13, 29, 1, 0, 13, 1);//저장시 에는 체크안함
        
        if( main.q2_14_1[0].checked==true ) initf(main, 14, 2, 3, 11); else research3f(main, 14, 2, 3, 11, 14, 1);
        if( main.q2_14_1[0].checked==true ) initf(main, 14, 29, 1, 0); else research3f(main, 14, 29, 1, 0, 14, 1);//저장시 에는 체크안함
        
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 31, 1, 0); else research3f(main, 15, 31, 1, 0, 15, 2);
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 32, 1, 0); else research3f(main, 15, 32, 1, 0, 15, 2);
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 33, 1, 0); else research3f(main, 15, 33, 1, 0, 15, 2);
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 34, 1, 0); else research3f(main, 15, 34, 1, 0, 15, 2);
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 41, 1, 0); else research3f(main, 15, 41, 1, 0, 15, 2);
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 42, 1, 0); else research3f(main, 15, 42, 1, 0, 15, 2);
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 43, 1, 0); else research3f(main, 15, 43, 1, 0, 15, 2);
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 44, 1, 0); else research3f(main, 15, 44, 1, 0, 15, 2);
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 4, 2, 0); else research3f(main, 15, 4, 2, 0, 15, 2);
        
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 11, 1, 0); else research3f(main, 16, 11, 1, 0, 16, 1);
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 12, 1, 0); else research3f(main, 16, 12, 1, 0, 16, 1);
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 13, 1, 0); else research3f(main, 16, 13, 1, 0, 16, 1);
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 14, 1, 0); else research3f(main, 16, 14, 1, 0, 16, 1);
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 3, 2, 0); else research3f(main, 16, 3, 2, 0, 16, 1);
        
        if( main.q2_18_1[1].checked==true ) initf(main, 18, 2, 3, 5); else research3f(main, 18, 2, 3, 5, 18, 1);
        if( main.q2_18_1[1].checked==true ) initf(main, 18, 29, 1, 0); else research3f(main, 18, 29, 1, 0, 18, 1);//
        
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 2, 3, 4); else research3f(main, 19, 2, 3, 4, 19, 1);
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 11, 1, 0); else research3f(main, 19, 11, 1, 0, 19, 1);
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 3, 3, 4); else research3f(main, 19, 3, 3, 4, 19, 1);
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 4, 2, 0); else research3f(main, 19, 4, 2, 0, 19, 1);
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 12, 1, 0); else research3f(main, 19, 12, 1, 0, 19, 1);
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 5, 2, 0); else research3f(main, 19, 5, 2, 0, 19, 1);
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 6, 2, 0); else research3f(main, 19, 6, 2, 0, 19, 1);
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 13, 1, 0); else research3f(main, 19, 13, 1, 0, 19, 1);
        if( main.q2_19_1[1].checked==true ) initf(main, 19, 7, 2, 0); else research3f(main, 19, 7, 2, 0, 19, 1);
        
        if( main.q2_19_4[1].checked==true ) initf(main, 19, 5, 2, 0); else research3f(main, 19, 5, 2, 0, 19, 4);
        
        if( main.q2_19_6[1].checked==true ) initf(main, 19, 7, 2, 0); else research3f(main, 19, 7, 2, 0, 19, 6);
        
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 21, 1, 0); else research3f(main, 20, 21, 1, 0, 20, 1);//
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 22, 1, 0); else research3f(main, 20, 22, 1, 0, 20, 1);//
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 23, 1, 0); else research3f(main, 20, 23, 1, 0, 20, 1);//
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 3, 3, 5); else research3f(main, 20, 3, 3, 5, 20, 1);
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 39, 1, 0); else research3f(main, 20, 39, 1, 0, 20, 1);//
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 41, 2, 0); else research3f(main, 20, 41, 2, 0, 20, 1);
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 42, 2, 0); else research3f(main, 20, 42, 2, 0, 20, 1);
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 43, 2, 0); else research3f(main, 20, 43, 2, 0, 20, 1);
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 44, 2, 0); else research3f(main, 20, 44, 2, 0, 20, 1);
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 45, 2, 0); else research3f(main, 20, 45, 2, 0, 20, 1);
      }
        }

    // Radio object 재선택시 초기화
    function checkradio(ni, nx) {
      eval("oldValue = document.info.c2_"+ni+"_"+nx+".value");
      eval("obj = document.info.q2_"+ni+"_"+nx);
      selValue = "";

      for(i=0; i<obj.length; i++) {
        if(obj[i].checked==true) {
          selValue = (i+1)+"";
          break;
        }
      }

      if(selValue != "") {
        if(selValue == oldValue) {
          eval("document.info.c2_"+ni+"_"+nx+".value = ''");
          initf(document.info, ni, nx, 2, 0);
          relationf(document.info);
        } else {
          eval("document.info.c2_"+ni+"_"+nx+".value = selValue");
          relationf(document.info);
        }
      }
    }

    //-- 필수항목 선택여부 확인 --//
    function research2f(obj,fno,sno,type,gesu) {
      var ccheck="no", i;

      switch (type) {
        case 1: // text
          ccheck="yes";
          eval("if(obj.q2_"+fno+"_"+sno+".value=='') ccheck='no'");
          break;
        case 2: // Radio
          eval("for(i=0;i<obj.q2_"+fno+"_"+sno+".length;i++) if(obj.q2_"+fno+"_"+sno+"[i].checked==true) ccheck='yes'");
          break;
        case 3: // checkbox
          for(i=1;i<=gesu;i++)
            eval("if(obj.q2_"+fno+"_"+sno+"_"+i+".checked==true) ccheck='yes'");
          break;
      }

      if(ccheck=="no") {
        msg=msg+"\n";
        
        if( type=="1" ) {
          eval("msg=msg+'하도급거래상황의 "+fno+"번의 ("+sno+")번을 입력하여 주십시오.'");
        } else {
          eval("msg=msg+'하도급거래상황의 "+fno+"번의 ("+sno+")번을 선택하여 주십시오.'");
        }
      }
    }
    function research2f_txt(obj,fno,sno,type,gesu,txt) {
      var ccheck="no", i;

      switch (type) {
        case 1: // text
          ccheck="yes";
          eval("if(obj.q2_"+fno+"_"+sno+".value=='') ccheck='no'");
          break;
        case 2: // Radio
          eval("for(i=0;i<obj.q2_"+fno+"_"+sno+".length;i++) if(obj.q2_"+fno+"_"+sno+"[i].checked==true) ccheck='yes'");
          break;
        case 3: // checkbox
          for(i=1;i<=gesu;i++)
            eval("if(obj.q2_"+fno+"_"+sno+"_"+i+".checked==true) ccheck='yes'");
          break;
      }

      if(ccheck=="no") {
        msg=msg+"\n";
        
        if( type=="1" ) {
          eval("msg=msg+'하도급거래상황의 "+fno+"번 "+txt+"을(를) 입력하여 주십시오.'");
        } else {
          eval("msg=msg+'하도급거래상황의 "+fno+"번 "+txt+"을(를) 선택하여 주십시오.'");
        }
      }
    }

    //-- 연계항목 선택여부 확인 --//
    function research3f(obj,fno,sno,type,gesu,ofno,osno) {
      var ccheck="no", i;

      switch (type) {
        case 1: // text
          ccheck="yes";
          eval("if(obj.q2_"+fno+"_"+sno+".value=='') ccheck='no'");
          eval("obj.q2_"+fno+"_"+sno+".disabled=false");
          break;
        case 2: // Radio
          eval("for(i=0;i<obj.q2_"+fno+"_"+sno+".length;i++) if(obj.q2_"+fno+"_"+sno+"[i].checked==true) ccheck='yes'");
          break;
        case 3: // checkbox
          for(i=1;i<=gesu;i++)
            eval("if(obj.q2_"+fno+"_"+sno+"_"+i+".checked==true) ccheck='yes'");
          break;
      }

      // 연계문항 시 맨 오른쪽 변수 1 : 활성화 , 2 : 비활성화
      chBoxDisplay(obj, fno, sno, type, gesu, 2);

      if(ccheck=="no") {
        msg=msg+"\n";
        
        if( type=="1") {
          eval("msg=msg+'하도급거래상황의 "+ofno+"번의 ("+osno+")번의 연계문항 "+fno+"번의 ("+sno+")번을 입력하여 주십시오.'");
        } else {
          eval("msg=msg+'하도급거래상황의 "+ofno+"번의 ("+osno+")번의 연계문항 "+fno+"번의 ("+sno+")번을 선택하여 주십시오.'");
        }
      }
    }
    
    function research3f_txt(obj,fno,sno,type,gesu,ofno,osno,txt) {
      var ccheck="no", i;

      switch (type) {
        case 1: // text
          ccheck="yes";
          eval("if(obj.q2_"+fno+"_"+sno+".value=='') ccheck='no'");
          eval("obj.q2_"+fno+"_"+sno+".disabled=false");
          break;
        case 2: // Radio
          eval("for(i=0;i<obj.q2_"+fno+"_"+sno+".length;i++) if(obj.q2_"+fno+"_"+sno+"[i].checked==true) ccheck='yes'");
          break;
        case 3: // checkbox
          for(i=1;i<=gesu;i++)
            eval("if(obj.q2_"+fno+"_"+sno+"_"+i+".checked==true) ccheck='yes'");
          break;
      }

      // 연계문항 시 맨 오른쪽 변수 1 : 활성화 , 2 : 비활성화
      chBoxDisplay(obj, fno, sno, type, gesu, 2);

      if(ccheck=="no") {
        msg=msg+"\n";
        
        if( type=="1") {
          eval("msg=msg+'하도급거래상황의 "+ofno+"번의 ("+osno+")번의 연계문항 "+fno+"번의 "+txt+"을(를) 입력하여 주십시오.'");
        } else {
          eval("msg=msg+'하도급거래상황의 "+ofno+"번의 ("+osno+")번의 연계문항 "+fno+"번의 "+txt+"을(를) 선택하여 주십시오.'");
        }
      }
    }


    // 문항 초기화 function
    function initf(obj,fno,sno,type,gesu) {
      switch(type) {
        case 1:
          eval("obj.q2_"+fno+"_"+sno+".value=''");
          eval("obj.q2_"+fno+"_"+sno+".disabled=true");
          break;
        case 2:
          eval("for(i=0;i<obj.q2_"+fno+"_"+sno+".length;i++) obj.q2_"+fno+"_"+sno+"[i].checked=false");
          break;
        case 3:
          for(i=1;i<=gesu;i++)
            eval("obj.q2_"+fno+"_"+sno+"_"+i+".checked=false");

          // 연계문항 시 맨 오른쪽 변수 1 : 활성화 , 2 : 비활성화
          chBoxDisplay(obj, fno, sno, type, gesu, 1);

        break;
      }
    }

    // 체크박스 활성화 / 비활성화
    function chBoxDisplay(obj,fno,sno,type,gesu,view) {
      //alert("값:"+obj+"/"+fno+"/"+sno+"타입:"+type);
      switch(view) {
        case 1:
          for(i=1;i<=gesu;i++)
            eval("obj.q2_"+fno+"_"+sno+"_"+i+".disabled=true");
          break;
        case 2:
          for(i=1;i<=gesu;i++)
            eval("obj.q2_"+fno+"_"+sno+"_"+i+".disabled=false");
          break;
      }
    }

    //--------------------------------------------------------------------------------------------------------
    var bName = navigator.appName;
    var bVer = parseInt(navigator.appVersion);
    var NS4 = (bName == "Netscape" && bVer >= 4);
    var IE4 = (bName == "Microsoft Internet Explore" && bVer >= 4);
    var NS3 = (bName == "Netscape" && bVer < 4);
    var IE3 = (bName == "Microsoft Internet Explore" && bVer < 4);

    var vTime = 5;

    function view_layer(obj) {
      var listDiv = eval("document.getElementById('" + obj + "')");
      var topx  = 50;
      var leftx = 60;

      if(NS4) {
        //var e = window.event;
        //listDiv.style.top = e.clientY + document.body.scrollTop + document.documentElement.scrollTop - topx;
        listDiv.style.top = document.body.scrollTop + document.documentElement.scrollTop + topx;
        //listDiv.style.left = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft - leftx;
        listDiv.style.left = document.body.scrollLeft + document.documentElement.scrollLeft + leftx;
      } else {
        //listDiv.style.posTop = event.y + document.body.scrollTop - topx;
        listDiv.style.posTop = document.body.scrollTop + topx;
        //listDiv.style.posLeft = event.x + document.body.scrollLeft - leftx;
        listDiv.style.posLeft = document.body.scrollLeft + leftx;
      }
    }

    function ShowInfo(str) {
      vTime = 5;

      infoLayerText.innerHTML = "<font color='#006633'>" + str + "</font>";

      goShowInfo();
      infotimer = setInterval(goShowInfo,1000);
    }

    function goShowInfo() {
      if(vTime > 0) {
        document.getElementById("infoLayer").style.visibility = '';
        vTime = vTime - 1;
        view_layer("infoLayer");
      } else {
        document.getElementById("infoLayer").style.visibility='hidden';
        clearInterval(infotimer);
      }
    }

    //--------------------------------------------------------------------------------------------------------
    function ohapf(main) {
      main.qhap16.value=Cnum(main.q2_100_3_1.value)+Cnum(main.q2_100_3_2.value)+Cnum(main.q2_100_3_3.value)+Cnum(main.q2_100_3_4.value)+Cnum(main.q2_100_3_5.value)+Cnum(main.q2_100_3_6.value)+Cnum(main.q2_100_3_7.value)+Cnum(main.q2_100_3_8.value);

      main.qper7.value=Cnum(Cnum(main.q2_100_3_1.value)/Cnum(main.qhap16.value)*100).toFixed(2);
      main.qper8.value=Cnum(Cnum(main.q2_100_3_2.value)/Cnum(main.qhap16.value)*100).toFixed(2);
      main.qper9.value=Cnum(Cnum(main.q2_100_3_3.value)/Cnum(main.qhap16.value)*100).toFixed(2);
      main.qper10.value=Cnum(Cnum(main.q2_100_3_4.value)/Cnum(main.qhap16.value)*100).toFixed(2);
      main.qper11.value=Cnum(Cnum(main.q2_100_3_5.value)/Cnum(main.qhap16.value)*100).toFixed(2);
      main.qper12.value=Cnum(Cnum(main.q2_100_3_6.value)/Cnum(main.qhap16.value)*100).toFixed(2);
      main.qper13.value=Cnum(Cnum(main.q2_100_3_7.value)/Cnum(main.qhap16.value)*100).toFixed(2);
      main.qper14.value=Cnum(Cnum(main.q2_100_3_8.value)/Cnum(main.qhap16.value)*100).toFixed(2);
    }
    /* 20160411 박원영 추가 */
    function ohapf2(main) {
      main.qhap25.value=Cnum(main.q2_100_4_1.value)+Cnum(main.q2_100_4_2.value)+Cnum(main.q2_100_4_3.value)+Cnum(main.q2_100_4_4.value)+Cnum(main.q2_100_4_5.value)+Cnum(main.q2_100_4_6.value)+Cnum(main.q2_100_4_7.value)+Cnum(main.q2_100_4_8.value);

      main.qper17.value=Cnum(Cnum(main.q2_100_4_1.value)/Cnum(main.qhap25.value)*100).toFixed(2);
      main.qper18.value=Cnum(Cnum(main.q2_100_4_2.value)/Cnum(main.qhap25.value)*100).toFixed(2);
      main.qper19.value=Cnum(Cnum(main.q2_100_4_3.value)/Cnum(main.qhap25.value)*100).toFixed(2);
      main.qper20.value=Cnum(Cnum(main.q2_100_4_4.value)/Cnum(main.qhap25.value)*100).toFixed(2);
      main.qper21.value=Cnum(Cnum(main.q2_100_4_5.value)/Cnum(main.qhap25.value)*100).toFixed(2);
      main.qper22.value=Cnum(Cnum(main.q2_100_4_6.value)/Cnum(main.qhap25.value)*100).toFixed(2);
      main.qper23.value=Cnum(Cnum(main.q2_100_4_7.value)/Cnum(main.qhap25.value)*100).toFixed(2);
      main.qper24.value=Cnum(Cnum(main.q2_100_4_8.value)/Cnum(main.qhap25.value)*100).toFixed(2);
    }

    function OpenPost() {
      MsgWindow = window.open("WB_Find_Zip.jsp?ITEM=F&stype=prod3","_PostSerch","toolbar=no,width=430,height=320,directories=no,status=yes,scrollbars=yes,resize=no,menubar=no");
    }

    function formatmoney(m) {
      var money, pmoney, mlength, z, textsize, i;
      textsize= 20;
      pmoney  = "";
      z   = 0;
      money = m;
      money = clearstring(money);
      money = Number(money);
      money = money + "";

      for(i=money.length-1;i>=0;i--) {
        z=z+1;

        if(z%3==0) {
          pmoney=money.substr(i,1)+pmoney;
          if(i!=0)  pmoney=","+pmoney;
        }
        else pmoney=money.substr(i,1)+pmoney;
      }

      return pmoney;
    }

    function clearstring(s) {
      var pstr, sstr, iz;
      sstr  = s;
      pstr  = "";

      for(iz=0;iz<sstr.length;iz++) {
        if(!isNaN(sstr.substr(iz,1))||sstr.substr(iz,1)==".") pstr=pstr+sstr.substr(iz,1);
      }
      return pstr;
    }

    function HelpWindow(url, w, h) {
      helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=no,scrollbars=no,resize=no,menubar=no,location=no");
      helpwindow.focus();
    }

    function HelpWindow2(url, w, h) {
      helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
      helpwindow.focus();
    }

    function fMoveTo(url) {
      if(confirm("다음단계로의 이동을 선택하셨습니다.\n\n선택하신 기능은 최후 저장 후 변경한 내용을\n저장하지 않고 이동합니다.\n변경한 내용이 있을경우 저장 후 선택하십시오.\n\n확인을 누르시면 이동합니다.")) {
        location.href = url;
      }
    }

    function chkDiv() {
      inform = document.info;
      val1 = "";
      for(ni = 0; ni < inform.q1.length; ni++) {
        if(inform.q1[ni].checked == true) {
          val1 = inform.q1[ni].value;
          break;
        }
      }
      val2 = "";
      for(ni = 0; ni < inform.q7.length; ni++) {
        if(inform.q7[ni].checked == true) {
          val2 = inform.q7[ni].value;
          break;
        }
      }

      if(val1=="1" && (val2=="1" || val2=="2")) {
        if(ie4) {
          document.all["divResearch1"].style.visibility = "hidden";
          document.all["divResearch2"].style.visibility = "visible";
        } else {
          document.layers["divResearch1"].visibility = "hide";
          document.layers["divResearch2"].visibility = "show";
        }
      } else {
        if(ie4) {
          document.all["divResearch1"].style.visibility = "visible";
          document.all["divResearch2"].style.visibility = "hidden";
        } else {
          document.layers["divResearch1"].visibility = "show";
          document.layers["divResearch2"].visibility = "hide";
        }
      }

      if(val1=="2" || val1=="3" || val1=="4") HelpWindow('/help/help2.jsp',405,220);
      if(val1=="5" || val1=="6")        HelpWindow('/help/help3.jsp',405,220);
      if(val1=="7")             HelpWindow('/help/help4.jsp',405,220);
      if(val2=="3" || val2=="4")        HelpWindow('/help/help1.jsp',405,220);
    }

    function Cnum(aa) {
      bb  = aa + "";

      while (bb.indexOf(",") != -1)
      {
        bb=bb.replace(",","") ;
      }

      if(isNaN(bb)||bb==''||bb==null) return 0
      else              return Number(bb);
    }

    function sumf(main) {
      // 현금성 기간별
      main.mA3.value = 0;
      main.mB3.value = 0;
      main.mC3.value = 0;
      main.mD3.value = 0;
      main.mE3.value = 0;
      main.mF3.value = 0;
      main.mG3.value = 0;
      for(i=1 ; i<3; i++) eval("main.mA3.value = Cnum(main.mA3.value) + Cnum(main.mA"+i+".value)");
      for(i=1 ; i<3; i++) eval("main.mB3.value = Cnum(main.mB3.value) + Cnum(main.mB"+i+".value)");
      for(i=1 ; i<3; i++) eval("main.mC3.value = Cnum(main.mC3.value) + Cnum(main.mC"+i+".value)");
      for(i=1 ; i<3; i++) eval("main.mD3.value = Cnum(main.mD3.value) + Cnum(main.mD"+i+".value)");
      for(i=1 ; i<3; i++) eval("main.mE3.value = Cnum(main.mE3.value) + Cnum(main.mE"+i+".value)");
      for(i=1 ; i<3; i++) eval("main.mF3.value = Cnum(main.mF3.value) + Cnum(main.mF"+i+".value)");
      for(i=1 ; i<3; i++) eval("main.mG3.value = Cnum(main.mG3.value) + Cnum(main.mG"+i+".value)");
      for(i=1 ; i<4; i++) {
        eval("main.mSubSum"+i+".value = Cnum(main.mA"+i+".value)+Cnum(main.mB"+i+".value)+Cnum(main.mC"+i+".value)+Cnum(main.mD"+i+".value)+Cnum(main.mE"+i+".value)+Cnum(main.mF"+i+".value)+Cnum(main.mG"+i+".value)");
      }
    }

    function onDocument() {
      relationf(document.info);
      
      fn_hap(document.info);
      fn_hap15_1(document.info);
      fn_hap15_2(document.info);
      fn_hap15_3(document.info);
      fn_hap15_4(document.info);
      //f_oent01(document.info);
    }
    
    
    function fn_hap(main) {
      var total;
          total = Cnum(main.q2_11_11.value)+Cnum(main.q2_11_12.value)+Cnum(main.q2_11_13.value)+Cnum(main.q2_11_14.value)+Cnum(main.q2_11_15.value)+Cnum(main.q2_11_16.value)+Cnum(main.q2_11_17.value);
          main.allSum11.value= Cnum(total.toFixed(1));
    }
    function fn_hap15_1(main) {
      main.allSum15_1.value
      =Cnum(main.q2_15_11.value)
      +Cnum(main.q2_15_12.value)
      +Cnum(main.q2_15_13.value)
      +Cnum(main.q2_15_14.value)
      +Cnum(main.q2_15_15.value)
      +Cnum(main.q2_15_16.value)
      +Cnum(main.q2_15_17.value)
      +Cnum(main.q2_15_18.value)
      +Cnum(main.q2_15_19.value)
      +Cnum(main.q2_15_20.value);
    }
    function fn_hap15_2(main) {
      main.allSum15_2.value
      =Cnum(main.q2_15_21.value)
      +Cnum(main.q2_15_22.value)
      +Cnum(main.q2_15_23.value)
      +Cnum(main.q2_15_24.value)
      +Cnum(main.q2_15_25.value)
      +Cnum(main.q2_15_26.value)
      +Cnum(main.q2_15_27.value)
      +Cnum(main.q2_15_28.value)
      +Cnum(main.q2_15_29.value)
      +Cnum(main.q2_15_30.value);
    }
    function fn_hap15_3(main) {
      main.allSum15_3.value
      =Cnum(main.q2_15_31.value)
      +Cnum(main.q2_15_32.value)
      +Cnum(main.q2_15_33.value)
      +Cnum(main.q2_15_34.value);
    }
    function fn_hap15_4(main) {
      main.allSum15_4.value
      =Cnum(main.q2_15_41.value)
      +Cnum(main.q2_15_42.value)
      +Cnum(main.q2_15_43.value)
      +Cnum(main.q2_15_44.value);
    }
    function f_oent01(main) {
      main.q2_8_0.value
      =Cnum(main.q2_8_1.value)
      +Cnum(main.q2_8_2.value)
      +Cnum(main.q2_8_3.value)
      +Cnum(main.q2_8_4.value)
      +Cnum(main.q2_8_5.value)
      +Cnum(main.q2_8_6.value);
      
    }

    function byteLengCheck(frmobj, maxlength, objname, divname) {
      var nbyte = 0;
      var nlen = 0;

      for(i = 0; i < frmobj.value.length; i++) {
        if(escape(frmobj.value.charAt(i)).length > 4) {
          nbyte += 2;
        } else {
          nbyte++;
        }

        if(nbyte <= maxlength)
          nlen = i + 1;
      }

      obj = document.getElementById(divname);
      obj.innerText = nbyte + "/" + maxlength + "byte";

      if(nbyte > maxlength) {
        alert("최대 글자 입력수를 초과 하였습니다.");
        frmobj.value = frmobj.value.substr(0,nlen);
        obj.innerText = maxlength+"/"+maxlength+"byte";
      }

      frmobj.focus();
    }

    function goPrint() {
      /*url = "ProdStep_03_Print.jsp";
      w = 820;
      h = 600;

      if(confirm("화면 인쇄는 조사표 저장 후에 가능합니다.\n\n인쇄하시겠습니까?\n[확인]을 누르시면 인쇄됩니다.")) {
        HelpWindow2(url, w, h);
      }*/
      print();
    }
    </script>
</head>

<body>

    <div id="loadingImage" style="display:none;LEFT:220;TOP:11100;POSITION:absolute;z-index:1">
        <img src="/img/2010img/loading.gif" border="0"/></div>

    <div id="container">
    <div id="wrapper">

        <!-- Begin Header -->
        <div id="subheader">
            <ul class="lt">
                <li class="fl"><a href="#none" onfocus="this.blur()"><img src="img/logo.jpg" width="242" height="55"/></a></li>
                <li class="fr">
                    <ul class="lt">
                        <li class="pt_20"><font color="#FF6600">[용역업]</font>
                            <%=ckOentName%>&nbsp;/&nbsp;<iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" align="center" frameborder="0"></iframe></li>
                    </ul>
                </li>
            </ul>
        </div>

        <div id="submenu">
            <ul class="lt fr">
                <li class="fl pr_2"><a href="./WB_VP_Introduction.jsp" onfocus="this.blur()" class="mainmenu">1. 조사 안내</a></li>
                <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. 회사개요</a></li>
                <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenuup">3. 하도급 거래상황</a></li>
                <li class="fl pr_2"><a href="./WB_VP_Subcon.jsp" onfocus="this.blur()" class="mainmenu">4. 수급사업자 명부</a></li>
                <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="mainmenu">5. 조사표 전송</a></li>
            </ul>
        </div>
        <!-- End Header -->

        <form action="" method="post" name="info">
    <!-- Begin subcontent -->
    <div id="subcontent">
      <!-- title start -->
      <h1 class="contenttitle">3. 하도급 거래 상황</h1>
      <!-- title end -->

      <div class="fc pt_2"></div>

      <!-- 20160427 / 박원영 / 목차 -->
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="lt">
            <li class="boxcontenttitle"><a name="mokcha">목 차</a></li>
            <li class="boxcontentsubtitle">(클릭하시면 해당 목차로 이동합니다.)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="clt"><!-- 여기 -->
            <li><a href="#mokcha0" class="contentbutton3">하도급거래 기본사항에 관하여</a></li>
            <li><a href="#mokcha1" class="contentbutton3">10. 수급사업자 선정방식 및 계약 방법에 관하여</a></li>
            <li><a href="#mokcha2" class="contentbutton3">11. 하도급 계약 체결 시, 하도급용역 단가의 결정에 관하여</a></li>
            <li><a href="#mokcha3" class="contentbutton3">12. 용역 위탁의 취소 및 변경에 관하여</a></li>
            <li><a href="#mokcha4" class="contentbutton3">13. 물품 수령에 관하여</a></li>
            <li><a href="#mokcha5" class="contentbutton3">14. 계약체결 후, 하도급대금 감액에 관하여</a></li>
            <li><a href="#mokcha6" class="contentbutton3">15. 하도급대금 지급에 관하여</a></li>
            <li><a href="#mokcha7" class="contentbutton3">16. 공급원가(재료비,노무비,경비 등) 변동에 따른 하도급대금 조정 신청에 관하여</a></li>
            <li><a href="#mokcha8" class="contentbutton3">17. 협력관계에 관하여</a></li>
            <li><a href="#mokcha9" class="contentbutton3">18. 특약과 관련하여</a></li>
            <li><a href="#mokcha10" class="contentbutton3">19. 기술 자료 제공 요구에 관하여</a></li>
            <li><a href="#mokcha11" class="contentbutton3">20. 전속거래에 관하여</a></li>
            <li><a href="#mokcha12" class="contentbutton3">21. 새로 도입된 제도에 대한 인지도</a></li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <h2 class="contenttitle">하도급거래 기본사항</h2>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha0">하도급거래 기본사항에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>5. </span>귀사의 지난 <%=nCurrentYear-1%>년 하도급거래 형태는 어떠합니까?</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_5_1" value="<%=setHiddenValue(qa, 5, 1, 3)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_5_1" value="1" <%if(qa[5][1][1]!=null && qa[5][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"></input> 가. 하도급을 주기도 하고 받기도 함<span class="boxcontentsubtitle">문6으로</li>
            <li><input type="radio" name="q2_5_1" value="2" <%if(qa[5][1][2]!=null && qa[5][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"></input> 나. 하도급을 주기만 함<span class="boxcontentsubtitle">문7로</span></li>
            <li><input type="radio" name="q2_5_1" value="3" <%if(qa[5][1][3]!=null && qa[5][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"></input> 다. 하도급거래를 하지 않음</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>6. </span>귀사가 지난 3년간 원사업자로부터 '하도급을 받은' 금액은 얼마입니까?</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:30%;" />
                  <col style="width:70%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>구분</th>
                    <th>원(상위) 사업자로부터 하도급을 받은 금액<br/>[VAT 포함 금액]</th>
                  </tr>
                  <tr>
                    <th><%= nCurrentYear-3%>년도</th>
                    <td>
                      <input type="text" name="q2_6_1" value="<%=qa[6][1][20]%>" onkeyup="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 백만원
                    </td>
                  </tr>
                  <tr>
                    <th><%= nCurrentYear-2%>년도</th>
                    <td>
                      <input type="text" name="q2_6_2" value="<%=qa[6][2][20]%>" onKeyUp="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 백만원
                    </td>
                  </tr>
                  <tr>
                    <th><%= nCurrentYear-1%>년도</th>
                    <td>
                      <input type="text" name="q2_6_3" value="<%=qa[6][3][20]%>" onkeyup="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 백만원
                    </td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>7. </span>귀사가 지난 3년간 수급사업자에게 '하도급을 준' 금액은 얼마입니까?</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:30%;" />
                  <col style="width:70%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>구분</th>
                    <th>수급(하위) 사업자에게 하도급을 준 금액<br/>[VAT 포함 금액]</th>
                  </tr>
                  <tr>
                    <th><%= nCurrentYear-3%>년도</th>
                    <td>
                      <input type="text" name="q2_7_1" value="<%=qa[7][1][20]%>" onkeyup ="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
                    </td>
                  </tr>
                  <tr>
                    <th><%= nCurrentYear-2%>년도</th>
                    <td>
                      <input type="text" name="q2_7_2" value="<%=qa[7][2][20]%>" onKeyUp="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
                    </td>
                  </tr>
                  <tr>
                    <th><%= nCurrentYear-1%>년도</th>
                    <td>
                      <input type="text" name="q2_7_3" value="<%=qa[7][3][20]%>" onkeyup ="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
                    </td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>
      
      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>8. </span><%= nCurrentYear-1%>년도에 귀사가 수급사업자에게 '하도급을 준' 금액의 단계별 비중을 응답해 주십시오.</li>
            <li class="boxcontentsubtitle">* [보기] 목적물 완성업체 → 1차 협력업체 → 2차 협력업체 → 3차 협력업체 → 4차 협력업체 등</li>
                        <li class="boxcontentsubtitle">* 귀사가 하도급을 주기만 한 경우 귀사는 목적물 완성업체에 해당</li>
            <li class="boxcontentsubtitle">* 귀사가 목적물 완성업체로부터 하도급을 받아 수급사업자에게 하도급을 준 경우 귀사는 1차 협력업체에 해당</li>
            <li class="boxcontentsubtitle">* 귀사가 1차 협력업체로부터 하도급을 받아 수급사업자에게 하도급을 준 경우 귀사는 2차 협력업체에 해당</li>
          </ul>
        </div>
        <div class="boxcontentright">
                    <input type="hidden" name="c2_8_1" value="<%=setHiddenValue(qa, 8, 1, 6)%>"></input>
          <ul class="lt">
              <li><input type="radio" name="q2_8_1" value="1" <%if(qa[8][1][1]!=null && qa[8][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"></input> 가. 목적물 제조업체</li>
            <li><input type="radio" name="q2_8_1" value="2" <%if(qa[8][1][2]!=null && qa[8][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"></input> 나. 1차 협력업체</li>
            <li><input type="radio" name="q2_8_1" value="3" <%if(qa[8][1][3]!=null && qa[8][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"></input> 다. 2차 협력업체</li>
            <li><input type="radio" name="q2_8_1" value="4" <%if(qa[8][1][4]!=null && qa[8][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"></input> 라. 3차 협력업체</li>
            <li><input type="radio" name="q2_8_1" value="5" <%if(qa[8][1][5]!=null && qa[8][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"></input> 마. 4차 협력업체</li>
            <li><input type="radio" name="q2_8_1" value="6" <%if(qa[8][1][6]!=null && qa[8][1][6].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"></input> 바. 잘모름</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>9. </span>귀사가 <%= nCurrentYear-1%>년도에 거래한 원사업자, 수급사업자 수는 몇 개사입니까?</li>
            <li class="boxcontentsubtitle">* 총 매입(매출) 사업자는 <%= nCurrentYear-1%>년도 매입처별(매출처별) 세금계산서 합계표에 포함된 사업자들로서 하도급이 아닌 거래를 맺은 사업자들을 포함함.</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:60%;" />
                  <col style="width:40%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>구분</th>
                    <th>사업자 수</th>
                  </tr>
                  <tr>
                    <th>총 매출 사업자</th>
                    <td>
                      <input type="text" name="q2_9_1" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[9][1][20]%>"></input> 개사
                    </td>
                  </tr>
                  <tr>
                    <th>귀사에게 하도급을 준 원사업자</th>
                    <td>
                      <input type="text" name="q2_9_2" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[9][2][20]%>"></input> 개사
                    </td>
                  </tr>
                  <tr>
                    <th>총 매입 사업자</th>
                    <td>
                      <input type="text" name="q2_9_3" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[9][3][20]%>"></input> 개사
                    </td>
                  </tr>
                  <tr>
                    <th>귀사가 하도급을 준 수급사업자</th>
                    <td>
                      <input type="text" name="q2_9_4" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[9][4][20]%>"></input> 개사
                    </td>
                  </tr>
                </tbody>
              </table>
            </li>
            <div class="fc pt_10"></div>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <h2 class="contenttitle">하도급거래 세부사항 1 : 거래 제반</h2>

      <%-- <div class="boxcontent2">
        <ul class="boxcontenthelp clt">
          <li class="boxcontenttitle"><font color="#FF0066"><%= nCurrentYear-1%>.1.1.부터 <%= nCurrentYear-1%>.12.31.</font>(물품수령일 기준, 통상 세금계산서 발행일을 말함)까지의 하도급거래에 대하여 해당항목에 체크하여 주십시오.</li>
        </ul>
      </div> --%>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha1">10. 수급사업자 선정방식 및 계약 방법에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">※ 문10-1에서 문10-6은 수급사업자 선정방식 및 계약방법에 관한 질문입니다.</li>
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> 귀사가 <%= nCurrentYear-1%>년도 선정한 수급사업자 중 경쟁입찰 방식을 통해 선정한 비율은 어떻게 됩니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_10_1" value="<%=setHiddenValue(qa, 10, 1, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_10_1" value="1" <%if(qa[10][1][1]!=null && qa[10][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"></input> 가. 100% (전부 경쟁입찰)</li>
            <li><input type="radio" name="q2_10_1" value="2" <%if(qa[10][1][2]!=null && qa[10][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"></input> 나. 80% ~ 100% 미만</li>
            <li><input type="radio" name="q2_10_1" value="3" <%if(qa[10][1][3]!=null && qa[10][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"></input> 다. 50% ~ 80% 미만</li>
            <li><input type="radio" name="q2_10_1" value="4" <%if(qa[10][1][4]!=null && qa[10][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"></input> 라. 50% 미만</li>
            <li><input type="radio" name="q2_10_1" value="5" <%if(qa[10][1][5]!=null && qa[10][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"></input> 마. 0% (전부 수의계약)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> 귀사가 <%= nCurrentYear-1%>년도 수급사업자와 계약 시 서면계약서(전자문서 포함)를 작성·교부한 비율은 어떻게 됩니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_10_2" value="<%=setHiddenValue(qa, 10, 2, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_10_2" value="1" <%if(qa[10][2][1]!=null && qa[10][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,2);"></input> 가. 100% (전부 서면계약)<span class="boxcontentsubtitle">문10-5로</span></li>
            <li><input type="radio" name="q2_10_2" value="2" <%if(qa[10][2][2]!=null && qa[10][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,2);"></input> 나. 95% ~ 100% 미만 (예외적 경우 제외한 전체 서면계약)</li>
            <li><input type="radio" name="q2_10_2" value="3" <%if(qa[10][2][3]!=null && qa[10][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(10,2);"></input> 다. 75% ~ 95% 미만</li>
            <li><input type="radio" name="q2_10_2" value="4" <%if(qa[10][2][4]!=null && qa[10][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(10,2);"></input> 라. 50% ~ 75% 미만</li>
            <li><input type="radio" name="q2_10_2" value="5" <%if(qa[10][2][5]!=null && qa[10][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(10,2);"></input> 마. 50% 미만</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle" ><span>(3) </span> 귀사가 <%= nCurrentYear-1%>년도 수급사업자와의 위탁 계약을 구두로 맺은 경우, 수급사업자가 귀사에게 계약 내용의 확인을 요청하는 서면(이메일,전자문서 포함)을 보내온 경우가 몇 건 있습니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_10_3" value="<%=setHiddenValue(qa, 10, 3, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_10_3" value="1" <%if(qa[10][3][1]!=null && qa[10][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,3);"></input> 가. 있다(<input type="text" name="q2_10_18" value="<%=qa[10][18][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>건)<span class="boxcontentsubtitle">문10-4로</span></li>
            <li><input type="radio" name="q2_10_3" value="2" <%if(qa[10][3][2]!=null && qa[10][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,3);"></input> 나. 없다<span class="boxcontentsubtitle">문10-5로</span></li>
          </ul>
          <div class="fc pt_50"></div>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(4) </span> <%= nCurrentYear-1%>년도 수급사업자로부터 확인요청 서면을 받은 경우, 귀사가 수급사업자에게 15일 이내에 회신한 건수와 그 방법은 어떠하였습니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:60%;" />
                  <col style="width:40%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>구분</th>
                    <th>건수</th>
                  </tr>
                  <tr>
                    <th>15일 이내 총 회신</th>
                    <td><input type="text" name="q2_10_11" value="<%=qa[10][11][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 건</td>
                  </tr>
                  <tr>
                    <th>서면 회신</th>
                    <td><input type="text" name="q2_10_12" value="<%=qa[10][12][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 건</td>
                  </tr>
                  <tr>
                    <th>구두 회신</th>
                    <td><input type="text" name="q2_10_13" value="<%=qa[10][13][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 건</td>
                  </tr>
                  <tr>
                    <th>15일 이후 회신 또는 회신하지 않음</th>
                    <td><input type="text" name="q2_10_14" value="<%=qa[10][14][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 건</td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(5) </span> 귀사가 <%= nCurrentYear-1%>년도 수급사업자와 서면 계약서를 작성·교부 시, 표준하도급계약서를 사용한 비율은 어떻게 됩니까?</li>
            <li class="boxcontentsubtitle">* 최신 표준하도급계약서가 아닌 기존 표준하도급계약서를 사용한 경우나 업종·기업 특성을 고려하여 표준하도급계약서를 수정하여 사용한 경우에도 표준하도급계약서를 사용한 것으로 간주함. 단, 수급사업자에게 불리한 내용이 포함되지 않는다는 조건에 한함.</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_10_5" value="<%=setHiddenValue(qa, 10, 5, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_10_5" value="1" <%if(qa[10][5][1]!=null && qa[10][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,5);"></input> 가. 100% (전체 사용)<span class="boxcontentsubtitle">문11-1로</span></li>
            <li><input type="radio" name="q2_10_5" value="2" <%if(qa[10][5][2]!=null && qa[10][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,5);"></input> 나. 95% ~ 100% 미만 (예외적 경우 제외한 전체 서면계약)</li>
            <li><input type="radio" name="q2_10_5" value="3" <%if(qa[10][5][3]!=null && qa[10][5][3].equals("1")){out.print("checked");}%> onclick="checkradio(10,5);"></input> 다. 75% ~ 95% 미만</li>
            <li><input type="radio" name="q2_10_5" value="4" <%if(qa[10][5][4]!=null && qa[10][5][4].equals("1")){out.print("checked");}%> onclick="checkradio(10,5);"></input> 라. 50% ~ 75% 미만</li>
            <li><input type="radio" name="q2_10_5" value="5" <%if(qa[10][5][5]!=null && qa[10][5][5].equals("1")){out.print("checked");}%> onclick="checkradio(10,5);"></input> 마. 50% 미만</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(6) </span> 서면계약 시 표준하도급계약서를 사용하지 않았다면 주된 그 이유는 무엇입니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_10_6" value="<%=setHiddenValue(qa, 10, 6, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_10_6" value="1" <%if(qa[10][6][1]!=null && qa[10][6][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,6);"></input> 가. 기존 계약서 양식 변경시 업무 부담이 증가하기 때문에</li>
            <li><input type="radio" name="q2_10_6" value="2" <%if(qa[10][6][2]!=null && qa[10][6][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,6);"></input> 나. 우리 업종에는 표준하도급계약서 양식이 존재하지 않기 때문</li>
            <li><input type="radio" name="q2_10_6" value="3" <%if(qa[10][6][3]!=null && qa[10][6][3].equals("1")){out.print("checked");}%> onclick="checkradio(10,6);"></input> 다. 표준하도급계약서 내용이 업무 현실과 맞지 않기 때문</li>
            <li><input type="radio" name="q2_10_6" value="4" <%if(qa[10][6][4]!=null && qa[10][6][4].equals("1")){out.print("checked");}%> onclick="checkradio(10,6);"></input> 라. 표준하도급계약서가 있는지 몰랐기 때문</li>
            <li><input type="radio" name="q2_10_6" value="5" <%if(qa[10][6][5]!=null && qa[10][6][5].equals("1")){out.print("checked");}%> onclick="checkradio(10,6);"></input> 마. 기타(<input type="text" name="q2_10_19" value="<%=qa[10][19][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha2">11. 하도급계약 체결 시, 하도급용역 단가의 결정에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">※ 문11-1에서 문11-3은 하도급 계약 체결 시, 하도급 용역 단가의 결정에 관한 질문입니다.</li>
        </ul>
      </div>

      <div class="fc pt_2"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> 귀사가  <%= nCurrentYear-1%>년도에 수급사업자와 맺은 하도급 용역 단가는 <%= nCurrentYear-2%>년도 단가에 비해 어느 정도 변동되었습니까? 단가 변동의 정도에 해당되는 하도급 계약 건수의 비중을 기입하여 주십시오.</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:50%;" />
                  <col style="width:50%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>단가 변동의 정도</th>
                    <th>하도급 계약 건수의 비중</th>
                  </tr>
                  <tr>
                    <th>전체</th>
                    <td><input type="text" readonly="readonly" name="allSum11" value="" size="30" class="text06"></input> %</td>
                  </tr>
                  <tr>
                    <th>10% 이상 인하</th>
                    <td><input type="text" name="q2_11_11" value="<%=qa[11][11][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>5~10% 미만 인하</th>
                    <td><input type="text" name="q2_11_12" value="<%=qa[11][12][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>0~5% 미만 인하</th>
                    <td><input type="text" name="q2_11_13" value="<%=qa[11][13][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>변화 없음</th>
                    <td><input type="text" name="q2_11_14" value="<%=qa[11][14][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>0~5% 미만 인상</th>
                    <td><input type="text" name="q2_11_15" value="<%=qa[11][15][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>5~10% 미만 인상</th>
                    <td><input type="text" name="q2_11_16" value="<%=qa[11][16][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>10% 이상  인상</th>
                    <td><input type="text" name="q2_11_17" value="<%=qa[11][17][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> 하도급 단가 결정에 아래 요인들을 어느정도로 고려하였습니까?</li>
            <li class="boxcontentsubtitle"></li>

          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:38%;" />
                  <col style="width:10%;" />
                  <col style="width:10%;" />
                  <col style="width:10%;" />
                  <col style="width:10%;" />
                  <col style="width:10%;" />
                  <col style="width:12%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>항목</th>
                    <th>전혀 고려 안함</th>
                    <th>별로 고려 안함</th>
                    <th>보통</th>
                    <th>약간 고려</th>
                    <th>매우 고려</th>
                    <th>해당사항없음</th>
                  </tr>
                  <tr>
                    <th style="text-align: left;">1) 귀사의 인건비 변화</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_11_20" value="<%=setHiddenValue(qa, 11, 20, 6)%>"></input>
                      <input type="radio" name="q2_11_20" value="1" <%if(qa[11][20][1]!=null && qa[11][20][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,20);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_20" value="2" <%if(qa[11][20][2]!=null && qa[11][20][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,20);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_20" value="3" <%if(qa[11][20][3]!=null && qa[11][20][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,20);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_20" value="4" <%if(qa[11][20][4]!=null && qa[11][20][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,20);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_20" value="5" <%if(qa[11][20][5]!=null && qa[11][20][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,20);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_20" value="6" <%if(qa[11][20][6]!=null && qa[11][20][6].equals("1")){out.print("checked");}%> onclick="checkradio(11,20);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th style="text-align: left;">2) 귀사가 구입한 원재료 가격 변화</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_11_21" value="<%=setHiddenValue(qa, 11, 21, 6)%>"></input>
                      <input type="radio" name="q2_11_21" value="1" <%if(qa[11][21][1]!=null && qa[11][21][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,21);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_21" value="2" <%if(qa[11][21][2]!=null && qa[11][21][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,21);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_21" value="3" <%if(qa[11][21][3]!=null && qa[11][21][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,21);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_21" value="4" <%if(qa[11][21][4]!=null && qa[11][21][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,21);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_21" value="5" <%if(qa[11][21][5]!=null && qa[11][21][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,21);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_21" value="6" <%if(qa[11][21][6]!=null && qa[11][21][6].equals("1")){out.print("checked");}%> onclick="checkradio(11,21);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th style="text-align: left;">3) 수급사업자의 생산성 변화</th>
                    <td style="text-align: center;" >
                      <input type="hidden" name="c2_11_22" value="<%=setHiddenValue(qa, 11, 22, 6)%>"></input>
                      <input type="radio" name="q2_11_22" value="1" <%if(qa[11][22][1]!=null && qa[11][22][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,22);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_22" value="2" <%if(qa[11][22][2]!=null && qa[11][22][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,22);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_22" value="3" <%if(qa[11][22][3]!=null && qa[11][22][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,22);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_22" value="4" <%if(qa[11][22][4]!=null && qa[11][22][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,22);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_22" value="5" <%if(qa[11][22][5]!=null && qa[11][22][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,22);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_22" value="6" <%if(qa[11][22][6]!=null && qa[11][22][6].equals("1")){out.print("checked");}%> onclick="checkradio(11,22);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th style="text-align: left;">4) 수급사업자의 인건비 변화</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_11_23" value="<%=setHiddenValue(qa, 11, 23, 6)%>"></input>
                      <input type="radio" name="q2_11_23" value="1" <%if(qa[11][23][1]!=null && qa[11][23][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,23);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_23" value="2" <%if(qa[11][23][2]!=null && qa[11][23][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,23);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_23" value="3" <%if(qa[11][23][3]!=null && qa[11][23][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,23);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_23" value="4" <%if(qa[11][23][4]!=null && qa[11][23][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,23);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_23" value="5" <%if(qa[11][23][5]!=null && qa[11][23][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,23);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_23" value="6" <%if(qa[11][23][6]!=null && qa[11][23][6].equals("1")){out.print("checked");}%> onclick="checkradio(11,23);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th style="text-align: left;">5) 수급사업자가 구입한 원재료 가격 변화</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_11_24" value="<%=setHiddenValue(qa, 11, 24, 6)%>"></input>
                      <input type="radio" name="q2_11_24" value="1" <%if(qa[11][24][1]!=null && qa[11][24][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,24);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_24" value="2" <%if(qa[11][24][2]!=null && qa[11][24][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,24);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_24" value="3" <%if(qa[11][24][3]!=null && qa[11][24][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,24);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_24" value="4" <%if(qa[11][24][4]!=null && qa[11][24][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,24);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_24" value="5" <%if(qa[11][24][5]!=null && qa[11][24][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,24);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_24" value="6" <%if(qa[11][24][6]!=null && qa[11][24][6].equals("1")){out.print("checked");}%> onclick="checkradio(11,24);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th style="text-align: left;">6) 발주(구매)한 물량 변화</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_11_25" value="<%=setHiddenValue(qa, 11, 25, 6)%>"></input>
                      <input type="radio" name="q2_11_25" value="1" <%if(qa[11][25][1]!=null && qa[11][25][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,25);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_25" value="2" <%if(qa[11][25][2]!=null && qa[11][25][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,25);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_25" value="3" <%if(qa[11][25][3]!=null && qa[11][25][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,25);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_25" value="4" <%if(qa[11][25][4]!=null && qa[11][25][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,25);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_25" value="5" <%if(qa[11][25][5]!=null && qa[11][25][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,25);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_25" value="6" <%if(qa[11][25][6]!=null && qa[11][25][6].equals("1")){out.print("checked");}%> onclick="checkradio(11,25);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th style="text-align: left;">7) 환율 변화</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_11_26" value="<%=setHiddenValue(qa, 11, 26, 6)%>"></input>
                      <input type="radio" name="q2_11_26" value="1" <%if(qa[11][26][1]!=null && qa[11][26][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,26);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_26" value="2" <%if(qa[11][26][2]!=null && qa[11][26][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,26);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_26" value="3" <%if(qa[11][26][3]!=null && qa[11][26][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,26);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_26" value="4" <%if(qa[11][26][4]!=null && qa[11][26][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,26);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_26" value="5" <%if(qa[11][26][5]!=null && qa[11][26][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,26);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_26" value="6" <%if(qa[11][26][6]!=null && qa[11][26][6].equals("1")){out.print("checked");}%> onclick="checkradio(11,26);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th style="text-align: left;">8) 시장 가격경쟁 정도 변화</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_11_27" value="<%=setHiddenValue(qa, 11, 27, 6)%>"></input>
                      <input type="radio" name="q2_11_27" value="1" <%if(qa[11][27][1]!=null && qa[11][27][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,27);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_27" value="2" <%if(qa[11][27][2]!=null && qa[11][27][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,27);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_27" value="3" <%if(qa[11][27][3]!=null && qa[11][27][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,27);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_27" value="4" <%if(qa[11][27][4]!=null && qa[11][27][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,27);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_27" value="5" <%if(qa[11][27][5]!=null && qa[11][27][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,27);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_27" value="6" <%if(qa[11][27][6]!=null && qa[11][27][6].equals("1")){out.print("checked");}%> onclick="checkradio(11,27);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th style="text-align: left;">9) 기타</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_11_28" value="<%=setHiddenValue(qa, 11, 28, 6)%>"></input>
                      <input type="radio" name="q2_11_28" value="1" <%if(qa[11][28][1]!=null && qa[11][28][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,28);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_28" value="2" <%if(qa[11][28][2]!=null && qa[11][28][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,28);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_28" value="3" <%if(qa[11][28][3]!=null && qa[11][28][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,28);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_28" value="4" <%if(qa[11][28][4]!=null && qa[11][28][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,28);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_28" value="5" <%if(qa[11][28][5]!=null && qa[11][28][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,28);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_11_28" value="6" <%if(qa[11][28][6]!=null && qa[11][28][6].equals("1")){out.print("checked");}%> onclick="checkradio(11,28);"></input>
                    </td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(3) </span> 하도급 단가 결정은 어떻게 이루어졌습니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_11_3" value="<%=setHiddenValue(qa, 11, 3, 3)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_11_3" value="1" <%if(qa[11][3][1]!=null && qa[11][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,3);"></input> 가. 귀사의 제안과 수급사업자의 수용</li>
            <li><input type="radio" name="q2_11_3" value="2" <%if(qa[11][3][2]!=null && qa[11][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,3);"></input> 나. 수급사업자의 제안과 귀사의 수용</li>
            <li><input type="radio" name="q2_11_3" value="3" <%if(qa[11][3][3]!=null && qa[11][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,3);"></input> 다. 수차례 협의를 통해 결정</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha3">12. 용역 위탁과 취소 및 변경에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">※ 문12-1에서 문12-2는 용역 위탁의 취소 및 변경에 관한 질문입니다.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> <%= nCurrentYear-1%>년도에 귀사가 수급사업자에게 용역 위탁을 한 후, 임의로 위탁을 취소하거나 변경하지 않고 본래의 계약대로 이행한 계약건수의 비율은 어떻게 됩니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_12_1" value="<%=setHiddenValue(qa, 12, 1, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_12_1" value="1" <%if(qa[12][1][1]!=null && qa[12][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> 가. 100% (전체이행)<span class="boxcontentsubtitle">문13-1로</span></li>
            <li><input type="radio" name="q2_12_1" value="2" <%if(qa[12][1][2]!=null && qa[12][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> 나. 95% ~ 100% 미만 (예외적 경우 제외한 전체이행)</li>
            <li><input type="radio" name="q2_12_1" value="3" <%if(qa[12][1][3]!=null && qa[12][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> 다. 75% ~ 95% 미만</li>
            <li><input type="radio" name="q2_12_1" value="4" <%if(qa[12][1][4]!=null && qa[12][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> 라. 50% ~ 75% 미만</li>
            <li><input type="radio" name="q2_12_1" value="5" <%if(qa[12][1][5]!=null && qa[12][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> 마. 50% 미만</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> 귀사가 임의로 용역 위탁을 취소하거나 변경한 이유는 무엇입니까?</li>
                        <li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li><input type="checkbox" name="q2_12_2_1" value="1" <%if(qa[12][2][1]!=null && qa[12][2][1].equals("1")){out.print("checked");}%>></input> 가. 발주자 또는 거래처의 주문취소</li>
            <li><input type="checkbox" name="q2_12_2_2" value="1" <%if(qa[12][2][2]!=null && qa[12][2][2].equals("1")){out.print("checked");}%>></input> 나. 판매부진 또는 흥행 실패 예상</li>
            <li><input type="checkbox" name="q2_12_2_3" value="1" <%if(qa[12][2][3]!=null && qa[12][2][3].equals("1")){out.print("checked");}%>></input> 다. 목적물의 특성·사양 변경</li>
            <li><input type="checkbox" name="q2_12_2_4" value="1" <%if(qa[12][2][4]!=null && qa[12][2][4].equals("1")){out.print("checked");}%>></input> 라. 위탁물 수령 이전에 수급사업자의 부도로 정산합의</li>
            <li><input type="checkbox" name="q2_12_2_5" value="1" <%if(qa[12][2][5]!=null && qa[12][2][5].equals("1")){out.print("checked");}%>></input> 마. 수급사업자의 계약불이행(발주내용 미준수)</li>
            <li><input type="checkbox" name="q2_12_2_6" value="1" <%if(qa[12][2][6]!=null && qa[12][2][6].equals("1")){out.print("checked");}%>></input> 바. 기타 (<input type="text" name="q2_12_29" value="<%=qa[12][29][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha4">13. 목적물 수령에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">※ 문13-1에서 문13-2는 목절물 수령에 관한 질문입니다.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> 귀사가 <%= nCurrentYear-1%>년도에 용역 위탁한 물품을 수령한 비율은 어떻게 됩니까?</li>
            <li class="boxcontentsubtitle">* 수령 비율 = 100*(수령한 물량·건수/용역위탁한 물량·건수)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_13_1" value="<%=setHiddenValue(qa, 13, 1, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_13_1" value="1" <%if(qa[13][1][1]!=null && qa[13][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> 가. 100% (전체수령)<span class="boxcontentsubtitle">문14-1로</span></li>
            <li><input type="radio" name="q2_13_1" value="2" <%if(qa[13][1][2]!=null && qa[13][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> 나. 95% ~ 100% 미만 (예외적 경우 제외한 전체수령)</li>
            <li><input type="radio" name="q2_13_1" value="3" <%if(qa[13][1][3]!=null && qa[13][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> 다. 75% ~ 95% 미만</li>
            <li><input type="radio" name="q2_13_1" value="4" <%if(qa[13][1][4]!=null && qa[13][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> 라. 50% ~ 75% 미만</li>
            <li><input type="radio" name="q2_13_1" value="5" <%if(qa[13][1][5]!=null && qa[13][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> 마. 50% 미만</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> 귀사가 용역 위탁한 물품을 수령하지 않은 이유는 무엇입니까? (해당 항목에 모두 선택)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li><input type="checkbox" name="q2_13_2_1" value="1" <%if(qa[13][2][1]!=null && qa[13][2][1].equals("1")){out.print("checked");}%>></input> 가. 용역 위탁한 목적물이 불량품임</li>
            <li><input type="checkbox" name="q2_13_2_2" value="1" <%if(qa[13][2][2]!=null && qa[13][2][2].equals("1")){out.print("checked");}%>></input> 나. 주문내용대로 용역이 수행되지 않음</li>
            <li><input type="checkbox" name="q2_13_2_3" value="1" <%if(qa[13][2][3]!=null && qa[13][2][3].equals("1")){out.print("checked");}%>></input> 다. 수급사업자의 책임으로 납품이 지연됨</li>
            <li><input type="checkbox" name="q2_13_2_4" value="1" <%if(qa[13][2][4]!=null && qa[13][2][4].equals("1")){out.print("checked");}%>></input> 라. 발주자(고객)가 발주내용을 변경·취소함</li>
            <li><input type="checkbox" name="q2_13_2_5" value="1" <%if(qa[13][2][5]!=null && qa[13][2][5].equals("1")){out.print("checked");}%>></input> 마. 발주자(고객)의 클레임이 발생함</li>
            <li><input type="checkbox" name="q2_13_2_6" value="1" <%if(qa[13][2][6]!=null && qa[13][2][6].equals("1")){out.print("checked");}%>></input> 바. 시장에서 판매실적이 부진함</li>
            <li><input type="checkbox" name="q2_13_2_7" value="1" <%if(qa[13][2][7]!=null && qa[13][2][7].equals("1")){out.print("checked");}%>></input> 사. 목적물의 특성·사양이 변경됨</li>
            <li><input type="checkbox" name="q2_13_2_8" value="1" <%if(qa[13][2][8]!=null && qa[13][2][8].equals("1")){out.print("checked");}%>></input> 아. 기타 (<input type="text" name="q2_13_29" value="<%=qa[13][29][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha5">14. 계약체결 후, 하도급대금 감액에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">※ 문14-1에서 문14-2는 계약체결 후, 하도급대금 감액에 관한 질문입니다.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> 귀사가 <%= nCurrentYear-1%>년도 당초 계약할 때 정했던 금액대로 하도급대금(단가)을 지급한 비율은 어떻게 됩니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_14_1" value="<%=setHiddenValue(qa, 14, 1, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_14_1" value="1" <%if(qa[14][1][1]!=null && qa[14][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> 가. 100% (전체지급)<span class="boxcontentsubtitle">문15-1로</span></li>
            <li><input type="radio" name="q2_14_1" value="2" <%if(qa[14][1][2]!=null && qa[14][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> 나. 95% ~ 100% 미만 (예외적 경우 제외한 전체지급)</li>
            <li><input type="radio" name="q2_14_1" value="3" <%if(qa[14][1][3]!=null && qa[14][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> 다. 75% ~ 95% 미만</li>
            <li><input type="radio" name="q2_14_1" value="4" <%if(qa[14][1][4]!=null && qa[14][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> 라. 50% ~ 75% 미만</li>
            <li><input type="radio" name="q2_14_1" value="5" <%if(qa[14][1][5]!=null && qa[14][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> 마. 50% 미만</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> 귀사가 당초 계약할 때 정했던 금액보다 하도급대금(단가)을 적게 지급한 이유는 무엇입니까?</li>
                        <li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li><input type="checkbox" name="q2_14_2_1" value="1" <%if(qa[14][2][1]!=null && qa[14][2][1].equals("1")){out.print("checked");}%>></input> 가. 용역 수행 목적물에 하자가 존재함</li>
            <li><input type="checkbox" name="q2_14_2_2" value="1" <%if(qa[14][2][2]!=null && qa[14][2][2].equals("1")){out.print("checked");}%>></input> 나. 주문내용대로 용역이 수행되지 않음</li>
            <li><input type="checkbox" name="q2_14_2_3" value="1" <%if(qa[14][2][3]!=null && qa[14][2][3].equals("1")){out.print("checked");}%>></input> 다. 발주자 또는 거래처가 주문을 취소함</li>
            <li><input type="checkbox" name="q2_14_2_4" value="1" <%if(qa[14][2][4]!=null && qa[14][2][4].equals("1")){out.print("checked");}%>></input> 라. 귀사의 매출하락에 따른 고통분담</li>
            <li><input type="checkbox" name="q2_14_2_5" value="1" <%if(qa[14][2][5]!=null && qa[14][2][5].equals("1")){out.print("checked");}%>></input> 마. 광고비·판매촉진비의 사전 지급을 반영함</li>
            <li><input type="checkbox" name="q2_14_2_6" value="1" <%if(qa[14][2][6]!=null && qa[14][2][6].equals("1")){out.print("checked");}%>></input> 바. 귀사의 저가수주를 반영함</li>
            <li><input type="checkbox" name="q2_14_2_7" value="1" <%if(qa[14][2][7]!=null && qa[14][2][7].equals("1")){out.print("checked");}%>></input> 사. 귀사의 자금사정을 고려함</li>
            <li><input type="checkbox" name="q2_14_2_8" value="1" <%if(qa[14][2][8]!=null && qa[14][2][8].equals("1")){out.print("checked");}%>></input> 아. 귀사가 환율변동으로 입은 손해를 반영함</li>
            <li><input type="checkbox" name="q2_14_2_9" value="1" <%if(qa[14][2][9]!=null && qa[14][2][9].equals("1")){out.print("checked");}%>></input> 자. 원재료 가격의 하락을 반영함</li>
            <li><input type="checkbox" name="q2_14_2_10" value="1" <%if(qa[14][2][10]!=null && qa[14][2][10].equals("1")){out.print("checked");}%>></input> 차. 목적물의 판매가격 하락을 반영함</li>
            <li><input type="checkbox" name="q2_14_2_11" value="1" <%if(qa[14][2][11]!=null && qa[14][2][11].equals("1")){out.print("checked");}%>></input> 카. 기타 (<input type="text" name="q2_14_29" value="<%=qa[14][29][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha6">15. 하도급대금 지급에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">※ 문15-1에서 문15-4는 하도급대금 지급에 관한 질문입니다.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> <%= nCurrentYear-1%>년도 수급사업자에게 지급한 하도급대금의 지급수단별 비중은 어떻게 됩니까? 귀사가 거래한 수급사업자를 중소기업인과 중견기업인으로 분리해 응답해 주십시오.</li>
            <li class="boxcontentsubtitle">* 중견기업은 중견기업법 제2조제1호의 규정에 해당하는 회사임</li>
            <li class="boxcontentsubtitle">* 중소기업은 중소기업기본법 제2조의 규정에 해당하는 회사임</li>
            <li class="boxcontentsubtitle">&nbsp;</li>
            <li class="boxcontentsubtitle">* 어음대체 결제수단(만기 1일 이하) : 기업구매전용카드, 외상매출채권담보대출, 구매론 등 상환청구권이 없는 건을 기재</li>
            <li class="boxcontentsubtitle">* 어음 : 어음법에 의한 실물어음(종이어음) 이외에 "전자어음의 발행 및 유통에 관한 법률"에 따라 발행된 전자어음도 포함하여 작성</li>
            <li class="boxcontentsubtitle">* 기타 : 대물변제 등 다른 수단으로 지급한 경우 기재</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:40%;" />
                  <col style="width:30%;" />
                  <col style="width:30%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>구분</th>
                    <th>수급사업자가 중소기업인 경우</th>
                    <th>수급사업자가 중견기업인 경우</th>
                  </tr>
                  <tr>
                    <th>현금(수표 포함)</th>
                    <td><input type="text" name="q2_15_11" value="<%=qa[15][11][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_21" value="<%=qa[15][21][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>외상매출채권 담보대출(만기 1일 이하, 상환청구권 無)</th>
                    <td><input type="text" name="q2_15_12" value="<%=qa[15][12][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_22" value="<%=qa[15][22][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>기업구매전용카드(만기 1일 이하)</th>
                    <td><input type="text" name="q2_15_13" value="<%=qa[15][13][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_23" value="<%=qa[15][23][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>구매론(만기 1일 이하)</th>
                    <td><input type="text" name="q2_15_14" value="<%=qa[15][14][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_24" value="<%=qa[15][24][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>상생결제 시스템(만기 1일 이하)</th>
                    <td><input type="text" name="q2_15_15" value="<%=qa[15][15][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_25" value="<%=qa[15][25][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>위 어음대체결제수단(단, 만기 1일 초과)</th>
                    <td><input type="text" name="q2_15_16" value="<%=qa[15][16][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_26" value="<%=qa[15][26][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>어음(만기 60일 이하)</th>
                    <td><input type="text" name="q2_15_17" value="<%=qa[15][17][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_27" value="<%=qa[15][27][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>어음(하도급 거래 한정. 만기 61일~120일)</th>
                    <td><input type="text" name="q2_15_18" value="<%=qa[15][18][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_28" value="<%=qa[15][28][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>어음(하도급 거래 한정. 만기 121일 초과)</th>
                    <td><input type="text" name="q2_15_19" value="<%=qa[15][19][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_29" value="<%=qa[15][29][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>기타</th>
                    <td><input type="text" name="q2_15_20" value="<%=qa[15][20][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_30" value="<%=qa[15][30][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>합계</th>
                    <td><input type="text" readonly="readonly" name="allSum15_1" value="" size="30" class="text07"></input> %</td>
                    <td><input type="text" readonly="readonly" name="allSum15_2" value="" size="30" class="text07"></input> %</td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> 귀사가 하도급 대금을 지급함에 있어 목적물 수령일로부터 60일을 초과하여 지급한 비율은 어떻게 됩니까?</li>
            <li class="boxcontentsubtitle">* 목적물 수령일은 통상 지식·정보성과물 수령일 또는 역무 공급 완료일을 기준으로 함.</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_15_2" value="<%=setHiddenValue(qa, 15, 2, 4)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_15_2" value="1" <%if(qa[15][2][1]!=null && qa[15][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(15,2);"></input> 가. 없음<span class="boxcontentsubtitle">문16-1로</span></li>
            <li><input type="radio" name="q2_15_2" value="2" <%if(qa[15][2][2]!=null && qa[15][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(15,2);"></input> 나. 30% 미만</li>
            <li><input type="radio" name="q2_15_2" value="3" <%if(qa[15][2][3]!=null && qa[15][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(15,2);"></input> 다. 30% ~ 50% 미만</li>
            <li><input type="radio" name="q2_15_2" value="4" <%if(qa[15][2][4]!=null && qa[15][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(15,2);"></input> 라. 50% 이상</li>
          </ul>
          <div class="fc pt_10"></div>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(3) </span> 60일을 초과하여 하도급대금을 지급한 경우가 있다면, 그 경우의 지급수단별 비중은 어떻게 됩니까? 귀사가 거래한 수급사업자를 중소기업인과 중견기업인으로 분리해 응답해 주십시오.</li>
            <li class="boxcontentsubtitle">* 중견기업은 중견기업법 제2조제1호의 규정에 해당하는 회사임</li>
            <li class="boxcontentsubtitle">* 중소기업은 중소기업기본법 제2조의 규정에 해당하는 회사임</li>
            <li class="boxcontentsubtitle">&nbsp;</li>
                        <li class="boxcontentsubtitle">* 어음 : 어음법에 의한 실물어음(종이어음) 이외에 "전자어음의 발행 및 유통에 관한 법률"에 따라 발행된 전자어음도 포함하여 작성</li>
            <li class="boxcontentsubtitle">* 어음대체 결제수단 : 기업구매전용카드, 외상매출채권담보대출, 구매론 등 상환청구권이 없는 건을 기재</li>
            <li class="boxcontentsubtitle">* 기타 : 대물변제 등 다른 수단으로 지급한 경우 기재</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:40%;" />
                  <col style="width:30%;" />
                  <col style="width:30%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>구분</th>
                    <th>수급사업자가 중소기업인 경우</th>
                    <th>수급사업자가 중견기업인 경우</th>
                  </tr>
                  <tr>
                    <th>현금(수표 포함)</th>
                    <td><input type="text" name="q2_15_31" value="<%=qa[15][31][20]%>" onKeyUp="sukeyup(this); fn_hap15_3(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_41" value="<%=qa[15][41][20]%>" onKeyUp="sukeyup(this); fn_hap15_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>어음대체 결제수단</th>
                    <td><input type="text" name="q2_15_32" value="<%=qa[15][32][20]%>" onKeyUp="sukeyup(this); fn_hap15_3(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_42" value="<%=qa[15][42][20]%>" onKeyUp="sukeyup(this); fn_hap15_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>어음</th>
                    <td><input type="text" name="q2_15_33" value="<%=qa[15][33][20]%>" onKeyUp="sukeyup(this); fn_hap15_3(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_43" value="<%=qa[15][43][20]%>" onKeyUp="sukeyup(this); fn_hap15_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>기타</th>
                    <td><input type="text" name="q2_15_34" value="<%=qa[15][34][20]%>" onKeyUp="sukeyup(this); fn_hap15_3(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_44" value="<%=qa[15][44][20]%>" onKeyUp="sukeyup(this); fn_hap15_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>합계</th>
                    <td><input type="text" readonly="readonly" name="allSum15_3" value="" size="30" class="text07"></input> %</td>
                    <td><input type="text" readonly="readonly" name="allSum15_4" value="" size="30" class="text07"></input> %</td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
          <div class="fc pt_50"></div>
          <div class="fc pt_50"></div>
          <div class="fc pt_50"></div>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(4) </span> 60일을 초과하여 하도급대금을 지급한 경우, 지연이자·어음할인료·금융기관 약정수수료 등을 지급하였습니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_15_4" value="<%=setHiddenValue(qa, 15, 4, 3)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_15_4" value="1" <%if(qa[15][4][1]!=null && qa[15][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(15,4);"></input> 가. 전부 지급</li>
            <li><input type="radio" name="q2_15_4" value="2" <%if(qa[15][4][2]!=null && qa[15][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(15,4);"></input> 나. 일부 지급(일부 미지급)</li>
            <li><input type="radio" name="q2_15_4" value="3" <%if(qa[15][4][3]!=null && qa[15][4][3].equals("1")){out.print("checked");}%> onclick="checkradio(15,4);"></input> 다. 전부 미지급</li>
          </ul>
          <div class="fc pt_30"></div>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha7">16. 공급원가(재료비, 노무비, 경비 등) 변동에 따른 하도급대금 조정 신청에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">※ 문16-1에서 문16-3은 공급원가(재료비, 노무비, 경비 등) 변동에 따른 하도급대금 조정 신청에 관한 질문입니다.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> <%= nCurrentYear-1%>년도에 공급원가 상승을 이유로 귀사에게 하도급대금 조정을 직접 신청한 수급사업자나 중소기업협동조합을 통해 신청한 수급사업자가 있습니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_16_1" value="<%=setHiddenValue(qa, 16, 1, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_16_1" value="1" <%if(qa[16][1][1]!=null && qa[16][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> 가. 있다<span class="boxcontentsubtitle">문16-2로</span></li>
            <li><input type="radio" name="q2_16_1" value="2" <%if(qa[16][1][2]!=null && qa[16][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> 나. 없다<span class="boxcontentsubtitle">문17로</span></li>
          </ul>
          <div class="fc pt_50"></div>
          <div class="fc pt_50"></div>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> 하도급대금 조정 신청을 한 수급사업자 수와 신청을 받은 날부터 10일 이내에 협의를 개시한 업체는 몇 개사입니까?</li>
            <li class="boxcontentsubtitle">* 동일 수급사업자가 하도급대금 조정 신청(A)를 한 후 중소기업 협동조합을 통하여 대금 조정을 재신청(B)한 경우는, 후자(B)의 조정신청 건수로만 계산</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:40%;" />
                  <col style="width:30%;" />
                  <col style="width:30%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>구분</th>
                    <th>수급사업자 수</th>
                    <th>10일 이내 협의를 개시한 업체 수</th>
                  </tr>
                  <tr>
                    <th>직접 하도급대금 조정신청</th>
                    <td>
                      <input type="text" name="q2_16_11" value="<%=qa[16][11][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 개사
                    </td>
                    <td>
                      <input type="text" name="q2_16_12" value="<%=qa[16][12][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 개사
                    </td>
                  </tr>
                  <tr>
                    <th>중소기업협동조합을 통해 조정신청</th>
                    <td>
                      <input type="text" name="q2_16_13" value="<%=qa[16][13][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 개사
                    </td>
                    <td>
                      <input type="text" name="q2_16_14" value="<%=qa[16][14][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> 개사
                    </td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
          <div class="fc pt_50"></div>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(3) </span> 귀사가 <%= nCurrentYear-1%>년도에 수급사업자 또는 중소기업협동조합의 하도급대금 인상 요청을 받은 경우에 대하여, 요청사항을 <u>일부 또는 전적으로</u> 수용한 비율은 어떻게 됩니까? 업체수를 기준으로 응답하여 주십시오.</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_16_3" value="<%=setHiddenValue(qa, 16, 3, 6)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_16_3" value="1" <%if(qa[16][3][1]!=null && qa[16][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> 가. 100% (전체 수용)</li>
            <li><input type="radio" name="q2_16_3" value="2" <%if(qa[16][3][2]!=null && qa[16][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> 나. 75% ~ 100% 미만</li>
            <li><input type="radio" name="q2_16_3" value="3" <%if(qa[16][3][3]!=null && qa[16][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> 다. 50% ~ 75% 미만</li>
            <li><input type="radio" name="q2_16_3" value="4" <%if(qa[16][3][4]!=null && qa[16][3][4].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> 라. 25% ~ 50% 미만</li>
            <li><input type="radio" name="q2_16_3" value="5" <%if(qa[16][3][5]!=null && qa[16][3][5].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> 마. 25% 미만</li>
            <li><input type="radio" name="q2_16_3" value="6" <%if(qa[16][3][6]!=null && qa[16][3][6].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> 바. 0% (전체 미수용)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha8">17. 협력관계에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">※ 문17은 수급사업자와의 협력관계에 관한 질문입니다.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> <%= nCurrentYear-1%>년도에 수급사업자와의 협력관계 증진을 위해 다음의 사항을 유상 또는 무상으로 지원하였다면, 귀사가 지원한 수급사업자는 몇 개사 입니까?</li>
            <li class="boxcontentsubtitle">* 귀사가 A수급사업자에게 자금, 물자, 인력 지원을 모두 수행하였다면 해당 지원 부문의 업체 수 계산에 각각 포함.</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:50%;" />
                  <col style="width:50%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>구분</th>
                    <th>업체 수</th>
                  </tr>
                  <tr>
                    <th>자금(출자·융자) 지원</th>
                    <td><input type="text" name="q2_17_1" value="<%=qa[17][1][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 개사</td>
                  </tr>
                  <tr>
                    <th>물자(원재료·설비) 지원</th>
                    <td><input type="text" name="q2_17_2" value="<%=qa[17][2][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 개사</td>
                  </tr>
                  <tr>
                    <th>인력(교육) 지원</th>
                    <td><input type="text" name="q2_17_3" value="<%=qa[17][3][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 개사</td>
                  </tr>
                  <tr>
                    <th>기술(설계) 지원</th>
                    <td><input type="text" name="q2_17_4" value="<%=qa[17][4][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 개사</td>
                  </tr>
                  <tr>
                    <th>경영(컨설팅·정보화) 지원</th>
                    <td><input type="text" name="q2_17_5" value="<%=qa[17][5][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 개사</td>
                  </tr>
                  <tr>
                    <th>판로(내수·수출) 지원</th>
                    <td><input type="text" name="q2_17_6" value="<%=qa[17][6][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 개사</td>
                  </tr>
                  <tr>
                    <th>기타 지원</th>
                    <td><input type="text" name="q2_17_7" value="<%=qa[17][7][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 개사</td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <h2 class="contenttitle">하도급거래 세부사항 2 : 특약·기술자료</h2>
      
      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha9">18. 특약에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">※ 문18-1에서 문18-2는 특약에 관한 질문입니다.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> 귀사는 <%= nCurrentYear-1%>년도에 수급사업자와 하도급계약을 체결하면서 계약서 등에 특약 내용을 포함하여 작성한 적이 있습니까?</li>
            <li class="boxcontentsubtitle">* 특약은 하도급 본 계약서 내용 외에 클레임 약정서 등 계약상 권리·의무 관계를 기재한 서면 등을 말함</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_18_1" value="<%=setHiddenValue(qa, 18, 1, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_18_1" value="1" <%if(qa[18][1][1]!=null && qa[18][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"></input> 가. 있다</li>
            <li><input type="radio" name="q2_18_1" value="2" <%if(qa[18][1][2]!=null && qa[18][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"></input> 나. 없다<span class="boxcontentsubtitle">문19-로</span></li>
          </ul>
          <div class="fc pt_50"></div>
          <div class="fc pt_20"></div>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> 귀사가 수급사업자와 체결한 하도급계약서 등에 특약내용을 포함한 이유는 무엇입니까?</li>
            <li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li><input type="checkbox" name="q2_18_2_1" value="1" <%if(qa[18][2][1]!=null && qa[18][2][1].equals("1")){out.print("checked");}%>></input> 가. 계약시점에 예측할 수 없는 사항으로 인한 비용을 수급사업자와 분담하기 위해</li>
            <li><input type="checkbox" name="q2_18_2_2" value="1" <%if(qa[18][2][2]!=null && qa[18][2][2].equals("1")){out.print("checked");}%>></input> 나. 민원처리, 인·허가, 환경관리, 품질관리 등에 따른 비용을 수급사업자와 분담하기 위해</li>
            <li><input type="checkbox" name="q2_18_2_3" value="1" <%if(qa[18][2][3]!=null && qa[18][2][3].equals("1")){out.print("checked");}%>></input> 다. 설계 및 작업내용 변경으로 발생한 비용을 수급사업자와 분담하기 위해</li>
            <li><input type="checkbox" name="q2_18_2_4" value="1" <%if(qa[18][2][4]!=null && qa[18][2][4].equals("1")){out.print("checked");}%>></input> 라. 하자담보책임 또는 손해배상책임 이행에 따른 비용을 수급사업자와 분담하기 위해</li>
            <li><input type="checkbox" name="q2_18_2_5" value="1" <%if(qa[18][2][5]!=null && qa[18][2][5].equals("1")){out.print("checked");}%>></input> 마. 기타 (<input type="text" name="q2_18_29" value="<%=qa[18][29][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha10">19. 기술 자료 제공 요구에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">※ 문19-1에서 문19-7은 기술자료 제공 요구에 관한 질문입니다.</li>          
        </ul>
      </div>
      
      <div class="boxcontent2">
        <ul class="boxcontenthelp lt">
          <li class="boxcontenttitle">"기술자료"는 수급사업자의 상당한 노력에 의하여 만들어져 현재 비밀로 유지되고 있는 기술상 또는 경영상의 정보로서 아래 항목 중 하나에 해당하는 정보·자료를 말함.</li>
          <li class="boxcontenttitle">&nbsp;</li>
          <li class="boxcontenttitle">가. 제조·수리·시공 또는 용역수행 방법에 관한 정보·자료.</li>
          <li class="boxcontenttitle">나. 특허권, 실용신안권, 디자인권, 저작권 등의 지식재산권과 관련된 기술정보·자료로서 수급사업자의 기술개발(R&D)·생산·영업활동에 유용하고 독립된 경제적 가치가 있는 것.</li>
          <li class="boxcontenttitle">다. 시공프로세스 매뉴얼, 장비 제원, 설계도면, 생산 원가 내역서, 매출 정보 등 가목 또는 나목에 포함되지 않는 기타 사업자의 기술상 또는 경영상의 정보·자료로서 수급사업자의 기술개발(R&D)·생산·영업활동에 유용하고 독립된 경제적 가치가 있는 것.</li>
        </ul>
      </div>

      <div class="fc pt_10"></div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> 귀사는  <%= nCurrentYear-1%>년도에 수급사업자에게 기술 자료를 요구한 적이 있습니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_19_1" value="<%=setHiddenValue(qa, 19, 1, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_19_1" value="1" <%if(qa[19][1][1]!=null && qa[19][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);"></input> 가. 있다<span class="boxcontentsubtitle">문19-2로</span></li>
            <li><input type="radio" name="q2_19_1" value="2" <%if(qa[19][1][2]!=null && qa[19][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);"></input> 나. 없다<span class="boxcontentsubtitle">문20-1로</span></li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> 귀사가 수급사업자에게 기술 자료를 요구한 이유는 무엇입니까?</li>
            <li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li><input type="checkbox" name="q2_19_2_1" value="1" <%if(qa[19][2][1]!=null && qa[19][2][1].equals("1")){out.print("checked");}%>></input> 가. 공동 특허 개발</li>
            <li><input type="checkbox" name="q2_19_2_2" value="1" <%if(qa[19][2][2]!=null && qa[19][2][2].equals("1")){out.print("checked");}%>></input> 나. 공동 기술개발 약정 체결</li>
            <li><input type="checkbox" name="q2_19_2_3" value="1" <%if(qa[19][2][3]!=null && qa[19][2][3].equals("1")){out.print("checked");}%>></input> 다. 제품 하자의 원인규명</li>
            <li><input type="checkbox" name="q2_19_2_4" value="1" <%if(qa[19][2][4]!=null && qa[19][2][4].equals("1")){out.print("checked");}%>></input> 라. 기타 (<input type="text" name="q2_19_11" value="<%=qa[19][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(3) </span> 귀사는 수급사업자로부터 취득한 기술 자료를 어떻게 활용하였습니까?</li>
            <li class="boxcontentsubtitle">(해당 항목을 모두 선택)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li><input type="checkbox" name="q2_19_3_1" value="1" <%if(qa[19][3][1]!=null && qa[19][3][1].equals("1")){out.print("checked");}%>></input> 가. 공동특허, 공동 기술개발 약정 체결, 제품하자의 원인규명에 한정하여 사용</li>
            <li><input type="checkbox" name="q2_19_3_2" value="1" <%if(qa[19][3][2]!=null && qa[19][3][2].equals("1")){out.print("checked");}%>></input> 나. 공동특허, 공동 기술개발 약정 체결, 제품하자의 원인규명 이외 목적으로 귀사를 위해 사용</li>
            <li><input type="checkbox" name="q2_19_3_3" value="1" <%if(qa[19][3][3]!=null && qa[19][3][3].equals("1")){out.print("checked");}%>></input> 다. 공동특허, 공동 기술개발 약정 체결, 제품하자의 원인규명 이외 목적으로 제3자를 위해 사용</li>
            <li><input type="checkbox" name="q2_19_3_4" value="1" <%if(qa[19][3][4]!=null && qa[19][3][4].equals("1")){out.print("checked");}%>></input> 라. 공동특허, 공동 기술개발 약정 체결, 제품하자의 원인규명 이외 목적으로 제3자에게 제공</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(4) </span> 귀사는  <%= nCurrentYear-1%>년도에 수급사업자에게 기술 자료를 서면으로 요구한 적이 있습니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_19_4" value="<%=setHiddenValue(qa, 19, 4, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_19_4" value="1" <%if(qa[19][4][1]!=null && qa[19][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,4);"></input> 가. 있다(<input type="text" name="q2_19_12" value="<%=qa[19][12][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>건)<span class="boxcontentsubtitle">문19-5로</span></li>
            <li><input type="radio" name="q2_19_4" value="2" <%if(qa[19][4][2]!=null && qa[19][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,4);"></input> 나. 없다<span class="boxcontentsubtitle">문19-6으로</span></li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(5) </span> 귀사가 기술자료 요구 시 사용한 서면자료 양식은 무엇입니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_19_5" value="<%=setHiddenValue(qa, 19, 5, 3)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_19_5" value="1" <%if(qa[19][5][1]!=null && qa[19][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,5);"></input> 가. 자체양식</li>
            <li><input type="radio" name="q2_19_5" value="2" <%if(qa[19][5][2]!=null && qa[19][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,5);"></input> 나. 기술자료 요구서(공정위 예규 제263호 서식1)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(6) </span> 귀사는  <%= nCurrentYear-1%>년도에 수급사업자에게 기술 자료를 구두로 요구한 적이 있습니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_19_6" value="<%=setHiddenValue(qa, 19, 6, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_19_6" value="1" <%if(qa[19][6][1]!=null && qa[19][6][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,6);"></input> 가. 있다(<input type="text" name="q2_19_13" value="<%=qa[19][13][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>건)<span class="boxcontentsubtitle">문19-7로</span></li>
            <li><input type="radio" name="q2_19_6" value="2" <%if(qa[19][6][2]!=null && qa[19][6][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,6);"></input> 나. 없다<span class="boxcontentsubtitle">문20-1로</span></li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(7) </span> 귀사가 기술 자료를 구두로 요구한 주된 이유는 무엇입니까?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_19_7" value="<%=setHiddenValue(qa, 19, 7, 4)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_19_7" value="1" <%if(qa[19][7][1]!=null && qa[19][7][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,7);"></input> 가. 서면발급 의무를 알지 못해서</li>
            <li><input type="radio" name="q2_19_7" value="2" <%if(qa[19][7][2]!=null && qa[19][7][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,7);"></input> 나. 서면발급이 필요한 사항인지 불분명해서</li>
            <li><input type="radio" name="q2_19_7" value="3" <%if(qa[19][7][3]!=null && qa[19][7][3].equals("1")){out.print("checked");}%> onclick="checkradio(19,7);"></input> 다. 기술 자료 요청 건수가 너무 많아서</li>
            <li><input type="radio" name="q2_19_7" value="4" <%if(qa[19][7][4]!=null && qa[19][7][4].equals("1")){out.print("checked");}%> onclick="checkradio(19,7);"></input> 라. 관행적으로 구두 요구로 처리해서</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      
      
      <h2 class="contenttitle">하도급거래 세부사항 3 : 전속거래·PB거래</h2>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha11">20. 전속거래에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">※ 문20-1에서 문20-3은 전속거래에 관한 질문입니다.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> 귀사는 <%= nCurrentYear-1%>년에 수급사업자와 하도급 전속거래를 맺은 적이 있습니까?</li>
            <li class="boxcontentsubtitle">* 전속거래란 수급사업자로 하여금 원사업자인 '자기' 또는 '자기가 지정하는 사업자'와만 거래하도록 하는 것을 의미함.</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_20_1" value="<%=setHiddenValue(qa, 20, 1, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_20_1" value="1" <%if(qa[20][1][1]!=null && qa[20][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"></input> 가. 있다</li>
            <li><input type="radio" name="q2_20_1" value="2" <%if(qa[20][1][2]!=null && qa[20][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"></input> 나. 없다<span class="boxcontentsubtitle">문21-1로</span></li>
          </ul>
          <div class="fc pt_50"></div>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> <%= nCurrentYear-1%>년도 전체 하도급거래에서 수급사업자와 전속거래를 맺은 업체 수 비중, 구매 비중, 지속기간이 어떻게 됩니까?</li>
            <li class="boxcontentsubtitle">(해당사항 모두 체크)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:60%;" />
                  <col style="width:40%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>구분</th>
                    <th>내용</th>
                  </tr>
                  <tr>
                    <th>전체 수급사업자 중 전속거래 업체 수 비중</th>
                    <td><input type="text" name="q2_20_21" value="<%=qa[20][21][20]%>" onKeyUp="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>전체 구매금액 중 전속거래로부터 구매 비중</th>
                    <td><input type="text" name="q2_20_22" value="<%=qa[20][22][20]%>" onKeyUp="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>전속거래 평균 기간</th>
                    <td><input type="text" name="q2_20_23" value="<%=qa[20][23][20]%>" onKeyUp="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> 개월</td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(3) </span> 귀사가 전속거래를 통해 기대하는 바가 무엇인지 모두 선택하고 선택한 기대가 어느 정도 충족되고 있는지 평가해 주십시오.</li>
            <li class="boxcontentsubtitle">(해당사항 모두 체크)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:40%;" />
                  <col style="width:12%;" />
                  <col style="width:12%;" />
                  <col style="width:12%;" />
                  <col style="width:12%;" />
                  <col style="width:12%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>항목</th>
                    <th>전혀 충족 안됨</th>
                    <th>별로 충족 안됨</th>
                    <th>보통</th>
                    <th>약간 충족</th>
                    <th>매우 충족</th>
                  </tr>
                  <tr>
                    <th style="text-align: left;"><input type="checkbox" name="q2_20_3_1" value="1" <%if(qa[20][3][1]!=null && qa[20][3][1].equals("1")){out.print("checked");}%>></input>1) 품질 유지</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_20_41" value="<%=setHiddenValue(qa, 20, 41, 5)%>"></input>
                      <input type="radio" name="q2_20_41" value="1" <%if(qa[20][41][1]!=null && qa[20][41][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,41);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_41" value="2" <%if(qa[20][41][2]!=null && qa[20][41][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,41);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_41" value="3" <%if(qa[20][41][3]!=null && qa[20][41][3].equals("1")){out.print("checked");}%> onclick="checkradio(20,41);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_41" value="4" <%if(qa[20][41][4]!=null && qa[20][41][4].equals("1")){out.print("checked");}%> onclick="checkradio(20,41);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_41" value="5" <%if(qa[20][41][5]!=null && qa[20][41][5].equals("1")){out.print("checked");}%> onclick="checkradio(20,41);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th style="text-align: left;"><input type="checkbox" name="q2_20_3_2" value="1" <%if(qa[20][3][2]!=null && qa[20][3][2].equals("1")){out.print("checked");}%>></input>2) 원가 경쟁력 유지</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_20_42" value="<%=setHiddenValue(qa, 20, 42, 5)%>"></input>
                      <input type="radio" name="q2_20_42" value="1" <%if(qa[20][42][1]!=null && qa[20][42][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,42);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_42" value="2" <%if(qa[20][42][2]!=null && qa[20][42][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,42);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_42" value="3" <%if(qa[20][42][3]!=null && qa[20][42][3].equals("1")){out.print("checked");}%> onclick="checkradio(20,42);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_42" value="4" <%if(qa[20][42][4]!=null && qa[20][42][4].equals("1")){out.print("checked");}%> onclick="checkradio(20,42);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_42" value="5" <%if(qa[20][42][5]!=null && qa[20][42][5].equals("1")){out.print("checked");}%> onclick="checkradio(20,42);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th style="text-align: left;"><input type="checkbox" name="q2_20_3_3" value="1" <%if(qa[20][3][3]!=null && qa[20][3][3].equals("1")){out.print("checked");}%>></input>3) 기술유출 방지</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_20_43" value="<%=setHiddenValue(qa, 20, 43, 5)%>"></input>
                      <input type="radio" name="q2_20_43" value="1" <%if(qa[20][43][1]!=null && qa[20][43][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,43);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_43" value="2" <%if(qa[20][43][2]!=null && qa[20][43][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,43);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_43" value="3" <%if(qa[20][43][3]!=null && qa[20][43][3].equals("1")){out.print("checked");}%> onclick="checkradio(20,43);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_43" value="4" <%if(qa[20][43][4]!=null && qa[20][43][4].equals("1")){out.print("checked");}%> onclick="checkradio(20,43);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_43" value="5" <%if(qa[20][43][5]!=null && qa[20][43][5].equals("1")){out.print("checked");}%> onclick="checkradio(20,43);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th style="text-align: left;"><input type="checkbox" name="q2_20_3_4" value="1" <%if(qa[20][3][4]!=null && qa[20][3][4].equals("1")){out.print("checked");}%>></input>4) 안정적 물량 조달</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_20_44" value="<%=setHiddenValue(qa, 20, 44, 6)%>"></input>
                      <input type="radio" name="q2_20_44" value="1" <%if(qa[20][44][1]!=null && qa[20][44][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,44);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_44" value="2" <%if(qa[20][44][2]!=null && qa[20][44][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,44);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_44" value="3" <%if(qa[20][44][3]!=null && qa[20][44][3].equals("1")){out.print("checked");}%> onclick="checkradio(20,44);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_44" value="4" <%if(qa[20][44][4]!=null && qa[20][44][4].equals("1")){out.print("checked");}%> onclick="checkradio(20,44);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_44" value="5" <%if(qa[20][44][5]!=null && qa[20][44][5].equals("1")){out.print("checked");}%> onclick="checkradio(20,44);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th style="text-align: left;"><input type="checkbox" name="q2_20_3_5" value="1" <%if(qa[20][3][5]!=null && qa[20][3][5].equals("1")){out.print("checked");}%>></input>5) 기타(<input type="text" name="q2_20_39" value="<%=qa[20][39][20]%>" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>)</th>
                    <td style="text-align: center;">
                      <input type="hidden" name="c2_20_45" value="<%=setHiddenValue(qa, 20, 45, 6)%>"></input>
                      <input type="radio" name="q2_20_45" value="1" <%if(qa[20][45][1]!=null && qa[20][45][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,45);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_45" value="2" <%if(qa[20][45][2]!=null && qa[20][45][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,45);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_45" value="3" <%if(qa[20][45][3]!=null && qa[20][45][3].equals("1")){out.print("checked");}%> onclick="checkradio(20,45);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_45" value="4" <%if(qa[20][45][4]!=null && qa[20][45][4].equals("1")){out.print("checked");}%> onclick="checkradio(20,45);"></input>
                    </td>
                    <td style="text-align: center;">
                      <input type="radio" name="q2_20_45" value="5" <%if(qa[20][45][5]!=null && qa[20][45][5].equals("1")){out.print("checked");}%> onclick="checkradio(20,45);"></input>
                    </td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <h2 class="contenttitle">새로 도입된 제도에 대한 인지도 및 건의</h2>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha12">21. 제도에 관하여</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
        </ul>
      </div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> 다음은 공정거래위원회에서 불공정한 하도급거래 관행을 근절하기 위해 하도급법에 도입하여 운영하고 있는 제도입니다. 아래 각 제도에 대한 귀사의 인지 정도를 &lt;보기&gt;를 참고하여 응답해 주시기 바랍니다.</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
                <div class="boxcontentright">
                  <ul class="lt">
                    <li>
                      <table class="tbl_blue">
                        <colgroup>
                          <col style="width:38%;" />
                          <col style="width:10%;" />
                          <col style="width:10%;" />
                          <col style="width:10%;" />
                          <col style="width:10%;" />
                          <col style="width:10%;" />
                        </colgroup>
                        <tbody>
                          <tr>
                            <th>항목</th>
                            <th>들어본 적 없음</th>
                            <th>들어본 적은 있지만 내용을 전혀 모름</th>
                            <th>내용을 대략적으로 알고 있음</th>
                            <th>내용을 구체적으로 알고 있음</th>
                            <th>내용을 완벽히 알고 있음</th>
                          </tr>
                          <tr>
                            <th style="text-align: left;">1) 3배 손해배상제 적용대상 확대</th>
                            <td style="text-align: center;">
                              <input type="hidden" name="c2_21_20" value="<%=setHiddenValue(qa, 21, 20, 6)%>"></input>
                              <input type="radio" name="q2_21_20" value="1" <%if(qa[21][20][1]!=null && qa[21][20][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,20);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_20" value="2" <%if(qa[21][20][2]!=null && qa[21][20][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,20);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_20" value="3" <%if(qa[21][20][3]!=null && qa[21][20][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,20);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_20" value="4" <%if(qa[21][20][4]!=null && qa[21][20][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,20);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_20" value="5" <%if(qa[21][20][5]!=null && qa[21][20][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,20);"></input>
                            </td>
                          </tr>
                          <tr>
                            <th style="text-align: left;">2) 부당특약 금지</th>
                            <td style="text-align: center;">
                              <input type="hidden" name="c2_21_21" value="<%=setHiddenValue(qa, 21, 21, 6)%>"></input>
                              <input type="radio" name="q2_21_21" value="1" <%if(qa[21][21][1]!=null && qa[21][21][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,21);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_21" value="2" <%if(qa[21][21][2]!=null && qa[21][21][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,21);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_21" value="3" <%if(qa[21][21][3]!=null && qa[21][21][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,21);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_21" value="4" <%if(qa[21][21][4]!=null && qa[21][21][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,21);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_21" value="5" <%if(qa[21][21][5]!=null && qa[21][21][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,21);"></input>
                            </td>
                          </tr>
                          <tr>
                            <th style="text-align: left;">3) 하도급대금 지급보증 제도 보완</th>
                            <td style="text-align: center;" >
                              <input type="hidden" name="c2_21_22" value="<%=setHiddenValue(qa, 21, 22, 6)%>"></input>
                              <input type="radio" name="q2_21_22" value="1" <%if(qa[21][22][1]!=null && qa[21][22][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,22);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_22" value="2" <%if(qa[21][22][2]!=null && qa[21][22][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,22);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_22" value="3" <%if(qa[21][22][3]!=null && qa[21][22][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,22);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_22" value="4" <%if(qa[21][22][4]!=null && qa[21][22][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,22);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_22" value="5" <%if(qa[21][22][5]!=null && qa[21][22][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,22);"></input>
                            </td>
                          </tr>
                          <tr>
                            <th style="text-align: left;">4) 중소기업협동조합에 납품단가조정협의권을 부여</th>
                            <td style="text-align: center;">
                              <input type="hidden" name="c2_21_23" value="<%=setHiddenValue(qa, 21, 23, 6)%>"></input>
                              <input type="radio" name="q2_21_23" value="1" <%if(qa[21][23][1]!=null && qa[21][23][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,23);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_23" value="2" <%if(qa[21][23][2]!=null && qa[21][23][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,23);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_23" value="3" <%if(qa[21][23][3]!=null && qa[21][23][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,23);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_23" value="4" <%if(qa[21][23][4]!=null && qa[21][23][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,23);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_23" value="5" <%if(qa[21][23][5]!=null && qa[21][23][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,23);"></input>
                            </td>
                          </tr>
                          <tr>
                            <th style="text-align: left;">5) 조사개시 전 법위반 행위 자진시정 시 제재 면제</th>
                            <td style="text-align: center;">
                              <input type="hidden" name="c2_21_24" value="<%=setHiddenValue(qa, 21, 24, 6)%>"></input>
                              <input type="radio" name="q2_21_24" value="1" <%if(qa[21][24][1]!=null && qa[21][24][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,24);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_24" value="2" <%if(qa[21][24][2]!=null && qa[21][24][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,24);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_24" value="3" <%if(qa[21][24][3]!=null && qa[21][24][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,24);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_24" value="4" <%if(qa[21][24][4]!=null && qa[21][24][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,24);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_24" value="5" <%if(qa[21][24][5]!=null && qa[21][24][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,24);"></input>
                            </td>
                          </tr>
                          <tr>
                            <th style="text-align: left;">6) 중견기업의 수급사업자 보호대상 포함</th>
                            <td style="text-align: center;">
                              <input type="hidden" name="c2_21_25" value="<%=setHiddenValue(qa, 21, 25, 6)%>"></input>
                              <input type="radio" name="q2_21_25" value="1" <%if(qa[21][25][1]!=null && qa[21][25][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,25);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_25" value="2" <%if(qa[21][25][2]!=null && qa[21][25][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,25);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_25" value="3" <%if(qa[21][25][3]!=null && qa[21][25][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,25);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_25" value="4" <%if(qa[21][25][4]!=null && qa[21][25][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,25);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_25" value="5" <%if(qa[21][25][5]!=null && qa[21][25][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,25);"></input>
                            </td>
                          </tr>
                          <tr>
                            <th style="text-align: left;">7) 신고포상금 지급</th>
                            <td style="text-align: center;">
                              <input type="hidden" name="c2_21_26" value="<%=setHiddenValue(qa, 21, 26, 6)%>"></input>
                              <input type="radio" name="q2_21_26" value="1" <%if(qa[21][26][1]!=null && qa[21][26][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,26);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_26" value="2" <%if(qa[21][26][2]!=null && qa[21][26][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,26);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_26" value="3" <%if(qa[21][26][3]!=null && qa[21][26][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,26);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_26" value="4" <%if(qa[21][26][4]!=null && qa[21][26][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,26);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_26" value="5" <%if(qa[21][26][5]!=null && qa[21][26][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,26);"></input>
                            </td>
                          </tr>
                          <tr>
                            <th style="text-align: left;">8) 조사개시 후 대금 미지급 자진시정 시 벌점 부과 면제</th>
                            <td style="text-align: center;">
                              <input type="hidden" name="c2_21_27" value="<%=setHiddenValue(qa, 21, 27, 6)%>"></input>
                              <input type="radio" name="q2_21_27" value="1" <%if(qa[21][27][1]!=null && qa[21][27][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,27);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_27" value="2" <%if(qa[21][27][2]!=null && qa[21][27][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,27);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_27" value="3" <%if(qa[21][27][3]!=null && qa[21][27][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,27);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_27" value="4" <%if(qa[21][27][4]!=null && qa[21][27][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,27);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_27" value="5" <%if(qa[21][27][5]!=null && qa[21][27][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,27);"></input>
                            </td>
                          </tr>
                          <tr>
                            <th style="text-align: left;">9) 단순기술 유출도 위법행위로 인정</th>
                            <td style="text-align: center;">
                              <input type="hidden" name="c2_21_28" value="<%=setHiddenValue(qa, 21, 28, 6)%>"></input>
                              <input type="radio" name="q2_21_28" value="1" <%if(qa[21][28][1]!=null && qa[21][28][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,28);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_28" value="2" <%if(qa[21][28][2]!=null && qa[21][28][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,28);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_28" value="3" <%if(qa[21][28][3]!=null && qa[21][28][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,28);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_28" value="4" <%if(qa[21][28][4]!=null && qa[21][28][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,28);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_28" value="5" <%if(qa[21][28][5]!=null && qa[21][28][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,28);"></input>
                            </td>
                          </tr>
                          <tr>
                            <th style="text-align: left;">10) 기술탈취 행위에 대한 조사시효를 3년에서 7년으로 연장</th>
                            <td style="text-align: center;">
                              <input type="hidden" name="c2_21_29" value="<%=setHiddenValue(qa, 21, 29, 6)%>"></input>
                              <input type="radio" name="q2_21_29" value="1" <%if(qa[21][29][1]!=null && qa[21][29][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,29);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_29" value="2" <%if(qa[21][29][2]!=null && qa[21][29][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,29);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_29" value="3" <%if(qa[21][29][3]!=null && qa[21][29][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,29);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_29" value="4" <%if(qa[21][29][4]!=null && qa[21][29][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,29);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_29" value="5" <%if(qa[21][29][5]!=null && qa[21][29][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,29);"></input>
                            </td>
                          </tr> 
                          <tr>
                            <th style="text-align: left;">11) 경영정보 요구 금지, 특정 사업자와 거래유도 금지, 기술 수출 제한 행위 금지</th>
                            <td style="text-align: center;">
                              <input type="hidden" name="c2_21_30" value="<%=setHiddenValue(qa, 21, 30, 6)%>"></input>
                              <input type="radio" name="q2_21_30" value="1" <%if(qa[21][30][1]!=null && qa[21][30][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,30);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_30" value="2" <%if(qa[21][30][2]!=null && qa[21][30][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,30);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_30" value="3" <%if(qa[21][30][3]!=null && qa[21][30][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,30);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_30" value="4" <%if(qa[21][30][4]!=null && qa[21][30][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,30);"></input>
                            </td>
                            <td style="text-align: center;">
                              <input type="radio" name="q2_21_30" value="5" <%if(qa[21][30][5]!=null && qa[21][30][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,30);"></input>
                            </td>
                          </tr>            
                        </tbody>
                      </table>
                    </li>
                  </ul>
                </div>        
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <table class="tbl_blue">
          <colgroup>
            <col style="width:16%;" />
            <col style="width:16%;" />
            <col style="width:16%;" />
            <col style="width:16%;" />
            <col style="width:16%;" />
            <col style="width:16%;" />
          </colgroup>
          <tbody>
            <tr>
              <th rowspan="2">보기</th>
              <th>1</th>
              <th>2</th>
              <th>3</th>
              <th>4</th>
              <th>5</th>
            </tr>
            <tr>
              <th>들어본 적 없음</th>
              <th>들어본 적은 있지만 내용을 전혀 모름</th>
              <th>내용을 대략적으로 알고 있음</th>
              <th>내용을 구체적으로 알고 있음</th>
              <th>내용을 완벽히 알고 있음</th>
            </tr>
          </tbody>
        </table>
      </div>
      
      <div class="fc pt_10"></div>
      
         <div class="boxcontent2">
            <ul class="boxcontenthelp lt">
              <li class="boxcontenttitle">1) 3배 손해배상 제도 : <span style="font-size:12px;font-weight:400">원사업자의 기술유용, 부당한 하도급대금 결정·감액, 부당 위탁취소 및 부당반품 행위에서 보복행위도 추가로 적용범위가<br/> 확대 되었으며 피해를 입은 수급사업자가 법원에 손해 배상 청구를 하여 손해액의 3배까지 배상을 받을 수 있는 제도</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">2) 부당특약 금지 :<span style="font-size:12px;font-weight:400">원사업자가 수급사업자의 이익을 부당하게 침해하거나 제한하는 계약조건을 설정하지 못하도록 하는 제도</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">3) 하도급대금 지급보증 제도 : <span style="font-size:12px;font-weight:400">원사업자가 수급사업자에게 하도급계약의 체결일로부터 30일 이내에 하도급대금 지급보증을 하도록 기한 명시하고,<br/>원사업자가 하도급대금 지급 보증을 하지 않은 경우 수급사업자로부터 제공받는 계약이행보증을 청구할 수 없음</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">4) 중소기업협<span style="font-size:12px;font-weight:400">동조합에 납품단가조정협의권을 부여 : 공급원가(재료비, 노무비, 경비 등)의 급격한 변동으로 하도급대금의 조정이 필요한 경우<br/>수급사업자는 원사업자에게 하도급대금의 조정을 신청하거나, 중소기업협동조합이 소속 조합원인 수급사업자의 신청을 받아 원사업자와<br/>하도급대금의 조정을 협의할 수 있고, 원사업자는 정당한 사유 없이 그 협의를 거부할 수 없고 10일 안에 협의를 개시하도록 하는 제도</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">5) 조사개시 전 법위반 행위 자진시정 시 제재 면제 : <span style="font-size:12px;font-weight:400">사업자가 자신의 법위반 행위를 공정위 조사 전 스스로 시정하고 수급사업자들에게 피해구제 조치까지 완료한 경우에는 하도급법상 모든 제재조치를 면제하는 제도를 도입하여 시행</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">6) 중견기업의 수급사업자 보호대상 포함 : <span style="font-size:12px;font-weight:400">① 상호출자제한 기업집단 소속 회사가 매출액 3,000억 원 미만인 중견기업에게 위탁을 주거나,<br/>② 직전연도 매출액이 2조 원을 초과하는 대규모 중견기업이 직전연도 매출액이 업종별 중소기업 규모 기준 상한액의 2배에 해당하는 800억 원 ~ 3,000억 원 미만인 소규모 중견기업에게 위탁을 주는 경우 하도급법 적용 대상으로 포함하여 대금 지급에 있어 수급사업자가 보호를 받을 수 있음</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">7) 신고포상금 지급 : <span style="font-size:12px;font-weight:400">부당 단가 인하, 부당 발주 취소, 부당 반품·수령 거부 및 기술 유용 행위를 신고한 자에게 포상금을 지급하는 제도</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">8) 조사개시 후 대금 미지급 자진시정 시 벌점 부과 면제 : <span style="font-size:12px;font-weight:400">사업자가 대금 미지급에 대해 공정위 조사개시 후 30일 이내에 자진시정한 경우하도급법상<br/>벌점 부과조치를 면제하는 제도</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">9) 단순기술 유출도 위법행위로 인정 :<span style="font-size:12px;font-weight:400"> 원사업자가 취득한 수급사업자의 기술자료에 관하여 부당하게 '자기 또는 제3자를 위하여 사용하는 행위' 및<br/>'제3자에게 제공하는 행위'를 금지하는 행위로 단순히 '유출'하는 행위도 위법한 행위로 인정됨</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">10) 기술탈취 행위에 대한 조사시효를 3년에서 7년으로 연장 : <span style="font-size:12px;font-weight:400">기술자료 요구·유출·유용 등의 기술탈취 행위에 한해서는 조사개시 시효를 거래 종료 후<br/>'3년'에서 '7년'으로 확대</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">11) 경영정보 요구 금지, 특정 사업자와 거래유도 금지, 기술 수출 제한 행위 금지 :<span style="font-size:12px;font-weight:400"> 원사업자는 하도급 업체에게 정당한 사유 없이 원가 자료 등 경영정보를 요구하는 행위, 자기 또는 자기가 지정하는 사업자와 거래하도록 구속하는 행위, 하도급업체의 기술 수출을 제한하는 행위 등이 금지</span></li>
            </ul>
          </div>
        
        <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"> 22. 하도급제도 개선 또는 원사업자와 수급사업자간 수평적 협력관계 증진을 위하여 건의, 개선할 사항 등이 있으면 기재하여 주시기 바랍니다.<a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
        </ul>
      </div>

      <div class="fc pt_2"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="lt">
            <li class="boxcontentsubtitle"><p align="right" id="content_bytes25_1"> 0/4000byte</p></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt"><textarea cols="80" rows="8" maxlength="600" name="q2_22_1" class="textarea01b" maxlength="600" onFocus="javascript:this.className='textarea01o';" onBlur="javascript:this.className='textarea01b';" onkeyup="byteLengCheck(this, 4000, this.name,'content_bytes25_1');"><%=qa[22][1][20]%></textarea>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_20"></div>
      
      
      
      <div class="boxcontent2">
        <ul class="boxcontenthelp lt">
          <li class="boxcontenttitle"><p align="center"> 지금까지 사실대로 조사표를 작성해 주신데 대하여 감사드리며<br/>
          다음은 수급사업자 명부를 작성하여 주시기 바랍니다.</p></li>
        </ul>
      </div>

      <div class="fc pt_20"></div>

      <!-- 버튼 start -->
      <div class="fr">
        <ul class="lt">
          <%// 조사마감으로 저장버튼 가림 / 20141027 / 정광식%>
          <%// 조사마감으로 저장버튼 가림 / 20180716 / 김보선%>
          <%if (nAnswerCnt <= 0 ) {%>
          <li class="fl pr_2"><a href="javascript:savef2()" onfocus="this.blur()" class="contentbutton2">임시저장</a></li>
          <%}%>

          <%
          String oStatus = sOentStatus; // 조사표 제출 ("1")

          if (oStatus.equals("1")) {%>
          <li class="fl pr_2"><a href="#none" onfocus="this.blur()" class="contentbutton2">제출완료</a></li>
          <%}else{%>
          <li class="fl pr_2"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">저 장</a></li>
          <%} %>

          <li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">화면 인쇄하기</a></li>
          <li class="fl pr_2"><a href="./WB_VP_Subcon.jsp" onfocus="this.blur()" class="contentbutton2">4. 수급사업자 명부</a></li>
        </ul>
      </div>

      <!-- 버튼 end -->

    </div>
        </form>
        <!-- End subcontent -->

        <!-- Begin Footer -->
        <div id="subfooter"><img src="img/bottom.gif"/></div>
        <!-- End Footer -->

    </div>
    </div>

    <%/*-----------------------------------------------------------------------------------------------
    2010년 4월 26일 / iframe 추가 / 정광식
    :: 하도급거래상황 (설문문항) 선택 후 저장 시 오류발생으로 기존정보 소실되는 경우를 방지하기 위해 
    :: 선택사항을 iframe 타겟으로 submit 시킴
    */%>
    <iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
    <%/*-----------------------------------------------------------------------------------------------*/%>
    <!--div id="infoLayer" style="position: absolute; visibility:'hidden' ; z-index:100; top:1; left:1;">
        <table width="550" cellpadding="2" cellspacing="4" border="0">
            <tr><td bgcolor="#FF9900" align="center" valign="top" height="40">
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td width="5">
                        <td bgcolor="#FFFFCC" valign="middle" height="40"><div id="infoLayerText" name="infoLayerText"></div></td>
                    </tr>
                </table>
            </td></tr>
        </table>
    </div-->

<script language="JavaScript">
    <%if ( StringUtil.checkNull(request.getParameter("isSaved")).equals("1") ) {%>
        alert("하도급 거래상황 정상적으로 저장되었습니다.")
    <%}%>
</script>

</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>