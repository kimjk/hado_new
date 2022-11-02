<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��	: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���	: SOent_View.jsp
* ���α׷�����	: ���޻���� > �������ü > ���޻���� ������ ��ȸ
* ���α׷�����	: 1.0.1
* �����ۼ�����	: 2014�� 09�� 24��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-09-24	������       �����ۼ�
*  	2015-07-22    ������	 �������ܴ�� ó����� ���� ���� (SP_FLD_03 �ʵ忡 ���ܻ���)
*	2016-01-19	������	DB�������� ���� ���ڵ� ����
*/
%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>
<%@ page import="java.text.DecimalFormat"%>
<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String sMngNo	= StringUtil.checkNull(request.getParameter("no")).trim();
	String sCYear	= StringUtil.checkNull(request.getParameter("yyyy")).trim();
	String sOentGB	= StringUtil.checkNull(request.getParameter("gb")).trim();
	String sSentNo	= StringUtil.checkNull(request.getParameter("sno")).trim();
	String sLoc		= StringUtil.checkNull(request.getParameter("loc")).trim();
	String sMsg		= StringUtil.checkNull(request.getParameter("msg")).trim();

	String omngno	= "";
	String oname	= "";
	String smngno	= "";
	String sname	= "";
	String scaptine = "";
	String samt		= "";
	String zipcode	= "";
	String zipcode1 = "";
	String zipcode2 = "";
	String address	= "";
	String stel		= "";
	String sfax		= "";
	String semail	= "";
	String semail1	= "";
	String semail2	= "";
	String scompgb	= "";
	String scono	= "";
	String ssano	= "";
	String ssale	= "";
	String sempcnt	= "";
	String wname	= "";
	String worg		= "";
	String wjikwi	= "";
	String wtel		= "";
	String wfax		= "";
	String ssubcontype = "";
	String returngb = "";
	String resend	= "";
	String astatus	= "";
	String selgb	= "";
	String sstatus	= "";
	String wdate	= "";
	String sdontlogin = "";

	// �������ܴ��
	String sspfld03 = "";

	// �ش� �繫�� ����
	String sDCenterName	= "";
	String sDDeptName	= "";
	String sDUserName	= "";
	String sDCVSNo		= "";
	String sDPhoneNo	= "";

	String sRrchFolder	= "";
	String reason		= "";
	String sSQLs		= "";

	ConnectionResource resource	= null;
	Connection conn				= null;
	PreparedStatement pstmt		= null;
	ResultSet rs				= null;

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	if( ( sMngNo != null && sCYear != null && sOentGB != null && sSentNo != null ) && (!sMngNo.equals("")) && (!sCYear.equals("")) && (!sOentGB.equals("")) && (!sSentNo.equals("")) ) {

		// �⵵�� �������� ����
		if( sCYear.equals("2009") )		 { sRrchFolder = "/hado/hado/Research"; }
		else if( sCYear.equals("2010") ) { sRrchFolder = "/hado/hado/rsch0420"; }
		else if( sCYear.equals("2011") ) { sRrchFolder = "/hado/hado/rsch0614"; }
		else if( sCYear.equals("2012") ) { sRrchFolder = "/hado/hado/rsch0607"; }
		else if( sCYear.equals("2013") ) { sRrchFolder = "/hado/hado/rsch0923"; }
		else if( sCYear.equals("2014") ) { sRrchFolder = "/hado/hado/rsch141114"; }
		else if( sCYear.equals("2015") ) { sRrchFolder = "/hado/hado/rsch150706"; }
		else if( sCYear.equals("2016") ) { sRrchFolder = "/hado/hado/rsch160715"; }
		else if( sCYear.equals("2017") ) { sRrchFolder = "/hado/hado/rsch170731"; }
		else if( sCYear.equals("2018") ) { sRrchFolder = "/hado/hado/rsch180725"; }
		else if( sCYear.equals("2019") ) { sRrchFolder = "/hado/hado/rsch190722"; }
		else if( sCYear.equals("2020") ) { sRrchFolder = "/hado/hado/rsch200801"; }
		else if( sCYear.equals("2021") ) { sRrchFolder = "/hado/hado/rsch210909"; }
		else							 { sRrchFolder= ""; }

		// ���޻���� ���� �˻�
		/*StringBuffer sbSQLs = new StringBuffer();
		sbSQLs.append("SELECT * \n");
		sbSQLs.append("FROM HADO_VT_SOent_"+sCYear+" \n");
		sbSQLs.append("WHERE Mng_No = ? \n");
		sbSQLs.append("    AND Current_Year = ? \n");
		sbSQLs.append("    AND Oent_GB = ? \n");
		sbSQLs.append("    AND Sent_No = ? \n");*/

		sSQLs="SELECT * FROM HADO_VT_SOent_"+sCYear+" \n";
		
		if(sMngNo.substring(0,2).equals("HE")) {
			sSQLs+="WHERE Mng_No='"+sMngNo.substring(0,6)+"' \n";
		}
		else {
		    if( Integer.parseInt(sCYear) > 2020 ) {
				sSQLs+="WHERE child_Mng_No='"+sMngNo+"' \n";
			} else if( Integer.parseInt(sCYear) >= 2012 &&  Integer.parseInt(sCYear) <= 2020) {
				sSQLs+="WHERE Mng_No='"+sMngNo.substring(0,8)+"' \n";
			} else if( Integer.parseInt(sCYear) > 2010 ) {
				sSQLs+="WHERE Mng_No='"+sMngNo.substring(0,9)+"' \n";
			} else {
				sSQLs+="WHERE Mng_No='"+sMngNo.substring(0,10)+"' \n";
			}
		}
		sSQLs+="	AND Current_Year='"+sCYear+"' \n";
		sSQLs+="	AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="	AND Sent_No="+ sSentNo+" \n";
    
		try {
			resource	= new ConnectionResource();
			conn		= resource.getConnection();
			pstmt		= conn.prepareStatement(sSQLs);
			/*
			pstmt		= conn.prepareStatement(sbSQLs.toString());
			if(sCYear.equals("2012")||sCYear.equals("2013")) {
				pstmt.setString(1,sMngNo.substring(0,8));
			} else if(sCYear.equals("2011")) {
				pstmt.setString(1,sMngNo.substring(0,9));
			} else {
				pstmt.setString(1,sMngNo.substring(0,10));
			}
			pstmt.setString(2,sCYear);
			pstmt.setString(3,sOentGB);
			pstmt.setInt(4,Integer.valueOf(sSentNo).intValue() );
			//pstmt.setInt(4,Integer.parseInt(sSentNo));
			rs			= pstmt.executeQuery();
			*/
			rs			= pstmt.executeQuery();
			while(rs.next()) {
				omngno	= StringUtil.checkNull(rs.getString("Mng_No"));
				oname	= StringUtil.checkNull(rs.getString("oent_Name"));
				smngno	= StringUtil.checkNull(rs.getString("Child_Mng_No"));
				sname	= StringUtil.checkNull(rs.getString("Sent_Name"));
				scaptine = StringUtil.checkNull(rs.getString("Sent_Captine"));
				samt	= StringUtil.checkNull(rs.getString("Sent_Amt"));
				zipcode = StringUtil.checkNull(rs.getString("Zip_Code"));
				/*if ( zipcode.length() == 7 ) {
					zipcode1 	= zipcode.substring(0, 3);
					zipcode2 	= zipcode.substring(4, 7);
				} else if ( zipcode.length() == 6 ) {
					zipcode1 	= zipcode.substring(0, 3);
					zipcode2 	= zipcode.substring(3, 6);
				}*/
				address	= StringUtil.checkNull(rs.getString("Sent_Address"));
				stel	= StringUtil.checkNull(rs.getString("Sent_Tel"));
				sfax	= StringUtil.checkNull(rs.getString("Sent_Fax"));
				semail	= StringUtil.checkNull(rs.getString("Assign_Mail"));
				if ( (semail != null) && (!semail.equals("")) ) {
					if ( semail.indexOf("@") != -1 ) {
						semail1	= semail.substring(0, semail.indexOf("@"));
						semail2	= semail.substring(semail.indexOf("@") + 1, semail.length());
					}
				}
				scompgb = StringUtil.checkNull(rs.getString("Comp_GB"));
				scono	= StringUtil.checkNull(rs.getString("Sent_Co_No"));
				ssano	= StringUtil.checkNull(rs.getString("Sent_Sa_No"));
				ssale	= StringUtil.checkNull(rs.getString("Sent_Sale"));
				sempcnt = StringUtil.checkNull(rs.getString("Sent_Emp_Cnt"));
				wname	= StringUtil.checkNull(rs.getString("Writer_Name"));
				worg	= StringUtil.checkNull(rs.getString("Writer_ORG"));
				wjikwi	= StringUtil.checkNull(rs.getString("Writer_Jikwi"));
				wtel	= StringUtil.checkNull(rs.getString("Writer_Tel"));
				wfax	= StringUtil.checkNull(rs.getString("Writer_Fax"));
				wdate	= StringUtil.checkNull(rs.getString("Writer_Date"));
				ssubcontype = StringUtil.checkNull(rs.getString("Subcon_Type"));
				returngb = StringUtil.checkNull(rs.getString("Return_GB"));
				resend	= StringUtil.checkNull(rs.getString("Resend_GB"));
				astatus = StringUtil.checkNull(rs.getString("Addr_Status"));
				selgb	= StringUtil.checkNull(rs.getString("Sel_GB"));
				sstatus = StringUtil.checkNull(rs.getString("Sent_Status"));
				sspfld03 = StringUtil.checkNull(rs.getString("sp_fld_03"));
				sdontlogin = StringUtil.checkNull(rs.getString("Dont_Login"));
				sDCVSNo = StringUtil.checkNull(rs.getString("CVSNO")).trim();
				sDCenterName = StringUtil.checkNull(rs.getString("Center_Name")).trim();
				sDDeptName	= StringUtil.checkNull(rs.getString("Dept_Name")).trim();
				sDUserName	= StringUtil.checkNull(rs.getString("User_Name")).trim();
				sDPhoneNo	= StringUtil.checkNull(rs.getString("Phone_No")).trim();
			}
			rs.close();
		} catch(Exception e) {
				e.printStackTrace();
		} finally {
				if ( rs != null )	try{rs.close();}	catch(Exception e){}
				if ( pstmt != null )try{pstmt.close();}	catch(Exception e){}
				if ( conn != null ) try{conn.close();}	catch(Exception e){}
				if ( resource != null ) resource.release();
		}

		// �������ܴ�� ���� �˻�
		sSQLs="SELECT REPLACE(REPLACE(SUBJ_ANS, CHR(10), ''), CHR(13), '') SUBJ_ANS FROM HADO_TB_SOENT_ANSWER_"+sCYear+" \n";
		sSQLs+="WHERE MNG_NO='"+sMngNo+"' \n";
		sSQLs+="AND CURRENT_YEAR='"+sCYear+"' \n";
		sSQLs+="AND OENT_GB='"+sOentGB+"' \n";
		sSQLs+="AND SENT_NO="+sSentNo+" \n";
		sSQLs+="AND SOENT_Q_CD=30 AND SOENT_Q_GB=1 \n";

		try {
			resource	= new ConnectionResource();
			conn		= resource.getConnection();
			pstmt		= conn.prepareStatement(sSQLs);
			rs			= pstmt.executeQuery();
			while (rs.next()) {
				reason = StringUtil.checkNull(rs.getString("SUBJ_ANS")).trim();
			}
			rs.close();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if ( rs != null )	try{rs.close();}	catch(Exception e){}
			if ( pstmt != null )try{pstmt.close();}	catch(Exception e){}
			if ( conn != null ) try{conn.close();}	catch(Exception e){}
			if ( resource != null ) resource.release();
		}
		
		// ����ǥ ��ȸ�� ���� �������� ����
		session.setAttribute("ckMngNo",			sMngNo);
		session.setAttribute("ckCurrentYear",	sCYear);
		session.setAttribute("ckOentGB",		sOentGB);
		session.setAttribute("ckOentName",		oname);
		session.setAttribute("ckSentNo",		sSentNo);
		session.setAttribute("ckSentName",		sname);
		session.setAttribute("ckEntGB",			"2");
	}
