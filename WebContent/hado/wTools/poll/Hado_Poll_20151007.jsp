<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

<%
/*=======================================================*/
/* ������Ʈ��		: 2015�� �����ŷ�����ȸ �űԵ����������� ��������					*/
/* ���α׷���		: Hado_Poll.jsp																		*/
/* ���α׷�����	: �������� �Է� ������															*/
/* ���α׷�����	: 1.0.2																				*/
/* �����ۼ�����	: 2014�� 07�� 07��																*/
/*--------------------------------------------------------------------------------------- */
/*	�ۼ�����		�ۼ��ڸ�				����
/*--------------------------------------------------------------------------------------- */
/*	2014-07-07	������	�����ۼ�																*/			
/*	2014-11-05	������	�������																*/			
/*	2015-10-15	������	�������																*/			
/*=======================================================*/

/* Variable Difinition Start ======================================*/

String sPollId			= "20151007";		// ������ȣ
String sReturnURL	= "Hado_Poll.jsp";	// �������� �̵��� ������
String sSQLs			= "";						// SQL��

ConnectionResource resource		= null;	// Database Resource
Connection conn						= null;	// Database Connection
PreparedStatement pstmt			= null;	// PreparedStatument
ResultSet rs								= null;	// Result RecordSet

// ȸ�� �⺻���� (2015�⵵ ����� ����� ���� �ش� ���� ����)

String sSentType		= "";	// ����
String sBussTerm		= "";	// ����Ⱓ
String sAreaCD		= "";  // �����ڵ�
String sSubconStep	= "";	// ������ڿ��� �ŷ��ܰ�
String sDetailCD		= "";	// ���ξ�������
String sSentSale		= "";	// �����
String sEmpCnt		= "";	// �����������
String sCapaCD		= "";	// ����Ը𱸺�

// 20141105 / ������ / �亯���� ����
// [�빮��],[�ҹ���],[���ⰳ��]
String[][][] qa			= new String[23][5][21];	// �亯���� ����
int nAnswerCnt		= 0;

// �迭 �ʱ�ȭ
for (int ni = 0; ni < 23; ni++) {
	for (int nj = 0; nj < 5; nj++) {
		for (int nk = 0; nk < 21; nk++) {
			qa[ni][nj][nk] = "";
		}
	}
}
/* Variable Difinition End ========================================*/

/* Request Variable Start =========================================*/
/*	- �Է³��� Ȯ�� �� ������ ���� parameter ���� �����Ѵ�.
	- ���θ� �����ڰ� �Է³��� Ȯ�� �� �ʿ��׸�
	   --> ��������� ���� �ܺθ������� �ش� ������ ������ ��.
*/
String sCmd			= request.getParameter("cmd")==null ? "":request.getParameter("cmd").trim();
String sAcceptNo		= request.getParameter("accNo")==null ? "":request.getParameter("accNo").trim();
/* Request Variable End ==========================================*/

