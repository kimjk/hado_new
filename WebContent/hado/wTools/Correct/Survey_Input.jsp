<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>
<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
String tt = StringUtil.checkNull(request.getParameter("tt"));
ConnectionResource resource = null;
ArrayList moneygbtext = new ArrayList();
String[] act = new String[12];
String sCYear = StringUtil.checkNull(request.getParameter("cyear"));
String tmpStr = "";
String old_cd = "";
String ctype = "";
String atype = "";
String bData = "F";
String sTmpStr1 = "";
int i = 0;
int nx = 0;
java.util.Calendar cal = java.util.Calendar.getInstance();
DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
String tmpYear = "";
for(int ni=1; ni<12; ni++) {
	/* 2012�� ������� ���� DB Table �и� ����ó�� ���� ============================================================> */
	// �������
try {
	//System.out.print("194 ====>> " + sSQLs+"\n\n");
	pstmt = conn.prepareStatement(sSQLs);
	if( rs.next() ) {
	//System.out.print("265 ====> " + sSQLs+"\n\n");
	pstmt = conn.prepareStatement(sSQLs);
	if( rs.next() ) {
	i = 1;
		//System.out.print("296 ====> " + sSQLs+"\n\n");
		pstmt = conn.prepareStatement(sSQLs);
		while( rs.next() ) {
			if( !(old_cd.equals(oicd) && old_gb.equals(oigb)) ) {
	if( i > 1 ) {
		//System.out.print("347 ====> " + sSQLs+"\n\n");
		pstmt = conn.prepareStatement(sSQLs);
		while( rs.next() ) {
		sSQLs= "SELECT * \n";
		//System.out.print("372 ====> " + sSQLs+"\n\n");
		pstmt = conn.prepareStatement(sSQLs);
		int jj = 0;
		// ������ / 20141224
		if( currentYear==2016 && (ogb.equals("1") || ogb.equals("3")) ) {
			sSQLs = "SELECT CASE WHEN a1+sa2>0 THEN 1 ELSE 0 END AS violate_gb \n" +
							"FROM hado_tb_survey_print \n"+
							"WHERE mng_no=? AND current_year=? AND oent_gb=? \n";
			pstmt = conn.prepareStatement(sSQLs);
			pstmt.setString(1,omngno);
			pstmt.setString(2,currentYear+"");
			pstmt.setString(3,ogb);
			rs = pstmt.executeQuery();
			if( rs.next() ) {
				tmpViolate9383 = rs.getString("violate_gb")==null ? "0":rs.getString("violate_gb");
			}
			rs.close();
		} else if( currentYear==2015 && (ogb.equals("1") || ogb.equals("3")) ) {
			sSQLs = "SELECT CASE WHEN a3+sa2>0 THEN 1 ELSE 0 END AS violate_gb \n" +
							"FROM hado_tb_survey_print \n"+
							"WHERE mng_no=? AND current_year=? AND oent_gb=? \n";
			pstmt = conn.prepareStatement(sSQLs);
			pstmt.setString(1,omngno);
			pstmt.setString(2,currentYear+"");
			pstmt.setString(3,ogb);
			rs = pstmt.executeQuery();
			if( rs.next() ) {
				tmpViolate9383 = rs.getString("violate_gb")==null ? "0":rs.getString("violate_gb");
			}
			rs.close();
		} else if( currentYear==2014 && (ogb.equals("1") || ogb.equals("3")) ) {
		/* 2014�� ����/�뿪 �δ��� �ϵ��޴�� ���� �����Ǵ� ������ ���� ����� �̸� �������� �� */
		// �ԷµǾ� �ִ� ���� ������.....
			if( currentYear >= 2012 ) {
			sSQLs+="			b.SOent_Q_CDNM,b.Money_GB,b.Rank,b.Identity_Q_CD,b.Identity_Q_GB, \n";
		//System.out.print("578 ====> " + sSQLs+"\n\n");
		pstmt = conn.prepareStatement(sSQLs);
		while( rs.next() ) {
			if( !(old_cd.equals(oicd) && old_gb.equals(oigb)) ) {
					// ������ / 20141224
					if( currentYear>=2014 && ogb.equals("1") && oicd.equals("9") && oigb.equals("3") && tmpViolate9383.equals("0") ) {
						nomoneygbtext.add(otext);
						nicd.add(oicd);
						nigb.add(oigb);
						nomoneygb.add("");
					} else if( currentYear>=2014 && ogb.equals("3") && oicd.equals("8") && oigb.equals("3") && tmpViolate9383.equals("0") ) {
						nomoneygbtext.add(otext);
						nicd.add(oicd);
						nigb.add(oigb);
						nomoneygb.add("");
					} else {
						nomoneygbtext.add(otext);
						nicd.add(oicd);
						nigb.add(oigb);
						nomoneygb.add(ostotal.replaceAll("0",""));
					/* 2014�� ����/�뿪 �δ��� �ϵ��޴�� ���� �����Ǵ� ������ ���� ����� �̸� �������� �� */
					nomoneymoney.add(omoney.replaceAll("","0"));
			String year = Integer.toString(cal.get(Calendar.YEAR));
			strNDate = year;
		return strNDate;
		if( str.equals("20") ) {
		return sReturnStr ;
	content+="<div id='viewWinTop'>";
	content+="<div id='viewWinTitle' style='margin-left:-20px;'><li class='lt'><ul class='fl'>������ġ ����ȸ �� �Է�</ul><ul class='fr' id='ulBasicInfoView'><a href=javascript:hidContent('divBasicInfo','ulBasicInfoView','�⺻����'); class='sbutton'>�⺻���� ������</a></ul></li></div>";
	content+="<div id='divBasicInfo'>";
	if( sTmpStr1.equals("2") ) {
	content+="<div id='viewWinTitle2' style='margin-left:-20px;'><li class='lt'><ul class='fl'>��� ������� �Ϲ���Ȳ</ul><ul class='fr' id='ulOentInfoView'><a href=javascript:hidContent('divOentView','ulOentInfoView','�Ϲ���Ȳ'); class='sbutton'>�Ϲ���Ȳ ������</a></ul></li></div>";
	content+="<div id='divOentView'>";
	content+="<div id='viewWinTitle2' style='margin-left:-20px;'><li class='lt'><ul class='fl'>�����׸� ���ݿ���</ul><ul class='fr' id='ulSurveyView'><a href=javascript:hidContent('divSurveyView','ulSurveyView','�����׸�'); class='sbutton'>�����׸� ������</a></ul></li></div>";
	content+="<div id='divSurveyView'>";
	// 2014-01-16 ����ȣ �ֺ��� ����� ���÷� ���þ��� ��Ȱ��ȭ ó��
	// 2014-01-16 ����ȣ �ֺ��� ����� ���÷� ���þ��� ��Ȱ��ȭ ó��
	content+="<div id='viewWinTitle2' style='margin-left:-20px;'><li class='lt'><ul class='fl'>��� ���� ���ݻ��� ��������</ul><ul class='fr' id='ulCorrectView'><a href=javascript:hidContent('divCorrectView','ulCorrectView','��������'); class='sbutton'>�������� ������</a></ul></li></div>";
	content+="<div id='divCorrectView'>";
	content+="<div id='divViewWinbutton'>";
	/* 2014-03-05 : �ֺ�������� ��û���� ���ٱ��� ������ ���� - ������ */
	/* 2014-10-30 : ������ġ ��� ���� ó�� - ������ */
	/* 2014-11-12 : �ֺ��� ����� ������ġ ���� ���� ������ ���� �ӽ� ���� */
	/* 2014-11-13 : �ֺ��� ����� ��û���� �ȼ��� �繫��������ġ ���� ���� ������ ���� �ӽ� ���� */
	/* 2014-11-13 11:07 : �ȼ��� �繫�� ���� ���� */
	/* 2014-11-26 : �ֺ��� ����� ������ġ ���� ���� ���� */
	/* 2014-12-11 : �ֺ��� ����� ������ġ ���� ���� ������ ���� �ӽ� ���� */
	/* 2014-12-12 : �ֺ��� ����� ������ġ ���� ���� ���� */
	/* 2014-12-19 : 2014�⵵ �ϵ��ްŷ� ����������� ������ġ ���� ���� */
	/* 2015-04-13 : 2014�⵵ �ϵ��ްŷ� ����������� ������ġ ������ ���� ���� ���� ���� */
	/* 2015-04-22 : ������ ����� ������ġ ���� ���� ������ ���� �ӽ� ����  */
	/* 2015-05-06 : 2014�⵵ �ϵ��ްŷ� ����������� ������ġ �Է¿��� ������ ���� 5�� 15�ϱ��� �ӽ� ����  */
	/* 2015-12-07 : 2015�⵵ �ϵ��ްŷ� ����������� ������ġ �Է� ���� - �̼���������� ��� */
	%>
	<%//if(  sTmpPMS.equals("T") || ckSSOcvno.equals("1081") ) {%>
	<%if( currentYear>=2013 && centername.substring(0,2).equals(sTmpCName.substring(0,2)) && deptname.equals(sTmpDeptName) || sTmpPMS.equals("T") || sTmpPMS.equals("M") ) {%>
	<%//if(  sTmpPMS.equals("T") || ( currentYear>=2015 && ckSSOcvno.equals("0796")) ) {%>
	content+="		<li class='fl'><a href=javascript:top.conf(<%=moneygesu%>) class='sbutton'>������ġ ���</a></li>";
	top.document.getElementById("divView").innerHTML = content;
</script>