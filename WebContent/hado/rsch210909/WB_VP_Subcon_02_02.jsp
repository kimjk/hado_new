<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��   : �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���   : WB_VP_Subcon_02_02.jsp
* ���α׷�����  : ���޻���� > �⵵�� ����ǥ > 2015�� �Ǽ��� ����ǥ > �ͻ��� �Ϲ���Ȳ
* ���α׷�����  : 1.0.1
* �����ۼ�����  : 2009�� 05��
* �� �� �� ��       :
*=========================================================
* �ۼ�����      �ۼ��ڸ�        ����
*=========================================================
* 2009-05     ������       �����ۼ�
*   2010-07-20   ������      ������ �⺻��(0) ����
* 2015-07-08  ������       ����ǥ ���� �� �ڵ� ����(StringUtil)
*   2016-01-12  �̿뱤   DB�������� ���� ���ڵ� ����
*/
%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_I_Global.jsp"%>
<%@ include file="../Include/WB_I_chkSession.jsp"%>

<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
  String sErrorMsg = "";  // �����޽���

  String q_Cmd  = StringUtil.checkNull(request.getParameter("mode"));

  String sname  = "";
  String scompgb  = "";
  String scono  = "";
  String scono1 = "";
  String scono2 = "";
  String ssano  = "";
  String ssano1 = "";
  String ssano2 = "";
  String ssano3 = "";
  String scaptine = "";

  String sreggb = "";
  String sregtext = "";
  String zipcode  = "";
