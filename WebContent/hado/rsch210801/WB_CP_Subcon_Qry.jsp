<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="../Include/WB_I_Global.jsp"%>
/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String sErrorMsg	= "";						//오류메시지
	String sReturnURL 	= "/index.jsp";				//이동URL(상대주소)
	String qType		= StringUtil.checkNull(request.getParameter("type"));
	String qStep		= StringUtil.checkNull(request.getParameter("step"));

	// 20110923 - KS Jung - 콜센터관리툴 관련 파라메터
	String sMngType		= ""+session.getAttribute("ckMngType");
	// 접속지IP 정보
	String sRemoteIp = request.getRemoteAddr();
/*-----------------------------------------------------------------------------------------------------*/

/*=================================== Record Selection Processing =====================================*/	
	// Cookie Request
	String sMngNo		= ckMngNo;
	String sOentYYYY	= ckCurrentYear;
	String sOentGB		= ckOentGB;
	String sOentName	= ckOentName;
	String sSentNo		= ckSentNo;

	ConnectionResource resource = null;
	Connection conn				= null;
	PreparedStatement pstmt		= null;
	ResultSet rs				= null;

	ConnectionResource2 resource2 = null;
	Connection conn2			= null;

	String sSQLs		= "";
	String sTmp_Area	= "";
	String bexe			= "no";
	int updateCNT		= 0;

	if( ckMngNo.trim().length() > 8 ) {
		sMngNo = ckMngNo.substring(0,8);
	} else if( ckMngNo.trim().length() == 6 ) {
		sMngNo = ckMngNo.substring(0,5);
	} else if ( ckMngNo.trim().length() == 4 ) {
		sMngNo = ckMngNo.substring(0,3);
	}
