<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="/hado/wTools/inc/WB_I_Global.jsp"%>
<%@ include file="/hado/wTools/inc/WB_I_chkMngSession.jsp"%>

<%@ page import="java.text.DecimalFormat"%>

<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. ������Ʈ�� : ������������ȸ �ϵ��ްŷ� �������ǽ�������					                       */
/*  2. ��ü���� :																					   */
/*     - ��ü�� : (��)��Ƽ������																	   */
/*	   - Project Manamger : ������ ���� (pcxman99@naver.com)										   */
/*     - ����ó : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  3. ���� : 2012�� 7��																			   */
/*  4. �����ۼ��� �� ���� : (��)��Ƽ������ ����ȣ / 2012-07-03										   */
/*  5. ������Ʈ���� (���� / ����)																	   */
/*-----------------------------------------------------------------------------------------------------*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/
	
	// �������������߰� // 20100503 / ������
	ArrayList arrDamCenter = new ArrayList();
	ArrayList arrUserName = new ArrayList();
	ArrayList arrDeptName = new ArrayList();
	ArrayList arrCVSNo = new ArrayList();

	// ���� �����迭
	ArrayList arrDCode = new ArrayList();
	ArrayList arrDName = new ArrayList();
	// �Ǽ� �����迭
	ArrayList arrCCode = new ArrayList();
	ArrayList arrCName = new ArrayList();
	// �뿪 �����迭
	ArrayList arrSrvCode = new ArrayList();
	ArrayList arrSrvName = new ArrayList();
	// ����� �迭
	ArrayList arrDeptSeq = new ArrayList();
	ArrayList arrDeptCode = new ArrayList();
	ArrayList arrDamName = new ArrayList();


	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	int sStartYear = 2009;

	int i = 0;
	int gesu = 0;

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,###");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/

	int currentYear = st_Current_Year_n;
	
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		
		// ���� ���� �迭 ����
		StringBuffer sbSQLs1 = new StringBuffer();

		sbSQLs1.append("SELECT COMMON_CD, COMMON_NM \n");
		sbSQLs1.append("FROM COMMON_CD \n");
		sbSQLs1.append("WHERE ADDON_GB=?");
		
		pstmt = conn.prepareStatement(sbSQLs1.toString());
		pstmt.setString(1,"1");
		rs = pstmt.executeQuery();

		while (rs.next()) {
			arrDCode.add(StringUtil.checkNull(rs.getString("COMMON_CD")).trim());
			arrDName.add(new String( StringUtil.checkNull(rs.getString("COMMON_NM")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
		}
		rs.close();


		// �Ǽ� ���� �迭 ����
		pstmt = conn.prepareStatement(sbSQLs1.toString());
		pstmt.setString(1,"2");
		rs = pstmt.executeQuery(); 
	
		while (rs.next()) {
			arrCCode.add(StringUtil.checkNull(rs.getString("COMMON_CD")).trim());
			arrCName.add(new String( StringUtil.checkNull(rs.getString("COMMON_NM")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
		}
		rs.close();

		// �뿪 ���� �迭 ����
		pstmt = conn.prepareStatement(sbSQLs1.toString());
		pstmt.setString(1,"3");
		rs = pstmt.executeQuery();	  

		while (rs.next()) {
			arrSrvCode.add(StringUtil.checkNull(rs.getString("COMMON_CD")).trim());
			arrSrvName.add(new String(StringUtil.checkNull(rs.getString("COMMON_NM")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
		}
		rs.close();


		// 2010�� ����� ���� ��� ���� (HADO_TB_DEPT_HISTORY)
		StringBuffer sbSQLs2 = new StringBuffer();
		if( st_Current_Year_n>= 2010) {
			sbSQLs2.append("SELECT CVSNO DEPT_SEQ, Center_Name,User_Name \n");
			sbSQLs2.append("FROM HADO_TB_DEPT_HISTORY \n");
			sbSQLs2.append("WHERE Current_Year=? \n");
			sbSQLs2.append("GROUP BY CVSNO, Center_Name, User_Name \n");
			sbSQLs2.append("ORDER BY Center_Name, User_Name");
		} else {
			// ����ں� �迭 ����
			sbSQLs2.append("SELECT DEPT_SEQ, CENTER_NAME, USER_NAME FROM HADO_TB_FTC_USER \n");
			sbSQLs2.append("ORDER BY CENTER_NAME, USER_NAME");
		}

		pstmt = conn.prepareStatement(sbSQLs2.toString());
		if( st_Current_Year_n>= 2010) {
			pstmt.setString(1,st_Current_Year);
		}
		rs = pstmt.executeQuery();

		while(rs.next()) {
			arrDeptSeq.add(StringUtil.checkNull(rs.getString("DEPT_SEQ")).trim());
			arrDeptCode.add(selDeptCode(new String(StringUtil.checkNull(rs.getString("CENTER_NAME")).trim().getBytes("ISO8859-1"), "EUC-KR" )));
			arrDamName.add(new String( StringUtil.checkNull(rs.getString("USER_NAME")).trim().getBytes("ISO8859-1"), "EUC-KR" ));
		}
		rs.close();
	}
	catch(Exception e){
		e.printStackTrace();
	}
	finally {
		if ( rs != null ) try{rs.close();}catch(Exception e){}
		if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
		if ( conn != null ) try{conn.close();}catch(Exception e){}
		if ( resource != null ) resource.release();
	}
/*=====================================================================================================*/
%>
<%!
	public String selDeptCode(String str){
		String sReturnStr = "";
		
		if(str.equals("����繫��") || str.equals("���� �繫��") ){
			sReturnStr = "S";
		}else if(str.equals("�뱸�繫��") || str.equals("�뱸 �繫��")){
			sReturnStr = "K";
		}else if(str.equals("�����繫��") || str.equals("���� �繫��")){
			sReturnStr = "J";
		}else if(str.equals("���ֻ繫��") || str.equals("���� �繫��")){
			sReturnStr = "G";
		}else if(str.equals("�λ�繫��") || str.equals("�λ� �繫��") ){
			sReturnStr = "B";
		}else{
			sReturnStr = "H";
		}
		
		return sReturnStr ;
	}
