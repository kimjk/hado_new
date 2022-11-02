<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: 2014�� �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_Comp_Info_Load.jsp
* ���α׷�����	: ȸ�簳��_�Ϲ���Ȳ_�ҷ�����
* ���α׷�����	: 1.0.0-2014
* �����ۼ�����	: 2014�� 11�� 17��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-11-17	������       �����ۼ�
* 2014-11-27   ������       ������ȣ,�����ڵ� �빮�� ���� ��� �߰�
*/

/*====================== Variable Difinition======================*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="/Include/WB_I_Global.jsp"%>
<%@ include file="/Include/WB_I_chkSession.jsp"%>
<%@ include file="/Include/WB_I_Function.jsp"%>

<%
	ConnectionResource resource	= null;
	Connection conn	 = null;
	PreparedStatement pstmt	 = null;
	ResultSet rs = null;

	String sSQLs		= "";

	String sErrorMsg	= "";	// �����޽���
	String sname	= "";
	String scompgb	= "";
	String scono	= "";
	String scono1	= "";
	String scono2	= "";
	String ssano	= "";
	String ssano1	= "";
	String ssano2	= "";
	String ssano3	= "";
	String scaptine = "";

	//String sconamt = "0";
	//String ssale	= "0";
	//String samt		= "0";
	//String sempcnt	= "0";
	String sreggb = "";
	String sregtext = "";
	String zipcode	= "";
	String address	= "";
	String semail	= "";
	String semail1	= "";
	String semail2	= "";

	String worg		= "";
	String wjikwi	= "";
	String wname	= "";
	String wtel		= "";
	String wfax		= "";
	String wdate	= "";

	String reason	= "";
	
	
	/* 2020�⵵ �߰� */
	String sIncorp = "";		//��������
	String sIncorp1 = "";		//������
	String sIncorp2 = "";		//������
	
	String sCompStatus = "";		// ȸ�翵������
	String sQ1Etc = "";				// ȸ�翵������ ��Ÿ�亯
	
	String sSentCapa = "";		// ȸ��Ը�
	String sSentCapaTxt = "";	// ȸ��Ը��Ÿ
	
	String ssale1	= "0";		// �����  -3��
	String ssale2	= "0";		// -2
	String ssale	= "0";		// -1
	
	String soper1 = "0"; // �������
	String soper2 = "0";
	String soper = "0";
	
	String samt1		= "0";		// �ڻ��Ѿ�
	String samt2		= "0";		// 
	String samt		= "0";		// 
	
	String sconamt = "0";
	String sconamt1 = "0";
	String sconamt2 = "0";
	
	String sEmpCnt = "0";	// ��ð�������� ��
	String sEmpCnt1 = "0";	// ��ð�������� ��
	String sEmpCnt2 = "0";	// ��ð�������� ��
	
	String oentgb = "";
	

	java.util.Calendar cal = java.util.Calendar.getInstance();

	String sLoadMngNo		= request.getParameter("loadmngno")==null ? "":request.getParameter("loadmngno").trim();		//�ҷ����� ������ȣ
	String sLoadConnCode	= request.getParameter("loadconncode")==null ? "":request.getParameter("loadconncode").trim();	//�ҷ����� �����ڵ�

	boolean bCheckMngNo = false;	//������ȣ, �����ڵ尡 ��ġ���� �ʴ´ٴ� ���� �Ͽ� ����(���� ��� true)

	/*=========================================================*/
