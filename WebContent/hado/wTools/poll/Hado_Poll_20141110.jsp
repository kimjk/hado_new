<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%
/*=======================================================*/
/* ������Ʈ��		: 2014�� �����ŷ�����ȸ �űԵ����������� ��������					*/
/* ���α׷���		: Hado_Poll.jsp																		*/
/* ���α׷�����	: �������� �Է� ������															*/
/* ���α׷�����	: 1.0.0																				*/
/* �����ۼ�����	: 2014�� 07�� 07��																*/
/*--------------------------------------------------------------------------------------- */
/*	�ۼ�����		�ۼ��ڸ�				����
/*--------------------------------------------------------------------------------------- */
/*	2014-07-07	������	�����ۼ�																*/			
/*=======================================================*/

/* Variable Difinition Start ======================================*/
String sPollId			= "20141110";		// ������ȣ
String sReturnURL	= "Hado_Poll_20141110.jsp";	// �������� �̵��� ������
String sSQLs			= "";						// SQL��

ConnectionResource resource		= null;	// Database Resource
Connection conn						= null;	// Database Connection
PreparedStatement pstmt			= null;	// PreparedStatument
ResultSet rs								= null;	// Result RecordSet

// ȸ�� �⺻����
String sSentType		= "";	// ����
String sBussTerm		= "";	// ����Ⱓ
String sAreaCD		= "";  // �����ڵ�
String sSubconStep	= "";	// ������ڿ��� �ŷ��ܰ�
String sDetailCD		= "";	// ���ξ�������
String sSentSale		= "";	// �����
String sEmpCnt		= "";	// �����������
String sCapaCD		= "";	// ����Ը𱸺�

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
					sBussTerm		= rs.getString("buss_term_year")==null ? "":rs.getString("buss_term_year");
					sAreaCD			= rs.getString("area_cd")==null ? "":rs.getString("area_cd");
					sSubconStep	= rs.getString("subcon_step")==null ? "":rs.getString("subcon_step");
					sDetailCD		= rs.getString("detail_type_cd")==null ? "":rs.getString("detail_type_cd");
					sSentSale		= rs.getString("sent_sale")==null ? "":rs.getString("sent_sale");
					sEmpCnt		= rs.getString("sent_emp_cnt")==null ? "":rs.getString("sent_emp_cnt");
					sCapaCD		= rs.getString("sent_capa_cd")==null ? "":rs.getString("sent_capa_cd");
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
//}
/* Record Selection Processing End =================================*/