/*=====================================================================================================*/
%>
<%!
public String subcontypef(String str){
	String sReturnStr = "";

	if(str!= null && str.equals("1")){
		sReturnStr="�ϵ����� �ֱ⸸ ��";
	} else if(str!= null && str.equals("2")){
		sReturnStr="�ϵ����� �ֱ⵵ �ϰ� �ޱ⵵ ��";
	} else if(str!= null && str.equals("3")){
		sReturnStr="�ϵ����� �ޱ⸸ ��";
	} else if(str!= null && str.equals("4")){
		sReturnStr="�ϵ����� ������ �ʰ� ������ ����";
	}else{
		sReturnStr="&nbsp;";
	}
	return sReturnStr ;
}

public String astatusf(String str){
	String sReturnStr = "";

	if(str!= null && str.equals("1")){
		sReturnStr="����Ҹ�";
	} else if(str!= null && str.equals("2")){
		sReturnStr="�ϵ��ްŷ�����";
	} else if(str!= null && str.equals("3")){
		sReturnStr="���޻���ڿ�Ǿȵ�";
	} else if(str!= null && str.equals("4")){
		sReturnStr="�ش�⵵ ���� �ߺ���ü";
	}else{
		sReturnStr="&nbsp;";
	}
	return sReturnStr;
}

