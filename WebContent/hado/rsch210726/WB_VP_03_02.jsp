<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
/**
* ������Ʈ��   : �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���   : WB_VP_03_02.jsp
* ���α׷�����  : ȸ�簳��(�ͻ��� �Ϲ���Ȳ) ���
* ���α׷�����  : 3.0.1
* �����ۼ�����  : 2014�� 09�� 14��
* �� �� �� ��       :
*=========================================================
* �ۼ�����    �ۼ��ڸ�        ����
*=========================================================
* 2014-09-14   ������   �����ۼ�
* 2015-05-07   ������   ���繮�� ���� �� �������ܴ���ü ���� �߰�
* 2015-05-12   ������   ������ ��ü �����ڽ� �������� ��� �߰� (javascript)
* 2015-05-18   ������   ���ΰ��������� ���� ���ε� ����
* 2015-12-30   ������   DB�������� ���� ���ڵ� ����
* 2018-06-22    �躸�� Infinity üũ �߰�
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
String sMngNo = "H";    // ������ȣ
String sOentGB = "";    // ��������
String sOentType = "";    // ���ξ����ڵ�
String sOentName = "";    // ��ü��
String sOentCaptine = "";   // ��ǥ�ڸ�
String sOentMutualName = "";    // �Ҽ� ������ܸ�
String sOentZipCode = "";   // �����ȣ ��ü
//String sOentZipCode1 = "";  // �����ȣ ���ڸ�
//String sOentZipCode2 = "";  // �����ȣ ���ڸ�
String sOentAddress = "";   // �ּ�
String sOentTel = "";     // ��ȭ��ȣ
String sOentFax = "";     // �ѽ�
String sOentSale01 = "0";   // ����� (����⵵-2)
String sOentSale02 = "0";   // ����� (����⵵-1)
String sOentSsale = "0";    // �ϵ��� �ŷ��ݾ�
String sOentAssets = "0";   // �ڻ��Ѿ�
String sOentAssets01 = "0";   // �ڻ��Ѿ�
String sOentAssets02 = "0";   // �ڻ��Ѿ�
String sOentCapa = "";    // ȸ��Ը�
String sOentCapaTxt = ""; // ȸ��Ը��Ÿ
String sOentConAmt = "0"; // �ð��ɷ��򰡾�
String sOentEmpCnt = "0"; // ��ð�������� ��
String sOentEmpCnt01 = "0"; // ��ð�������� ��
String sOentEmpCnt02 = "0"; // ��ð�������� ��
String sOentCoGB = "";    // ����Ը�
String sOentCoNo = "";    // ���ε�Ϲ�ȣ ��ü
String sOentCoNo1 = "";   // ���ε�Ϲ�ȣ ���ڸ�
String sOentCoNo2 = "";   // ���ε�Ϲ�ȣ ���ڸ�
String sOentSaNo = "";    // ����ڵ�Ϲ�ȣ ��ü
String sOentSaNo1 = "";   // ����ڵ�Ϲ�ȣ ���ڸ�
String sOentSaNo2 = "";   // ����ڵ�Ϲ�ȣ �߰��ڸ�
String sOentSaNo3 = "";   // ����ڵ�Ϲ�ȣ ���ڸ�
String sOentEmail = "";   // �̸��� ��ü
String sOentEmail1 = "";    // �̸��� �� �ּ�
String sOentEmail2 = "";    // �̸��� �� �ּ�
String sWriterName = "";    // �ۼ��ڸ�
String sWriterOrg = "";   // �ۼ��� �μ���
String sWriterJikwi = "";   // �ۼ��� ������
String sWriterTel = "";     // �ۼ��� ��ȭ��ȣ
String sWriterFax = "";   // �ۼ��� FAX
String sWriterDate = "";    // �ۼ�����
String sCompStatus = "";    // ȸ�翵������
String sQ1Etc = "";       // ȸ�翵������ ��Ÿ�亯
String sAddrStatus = "";    // ������ڿ�Ǿȵ� ���� (3: ������ڿ�� �ȵ�)
String sSubconType = "";    // �ϵ��ްŷ�����
String sSubconCnt = "0";    // ���޻���� ��
//String sSubconCnt1 = "0";   // ���޻���� ��
String sOentStatus = "";    // ���ۿ���
String sCompUrl = "";     // Ȩ������ �ּ�
String sOentTypeDetail = "";  // �ϵ��ްŷ��ܰ�
String sOentCnt = "0";      // �� �ŷ���ü ��
//String sOentCnt1 = "0";     // �� �ŷ���ü ��
//2015-05-07 / �������ܴ�󿩺� ���� ���� / ������
String sOentNoExcept = "";      // �������ܴ�󿩺�

String sOentIncorp = "";    //��������
String sOentIncorp1 = "";   //������
String sOentIncorp2 = "";   //������

String sOentOper01 = "0";
String sOentOper02 = "0";
String sOentOper03 = "0";

String sfile = ""; // ���ܴ���� �����ڷ� ���ε�

int nCurrentYear = 0;   // ����⵵ ���� ��ȯ
/**
* �Է����� ���� ���� ���� �� �ʱ�ȭ ��
*/

/* �׸�ǥ���� ���⵵ �׸� ǥ�� ����� ���� ����⵵ ������ ��ȯ */
if( !ckCurrentYear.equals("") ) {
  nCurrentYear = Integer.parseInt(ckCurrentYear);
}

/* �ۼ����� ǥ�ø� ���� java Ķ���� ���̺귯�� ���� */
java.util.Calendar cal = java.util.Calendar.getInstance();

