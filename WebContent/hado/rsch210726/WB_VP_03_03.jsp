<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��     : �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���     : WB_VP_03_03.jsp
* ���α׷�����    : �ϵ��� �ŷ���Ȳ ���
* ���α׷�����    : 3.0.1
* �����ۼ�����    : 2014�� 09�� 14��
* �� �� �� ��       :
*=========================================================
*   �ۼ�����        �ۼ��ڸ�                ����
*=========================================================
*   2014-09-14  ������    �����ۼ�
*   2015-12-30  ������     DB�������� ���� ���ڵ� ����
*   2016-04-12  �ڿ���     ����ǥ ���� �� ���� ����
*   2016-04-14  �ڿ���     ���蹮�� �� üũ�ڽ� �ش� ���� �׸� ��Ȱ��ȭ �߰�
*   2018-06-22  �躸��   fn_TotalPayCheck �ȳ� ���� �߰�
*   2018-06-26  �躸��   research2f, research3f üũ�� ������ -1, -2�� ���� ���� ����ó��
*   2018-06-28  �躸��   ���蹮�� ���� ����
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
* �Է����� ���� ���� ���� �� �ʱ�ȭ ����
*/
String[][][] qa   = new String[30][50][30];
String[][][] opay = new String[3][3][9];
String[][] arrType  = new String[4][9];
String[][] arrTerm  = new String[4][9];

String sSubconType  = ""; // �ϵ��ްŷ�����
String sOentStatus    = ""; // ���ۿ���
String sCompStatus    = ""; // ȸ�翵������
String sOentSsale = "0";        // �ϵ��� �ŷ��ݾ�

// Cookie Request
String sMngNo   = ckMngNo;
String sOentYYYY  = ckCurrentYear;
String sCurrentYear = ckCurrentYear;
String sOentGB    = ckOentGB;

int np = 0;
int nAnswerCnt = 0;

/* �׸�ǥ���� ���⵵ �׸� ǥ�� ����� ���� ����⵵ ������ ��ȯ */
int nCurrentYear = 0;
if( !ckCurrentYear.equals("") ) {
  nCurrentYear = Integer.parseInt(ckCurrentYear);
}


/**
* �Է����� ���� ���� ���� �� �ʱ�ȭ ��
*/

