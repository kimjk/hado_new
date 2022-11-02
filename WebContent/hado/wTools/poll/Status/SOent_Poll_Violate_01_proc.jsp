<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>

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
/*  3. ���� : 2009�� 5��																			   */
/*  4. �����ۼ��� �� ���� : (��)��Ƽ������ ������ / 2011-10-18										   */
/*  5. ������Ʈ���� (���� / ����)																	   */
/*  6. ���																							   */
/*		1) �������� ������ / 2011-10-18																   */
/*-----------------------------------------------------------------------------------------------------*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String tt=StringUtil.checkNull(request.getParameter("tt"));
	String comm=StringUtil.checkNull(request.getParameter("comm"));

	ConnectionResource resource=null;
	Connection conn=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	
	String sCYear=st_Current_Year;
	String sSQLs="";
	String tmpStr="";

	String[][] arrData=new String[51][6];
	float[] arrSum=new float[4];

	int nLoop=1;

	int sStartYear=2015;

	java.util.Calendar cal=java.util.Calendar.getInstance();

	DecimalFormat formater=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
	String tmpYear=StringUtil.checkNull(request.getParameter("cyear")).trim();
	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
	}
	
	int currentYear=st_Current_Year_n;
	currentYear=Integer.parseInt(session.getAttribute("cyear")+"");

	if( tt.equals("start") ) {
		session.setAttribute("wgb", "1");
	}

	if( comm.equals("search") ) {
		session.setAttribute("wgb", StringUtil.checkNull(request.getParameter("wgb")).trim());
	}

	int endCurrentYear=st_Current_Year_n;
	
	// �հ�迭 �ʱ�ȭ
	for(int i=1; i <=6; i++) { arrSum[i]=0F; }
	
	int currentYear=st_Current_Year_n;
	currentYear=Integer.parseInt(session.getAttribute("cyear")+"");

	int endCurrentYear=st_Current_Year_n;

	String currentOent = "HADO_TB_Oent";
	if( currentYear>2011 ) {
		currentOent = "HADO_TB_Oent_"+currentYear;
	}
	
	try {
		resource=new ConnectionResource();
		conn=resource.getConnection();

		if( !tt.equals("start") ) {

			sSQLs="SELECT A.Oent_gb, \n";
			sSQLs+="    NVL(COUNT(Mng_No),0) Field01, \n";
			sSQLs+="    SUM(CASE A.A WHEN '1' THEN 1 ELSE 0 END) AS Field02, \n";
			sSQLs+="    SUM(CASE A.B WHEN '1' THEN 1 ELSE 0 END) AS Field03, \n";
			sSQLs+="    SUM(CASE A.C WHEN '1' THEN 1 ELSE 0 END) AS Field04, \n";
			sSQLs+="    SUM(CASE A.D WHEN '1' THEN 1 ELSE 0 END) AS Field05, \n";
			sSQLs+="    SUM(CASE A.E WHEN '1' THEN 1 ELSE 0 END) AS Field06 \n";
			sSQLs+="FROM ( \n";
			sSQLs+="    SELECT * FROM hado_tb_soent_answer_add \n";
			sSQLs+="    WHERE current_Year='"+session.getAttribute("cyear")+"' \n";
			if( session.getAttribute("wgb").equals("1") ) {
				sSQLs+="        AND Oent_GB='1' AND soent_Q_CD=1 AND soent_Q_GB=1 \n";
			} else if( session.getAttribute("wgb").equals("2") ) {
				sSQLs+="        AND Oent_GB='2' AND soent_Q_CD=1 AND soent_Q_GB=1 \n";
			} else if( session.getAttribute("wgb").equals("3") ) {
				sSQLs+="        AND Oent_GB='3' AND soent_Q_CD=1 AND soent_Q_GB=1 \n";
			} 
			sSQLs+="        AND LENGTH(Mng_No)>10 \n";
			sSQLs+=") A \n";
			sSQLs+="GROUP BY A.Oent_gb \n";
			sSQLs+="ORDER BY A.Oent_gb \n";

			pstmt=conn.prepareStatement(sSQLs);
			rs=pstmt.executeQuery();
			
			nLoop=1;
			while( rs.next() ) {
				arrData[nLoop][7] = rs.getString("Oent_gb");
				arrData[nLoop][1] = rs.getString("Field01");
				arrData[nLoop][2] = rs.getString("Field02");
				arrData[nLoop][3] = rs.getString("Field03");
				arrData[nLoop][4] = rs.getString("Field04");
				arrData[nLoop][5] = rs.getString("Field05");
				arrData[nLoop][6] = rs.getString("Field06");

				for(int i=1; i<=6; i++) {
					arrSum[i] = arrSum[i] + Float.parseFloat(arrData[nLoop][i]);
				}

				nLoop++;
			}
			rs.close();
			nLoop--;
		}
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if(rs!=null)		try{rs.close();}	catch(Exception e){}
		if(pstmt!=null)		try{pstmt.close();}	catch(Exception e){}
		if(conn!=null)		try{conn.close();}	catch(Exception e){}
		if(resource!=null)	resource.release();
	}
%>

<script language="javascript">
content="";
content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th rowspan='2'>����</th>";
content+="		<th rowspan='2'>�����ü��</th>";
content+="		<th colspan='5'>3�� ���ع�� ������ ������� Ȯ������� ���� </th>";
content+="  </tr>";
content+="	<tr>";
content+="		<th>��. �� �˰� ����</th>";
content+="		<th>��. ��ü�� �˰� ����</th>";
content+="		<th>��. �ణ �˰� ����</th>";
content+="		<th>��. �� ��</th>";
content+="		<th>��. ���� ��</th>";
content+="  </tr>";

<%if( !tt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan='2'>��</th>";
content+="		<th rowspan='2'><%=formater2.format(arrSum[1])%></th>";
	<%for(int i=2; i<=6; i++) {%>
content+="		<td><%=formater2.format(arrSum[i])%></td>";
	<%}%>
content+="	</tr>";

content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for(int i=2; i<=6; i++) {%>	
		<%if( arrSum[1] > 0F) {%>
content+="		<td><%=formater.format(arrSum[i] / arrSum[1] * 100F)%>%</td>";
		<%} else {%>
content+="		<td>0.0%</td>";
		<%}%>
	<%}%>
content+="	</tr>";

	<%for(int ni=1; ni<=nLoop; ni++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
		<%if( !session.getAttribute("wgb").equals("") ) {%>	
content+="		<th rowspan='2'><%=arrData[ni][7]%></th>";
		<%} else {%>
				<%if( arrData[ni][7].equals("1") ) {%>		
content+="		<th rowspan='2'>����</th>";
				<%} else if( arrData[ni][7].equals("2") ) {%>
content+="		<th rowspan='2'>�Ǽ�</th>";
				<%} else if( arrData[ni][7].equals("3") ) {%>								
content+="		<th rowspan='2'>�뿪</th>";
				<%}
		}%>
content+="		<th rowspan='2'><%=formater2.format(Float.parseFloat(arrData[ni][1]))%></th>";
		<%for(int i=2; i<=6; i++) {%>
content+="		<td><%=formater2.format(Float.parseFloat(arrData[ni][i]))%></td>";
		<%}%>
content+="	</tr>";

content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
		<%for(int i=2; i<=6; i++) {%>
			<%if( Float.parseFloat(arrData[ni][1]) > 0F) {%>
content+="		<td><%=formater.format(Float.parseFloat(arrData[ni][i]) / Float.parseFloat(arrData[ni][1]) * 100F)%>%</td>";
			<%} else {%>
content+="		<td>0.0%</td>";
			<%}%>
		<%}%>
content+="	</tr>";

	<%}%>
<%} else {%>
content+="	<tr>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="		<td>&nbsp;</td>";
content+="	</tr>";
<%}%>
content+="</table>";

top.document.getElementById("divResult").innerHTML=content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>