if ( !ckMngNo.equals("") && !ckCurrentYear.equals("") && !ckOentGB.equals("") ) {
  /* �̹� ȸ�簳��(�ͻ��� �Ϲ���Ȳ)�� �ԷµǾ� �ִ� ��� ���� ��������  ����*/
  try {
    resource = new ConnectionResource();
    conn = resource.getConnection();

    sSQLs   = "SELECT A.*, \n";  
      sSQLs   += "(SELECT file_name \n";  
      sSQLs   += "FROM hado_tb_oent_attach_file \n";
      sSQLs   += "WHERE mng_no = ? \n";
      sSQLs   += "AND current_year = ? \n";
      sSQLs   += "AND oent_gb = ? \n";
      sSQLs   += "AND file_sn = (SELECT MAX(file_sn) FROM hado_tb_oent_attach_file \n";
      sSQLs   += "WHERE mng_no = ? \n";
      sSQLs   += "AND current_year = ? \n";
      sSQLs   += "AND oent_gb = ? ) ) sfile \n";    
      sSQLs   += "FROM hado_tb_oent_" +ckCurrentYear+ " A \n";
      sSQLs   += "WHERE A.mng_no = ? AND A.current_year = ? AND A.oent_gb = ? \n";
    
        pstmt = conn.prepareStatement(sSQLs);
    
        pstmt = conn.prepareStatement(sSQLs);
        pstmt.setString(1, ckMngNo);
        pstmt.setString(2, ckCurrentYear);
        pstmt.setString(3, ckOentGB);
        pstmt.setString(4, ckMngNo);
        pstmt.setString(5, ckCurrentYear);
        pstmt.setString(6, ckOentGB);
        pstmt.setString(7, ckMngNo);
        pstmt.setString(8, ckCurrentYear);
        pstmt.setString(9, ckOentGB);
        
    rs = pstmt.executeQuery();
    
    if (rs.next()) {
      sMngNo = rs.getString("mng_no")==null ? "H":rs.getString("mng_no");
      sOentGB = rs.getString("oent_gb")==null ? "":rs.getString("oent_gb");
      sOentType = rs.getString("oent_type")== null ? "":rs.getString("oent_type");
      sOentName = rs.getString("oent_name")==null ? "":rs.getString("oent_name");
      sOentCaptine = rs.getString("oent_captine")==null ? "":rs.getString("oent_captine");
      sOentMutualName = rs.getString("oent_mutual_name")==null ? "":rs.getString("oent_mutual_name");
      sOentZipCode = rs.getString("zip_code")==null ? "":rs.getString("zip_code");
      sOentAddress = rs.getString("oent_address")==null ? "":rs.getString("oent_address");
      sOentTel = rs.getString("oent_tel")==null ? "":rs.getString("oent_tel");
      sOentFax = rs.getString("oent_fax")==null ? "":rs.getString("oent_fax");
      sOentSale01 = rs.getString("oent_sale01")==null ? "0":rs.getString("oent_sale01");
      sOentSale02 = rs.getString("oent_sale02")==null ? "0":rs.getString("oent_sale02");
      sOentSsale = rs.getString("oent_ssale")==null ? "0":rs.getString("oent_ssale");
      sOentAssets = rs.getString("oent_assets")==null ? "0":rs.getString("oent_assets");
      sOentAssets01 = rs.getString("oent_assets01")==null ? "0":rs.getString("oent_assets01");
      sOentAssets02 = rs.getString("oent_assets02")==null ? "0":rs.getString("oent_assets02");
      sOentConAmt = rs.getString("oent_con_amt")==null ? "0":rs.getString("oent_con_amt");
      sOentCapa = rs.getString("oent_capa")==null ? "":rs.getString("oent_capa");
      sOentCapaTxt = rs.getString("sp_fld_05")==null ? "":rs.getString("sp_fld_05");
      sOentEmpCnt = rs.getString("oent_emp_cnt")==null ? "0":rs.getString("oent_emp_cnt");
      sOentEmpCnt01 = rs.getString("oent_emp_cnt01")==null ? "0":rs.getString("oent_emp_cnt01");
      sOentEmpCnt02 = rs.getString("oent_emp_cnt02")==null ? "0":rs.getString("oent_emp_cnt02");
      sOentCoGB = rs.getString("oent_co_gb")==null ? "":rs.getString("oent_co_gb");
      sOentCoNo = rs.getString("oent_co_no")==null ? "":rs.getString("oent_co_no");
      sOentSaNo = rs.getString("oent_sa_no")==null ? "":rs.getString("oent_sa_no");
      sCompUrl = rs.getString("comp_url")==null ? "":new String(rs.getString("comp_url"));
      sOentEmail = rs.getString("assign_mail")==null ? "":new String(rs.getString("assign_mail"));
      sWriterName = rs.getString("writer_name")==null ? "":rs.getString("writer_name");
      sWriterOrg = rs.getString("writer_org")==null ? "":rs.getString("writer_org");
      sWriterJikwi = rs.getString("writer_jikwi")==null ? "":rs.getString("writer_jikwi");
      sWriterTel = rs.getString("writer_tel")==null ? "":rs.getString("writer_tel");
      sWriterFax = rs.getString("writer_fax")==null ? "":rs.getString("writer_fax");
      sWriterDate = rs.getString("write_date")==null ? "":rs.getString("write_date");
      sCompStatus = rs.getString("comp_status")==null ? "":rs.getString("comp_status");
      sQ1Etc = rs.getString("sp_fld_03")==null ? "":rs.getString("sp_fld_03");
      sSubconType = rs.getString("subcon_type")==null ? "":rs.getString("subcon_type");
      sSubconCnt = rs.getString("subcon_cnt")==null ? "0":rs.getString("subcon_cnt");
      //sSubconCnt1 = rs.getString("subcon_cnt1")==null ? "0":rs.getString("subcon_cnt1");
      sAddrStatus = rs.getString("addr_status")==null ? "":rs.getString("addr_status");
      sOentStatus = rs.getString("oent_status")==null ? "":rs.getString("oent_status");
      sOentTypeDetail = rs.getString("sp_fld_01")==null ? "":rs.getString("sp_fld_01");
      sOentCnt = rs.getString("subcon_tot_cnt")==null ? "0":rs.getString("subcon_tot_cnt");
      //sOentCnt1 = rs.getString("subcon_tot_cnt1")==null ? "0":rs.getString("subcon_tot_cnt1");
      //2015-05-07 / DB�� ����� Record ���� / ������
      sOentNoExcept = rs.getString("sp_fld_02")==null ? "":rs.getString("sp_fld_02");
      
      sOentIncorp = rs.getString("oent_incorp")==null ? "":rs.getString("oent_incorp");
      
      sOentOper01 = rs.getString("oent_oper01")==null ? "0":rs.getString("oent_oper01");
      sOentOper02 = rs.getString("oent_oper02")==null ? "0":rs.getString("oent_oper02");
      sOentOper03 = rs.getString("oent_oper03")==null ? "0":rs.getString("oent_oper03");
      
      // ���ܴ���� �����ڷ� ���ε� ���� (���� ����)
        sfile = rs.getString("sfile")==null ? "":rs.getString("sfile"); 
      
      /* ���ε�Ϲ�ȣ ���� */
      String[] arrTmpCoNo = sOentCoNo.split("-");
      if( arrTmpCoNo.length==2 ) {
        sOentCoNo1  = arrTmpCoNo[0];
        sOentCoNo2  = arrTmpCoNo[1];
      }

      /* ����ڵ�Ϲ�ȣ ���� */
      String[] arrTmpSaNo = sOentSaNo.split("-");
      if( arrTmpSaNo.length==3 ) {
        sOentSaNo1 = arrTmpSaNo[0];
        sOentSaNo2 = arrTmpSaNo[1];
        sOentSaNo3 = arrTmpSaNo[2];
      }

      /* �̸����ּ� ���� */
      String[] arrTmpEmail = sOentEmail.split("@");
      if( arrTmpEmail.length==2 ) {
        sOentEmail1 = arrTmpEmail[0];
        sOentEmail2 = arrTmpEmail[1];
      }
      
      /* �������� */
      String[] arrTmpIncorp = sOentIncorp.split("-");
      if( arrTmpIncorp.length==2 ) {
        sOentIncorp1 = arrTmpIncorp[0];
        sOentIncorp2 = arrTmpIncorp[1];
      }

      /* ������� ��Ǿȵ� ���� (��Ǿȵ� '3' �� ���) */
      /* 2015-05-07 / �������ܴ�󿩺� ���� �߰��� ���� ���� ���� / ������
      if( !sAddrStatus.equals("3") ) sAddrStatus = "";
      */
    }
    rs.close();
  } catch(Exception e){
    e.printStackTrace();
  } finally {
    if ( rs != null ) try{rs.close();}    catch(Exception e){}
    if ( pstmt != null )  try{pstmt.close();} catch(Exception e){}
    if ( conn != null )   try{conn.close();}  catch(Exception e){}
    if ( resource != null ) resource.release();
  }
  /* �̹� ȸ�簳��(�ͻ��� �Ϲ���Ȳ)�� �ԷµǾ� �ִ� ��� ���� ��������  �� */
}
/*=====================================================================================================*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--[if lt IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie6"><![endif]-->
<!--[if IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie7"><![endif]-->
<!--[if IE 8]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie8"><![endif]-->
<!--[if (gt IE 8)|!(IE)]><!-->
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko-KR" class="no-js">
<!--<![endif]-->
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta http-equiv='Cache-Control' content='no-cache' />
    <meta http-equiv='Pragma' content='no-cache' />
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
    <script src="../js/login_2019.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/credian_common_script.js" type="text/javascript"  charset="euc-kr"></script>
    <script language="JavaScript">
    ns4 = (document.layers)? true:false
    ie4 = (document.all)? true:false

    var msg = "";

    function savef() {
      var cchekc = "no", i, j;
      var main = document.info;
      msg = "";

      // �ʼ����� Ȯ�� 
      if(main.rcomp.value=="")
        msg+="\nȸ����� �Է��� �ּ���.";
      if(main.rcogb[0].checked!=true&&main.rcogb[1].checked!=true)
        msg+="\n���ε�Ͽ��θ� �Է����ּ���.";
      else {
        if(main.rcogb[0].checked==true) {
          if(main.rlawno1.value=="" || main.rlawno2.value=="")
            msg+="\n���ε�Ϲ�ȣ�� �Է��� �ּ���.";
          else
            main.rlawno.value = main.rlawno1.value + "-" + main.rlawno2.value;
        }
      }
      if(main.rregno1.value=="" || main.rregno2.value=="" || main.rregno3.value==""){
        msg+="\n����ڵ�Ϲ�ȣ�� �Է��� �ּ���.";
      } else {
        main.rregno.value = main.rregno1.value+"-"+main.rregno2.value+"-"+main.rregno3.value;
      }
      if(main.raddr.value=="")
        msg+="\n���� �������� �Է��� �ּ���.";
      if(main.remail1.value=="" || main.remail2.value=="")
        msg+="\�ۼ�å���� E-mail�ּҸ� �Է��� �ּ���.";
      if(main.rname.value=="")
        msg+="\n�ۼ�å���� ������ �Է��� �ּ���.";
      if(main.rposition.value=="")
        msg+="\n�ۼ�å���� ������ �Է��� �ּ���.";
      if(main.rtel.value=="")
        msg+="\n�ۼ�å���� ��ȭ��ȣ�� �Է��� �ּ���.";

        // �������� ����
      if( jQuery("input:radio[name='q0']").is(":checked")) {
          if( jQuery("input[name='fileCheck']").val() == "N" ) {
            msg += "\n���ܴ���� ���������� ÷���Ͽ� �ּ���.";
          }
      }
      // ÷������ ���ε� �Ǹ� �������� �׸� ���� �ʼ�
      if( jQuery("input[name='fileCheck']").val() == "Y" ) {
          if(!jQuery("input:radio[name='q0']").is(":checked") ){
            msg += "\n�������� ��� �׸��� �������ּ���.";
          }
      }
      
      var cstatus = jQuery("input:radio[name='q1']:checked").val();
    if( cstatus!="1" ) {
      if(!jQuery("input:radio[name='q0']").is(":checked")) {
          msg += "\n���󿵾��� �ƴѰ�� �������� ��� �׸��� �������ּ���.";
        }
    }
      

      if(msg!="") msg+="\n";


      researchf(main.q1,2,"ȸ�簳���� 1�� �������¸� �������ּ���");
      researchf(main.q2,2,"ȸ�簳���� 2�� ȸ��Ը� �������ּ���");
      researchf(main.q3_3,1,"ȸ�簳���� 3�� <%= nCurrentYear-3%>�� ������� �Է����ּ���");
      researchf(main.q3_1,1,"ȸ�簳���� 3�� <%= nCurrentYear-2%>�� ������� �Է����ּ���");
      researchf(main.q3_2,1,"ȸ�簳���� 3�� <%= nCurrentYear-1%>�� ������� �Է����ּ���");
      researchf(main.q3_4,1,"ȸ�簳���� 3�� <%= nCurrentYear-3%>�� ��������� �Է����ּ���");
      researchf(main.q3_5,1,"ȸ�簳���� 3�� <%= nCurrentYear-2%>�� ��������� �Է����ּ���");
      researchf(main.q3_6,1,"ȸ�簳���� 3�� <%= nCurrentYear-1%>�� ��������� �Է����ּ���");
      researchf(main.q3_7,1,"ȸ�簳���� 3�� <%= nCurrentYear-3%>�� �ڻ��Ѿ��� �Է����ּ���");
      researchf(main.q3_8,1,"ȸ�簳���� 3�� <%= nCurrentYear-2%>�� �ڻ��Ѿ��� �Է����ּ���");
      researchf(main.q3_9,1,"ȸ�簳���� 3�� <%= nCurrentYear-1%>�� �ڻ��Ѿ��� �Է����ּ���");
      researchf(main.q4,1,"ȸ�簳���� 4�� �ѱ� ���ڼ��� �Է����ּ���");
      researchf(main.q4_1,1,"ȸ�簳���� 4�� ��� �ٷ��ڼ��� �Է����ּ���");
      researchf(main.q4_2,1,"ȸ�簳���� 4�� �ӽ� �� �Ͽ� �ٷ��ڼ��� �Է����ּ���");
      

      if(msg!="") msg+="\n";

      var mutualName = main.mutualName.value;
      if(mutualName != null && mutualName != "") {
        mutualName = mutualName.replace(/\'/g, '');
        mutualName = mutualName.replace(/\"/g, '');
        
        main.mutualName.value = mutualName;
      }

      if(msg=="") {
        if(confirm("[ ȸ�簳�並 �����մϴ�. ]\n\n�����ڰ� ������� �ټ� �ð��� �ɸ����� �ֽ��ϴ�.\n���������� ������ �ȵɰ��\n���ʺ��Ŀ� �ٽýõ��Ͽ� �ֽʽÿ�.\n\n������ ���Ϸ� ���忡 �����Ұ��\n�����Ͻ� ���系���� ������ �� �����ϴ�.\n�����Ͻ� ����ǥ�� �μ��Ͽ� �����Ͻð�\n�������������� ���콺������ ��ư�� ����\n���ΰ�ħ�� �����Ͽ� �������� �õ��Ͻʽÿ�.\n\nȮ���� �����ø� �����մϴ�.")) {

          processSystemStart("[1/1] �Է��� ȸ�簳���� �����մϴ�.");

          main.target = "ProceFrame";
          main.action = "WB_CP_Research_Qry.jsp?type=Srv&step=Basic";
          main.submit();
        }
      } else {
        alert(msg+"\n\n������ ��ҵǾ����ϴ�.")
      }
    }

    function researchf(obj,type,mm) {
      var ccheck="no", i;

      switch (type) {
        case 1:
          if(obj.value=="") msg+="\n"+mm;
          break;
        case 2:
          for(i=0;i<obj.length;i++)
            if(obj[i].checked==true) ccheck="yes";
          if(ccheck=="no") msg+="\n"+mm;
          break;
      }
    }
    

    function formatmoney(m) {
      var money, pmoney, mlength, z, textsize, i;
      textsize=20;
      pmoney="";
      z=0;
      money=m;
      money=clearstring(money);
      money=Number(money);
      money=money+"";
      for(i=money.length-1;i>=0;i--) {
        z+=1;
        if(z%3==0) {
          pmoney=money.substr(i,1)+pmoney;
          if(i!=0)
            pmoney=","+pmoney;
        }
        else pmoney=money.substr(i,1)+pmoney;
      }
      return pmoney;
    }

    function clearstring(s) {
      var pstr, sstr, iz;
      sstr=s;
      pstr="";
      for(iz=0;iz<sstr.length;iz++)
        {
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

    function OpenPost() {
      MsgWindow = window.open("WB_Find_Zip.jsp?ITEM=F&stype=nomr","_PostSerch","toolbar=no,width=430,height=320,directories=no,status=yes,scrollbars=yes,resize=no,menubar=no");
    }

    function onDocument() {
    }

    function goPrint() {
      print();
    }

    function chkCompStatus() {
      var cstatus = jQuery("input:radio[name='q1']:checked").val();
      if( cstatus!="1" ) {
        if( jQuery("#attachFileYN").val()!="Y" ) {
          alert("���󿵾��� �ƴѰ�� �����ڷḦ ÷���Ͽ��� �մϴ�.\n÷���� ���������� �������� ��� �ȳ��� �����Ͻñ� �ٶ��ϴ�.");
        }
        jQuery("#lyAttachFile").css({"display":"block"});
      } else {
        jQuery("#lyAttachFile").css({"display":"none"});
      }
    }


    function doFileupload() {
      window.open("WB_Edoc_Up.jsp","_blank","toolbar=no,width=450,height=380,directories=no,status=no,scrollbars=Yes,resize=no,menubar=no");
    }

    function refreshAttachFileList() {
      jQuery.ajax({
        type : "post",
        url : "WB_AP_getAttachFile_List.jsp",
        cache : false,
        data : "",
        ascync : false,
        datatype : "html",
        success : function(data) {
          var msg = data.replace(/(^\s*)|(\s*$)/gi,""); // �������� ���Խ�
          if( msg!= "") {
            jQuery("#lyAttachFileBody").html(msg);
            jQuery("#attachFileYN").attr("value","Y");
                    }
        },
        error : function() {
          alert("������ ����� ������ �߻��Ͽ����ϴ�.\n\n��� �� �ٽ� �õ��� �ֽñ� �ٶ��ϴ�.");
        }
      });
    }

    // Radio object �缱�ý� �ʱ�ȭ
    function checkradioUnit(valObj,radioObj) {
      eval("oldValue = document.info."+valObj+".value");
      eval("obj = document.info."+radioObj);
      selValue = "";

      for(i=0; i<obj.length; i++) {
        if(obj[i].checked==true) {
          selValue = obj[i].value;
          if( selValue==oldValue ) {
            obj[i].checked = false;
            eval("document.info."+valObj+".value=''");
          } else {
            eval("document.info."+valObj+".value='"+selValue+"'");
          }
          break;
        }
      }
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
    
    
    function f_oent(main) {
          
      <%/* 2018-06-22   �躸�� 9�� �׸񿡼� ���޻���� ���� 0���� �� ��� Infinity �� ��� �Ǿ� ����Ŭ�� ���� �� ���� ��.
        Infinity üũ �߰�
       */%>
      main.q12_1.value= isFinite(avg(main.q10_1.value, main.q11_1.value))?avg(main.q10_1.value, main.q11_1.value):0;
      main.q12_2.value= isFinite(avg(main.q10_2.value, main.q11_2.value))?avg(main.q10_2.value, main.q11_2.value):0;
      main.q9_3.value = percent(main.q9_2.value, main.q9_1.value);
      main.q10_3.value = percent(main.q10_2.value, main.q10_1.value);
      main.q11_3.value = percent(main.q11_2.value, main.q11_1.value);
      main.q12_3.value = percent(main.q12_2.value, main.q12_1.value);
      
    }
    
    function f_oent01(main) {
      
      main.q8_0.value = Number(main.q8_1.value)+Number(main.q8_2.value)+Number(main.q8_3.value)+Number(main.q8_4.value)+Number(main.q8_5.value)+Number(main.q8_6.value);
      
    }
    
    function avg(a, b) {
            if(!a || a < 1) {
                return 0;
            }
            if(!b) {
              b = 0;
            }
            return Cnum(Math.round(Cnum(a)/Cnum(b)));
        }
        
        function percent(a, b) {
          if(!b || b < 1) {
                return 0;
            }
          if(!a) {
            a = 0;
          }
            return Cnum(Math.round(Cnum(a)/Cnum(b) * 100));
        }
        
        var beforeChecked = -1;
        jQuery(function(){
            jQuery(document).on("click", "input[type=radio][name=q0]", function(e){
                var index = jQuery(this).val();
                //alert(index);
                if(beforeChecked == index){
                    beforeChecked = -1;
                    jQuery(this).prop("checked", false);
                }else{
                    beforeChecked = index;   
                }
            });
        });
        
  </script>
