<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ�� : �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷��� : Oent_Submit_Total_proc.jsp
* ���α׷�����  : ������� > ������Ȳ > ��ü ������Ȳ
* ���α׷�����  : 1.0.1
* �����ۼ�����  : 2009�� 05��
* �� �� �� ��       :
*=========================================================
* �ۼ�����    �ۼ��ڸ�        ����
*=========================================================
* 2009-05-00  ������       �����ۼ�
* 2015-07-21  ������       ������ ������Ȳ ��� �� ���� ���� ���� ��µǵ��� SQL�� ����
* 2016-01-08  ������   DB�������� ���� ���ڵ� ����
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
  String stt = StringUtil.checkNull(request.getParameter("tt")).trim();
  String comm = StringUtil.checkNull(request.getParameter("comm")).trim();

  ConnectionResource resource = null;
  Connection conn = null;
  PreparedStatement pstmt = null;
  ResultSet rs = null;

  String sCYear = st_Current_Year;
  String sSQLs = "";

  String deptName = "";
  String mngNoCnt = "";
  String fileCnt = ""; 
  String cntAvg = ""; 
  
  String type1 = "";
  String type2 = "";
  String type3 = "";
  String type4 = "";
  
  String result = "";
  
  java.util.Calendar cal = java.util.Calendar.getInstance();

  DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.00");
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/
  String tmpYear = StringUtil.checkNull(request.getParameter("cyear")).trim();

  if( !tmpYear.equals("") ) {
    session.setAttribute("cyear", tmpYear);
  } else {
    session.setAttribute("cyear", st_Current_Year);
  }

  int currentYear = st_Current_Year_n;

  currentYear = Integer.parseInt(session.getAttribute("cyear")+"");

    try {
    resource = new ConnectionResource();
    conn = resource.getConnection();
            
            sSQLs =  "SELECT DECODE(T.DEPT_NAME, NULL, '      ��ü', T.DEPT_NAME) AS DEPT_NAME                                                            \n";            
            sSQLs += "       ,SUM(T.MNG_NO_CNT) AS MNG_NO_CNT                                                                                            \n";
            sSQLs += "       ,SUM(T.FILE_CNT) AS FILE_CNT                                                                                                \n";
            sSQLs += "       ,TO_CHAR(TRUNC((SUM(T.FILE_CNT)/SUM(T.MNG_NO_CNT)*100), 2), 'FM999990.00') AS CNT_AVG                                       \n";
            sSQLs += "       ,SUM(T.CORRECT_TYP_1) AS CORRECT_TYP_1                                                                                      \n";
            sSQLs += "       ,SUM(T.CORRECT_TYP_2) AS CORRECT_TYP_2                                                                                      \n";
            sSQLs += "       ,SUM(T.CORRECT_TYP_3) AS CORRECT_TYP_3                                                                                      \n";
            sSQLs += "       ,SUM(T.CORRECT_TYP_4) AS CORRECT_TYP_4                                                                                      \n";
            sSQLs += "  FROM (SELECT ROWNUM AS RNUM                                                                                                      \n";
            sSQLs += "                ,T1.*                                                                                                              \n";
            sSQLs += "          FROM (SELECT A.DEPT_NAME AS DEPT_NAME                                                                                    \n";
            sSQLs += "                       ,COUNT(A.MNG_NO) AS MNG_NO_CNT                                                                              \n";
            sSQLs += "                       ,(SELECT COUNT(MAX(F.MNG_NO)) AS CNT                                                                        \n";
            sSQLs += "                          FROM HADO_TB_SELFCORRECTION A1,                                                                          \n";
            sSQLs += "                               HADO_TB_OENT_SELFCORREC_FILE F                                                                      \n";
            sSQLs += "                          WHERE A1.MNG_NO = F.MNG_NO                                                                               \n";
            sSQLs += "                            AND A1.OENT_GB = F.OENT_GB                                                                             \n";
            sSQLs += "                            AND A1.DEPT_NAME = A.DEPT_NAME                                                                         \n";
            sSQLs += "                          GROUP BY F.MNG_NO) AS FILE_CNT                                                                           \n";
            sSQLs += "                       ,NVL((SELECT COUNT(NVL(CT.CORRECT_TYP, 0)) AS CORRECT_TYP                                                   \n";
            sSQLs += "                             FROM HADO_VT_SURVEY_CTX CT                                                                            \n";
            sSQLs += "                            WHERE CT.MNG_NO IN (SELECT SC.MNG_NO FROM HADO_TB_SELFCORRECTION SC WHERE SC.DEPT_NAME = A.DEPT_NAME)  \n";
            sSQLs += "                              AND CT.CORRECT_TYP = '1'                                                                             \n";
            sSQLs += "                              AND CT.CURRENT_YEAR = '"+currentYear+"'                                                              \n";
            sSQLs += "                            ), 0) AS CORRECT_TYP_1                                                                                 \n";
            sSQLs += "                       ,NVL((SELECT COUNT(NVL(CT.CORRECT_TYP, 0)) AS CORRECT_TYP                                                   \n";
            sSQLs += "                             FROM HADO_VT_SURVEY_CTX CT                                                                            \n";
            sSQLs += "                            WHERE CT.MNG_NO IN (SELECT SC.MNG_NO FROM HADO_TB_SELFCORRECTION SC WHERE SC.DEPT_NAME = A.DEPT_NAME)  \n";
            sSQLs += "                              AND CT.CORRECT_TYP = '2'                                                                             \n";
            sSQLs += "                              AND CT.CURRENT_YEAR = '"+currentYear+"'                                                              \n";
            sSQLs += "                            ), 0) AS CORRECT_TYP_2                                                                                 \n";
            sSQLs += "                       ,NVL((SELECT COUNT(NVL(CT.CORRECT_TYP, 0)) AS CORRECT_TYP                                                   \n";
            sSQLs += "                             FROM HADO_VT_SURVEY_CTX CT                                                                            \n";
            sSQLs += "                            WHERE CT.MNG_NO IN (SELECT SC.MNG_NO FROM HADO_TB_SELFCORRECTION SC WHERE SC.DEPT_NAME = A.DEPT_NAME)  \n";
            sSQLs += "                              AND CT.CORRECT_TYP = '3'                                                                             \n";
            sSQLs += "                              AND CT.CURRENT_YEAR = '"+currentYear+"'                                                              \n";
            sSQLs += "                            ), 0) AS CORRECT_TYP_3                                                                                 \n"; 
            sSQLs += "                       ,NVL((SELECT COUNT(NVL(CT.CORRECT_TYP, 0)) AS CORRECT_TYP                                                   \n";
            sSQLs += "                             FROM HADO_VT_SURVEY_CTX CT                                                                            \n";
            sSQLs += "                            WHERE CT.MNG_NO IN (SELECT SC.MNG_NO FROM HADO_TB_SELFCORRECTION SC WHERE SC.DEPT_NAME = A.DEPT_NAME)  \n";
            sSQLs += "                              AND CT.CORRECT_TYP = '4'                                                                             \n";
            sSQLs += "                              AND CT.CURRENT_YEAR = '"+currentYear+"'                                                              \n";
            sSQLs += "                            ), 0) AS CORRECT_TYP_4                                                                                 \n";
            sSQLs += "                   FROM HADO_TB_SELFCORRECTION A                                                                                   \n";
            sSQLs += "                    WHERE A.CURRENT_YEAR = '"+currentYear+"'                                                                       \n";
            sSQLs += "                  GROUP BY A.DEPT_NAME                                                                                             \n";
            sSQLs += "                ) T1                                                                                                               \n";
            sSQLs += "         ) T                                                                                                                       \n";
            sSQLs += "  GROUP BY ROLLUP(T.DEPT_NAME)                                                                                                     \n";
            sSQLs += "  ORDER BY (CASE WHEN T.DEPT_NAME IS NULL THEN 0 ELSE MAX(T.RNUM) END)                                                             \n";

     // System.out.println(sSQLs);  
      pstmt = conn.prepareStatement(sSQLs);
      rs = pstmt.executeQuery();

      while( rs.next() ) {

                deptName = rs.getString("DEPT_NAME")==null ? "":rs.getString("DEPT_NAME").trim();
                mngNoCnt = rs.getString("MNG_NO_CNT")==null ? "":rs.getString("MNG_NO_CNT").trim();
                fileCnt = rs.getString("FILE_CNT")==null ? "":rs.getString("FILE_CNT").trim();
                cntAvg = rs.getString("CNT_AVG")==null ? "":rs.getString("CNT_AVG").trim();
                type1 = rs.getString("CORRECT_TYP_1")==null ? "":rs.getString("CORRECT_TYP_1").trim();
                type2 = rs.getString("CORRECT_TYP_2")==null ? "":rs.getString("CORRECT_TYP_2").trim();
                type3 = rs.getString("CORRECT_TYP_3")==null ? "":rs.getString("CORRECT_TYP_3").trim();
                type4 = rs.getString("CORRECT_TYP_4")==null ? "":rs.getString("CORRECT_TYP_4").trim();
            
                result += "<tr>";
                result += "<td>"+deptName+"</td>";
                result += "<td>"+mngNoCnt+"</td>";
                result += "<td>"+fileCnt+"</td>";
                result += "<td>"+cntAvg+"</td>";
                result += "<td>"+type1+"</td>";
                result += "<td>"+type2+"</td>";
                result += "<td>"+type3+"</td>";
                result += "<td>"+type4+"</td>";
                result +="</tr>";
      } 
    //  System.out.println("result ==> " + result);
      rs.close();
  }catch(Exception e){
    e.printStackTrace();
  }finally {
    if ( rs != null ) try{rs.close();}catch(Exception e){}
    if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
    if ( conn != null ) try{conn.close();}catch(Exception e){}
    if ( resource != null ) resource.release();
  }

/*=====================================================================================================*/
%>

<meta charset="utf-8">
<script type="text/javascript">
//<![CDATA[
content = "";

content+="<table id='divButton'>";
content+="  <tr>";
content+="    <td><%=cal.get(Calendar.YEAR)%>��<%=cal.get(Calendar.MONTH)+1%>��<%=cal.get(Calendar.DATE)%>��(����)</td>";
content+="  </tr>";
content+="</table>";

content+="<table class='resultTable'>";
content+="  <tr>";
content+="    <th height=40px width=80px></th>";
content+="    <th>�������� ����� ��(A)</th>";
content+="    <th>�ڷ� ���� ��ü��(B)</th>";
content+="    <th>�����(B/A)</th>";
content+="    <th>���������Ϸ�</th>";
content+="    <th>�Ϻν���</th>";
content+="    <th>���ι̽���</th>";
content+="    <th>������</th>";
content+="  </tr>";

content+="<%=result%>"; 

content+="</table>";

top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
//]]
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>