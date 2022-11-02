<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_VP_Subcon_01_03.jsp
* ���α׷�����	: ���޻���� > �⵵�� ����ǥ > 2015�� ������ ����ǥ > �ϵ��� �ŷ� ��Ȳ
* ���α׷�����	: 1.0.1
* �����ۼ�����	: 2009�� 05��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����			�ۼ��ڸ�				����
*=========================================================
*	2009-05			������       �����ۼ�
*	2015-07-08	������       ����ǥ ���� �� �ڵ� ����(StringUtil)
*  2015-07-23  	������		������� ��� �ۼ� �߰�
*   2016-01-12	�̿뱤		DB�������� ���� ���ڵ� ����
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

	String[][][] qa = new String[31][40][30];

	String sErrorMsg = "";	// �����޽���

	String q_Cmd = StringUtil.checkNull(request.getParameter("mode"));

	// Cookie Request
	String sMngNo = ckMngNo;
	String sOentYYYY = ckCurrentYear;
	String sOentGB = ckOentGB;
	String sOentName = ckOentName;
	String sSentNo = ckSentNo;

	String sSQLs = "";

	// ������� ��� ����
	String sOentFileName = "";

	java.util.Calendar cal = java.util.Calendar.getInstance();

/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection processing =====================================*/

	if ( (ckMngNo != null) && (!ckMngNo.equals("")) ) {
		ConnectionResource resource = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;


		// �迭 �ʱ�ȭ
		for (int ni = 1; ni < 31; ni++) {
			for (int nj = 1; nj < 40; nj++) {
				for (int nk = 1; nk < 30; nk++) {
					qa[ni][nj][nk] = "";
				}
			}
		}

		// �ش����� ���� ��������
		sSQLs = "SELECT * FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
		sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";
		sSQLs+="ORDER BY SOENT_Q_CD, SOENT_Q_GB \n";
		try {
			resource= new ConnectionResource();
			conn	= resource.getConnection();
			pstmt	= conn.prepareStatement(sSQLs);
			rs		= pstmt.executeQuery();

			int qcd = 0;
			int qgb = 0;
			while (rs.next()) {
				qcd = rs.getInt("soent_q_cd");
				qgb = rs.getInt("soent_q_gb");
				qa[qcd][qgb][1] = rs.getString("A")==null ? "":rs.getString("A");
				qa[qcd][qgb][2] = rs.getString("B")==null ? "":rs.getString("B");
				qa[qcd][qgb][3] = rs.getString("C")==null ? "":rs.getString("C");
				qa[qcd][qgb][4] = rs.getString("D")==null ? "":rs.getString("D");
				qa[qcd][qgb][5] = rs.getString("E")==null ? "":rs.getString("E");
				qa[qcd][qgb][6] = rs.getString("F")==null ? "":rs.getString("F");
				qa[qcd][qgb][7] = rs.getString("G")==null ? "":rs.getString("G");
				qa[qcd][qgb][8] = rs.getString("H")==null ? "":rs.getString("H");
				qa[qcd][qgb][9] = rs.getString("I")==null ? "":rs.getString("I");
				qa[qcd][qgb][10] = rs.getString("J")==null ? "":rs.getString("J");
				qa[qcd][qgb][11] = rs.getString("K")==null ? "":rs.getString("K");
				qa[qcd][qgb][12] = rs.getString("L")==null ? "":rs.getString("L");
				qa[qcd][qgb][13] = rs.getString("M")==null ? "":rs.getString("M");
				qa[qcd][qgb][14] = rs.getString("N")==null ? "":rs.getString("N");
				qa[qcd][qgb][15] = rs.getString("O")==null ? "":rs.getString("O");
				qa[qcd][qgb][16] = rs.getString("p")==null ? "":rs.getString("p");
				qa[qcd][qgb][17] = rs.getString("Q")==null ? "":rs.getString("Q");
				qa[qcd][qgb][18] = rs.getString("R")==null ? "":rs.getString("R");
				qa[qcd][qgb][19] = rs.getString("S")==null ? "":rs.getString("S");
				qa[qcd][qgb][20] = rs.getString("SUBJ_ANS")==null ? "":rs.getString("SUBJ_ANS");
			}
			rs.close();
		} catch(Exception e){
			e.printStackTrace();
		} finally {
			if (rs != null)		try{rs.close();}	catch(Exception e){}
			if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
			if (conn != null)	try{conn.close();}	catch(Exception e){}
			if (resource != null) resource.release();
		}

		/* ������� ��� ���� - ������ 2015-07-23 */
		sSQLs = "SELECT oent_file FROM hado_tb_subcon_oent_file \n";
		sSQLs+="WHERE Mng_No=? \n";
		sSQLs+="	AND Current_Year=? \n";
		sSQLs+="	AND Oent_GB=? \n";

		try {
			resource	= new ConnectionResource();
			conn		= resource.getConnection();

			pstmt		= conn.prepareStatement(sSQLs);
			pstmt.setString(1, ckMngNo);
			pstmt.setString(2, sOentYYYY);
			pstmt.setString(3, sOentGB);

			rs			= pstmt.executeQuery();

			while (rs.next()) {
				sOentFileName = StringUtil.checkNull(rs.getString("oent_file")).trim();
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

	}
/*=====================================================================================================*/
%>
<%!
public String setHiddenValue(String[][][] arrVal,int ni, int nx, int gesu)
{
	String retValue = "";

	if ( ni > 0 && nx > 0 && gesu > 0 )
	{
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
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta http-equiv='Cache-Control' content='no-cache'>
    <meta http-equiv='Pragma' content='no-cache'>
	<meta charset="euc-kr">
    <title><%=st_Current_Year_n %>�⵵ �ϵ��ްŷ� ������� ����</title>

	<link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="euc-kr" />
	<link rel="stylesheet" href="style.css" type="text/css">
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
    <script type="text/JavaScript">
	//<![CDATA[
		ns4 = (document.layers)? true:false
		ie4 = (document.all)? true:false

		var msg = "";
		var radiof = false;
		
		var ckSave = 1;
		var itemChkFlag = false;
		var rowChk = 0;
		var itemChk1 = false;
		var itemChk2 = false;

		function savef(){
			var main = document.info;
			msg = "";
			ckSave = 0;
			
			relationf(main);
			
			fn_itemChk1(main, 25, 1);
			if(itemChk1 == true){
			    fn_itemChk2(main, 25, 11);    
			}
			if(itemChk2 == true){
			    fn_itemChk3(main, 25, 17);    
			}
			
			if(itemChkFlag){
    			if(msg=="") {
    				if(confirm("[ ����ǥ������ �����մϴ�. ]\n\n�����ڰ� ������� �ټ� �ð��� �ɸ����� �ֽ��ϴ�.\n���������� ������ �ȵɰ��\n���ʺ��Ŀ� �ٽýõ��Ͽ� �ֽʽÿ�.\n\n������ ���Ϸ� ���忡 �����Ұ��\n�����Ͻ� ���系���� ������ �� �����ϴ�.\n�����Ͻ� ����ǥ�� �μ��Ͽ� �����Ͻð�\n�������������� ���콺������ ��ư�� ����\n���ΰ�ħ�� �����Ͽ� �������� �õ��Ͻʽÿ�.\n\nȮ���� �����ø� �����մϴ�.")) {
    
    					processSystemStart("[1/1] �Է��� �ϵ��ްŷ���Ȳ�� �����մϴ�.");
    
    					main.target = "ProceFrame";
    					main.action = "WB_CP_Subcon_Qry.jsp?type=Srv&step=Detail";
    					main.submit();
    				}
    			} else {
    				ckSave = 1;
    				alert(msg+"\n\n������ ��ҵǾ����ϴ�.")
    			}
			}
		}

		function savef2(main){
			var main = document.info;

			if( confirm("[�ӽ�����] ����� ������ ����� �����ϱ� ���� ����Դϴ�.\n\n����ǥ�� ������ �ϱ� ���ؼ��� �� [�� ��] ����� �̿��ϼž� �ϸ�,\n[�� ��] ����� ������� ���� ��� [����ǥ ����]�� �ȵǿ���\n����ǥ ������ �Ϸ��Ҷ��� ���� [�� ��] ����� �̿��ϼž� �մϴ�.\n\nȮ���� �����ø� [�ӽ�����] ����� �����մϴ�.") ) {
				main.target = "ProceFrame";
				main.action = "WB_CP_Subcon_Qry.jsp?type=Srv&step=Temp";
				main.submit();
			}
		}

		function relationf(main){
			msg = "";
			
			//research2f(obj,fno,sno,type,gesu)
			//�ʼ��Է� ���� Ȯ��
			research2f(main, 5, 1, 2, 9);
			research2f(main, 7, 1, 1, 9);
			research2f(main, 8, 1, 1, 9);
			research2f(main, 9, 1, 2, 9);
			research2f(main, 10, 1, 2, 9);
			research2f(main, 11, 1, 2, 0);
			research2f(main, 11, 2, 2, 0);
			research2f(main, 12, 1, 2, 0);
			research2f(main, 12, 11, 2, 10);
			research2f(main, 12, 3, 2, 0);
			research2f(main, 13, 1, 2, 0);
			research2f(main, 14, 1, 2, 0);
			research2f(main, 15, 1, 2, 0);
			research2f(main, 16, 1, 2, 0);
			
			if(main.allSum16_2.value != "0"){
			    if(main.allSum16_2.value != "100"){
    			    msg=msg+"\n";
    			  	msg=msg+"�ϵ��ްŷ���Ȳ�� 16-2���� �ϵ��޴�� ���� ���ܺ� ������ �հ踦 100%�� �Է��� �ּ���.";
			    }    			  	
  			}
			
			research2f(main, 16, 21, 1, 10);
			research2f(main, 16, 3, 2, 0);
			
			if(main.allSum16_4.value != "0"){
				if(main.allSum16_4.value != "100"){
  			    	msg=msg+"\n";
    			  	msg=msg+"�ϵ��ްŷ���Ȳ�� 16-4���� �ϵ��޴���� ������ ��� ���޹��� ���ܺ� ������ �հ踦 100%�� �Է��� �ּ���.";
  				}
			}				
			
			research2f(main, 17, 1, 2, 0);
			research2f(main, 17, 2, 2, 0);
			research2f(main, 18, 1, 2, 0);
			research2f(main, 18, 2, 2, 0);
			research2f(main, 19, 1, 1, 9);
			research2f(main, 20, 1, 2, 0);
			research2f(main, 21, 1, 2, 0);
			research2f(main, 22, 1, 2, 0);
			research2f(main, 23, 1, 3, 6);
			research2f(main, 23, 11, 1, 10);
			research2f(main, 24, 1, 2, 0);
			research2f(main, 25, 1, 2, 0);
			research2f(main, 25, 11, 2, 10);
			research2f(main, 25, 17, 2, 11);
			
			// ���蹮�� ���� Ȯ��
			//--> �Է¿��� Ȯ�� :: research3f(form-name, ���蹮�״��ȣ, ���蹮�׼ҹ�ȣ, ��üŸ��(1:text,2:radio,3:checkbox), ���ⰳ��(checkbox�� �ش� �ƴϸ� 0), ������(����)���״��ȣ, ������(����)���׼ҹ�ȣ);
			//--> �����ʱ�ȭ :: initf(form-name, ���״��ȣ, ���׼ҹ�ȣ, ��üŸ��(2:radio,3:checkbox), 0���ⰳ��(checkbox�� �ش� �ƴϸ� 0));
			if( main.q2_5_1[0].checked==true ) {research4f(main, 6, 2, 5, 1);initf(main, 6, 1, 1, 0); initf(main, 6, 2, 1, 0); initf(main, 6, 3, 1, 0);}
			if( main.q2_5_1[1].checked==true ) {research4f(main, 6, 1, 5, 1); research4f(main, 6, 2, 5, 1);}
			
			if( main.q2_11_2[0].checked==true ) {
				initf(main, 11, 3, 2, 0); initf(main, 11, 22, 1, 0); initf(main, 11, 23, 1, 0); initf(main, 11, 24, 1, 0); initf(main, 11, 25, 1, 0); initf(main, 11, 26, 1, 0);
				initf(main, 11, 5, 2, 0); initf(main, 11, 27, 1, 0); research3f(main, 11, 6, 2, 0, 11, 2);
			}
			if( main.q2_11_2[1].checked==true || main.q2_11_2[2].checked==true || main.q2_11_2[3].checked==true || main.q2_11_2[4].checked==true ) {
				research3f(main, 11, 3, 2, 0, 11, 2);
				if(ckSave == 1) {research3f(main, 11, 22, 1, 0, 11, 2);}
				
				if( main.q2_11_3[0].checked==true ) {
					research4f(main, 11, 4, 11, 2); research3f(main, 11, 5, 2, 0, 11, 2); research3f(main, 11, 6, 2, 0, 11, 2);
					if(ckSave == 1) {research3f(main, 11, 27, 1, 0, 11, 2);}
				}
				if( main.q2_11_3[1].checked==true ) {
					initf(main, 11, 23, 1, 0); initf(main, 11, 24, 1, 0); initf(main, 11, 25, 1, 0); initf(main, 11, 26, 1, 0);
					initf(main, 11, 5, 2, 0); initf(main, 11, 27, 1, 0); research3f(main, 11, 6, 2, 0, 11, 2);
				}
			}
			
			if( main.q2_11_6[0].checked==true ) {
				initf(main, 11, 7, 2, 0); initf(main, 11, 28, 1, 0);
			}
			if( main.q2_11_6[1].checked==true || main.q2_11_6[2].checked==true || main.q2_11_6[3].checked==true || main.q2_11_6[4].checked==true ) {
				research3f(main, 11, 7, 2, 0, 11, 6);
				if(ckSave == 1) {research3f(main, 11, 28, 1, 0, 11, 6);}
			}
			
			if( main.q2_13_1[0].checked==true ) {
				initf(main, 13, 2, 3, 7); initf(main, 13, 11, 1, 0);
			}
			if( main.q2_13_1[1].checked==true || main.q2_13_1[2].checked==true || main.q2_13_1[3].checked==true || main.q2_13_1[4].checked==true ) {
				research3f(main, 13, 2, 3, 7, 13, 1);
				if(ckSave == 1) {research3f(main, 13, 11, 1, 0, 13, 1);}
			}
			
			if( main.q2_14_1[0].checked==true ) {
				initf(main, 14, 2, 3, 7); initf(main, 14, 11, 1, 0);
			}
			if( main.q2_14_1[1].checked==true || main.q2_14_1[2].checked==true || main.q2_14_1[3].checked==true || main.q2_14_1[4].checked==true ) {
				research3f(main, 14, 2, 3, 7, 14, 1);
				if(ckSave == 1) {research3f(main, 14, 11, 1, 0, 14, 1);}
			}
			
			if( main.q2_15_1[0].checked==true ) {
				initf(main, 15, 2, 3, 10); initf(main, 15, 11, 1, 0);
			}
			if( main.q2_15_1[1].checked==true || main.q2_15_1[2].checked==true || main.q2_15_1[3].checked==true || main.q2_15_1[4].checked==true ) {
				research3f(main, 15, 2, 3, 10, 15, 1);
				if(ckSave == 1) {research3f(main, 15, 11, 1, 0, 15, 1);}
			}
			
			if( main.q2_16_3[0].checked==true ) {
				initf(main, 16, 31, 1, 0); initf(main, 16, 32, 1, 0); initf(main, 16, 33, 1, 0); initf(main, 16, 34, 1, 0);
				initf(main, 16, 5, 2, 0); initf(main, 16, 6, 2, 0);
			}
			if( main.q2_16_3[1].checked==true || main.q2_16_3[2].checked==true || main.q2_16_3[3].checked==true ) {
				research4f(main, 16, 4, 16, 3); research3f(main, 16, 5, 2, 0, 16, 3); research3f(main, 16, 6, 2, 0, 16, 3);
			}
			
			if( main.q2_17_2[1].checked==true ) {
				initf(main, 17, 11, 1, 0); initf(main, 17, 12, 1, 0); initf(main, 17, 13, 1, 0); initf(main, 17, 14, 1, 0);
				initf(main, 17, 4, 2, 0); research3f(main, 17, 5, 2, 0, 17, 2);
			}
			if( main.q2_17_2[0].checked==true ) {
				research4f(main, 17, 3, 17, 2); research3f(main, 17, 4, 2, 0, 17, 2);
			}
			
			if( main.q2_18_2[1].checked==true ) {
				initf(main, 18, 3, 2, 0); initf(main, 18, 4, 3, 3); initf(main, 18, 13, 1, 0); initf(main, 18, 14, 1, 0);
			}
			if( main.q2_18_2[0].checked==true ) {
				research3f(main, 18, 3, 2, 0, 18, 2); research3f(main, 18, 4, 3, 3, 18, 2);
				if(ckSave == 1) {research3f(main, 18, 13, 1, 0, 18, 2); research3f(main, 18, 14, 1, 0, 18, 2);}
			}
			
			if( main.q2_20_1[1].checked==true ) {
				initf(main, 20, 2, 3, 6); initf(main, 20, 11, 1, 0);
			}
			if( main.q2_20_1[0].checked==true ) {
				research3f(main, 20, 2, 3, 6, 20, 1);
				if(ckSave == 1) {research3f(main, 20, 11, 1, 0, 20, 1);}
			}
			
			if( main.q2_21_1[1].checked==true ) {
				initf(main, 21, 2, 3, 5); initf(main, 21, 11, 1, 0); initf(main, 21, 3, 2, 0); initf(main, 21, 21, 1, 0); initf(main, 21, 22, 1, 0);
				initf(main, 21, 23, 1, 0); initf(main, 21, 24, 1, 0); initf(main, 21, 25, 1, 0); initf(main, 21, 26, 1, 0); initf(main, 21, 27, 1, 0);
				initf(main, 21, 28, 1, 0); initf(main, 21, 29, 1, 0); initf(main, 21, 30, 1, 0); initf(main, 21, 5, 3, 4);
				initf(main, 21, 12, 1, 0); initf(main, 21, 13, 1, 0); initf(main, 21, 14, 1, 0); initf(main, 21, 7, 2, 0); initf(main, 21, 15, 1, 0);
				initf(main, 21, 31, 1, 0); initf(main, 21, 32, 1, 0); initf(main, 21, 33, 1, 0);
				initf(main, 21, 34, 1, 0); initf(main, 21, 35, 1, 0); initf(main, 21, 36, 1, 0); research3f(main, 21, 9, 2, 0, 21, 1);
			}
			if( main.q2_21_1[0].checked==true ) {
				research3f(main, 21, 2, 3, 5, 21, 1); research3f(main, 21, 3, 2, 0, 21, 1);
				if(ckSave == 1) {research3f(main, 21, 11, 1, 0, 21, 1);}
				
				if( main.q2_21_3[2].checked==true ) {
					initf(main, 21, 21, 1, 0); initf(main, 21, 22, 1, 0);
					initf(main, 21, 23, 1, 0); initf(main, 21, 24, 1, 0); initf(main, 21, 25, 1, 0); initf(main, 21, 26, 1, 0); initf(main, 21, 27, 1, 0);
					initf(main, 21, 28, 1, 0); initf(main, 21, 29, 1, 0); initf(main, 21, 30, 1, 0); initf(main, 21, 5, 3, 4);
					initf(main, 21, 12, 1, 0); initf(main, 21, 13, 1, 0); initf(main, 21, 14, 1, 0); initf(main, 21, 7, 2, 0); initf(main, 21, 15, 1, 0);
					initf(main, 21, 31, 1, 0); initf(main, 21, 32, 1, 0); initf(main, 21, 33, 1, 0);
					initf(main, 21, 34, 1, 0); initf(main, 21, 35, 1, 0); initf(main, 21, 36, 1, 0); initf(main, 21, 9, 2, 0);
				}
				if( main.q2_21_3[0].checked==true || main.q2_21_3[1].checked==true ) {
					research4f(main, 21, 4, 21, 3); research3f(main, 21, 5, 3, 4, 21, 3); research4f(main, 21, 6, 21, 3); research4f(main, 21, 8, 21, 3);
					research3f(main, 21, 7, 2, 0, 21, 3); research3f(main, 21, 9, 2, 0, 21, 3);
					if(ckSave == 1) {research3f(main, 21, 15, 1, 0, 21, 3);}
				}
			}
			
			if( main.q2_22_1[1].checked==true ) {
				initf(main, 22, 2, 2, 0); initf(main, 22, 3, 2, 0); initf(main, 22, 4, 2, 0); initf(main, 22, 11, 1, 0);
			}
			if( main.q2_22_1[0].checked==true ) {
				research3f(main, 22, 2, 2, 0, 22, 1);
				
				if( main.q2_22_2[1].checked==true ) {
					initf(main, 22, 3, 2, 0); initf(main, 22, 4, 2, 0); initf(main, 22, 11, 1, 0);
				}
				if( main.q2_22_2[0].checked==true || main.q2_22_2[2].checked==true || main.q2_22_2[3].checked==true ) {
					research3f(main, 22, 3, 2, 0, 22, 2);
					
					if( main.q2_22_3[0].checked==true ) {
						initf(main, 22, 4, 2, 0); initf(main, 22, 11, 1, 0);
					}
					if( main.q2_22_3[1].checked==true ) {
						research3f(main, 22, 4, 2, 0, 22, 3);
						if(ckSave == 1) {research3f(main, 22, 11, 1, 0, 22, 1);}
					}
				}
			}
			
			if( main.q2_24_1[1].checked==true ) {
				initf(main, 24, 2, 1, 0); initf(main, 24, 11, 1, 0); initf(main, 24, 12, 1, 0); initf(main, 24, 13, 1, 0);
				initf(main, 24, 4, 2, 0); initf(main, 24, 14, 1, 0);
				initf(main, 24, 5, 3, 5); initf(main, 24, 15, 1, 0);
				initf(main, 24, 6, 3, 10); initf(main, 24, 16, 1, 0);
			}
			if( main.q2_24_1[0].checked==true ) {
				research3f(main, 24, 2, 1, 0, 24, 1);
				research4f(main, 24, 3, 24, 1);
				research3f(main, 24, 4, 2, 0, 24, 1);
				research3f(main, 24, 5, 3, 5, 24, 1);
				research3f(main, 24, 6, 3, 10, 24, 1);
				if(ckSave == 1) {research3f(main, 24, 14, 1, 0, 24, 1); research3f(main, 24, 15, 1, 0, 24, 1); research3f(main, 24, 16, 1, 0, 24, 1);}
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
	        
		        if( type=="1" && (gesu !="9" && gesu !="10")) {
					eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+fno+"-"+sno+"���� �Է��Ͽ� �ֽʽÿ�.'");
	    	    }else if(type=="1" && gesu =="9"){
	    	        eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+fno+"���� �Է��Ͽ� �ֽʽÿ�.'");
	    	    }else if(type=="2" && gesu =="9"){
	    	        eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+fno+"���� �����Ͽ� �ֽʽÿ�.'");
	    	    }else if(type=="2" && gesu =="10"){
	    	        eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+fno+"-2���� �����Ͽ� �ֽʽÿ�.'");
	    	    }else if(type=="2" && gesu =="11"){
	    	        eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+fno+"-3���� �����Ͽ� �ֽʽÿ�.'");
	    	    }else if(type=="1" && gesu =="10"){
	    	        eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+fno+"-2���� �Է��Ͽ� �ֽʽÿ�.'");
	      		}else {
	        	  	eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+fno+"-"+sno+"���� �����Ͽ� �ֽʽÿ�.'");
	        	}
	      	}
	    }
		
		function checkradio(ni, nx){

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

		function initf(obj,fno,sno,type,gesu){
			switch(type){
				case 1:
					eval("obj.q2_"+fno+"_"+sno+".value=''");
					break;
				case 2:
					eval("for(i=0;i<obj.q2_"+fno+"_"+sno+".length;i++) obj.q2_"+fno+"_"+sno+"[i].checked=false");
					break;
				case 3:
					for(i=1;i<=gesu;i++)
						eval("obj.q2_"+fno+"_"+sno+"_"+i+".checked=false");
					break;
			}
			// ���蹮�� �� �� ������ ���� 1 : Ȱ��ȭ , 2 : ��Ȱ��ȭ
			chBoxDisplay(obj, fno, sno, type, gesu, 1);
		}

		// üũ�ڽ� Ȱ��ȭ / ��Ȱ��ȭ
		function chBoxDisplay(obj,fno,sno,type,gesu,view) {
			//alert("��:"+obj+"/"+fno+"/"+sno+"Ÿ��:"+type);
			switch (type) {
			case 1:
				eval("obj.q2_"+fno+"_"+sno+".disabled=" + (view == 1 ? "true" : "false"));
				break;
			case 2:
				for(i=0;i<eval("obj.q2_"+fno+"_"+sno+".length");i++)
				break;
			case 3:
				for(i=1;i<=gesu;i++)
					eval("obj.q2_"+fno+"_"+sno+"_"+i+".disabled=" + (view == 1 ? "true" : "false"));
				break;
			}
		}

		//-- �����׸� ���ÿ��� Ȯ�� --//
		function research3f(obj,fno,sno,type,gesu,ofno,osno){

			var ccheck="no", i
			switch (type){
				case 1:	// text
					ccheck="yes";
					eval("if(obj.q2_"+fno+"_"+sno+".value=='') ccheck='no'"  );
					break;
				case 2:	// Radio
					eval("for(i=0;i<obj.q2_"+fno+"_"+sno+".length;i++) if(obj.q2_"+fno+"_"+sno+"[i].checked==true) ccheck='yes'");
					break;
				case 3:	// checkbox
					for(i=1;i<=gesu;i++)
						eval("if(obj.q2_"+fno+"_"+sno+"_"+i+".checked==true) ccheck='yes'");
					break;
			}

			// ���蹮�� �� �� ������ ���� 1 : Ȱ��ȭ , 2 : ��Ȱ��ȭ
			chBoxDisplay(obj, fno, sno, type, gesu, 2);

			if(ccheck=="no"){
				msg=msg+"\n";

				if( type=="1") {
					eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+ofno+"-"+osno+"���� ���蹮�� "+fno+"-"+sno+"���� �Է��Ͽ� �ֽʽÿ�.'");
				} else {
					eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+ofno+"-"+osno+"���� ���蹮�� "+fno+"-"+sno+"���� �����Ͽ� �ֽʽÿ�.'");
				}
			}
		}
		
		function research4f(obj,fno,sno,ofno,osno){

			var ccheck="no", i
			if(fno==6 && sno==1) {
				ccheck="yes";
				eval("if(obj.q2_6_1.value=='' && obj.q2_6_2.value=='' && obj.q2_6_3.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 6, 1, 1, 0, 2);
				chBoxDisplay(obj, 6, 2, 1, 0, 2);
				chBoxDisplay(obj, 6, 3, 1, 0, 2);
			}
			if(fno==6 && sno==2) {
				ccheck="yes";
				eval("if(obj.q2_6_4.value=='' && obj.q2_6_5.value=='' && obj.q2_6_6.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 6, 4, 1, 0, 2);
				chBoxDisplay(obj, 6, 5, 1, 0, 2);
				chBoxDisplay(obj, 6, 6, 1, 0, 2);
			}
			if(fno==11 && sno==4) {
				ccheck="yes";
				eval("if(obj.q2_11_23.value=='' && obj.q2_11_24.value=='' && obj.q2_11_25.value=='' && obj.q2_11_26.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 11, 23, 1, 0, 2);
				chBoxDisplay(obj, 11, 24, 1, 0, 2);
				chBoxDisplay(obj, 11, 25, 1, 0, 2);
				chBoxDisplay(obj, 11, 26, 1, 0, 2);
			}
			if(fno==16 && sno==4) {
				ccheck="yes";
				eval("if(obj.q2_16_31.value=='' && obj.q2_16_32.value=='' && obj.q2_16_33.value=='' && obj.q2_16_34.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 16, 31, 1, 0, 2);
				chBoxDisplay(obj, 16, 32, 1, 0, 2);
				chBoxDisplay(obj, 16, 33, 1, 0, 2);
				chBoxDisplay(obj, 16, 34, 1, 0, 2);
			}
			if(fno==17 && sno==3) {
				ccheck="yes";
				eval("if(obj.q2_17_11.value=='' && obj.q2_17_12.value=='' && obj.q2_17_13.value=='' && obj.q2_17_14.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 17, 11, 1, 0, 2);
				chBoxDisplay(obj, 17, 12, 1, 0, 2);
				chBoxDisplay(obj, 17, 13, 1, 0, 2);
				chBoxDisplay(obj, 17, 14, 1, 0, 2);
			}
			if(fno==21 && sno==4) {
				ccheck="yes";
				eval("if(obj.q2_21_21.value=='' && obj.q2_21_22.value=='' && obj.q2_21_23.value=='' && obj.q2_21_24.value=='' && obj.q2_21_25.value=='' && obj.q2_21_26.value=='' && obj.q2_21_27.value=='' && obj.q2_21_28.value=='' && obj.q2_21_29.value=='' && obj.q2_21_30.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 21, 21, 1, 0, 2);
				chBoxDisplay(obj, 21, 22, 1, 0, 2);
				chBoxDisplay(obj, 21, 23, 1, 0, 2);
				chBoxDisplay(obj, 21, 24, 1, 0, 2);
				chBoxDisplay(obj, 21, 25, 1, 0, 2);
				chBoxDisplay(obj, 21, 26, 1, 0, 2);
				chBoxDisplay(obj, 21, 27, 1, 0, 2);
				chBoxDisplay(obj, 21, 28, 1, 0, 2);
				chBoxDisplay(obj, 21, 29, 1, 0, 2);
				chBoxDisplay(obj, 21, 30, 1, 0, 2);
			}
			if(fno==21 && sno==6) {
				ccheck="yes";
				eval("if(obj.q2_21_12.value=='' && obj.q2_21_13.value=='' && obj.q2_21_14.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 21, 12, 1, 0, 2);
				chBoxDisplay(obj, 21, 13, 1, 0, 2);
				chBoxDisplay(obj, 21, 14, 1, 0, 2);
			}
			if(fno==21 && sno==8) {
				ccheck="yes";
				eval("if(obj.q2_21_31.value=='' && obj.q2_21_32.value=='' && obj.q2_21_33.value=='' && obj.q2_21_34.value=='' && obj.q2_21_35.value=='' && obj.q2_21_36.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 21, 31, 1, 0, 2);
				chBoxDisplay(obj, 21, 32, 1, 0, 2);
				chBoxDisplay(obj, 21, 33, 1, 0, 2);
				chBoxDisplay(obj, 21, 34, 1, 0, 2);
				chBoxDisplay(obj, 21, 35, 1, 0, 2);
				chBoxDisplay(obj, 21, 36, 1, 0, 2);
			}
			if(fno==24 && sno==3) {
				ccheck="yes";
				eval("if(obj.q2_24_11.value=='' && obj.q2_24_12.value=='' && obj.q2_24_13.value=='') ccheck='no'"  );
				chBoxDisplay(obj, 24, 11, 1, 0, 2);
				chBoxDisplay(obj, 24, 12, 1, 0, 2);
				chBoxDisplay(obj, 24, 13, 1, 0, 2);
			}
			
			if(ccheck=="no"){
				msg=msg+"\n";
				if(ofno == "5"){
				    eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+ofno+"���� ���蹮�� "+fno+"-"+sno+"���� �Է��Ͽ� �ֽʽÿ�.'");
				}else{
					eval("msg=msg+'�ϵ��ްŷ���Ȳ�� "+ofno+"-"+osno+"���� ���蹮�� "+fno+"-"+sno+"���� �Է��Ͽ� �ֽʽÿ�.'");
				}					
			}
		}
		
		function fn_hap16_2(main) {
			main.allSum16_2.value
			=Math.round(Cnum(main.q2_16_21.value)
			+Cnum(main.q2_16_22.value)
			+Cnum(main.q2_16_23.value)
			+Cnum(main.q2_16_24.value)
			+Cnum(main.q2_16_25.value)
			+Cnum(main.q2_16_26.value)
			+Cnum(main.q2_16_27.value)
			+Cnum(main.q2_16_28.value)
			+Cnum(main.q2_16_29.value)
			+Cnum(main.q2_16_30.value));
		}
		function fn_hap16_4(main) {
			main.allSum16_4.value
			=Math.round(Cnum(main.q2_16_31.value)
			+Cnum(main.q2_16_32.value)
			+Cnum(main.q2_16_33.value)
			+Cnum(main.q2_16_34.value));
		}

		//--------------------------------------------------------------------------------------------------------
		var bName = navigator.appName;
		var bVer = parseInt(navigator.appVersion);
		var NS4 = (bName == "Netscape" && bVer >= 4);
		var IE4 = (bName == "Microsoft Internet Explore" && bVer >= 4);
		var NS3 = (bName == "Netscape" && bVer < 4);
		var IE3 = (bName == "Microsoft Internet Explore" && bVer < 4);

		var vTime = 5;

		function view_layer(obj){
			var listDiv = eval("document.getElementById('"+obj+"')");
			var topx = 50;
			var leftx = 60;

			if(NS4) {
				listDiv.style.top = document.body.scrollTop+document.documentElement.scrollTop+topx;
				listDiv.style.left = document.body.scrollLeft+document.documentElement.scrollLeft+leftx;
			} else {
				listDiv.style.posTop = document.body.scrollTop+topx;
				listDiv.style.posLeft = document.body.scrollLeft+leftx;
			}
		}

		function ShowInfo(str){
			vTime = 5;

			infoLayerText.innerHTML = "<font color='#006633'>"+str+"</font>";

			goShowInfo();
			infotimer = setInterval(goShowInfo,1000)
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

		function HelpWindow2(url, w, h){
			helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
			helpwindow.focus();
		}

		function Cnum(aa)
		{
			bb=aa+"";
			while (bb.indexOf(",") != -1)
			{
				bb=bb.replace(",","") ;
			}
			if(isNaN(bb)||bb==''||bb==null)
				return 0
			else
				return Number(bb);
		}


		// ũ����� Ŀ�� ��ũ��Ʈ..
		var SU_COMMA = ',';

		// ���ڿ� ġȯ
		function kreplace(str,str1,str2) {

			if (str == "" || str == null) return str;

			while (str.indexOf(str1) != -1) {
				str = str.replace(str1,str2);
			}
			return str;
		}

		// �Ǽ������� Ȯ���Ѵ�.
		function isFloat(str) {
			return (str.indexOf('.') != -1);
		}

		// ���ڿ� �ĸ��� �����Ѵ�.
		function suwithcomma(su) {

			su = kreplace(su,',','');

			var rtn = '';
			var fd = false;
			// �Էµ� ���� �˻��Ͽ� ���ڰ� �ƴ� ��� 0�� �����ش�.
			// ������ ��쿡�� ���ڿ��� �ٲ۴�.
			if (isNaN(su)) {
				alert("���ڸ� �Է��ϼž� �մϴ�.");
				return 0;
			} else {
				su = new String(su);
			}

			n = su.indexOf('.');
			if (n<0) {
				n = parseInt(su.length);
			} else {
				fd = true;
			}

			while (su.indexOf('0') == 0 ) {
				if (!fd) {
					su = su.substring(1,su.length);
				} else {
					if (n > 1) {
						su = su.substring(1, su.length);
						n --;
					} else {
						return su;
					}
				}
			}
			cnt = parseInt(n / 3);
		//	alert(cnt);
			mod = parseInt(n % 3);
		//	alert(mod);
			if (mod>0) {
				rtn = su.substring(0,mod);
				if (cnt > 0) rtn = rtn+SU_COMMA;
			}
			for (i = 0; i < cnt ; i++) {
				idx = i*3+mod;
				if (idx == 0) {
					rtn = su.substring(idx,idx+3);
					if (cnt > 1) rtn = rtn+SU_COMMA;
				} else {
					rtn = rtn+su.substring(idx,idx+3);
					if (idx < n - 3) rtn = rtn+SU_COMMA;
				}

			}
			if (fd) rtn = rtn+su.substring(n,su.length);
			return rtn;
		}

		// ���ڰ�, "."������ üũ�Ѵ�.
		function checkStringValid(src){
			var len = src.value.length;

			for(var i=0;i<len;i++){
				if ((!isDecimal(src.value.charAt(i)) || src.value.charAt(i)==" ") && src.value.charAt(i)!="." ){
					assortString(src,i);
					i=0;
				}
			}

		}

		// ���ڸ� �����Ѵ�.
		function assortString(source,index){
			var len = source.value.length;
			var temp1 = source.value.substring(0,index);
			var temp2 = source.value.substring(index+1,len);
			source.value = temp1+temp2;
		}

		// 10�������� ������ �ִ��� Ȯ���Ѵ�.
		function isDecimal(number){
			if (number>=0 && number<=9)  return true;
			else return false;
		}

		// �Ҽ����� �ΰ� �̻��ԷµǸ� ������ ���� �����Ѵ�.
		function ispoint(src) {
			if ((p1 = src.value.indexOf('.')) != -1) {
				if ((p2 = src.value.indexOf('.',p1+1)) != -1) {
					src.value = src.value.substring(0,p2);
					return true;
				}
			}
			return false;
		}

		// Ű�ڵ带 �˻��ϰ� ��Ʈ���� ���� �ĸ��� �����Ѵ�.
		function sukeyup(src) {

			if (sukeyup_n(src)) {
				src.value = suwithcomma(src.value);
				return true;
			}
			return false;
		}
		// �Է°��� �˻��Ѵ�.
		function sukeyup_n(src) {

			keycode = window.event.keyCode;
			//alert(isArrowKey(keycode));
			if (isArrowKey(keycode) || keycode == 13 || ispoint(src)) {
				return false;
			}
			checkStringValid(src);

			if (src.value == '' || src.value == '0') {
				src.value = 0;
				return false;
			}

			if (src.value == '.' || src.value == '0.') {
				src.value = '0.';
				return false;
			}

			if(!isNaN(src.value)) {

				if (src.value.indexOf('.') == 1) return false;
				if (src.value.length <= 3) {
					if (src.value.indexOf('0') == 0)
						src.value = src.value.substring(1,src.value.length);
					return false;
				}

			}
			return true;
		}

		// ���� Ű�� ȭ��ǥ������ Ȯ���Ѵ�.
		function isArrowKey(key){
			if(key>=37 && key<=40) return true;
			else return false;
		}

		// ���� �ִ밪 ���� ū ��� �ִ밪�� �Է��Ѵ�.
		// vmax : �ִ밪
		function isMax(src,vmax) {

			var sv = src.value;
			var smax = suwithcomma(new String(vmax));
			sv = parseFloat(kreplace(sv,',',''));

			if (sv > vmax) {
				alert('�ִ밪('+smax+')���� ū ���� �Է� �Ǿ����ϴ�.');
				src.value = smax;
				return false;
			}
			return true;
		}

		function suwithdec(src,dec) {
			sukeyup(src);
			wpoint(src,dec);
		}

		//
		function isMonth(src) {

			onlyNumeric(src);
			v = parseInt(src.value);
			if ((v < 1) || (v > 12)) {
				alert("���� �Է� �ϼž� �մϴ�.");
				src.value = new Date().getMonth();
				return false;
			}
			return true;

		}

		// ���ڰ����� �Է¹޴´�.
		function onlyNumeric(src){
			var len = src.value.length;

			for(var i=0;i<len;i++){
				if (!isDecimal(src.value.charAt(i)) || src.value.charAt(i)==" ") {
					assortString(src,i);
					i=0;
				}
			}

		}

		// ������ �Ҽ��� ������ ���� ������.
		function wpoint(src,dec) {
			if ((p = src.value.indexOf('.')) != -1) {
				if (src.value.length > p+dec+1) {
					src.value = src.value.substring(0,p+dec+1);
				}
			}
		}

		// �ʱ� �ε�� ����
		function onDocumentInit(){
			fn_hap16_2(document.info);
			fn_hap16_4(document.info);

			relationf(document.info);
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


	//2015-07-18 /������/ȭ�� �μ�� �� â���� ���
		function goPrint(){
			url = "WB_VP_Subcon_03_03.jsp?mode=print";
			w = 1024;
			h = 768;

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
		
		// 7������ üũ
		function checkVal(main){
			var q2_7_1 = kreplace(main.q2_7_1.value, ",", "");
			var q2_7_2 = kreplace(main.q2_7_2.value, ",", "");
			var q2_7_3 = kreplace(main.q2_7_3.value, ",", "");
			var q2_7_4 = kreplace(main.q2_7_4.value, ",", "");
			
			if(q2_7_1 > 0 && q2_7_2 > 0){
			    if(parseInt(q2_7_1) < parseInt(q2_7_2)){
			        alert("�� �������� ���� �ϵ����� �� ������ڼ� �̻��̾�� �մϴ�.");	
			        main.q2_7_2.value = 0;
			        main.q2_7_2.focus();
			    }
			}
			
			if(q2_7_3 > 0 && q2_7_4 > 0){
			    if(parseInt(q2_7_3) < parseInt(q2_7_4)){
			        alert("�� ���Ի���� ���� �ϵ����� �� ���޻���ڼ� �̻��̾�� �մϴ�.");	
			        main.q2_7_4.value = 0;
			        main.q2_7_4.focus();
			    }
			} 
		}
		
		// 13-2, 24-6 ���� üũ
		function fn_chk(main, fno, sno){
		    if(fno == "13" && sno == "2"){
    		    if(main.q2_13_2_7.checked){
    			    initf(main, 13, 2, 3, 6);
    			    initf(main, 13, 11, 1, 0);
    			}else{
    			    research3f(main, 13, 2, 3, 7, 13, 1);
    			    research3f(main, 13, 11, 1, 0, 13, 1);
    			}
		    }else if(fno == "24" && sno == "6"){
		        if(main.q2_24_6_10.checked){
    			    initf(main, 24, 6, 3, 9);
    			    initf(main, 24, 16, 1, 0);
    			}else{
    			    research3f(main, 24, 6, 3, 10, 24, 6);
    			    research3f(main, 24, 16, 1, 0, 24, 6);
    			}
		    }    		    
		}
		
		// ������ ���� ���� üũ
		function fn_itemChk1(main, fno, sno, gesu){
		    rowChk = 0;
  			for(i=0;i<=6;i++) {
  			    if(main.q2_25_1[i].checked == true) rowChk++;
  			    if(main.q2_25_2[i].checked == true) rowChk++;
  			    if(main.q2_25_3[i].checked == true) rowChk++;
  			    if(main.q2_25_4[i].checked == true) rowChk++;
  			    if(main.q2_25_5[i].checked == true) rowChk++;
  			    if(main.q2_25_6[i].checked == true) rowChk++;
  			    if(main.q2_25_7[i].checked == true) rowChk++;
  			    if(main.q2_25_8[i].checked == true) rowChk++;
  			    if(main.q2_25_9[i].checked == true) rowChk++;
  			    if(main.q2_25_10[i].checked == true) rowChk++;
   			}	
		    
        	if(rowChk < 10){
        	    msg=msg+"\n";
			  	msg=msg+"�ϵ��ްŷ���Ȳ�� 25-1�� �ϵ��� �ŷ��� �ϵ��� ��å�� ���� �ͻ��� ������ ���翡 ��� ������ �ּ���.";
        	}
        	
        	itemChk1 = true;
        	
		}
		
		function fn_itemChk2(main, fno, sno){
		    rowChk = 0;
			for(i=0;i<=6;i++) {
			    if(main.q2_25_11[i].checked == true) rowChk++;
			    if(main.q2_25_12[i].checked == true) rowChk++;
			    if(main.q2_25_14[i].checked == true) rowChk++;
			    if(main.q2_25_15[i].checked == true) rowChk++;
			    if(main.q2_25_16[i].checked == true) rowChk++;
			}			    
	    
			if(rowChk < 5){
			    msg=msg+"\n";
			  	msg=msg+"�ϵ��ްŷ���Ȳ�� 25-2�� �ϵ��� �ŷ��� �ϵ��� ��å�� ���� �ͻ��� ������ ���翡 ��� ������ �ּ���.";
	    	}
	    	
        	itemChk2 = true;
		}
		
		function fn_itemChk3(main, fno, sno){
		    rowChk = 0;
			for(i=0;i<=6;i++) {
			    if(main.q2_25_17[i].checked == true) rowChk++;
			    if(main.q2_25_18[i].checked == true) rowChk++;
			    if(main.q2_25_19[i].checked == true) rowChk++;
			    if(main.q2_25_20[i].checked == true) rowChk++;
			    if(main.q2_25_21[i].checked == true) rowChk++;
			    if(main.q2_25_22[i].checked == true) rowChk++;
			    if(main.q2_25_23[i].checked == true) rowChk++;
			    if(main.q2_25_24[i].checked == true) rowChk++;
			    if(main.q2_25_25[i].checked == true) rowChk++;
			    if(main.q2_25_26[i].checked == true) rowChk++;
			    if(main.q2_25_27[i].checked == true) rowChk++;
			    if(main.q2_25_28[i].checked == true) rowChk++;
			}			    
	    
			if(rowChk < 12){
			    msg=msg+"\n";
			  	msg=msg+"�ϵ��ްŷ���Ȳ�� 25-3�� �ϵ��� �ŷ��� �ϵ��� ��å�� ���� �ͻ��� ������ ���翡 ��� ������ �ּ���.";
	    	}
			
			itemChkFlag = true;
		}
	//]]
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
				<li class="fl"><a href="/" onfocus="this.blur()" name="#mokcha"><img src="img/logo.jpg" width="242" height="55"></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"><font color="#FF6600">[
							<% if( ckOentGB.equals("1") ) {%>������
							<% } else if( ckOentGB.equals("2") ) {%>�Ǽ���
							<% } else if( ckOentGB.equals("3") ) {%>�뿪��<% } %>]</font>
							<%=ckOentName%>&nbsp;/&nbsp;<%=ckSentName%><iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="24" marginwidth="0" marginheight="0" align="center" frameborder="0"></iframe></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			<ul class="lt fr">
				<li class="fl pr_2"><a href="../rsch210909/WB_VP_Subcon_Intro.jsp" onfocus="this.blur()" class="mainmenu">1. ����ȳ�</a></li>
				<li class="fl pr_2"><a href="../rsch210909/WB_VP_Subcon_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenu">2. �ͻ��� �Ϲ���Ȳ</a></li>
				<li class="fl pr_2"><a href="../rsch210909/WB_VP_Subcon_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenuup">3. �ϵ��� �ŷ� ��Ȳ</a></li>
				<li class="fl pr_2"><a href="../rsch210909/WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="mainmenu">4. ����ǥ ����</a></li>
				<li class="fl pr_2"><a href="../rsch210909/WB_VP_Subcon_Add.jsp" onfocus="this.blur()" class="mainmenu">5. �߰� ����</a></li>
			</ul>
		</div>
		<!-- End Header -->

		<form action="" method="post" name="info">
		<!-- Begin subcontent -->
		<div id="subcontent">
			<!-- title start -->
			<h1 class="contenttitle">3. �ϵ��� �ŷ� ��Ȳ</h1>
			<!-- title end -->

			<div class="fc pt_10"></div>

			<!--2015075 / ������ / ����-->
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle"><a name="mokcha">�� ��</a></li>
						<li class="boxcontentsubtitle">(Ŭ���Ͻø� �ش� ������ �̵��մϴ�.)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><a href="#mokcha0" class="contentbutton3">�ϵ��ްŷ� �⺻����</a></li>
						<li><a href="#mokcha1" class="contentbutton3">11. ���޻���� ������� �� �����</a></li>
						<li><a href="#mokcha2" class="contentbutton3">12. �ϵ��� ��� ü�� ��, �ϵ��� �ŷ� �ܰ��� ����</a></li>
						<li><a href="#mokcha3" class="contentbutton3">13. �뿪 ��Ź�� ��� �� ����</a></li>
						<li><a href="#mokcha4" class="contentbutton3">14. ������ ����</a></li>
						<li><a href="#mokcha5" class="contentbutton3">15. ���ü�� ��, �ϵ��޴�� ����</a></li>
						<li><a href="#mokcha6" class="contentbutton3">16. �ϵ��޴�� ����</a></li>
						<li><a href="#mokcha7" class="contentbutton3">17. ���޿���(����, �빫��, ��� ��) ������ ���� �ϵ��޴�� ���� ��û</a></li>
						<li><a href="#mokcha8" class="contentbutton3">18. �ϵ��޹� ����</a></li>
						<li><a href="#mokcha9" class="contentbutton3">19. ���°���</a></li>
						<li><a href="#mokcha10" class="contentbutton3">20. Ư��</a></li>
						<li><a href="#mokcha11" class="contentbutton3">21. ������ ��������� ����ڷ� �䱸</a></li>
						<li><a href="#mokcha12" class="contentbutton3">22. ���������� �δ�</a></li>
						<li><a href="#mokcha13" class="contentbutton3">23. ������ ��������� �濵����</a></li>
						<li><a href="#mokcha14" class="contentbutton3">24. ���Ӱŷ�</a></li>
						<li><a href="#mokcha15" class="contentbutton3">25. �ϵ��� �ŷ��� �ϵ��� ��å�� ���� �ͻ��� ������ ����</a></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_30"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">�ۼ��ȳ�</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><span>��&nbsp;</span>�� ������ ����� �Ǵ� �ϵ��ްŷ��� <font style="font-weight:bold;" color="#3333CC">������ ��ǰ��(��� ���ݰ�꼭 ������)�� <%=st_Current_Year_n-1%>.1.1.~ <%=st_Current_Year_n-1%>.12.31.�Ⱓ�� ���ϴ� �ŷ�</font>�Դϴ�.</li>
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
						<li class="boxcontenttitle"><span>5. </span>�ͻ��� ���� <%=st_Current_Year_n-1%>�� �ϵ��ްŷ� ���´� ��մϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_5_1" value="<%=setHiddenValue(qa, 5, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_5_1" value="1" <%if(qa[5][1][1]!=null && qa[5][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"></input> ��. �ϵ����� �ޱ⸸ ��<span class="boxcontentsubtitle">��6-2��</span></li>
						<li><input type="radio" name="q2_5_1" value="2" <%if(qa[5][1][2]!=null && qa[5][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"></input> ��. �ϵ����� �ޱ⵵ �ϰ� �ֱ⵵ ��<span class="boxcontentsubtitle">��6-1��</span></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>6-1. </span>�ͻ簡 ���� 3�Ⱓ '��ü ���޻����'���� '�ϵ����� ��' �ݾ��� ���Դϱ�?</li>
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
										<th>��ü ����(����) ����ڿ��� �ϵ����� �� �ݾ�<br/>[VAT ���� �ݾ�]</th>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-3%>�⵵</th>
										<td>
											<input type="text" name="q2_6_1" value="<%=qa[6][1][20]%>" onkeyup="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> �鸸��
										</td>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-2%>�⵵</th>
										<td>
											<input type="text" name="q2_6_2" value="<%=qa[6][2][20]%>" onKeyUp="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> �鸸��
										</td>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-1%>�⵵</th>
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
						<li class="boxcontenttitle"><span>6-2. </span>�ͻ簡 ���� 3�Ⱓ '��ü ������ڵ�'�κ��� '�ϵ����� ����' �ݾ��� ���Դϱ�?</li>
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
										<th>��ü ��(����) ����ڵ�κ��� �ϵ����� ���� �ݾ�<br/>[VAT ���� �ݾ�]</th>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-3%>�⵵</th>
										<td>
											<input type="text" name="q2_6_4" value="<%=qa[6][4][20]%>" onkeyup ="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
										</td>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-2%>�⵵</th>
										<td>
											<input type="text" name="q2_6_5" value="<%=qa[6][5][20]%>" onKeyUp="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
										</td>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-1%>�⵵</th>
										<td>
											<input type="text" name="q2_6_6" value="<%=qa[6][6][20]%>" onkeyup ="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
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
						<li class="boxcontenttitle"><span>7. </span>�ͻ簡 <%= st_Current_Year_n-1%>�⵵�� �ŷ��� ��ü �������, ���޻���� ���� �� �����Դϱ�?</li>
						<li class="boxcontentsubtitle">* �� ����(����) ����ڴ� <%= st_Current_Year_n-1%>�⵵ ����ó��(����ó��) ���ݰ�꼭 �հ�ǥ�� ���Ե� ����ڵ�μ� �ϵ����� �ƴ� �ŷ��� ���� ����ڵ��� ������.</li>
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
											<input type="text" name="q2_7_1" onkeyup ="sukeyup(this); checkVal(this.form);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[7][1][20]%>"></input> ����
										</td>
									</tr>
									<tr>
										<th>�ͻ翡�� �ϵ����� �� �������</th>
										<td>
											<input type="text" name="q2_7_2" onkeyup ="sukeyup(this); checkVal(this.form);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[7][2][20]%>"></input> ����
										</td>
									</tr>
									<tr>
										<th>�� ���� �����</th>
										<td>
											<input type="text" name="q2_7_3" onkeyup ="sukeyup(this); checkVal(this.form);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[7][3][20]%>"></input> ����
										</td>
									</tr>
									<tr>
										<th>�ͻ簡 �ϵ����� �� ���޻����</th>
										<td>
											<input type="text" name="q2_7_4" onkeyup ="sukeyup(this); checkVal(this.form);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=qa[7][4][20]%>"></input> ����
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
					<ul class="clt">
						<li class="boxcontenttitle"><span>8. </span>�ͻ簡 ���� 3�Ⱓ '������ �������'�κ��� '�ϵ����� ����' �ݾ��� ���Դϱ�?</li>
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
										<th>������ ��(����) ����ڿ��� �ϵ��� �ŷ� �ݾ�<br/>[VAT ���� �ݾ�]</th>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-3%>�⵵</th>
										<td>
											<input type="text" name="q2_8_1" value="<%=qa[8][1][20]%>" onkeyup ="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
										</td>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-2%>�⵵</th>
										<td>
											<input type="text" name="q2_8_2" value="<%=qa[8][2][20]%>" onKeyUp="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
										</td>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-1%>�⵵</th>
										<td>
											<input type="text" name="q2_8_3" value="<%=qa[8][3][20]%>" onkeyup ="sukeyup(this);" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> �鸸��
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
						<li class="boxcontenttitle"><span>9. </span> <%=st_Current_Year_n-1%>�⵵ �ϵ��ްŷ� �Ը�(�ݾ�)�鿡�� '������ �������'�� �ͻ簡 �ϵ��ްŷ��� ���� '��ü ������ڵ�' �� �� ��°�� ū �ŷ����� �ش��մϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c2_9_1" value="<%=setHiddenValue(qa, 9, 1, 4)%>"/>
						<li><input type="radio" name="q2_9_1" value="1" <%if(qa[9][1][1]!=null && qa[9][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);"> ��. 1��</li>
						<li><input type="radio" name="q2_9_1" value="2" <%if(qa[9][1][2]!=null && qa[9][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);"> ��. 2��</li>
						<li><input type="radio" name="q2_9_1" value="3" <%if(qa[9][1][3]!=null && qa[9][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);"> ��. 3��</li>
						<li><input type="radio" name="q2_9_1" value="4" <%if(qa[9][1][4]!=null && qa[9][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);"> ��. 4�� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>10. </span> �ͻ簡 <%=st_Current_Year_n-1%>�⵵�� '������ �������'�� ���� ���� �ϵ��ްŷ��� �Ʒ� ���⿡�� ��� �ܰ迡 �ش��մϱ�?</li>
						<li class="boxcontentsubtitle">[����] ������ �ϼ���ü -> 1�� ���¾�ü -> 2�� ���¾�ü -> 3�� ���¾�ü -> 4�� ���¾�ü ��</li>
						<li class="boxcontentsubtitle">* �ͻ簡 ������ �ϼ���ü�κ��� �ϵ����� ���� ��� �ͻ�� 1�� ���¾�ü�� �ش�</li>
						<li class="boxcontentsubtitle">* �ͻ簡 1�� ���¾�ü�κ��� �ϵ����� ���� ��� �ͻ�� 2�� ���¾�ü�� �ش�</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c2_10_1" value="<%=setHiddenValue(qa, 10, 1, 5)%>"/>
						<li><input type="radio" name="q2_10_1" value="1" <%if(qa[10][1][1]!=null && qa[10][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> ��. �ͻ簡 1�� ���¾�ü</li>
						<li><input type="radio" name="q2_10_1" value="2" <%if(qa[10][1][2]!=null && qa[10][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> ��. �ͻ簡 2�� ���¾�ü</li>
						<li><input type="radio" name="q2_10_1" value="3" <%if(qa[10][1][3]!=null && qa[10][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> ��. �ͻ簡 3�� ���¾�ü</li>
						<li><input type="radio" name="q2_10_1" value="4" <%if(qa[10][1][4]!=null && qa[10][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> ��. �ͻ簡 4�� ���¾�ü</li>
						<li><input type="radio" name="q2_10_1" value="5" <%if(qa[10][1][5]!=null && qa[10][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> ��. �� ��</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent2">
				<ul class="boxcontenthelp lt">
					<li class="boxcontenttitle"><p align="center">�Ʒ� ���׵鿡 ���ؼ��� �ͻ簡 <%=st_Current_Year_n-1%>�⵵�� �ͻ��� �������[<%=ckOentName%>]�� ���� �ϵ��ްŷ��� �������� �����Ͽ� �ֽʽÿ�.</p></li>
				</ul>
			</div>

			<div class="fc pt_10"></div>
			
			<h2 class="contenttitle">�ϵ��ްŷ� ���λ��� 1 : �ŷ� ����</h2>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha1">11. ���޻���� ������� �� ��� ���</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��11-1���� ��11-7�� <strong>���޻���� ������� �� �����</strong>�� ���� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11-1. </span> �ͻ簡 <%= st_Current_Year_n-1%>�⵵�� ������ ��������� ���޻���ڷ� ������ ����� ��Ͽ����ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_11_1" value="<%=setHiddenValue(qa, 11, 1, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_11_1" value="1" <%if(qa[11][1][1]!=null && qa[11][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);"></input> ��. ���� ���ǰ�� ���</li>
						<li><input type="radio" name="q2_11_1" value="2" <%if(qa[11][1][2]!=null && qa[11][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);"></input> ��. �Ϻ� ���ǰ��, �Ϻ� �������� ���</li>
						<li><input type="radio" name="q2_11_1" value="3" <%if(qa[11][1][3]!=null && qa[11][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);"></input> ��. ���� �������� ���</li>
						<li><input type="radio" name="q2_11_1" value="4" <%if(qa[11][1][4]!=null && qa[11][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);"></input> ��. ��Ÿ(<input type="text" name="q2_11_21" value="<%=qa[11][21][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11-2. </span> �ͻ簡 <%= st_Current_Year_n-1%>�⵵�� ������ ������ڿ� �ϵ��ް���� ü���� �� �����༭(���ڹ��� ����)�� �ۼ��� ������ ��� �˴ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_11_2" value="<%=setHiddenValue(qa, 11, 2, 5)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_11_2" value="1" <%if(qa[11][2][1]!=null && qa[11][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,2);"></input> ��. 100% (��ü ������)<span class="boxcontentsubtitle">��11-6����</span></li>
						<li><input type="radio" name="q2_11_2" value="2" <%if(qa[11][2][2]!=null && qa[11][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,2);"></input> ��. 95% ~ 100% �̸� (������ ��� ������ ��ü ������)</li>
						<li><input type="radio" name="q2_11_2" value="3" <%if(qa[11][2][3]!=null && qa[11][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,2);"></input> ��. 75% ~ 95% �̸�</li>
						<li><input type="radio" name="q2_11_2" value="4" <%if(qa[11][2][4]!=null && qa[11][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,2);"></input> ��. 50% ~ 75% �̸�</li>
						<li><input type="radio" name="q2_11_2" value="5" <%if(qa[11][2][5]!=null && qa[11][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,2);"></input> ��. 50% �̸�</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle" ><span>11-3. </span> �ͻ簡 <%= st_Current_Year_n-1%>�⵵ ������ ������ڿ��� ��Ź ����� ���η� ���� ���, �ͻ簡 �ش� ������ڿ��� ��� ������ Ȯ���� ��û�ϴ� ����(�̸��Ϥ����ڹ��� ����)�� �߼��� ��찡 �� �� �ֽ��ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_11_3" value="<%=setHiddenValue(qa, 11, 3, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_11_3" value="1" <%if(qa[11][3][1]!=null && qa[11][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,3);"></input> ��. �ִ�(<input type="text" name="q2_11_22" value="<%=qa[11][22][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>��)<span class="boxcontentsubtitle">��11-4��</span></li>
						<li><input type="radio" name="q2_11_3" value="2" <%if(qa[11][3][2]!=null && qa[11][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,3);"></input> ��. ����<span class="boxcontentsubtitle">��11-6����</span></li>
					</ul>
					<div class="fc pt_50"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11-4. </span> �ͻ簡 ������ ������ڿ��� ��� ������ Ȯ���� ��û�ϴ� ������ �߼��� ����, �ش� ������ڰ� 15�� �̳��� ȸ���� �Ǽ��� �� ����� ��Ͽ����ϱ�?</li>
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
										<td><input type="text" name="q2_11_23" value="<%=qa[11][23][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ��</td>
									</tr>
									<tr>
										<th>���� ȸ��</th>
										<td><input type="text" name="q2_11_24" value="<%=qa[11][24][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ��</td>
									</tr>
									<tr>
										<th>���� ȸ��</th>
										<td><input type="text" name="q2_11_25" value="<%=qa[11][25][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ��</td>
									</tr>
									<tr>
										<th>15�� ���� ȸ�� �Ǵ� ȸ������ ����</th>
										<td><input type="text" name="q2_11_26" value="<%=qa[11][26][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ��</td>
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
						<li class="boxcontenttitle" ><span>11-5. </span> �ͻ簡 ������ ������ڷκ��� 15�� �̳��� ���� �Ǵ� ���η� ȸ�� ���� ���� ��Ȳ���� ����� ��Ҵ��� ��찡 �־����ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_11_5" value="<%=setHiddenValue(qa, 11, 5, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_11_5" value="1" <%if(qa[11][5][1]!=null && qa[11][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,5);"></input> ��. �ִ�(<input type="text" name="q2_11_27" value="<%=qa[11][27][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>��)</li>
						<li><input type="radio" name="q2_11_5" value="2" <%if(qa[11][5][2]!=null && qa[11][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,5);"></input> ��. ����</li>
					</ul>
					<div class="fc pt_50"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11-6. </span> �ͻ簡 <%= st_Current_Year_n-1%>�⵵�� ������ ������ڿ� �ϵ��ް���� ü���� �� ǥ���ϵ��ް�༭�� ����� ������ ��� �˴ϱ�?</li>
						<li class="boxcontentsubtitle">* �ֽ� ǥ���ϵ��ް�༭�� �ƴ� ���� ǥ���ϵ��ް�༭�� ����� ��쳪 ��������� Ư���� ����Ͽ� ǥ���ϵ��ް�༭�� �����Ͽ� ����� ��쿡�� ǥ���ϵ��ް�༭�� ����� ������ ������. ��, ���޻���ڿ��� �Ҹ��� ������ ���Ե��� �����ٴ� ���ǿ� ����.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_11_6" value="<%=setHiddenValue(qa, 11, 6, 5)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_11_6" value="1" <%if(qa[11][6][1]!=null && qa[11][6][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,6);"></input> ��. 100% (��ü ���)<span class="boxcontentsubtitle">��12-1��</span></li>
						<li><input type="radio" name="q2_11_6" value="2" <%if(qa[11][6][2]!=null && qa[11][6][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,6);"></input> ��. 95% ~ 100% �̸� (������ ��� ������ ��ü ���)</li>
						<li><input type="radio" name="q2_11_6" value="3" <%if(qa[11][6][3]!=null && qa[11][6][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,6);"></input> ��. 75% ~ 95% �̸�</li>
						<li><input type="radio" name="q2_11_6" value="4" <%if(qa[11][6][4]!=null && qa[11][6][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,6);"></input> ��. 50% ~ 75% �̸�</li>
						<li><input type="radio" name="q2_11_6" value="5" <%if(qa[11][6][5]!=null && qa[11][6][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,6);"></input> ��. 50% �̸�</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11-7. </span> ������ �� ǥ���ϵ��ް�༭�� ������� �ʾҴٸ� �ֵ� �� ������ �����Դϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_11_7" value="<%=setHiddenValue(qa, 11, 7, 6)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_11_7" value="1" <%if(qa[11][7][1]!=null && qa[11][7][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,7);"></input> ��. ������ڰ� ���� ��༭ ����� ����ϱ� ���߱� ����</li>
						<li><input type="radio" name="q2_11_7" value="2" <%if(qa[11][7][2]!=null && qa[11][7][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,7);"></input> ��. ���� ��༭ ��� ���� �� ���� �δ��� �����ϱ� ����</li>
						<li><input type="radio" name="q2_11_7" value="3" <%if(qa[11][7][3]!=null && qa[11][7][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,7);"></input> ��. �츮 �������� ǥ���ϵ��ް�༭ ����� �������� �ʱ� ����</li>
						<li><input type="radio" name="q2_11_7" value="4" <%if(qa[11][7][4]!=null && qa[11][7][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,7);"></input> ��. ǥ���ϵ��ް�༭ ������ ���� ���ǰ� ���� �ʱ� ����</li>
						<li><input type="radio" name="q2_11_7" value="5" <%if(qa[11][7][5]!=null && qa[11][7][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,7);"></input> ��. ǥ���ϵ��ް�༭�� �ִ��� ������ ����</li>
						<li><input type="radio" name="q2_11_7" value="6" <%if(qa[11][7][6]!=null && qa[11][7][6].equals("1")){out.print("checked");}%> onclick="checkradio(11,7);"></input> ��. ��Ÿ(<input type="text" name="q2_11_28" value="<%=qa[11][28][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha2">12. �ϵ��� ��� ü�� ��, �ϵ��� �ŷ� �ܰ��� ����</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��12-1���� ��12-3�� ������ ������ڿ��� <strong>�ϵ��� ��� ü���, �ϵ��� �ŷ� �ܰ��� ����</strong>�� ���� �����Դϴ�.</li>					
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>12-1. </span> <%= st_Current_Year_n-1%>�⵵�� �ͻ簡 ������ ������ڿ� ���� �ϵ��� �ŷ� �ܰ��� <%= st_Current_Year_n-2%>�⵵ �ܰ��� ���� ��������� ��� ���� �����Ǿ����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_12_1" value="<%=setHiddenValue(qa, 12, 1, 7)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_12_1" value="1" <%if(qa[12][1][1]!=null && qa[12][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> ��. 10% �̻� ����</li>
						<li><input type="radio" name="q2_12_1" value="2" <%if(qa[12][1][2]!=null && qa[12][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> ��. 5~10% �̸� ����</li>
						<li><input type="radio" name="q2_12_1" value="3" <%if(qa[12][1][3]!=null && qa[12][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> ��. 0~5% �̸� ����</li>
						<li><input type="radio" name="q2_12_1" value="4" <%if(qa[12][1][4]!=null && qa[12][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> ��. ��ȭ ����</li>
						<li><input type="radio" name="q2_12_1" value="5" <%if(qa[12][1][5]!=null && qa[12][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> ��. 0~5% �̸� �λ�</li>
						<li><input type="radio" name="q2_12_1" value="6" <%if(qa[12][1][6]!=null && qa[12][1][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> ��. 5~10% �̸� �λ�</li>
						<li><input type="radio" name="q2_12_1" value="7" <%if(qa[12][1][7]!=null && qa[12][1][7].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"></input> ��. 10% �̻� �λ�</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>12-2. </span> �ϵ��� �ܰ� ������ �Ʒ� ���ε��� ��������� ����Ͽ����ϱ�?</li>
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
										<th style="text-align: left;">1) ��������� �ΰǺ� ��ȭ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_12_11" value="<%=setHiddenValue(qa, 12, 11, 6)%>"></input>
											<input type="radio" name="q2_12_11" value="1" <%if(qa[12][11][1]!=null && qa[12][11][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,11);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_11" value="2" <%if(qa[12][11][2]!=null && qa[12][11][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,11);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_11" value="3" <%if(qa[12][11][3]!=null && qa[12][11][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,11);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_11" value="4" <%if(qa[12][11][4]!=null && qa[12][11][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,11);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_11" value="5" <%if(qa[12][11][5]!=null && qa[12][11][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,11);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_11" value="6" <%if(qa[12][11][6]!=null && qa[12][11][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,11);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">2) ������ڰ� ������ ������ ���� ��ȭ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_12_12" value="<%=setHiddenValue(qa, 12, 12, 6)%>"></input>
											<input type="radio" name="q2_12_12" value="1" <%if(qa[12][12][1]!=null && qa[12][12][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,12);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_12" value="2" <%if(qa[12][12][2]!=null && qa[12][12][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,12);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_12" value="3" <%if(qa[12][12][3]!=null && qa[12][12][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,12);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_12" value="4" <%if(qa[12][12][4]!=null && qa[12][12][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,12);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_12" value="5" <%if(qa[12][12][5]!=null && qa[12][12][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,12);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_12" value="6" <%if(qa[12][12][6]!=null && qa[12][12][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,12);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">3) �ͻ��� ���꼺 ��ȭ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_12_13" value="<%=setHiddenValue(qa, 12, 13, 6)%>"></input>
											<input type="radio" name="q2_12_13" value="1" <%if(qa[12][13][1]!=null && qa[12][13][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,13);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_13" value="2" <%if(qa[12][13][2]!=null && qa[12][13][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,13);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_13" value="3" <%if(qa[12][13][3]!=null && qa[12][13][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,13);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_13" value="4" <%if(qa[12][13][4]!=null && qa[12][13][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,13);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_13" value="5" <%if(qa[12][13][5]!=null && qa[12][13][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,13);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_13" value="6" <%if(qa[12][13][6]!=null && qa[12][13][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,13);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">4) �ͻ��� �ΰǺ� ��ȭ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_12_14" value="<%=setHiddenValue(qa, 12, 14, 6)%>"></input>
											<input type="radio" name="q2_12_14" value="1" <%if(qa[12][14][1]!=null && qa[12][14][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,14);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_14" value="2" <%if(qa[12][14][2]!=null && qa[12][14][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,14);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_14" value="3" <%if(qa[12][14][3]!=null && qa[12][14][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,14);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_14" value="4" <%if(qa[12][14][4]!=null && qa[12][14][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,14);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_14" value="5" <%if(qa[12][14][5]!=null && qa[12][14][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,14);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_14" value="6" <%if(qa[12][14][6]!=null && qa[12][14][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,14);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">5) �ͻ簡 ������ ������ ���� ��ȭ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_12_15" value="<%=setHiddenValue(qa, 12, 15, 6)%>"></input>
											<input type="radio" name="q2_12_15" value="1" <%if(qa[12][15][1]!=null && qa[12][15][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,15);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_15" value="2" <%if(qa[12][15][2]!=null && qa[12][15][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,15);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_15" value="3" <%if(qa[12][15][3]!=null && qa[12][15][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,15);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_15" value="4" <%if(qa[12][15][4]!=null && qa[12][15][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,15);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_15" value="5" <%if(qa[12][15][5]!=null && qa[12][15][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,15);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_15" value="6" <%if(qa[12][15][6]!=null && qa[12][15][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,15);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">6) ��ࡤ��ǰ�� ���� ��ȭ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_12_16" value="<%=setHiddenValue(qa, 12, 16, 6)%>"></input>
											<input type="radio" name="q2_12_16" value="1" <%if(qa[12][16][1]!=null && qa[12][16][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,16);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_16" value="2" <%if(qa[12][16][2]!=null && qa[12][16][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,16);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_16" value="3" <%if(qa[12][16][3]!=null && qa[12][16][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,16);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_16" value="4" <%if(qa[12][16][4]!=null && qa[12][16][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,16);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_16" value="5" <%if(qa[12][16][5]!=null && qa[12][16][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,16);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_16" value="6" <%if(qa[12][16][6]!=null && qa[12][16][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,16);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">7) ��������� �ڱݡ����� ���� ��ȭ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_12_17" value="<%=setHiddenValue(qa, 12, 17, 6)%>"></input>
											<input type="radio" name="q2_12_17" value="1" <%if(qa[12][17][1]!=null && qa[12][17][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,17);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_17" value="2" <%if(qa[12][17][2]!=null && qa[12][17][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,17);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_17" value="3" <%if(qa[12][17][3]!=null && qa[12][17][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,17);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_17" value="4" <%if(qa[12][17][4]!=null && qa[12][17][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,17);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_17" value="5" <%if(qa[12][17][5]!=null && qa[12][17][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,17);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_17" value="6" <%if(qa[12][17][6]!=null && qa[12][17][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,17);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">8) ȯ�� ��ȭ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_12_18" value="<%=setHiddenValue(qa, 12, 18, 6)%>"></input>
											<input type="radio" name="q2_12_18" value="1" <%if(qa[12][18][1]!=null && qa[12][18][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,18);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_18" value="2" <%if(qa[12][18][2]!=null && qa[12][18][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,18);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_18" value="3" <%if(qa[12][18][3]!=null && qa[12][18][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,18);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_18" value="4" <%if(qa[12][18][4]!=null && qa[12][18][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,18);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_18" value="5" <%if(qa[12][18][5]!=null && qa[12][18][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,18);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_18" value="6" <%if(qa[12][18][6]!=null && qa[12][18][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,18);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">9) ���� ���ݰ��� ���� ��ȭ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_12_19" value="<%=setHiddenValue(qa, 12, 19, 6)%>"></input>
											<input type="radio" name="q2_12_19" value="1" <%if(qa[12][19][1]!=null && qa[12][19][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,19);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_19" value="2" <%if(qa[12][19][2]!=null && qa[12][19][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,19);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_19" value="3" <%if(qa[12][19][3]!=null && qa[12][19][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,19);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_19" value="4" <%if(qa[12][19][4]!=null && qa[12][19][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,19);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_19" value="5" <%if(qa[12][19][5]!=null && qa[12][19][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,19);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_19" value="6" <%if(qa[12][19][6]!=null && qa[12][19][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,19);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">10) ��Ÿ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_12_20" value="<%=setHiddenValue(qa, 12, 20, 6)%>"></input>
											<input type="radio" name="q2_12_20" value="1" <%if(qa[12][20][1]!=null && qa[12][20][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,20);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_20" value="2" <%if(qa[12][20][2]!=null && qa[12][20][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,20);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_20" value="3" <%if(qa[12][20][3]!=null && qa[12][20][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,20);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_20" value="4" <%if(qa[12][20][4]!=null && qa[12][20][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,20);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_20" value="5" <%if(qa[12][20][5]!=null && qa[12][20][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,20);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_12_20" value="6" <%if(qa[12][20][6]!=null && qa[12][20][6].equals("1")){out.print("checked");}%> onclick="checkradio(12,20);"></input>
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
						<li class="boxcontenttitle"><span>12-3. </span> �ϵ��� �ܰ� ������ ��� �̷�������ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_12_3" value="<%=setHiddenValue(qa, 12, 3, 5)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_12_3" value="1" <%if(qa[12][3][1]!=null && qa[12][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,3);"></input> ��. ��������� �Ϲ��� ����</li>
						<li><input type="radio" name="q2_12_3" value="2" <%if(qa[12][3][2]!=null && qa[12][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,3);"></input> ��. ��������� ���Ȱ� �ͻ��� ����</li>
						<li><input type="radio" name="q2_12_3" value="3" <%if(qa[12][3][3]!=null && qa[12][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(12,3);"></input> ��. �ͻ��� ���Ȱ� ��������� ����</li>
						<li><input type="radio" name="q2_12_3" value="4" <%if(qa[12][3][4]!=null && qa[12][3][4].equals("1")){out.print("checked");}%> onclick="checkradio(12,3);"></input> ��. ������ ���Ǹ� ���� ����</li>
						<li><input type="radio" name="q2_12_3" value="5" <%if(qa[12][3][5]!=null && qa[12][3][5].equals("1")){out.print("checked");}%> onclick="checkradio(12,3);"></input> ��. ��Ÿ(<input type="text" name="q2_12_21" value="<%=qa[12][21][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha3">13. �뿪 ��Ź�� ��� �� ����</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��13-1���� ��13-2�� <strong>�뿪 ��Ź�� ��� �� ����</strong>�� ���� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>13-1. </span> <%= st_Current_Year_n-1%>�⵵�� ������ ������ڷκ��� �뿪 ��Ź�� ���� ��, ���Ƿ� ��Ź�� ��ҵǰų� ������� �ʰ� ������ ����� ����� ���Ǽ��� ������ ��� �˴ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
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
						<li class="boxcontenttitle"><span>13-2. </span> ������ ������ڰ� �뿪 ��Ź�� ����ϰų� ������ ������ �����Դϱ�?</li>
						<li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_13_2_1" value="1" <%if(qa[13][2][1]!=null && qa[13][2][1].equals("1")){out.print("checked");}%>></input> ��. ��������� ������ �Ǵ� �ŷ�ó�� �ֹ����</li>
						<li><input type="checkbox" name="q2_13_2_2" value="1" <%if(qa[13][2][2]!=null && qa[13][2][2].equals("1")){out.print("checked");}%>></input> ��. ��������� �Ǹź��� �Ǵ� ���� ���� ����</li>
						<li><input type="checkbox" name="q2_13_2_3" value="1" <%if(qa[13][2][3]!=null && qa[13][2][3].equals("1")){out.print("checked");}%>></input> ��. ������� �������� Ư������� ����</li>
						<li><input type="checkbox" name="q2_13_2_4" value="1" <%if(qa[13][2][4]!=null && qa[13][2][4].equals("1")){out.print("checked");}%>></input> ��. ��Ź�� ���� ������ �ͻ��� �ε��� ��������</li>
						<li><input type="checkbox" name="q2_13_2_5" value="1" <%if(qa[13][2][5]!=null && qa[13][2][5].equals("1")){out.print("checked");}%>></input> ��. �ͻ��� ��������(������ �Ǵ� �ֹ����� ���ؼ�)</li>
						<li><input type="checkbox" name="q2_13_2_6" value="1" <%if(qa[13][2][6]!=null && qa[13][2][6].equals("1")){out.print("checked");}%>></input> ��. ��Ÿ (<input type="text" name="q2_13_11" value="<%=qa[13][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="checkbox" name="q2_13_2_7" value="1" <%if(qa[13][2][7]!=null && qa[13][2][7].equals("1")){out.print("checked");}%> onclick="fn_chk(this.form, 13, 2);"></input> ��. ������ ��</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha4">14. ������ ����</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��14-1���� ��14-2�� <strong>������ ����</strong>�� ���� �����Դϴ�.</li>					
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>14-1. </span> ������ ������ڰ� <%= st_Current_Year_n-1%>�⵵�� �ͻ翡�� �������� �뿪 ��Ź�� ��, �װ��� ������ ������ ��� �˴ϱ�?</li>
						<li class="boxcontentsubtitle">* ���� ���� = 100*(������ �������Ǽ�/�뿪��Ź�� �������Ǽ�)</li>
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
						<li class="boxcontenttitle"><span>14-2. </span> ������ ������ڰ� �뿪 ��Ź�� �������� �������� ���� ������ �����Դϱ�?</li>
						<li class="boxcontentsubtitle">(�ش� �׸� ��� ����)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_14_2_1" value="1" <%if(qa[14][2][1]!=null && qa[14][2][1].equals("1")){out.print("checked");}%>></input> ��. ��������� �Ϲ����� ���ֺ��桤���</li>
						<li><input type="checkbox" name="q2_14_2_2" value="1" <%if(qa[14][2][2]!=null && qa[14][2][2].equals("1")){out.print("checked");}%>></input> ��. ��������� �Ǹź���</li>
						<li><input type="checkbox" name="q2_14_2_3" value="1" <%if(qa[14][2][3]!=null && qa[14][2][3].equals("1")){out.print("checked");}%>></input> ��. ������� �������� Ư������� ����</li>
						<li><input type="checkbox" name="q2_14_2_4" value="1" <%if(qa[14][2][4]!=null && qa[14][2][4].equals("1")){out.print("checked");}%>></input> ��. �ͻ簡 ��ǰ�� ��ǰ�� ǰ������(�ҷ� ��)</li>
						<li><input type="checkbox" name="q2_14_2_5" value="1" <%if(qa[14][2][5]!=null && qa[14][2][5].equals("1")){out.print("checked");}%>></input> ��. �ͻ簡 �ֹ������� �뿪�� �������� ����</li>
						<li><input type="checkbox" name="q2_14_2_6" value="1" <%if(qa[14][2][6]!=null && qa[14][2][6].equals("1")){out.print("checked");}%>></input> ��. �ͻ��� ��ǰ ����</li>
						<li><input type="checkbox" name="q2_14_2_7" value="1" <%if(qa[14][2][7]!=null && qa[14][2][7].equals("1")){out.print("checked");}%>></input> ��. ��Ÿ (<input type="text" name="q2_14_11" value="<%=qa[14][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha5">15. ���ü�� ��, �ϵ��޴�� ����</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��15-1���� ��15-2�� <strong>���ü�� ��</strong>, �ϵ��޴�� ���׿� ���� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>15-1. </span> <%= st_Current_Year_n-1%>�⵵�� �ͻ簡 ������ ������ڿ� ���� ����� �� ���ߴ� �ݾ״�� �ϵ��޴��(�ܰ�)�� ���޹��� ������ ��� �˴ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_15_1" value="<%=setHiddenValue(qa, 15, 1, 5)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_15_1" value="1" <%if(qa[15][1][1]!=null && qa[15][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"></input> ��. 100% (��ü����)<span class="boxcontentsubtitle">��16-1��</span></li>
						<li><input type="radio" name="q2_15_1" value="2" <%if(qa[15][1][2]!=null && qa[15][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"></input> ��. 95% ~ 100% �̸� (������ ��� ������ ��ü����)</li>
						<li><input type="radio" name="q2_15_1" value="3" <%if(qa[15][1][3]!=null && qa[15][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"></input> ��. 75% ~ 95% �̸�</li>
						<li><input type="radio" name="q2_15_1" value="4" <%if(qa[15][1][4]!=null && qa[15][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"></input> ��. 50% ~ 75% �̸�</li>
						<li><input type="radio" name="q2_15_1" value="5" <%if(qa[15][1][5]!=null && qa[15][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"></input> ��. 50% �̸�</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>15-2. </span> �ͻ簡 ���� ����� �� ���ߴ� �ݾ׺��� ������ ������ڷκ��� �ϵ��޴��(�ܰ�)�� ���� ���޹��� ������ �����Դϱ�?</li>
						<li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_15_2_1" value="1" <%if(qa[15][2][1]!=null && qa[15][2][1].equals("1")){out.print("checked");}%>></input> ��. ��������� ������ �Ǵ� �ŷ�ó�� �ֹ� ���</li>
						<li><input type="checkbox" name="q2_15_2_2" value="1" <%if(qa[15][2][2]!=null && qa[15][2][2].equals("1")){out.print("checked");}%>></input> ��. ��������� �Ǹź����� ���� ����д�</li>
						<li><input type="checkbox" name="q2_15_2_3" value="1" <%if(qa[15][2][3]!=null && qa[15][2][3].equals("1")){out.print("checked");}%>></input> ��. ������Ǹ��������� ���� �Ҵ��� �ݿ�</li>
						<li><input type="checkbox" name="q2_15_2_4" value="1" <%if(qa[15][2][4]!=null && qa[15][2][4].equals("1")){out.print("checked");}%>></input> ��. ��������� �ڱݻ����� ���</li>
						<li><input type="checkbox" name="q2_15_2_5" value="1" <%if(qa[15][2][5]!=null && qa[15][2][5].equals("1")){out.print("checked");}%>></input> ��. ������ڰ� ȯ���������� ���� ���ظ� �ݿ�</li>
						<li><input type="checkbox" name="q2_15_2_6" value="1" <%if(qa[15][2][6]!=null && qa[15][2][6].equals("1")){out.print("checked");}%>></input> ��. ��� ���ɽ����� ������ �����϶��� �ݿ�</li>
						<li><input type="checkbox" name="q2_15_2_7" value="1" <%if(qa[15][2][7]!=null && qa[15][2][7].equals("1")){out.print("checked");}%>></input> ��. ��ǰ�� �������� �ǸŰ��� �϶��� �ݿ�</li>
						<li><input type="checkbox" name="q2_15_2_8" value="1" <%if(qa[15][2][8]!=null && qa[15][2][8].equals("1")){out.print("checked");}%>></input> ��. �Ҹ�Ȯ�� ������ ������ڰ� �Ϲ������� ����</li>
						<li><input type="checkbox" name="q2_15_2_9" value="1" <%if(qa[15][2][9]!=null && qa[15][2][9].equals("1")){out.print("checked");}%>></input> ��. �ͻ��� ��������(������ ����, �ֹ����� ���ؼ� ��)</li>
						<li><input type="checkbox" name="q2_15_2_10" value="1" <%if(qa[15][2][10]!=null && qa[15][2][10].equals("1")){out.print("checked");}%>></input> ��. ��Ÿ (<input type="text" name="q2_15_11" value="<%=qa[15][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha6">16. �ϵ��޴�� ����</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��16-1���� ��16-6�� <strong>�ϵ��޴�� ����</strong>�� ���� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>16-1. </span> �ͻ簡 �������� ���� ��ǰ�Ͽ������� <%= st_Current_Year_n-1%>�� 12�� ������ ������ ������ڷκ��� �ϵ��� ����� ���޹��� ���� ���� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_16_1" value="<%=setHiddenValue(qa, 16, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_16_1" value="1" <%if(qa[16][1][1]!=null && qa[16][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> ��. �ִ�(<input type="text" name="q2_16_11" value="<%=qa[16][11][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>��)</li>
						<li><input type="radio" name="q2_16_1" value="2" <%if(qa[16][1][2]!=null && qa[16][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> ��. ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>16-2. </span> �ͻ簡 <%= st_Current_Year_n-1%>�⵵�� ������ ������ڷκ��� ���� �ϵ��޴���� ���� ���ܺ� ������ ��� �˴ϱ�?</li>
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
									<col style="width:60%;" />
									<col style="width:40%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>����</th>
										<th>����</th>
									</tr>
									<tr>
										<th>����(��ǥ ����)</th>
										<td><input type="text" name="q2_16_21" value="<%=qa[16][21][20]%>" onKeyUp="sukeyup(this); fn_hap16_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>�ܻ����ä�� �㺸����(���� 1�� ����, ��ȯû���� ��)</th>
										<td><input type="text" name="q2_16_22" value="<%=qa[16][22][20]%>" onKeyUp="sukeyup(this); fn_hap16_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>�����������ī��(���� 1�� ����)</th>
										<td><input type="text" name="q2_16_23" value="<%=qa[16][23][20]%>" onKeyUp="sukeyup(this); fn_hap16_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>���ŷ�(���� 1�� ����)</th>
										<td><input type="text" name="q2_16_24" value="<%=qa[16][24][20]%>" onKeyUp="sukeyup(this); fn_hap16_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>������� �ý���(���� 1�� ����)</th>
										<td><input type="text" name="q2_16_25" value="<%=qa[16][25][20]%>" onKeyUp="sukeyup(this); fn_hap16_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>�� ������ü��������(��, ���� 1�� �ʰ�)</th>
										<td><input type="text" name="q2_16_26" value="<%=qa[16][26][20]%>" onKeyUp="sukeyup(this); fn_hap16_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>����(���� 60�� ����)</th>
										<td><input type="text" name="q2_16_27" value="<%=qa[16][27][20]%>" onKeyUp="sukeyup(this); fn_hap16_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>����(�ϵ��� �ŷ� ����. ���� 61��~120��)</th>
										<td><input type="text" name="q2_16_28" value="<%=qa[16][28][20]%>" onKeyUp="sukeyup(this); fn_hap16_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>����(�ϵ��� �ŷ� ����. ���� 121�� �ʰ�)</th>
										<td><input type="text" name="q2_16_29" value="<%=qa[16][29][20]%>" onKeyUp="sukeyup(this); fn_hap16_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>��Ÿ</th>
										<td><input type="text" name="q2_16_30" value="<%=qa[16][30][20]%>" onKeyUp="sukeyup(this); fn_hap16_2(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>�հ�</th>
										<td><input type="text" readonly="readonly" name="allSum16_2" value="" size="30" class="text03b"></input> %</td>
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
						<li class="boxcontenttitle"><span>16-3 </span> �ͻ簡 ������ ������ڷκ��� �ϵ��� ����� �����Կ� �־�, ������ ��ǰ�Ϸκ��� 60���� �ʰ��Ͽ� ����� ������ ������ ��� �˴ϱ�?</li>
						<li class="boxcontentsubtitle">* ������ ��ǰ���� ��� ���ġ����������� ��ǰ�� �Ǵ� ���� ���޿Ϸ����� �������� ��.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_16_3" value="<%=setHiddenValue(qa, 16, 3, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_16_3" value="1" <%if(qa[16][3][1]!=null && qa[16][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> ��. ����<span class="boxcontentsubtitle">��17-1��</span></li>
						<li><input type="radio" name="q2_16_3" value="2" <%if(qa[16][3][2]!=null && qa[16][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> ��. 30% �̸�</li>
						<li><input type="radio" name="q2_16_3" value="3" <%if(qa[16][3][3]!=null && qa[16][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> ��. 30% ~ 50% �̸�</li>
						<li><input type="radio" name="q2_16_3" value="4" <%if(qa[16][3][4]!=null && qa[16][3][4].equals("1")){out.print("checked");}%> onclick="checkradio(16,3);"></input> ��. 50% �̻�</li>
					</ul>
					<div class="fc pt_10"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>16-4 </span> 60���� �ʰ��Ͽ� �ϵ��޴���� ������ ��찡 �ִٸ�, �� ����� ���޹��� ���ܺ� ������ ��� �˴ϱ�?</li>
                        <li class="boxcontentsubtitle">* ���� : �������� ���� �ǹ�����(���̾���) �̿ܿ� "���ھ����� ���� �� ���뿡 ���� ����"�� ���� ����� ���ھ����� �����Ͽ� �ۼ�</li>            
						<li class="boxcontentsubtitle">* ������ü �������� : �����������ī��, �ܻ����ä�Ǵ㺸����, ���ŷ� ��</li>
						<li class="boxcontentsubtitle">* ��Ÿ : �빰���� �� �ٸ� �������� ������ ��� ����</li>
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
										<th>����(��ǥ ����)</th>
										<td><input type="text" name="q2_16_31" value="<%=qa[16][31][20]%>" onKeyUp="sukeyup(this); fn_hap16_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>������ü ��������</th>
										<td><input type="text" name="q2_16_32" value="<%=qa[16][32][20]%>" onKeyUp="sukeyup(this); fn_hap16_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>����</th>
										<td><input type="text" name="q2_16_33" value="<%=qa[16][33][20]%>" onKeyUp="sukeyup(this); fn_hap16_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>��Ÿ</th>
										<td><input type="text" name="q2_16_34" value="<%=qa[16][34][20]%>" onKeyUp="sukeyup(this); fn_hap16_4(this.form);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> %</td>
									</tr>
									<tr>
										<th>�հ�</th>
										<td><input type="text" readonly="readonly" name="allSum16_4" value="" size="30" class="text03b"></input> %</td>
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
						<li class="boxcontenttitle"><span>16-5. </span> 60���� �ʰ��Ͽ� �ϵ��޴���� ������ ���, �������ڡ��������ηᡤ������� ���������� � �����Ͽ����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_16_5" value="<%=setHiddenValue(qa, 16, 5, 3)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_16_5" value="1" <%if(qa[16][5][1]!=null && qa[16][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,5);"></input> ��. ���� ����</li>
						<li><input type="radio" name="q2_16_5" value="2" <%if(qa[16][5][2]!=null && qa[16][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,5);"></input> ��. �Ϻ� ����(�Ϻ� �̼���)</li>
						<li><input type="radio" name="q2_16_5" value="3" <%if(qa[16][5][3]!=null && qa[16][5][3].equals("1")){out.print("checked");}%> onclick="checkradio(16,5);"></input> ��. ���� �̼���</li>
					</ul>
					<div class="fc pt_30"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>16-6. </span> ������ ������ڰ� �������ڡ��������ηᡤ������� ���������� ���� �ϴ� �ͻ翡 ������ ��, �ٽ� ȸ���ذ��ų� �� ������ŭ �ϵ��޴���� ������ ����� �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_16_6" value="<%=setHiddenValue(qa, 16, 6, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_16_6" value="1" <%if(qa[16][6][1]!=null && qa[16][6][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> ��. �ִ�</li>
						<li><input type="radio" name="q2_16_6" value="2" <%if(qa[16][6][2]!=null && qa[16][6][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"></input> ��. ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha7">17. ���޿���(����, �빫��, ��� ��) ������ ���� �ϵ��޴�� ���� ��û</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��17-1���� ��17-5�� <strong>���޿���(����, �빫��, ��� ��) ������ ���� �ϵ��޴�� ���� ��û</strong>�� ���� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>17-1. </span> �ͻ�� �ϵ��޴�� ���������� ���� �˰� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle">* �ϵ��޴�� �������� : ���޿���(����, �빫��, ��� ��) �������� �ϵ��޴���� ������ �Ұ����� ���, ���޻���� �Ǵ� ���޻���ڰ� ���� �߼ұ������������ ������ڿ��� �ϵ��޴�� ������û�� �� �� ����. ������ڴ� 10�� �̳� ���Ǹ� �����Ͽ��� �ϰ�, ������ �������� ���Ǹ� �ź��ϰų� ������ �Ͽ����� �ƴ� ��.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_17_1" value="<%=setHiddenValue(qa, 17, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_17_1" value="1" <%if(qa[17][1][1]!=null && qa[17][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"></input> ��. �˰� ����</li>
						<li><input type="radio" name="q2_17_1" value="2" <%if(qa[17][1][2]!=null && qa[17][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"></input> ��. �� ��</li>
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
						<li class="boxcontenttitle"><span>17-2. </span> <%= st_Current_Year_n-1%>�⵵�� ���޿��� ����� ������ ������ ������ڿ��� �ϵ��޴�� ������ �ͻ簡 ���� ��û�ϰų�, �߼ұ������������ ���� ��û�� ���� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_17_2" value="<%=setHiddenValue(qa, 17, 2, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_17_2" value="1" <%if(qa[17][2][1]!=null && qa[17][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(17,2);"></input> ��. �ִ�<span class="boxcontentsubtitle">��17-3����</span></li>
						<li><input type="radio" name="q2_17_2" value="2" <%if(qa[17][2][2]!=null && qa[17][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(17,2);"></input> ��. ����<span class="boxcontentsubtitle">��17-5��</span></li>
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
						<li class="boxcontenttitle"><span>17-3. </span> �ͻ簡 �ϵ��޴�� ���� ��û�� �� �Ǽ��� ��û �� 10�� �̳��� ������ ������ڰ� ���Ǹ� ������ �Ǽ��� �� ���Դϱ�?</li>
						<li class="boxcontentsubtitle">* �ϵ��޴�� ���� ��û(A)�� �� �� ���� �ǿ� ���Ͽ� �߼ұ������������ ���Ͽ� ��� ������ ���û(B)�� ����, ����(B)�� ������û �Ǽ��θ� ���</li>
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
										<th>��û �Ǽ�</th>
										<th>10�� �̳� ���Ǹ� ������ �� ��</th>
									</tr>
									<tr>
										<th>���� �ϵ��޴�� ������û</th>
										<td>
											<input type="text" name="q2_17_11" value="<%=qa[17][11][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ��
										</td>
										<td>
											<input type="text" name="q2_17_12" value="<%=qa[17][12][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ��
										</td>
									</tr>
									<tr>
										<th>�߼ұ������������ ���� ������û</th>
										<td>
											<input type="text" name="q2_17_13" value="<%=qa[17][13][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ��
										</td>
										<td>
											<input type="text" name="q2_17_14" value="<%=qa[17][14][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ��
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
						<li class="boxcontenttitle"><span>17-4. </span> �ͻ簡 ���� �Ǵ� �߼ұ������������ ���� �ϵ��޴�� �λ� ��û�� �� ��쿡 ���Ͽ�, ������ ������ڰ� ��û������ <u>�Ϻ� �Ǵ� ��������</u> ������ ������ ��� �˴ϱ�? �Ǽ��� �������� �����Ͽ� �ֽʽÿ�.</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_17_4" value="<%=setHiddenValue(qa, 17, 4, 6)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_17_4" value="1" <%if(qa[17][4][1]!=null && qa[17][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(17,4);"></input> ��. 100% (��ü ����)</li>
						<li><input type="radio" name="q2_17_4" value="2" <%if(qa[17][4][2]!=null && qa[17][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(17,4);"></input> ��. 75% ~ 100% �̸�</li>
						<li><input type="radio" name="q2_17_4" value="3" <%if(qa[17][4][3]!=null && qa[17][4][3].equals("1")){out.print("checked");}%> onclick="checkradio(17,4);"></input> ��. 50% ~ 75% �̸�</li>
						<li><input type="radio" name="q2_17_4" value="4" <%if(qa[17][4][4]!=null && qa[17][4][4].equals("1")){out.print("checked");}%> onclick="checkradio(17,4);"></input> ��. 25% ~ 50% �̸�</li>
						<li><input type="radio" name="q2_17_4" value="5" <%if(qa[17][4][5]!=null && qa[17][4][5].equals("1")){out.print("checked");}%> onclick="checkradio(17,4);"></input> ��. 25% �̸�</li>
						<li><input type="radio" name="q2_17_4" value="6" <%if(qa[17][4][6]!=null && qa[17][4][6].equals("1")){out.print("checked");}%> onclick="checkradio(17,4);"></input> ��. 0% (��ü �̼���)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>17-5. </span> �ͻ��� ���޿����� �λ�Ǿ������� �ұ��ϰ�, ������ ������ڿ��� �ϵ��޴�� �λ��� ��û���� ���� ��찡 �־��ٸ� �� ������ �����Դϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_17_5" value="<%=setHiddenValue(qa, 17, 5, 7)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_17_5" value="1" <%if(qa[17][5][1]!=null && qa[17][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(17,5);"></input> ��. ���޿��� ������� �̹��ؼ�</li>
						<li><input type="radio" name="q2_17_5" value="2" <%if(qa[17][5][2]!=null && qa[17][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(17,5);"></input> ��. ������ڰ� �ϵ��޴���� �̹� �����ؼ�</li>
						<li><input type="radio" name="q2_17_5" value="3" <%if(qa[17][5][3]!=null && qa[17][5][3].equals("1")){out.print("checked");}%> onclick="checkradio(17,5);"></input> ��. ���� ��ǰ���ݿ� �ݿ��ϱ�� �����ؼ�</li>
						<li><input type="radio" name="q2_17_5" value="4" <%if(qa[17][5][4]!=null && qa[17][5][4].equals("1")){out.print("checked");}%> onclick="checkradio(17,5);"></input> ��. ��û�ص� ������ڰ� ������ �� ���� �ʾƼ�</li>
						<li><input type="radio" name="q2_17_5" value="5" <%if(qa[17][5][5]!=null && qa[17][5][5].equals("1")){out.print("checked");}%> onclick="checkradio(17,5);"></input> ��. �ŷ��� ���, �ŷ� ���� �� ��������� ������ �η�����</li>
						<li><input type="radio" name="q2_17_5" value="6" <%if(qa[17][5][6]!=null && qa[17][5][6].equals("1")){out.print("checked");}%> onclick="checkradio(17,5);"></input> ��. ��Ÿ(<input type="text" name="q2_17_15" value="<%=qa[17][15][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="radio" name="q2_17_5" value="7" <%if(qa[17][5][7]!=null && qa[17][5][7].equals("1")){out.print("checked");}%> onclick="checkradio(17,5);"></input> ��. �ش���� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha8">18. �ϵ��޹� ����</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��18-1���� ��18-4�� ������ ��������� <strong>�ϵ��޹� ����</strong>�� ���� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18-1. </span> �ͻ� �Ǵ� �ͻ簡 �Ҽӵ� ������ <%= st_Current_Year_n-1%>�� ���� ������ �� ���� ����� ������ ������ڿ��� �ϵ��޹� ������ �Ű��� ��찡 �� �� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_18_1" value="<%=setHiddenValue(qa, 18, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_18_1" value="1" <%if(qa[18][1][1]!=null && qa[18][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"></input> ��. �ִ�(<input type="text" name="q2_18_11" value="<%=qa[18][11][20]%>" onkeyup ="sukeyup(this)" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>��)</li>
						<li><input type="radio" name="q2_18_1" value="2" <%if(qa[18][1][2]!=null && qa[18][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"></input> ��. ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18-2. </span> <%= st_Current_Year_n-1%>�� ���� �ͻ� �Ǵ� �ͻ� ������ (�ϵ��� ����������� ���� ���뿡 ���� �ļ� ���� ��������) ������ ������ڿ��� �ϵ��� �ŷ��� ���� �����ڷḦ �������� ������ ��찡 �� �� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_18_2" value="<%=setHiddenValue(qa, 18, 2, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_18_2" value="1" <%if(qa[18][2][1]!=null && qa[18][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,2);"></input> ��. �ִ�(<input type="text" name="q2_18_12" value="<%=qa[18][12][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>��)</li>
						<li><input type="radio" name="q2_18_2" value="2" <%if(qa[18][2][2]!=null && qa[18][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,2);"></input> ��. ����<span class="boxcontentsubtitle">��19��</span></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18-3. </span> �ͻ��  <%= st_Current_Year_n-1%>�� ���� �Ű� ������û �Ǵ� ����������翡 ���� �����ڷḦ �����Ͽ��ٴ� ������ ������ ������ڷκ��� �������� ���� ��찡 �� �� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_18_3" value="<%=setHiddenValue(qa, 18, 3, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_18_3" value="1" <%if(qa[18][3][1]!=null && qa[18][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,3);"></input> ��. �ִ�(<input type="text" name="q2_18_13" value="<%=qa[18][13][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>��)</li>
						<li><input type="radio" name="q2_18_3" value="2" <%if(qa[18][3][2]!=null && qa[18][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,3);"></input> ��. ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18-4. </span> �ͻ簡 ������ ������ڷκ��� �������� ���� ����� �ִٸ�, �Ʒ��� �ش��׸��� ��� �����Ͽ� �ֽʽÿ�.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_18_4_1" value="1" <%if(qa[18][4][1]!=null && qa[18][4][1].equals("1")){out.print("checked");}%>></input> ��. ���ֱ�ȸ ����</li>
						<li><input type="checkbox" name="q2_18_4_2" value="1" <%if(qa[18][4][2]!=null && qa[18][4][2].equals("1")){out.print("checked");}%>></input> ��. �ŷ� �ߴ�</li>
						<li><input type="checkbox" name="q2_18_4_3" value="1" <%if(qa[18][4][3]!=null && qa[18][4][3].equals("1")){out.print("checked");}%>></input> ��. ��Ÿ (<input type="text" name="q2_18_14" value="<%=qa[18][14][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha9">19. ���°���</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��19�� ������ ������ڿ��� <strong>���°���</strong>�� ���� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>19. </span> <%= st_Current_Year_n-1%>�⵵�� ������ ������ڰ� �ͻ���� ���°��� ������ ���� ������ ������ ���� �Ǵ� �������� ������ ��찡 �� �� �ֽ��ϱ�?</li>
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
										<td><input type="text" name="q2_19_1" value="<%=qa[19][1][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ��</td>
									</tr>
									<tr>
										<th>����(�����硤����) ����</th>
										<td><input type="text" name="q2_19_2" value="<%=qa[19][2][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ��</td>
									</tr>
									<tr>
										<th>�η�(����) ����</th>
										<td><input type="text" name="q2_19_3" value="<%=qa[19][3][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ��</td>
									</tr>
									<tr>
										<th>���(����) ����</th>
										<td><input type="text" name="q2_19_4" value="<%=qa[19][4][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ��</td>
									</tr>
									<tr>
										<th>�濵(�����á�����ȭ) ����</th>
										<td><input type="text" name="q2_19_5" value="<%=qa[19][5][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ��</td>
									</tr>
									<tr>
										<th>�Ƿ�(����������) ����</th>
										<td><input type="text" name="q2_19_6" value="<%=qa[19][6][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ��</td>
									</tr>
									<tr>
										<th>��Ÿ ����</th>
										<td><input type="text" name="q2_19_7" value="<%=qa[19][7][20]%>" onkeyup ="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> ��</td>
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
					<li class="noneboxcontenttitle"><a name="mokcha10">20. Ư��</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��20-1���� ��20-2�� <strong>Ư��</strong>�� ���� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>20-1. </span> �ͻ簡 <%= st_Current_Year_n-1%>�⵵�� ������ ������ڿͿ� �ϵ��ް�� ���� ü���ϸ鼭 ��༭ � Ư�� ������ �����Ͽ� �ۼ��� ���� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle">* Ư���� �ϵ��� �� ��༭�Ӹ� �ƴ϶� Ŭ���� ������ �� ���� �Ǹ����ǹ� ���踦 ������ ���� ���� ����</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_20_1" value="<%=setHiddenValue(qa, 20, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_20_1" value="1" <%if(qa[20][1][1]!=null && qa[20][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"></input> ��. �ִ�</li>
						<li><input type="radio" name="q2_20_1" value="2" <%if(qa[20][1][2]!=null && qa[20][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"></input> ��. ����<span class="boxcontentsubtitle">��21-1��</span></li>
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
						<li class="boxcontenttitle"><span>20-2. </span> �ͻ簡 <%= st_Current_Year_n-1%>�⵵�� ������ ������ڿ� ü���� �ϵ��ް�༭ � ���Ե� Ư�೻���� �����Դϱ�?</li>
						<li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_20_2_1" value="1" <%if(qa[20][2][1]!=null && qa[20][2][1].equals("1")){out.print("checked");}%>></input> ��. �������� ���ǵ��� �ʰų� ������ �� ���� �������� ���� ����� �ͻ簡 �δ㡤�д�</li>
						<li><input type="checkbox" name="q2_20_2_2" value="1" <%if(qa[20][2][2]!=null && qa[20][2][2].equals("1")){out.print("checked");}%>></input> ��. �ο�ó��, �Ρ��㰡, ȯ�����, ǰ������ � ���� ����� �ͻ簡 �δ㡤�д�</li>
						<li><input type="checkbox" name="q2_20_2_3" value="1" <%if(qa[20][2][3]!=null && qa[20][2][3].equals("1")){out.print("checked");}%>></input> ��. ���� �� �۾����� �������� �߻��� ����� �ͻ簡 �δ㡤�д�</li>
						<li><input type="checkbox" name="q2_20_2_4" value="1" <%if(qa[20][2][4]!=null && qa[20][2][4].equals("1")){out.print("checked");}%>></input> ��. ���ڴ㺸å�� �Ǵ� ���ع��å�� ���࿡ ���� ����� �ͻ簡 �δ㡤�д�</li>
						<li><input type="checkbox" name="q2_20_2_5" value="1" <%if(qa[20][2][5]!=null && qa[20][2][5].equals("1")){out.print("checked");}%>></input> ��. ��������� �䱸�� ���� ���۾�, �����۾� �� �߻��ϴ� ����� �ͻ簡 �δ㡤�д�</li>
						<li><input type="checkbox" name="q2_20_2_6" value="1" <%if(qa[20][2][6]!=null && qa[20][2][6].equals("1")){out.print("checked");}%>></input> ��. ��Ÿ (<input type="text" name="q2_20_11" value="<%=qa[20][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha11">21. ������ ��������� ����ڷ� �䱸</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��21-1���� ��21-9�� <strong>������ ��������� ����ڷ� �䱸</strong>�� ���� �����Դϴ�.</li>          
				</ul>
			</div>
			
			<div class="boxcontent2">
				<ul class="boxcontenthelp lt">
					<li class="boxcontenttitle">"����ڷ�"�� �ͻ��� ����� ��¿� ���Ͽ� ������� ���� ��з� �����ǰ� �ִ� ����� �Ǵ� �濵���� �����μ� �Ʒ� �׸� �� �ϳ��� �ش��ϴ� �������ڷḦ ����.</li>
					<li class="boxcontenttitle">&nbsp;</li>
					<li class="boxcontenttitle">��. �������������ð� �Ǵ� �뿪���� ����� ���� �������ڷ�.</li>
					<li class="boxcontenttitle">��. Ư���, �ǿ�žȱ�, �����α�, ���۱� ���� �������ǰ� ���õ� ����������ڷ�μ� ���޻������ �������(R&D)�����ꡤ����Ȱ���� �����ϰ� ������ ������ ��ġ�� �ִ� ��.</li>
					<li class="boxcontenttitle">��. �ð����μ��� �޴���, ��� ����, ���赵��, ���� ���� ������, ���� ���� �� ���� �Ǵ� ���� ���Ե��� �ʴ� ��Ÿ ������� ����� �Ǵ� �濵���� �������ڷ�μ� ���޻������ �������(R&D)�����ꡤ����Ȱ���� �����ϰ� ������ ������ ��ġ�� �ִ� ��.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>21-1. </span> �ͻ��  <%= st_Current_Year_n-1%>�⵵�� ������ ������ڷκ��� ����ڷ� ������ �䱸���� ���� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_21_1" value="<%=setHiddenValue(qa, 21, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_21_1" value="1" <%if(qa[21][1][1]!=null && qa[21][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"></input> ��. �ִ�</li>
						<li><input type="radio" name="q2_21_1" value="2" <%if(qa[21][1][2]!=null && qa[21][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"></input> ��. ����<span class="boxcontentsubtitle">��21-9��</span></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>21-2. </span> ������ ������ڰ� �ͻ翡�� ����ڷḦ �䱸�� ������ �����Դϱ�?</li>
						<li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_21_2_1" value="1" <%if(qa[21][2][1]!=null && qa[21][2][1].equals("1")){out.print("checked");}%>></input> ��. ���� Ư�� ����</li>
						<li><input type="checkbox" name="q2_21_2_2" value="1" <%if(qa[21][2][2]!=null && qa[21][2][2].equals("1")){out.print("checked");}%>></input> ��. ���� ������� ���� ü��</li>
						<li><input type="checkbox" name="q2_21_2_3" value="1" <%if(qa[21][2][3]!=null && qa[21][2][3].equals("1")){out.print("checked");}%>></input> ��. ��ǰ ������ ���αԸ�</li>
						<li><input type="checkbox" name="q2_21_2_4" value="1" <%if(qa[21][2][4]!=null && qa[21][2][4].equals("1")){out.print("checked");}%>></input> ��. ��Ÿ (<input type="text" name="q2_21_11" value="<%=qa[21][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="checkbox" name="q2_21_2_5" value="1" <%if(qa[21][2][5]!=null && qa[21][2][5].equals("1")){out.print("checked");}%>></input> ��. ������ �� ��</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>21-3. </span> �ͻ�� ������ ��������� �䱸�� ���� ����ڷḦ �����Ͽ����ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_21_3" value="<%=setHiddenValue(qa, 21, 3, 3)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_21_3" value="1" <%if(qa[21][3][1]!=null && qa[21][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,3);"></input> ��. ��� ������</li>
						<li><input type="radio" name="q2_21_3" value="2" <%if(qa[21][3][2]!=null && qa[21][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,3);"></input> ��. �Ϻ� ������</li>
						<li><input type="radio" name="q2_21_3" value="3" <%if(qa[21][3][3]!=null && qa[21][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,3);"></input> ��. �������� ����<span class="boxcontentsubtitle">��22-1��</span></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>21-4. </span> ������ ������ڰ� �ͻ翡�� �䱸�� ����ڷ��� ��Ī�� �ͻ��� ���������� �����Ͽ� �ֽʽÿ�.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:20%;" />
									<col style="width:50%;" />
									<col style="width:30%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>����</th>
										<th>������ ������ڰ� �䱸�� ����ڷ� ��Ī</th>
										<th>��������</th>
									</tr>
                                    <tr>
                                      <th>����</th>
                                      <td>A��ǰ ���� ���� ����������</td>
                                      <td>��������/�Ϻ����� �Ǵ� ������</td>
                                    </tr>
                                    <tr>
                                      <th>����</th>
                                      <td>B��ǰ ���� ���� ���赵��</td>
                                      <td>��������/�Ϻ����� �Ǵ� ������</td>
                                    </tr>                  
									<tr>
										<th>1</th>
										<td>
											<input type="text" name="q2_21_21" value="<%=qa[21][21][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_21_27" value="<%=qa[21][27][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>2</th>
										<td>
											<input type="text" name="q2_21_22" value="<%=qa[21][22][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_21_28" value="<%=qa[21][28][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>3</th>
										<td>
											<input type="text" name="q2_21_23" value="<%=qa[21][23][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_21_29" value="<%=qa[21][29][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>4</th>
										<td>
											<input type="text" name="q2_21_24" value="<%=qa[21][24][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_21_30" value="<%=qa[21][30][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>5</th>
										<td>
											<input type="text" name="q2_21_25" value="<%=qa[21][25][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_21_31" value="<%=qa[21][31][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>6</th>
										<td>
											<input type="text" name="q2_21_26" value="<%=qa[21][26][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_21_32" value="<%=qa[21][32][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
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
						<li class="boxcontenttitle"><span>21-5. </span> ������ ������ڴ� �ͻ�κ��� ����� ����ڷḦ ��� Ȱ���Ͽ����ϱ�?</li>
						<li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_21_5_1" value="1" <%if(qa[21][5][1]!=null && qa[21][5][1].equals("1")){out.print("checked");}%>></input> ��. ����Ư��, ���� ������� ���� ü��, ��ǰ������ ���αԸ� �����Ͽ� ���</li>
						<li><input type="checkbox" name="q2_21_5_2" value="1" <%if(qa[21][5][2]!=null && qa[21][5][2].equals("1")){out.print("checked");}%>></input> ��. ����Ư��, ���� ������� ���� ü��, ��ǰ������ ���αԸ� �̿� �������� ������� �ڽ��� ���� ���</li>
						<li><input type="checkbox" name="q2_21_5_3" value="1" <%if(qa[21][5][3]!=null && qa[21][5][3].equals("1")){out.print("checked");}%>></input> ��. ����Ư��, ���� ������� ���� ü��, ��ǰ������ ���αԸ� �̿� �������� ��3�ڸ� ���� ���</li>
						<li><input type="checkbox" name="q2_21_5_4" value="1" <%if(qa[21][5][4]!=null && qa[21][5][4].equals("1")){out.print("checked");}%>></input> ��. ����Ư��, ���� ������� ���� ü��, ��ǰ������ ���αԸ� �̿� �������� ��3�ڿ��� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>21-6. </span> �ͻ��  <%= st_Current_Year_n-1%>�⵵�� ������ ������ڷκ��� ����ڷ� �䱸�� ��� ������� �޾ҽ��ϱ�?</li>
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
										<th>�䱸 �Ǽ�</th>
									</tr>
									<tr>
										<th>��ü</th>
										<td><input type="text" name="q2_21_12" value="<%=qa[21][12][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ��</td>
									</tr>
									<tr>
										<th>���� �䱸</th>
										<td><input type="text" name="q2_21_13" value="<%=qa[21][13][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ��</td>
									</tr>
									<tr>
										<th>���� �䱸</th>
										<td><input type="text" name="q2_21_14" value="<%=qa[21][14][20]%>" onkeyup ="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ��</td>
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
						<li class="boxcontenttitle"><span>21-7. </span> ������ ������ڰ� ����ڷ� �䱸 �ÿ� ����� �����ڷ� ����� �����Դϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_21_7" value="<%=setHiddenValue(qa, 21, 7, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_21_7" value="1" <%if(qa[21][7][1]!=null && qa[21][7][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,7);"></input> ��. ��ü���</li>
						<li><input type="radio" name="q2_21_7" value="2" <%if(qa[21][7][2]!=null && qa[21][7][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,7);"></input> ��. ����ڷ� �䱸��(������ ���� ��263ȣ ����1)</li>
						<li><input type="radio" name="q2_21_7" value="3" <%if(qa[21][7][3]!=null && qa[21][7][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,7);"></input> ��. ��Ÿ(<input type="text" name="q2_21_15" value="<%=qa[21][15][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<%-- <li><input type="radio" name="q2_21_7" value="4" <%if(qa[21][7][4]!=null && qa[21][7][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,7);"></input> ��. �ش���� ����(���ηθ� ��û)</li> --%>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>21-8. </span> ������ ������ڰ� �ͻ�κ��� ����� ����ڷ�� ���� �ͻ簡 ���� ���ظ� �԰� �� ��찡 �־��ٸ�, �� ����ڷ��� ��Ī�� ���ؾ��� ��� �˴ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:20%;" />
									<col style="width:50%;" />
									<col style="width:30%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>����</th>
										<th>������ ������ڰ� ������ ����ڷ� ��Ī</th>
										<th>���ع߻���</th>
									</tr>
									<tr>
										<th>1</th>
										<td>
											<input type="text" name="q2_21_33" value="<%=qa[21][33][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_21_36" value="<%=qa[21][36][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>�鸸 ��
										</td>
									</tr>
									<tr>
										<th>2</th>
										<td>
											<input type="text" name="q2_21_34" value="<%=qa[21][34][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_21_37" value="<%=qa[21][37][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>�鸸 ��
										</td>
									</tr>
									<tr>
										<th>3</th>
										<td>
											<input type="text" name="q2_21_35" value="<%=qa[21][35][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_21_38" value="<%=qa[21][38][20]%>" onkeyup ="sukeyup(this)" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>�鸸 ��
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
						<li class="boxcontenttitle"><span>21-9. </span> �ͻ�� ����ڷ� ��ġ��, ����ڷ� ������, ���������� �� ����ڷ� ��������� ���� �˰� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle">* <strong>����ڷ� �����</strong>�� ���޻���ڰ� �����ϰ� �ִ� ����ڷḦ ���ù����� ���� ��3�� ���(���߼ұ���������, �ѱ�Ư��������)�� ����ϸ� ���� ����� �� ����ڷḦ ���޻���ڰ� �����ϰ������� ������ �ִ� ������ ����. ���� ���߼ұ��������ܿ��� ����ϴ� <strong>����ڷ� ��ġ��, ����ڷ� ������</strong>�� �ѱ�Ư������������ ����ϴ� <strong>����������</strong> ���� ����.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_21_9" value="<%=setHiddenValue(qa, 21, 9, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_21_9" value="1" <%if(qa[21][9][1]!=null && qa[21][9][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,9);"></input> ��. �� �� ����</li>
						<li><input type="radio" name="q2_21_9" value="2" <%if(qa[21][9][2]!=null && qa[21][9][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,9);"></input> ��. �� ���� ������ ������ ���� ��</li>
						<li><input type="radio" name="q2_21_9" value="3" <%if(qa[21][9][3]!=null && qa[21][9][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,9);"></input> ��. ������ �뷫������ �˰� ����</li>
						<li><input type="radio" name="q2_21_9" value="4" <%if(qa[21][9][4]!=null && qa[21][9][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,9);"></input> ��. ������ ��ü������ �˰� ����</li>
						<li><input type="radio" name="q2_21_9" value="5" <%if(qa[21][9][5]!=null && qa[21][9][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,9);"></input> ��. ������ �Ϻ��� �˰� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<h2 class="contenttitle">�ϵ��ްŷ� ���λ��� 3 : �����������濵����</h2>
			
			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha12">22. ���������� �δ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��22-1���� ��22-4�� <strong>���������� �δ�</strong>�� ���� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>22-1. </span> <%= st_Current_Year_n-1%>�⵵ ������ ������ڿ��� �ϵ��� �ŷ� �Ⱓ �� ����� ������������ ���� �Ϻθ� �ͻ簡 ���� ������ ����� �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_22_1" value="<%=setHiddenValue(qa, 22, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_22_1" value="1" <%if(qa[22][1][1]!=null && qa[22][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(22,1);"></input> ��. �ִ�</li>
						<li><input type="radio" name="q2_22_1" value="2" <%if(qa[22][1][2]!=null && qa[22][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(22,1);"></input> ��. ����<span class="boxcontentsubtitle">��23-1��</span></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>22-2. </span> �ͻ�� ����� �������� �������� �߻��� ����� ��� �δ��Ͽ�����?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_22_2" value="<%=setHiddenValue(qa, 22, 2, 4)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_22_2" value="1" <%if(qa[22][2][1]!=null && qa[22][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);"></input> ��. �ͻ簡 �δ�</li>
						<li><input type="radio" name="q2_22_2" value="2" <%if(qa[22][2][2]!=null && qa[22][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);"></input> ��. ������ڰ� �δ�<span class="boxcontentsubtitle">��23-1��</span></li>
						<li><input type="radio" name="q2_22_2" value="3" <%if(qa[22][2][3]!=null && qa[22][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);"></input> ��. �ͻ�� ������ڰ� �����ϰ� �δ�</li>
						<li><input type="radio" name="q2_22_2" value="4" <%if(qa[22][2][4]!=null && qa[22][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(22,2);"></input> ��. ���� �δ��Ͽ����� �Ұ�����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>22-3. </span> �ͻ簡 ������������� �δ��Ͽ��ٸ�, ������ ������ڰ� �ͻ翡�� �δ�п� �ش��ϴ� ����� �����Ͽ�����?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_22_3" value="<%=setHiddenValue(qa, 22, 3, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_22_3" value="1" <%if(qa[22][3][1]!=null && qa[22][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(22,3);"></input> ��. �����Ͽ���<span class="boxcontentsubtitle">��23-1��</span></li>
						<li><input type="radio" name="q2_22_3" value="2" <%if(qa[22][3][2]!=null && qa[22][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(22,3);"></input> ��. �������� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>22-4. </span> ������ ������ڰ� �������� ����� �������� �ƴ��Ͽ��ٸ�, �� ������ �����ΰ���?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_22_4" value="<%=setHiddenValue(qa, 22, 4, 3)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_22_4" value="1" <%if(qa[22][4][1]!=null && qa[22][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(22,4);"></input> ��. ������ڰ� ���������� �δ� ������ ��������</li>
						<li><input type="radio" name="q2_22_4" value="2" <%if(qa[22][4][2]!=null && qa[22][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(22,4);"></input> ��. �ͻ簡 �δ��Ѵٴ� ��������� ü����</li>
						<li><input type="radio" name="q2_22_4" value="3" <%if(qa[22][4][3]!=null && qa[22][4][3].equals("1")){out.print("checked");}%> onclick="checkradio(22,4);"></input> ��. ��Ÿ(<input type="text" name="q2_22_11" value="<%=qa[22][11][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha13">23. ������ ��������� �濵����</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��23-1���� ��23-2�� <strong>������ ��������� �濵����</strong>�� ���� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>23-1. </span> <%= st_Current_Year_n-1%>�⵵�� ������ ������ڰ� �ͻ翡�� ������ ���� ���� �Ʒ��� �濵���� ������ �� ��찡 �־����ϱ�?</li>
						<li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_23_1_1" value="1" <%if(qa[23][1][1]!=null && qa[23][1][1].equals("1")){out.print("checked");}%>></input> ��. Ư�� ����ڿ͸� �ŷ��ϵ��� ����</li>
						<li><input type="checkbox" name="q2_23_1_2" value="1" <%if(qa[23][1][2]!=null && qa[23][1][2].equals("1")){out.print("checked");}%>></input> ��. �ͻ��� ������ ���ӡ����ӿ� ������ڰ� ����</li>
						<li><input type="checkbox" name="q2_23_1_3" value="1" <%if(qa[23][1][3]!=null && qa[23][1][3].equals("1")){out.print("checked");}%>></input> ��. �ͻ��� ����ǰ�񡤼��� ���� ����</li>
						<li><input type="checkbox" name="q2_23_1_4" value="1" <%if(qa[23][1][4]!=null && qa[23][1][4].equals("1")){out.print("checked");}%>></input> ��. �ͻ��� �濵�� ������ �䱸</li>
						<li><input type="checkbox" name="q2_23_1_5" value="1" <%if(qa[23][1][5]!=null && qa[23][1][5].equals("1")){out.print("checked");}%>></input> ��. �ͻ� ����ڷ��� �ؿ� ���⿡ ����</li>
						<li><input type="checkbox" name="q2_23_1_6" value="1" <%if(qa[23][1][6]!=null && qa[23][1][6].equals("1")){out.print("checked");}%>></input> ��. ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>23-2. </span> <%= st_Current_Year_n-1%>�⵵�� ������ ������ڰ� �ͻ翡�� �濵���� ������ �䱸�ߴٸ�, �䱸�� �濵������ �䱸 ������ �����Դϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:10%;" />
									<col style="width:50%;" />
									<col style="width:40%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>����</th>
										<th>������ ������ڰ� �䱸�� �濵���� ��Ī</th>
										<th>������ ��������� �䱸 ����</th>
									</tr>
									<tr>
										<th>����</th>
										<td>A��ǰ ���� ���ο���������</td>
										<td>�ܰ� ���Ͽ� Ȱ��</td>
									</tr>
									<tr>
										<th>1</th>
										<td>
											<input type="text" name="q2_23_11" value="<%=qa[23][11][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_23_14" value="<%=qa[23][14][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>2</th>
										<td>
											<input type="text" name="q2_23_12" value="<%=qa[23][12][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_23_15" value="<%=qa[23][15][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
										</td>
									</tr>
									<tr>
										<th>3</th>
										<td>
											<input type="text" name="q2_23_13" value="<%=qa[23][13][20]%>" class="text08b" onFocus="javascript:this.className='text08o';" onBlur="javascript:this.className='text08b';"></input>
										</td>
										<td>
											<input type="text" name="q2_23_16" value="<%=qa[23][16][20]%>" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
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
			
			<h2 class="contenttitle">�ϵ��ްŷ� ���λ��� 4 : ���Ӱŷ�</h2>
			
			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha14">24. ���Ӱŷ�</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��24-1���� ��24-6�� <strong>���Ӱŷ�</strong>�� ���� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>24-1. </span> �ͻ�� <%= st_Current_Year_n-1%>�⿡ ������ ������ڿ� �ϵ��� ���Ӱŷ��� ���� ���� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle">* ���Ӱŷ��� ���޻���ڷ� �Ͽ��� ��������� '�ڱ�' �Ǵ� '�ڱⰡ �����ϴ� �����'�͸� �ŷ��ϵ��� �ϴ� ���� �ǹ���.</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_24_1" value="<%=setHiddenValue(qa, 24, 1, 2)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_24_1" value="1" <%if(qa[24][1][1]!=null && qa[24][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(24,1);"></input> ��. �ִ�</li>
						<li><input type="radio" name="q2_24_1" value="2" <%if(qa[24][1][2]!=null && qa[24][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(24,1);"></input> ��. ����<span class="boxcontentsubtitle">��25-1��</span></li>
					</ul>
					<div class="fc pt_50"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>24-2. </span> <%= st_Current_Year_n-1%>�⵵ �ͻ��� ����׿��� ������ ������ڿ��� �ϵ��� ���Ӱŷ��� �߻��� ������� ���Դϱ�?</li>
						<li class="boxcontentsubtitle"></li>
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
										<th>�� �� ����ڿ��� �ϵ��� ���Ӱŷ� �����</th>
									</tr>
									<tr>
										<th><%= st_Current_Year_n-1%>�⵵</th>
										<td><input type="text" name="q2_24_2" value="<%=qa[24][2][20]%>" onKeyUp="sukeyup(this);" size="30" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';"></input> �鸸��</td>
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
						<li class="boxcontenttitle"><span>24-3. </span> <%= st_Current_Year_n-1%>�⵵�� �ͻ簡 �ϵ��� ���Ӱŷ��� ü���� ��ü ��ü ��, �����, ��� �ŷ� ���ӱⰣ�� ��� �˴ϱ�? ������ ������ڸ� �����Ͽ� ��ü ������ڵ�� ü���� ���Ӱŷ��� ������� �����Ͽ� �ֽʽÿ�.</li>
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
										<th>����</th>
									</tr>
									<tr>
										<th>���Ӱŷ� ��ü ��</th>
										<td><input type="text" name="q2_24_11" value="<%=qa[24][11][20]%>" onKeyUp="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ����</td>
									</tr>
									<tr>
										<th>���Ӱŷ��� ���� �����</th>
										<td><input type="text" name="q2_24_12" value="<%=qa[24][12][20]%>" onKeyUp="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> �鸸 ��</td>
									</tr>
									<tr>
										<th>��� ���Ӱŷ� �Ⱓ</th>
										<td><input type="text" name="q2_24_13" value="<%=qa[24][13][20]%>" onKeyUp="sukeyup(this);" size="30" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input> ����</td>
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
						<li class="boxcontenttitle"><span>24-4. </span> �ͻ�� ��� ��θ� ���� ������ ������ڿ� ���Ӱŷ��� �ϰ� �Ǿ����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<input type="hidden" name="c2_24_4" value="<%=setHiddenValue(qa, 24, 4, 7)%>"></input>
					<ul class="lt">
						<li><input type="radio" name="q2_24_4" value="1" <%if(qa[24][4][1]!=null && qa[24][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(24,4);"></input> ��. ������ڿ��� ���Ǹ� ���� ���ü��</li>
						<li><input type="radio" name="q2_24_4" value="1" <%if(qa[24][4][2]!=null && qa[24][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(24,4);"></input> ��. ��������� ���Ӱŷ� �䱸�� ���� ���ü��</li>
						<li><input type="radio" name="q2_24_4" value="1" <%if(qa[24][4][3]!=null && qa[24][4][3].equals("1")){out.print("checked");}%> onclick="checkradio(24,4);"></input> ��. ������ڿ��� �ӿ� ������ ���� ���ü��</li>
						<li><input type="radio" name="q2_24_4" value="1" <%if(qa[24][4][4]!=null && qa[24][4][4].equals("1")){out.print("checked");}%> onclick="checkradio(24,4);"></input> ��. ������������� ���� ���ü��</li>
						<li><input type="radio" name="q2_24_4" value="1" <%if(qa[24][4][5]!=null && qa[24][4][5].equals("1")){out.print("checked");}%> onclick="checkradio(24,4);"></input> ��. �������������� ������ �� ���ü��</li>
						<li><input type="radio" name="q2_24_4" value="1" <%if(qa[24][4][6]!=null && qa[24][4][6].equals("1")){out.print("checked");}%> onclick="checkradio(24,4);"></input> ��. �ͻ�� ������ڿ� �и��Ǿ� ������ �迭��� �׷��� Ư�����迡 ���� ���ü��</li>
						<li><input type="radio" name="q2_24_4" value="1" <%if(qa[24][4][7]!=null && qa[24][4][7].equals("1")){out.print("checked");}%> onclick="checkradio(24,4);"></input> ��. ��Ÿ(<input type="text" name="q2_24_14" value="<%=qa[24][14][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
					<div class="fc pt_50"></div>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>24-5. </span> �ͻ簡 ������ ������ڿ��� ���Ӱŷ��� ���Ͽ� �޼�(����)�ϰ� �� ���� �����Դϱ�?</li>
						<li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_24_5_1" value="1" <%if(qa[24][5][1]!=null && qa[24][5][1].equals("1")){out.print("checked");}%>></input> ��. ǰ�����</li>
						<li><input type="checkbox" name="q2_24_5_2" value="1" <%if(qa[24][5][2]!=null && qa[24][5][2].equals("1")){out.print("checked");}%>></input> ��. R&D �� ��� ����</li>
						<li><input type="checkbox" name="q2_24_5_3" value="1" <%if(qa[24][5][3]!=null && qa[24][5][3].equals("1")){out.print("checked");}%>></input> ��. �������</li>
						<li><input type="checkbox" name="q2_24_5_4" value="1" <%if(qa[24][5][4]!=null && qa[24][5][4].equals("1")){out.print("checked");}%>></input> ��. ������ ����ó Ȯ��</li>
						<li><input type="checkbox" name="q2_24_5_5" value="1" <%if(qa[24][5][5]!=null && qa[24][5][5].equals("1")){out.print("checked");}%>></input> ��. ��Ÿ(<input type="text" name="q2_24_15" value="<%=qa[24][15][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>24-6. </span> ������ ������ڿ��� ���Ӱŷ� ����, �ͻ��� �ŷ������� ��ȭ�� ��찡 �ִٸ�, �Ʒ� �� ��� ���׿� �ش��մϱ�?</li>
						<li class="boxcontentsubtitle">(�ش� �׸��� ��� ����)</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li><input type="checkbox" name="q2_24_6_1" value="1" <%if(qa[24][6][1]!=null && qa[24][6][1].equals("1")){out.print("checked");}%>></input> ��. �ܰ� ���Ͽ� ���� ���ͼ� ��ȭ</li>
						<li><input type="checkbox" name="q2_24_6_2" value="1" <%if(qa[24][6][2]!=null && qa[24][6][2].equals("1")){out.print("checked");}%>></input> ��. �Ϲ����� ���� ��� �� �������� ���Ⱘ��</li>
						<li><input type="checkbox" name="q2_24_6_3" value="1" <%if(qa[24][6][3]!=null && qa[24][6][3].equals("1")){out.print("checked");}%>></input> ��. �ͻ��� ���޼� �Ǵ� ������� Ȯ�� ����</li>
						<li><input type="checkbox" name="q2_24_6_4" value="1" <%if(qa[24][6][4]!=null && qa[24][6][4].equals("1")){out.print("checked");}%>></input> ��. ��� ������ ����</li>
						<li><input type="checkbox" name="q2_24_6_5" value="1" <%if(qa[24][6][5]!=null && qa[24][6][5].equals("1")){out.print("checked");}%>></input> ��. Ư����ü�� ���������� ���� �䱸</li>
						<li><input type="checkbox" name="q2_24_6_6" value="1" <%if(qa[24][6][6]!=null && qa[24][6][6].equals("1")){out.print("checked");}%>></input> ��. �ϵ��޴�� ���� ����</li>
						<li><input type="checkbox" name="q2_24_6_7" value="1" <%if(qa[24][6][7]!=null && qa[24][6][7].equals("1")){out.print("checked");}%>></input> ��. ������ ǰ�� ���� �䱸 �� �δ��� ��ǰ</li>
						<li><input type="checkbox" name="q2_24_6_8" value="1" <%if(qa[24][6][8]!=null && qa[24][6][8].equals("1")){out.print("checked");}%>></input> ��. �Ϲ����� ������ ���� �䱸 �� ��ǰ���� �ź�</li>
						<li><input type="checkbox" name="q2_24_6_9" value="1" <%if(qa[24][6][9]!=null && qa[24][6][9].equals("1")){out.print("checked");}%>></input> ��. ��Ÿ (<input type="text" name="q2_24_16" value="<%=qa[24][16][20]%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
						<li><input type="checkbox" name="q2_24_6_10" value="1" <%if(qa[24][6][10]!=null && qa[24][6][10].equals("1")){out.print("checked");}%> onclick="fn_chk(this.form, 24, 6);"></input> ��. �ش���� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<h2 class="contenttitle">������ ����</h2>
			
			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><a name="mokcha15">25. �ϵ��� �ŷ��� �ϵ��� ��å�� ���� �ͻ��� ������ ����</a><a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
                    <li class="boxcontentsubtitle">�� ��25-1���� ��25-3�� <strong>�ϵ��� �ŷ��� �ϵ��� ��å�� ����</strong> �ͻ��� <strong>������</strong>�� ���� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>25-1. </span> �ͻ�� ������ ������ڿ��� �ϵ��ްŷ� ���ݰ� �����׸� ���Ͽ� ��� ���� �����ϰ� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle"></li>

					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:30%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>�����׸�</th>
										<th>�ſ�<br/> ����</th>
										<th>����</th>
										<th>�ణ<br/> ����</th>
										<th>����</th>
										<th>�ణ<br/> �Ҹ���</th>
										<th>�Ҹ���</th>
										<th>�ſ�<br/> �Ҹ���</th>
									</tr>
									<tr>
										<th style="text-align: left;">�ŷ� ���ݿ� ���� ������</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_1" value="<%=setHiddenValue(qa, 25, 1, 7)%>"></input>
											<input type="radio" name="q2_25_1" value="1" <%if(qa[25][1][1]!=null && qa[25][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,1);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_1" value="2" <%if(qa[25][1][2]!=null && qa[25][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,1);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_1" value="3" <%if(qa[25][1][3]!=null && qa[25][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,1);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_1" value="4" <%if(qa[25][1][4]!=null && qa[25][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,1);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_1" value="5" <%if(qa[25][1][5]!=null && qa[25][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,1);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_1" value="6" <%if(qa[25][1][6]!=null && qa[25][1][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,1);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_1" value="7" <%if(qa[25][1][7]!=null && qa[25][1][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,1);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">1) ��ü ���� ���</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_2" value="<%=setHiddenValue(qa, 25, 2, 7)%>"></input>
											<input type="radio" name="q2_25_2" value="1" <%if(qa[25][2][1]!=null && qa[25][2][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,2);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_2" value="2" <%if(qa[25][2][2]!=null && qa[25][2][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,2);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_2" value="3" <%if(qa[25][2][3]!=null && qa[25][2][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,2);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_2" value="4" <%if(qa[25][2][4]!=null && qa[25][2][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,2);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_2" value="5" <%if(qa[25][2][5]!=null && qa[25][2][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,2);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_2" value="6" <%if(qa[25][2][6]!=null && qa[25][2][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,2);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_2" value="7" <%if(qa[25][2][7]!=null && qa[25][2][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,2);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">2) ��� ü�� ����</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_3" value="<%=setHiddenValue(qa, 25, 3, 7)%>"></input>
											<input type="radio" name="q2_25_3" value="1" <%if(qa[25][3][1]!=null && qa[25][3][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,3);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_3" value="2" <%if(qa[25][3][2]!=null && qa[25][3][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,3);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_3" value="3" <%if(qa[25][3][3]!=null && qa[25][3][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,3);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_3" value="4" <%if(qa[25][3][4]!=null && qa[25][3][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,3);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_3" value="5" <%if(qa[25][3][5]!=null && qa[25][3][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,3);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_3" value="6" <%if(qa[25][3][6]!=null && qa[25][3][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,3);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_3" value="7" <%if(qa[25][3][7]!=null && qa[25][3][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,3);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">3) �ŷ� �ܰ� ����</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_4" value="<%=setHiddenValue(qa, 25, 4, 7)%>"></input>
											<input type="radio" name="q2_25_4" value="1" <%if(qa[25][4][1]!=null && qa[25][4][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,4);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_4" value="2" <%if(qa[25][4][2]!=null && qa[25][4][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,4);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_4" value="3" <%if(qa[25][4][3]!=null && qa[25][4][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,4);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_4" value="4" <%if(qa[25][4][4]!=null && qa[25][4][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,4);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_4" value="5" <%if(qa[25][4][5]!=null && qa[25][4][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,4);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_4" value="6" <%if(qa[25][4][6]!=null && qa[25][4][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,4);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_4" value="7" <%if(qa[25][4][7]!=null && qa[25][4][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,4);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">4) ��Ź ��� �� ���� ����</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_5" value="<%=setHiddenValue(qa, 25, 5, 7)%>"></input>
											<input type="radio" name="q2_25_5" value="1" <%if(qa[25][5][1]!=null && qa[25][5][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,5);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_5" value="2" <%if(qa[25][5][2]!=null && qa[25][5][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,5);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_5" value="3" <%if(qa[25][5][3]!=null && qa[25][5][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,5);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_5" value="4" <%if(qa[25][5][4]!=null && qa[25][5][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,5);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_5" value="5" <%if(qa[25][5][5]!=null && qa[25][5][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,5);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_5" value="6" <%if(qa[25][5][6]!=null && qa[25][5][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,5);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_5" value="7" <%if(qa[25][5][7]!=null && qa[25][5][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,5);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">5) ��ǰ ���� ����</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_6" value="<%=setHiddenValue(qa, 25, 6, 7)%>"></input>
											<input type="radio" name="q2_25_6" value="1" <%if(qa[25][6][1]!=null && qa[25][6][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,6);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_6" value="2" <%if(qa[25][6][2]!=null && qa[25][6][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,6);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_6" value="3" <%if(qa[25][6][3]!=null && qa[25][6][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,6);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_6" value="4" <%if(qa[25][6][4]!=null && qa[25][6][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,6);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_6" value="5" <%if(qa[25][6][5]!=null && qa[25][6][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,6);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_6" value="6" <%if(qa[25][6][6]!=null && qa[25][6][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,6);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_6" value="7" <%if(qa[25][6][7]!=null && qa[25][6][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,6);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">6) ��� �� �ܰ�����</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_7" value="<%=setHiddenValue(qa, 25, 7, 7)%>"></input>
											<input type="radio" name="q2_25_7" value="1" <%if(qa[25][7][1]!=null && qa[25][7][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,7);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_7" value="2" <%if(qa[25][7][2]!=null && qa[25][7][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,7);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_7" value="3" <%if(qa[25][7][3]!=null && qa[25][7][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,7);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_7" value="4" <%if(qa[25][7][4]!=null && qa[25][7][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,7);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_7" value="5" <%if(qa[25][7][5]!=null && qa[25][7][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,7);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_7" value="6" <%if(qa[25][7][6]!=null && qa[25][7][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,7);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_7" value="7" <%if(qa[25][7][7]!=null && qa[25][7][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,7);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">7) �ϵ��޴�� ����</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_8" value="<%=setHiddenValue(qa, 25, 8, 7)%>"></input>
											<input type="radio" name="q2_25_8" value="1" <%if(qa[25][8][1]!=null && qa[25][8][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,8);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_8" value="2" <%if(qa[25][8][2]!=null && qa[25][8][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,8);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_8" value="3" <%if(qa[25][8][3]!=null && qa[25][8][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,8);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_8" value="4" <%if(qa[25][8][4]!=null && qa[25][8][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,8);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_8" value="5" <%if(qa[25][8][5]!=null && qa[25][8][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,8);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_8" value="6" <%if(qa[25][8][6]!=null && qa[25][8][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,8);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_8" value="7" <%if(qa[25][8][7]!=null && qa[25][8][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,8);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">8) ������ڿ��� ���°���</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_9" value="<%=setHiddenValue(qa, 25, 9, 7)%>"></input>
											<input type="radio" name="q2_25_9" value="1" <%if(qa[25][9][1]!=null && qa[25][9][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,9);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_9" value="2" <%if(qa[25][9][2]!=null && qa[25][9][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,9);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_9" value="3" <%if(qa[25][9][3]!=null && qa[25][9][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,9);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_9" value="4" <%if(qa[25][9][4]!=null && qa[25][9][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,9);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_9" value="5" <%if(qa[25][9][5]!=null && qa[25][9][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,9);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_9" value="6" <%if(qa[25][9][6]!=null && qa[25][9][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,9);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_9" value="7" <%if(qa[25][9][7]!=null && qa[25][9][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,9);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">9) ��������� �濵����</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_10" value="<%=setHiddenValue(qa, 25, 10, 7)%>"></input>
											<input type="radio" name="q2_25_10" value="1" <%if(qa[25][10][1]!=null && qa[25][10][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,10);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_10" value="2" <%if(qa[25][10][2]!=null && qa[25][10][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,10);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_10" value="3" <%if(qa[25][10][3]!=null && qa[25][10][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,10);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_10" value="4" <%if(qa[25][10][4]!=null && qa[25][10][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,10);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_10" value="5" <%if(qa[25][10][5]!=null && qa[25][10][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,10);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_10" value="6" <%if(qa[25][10][6]!=null && qa[25][10][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,10);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_10" value="7" <%if(qa[25][10][7]!=null && qa[25][10][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,10);"></input>
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
						<li class="boxcontenttitle"><span>25-2. </span> �ͻ�� �����ŷ�����ȸ�� �����ϰ� �ִ� �ϵ��� ���� ��å�� ��� ���� �����ϰ� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle"></li>

					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:30%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>��å</th>
										<th>�ſ�<br/> ����</th>
										<th>����</th>
										<th>�ణ<br/> ����</th>
										<th>����</th>
										<th>�ణ<br/> �Ҹ���</th>
										<th>�Ҹ���</th>
										<th>�ſ�<br/> �Ҹ���</th>
									</tr>
									<tr>
										<th style="text-align: left;">��å ���ݿ� ���� ������</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_11" value="<%=setHiddenValue(qa, 25, 11, 7)%>"></input>
											<input type="radio" name="q2_25_11" value="1" <%if(qa[25][11][1]!=null && qa[25][11][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,11);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_11" value="2" <%if(qa[25][11][2]!=null && qa[25][11][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,11);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_11" value="3" <%if(qa[25][11][3]!=null && qa[25][11][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,11);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_11" value="4" <%if(qa[25][11][4]!=null && qa[25][11][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,11);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_11" value="5" <%if(qa[25][11][5]!=null && qa[25][11][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,11);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_11" value="6" <%if(qa[25][11][6]!=null && qa[25][11][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,11);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_11" value="7" <%if(qa[25][11][7]!=null && qa[25][11][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,11);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">1) �ϵ��� ��������</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_12" value="<%=setHiddenValue(qa, 25, 12, 7)%>"></input>
											<input type="radio" name="q2_25_12" value="1" <%if(qa[25][12][1]!=null && qa[25][12][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,12);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_12" value="2" <%if(qa[25][12][2]!=null && qa[25][12][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,12);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_12" value="3" <%if(qa[25][12][3]!=null && qa[25][12][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,12);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_12" value="4" <%if(qa[25][12][4]!=null && qa[25][12][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,12);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_12" value="5" <%if(qa[25][12][5]!=null && qa[25][12][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,12);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_12" value="6" <%if(qa[25][12][6]!=null && qa[25][12][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,12);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_12" value="7" <%if(qa[25][12][7]!=null && qa[25][12][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,12);"></input>
										</td>
									</tr>
									
									<tr>
										<th style="text-align: left;">2) �����ŷ� �� ���ݼ��� ���� Ȯ��</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_14" value="<%=setHiddenValue(qa, 25, 14, 7)%>"></input>
											<input type="radio" name="q2_25_14" value="1" <%if(qa[25][14][1]!=null && qa[25][14][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,14);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_14" value="2" <%if(qa[25][14][2]!=null && qa[25][14][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,14);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_14" value="3" <%if(qa[25][14][3]!=null && qa[25][14][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,14);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_14" value="4" <%if(qa[25][14][4]!=null && qa[25][14][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,14);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_14" value="5" <%if(qa[25][14][5]!=null && qa[25][14][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,14);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_14" value="6" <%if(qa[25][14][6]!=null && qa[25][14][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,14);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_14" value="7" <%if(qa[25][14][7]!=null && qa[25][14][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,14);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">3) ���� �������� ��ȭ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_15" value="<%=setHiddenValue(qa, 25, 15, 7)%>"></input>
											<input type="radio" name="q2_25_15" value="1" <%if(qa[25][15][1]!=null && qa[25][15][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,15);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_15" value="2" <%if(qa[25][15][2]!=null && qa[25][15][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,15);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_15" value="3" <%if(qa[25][15][3]!=null && qa[25][15][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,15);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_15" value="4" <%if(qa[25][15][4]!=null && qa[25][15][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,15);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_15" value="5" <%if(qa[25][15][5]!=null && qa[25][15][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,15);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_15" value="6" <%if(qa[25][15][6]!=null && qa[25][15][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,15);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_15" value="7" <%if(qa[25][15][7]!=null && qa[25][15][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,15);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">4) �Ұ��� �ϵ��� �Ű��� �</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_16" value="<%=setHiddenValue(qa, 25, 16, 7)%>"></input>
											<input type="radio" name="q2_25_16" value="1" <%if(qa[25][16][1]!=null && qa[25][16][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,16);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_16" value="2" <%if(qa[25][16][2]!=null && qa[25][16][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,16);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_16" value="3" <%if(qa[25][16][3]!=null && qa[25][16][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,16);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_16" value="4" <%if(qa[25][16][4]!=null && qa[25][16][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,16);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_16" value="5" <%if(qa[25][16][5]!=null && qa[25][16][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,16);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_16" value="6" <%if(qa[25][16][6]!=null && qa[25][16][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,16);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_16" value="7" <%if(qa[25][16][7]!=null && qa[25][16][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,16);"></input>
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
						<li class="boxcontenttitle"><span>25-3. </span> �ͻ簡 <%= st_Current_Year_n-1%>�⿡ ������ �ϵ��ްŷ��� �Ұ����� ���鿡�� <%= st_Current_Year_n-2%>�⿡ ���Ͽ� ��� ���� �����Ǿ��ٰ� �����Ͻʴϱ�?</li>
						<li class="boxcontentsubtitle"></li>

					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:30%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
									<col style="width:10%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>�����׸�</th>
										<th>�ſ�<br/> ����</th>
										<th>����</th>
										<th>�ణ<br/> ����</th>
										<th>����</th>
										<th>�ణ<br/> ��ȭ</th>
										<th>��ȭ</th>
										<th>�ſ�<br/> ��ȭ</th>
									</tr>
									<tr>
										<th style="text-align: left;">�Ұ��� �ŷ��� �������� ������</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_17" value="<%=setHiddenValue(qa, 25, 17, 7)%>"></input>
											<input type="radio" name="q2_25_17" value="1" <%if(qa[25][17][1]!=null && qa[25][17][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,17);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_17" value="2" <%if(qa[25][17][2]!=null && qa[25][17][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,17);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_17" value="3" <%if(qa[25][17][3]!=null && qa[25][17][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,17);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_17" value="4" <%if(qa[25][17][4]!=null && qa[25][17][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,17);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_17" value="5" <%if(qa[25][17][5]!=null && qa[25][17][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,17);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_17" value="6" <%if(qa[25][17][6]!=null && qa[25][17][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,17);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_17" value="7" <%if(qa[25][17][7]!=null && qa[25][17][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,17);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">1) ���� �̹߱� �� �̺���</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_18" value="<%=setHiddenValue(qa, 25, 18, 7)%>"></input>
											<input type="radio" name="q2_25_18" value="1" <%if(qa[25][18][1]!=null && qa[25][18][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,18);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_18" value="2" <%if(qa[25][18][2]!=null && qa[25][18][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,18);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_18" value="3" <%if(qa[25][18][3]!=null && qa[25][18][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,18);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_18" value="4" <%if(qa[25][18][4]!=null && qa[25][18][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,18);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_18" value="5" <%if(qa[25][18][5]!=null && qa[25][18][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,18);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_18" value="6" <%if(qa[25][18][6]!=null && qa[25][18][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,18);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_18" value="7" <%if(qa[25][18][7]!=null && qa[25][18][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,18);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">2) �δ��� Ư��</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_19" value="<%=setHiddenValue(qa, 25, 19, 7)%>"></input>
											<input type="radio" name="q2_25_19" value="1" <%if(qa[25][19][1]!=null && qa[25][19][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,19);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_19" value="2" <%if(qa[25][19][2]!=null && qa[25][19][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,19);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_19" value="3" <%if(qa[25][19][3]!=null && qa[25][19][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,19);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_19" value="4" <%if(qa[25][19][4]!=null && qa[25][19][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,19);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_19" value="5" <%if(qa[25][19][5]!=null && qa[25][19][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,19);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_19" value="6" <%if(qa[25][19][6]!=null && qa[25][19][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,19);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_19" value="7" <%if(qa[25][19][7]!=null && qa[25][19][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,19);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">3) �δ��� �ϵ��� ��� ����</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_20" value="<%=setHiddenValue(qa, 25, 20, 7)%>"></input>
											<input type="radio" name="q2_25_20" value="1" <%if(qa[25][20][1]!=null && qa[25][20][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,20);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_20" value="2" <%if(qa[25][20][2]!=null && qa[25][20][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,20);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_20" value="3" <%if(qa[25][20][3]!=null && qa[25][20][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,20);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_20" value="4" <%if(qa[25][20][4]!=null && qa[25][20][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,20);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_20" value="5" <%if(qa[25][20][5]!=null && qa[25][20][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,20);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_20" value="6" <%if(qa[25][20][6]!=null && qa[25][20][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,20);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_20" value="7" <%if(qa[25][20][7]!=null && qa[25][20][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,20);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">4) �δ��� ��Ź ���</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_21" value="<%=setHiddenValue(qa, 25, 21, 7)%>"></input>
											<input type="radio" name="q2_25_21" value="1" <%if(qa[25][21][1]!=null && qa[25][21][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,21);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_21" value="2" <%if(qa[25][21][2]!=null && qa[25][21][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,21);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_21" value="3" <%if(qa[25][21][3]!=null && qa[25][21][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,21);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_21" value="4" <%if(qa[25][21][4]!=null && qa[25][21][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,21);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_21" value="5" <%if(qa[25][21][5]!=null && qa[25][21][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,21);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_21" value="6" <%if(qa[25][21][6]!=null && qa[25][21][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,21);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_21" value="7" <%if(qa[25][21][7]!=null && qa[25][21][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,21);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">5) �δ��� ��ǰ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_22" value="<%=setHiddenValue(qa, 25, 22, 7)%>"></input>
											<input type="radio" name="q2_25_22" value="1" <%if(qa[25][22][1]!=null && qa[25][22][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,22);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_22" value="2" <%if(qa[25][22][2]!=null && qa[25][22][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,22);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_22" value="3" <%if(qa[25][22][3]!=null && qa[25][22][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,22);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_22" value="4" <%if(qa[25][22][4]!=null && qa[25][22][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,22);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_22" value="5" <%if(qa[25][22][5]!=null && qa[25][22][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,22);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_22" value="6" <%if(qa[25][22][6]!=null && qa[25][22][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,22);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_22" value="7" <%if(qa[25][22][7]!=null && qa[25][22][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,22);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">6) �δ��� ��� ����</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_23" value="<%=setHiddenValue(qa, 25, 23, 7)%>"></input>
											<input type="radio" name="q2_25_23" value="1" <%if(qa[25][23][1]!=null && qa[25][23][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,23);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_23" value="2" <%if(qa[25][23][2]!=null && qa[25][23][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,23);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_23" value="3" <%if(qa[25][23][3]!=null && qa[25][23][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,23);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_23" value="4" <%if(qa[25][23][4]!=null && qa[25][23][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,23);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_23" value="5" <%if(qa[25][23][5]!=null && qa[25][23][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,23);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_23" value="6" <%if(qa[25][23][6]!=null && qa[25][23][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,23);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_23" value="7" <%if(qa[25][23][7]!=null && qa[25][23][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,23);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">7) �δ��� ������ ���� ���� �䱸</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_24" value="<%=setHiddenValue(qa, 25, 24, 7)%>"></input>
											<input type="radio" name="q2_25_24" value="1" <%if(qa[25][24][1]!=null && qa[25][24][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,24);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_24" value="2" <%if(qa[25][24][2]!=null && qa[25][24][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,24);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_24" value="3" <%if(qa[25][24][3]!=null && qa[25][24][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,24);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_24" value="4" <%if(qa[25][24][4]!=null && qa[25][24][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,24);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_24" value="5" <%if(qa[25][24][5]!=null && qa[25][24][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,24);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_24" value="6" <%if(qa[25][24][6]!=null && qa[25][24][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,24);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_24" value="7" <%if(qa[25][24][7]!=null && qa[25][24][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,24);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">8) �δ��� ����ڷ� ���� �䱸</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_25" value="<%=setHiddenValue(qa, 25, 25, 7)%>"></input>
											<input type="radio" name="q2_25_25" value="1" <%if(qa[25][25][1]!=null && qa[25][25][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,25);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_25" value="2" <%if(qa[25][25][2]!=null && qa[25][25][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,25);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_25" value="3" <%if(qa[25][25][3]!=null && qa[25][25][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,25);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_25" value="4" <%if(qa[25][25][4]!=null && qa[25][25][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,25);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_25" value="5" <%if(qa[25][25][5]!=null && qa[25][25][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,25);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_25" value="6" <%if(qa[25][25][6]!=null && qa[25][25][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,25);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_25" value="7" <%if(qa[25][25][7]!=null && qa[25][25][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,25);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">9) �δ��� ��� ���� ����</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_26" value="<%=setHiddenValue(qa, 25, 26, 7)%>"></input>
											<input type="radio" name="q2_25_26" value="1" <%if(qa[25][26][1]!=null && qa[25][26][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,26);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_26" value="2" <%if(qa[25][26][2]!=null && qa[25][26][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,26);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_26" value="3" <%if(qa[25][26][3]!=null && qa[25][26][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,26);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_26" value="4" <%if(qa[25][26][4]!=null && qa[25][26][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,26);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_26" value="5" <%if(qa[25][26][5]!=null && qa[25][26][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,26);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_26" value="6" <%if(qa[25][26][6]!=null && qa[25][26][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,26);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_26" value="7" <%if(qa[25][26][7]!=null && qa[25][26][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,26);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">10) �δ��� �濵����</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_27" value="<%=setHiddenValue(qa, 25, 27, 7)%>"></input>
											<input type="radio" name="q2_25_27" value="1" <%if(qa[25][27][1]!=null && qa[25][27][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,27);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_27" value="2" <%if(qa[25][27][2]!=null && qa[25][27][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,27);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_27" value="3" <%if(qa[25][27][3]!=null && qa[25][27][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,27);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_27" value="4" <%if(qa[25][27][4]!=null && qa[25][27][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,27);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_27" value="5" <%if(qa[25][27][5]!=null && qa[25][27][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,27);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_27" value="6" <%if(qa[25][27][6]!=null && qa[25][27][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,27);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_27" value="7" <%if(qa[25][27][7]!=null && qa[25][27][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,27);"></input>
										</td>
									</tr>
									<tr>
										<th style="text-align: left;">11) ������ġ</th>
										<td style="text-align: center;">
											<input type="hidden" name="c2_25_28" value="<%=setHiddenValue(qa, 25, 28, 7)%>"></input>
											<input type="radio" name="q2_25_28" value="1" <%if(qa[25][28][1]!=null && qa[25][28][1].equals("1")){out.print("checked");}%> onclick="checkradio(25,28);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_28" value="2" <%if(qa[25][28][2]!=null && qa[25][28][2].equals("1")){out.print("checked");}%> onclick="checkradio(25,28);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_28" value="3" <%if(qa[25][28][3]!=null && qa[25][28][3].equals("1")){out.print("checked");}%> onclick="checkradio(25,28);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_28" value="4" <%if(qa[25][28][4]!=null && qa[25][28][4].equals("1")){out.print("checked");}%> onclick="checkradio(25,28);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_28" value="5" <%if(qa[25][28][5]!=null && qa[25][28][5].equals("1")){out.print("checked");}%> onclick="checkradio(25,28);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_28" value="6" <%if(qa[25][28][6]!=null && qa[25][28][6].equals("1")){out.print("checked");}%> onclick="checkradio(25,28);"></input>
										</td>
										<td style="text-align: center;">
											<input type="radio" name="q2_25_28" value="7" <%if(qa[25][28][7]!=null && qa[25][28][7].equals("1")){out.print("checked");}%> onclick="checkradio(25,28);"></input>
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
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"> 26. �ϵ��� ��å ���� �Ǵ� �������-���޻���� �� ������ ���°��� ������ ���Ͽ� �����Ͻ� ������ ������ �����Ӱ� �����Ͽ� �ֽñ� �ٶ��ϴ�.<a href="#mokcha"><img src="img/icon_gotop.gif"></img></a></li>
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
					<ul class="lt"><textarea cols="80" rows="8" maxlength="600" name="q2_26_1" class="textarea01b" maxlength="600" onFocus="javascript:this.className='textarea01o';" onBlur="javascript:this.className='textarea01b';" onkeyup="byteLengCheck(this, 4000, this.name,'content_bytes25_1');"><%=qa[26][1][20]%></textarea>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_20"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="padding-left:20px;">
					<li class="boxcontenttitle"><span>*</span>���� �ܰ�� �Ѿ�� ���� �ϴ��� <font style="font-weight:bold;">�����塹</font>��ư�� ���� �����Ͻð� ���� �ܰ踦 �����Ͻñ� �ٶ��ϴ�. </li>
				</ul>
			</div>

			<div class="fc pt_20"></div>

			<!-- ��ư start -->
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">�� ��</a></li>
					<li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">ȭ�� �μ��ϱ�</a></li>
					<li class="fl pr_2"><a href="./WB_VP_Subcon_0<%=ckOentGB%>_04.jsp" onfocus="this.blur()" class="contentbutton2">4. ����ǥ �����ϱ�</a></li>
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
	<iframe src="/blank.jsp" name="proceFrame" id="proceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
	<%/*-----------------------------------------------------------------------------------------------*/%>
	<script type="text/JavaScript">
	//<![CDATA[
	<%if ( StringUtil.checkNull(request.getParameter("isSaved")).equals("1") ) {%>
		alert("�ϵ��� �ŷ���Ȳ ���������� ����Ǿ����ϴ�.")
	<%}%>
	//]]
	</script>
</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>