/*=====================================================================================================*/
// 회사개요
if (qStep.equals("Basic")) {
	// 수정된 회사개요 업데이트
	sSQLs="UPDATE HADO_TB_Subcon_"+sOentYYYY+" SET \n";
	sSQLs+="sent_name='"+StringUtil.checkNull(request.getParameter("rcomp")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", comp_gb='"+StringUtil.checkNull(request.getParameter("rcogb")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", sent_co_no='"+StringUtil.checkNull(request.getParameter("rlawno")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", sent_sa_no='"+StringUtil.checkNull(request.getParameter("rregno")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", sent_captine='"+StringUtil.checkNull(request.getParameter("rowner")).trim().replaceAll("'","''")+"' \n";
	if( (!StringUtil.checkNull(request.getParameter("rpost")).trim().equals(""))) {
		sSQLs+=", zip_code='"+StringUtil.checkNull(request.getParameter("rpost")).trim().replaceAll("'","''")+"' \n";
	} else {
		sSQLs+=", zip_code=null \n";
	}
	sSQLs+=", sent_address='"+StringUtil.checkNull(request.getParameter("raddr")).trim().replaceAll("'","''")+"' \n";
	if( (!StringUtil.checkNull(request.getParameter("remail1")).trim().equals("")) && (!StringUtil.checkNull(request.getParameter("remail2")).trim().equals("")) ) {
		sSQLs+=", assign_mail='"+StringUtil.checkNull(request.getParameter("remail1")).trim().replaceAll("'","''")+"@"+StringUtil.checkNull(request.getParameter("remail2")).trim().replaceAll("'","''")+"' \n";
	} else {
		sSQLs+=", assign_mail=null \n";
	}
	sSQLs+=", writer_org='"+StringUtil.checkNull(request.getParameter("rdept")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", writer_jikwi='"+StringUtil.checkNull(request.getParameter("rposition")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", writer_name='"+StringUtil.checkNull(request.getParameter("rname")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", writer_tel='"+StringUtil.checkNull(request.getParameter("rtel")).trim().replaceAll("'","''")+"' \n";
	sSQLs+=", writer_fax='"+StringUtil.checkNull(request.getParameter("rfax")).trim().replaceAll("'","''")+"' \n";
	/* if( !StringUtil.checkNull(request.getParameter("rsale")).trim().equals("") ) {
		sSQLs+=", sent_sale="+StringUtil.checkNull(request.getParameter("rsale")).trim().replaceAll("'","''").replaceAll(",","")+" \n";
	} else {
		sSQLs+=", sent_sale=0 \n";
	} */
	/* if( !StringUtil.checkNull(request.getParameter("rasset")).trim().equals("") ) {
		sSQLs+=", sent_amt="+StringUtil.checkNull(request.getParameter("rasset")).trim().replaceAll("'","''").replaceAll(",","")+" \n";
	} else {
		sSQLs+=", sent_amt=0 \n";
	} */
	/* if( !StringUtil.checkNull(request.getParameter("rempcnt")).trim().equals("") ) {
		sSQLs+=", sent_emp_cnt="+StringUtil.checkNull(request.getParameter("rempcnt")).trim().replaceAll("'","''").replaceAll(",","")+" \n";
	} else {
		sSQLs+=", sent_emp_cnt=0 \n";
	} */
	/* if (qType.equals("Const")) {
		if( !StringUtil.checkNull(request.getParameter("rconamt")).trim().equals("") ) {
			sSQLs+=", sent_con_amt="+StringUtil.checkNull(request.getParameter("rconamt")).trim().replaceAll("'","''").replaceAll(",","")+" \n";
		} else {
			sSQLs+=", sent_con_amt=0 \n";
		}
		sSQLs+=", con_reg_gb='"+StringUtil.checkNull(request.getParameter("rreggb")).trim().replaceAll("'","''")+"' \n";
		sSQLs+=", con_reg_text='"+StringUtil.checkNull(request.getParameter("rregtext")).trim().replaceAll("'","''")+"' \n";
	} */
	sSQLs+=", remote_ip='" + sRemoteIp + "' \n";
	sSQLs+=", writer_date=sysdate \n";
	// 2015-07-15 / 조사제외대상여부 추가 / 강슬기
	String sSentNoExcept = request.getParameter("rnoexpt")==null ? "":request.getParameter("rnoexpt");
	if( !sSentNoExcept.equals("") ) {
		sSQLs+=",	SP_FLD_03='"+request.getParameter("rnoexpt").trim()+"' \n";	// 조사제외대상여부
	} else {
		sSQLs+=",	SP_FLD_03=NULL \n";
	}

	// 20110923 - KS Jung - 콜센터관리툴 관련 파라메터
	if( sMngType!=null && !sMngType.equals("")) {
		sSQLs+=", Admin_Insert_GB='1' \n";
		sSQLs+=", SP_FLD_02='"+sMngType+"' \n";
	}

	//sSQLs+=" WHERE Mng_No='"+sMngNo+"' \n";
	sSQLs+=" WHERE Child_Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";

	//System.out.println(sSQLs);

	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
		System.out.println("is Error SQL : "+sSQLs);
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}

	// 하도급법이 적용되지 않는 사유 저장
	if(!StringUtil.checkNull(request.getParameter("reason")).trim().equals("")) {
		// 기존 답변 삭제
		sSQLs="DELETE FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
		sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";
		sSQLs+="AND SOENT_Q_CD=30 AND SOENT_Q_GB=1 \n";
	
		try {
			resource2	= new ConnectionResource2();
			conn2		= resource2.getConnection();
			//System.out.println("delete : "+sSQLs+ "\n");
			pstmt		= conn2.prepareStatement(sSQLs);
			updateCNT	= pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			System.out.println("is ORA-00942 at reason_delete1? : "+sSQLs);
		} finally {
			if (rs != null)		try{rs.close();}	catch(Exception e){}
			if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
			if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
			if (resource2 != null) resource2.release();
		}

		// 새 답변 저장
		String temp = StringUtil.checkNull(request.getParameter("reason")).trim().replaceAll("'","''");

		sSQLs="INSERT INTO HADO_TB_SOENT_ANSWER_"+sOentYYYY+" (  \n";
		sSQLs+="MNG_NO, CURRENT_YEAR, OENT_GB, SENT_NO,SOENT_Q_CD, SOENT_Q_GB, SUBJ_ANS ) VALUES ( \n";
		sSQLs+="'"+ckMngNo+"', '"+sOentYYYY+"', '"+sOentGB+"', "+sSentNo+", 30, 1, '"+temp+"') \n";
		//sSQLs="UPDATE HADO_TB_SOENT_ANSWER SET MNG_NO='"+ckMngNo+"', CURRENT_YEAR='"+sOentYYYY+
		//		"', OENT_GB='"+sOentGB+"', SENT_NO="+sSentNo+", SOENT_Q_CD=30, SOENT_Q_GB=1 "+
		//		", SUBJ_ANS='"+temp+"'";
			
		try {
			resource2	= new ConnectionResource2();
			conn2		= resource2.getConnection();
			//System.out.println("update : "+sSQLs+"\n");
			pstmt		= conn2.prepareStatement(sSQLs);
			updateCNT	= pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			System.out.println("is ORA-00942 at reason_save? : "+sSQLs);
		} finally {
			if (rs != null)		try{rs.close();}	catch(Exception e){}
			if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
			if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
			if (resource2 != null) resource2.release();
		}
	} else {
		// 기존 답변 삭제
		sSQLs="DELETE FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
		sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
		sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
		sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
		sSQLs+="AND Sent_No="+sSentNo+" \n";
		sSQLs+="AND SOENT_Q_CD=30 AND SOENT_Q_GB=1 \n";
	
		try {
			resource2	= new ConnectionResource2();
			conn2		= resource2.getConnection();
			//System.out.println("delete : "+sSQLs+ "\n");
			pstmt		= conn2.prepareStatement(sSQLs);
			updateCNT	= pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
			System.out.println("is ORA-00942 at reason_delete2? : "+sSQLs);
		} finally {
			if (rs != null)		try{rs.close();}	catch(Exception e){}
			if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
			if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
			if (resource2 != null) resource2.release();
		}
	}
	sReturnURL	= "WB_VP_Subcon_0" + sOentGB+"_02.jsp?isSaved=1";

/*=====================================================================================================*/	
// 하도급 거래현황
} else if (qStep.equals("Detail")) {
	// 기존 답변 삭제
	sSQLs="DELETE FROM HADO_TB_SOENT_ANSWER_"+sOentYYYY+" \n";
	sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";
	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();
		e.printStackTrace();
		System.out.println("is ORA-00942 03_answer_delete? : "+sSQLs);
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}	
	// 배열 초기화
	for(int ni = 1; ni < 35; ni++) {
		for(int nj = 1; nj < 40; nj++) {
			qs[ni][nj] = "0";
		}
	}
	/* for(int ni = 0; ni < 24; ni++) {
		q[ni] = 0;
	} */
	
	// 조사표 문항별 속성 설정
	// 1 = 라디오 버튼
	// 2 = 체크박스
	// 3 = 주관식
	if (qType.equals("Prod")) {
		qs[5][1] = "1";
	} else if (qType.equals("Const")) {
		qs[5][1] = "1";
	}
	
	sqls1="";
	sqls2="";
	sqls1="mng_no";
	sqls2="'"+ckMngNo+"'";
	sqls1+=", current_year";
	sqls2+=", '"+sOentYYYY+"'";
	sqls1+=", oent_gb";
	sqls2+=", '"+sOentGB+"'";
	sqls1+=", sent_no";
	sqls2+=", "+sSentNo;
	sqlsour1=sqls1;
	sqlsour2=sqls2;	

	for(int i=1; i<35; i++) {
		for(int j=1; j < 40; j++) {
			sqls1=sqlsour1;
			sqls2=sqlsour2;
			
			bexe="no";
			sqls1+=", soent_q_cd";
			sqls2+=", "+i;
			sqls1+=", soent_q_gb";
			sqls2+=", "+j;
				if(!StringUtil.checkNull(request.getParameter("q2_"+i+"_"+j)).trim().equals("")) {
					bexe="yes";
					sqls1+=", "+abcf(request.getParameter("q2_"+i+"_"+j));
					sqls2+=", '1'";
				}
			} 
				for(int l=1;l <= 23; l++) {
					if(!StringUtil.checkNull(request.getParameter("q2_"+i+"_"+j+"_"+l)).trim().equals("")) {
						bexe="yes";
						sqls1+=", "+abc;
						sqls2+=", '1'";
					}
				}
			} 
				if(!StringUtil.checkNull(request.getParameter("q2_"+i+"_"+j)).trim().equals("")) {
					bexe="yes";
					sqls1+=", subj_ans";
					String temp = StringUtil.checkNull(request.getParameter("q2_"+i+"_"+j)).trim().replaceAll("'","''");
					String temp1 = temp;
					sqls2+=", '"+temp1+"'";
				}
			}			
			if( bexe.equals("yes") ) {
				sqls1+=", REG_DATE, remote_ip";
				sqls2+=", SYSDATE,'" + sRemoteIp +"'";

				sSQLs="INSERT INTO HADO_TB_SOENT_ANSWER_"+sOentYYYY+" ("+sqls1+") VALUES ("+sqls2+")";

				try {
					resource2	= new ConnectionResource2();
					conn2		= resource2.getConnection();
					pstmt		= conn2.prepareStatement(sSQLs);
					updateCNT	= pstmt.executeUpdate();
				} catch(Exception e) {
					e.printStackTrace();
					System.out.println("is ORA-00942 at 03_answer_save? : "+sSQLs);
				} finally {
					if (rs != null)		try{rs.close();}	catch(Exception e){}
					if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
					if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
					if (resource2 != null) resource2.release();
				}
				bexe = "no";
			}
		}
	}
				
	sSQLs="UPDATE HADO_TB_Subcon_"+sOentYYYY+" SET Sent_Status='1' \n";
	sSQLs+=", remote_ip='" + sRemoteIp + "' \n";
	sSQLs+=", writer_date=sysdate \n";
	// 20110923 - KS Jung - 콜센터관리툴 관련 파라메터
	if( sMngType!=null && sMngType!="") {
		sSQLs+=", Admin_Insert_GB='1' \n";
		sSQLs+=", SP_FLD_02='"+sMngType+"' \n";
	}
	sSQLs+=" WHERE Child_Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";
	
	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
		System.out.println("is ORA-00942 at End of state? : "+sSQLs);
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}
	
	sReturnURL	= "WB_VP_Subcon_0" + sOentGB+"_03.jsp?isSaved=1";

/*관리자화면에서 입력시******************************
if request("sql")="constinput" or request("sql")="prodinput" or request("sql")="serviceinput" then
	'if trim(request.cookies("uid"))="fair" then
	if sMngFlag = "manager" then
		sqls = sqls+", admin_insert_gb='1'"
	end if
end if
'************************************************/	
/*=====================================================================================================*/	
// 전송처리
} else if (qStep.equals("End")) {	
	sSQLs="UPDATE HADO_TB_Subcon_"+sOentYYYY+" SET Sent_Status='1' \n";
	sSQLs+=", remote_ip='" + sRemoteIp + "' \n";
	sSQLs+=", writer_date=sysdate \n";
	// 20110923 - KS Jung - 콜센터관리툴 관련 파라메터
	if( sMngType!=null && sMngType!="") {
		sSQLs+=", Admin_Insert_GB='1' \n";
		sSQLs+=", SP_FLD_02='"+sMngType+"' \n";
	}
	sSQLs+=" WHERE Child_Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";
	//System.out.println(sSQLs);
	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
		System.out.println("is ORA-00942 at End of state? : "+sSQLs);
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}

	// 20150713 / 강슬기 / 추가설문조사페이지로 페이지 리턴
	sReturnURL	= "WB_VP_Subcon_Add.jsp";
	//sReturnURL	= "WB_VP_Subcon_0" + sOentGB+"_04.jsp?isEnded=ok";

/*=====================================================================================================*/	
// 추가설문조사 전송처리
} else if (qStep.equals("Add")) {

	// 기존 답변 삭제
	sSQLs="DELETE FROM HADO_TB_SOENT_ANSWER_ADD \n";
	sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";
	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}	
	// 배열 초기화
	for(int ni = 1; ni < 31; ni++) {
		for(int nj = 1; nj < 12; nj++) {
			qs[ni][nj] = "0";
		}
	}
	for(int ni = 0; ni < 24; ni++) {
		q[ni] = 0;
	}
	
		// 조사표 문항별 속성 설정
		// 1 = 라디오 버튼
		// 2 = 체크박스
		// 3 = 주관식
		qs[1][1] = "1";
		qs[1][2] = "1";
		qs[1][3] = "1";
		qs[1][4] = "1";
		qs[1][5] = "1";
		qs[1][6] = "1";
		qs[1][7] = "1";
		qs[1][8] = "1";
		qs[1][9] = "1";
		qs[1][10] = "1";
		qs[1][11] = "1";
		qs[1][12] = "1";
		qs[1][13] = "1";
		qs[2][14] = "1";
		qs[2][15] = "1";
		qs[2][16] = "1";
		qs[2][17] = "1";
		qs[3][18] = "1";
		qs[3][19] = "1";
		qs[3][20] = "1";
		qs[3][21] = "1";
		
		sqls1="";
		sqls2="";
		sqls1="mng_no";
		sqls2="'"+ckMngNo+"'";
		sqls1+=", current_year";
		sqls2+=", '"+sOentYYYY+"'";
		sqls1+=", oent_gb";
		sqls2+=", '"+sOentGB+"'";
		sqls1+=", sent_no";
		sqls2+=", "+sSentNo;
		sqlsour1=sqls1;
		sqlsour2=sqls2;	

	for(int i=1; i< 31; i++) {
		for(int j=1; j < 30; j++) {
			sqls1=sqlsour1;
			sqls2=sqlsour2;
			
			bexe="no";
			sqls1+=", soent_q_cd";
			sqls2+=", "+i;
			sqls1+=", soent_q_gb";
			sqls2+=", "+j;
			if( qs[i][j].equals("1") ) {
				if(!StringUtil.checkNull(request.getParameter("q"+i+"_"+j)).trim().equals("")) {
					bexe="yes";
					sqls1+=", "+abcf(request.getParameter("q"+i+"_"+j));
					sqls2+=", '1'";
				}
			} else if( qs[i][j].equals("2") ) {
				for(int l=1;l <= 23; l++) {
					if(!StringUtil.checkNull(request.getParameter("q"+i+"_"+j+"_"+l)).trim().equals("")) {
						bexe="yes";
						sqls1+=", "+abcf(l+"");
						sqls2+=", '1'";
					}
				}
			} else if( qs[i][j].equals("3") ) {
				if(!StringUtil.checkNull(request.getParameter("q"+i+"_"+j+"_20")).trim().equals("")) {
					bexe="yes";
					sqls1+=", subj_ans";
					String temp = StringUtil.checkNull(request.getParameter("q"+i+"_"+j+"_20")).trim().replaceAll("'","''");
					String temp1 = temp;
					sqls2+=", '"+temp1+"'";
				}
			}			
			if( bexe.equals("yes") ) {

				sqls1+=", REG_DATE, remote_ip";
				sqls2+=", SYSDATE,'" + sRemoteIp +"'";

				sSQLs="INSERT INTO HADO_TB_SOENT_ANSWER_ADD ("+sqls1+") VALUES ("+sqls2+")";

				try {
					resource2	= new ConnectionResource2();
					conn2		= resource2.getConnection();
					pstmt		= conn2.prepareStatement(sSQLs);
					updateCNT	= pstmt.executeUpdate();

				} catch(Exception e) {
					e.printStackTrace();
				} finally {
					if (rs != null)		try{rs.close();}	catch(Exception e){}
					if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
					if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
					if (resource2 != null) resource2.release();
				}
				bexe = "no";
			}
		}
	}

	sReturnURL	= "WB_VP_Subcon_Add.jsp?isSaved=1";