if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
  // �迭 �ʱ�ȭ
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

    // �ش��ü ���ۿ��� ��������
    // Subcon_Type : �ϵ��ްŷ����� (1:�ֱ⸸��, 2:�ֱ⵵�ϰ�ޱ⵵��, 3:�ޱ⸸��, 4:����������������)
    // Comp_Status : �������� (1: ���󿵾� <-- ���ݿ�)
    // Oent_Status : ���ۿ��� (1: ����)
        // Oent_Ssale : ��ü �ϵ��ްŷ��ݾ�[VAT ���� �ݾ�]
    sSQLs  ="SELECT Subcon_Type, Comp_Status, Oent_Status, Oent_Ssale \n";
    sSQLs+="FROM HADO_TB_Oent_"+ckCurrentYear+" \n";
    sSQLs+= "WHERE Mng_No = ? AND Current_Year = ? AND Oent_Gb = ? \n";

    pstmt = conn.prepareStatement(sSQLs);
    pstmt.setString(1, sMngNo);
    pstmt.setString(2, sCurrentYear);
    pstmt.setString(3, sOentGB);

    //System.out.println("����1 = "+sSQLs);

    rs = pstmt.executeQuery();

    if (rs.next()) {
      sSubconType = rs.getString("Subcon_Type")== null ? "":rs.getString("Subcon_Type").trim();
      sCompStatus = rs.getString("Comp_Status")== null ? "":rs.getString("Comp_Status").trim();
      sOentStatus = rs.getString("Oent_Status")== null ? "":rs.getString("Oent_Status").trim();
            sOentSsale = rs.getString("Oent_Ssale")==null ? "0":rs.getString("Oent_Ssale").trim();
    }
    //System.out.println("�� : "+sOentStatus);
    rs.close();

    int qcd = 0;
    int qgb = 0;

    // �ش��ü ���䳻�� ��������
    sSQLs  ="SELECT * \n";
    sSQLs+="FROM HADO_TB_Oent_Answer_"+ckCurrentYear+" \n";
    sSQLs+= "WHERE Mng_No = ? AND Current_Year = ? AND Oent_Gb = ? \n";

    pstmt = conn.prepareStatement(sSQLs);
    pstmt.setString(1, sMngNo);
    pstmt.setString(2, sCurrentYear);
    pstmt.setString(3, sOentGB);

    //System.out.println("����2 = "+sSQLs);

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
      // ���䳻���� ���� ��� �ӽ����̺� �ӽ������� ������ �ִ��� Ȯ��
      sSQLs  ="SELECT * \n";
      sSQLs+="FROM HADO_TMP_OENT_ANSWER_"+ckCurrentYear+" \n";
      sSQLs+="WHERE Mng_No = ? AND Current_Year = ? AND Oent_Gb = ? \n";
      sSQLs+="ORDER BY Oent_Q_CD, Oent_Q_GB \n";

      pstmt = conn.prepareStatement(sSQLs);
      pstmt.setString(1, sMngNo);
      pstmt.setString(2, sCurrentYear);
      pstmt.setString(3, sOentGB);

      //System.out.println("����3 = "+sSQLs);

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

    // �ϵ��޴�� ���� ���Ͽ�
    sSQLs  ="SELECT * \n";
    sSQLs+="FROM HADO_TB_Rec_Pay_"+ckCurrentYear+" \n";
    sSQLs+="WHERE Mng_No = ? AND Current_Year = ? AND Oent_Gb = ? \n";
    sSQLs+="Order By Oent_Q_CD, Oent_Q_GB, Rec_Pay_GB \n";

    pstmt = conn.prepareStatement(sSQLs);
    pstmt.setString(1, sMngNo);
    pstmt.setString(2, sCurrentYear);
    pstmt.setString(3, sOentGB);

    //System.out.println("����4 = "+sSQLs);

    rs = pstmt.executeQuery();

    while (rs.next()) {
      rpg             = rs.getInt("Rec_Pay_GB");
      hg              = rs.getInt("Half_GB"); // ��,�Ϲݱ� ���� (2005����� �Ϲݱ⸸ �ް� ���� : Half_gb='1')
      opay[rpg][hg][1]  = rs.getString("Currency")== null ? "":new String(rs.getString("Currency"));  // ����
      opay[rpg][hg][2]  = rs.getString("Ent_Card")== null ? "":new String(rs.getString("Ent_Card"));  // �����������ī��
      opay[rpg][hg][3]  = rs.getString("Ent_Loan")== null ? "":new String(rs.getString("Ent_Loan"));  // ��������ڱݴ���
      opay[rpg][hg][4]  = rs.getString("Cred_Loan")== null ? "":new String(rs.getString("Cred_Loan"));  // �ܻ����ä�Ǵ㺸����
      opay[rpg][hg][5]  = rs.getString("Buy_Loan")== null ? "":new String(rs.getString("Buy_Loan"));  // ���ŷ�
      opay[rpg][hg][6]  = rs.getString("Network_Loan")== null ? "":new String(rs.getString("Network_Loan"));  // ��Ʈ��ũ��
      opay[rpg][hg][7]  = rs.getString("Bill")== null ? "":new String(rs.getString("Bill"));  // ����
      opay[rpg][hg][8]  = rs.getString("Etc")== null ? "":new String(rs.getString("Etc"));  // ��Ÿ
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

    <title><%= nCurrentYear %>�⵵ �ϵ��ްŷ� ������� ����</title>
    
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

          // ���󿵾� + �ϵ��ްŷ�����(�ֱ⸸��[1],�ֱ⵵�ϰ�ޱ⸸��[2]) �ϰ�� üũ
      //if( (stype == "1" || stype=="2") && sCompStatus == "1" ) {
      // �ϵ��ްŷ�����(�ֱ⸸��[1],�ֱ⵵�ϰ�ޱ⸸��[2]) �ϰ�� üũ
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
        
        research2f_txt(main, 7, 1, 1, 0, '2018�⵵ �ϵ����� �� �ݾ�');
        research2f_txt(main, 7, 2, 1, 0, '2019�⵵ �ϵ����� �� �ݾ�');
        research2f_txt(main, 7, 3, 1, 0, '2020�⵵ �ϵ����� �� �ݾ�');
        research2f_txt(main, 9, 1, 1, 0, '�� ���� ����� ��');
        research2f_txt(main, 9, 2, 1, 0, '�ͻ翡�� �ϵ����� �� ������� ��');
        research2f_txt(main, 9, 3, 1, 0, '�� ���� ����� ��');
        research2f_txt(main, 9, 4, 1, 0, '�ͻ簡 �ϵ����� �� ���޻���� ��');
        
        research2f(main, 8, 1, 2, 0);
        research2f(main, 10, 1, 2, 0);
        research2f(main, 10, 2, 2, 0);
        research2f(main, 10, 5, 2, 0);
        research2f_txt(main, 11, 20, 2, 0, '(2)�׸��� 1)�ͻ��� �ΰǺ� ��ȭ');
        research2f_txt(main, 11, 21, 2, 0, '(2)�׸��� 2)�ͻ簡 ������ ������ ���� ��ȭ');
        research2f_txt(main, 11, 22, 2, 0, '(2)�׸��� 3)���޻������ ���꼺 ��ȭ');
        research2f_txt(main, 11, 23, 2, 0, '(2)�׸��� 4)���޻������ �ΰǺ� ��ȭ');
        research2f_txt(main, 11, 24, 2, 0, '(2)�׸��� 5)���޻���ڰ� ������ ������ ���� ��ȭ');
        research2f_txt(main, 11, 25, 2, 0, '(2)�׸��� 6)����(����)�� ���� ��ȭ');
        research2f_txt(main, 11, 26, 2, 0, '(2)�׸��� 7)ȯ�� ��ȭ');
        research2f_txt(main, 11, 27, 2, 0, '(2)�׸��� 8)���� ���ݰ��� ���� ��ȭ');
        research2f_txt(main, 11, 28, 2, 0, '(2)�׸��� 9)��Ÿ');
        research2f(main, 11, 3, 2, 0);
        research2f(main, 12, 1, 2, 0);
        research2f(main, 13, 1, 2, 0);
        research2f(main, 14, 1, 2, 0);
        research2f_txt(main, 15, 11, 1, 0, '(1)�׸��� �߼ұ�� ���޻���ڿ��� ���� ������ ����');
        research2f_txt(main, 15, 12, 1, 0, '(1)�׸��� �߼ұ�� ���޻���ڿ��� �ܻ����ä�� �㺸���� ������ ����');
        research2f_txt(main, 15, 13, 1, 0, '(1)�׸��� �߼ұ�� ���޻���ڿ��� �����������ī�� ������ ����');
        research2f_txt(main, 15, 14, 1, 0, '(1)�׸��� �߼ұ�� ���޻���ڿ��� ���ŷ� ������ ����');
        research2f_txt(main, 15, 15, 1, 0, '(1)�׸��� �߼ұ�� ���޻���ڿ��� ������� �ý��� ������ ����');
        research2f_txt(main, 15, 16, 1, 0, '(1)�׸��� �߼ұ�� ���޻���ڿ��� �� ������ü�������� ������ ����');
        research2f_txt(main, 15, 17, 1, 0, '(1)�׸��� �߼ұ�� ���޻���ڿ��� ����(���� 60�� ����) ������ ����');
        research2f_txt(main, 15, 18, 1, 0, '(1)�׸��� �߼ұ�� ���޻���ڿ��� ����(���� 61~120��) ������ ����');
        research2f_txt(main, 15, 19, 1, 0, '(1)�׸��� �߼ұ�� ���޻���ڿ��� ����(���� 121�� �ʰ�) ������ ����');
        research2f_txt(main, 15, 20, 1, 0, '(1)�׸��� �߼ұ�� ���޻���ڿ��� ��Ÿ ������ ����');
        research2f_txt(main, 15, 21, 1, 0, '(1)�׸��� �߰߱�� ���޻���ڿ��� ���� ������ ����');
        research2f_txt(main, 15, 22, 1, 0, '(1)�׸��� �߰߱�� ���޻���ڿ��� �ܻ����ä�� �㺸���� ������ ����');
        research2f_txt(main, 15, 23, 1, 0, '(1)�׸��� �߰߱�� ���޻���ڿ��� �����������ī�� ������ ����');
        research2f_txt(main, 15, 24, 1, 0, '(1)�׸��� �߰߱�� ���޻���ڿ��� ���ŷ� ������ ����');
        research2f_txt(main, 15, 25, 1, 0, '(1)�׸��� �߰߱�� ���޻���ڿ��� ������� �ý��� ������ ����');
        research2f_txt(main, 15, 26, 1, 0, '(1)�׸��� �߰߱�� ���޻���ڿ��� �� ������ü�������� ������ ����');
        research2f_txt(main, 15, 27, 1, 0, '(1)�׸��� �߰߱�� ���޻���ڿ��� ����(���� 60�� ����) ������ ����');
        research2f_txt(main, 15, 28, 1, 0, '(1)�׸��� �߰߱�� ���޻���ڿ��� ����(���� 61~120��) ������ ����');
        research2f_txt(main, 15, 29, 1, 0, '(1)�׸��� �߰߱�� ���޻���ڿ��� ����(���� 121�� �ʰ�) ������ ����');
        research2f_txt(main, 15, 30, 1, 0, '(1)�׸��� �߰߱�� ���޻���ڿ��� ��Ÿ ������ ����');
        research2f(main, 15, 2, 2, 0);
        research2f(main, 16, 1, 2, 0);
        research2f_txt(main, 17, 1, 1, 0, '(1)�ڱ� ���� ��ü ��');
        research2f_txt(main, 17, 2, 1, 0, '(1)���� ���� ��ü ��');
        research2f_txt(main, 17, 3, 1, 0, '(1)�η� ���� ��ü ��');
        research2f_txt(main, 17, 4, 1, 0, '(1)��� ���� ��ü ��');
        research2f_txt(main, 17, 5, 1, 0, '(1)�濵 ���� ��ü ��');
        research2f_txt(main, 17, 6, 1, 0, '(1)�Ƿ� ���� ��ü ��');
        research2f_txt(main, 17, 7, 1, 0, '(1)��Ÿ ���� ��ü ��');
        research2f(main, 18, 1, 2, 0);
        research2f(main, 19, 1, 2, 0);
        research2f(main, 20, 1, 2, 0);
        research2f_txt(main, 21, 20, 2, 0, '(1) 3�� ���ع���� ������ Ȯ��');
        research2f_txt(main, 21, 21, 2, 0, '(2) �δ�Ư�� ����');
        research2f_txt(main, 21, 22, 2, 0, '(3) �ϵ��޴�� ���޺��� ���� ���� ');
        research2f_txt(main, 21, 23, 2, 0, '(4) �߼ұ���������տ� ��ǰ�ܰ��������Ǳ��� �ο�');
        research2f_txt(main, 21, 24, 2, 0, '(5) ���簳�� �� ������ ���� �������� �� ���� ����');
        research2f_txt(main, 21, 25, 2, 0, '(6) �߰߱���� ���޻���� ��ȣ��� ����');
        research2f_txt(main, 21, 26, 2, 0, '(7) �Ű������ ����');
        research2f_txt(main, 21, 27, 2, 0, '(8) ���簳�� �� ��� ������ �������� �� ���� �ΰ� ����');
        research2f_txt(main, 21, 28, 2, 0, '(9) �ܼ���� ���⵵ ���������� ����');
        research2f_txt(main, 21, 29, 2, 0, '(10) ���Ż�� ������ ���� �����ȿ�� 3�⿡�� 7������ ���� ��');
        research2f_txt(main, 21, 30, 2, 0, '(11) �濵���� �䱸 ����, Ư�� ����ڿ� �ŷ����� ����, ��� ���� ���� ���� ����');

        if( main.q2_5_1[1].checked==true ) {
          initf(main, 6, 1, 1, 0);  initf(main, 6, 2, 1, 0);  initf(main, 6, 2, 1, 0);
        }
        else {
          research3f_txt(main, 6, 1, 1, 0, 5, 1, '(1)������ 2017�⵵ �ϵ����� ���� �ݾ�');
          research3f_txt(main, 6, 2, 1, 0, 5, 1, '(1)������ 2018�⵵ �ϵ����� ���� �ݾ�');
          research3f_txt(main, 6, 3, 1, 0, 5, 1, '(1)������ 2019�⵵ �ϵ����� ���� �ݾ�');
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
            research3f_txt(main, 10, 11, 1, 0, 10, 2, '(4)������ 15�� �̳� �� ȸ�� �Ǽ�');
            research3f_txt(main, 10, 12, 1, 0, 10, 2, '(4)������ ���� ȸ�� �Ǽ�');
            research3f_txt(main, 10, 13, 1, 0, 10, 2, '(4)������ ���� ȸ�� �Ǽ�');
            research3f_txt(main, 10, 14, 1, 0, 10, 2, '(4)������ 15�� ���� ȸ�� �Ǵ� ȸ������ ���� �Ǽ�');
          }
        }
        
        
        if( main.q2_10_5[0].checked==true ) initf(main, 10, 6, 2, 0); else research3f(main, 10, 6, 2, 0, 10, 5);
        
        if( main.q2_12_1[0].checked==true ) initf(main, 12, 2, 3, 6); else research3f(main, 12, 2, 3, 6, 12, 1);
        
        if( main.q2_13_1[0].checked==true ) initf(main, 13, 2, 3, 8); else research3f(main, 13, 2, 3, 8, 13, 1);
        
        if( main.q2_14_1[0].checked==true ) initf(main, 14, 2, 3, 11); else research3f(main, 14, 2, 3, 11, 14, 1);
        
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 31, 1, 0); else research3f_txt(main, 15, 31, 1, 0, 15, 2, '(3)������  �߼ұ�� ���޻���ڿ��� ���� ������ ����');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 32, 1, 0); else research3f_txt(main, 15, 32, 1, 0, 15, 2, '(3)������  �߼ұ�� ���޻���ڿ��� ������ü �������� ������ ����');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 33, 1, 0); else research3f_txt(main, 15, 33, 1, 0, 15, 2, '(3)������  �߼ұ�� ���޻���ڿ��� ���� ������ ����');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 34, 1, 0); else research3f_txt(main, 15, 34, 1, 0, 15, 2, '(3)������  �߼ұ�� ���޻���ڿ��� ��Ÿ ������ ����');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 41, 1, 0); else research3f_txt(main, 15, 41, 1, 0, 15, 2, '(3)������  �߰߱�� ���޻���ڿ��� ���� ������ ����');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 42, 1, 0); else research3f_txt(main, 15, 42, 1, 0, 15, 2, '(3)������  �߰߱�� ���޻���ڿ��� ������ü �������� ������ ����');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 43, 1, 0); else research3f_txt(main, 15, 43, 1, 0, 15, 2, '(3)������  �߰߱�� ���޻���ڿ��� ���� ������ ����');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 44, 1, 0); else research3f_txt(main, 15, 44, 1, 0, 15, 2, '(3)������  �߰߱�� ���޻���ڿ��� ��Ÿ ������ ����');
        if( main.q2_15_2[0].checked==true ) initf(main, 15, 4, 2, 0); else research3f(main, 15, 4, 2, 0, 15, 2);
        
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 11, 1, 0); else research3f_txt(main, 16, 11, 1, 0, 16, 1, '(2)������  ���� �ϵ��޴�� ������û�� ���޻���� ��');
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 12, 1, 0); else research3f_txt(main, 16, 12, 1, 0, 16, 1, '(2)������  ���� �ϵ��޴�� ������û�� ���޻���ڿ� 10�� �̳��� ���Ǹ� ������ ��ü ��');
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 13, 1, 0); else research3f_txt(main, 16, 13, 1, 0, 16, 1, '(2)������  �߼ұ������������ ���� ������û�� ���޻���� ��');
        if( main.q2_16_1[1].checked==true ) initf(main, 16, 14, 1, 0); else research3f_txt(main, 16, 14, 1, 0, 16, 1, '(2)������  �߼ұ������������ ���� ������û�� ���޻���ڿ� 10�� �̳��� ���Ǹ� ������ ��ü ��');
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
        
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 21, 1, 0); else research3f_txt(main, 20, 21, 1, 0, 20, 1, '(2)������ ���Ӱŷ� ��ü �� ����');//
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 22, 1, 0); else research3f_txt(main, 20, 22, 1, 0, 20, 1, '(2)������ ���Ӱŷ��κ��� ���� ����');//
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 23, 1, 0); else research3f_txt(main, 20, 23, 1, 0, 20, 1, '(2)������ ���Ӱŷ� ��� �Ⱓ');//
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 3, 3, 5);  else research3f(main, 20, 3, 3, 5, 20, 1);
        /*
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 41, 2, 0); else research3f_txt(main, 20, 41, 2, 0, 20, 1, '(3)������ 1)ǰ�� ����');
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 42, 2, 0); else research3f_txt(main, 20, 42, 2, 0, 20, 1, '(3)������ 2)���� ����� ����');
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 43, 2, 0); else research3f_txt(main, 20, 43, 2, 0, 20, 1, '(3)������ 3)������� ����');
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 44, 2, 0); else research3f_txt(main, 20, 44, 2, 0, 20, 1, '(3)������ 4)������ ���� ����');
        if( main.q2_20_1[1].checked==true ) initf(main, 20, 45, 2, 0); else research3f_txt(main, 20, 45, 2, 0, 20, 1, '(3)������ 5)��Ÿ');
          */
      }
            //} else {
                //msg = "�ϵ��ްŷ��� ���ų� �ޱ⸸�ϴ� ���\n[�ϵ��ްŷ���Ȳ]�� �ۼ����� �ʽ��ϴ�.\n\n�ش� ������ �����Ͽ� �ֽʽÿ�.";
            //}

            if(msg=="") {
                if(confirm("[ ����ǥ������ �����մϴ�. ]\n\n�����ڰ� ������� �ټ� �ð��� �ɸ����� �ֽ��ϴ�.\n���������� ������ �ȵɰ��\n���ʺ��Ŀ� �ٽýõ��Ͽ� �ֽʽÿ�.\n\n������ ���Ϸ� ���忡 �����Ұ��\n�����Ͻ� ���系���� ������ �� �����ϴ�.\n�����Ͻ� ����ǥ�� �μ��Ͽ� �����Ͻð�\n�������������� ���콺������ ��ư�� ����\n���ΰ�ħ�� �����Ͽ� �������� �õ��Ͻʽÿ�.\n\nȮ���� �����ø� �����մϴ�.")) {
                    
                    processSystemStart("[1/1] �Է��� �ϵ��ްŷ���Ȳ�� �����մϴ�.");

                    main.target = "ProceFrame";
                    main.action = "WB_CP_Research_Qry.jsp?type=Srv&step=Detail";
                    main.submit();
                }
            } else {
                alert(msg+"\n\n������ ��ҵǾ����ϴ�.")
            }

        }
        
        /**
         * 2. ȸ�簳�� ���� ��ü �ϵ��ްŷ��ݾ�[VAT ���� �ݾ�]��
         * �ϵ��� ��� ���޻����� �հ�(�߼ұ�� + �߰߱��)���� 
         * ������� ��������
         * @param: total (2�� ȸ�簳������ ��ü �ϵ��ްŷ��ݾ�)
         * @param: main (form��ü)
         */
        function fn_TotalPayCheck(total, main) {
            var qhap16 = Cnum(main.qhap16.value);
            var qhap25 = Cnum(main.qhap25.value);
            if(total < (qhap16 + qhap25)) {
                msg += '\n\n[�ȳ�����]\n�� �ϵ��޴�� �����׸��� �ݾ� �Է� ������ "�鸸��, �ΰ���ġ������"\n�̹Ƿ�, �ݾ״����� �ٽ� Ȯ�� �� �Է��Ͽ� �ֽñ� �ٶ��ϴ�.';
                <%//2018-06-22 �躸�� �ȳ� �޽��� �߰�%>
                msg += ' ����, \n"2.ȸ�簳��"���� �ۼ� �� <%= nCurrentYear-1 %>�⵵ ��ü �ϵ��ްŷ��ݾ׺��� \n"3.�ϵ��� �ŷ���Ȳ"���� �ۼ� �� �ϵ��޴������ �ݾ��� Ŭ ��� ������� �ʽ��ϴ�. �ٽ� Ȯ�� �� �Է��Ͽ� �ֽñ� �ٶ��ϴ�.';
            }
        }

        function savef2(main) {
            var main = document.info;

            if( confirm("[�ӽ�����] ����� ������ ����� �����ϱ� ���� ����Դϴ�.\n\n����ǥ�� ������ �ϱ� ���ؼ��� �� [�� ��] ����� �̿��ϼž� �ϸ�,\n[�� ��] ����� ������� ���� ��� [����ǥ ����]�� �ȵǿ���\n����ǥ ������ �Ϸ��Ҷ��� ���� [�� ��] ����� �̿��ϼž� �մϴ�.\n\nȮ���� �����ø� [�ӽ�����] ����� �����մϴ�.") ) {
                
                processSystemStart("[1/1] �Է��� �ϵ��ްŷ���Ȳ�� �ӽ������մϴ�.");

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
        if( main.q2_10_5[0].checked==true ) initf(main, 10, 19, 1, 0); else research3f(main, 10, 19, 1, 0, 10, 5);//����� ���� üũ����
        
        if( main.q2_12_1[0].checked==true ) initf(main, 12, 2, 3, 6); else research3f(main, 12, 2, 3, 6, 12, 1);
        if( main.q2_12_1[0].checked==true ) initf(main, 12, 29, 1, 0); else research3f(main, 12, 29, 1, 0, 12, 1);//����� ���� üũ����
        
        if( main.q2_13_1[0].checked==true ) initf(main, 13, 2, 3, 8); else research3f(main, 13, 2, 3, 8, 13, 1);
        if( main.q2_13_1[0].checked==true ) initf(main, 13, 29, 1, 0); else research3f(main, 13, 29, 1, 0, 13, 1);//����� ���� üũ����
        
        if( main.q2_14_1[0].checked==true ) initf(main, 14, 2, 3, 11); else research3f(main, 14, 2, 3, 11, 14, 1);
        if( main.q2_14_1[0].checked==true ) initf(main, 14, 29, 1, 0); else research3f(main, 14, 29, 1, 0, 14, 1);//����� ���� üũ����
        
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

    // Radio object �缱�ý� �ʱ�ȭ
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

    //-- �ʼ��׸� ���ÿ��� Ȯ�� --//
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
          eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+fno+"���� ("+sno+")���� �Է��Ͽ� �ֽʽÿ�.'");
        } else {
          eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+fno+"���� ("+sno+")���� �����Ͽ� �ֽʽÿ�.'");
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
          eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+fno+"�� "+txt+"��(��) �Է��Ͽ� �ֽʽÿ�.'");
        } else {
          eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+fno+"�� "+txt+"��(��) �����Ͽ� �ֽʽÿ�.'");
        }
      }
    }

    //-- �����׸� ���ÿ��� Ȯ�� --//
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

      // ���蹮�� �� �� ������ ���� 1 : Ȱ��ȭ , 2 : ��Ȱ��ȭ
      chBoxDisplay(obj, fno, sno, type, gesu, 2);

      if(ccheck=="no") {
        msg=msg+"\n";
        
        if( type=="1") {
          eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+ofno+"���� ("+osno+")���� ���蹮�� "+fno+"���� ("+sno+")���� �Է��Ͽ� �ֽʽÿ�.'");
        } else {
          eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+ofno+"���� ("+osno+")���� ���蹮�� "+fno+"���� ("+sno+")���� �����Ͽ� �ֽʽÿ�.'");
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

      // ���蹮�� �� �� ������ ���� 1 : Ȱ��ȭ , 2 : ��Ȱ��ȭ
      chBoxDisplay(obj, fno, sno, type, gesu, 2);

      if(ccheck=="no") {
        msg=msg+"\n";
        
        if( type=="1") {
          eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+ofno+"���� ("+osno+")���� ���蹮�� "+fno+"���� "+txt+"��(��) �Է��Ͽ� �ֽʽÿ�.'");
        } else {
          eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+ofno+"���� ("+osno+")���� ���蹮�� "+fno+"���� "+txt+"��(��) �����Ͽ� �ֽʽÿ�.'");
        }
      }
    }


    // ���� �ʱ�ȭ function
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

          // ���蹮�� �� �� ������ ���� 1 : Ȱ��ȭ , 2 : ��Ȱ��ȭ
          chBoxDisplay(obj, fno, sno, type, gesu, 1);

        break;
      }
    }

    // üũ�ڽ� Ȱ��ȭ / ��Ȱ��ȭ
    function chBoxDisplay(obj,fno,sno,type,gesu,view) {
      //alert("��:"+obj+"/"+fno+"/"+sno+"Ÿ��:"+type);
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
    /* 20160411 �ڿ��� �߰� */
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
      if(confirm("�����ܰ���� �̵��� �����ϼ̽��ϴ�.\n\n�����Ͻ� ����� ���� ���� �� ������ ������\n�������� �ʰ� �̵��մϴ�.\n������ ������ ������� ���� �� �����Ͻʽÿ�.\n\nȮ���� �����ø� �̵��մϴ�.")) {
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
      // ���ݼ� �Ⱓ��
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
        alert("�ִ� ���� �Է¼��� �ʰ� �Ͽ����ϴ�.");
        frmobj.value = frmobj.value.substr(0,nlen);
        obj.innerText = maxlength+"/"+maxlength+"byte";
      }

      frmobj.focus();
    }

    function goPrint() {
      /*url = "ProdStep_03_Print.jsp";
      w = 820;
      h = 600;

      if(confirm("ȭ�� �μ�� ����ǥ ���� �Ŀ� �����մϴ�.\n\n�μ��Ͻðڽ��ϱ�?\n[Ȯ��]�� �����ø� �μ�˴ϴ�.")) {
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
                        <li class="pt_20"><font color="#FF6600">[�뿪��]</font>
                            <%=ckOentName%>&nbsp;/&nbsp;<iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" align="center" frameborder="0"></iframe></li>
                    </ul>
                </li>
            </ul>
        </div>

        <div id="submenu">
            <ul class="lt fr">
                <li class="fl pr_2"><a href="./WB_VP_Introduction.jsp" onfocus="this.blur()" class="mainmenu">1. ���� �ȳ�</a></li>
                <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. ȸ�簳��</a></li>
                <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenuup">3. �ϵ��� �ŷ���Ȳ</a></li>
                <li class="fl pr_2"><a href="./WB_VP_Subcon.jsp" onfocus="this.blur()" class="mainmenu">4. ���޻���� ���</a></li>
                <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="mainmenu">5. ����ǥ ����</a></li>
            </ul>
        </div>
        <!-- End Header -->

        <form action="" method="post" name="info">
    <!-- Begin subcontent -->
    <div id="subcontent">
      <!-- title start -->
      <h1 class="contenttitle">3. �ϵ��� �ŷ� ��Ȳ</h1>
      <!-- title end -->

      <div class="fc pt_2"></div>

      <!-- 20160427 / �ڿ��� / ���� -->
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="lt">
            <li class="boxcontenttitle"><a name="mokcha">�� ��</a></li>
            <li class="boxcontentsubtitle">(Ŭ���Ͻø� �ش� ������ �̵��մϴ�.)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="clt"><!-- ���� -->
            <li><a href="#mokcha0" class="contentbutton3">�ϵ��ްŷ� �⺻���׿� ���Ͽ�</a></li>
            <li><a href="#mokcha1" class="contentbutton3">10. ���޻���� ������� �� ��� ����� ���Ͽ�</a></li>
            <li><a href="#mokcha2" class="contentbutton3">11. �ϵ��� ��� ü�� ��, �ϵ��޿뿪 �ܰ��� ������ ���Ͽ�</a></li>
            <li><a href="#mokcha3" class="contentbutton3">12. �뿪 ��Ź�� ��� �� ���濡 ���Ͽ�</a></li>
            <li><a href="#mokcha4" class="contentbutton3">13. ��ǰ ���ɿ� ���Ͽ�</a></li>
            <li><a href="#mokcha5" class="contentbutton3">14. ���ü�� ��, �ϵ��޴�� ���׿� ���Ͽ�</a></li>
            <li><a href="#mokcha6" class="contentbutton3">15. �ϵ��޴�� ���޿� ���Ͽ�</a></li>
            <li><a href="#mokcha7" class="contentbutton3">16. ���޿���(����,�빫��,��� ��) ������ ���� �ϵ��޴�� ���� ��û�� ���Ͽ�</a></li>
            <li><a href="#mokcha8" class="contentbutton3">17. ���°��迡 ���Ͽ�</a></li>
            <li><a href="#mokcha9" class="contentbutton3">18. Ư��� �����Ͽ�</a></li>
            <li><a href="#mokcha10" class="contentbutton3">19. ��� �ڷ� ���� �䱸�� ���Ͽ�</a></li>
            <li><a href="#mokcha11" class="contentbutton3">20. ���Ӱŷ��� ���Ͽ�</a></li>
            <li><a href="#mokcha12" class="contentbutton3">21. ���� ���Ե� ������ ���� ������</a></li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <h2 class="contenttitle">�ϵ��ްŷ� �⺻����</h2>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha0">�ϵ��ްŷ� �⺻���׿� ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>5. </span>�ͻ��� ���� <%=nCurrentYear-1%>�� �ϵ��ްŷ� ���´� ��մϱ�?</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_5_1" value="<%=setHiddenValue(qa, 5, 1, 3)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_5_1" value="1" <%if(qa[5][1][1]!=null && qa[5][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"></input> ��. �ϵ����� �ֱ⵵ �ϰ� �ޱ⵵ ��<span class="boxcontentsubtitle">��6����</li>
            <li><input type="radio" name="q2_5_1" value="2" <%if(qa[5][1][2]!=null && qa[5][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"></input> ��. �ϵ����� �ֱ⸸ ��<span class="boxcontentsubtitle">��7��</span></li>
            <li><input type="radio" name="q2_5_1" value="3" <%if(qa[5][1][3]!=null && qa[5][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"></input> ��. �ϵ��ްŷ��� ���� ����</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>6. </span>�ͻ簡 ���� 3�Ⱓ ������ڷκ��� '�ϵ����� ����' �ݾ��� ���Դϱ�?</li>
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
                    <th>����</th>
                    <th>��(����) ����ڷκ��� �ϵ����� ���� �ݾ�<br/>[VAT ���� �ݾ�]</th>
                  </tr>
                  <tr>
                    <th><%= nCurrentYear-3%>�⵵</th>
                    <td>
                      <input type="text" name="q2_6_1" value="<%=qa[6][1][20]%>" onkeyup="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> �鸸��
                    </td>
                  </tr>
                  <tr>
                    <th><%= nCurrentYear-2%>�⵵</th>
                    <td>
                      <input type="text" name="q2_6_2" value="<%=qa[6][2][20]%>" onKeyUp="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> �鸸��
                    </td>
                  </tr>
                  <tr>
                    <th><%= nCurrentYear-1%>�⵵</th>
                    <td>
                      <input type="text" name="q2_6_3" value="<%=qa[6][3][20]%>" onkeyup="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> �鸸��
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
            <li class="boxcontenttitle"><span>7. </span>�ͻ簡 ���� 3�Ⱓ ���޻���ڿ��� '�ϵ����� ��' �ݾ��� ���Դϱ�?</li>
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
                    <th>����</th>
                    <th>����(����) ����ڿ��� �ϵ����� �� �ݾ�<br/>[VAT ���� �ݾ�]</th>
                  </tr>
                  <tr>
                    <th><%= nCurrentYear-3%>�⵵</th>
                    <td>
                      <input type="text" name="q2_7_1" value="<%=qa[7][1][20]%>" onkeyup ="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                    </td>
                  </tr>
                  <tr>
                    <th><%= nCurrentYear-2%>�⵵</th>
                    <td>
                      <input type="text" name="q2_7_2" value="<%=qa[7][2][20]%>" onKeyUp="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                    </td>
                  </tr>
                  <tr>
                    <th><%= nCurrentYear-1%>�⵵</th>
                    <td>
                      <input type="text" name="q2_7_3" value="<%=qa[7][3][20]%>" onkeyup ="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
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
            <li class="boxcontenttitle"><span>8. </span><%= nCurrentYear-1%>�⵵�� �ͻ簡 ���޻���ڿ��� '�ϵ����� ��' �ݾ��� �ܰ躰 ������ ������ �ֽʽÿ�.</li>
            <li class="boxcontentsubtitle">* [����] ������ �ϼ���ü �� 1�� ���¾�ü �� 2�� ���¾�ü �� 3�� ���¾�ü �� 4�� ���¾�ü ��</li>
                        <li class="boxcontentsubtitle">* �ͻ簡 �ϵ����� �ֱ⸸ �� ��� �ͻ�� ������ �ϼ���ü�� �ش�</li>
            <li class="boxcontentsubtitle">* �ͻ簡 ������ �ϼ���ü�κ��� �ϵ����� �޾� ���޻���ڿ��� �ϵ����� �� ��� �ͻ�� 1�� ���¾�ü�� �ش�</li>
            <li class="boxcontentsubtitle">* �ͻ簡 1�� ���¾�ü�κ��� �ϵ����� �޾� ���޻���ڿ��� �ϵ����� �� ��� �ͻ�� 2�� ���¾�ü�� �ش�</li>
          </ul>
        </div>
        <div class="boxcontentright">
                    <input type="hidden" name="c2_8_1" value="<%=setHiddenValue(qa, 8, 1, 6)%>"></input>
          <ul class="lt">
              <li><input type="radio" name="q2_8_1" value="1" <%if(qa[8][1][1]!=null && qa[8][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"></input> ��. ������ ������ü</li>
            <li><input type="radio" name="q2_8_1" value="2" <%if(qa[8][1][2]!=null && qa[8][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"></input> ��. 1�� ���¾�ü</li>
            <li><input type="radio" name="q2_8_1" value="3" <%if(qa[8][1][3]!=null && qa[8][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"></input> ��. 2�� ���¾�ü</li>
            <li><input type="radio" name="q2_8_1" value="4" <%if(qa[8][1][4]!=null && qa[8][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"></input> ��. 3�� ���¾�ü</li>
            <li><input type="radio" name="q2_8_1" value="5" <%if(qa[8][1][5]!=null && qa[8][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"></input> ��. 4�� ���¾�ü</li>
            <li><input type="radio" name="q2_8_1" value="6" <%if(qa[8][1][6]!=null && qa[8][1][6].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"></input> ��. �߸�</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>9. </span>�ͻ簡 <%= nCurrentYear-1%>�⵵�� �ŷ��� �������, ���޻���� ���� �� �����Դϱ�?</li>
            <li class="boxcontentsubtitle">* �� ����(����) ����ڴ� <%= nCurrentYear-1%>�⵵ ����ó��(����ó��) ���ݰ�꼭 �հ�ǥ�� ���Ե� ����ڵ�μ� �ϵ����� �ƴ� �ŷ��� ���� ����ڵ��� ������.</li>
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
                    <th>����</th>
                    <th>����� ��</th>
                  </tr>
                  <tr>
                    <th>�� ���� �����</th>
                    <td>
                      <input type="text" name="q2_9_1" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[9][1][20]%>"></input> ����
                    </td>
                  </tr>
                  <tr>
                    <th>�ͻ翡�� �ϵ����� �� �������</th>
                    <td>
                      <input type="text" name="q2_9_2" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[9][2][20]%>"></input> ����
                    </td>
                  </tr>
                  <tr>
                    <th>�� ���� �����</th>
                    <td>
                      <input type="text" name="q2_9_3" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[9][3][20]%>"></input> ����
                    </td>
                  </tr>
                  <tr>
                    <th>�ͻ簡 �ϵ����� �� ���޻����</th>
                    <td>
                      <input type="text" name="q2_9_4" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[9][4][20]%>"></input> ����
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

      <h2 class="contenttitle">�ϵ��ްŷ� ���λ��� 1 : �ŷ� ����</h2>

      <%-- <div class="boxcontent2">
        <ul class="boxcontenthelp clt">
          <li class="boxcontenttitle"><font color="#FF0066"><%= nCurrentYear-1%>.1.1.���� <%= nCurrentYear-1%>.12.31.</font>(��ǰ������ ����, ��� ���ݰ�꼭 �������� ����)������ �ϵ��ްŷ��� ���Ͽ� �ش��׸� üũ�Ͽ� �ֽʽÿ�.</li>
        </ul>
      </div> --%>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha1">10. ���޻���� ������� �� ��� ����� ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��10-1���� ��10-6�� ���޻���� ������� �� ������� ���� �����Դϴ�.</li>
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> �ͻ簡 <%= nCurrentYear-1%>�⵵ ������ ���޻���� �� �������� ����� ���� ������ ������ ��� �˴ϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_10_1" value="<%=setHiddenValue(qa, 10, 1, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_10_1" value="1" <%if(qa[10][1][1]!=null && qa[10][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"></input> ��. 100% (���� ��������)</li>
            <li><input type="radio" name="q2_10_1" value="2" <%if(qa[10][1][2]!=null && qa[10][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"></input> ��. 80% ~ 100% �̸�</li>
            <li><input type="radio" name="q2_10_1" value="3" <%if(qa[10][1][3]!=null && qa[10][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"></input> ��. 50% ~ 80% �̸�</li>
            <li><input type="radio" name="q2_10_1" value="4" <%if(qa[10][1][4]!=null && qa[10][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"></input> ��. 50% �̸�</li>
            <li><input type="radio" name="q2_10_1" value="5" <%if(qa[10][1][5]!=null && qa[10][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"></input> ��. 0% (���� ���ǰ��)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> �ͻ簡 <%= nCurrentYear-1%>�⵵ ���޻���ڿ� ��� �� �����༭(���ڹ��� ����)�� �ۼ��������� ������ ��� �˴ϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_10_2" value="<%=setHiddenValue(qa, 10, 2, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_10_2" value="1" <%if(qa[10][2][1]!=null && qa[10][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,2);"></input> ��. 100% (���� ������)<span class="boxcontentsubtitle">��10-5��</span></li>
            <li><input type="radio" name="q2_10_2" value="2" <%if(qa[10][2][2]!=null && qa[10][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,2);"></input> ��. 95% ~ 100% �̸� (������ ��� ������ ��ü ������)</li>
            <li><input type="radio" name="q2_10_2" value="3" <%if(qa[10][2][3]!=null && qa[10][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(10,2);"></input> ��. 75% ~ 95% �̸�</li>
            <li><input type="radio" name="q2_10_2" value="4" <%if(qa[10][2][4]!=null && qa[10][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(10,2);"></input> ��. 50% ~ 75% �̸�</li>
            <li><input type="radio" name="q2_10_2" value="5" <%if(qa[10][2][5]!=null && qa[10][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(10,2);"></input> ��. 50% �̸�</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle" ><span>(3) </span> �ͻ簡 <%= nCurrentYear-1%>�⵵ ���޻���ڿ��� ��Ź ����� ���η� ���� ���, ���޻���ڰ� �ͻ翡�� ��� ������ Ȯ���� ��û�ϴ� ����(�̸���,���ڹ��� ����)�� ������ ��찡 �� �� �ֽ��ϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_10_3" value="<%=setHiddenValue(qa, 10, 3, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_10_3" value="1" <%if(qa[10][3][1]!=null && qa[10][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,3);"></input> ��. �ִ�(<input type="text" name="q2_10_18" value="<%=qa[10][18][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>��)<span class="boxcontentsubtitle">��10-4��</span></li>
            <li><input type="radio" name="q2_10_3" value="2" <%if(qa[10][3][2]!=null && qa[10][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,3);"></input> ��. ����<span class="boxcontentsubtitle">��10-5��</span></li>
          </ul>
          <div class="fc pt_50"></div>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(4) </span> <%= nCurrentYear-1%>�⵵ ���޻���ڷκ��� Ȯ�ο�û ������ ���� ���, �ͻ簡 ���޻���ڿ��� 15�� �̳��� ȸ���� �Ǽ��� �� ����� ��Ͽ����ϱ�?</li>
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
                    <th>����</th>
                    <th>�Ǽ�</th>
                  </tr>
                  <tr>
                    <th>15�� �̳� �� ȸ��</th>
                    <td><input type="text" name="q2_10_11" value="<%=qa[10][11][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ��</td>
                  </tr>
                  <tr>
                    <th>���� ȸ��</th>
                    <td><input type="text" name="q2_10_12" value="<%=qa[10][12][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ��</td>
                  </tr>
                  <tr>
                    <th>���� ȸ��</th>
                    <td><input type="text" name="q2_10_13" value="<%=qa[10][13][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ��</td>
                  </tr>
                  <tr>
                    <th>15�� ���� ȸ�� �Ǵ� ȸ������ ����</th>
                    <td><input type="text" name="q2_10_14" value="<%=qa[10][14][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ��</td>
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
            <li class="boxcontenttitle"><span>(5) </span> �ͻ簡 <%= nCurrentYear-1%>�⵵ ���޻���ڿ� ���� ��༭�� �ۼ������� ��, ǥ���ϵ��ް�༭�� ����� ������ ��� �˴ϱ�?</li>
            <li class="boxcontentsubtitle">* �ֽ� ǥ���ϵ��ް�༭�� �ƴ� ���� ǥ���ϵ��ް�༭�� ����� ��쳪 ��������� Ư���� ����Ͽ� ǥ���ϵ��ް�༭�� �����Ͽ� ����� ��쿡�� ǥ���ϵ��ް�༭�� ����� ������ ������. ��, ���޻���ڿ��� �Ҹ��� ������ ���Ե��� �ʴ´ٴ� ���ǿ� ����.</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_10_5" value="<%=setHiddenValue(qa, 10, 5, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_10_5" value="1" <%if(qa[10][5][1]!=null && qa[10][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,5);"></input> ��. 100% (��ü ���)<span class="boxcontentsubtitle">��11-1��</span></li>
            <li><input type="radio" name="q2_10_5" value="2" <%if(qa[10][5][2]!=null && qa[10][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,5);"></input> ��. 95% ~ 100% �̸� (������ ��� ������ ��ü ������)</li>
            <li><input type="radio" name="q2_10_5" value="3" <%if(qa[10][5][3]!=null && qa[10][5][3].equals("1")){out.print("checked");}%> onclick="checkradio(10,5);"></input> ��. 75% ~ 95% �̸�</li>
            <li><input type="radio" name="q2_10_5" value="4" <%if(qa[10][5][4]!=null && qa[10][5][4].equals("1")){out.print("checked");}%> onclick="checkradio(10,5);"></input> ��. 50% ~ 75% �̸�</li>
            <li><input type="radio" name="q2_10_5" value="5" <%if(qa[10][5][5]!=null && qa[10][5][5].equals("1")){out.print("checked");}%> onclick="checkradio(10,5);"></input> ��. 50% �̸�</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(6) </span> ������ �� ǥ���ϵ��ް�༭�� ������� �ʾҴٸ� �ֵ� �� ������ �����Դϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_10_6" value="<%=setHiddenValue(qa, 10, 6, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_10_6" value="1" <%if(qa[10][6][1]!=null && qa[10][6][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,6);"></input> ��. ���� ��༭ ��� ����� ���� �δ��� �����ϱ� ������</li>
            <li><input type="radio" name="q2_10_6" value="2" <%if(qa[10][6][2]!=null && qa[10][6][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,6);"></input> ��. �츮 �������� ǥ���ϵ��ް�༭ ����� �������� �ʱ� ����</li>
            <li><input type="radio" name="q2_10_6" value="3" <%if(qa[10][6][3]!=null && qa[10][6][3].equals("1")){out.print("checked");}%> onclick="checkradio(10,6);"></input> ��. ǥ���ϵ��ް�༭ ������ ���� ���ǰ� ���� �ʱ� ����</li>
            <li><input type="radio" name="q2_10_6" value="4" <%if(qa[10][6][4]!=null && qa[10][6][4].equals("1")){out.print("checked");}%> onclick="checkradio(10,6);"></input> ��. ǥ���ϵ��ް�༭�� �ִ��� ������ ����</li>
            <li><input type="radio" name="q2_10_6" value="5" <%if(qa[10][6][5]!=null && qa[10][6][5].equals("1")){out.print("checked");}%> onclick="checkradio(10,6);"></input> ��. ��Ÿ(<input type="text" name="q2_10_19" value="<%=qa[10][19][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha2">11. �ϵ��ް�� ü�� ��, �ϵ��޿뿪 �ܰ��� ������ ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��11-1���� ��11-3�� �ϵ��� ��� ü�� ��, �ϵ��� �뿪 �ܰ��� ������ ���� �����Դϴ�.</li>
        </ul>
      </div>

      <div class="fc pt_2"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> �ͻ簡  <%= nCurrentYear-1%>�⵵�� ���޻���ڿ� ���� �ϵ��� �뿪 �ܰ��� <%= nCurrentYear-2%>�⵵ �ܰ��� ���� ��� ���� �����Ǿ����ϱ�? �ܰ� ������ ������ �ش�Ǵ� �ϵ��� ��� �Ǽ��� ������ �����Ͽ� �ֽʽÿ�.</li>
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
                    <th>�ܰ� ������ ����</th>
                    <th>�ϵ��� ��� �Ǽ��� ����</th>
                  </tr>
                  <tr>
                    <th>��ü</th>
                    <td><input type="text" readonly="readonly" name="allSum11" value="" size="30" class="text06"></input> %</td>
                  </tr>
                  <tr>
                    <th>10% �̻� ����</th>
                    <td><input type="text" name="q2_11_11" value="<%=qa[11][11][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>5~10% �̸� ����</th>
                    <td><input type="text" name="q2_11_12" value="<%=qa[11][12][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>0~5% �̸� ����</th>
                    <td><input type="text" name="q2_11_13" value="<%=qa[11][13][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>��ȭ ����</th>
                    <td><input type="text" name="q2_11_14" value="<%=qa[11][14][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>0~5% �̸� �λ�</th>
                    <td><input type="text" name="q2_11_15" value="<%=qa[11][15][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>5~10% �̸� �λ�</th>
                    <td><input type="text" name="q2_11_16" value="<%=qa[11][16][20]%>" onKeyUp="sukeyup(this); fn_hap(this.form);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>10% �̻�  �λ�</th>
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
            <li class="boxcontenttitle"><span>(2) </span> �ϵ��� �ܰ� ������ �Ʒ� ���ε��� ��������� ����Ͽ����ϱ�?</li>
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
                    <th>�׸�</th>
                    <th>���� ��� ����</th>
                    <th>���� ��� ����</th>
                    <th>����</th>
                    <th>�ణ ���</th>
                    <th>�ſ� ���</th>
                    <th>�ش���׾���</th>
                  </tr>
                  <tr>
                    <th style="text-align: left;">1) �ͻ��� �ΰǺ� ��ȭ</th>
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
                    <th style="text-align: left;">2) �ͻ簡 ������ ����� ���� ��ȭ</th>
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
                    <th style="text-align: left;">3) ���޻������ ���꼺 ��ȭ</th>
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
                    <th style="text-align: left;">4) ���޻������ �ΰǺ� ��ȭ</th>
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
                    <th style="text-align: left;">5) ���޻���ڰ� ������ ����� ���� ��ȭ</th>
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
                    <th style="text-align: left;">6) ����(����)�� ���� ��ȭ</th>
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
                    <th style="text-align: left;">7) ȯ�� ��ȭ</th>
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
                    <th style="text-align: left;">8) ���� ���ݰ��� ���� ��ȭ</th>
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
                    <th style="text-align: left;">9) ��Ÿ</th>
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
            <li class="boxcontenttitle"><span>(3) </span> �ϵ��� �ܰ� ������ ��� �̷�������ϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_11_3" value="<%=setHiddenValue(qa, 11, 3, 3)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_11_3" value="1" <%if(qa[11][3][1]!=null && qa[11][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,3);"></input> ��. �ͻ��� ���Ȱ� ���޻������ ����</li>
            <li><input type="radio" name="q2_11_3" value="2" <%if(qa[11][3][2]!=null && qa[11][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,3);"></input> ��. ���޻������ ���Ȱ� �ͻ��� ����</li>
            <li><input type="radio" name="q2_11_3" value="3" <%if(qa[11][3][3]!=null && qa[11][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,3);"></input> ��. ������ ���Ǹ� ���� ����</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha3">12. �뿪 ��Ź�� ��� �� ���濡 ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��12-1���� ��12-2�� �뿪 ��Ź�� ��� �� ���濡 ���� �����Դϴ�.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> <%= nCurrentYear-1%>�⵵�� �ͻ簡 ���޻���ڿ��� �뿪 ��Ź�� �� ��, ���Ƿ� ��Ź�� ����ϰų� �������� �ʰ� ������ ����� ������ ���Ǽ��� ������ ��� �˴ϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_12_1" value="<%=setHiddenValue(qa, 12, 1, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_12_1" value="1" <%if(qa[12][1][1]!=null && qa[12][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> ��. 100% (��ü����)<span class="boxcontentsubtitle">��13-1��</span></li>
            <li><input type="radio" name="q2_12_1" value="2" <%if(qa[12][1][2]!=null && qa[12][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> ��. 95% ~ 100% �̸� (������ ��� ������ ��ü����)</li>
            <li><input type="radio" name="q2_12_1" value="3" <%if(qa[12][1][3]!=null && qa[12][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> ��. 75% ~ 95% �̸�</li>
            <li><input type="radio" name="q2_12_1" value="4" <%if(qa[12][1][4]!=null && qa[12][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> ��. 50% ~ 75% �̸�</li>
            <li><input type="radio" name="q2_12_1" value="5" <%if(qa[12][1][5]!=null && qa[12][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> ��. 50% �̸�</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> �ͻ簡 ���Ƿ� �뿪 ��Ź�� ����ϰų� ������ ������ �����Դϱ�?</li>
                        <li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li><input type="checkbox" name="q2_12_2_1" value="1" <%if(qa[12][2][1]!=null && qa[12][2][1].equals("1")){out.print("checked");}%>></input> ��. ������ �Ǵ� �ŷ�ó�� �ֹ����</li>
            <li><input type="checkbox" name="q2_12_2_2" value="1" <%if(qa[12][2][2]!=null && qa[12][2][2].equals("1")){out.print("checked");}%>></input> ��. �Ǹź��� �Ǵ� ���� ���� ����</li>
            <li><input type="checkbox" name="q2_12_2_3" value="1" <%if(qa[12][2][3]!=null && qa[12][2][3].equals("1")){out.print("checked");}%>></input> ��. �������� Ư������� ����</li>
            <li><input type="checkbox" name="q2_12_2_4" value="1" <%if(qa[12][2][4]!=null && qa[12][2][4].equals("1")){out.print("checked");}%>></input> ��. ��Ź�� ���� ������ ���޻������ �ε��� ��������</li>
            <li><input type="checkbox" name="q2_12_2_5" value="1" <%if(qa[12][2][5]!=null && qa[12][2][5].equals("1")){out.print("checked");}%>></input> ��. ���޻������ ��������(���ֳ��� ���ؼ�)</li>
            <li><input type="checkbox" name="q2_12_2_6" value="1" <%if(qa[12][2][6]!=null && qa[12][2][6].equals("1")){out.print("checked");}%>></input> ��. ��Ÿ (<input type="text" name="q2_12_29" value="<%=qa[12][29][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha4">13. ������ ���ɿ� ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��13-1���� ��13-2�� ������ ���ɿ� ���� �����Դϴ�.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> �ͻ簡 <%= nCurrentYear-1%>�⵵�� �뿪 ��Ź�� ��ǰ�� ������ ������ ��� �˴ϱ�?</li>
            <li class="boxcontentsubtitle">* ���� ���� = 100*(������ �������Ǽ�/�뿪��Ź�� �������Ǽ�)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_13_1" value="<%=setHiddenValue(qa, 13, 1, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_13_1" value="1" <%if(qa[13][1][1]!=null && qa[13][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> ��. 100% (��ü����)<span class="boxcontentsubtitle">��14-1��</span></li>
            <li><input type="radio" name="q2_13_1" value="2" <%if(qa[13][1][2]!=null && qa[13][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> ��. 95% ~ 100% �̸� (������ ��� ������ ��ü����)</li>
            <li><input type="radio" name="q2_13_1" value="3" <%if(qa[13][1][3]!=null && qa[13][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> ��. 75% ~ 95% �̸�</li>
            <li><input type="radio" name="q2_13_1" value="4" <%if(qa[13][1][4]!=null && qa[13][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> ��. 50% ~ 75% �̸�</li>
            <li><input type="radio" name="q2_13_1" value="5" <%if(qa[13][1][5]!=null && qa[13][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"></input> ��. 50% �̸�</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> �ͻ簡 �뿪 ��Ź�� ��ǰ�� �������� ���� ������ �����Դϱ�? (�ش� �׸� ��� ����)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li><input type="checkbox" name="q2_13_2_1" value="1" <%if(qa[13][2][1]!=null && qa[13][2][1].equals("1")){out.print("checked");}%>></input> ��. �뿪 ��Ź�� �������� �ҷ�ǰ��</li>
            <li><input type="checkbox" name="q2_13_2_2" value="1" <%if(qa[13][2][2]!=null && qa[13][2][2].equals("1")){out.print("checked");}%>></input> ��. �ֹ������� �뿪�� ������� ����</li>
            <li><input type="checkbox" name="q2_13_2_3" value="1" <%if(qa[13][2][3]!=null && qa[13][2][3].equals("1")){out.print("checked");}%>></input> ��. ���޻������ å������ ��ǰ�� ������</li>
            <li><input type="checkbox" name="q2_13_2_4" value="1" <%if(qa[13][2][4]!=null && qa[13][2][4].equals("1")){out.print("checked");}%>></input> ��. ������(��)�� ���ֳ����� ���桤�����</li>
            <li><input type="checkbox" name="q2_13_2_5" value="1" <%if(qa[13][2][5]!=null && qa[13][2][5].equals("1")){out.print("checked");}%>></input> ��. ������(��)�� Ŭ������ �߻���</li>
            <li><input type="checkbox" name="q2_13_2_6" value="1" <%if(qa[13][2][6]!=null && qa[13][2][6].equals("1")){out.print("checked");}%>></input> ��. ���忡�� �ǸŽ����� ������</li>
            <li><input type="checkbox" name="q2_13_2_7" value="1" <%if(qa[13][2][7]!=null && qa[13][2][7].equals("1")){out.print("checked");}%>></input> ��. �������� Ư��������� �����</li>
            <li><input type="checkbox" name="q2_13_2_8" value="1" <%if(qa[13][2][8]!=null && qa[13][2][8].equals("1")){out.print("checked");}%>></input> ��. ��Ÿ (<input type="text" name="q2_13_29" value="<%=qa[13][29][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha5">14. ���ü�� ��, �ϵ��޴�� ���׿� ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��14-1���� ��14-2�� ���ü�� ��, �ϵ��޴�� ���׿� ���� �����Դϴ�.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> �ͻ簡 <%= nCurrentYear-1%>�⵵ ���� ����� �� ���ߴ� �ݾ״�� �ϵ��޴��(�ܰ�)�� ������ ������ ��� �˴ϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_14_1" value="<%=setHiddenValue(qa, 14, 1, 5)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_14_1" value="1" <%if(qa[14][1][1]!=null && qa[14][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> ��. 100% (��ü����)<span class="boxcontentsubtitle">��15-1��</span></li>
            <li><input type="radio" name="q2_14_1" value="2" <%if(qa[14][1][2]!=null && qa[14][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> ��. 95% ~ 100% �̸� (������ ��� ������ ��ü����)</li>
            <li><input type="radio" name="q2_14_1" value="3" <%if(qa[14][1][3]!=null && qa[14][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> ��. 75% ~ 95% �̸�</li>
            <li><input type="radio" name="q2_14_1" value="4" <%if(qa[14][1][4]!=null && qa[14][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> ��. 50% ~ 75% �̸�</li>
            <li><input type="radio" name="q2_14_1" value="5" <%if(qa[14][1][5]!=null && qa[14][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"></input> ��. 50% �̸�</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> �ͻ簡 ���� ����� �� ���ߴ� �ݾ׺��� �ϵ��޴��(�ܰ�)�� ���� ������ ������ �����Դϱ�?</li>
                        <li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li><input type="checkbox" name="q2_14_2_1" value="1" <%if(qa[14][2][1]!=null && qa[14][2][1].equals("1")){out.print("checked");}%>></input> ��. �뿪 ���� �������� ���ڰ� ������</li>
            <li><input type="checkbox" name="q2_14_2_2" value="1" <%if(qa[14][2][2]!=null && qa[14][2][2].equals("1")){out.print("checked");}%>></input> ��. �ֹ������� �뿪�� ������� ����</li>
            <li><input type="checkbox" name="q2_14_2_3" value="1" <%if(qa[14][2][3]!=null && qa[14][2][3].equals("1")){out.print("checked");}%>></input> ��. ������ �Ǵ� �ŷ�ó�� �ֹ��� �����</li>
            <li><input type="checkbox" name="q2_14_2_4" value="1" <%if(qa[14][2][4]!=null && qa[14][2][4].equals("1")){out.print("checked");}%>></input> ��. �ͻ��� �����϶��� ���� ����д�</li>
            <li><input type="checkbox" name="q2_14_2_5" value="1" <%if(qa[14][2][5]!=null && qa[14][2][5].equals("1")){out.print("checked");}%>></input> ��. ������Ǹ��������� ���� ������ �ݿ���</li>
            <li><input type="checkbox" name="q2_14_2_6" value="1" <%if(qa[14][2][6]!=null && qa[14][2][6].equals("1")){out.print("checked");}%>></input> ��. �ͻ��� �������ָ� �ݿ���</li>
            <li><input type="checkbox" name="q2_14_2_7" value="1" <%if(qa[14][2][7]!=null && qa[14][2][7].equals("1")){out.print("checked");}%>></input> ��. �ͻ��� �ڱݻ����� �����</li>
            <li><input type="checkbox" name="q2_14_2_8" value="1" <%if(qa[14][2][8]!=null && qa[14][2][8].equals("1")){out.print("checked");}%>></input> ��. �ͻ簡 ȯ���������� ���� ���ظ� �ݿ���</li>
            <li><input type="checkbox" name="q2_14_2_9" value="1" <%if(qa[14][2][9]!=null && qa[14][2][9].equals("1")){out.print("checked");}%>></input> ��. ����� ������ �϶��� �ݿ���</li>
            <li><input type="checkbox" name="q2_14_2_10" value="1" <%if(qa[14][2][10]!=null && qa[14][2][10].equals("1")){out.print("checked");}%>></input> ��. �������� �ǸŰ��� �϶��� �ݿ���</li>
            <li><input type="checkbox" name="q2_14_2_11" value="1" <%if(qa[14][2][11]!=null && qa[14][2][11].equals("1")){out.print("checked");}%>></input> ī. ��Ÿ (<input type="text" name="q2_14_29" value="<%=qa[14][29][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha6">15. �ϵ��޴�� ���޿� ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��15-1���� ��15-4�� �ϵ��޴�� ���޿� ���� �����Դϴ�.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> <%= nCurrentYear-1%>�⵵ ���޻���ڿ��� ������ �ϵ��޴���� ���޼��ܺ� ������ ��� �˴ϱ�? �ͻ簡 �ŷ��� ���޻���ڸ� �߼ұ���ΰ� �߰߱�������� �и��� ������ �ֽʽÿ�.</li>
            <li class="boxcontentsubtitle">* �߰߱���� �߰߱���� ��2����1ȣ�� ������ �ش��ϴ� ȸ����</li>
            <li class="boxcontentsubtitle">* �߼ұ���� �߼ұ���⺻�� ��2���� ������ �ش��ϴ� ȸ����</li>
            <li class="boxcontentsubtitle">&nbsp;</li>
            <li class="boxcontentsubtitle">* ������ü ��������(���� 1�� ����) : �����������ī��, �ܻ����ä�Ǵ㺸����, ���ŷ� �� ��ȯû������ ���� ���� ����</li>
            <li class="boxcontentsubtitle">* ���� : �������� ���� �ǹ�����(���̾���) �̿ܿ� "���ھ����� ���� �� ���뿡 ���� ����"�� ���� ����� ���ھ����� �����Ͽ� �ۼ�</li>
            <li class="boxcontentsubtitle">* ��Ÿ : �빰���� �� �ٸ� �������� ������ ��� ����</li>
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
                    <th>����</th>
                    <th>���޻���ڰ� �߼ұ���� ���</th>
                    <th>���޻���ڰ� �߰߱���� ���</th>
                  </tr>
                  <tr>
                    <th>����(��ǥ ����)</th>
                    <td><input type="text" name="q2_15_11" value="<%=qa[15][11][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_21" value="<%=qa[15][21][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>�ܻ����ä�� �㺸����(���� 1�� ����, ��ȯû���� ��)</th>
                    <td><input type="text" name="q2_15_12" value="<%=qa[15][12][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_22" value="<%=qa[15][22][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>�����������ī��(���� 1�� ����)</th>
                    <td><input type="text" name="q2_15_13" value="<%=qa[15][13][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_23" value="<%=qa[15][23][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>���ŷ�(���� 1�� ����)</th>
                    <td><input type="text" name="q2_15_14" value="<%=qa[15][14][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_24" value="<%=qa[15][24][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>������� �ý���(���� 1�� ����)</th>
                    <td><input type="text" name="q2_15_15" value="<%=qa[15][15][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_25" value="<%=qa[15][25][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>�� ������ü��������(��, ���� 1�� �ʰ�)</th>
                    <td><input type="text" name="q2_15_16" value="<%=qa[15][16][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_26" value="<%=qa[15][26][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>����(���� 60�� ����)</th>
                    <td><input type="text" name="q2_15_17" value="<%=qa[15][17][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_27" value="<%=qa[15][27][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>����(�ϵ��� �ŷ� ����. ���� 61��~120��)</th>
                    <td><input type="text" name="q2_15_18" value="<%=qa[15][18][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_28" value="<%=qa[15][28][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>����(�ϵ��� �ŷ� ����. ���� 121�� �ʰ�)</th>
                    <td><input type="text" name="q2_15_19" value="<%=qa[15][19][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_29" value="<%=qa[15][29][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>��Ÿ</th>
                    <td><input type="text" name="q2_15_20" value="<%=qa[15][20][20]%>" onKeyUp="sukeyup(this); fn_hap15_1(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_30" value="<%=qa[15][30][20]%>" onKeyUp="sukeyup(this); fn_hap15_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>�հ�</th>
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
            <li class="boxcontenttitle"><span>(2) </span> �ͻ簡 �ϵ��� ����� �����Կ� �־� ������ �����Ϸκ��� 60���� �ʰ��Ͽ� ������ ������ ��� �˴ϱ�?</li>
            <li class="boxcontentsubtitle">* ������ �������� ��� ���ġ����������� ������ �Ǵ� ���� ���� �Ϸ����� �������� ��.</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_15_2" value="<%=setHiddenValue(qa, 15, 2, 4)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_15_2" value="1" <%if(qa[15][2][1]!=null && qa[15][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(15,2);"></input> ��. ����<span class="boxcontentsubtitle">��16-1��</span></li>
            <li><input type="radio" name="q2_15_2" value="2" <%if(qa[15][2][2]!=null && qa[15][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(15,2);"></input> ��. 30% �̸�</li>
            <li><input type="radio" name="q2_15_2" value="3" <%if(qa[15][2][3]!=null && qa[15][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(15,2);"></input> ��. 30% ~ 50% �̸�</li>
            <li><input type="radio" name="q2_15_2" value="4" <%if(qa[15][2][4]!=null && qa[15][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(15,2);"></input> ��. 50% �̻�</li>
          </ul>
          <div class="fc pt_10"></div>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(3) </span> 60���� �ʰ��Ͽ� �ϵ��޴���� ������ ��찡 �ִٸ�, �� ����� ���޼��ܺ� ������ ��� �˴ϱ�? �ͻ簡 �ŷ��� ���޻���ڸ� �߼ұ���ΰ� �߰߱�������� �и��� ������ �ֽʽÿ�.</li>
            <li class="boxcontentsubtitle">* �߰߱���� �߰߱���� ��2����1ȣ�� ������ �ش��ϴ� ȸ����</li>
            <li class="boxcontentsubtitle">* �߼ұ���� �߼ұ���⺻�� ��2���� ������ �ش��ϴ� ȸ����</li>
            <li class="boxcontentsubtitle">&nbsp;</li>
                        <li class="boxcontentsubtitle">* ���� : �������� ���� �ǹ�����(���̾���) �̿ܿ� "���ھ����� ���� �� ���뿡 ���� ����"�� ���� ����� ���ھ����� �����Ͽ� �ۼ�</li>
            <li class="boxcontentsubtitle">* ������ü �������� : �����������ī��, �ܻ����ä�Ǵ㺸����, ���ŷ� �� ��ȯû������ ���� ���� ����</li>
            <li class="boxcontentsubtitle">* ��Ÿ : �빰���� �� �ٸ� �������� ������ ��� ����</li>
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
                    <th>����</th>
                    <th>���޻���ڰ� �߼ұ���� ���</th>
                    <th>���޻���ڰ� �߰߱���� ���</th>
                  </tr>
                  <tr>
                    <th>����(��ǥ ����)</th>
                    <td><input type="text" name="q2_15_31" value="<%=qa[15][31][20]%>" onKeyUp="sukeyup(this); fn_hap15_3(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_41" value="<%=qa[15][41][20]%>" onKeyUp="sukeyup(this); fn_hap15_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>������ü ��������</th>
                    <td><input type="text" name="q2_15_32" value="<%=qa[15][32][20]%>" onKeyUp="sukeyup(this); fn_hap15_3(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_42" value="<%=qa[15][42][20]%>" onKeyUp="sukeyup(this); fn_hap15_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>����</th>
                    <td><input type="text" name="q2_15_33" value="<%=qa[15][33][20]%>" onKeyUp="sukeyup(this); fn_hap15_3(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_43" value="<%=qa[15][43][20]%>" onKeyUp="sukeyup(this); fn_hap15_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>��Ÿ</th>
                    <td><input type="text" name="q2_15_34" value="<%=qa[15][34][20]%>" onKeyUp="sukeyup(this); fn_hap15_3(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                    <td><input type="text" name="q2_15_44" value="<%=qa[15][44][20]%>" onKeyUp="sukeyup(this); fn_hap15_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
                  </tr>
                  <tr>
                    <th>�հ�</th>
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
            <li class="boxcontenttitle"><span>(4) </span> 60���� �ʰ��Ͽ� �ϵ��޴���� ������ ���, �������ڡ��������ηᡤ������� ���������� ���� �����Ͽ����ϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_15_4" value="<%=setHiddenValue(qa, 15, 4, 3)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_15_4" value="1" <%if(qa[15][4][1]!=null && qa[15][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(15,4);"></input> ��. ���� ����</li>
            <li><input type="radio" name="q2_15_4" value="2" <%if(qa[15][4][2]!=null && qa[15][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(15,4);"></input> ��. �Ϻ� ����(�Ϻ� ������)</li>
            <li><input type="radio" name="q2_15_4" value="3" <%if(qa[15][4][3]!=null && qa[15][4][3].equals("1")){out.print("checked");}%> onclick="checkradio(15,4);"></input> ��. ���� ������</li>
          </ul>
          <div class="fc pt_30"></div>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha7">16. ���޿���(����, �빫��, ��� ��) ������ ���� �ϵ��޴�� ���� ��û�� ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��16-1���� ��16-3�� ���޿���(����, �빫��, ��� ��) ������ ���� �ϵ��޴�� ���� ��û�� ���� �����Դϴ�.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> <%= nCurrentYear-1%>�⵵�� ���޿��� ����� ������ �ͻ翡�� �ϵ��޴�� ������ ���� ��û�� ���޻���ڳ� �߼ұ������������ ���� ��û�� ���޻���ڰ� �ֽ��ϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_16_1" value="<%=setHiddenValue(qa, 16, 1, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_16_1" value="1" <%if(qa[16][1][1]!=null && qa[16][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> ��. �ִ�<span class="boxcontentsubtitle">��16-2��</span></li>
            <li><input type="radio" name="q2_16_1" value="2" <%if(qa[16][1][2]!=null && qa[16][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> ��. ����<span class="boxcontentsubtitle">��17��</span></li>
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
            <li class="boxcontenttitle"><span>(2) </span> �ϵ��޴�� ���� ��û�� �� ���޻���� ���� ��û�� ���� ������ 10�� �̳��� ���Ǹ� ������ ��ü�� �� �����Դϱ�?</li>
            <li class="boxcontentsubtitle">* ���� ���޻���ڰ� �ϵ��޴�� ���� ��û(A)�� �� �� �߼ұ�� ���������� ���Ͽ� ��� ������ ���û(B)�� ����, ����(B)�� ������û �Ǽ��θ� ���</li>
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
                    <th>����</th>
                    <th>���޻���� ��</th>
                    <th>10�� �̳� ���Ǹ� ������ ��ü ��</th>
                  </tr>
                  <tr>
                    <th>���� �ϵ��޴�� ������û</th>
                    <td>
                      <input type="text" name="q2_16_11" value="<%=qa[16][11][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ����
                    </td>
                    <td>
                      <input type="text" name="q2_16_12" value="<%=qa[16][12][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ����
                    </td>
                  </tr>
                  <tr>
                    <th>�߼ұ������������ ���� ������û</th>
                    <td>
                      <input type="text" name="q2_16_13" value="<%=qa[16][13][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ����
                    </td>
                    <td>
                      <input type="text" name="q2_16_14" value="<%=qa[16][14][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ����
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
            <li class="boxcontenttitle"><span>(3) </span> �ͻ簡 <%= nCurrentYear-1%>�⵵�� ���޻���� �Ǵ� �߼ұ������������ �ϵ��޴�� �λ� ��û�� ���� ��쿡 ���Ͽ�, ��û������ <u>�Ϻ� �Ǵ� ��������</u> ������ ������ ��� �˴ϱ�? ��ü���� �������� �����Ͽ� �ֽʽÿ�.</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_16_3" value="<%=setHiddenValue(qa, 16, 3, 6)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_16_3" value="1" <%if(qa[16][3][1]!=null && qa[16][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> ��. 100% (��ü ����)</li>
            <li><input type="radio" name="q2_16_3" value="2" <%if(qa[16][3][2]!=null && qa[16][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> ��. 75% ~ 100% �̸�</li>
            <li><input type="radio" name="q2_16_3" value="3" <%if(qa[16][3][3]!=null && qa[16][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> ��. 50% ~ 75% �̸�</li>
            <li><input type="radio" name="q2_16_3" value="4" <%if(qa[16][3][4]!=null && qa[16][3][4].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> ��. 25% ~ 50% �̸�</li>
            <li><input type="radio" name="q2_16_3" value="5" <%if(qa[16][3][5]!=null && qa[16][3][5].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> ��. 25% �̸�</li>
            <li><input type="radio" name="q2_16_3" value="6" <%if(qa[16][3][6]!=null && qa[16][3][6].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> ��. 0% (��ü �̼���)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha8">17. ���°��迡 ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��17�� ���޻���ڿ��� ���°��迡 ���� �����Դϴ�.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> <%= nCurrentYear-1%>�⵵�� ���޻���ڿ��� ���°��� ������ ���� ������ ������ ���� �Ǵ� �������� �����Ͽ��ٸ�, �ͻ簡 ������ ���޻���ڴ� �� ���� �Դϱ�?</li>
            <li class="boxcontentsubtitle">* �ͻ簡 A���޻���ڿ��� �ڱ�, ����, �η� ������ ��� �����Ͽ��ٸ� �ش� ���� �ι��� ��ü �� ��꿡 ���� ����.</li>
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
                    <th>����</th>
                    <th>��ü ��</th>
                  </tr>
                  <tr>
                    <th>�ڱ�(���ڡ�����) ����</th>
                    <td><input type="text" name="q2_17_1" value="<%=qa[17][1][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ����</td>
                  </tr>
                  <tr>
                    <th>����(����ᡤ����) ����</th>
                    <td><input type="text" name="q2_17_2" value="<%=qa[17][2][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ����</td>
                  </tr>
                  <tr>
                    <th>�η�(����) ����</th>
                    <td><input type="text" name="q2_17_3" value="<%=qa[17][3][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ����</td>
                  </tr>
                  <tr>
                    <th>���(����) ����</th>
                    <td><input type="text" name="q2_17_4" value="<%=qa[17][4][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ����</td>
                  </tr>
                  <tr>
                    <th>�濵(�����á�����ȭ) ����</th>
                    <td><input type="text" name="q2_17_5" value="<%=qa[17][5][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ����</td>
                  </tr>
                  <tr>
                    <th>�Ƿ�(����������) ����</th>
                    <td><input type="text" name="q2_17_6" value="<%=qa[17][6][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ����</td>
                  </tr>
                  <tr>
                    <th>��Ÿ ����</th>
                    <td><input type="text" name="q2_17_7" value="<%=qa[17][7][20]%>" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ����</td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <h2 class="contenttitle">�ϵ��ްŷ� ���λ��� 2 : Ư�ࡤ����ڷ�</h2>
      
      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha9">18. Ư�࿡ ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��18-1���� ��18-2�� Ư�࿡ ���� �����Դϴ�.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> �ͻ�� <%= nCurrentYear-1%>�⵵�� ���޻���ڿ� �ϵ��ް���� ü���ϸ鼭 ��༭ � Ư�� ������ �����Ͽ� �ۼ��� ���� �ֽ��ϱ�?</li>
            <li class="boxcontentsubtitle">* Ư���� �ϵ��� �� ��༭ ���� �ܿ� Ŭ���� ������ �� ���� �Ǹ����ǹ� ���踦 ������ ���� ���� ����</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_18_1" value="<%=setHiddenValue(qa, 18, 1, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_18_1" value="1" <%if(qa[18][1][1]!=null && qa[18][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"></input> ��. �ִ�</li>
            <li><input type="radio" name="q2_18_1" value="2" <%if(qa[18][1][2]!=null && qa[18][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"></input> ��. ����<span class="boxcontentsubtitle">��19-��</span></li>
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
            <li class="boxcontenttitle"><span>(2) </span> �ͻ簡 ���޻���ڿ� ü���� �ϵ��ް�༭ � Ư�೻���� ������ ������ �����Դϱ�?</li>
            <li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li><input type="checkbox" name="q2_18_2_1" value="1" <%if(qa[18][2][1]!=null && qa[18][2][1].equals("1")){out.print("checked");}%>></input> ��. �������� ������ �� ���� �������� ���� ����� ���޻���ڿ� �д��ϱ� ����</li>
            <li><input type="checkbox" name="q2_18_2_2" value="1" <%if(qa[18][2][2]!=null && qa[18][2][2].equals("1")){out.print("checked");}%>></input> ��. �ο�ó��, �Ρ��㰡, ȯ�����, ǰ������ � ���� ����� ���޻���ڿ� �д��ϱ� ����</li>
            <li><input type="checkbox" name="q2_18_2_3" value="1" <%if(qa[18][2][3]!=null && qa[18][2][3].equals("1")){out.print("checked");}%>></input> ��. ���� �� �۾����� �������� �߻��� ����� ���޻���ڿ� �д��ϱ� ����</li>
            <li><input type="checkbox" name="q2_18_2_4" value="1" <%if(qa[18][2][4]!=null && qa[18][2][4].equals("1")){out.print("checked");}%>></input> ��. ���ڴ㺸å�� �Ǵ� ���ع��å�� ���࿡ ���� ����� ���޻���ڿ� �д��ϱ� ����</li>
            <li><input type="checkbox" name="q2_18_2_5" value="1" <%if(qa[18][2][5]!=null && qa[18][2][5].equals("1")){out.print("checked");}%>></input> ��. ��Ÿ (<input type="text" name="q2_18_29" value="<%=qa[18][29][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha10">19. ��� �ڷ� ���� �䱸�� ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��19-1���� ��19-7�� ����ڷ� ���� �䱸�� ���� �����Դϴ�.</li>          
        </ul>
      </div>
      
      <div class="boxcontent2">
        <ul class="boxcontenthelp lt">
          <li class="boxcontenttitle">"����ڷ�"�� ���޻������ ����� ��¿� ���Ͽ� ������� ���� ��з� �����ǰ� �ִ� ����� �Ǵ� �濵���� �����μ� �Ʒ� �׸� �� �ϳ��� �ش��ϴ� �������ڷḦ ����.</li>
          <li class="boxcontenttitle">&nbsp;</li>
          <li class="boxcontenttitle">��. �������������ð� �Ǵ� �뿪���� ����� ���� �������ڷ�.</li>
          <li class="boxcontenttitle">��. Ư���, �ǿ�žȱ�, �����α�, ���۱� ���� �������ǰ� ���õ� ����������ڷ�μ� ���޻������ �������(R&D)�����ꡤ����Ȱ���� �����ϰ� ������ ������ ��ġ�� �ִ� ��.</li>
          <li class="boxcontenttitle">��. �ð����μ��� �Ŵ���, ��� ����, ���赵��, ���� ���� ������, ���� ���� �� ���� �Ǵ� ���� ���Ե��� �ʴ� ��Ÿ ������� ����� �Ǵ� �濵���� �������ڷ�μ� ���޻������ �������(R&D)�����ꡤ����Ȱ���� �����ϰ� ������ ������ ��ġ�� �ִ� ��.</li>
        </ul>
      </div>

      <div class="fc pt_10"></div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> �ͻ��  <%= nCurrentYear-1%>�⵵�� ���޻���ڿ��� ��� �ڷḦ �䱸�� ���� �ֽ��ϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_19_1" value="<%=setHiddenValue(qa, 19, 1, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_19_1" value="1" <%if(qa[19][1][1]!=null && qa[19][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);"></input> ��. �ִ�<span class="boxcontentsubtitle">��19-2��</span></li>
            <li><input type="radio" name="q2_19_1" value="2" <%if(qa[19][1][2]!=null && qa[19][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);"></input> ��. ����<span class="boxcontentsubtitle">��20-1��</span></li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> �ͻ簡 ���޻���ڿ��� ��� �ڷḦ �䱸�� ������ �����Դϱ�?</li>
            <li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li><input type="checkbox" name="q2_19_2_1" value="1" <%if(qa[19][2][1]!=null && qa[19][2][1].equals("1")){out.print("checked");}%>></input> ��. ���� Ư�� ����</li>
            <li><input type="checkbox" name="q2_19_2_2" value="1" <%if(qa[19][2][2]!=null && qa[19][2][2].equals("1")){out.print("checked");}%>></input> ��. ���� ������� ���� ü��</li>
            <li><input type="checkbox" name="q2_19_2_3" value="1" <%if(qa[19][2][3]!=null && qa[19][2][3].equals("1")){out.print("checked");}%>></input> ��. ��ǰ ������ ���αԸ�</li>
            <li><input type="checkbox" name="q2_19_2_4" value="1" <%if(qa[19][2][4]!=null && qa[19][2][4].equals("1")){out.print("checked");}%>></input> ��. ��Ÿ (<input type="text" name="q2_19_11" value="<%=qa[19][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(3) </span> �ͻ�� ���޻���ڷκ��� ����� ��� �ڷḦ ��� Ȱ���Ͽ����ϱ�?</li>
            <li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li><input type="checkbox" name="q2_19_3_1" value="1" <%if(qa[19][3][1]!=null && qa[19][3][1].equals("1")){out.print("checked");}%>></input> ��. ����Ư��, ���� ������� ���� ü��, ��ǰ������ ���αԸ� �����Ͽ� ���</li>
            <li><input type="checkbox" name="q2_19_3_2" value="1" <%if(qa[19][3][2]!=null && qa[19][3][2].equals("1")){out.print("checked");}%>></input> ��. ����Ư��, ���� ������� ���� ü��, ��ǰ������ ���αԸ� �̿� �������� �ͻ縦 ���� ���</li>
            <li><input type="checkbox" name="q2_19_3_3" value="1" <%if(qa[19][3][3]!=null && qa[19][3][3].equals("1")){out.print("checked");}%>></input> ��. ����Ư��, ���� ������� ���� ü��, ��ǰ������ ���αԸ� �̿� �������� ��3�ڸ� ���� ���</li>
            <li><input type="checkbox" name="q2_19_3_4" value="1" <%if(qa[19][3][4]!=null && qa[19][3][4].equals("1")){out.print("checked");}%>></input> ��. ����Ư��, ���� ������� ���� ü��, ��ǰ������ ���αԸ� �̿� �������� ��3�ڿ��� ����</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(4) </span> �ͻ��  <%= nCurrentYear-1%>�⵵�� ���޻���ڿ��� ��� �ڷḦ �������� �䱸�� ���� �ֽ��ϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_19_4" value="<%=setHiddenValue(qa, 19, 4, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_19_4" value="1" <%if(qa[19][4][1]!=null && qa[19][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,4);"></input> ��. �ִ�(<input type="text" name="q2_19_12" value="<%=qa[19][12][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>��)<span class="boxcontentsubtitle">��19-5��</span></li>
            <li><input type="radio" name="q2_19_4" value="2" <%if(qa[19][4][2]!=null && qa[19][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,4);"></input> ��. ����<span class="boxcontentsubtitle">��19-6����</span></li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(5) </span> �ͻ簡 ����ڷ� �䱸 �� ����� �����ڷ� ����� �����Դϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_19_5" value="<%=setHiddenValue(qa, 19, 5, 3)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_19_5" value="1" <%if(qa[19][5][1]!=null && qa[19][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,5);"></input> ��. ��ü���</li>
            <li><input type="radio" name="q2_19_5" value="2" <%if(qa[19][5][2]!=null && qa[19][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,5);"></input> ��. ����ڷ� �䱸��(������ ���� ��263ȣ ����1)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(6) </span> �ͻ��  <%= nCurrentYear-1%>�⵵�� ���޻���ڿ��� ��� �ڷḦ ���η� �䱸�� ���� �ֽ��ϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_19_6" value="<%=setHiddenValue(qa, 19, 6, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_19_6" value="1" <%if(qa[19][6][1]!=null && qa[19][6][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,6);"></input> ��. �ִ�(<input type="text" name="q2_19_13" value="<%=qa[19][13][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>��)<span class="boxcontentsubtitle">��19-7��</span></li>
            <li><input type="radio" name="q2_19_6" value="2" <%if(qa[19][6][2]!=null && qa[19][6][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,6);"></input> ��. ����<span class="boxcontentsubtitle">��20-1��</span></li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(7) </span> �ͻ簡 ��� �ڷḦ ���η� �䱸�� �ֵ� ������ �����Դϱ�?</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_19_7" value="<%=setHiddenValue(qa, 19, 7, 4)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_19_7" value="1" <%if(qa[19][7][1]!=null && qa[19][7][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,7);"></input> ��. ����߱� �ǹ��� ���� ���ؼ�</li>
            <li><input type="radio" name="q2_19_7" value="2" <%if(qa[19][7][2]!=null && qa[19][7][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,7);"></input> ��. ����߱��� �ʿ��� �������� �Һи��ؼ�</li>
            <li><input type="radio" name="q2_19_7" value="3" <%if(qa[19][7][3]!=null && qa[19][7][3].equals("1")){out.print("checked");}%> onclick="checkradio(19,7);"></input> ��. ��� �ڷ� ��û �Ǽ��� �ʹ� ���Ƽ�</li>
            <li><input type="radio" name="q2_19_7" value="4" <%if(qa[19][7][4]!=null && qa[19][7][4].equals("1")){out.print("checked");}%> onclick="checkradio(19,7);"></input> ��. ���������� ���� �䱸�� ó���ؼ�</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      
      
      <h2 class="contenttitle">�ϵ��ްŷ� ���λ��� 3 : ���Ӱŷ���PB�ŷ�</h2>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha11">20. ���Ӱŷ��� ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��20-1���� ��20-3�� ���Ӱŷ��� ���� �����Դϴ�.</li>          
        </ul>
      </div>

      <div class="fc pt_2"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> �ͻ�� <%= nCurrentYear-1%>�⿡ ���޻���ڿ� �ϵ��� ���Ӱŷ��� ���� ���� �ֽ��ϱ�?</li>
            <li class="boxcontentsubtitle">* ���Ӱŷ��� ���޻���ڷ� �Ͽ��� ��������� '�ڱ�' �Ǵ� '�ڱⰡ �����ϴ� �����'�͸� �ŷ��ϵ��� �ϴ� ���� �ǹ���.</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="c2_20_1" value="<%=setHiddenValue(qa, 20, 1, 2)%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q2_20_1" value="1" <%if(qa[20][1][1]!=null && qa[20][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"></input> ��. �ִ�</li>
            <li><input type="radio" name="q2_20_1" value="2" <%if(qa[20][1][2]!=null && qa[20][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"></input> ��. ����<span class="boxcontentsubtitle">��21-1��</span></li>
          </ul>
          <div class="fc pt_50"></div>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(2) </span> <%= nCurrentYear-1%>�⵵ ��ü �ϵ��ްŷ����� ���޻���ڿ� ���Ӱŷ��� ���� ��ü �� ����, ���� ����, ���ӱⰣ�� ��� �˴ϱ�?</li>
            <li class="boxcontentsubtitle">(�ش���� ��� üũ)</li>
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
                    <th>����</th>
                    <th>����</th>
                  </tr>
                  <tr>
                    <th>��ü ���޻���� �� ���Ӱŷ� ��ü �� ����</th>
                    <td><input type="text" name="q2_20_21" value="<%=qa[20][21][20]%>" onKeyUp="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>��ü ���űݾ� �� ���Ӱŷ��κ��� ���� ����</th>
                    <td><input type="text" name="q2_20_22" value="<%=qa[20][22][20]%>" onKeyUp="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> %</td>
                  </tr>
                  <tr>
                    <th>���Ӱŷ� ��� �Ⱓ</th>
                    <td><input type="text" name="q2_20_23" value="<%=qa[20][23][20]%>" onKeyUp="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ����</td>
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
            <li class="boxcontenttitle"><span>(3) </span> �ͻ簡 ���Ӱŷ��� ���� ����ϴ� �ٰ� �������� ��� �����ϰ� ������ ��밡 ��� ���� �����ǰ� �ִ��� ���� �ֽʽÿ�.</li>
            <li class="boxcontentsubtitle">(�ش���� ��� üũ)</li>
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
                    <th>�׸�</th>
                    <th>���� ���� �ȵ�</th>
                    <th>���� ���� �ȵ�</th>
                    <th>����</th>
                    <th>�ణ ����</th>
                    <th>�ſ� ����</th>
                  </tr>
                  <tr>
                    <th style="text-align: left;"><input type="checkbox" name="q2_20_3_1" value="1" <%if(qa[20][3][1]!=null && qa[20][3][1].equals("1")){out.print("checked");}%>></input>1) ǰ�� ����</th>
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
                    <th style="text-align: left;"><input type="checkbox" name="q2_20_3_2" value="1" <%if(qa[20][3][2]!=null && qa[20][3][2].equals("1")){out.print("checked");}%>></input>2) ���� ����� ����</th>
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
                    <th style="text-align: left;"><input type="checkbox" name="q2_20_3_3" value="1" <%if(qa[20][3][3]!=null && qa[20][3][3].equals("1")){out.print("checked");}%>></input>3) ������� ����</th>
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
                    <th style="text-align: left;"><input type="checkbox" name="q2_20_3_4" value="1" <%if(qa[20][3][4]!=null && qa[20][3][4].equals("1")){out.print("checked");}%>></input>4) ������ ���� ����</th>
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
                    <th style="text-align: left;"><input type="checkbox" name="q2_20_3_5" value="1" <%if(qa[20][3][5]!=null && qa[20][3][5].equals("1")){out.print("checked");}%>></input>5) ��Ÿ(<input type="text" name="q2_20_39" value="<%=qa[20][39][20]%>" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>)</th>
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
      
      <h2 class="contenttitle">���� ���Ե� ������ ���� ������ �� ����</h2>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"><a name="mokcha12">21. ������ ���Ͽ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
        </ul>
      </div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="elt">
            <li class="boxcontenttitle"><span>(1) </span> ������ �����ŷ�����ȸ���� �Ұ����� �ϵ��ްŷ� ������ �����ϱ� ���� �ϵ��޹��� �����Ͽ� ��ϰ� �ִ� �����Դϴ�. �Ʒ� �� ������ ���� �ͻ��� ���� ������ &lt;����&gt;�� �����Ͽ� ������ �ֽñ� �ٶ��ϴ�.</li>
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
                            <th>�׸�</th>
                            <th>�� �� ����</th>
                            <th>�� ���� ������ ������ ���� ��</th>
                            <th>������ �뷫������ �˰� ����</th>
                            <th>������ ��ü������ �˰� ����</th>
                            <th>������ �Ϻ��� �˰� ����</th>
                          </tr>
                          <tr>
                            <th style="text-align: left;">1) 3�� ���ع���� ������ Ȯ��</th>
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
                            <th style="text-align: left;">2) �δ�Ư�� ����</th>
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
                            <th style="text-align: left;">3) �ϵ��޴�� ���޺��� ���� ����</th>
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
                            <th style="text-align: left;">4) �߼ұ���������տ� ��ǰ�ܰ��������Ǳ��� �ο�</th>
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
                            <th style="text-align: left;">5) ���簳�� �� ������ ���� �������� �� ���� ����</th>
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
                            <th style="text-align: left;">6) �߰߱���� ���޻���� ��ȣ��� ����</th>
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
                            <th style="text-align: left;">7) �Ű������ ����</th>
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
                            <th style="text-align: left;">8) ���簳�� �� ��� ������ �������� �� ���� �ΰ� ����</th>
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
                            <th style="text-align: left;">9) �ܼ���� ���⵵ ���������� ����</th>
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
                            <th style="text-align: left;">10) ���Ż�� ������ ���� �����ȿ�� 3�⿡�� 7������ ����</th>
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
                            <th style="text-align: left;">11) �濵���� �䱸 ����, Ư�� ����ڿ� �ŷ����� ����, ��� ���� ���� ���� ����</th>
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
              <th rowspan="2">����</th>
              <th>1</th>
              <th>2</th>
              <th>3</th>
              <th>4</th>
              <th>5</th>
            </tr>
            <tr>
              <th>�� �� ����</th>
              <th>�� ���� ������ ������ ���� ��</th>
              <th>������ �뷫������ �˰� ����</th>
              <th>������ ��ü������ �˰� ����</th>
              <th>������ �Ϻ��� �˰� ����</th>
            </tr>
          </tbody>
        </table>
      </div>
      
      <div class="fc pt_10"></div>
      
         <div class="boxcontent2">
            <ul class="boxcontenthelp lt">
              <li class="boxcontenttitle">1) 3�� ���ع�� ���� : <span style="font-size:12px;font-weight:400">��������� �������, �δ��� �ϵ��޴�� ����������, �δ� ��Ź��� �� �δ��ǰ �������� ���������� �߰��� ���������<br/> Ȯ�� �Ǿ����� ���ظ� ���� ���޻���ڰ� ������ ���� ��� û���� �Ͽ� ���ؾ��� 3����� ����� ���� �� �ִ� ����</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">2) �δ�Ư�� ���� :<span style="font-size:12px;font-weight:400">������ڰ� ���޻������ ������ �δ��ϰ� ħ���ϰų� �����ϴ� ��������� �������� ���ϵ��� �ϴ� ����</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">3) �ϵ��޴�� ���޺��� ���� : <span style="font-size:12px;font-weight:400">������ڰ� ���޻���ڿ��� �ϵ��ް���� ü���Ϸκ��� 30�� �̳��� �ϵ��޴�� ���޺����� �ϵ��� ���� ����ϰ�,<br/>������ڰ� �ϵ��޴�� ���� ������ ���� ���� ��� ���޻���ڷκ��� �����޴� ������ຸ���� û���� �� ����</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">4) �߼ұ����<span style="font-size:12px;font-weight:400">�����տ� ��ǰ�ܰ��������Ǳ��� �ο� : ���޿���(����, �빫��, ��� ��)�� �ް��� �������� �ϵ��޴���� ������ �ʿ��� ���<br/>���޻���ڴ� ������ڿ��� �ϵ��޴���� ������ ��û�ϰų�, �߼ұ������������ �Ҽ� ���տ��� ���޻������ ��û�� �޾� ������ڿ�<br/>�ϵ��޴���� ������ ������ �� �ְ�, ������ڴ� ������ ���� ���� �� ���Ǹ� �ź��� �� ���� 10�� �ȿ� ���Ǹ� �����ϵ��� �ϴ� ����</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">5) ���簳�� �� ������ ���� �������� �� ���� ���� : <span style="font-size:12px;font-weight:400">����ڰ� �ڽ��� ������ ������ ������ ���� �� ������ �����ϰ� ���޻���ڵ鿡�� ���ر��� ��ġ���� �Ϸ��� ��쿡�� �ϵ��޹��� ��� ������ġ�� �����ϴ� ������ �����Ͽ� ����</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">6) �߰߱���� ���޻���� ��ȣ��� ���� : <span style="font-size:12px;font-weight:400">�� ��ȣ�������� ������� �Ҽ� ȸ�簡 ����� 3,000�� �� �̸��� �߰߱������ ��Ź�� �ְų�,<br/>�� �������� ������� 2�� ���� �ʰ��ϴ� ��Ը� �߰߱���� �������� ������� ������ �߼ұ�� �Ը� ���� ���Ѿ��� 2�迡 �ش��ϴ� 800�� �� ~ 3,000�� �� �̸��� �ұԸ� �߰߱������ ��Ź�� �ִ� ��� �ϵ��޹� ���� ������� �����Ͽ� ��� ���޿� �־� ���޻���ڰ� ��ȣ�� ���� �� ����</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">7) �Ű������ ���� : <span style="font-size:12px;font-weight:400">�δ� �ܰ� ����, �δ� ���� ���, �δ� ��ǰ������ �ź� �� ��� ���� ������ �Ű��� �ڿ��� ������� �����ϴ� ����</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">8) ���簳�� �� ��� ������ �������� �� ���� �ΰ� ���� : <span style="font-size:12px;font-weight:400">����ڰ� ��� �����޿� ���� ������ ���簳�� �� 30�� �̳��� ���������� ����ϵ��޹���<br/>���� �ΰ���ġ�� �����ϴ� ����</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">9) �ܼ���� ���⵵ ���������� ���� :<span style="font-size:12px;font-weight:400"> ������ڰ� ����� ���޻������ ����ڷῡ ���Ͽ� �δ��ϰ� '�ڱ� �Ǵ� ��3�ڸ� ���Ͽ� ����ϴ� ����' ��<br/>'��3�ڿ��� �����ϴ� ����'�� �����ϴ� ������ �ܼ��� '����'�ϴ� ������ ������ ������ ������</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">10) ���Ż�� ������ ���� �����ȿ�� 3�⿡�� 7������ ���� : <span style="font-size:12px;font-weight:400">����ڷ� �䱸�����⡤���� ���� ���Ż�� ������ ���ؼ��� ���簳�� ��ȿ�� �ŷ� ���� ��<br/>'3��'���� '7��'���� Ȯ��</span></li>
              <li class="boxcontenttitle">&nbsp;</li>
              <li class="boxcontenttitle">11) �濵���� �䱸 ����, Ư�� ����ڿ� �ŷ����� ����, ��� ���� ���� ���� ���� :<span style="font-size:12px;font-weight:400"> ������ڴ� �ϵ��� ��ü���� ������ ���� ���� ���� �ڷ� �� �濵������ �䱸�ϴ� ����, �ڱ� �Ǵ� �ڱⰡ �����ϴ� ����ڿ� �ŷ��ϵ��� �����ϴ� ����, �ϵ��޾�ü�� ��� ������ �����ϴ� ���� ���� ����</span></li>
            </ul>
          </div>
        
        <div class="fc pt_10"></div>
      
      <div class="boxcontent3">
        <ul class="boxcontenthelp2 lt">
          <li class="noneboxcontenttitle"> 22. �ϵ������� ���� �Ǵ� ������ڿ� ���޻���ڰ� ������ ���°��� ������ ���Ͽ� ����, ������ ���� ���� ������ �����Ͽ� �ֽñ� �ٶ��ϴ�.<a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
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
          <li class="boxcontenttitle"><p align="center"> ���ݱ��� ��Ǵ�� ����ǥ�� �ۼ��� �ֽŵ� ���Ͽ� ����帮��<br/>
          ������ ���޻���� ��θ� �ۼ��Ͽ� �ֽñ� �ٶ��ϴ�.</p></li>
        </ul>
      </div>

      <div class="fc pt_20"></div>

      <!-- ��ư start -->
      <div class="fr">
        <ul class="lt">
          <%// ���縶������ �����ư ���� / 20141027 / ������%>
          <%// ���縶������ �����ư ���� / 20180716 / �躸��%>
          <%if (nAnswerCnt <= 0 ) {%>
          <li class="fl pr_2"><a href="javascript:savef2()" onfocus="this.blur()" class="contentbutton2">�ӽ�����</a></li>
          <%}%>

          <%
          String oStatus = sOentStatus; // ����ǥ ���� ("1")

          if (oStatus.equals("1")) {%>
          <li class="fl pr_2"><a href="#none" onfocus="this.blur()" class="contentbutton2">����Ϸ�</a></li>
          <%}else{%>
          <li class="fl pr_2"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">�� ��</a></li>
          <%} %>

          <li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">ȭ�� �μ��ϱ�</a></li>
          <li class="fl pr_2"><a href="./WB_VP_Subcon.jsp" onfocus="this.blur()" class="contentbutton2">4. ���޻���� ���</a></li>
        </ul>
      </div>

      <!-- ��ư end -->

    </div>
        </form>
        <!-- End subcontent -->

        <!-- Begin Footer -->
        <div id="subfooter"><img src="img/bottom.gif"/></div>
        <!-- End Footer -->

    </div>
    </div>

    <%/*-----------------------------------------------------------------------------------------------
    2010�� 4�� 26�� / iframe �߰� / ������
    :: �ϵ��ްŷ���Ȳ (��������) ���� �� ���� �� �����߻����� �������� �ҽǵǴ� ��츦 �����ϱ� ���� 
    :: ���û����� iframe Ÿ������ submit ��Ŵ
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
        alert("�ϵ��� �ŷ���Ȳ ���������� ����Ǿ����ϴ�.")
    <%}%>
</script>

</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>