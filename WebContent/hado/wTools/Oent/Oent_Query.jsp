<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.io.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
	ConnectionResource resource = null;
	String sSQLs = "";
/*=================================== Record Selection Processing =====================================*/
		sTableName1 = "HADO_TB_Oent_2013";
		sTableName2 = "HADO_TB_Oent_Answer_2013";
		sTableName3 = "HADO_TB_REC_PAY_2013";
		sTableName4 = "HADO_TB_OENT_CASH_PAYTYPE_2013";
	} else if( sCYear.equals("2014") ) {
		sTableName1 = "HADO_TB_Oent_2014";
		sTableName2 = "HADO_TB_Oent_Answer_2014";
		sTableName3 = "HADO_TB_REC_PAY_2014";
		//sTableName4 = "HADO_TB_OENT_CASH_PAYTYPE_2014";
	} else if( sCYear.equals("2015") ) {
		sTableName1 = "HADO_TB_Oent_2015";
		sTableName2 = "HADO_TB_Oent_Answer_2015";
		sTableName3 = "HADO_TB_REC_PAY_2015";
	} else if( sCYear.equals("2016") ) {

	if( sCmd != null && sCmd.equals("edit") ) {
			try {
				sSQLs = "UPDATE "+sTableName1+" SET OENT_NAME = '" + request.getParameter("oname").trim().replaceAll("'","''") + "'";
				//System.out.println(sSQLs);
				pstmt = conn.prepareStatement(sSQLs);
			sReturnURL	=  "Oent_View.jsp?no="+sMngNo+"&yyyy="+sCYear+"&gb="+sOentGB;
	if( sCmd != null && sCmd.equals("answerdel") ) {
				sSQLs = "DELETE FROM "+sTableName2+" WHERE Mng_No = '" + sMngNo + "' " +
				pstmt = conn.prepareStatement(sSQLs);
	if( sCmd != null && sCmd.equals("answerinit") ) {
				// �ϵ��ްŷ���Ȳ
				pstmt = conn.prepareStatement(sSQLs);
				int updateCNT1 = pstmt.executeUpdate();
				// ���� �� �������Ȳ

				// �ϵ��޴�� ����
				pstmt = conn.prepareStatement(sSQLs);
				int updateCNT3 = pstmt.executeUpdate();

				// ���ݼ� �������� 1
				pstmt = conn.prepareStatement(sSQLs);
				int updateCNT4 = pstmt.executeUpdate();
				
				// ���ݼ� �������� 2
				pstmt = conn.prepareStatement(sSQLs);
				int updateCNT5 = pstmt.executeUpdate();
			try {
				// ���޻���� ���ε� ����
				pstmt = conn.prepareStatement(sSQLs);
				int updateCNT6 = pstmt.executeUpdate();

				// ���޻���ڸ���
				pstmt = conn.prepareStatement(sSQLs);
				int updateCNT7 = pstmt.executeUpdate();
			try {
				// 2010.5.25 ����ȣ �ʱ�ȭ�� �����ư�� �Ⱥ��̴� ������ oent_status=null �߰�
				pstmt = conn.prepareStatement(sSQLs);
				int updateCNT8 = pstmt.executeUpdate();