/*=====================================================================================================*/	
// 로그인차단
} else if (qStep.equals("Block")) {	
	sSQLs="UPDATE HADO_TB_Security_"+sOentYYYY+" SET Dont_Login='Y' \n";
	sSQLs+="WHERE Mng_No='"+ckMngNo+"' \n";
	sSQLs+="AND Current_Year='"+sOentYYYY+"' \n";
	sSQLs+="AND Oent_GB='"+sOentGB+"' \n";
	sSQLs+="AND Sent_No="+sSentNo+" \n";
	sSQLs+="AND Ent_GB='2' \n";
	
	try {
		resource2	= new ConnectionResource2();
		conn2		= resource2.getConnection();
		pstmt		= conn2.prepareStatement(sSQLs);
		updateCNT	= pstmt.executeUpdate();

	} catch(Exception e) {
		e.printStackTrace();
		System.out.println("is ORA-00942 at login_block? : "+sSQLs);
	} finally {
		if (rs != null)		try{rs.close();}	catch(Exception e){}
		if (pstmt != null)	try{pstmt.close();}	catch(Exception e){}
		if (conn2 != null)	try{conn2.close();}	catch(Exception e){}
		if (resource2 != null) resource2.release();
	}
//	sReturnURL	= "../index.jsp";
}
%>

<html>
<head>
	<title>Untitled</title>
</head>
<body>
<%-- <%= "* 정보저장중입니다. (잠시만 기다려 주십시오) ==>"+sErrorMsg.replaceAll("\n", "<br>")%> --%>
</body>
</html>



<%@ include file="../Include/WB_I_Function.jsp"%>