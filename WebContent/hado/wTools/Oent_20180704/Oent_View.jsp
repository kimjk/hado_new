<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��	: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���	: Oent_View.jsp
* ���α׷�����	: ������� ���� ��ȸ
* ���α׷�����	: 1.0.1
* �����ۼ�����	: 2009�� 05��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2009-05-00	������       �����ۼ�
*	2011-10-18	������		�������� ������
*	2015-12-30	������		DB�������� ���� ���ڵ� ����
*/
%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>
<%@ page import="java.text.DecimalFormat"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>
<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String sMngNo = request.getParameter("no")==null ? "":request.getParameter("no").trim();
	String sCYear = request.getParameter("yyyy")==null ? "":request.getParameter("yyyy").trim();
	String sOentGB = request.getParameter("gb")==null ? "":request.getParameter("gb").trim();
	String sLoc = request.getParameter("loc")==null ? "":request.getParameter("loc").trim();
	String sMsg = request.getParameter("msg")==null ? "":request.getParameter("msg").trim();
	
	String otype = "";
	String oname = "";
	String ocaptine = "";
	String zipcode = "";
	String oaddress = "";
	String otel = "";
	String ofax = "";
	String oarea = "";
	String osale01 = "";
	String osale02 = "";
	String oassets = "";
	String oconamt = "";
	String oempcnt = "";
	String ocogb = "";
	String ocono = "";
	String ono = "";
	String assignmail = "";
	String w = "";
	String worg = "";
	String wjikwi = "";
	String wtel = "";
	String wfax = "";
	String wdate = "";
	String returngb = "";
	String resend = "";
	String compstatus = "";
	String subcontype = "";
	String subconcnt = "";
	String ostatus = "";
	String astatus = "";
	String deptseq = "";
	String submitdate = "";
	String cnm = "";
	String sOentRemake = "";

	// �ش� �繫�� ����
	String sDCenterName = "";
	String sDDeptName = "";
	String sDUserName = "";
	String sDCVSNo = "";
	String sDPhoneNo = "";
	
	// ������ �߼۹�ȣ
	String sPostNo1 = "";
	String sPostNo2 = "";
	String sPostNo3 = "";
	String sPostNo4 = "";
	String sPostNo5 = "";

	String sRrchFolder = "";
	/*2016-05-24 ���ϴٿ�ε� �߰��κ� ���� */
	ArrayList arrMngNo = new ArrayList();		//������ȣ
	ArrayList arrCYear = new ArrayList();			//����⵵
	ArrayList arrOentGB = new ArrayList();		//��������
	/*2016-05-24 ���ϴٿ�ε� �� */
	ArrayList arrFileSn = new ArrayList();
	ArrayList arrFileNm = new ArrayList();
	ArrayList arrDocuNm = new ArrayList();
	ArrayList arrUpDt = new ArrayList();

	ArrayList arrCenterName = new ArrayList();	//�繫�Ҹ�
	ArrayList arrDeptName = new ArrayList();	//����
	ArrayList arrUserName = new ArrayList();		//����ڸ�
	ArrayList arrProcCD = new ArrayList();			//ó������
	ArrayList arrWriteDate = new ArrayList();		//ó������
	ArrayList arrConst = new ArrayList();				//���

	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	if(sMngNo != null && sCYear != null && sOentGB != null && (!sMngNo.equals("")) && (!sCYear.equals("")) && (!sOentGB.equals("")) ) {
		
		
		if( sCYear.equals("2009") ) { sRrchFolder = "/hado/hado/Research"; }
		else if( sCYear.equals("2010") ) { sRrchFolder = "/hado/hado/rsch0420"; }
		else if( sCYear.equals("2011") ) { sRrchFolder = "/hado/hado/rsch0614"; }
		else if( sCYear.equals("2012") ) { sRrchFolder = "/hado/hado/rsch0607"; }
		else if( sCYear.equals("2013") ) { sRrchFolder = "/hado/hado/rsch0923"; }
		else if( sCYear.equals("2014") ) { sRrchFolder = "/hado/hado/rsch140915"; }
		else if( sCYear.equals("2015") ) { sRrchFolder = "/hado/hado/rsch150427"; }
		else if( sCYear.equals("2016") ) { sRrchFolder = "/hado/hado/rsch160411"; }
		else if( sCYear.equals("2017") ) { sRrchFolder = "/hado/hado/rsch170602"; }
		else if( sCYear.equals("2018") ) { sRrchFolder = "/hado/hado/rsch180611"; }
		else { sRrchFolder= ""; }

		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();
			
			StringBuffer sbSQLs = new StringBuffer();

			sbSQLs.append("SELECT * \n");
			if( sCYear.equals("2018") ) {
				sbSQLs.append("FROM HADO_VT_OENT_SUBMIT_2018 \n");
			}else if( sCYear.equals("2017") ) {
				sbSQLs.append("FROM HADO_VT_OENT_SUBMIT_2017 \n");
			}else if( sCYear.equals("2016") ) {
				sbSQLs.append("FROM HADO_VT_OENT_SUBMIT_2016 \n");
			}else if( sCYear.equals("2015") ) {
				sbSQLs.append("FROM HADO_VT_OENT_SUBMIT_2015 \n");
			} else if( sCYear.equals("2014") ) {
				sbSQLs.append("FROM HADO_VT_OENT_SUBMIT_2014 \n");
			} else if( sCYear.equals("2013") ) {
				sbSQLs.append("FROM HADO_VT_OENT_SUBMIT_2013 \n");
			} else if( sCYear.equals("2012") ) {
				sbSQLs.append("FROM HADO_VT_OENT_SUBMIT_2012 \n");
			} else {
				sbSQLs.append("FROM HADO_VT_OENT_SUBMIT \n");
			}
			sbSQLs.append("WHERE RTRIM(MNG_NO)=? \n");
			sbSQLs.append("    AND CURRENT_YEAR=? \n");
			sbSQLs.append("    AND OENT_GB=? \n");
		
			pstmt = conn.prepareStatement(sbSQLs.toString());
			pstmt.setString(1,sMngNo);
			pstmt.setString(2,sCYear);
			pstmt.setString(3,sOentGB);
			rs = pstmt.executeQuery();

			if( rs.next() ) {
				otype = rs.getString("OENT_TYPE")==null ? "":rs.getString("OENT_TYPE").trim();
				oname = rs.getString("OENT_NAME")==null ? "":rs.getString("OENT_NAME").trim();
				ocaptine = rs.getString("OENT_CAPTINE")==null ? "":rs.getString("OENT_CAPTINE").trim();
				zipcode= rs.getString("ZIP_CODE")==null ? "":rs.getString("ZIP_CODE").trim();
				oaddress= rs.getString("OENT_ADDRESS")==null ? "":rs.getString("OENT_ADDRESS").trim();
				otel= rs.getString("OENT_TEL")==null ? "":rs.getString("OENT_TEL").trim();
				ofax= rs.getString("OENT_FAX")==null ? "":rs.getString("OENT_FAX").trim();
				oarea= rs.getString("OENT_AREA")==null ? "":rs.getString("OENT_AREA").trim();
				osale01= rs.getString("OENT_SALE01")==null ? "":rs.getString("OENT_SALE01").trim();
				osale02= rs.getString("OENT_SALE02")==null ? "":rs.getString("OENT_SALE02").trim();
				oassets= rs.getString("OENT_ASSETS")==null ? "":rs.getString("OENT_ASSETS").trim();
				oconamt= rs.getString("OENT_CON_AMT")==null ? "":rs.getString("OENT_CON_AMT").trim();
				oempcnt= rs.getString("OENT_EMP_CNT")==null ? "":rs.getString("OENT_EMP_CNT").trim();
				ocogb= rs.getString("OENT_CO_GB")==null ? "":rs.getString("OENT_CO_GB").trim();
				ocono= rs.getString("OENT_CO_NO")==null ? "":rs.getString("OENT_CO_NO").trim();
				ono= rs.getString("OENT_SA_NO")==null ? "":rs.getString("OENT_SA_NO").trim();
				assignmail= rs.getString("ASSIGN_MAIL")==null ? "":rs.getString("ASSIGN_MAIL").trim();
				w= rs.getString("WRITER_NAME")==null ? "":rs.getString("WRITER_NAME").trim();
				worg= rs.getString("WRITER_ORG")==null ? "":rs.getString("WRITER_ORG").trim();
				wjikwi= rs.getString("WRITER_JIKWI")==null ? "":rs.getString("WRITER_JIKWI").trim();
				wtel= rs.getString("WRITER_TEL")==null ? "":rs.getString("WRITER_TEL").trim();
				wfax= rs.getString("WRITER_FAX")==null ? "":rs.getString("WRITER_FAX").trim();
				wdate= rs.getString("WRITE_DATE")==null ? "":rs.getString("WRITE_DATE").trim();
				returngb= rs.getString("RETURN_GB")==null ? "":rs.getString("RETURN_GB").trim();
				resend= rs.getString("RE_SEND")==null ? "":rs.getString("RE_SEND").trim();
				compstatus= rs.getString("COMP_STATUS")==null ? "":rs.getString("COMP_STATUS").trim();
				subcontype= rs.getString("SUBCON_TYPE")==null ? "":rs.getString("SUBCON_TYPE").trim();
				subconcnt= rs.getString("SUBCON_CNT")==null ? "":rs.getString("SUBCON_CNT").trim();
				ostatus= rs.getString("OENT_STATUS")==null ? "":rs.getString("OENT_STATUS").trim();
				astatus= rs.getString("ADDR_STATUS")==null ? "":rs.getString("ADDR_STATUS").trim();
				submitdate= rs.getString("SUBMIT_DATE")==null ? "":rs.getString("SUBMIT_DATE").trim();
				cnm= rs.getString("COMMON_NM")==null ? "":rs.getString("COMMON_NM").trim();
				if( sCYear.equals("2013") ||  sCYear.equals("2014") ||  sCYear.equals("2015")  ) {
					sOentRemake = rs.getString("oent_remake")==null ? "":rs.getString("oent_remake").trim();
				}
			}
			rs.close();

			// �ش� ����� ���繫������ ��������
			StringBuffer sbSQLs2 = new StringBuffer();

			sbSQLs2.append("SELECT CVSNO,Center_Name,Dept_Name,User_Name,Phone_No \n");
			/*
			* 2014�� 10�� 02�� - ������
			* ����Ÿ���̽� ����ȭ�� ���Ͽ� 2014����� ���� ���� ���̺� �и�
			* 2014�� ���� : hado_vt_dept_history, 2014��~ : hado_vt_dept_hostory_2014
			*/
			int nTmpCYear = Integer.parseInt(sCYear);
			if( nTmpCYear>=2014 ) {
				sbSQLs2.append("FROM HADO_VT_Dept_History_" + sCYear + " \n");
			} else {
				sbSQLs2.append("FROM HADO_VT_Dept_History \n");
			}
			sbSQLs2.append("WHERE Mng_No=? \n");
			sbSQLs2.append("    AND CURRENT_YEAR=? \n");
			sbSQLs2.append("    AND OENT_GB=? \n");

			pstmt = conn.prepareStatement(sbSQLs2.toString());
			pstmt.setString(1,sMngNo);
			pstmt.setString(2,sCYear);
			pstmt.setString(3,sOentGB);
			rs = pstmt.executeQuery();

			if( rs.next() ) {
				sDCVSNo = rs.getString("CVSNO")==null ? "":rs.getString("CVSNO").trim();
				sDCenterName = rs.getString("Center_Name")==null ? "":rs.getString("Center_Name").trim();
				sDDeptName = rs.getString("Dept_Name")==null ? "":rs.getString("Dept_Name").trim();
				sDUserName = rs.getString("User_Name")==null ? "":rs.getString("User_Name").trim();
				sDPhoneNo = rs.getString("Phone_No")==null ? "":rs.getString("Phone_No").trim();
			}
			rs.close();

			// ������ �߼� ��ȣ
			StringBuffer sbSQLs3 = new StringBuffer();

			sbSQLs3.append("SELECT * \n");
			/*
			* 2014�� 10�� 02�� - ������
			* ����Ÿ���̽� ����ȭ�� ���Ͽ� 2014����� ����ȣ ���� ���̺� �и�
			* 2014�� ���� : hado_tb_oent_postno, 2014��~ : hado_tb_oent_postno_2014
			*/
			//int nTmpCYear = Integer.parseInt(sCYear);  <-- �� �ܰ迡�� �̹� ����
			if( nTmpCYear>=2014 ) {
				sbSQLs3.append("FROM HADO_TB_Oent_PostNo_" + sCYear + " \n");
			} else {
				sbSQLs3.append("FROM HADO_TB_Oent_PostNo \n");
			}
			sbSQLs3.append("WHERE Mng_No=? \n");
			sbSQLs3.append("    AND CURRENT_YEAR=? \n");
			sbSQLs3.append("    AND OENT_GB=? \n");

			pstmt = conn.prepareStatement(sbSQLs3.toString());
			pstmt.setString(1,sMngNo);
			pstmt.setString(2,sCYear);
			pstmt.setString(3,sOentGB);
			rs = pstmt.executeQuery();

			if( rs.next() ) {
				sPostNo1 = rs.getString("Post_No_01")==null ? "":rs.getString("Post_No_01").trim();
				sPostNo2 = rs.getString("Post_No_02")==null ? "":rs.getString("Post_No_02").trim();
				sPostNo3 = rs.getString("Post_No_03")==null ? "":rs.getString("Post_No_03").trim();
				sPostNo4 = rs.getString("Post_No_04")==null ? "":rs.getString("Post_No_04").trim();
				sPostNo5 = rs.getString("Post_No_05")==null ? "":rs.getString("Post_No_05").trim();
			}
			rs.close();

			// �����ڷ� ��������
			StringBuffer sbSQLs4 = new StringBuffer();

			sbSQLs4.append("SELECT * \n");
			sbSQLs4.append("FROM hado_tb_oent_attach_file \n");
			sbSQLs4.append("WHERE mng_no=? \n");
			sbSQLs4.append("AND current_year=? \n");
			sbSQLs4.append("AND oent_gb=? \n");
			sbSQLs4.append("ORDER BY file_sn DESC \n");

			pstmt = conn.prepareStatement(sbSQLs4.toString());
			pstmt.setString(1,sMngNo);
			pstmt.setString(2,sCYear);
			pstmt.setString(3,sOentGB);
			rs = pstmt.executeQuery();

			while( rs.next() ) {
				/*2016-05-24 ���ϴٿ�ε� �߰��κ� ���� */
				arrMngNo.add( rs.getString("mng_no")==null ? "":rs.getString("mng_no").trim() );
				arrCYear.add( rs.getString("current_year")==null ? "":rs.getString("current_year").trim() );
				arrOentGB.add( rs.getString("oent_gb")==null ? "":rs.getString("oent_gb").trim() );
				/*2016-05-24 ���ϴٿ�ε� �� */
				arrFileSn.add( rs.getString("file_sn")==null ? "":rs.getString("file_sn").trim() );
				arrFileNm.add( rs.getString("file_name")==null ? "":rs.getString("file_name").trim() );
				arrDocuNm.add( rs.getString("docu_name")==null ? "":rs.getString("docu_name").trim() );
				arrUpDt.add( rs.getString("upload_dt")==null ? "":rs.getString("upload_dt").trim() );
			}
			rs.close();

			// ó����Ȳ ����Ʈ  ��������
			StringBuffer sbSQLs5 = new StringBuffer();

			sbSQLs5.append("SELECT * \n");
			sbSQLs5.append("FROM hado_tb_comp_status_proc \n");
			sbSQLs5.append("WHERE mng_no=? AND current_year=? AND oent_gb=? \n");
			sbSQLs5.append("ORDER BY proc_sn DESC \n");
			
			pstmt = conn.prepareStatement(sbSQLs5.toString());
			pstmt.setString(1, sMngNo);
			pstmt.setString(2, sCYear);
			pstmt.setString(3, sOentGB);
			rs = pstmt.executeQuery();
			
			while ( rs.next() ) {
				arrCenterName.add( rs.getString("center_name")==null ? "":rs.getString("center_name").trim() );
				arrDeptName.add( rs.getString("dept_name")==null ? "":rs.getString("dept_name").trim() );
				arrUserName.add( rs.getString("user_name")==null ? "":rs.getString("user_name").trim() );
				arrProcCD.add( rs.getString("proc_cd")==null ? "":rs.getString("proc_cd").trim() );
				arrWriteDate.add( rs.getString("write_date")==null ? "":rs.getString("write_date").trim() );
				arrConst.add( rs.getString("const")==null ? "��� ���� ����":rs.getString("const").trim() );
			}
			rs.close();
		} catch(Exception e){
				e.printStackTrace();
		} finally {
				if ( rs != null )	try{rs.close();}		catch(Exception e){}
				if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
				if ( conn != null )		try{conn.close();}	catch(Exception e){}
				if ( resource != null ) resource.release();
		}
		
		
		// ����ǥ ��ȸ�� ���� �������� ����
		session.setAttribute("ckMngNo", sMngNo);
		session.setAttribute("ckCurrentYear", sCYear);
		session.setAttribute("ckOentGB", sOentGB);
		session.setAttribute("ckOentName", oname );
		session.setAttribute("ckSentNo", "");
		session.setAttribute("ckSentName", "");
		session.setAttribute("ckEntGB", "1");
		session.setAttribute("ckLoginGB", "N");
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
		sReturnStr="����ȸ��";
	} else if(str!= null && str.equals("3")){
		sReturnStr="������ڿ�Ǿȵ�";
	} else if(str!= null && str.equals("9")){
		sReturnStr="�ش�⵵ ���� �ߺ���ü";
	} else if(str!= null && str.equals("8")){
		sReturnStr="���������ü";
	}else{
		sReturnStr="&nbsp;";
	}	
	return sReturnStr;
}
%>
<script language="javascript">
//<![CDATA[
	content = "";
	
	content+="<div id='viewWinTop'>";
	content+="	<ul class='lt'>";
	content+="		<li class='fr'><a href=javascript:closeViewWin('divView') class='sbutton'>â�ݱ�</a></li>";
	content+="	</ul>";
	content+="</div>";
	
	content+="<div id='viewWinTitle'>������� ������ ��ȸ</div>";
	
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
	content+="</table>";
	
	content+="<table class='ViewResultTable' align='center'>";
	content+="	<tr>";
	content+="		<th>�������ȣ</th>";
	content+="		<td>&nbsp;��<%=sPostNo1%> / ��<%=sPostNo2%><br/>&nbsp;��<%=sPostNo3%> / ��<%=sPostNo4%> / ��<%=sPostNo5%></td>";
	content+="	</tr>";
	content+="</table>";
	
	content+="<table class='ViewResultTable' align='center'>";
	content+="	<tr>";
	content+="		<th>����⵵</th>";
	content+="		<td>&nbsp;<%=sCYear%>�� [<%=sMngNo%>]</td>";
	content+="		<th>����</th>";
	content+="		<td>&nbsp;<%=StringUtil.gbf(sOentGB)%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>�����ڵ�</th>";
	content+="		<td>&nbsp;<%=otype%>(<%=cnm%>)</td>";
	content+="		<th>ȸ���</th>";
	content+="		<td>&nbsp;<%=oname%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>��ǥ�ڸ�</th>";
	content+="		<td>&nbsp;<%=ocaptine%></td>";
	content+="		<th>�����ȣ</th>";
	content+="		<td>&nbsp;<%=zipcode%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>�ּ�</th>";
	content+="		<td>&nbsp;<%=oaddress%></td>";
	content+="		<th>��ȭ��ȣ</th>";
	content+="		<td>&nbsp;<%=otel%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>�ѽ���ȣ</th>";
	content+="		<td>&nbsp;<%=ofax%></td>";
	content+="		<th><%=Integer.parseInt(sCYear)-2%>�� �����</th>";
	content+="		<td>&nbsp;<%=osale01%> �鸸��</td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th><%=Integer.parseInt(sCYear)-1%> �����</th>";
	content+="		<td>&nbsp;<%=osale02%> �鸸��</td>";
	content+="		<th>�ð��ɷ��򰡾�</th>";
	content+="		<td>&nbsp;<%=oconamt%> �鸸��</td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>�����������</th>";
	content+="		<td>&nbsp;<%=oempcnt%> ��</td>";
	content+="		<th>���ε�Ͽ���</th>";
	content+="		<td>&nbsp;<%if( ocogb != null && ocogb.equals("1")){%>���λ����<%} else if( ocogb != null && ocogb.equals("0")){%>���λ����<%} else {%>&nbsp;<%}%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>���ι�ȣ</th>";
	content+="		<td>&nbsp;<%=ocono%></td>";
	content+="		<th>����ڵ�Ϲ�ȣ</th>";
	content+="		<td>&nbsp;<%=ono%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>����� E-mail</th>";
	content+="		<td>&nbsp;<%=assignmail%></td>";
	content+="		<th>�ۼ��ڼҼ�</th>";
	content+="		<td>&nbsp;<%=worg%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>�ۼ���</th>";
	content+="		<td>&nbsp;<%=w%></td>";
	content+="		<th>�ۼ�������</th>";
	content+="		<td>&nbsp;<%=wjikwi%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>�ۼ�����ȭ</th>";
	content+="		<td>&nbsp;<%=wtel%></td>";
	content+="		<th>�ۼ����ѽ�</th>";
	content+="		<td>&nbsp;<%=wfax%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>�ۼ�����</th>";
	content+="		<td>&nbsp;<%=wdate%></td>";
	content+="		<th>�ݼۿ���</th>";
	content+="		<td>&nbsp;<%=StringUtil.returnf(returngb)%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>��߼ۿ���</th>";
	content+="		<td>&nbsp;<%=StringUtil.resendf(resend)%></td>";
	content+="		<th>ȸ�翵������</th>";
	content+="		<td>&nbsp;<%=StringUtil.statusf(compstatus)%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>�ϵ��ްŷ�����</th>";
	content+="		<td>&nbsp;<%=subcontypef(subcontype)%></td>";
	content+="		<th>���ۿ���</th>";
	content+="		<td>&nbsp;<%=StringUtil.ostatusf(ostatus)%></td>";
	content+="	</tr>";
	content+="	<tr>";
	content+="		<th>��������</th>";
	content+="		<td>&nbsp;<%=submitdate%></td>";
	content+="		<th>����Ҹ���</th>";
	content+="		<td>&nbsp;<%=astatusf(astatus)%></td>";
	content+="	</tr>";
	content+="	<tr>";
	<%
	if( sCYear.equals("2013") || sCYear.equals("2014") || sCYear.equals("2015") ) {
	%>
	content+="	<tr>";
	content+="		<th>���<br/>(������ġ��<br/>������<br/>�Է�)</th>";
	content+="		<td colspan='3'>&nbsp;";
	content+="			<%=sOentRemake%>";
	content+="		</td>";
	content+="	</tr>";
	<%
	}%>
	content+="</table>";
	
	<%if((compstatus != null) && (!compstatus.equals("")) && (!compstatus .equals("1")) ) {%>
	content+="<div id='viewWinTitle'>ȸ�� �Ϲ���Ȳ �����󿵾� ����� �����ڷ�</div>";
	content+="<input type='hidden' id='attachFileYN' name='attachFileYN' value='N' />";
	content+="<table class='ViewResultTable' align='center'>";
	content+="	<colgroup>";
	content+="		<col style='width:10%;' />";
	content+="		<col style='width:40%;' />";
	content+="		<col style='width:30%;' />";
	content+="		<col style='width:20%;' />";
	content+="	</colgroup>";
	content+="	<tr>";
	content+="		<th>����</th>";
	content+="		<th>÷�ι�����</th>";
	content+="		<th>÷�����ϸ�</th>";
	content+="		<th>���ε�����</th>";
	content+="	</tr>";
	content+="	<tr>";
		<%for( int i=0; i<arrFileNm.size(); i++ ) {%>
	content+="		<td>&nbsp;<%=arrFileNm.size() - i%></td>";
	content+="		<td>&nbsp;<%=arrDocuNm.get(i)%></td>";
	content+="		<td>&nbsp;<a href='<%=sRrchFolder%>/WB_SP_Download_01.jsp?sn=<%=arrFileSn.get(i)%>&mno=<%=arrMngNo.get(i)%>&cyear=<%=arrCYear.get(i)%>&ogb=<%=arrOentGB.get(i)%>'><%=arrFileNm.get(i)%></a></td>";
	content+="		<td>&nbsp;<%=arrUpDt.get(i).toString().substring(0,10)%></td>";
	content+="	</tr>";
		<%}%>
	content+="</table>";
	<%}%>
	
	<%if((compstatus != null) && (!compstatus.equals("")) && (!compstatus .equals("1")) ) {%>
	content+="<div id='viewWinTitle'>�����ڷ� ó�����</div>";
	content+="<input type='hidden' id='attachFileYN' name='attachFileYN' value='N' />";
	content+="<table class='ViewResultTable' align='center'>";
	content+="	<colgroup>";
	content+="		<col style='width:25%;' />";
	content+="		<col style='width:20%;' />";
	content+="		<col style='width:15%;' />";
	content+="		<col style='width:10%;' />";
	content+="		<col style='width:15%;' />";
	content+="		<col style='width:15%;' />";
	content+="	</colgroup>";
	content+="	<tr>";
	content+="		<th>�繫�Ҹ�</th>";
	content+="		<th>����</th>";
	content+="		<th>������</th>";
	content+="		<th>����</th>";
	content+="		<th>ó������</th>";
	content+="		<th>�����</th>";
	content+="	</tr>";
		<%if( arrProcCD.size()>0 ) {
			for( int i=0; i<arrProcCD.size(); i++ ) {%>
	content+="	<tr>";
	content+="		<td>&nbsp;<%=arrCenterName.get(i).toString()%></td>";
	content+="		<td>&nbsp;<%=arrDeptName.get(i).toString()%></td>";
	content+="		<td>&nbsp;<%=arrUserName.get(i).toString()%></td>";
			<%
			String sTmpProcCD = arrProcCD.get(i).toString();
			if( sTmpProcCD.equals("1") ) sTmpProcCD = "<font style='color:blue;'>����</font>";
			else if( sTmpProcCD.equals("2") ) sTmpProcCD = "<font style='color:red;'>�ݷ�</font>";
			else sTmpProcCD = "��ó��";
			String sTmpConst = arrConst.get(i)==null ? "":arrConst.get(i).toString();
			sTmpConst = sTmpConst.replaceAll("\r\n","<br/>");
			%>
	content+="		<td>&nbsp;<%=sTmpProcCD%></td>";
	content+="		<td>&nbsp;<%=arrWriteDate.get(i).toString().substring(0,10)%></td>";
	content+="		<td>&nbsp;<li class=\"fr\"><a href=\"javascript:viewConst('<%=i%>');\" class=\"sbutton\">�����</a></li></td>";
	content+="	</tr>";
	content+="<tr id=\"lyList<%=i%>\" style=\"display:none;\">";
	content+="		<td colspan=\"6\"><%=sTmpConst%><li class=\"fr\"><a href=\"javascript:closeConst('<%=i%>');\" class=\"sbutton\">���ݱ�</a></li></td>";
	content+="	</tr>";
		<%}
		} else {%>
	content+="	<tr>";
	content+="		<td colspan=\"6\" align=\"center\">��ϵ� ó������� �����ϴ�.</td>";
	content+="	</tr>";
		<%}%>
	content+="</table>";
	<%}%>
	
	content+="<div id='divViewWinbutton'>";
	content+="	<ul class='lt'>";
			<%if( !sRrchFolder.equals("") ) {%>
	content+="		<li class='fl'>";
				<%if( sCYear.equals("2014") || sCYear.equals("2015") || sCYear.equals("2016") || sCYear.equals("2017") || sCYear.equals("2018") ) {%>
					<%if( sOentGB.equals("1") ) {%>
	content+="				<a href='<%=sRrchFolder%>/WB_VP_Introduction.jsp' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
					<%} else if( sOentGB.equals("2") ) {%>
	content+="				<a href='<%=sRrchFolder%>/WB_VP_Introduction.jsp' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
					<%} else if( sOentGB.equals("3") ) {%>
	content+="				<a href='<%=sRrchFolder%>/WB_VP_Introduction.jsp' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
					<%}%>
				<%} else if( sCYear.equals("2012") || sCYear.equals("2013") ) {%>
					<%if( sOentGB.equals("1") ) {%>
	content+="				<a href='<%=sRrchFolder%>/ProdStep_01.jsp' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
					<%} else if( sOentGB.equals("2") ) {%>
	content+="				<a href='<%=sRrchFolder%>/ConstStep_01.jsp' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
					<%} else if( sOentGB.equals("3") ) {%>
	content+="				<a href='<%=sRrchFolder%>/SrvStep_01.jsp' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
					<%}%>
				<%} else {%>
					<%if( sOentGB.equals("1") ) {%>
	content+="				<a href='<%=sRrchFolder%>/index.jsp?type=1' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
					<%} else if( sOentGB.equals("2") ) {%>
	content+="				<a href='<%=sRrchFolder%>/index.jsp?type=2' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
					<%} else if( sOentGB.equals("3") ) {%>
	content+="				<a href='<%=sRrchFolder%>/index.jsp?type=5' target='hado_site_01' class='sbutton'>����ǥ ����</a>";
					<%}%>
				<%}%>
	
	content+="		</li>";
			<%}%>
			<%if( st_Current_Year.equals(sCYear)  && (ckPermision.equals("T") || ckPermision.equals("M") || ckPermision.equals("P")) ) {%>
			<%//if( st_Current_Year.equals(sCYear)  && (ckPermision.equals("T") || ckPermision.equals("M")) ) {%>
			<%//if( st_Current_Year.equals(sCYear)  && ( ckCenterName.equals(sDCenterName) || ckPermision.equals("M") || ckPermision.equals("T") ) ) {%>
			<%//if( ckPermision.equals("T") ) {	// ��ü �����û(�ֺ��������) - ������ �۾� 20131007%>
	content+="			<li class='fl'><a href=javascript:top.f_Edit('<%=sMngNo%>','<%=sCYear%>','<%=sOentGB%>') class='sbutton'>��ü��������</a></li>";
	content+="			<li class='fl'><a href=javascript:top.f_AnsDel('<%=sMngNo%>','<%=sCYear%>','<%=sOentGB%>') class='sbutton'>���䳻���ʱ�ȭ</a></li>";
			<%}%>
	content+="		<li class='fr'><a href=javascript:closeViewWin('divView') class='sbutton'>â�ݱ�</a></li>";
	content+="	</ul>";
	content+="</div>";
	
	top.document.getElementById("divView").innerHTML = content;
	top.document.getElementById("divView").className = "dragLayer";
	top.setNowProcessFalse();
//]]
</script>