/* Record Selection Processing Start =================================*/
//if( false ) {
	if( !sPollId.equals("") && sCmd.equals("mngvw") && !sAcceptNo.equals("") ) {
		/* ��� �⺻���� */
		sSQLs = "SELECT * \n" +
					"FROM hado_tb_poll_sent \n" +
					"WHERE poll_id = ? \n" +
					"	AND accept_no = ? \n";
		try {		
				resource	= new ConnectionResource();
				conn		= resource.getConnection();
				pstmt		= conn.prepareStatement(sSQLs);
				pstmt.setString(1, sPollId);
				pstmt.setInt(2, Integer.parseInt(sAcceptNo));
				rs			= pstmt.executeQuery();

				if( rs.next() ) {
					sSentType		= rs.getString("sent_type")==null ? "":rs.getString("sent_type");
					/*
					sBussTerm		= rs.getString("buss_term_year");
					sAreaCD			= rs.getString("area_cd");
					sSubconStep	= rs.getString("subcon_step");
					sDetailCD		= rs.getString("detail_type_cd");
					sSentSale		= rs.getString("sent_sale");
					sEmpCnt		= rs.getString("sent_emp_cnt");
					sCapaCD		= rs.getString("sent_capa_cd");
					*/
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
		/* ����ǥ �������� */
		sSQLs = "SELECT * \n" +
					"FROM hado_tb_poll_sent_answer \n" +
					"WHERE poll_id = ? \n" +
					"	AND accept_no = ? \n" +
					"ORDER BY sent_q_cd, sent_q_gb \n";
		try {		
				resource	= new ConnectionResource();
				conn		= resource.getConnection();
				pstmt		= conn.prepareStatement(sSQLs);
				pstmt.setString(1, sPollId);
				pstmt.setInt(2, Integer.parseInt(sAcceptNo));
				rs			= pstmt.executeQuery();
				
				int qcd = 0;
				int qgb = 0;
				
				nAnswerCnt = 0;

				while( rs.next() ) {
					qcd						= rs.getInt("sent_q_cd");
					qgb						= rs.getInt("sent_q_gb");
					qa[qcd][qgb][1]		= rs.getString("A");
					qa[qcd][qgb][2]		= rs.getString("B");
					qa[qcd][qgb][3]		= rs.getString("C");
					qa[qcd][qgb][4]		= rs.getString("D");
					qa[qcd][qgb][5]		= rs.getString("E");
					qa[qcd][qgb][6]		= rs.getString("F");
					qa[qcd][qgb][7]		= rs.getString("G");
					qa[qcd][qgb][8]		= rs.getString("H");
					qa[qcd][qgb][9]		= rs.getString("I");
					qa[qcd][qgb][10]		= rs.getString("J");
					qa[qcd][qgb][11]		= rs.getString("K");
					qa[qcd][qgb][12]		= rs.getString("L");
					qa[qcd][qgb][13]		= rs.getString("M");
					qa[qcd][qgb][14]		= rs.getString("N");
					qa[qcd][qgb][15]		= rs.getString("O");
					qa[qcd][qgb][16]		= rs.getString("P");
					qa[qcd][qgb][17]		= rs.getString("Q");
					qa[qcd][qgb][18]		= rs.getString("R");
					qa[qcd][qgb][19]		= rs.getString("S");
					qa[qcd][qgb][20]		= rs.getString("Subj_Ans")==null ? "":new String( rs.getString("Subj_Ans").getBytes("ISO8859-1"), "EUC-KR" );

					nAnswerCnt++;
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
	}
}
/* Record Selection Processing End =================================*/
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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
	<title>�����ŷ�����ȸ �ű��������� ��������</title>
	<link rel="stylesheet" href="style.css" type="text/css">
	<script language="javascript" type="text/javascript" src="../js/credian_common_script.js"></script>
</head>

<script language="JavaScript">
	ns4 = (document.layers)? true:false;
	ie4 = (document.all)? true:false;
	
	var msg		= "";
	var radiof	= false;

	function savef() {
		var cchekc	="no";
		var main	= document.info;

		msg = "";
		
		// �ʼ� �Է¹��� üũ :: research2f( form-name, ���ȣ, �ҹ�ȣ, ��üŸ��(1:text,2:radio,3:checkbox),���ⰳ��(checkbox�� �ش� �ƴϸ� 0) );		

		researchf(main.oSentType, 2, "������ �����Ͽ� �ֽʽÿ�.");
		research2f(info, 1, 1, 2, 0);
		research2f(info, 2, 1, 2, 0);
		research2f(info, 3, 1, 2, 0);
		research2f(info, 4, 1, 2, 0);
		research2f(info, 5, 1, 2, 0);
		research2f(info, 6, 1, 2, 0);
		research2f(info, 7, 1, 2, 0);
		research2f(info, 8, 1, 2, 0);
		research2f(info, 9, 1, 2, 0);
		research2f(info, 10, 1, 2, 0);
		research2f(info, 11, 1, 2, 0);
		research2f(info, 12, 1, 2, 0);
		research2f(info, 13, 1, 2, 0);
		research2f(info, 14, 1, 2, 0);
		research2f(info, 15, 1, 2, 0);
		research2f(info, 16, 1, 2, 0);
		research2f(info, 17, 1, 2, 0);
		research2f(info, 18, 1, 2, 0);
		research2f(info, 19, 1, 2, 0);
		research2f(info, 20, 1, 2, 0);
		research2f(info, 21, 1, 2, 0);

		// ���蹮�� ���� Ȯ��
		//--> �Է¿��� Ȯ�� :: research3f(form-name, ���蹮�״��ȣ, ���蹮�׼ҹ�ȣ, ��üŸ��(1:text,2:radio,3:checkbox), ���ⰳ��(checkbox�� �ش� �ƴϸ� 0), ������(����)���״��ȣ, ������(����)���׼ҹ�ȣ);

		//if( main.q1_5_1[3].checked==true || main.q1_5_1[4].checked==true || main.q1_8_1[3].checked==true || main.q1_8_1[4].checked==true || main.q1_11_1[3].checked==true || main.q1_11_1[4].checked==true || main.q1_14_1[3].checked==true || main.q1_14_1[4].checked==true || main.q1_17_1[3].checked==true || main.q1_17_1[4].checked==true ) research3f(main, 18, 1, 1, 0, 18, 1); else initf(main, 18, 1, 1, 0);
		// ���蹮�� ��

		if(msg=="") {
			if(confirm("[ ����ǥ������ �����մϴ�. ]\n\n�����ڰ� ������� �ټ� �ð��� �ɸ����� �ֽ��ϴ�.\n���������� ������ �ȵɰ��\n���ʺ��Ŀ� �ٽýõ��Ͽ� �ֽʽÿ�.\n\nȮ���� �����ø� �����մϴ�.")) {
				
				//document.getElementById("loadingImage").style.display="block";
				//view_layer("loadingImage");

				main.target = "ProceFrame";
				main.action = "Hado_Poll_Query.jsp?cmd=submit";
				main.submit();
			}
		} else {
			alert(msg+"\n\n������ ��ҵǾ����ϴ�.")
		}

	}

	function relationf(main) {
		msg = "";

		// ���蹮�� ���� Ȯ��
		//--> �Է¿��� Ȯ�� :: research3f(form-name, ���蹮�״��ȣ, ���蹮�׼ҹ�ȣ, ��üŸ��(1:text,2:radio,3:checkbox), ���ⰳ��(checkbox�� �ش� �ƴϸ� 0),
		//-->               ������(����)���״��ȣ, ������(����)���׼ҹ�ȣ);
		//--> �����ʱ�ȭ :: initf(form-name, ���״��ȣ, ���׼ҹ�ȣ, ��üŸ��(2:radio,3:checkbox), 0���ⰳ��(checkbox�� �ش� �ƴϸ� 0));

		//if( main.q1_5_1[3].checked==true || main.q1_5_1[4].checked==true || main.q1_8_1[3].checked==true || main.q1_8_1[4].checked==true || main.q1_11_1[3].checked==true || main.q1_11_1[4].checked==true || main.q1_14_1[3].checked==true || main.q1_14_1[4].checked==true || main.q1_17_1[3].checked==true || main.q1_17_1[4].checked==true ) research3f(main, 18, 1, 1, 0, 18, 1); else initf(main, 18, 1, 1, 0);
	}

	// Radio object �缱�ý� �ʱ�ȭ
	function checkradio(ni, nx) {
		eval("oldValue = document.info.c1_"+ni+"_"+nx+".value");
		eval("obj = document.info.q1_"+ni+"_"+nx);
		selValue = "";

		for(i=0; i<obj.length; i++) {
			if(obj[i].checked==true) {
				selValue = (i+1)+"";
				break;
			}
		}

		if(selValue != "") {
			if(selValue == oldValue) {
				eval("document.info.c1_"+ni+"_"+nx+".value = ''");
				initf(document.info, ni, nx, 2, 0);
				relationf(document.info);
			} else {
				eval("document.info.c1_"+ni+"_"+nx+".value = selValue");
				relationf(document.info);
			}
		}
	}

	function researchf(obj,type,mm) {
		var ccheck="no", i;
		switch (type) {
			case 1:
				if(obj.value=="") msg=msg+"\n"+mm;
				break;
			case 2:
				for(i=0;i<obj.length;i++)
					if(obj[i].checked==true) ccheck="yes";
				if(ccheck=="no") msg=msg+"\n"+mm;
				break;
		}
	
	}

	//-- �ʼ��׸� ���ÿ��� Ȯ�� --//
	function research2f(obj,fno,sno,type,gesu) {
		var ccheck="no", i;

		switch (type) {
			case 1:	// text
				ccheck="yes";
				eval("if(obj.q1_"+fno+"_"+sno+".value=='') ccheck='no'");
				break;
			case 2:	// Radio
				eval("for(i=0;i<obj.q1_"+fno+"_"+sno+".length;i++) if(obj.q1_"+fno+"_"+sno+"[i].checked==true) ccheck='yes'");
				break;
			case 3:	// checkbox
				for(i=1;i<=gesu;i++)
					eval("if(obj.q1_"+fno+"_"+sno+"_"+i+".checked==true) ccheck='yes'");
				break;
		}

		if(ccheck=="no") {
			msg=msg+"\n";

			if( type=="1" ) {
				eval("msg=msg+'����ǥ�� "+fno+"�� ������ �Է��Ͽ� �ֽʽÿ�.'");
				//eval("msg=msg+'����ǥ�� "+fno+"���� ("+sno+")���� �Է��Ͽ� �ֽʽÿ�.'");
			} else if (fno=="22") {
				eval("msg=msg+'���������� üũ�Ͽ� �ֽʽÿ�.'");
				//eval("msg=msg+'����ǥ�� "+fno+"���� ("+sno+")���� �Է��Ͽ� �ֽʽÿ�.'");
			}else {
				eval("msg=msg+'����ǥ�� "+fno+"�� ������ �����Ͽ� �ֽʽÿ�.'");
				//eval("msg=msg+'����ǥ�� "+fno+"���� ("+sno+")���� �Է��Ͽ� �ֽʽÿ�.'");
			}
		}
	}

	//-- �����׸� ���ÿ��� Ȯ�� --//
	function research3f(obj,fno,sno,type,gesu,ofno,osno) {
		var ccheck="no", i;

		switch (type) {
			case 1:	// text
				ccheck="yes";
				eval("if(obj.q1_"+fno+"_"+sno+".value=='') ccheck='no'");
				break;
			case 2:	// Radio
				eval("for(i=0;i<obj.q1_"+fno+"_"+sno+".length;i++) if(obj.q1_"+fno+"_"+sno+"[i].checked==true) ccheck='yes'");
				break;
			case 3:	// checkbox
				for(i=1;i<=gesu;i++)
					eval("if(obj.q1_"+fno+"_"+sno+"_"+i+".checked==true) ccheck='yes'");
				break;
		}

		if(ccheck=="no") {
			msg=msg+"\n";

			if( type=="1") {
				eval("msg=msg+'����ǥ�� "+ofno+"�� ������ �Է��Ͽ� �ֽʽÿ�.'");
				//eval("msg=msg+'����ǥ�� "+ofno+"���� ("+osno+")���� ���蹮�� "+fno+"���� ("+sno+")���� �Է��Ͽ� �ֽʽÿ�.'");
			} else {
				eval("msg=msg+'����ǥ�� "+ofno+"�� ������ �����Ͽ� �ֽʽÿ�.'");
				//eval("msg=msg+'����ǥ�� "+ofno+"���� ("+osno+")���� ���蹮�� "+fno+"���� ("+sno+")���� �����Ͽ� �ֽʽÿ�.'");
			}
		}
	}
	
	// ���� �ʱ�ȭ function
	function initf(obj,fno,sno,type,gesu) {
		switch(type) {
			case 1:
				eval("obj.q1_"+fno+"_"+sno+".value=''");
				break;
			case 2:
				eval("for(i=0;i<obj.q1_"+fno+"_"+sno+".length;i++) obj.q1_"+fno+"_"+sno+"[i].checked=false");
				break;
			case 3:
				for(i=1;i<=gesu;i++)
					eval("obj.q1_"+fno+"_"+sno+"_"+i+".checked=false");
				break;
		}
	}

</script>

<body>
	
	<div id="loadingImage" style="display:none;left:1;top:1;position:absolute;z-index:1000;">
		<br/><br/><br/><br/><br/>
		<img src="../img/system_loding.gif" border="0"/>
	</div>

	<div id="container">
	<div id="wrapper">
		<!-- Begin Header -->
		<div id="subheader">
			<ul class="lt">
				<li class="fl"><a href="/" onfocus="this.blur()"><img src="img/logo.gif" ></a></li>
				<li class="fr">
					<ul class="lt">
						<li class="pt_20"></li>
					</ul>
				</li>
			</ul>
		</div>

		<div id="submenu">
			
		</div>
		<!-- End Header -->

		<form action="" method="post" name="info">
		<!-- Begin subcontent -->
		<div id="subcontent">
			<!-- title start -->
			<h1 class="contenttitle">�ű��������� ��������</h1>
			<!-- title end -->
			
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">�� �������</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><span>��</span>�����ŷ�����ȸ�� �ϵ��ްŷ����� ��������� �Ұ����� �����κ��� ���޻���ڸ� ��ȣ�ϰ� ���޻������ �Ǹ��� ��ȭ�ϱ� ���� <font style="font-weight:bold;">��3�� ���ع���� �������� Ȯ��</font>�ϰ�, <font style="font-weight:bold;">��δ�Ư���� �����ϴ� ����</font>�� ���ϵ��ްŷ� ����ȭ�� ���� �������� �����Ͽ����ϴ�.</li>
						<li><span>��</span>�̿� ���� ���Ե� ������ ���޻���ڿ��� ������ ������ �ǰ� �ִ��� ���θ� �ľ��ϰ�, �ʿ��� ���� ���ϻ����� �����ϱ� ���� �ڷ�� Ȱ���ϱ� ���� �� ���縦 �ǽ��ϰ��� �Ͽ���, ������� �ٻڽð����� ��� �ð��� �Ҿ��Ͻþ� �� ���翡 ���������� ���Ͽ� �ֽñ� �ٶ��ϴ�.</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontenttitle">�� �������</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="clt">
						<li><span>��</span>�� ����� ��������� ����Ǹ�, �ͻ簡 ����ǥ�� ������ ���������ϵ��ްŷ� ����ȭ�� ���� ������ ��27�� ��3�׿� ���� ö���� ����� ����ǰ�, ��� ���� �̿��� �ٸ� �뵵�δ� ������ ������ ��ӵ帳�ϴ�.</li>
						<li><span>��</span>�������� ���μ��� �����ŷ�����ȸ ����ŷ���å���̸�, ���ǻ����� �����ø� �Ʒ� ��ȭ�� �����ֽñ� �ٶ��ϴ�.</li>
						<li><span></span>�� 044-200-4588, 044-200-4593</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			
			<h2 class="contenttitle">�� ��ü��Ȳ</h2>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">  �ش���� �����ϰų� üũ�Ͽ� �ֽʽÿ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<table class="tbl_blue">
					<tr>
						<th>����</th>
						<td colspan="3">
							<input type="radio" name="oSentType" value="1" <%if(sSentType.equals("1")){out.print("checked");}%>>�� ������
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="oSentType" value="2" <%if(sSentType.equals("2")){out.print("checked");}%>>�� �Ǽ���
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" name="oSentType" value="3" <%if(sSentType.equals("3")){out.print("checked");}%>>�� �뿪��
						</td>
					</tr>
				</table>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">��. 3�� ���ع�� ������ ������� Ȯ������� ����</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span>��</span>���� ���� �Ұ����� ������ �����ϰ� ���ظ� ���� �߼ұ���� �Ǹ��� ��ȭ�ϱ� ���Ͽ� 3�� ���ع���� �������� <font style="font-weight:bold;">'�����������'���� '�δ���<br/>�ϵ��޴�ݰ���������, �δ���Ź ��� �� �δ��ǰ'���� Ȯ��(�ϵ��޹� ����, 2013.11.29. ����)</font>�Ͽ����ϴ�. ���� ���� �� �Ұ��������� �� ���<br/>�������, ��¡��, ���� ���� �ΰ��� �Ӹ� �ƴ϶�, <font style="font-weight:bold;">���ظ� ���� �߼ұ���� ������ ���ع�� û���� �Ͽ� ���ؾ��� 3����� ����� ���� �� �ְ�<br/>�Ǿ����ϴ�.</font></li>
				</ul>
			</div>	

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>1. </span> �����ŷ�����ȸ�� <font style="font-weight:bold;">3�� ���ع�� ������ �������</font>�� ���� ������뿡�� �δ��� <font style="font-weight:bold;">�ϵ��޴�� ���������� ����, �δ��� ��Ź��� �� �δ��ǰ �������� Ȯ���Ͽ� ����</font>�ϰ� �ֽ��ϴ�. �ͻ�� �̷��� ������ ����ǰ� �ִ� ���� �˰� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_1_1" value="<%=setHiddenValue(qa, 1, 1, 5)%>">
						<li><input type="Radio" name="q1_1_1" value="1" <%if(qa[1][1][1]!=null && qa[1][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);"> ��. �� �˰� ����</li>
						<li><input type="Radio" name="q1_1_1" value="2" <%if(qa[1][1][2]!=null && qa[1][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);"> ��. ��ü�� �˰� ����</li>
						<li><input type="Radio" name="q1_1_1" value="3" <%if(qa[1][1][3]!=null && qa[1][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);"> ��. �ణ �˰� ����</li>
						<li><input type="Radio" name="q1_1_1" value="4" <%if(qa[1][1][4]!=null && qa[1][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);"> ��. �� ��</li>
						<li><input type="Radio" name="q1_1_1" value="5" <%if(qa[1][1][5]!=null && qa[1][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);"> ��. ���� ��</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span></span>3�� ���ع���� ������ �� <font style="font-weight:bold;">�δ��� �ϵ��� ��ݰ��������� ����</font>�Դϴ�. ������ڰ� <font style="font-weight:bold;">�δ��ϰ� �ϵ��޴���� �����ϰų�, ������ ������ ��������<br/>��Ź ��� ���ߴ� �ݾ׺��� ���� �ϵ��޴���� �����ϴ� ����</font>�� ���� �Ʒ� 2~4�� ���׿� �����Ͽ� �ֽñ� �ٶ��ϴ�.</li>
				</ul>
			</div>	

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>2. </span> <font style="font-weight:bold;">2014�⵵ ��ݱ�(2014.1.1.��2014.6.30.)</font>���� ������ڰ� �δ��ϰ� �ϵ��޴���� �����ϰų� ������ ��찡 �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_2_1" value="<%=setHiddenValue(qa, 2, 1, 2)%>">
						<li><input type="Radio" name="q1_2_1" value="1" <%if(qa[2][1][1]!=null && qa[2][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);"> ��. ������</li>
						<li><input type="Radio" name="q1_2_1" value="2" <%if(qa[2][1][2]!=null && qa[2][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);"> ��. �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>3. </span> <font style="font-weight:bold;">2015�⵵ ��ݱ�(2015.1.1.��2015.6.30.)</font>���� ������ڰ� �δ��ϰ� �ϵ��޴���� �����ϰų� ������ ��찡 �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_3_1" value="<%=setHiddenValue(qa, 3, 1, 2)%>">
						<li><input type="Radio" name="q1_3_1" value="1" <%if(qa[3][1][1]!=null && qa[3][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);"> ��. ������</li>
						<li><input type="Radio" name="q1_3_1" value="2" <%if(qa[3][1][2]!=null && qa[3][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);"> ��. �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>4. </span> ��������� �δ��� �ϵ��޴�� ���������� ������ 2014�⵵ ��ݱ�� ���Ͽ� 2015�⵵ ��ݱ⿡ ��� ���� �����Ǿ��ٰ� �����Ͻʴϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_4_1" value="<%=setHiddenValue(qa, 4, 1, 5)%>">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_4_1" value="1" <%if(qa[4][1][1]!=null && qa[4][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);"> 5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_4_1" value="2" <%if(qa[4][1][2]!=null && qa[4][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);"> 4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_4_1" value="3" <%if(qa[4][1][3]!=null && qa[4][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);"> 3��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_4_1" value="4" <%if(qa[4][1][4]!=null && qa[4][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);"> 2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_4_1" value="5" <%if(qa[4][1][5]!=null && qa[4][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);"> 1��&nbsp;&nbsp; ������</li>
						<li>�ſ� �����ǰ� ���� ������������������������������������������������ �������� �ʰ� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span></span>3�� ���ع���� ������ �� <font style="font-weight:bold;">�δ��� ��Ź��� ����</font>�Դϴ�. ������ڰ� <font style="font-weight:bold;">�ϵ��� ����� �Ϲ������� ����ϴ� ����</font>�� ���� �Ʒ� 5~7�� ���׿�<br/>�����Ͽ� �ֽñ� �ٶ��ϴ�.</li>
				</ul>
			</div>	

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>5. </span> <font style="font-weight:bold;">2014�⵵ ��ݱ�(2014.1.1.��2014.6.30.)</font>���� �ͻ��� ��å������ �������� �ұ��ϰ� ������ڰ� �ϵ��� ����� �Ϲ������� ����� ��찡 �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_5_1" value="<%=setHiddenValue(qa, 5, 1, 2)%>">
						<li><input type="Radio" name="q1_5_1" value="1" <%if(qa[5][1][1]!=null && qa[5][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"> ��. ������</li>
						<li><input type="Radio" name="q1_5_1" value="2" <%if(qa[5][1][2]!=null && qa[5][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);"> ��. �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>6. </span> <font style="font-weight:bold;">2015�⵵ ��ݱ�(2015.1.1.��2015.6.30.)</font>���� �ͻ��� ��å������ �������� �ұ��ϰ� ������ڰ� �ϵ��� ����� �Ϲ������� ����� ��찡 �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_6_1" value="<%=setHiddenValue(qa, 6, 1, 2)%>">
						<li><input type="Radio" name="q1_6_1" value="1" <%if(qa[6][1][1]!=null && qa[6][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(6,1);"> ��. ������</li>
						<li><input type="Radio" name="q1_6_1" value="2" <%if(qa[6][1][2]!=null && qa[6][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(6,1);"> ��. �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>7. </span> ��������� �δ��� ��Ź��� ������ 2014�⵵ ��ݱ�� ���Ͽ� 2015�⵵ ��ݱ⿡ ��� ���� �����Ǿ��ٰ� �����Ͻʴϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_7_1" value="<%=setHiddenValue(qa, 7, 1, 5)%>">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_7_1" value="1" <%if(qa[7][1][1]!=null && qa[7][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);"> 5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_7_1" value="2" <%if(qa[7][1][2]!=null && qa[7][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);"> 4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_7_1" value="3" <%if(qa[7][1][3]!=null && qa[7][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);"> 3��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_7_1" value="4" <%if(qa[7][1][4]!=null && qa[7][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);"> 2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_7_1" value="5" <%if(qa[7][1][5]!=null && qa[7][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);"> 1��&nbsp;&nbsp; ������</li>
						<li>�ſ� �����ǰ� ���� ������������������������������������������������ �������� �ʰ� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span></span>3�� ���ع���� ������ �� <font style="font-weight:bold;">�δ��ǰ ����</font>�Դϴ�. ������ڰ� <font style="font-weight:bold;">�������� ��ǰ ���� ���� �� �Ϲ������� ��ǰ�ϴ� ����</font>�� ���� �Ʒ� 8~10�� ���׿�<br>�����Ͽ� �ֽñ� �ٶ��ϴ�.</li>
				</ul>
			</div>	

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>8. </span> <font style="font-weight:bold;">2014�⵵ ��ݱ�(2014.1.1.��2014.6.30.)</font>���� �ͻ��� ��å������ �������� �ұ��ϰ� ������ڰ� �������� ��ǰ ���� ���� �� ��ǰ�� ��찡 �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_8_1" value="<%=setHiddenValue(qa, 8, 1, 2)%>">
						<li><input type="Radio" name="q1_8_1" value="1" <%if(qa[8][1][1]!=null && qa[8][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"> ��. ������</li>
						<li><input type="Radio" name="q1_8_1" value="2" <%if(qa[8][1][2]!=null && qa[8][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);"> ��. �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>9. </span> <font style="font-weight:bold;">2015�⵵ ��ݱ�(2015.1.1.��2015.6.30.)</font>���� �ͻ��� ��å������ �������� �ұ��ϰ� ������ڰ� �������� ��ǰ ���� ���� �� ��ǰ�� ��찡 �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_9_1" value="<%=setHiddenValue(qa, 9, 1, 2)%>">
						<li><input type="Radio" name="q1_9_1" value="1" <%if(qa[9][1][1]!=null && qa[9][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);"> ��. ������</li>
						<li><input type="Radio" name="q1_9_1" value="2" <%if(qa[9][1][2]!=null && qa[9][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);"> ��. �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>10. </span> ��������� �δ��ǰ ������ 2014�⵵ ��ݱ�� ���Ͽ� 2015�⵵ ��ݱ⿡ ��� ���� �����Ǿ��ٰ� �����Ͻʴϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_10_1" value="<%=setHiddenValue(qa, 10, 1, 5)%>">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_10_1" value="1" <%if(qa[10][1][1]!=null && qa[10][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_10_1" value="2" <%if(qa[10][1][2]!=null && qa[10][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_10_1" value="3" <%if(qa[10][1][3]!=null && qa[10][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 3��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_10_1" value="4" <%if(qa[10][1][4]!=null && qa[10][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_10_1" value="5" <%if(qa[10][1][5]!=null && qa[10][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);"> 1��&nbsp;&nbsp; ������</li>
						<li>�ſ� �����ǰ� ���� ������������������������������������������������ �������� �ʰ� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span></span>3�� ���ع���� ������ �� <font style="font-weight:bold;">������� ����</font>�Դϴ�. ��������� <font style="font-weight:bold;">������� ����</font>�� ���� �Ʒ� 11~13�� ���׿� �����Ͽ� �ֽñ� �ٶ��ϴ�.</li>
				</ul>
			</div>	

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>11. </span> <font style="font-weight:bold;">2014�⵵ ��ݱ�(2014.1.1.��2014.6.30.)</font>���� ������ڰ� �ͻ�κ��� ����� ����ڷḦ ������� �Ǵ� ��3���� ������ ���� ��������ν� �ͻ翡�� ���ذ� �߻��� ������ �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_11_1" value="<%=setHiddenValue(qa, 11, 1, 2)%>">
						<li><input type="Radio" name="q1_11_1" value="1" <%if(qa[11][1][1]!=null && qa[11][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);"> ��. ������</li>
						<li><input type="Radio" name="q1_11_1" value="2" <%if(qa[11][1][2]!=null && qa[11][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);"> ��. �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>12. </span> <font style="font-weight:bold;">2015�⵵ ��ݱ�(2015.1.1.��2015.6.30.)</font>���� ������ڰ� �ͻ�κ��� ����� ����ڷḦ ������� �Ǵ� ��3���� ������ ���� ��������ν� �ͻ翡�� ���ذ� �߻��� ������ �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_12_1" value="<%=setHiddenValue(qa, 12, 1, 2)%>">
						<li><input type="Radio" name="q1_12_1" value="1" <%if(qa[12][1][1]!=null && qa[12][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"> ��. ������</li>
						<li><input type="Radio" name="q1_12_1" value="2" <%if(qa[12][1][2]!=null && qa[12][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);"> ��. �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>13. </span> ��������� ������� ������ 2014�⵵ ��ݱ�� ���Ͽ� 2015�⵵ ��ݱ⿡ ��� ���� �����Ǿ��ٰ� �����Ͻʴϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_13_1" value="<%=setHiddenValue(qa, 13, 1, 5)%>">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_13_1" value="1" <%if(qa[13][1][1]!=null && qa[13][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"> 5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_13_1" value="2" <%if(qa[13][1][2]!=null && qa[13][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"> 4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_13_1" value="3" <%if(qa[13][1][3]!=null && qa[13][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"> 3��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_13_1" value="4" <%if(qa[13][1][4]!=null && qa[13][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"> 2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_13_1" value="5" <%if(qa[13][1][5]!=null && qa[13][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);"> 1��&nbsp;&nbsp; ������</li>
						<li>�ſ� �����ǰ� ���� ������������������������������������������������ �������� �ʰ� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">��. �δ�Ư�� �������� ���� ����</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span>��</span>����(Ư��)�� ������� <font style="font-weight:bold;">���� ���� �δ��ؾ� �� ���� ���(��:�ο�ó�� ��� ��)�� �߼ұ������ �����ϴ� ������ ����</font>�ϱ� ���� �ϵ��ް�࿡��<br><font style="font-weight:bold;">�δ��� Ư���� ������ ����(�ϵ��޹� ����, 2014.2.14.����)</font>�Ͽ����ϴ�. ���� ���� �δ�Ư���� ������ ��� Ư�������� ���������� �� �������,<br>��¡��, ���� ���� �ΰ��˴ϴ�.</font></li>
				</ul>
			</div>	

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>14. </span> �����ŷ�����ȸ�� ������ڰ� �δ��ؾ� �� ���� ����� �����ϴ� ������ �����ϱ� ���� <font style="font-weight:bold;"><u>���޻������ ������ �δ��ϰ� ħ���ϰų� �����ϴ� ��������� �������� ���ϵ��� �ϴ� �δ�Ư����������� �����Ͽ� ����</u></font>�ϰ� �ֽ��ϴ�. �ͻ�� �̷��� ������ ����ǰ� �ִ� ���� �˰� �ֽ��ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_14_1" value="<%=setHiddenValue(qa, 14, 1, 5)%>">
						<li><input type="Radio" name="q1_14_1" value="1" <%if(qa[14][1][1]!=null && qa[14][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"> ��. �� �˰� ����</li>
						<li><input type="Radio" name="q1_14_1" value="2" <%if(qa[14][1][2]!=null && qa[14][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"> ��. ��ü�� �˰� ����</li>
						<li><input type="Radio" name="q1_14_1" value="3" <%if(qa[14][1][3]!=null && qa[14][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"> ��. �ణ �˰� ����</li>
						<li><input type="Radio" name="q1_14_1" value="4" <%if(qa[14][1][4]!=null && qa[14][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"> ��. �� ��</li>
						<li><input type="Radio" name="q1_14_1" value="5" <%if(qa[14][1][5]!=null && qa[14][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);"> ��. ���� ��</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>15. </span> <font style="font-weight:bold;">2014�⵵ ��ݱ�(2014.1.1.��2014.6.30.)</font>���� �ͻ簡 ������ڿ� ü���� �ϵ��ް�࿡ ������ڰ� �ͻ��� ������ �δ��ϰ� ħ���ϰų� �����ϴ� ��������� ������ ����� �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_15_1" value="<%=setHiddenValue(qa, 15, 1, 2)%>">
						<li><input type="Radio" name="q1_15_1" value="1" <%if(qa[15][1][1]!=null && qa[15][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"> ��. ������</li>
						<li><input type="Radio" name="q1_15_1" value="2" <%if(qa[15][1][2]!=null && qa[15][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);"> ��. �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>16. </span> <font style="font-weight:bold;">2015�⵵ ��ݱ�(2015.1.1.��2015.6.30.)</font>���� �ͻ簡 ������ڿ� ü���� �ϵ��ް�࿡ ������ڰ� �ͻ��� ������ �δ��ϰ� ħ���ϰų� �����ϴ� ��������� ������ ����� �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_16_1" value="<%=setHiddenValue(qa, 16, 1, 2)%>">
						<li><input type="Radio" name="q1_16_1" value="1" <%if(qa[16][1][1]!=null && qa[16][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"> ��. ������</li>
						<li><input type="Radio" name="q1_16_1" value="2" <%if(qa[16][1][2]!=null && qa[16][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);"> ��. �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>17. </span> ������ڰ� �δ��� Ư���� �����ϴ� �Ұ��������� 2014�⵵ ��ݱ�� ���Ͽ� 2015�⵵ ��ݱ⿡ ��� ���� �����Ǿ��ٰ� �����Ͻʴϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_17_1" value="<%=setHiddenValue(qa, 17, 1, 5)%>">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="1" <%if(qa[17][1][1]!=null && qa[17][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"> 5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="2" <%if(qa[17][1][2]!=null && qa[17][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"> 4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="3" <%if(qa[17][1][3]!=null && qa[17][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"> 3��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="4" <%if(qa[17][1][4]!=null && qa[17][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"> 2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="5" <%if(qa[17][1][5]!=null && qa[17][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);"> 1��&nbsp;&nbsp; ������</li>
						<li>�ſ� �����ǰ� ���� ������������������������������������������������ �������� �ʰ� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">��. �ϵ��޴�� ���޽��� ����</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt">
					<li class="boxcontenttitle"><span>��</span>�����ŷ�����ȸ�� 2014.7�� ���� �ϵ��޴�� ���� ���� �Ұ��������� ������ ���߾� �������縦 �ϰ� ������, Ư�� <font style="font-weight:bold;">2015�� 3������ �Ƿ�, ����,<br>�ڵ���, �Ǽ�, ��� ���� ���� �ϵ��޴�� ���� �ο��� ����ϴ� ������ ���� �ϵ��޴�� �����ޤ���������, �������η� ������, ���ݰ��� ����<br>���ؼ�</font> �� �ϵ��޴�� ���� ���� <font style="font-weight:bold;">�������縦 ���������� �ǽ�</font>�ϰ� �ֽ��ϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>18. </span> 2014�⵵ ��ݱ�(2014.1.1 ~ 2014.6.30.)���� ������ڰ� �ϵ��޴���� �������ϰų�, �������ڸ� �������� ��찡 �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_18_1" value="<%=setHiddenValue(qa, 18, 1, 2)%>">
						<li><input type="Radio" name="q1_18_1" value="1" <%if(qa[18][1][1]!=null && qa[18][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"> ��. ������</li>
						<li><input type="Radio" name="q1_18_1" value="2" <%if(qa[18][1][2]!=null && qa[18][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);"> ��. �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>19. </span> 2015�⵵ ��ݱ�(2015.1.1 ~ 2015.6.30.)���� ������ڰ� �ϵ��޴���� �������ϰų�, �������ڸ� �������� ��찡 �־����ϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="1_19_1" value="<%=setHiddenValue(qa, 19, 1, 2)%>">
						<li><input type="Radio" name="q1_19_1" value="1" <%if(qa[19][1][1]!=null && qa[19][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);"> ��. ������</li>
						<li><input type="Radio" name="q1_19_1" value="2" <%if(qa[19][1][2]!=null && qa[19][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);"> ��. �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>20. </span> �ϵ��޴�� ���� ���� �Ұ��������� 2014�⵵ ��ݱ�� ���Ͽ� <font style="font-weight:bold;">�������� �ϵ��޴�� ���� �ο���� ������ ���� �������縦 ���������� ������ 2015�� ��ݱ⿡</font> ��� ���� �����Ǿ��ٰ� �����Ͻʴϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_20_1" value="<%=setHiddenValue(qa, 20, 1, 5)%>">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_20_1" value="1" <%if(qa[20][1][1]!=null && qa[20][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"> 5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_20_1" value="2" <%if(qa[20][1][2]!=null && qa[20][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"> 4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_20_1" value="3" <%if(qa[20][1][3]!=null && qa[20][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"> 3��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_20_1" value="4" <%if(qa[20][1][4]!=null && qa[20][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"> 2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_20_1" value="5" <%if(qa[20][1][5]!=null && qa[20][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(20,1);"> 1��&nbsp;&nbsp; ������</li>
						<li>�ſ� �����ǰ� ���� ������������������������������������������������ �������� �ʰ� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="clt">
						<li class="boxcontenttitle"><span>21. </span> �ͻ�� ���� ���� �������� �ϵ��޴�� ���� ���� �������簡 �ϵ��޴�� ���� �Ұ��������� �����ϴµ� ��� ���� ������ �ǰų� ȿ���� ���� ���̶�� �����Ͻʴϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_21_1" value="<%=setHiddenValue(qa, 21, 1, 5)%>">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_21_1" value="1" <%if(qa[21][1][1]!=null && qa[21][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"> 5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_21_1" value="2" <%if(qa[21][1][2]!=null && qa[21][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"> 4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_21_1" value="3" <%if(qa[21][1][3]!=null && qa[21][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"> 3��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_21_1" value="4" <%if(qa[21][1][4]!=null && qa[21][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"> 2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_21_1" value="5" <%if(qa[21][1][5]!=null && qa[21][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(21,1);"> 1��&nbsp;&nbsp; ������</li>
						<li>���� ȿ���� ���� ���� ���������������������������������������������� ȿ���� ���� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_20"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp lt">
					<li class="boxcontenttitle"><p align="center">�ٻڽ� �߿��� ������ ������ �����Ͽ� �ּż� �����մϴ�.</p></li>
				</ul>
			</div>

			<div class="fc pt_20"></div>

			<!-- ��ư start -->
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="#" onclick="savef(); return false;" onfocus="this.blur()" class="contentbutton2">�� ��</a></li>
				</ul>
			</div>

			<!-- ��ư end -->

		</div>
		</form>
		<!-- End subcontent -->

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
		alert("���������� ���۵Ǿ����ϴ�.\������ �ּż� �����մϴ�.")
	<%}%>
</script>

</body>
</html>
<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>