if(!ckMngNo.equals("")) {	//�α��� �϶��� ����

	//�ҷ����� ������ȣ�� DB���� SELECT�Ѵ�
	if ( !sLoadMngNo.equals("") && !sLoadConnCode.equals("") ) {
		/*
			�Էµ� ������ȣ �� �����ڵ带 �ϰ� �빮�� ��ȯ
			2014-11-27 / ������ ��� �߰�
		*/
		if ( !sLoadMngNo.equals("") ) 	sLoadMngNo = sLoadMngNo.toUpperCase();
		if ( !sLoadConnCode.equals("") ) sLoadConnCode = sLoadConnCode.toUpperCase();

		/* ������ȣ, �����ڵ� ���� */
		try {
			resource= new ConnectionResource();
			conn	= resource.getConnection();

			sSQLs = "SELECT mng_no \n";
			sSQLs+="FROM hado_tb_security_" +ckCurrentYear+ " \n";
			sSQLs+="WHERE mng_no= ? AND SUBSTR(conn_code,-4)= ? AND ent_gb= ? \n";
			pstmt = conn.prepareStatement(sSQLs);
			pstmt.setString(1, sLoadMngNo);
			pstmt.setString(2, sLoadConnCode);
			pstmt.setString(3, ckEntGB);
			rs = pstmt.executeQuery();

			if( rs.next() ) {
				bCheckMngNo = true;
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

		if( bCheckMngNo ) {	// ������ȣ, �����ڵ尡 ��ġ�Ҷ��� ����
			try {
				resource= new ConnectionResource();
				conn	= resource.getConnection();

				sSQLs   = "SELECT * \n";
				sSQLs+= "FROM hado_tb_subcon_" +ckCurrentYear+ " \n";
				sSQLs+= "WHERE child_mng_no = ? AND current_year = ? \n";
				pstmt = conn.prepareStatement(sSQLs);
				pstmt.setString(1, sLoadMngNo);
				pstmt.setString(2, ckCurrentYear);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					oentgb = rs.getString("OENT_GB")==null ? "": rs.getString("OENT_GB");
					sname = rs.getString("Sent_Name")==null ? "": rs.getString("Sent_Name");
					scaptine	= rs.getString("Sent_Captine")==null ? "": rs.getString("Sent_Captine");
					//ssale = rs.getString("Sent_Sale")==null ? "":  rs.getString("Sent_Sale");
					//samt = rs.getString("Sent_Amt")==null ? "": rs.getString("Sent_Amt");
					//sconamt = rs.getString("Sent_Con_Amt")==null ? "":  rs.getString("Sent_Con_Amt");
					zipcode = rs.getString("Zip_Code")==null ? "": rs.getString("Zip_Code");
					address = rs.getString("Sent_Address")==null ? "": rs.getString("Sent_Address");
					semail = rs.getString("Assign_Mail")==null ? "": rs.getString("Assign_Mail");
					if ( semail.indexOf("@") != -1 ) {
						semail1	= semail.substring(0, semail.indexOf("@"));
						semail2	= semail.substring(semail.indexOf("@")+1, semail.length());
					}
					scompgb = rs.getString("Comp_GB")==null ? "":  rs.getString("Comp_GB");
					scono = rs.getString("Sent_Co_No")==null ? "":  rs.getString("Sent_Co_No");
					if( scono.length() == 14 ) {
						scono1	= scono.substring(0,6);
						scono2	= scono.substring(7,14);
					}
					ssano		= rs.getString("Sent_Sa_No")==null ? "":  rs.getString("Sent_Sa_No");
					if( ssano.length() == 12) {
						ssano1	= ssano.substring(0,3);
						ssano2	= ssano.substring(4,6);
						ssano3	= ssano.substring(7,12);
					}
					//sempcnt	= rs.getString("Sent_Emp_Cnt")==null ? "":  rs.getString("Sent_Emp_Cnt");
					sreggb = rs.getString("Con_Reg_GB")==null ? "":  rs.getString("Con_Reg_GB");
					sregtext = rs.getString("Con_Reg_Text")==null ? "":  rs.getString("Con_Reg_Text");
					wname = rs.getString("Writer_Name")==null ? "":  rs.getString("Writer_Name");
					worg = rs.getString("Writer_ORG")==null ? "":  rs.getString("Writer_ORG");
					wjikwi	 = rs.getString("Writer_Jikwi")==null ? "":  rs.getString("Writer_Jikwi");
					wtel = rs.getString("Writer_Tel")==null ? "":  rs.getString("Writer_Tel");
					wfax = rs.getString("Writer_Fax")==null ? "":  rs.getString("Writer_Fax");
					wdate	 = rs.getString("Writer_Date")==null ? "":  rs.getString("Writer_Date");
					
					/* 2020�� �߰� */
					sIncorp		= rs.getString("Sent_Incorp")==null ? "":rs.getString("Sent_Incorp");
					sCompStatus = rs.getString("comp_status")==null ? "":rs.getString("comp_status");
					sQ1Etc = rs.getString("comp_status_etc")==null ? "":rs.getString("comp_status_etc");
					sSentCapa = rs.getString("sent_capa")==null ? "":rs.getString("sent_capa");
					sSentCapaTxt = rs.getString("sent_capa_etc")==null ? "":rs.getString("sent_capa_etc");
					
					ssale1	= rs.getString("Sent_Sale1")==null ? "":rs.getString("Sent_Sale1");
					ssale2	= rs.getString("Sent_Sale2")==null ? "":rs.getString("Sent_Sale2");
					ssale	= rs.getString("Sent_Sale")==null ? "":rs.getString("Sent_Sale");
					
					soper1	= rs.getString("Sent_Oper1")==null ? "":rs.getString("Sent_Oper1");
					soper2	= rs.getString("Sent_Oper2")==null ? "":rs.getString("Sent_Oper2");
					soper	= rs.getString("Sent_Oper")==null ? "":rs.getString("Sent_Oper");
					
					samt1	= rs.getString("Sent_Amt1")==null ? "":rs.getString("Sent_Amt1");
					samt2	= rs.getString("Sent_Amt2")==null ? "":rs.getString("Sent_Amt2");
					samt	= rs.getString("Sent_Amt")==null ? "":rs.getString("Sent_Amt");
					
					sconamt1	= rs.getString("SENT_CON_AMT1")==null ? "":rs.getString("SENT_CON_AMT1");
					sconamt2	= rs.getString("SENT_CON_AMT2")==null ? "":rs.getString("SENT_CON_AMT2");
					sconamt	= rs.getString("SENT_CON_AMT")==null ? "":rs.getString("SENT_CON_AMT");
					
					sEmpCnt	= rs.getString("Sent_Emp_Cnt")==null ? "":rs.getString("Sent_Emp_Cnt");
					sEmpCnt1	= rs.getString("Sent_Emp_Cnt1")==null ? "":rs.getString("Sent_Emp_Cnt1");
					sEmpCnt2	= rs.getString("Sent_Emp_Cnt2")==null ? "":rs.getString("Sent_Emp_Cnt2");
					
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
				if (rs != null)		try{rs.close();}	catch(Exception e){}
				if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
				if (conn != null)	try{conn.close();}	catch(Exception e){}
				if (resource != null) resource.release();
			}
		}	else { // ������ȣ, �����ڵ尡 ��ġ�Ҷ��� ���� ��
			sErrorMsg = "��ġ�ϴ� ������ ã�� �� �����ϴ�. ������ȣ �Ǵ� �����ڵ带 Ȯ���� �ּ���.";
		}
	}
} else { // �α��� ������ ���� ���
	sErrorMsg = "�α��� ������ �Ҹ�Ǿ��ų�, �������� ������ �ƴմϴ�. �۾��� ��ҵǾ����ϴ�.";
}
%>

<html>
<head>
	<title>���޻���� �Ϲ���Ȳ ��������</title>
	<script type="text/javascript">
		var sErrorMsg = "<%=sErrorMsg%>";

		if( sErrorMsg!="") {
			alert(sErrorMsg);
		} else {
		    
			parent.document.info.rcomp.value =  "<%=sname%>";
			parent.document.info.rcogb.value = "<%=scompgb%>";
			parent.document.info.rlawno1.value = "<%=scono1%>";
			parent.document.info.rlawno2.value = "<%=scono2%>";
			parent.document.info.rincorp1.value = "<%=sIncorp1%>";
			parent.document.info.rincorp2.value = "<%=sIncorp2%>";
			parent.document.info.rregno1.value = "<%=ssano1%>";
			parent.document.info.rregno2.value = "<%=ssano2%>";
			parent.document.info.rregno3.value = "<%=ssano3%>";
			parent.document.info.rowner.value = "<%=scaptine%>";
			parent.document.info.rpost.value = "<%=zipcode%>";
			parent.document.info.raddr.value = "<%=address%>";
			parent.document.info.rtel.value = "<%=wtel%>";
			
			<%-- parent.document.info.q1.value = "<%=sCompStatus%>"; --%>
			var q1Obj = parent.document.info.q1;
			for(var i = 0; i < q1Obj.length; i++) {
				if(q1Obj[i].value == "<%=sCompStatus%>") q1Obj[i].checked = true;
				else q1Obj[i].checked = false;
			}
			parent.document.info.q1Etc.value = "<%=sQ1Etc%>";
			
			<%-- parent.document.info.q2.value = "<%=sSentCapa%>"; --%>
			var q2Obj = parent.document.info.q2;
			for(var i = 0; i < q2Obj.length; i++) {
				if(q2Obj[i].value == "<%=sSentCapa%>") q2Obj[i].checked = true;
				else q2Obj[i].checked = false;
			}
			<%-- parent.document.info.q2Etc.value = "<%=sSentCapaTxt%>"; --%>
			
			parent.document.info.q3_1.value = "<%=ssale1%>";
			parent.document.info.q3_2.value = "<%=ssale2%>";
			parent.document.info.q3_3.value = "<%=ssale%>";
			parent.document.info.q3_4.value = "<%=soper1%>";
			parent.document.info.q3_5.value = "<%=soper2%>";
			parent.document.info.q3_6.value = "<%=soper%>";
			parent.document.info.q3_7.value = "<%=samt1%>";
			parent.document.info.q3_8.value = "<%=samt2%>";
			parent.document.info.q3_9.value = "<%=samt%>";
			<% if(ckOentGB != null && ckOentGB.equals("2")) { %>
			parent.document.info.q3_10.value = "<%=sconamt1%>";
			parent.document.info.q3_11.value = "<%=sconamt2%>";
			parent.document.info.q3_12.value = "<%=sconamt%>";
			<% } %>
			parent.document.info.q4.value = "<%=sEmpCnt%>";
			parent.document.info.q4_1.value = "<%=sEmpCnt1%>";
			parent.document.info.q4_2.value = "<%=sEmpCnt2%>";
			
			alert("�����������⸦ �Ϸ��Ͽ����ϴ�. �Էµ� ������ Ȯ�� �� ���� �ܰ踦 ������ �ּ���.");
		}
	</script>
</head>
<body>
	<p>sname : <%=sname%></p>
	<p>scaptine : <%=scaptine%></p>
	<%-- <p>ssale : <%=ssale%></p>
	<p>samt : <%=samt%></p>
	<p>sempcnt	: <%=sempcnt%></p> --%>
	<p>wname : <%=wname%></p>
	<p>worg : <%=worg%></p>
	<p>wjikwi : <%=wjikwi%></p>
	<p>zipcode : <%=zipcode%></p>
	<p>address : <%=address%></p>
	<p>wtel : <%=wtel%></p>
	<p>wfax : <%=wfax%></p>
	<p>semail1 : <%=semail1%></p>
	<p>semail2 : <%=semail2%></p>
	<p>scompgb : <%=scompgb%></p>
	<p>scono1 : <%=scono1%></p>
	<p>scono2 : <%=scono2%></p>
	<p>ssano1 : <%=ssano1%></p>
	<p>ssano2 : <%=ssano2%></p>
	<p>ssano3 : <%=ssano3%></p>
	<p>sconamt : <%=sconamt%></p>
	<p>sreggb	: <%=sreggb%></p>
	<p>sregtext	: <%=sregtext%></p>
	<p>wdate : <%=wdate%></p>
	
</body>
</html>