//  String zipcode1 = "";
//  String zipcode2 = "";
  String address  = "";
  String semail = "";
  String semail1  = "";
  String semail2  = "";

  String worg   = "";
  String wjikwi = "";
  String wname  = "";
  String wtel   = "";
  String wfax   = "";
  String wdate  = "";

  String reason = "";
  //2015-07-15 / �������ܴ�󿩺� ���� ���� / ������
  String sSentNoExcept = "";      // �������ܴ�󿩺�
  /* �������ܴ�� ��Ÿ���� �߰� 20210915 */
  String sSentNoExceptEtc = "";
  
  /* 2020�⵵ �߰� */
  String sIncorp = "";    //��������
  String sIncorp1 = "";   //������
  String sIncorp2 = "";   //������
  
  String sCompStatus = "";    // ȸ�翵������
  String sQ1Etc = "";       // ȸ�翵������ ��Ÿ�亯
  
  String sSentCapa = "";    // ȸ��Ը�
  String sSentCapaTxt = ""; // ȸ��Ը��Ÿ
  
  String ssale1 = "0";    // �����  -3��
  String ssale2 = "0";    // -2
  String ssale  = "0";    // -1
  
  String soper1 = "0"; // �������
  String soper2 = "0";
  String soper = "0";
  
  String samt1    = "0";    // �ڻ��Ѿ�
  String samt2    = "0";    // 
  String samt   = "0";    //
  
  String sconamt = "0";
  String sconamt1 = "0";
  String sconamt2 = "0";
  
  String sEmpCnt = "0"; // ��ð�������� ��
  String sEmpCnt1 = "0";  // ��ð�������� ��
  String sEmpCnt2 = "0";  // ��ð�������� ��

  // Cookie Request
  String sMngNo = "";
  if( ckMngNo.trim().length() >= 8 ) {
    //sMngNo = ckMngNo.substring(0,8);
      sMngNo = ckMngNo;
  } else if( ckMngNo.trim().length() == 6 ) {
    sMngNo = ckMngNo.substring(0,5);
  } else if ( ckMngNo.trim().length() == 4 ) {
    //sMngNo = ckMngNo.substring(0,3);
      sMngNo = ckMngNo;
  }
  String sOentYYYY = ckCurrentYear;
  String sOentGB = ckOentGB;
  String sOentName = ckOentName;
  String sSentNo = ckSentNo;
  String sSQLs = "";

  /* �ۼ����� ǥ�ø� ���� java Ķ���� ���̺귯�� ���� */
  java.util.Calendar cal = java.util.Calendar.getInstance();

  String loadMngNo    = request.getParameter("loadmngno")==null ? "":request.getParameter("loadmngno").trim();  //������ȣ
  String loadConnCode   = request.getParameter("loadconncode")==null ? "":request.getParameter("loadconncode").trim();  //�����ڵ�
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
  if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
    ConnectionResource resource = null;
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // ���� ����� ���� ��������
    sSQLs="SELECT * FROM HADO_TB_SUBCON_"+sOentYYYY+" \n";
    sSQLs+="WHERE Child_Mng_No='"+ckMngNo+"' \n";
    sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
    sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
    sSQLs+="AND Sent_No="+sSentNo+" \n";
    try {
      resource= new ConnectionResource();
      conn  = resource.getConnection();
      pstmt = conn.prepareStatement(sSQLs);
      rs    = pstmt.executeQuery();

      while (rs.next()) {
        sname   = rs.getString("Sent_Name")==null ? "":rs.getString("Sent_Name");
        scaptine    = rs.getString("Sent_Captine")==null ? "":rs.getString("Sent_Captine");
        /* 20100720 - ������ / NULL �ΰ�� 0���� �⺻�� ���� */
        /* if( rs.getString("Sent_Amt") != null ) {
          samt  = rs.getString("Sent_Amt")==null ? "":rs.getString("Sent_Amt");
        } */
        zipcode   = rs.getString("Zip_Code")==null ? "":rs.getString("Zip_Code");
        /*
        if ( zipcode.length() == 7 ) {
          zipcode1 = zipcode.substring(0, 3);
          zipcode2 = zipcode.substring(4, 7);
        } else if ( zipcode.length() == 6 ) {
          zipcode1 = zipcode.substring(0, 3);
          zipcode2 = zipcode.substring(3, 6);
        }
        */
        address   = rs.getString("Sent_Address")==null ? "":rs.getString("Sent_Address");
        semail    = rs.getString("Assign_Mail")==null ? "":rs.getString("Assign_Mail");
        if ( (semail != null) && (!semail.equals("")) ) {
          if ( semail.indexOf("@") != -1 ) {
            semail1 = semail.substring(0, semail.indexOf("@"));
            semail2 = semail.substring(semail.indexOf("@")+1, semail.length());
          }
        }
        scompgb   = rs.getString("Comp_GB")==null ? "":rs.getString("Comp_GB");
        scono   = rs.getString("Sent_Co_No")==null ? "":rs.getString("Sent_Co_No");
        scono = scono.replaceAll("-", "");
        if( scono.length() == 13 ) {
          scono1  = scono.substring(0,6);
          scono2  = scono.substring(6,13);
        }
        ssano   = rs.getString("Sent_Sa_No")==null ? "":rs.getString("Sent_Sa_No");
        ssano = ssano.replaceAll("-", "");
        if( ssano.length() == 10) {
          ssano1  = ssano.substring(0,3);
          ssano2  = ssano.substring(3,5);
          ssano3  = ssano.substring(5,10);
        }
        if( rs.getString("Sent_Con_Amt") != null ) {
          sconamt = rs.getString("Sent_Con_Amt")==null ? "":rs.getString("Sent_Con_Amt");
        }
        /* 20100720 - ������ / NULL �ΰ�� 0���� �⺻�� ���� * /
        /*if( rs.getString("Sent_Sale") != null ) {
          ssale = rs.getString("Sent_Sale")==null ? "":rs.getString("Sent_Sale");
        } */
        /* 20100720 - ������ / NULL �ΰ�� 0���� �⺻�� ���� * /
        /*if( rs.getString("Sent_Emp_Cnt") != null ) {
          sempcnt = rs.getString("Sent_Emp_Cnt")==null ? "":rs.getString("Sent_Emp_Cnt");
        } */
        sreggb    = rs.getString("Con_Reg_GB")==null ? "":rs.getString("Con_Reg_GB");
        sregtext    = rs.getString("Con_Reg_Text")==null ? "":rs.getString("Con_Reg_Text");
        wname   = rs.getString("Writer_Name")==null ? "":rs.getString("Writer_Name");
        worg    = rs.getString("Writer_ORG")==null ? "":rs.getString("Writer_ORG");
        wjikwi    = rs.getString("Writer_Jikwi")==null ? "":rs.getString("Writer_Jikwi");
        wtel    = rs.getString("Writer_Tel")==null ? "":rs.getString("Writer_Tel");
        wfax    = rs.getString("Writer_Fax")==null ? "":rs.getString("Writer_Fax");
        wdate   = rs.getString("Writer_Date")==null ? "":rs.getString("Writer_Date");
        /* 20140715 - ������ / �������ܴ�� ���й��� ������ ���� */
        sSentNoExcept = rs.getString("SP_FLD_03")==null ? "":rs.getString("SP_FLD_03");
        /* �������ܴ�� ��Ÿ���� �߰� 20210915 */
        sSentNoExceptEtc = rs.getString("SP_FLD_03_ETC")==null ? "":rs.getString("SP_FLD_03_ETC");
        
        /* 2020�� �߰� */
        sIncorp   = rs.getString("Sent_Incorp")==null ? "":rs.getString("Sent_Incorp");
        sCompStatus = rs.getString("comp_status")==null ? "":rs.getString("comp_status");
        sQ1Etc = rs.getString("comp_status_etc")==null ? "":rs.getString("comp_status_etc");
        sSentCapa = rs.getString("sent_capa")==null ? "":rs.getString("sent_capa");
        sSentCapaTxt = rs.getString("sent_capa_etc")==null ? "":rs.getString("sent_capa_etc");
        
        ssale1  = rs.getString("Sent_Sale1")==null ? "":rs.getString("Sent_Sale1");
        ssale2  = rs.getString("Sent_Sale2")==null ? "":rs.getString("Sent_Sale2");
        ssale = rs.getString("Sent_Sale")==null ? "":rs.getString("Sent_Sale");
        
        soper1  = rs.getString("Sent_Oper1")==null ? "":rs.getString("Sent_Oper1");
        soper2  = rs.getString("Sent_Oper2")==null ? "":rs.getString("Sent_Oper2");
        soper = rs.getString("Sent_Oper")==null ? "":rs.getString("Sent_Oper");
        
        samt1 = rs.getString("Sent_Amt1")==null ? "":rs.getString("Sent_Amt1");
        samt2 = rs.getString("Sent_Amt2")==null ? "":rs.getString("Sent_Amt2");
        samt  = rs.getString("Sent_Amt")==null ? "":rs.getString("Sent_Amt");
        
        sconamt1  = rs.getString("SENT_CON_AMT1")==null ? "":rs.getString("SENT_CON_AMT1");
        sconamt2  = rs.getString("SENT_CON_AMT2")==null ? "":rs.getString("SENT_CON_AMT2");
        sconamt = rs.getString("SENT_CON_AMT")==null ? "":rs.getString("SENT_CON_AMT");
        
        sEmpCnt = rs.getString("Sent_Emp_Cnt")==null ? "":rs.getString("Sent_Emp_Cnt");
        sEmpCnt1  = rs.getString("Sent_Emp_Cnt1")==null ? "":rs.getString("Sent_Emp_Cnt1");
        sEmpCnt2  = rs.getString("Sent_Emp_Cnt2")==null ? "":rs.getString("Sent_Emp_Cnt2");
        
        /* �������� */
        String[] arrTmpIncorp = sIncorp.split("-");
        if( arrTmpIncorp.length==2 ) {
          sIncorp1 = arrTmpIncorp[0];
          sIncorp2 = arrTmpIncorp[1];
        }
      }
      rs.close();
    } catch(Exception e){
      e.printStackTrace();
    } finally {
      if (rs != null)   try{rs.close();}  catch(Exception e){}
      if (pstmt != null)  try{pstmt.close();} catch(Exception e){}
      if (conn != null) try{conn.close();}  catch(Exception e){}
      if (resource != null) resource.release();
    }

    // �ϵ��޹��� ������� �ʴ� ���� - 15�⵵���� �������ܴ�� ������ ����
    sSQLs="SELECT SUBJ_ANS FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
    sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
    sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
    sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
    sSQLs+="AND Sent_No="+sSentNo+" \n";
    sSQLs+="AND SOENT_Q_CD=30 AND SOENT_Q_GB=1 \n";
    try {
      resource= new ConnectionResource();
      conn  = resource.getConnection();
      pstmt = conn.prepareStatement(sSQLs);
      rs    = pstmt.executeQuery();

      while (rs.next()) {
        reason = rs.getString("SUBJ_ANS")==null ? "":rs.getString("SUBJ_ANS");
      }
      rs.close();
    } catch(Exception e){
      e.printStackTrace();
    } finally {
      if (rs != null)   try{rs.close();}  catch(Exception e){}
      if (pstmt != null)  try{pstmt.close();} catch(Exception e){}
      if (conn != null) try{conn.close();}  catch(Exception e){}
      if (resource != null) resource.release();
    }
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
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta http-equiv='Cache-Control' content='no-cache'>
    <meta http-equiv='Pragma' content='no-cache'>
  <meta charset="euc-kr">
  <title><%=st_Current_Year_n %>�⵵ �ϵ��ްŷ� ������� ����</title>

  <link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="euc-kr" />
  <link rel="stylesheet" href="style.css" type="text/css">
  <script src="../js/jquery-1.7.min.js"></script>
    <script type="text/javascript">jQuery.noConflict();</script>
    <script src="../js/mootools-core-1.3.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/mootools-more-1.3.1.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/simplemodal.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/commonScript.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/login_2019.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/credian_common_script.js" type="text/javascript"  charset="euc-kr"></script>

  <script type="text/JavaScript">
  //<![CDATA[
    ns4 = (document.layers)? true:false
    ie4 = (document.all)? true:false

    var msg = "";

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

    //�Ϲ���Ȳ �ҷ����� �Լ�
    function loadf(){
      msg="";
      var main = document.info;

      if(main.loadmngno.value=="") msg=msg+"\n������ȣ�� �Է��� �ּ���.";
      if(main.loadconncode.value=="") msg=msg+"\n�����ڵ带 �Է��� �ּ���.";

      if(msg!="") msg=msg+"\n";

      if(msg=="") {
        if(confirm("�Ϲ���Ȳ ������ �ҷ��ɴϴ�.")) {
          //document.getElementById("loadingImage").style.display="";

          main.target = "ProceFrame";
          main.action = "WP_Comp_Info_Load.jsp";
          main.submit();
        }
      } else {
        alert(msg+"\n\n�������⸦ �ߴ��մϴ�.")
      }
    }

	function savef(){
		msg="";
		var main = document.info;

        // ���� üũ.
        <%-- if(main.rcomp.value=="") msg=msg+"\nȸ����� �Է��� �ּ���.";
        if(main.rcogb[0].checked!=true&&main.rcogb[1].checked!=true) {
          // ���޻���� �ʼ� �׸� ����
          <%
          //msg=msg+"\n���ε�Ͽ��θ� �Է����ּ���.";
          %>
        } else {
          if(main.rcogb[0].checked==true) {
            if(main.rlawno1.value=="" || main.rlawno2.value=="") {
              // ���޻���� �ʼ� �׸� ����
              <%
              //msg=msg+"\n���ε�Ϲ�ȣ�� �Է��� �ּ���.";
              %>
            } else {
              main.rlawno.value = main.rlawno1.value+"-"+main.rlawno2.value;
            }
          }
        }
  
        if(main.rregno1.value=="" || main.rregno2.value=="" || main.rregno3.value=="") {
          // ���޻���� �ʼ� �׸� ����
          <%
          //msg=msg+"\n����ڵ�Ϲ�ȣ�� �Է��� �ּ���.";
          %>
        } else {
          main.rregno.value = main.rregno1.value+"-"+main.rregno2.value+"-"+main.rregno3.value;
        }
  
        <%
        /* ���޻���� �ʼ� �׸� ����
        if(main.rowner.value=="")   msg=msg+"\n��ǥ�� ������ �Է����ּ���.";
        
        if(main.rsale.value=="")    msg=msg+"\n���� ������� �Է����ּ���.";
        if(main.rasset.value=="")   msg=msg+"\n�ڻ��Ѿ��� �Է����ּ���.";
        if(main.rempcnt.value=="")  msg=msg+"\n������������� �Է����ּ���.";
        if(main.raddr.value=="")    msg=msg+"\n���� �������� �Է��� �ּ���.";
  
        if(main.rposition.value=="")  msg=msg+"\n�ۼ�å���� ������ �Է��� �ּ���.";
        if(main.rname.value=="")    msg=msg+"\n�ۼ�å���� ������ �Է��� �ּ���.";
        if(main.rtel.value=="")     msg=msg+"\n�ۼ�å���� ��ȭ��ȣ�� �Է��� �ּ���.";
        if(main.remail1.value=="" || main.remail2.value=="") msg=msg+"\n�ۼ�å���� E-mail�ּҸ� �Է��� �ּ���.";
        */%> --%>
      
		if(main.rcomp.value=="") msg=msg+"\nȸ����� �Է��� �ּ���.";
        if(main.rcogb[0].checked!=true && main.rcogb[1].checked!=true){
            msg=msg+"\n���ε�Ͽ��θ� �Է����ּ���.";
        } else {
            if(main.rcogb[0].checked==true) {
                if(main.rlawno1.value=="" || main.rlawno2.value==""){
                  msg=msg+"\n���ε�Ϲ�ȣ�� �Է��� �ּ���.";
                } else {
                  main.rlawno.value = main.rlawno1.value + "-" + main.rlawno2.value;
                }
            }
        } 
        if(main.rregno1.value=="" || main.rregno2.value=="" || main.rregno3.value==""){
            msg=msg+"\n����ڵ�Ϲ�ȣ�� �Է��� �ּ���.";
        } else {
            main.rregno.value = main.rregno1.value+"-"+main.rregno2.value+"-"+main.rregno3.value;
        }
        
        if(main.rowner.value=="") msg=msg+"\n��ǥ�� ������ �Է����ּ���.";
        if(main.rincorp1.value=="" || main.rincorp2.value=="") msg=msg+"\n�����⵵�� �Է����ּ���.";
      	if(main.raddr.value=="") msg=msg+"\n���� �������� �Է��� �ּ���.";
        
        var cstatus = jQuery("input:radio[name='q1']:checked").val();
      	if( cstatus!="1" ) {
        if(!jQuery("input:radio[name='q0']").is(":checked")) {
			msg += "\n���󿵾��� �ƴѰ�� �������� ��� �׸��� �������ּ���.";
			}
      	}
          
		if(msg!="") msg+="\n";

      	//���ܴ�� �׸��� ������ ��� ȸ�簳�丸 �Է��ϵ��� ó��
        if(!jQuery("input:radio[name='q0']").is(":checked")) {
            researchf(main.q1,2,"ȸ�簳���� 1�� �������¸� �������ּ���");
            researchf(main.q2,2,"ȸ�簳���� 2�� ȸ��Ը� �������ּ���");
            researchf(main.q3_3,1,"ȸ�簳���� 3�� <%=st_Current_Year_n-3%>�� ������� �Է����ּ���");
            researchf(main.q3_1,1,"ȸ�簳���� 3�� <%=st_Current_Year_n-2%>�� ������� �Է����ּ���");
            researchf(main.q3_2,1,"ȸ�簳���� 3�� <%=st_Current_Year_n-1%>�� ������� �Է����ּ���");
            researchf(main.q3_4,1,"ȸ�簳���� 3�� <%=st_Current_Year_n-3%>�� ��������� �Է����ּ���");
            researchf(main.q3_5,1,"ȸ�簳���� 3�� <%=st_Current_Year_n-2%>�� ��������� �Է����ּ���");
            researchf(main.q3_6,1,"ȸ�簳���� 3�� <%=st_Current_Year_n-1%>�� ��������� �Է����ּ���");
            researchf(main.q3_7,1,"ȸ�簳���� 3�� <%=st_Current_Year_n-3%>�� �ڻ��Ѿ��� �Է����ּ���");
            researchf(main.q3_8,1,"ȸ�簳���� 3�� <%=st_Current_Year_n-2%>�� �ڻ��Ѿ��� �Է����ּ���");
            researchf(main.q3_9,1,"ȸ�簳���� 3�� <%=st_Current_Year_n-1%>�� �ڻ��Ѿ��� �Է����ּ���");
            researchf(main.q3_10,1,"ȸ�簳���� 3�� <%=st_Current_Year_n-3%>�� �ð��ɷ��򰡾��� �Է����ּ���");
            researchf(main.q3_11,1,"ȸ�簳���� 3�� <%=st_Current_Year_n-2%>�� �ð��ɷ��򰡾��� �Է����ּ���");
            researchf(main.q3_12,1,"ȸ�簳���� 3�� <%=st_Current_Year_n-1%>�� �ð��ɷ��򰡾��� �Է����ּ���");
            researchf(main.q4,1,"ȸ�簳���� 4�� �ѱ� ���ڼ��� �Է����ּ���");
            researchf(main.q4_1,1,"ȸ�簳���� 4�� ��� �ٷ��ڼ��� �Է����ּ���");
            researchf(main.q4_2,1,"ȸ�簳���� 4�� �ӽ� �� �Ͽ� �ٷ��ڼ��� �Է����ּ���");
        }

      	if(msg=="") {
        	if(confirm("[ �ͻ��� �Ϲ���Ȳ�� �����մϴ�. ]\n\n�����ڰ� ������� �ټ� �ð��� �ɸ����� �ֽ��ϴ�.\n���������� ������ �ȵɰ��\n���ʺ��Ŀ� �ٽýõ��Ͽ� �ֽʽÿ�.\n\n������ ���Ϸ� ���忡 �����Ұ��\n�����Ͻ� ���系���� ������ �� �����ϴ�.\n�����Ͻ� ����ǥ�� �μ��Ͽ� �����Ͻð�\n�������������� ���콺������ ��ư�� ����\n���ΰ�ħ�� �����Ͽ� �������� �õ��Ͻʽÿ�.\n\nȮ���� �����ø� �����մϴ�.")) {
              //document.getElementById("loadingImage").style.display="";
              //main.target = "ProceFrame";
              processSystemStart("[1/1] �Է��� ȸ�簳�並 �����մϴ�.");
              main.action = "WB_CP_Subcon_Qry.jsp?type=Srv&step=Basic";
              main.submit();
        	}
      	} else {
        	alert(msg+"\n\n������ ��ҵǾ����ϴ�.")
      	}
    }

    function researchf(obj,type,mm){
      var ccheck="no", i
      switch (type){
        case 1:
          if(obj.value=="") msg=msg+"\n"+mm
          break;
        case 2:
          for(i=0;i<obj.length;i++)
            if(obj[i].checked==true) ccheck="yes";

          if(ccheck=="no") msg=msg+"\n"+mm;
          break;
        }

    }

    function formatmoney(m){
      var money, pmoney, mlength, z, textsize, i
      textsize=20
      pmoney=""
      z=0
      money=m
      money=clearstring(money)
      money=Number(money)
      money=money+""

      for(i=money.length-1;i>=0;i--){
        z=z+1
        if(z%3==0) {
          pmoney=money.substr(i,1)+pmoney
          if(i!=0)  pmoney=","+pmoney
        }
   else pmoney=money.substr(i,1)+pmoney
      }
      return pmoney
    }

    function clearstring(s){
      var pstr, sstr, iz
      sstr=s
      pstr=""
      for(iz=0;iz<sstr.length;iz++){
        if(!isNaN(sstr.substr(iz,1))||sstr.substr(iz,1)==".") pstr=pstr+sstr.substr(iz,1)
      }
      return pstr
    }


    function HelpWindow(url, w, h){
      helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=no,scrollbars=no,resize=no,menubar=no,location=no");
      helpwindow.focus();
    }

    function HelpWindow2(url, w, h){
      helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
      helpwindow.focus();
    }

    function fMoveTo(url){
      if(confirm("�����ܰ���� �̵��� �����ϼ̽��ϴ�.\n\n�����Ͻ� ����� ���� ���� �� ������ ������\n�������� �ʰ� �̵��մϴ�.\n������ ������ ������� ���� �� �����Ͻʽÿ�.\n\nȮ���� �����ø� �̵��մϴ�.")) {
        location.href = url;
      }
    }

    function fSubmitFile(url){
      if(confirm("����ǥ �������� �̵��մϴ�.\n\n�����Ͻ� ����� ���� ���� �� ������ ������\n�������� �ʰ� �̵��մϴ�.\n������ ������ ������� ���� �� �����Ͻʽÿ�.\n\nȮ���� �����ø� �̵��մϴ�.")) {
        location.href = url;
      }
    }

    function OpenPost(){
      MsgWindow = window.open("WB_Find_Zip.jsp?ITEM=F&stype=nomr","_PostSerch","toolbar=no,width=430,height=320,directories=no,status=yes,scrollbars=yes,resize=no,menubar=no");
    }

    function byteLengCheck(frmobj, maxlength, objname, divname){
      var nbyte = 0;
      var nlen = 0;

      for(i = 0; i < frmobj.value.length; i++) {
        if(escape(frmobj.value.charAt(i)).length > 4) {
          nbyte += 2;
        } else {
          nbyte++;
        }

        if(nbyte <= maxlength) {
          nlen = i+1;
        }
      }

      obj = document.getElementById(divname);
      obj.innerText = nbyte+"/"+maxlength+"byte";

      if(nbyte > maxlength) {
        alert("�ִ� ���� �Է¼��� �ʰ� �Ͽ����ϴ�.");
        frmobj.value = frmobj.value.substr(0,nlen);
        obj.innerText = maxlength+"/"+maxlength+"byte";
      }

      frmobj.focus();
    }


    function erase8(){
      main = document.info;
      for(ni=0;ni<4;ni++) {
        document.info.q8[ni].checked = false;
      }
    }

    function check7(){
      main = document.info;
      if( main.q7[0].checked == true || main.q7[3].checked == true ) {
        alert("7. �ͻ��� �ϵ��ްŷ� ���� ������ Ȯ�� �� �ּ���");
        for(ni=0;ni<4;ni++) {
          erase8();
        }
      }
    }

    //2015-07-18 /������/ȭ�� �μ�� �� â���� ���
    function goPrint(){
      url = "WB_VP_Subcon_02_02.jsp?mode=print";
      w = 1024;
      h = 768;
      //HelpWindow2(url, w, h);

      if(confirm("ȭ�� �μ�� ����ǥ ���� �Ŀ� �����մϴ�.\n\n�μ��Ͻðڽ��ϱ�?\n[Ȯ��]�� �����ø� �μ�˴ϴ�."));{
        HelpWindow2(url, w, h);
      }
    }

    function doPrint(){
      print();
    }

    function moveNext(url){
      if(confirm("�����ܰ���� �̵��� �����ϼ̽��ϴ�.\n\n�����Ͻ� ����� ���� ���� �� ������ ������\n�������� �ʰ� �̵��մϴ�.\n������ ������ ������� ���� �� �����Ͻʽÿ�.\n\nȮ���� �����ø� �̵��մϴ�.")) {
        location.href = url;
      }
    }

    function onDocumentInit() {
      //
    }
    
    function total(){
        var main = document.info;
        var q4 = 0;
        var q4_1 = kreplace(main.q4_1.value, ",", "");
        var q4_2 = kreplace(main.q4_2.value, ",", ""); 
        
    //  if(isNaN(Number(q4_1))){ q4_1 = 0;}
    //  if(isNaN(Number(q4_2))){ q4_2 = 0;}
        
        q4 = Number(q4_1) + Number(q4_2);
        main.q4.value = suwithcomma(new String(q4));
    }

    var beforeChecked = -1;
      jQuery(function(){
          jQuery(document).on("click", "input[type=radio]", function(e){
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

<% if (q_Cmd.equals("print")) { %>
<body onload="doPrint();">
<% } else { %>
<body onLoad="onDocumentInit();">
<% } %>

<div id="container">
  <div id="wrapper">

    <!-- Begin Header -->
    <div id="subheader">
      <ul class="lt">
        <li class="fl"><a href="/" onfocus="this.blur()"><img src="img/logo.jpg" width="242" height="55"></a></li>
        <li class="fr">
          <ul class="lt">
            <li class="pt_20"><font color="#FF6600">[
              <% if( ckOentGB.equals("1") ) {%>������
              <% } else if( ckOentGB.equals("2") ) {%>�Ǽ���
              <% } else if( ckOentGB.equals("3") ) {%>�뿪��<% } %>]</font>
              <%=ckOentName%>&nbsp;/&nbsp;<%=ckSentName%><iframe src="/Include/WB_FP_sessionClock.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" align="center" frameborder="0"></iframe></li>
          </ul>
        </li>
      </ul>
    </div>

    <div id="submenu">
      <ul class="lt fr">
        <li class="fl pr_2"><a href="../rsch210909/WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="mainmenu">1. ����ȳ�</a></li>
        <li class="fl pr_2"><a href="../rsch210909/WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenuup">2. �ͻ��� �Ϲ���Ȳ</a></li>
        <li class="fl pr_2"><a href="../rsch210909/WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. �ϵ��� �ŷ� ��Ȳ</a></li>
        <li class="fl pr_2"><a href="../rsch210909/WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="mainmenu">4. ����ǥ ����</a></li>
        <li class="fl pr_2"><a href="../rsch210909/WB_VP_Subcon_Add.jsp" onfocus="this.blur()" class="mainmenu">5. �߰� ����</a></li>
      </ul>
    </div>
    <!-- End Header -->

    <form action="" method="post" name="info">
    <!-- Begin subcontent -->
    <div id="subcontent">
      <!-- title start -->
      <h1 class="contenttitle">2. �ͻ��� �Ϲ���Ȳ</h1>
      <!-- title end -->
            <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="lt">
            <li class="boxcontenttitle"><font color="#999999">����ǥ�� 2�� �̻� �ۼ��Ͻô� ��� Tip</font></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt clt">
            <li><font style="font-weight:bold;" color="#ff6600">������ ������ڰ� 2�� �̻��� ���</font>���� �̹� <font style="font-weight:bold;" color="#ff6600">�Է��Ͻ� �ͻ� �Ϲ���Ȳ ������ ����</font>�Ͻ� �� �ֽ��ϴ�. �̹� �Է��Ͻ� ������ �ִ� ��� <font style="font-weight:bold;" color="#ff6600">������ �Է��Ͻ� ������ȣ �� �����ڵ�(��4�ڸ�)�� �Է�</font> �� <b>[�Ϲ���Ȳ ���� ��������]</b> ��ư�� Ŭ���Ͻʽÿ�.</li>
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="" />
                  <col style="" />
                  <col style="" />
                </colgroup>
                <tbody>
                <tr>
                  <td>������ȣ :
                      <input type="text" name="loadmngno" value="<%=loadMngNo%>" maxlength="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></td>
                  <td>�����ڵ� :
                      <font style="font-weight:bold;">******</font><input type="password" name="loadconncode" value="<%=loadConnCode%>" maxlength="4" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';"></td>
                  <td><a href="javascript:loadf();" onfocus="this.blur()" class="contentbutton2">�Ϲ���Ȳ ���� ��������</a></li>
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
            <li class="boxcontenttitle">ȸ�簳��</li>
            <li class="boxcontentsubtitle">* ȸ����� ������� �Է�<br/>
            &nbsp;&nbsp;&nbsp;- �Է¿���) (��) ȸ �� �� <font color="#FF0066">(X)</font> --> (��)ȸ��� <font color="#FF0066">(0)</font><br/>
            * ����ڵ������ ��õ� ȸ���(�ѱ�/����)���� ����.</li>
            <li class="boxcontentsubtitle"><font color="#FF0066">* ���� �����, �ڻ��Ѿ� ������ <strong><u>�鸸��</u></strong> ��</font></li>
            <li class="boxcontentsubtitle">* �������� �����ȣ �˻� �� ���ּҸ� �߰��� �Է�<br/>
              &nbsp;&nbsp;&nbsp;�ϼ���.</li>
            <li class="boxcontentsubtitle">* ��ȭ��ȣ �Է� ��: 02-123-4567 (��ǥ��ȭ 1�� �Է�)</li>
            <li class="boxcontentsubtitle">* �ѽ���ȣ ��ǥ��ȣ 1���� �Է�.</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
                        <li><span>�� </span>�� ��������� �ͻ��� <strong><u>�繫��Ȳ�� �ϵ��ްŷ���Ȳ�� ���������� �� �ľ��ϰ� �ִ� �����ǥ �Ǵ� ȸ��</u> &nbsp;&nbsp;&nbsp;<u>å���ڸ�</u></strong> ������� �ϰ� �ֽ��ϴ�.</li>
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
                    <td><input type="text" name="rcomp" value="<%=sname%>" maxlength="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input></td>
                  </tr>
                  <tr>
                    <th>���ο���</th>
                    <td>
                      <input type="radio" name="rcogb" value="1" <%if(scompgb!=null && scompgb.equals("1")){out.print("checked");}%>></input>����
                      <input type="radio" name="rcogb" value="0" <%if(scompgb!=null && scompgb.equals("0")){out.print("checked");}%>></input>�����
                    </td>
                    <th>���ε�Ϲ�ȣ</th>
                    <td><input type="hidden" name="rlawno" value="<%=scono%>"></input>
                      <input type="text" name="rlawno1" value="<%=scono1%>" maxlength="6" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="onlyNumeric(this); fnextTextMove('rlawno1',6,'rlawno2');"></input>-
                      <input type="text" name="rlawno2" value="<%=scono2%>" maxlength="7" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="onlyNumeric(this);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th>��������</th>
                    <td><input type="hidden" name="rincorp" value="<%=sIncorp%>"></input>
                      <input type="text" name="rincorp1" value="<%=sIncorp1%>" maxlength="4" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rincorp1',4,'rincorp2');"></input>��
                      <input type="text" name="rincorp2" value="<%=sIncorp2%>" maxlength="2" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="isMonth(this);"></input>��
                    </td>
                    <th>����ڵ�Ϲ�ȣ</th>
                    <td><input type="hidden" name="rregno" value="<%=ssano%>"></input>
                      <input type="text" name="rregno1" value="<%=ssano1%>" maxlength="3" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="onlyNumeric(this); fnextTextMove('rregno1',3,'rregno2');"></input>-
                      <input type="text" name="rregno2" value="<%=ssano2%>" maxlength="2" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="onlyNumeric(this); fnextTextMove('rregno2',2,'rregno3');"></input>-
                      <input type="text" name="rregno3" value="<%=ssano3%>" maxlength="5" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="onlyNumeric(this);"></input>
                    </td>
                  </tr>
                  <tr>
                    <th>��ǥ��</th>
                    <td colspan="3">
                      <input type="text" name="rowner" value="<%=scaptine%>" maxlength="16" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
                      <%-- <input type="hidden" name="roenttype" value="<%=sOentType%>"/> --%>
                    </td>
                    <%-- <th>����з��ڵ�</th>
                    <td>
                      <input type="text" name="roenttype" value="<%=sOentType%>" maxlength="5" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
                    </td> --%>
                  </tr>
                  <tr>
                    <th rowspan="3">����</th>
                    <td colspan="3">�����ȣ : <input type="text" name="rpost" value="<%=zipcode%>" class="text03b"></input>&nbsp;&nbsp;<a href="javascript:OpenPost();"><img src="img/btn_post.gif" border="0" alt="�����ȣ ã��" align="absmiddle"></img></a></td>
                  </tr>
                  <tr>
                    <td colspan="3">��  ��  �� : <input type="text" name="raddr" value="<%=address%>" maxlength="76" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <td colspan="3">��ȭ��ȣ(������ȣ ����) : <input type="text" name="rtel" value="<%=wtel%>" maxlength="20" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input></td>
                  </tr>
                  <%-- <tr>
                    <th>����ǥ�ۼ���</th>
                    <td colspan="3">
                      <%if ( wdate==null || wdate.equals("") ) {%>
                        <%=cal.get(Calendar.YEAR)%>�� <%=cal.get(Calendar.MONTH)+1%>�� <%=cal.get(Calendar.DATE)%>��
                      <%} else {%><%=wdate%><%}%>
                    </td>
                  </tr> --%>
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
            <li class="boxcontenttitle"><span>1. </span>�ͻ��� <%=st_Current_Year_n-1%>�⵵ 12�� �� ���� ���� ���´� ��մϱ�?</li>
          </ul>
        </div>
        <div class="boxcontentright">
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
            <li class="boxcontenttitle"><span>2. </span>�ͻ��� <%=st_Current_Year_n-1%>�⵵ 12�� �� ���� ȸ��Ը�� �����Դϱ�?</li>
            <li class="boxcontentsubtitle">* �߰߱���� �߰߱���� ��2����1ȣ�� ������ �ش��ϴ� ȸ����</li>
            <li class="boxcontentsubtitle">* �߼ұ���� �߼ұ���⺻�� ��2���� ������ �ش��ϴ� ȸ����</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <input type="radio" name="q2" value="1" <%if(sSentCapa!=null && sSentCapa.equals("1")){out.print("checked");}%>></input> 1. (����� 2���� �ʰ�) ��Ը� �߰߱��<br/>
              <input type="radio" name="q2" value="2" <%if(sSentCapa!=null && sSentCapa.equals("2")){out.print("checked");}%>></input> 2. (����� 3,000���~2���� �̸�) �߰߱��<br/>
              <input type="radio" name="q2" value="3" <%if(sSentCapa!=null && sSentCapa.equals("3")){out.print("checked");}%>></input> 3. (����� 800~3,000��� �̸�) �ұԸ� �߰߱��<br/>
              <input type="radio" name="q2" value="4" <%if(sSentCapa!=null && sSentCapa.equals("4")){out.print("checked");}%>></input> 4. �߼ұ��(�߱�����ұ�����һ����)<br/>
              <%-- <input type="radio" name="q2" value="5" <%if(sSentCapa!=null && sSentCapa.equals("5")){out.print("checked");}%>></input> 5. ��Ÿ(<input type="text" name="q2Etc" value="<%=sSentCapaTxt%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li> --%>
            </li>
            <div class="fc pt_30"></div>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>3. </span>�ͻ��� ���� 3�Ⱓ(<%=st_Current_Year_n-3%>��~<%=st_Current_Year_n-1%>��) �����, �������, �ڻ��Ѿ� �� �ð��ɷ��򰡾��� �������ֽʽÿ�.</li>
            <li class="boxcontentsubtitle">* ��������� �������, �ΰǺ�, ������, ���ݰ�����, �����󰢺� �� ����Ȱ���� �ҿ�� ����� �����ϸ�, ���Ͱ�꼭 �� ��������� �Ǹź�װ������� ������ �����.</li>
            <li class="boxcontentsubtitle">* ��������� ��� ������ ���õ� ����鿡 ��κ� ���ԵǴ� ������. ���������� ���Ǵ� ��������(��Ȳ�� �ľ��ϴ� ����)���� ���� ������. (�ϵ��޹� ���ݰ��� ��� ����)</li>
            <li class="boxcontentsubtitle">* ��������� ���Ͱ�꼭�� �ִ� �ڷ� �������� �Է��ϵ�, ���������  ���ϱ� ������ �뷫���� �ݾ����� ����</li>
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
                    <th><%= st_Current_Year_n-3%>�⵵</th>
                    <td><input type="text" name="q3_1" value="<%=ssale1%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount003');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount003" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= st_Current_Year_n-2%>�⵵</th>
                    <td><input type="text" name="q3_2" value="<%=ssale2%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount001');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount001" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= st_Current_Year_n-1%>�⵵</th>
                    <td><input type="text" name="q3_3" value="<%=ssale%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount002');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
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
                    <th><%= st_Current_Year_n-3%>�⵵</th>
                    <td><input type="text" name="q3_4" value="<%=soper1%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount004');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount004" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= st_Current_Year_n-2%>�⵵</th>
                    <td><input type="text" name="q3_5" value="<%=soper2%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount005');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount005" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= st_Current_Year_n-1%>�⵵</th>
                    <td><input type="text" name="q3_6" value="<%=soper%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount006');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
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
                    <th><%= st_Current_Year_n-3%>�⵵</th>
                    <td><input type="text" name="q3_7" value="<%=samt1%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount007');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount007" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= st_Current_Year_n-2%>�⵵</th>
                    <td><input type="text" name="q3_8" value="<%=samt2%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount008');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount008" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= st_Current_Year_n-1%>�⵵</th>
                    <td><input type="text" name="q3_9" value="<%=samt%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount009');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount009" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
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
                    <th colspan="2">�ð��ɷ��򰡾�</th>
                  </tr>
                  <tr align="center">
                    <th><%= st_Current_Year_n-3%>�⵵</th>
                    <td><input type="text" name="q3_10" value="<%=sconamt1%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount0010');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount0010" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= st_Current_Year_n-2%>�⵵</th>
                    <td><input type="text" name="q3_11" value="<%=sconamt2%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount0011');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount0011" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= st_Current_Year_n-1%>�⵵</th>
                    <td><input type="text" name="q3_12" value="<%=sconamt%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount0012');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
                      <div id="hanAmount0012" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
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
            <li class="boxcontenttitle"><span>4. </span><%= st_Current_Year_n-1%>�� 12�� �� ����, �ͻ��� ��������� ���� ������ �ֽʽÿ�.</li>
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
                      <input type="text" name="q4" id="q4" readonly="readonly" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=sEmpCnt%>" size="6"></input> ��
                    </td>
                  </tr>
                  <tr align="center">
                    <th>��� �ٷ���</th>
                    <td>
                      <input type="text" name="q4_1" id="q4_1" onkeyup ="sukeyup(this); total();" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=sEmpCnt1%>" size="6"></input> ��
                    </td>
                  </tr>
                  <tr align="center">
                    <th>�ӽ� �� �Ͽ� �ٷ���</th>
                    <td>
                      <input type="text" name="q4_2" id="q4_2" onkeyup ="sukeyup(this); total();" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=sEmpCnt2%>" size="6"></input> ��
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
      
            <div class="boxcontent">
              <div class="boxcontentleft">
                <ul class="lt">
                  <li class="boxcontenttitle">�������� �ȳ�</li>
                </ul>
              </div>
              <div class="boxcontentright">
                <ul class="clt">
                  <li><span>�� </span>���� �ͻ�� ������ ������ڿ��� �ŷ����谡 <strong>�Ʒ� ������ �ش�</strong>�� ���, �ͻ�� <strong>���� ��󿡼� ���ܵ˴ϴ�.</strong></li>
                  <div class="fc pt_5"></div>
                  <li>
                    <table class="tbl_blue">
                      <colgroup>
                        <col style="width:40%;" />
                        <col style="width:60%;" />
                      </colgroup>
                      <thead>
                        <tr>
                          <th>���� ���� ���</th>
                          <th>��ü�� ���</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td>�� �ͻ簡 "�ϵ��޹����� ���޻����" <br/>&nbsp;&nbsp;&nbsp;
                          ��ǿ� �ش���� �ʴ� ���</td>
                          <td>���ͻ簡 �����ŷ������� <strong>����</strong>�� ���<br/>
                                                  ���ͻ簡 �߼ұ���̰�, �ͻ��� ���� �����(2020�� ����)�� ���� &nbsp;&nbsp;&nbsp;��� ��������� ���� ����׿� ���� ū ���</td>
                        </tr>
                        <tr>
                          <td>�� �ϵ��ްŷ��� �ƴ� ���</td>
                          <td>���������� �Ǹ��ϴ� �ܼ� <strong>�Ÿ�����</strong></font><br/>
                              �������� ������ڷκ��� ��Ź���� �������� �������� �ʰ� &nbsp;&nbsp;&nbsp;<strong>�ܼ� ����</strong>�Ͽ� <strong>��ǰ</strong>�ϴ� ��� ��</td>
                        </tr>
                        <tr>
                          <td>�� �ͻ簡 �ϵ����� �ֱ⸸ �ϴ� ���</td>
                          <td>���ϵ����� �ֱ⸸�ϴ� ���� ������ڿ� �ش�ǹǷ�,<br/>&nbsp;&nbsp;&nbsp;���޻���ڷ� �� �� ����</td>
                        </tr>
                        <tr>
                          <td>�� �ϵ����� ������ ������ �ʴ� ���<br/>&nbsp;&nbsp;&nbsp;(�ϵ��ްŷ� ����)</td>
                          <td>���ϵ��ްŷ��� ���� ����̹Ƿ� �ϵ��޹��� ������� ����</td>
                        </tr>
                          <tr>
                            <td>�� �ͻ簡 ����� ���</td>
                            <td>������ ������ ���� �ʰ� ����� ���</td>
                          </tr>
                          <tr>
                            <td>�� ��Ÿ����</td>
                            <td>��(��ü�� ���� ���)</td>
                          </tr>                                    
                      </tbody>
                    </table>
                  </li>
                  
                  <div class="fc pt_10"></div>            
      
                  <li><span>��</span><strong>���ܴ�� �׸� ���� (��1)</strong></li>
                  <li><input type="radio" name="q0" value="1" <%if(sSentNoExcept!=null && sSentNoExcept.equals("1")){out.print("checked");}%>></input> 1. �ͻ簡 "�ϵ��޹����� ���޻����" ��ǿ� �ش���� �ʴ� ���</li>
                  <li><input type="radio" name="q0" value="2" <%if(sSentNoExcept!=null && sSentNoExcept.equals("2")){out.print("checked");}%>></input> 2. �ϵ��ްŷ��� �ƴ� ���</li>
                  <li><input type="radio" name="q0" value="3" <%if(sSentNoExcept!=null && sSentNoExcept.equals("3")){out.print("checked");}%>></input> 3. �ͻ簡 �ϵ����� �ֱ⸸ �ϴ� ���</li>
                  <li><input type="radio" name="q0" value="4" <%if(sSentNoExcept!=null && sSentNoExcept.equals("4")){out.print("checked");}%>></input> 4. �ϵ����� ������ ������ �ʴ� ��� (�ϵ��ްŷ� ����)</li>
                  <li><input type="radio" name="q0" value="5" <%if(sSentNoExcept!=null && sSentNoExcept.equals("5")){out.print("checked");}%>></input> 5. �ͻ簡 ����� ���</li>
                  <li><input type="radio" name="q0" value="6" <%if(sSentNoExcept!=null && sSentNoExcept.equals("6")){out.print("checked");}%>></input> 6. ��Ÿ����(<input type="text" name="q0Etc" value="<%=sSentNoExceptEtc%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li></li>
                  <li></li>            
                  
                  <div class="fc pt_10"></div>
                  <!--2015-05-07 / �������ܴ�󿩺� Ȯ�� ���� �߰� / ������ -->
                  <li><span>�� </span>�ͻ簡 <strong>�� ������ �ش�</strong> �ȴٰ� �Ǵܵǽ� ��쿡��, �ش�Ǵ� �������� ��� �׸��� �����Ͽ� �ֽð�, �����Ͻ� �� <strong>��4. ����ǥ ���ۡ�</strong>������ ���ż� ����ǥ ���� ��ư�� ������ �ֽñ� �ٶ��ϴ�.</li>
                  <div class="fc pt_10"></div>
                  <%-- <li>�� ��, �ϵ��޹��� ������� �ʴ� ������ ����</li>
                  <ul class="lt"><input type="hidden" name="rnoexptVal" value="<%=sSentNoExcept%>"/>
                    <li><textarea cols="80" rows="4" maxlength="600" name="reason" class="textarea01b" placeholder="��: ����޻���� ��ǿ� �ش���� ���� ��ܼ� ���Ť��Ÿ� ���� ���ϵ����� �ֱ⸸ ��  ���ϵ��ްŷ� ���� ��" onFocus="javascript:this.className='textarea01o';" onBlur="javascript:this.className='textarea01b';" onkeyup="byteLengCheck(this, 600, this.name,'content_bytes1');"><%=StringUtil.checkNull(reason)%></textarea></li>
                  <li class="fr"><p align="right" style="margin-right:40px;"><span id="content_bytes1">0/600 byte</span></p></td></li> --%>
                  </ul>
                </ul>
              </div>
              
              <div class="fc"></div>
            </div>
            
            <div class="fc pt_10"></div>      

      <div class="boxcontent2">
        <ul class="boxcontenthelp clt" style="padding-left:20px;">
          <li class="boxcontenttitle"><span>��</span>�ͻ簡 �� ����ڿ��� �ŷ� ���谡 �ϵ��ްŷ��� �ش�Ǵ� ��쿡�� ���� �ܰ��� ��3. �ϵ��ްŷ� ��Ȳ�� ���� ���ż� ���� ���뿡 ���� �����Ͽ�<br/> �ֽñ� �ٶ��ϴ�. </li>
        </ul>
      </div>

      <div class="fc pt_10"></div>

      <!-- ��ư start -->
      <div class="fr">
        <ul class="lt">
          <%if ((ckMngNo.equals("HF0101")) || (ckMngNo.equals("HF0102")) || (ckMngNo.equals("HF0103")) ){%>
          <li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">ȭ�� �μ��ϱ� �׽�Ʈ</a></li>
          <%}%>
          <li class="fl pr_2"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">�� ��</a></li>
          <li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">ȭ�� �μ��ϱ�</a></li>
          <li class="fl pr_2"><a href="../rsch210909/WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="contentbutton2">3. �ϵ��� �ŷ� ��Ȳ���� ����</a></li>
          <li class="fl pr_2"><a href="../rsch210909/WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="contentbutton2">4. ����ǥ �������� ����</a></li>
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

  <%
  /*-----------------------------------------------------------------------------------------------
  2011�� 4�� 26�� / iframe �߰� / ������
  :: �ϵ��ްŷ���Ȳ (��������) ���� �� ���� �� �����߻����� �������� �ҽǵǴ� ��츦 �����ϱ� ����
  :: ���û����� iframe Ÿ������ submit ��Ŵ
  */
  %>
  <iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
  <%/*-----------------------------------------------------------------------------------------------*/%>
  <script type="text/JavaScript">
  //<![CDATA[
  <%if ( StringUtil.checkNull(request.getParameter("isSaved")).equals("1") ) {%>
    alert("ȸ�簳�䰡 ����Ǿ����ϴ�.")
  <%}%>
  //]]
  </script>
</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>