%>

<html>
<head>
	<link rel="stylesheet" href="/hado/hado/wTools/style.css" type="text/css">
</head>
<script language="javascript" type="text/javascript" src="/hado/hado/wTools/inc/jquery.js"></script>
<script language="JavaScript">
	function goSearch() {
		$.ajax({
			//type: 'post',
			//url: 'Paper_List.jsp',
			//cache: false,
			//data: $('#searchform').serialize(),
			//async: false,
			//dataType: function(data) {
			//	$('divResult').html(data);
			//},
			url: './Paper_Stat_Proc.jsp',
			data: $('#searchform').serialize(),
			dataType : "HTML",
			success  : function(data) {
				$('#divResult').html(data);
			}			
		});

	}
</script>

<body>
	<div id="ajax_ready" style="position:absolute;top:1px;left:1px;width:60px;height:60px;display:none;z-index:99;"><img src="/hado/hado/wTools/img/ajax_ani.gif" border="0"></div>
	<div id="ajax_bg" style="position:absolute;top:1px;left:1px;display:none;background:url(/hado/hado/wTools/img/ajax_bg.gif);z-index:51;"></div>

	<div id="container">
		<!-- Begin Header -->
		<%@ include file="/hado/wTools/inc/WB_I_pageTop.jsp"%>
		<!-- End Header -->
		
		<!-- Begin Main-menu -->
		<jsp:include page="/hado/wTools/inc/WB_I_topMenu.jsp">
		<jsp:param value="04" name="sel"/>
		</jsp:include>
		<!-- End Main-menu -->

		<!-- Begin Contents -->
		<div id="wrapper">
			<div id="contents">
				<!-- Begin Left-menu -->
				<jsp:include page="/hado/wTools/inc/WB_I_Correct_LMenu.jsp">
				<jsp:param value="006" name="sel"/>
				</jsp:include>
				<!-- End Left-menu -->

				<div id="divContent">

					<div id="searchContent">
						<li class="subtitle">����̹߱� �Է���Ȳ</li>
						<li class="whereiam">HOME > ������ġ > ����̹߱� > ����̹߱� �Է���Ȳ</li>
						<p></p>
					</div>
					
					<div class="searchbox" id="searchbox">
						<table class="searchboxtable">
						<form id="searchform" name="searchform" method="POST">
							<tr>
								<th>����⵵</th>
								<td>
									<select name="cyear">
										<option value="2011">2011</option>
										<option value="2012">2012</option>
									</select>
								</td>
							</tr>
						</form>
						</table>
					</div>

					<div id="divButton">
						<ul class="lt">
							<li class="fr" id="divSrchWindow"><a href="javascript:divSearchWin();" class="sbutton">�˻�â ������</a></li>
							<li class="fr"><a href="javascript:document.searchform.reset();" class="sbutton">�˻� �ʱ�ȭ</a></li>
							<li class="fr"><a href="javascript:goSearch();" class="sbutton">�� ��</a></li>
						</ul>
					</div>

					<div id="divResult"></div>
					<div id="divView" onMouseDown="f_DragMDown(this)"></div>
					<div id="divViewInfo1" onMouseDown="f_DragMDown(this)"></div>
					<div id="divViewInfo2" onMouseDown="f_DragMDown(this)"></div>
					<div id="divViewInfo3" onMouseDown="f_DragMDown(this)"></div>
				</div>
			</div>
		</div>
		<!-- End Contents -->

		<!-- Begin Footer -->
		<%@ include file="/hado/wTools/inc/WB_I_Copyright.jsp"%>
		<!-- End Footer -->
	</div>
</body>
</html>