</head>

<body onload="onDocument();">

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
        <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenuup">2. ȸ�簳��</a></li>
        <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. �ϵ��� �ŷ���Ȳ</a></li>
        <li class="fl pr_2"><a href="./WB_VP_Subcon.jsp" onfocus="this.blur()" class="mainmenu">4. ���޻���� ���</a></li>
        <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="mainmenu">5. ����ǥ ����</a></li>
      </ul>
    </div>
    <!-- End Header -->
    <form action="" method="post" id="info" name="info">
    <!-- Begin subcontent -->
    <div id="subcontent">
      <!-- title start -->
      <h1 class="contenttitle">2. ȸ�簳��</h1>
      <!-- title end -->


      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="lt">
            <li class="boxcontenttitle">ȸ�簳�� �ۼ��ȳ�</li>
            <li class="boxcontentsubtitle">�������� ��� �ȳ� �� ������ �ȳ�</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="clt">
            <li><span>�� </span><strong>������ ���</strong>�� <strong>���� ����� �ƴ� �� �����Ƿ�</strong>,&nbsp;��<strong>��2. ȸ�� ���䡹�κб��� �Է�</strong>�ϰ�, �� �������� ������� ������ �� �ִ� <strong>�����ڷ�(PDF����)�� ����Ʈ�� ���ε�</strong>�Ͻ� ��, �� <strong>��3. �ϵ��ްŷ���Ȳ���� 5������(�ϵ��ްŷ�����)�� "��. �ϵ��ްŷ��� ���� ����"�� �����ϰ� ����</strong>, ��<strong>&lt;����ǥ ����&gt; �޴��� ����</strong>�Ͽ� �ֽñ� �ٶ��ϴ�.</li>
            <%-- <li><span>�� </span>�������� ��� ������<strong> ���󿵾��� �ƴѰ��(�Ʒ��� ��, ��, ���׸� �ش��ϴ� ���)</strong>�� <strong>�����ڷḦ ���Ϸ� ÷��</strong>�Ͽ� �����Ͽ� �ֽñ� �ٶ��ϴ�.</li>--%>
            <li><span>�� </span>�ٸ�, �������� ������� �ڷḦ �����Ͻ� ���, ���� �ڷ��� ��ǰ��� ���θ� Ȯ���ϱ� ���� ���� �������縦 �ǽ��� �� ����</li>
            <li>&nbsp;</li>
            <li><p align="center">- �� �� - </p></li>
            <li>&nbsp;</li>
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:50%;" />
                  <col style="width:50%;" />
                </colgroup>
                <thead>
                  <tr>
                    <th height="35"><strong>���� ���� ���</strong></th>
                    <th height="35"><strong>���� �����ڷ�(�����ؾ� �� �ڷ�)</strong></th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>�� '�������' ��ǿ� �ش����� �ʴ� ���</td>
                    <td>- <%=nCurrentYear-2%>�⵵ ���Ͱ�꼭 (����, �뿪 ����)<br/>
                    - <%=nCurrentYear-1%>�� �ð��ɷ��򰡾� (�Ǽ� ����)</td>
                  </tr>
                  <tr>
                    <td>�� �ϵ��ްŷ��� ���ų� �ϵ����� �ޱ⸸ �ϴ� ���</td>
                    <td>- �ͻ��� �ŷ�����(ǰ��) �� �ŷ����� ���� ������<br/>
                      &nbsp;&nbsp;&nbsp;�� �ִ� �Ҹ��ڷ�(���� ��� ����)<br/>
                      - ���ᱸ�Ժ��� ��ǰ�ϼ� �� ��������� ������� <br/>
                      &nbsp;&nbsp;&nbsp;���μ��� ���� �����Ͽ� ����</td>
                  </tr>
                  <tr>
                    <td>�� "ä����ȸ�� �� �Ļ꿡 ���ѹ���" �� ���� ȸ����<br/>
                      &nbsp;&nbsp;&nbsp;&nbsp;�� �Ǵ� ��������۾�(work-out)�� ���� ���� ���</td>
                    <td>- ȸ������ ���ð��� ���� �����ǰṮ �Ǵ� �������<br/>
                      &nbsp;&nbsp;&nbsp;�۾��� ���� ������ �� �� �ִ� �����ڷ�</td>
                  </tr>
                  <tr>
                    <td>�� �ε��� �����ߴ� �Ǵ� ����� ���</td>
                    <td>- �ε���� Ȯ�ο� �Ǵ� ����������� ��</td>
                  </tr>
                  <tr>
                    <td>�� �ٸ� ȸ�翡 ����պ��� ���</td>
                    <td>- �պ����� ��༭, ���ε��� � ��</td>
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
          <ul class="lt">
            <li class="boxcontenttitle">�������� ��� �����ڷ�</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="clt">
            <li><span>�� </span>�������� ����� �ǽô� ��� �������� ������� ������ �� �ִ� <strong>�����ڷ�(PDF ����)�� ���ε�</strong> �� �ֽñ� �ٶ��ϴ�.</li>
            <li></li>
            <li><span>��</span><strong>Step1. ���ܴ�� �׸� ���� (��1)</strong></li>
            <li><input type="radio" name="q0" value="1" <%if(sOentNoExcept!=null && sOentNoExcept.equals("1")){out.print("checked");}%>></input> 1. ��������ڡ� ��ǿ� �ش����� �ʴ� ���</li>
            <li><input type="radio" name="q0" value="2" <%if(sOentNoExcept!=null && sOentNoExcept.equals("2")){out.print("checked");}%>></input> 2. �ϵ��ްŷ��� ���ų� �ϵ����� �ޱ⸸ �ϴ� ���</li>
            <li><input type="radio" name="q0" value="3" <%if(sOentNoExcept!=null && sOentNoExcept.equals("3")){out.print("checked");}%>></input> 3. ��ä����ȸ�� �� �Ļ꿡 ���ѹ������� ���� ȸ������ �Ǵ� ��������۾�(work-out)�� ���� ���� ���</li>
            <li><input type="radio" name="q0" value="4" <%if(sOentNoExcept!=null && sOentNoExcept.equals("4")){out.print("checked");}%>></input> 4. �ε��� �����ߴ� �Ǵ� ����� ���</li>
            <li><input type="radio" name="q0" value="5" <%if(sOentNoExcept!=null && sOentNoExcept.equals("5")){out.print("checked");}%>></input> 5. �ٸ� ȸ�翡 ����պ��� ���</li>
            <li><input type="radio" name="q0" value="6" <%if(sOentNoExcept!=null && sOentNoExcept.equals("6")){out.print("checked");}%>></input> 6. 2020�� ��ü �ϵ��ްŷ��� ���� ������ ������ �������縦 �޾Ұų� �ް� �ִ� ���</li>
            <li></li>
            <li><span>��</span><strong>Step2. ���� ���ε�</strong></li>
            <li><p style="padding-left:60px; width:200px;"><a href="javascript:doFileupload()" onfocus="this.blur()" class="contentbutton2">���ܴ���� �����ڷ� ���ε�</a></p></li>
            <li>
                <c:set var="sfile" value="<%=sfile%>" />
                <input type="hidden" name="fileCheck" value="${sfile eq '' ? 'N':'Y'}" />
                <c:if test="${sfile ne ''}">
                  <p style="padding-left:60px; margin: 10px 0px 10px;"><strong>����� ���� :</strong><a href="WB_File_Down.jsp?Type=O"><%=sfile%></a></p>
                </c:if>
            </li>
            <li><span>��</span><strong>Step3. ȸ�簳�� �Է� �� ���� ���� �� "3. �ϵ��ްŷ���Ȳ"�� 5������ (�ϵ��ްŷ�����) ����, "5. ����ǥ����" ���� �̵��Ͽ� ����ǥ ����</strong></li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>


      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="lt">
            <li class="boxcontenttitle">I. ȸ�簳��</li>
            <li class="boxcontentsubtitle">* ȸ����� ������� �Է�.<br/>
            &nbsp;&nbsp;&nbsp;- �Է¿���) (��) ȸ �� �� <font color="#FF0066">(X)</font> --> (��)ȸ��� <font color="#FF0066">(0)</font><br/>
            * ����ڵ������ ��õ� ȸ���(�ѱ�/����)���� ����.</li>
            <li class="boxcontentsubtitle">&nbsp;</li>
            <li class="boxcontentsubtitle">* �ͻ��� �Ҽ� ������ܸ��� �����ϵ�, ����<br/> �Ҽ� ��������� ���� ��� '�ش���� ����'���� ����</li>
            <li class="boxcontentsubtitle">&nbsp;</li>
            <li class="boxcontentsubtitle">* �������� �����ȣ �˻� �� ���ּҸ� �߰��� �Է�<br/>
              &nbsp;&nbsp;&nbsp;�ϼ���.</li>
            <li class="boxcontentsubtitle">&nbsp;</li>
            <li class="boxcontentsubtitle">* ��ȭ��ȣ �Է� ��: 02-123-4567 (��ǥ��ȭ 1�� �Է�)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:15%;" />
                  <col style="width:30%;" />
                  <col style="width:15%;" />
                  <col style="width:40%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>������ȣ</th>
                    <td><strong><%=sMngNo%></strong></td>
                    <th>ȸ �� ��</th>
                    <td><input type="text" name="rcomp" value="<%=sOentName%>" maxlength="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input></td>
                  </tr>
                  <tr>
                    <th>���ο���</th>
                    <td>
                      <input type="radio" name="rcogb" value="1" <%if(sOentCoGB!=null && sOentCoGB.equals("1")){out.print("checked");}%>></input>����
                      <input type="radio" name="rcogb" value="0" <%if(sOentCoGB!=null && sOentCoGB.equals("0")){out.print("checked");}%>></input>�����
                    </td>
                    <th>���ε�Ϲ�ȣ</th>
                    <td><input type="hidden" name="rlawno" value="<%=sOentCoNo%>"></input>
                      <input type="text" name="rlawno1" value="<%=sOentCoNo1%>" maxlength="6" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rlawno1',6,'rlawno2');"></input>-
                      <input type="text" name="rlawno2" value="<%=sOentCoNo2%>" maxlength="7" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';"></input>
                    </td>
                  </tr>
                  <tr>
                    <th>��������</th>
                    <td><input type="hidden" name="rincorp" value="<%=sOentIncorp%>"></input>
                      <input type="text" name="rincorp1" value="<%=sOentIncorp1%>" maxlength="6" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rincorp1',4,'rincorp2');"></input>��
                      <input type="text" name="rincorp2" value="<%=sOentIncorp2%>" maxlength="7" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';"></input>��
                    </td>
                    <th>����ڵ�Ϲ�ȣ</th>
                    <td><input type="hidden" name="rregno" value="<%=sOentSaNo%>"></input>
                      <input type="text" name="rregno1" value="<%=sOentSaNo1%>" maxlength="3" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rregno1',3,'rregno2');"></input>-
                      <input type="text" name="rregno2" value="<%=sOentSaNo2%>" maxlength="2" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rregno2',2,'rregno3');"></input>-
                      <input type="text" name="rregno3" value="<%=sOentSaNo3%>" maxlength="5" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';"></input>
                    </td>
                  </tr>
                  <tr>
                    <th>��ǥ�ڸ�</th>
                    <td colspan="3">
                      <input type="text" name="rowner" value="<%=sOentCaptine%>" maxlength="16" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
                      <input type="hidden" name="roenttype" value="<%=sOentType%>"/>
                    </td>
                    <%-- <th>����з��ڵ�</th>
                    <td>
                      <input type="text" name="roenttype" value="<%=sOentType%>" maxlength="5" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
                    </td> --%>
                  </tr>
                  <tr>
                    <th>�Ҽ� ������ܸ�</th>
                    <td colspan="3"><input type="text" name="mutualName" value="<%=sOentMutualName%>" maxlength="16" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <th rowspan="3">����</th>
                    <td colspan="3">�����ȣ : <input type="text" name="rpost" value="<%=sOentZipCode%>" class="text03b"></input>&nbsp;&nbsp;<a href="javascript:OpenPost();"><img src="img/btn_post.gif" border="0" alt="�����ȣ ã��" align="absmiddle"></img></a></td>
                  </tr>
                  <tr>
                    <td colspan="3">��  ��  �� : <input type="text" name="raddr" value="<%=sOentAddress%>" maxlength="76" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <td colspan="3">��ȭ��ȣ(������ȣ ����) : <input type="text" name="mtel01" value="<%=sOentTel%>" maxlength="20" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input></td>
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
          <ul class="lt">
            <li class="boxcontenttitle">II. ����ǥ �ۼ�å����</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:20%;" />
                  <col style="width:80%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>�Ҽ� �μ�</th>
                    <td><input type="text" name="rdept" value="<%=sWriterOrg%>" maxlength="33" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <th>����</th>
                    <td><input type="text" name="rposition" value="<%=sWriterJikwi%>" maxlength="16" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <th>����</th>
                    <td><input type="text" name="rname" value="<%=sWriterName%>" maxlength="16" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <th>��ȭ��ȣ</th>
                    <td><input type="text" name="rtel" value="<%=sWriterTel%>" maxlength="20" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <th>E-mail �ּ�</th>
                    <td><input type="text" name="remail1" value="<%=sOentEmail1%>" maxlength="26" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>@<input type="text" name="remail2" value="<%=sOentEmail2%>" maxlength="50" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input></td>
                  </tr>
                  <tr>
                    <th>����ǥ�ۼ���</th> 
                    <td>
                      <%if ( sWriterDate==null || sWriterDate.equals("") ) {%>
                        <%=cal.get(Calendar.YEAR)%>�� <%=cal.get(Calendar.MONTH)+1%>�� <%=cal.get(Calendar.DATE)%>��
                      <%} else {%><%=sWriterDate%><%}%>
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
            <li class="boxcontenttitle"><span>1. </span>�ͻ��� <%=nCurrentYear-1%>�⵵ 12�� �� ���� ���� ���´� ��մϱ�?</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="rnoexptVal" value="<%=sOentNoExcept%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q1" value="1" <%if(sCompStatus!=null && sCompStatus.equals("1")){out.print("checked");}%> onclick="chkCompStatus();"></input> 1. ���󿵾�</li>
            <li><input type="radio" name="q1" value="2" <%if(sCompStatus!=null && sCompStatus.equals("2")){out.print("checked");}%> onclick="chkCompStatus();"></input> 2. ���ȸ�� ���� ���� ��</li>
            <li><input type="radio" name="q1" value="3" <%if(sCompStatus!=null && sCompStatus.equals("3")){out.print("checked");}%> onclick="chkCompStatus();"></input> 3. �����ߴ� �� �Ǵ� ��� ���� ��</li>
            <li><input type="radio" name="q1" value="4" <%if(sCompStatus!=null && sCompStatus.equals("4")){out.print("checked");}%> onclick="chkCompStatus();"></input> 4. �ٸ� ȸ��� �պ� ���� ��</li>
            <li><input type="radio" name="q1" value="5" <%if(sCompStatus!=null && sCompStatus.equals("5")){out.print("checked");}%> onclick="chkCompStatus();"></input> 5. ��Ÿ(<input type="text" name="q1Etc" value="<%=sQ1Etc%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>2. </span>�ͻ��� <%=nCurrentYear-1%>�⵵ 12�� �� ���� ȸ��Ը�� �����Դϱ�?</li>
            <li class="boxcontentsubtitle">* ������ �����ŷ��� ��14����1���� ������ ���� '��ȣ�������ѱ������'�� �Ҽӵ� ȸ����</li>
            <li class="boxcontentsubtitle">* �߰߱���� �߰߱���� ��2����1ȣ�� ������ �ش��ϴ� ȸ����</li>
            <li class="boxcontentsubtitle">* �߼ұ���� �߼ұ���⺻�� ��2���� ������ �ش��ϴ� ȸ����</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <input type="radio" name="q2" value="1" <%if(sOentCapa!=null && sOentCapa.equals("1")){out.print("checked");}%>></input> 1. ����<br/>
              <input type="radio" name="q2" value="2" <%if(sOentCapa!=null && sOentCapa.equals("2")){out.print("checked");}%>></input> 2. �߰߱��<br/>
              <input type="radio" name="q2" value="3" <%if(sOentCapa!=null && sOentCapa.equals("3")){out.print("checked");}%>></input> 3. �߼ұ��(�߱�����ұ�����һ����)<br/>
            </li>
            <div class="fc pt_50"></div>
            <div class="fc pt_30"></div>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>3. </span>�ͻ��� ���� 3�Ⱓ(<%=nCurrentYear-3%>��~<%=nCurrentYear-1%>��) �����, �������, �ڻ��Ѿ��� ������ �ֽʽÿ�.</li>
            <li class="boxcontentsubtitle">* ��������� �������, �ΰǺ�, ������, ���ݰ�����, �����󰢺� �� ����Ȱ���� �ҿ�� ����� �����ϸ�, ���Ͱ�꼭 �� ��������� �Ǹź� �� �������� ������ �����.</li>
                        <li class="boxcontentsubtitle">* ��������� ��� ������ ���õ� ����鿡 ��κ� ���ԵǴ� ������. ���������� ���Ǵ� ��������(��Ȳ�� �ľ��ϴ� ����)���� ���� ������.(�ϵ��޹� ���ݰ��� ��� ����.)</li>
                        <li class="boxcontentsubtitle">* ��������� ���Ͱ�꼭�� �ִ� �ڷ� �������� �Է��ϵ�, ��������� ���ϱ� ������ �뷫���� �ݾ����� ����</li>
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
                  <tr align="center">
                    <th colspan="2">�����</th>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-3%>�⵵</th>
                    <td height="40" valign="top"><input type="text" name="q3_3" value="<%=sOentSsale%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount003');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount003" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-2%>�⵵</th>
                    <td height="40" valign="top"><input type="text" name="q3_1" value="<%=sOentSale01%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount001');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount001" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-1%>�⵵</th>
                    <td height="40" valign="top"><input type="text" name="q3_2" value="<%=sOentSale02%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount002');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount002" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                </tbody>
              </table>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:30%;" />
                  <col style="width:70%;" />
                </colgroup>
                <tbody>
                  <tr align="center">
                    <th colspan="2">�������</th>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-3%>�⵵</th>
                    <td height="40" valign="top"><input type="text" name="q3_4" value="<%=sOentOper01%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount004');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount004" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-2%>�⵵</th>
                    <td height="40" valign="top"><input type="text" name="q3_5" value="<%=sOentOper02%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount005');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount005" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-1%>�⵵</th>
                    <td height="40" valign="top"><input type="text" name="q3_6" value="<%=sOentOper03%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount006');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount006" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                </tbody>
              </table>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:30%;" />
                  <col style="width:70%;" />
                </colgroup>
                <tbody>
                  <tr align="center">
                    <th colspan="2">�ڻ��Ѿ�</th>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-3%>�⵵</th>
                    <td height="40" valign="top"><input type="text" name="q3_7" value="<%=sOentAssets%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount007');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount007" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-2%>�⵵</th>
                    <td height="40" valign="top"><input type="text" name="q3_8" value="<%=sOentAssets01%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount008');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount008" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-1%>�⵵</th>
                    <td height="40" valign="top"><input type="text" name="q3_9" value="<%=sOentAssets02%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount009');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount009" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
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
            <li class="boxcontenttitle"><span>4. </span><%= nCurrentYear-1%>�� 12�� �� ����, �ͻ��� ��������� ���� ������ �ֽʽÿ�.</li>
            <li class="boxcontentsubtitle">* ��� �ٷ��� : ���Ⱓ�� 1�� �̻� �Ǵ� ���� ��� ���� �ٷ��ڷμ� ��õ¡�� �����Ȳ �Ű����� �ٷμҵ� ���̼���(A01)�� ���ο�</li>
            <li class="boxcontentsubtitle">* �ӽ� �� �Ͽ� �ٷ��� : ���Ⱓ�� 1�� �̸��� �ٷ���</li>
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
                  <tr align="center">
                    <th>����</th>
                    <th>�ٷ��� ��</th>
                  </tr>
                  <tr align="center">
                    <th>�� �ٷ���</th>
                    <td>
                      <input type="text" name="q4" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=sOentEmpCnt%>" size="6"></input> ��
                    </td>
                  </tr>
                  <tr align="center">
                    <th>��� �ٷ���</th>
                    <td>
                      <input type="text" name="q4_1" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=sOentEmpCnt01%>" size="6"></input> ��
                    </td>
                  </tr>
                  <tr align="center">
                    <th>�ӽ� �� �Ͽ� �ٷ���</th>
                    <td>
                      <input type="text" name="q4_2" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=sOentEmpCnt02%>" size="6"></input> ��
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

      <div class="boxcontent2">
        <ul class="boxcontenthelp lt">
          <li class="boxcontenttitle">�ͻ簡 �������� ��� �ش��ϴ� ���(�� ���κ� "�ۼ��ȳ�" �� ����)�� ��2. ȸ�簳�䡹 �ס�3. �ϵ��ްŷ���Ȳ���� 5������ �ۼ� �� �����Ͻð�,��5. ����ǥ ���ۡ����� ���ż� �Է³����� ������ �ֽʽÿ�. (<span class="pinktext">�����ڷ�� ���Ϸ� ���ε� �� ��</span>)</li>
        </ul>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent2">
        <ul class="boxcontenthelp lt">
          <li class="boxcontenttitle"><p align="center"><span class="pinktext">���� �ܰ�� �̵��ϱ� ���� "����" ��ư�� ���� �ۼ��Ͻ� ������ �����Ͻñ� �ٶ��ϴ�.</span></p></li>
        </ul>
      </div>

      <div class="fc pt_20"></div>

      <!-- ��ư start -->
      <div class="fr">
        <ul class="lt">
        <%// ���縶������ �����ư ���� / 20180716 / �躸��%>
          <%
          String oStatus = sOentStatus; // ����ǥ ���� ("1")
          if (oStatus.equals("1")) {%>
          <li class="fl pr_2"><a href="#none" onfocus="this.blur()" class="contentbutton2">����Ϸ�</a></li>
          <%}else{%>
          <li class="fl pr_2"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">�� ��</a></li>
          <%} %>
          <li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">ȭ�� �μ��ϱ�</a></li>
          <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="contentbutton2">3. �ϵ��� �ŷ� ��Ȳ���� ����</a></li>
          <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="contentbutton2">5. ����ǥ �������� ����</a></li>
        </ul>
      </div>

      <!-- ��ư end -->

    </div>
    </form>
    <!-- End subcontent  -->

    <!-- Begin Footer -->
    <div id="subfooter"><img src="img/bottom.gif"></div>
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

<script language="JavaScript">
  <%if ( StringUtil.checkNull(request.getParameter("isSaved")).equals("1") ) {%>
    alert("ȸ�簳�䰡 ����Ǿ����ϴ�.")
  <%}%>
</script>

</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>