<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
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
/*  1. 프로젝트명 : 공정관리위원회 하도급거래 서면직권실태조사					                       */
/*  2. 업체정보 :																					   */
/*     - 업체명 : (주)로티스아이																	   */
/*	   - Project Manamger : 정광식 부장 (pcxman99@naver.com)										   */
/*     - 연락처 : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  3. 일자 : 2009년 5월																			   */
/*  4. 최초작성자 및 일자 : (주)로티스아이 정광식 / 2011-10-18										   */
/*  5. 업데이트내용 (내용 / 일자)																	   */
/*  6. 비고																							   */
/*		1) 웹관리툴 리뉴얼 / 2011-10-18																   */
/*-----------------------------------------------------------------------------------------------------*/

/*---------------------------------------- Variable Difinition ----------------------------------------*/
	String tt = StringUtil.checkNull(request.getParameter("tt"));
	String comm = StringUtil.checkNull(request.getParameter("comm"));
	
	ConnectionResource resource = null;
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sSQLs = "";
	String sSQLsWhere = "";
	String sOentGB = "";

	// 위반행위명 배열
	String[] money_nm = new String[16];
	String[] money_cd = new String[16];
	String[] no_money_nm = new String[16];
	String[] no_money_cd = new String[16];
	// 원사업자 위반행위수 배열
	Float[] arrViolate = new Float[36];
	// 수급사업자 위반행위수 배열
	String[][] save_data = new String[10001][36];
	Float[] arrTot = new Float[36];

	String tmpStr = "";
	String sTmpPMS = session.getAttribute("ckPermision") + "";

	Float m_violate_cnt = 0F;
	Float nom_violate_cnt = 0F;

	int money_cnt = 8;
	int no_money_cnt = 8;
	int field_cnt = 19;

	int nLoop = 1;
	int i = 0;
	int j = 0;
	
	int sStartYear = 2007;

	java.util.Calendar cal = java.util.Calendar.getInstance();

	DecimalFormat formater = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2 = new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record Selection Processing =====================================*/
	// 합계배열 초기화
	for(i=0; i<36; i++) {
		arrViolate[i]=0F;
		arrTot[i] = 0F;
	}

	String tmpYear = StringUtil.checkNull(request.getParameter("cyear")).trim();
	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
	}
	
	if( comm.equals("search") ) {
		session.setAttribute("sgb", StringUtil.checkNull(request.getParameter("sgb")).trim());
		session.setAttribute("wgb", StringUtil.checkNull(request.getParameter("wgb")).trim());
		session.setAttribute("violatecomp", StringUtil.checkNull(request.getParameter("violatecomp")).trim());
		session.setAttribute("violatecompno", StringUtil.checkNull(request.getParameter("violatecompno")).trim());
	}
	
	int currentYear = st_Current_Year_n;
	currentYear = Integer.parseInt(session.getAttribute("cyear")+"");
	
	try {
		resource = new ConnectionResource();
		conn = resource.getConnection();
		
		// 위반혐의항목 세팅
		sSQLs ="SELECT Oent_Q_CDNM,RANK,('['||RTRIM(MIN(Oent_Q_CD))||'-'||RTRIM(MIN(Oent_Q_GB))||']') q_code,money_gb \n";
		sSQLs+="FROM HADO_TB_Oent_Question \n";
		sSQLs+="WHERE Oent_GB='2' \n";
		sSQLs+="	AND Current_Year='"+currentYear+"' \n";
		sSQLs+="	AND (Money_GB='1' OR Money_GB='2') \n";
		sSQLs+="GROUP BY Oent_Q_CDNM,Money_GB,RANK \n";
		sSQLs+="ORDER BY Money_GB,RANK \n";
		
		pstmt = conn.prepareStatement(sSQLs);
		rs = pstmt.executeQuery();

		i = 1;
		j = 1;
		while( rs.next() ) {
			tmpStr = rs.getString("money_gb");
			if( tmpStr.trim().equals("1") ) {
				money_nm[i] = new String( StringUtil.checkNull(rs.getString("Oent_Q_CDNM")).trim().getBytes("ISO8859-1"), "utf-8" );
				money_cd[i] = StringUtil.checkNull(rs.getString("Q_Code")).trim();
				i++;
			} else {
				no_money_nm[j] = new String( StringUtil.checkNull(rs.getString("Oent_Q_CDNM")).trim().getBytes("ISO8859-1"), "utf-8" );
				no_money_cd[j] = StringUtil.checkNull(rs.getString("Q_Code")).trim();
				j++;
			}
		}
		rs.close();

		money_cnt = i - 1;
		no_money_cnt = j - 1;
		field_cnt = money_cnt + no_money_cnt + 3;

		if( !tt.equals("start") ) {
			if( currentYear == 2010 ) {
				sSQLs="";
				sOentGB = "2";

				sSQLs=sSQLs+"SELECT ";
				//-- 대금 항목별 -- 
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 13 THEN CASE WHEN Oent_Q_GB IN (2,3) THEN 1 ELSE 0 END ELSE 0 END) CNT_132, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 13 THEN CASE WHEN Oent_Q_GB IN (5,6) THEN 1 ELSE 0 END ELSE 0 END) CNT_135, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 15 THEN CASE Oent_Q_GB WHEN 2 THEN 1 ELSE 0 END ELSE 0 END) CNT_152, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 18 THEN CASE Oent_Q_GB WHEN 5 THEN 1 ELSE 0 END ELSE 0 END) CNT_185, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 18 THEN CASE Oent_Q_GB WHEN 6 THEN 1 ELSE 0 END ELSE 0 END) CNT_186, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 18 THEN CASE Oent_Q_GB WHEN 7 THEN 1 ELSE 0 END ELSE 0 END) CNT_187, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 18 THEN CASE Oent_Q_GB WHEN 8 THEN 1 ELSE 0 END ELSE 0 END) CNT_188, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 21 THEN CASE Oent_Q_GB WHEN 1 THEN 1 ELSE 0 END ELSE 0 END) CNT_211, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 21 THEN CASE Oent_Q_GB WHEN 3 THEN 1 ELSE 0 END ELSE 0 END) CNT_213, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 21 THEN CASE Oent_Q_GB WHEN 4 THEN 1 ELSE 0 END ELSE 0 END) CNT_214, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 21 THEN CASE Oent_Q_GB WHEN 5 THEN 1 ELSE 0 END ELSE 0 END) CNT_215, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 22 THEN CASE Oent_Q_GB WHEN 2 THEN 1 ELSE 0 END ELSE 0 END) CNT_222, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 22 THEN CASE Oent_Q_GB WHEN 4 THEN 1 ELSE 0 END ELSE 0 END) CNT_224, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 22 THEN CASE Oent_Q_GB WHEN 5 THEN 1 ELSE 0 END ELSE 0 END) CNT_225, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 22 THEN CASE Oent_Q_GB WHEN 6 THEN 1 ELSE 0 END ELSE 0 END) CNT_226, ";
				//-- 비대금 항목별 -- 
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 9 THEN CASE Oent_Q_GB WHEN 1 THEN 1 ELSE 0 END ELSE 0 END) CNT_91, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 10 THEN CASE Oent_Q_GB WHEN 1 THEN 1 ELSE 0 END ELSE 0 END) CNT_101, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 12 THEN CASE Oent_Q_GB WHEN 5 THEN 1 ELSE 0 END ELSE 0 END) CNT_125, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 14 THEN CASE Oent_Q_GB WHEN 2 THEN 1 ELSE 0 END ELSE 0 END) CNT_142, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 14 THEN CASE Oent_Q_GB WHEN 4 THEN 1 ELSE 0 END ELSE 0 END) CNT_144, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 16 THEN CASE WHEN Oent_Q_GB IN (2,3) THEN 1 ELSE 0 END ELSE 0 END) CNT_162, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 17 THEN CASE Oent_Q_GB WHEN 1 THEN 1 ELSE 0 END ELSE 0 END) CNT_171, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 18 THEN CASE Oent_Q_GB WHEN 9 THEN 1 ELSE 0 END ELSE 0 END) CNT_189, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 18 THEN CASE Oent_Q_GB WHEN 10 THEN 1 ELSE 0 END ELSE 0 END) CNT_1810, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 19 THEN CASE Oent_Q_GB WHEN 2 THEN 1 ELSE 0 END ELSE 0 END) CNT_192, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 21 THEN CASE Oent_Q_GB WHEN 2 THEN 1 ELSE 0 END ELSE 0 END) CNT_212, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 22 THEN CASE Oent_Q_GB WHEN 3 THEN 1 ELSE 0 END ELSE 0 END) CNT_223, ";
				sSQLs=sSQLs+"	SUM(CASE Oent_Q_CD WHEN 23 THEN CASE Oent_Q_GB WHEN 2 THEN 1 ELSE 0 END ELSE 0 END) CNT_232, ";
				sSQLs=sSQLs+"   0 CNT_291 ";
				sSQLs=sSQLs+"FROM ( ";
				sSQLs=sSQLs+"	SELECT AA.Mng_No,AA.Oent_GB,AA.Oent_Q_CD,AA.Oent_Q_GB, ";
				sSQLs=sSQLs+"		BB.Oent_Type,BB.Oent_Name,BB.Comp_Status,BB.Oent_Status,BB.Subcon_Type,BB.Addr_Status ";
				sSQLs=sSQLs+"	FROM ( ";
				sSQLs=sSQLs+"		SELECT Mng_No,Current_Year,Oent_GB,Oent_Q_CD,Oent_Q_GB  ";
				sSQLs=sSQLs+"		FROM ( ";
				sSQLs=sSQLs+"			SELECT A.Mng_No,A.Current_Year,A.Oent_GB,A.Oent_Q_CD,A.Oent_Q_GB, ";
				sSQLs=sSQLs+"				CASE B.Oent_GB WHEN A.Oent_GB THEN '1' ELSE '0' END CHKs ";
				sSQLs=sSQLs+"			FROM ( ";
				sSQLs=sSQLs+"				SELECT *  ";
				sSQLs=sSQLs+"					FROM HADO_TB_Oent_Answer  ";
				sSQLs=sSQLs+"					WHERE Current_Year='"+currentYear+"'  ";
				sSQLs=sSQLs+"						AND Oent_GB='"+sOentGB+"' ";
				sSQLs=sSQLs+"			) A LEFT JOIN ( ";
				sSQLs=sSQLs+"				SELECT *  ";
				sSQLs=sSQLs+"				FROM HADO_TB_Oent_Question  ";
				sSQLs=sSQLs+"				WHERE Current_Year='"+currentYear+"' ";
				sSQLs=sSQLs+"					AND Oent_GB='"+sOentGB+"' ";
				sSQLs=sSQLs+"			) B ";
				sSQLs=sSQLs+"			ON A.Oent_GB=B.Oent_GB  ";
				sSQLs=sSQLs+"				AND A.Oent_Q_CD=B.Oent_Q_CD  ";
				sSQLs=sSQLs+"				AND A.Oent_Q_GB=B.Oent_Q_GB ";
				sSQLs=sSQLs+"				AND A.Current_Year=B.Current_Year ";
				sSQLs=sSQLs+"				AND ( NVL(A.A,'2')=NVL(B.CHK_V_A,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.B,'2')=NVL(B.CHK_V_B,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.C,'2')=NVL(B.CHK_V_C,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.D,'2')=NVL(B.CHK_V_D,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.E,'2')=NVL(B.CHK_V_E,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.F,'2')=NVL(B.CHK_V_F,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.G,'2')=NVL(B.CHK_V_G,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.H,'2')=NVL(B.CHK_V_H,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.I,'2')=NVL(B.CHK_V_I,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.J,'2')=NVL(B.CHK_V_J,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.K,'2')=NVL(B.CHK_V_K,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.L,'2')=NVL(B.CHK_V_L,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.M,'2')=NVL(B.CHK_V_M,'3') ";
				sSQLs=sSQLs+"				OR NVL(A.N,'2')=NVL(B.CHK_V_N,'3') ) ";
				sSQLs=sSQLs+"		) OentAnswer_Result ";
				sSQLs=sSQLs+"		WHERE CHKs='1' ";
				sSQLs=sSQLs+"		GROUP BY Mng_No,Current_Year,Oent_GB,Oent_Q_CD,Oent_Q_GB ";
				sSQLs=sSQLs+"	) AA LEFT JOIN ( ";
				sSQLs=sSQLs+"		SELECT *  ";
				sSQLs=sSQLs+"		FROM HADO_TB_Oent  ";
				sSQLs=sSQLs+"		WHERE Current_Year='"+currentYear+"' ";
				sSQLs=sSQLs+"			AND Oent_GB='"+sOentGB+"' ";
				sSQLs=sSQLs+"	  ) BB ";
				sSQLs=sSQLs+"	ON AA.Mng_No=BB.Mng_No  ";
				sSQLs=sSQLs+"		AND AA.Current_Year=BB.Current_Year  ";
				sSQLs=sSQLs+"		AND AA.Oent_GB=BB.Oent_GB ";
				sSQLs=sSQLs+") CCC ";
				sSQLs=sSQLs+"WHERE Oent_Status='1' ";
				sSQLs=sSQLs+"	AND Comp_Status='1' ";
				sSQLs=sSQLs+"	AND Subcon_Type<='2' ";
				sSQLs=sSQLs+"	AND Addr_Status IS NULL ";
				if( !session.getAttribute("sgb").equals("") ) {
					sSQLs=sSQLs+"AND Oent_Type = '" + session.getAttribute("sgb") + "' ";
				}
				if( !session.getAttribute("violatecomp").equals("") ) {
					tmpStr = new String((""+session.getAttribute("violatecomp")).getBytes("utf-8"), "ISO8859-1");
					sSQLs=sSQLs+"AND Oent_Name LIKE '%" + tmpStr + "%' ";
				}
				if( !session.getAttribute("violatecompno").equals("") ) {
					sSQLs=sSQLs+"AND Mng_No = '" + session.getAttribute("violatecompno") + "' ";
				}
				sSQLs=sSQLs+"GROUP BY Mng_No,Oent_Name ";
				sSQLs=sSQLs+"ORDER BY Mng_No ";
				
				pstmt = conn.prepareStatement(sSQLs);
				rs = pstmt.executeQuery();

				while( rs.next() ) {
					for(int ni=1; ni <= field_cnt-3; ni++) {
						if( ni>=1 && ni <= money_cnt ) {
							if(rs.getString(ni) != null ) {
								if( rs.getString(ni).equals("1") ) {
									arrViolate[ni] = 1F;
								}
							} else {
								arrViolate[ni] = arrViolate[ni] + 0F;
							}
						} else {
							if( rs.getString(ni) != null ) {
								if( rs.getString(ni).equals("1") ) {
									arrViolate[ni+1] = 1F;
								}
							} else {
								arrViolate[ni+1] = arrViolate[ni+1] + 0F;
							}
						}
					}
				}
				rs.close();
				
				for( int ni=1; ni<=field_cnt-3; ni++) {
					if( ni>=1 && ni<=money_cnt ) {
						arrViolate[money_cnt+1] = arrViolate[money_cnt+1] + arrViolate[ni];
						arrViolate[field_cnt] = arrViolate[field_cnt] + arrViolate[ni];
					} else {
						arrViolate[field_cnt-1] = arrViolate[field_cnt-1] + arrViolate[ni+1];
						arrViolate[field_cnt] = arrViolate[field_cnt] + arrViolate[ni+1];
					}
				}
			}
			
			if( session.getAttribute("wgb").equals("2") ) {
				if( currentYear== 2010) {
					sSQLs = "SELECT Mng_No,Current_Year,Sent_Name, " +
						"(CASE WHEN SUM(d1)>0 THEN 1 ELSE 0 END) d1, " +
						"0 d2, " +
						"(CASE WHEN SUM(d2)>0 THEN 1 ELSE 0 END) d3, " +
						"(CASE WHEN SUM(d3)>0 THEN 1 ELSE 0 END) d4, " +
						"(CASE WHEN SUM(d4)>0 THEN 1 ELSE 0 END) d5, " +
						"(CASE WHEN SUM(d5)>0 THEN 1 ELSE 0 END) d6, " +
						"(CASE WHEN SUM(d6)>0 THEN 1 ELSE 0 END) d7, " +
						"(CASE WHEN SUM(d7)>0 THEN 1 ELSE 0 END) d8, " +
						"0 d9, " +
						"0 d10, " +
						"0 d11, " +
						"(CASE WHEN SUM(d8)>0 THEN 1 ELSE 0 END) d12, " +
						"0 d13, " +
						"0 d14, " +
						"0 d15, " +
						"(CASE WHEN SUM(a1)>0 THEN 1 ELSE 0 END) a1, " +
						"0 a2, " +
						"(CASE WHEN SUM(a2)>0 THEN 1 ELSE 0 END) a3, " +
						"(CASE WHEN SUM(a3)>0 THEN 1 ELSE 0 END) a4, " +
						"(CASE WHEN SUM(a4)>0 THEN 1 ELSE 0 END) a5, " +
						"(CASE WHEN SUM(a5)>0 THEN 1 ELSE 0 END) a6, " +
						"(CASE WHEN SUM(a9)>0 THEN 1 ELSE 0 END) a7, " +
						"0 a8, " +
						"0 a9, " +
						"(CASE WHEN SUM(a6)>0 THEN 1 ELSE 0 END) a10, " +
						"0 a11, " +
						"0 a12, " +
						"(CASE WHEN SUM(a7)>0 THEN 1 ELSE 0 END) a13, " +
						"(CASE WHEN SUM(a8)>0 THEN 1 ELSE 0 END) a14 ";
				} else {
					sSQLs = "SELECT Mng_No,Current_Year,Sent_Name, " +
						"(CASE WHEN SUM(d1)>0 THEN 1 ELSE 0 END) d1, " +
						"(CASE WHEN SUM(d2)>0 THEN 1 ELSE 0 END) d2, " +
						"(CASE WHEN SUM(d3)>0 THEN 1 ELSE 0 END) d3, " +
						"(CASE WHEN SUM(d4)>0 THEN 1 ELSE 0 END) d4, " +
						"(CASE WHEN SUM(d5)>0 THEN 1 ELSE 0 END) d5, " +
						"(CASE WHEN SUM(d6)>0 THEN 1 ELSE 0 END) d6, " +
						"(CASE WHEN SUM(d7)>0 THEN 1 ELSE 0 END) d7, " +
						"(CASE WHEN SUM(d8)>0 THEN 1 ELSE 0 END) d8, " +
						"(CASE WHEN SUM(a1)>0 THEN 1 ELSE 0 END) a1, " +
						"(CASE WHEN SUM(a2)>0 THEN 1 ELSE 0 END) a2, " +
						"(CASE WHEN SUM(a3)>0 THEN 1 ELSE 0 END) a3, " +
						"(CASE WHEN SUM(a4)>0 THEN 1 ELSE 0 END) a4, " +
						"(CASE WHEN SUM(a5)>0 THEN 1 ELSE 0 END) a5, " +
						"(CASE WHEN SUM(a6)>0 THEN 1 ELSE 0 END) a6, " +
						"(CASE WHEN SUM(a7)>0 THEN 1 ELSE 0 END) a7, " +
						"(CASE WHEN SUM(a8)>0 THEN 1 ELSE 0 END) a8 ";
				}
				sSQLs=sSQLs+"FROM HADO_VT_Oent2_Answer WHERE SUBSTR(Mng_No,-5)<>'99999' ";
				sSQLs=sSQLs+"AND Current_Year = '" + currentYear + "' ";
						
			}

			if( !session.getAttribute("sgb").equals("") ) {
				sSQLs = sSQLs + "AND Oent_Type = '" + session.getAttribute("sgb")+"' ";
			}
			if( !session.getAttribute("violatecomp").equals("") ) {
				tmpStr = new String((""+session.getAttribute("violatecomp")).getBytes("utf-8"), "ISO8859-1");
				sSQLs  = sSQLs + "AND Oent_Name LIKE '%" + tmpStr + "%' ";
			}
			if( !session.getAttribute("violatecompno").equals("") ) {
				sSQLs  = sSQLs + "AND RTRIM(Oent_Mng_No) = '" + session.getAttribute("violatecompno") + "' ";
			}
			
			sSQLs = sSQLs + "GROUP BY Oent_Type,Oent_Name,Oent_Mng_No,Sent_Name,Mng_No,Current_Year ORDER BY Mng_No";
				
			pstmt = conn.prepareStatement(sSQLs);
			rs = pstmt.executeQuery();
			
			i = 1;
			while (rs.next()) {
				save_data[i][money_cnt+4] = "0";
				save_data[i][field_cnt+2] = "0";
				save_data[i][field_cnt+3] = "0";
				for(j=1 ; j <= field_cnt; j++) {
					if( (j>=1) && (j<=money_cnt+3) ) {
						tmpStr = rs.getString(j);
						if( tmpStr != null && (!tmpStr.equals("")) && (!tmpStr.equals("null")) ) {
							save_data[i][j] = new String( rs.getString(j).trim().getBytes("ISO8859-1"), "utf-8" );
							if( j > 3 ) {
								save_data[i][money_cnt+4] = "" + (Float.parseFloat(save_data[i][money_cnt+4]) + Float.parseFloat(save_data[i][j]));
								save_data[i][field_cnt+3] = "" + (Float.parseFloat(save_data[i][field_cnt+3]) + Float.parseFloat(save_data[i][j]));
								if( save_data[i][j].equals("1") ) {
									arrTot[j] = 1F;
								}
							}
						} else {
							save_data[i][j] = "0";
						}
					} else {
						tmpStr = rs.getString(j);
						if( tmpStr != null && (!tmpStr.equals("")) && (!tmpStr.equals("null")) ) {
							save_data[i][j+1] = tmpStr;
							save_data[i][field_cnt+2] = "" + (Float.parseFloat(save_data[i][field_cnt+2]) + Float.parseFloat(save_data[i][j+1]));
							save_data[i][field_cnt+3] = "" + (Float.parseFloat(save_data[i][field_cnt+3]) + Float.parseFloat(save_data[i][j+1]));
							if( save_data[i][j+1].equals("1") ) {
									arrTot[j+1] = 1F;
							}
						} else {
							save_data[i][j+1] = "0";
						}
					}
				}
				i++;
			}
			nLoop = i - 1;
			
			for(j=1 ; j <= field_cnt; j++) {
				if( (j>=4) && (j<=money_cnt+3) ) {
					arrTot[money_cnt+4] = arrTot[money_cnt+4] + arrTot[j];
					arrTot[field_cnt+3] = arrTot[field_cnt+3] + arrTot[j];
				} else if( (j>money_cnt+3) && (j<=field_cnt+3) ) {
					arrTot[field_cnt+2] = arrTot[field_cnt+2] + arrTot[j+1];
					arrTot[field_cnt+3] = arrTot[field_cnt+3] + arrTot[j+1];
				}
			}
		}
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
%>