/* Other Bussines Processing Start ==================================*/
//None
/* Other Bussines Processing End ===================================*/
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
	<title>�����ŷ�����ȸ �űԵ����������� ��������</title>
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
		//research2f(main, 9, 1, 2, 0);

		researchf(main.oSentType, 2, "������ �����Ͽ� �ֽʽÿ�.");
		if(main.oSentType[0].checked==true) researchf(main.oDetailCD, 2, "���ξ����� �����Ͽ� �ֽʽÿ�.");
		researchf(main.oSubconStep, 2, "�ŷ����¸� �����Ͽ� �ֽʽÿ�.");
		researchf(main.oSentSale, 1, "������� �Է��Ͽ� �ֽʽÿ�.");

		research2f(info, 22, 1, 3, 12);
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


		// ���蹮�� ���� Ȯ��
		//--> �Է¿��� Ȯ�� :: research3f(form-name, ���蹮�״��ȣ, ���蹮�׼ҹ�ȣ, ��üŸ��(1:text,2:radio,3:checkbox), ���ⰳ��(checkbox�� �ش� �ƴϸ� 0), ������(����)���״��ȣ, ������(����)���׼ҹ�ȣ);
		//if( main.q1_29_1[3].checked==true || main.q1_29_1[4].checked==true ) research3f(main, 29, 3, 1, 0, 29, 1); else initf(main, 29, 3, 1, 0);
		// ���蹮�� ��

		if(msg=="") {
			if(confirm("[ ����ǥ������ �����մϴ�. ]\n\n�����ڰ� ������� �ټ� �ð��� �ɸ����� �ֽ��ϴ�.\n���������� ������ �ȵɰ��\n���ʺ��Ŀ� �ٽýõ��Ͽ� �ֽʽÿ�.\n\nȮ���� �����ø� �����մϴ�.")) {
				
				//document.getElementById("loadingImage").style.display="block";
				view_layer("loadingImage");

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
		//if( main.q1_29_1[3].checked==true || main.q1_29_1[4].checked==true ) research3f(main, 29, 3, 1, 0, 29, 1); else initf(main, 29, 3, 1, 0);

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
			} else {
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
				eval("msg=msg+'����ǥ�� "+ofno+"���� ("+osno+")���� ���蹮�� "+fno+"���� ("+sno+")���� �Է��Ͽ� �ֽʽÿ�.'");
			} else {
				eval("msg=msg+'����ǥ�� "+ofno+"���� ("+osno+")���� ���蹮�� "+fno+"���� ("+sno+")���� �����Ͽ� �ֽʽÿ�.'");
			}
		}
	}

	function noanswerf(obj,fno,sno,tno,type,gesu,ft1,ft2) {
		var ccheck="no";

		if(fno==9&&sno==3) {
			if(ft1!="z")
				eval("if(obj.q1_"+fno+"_"+sno+"_"+ft1+".checked==false&&obj.q1_"+fno+"_"+sno+"_"+ft2+".checked==false) ccheck='yes'");
		} else {
			if(ft1!="z")
				eval("if(obj.q1_"+fno+"_"+sno+"["+ft1+"].checked==true) ccheck='yes'");
			if(ft2!="z")
				eval("if(obj.q1_"+fno+"_"+sno+"["+ft2+"].checked==true) ccheck='yes'");
		}

		if(ccheck=="yes") {
			eval("alert('������� : "+fno+"���� ("+sno+")�� ����Ȯ�� ��� ')");

			switch(type) {
				case 2:
					eval("for(i=0;i<obj.q1_"+fno+"_"+tno+".length;i++) obj.q1_"+fno+"_"+tno+"[i].checked=false");
					break;
				case 3:
					for(i=1;i<=gesu;i++)
						eval("obj.q1_"+fno+"_"+tno+"_"+i+".checked=false");
					break;
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

	//--------------------------------------------------------------------------------------------------------
	var bName = navigator.appName;
	var bVer = parseInt(navigator.appVersion);
	var NS4 = (bName == "Netscape" && bVer >= 4);
	var IE4 = (bName == "Microsoft Internet Explore" && bVer >= 4);
	var NS3 = (bName == "Netscape" && bVer < 4);
	var IE3 = (bName == "Microsoft Internet Explore" && bVer < 4);

	var vTime = 5;

	function view_layer(obj) {
		var listDiv	= eval("document.getElementById('" + obj + "')");
		var topx	= 50;
		var leftx	= 60;

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
		main.qhap16.value=Cnum(main.q1_100_3_1.value)+Cnum(main.q1_100_3_2.value)+Cnum(main.q1_100_3_3.value)+Cnum(main.q1_100_3_4.value)+Cnum(main.q1_100_3_5.value)+Cnum(main.q1_100_3_6.value)+Cnum(main.q1_100_3_7.value)+Cnum(main.q1_100_3_8.value);
		
		main.qper7.value=Cnum(Math.round(Cnum(main.q1_100_3_1.value)/Cnum(main.qhap16.value)*100));
		main.qper8.value=Cnum(Math.round(Cnum(main.q1_100_3_2.value)/Cnum(main.qhap16.value)*100));
		main.qper9.value=Cnum(Math.round(Cnum(main.q1_100_3_3.value)/Cnum(main.qhap16.value)*100));
		main.qper10.value=Cnum(Math.round(Cnum(main.q1_100_3_4.value)/Cnum(main.qhap16.value)*100));
		main.qper11.value=Cnum(Math.round(Cnum(main.q1_100_3_5.value)/Cnum(main.qhap16.value)*100));
		main.qper12.value=Cnum(Math.round(Cnum(main.q1_100_3_6.value)/Cnum(main.qhap16.value)*100));
		main.qper13.value=Cnum(Math.round(Cnum(main.q1_100_3_7.value)/Cnum(main.qhap16.value)*100));
		main.qper14.value=Cnum(Math.round(Cnum(main.q1_100_3_8.value)/Cnum(main.qhap16.value)*100));
	}

	function OpenPost() {
		MsgWindow = window.open("WB_Find_Zip.jsp?ITEM=F&stype=prod3","_PostSerch","toolbar=no,width=430,height=320,directories=no,status=yes,scrollbars=yes,resize=no,menubar=no");
	}
	
	function formatmoney(m) {
		var money, pmoney, mlength, z, textsize, i;
		textsize= 20;
		pmoney	= "";
		z		= 0;
		money	= m;
		money	= clearstring(money);
		money	= Number(money);
		money	= money + "";

		for(i=money.length-1;i>=0;i--) {
			z=z+1;

			if(z%3==0) {
				pmoney=money.substr(i,1)+pmoney;
				if(i!=0)	pmoney=","+pmoney;
			}
			else pmoney=money.substr(i,1)+pmoney;
		}

		return pmoney;
	}

	function clearstring(s) {
		var pstr, sstr, iz;
		sstr	= s;
		pstr	= "";

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
		if(val1=="5" || val1=="6")				HelpWindow('/help/help3.jsp',405,220);
		if(val1=="7")							HelpWindow('/help/help4.jsp',405,220);
		if(val2=="3" || val2=="4")				HelpWindow('/help/help1.jsp',405,220);
	}

	function Cnum(aa) {
		bb	= aa + "";

		while (bb.indexOf(",") != -1)
		{
			bb=bb.replace(",","") ;
		}

		if(isNaN(bb)||bb==''||bb==null)	return 0
		else							return Number(bb);
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
		/*
		main.m2A3.value = 0;
		main.m2B3.value = 0;
		main.m2C3.value = 0;
		main.m2D3.value = 0;
		main.m2E3.value = 0;
		main.m2F3.value = 0;
		main.m2G3.value = 0;
		for(i=1 ; i<3; i++) eval("main.m2A3.value = Cnum(main.m2A3.value) + Cnum(main.m2A"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.m2B3.value = Cnum(main.m2B3.value) + Cnum(main.m2B"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.m2C3.value = Cnum(main.m2C3.value) + Cnum(main.m2C"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.m2D3.value = Cnum(main.m2D3.value) + Cnum(main.m2D"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.m2E3.value = Cnum(main.m2E3.value) + Cnum(main.m2E"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.m2F3.value = Cnum(main.m2F3.value) + Cnum(main.m2F"+i+".value)");
		for(i=1 ; i<3; i++) eval("main.m2G3.value = Cnum(main.m2G3.value) + Cnum(main.m2G"+i+".value)");
		for(i=1 ; i<4; i++) {
			eval("main.m2SubSum"+i+".value = Cnum(main.m2A"+i+".value)+Cnum(main.m2B"+i+".value)+Cnum(main.m2C"+i+".value)+Cnum(main.m2D"+i+".value)+Cnum(main.m2E"+i+".value)+Cnum(main.m2F"+i+".value)+Cnum(main.m2G"+i+".value)");
		}
		*/
	}

	function onDocument() {
		ohapf(document.info);
		sumf(document.info);
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
		url	= "ProdStep_03_Print.jsp";
		w	= 820;
		h	= 600;

		if(confirm("ȭ�� �μ�� ����ǥ ���� �Ŀ� �����մϴ�.\n\n�μ��Ͻðڽ��ϱ�?\n[Ȯ��]�� �����ø� �μ�˴ϴ�.")) {
			HelpWindow2(url, w, h);
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
			<h1 class="contenttitle" align="center"><b>�ϵ��޺о� ��������</b><br>
			(3�� ���ع�� ���� �� �δ�Ư����� ���� ����)</h1>
			<!-- title end -->
			
			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="width:920px;">
				<!--���θ� ��¥ ����-->
					<li class="boxcontenttitle"><font color="#FF0066">�� �������</font></li>
					<li class="boxcontenttitle"><span>�� </span>�����ŷ�����ȸ�� �ϵ��ްŷ����� ��������� �Ұ����� �����κ��� ���޻���ڸ� ��ȣ�ϰ� ���޻������ �Ǹ��� ��ȭ�ϱ� ���� ���ϵ��ްŷ� ����ȭ�� ���� �������� ��3�� ���ع���� ������ Ȯ�� �� ��δ�Ư���� �����ϴ� ������ �����Ͽ����ϴ�.</li>
					<li class="boxcontenttitle"><span>�� </span>�̿� ���� ���Ե� ������ ���޻���ڿ��� ������ ������ �ǰ� �ִ��� ���θ� �ľ��ϰ�,  �ʿ��� ���� ���ϻ����� �����ϱ� ���� �ڷ�� Ȱ���ϱ� ���� �߼ұ���� ������� �� ���縦 �ǽ��ϰ��� �Ͽ���, �ٻڽô��� ���翡 �� ���Ͽ� �ֽñ⸦ ��Ź�帳�ϴ�. </li>
					<!--
					<li class="boxcontenttitle"><span>�� </span>�������� ����� ���������� �ִ� �� ����Ʈ(<a href="http://hado.ftc.go.kr/poll/">http://hado.ftc.go.kr/poll/</a>)�� �����ϼż�, <font color="#FF0066">2014.11.21.(��)</font>���� �Է� �� �����Ͽ� �ֽø� �˴ϴ�.</li>
					-->
					<li class="boxcontenttitle"><font color="#FF0066">�� �������</font></li>
					<li class="boxcontenttitle"><span>�� </span>�� ����� ��������� ����Ǹ�, �ͻ簡 ����ǥ�� ������ ������ ���� ��33���� ���� ����� ����ǰ�, ��� ���� �̿ܿ��� ������ ������ ��ӵ帳�ϴ�.  </li>
					<li class="boxcontenttitle"><span>�� </span>�� ����� �����ŷ�����ȸ�� �߼һ���ڴ�ü(�߼ұ���߾�ȸ �� �����Ǽ���ȸ)�� �������� �ǽ��ϴ� ������ �˷��帳�ϴ�.</li>
					<li class="boxcontenttitle"><span>�� </span>����ǥ�� ���� ���ǻ����� �Ʒ� ����ڿ��� �����ֽñ� �ٶ��ϴ�.</li>
					<li class="boxcontenttitle">- �����ŷ�����ȸ ����ŷ���å�� : �۸��� �繫��  (��ȭ��ȣ : 044-200-4588)</li>
				</ul>
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
					<ul class="lt">
						<li>
							<table class="tbl_blue">
								<colgroup>
									<col style="width:15%;" />
									<col style="width:35%;" />
									<col style="width:15%;" />
									<col style="width:35%;" />
								</colgroup>
								<tbody>
									<tr>
										<th>����</th>
										<td colspan="3">
											<input type="radio" name="oSentType" value="1" <%if(sSentType.equals("1")){out.print("checked");}%>>�� ������ (�Ʒ� ���ξ��� üũ)
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oSentType" value="2" <%if(sSentType.equals("2")){out.print("checked");}%>>�� �Ǽ���<br/>
										</td>
									</tr>
									<tr>
										<th>���ξ���<br/>(������)</th>
										<td colspan="3">
											<input type="radio" name="oDetailCD" value="1" <%if(sDetailCD.equals("1")){out.print("checked");}%>>�� ������������ݼ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="2" <%if(sDetailCD.equals("2")){out.print("checked");}%>>�� ��������ڤ�����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="3" <%if(sDetailCD.equals("3")){out.print("checked");}%>>�� ����ȭ�Ф������ö�ƽ<br/>
											<input type="radio" name="oDetailCD" value="4" <%if(sDetailCD.equals("4")){out.print("checked");}%>>�� �������Ǻ�������&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="5" <%if(sDetailCD.equals("5")){out.print("checked");}%>>�� ��������̤��μ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="6" <%if(sDetailCD.equals("6")){out.print("checked");}%>>�� �ķ�ǰ������<br/>
											<input type="radio" name="oDetailCD" value="7" <%if(sDetailCD.equals("7")){out.print("checked");}%>>�� �ڵ�������������Ÿ ������&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="8" <%if(sDetailCD.equals("8")){out.print("checked");}%>>�� ��ݼ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="9" <%if(sDetailCD.equals("9")){out.print("checked");}%>>�� ö��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oDetailCD" value="10" <%if(sDetailCD.equals("10")){out.print("checked");}%>>�� ��Ÿ
										</td>
									</tr>	
									<tr>
										<th>�����</th>
										<td>
											2013�⵵ <font color="#FF0066"><b>��</b>  <input type="text" name="oSentSale" value="<%=sSentSale%>"  maxlength="6" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"  onkeyup ="sukeyup(this);ohapf(this.form);" style="width:100px;text-align:right;"><b>���</b></font>
										</td>
										<th>�ϵ���<br/>�ŷ��ܰ�</th>
										<td>
											<input type="radio" name="oSubconStep" value="1" <%if(sSubconStep.equals("1")){out.print("checked");}%>>�� 1��&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oSubconStep" value="2" <%if(sSubconStep.equals("2")){out.print("checked");}%>>�� 2��&nbsp;&nbsp;&nbsp;
											<input type="radio" name="oSubconStep" value="3" <%if(sSubconStep.equals("3")){out.print("checked");}%>>�� 3�� ����<br/>
											<input type="radio" name="oSubconStep" value="4" <%if(sSubconStep.equals("4")){out.print("checked");}%>>�� ������ ����� ���
										</td>
									</tr>
								</tbody>
							</table>
						</li>
					</ul>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">  �ͻ簡 ���� ���������� üũ�Ͽ� �ֽʽÿ�. (�ִ� 3������ üũ ����)</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
					<ul class="lt"><input type="hidden" name="c1_22_1" value="<%=setHiddenValue(qa, 22, 1, 12)%>">
						<li>
							<table class="tbl_blue">
								<tr>
									<td><input type="checkbox" name="q1_22_1_1" value="1" <%if(qa[22][1][1]!=null && qa[22][1][1].equals("1")){out.print("checked");}%>>
									�� �ѱ�����������������</td>
									<td><input type="checkbox" name="q1_22_1_2" value="2" <%if(qa[22][1][2]!=null && qa[22][1][2].equals("1")){out.print("checked");}%>>
									�� �ѱ��Ǻ�������������</td>
									<td><input type="checkbox" name="q1_22_1_3" value="3" <%if(qa[22][1][3]!=null && qa[22][1][3].equals("1")){out.print("checked");}%>>
									�� �ѱ������ؾ�����������������</td>
								</tr>
								<tr>
									<td><input type="checkbox" name="q1_22_1_4" value="4" <%if(qa[22][1][5]!=null && qa[22][1][4].equals("1")){out.print("checked");}%>>
									�� �ѱ��ݼӿ�Ÿ��������������</td>
									<td><input type="checkbox" name="q1_22_1_5" value="5" <%if(qa[22][1][5]!=null && qa[22][1][5].equals("1")){out.print("checked");}%>>
									�� �ѱ�����ΰ�����������</td>
									<td><input type="checkbox" name="q1_22_1_6" value="6" <%if(qa[22][1][6]!=null && qa[22][1][6].equals("1")){out.print("checked");}%>>
									�� �ѱ�����ƽ�����������տ���</td>
								</tr>
								<tr>
									<td><input type="checkbox" name="q1_22_1_7" value="7" <%if(qa[22][1][7]!=null && qa[22][1][7].equals("1")){out.print("checked");}%>>
									�� �ѱ����������������</td>
									<td><input type="checkbox" name="q1_22_1_8" value="8" <%if(qa[22][1][8]!=null && qa[22][1][8].equals("1")){out.print("checked");}%>>
									�� �ѱ�����������������</td>
									<td><input type="checkbox" name="q1_22_1_9" value="9" <%if(qa[22][1][9]!=null && qa[22][1][9].equals("1")){out.print("checked");}%>>
									�� �ѱ��ڽ������������</td>
								</tr>
								<tr>
									<td><input type="checkbox" name="q1_22_1_10" value="10" <%if(qa[22][1][10]!=null && qa[22][1][10].equals("1")){out.print("checked");}%>>
									�� �ѱ�����������������</td>
									<td><input type="checkbox" name="q1_22_1_11" value="11" <%if(qa[22][1][11]!=null && qa[22][1][11].equals("1")){out.print("checked");}%>>
									�� �ѱ�ö�ٰ�������������</td>
									<td><input type="checkbox" name="q1_22_1_12" value="12" <%if(qa[22][1][12]!=null && qa[22][1][12].equals("1")){out.print("checked");}%>>
									�� ���������Ǽ���ȸ</td>
								</tr>
							</table>
						</li>
					</ul>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">��.������ ���� ������</a></li>
						</ul>
					</li>
				</ul>
			</div>
			
			<div class="fc pt_10"></div>
			
			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b>�� <font color="#FF0066">1�� �� 2�� ����</font>�� �ֱ�<font color="#FF0066">���ϵ��ްŷ� ����ȭ�� ���� ������</font>�� ���Ե� ��<font color="#FF0066">3�� ���ع���� ������ Ȯ��</font>, ��<font color="#FF0066">�δ�Ư�� ���� ����</font>�� ���� <font color="#FF0066">�ͻ��� ������</font>�� �ľ��ϱ� ���� �����Դϴ�.</b></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>1. </span>�ͻ�� �ϵ��ްŷ����� ���� ���� �Ұ����� ������ �����ϰ� �߼ұ���� �Ǹ��� ��ȭ�ϱ� ���� <font color="#FF0066">3�� ���ع�������� ������</font>�� �߼ұ���� ���ظ� ũ�� ������ �Ұ��������� <font color="#FF0066">�δ��� �ϵ��޴�� ���������� ����, �δ���Ź���, �δ��ǰ</font>���� <font color="#FF0066">Ȯ��� ���</font>�� �˰� ��ʴϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_1_1" value="<%=setHiddenValue(qa, 1, 1, 5)%>">
						<li><input type="radio" name="q1_1_1" value="1" <%if(qa[1][1][1]!=null && qa[1][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);">�� �� �˰� �ִ�</li>
						<li><input type="radio" name="q1_1_1" value="2" <%if(qa[1][1][2]!=null && qa[1][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);">�� ��ü�� �˰� �ִ�</li>
						<li><input type="radio" name="q1_1_1" value="3" <%if(qa[1][1][3]!=null && qa[1][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);">�� �ణ �˰� �ִ�</li>
						<li><input type="radio" name="q1_1_1" value="4" <%if(qa[1][1][4]!=null && qa[1][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);">�� �� �𸥴�</li>
						<li><input type="radio" name="q1_1_1" value="5" <%if(qa[1][1][5]!=null && qa[1][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(1,1);">�� ���� �𸥴�</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>2. </span>�ͻ�� �ϵ��ްŷ����� ����(Ư��)�� ������� ���� ���� �δ��ؾ� �� ���� ����� �߼ұ������ �����ϴ� ������ �����ϱ� ���� <font color="#FF0066">������ڰ� ���޻������ ������ �δ��ϰ� ħ���ϰų� �����ϴ� ��������� �����ϴ� ����</font>�� <font color="#FF0066">������ ���</font>�� �˰� ��ʴϱ�?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_2_1" value="<%=setHiddenValue(qa, 2, 1, 5)%>">
						<li><input type="radio" name="q1_2_1" value="1" <%if(qa[2][1][1]!=null && qa[2][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);">�� �� �˰� �ִ�</li>
						<li><input type="radio" name="q1_2_1" value="2" <%if(qa[2][1][2]!=null && qa[2][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);">�� ��ü�� �˰� �ִ�</li>
						<li><input type="radio" name="q1_2_1" value="3" <%if(qa[2][1][3]!=null && qa[2][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);">�� �ణ �˰� �ִ�</li>
						<li><input type="radio" name="q1_2_1" value="4" <%if(qa[2][1][4]!=null && qa[2][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);">�� �� �𸥴�</li>
						<li><input type="radio" name="q1_2_1" value="5" <%if(qa[2][1][5]!=null && qa[2][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(2,1);">�� ���� �𸥴�</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">��.3�� ���ع���� ������ Ȯ�� (2013.11.29. ����)</a></li>
						</ul>
					</li>
				</ul>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="width:920px;">
					<li class="boxcontenttitle">���� ���� �Ұ����� ������ �����ϰ� ���ظ� ���� �߼ұ���� �Ǹ��� ��ȭ�ϱ� ���Ͽ� 3�� ���ع���� ��������'<font color="#FF0066">�����������</font>���� <font color="#FF0066">�δ��� �ϵ��޴�ݰ���������, �δ���Ź ��� �� �δ��ǰ</font>'���� Ȯ���Ͽ����ϴ�. ���� ���� �� �Ұ��������� �� ��� �������, ��¡��, ���� ���� �ΰ��� �Ӹ� �ƴ϶�, ���ظ� ���� �߼ұ���� ������ ���ع�� û���� �Ͽ� ���ؾ��� 3����� ����� ���� �� �ְ� �Ǿ����ϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b>�� <font color="#FF0066">3�� ���׺��� 14�� ����</font>������ 3�� ���ع�������� <font color="#FF0066">Ȯ�� ����Ǳ� �� �Ⱓ</font>�� <font color="#FF0066">Ȯ�� ����� ���� �Ⱓ ���� �ͻ��� �Ұ������� ���� ���� �� �ŷ����� ��������</font>�� �ľ��ϱ� ���� �����Դϴ�.</b></li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><font color="#FF0066">(�δ��� �ϵ��޴�� ���������� ����)</font></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>3. </span>3�� ���ع�������� <font color="#FF0066">Ȯ�� ����Ǳ� ��</font> 10������(2013.1.1.~2013.10.31.) <font color="#FF0066">������ڰ�</font> �ͻ�� ��ȣ ���� ���� <font color="#FF0066">�δ��ϰ� �ϵ��޴���� ����</font>�ϰų�, ������ ������ �������� <font color="#FF0066">��Ź�� ���� �� ���ߴ� �ݾ׺��� ���� �ϵ��޴���� ������ ���</font>�� �־����ϱ� ?</li>
						<li class="boxcontentsubtitle"></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_3_1" value="<%=setHiddenValue(qa, 3, 1, 2)%>">
						<li><input type="radio" name="q1_3_1" value="1" <%if(qa[3][1][1]!=null && qa[3][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);">�� ������</li>
						<li><input type="radio" name="q1_3_1" value="2" <%if(qa[3][1][2]!=null && qa[3][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(3,1);">�� �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>	

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>4. </span>3�� ���ع�������� <font color="#FF0066">Ȯ�� ����� ����</font> 10������(2014.1.1.~2014.10.31.) <font color="#FF0066">������ڰ�</font> �ͻ�� ��ȣ ���� ���� <font color="#FF0066">�δ��ϰ� �ϵ��޴���� ����</font>�ϰų�, ������ ������ �������� <font color="#FF0066">��Ź�� ���� �� ���ߴ� �ݾ׺��� ���� �ϵ��޴���� ������ ���</font>�� �־����ϱ� ?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_4_1" value="<%=setHiddenValue(qa, 4, 1, 2)%>">
						<li><input type="radio" name="q1_4_1" value="1" <%if(qa[4][1][1]!=null && qa[4][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);">�� ������</li>
						<li><input type="radio" name="q1_4_1" value="2" <%if(qa[4][1][2]!=null && qa[4][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(4,1);">�� �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>5. </span><font color="#FF0066">3�� ���ع�������� ���������� Ȯ�� ����� 2014.1.1. ����</font>, 1�� ���� ���Ͽ�, �ͻ��  <font color="#FF0066">��������� �δ��� �ϵ��޴�� ���������� ����</font>�� <font color="#FF0066">��� ���� ����</font>�Ǿ��ٰ� �����Ͻʴϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_5_1" value="<%=setHiddenValue(qa, 5, 1, 5)%>">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_5_1" value="1" <%if(qa[5][1][1]!=null && qa[5][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(5,1);">5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_5_1" value="2" <%if(qa[5][1][2]!=null && qa[5][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(5,2);">4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_5_1" value="3" <%if(qa[5][1][3]!=null && qa[5][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(5,3);">3��
						&nbsp;&nbsp; ����&nbsp;&nbsp;<input type="radio" name="q1_5_1" value="4" <%if(qa[5][1][4]!=null && qa[5][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(5,4);">2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_5_1" value="5" <%if(qa[5][1][5]!=null && qa[5][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(5,5);">1��&nbsp;&nbsp; ������</li>
						<li>�ſ� ������ �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �ѡ����� �������� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><font color="#FF0066">(�δ��� ��Ź��� ����)</font></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>6. </span>3�� ���ع�������� <font color="#FF0066">Ȯ�� ����Ǳ� ��</font> 10������(2013.1.1.~2013.10.31.) �ͻ��� ��å������ �������� �ұ��ϰ� <font color="#FF0066">������ڰ� �ϵ��� ����� �Ϲ������� ����� ���</font>�� �־����ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_6_1" value="<%=setHiddenValue(qa, 6, 1, 2)%>">
						<li><input type="radio" name="q1_6_1" value="1" <%if(qa[6][1][1]!=null && qa[6][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(6,1);">�� ������</li>
						<li><input type="radio" name="q1_6_1" value="2" <%if(qa[6][1][2]!=null && qa[6][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(6,1);">�� �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>7. </span>3�� ���ع�������� <font color="#FF0066">Ȯ�� ����� ����</font> 10������(2014.1.1.~2014.10.31.) �ͻ��� ��å������ �������� �ұ��ϰ� <font color="#FF0066">������ڰ� �ϵ��� ����� �Ϲ������� ����� ���</font>�� �־����ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_7_1" value="<%=setHiddenValue(qa, 7, 1, 2)%>">
						<li><input type="radio" name="q1_7_1" value="1" <%if(qa[7][1][1]!=null && qa[7][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);">�� ������</li>
						<li><input type="radio" name="q1_7_1" value="2" <%if(qa[7][1][2]!=null && qa[7][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(7,1);">�� �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>8. </span><font color="#FF0066">3�� ���ع�������� ���������� Ȯ�� ����� 2014.1.1. ����</font>, 1�� ���� ���Ͽ�, <font color="#FF0066">�ͻ��  ��������� �δ��� ��Ź��� ����</font>�� <font color="#FF0066">��� ���� ����</font>�Ǿ��ٰ� �����Ͻʴϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_8_1" value="1" <%if(qa[8][1][1]!=null && qa[8][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(8,1);">5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_8_1" value="2" <%if(qa[8][1][2]!=null && qa[8][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(8,2);">4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_8_1" value="3" <%if(qa[8][1][3]!=null && qa[8][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(8,3);">3��
						&nbsp;&nbsp; ����&nbsp;&nbsp;<input type="radio" name="q1_8_1" value="4" <%if(qa[8][1][4]!=null && qa[8][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(8,4);">2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_8_1" value="5" <%if(qa[8][1][5]!=null && qa[8][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(8,5);">1��&nbsp;&nbsp; ������</li>
						<li>�ſ� ������ �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �ѡ����� �������� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><font color="#FF0066">(�δ��ǰ ����)</font></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>9. </span>3�� ���ع�������� <font color="#FF0066">Ȯ�� ����Ǳ� ��</font> 10������(2013.1.1.~2013.10.31.) �ͻ��� ��å������ �������� �ұ��ϰ� <font color="#FF0066">������ڰ� �������� ��ǰ ���� ���� �� ��ǰ�� ���</font>�� �־����ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_9_1" value="<%=setHiddenValue(qa, 9, 1, 2)%>">
						<li><input type="radio" name="q1_9_1" value="1" <%if(qa[9][1][1]!=null && qa[9][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);">�� ������</li>
						<li><input type="radio" name="q1_9_1" value="2" <%if(qa[9][1][2]!=null && qa[9][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(9,1);">�� �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>	

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>10. </span>3�� ���ع�������� <font color="#FF0066">Ȯ�� ����� ����</font> 10������(2014.1.1.~2014.10.31.) �ͻ��� ��å������ �������� �ұ��ϰ� <font color="#FF0066">������ڰ� �������� ��ǰ ���� ���� �� ��ǰ�� ���</font>�� �־����ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_10_1" value="<%=setHiddenValue(qa, 10, 1, 2)%>">
						<li><input type="radio" name="q1_10_1" value="1" <%if(qa[10][1][1]!=null && qa[10][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);">�� ������</li>
						<li><input type="radio" name="q1_10_1" value="2" <%if(qa[10][1][2]!=null && qa[10][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(10,1);">�� �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>11. </span><font color="#FF0066">3�� ���ع�������� ���������� Ȯ�� ����� 2014.1.1. ����</font>, 1�� ���� ���Ͽ�, �ͻ�� <font color="#FF0066">��������� �δ��ǰ ����</font>�� <font color="#FF0066">��� ���� ����</font>�Ǿ��ٰ� �����Ͻʴϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_11_1" value="1" <%if(qa[11][1][1]!=null && qa[11][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(11,1);">5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_11_1" value="2" <%if(qa[11][1][2]!=null && qa[11][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(11,2);">4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_11_1" value="3" <%if(qa[11][1][3]!=null && qa[11][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(11,3);">3��
						&nbsp;&nbsp; ����&nbsp;&nbsp;<input type="radio" name="q1_11_1" value="4" <%if(qa[11][1][4]!=null && qa[11][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(11,4);">2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_11_1" value="5" <%if(qa[11][1][5]!=null && qa[11][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(11,5);">1��&nbsp;&nbsp; ������</li>
						<li>�ſ� ������ �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �ѡ����� �������� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>
			
			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><font color="#FF0066">(������� ����)</font></li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>12. </span>3�� ���ع�������� <font color="#FF0066">Ȯ�� ����Ǳ� ��</font> 10������(2013.1.1.~2013.10.31.) <font color="#FF0066">������ڰ� �ͻ�κ��� ����� ����ڷḦ</font> ������� �Ǵ� ��3���� ������ ���� <font color="#FF0066">��������ν� �ͻ翡�� ���ذ� �߻��� ����</font>�� �־����ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_12_1" value="<%=setHiddenValue(qa, 12, 1, 2)%>">
						<li><input type="radio" name="q1_12_1" value="1" <%if(qa[12][1][1]!=null && qa[12][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);">�� ������</li>
						<li><input type="radio" name="q1_12_1" value="2" <%if(qa[12][1][2]!=null && qa[12][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(12,1);">�� �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>13. </span>3�� ���ع�������� <font color="#FF0066">Ȯ�� ����� ����</font> 10������(2014.1.1.~2014.10.31.) <font color="#FF0066">������ڰ� �ͻ�κ��� ����� ����ڷḦ</font> ������� �Ǵ� ��3���� ������ ���� <font color="#FF0066">��������ν� �ͻ翡�� ���ذ� �߻��� ����</font>�� �־����ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_13_1" value="<%=setHiddenValue(qa, 13, 1, 2)%>">
						<li><input type="radio" name="q1_13_1" value="1" <%if(qa[13][1][1]!=null && qa[13][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);">�� ������</li>
						<li><input type="radio" name="q1_13_1" value="2" <%if(qa[13][1][2]!=null && qa[13][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(13,1);">�� �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>14. </span><font color="#FF0066">3�� ���ع�������� ���������� Ȯ�� ����� 2014.1.1. ����</font>, 1�� ���� ���Ͽ�, �ͻ�� <font color="#FF0066">��������� ������� ����</font>�� <font color="#FF0066">��� ���� ����</font>�Ǿ��ٰ� �����Ͻʴϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_14_1" value="1" <%if(qa[14][1][1]!=null && qa[14][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(14,1);">5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_14_1" value="2" <%if(qa[14][1][2]!=null && qa[14][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(14,2);">4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_14_1" value="3" <%if(qa[14][1][3]!=null && qa[14][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(14,3);">3��
						&nbsp;&nbsp; ����&nbsp;&nbsp;<input type="radio" name="q1_14_1" value="4" <%if(qa[14][1][4]!=null && qa[14][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(14,4);">2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_14_1" value="5" <%if(qa[14][1][5]!=null && qa[14][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(14,5);">1��&nbsp;&nbsp; ������</li>
						<li>�ſ� ������ �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �ѡ����� �������� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">��. �δ�Ư�� ���� ���� (2014.2.14. ����)</a></li>
						</ul>
					</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="width:920px;">
					<li class="boxcontenttitle">����(Ư��)�� ������� ���� ���� �δ��ؾ� �� ���� ���(��:�ο�ó�� ��� ��)�� �߼ұ������ �����ϴ� ������ �����ϱ� ���� �ϵ��ް�࿡�� �δ��� Ư���� ������ �����Ͽ����ϴ�. ���� ���� �δ�Ư���� ������ ��� Ư�������� ���������� �� �������, ��¡��, ���� ���� �ΰ��˴ϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b>�� <font color="#FF0066">15�� ���׺��� 17�� ����</font>������ <font color="#FF0066">�δ�Ư���� �����ϴ� ����</font>�� <font color="#FF0066">����Ǳ� �� �Ⱓ</font>�� <font color="#FF0066">Ȯ�� ����� ���� �Ⱓ ���� �ͻ��� �Ұ������� ���� ���� �� �ŷ����� ��������</font>�� �ľ��ϱ� ���� �����Դϴ�.</b></li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>15. </span>�δ��� Ư���� �����ϴ� ������ <font color="#FF0066">����Ǳ� ��</font> �� 8���� �Ⱓ ���� (2013.2.14.~2013.10.31.) �ͻ簡 ������ڿ� ü���� �ϵ��ް�࿡ <font color="#FF0066">������ڰ� �ͻ��� ������ �δ��ϰ� ħ���ϰų� �����ϴ� ��������� ������ ���</font>�� �־����ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_15_1" value="<%=setHiddenValue(qa, 15, 1, 2)%>">
						<li><input type="radio" name="q1_15_1" value="1" <%if(qa[15][1][1]!=null && qa[15][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);">�� ������</li>
						<li><input type="radio" name="q1_15_1" value="2" <%if(qa[15][1][2]!=null && qa[15][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(15,1);">�� �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>16. </span>�δ��� Ư���� �����ϴ� ������ <font color="#FF0066">����� ����</font> �� 8���� �Ⱓ ���� (2014.2.14.~2014.10.31.) �ͻ簡 ������ڿ� ü���� �ϵ��ް�࿡ <font color="#FF0066">������ڰ� �ͻ��� ������ �δ��ϰ� ħ���ϰų� �����ϴ� ��������� ������ ���</font>�� �־����ϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_16_1" value="<%=setHiddenValue(qa, 16, 1, 2)%>">
						<li><input type="radio" name="q1_16_1" value="1" <%if(qa[16][1][1]!=null && qa[16][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);">�� ������</li>
						<li><input type="radio" name="q1_16_1" value="2" <%if(qa[16][1][2]!=null && qa[16][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(16,1);">�� �־���</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>17. </span><font color="#FF0066">�δ��� Ư���� �����ϴ� ������ ����� 2014.2.14. ����</font>, 1�� ���� ���Ͽ�, �ͻ�� <font color="#FF0066">������ڰ� �δ��� Ư���� �����ϴ� �Ұ�������</font>�� <font color="#FF0066">������� ����</font>�Ǿ��ٰ� �����Ͻʴϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="1" <%if(qa[17][1][1]!=null && qa[17][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(17,1);">5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="2" <%if(qa[17][1][2]!=null && qa[17][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(17,2);">4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="3" <%if(qa[17][1][3]!=null && qa[17][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(17,3);">3��
						&nbsp;&nbsp; ����&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="4" <%if(qa[17][1][4]!=null && qa[17][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(17,4);">2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_17_1" value="5" <%if(qa[17][1][5]!=null && qa[17][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(17,5);">1��&nbsp;&nbsp; ������</li>
						<li>�ſ� ������ �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �ѡ����� �������� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">��. �ϵ��޴�� ���޽��� ����</a></li>
						</ul>
					</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent2">
				<ul class="boxcontenthelp clt" style="width:920px;">
					<li class="boxcontenttitle">�����ŷ�����ȸ�� �ų� ����������� ���� ���� �ϵ��޴�� ���޽��¸� �����ϰ� ������, Ư�� 2014.7�� ���Ŀ��� ���ݰ��� ���� ���ؼ�, �������η� ������, �ϵ��޴�� �������� �� �ϵ��޴�� ���� �������縦 ���������� �ǽ��ϰ� �ֽ��ϴ�. 1�� ��������� �Ǽ������� ������� 7~8���� �ǽ��Ͽ���, 2�� ��������� ���� �� �뿪������ ������� 11���� �ǽ� ���̸�, 12������ �� ������ ������� 3�� �������縦 �ǽ��� �����Դϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><b>�� <font color="#FF0066">18�� �� 19�� ����</font>�� �ϵ��޴�� ���޽��� ���� �������縦 ���������� ������ ���� <font color="#FF0066">�ŷ����� �������� �� ���� ȿ�� ����</font>�� �ľ��ϱ� ���� �����Դϴ�.</b></li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>18. </span>�������� <font color="#FF0066">�ϵ��޴�� ���޽��¿� ���� �������縦 ���������� ������ 2014.7�� ����,</font> 1�� ���� ���Ͽ�, �ͻ�� <font color="#FF0066">���ݰ��� ���� ���ؼ�, �������η� ������, �ϵ��޴�� �������� �� ��������� ������� ���� �Ұ�������</font>�� <font color="#FF0066">��� ���� ����</font>�Ǿ��ٰ� �����Ͻʴϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt">
						<li class="boxcontenttitle">������&nbsp;&nbsp;<input type="radio" name="q1_18_1" value="1" <%if(qa[18][1][1]!=null && qa[18][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(18,1);">5��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_18_1" value="2" <%if(qa[18][1][2]!=null && qa[18][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(18,2);">4��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_18_1" value="3" <%if(qa[18][1][3]!=null && qa[18][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(18,3);">3��
						&nbsp;&nbsp; ����&nbsp;&nbsp;<input type="radio" name="q1_18_1" value="4" <%if(qa[18][1][4]!=null && qa[18][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(18,4);">2��
						&nbsp;&nbsp;����&nbsp;&nbsp;<input type="radio" name="q1_18_1" value="5" <%if(qa[18][1][5]!=null && qa[18][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(18,5);">1��&nbsp;&nbsp; ������</li>
						<li>�ſ� ������ �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �ѡ����� �������� ����</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="elt">
						<li class="boxcontenttitle"><span>19. </span>�ͻ�� ���Ͱ��� <font color="#FF0066">�������� �ϵ��޴�� ���� ���� ��������</font>�� <font color="#FF0066">�ϵ��޴�� ���� ���� �Ұ��� ������ ����</font>�ϴµ� <font color="#FF0066">��� ���� ������ �ǰų� ȿ���� ���� ��</font>�̶�� �����Ͻʴϱ�?</li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><input type="hidden" name="c1_19_1" value="<%=setHiddenValue(qa, 19, 1, 5)%>">
						<li><input type="radio" name="q1_19_1" value="1" <%if(qa[19][1][1]!=null && qa[19][1][1].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">�� ���� ȿ���� ���� ���̴�</li>
						<li><input type="radio" name="q1_19_1" value="2" <%if(qa[19][1][2]!=null && qa[19][1][2].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">�� ��ü�� ȿ���� ���� ���̴�</li>
						<li><input type="radio" name="q1_19_1" value="3" <%if(qa[19][1][3]!=null && qa[19][1][3].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">�� �ణ ȿ���� ���� ���̴�</li>
						<li><input type="radio" name="q1_19_1" value="4" <%if(qa[19][1][4]!=null && qa[19][1][4].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">�� ���� ȿ���� ���� ���̴�</li>
						<li><input type="radio" name="q1_19_1" value="5" <%if(qa[19][1][5]!=null && qa[19][1][5].equals("1")){out.print("checked");}%> onclick="checkradio(19,1);">�� ���� ȿ���� ���� ���̴�</li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle">
						<ul class="lt">
							<li class="fl pr_2"><a href="#"  class="contentbutton2">��. ��Ÿ</a></li>
						</ul>
					</li>
				</ul>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><span>20. </span>�ͻ簡 ��5(�δ��� �ϵ��޴�� ����������), ��8(�δ��� ��Ź���) ��11(�δ��ǰ), ��14(�������), ��17��(�δ�Ư��) �Ǵ� ��18��(�ϵ��޴�� ���޽���)�� �����Ͽ� <font color="#FF0066">�ŷ����� ���������� ���� 1�� �Ǵ� 2���̶�� ������ ��� �ŷ������� �������� �ʴ� �ֿ� ������ ����</font>�̶�� �����ϴ��� �����ϰ� �����Ͽ� �ֽñ� �ٶ��ϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontentsubtitle"><p align="right" id="content_bytes20">0/4000byte</p></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><textarea cols="80" rows="8" maxlength="600" name="q1_20_1" class="textarea01b" maxlength="600" onFocus="javascript:this.className='textarea01o';" onBlur="javascript:this.className='textarea01b';" onkeyup="byteLengCheck(this, 4000, this.name,'content_bytes20');"><%=qa[20][1][20]%></textarea></li>
					</ul>
				</div>
				<div class="fc"></div>
			</div>

			<div class="fc pt_10"></div>

			<div class="boxcontent3">
				<ul class="boxcontenthelp2 lt">
					<li class="noneboxcontenttitle"><span>21. </span>�ͻ簡 ������ �ϵ��ްŷ� ���� ������ ���� �ʿ��ϴٰ� �����Ͻô� <font color="#FF0066">���ǻ���</font> �Ǵ� <font color="#FF0066">������ڿ� �ϵ��ްŷ��� �ϸ鼭 ������ �Ұ�������</font> ���� �����Ӱ� �����Ͽ� �ֽñ� �ٶ��ϴ�.</li>
				</ul>
			</div>

			<div class="fc pt_2"></div>

			<div class="boxcontent">
				<div class="boxcontentleft">
					<ul class="lt">
						<li class="boxcontentsubtitle"><p align="right" id="content_bytes21">0/4000byte</p></li>
					</ul>
				</div>
				<div class="boxcontentright">
					<ul class="lt"><textarea cols="80" rows="8" maxlength="600" name="q1_21_1" class="textarea01b" maxlength="600" onFocus="javascript:this.className='textarea01o';" onBlur="javascript:this.className='textarea01b';" onkeyup="byteLengCheck(this, 4000, this.name,'content_bytes21');"><%=qa[21][1][20]%></textarea></li>
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
			<!--
			<div class="fr">
				<ul class="lt">
					<li class="fl pr_2"><a href="#" onclick="savef(); return false;" onfocus="this.blur()" class="contentbutton2">�� ��</a></li>
				</ul>
			</div>
			-->

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