public String fSelReason(String str){
	String sReturnStr = "";

	if(str!= null && str.equals("1")){
		sReturnStr="��. �ͻ簡 '�ϵ��޹����� ���޻����' ��ǿ� �ش���� �ʴ� ���";
	} else if(str!= null && str.equals("2")){
		sReturnStr="��. �ϵ��ްŷ��� �ƴ� ���";
	} else if(str!= null && str.equals("3")){
		sReturnStr="��. �ͻ簡 �ϵ����� �ֱ⸸ �ϴ� ���";
	} else if(str!= null && str.equals("4")){
		sReturnStr="��. �ϵ����� ������ ������ �ʴ� ���(�ϵ��ްŷ� ����)";
	}else{
		sReturnStr="&nbsp;";
	}
	return sReturnStr;
}
%>

<script type="text/JavaScript">
var content;
//<![CDATA[
content = "";

content+="<div id='viewWinTop'>";
content+="	<ul class='lt'>";
content+="		<li class='fr'><a href=javascript:closeViewWin('divView') class='sbutton'>â�ݱ�</a></li>";
content+="	</ul>";
content+="</div>";

content+="<div id='viewWinTitle'>���޻���� ������ ��ȸ</div>";

content+="<table class='ViewResultTable' align='center'>";
content+="	<tr>";
content+="		<th>���繫��</th>";
content+="		<td>&nbsp;<%=sDCenterName%></td>";
content+="		<th>������</th>";
content+="		<td>&nbsp;<%=sDDeptName%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>������</th>";
content+="		<td>&nbsp;<%=sDUserName%></td>";
content+="		<th>��翬��ó</th>";
content+="		<td>&nbsp;<%=sDPhoneNo%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>������ڰ�����ȣ</th>";
content+="		<td>&nbsp;<%=omngno%></td>";
content+="		<th>������ڸ�</th>";
content+="		<td>&nbsp;<%=oname%></td>";
content+="	</tr>";
content+="</table>";