<script language="javascript">
content = "";

content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th rowspan=2 colspan=3  style='width:300px;'>구분</th>";
content+="		<th colspan=<%=money_cnt+1%>>대금관련사항(<%=money_cnt%>)</th>";
content+="		<th colspan=<%=no_money_cnt+1%>>비대금관련사항(<%=no_money_cnt%>)</th>";
content+="		<th rowspan=2>계</th>";
content+="	</tr>";
content+="	<tr>";
<%for(j=1; j<=money_cnt; j++) {%>
content+="		<th><%=money_nm[j]%></th>";
<%}%>
content+="		<th>소계</th>";
<%for(j=1; j<=no_money_cnt; j++) {%>
content+="		<th><%=no_money_nm[j]%></th>";
<%}%>
content+="		<th>소계</th>";
content+="	</tr>";

<%if( !tt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan=<%if( sTmpPMS!=null && (sTmpPMS.equals("M") || sTmpPMS.equals("T")) ) {%><%=nLoop+3%><%} else {%>4<%}%> valign=middle>위<br>반<br>항<br>목<br>수</th>";
content+="		<th colspan=2>계</td>";
	<%for(int ni=1; ni<=field_cnt; ni++) {%>
		<%if( ni == (money_cnt + 1) || ni == (money_cnt + no_money_cnt + 2) || ni == (money_cnt + no_money_cnt + 3) ) {%>
			<%if( ni == (money_cnt + 1) ) {%>
content+="		<td><%=formater2.format(m_violate_cnt)%></td>";
			<%}%>		
			<%if( ni == (money_cnt + no_money_cnt + 2) ) {%>
content+="		<td><%=formater2.format(nom_violate_cnt)%></td>";
			<%}%>				
			<%if( ni == (money_cnt + no_money_cnt + 3) ) {%>
content+="		<td><%=formater2.format(m_violate_cnt + nom_violate_cnt)%></td>";
			<%}%>		
		<%} else {%>
			<%if( arrViolate[ni] + arrTot[ni+3] >= 1F && ni <= money_cnt ) {
				m_violate_cnt = m_violate_cnt + 1F;
			} else if( arrViolate[ni] + arrTot[ni+3] >= 1F && ni > money_cnt+1 && ni <= money_cnt + no_money_cnt+2 ) {
				nom_violate_cnt = nom_violate_cnt + 1F;
			}%>
content+="		<td><%if( arrViolate[ni] + arrTot[ni+3] >= 1F ) {%>1<%} else {%>0<%}%></td>";
		<%}%>
	<%}%>
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th colspan=2>원사업자 조사</th>";
	<%for(int ni=1; ni<=field_cnt; ni++) {%>
content+="		<td><%=formater2.format(arrViolate[ni])%></td>";
	<%}%>
content+="	</tr>";
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan=<%if( sTmpPMS!=null && (sTmpPMS.equals("M") || sTmpPMS.equals("T")) ) {%><%=nLoop+1%><%} else {%>2<%}%> valign=middle>수급사업자 조사 (응답업체 기준)</th>";
content+="		<th>소계</th>";
	<%for(int ni=4; ni<=field_cnt+3; ni++) {%>
content+="		<td><%=formater2.format(arrTot[ni])%></td>";
	<%}%>
content+="	</tr>";
<%if( sTmpPMS!=null && (sTmpPMS.equals("M") || sTmpPMS.equals("T")) ) {%>
<%for(int ni=1; ni<=nLoop; ni++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for( int k=3; k<=field_cnt+3; k++) {%>
		<%if( k == 3 ) {%>
content+="		<th><%=save_data[ni][3]%>(<%=save_data[ni][1]%>)</th>";
		<%} else {%>
content+="		<td><%=formater2.format(Float.parseFloat(save_data[ni][k]))%></td>";
		<%}%>
	<%}%>
content+="	</tr>";
<%}%>
<%} else {%>
content+="	<tr>";
content+="		<td colspan=<%=field_cnt+1%> style='text-align:center;'><font color=red>이하 조회권한 없음</font></td>";
content+="	</tr>";
<%}%>
<%}%>
content+="</table>";

top.document.getElementById("divResult").innerHTML = content;
top.setNowProcessFalse();
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>