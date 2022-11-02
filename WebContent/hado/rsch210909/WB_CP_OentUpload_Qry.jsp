<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_CP_OentUpload_Qry.jsp
* ���α׷�����		: ������ڸ�� ���ε�
* ���α׷�����		: 1.0.0-2015
* �����ۼ�����		: 2015�� 07�� 23��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2015-07-23	������       �����ۼ�
*/
%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="/Include/WB_Inc_Global.jsp"%>
<%@ include file="/Include/WB_Inc_chkSession.jsp"%>

<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%
/*---------------------------------------- Variable Difinition ----------------------------------------*/

	int maxPostSize = 100 * 1024 * 1024;

	ConnectionResource resource		= null;
	Connection conn					= null;
	PreparedStatement pstmt			= null;
	ResultSet rs					= null;
	ConnectionResource2 resource2	= null;
	Connection conn2				= null;
	
	

	String fileInput		= "";
	String fileName			= "";
	String type				= "";
	File fileObj			= null;
	String originFileName	= "";
	String fileExtend		= "";
	String fileSize			= "";
	String sSQLs			= "";
	String sSQLs1			= "";
	String sSQLs2			= "";
	String uploadAction		= "F";
	String saveDirectory	= "";

	boolean bIOException = false;
	
	saveDirectory = config.getServletContext().getRealPath("/upload/2020");

	try {
		MultipartRequest multi = new MultipartRequest(request, saveDirectory, maxPostSize, "euc-kr",new DefaultFileRenamePolicy());
		Enumeration formNames	= multi.getFileNames();

	/*=================================== Record Processing ===============================================*/
		while(formNames.hasMoreElements()) {
			fileInput	= (String)formNames.nextElement();
			fileName	= multi.getFilesystemName(fileInput);
			if(fileName != null) {
				type			= multi.getContentType(fileInput);
				fileObj			= multi.getFile(fileInput);
				originFileName	= multi.getOriginalFileName(fileInput);
				fileExtend		= fileName.substring(fileName.lastIndexOf(".")+1);
				fileSize		= String.valueOf(fileObj.length());
			}
		}
	} catch(IOException e) {
		//e.printStackTrace();
		bIOException = true;
	}

	
	if( !bIOException ) {	// **** ���Ͼ��ε尡 ���������� �Ϸ�Ǿ������� ���� ����
		// �������ϸ� ���ε带 ����Ѵ�.
		if( fileExtend.equals("XLS") || fileExtend.equals("XLSX") || fileExtend.equals("xls") || fileExtend.equals("xlsx") ) {
			uploadAction = "T";
		} else {
			if(fileName != null) {
				String filePath = saveDirectory + "/" + fileName;
				File f			= new File(filePath);
				if( f.exists() )  {
					f.delete();
				}
			}
		}

		if( uploadAction.equals("T") ) {
			if(fileName != null) {

				sSQLs="DELETE FROM hado_tb_subcon_oent_file \n";
				sSQLs+="WHERE RTRIM(Mng_No)=? \n";
				sSQLs+="AND Current_Year=? \n";
				sSQLs+="AND Oent_GB=? \n";

				try {
					resource2 = new ConnectionResource2();
					conn2 = resource2.getConnection();

					pstmt = conn2.prepareStatement(sSQLs);
					pstmt.setString(1, ckMngNo);
					pstmt.setString(2, ckCurrentYear);
					pstmt.setString(3, ckOentGB);

					int updateCNT	= pstmt.executeUpdate();
				} catch(Exception e){
					e.printStackTrace();
				} finally {
					if ( rs != null )		try{rs.close();}	catch(Exception e){}
					if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
					if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
					if ( resource2 != null ) resource2.release();
				}

				sSQLs1="Mng_No";
				sSQLs2="'"+ckMngNo+"'";
				sSQLs1+=", Current_Year";
				sSQLs2+=", '"+ckCurrentYear+"'";
				sSQLs1+=", oent_gb";
				sSQLs2+=", '"+ckOentGB+"'";
				sSQLs1+=", oent_file";
				sSQLs2+=", '"+fileName+"'";
				sSQLs1+=", oent_file_size";
				sSQLs2+=","+fileSize;
				
				sSQLs="INSERT INTO hado_tb_subcon_oent_file ("+sSQLs1+") VALUES ("+sSQLs2+")";
				
				try {
					resource2		= new ConnectionResource2();
					conn2			= resource2.getConnection();
					pstmt			= conn2.prepareStatement(sSQLs);
					int updateCNT	= pstmt.executeUpdate();
				} catch(Exception e){
					e.printStackTrace();
				} finally {
					if ( rs != null )		try{rs.close();}	catch(Exception e){}
					if ( pstmt != null )	try{pstmt.close();}	catch(Exception e){}
					if ( conn2 != null )	try{conn2.close();}	catch(Exception e){}
					if ( resource2 != null ) resource2.release();
				}
			}
		}
	}	// **** ���Ͼ��ε尡 ���������� �Ϸ�Ǿ������� ����  ��
%>

<html>
<head>
	<title>���ε�</title>
	<link href="/Include/common.css" rel="stylesheet" type="text/css" />
<%
	if( bIOException ) {%>
		<script type="text/javascript">
			alert("���ε��� ����ڰ� ������ �ߴ��Ͽ��ų�, ������ �д��� ������ �߻��Ͽ����ϴ�.\n���ε��� ���ΰ�ħ(F5)�� �Ұ�� ������ �ߴܵ˴ϴ�.\n\n�ٽ� ���ε带 ������ �ּ���.");
			//parent.top.opener.location.reload();
			self.close();
		</script>
<%
	} else {
		if( uploadAction.equals("T") ) {%>
			<script type="text/javascript">
				//parent.top.opener.location.reload();
				var fileName = "<%=fileName%>";
				var content = "<a href='WB_CP_OentFile_Down.jsp' target='ProceFrame'>"+fileName+"</a>";
				parent.opener.top.document.getElementById("oentuploadlink").innerHTML = content;
				self.close();
			</script>
<%
		} else {%>
			<script type="text/javascript">
				alert("������� �ʴ� ���������Դϴ�.\n���ε��ϴ� ������ Ȯ���Ͻ� �� �ٽ� �õ��� �ּ���.");
				location.href = "WB_VP_OentFile_Up.jsp":
			</script>
<%
		}
	}
%>
</head>
<body>

</body>
</html>