content+="<table class='ViewResultTable' align='center'>";
content+="	<tr>";
content+="		<th>������ڸ�</th>";
content+="		<td>&nbsp;<%=oname%></td>";
content+="		<th>������ȣ</th>";
content+="		<td>&nbsp;<%=smngno%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>���޻���ڸ�</th>";
content+="		<td>&nbsp;<%=sname%></td>";
content+="		<th>��ǥ�ڸ�</th>";
content+="		<td>&nbsp;<%=scaptine%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>�ּ�</th>";
content+="		<td>&nbsp;<%=address%></td>";
content+="		<th>������ȣ</th>";
content+="		<td>&nbsp;<%=zipcode%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>��ȭ��ȣ</th>";
content+="		<td>&nbsp;<%=stel%></td>";
content+="		<th>�ѽ���ȣ</th>";
content+="		<td>&nbsp;<%=sfax%></td>";
content+="	</tr>";

content+="	<tr>";
content+="		<th>����ڱ���</th>";
content+="		<td>&nbsp;<%if( scompgb != null && scompgb.equals("1")){%>���λ����<%} else if( scompgb != null && scompgb.equals("0")){%>���λ����<%} else {%>&nbsp;<%}%></td>";
content+="		<th>���ι�ȣ</th>";
content+="		<td>&nbsp;<%=scono%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>����ڵ�Ϲ�ȣ</th>";
content+="		<td>&nbsp;<%=ssano%></td>";
content+="		<th>�ڻ��Ѿ�</th>";
content+="		<td>&nbsp;<%=samt%> �鸸��</td>";
content+="	</tr>";

