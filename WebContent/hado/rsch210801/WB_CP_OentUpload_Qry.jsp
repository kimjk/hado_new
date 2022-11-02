<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/**
* 프로젝트명		: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_CP_OentUpload_Qry.jsp
* 프로그램설명		: 원사업자명부 업로드
* 프로그램버전		: 1.0.0-2015
* 최초작성일자		: 2015년 07월 23일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2015-07-23	정광식       최초작성
*/
%>
<%@ page import="java.io.*"%>
<%//@ page import="java.util.regex.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%@ page import="ftc.db.ConnectionResource"%>
<%@ page import="ftc.db.ConnectionResource2"%>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<%@ include file="../Include/WB_Inc_chkSession.jsp"%>

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
	
	saveDirectory = config.getServletContext().getRealPath("/upload/2021");

	try {
		MultipartRequest multi = new MultipartRequest(request, saveDirectory, maxPostSize, "utf-8",new DefaultFileRenamePolicy());
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

	
	if( !bIOException ) {	// **** 파일업로드가 정상적으로 완료되었을때만 실행 시작
		// 엑셀파일만 업로드를 허용한다.
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
	}	// **** 파일업로드가 정상적으로 완료되었을때만 실행  끝
%>

<html>
<head>
	<title>업로드</title>
	<link href="/Include/common.css" rel="stylesheet" type="text/css" />
<%
	if( bIOException ) {%>
		<script type="text/javascript">
			alert("업로드중 사용자가 전송을 중단하였거나, 파일을 읽는중 오류가 발생하였습니다.\n업로드중 새로고침(F5)을 할경우 전송이 중단됩니다.\n\n다시 업로드를 실행해 주세요.");
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
				alert("허용하지 않는 파일형식입니다.\n업로드하는 파일을 확인하신 후 다시 시도해 주세요.");
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