content+="	<tr>";
content+="		<th>�����</th>";
content+="		<td>&nbsp;<%=ssale%> �鸸��</td>";
content+="		<th>�����������</th>";
content+="		<td>&nbsp;<%=sempcnt%> ��</td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>�ۼ��ڼҼ�</th>";
content+="		<td>&nbsp;<%=worg%></td>";
content+="		<th>�ۼ�������</th>";
content+="		<td>&nbsp;<%=wjikwi%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>�ۼ���</th>";
content+="		<td>&nbsp;<%=wname%></td>";
content+="		<th>�ۼ�����ȭ</th>";
content+="		<td>&nbsp;<%=wtel%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>�ۼ����ѽ�</th>";
content+="		<td>&nbsp;<%=wfax%></td>";
content+="		<th>����� E-mail</th>";
content+="		<td>&nbsp;<%=semail%></td>";
content+="	</tr>";

content+="	<tr>";
content+="		<th>���ۿ���</th>";
content+="		<td>&nbsp;<%if( sstatus != null && sstatus.equals("1")){%>����<%} else {%>������<%}%></td>";
content+="		<th>�ݼۿ���</th>";
content+="		<td>&nbsp;<%if( returngb != null && returngb.equals("1")){%>�ݼ�<%}%></td>";
content+="	</tr>";
content+="	<tr>";
content+="		<th>����Ҹ�����</th>";
		<%if( astatus != null && astatus.equals("1")){%>
			content+="		<td>&nbsp;����Ҹ�</td>";
		<%} else if( astatus != null && astatus.equals("2")){%>
			content+="		<td>&nbsp;�ϵ��ްŷ�����</td>";
		<%} else if( astatus != null && astatus.equals("3")){%>
			content+="		<td>&nbsp;���޻���ڿ�Ǿȵ�</td>";
		<%} else if( astatus != null && astatus.equals("4")){%>
			content+="		<td>&nbsp;�ߺ���ü</td>";
		<%}	else {%>
			content+="		<td>&nbsp;</td>";
		<%}%>
content+="		<th>�ۼ�����</th>";
content+="		<td>&nbsp;<%=wdate%></td>";
content+="	</tr>";
		<%//if( reason != null && !reason.equals("")){%>
		<%if( sspfld03 != null && !sspfld03.equals("")){%>
content+="	<tr>";
content+="		<th>�������ܻ���</th>";
content+="		<td colspan='3'><font color='#FF0000'><%=fSelReason(sspfld03)%></font><br/><%=reason.replaceAll("\"","&quot;")%></td>";
content+="	</tr>";
		<%}%>
content+="	<tr>";
content+="		<th>��������</th>";
content+="		<td colspan='3'>&nbsp;<li class='fl'><%if( sdontlogin.equals("Y") ) {%><font color='#FF0000'>��������</font><%} else  if( sdontlogin.equals("N") ) {%><font color='#3300CC'>���Ӱ���</font><%}%>&nbsp;&nbsp;&nbsp;&nbsp;</li> <li class='fl'><a href=javascript:chgDongLogin('<%=sMngNo%>','<%=sCYear%>','<%=sOentGB%>','<%=sSentNo%>','<%=sdontlogin%>'); class='sbutton'>���ܼӼ� ����</a></li></td>";
content+="	</tr>";
content+="</table>";
content+="<div id='divViewWinbutton'>";
content+="	<ul class='lt'>";
		<%if( !sRrchFolder.equals("") ) {%>
content+="		<li class='fl'>";
			<% if(Integer.parseInt(sCYear) >= 2015){%>
				<%if( sOentGB.equals("1") ) {%>
content+="				<a href='<%=sRrchFolder%>/WB_VP_Subcon_Intro.jsp' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
				<%} else if( sOentGB.equals("2") ) {%>
content+="				<a href='<%=sRrchFolder%>/WB_VP_Subcon_Intro.jsp' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
				<%} else if( sOentGB.equals("3") ) {%>
content+="				<a href='<%=sRrchFolder%>/WB_VP_Subcon_Intro.jsp' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
				<%}%>
			<%} else if(Integer.parseInt(sCYear) >= 2011){%>
				<%if( sOentGB.equals("1") ) {%>
content+="					<a href='<%=sRrchFolder%>/ProdSub_01.jsp' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
				<%} else if( sOentGB.equals("2") ) {%>
content+="					<a href='<%=sRrchFolder%>/ConstSub_01.jsp' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
				<%} else if( sOentGB.equals("3") ) {%>
content+="					<a href='<%=sRrchFolder%>/SrvSub_01.jsp' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
				<%}%>
			<%} else {%>
				<%if( sOentGB.equals("1") ) {%>
content+="					<a href='<%=sRrchFolder%>/index.jsp?type=3' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
				<%} else if( sOentGB.equals("2") ) {%>
content+="					<a href='<%=sRrchFolder%>/index.jsp?type=4' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
				<%} else if( sOentGB.equals("3") ) {%>
content+="					<a href='<%=sRrchFolder%>/index.jsp?type=6' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
				<%}%>
			<%}%>
content+="		</li>";
		<%}%>
		//���縶�� �� �����ڸ� �����ϵ��� ����
		<% //if (st_Current_Year.equals(sCYear)  && (ckUserName.equals(sDUserName) || (ckCenterName.equals(sDCenterName) && ckPermision.equals("V")) || ckPermision.equals("M") || ckPermision.equals("T"))) {%>
		<% if( ckPermision.equals("T") || ckPermision.equals("M") ) {%>
content+="			<li class='fl'><a href=javascript:f_Edit('<%=sMngNo%>','<%=sCYear%>','<%=sOentGB%>','<%=sSentNo%>') class='sbutton'>��ü��������</a></li>";
content+="			<li class='fl'><a href=javascript:f_AnsDel('<%=sMngNo%>','<%=sCYear%>','<%=sOentGB%>','<%=sSentNo%>') class='sbutton'>���䳻���ʱ�ȭ</a></li>";
		<%}%>
content+="		<li class='fr'><a href=javascript:closeViewWin('divView') class='sbutton'>â�ݱ�</a></li>";
content+="	</ul>";
content+="</div>";
top.document.getElementById("divView").innerHTML = content;
top.document.getElementById("divView").className = "dragLayer";
top.setNowProcessFalse();
//]]
</script>