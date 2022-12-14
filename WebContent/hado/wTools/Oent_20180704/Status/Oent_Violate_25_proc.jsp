<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명	: Oent_Violate_25_proc.jsp	
* 프로그램설명	: 원사업자 > 조사결과분석 > 위반행위 유형별 점유율
* 프로그램버전	: 1.0.1
* 최초작성일자	: 2009년 05월
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2009-05-00	정광식       최초작성
*   2011-12-06	정광식       웹관리툴 리뉴얼
*   2015-02-05	정광식       복합항목중 제조/용역 OR 조건인 아닌 AND 조건으로 처리내용 예외처리 추가
*	2016-01-08	민현근		DB변경으로 인한 인코딩 변경
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
	String sErrorMsg="";	// 오류메시지
	String sReturnURL="/index.jsp";	// 이동URL

	ConnectionResource resource=null;
	Connection conn=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;

	String stt=StringUtil.checkNull(request.getParameter("tt"));
	String comm=StringUtil.checkNull(request.getParameter("comm"));

	String sSQLs="";

	int oType_CNT=0;
	int Money_CNT=0;
	int No_Money_CNT=0;
	int nTmpCnt=0;

	Long tot_type=new Long(0);
	Long tot_subcon=new Long(0);
	Long tot_Money_CNT=new Long(0);
	Long tot_No_Money_CNT=new Long(0);
	Long typ_Money_CNT=new Long(0);
	Long typ_No_Money_CNT=new Long(0);
	Long total_vio=new Long(0);

	String[] oType=new String[101];
	String[] type_CD=new String[101];
	String[] Money_NM=new String[30];
	String[] Money_CD=new String[30];
	String[] No_Money_NM=new String[30];
	String[] No_Money_CD=new String[30];

	Long[] type_cnt=new Long[121];
	Long[] subcon_cnt=new Long[121];
	Long[][] Violate_CNT=new Long[49][60];
	Long[] tot_Violate=new Long[64];
	Long[] e_total=new Long[60];

	// 위반 쿼리 생성을 위한 배열
	//==> 대금
	ArrayList arrQCD1=new ArrayList();
	ArrayList arrQGB1=new ArrayList();
	ArrayList arrCDNM1=new ArrayList();
	ArrayList arrMoneyGB1=new ArrayList();
	ArrayList arrIDT_QCD1=new ArrayList();
	ArrayList arrIDT_QGB1=new ArrayList();
	//==> 비대금
	ArrayList arrQCD2=new ArrayList();
	ArrayList arrQGB2=new ArrayList();
	ArrayList arrCDNM2=new ArrayList();
	ArrayList arrMoneyGB2=new ArrayList();
	ArrayList arrIDT_QCD2=new ArrayList();
	ArrayList arrIDT_QGB2=new ArrayList();

	// 쿼리 저장 배열
	String sAllSurveySQL="";
	String sAllSumSQL="";
	String sMoneySumSQL="";
	String sBiSumSQL="";
	String sSurveySQL="";

	int sStartYear=2000;

	java.util.Calendar cal=java.util.Calendar.getInstance();

	DecimalFormat formater=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0.0");
	DecimalFormat formater2=new java.text.DecimalFormat("###,###,###,###,###,###,###,##0");
/*-----------------------------------------------------------------------------------------------------*/
/*=================================== Record SELECTion Processing =====================================*/
	int currentYear=st_Current_Year_n;

	String tmpYear=StringUtil.checkNull(request.getParameter("cyear")).trim();

	if( !tmpYear.equals("") ) {
		session.setAttribute("cyear", tmpYear);
	} else {
		session.setAttribute("cyear", st_Current_Year);
	}

	currentYear=Integer.parseInt(session.getAttribute("cyear")+"");

	int endCurrentYear=st_Current_Year_n;

	// view table name
	String currentOent = currentYear>=2012 ? "HADO_TB_Oent_"+tmpYear : "HADO_TB_Oent";
	String currentAnswer = currentYear>=2012 ? "HADO_TB_Oent_Answer_"+tmpYear : "HADO_TB_Oent_Answer";

	session.setAttribute("wgb", StringUtil.checkNull(request.getParameter("wgb")).trim());
	String sGB=StringUtil.checkNull(request.getParameter("wgb")).trim();
	String sCapa=StringUtil.checkNull(request.getParameter("wcapa")).trim();
	String sTradeST=StringUtil.checkNull(request.getParameter("tradest")).trim();

	// 초기화
	for(int i=1; i<=100; i++) {
		type_cnt[i]=new Long(0);
		subcon_cnt[i]=new Long(0);
	}
	for(int i=1; i<=48; i++) {
		tot_Violate[i]=new Long(0);
		for(int j=1; j<=59; j++) {
			Violate_CNT[i][j]=new Long(0);
			e_total[j]=new Long(0);
		}
	}

	try {
		resource=new ConnectionResource();
		conn=resource.getConnection();
		
/********************************************************************************************************/
		sSQLs="SELECT Common_CD, (Common_CD || '(' || Common_NM || ')') as_Type FROM Common_CD \n";  
		sSQLs+="WHERE  Addon_GB='"+sGB+"' ";  

		if( currentYear>=2012 ) 
			sSQLs+="AND COMMON_GB='010' \n";
		else
			sSQLs+="AND COMMON_GB='002' \n";  
		sSQLs+="ORDER BY Common_CD \n";   

		pstmt=conn.prepareStatement(sSQLs);
		rs=pstmt.executeQuery();

		oType_CNT=0;

		while( rs.next() ) {
			oType_CNT++;
			oType[oType_CNT]=StringUtil.checkNull(rs.getString("as_Type")).trim();
			type_CD[oType_CNT]=rs.getString("Common_CD");
		}
		rs.close();

		sSQLs ="SELECT Oent_Q_CD,Oent_Q_GB,Oent_Q_CDNM,Money_GB,IDentity_Q_CD,IDentity_Q_GB \n";
		sSQLs+="FROM HADO_TB_Oent_Question \n";
		sSQLs+="WHERE Current_Year='"+currentYear+"' \n";
		sSQLs+="	AND Oent_GB='"+sGB+"' \n";
		sSQLs+="	AND (Money_GB='1' OR Money_GB='2') \n";
		sSQLs+="ORDER BY Money_GB,Rank \n";

		pstmt=conn.prepareStatement(sSQLs);
		rs=pstmt.executeQuery();

		while( rs.next() ) {
			String tmp_MoneyGB=rs.getString("Money_GB").trim();

			if( tmp_MoneyGB.equals("1") ) {
				arrQCD1.add(rs.getString("Oent_Q_CD"));
				arrQGB1.add(rs.getString("Oent_Q_GB"));
				arrCDNM1.add(rs.getString("Oent_Q_CDNM").trim());
				arrMoneyGB1.add(tmp_MoneyGB);
				arrIDT_QCD1.add(rs.getString("Identity_Q_CD"));
				arrIDT_QGB1.add(rs.getString("Identity_Q_GB"));
			} else {
				arrQCD2.add(rs.getString("Oent_Q_CD"));
				arrQGB2.add(rs.getString("Oent_Q_GB"));
				arrCDNM2.add(rs.getString("Oent_Q_CDNM").trim());
				arrMoneyGB2.add(tmp_MoneyGB);
				arrIDT_QCD2.add(rs.getString("Identity_Q_CD"));
				arrIDT_QGB2.add(rs.getString("Identity_Q_GB"));
			}
		}
		rs.close();

		/* 쿼리 생성 시작 */
		String tmp_IDT_QCD="";
		String tmp_IDT_QGB="";
		String prev_QCD="";
		String prev_QGB="";
		String tmp_Duble="F";

		int nWriteCnt=0;

		for(int i=0; i<arrQCD1.size(); i++) {
			if( !(tmp_IDT_QCD.equals(arrIDT_QCD1.get(i)+"") && tmp_IDT_QGB.equals(arrIDT_QGB1.get(i)+"")) ) {
				if( !sAllSumSQL.equals("") ) { 
					sAllSumSQL+="+";
					sMoneySumSQL+="+";
					sAllSurveySQL+=", ";
				}
				sAllSumSQL+="SUM(NVL(cnt_"+arrQCD1.get(i)+arrQGB1.get(i)+",0))";
				sMoneySumSQL+="SUM(NVL(cnt_"+arrQCD1.get(i)+arrQGB1.get(i)+",0))";
				sAllSurveySQL+="SUM(NVL(cnt_"+arrQCD1.get(i)+arrQGB1.get(i)+",0))";

				nWriteCnt++;
			} else {
				tmp_Duble="T";
				nWriteCnt=0;
			}

			if( tmp_Duble.equals("T") ) {
				if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; 
				}
				/* 2014년도부터 복합항목중 제조/용역 OR 조건인 아닌 AND 조건으로 처리내용 예외처리 추가 / 정광식 / 2015-02-05 */
				if( currentYear>=2014 && ((sGB.equals("1") && prev_QCD.equals("9") && prev_QGB.equals("3")) || (sGB.equals("3") && prev_QCD.equals("8") && prev_QGB.equals("3"))) ) {
					sSurveySQL+="CASE SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE WHEN Oent_Q_GB IN ("+prev_QGB+","+arrQGB1.get(i)+") THEN 1 ELSE 0 END ELSE 0 END) WHEN 2 THEN 1 WHEN 1 THEN 0 ELSE 0 END cnt_"+prev_QCD+prev_QGB;
				} else {
					sSurveySQL+="CASE SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE WHEN Oent_Q_GB IN ("+prev_QGB+","+arrQGB1.get(i)+") THEN 1 ELSE 0 END ELSE 0 END) WHEN 2 THEN 1 WHEN 1 THEN 1 ELSE 0 END cnt_"+prev_QCD+prev_QGB;
				}
				tmp_Duble="F";
			} else if( nWriteCnt==2 ) {
				if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; 
				}
				sSurveySQL+="SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE Oent_Q_GB WHEN "+prev_QGB+" THEN 1 ELSE 0 END ELSE 0 END) cnt_"+prev_QCD+prev_QGB;
				nWriteCnt=1;
			}

			tmp_IDT_QCD=arrIDT_QCD1.get(i)+"";
			tmp_IDT_QGB=arrIDT_QGB1.get(i)+"";
			prev_QCD=arrQCD1.get(i)+"";
			prev_QGB=arrQGB1.get(i)+"";
		}

		if( tmp_Duble.equals("T") ) {
			if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; 
			}
			/* 2014년도부터 복합항목중 제조/용역 OR 조건인 아닌 AND 조건으로 처리내용 예외처리 추가 / 정광식 / 2015-02-05 */
			if( currentYear>=2014 && ((sGB.equals("1") && prev_QCD.equals("9") && prev_QGB.equals("3")) || (sGB.equals("3") && prev_QCD.equals("8") && prev_QGB.equals("3"))) ) {
				sSurveySQL+="CASE SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE WHEN Oent_Q_GB IN ("+prev_QGB+","+arrQGB1.get(arrQCD1.size()-1)+") THEN 1 ELSE 0 END ELSE 0 END) WHEN 2 THEN 1 WHEN 1 THEN 0 ELSE 0 END cnt_"+prev_QCD+prev_QGB;
			} else {
				sSurveySQL+="CASE SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE WHEN Oent_Q_GB IN ("+prev_QGB+","+arrQGB1.get(arrQCD1.size()-1)+") THEN 1 ELSE 0 END ELSE 0 END) WHEN 2 THEN 1 WHEN 1 THEN 1 ELSE 0 END cnt_"+prev_QCD+prev_QGB;
			}
		} else {
			if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; 
			}
			sSurveySQL+="SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE Oent_Q_GB WHEN "+prev_QGB+" THEN 1 ELSE 0 END ELSE 0 END) cnt_"+prev_QCD+prev_QGB;
		}
		
		prev_QCD="";
		prev_QGB="";
		tmp_Duble="F";

		nWriteCnt=0;
		
		for(int i=0; i<arrQCD2.size(); i++) {
			if( !(tmp_IDT_QCD.equals(arrIDT_QCD2.get(i)+"") && tmp_IDT_QGB.equals(arrIDT_QGB2.get(i)+"")) ) {
				if( !sAllSumSQL.equals("") ) { sAllSumSQL+="+"; sAllSurveySQL+=", "; 
				}
				if( !sBiSumSQL.equals("") ) { sBiSumSQL+="+"; 
				}
				sAllSumSQL+="SUM(NVL(cnt_"+arrQCD2.get(i)+arrQGB2.get(i)+",0))";
				sBiSumSQL+="SUM(NVL(cnt_"+arrQCD2.get(i)+arrQGB2.get(i)+",0))";
				sAllSurveySQL+="SUM(NVL(cnt_"+arrQCD2.get(i)+arrQGB2.get(i)+",0))";
				nWriteCnt++;
			} else {
				tmp_Duble="T";
				nWriteCnt=0;
			}

			if( tmp_Duble.equals("T") ) {
				if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; 
				}
				/* 2014년도부터 복합항목중 제조/용역 OR 조건인 아닌 AND 조건으로 처리내용 예외처리 추가 / 정광식 / 2015-02-05 */
				if( currentYear>=2014 && ((sGB.equals("1") && prev_QCD.equals("9") && prev_QGB.equals("3")) || (sGB.equals("3") && prev_QCD.equals("8") && prev_QGB.equals("3"))) ) {
					sSurveySQL+="CASE SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE WHEN Oent_Q_GB IN ("+prev_QGB+","+arrQGB2.get(i)+") THEN 1 ELSE 0 END ELSE 0 END) WHEN 2 THEN 1 WHEN 1 THEN 0 ELSE 0 END cnt_"+prev_QCD+prev_QGB;
				} else {
					sSurveySQL+="CASE SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE WHEN Oent_Q_GB IN ("+prev_QGB+","+arrQGB2.get(i)+") THEN 1 ELSE 0 END ELSE 0 END) WHEN 2 THEN 1 WHEN 1 THEN 1 ELSE 0 END cnt_"+prev_QCD+prev_QGB;
				}
				tmp_Duble="F";
			} else if( nWriteCnt==2 ) {
				if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; 
				}
				sSurveySQL+="SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE Oent_Q_GB WHEN "+prev_QGB+" THEN 1 ELSE 0 END ELSE 0 END) cnt_"+prev_QCD+prev_QGB;
				nWriteCnt=1;
			}

			tmp_IDT_QCD=arrIDT_QCD2.get(i)+"";
			tmp_IDT_QGB=arrIDT_QGB2.get(i)+"";
			prev_QCD=arrQCD2.get(i)+"";
			prev_QGB=arrQGB2.get(i)+"";
		}

		if( tmp_Duble.equals("T") ) {
			if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n"; 
			}
			/* 2014년도부터 복합항목중 제조/용역 OR 조건인 아닌 AND 조건으로 처리내용 예외처리 추가 / 정광식 / 2015-02-05 */
			if( currentYear>=2014 && ((sGB.equals("1") && prev_QCD.equals("9") && prev_QGB.equals("3")) || (sGB.equals("3") && prev_QCD.equals("8") && prev_QGB.equals("3"))) ) {
				sSurveySQL+="CASE SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE WHEN Oent_Q_GB IN ("+prev_QGB+","+arrQGB2.get(arrQCD2.size()-1)+") THEN 1 ELSE 0 END ELSE 0 END) WHEN 2 THEN 1 WHEN 1 THEN 0 ELSE 0 END cnt_"+prev_QCD+prev_QGB;
			} else {
				sSurveySQL+="CASE SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE WHEN Oent_Q_GB IN ("+prev_QGB+","+arrQGB2.get(arrQCD2.size()-1)+") THEN 1 ELSE 0 END ELSE 0 END) WHEN 2 THEN 1 WHEN 1 THEN 1 ELSE 0 END cnt_"+prev_QCD+prev_QGB;
			}
		} else {
			if( !sSurveySQL.equals("") ) { sSurveySQL+=", \n";
			}
			sSurveySQL+="SUM(CASE Oent_Q_CD WHEN "+prev_QCD+" THEN CASE Oent_Q_GB WHEN "+prev_QGB+" THEN 1 ELSE 0 END ELSE 0 END) cnt_"+prev_QCD+prev_QGB;
		}
/********************************************************************************************************/
		// Violate_Title & Code Number
		sSQLs="SELECT ('[' || MIN(Oent_Q_CD) || '-' || MIN(Oent_Q_GB) || ']') Q_Code, \n";
		sSQLs+="Oent_Q_CDNM, Rank, Money_GB FROM HADO_TB_Oent_Question \n";
		sSQLs+="WHERE Oent_GB='"+sGB+"' \n";
		sSQLs+="	AND Current_Year='"+currentYear+"' \n";
		sSQLs+="	AND (Money_GB='1' OR Money_GB='2') \n";
		sSQLs+="GROUP BY Oent_Q_CDNM, Money_GB, Rank \n";
		sSQLs+="ORDER BY Money_GB, Rank \n";

		pstmt=conn.prepareStatement(sSQLs);
		rs=pstmt.executeQuery();

		Money_CNT=0;
		No_Money_CNT=0;

		String nTmpStr="";

		while( rs.next() ) {
			nTmpStr=rs.getString("Money_GB");
			if( nTmpStr.equals("1") ) {
				Money_CNT++;
				Money_NM[Money_CNT]=StringUtil.checkNull(rs.getString("Oent_Q_CDNM")).trim();
				Money_CD[Money_CNT]=rs.getString("Q_Code");
			} else if( nTmpStr.equals("2") || nTmpStr.equals("3") ) {
				No_Money_CNT++;
				No_Money_NM[No_Money_CNT]=StringUtil.checkNull(rs.getString("Oent_Q_CDNM")).trim();
				No_Money_CD[No_Money_CNT]=rs.getString("Q_Code");
			}
		}
		rs.close();

		sSQLs="SELECT Oent_Type, \n";
		sSQLs+=sAllSurveySQL+" \n";
		sSQLs+="FROM ( \n";
		sSQLs+="	SELECT Mng_No, Oent_Type, Oent_GB, \n";	
		sSQLs+="	"+sSurveySQL+" \n";	
		sSQLs+="	FROM ( \n";	
		sSQLs+="		SELECT AA.Mng_No, AA.Oent_GB ,AA.Oent_Q_CD, AA.Oent_Q_GB, \n";	
		sSQLs+="			BB.Oent_Type, BB.Oent_Name, BB.Oent_Capa, BB.TradeST, AA.Money_GB, \n";		
		sSQLs+="			BB.Comp_Status, BB.Oent_Status, BB.Subcon_Type, BB.Addr_Status \n";	
		sSQLs+="		FROM ( \n";	
		sSQLs+="			SELECT Mng_No,Current_Year,Oent_GB,Oent_Q_CD,Oent_Q_GB,Money_GB  \n";	
		sSQLs+="			FROM ( \n";	
		sSQLs+="				SELECT A.Mng_No,A.Current_Year,A.Oent_GB,A.Oent_Q_CD,A.Oent_Q_GB, \n";	
		sSQLs+="				CASE B.Oent_GB WHEN A.Oent_GB THEN '1' ELSE '0' END CHKs, \n";	
		sSQLs+="                B.Money_GB \n";	
		sSQLs+="				FROM ( \n";	
		sSQLs+="					SELECT *  \n";	
		sSQLs+="						FROM "+currentAnswer+" \n";	
		sSQLs+="						WHERE Current_Year='"+currentYear+"' \n";	
		sSQLs+="						AND Oent_GB='"+sGB+"' \n";	
		sSQLs+="				) A LEFT JOIN ( \n";	
		sSQLs+="					SELECT * \n";	
		sSQLs+="					FROM HADO_TB_Oent_Question \n";	
		sSQLs+="					WHERE Current_Year='"+currentYear+"' \n";	
		sSQLs+="					AND Oent_GB='"+sGB+"' \n";	
		sSQLs+="				) B \n";	
		sSQLs+="				ON A.Oent_GB=B.Oent_GB \n";	
		sSQLs+="				AND A.Oent_Q_CD=B.Oent_Q_CD \n";	
		sSQLs+="				AND A.Oent_Q_GB=B.Oent_Q_GB \n";	
		sSQLs+="				AND A.Current_Year=B.Current_Year \n";	
		sSQLs+="				AND ( NVL(A.A,'2')=NVL(B.CHK_V_A,'3') \n";	
		sSQLs+="					OR NVL(A.B,'2')=NVL(B.CHK_V_B,'3') \n";	
		sSQLs+="					OR NVL(A.C,'2')=NVL(B.CHK_V_C,'3') \n";	
		sSQLs+="					OR NVL(A.D,'2')=NVL(B.CHK_V_D,'3') \n";	
		sSQLs+="					OR NVL(A.E,'2')=NVL(B.CHK_V_E,'3') \n";	
		sSQLs+="					OR NVL(A.F,'2')=NVL(B.CHK_V_F,'3') \n";	
		sSQLs+="					OR NVL(A.G,'2')=NVL(B.CHK_V_G,'3') \n";	
		sSQLs+="					OR NVL(A.H,'2')=NVL(B.CHK_V_H,'3') \n";	
		sSQLs+="					OR NVL(A.I,'2')=NVL(B.CHK_V_I,'3') \n";	
		sSQLs+="					OR NVL(A.J,'2')=NVL(B.CHK_V_J,'3') \n";	
		sSQLs+="					OR NVL(A.K,'2')=NVL(B.CHK_V_K,'3') \n";	
		sSQLs+="					OR NVL(A.L,'2')=NVL(B.CHK_V_L,'3') \n";	
		sSQLs+="					OR NVL(A.M,'2')=NVL(B.CHK_V_M,'3') \n";	
		sSQLs+="					OR NVL(A.N,'2')=NVL(B.CHK_V_N,'3') ) \n";	
		sSQLs+="			) OentAnswer_Result \n";	
		sSQLs+="			WHERE CHKs='1' \n";	
		sSQLs+="			GROUP BY Mng_No, Current_Year, Oent_GB, Oent_Q_CD, Oent_Q_GB, Money_GB \n";	
		sSQLs+="		) AA LEFT JOIN ( \n";	
		sSQLs+="			SELECT Mng_No, Current_Year, Oent_GB, Oent_Type, Oent_Capa, \n";	
		sSQLs+="			Oent_Name, Comp_Status, Oent_Status, Subcon_Type, Addr_Status, \n";	
		sSQLs+="			NVL(CASE Subcon_Type WHEN '1' THEN '0' ELSE \n";
        sSQLs+="				CASE WHEN SP_FLD_01 IS NULL OR SP_FLD_01='NULL' THEN '4' ELSE SP_FLD_01 END \n";
        sSQLs+="			END, 0) TradeST FROM "+currentOent+" \n";	
		sSQLs+="			WHERE Current_Year='"+currentYear+"' \n";	
		sSQLs+="			AND Oent_GB='"+sGB+"' \n";	
		sSQLs+="		) BB \n";	
		sSQLs+="		ON AA.Mng_No=BB.Mng_No \n";	
		sSQLs+="		AND AA.Current_Year=BB.Current_Year \n";	
		sSQLs+="		AND AA.Oent_GB=BB.Oent_GB \n";	
		sSQLs+="	) CCC \n";	
		sSQLs+="	WHERE Oent_Status='1' \n";	
		sSQLs+="	AND Comp_Status='1' \n";	
		sSQLs+="	AND Subcon_Type<='2' \n";	
		sSQLs+="	AND Addr_Status IS NULL \n";	
		sSQLs+="	AND SUBSTR(Mng_No,-7)<>'1234567' \n";
		sSQLs+="	AND LENGTH(Mng_No)>4 \n";
		
		if( !sCapa.equals("") ) {
			sSQLs+="	AND Oent_Capa='"+sCapa+"' \n";	
		}

		if( !sTradeST.equals("") ) {
			sSQLs+="	AND TradeST='"+sTradeST+"' \n";
		}
		sSQLs+="	GROUP BY Mng_No,Oent_GB,Oent_Type,Oent_Name \n";	
		sSQLs+=") vi_Temp \n";
		sSQLs+="GROUP BY Oent_Type \n";
		sSQLs+="ORDER BY Oent_Type \n";	

		//System.out.print(sSQLs);
		pstmt=conn.prepareStatement(sSQLs);
		rs=pstmt.executeQuery();

		nTmpCnt=1;

		int ni=1;

		String oentTypeCode="";

		while( rs.next() ) {
			oentTypeCode=rs.getString(1);
			if( !oentTypeCode.equals(type_CD[ni]) ) {
				while( !type_CD[ni].equals(oentTypeCode) ) {
					ni++;
					nTmpCnt++;
				}
				for(int j=2; j<=Money_CNT+No_Money_CNT+1;j++) {
					Violate_CNT[nTmpCnt][j-1]=rs.getLong(j);
					tot_Violate[nTmpCnt]=tot_Violate[nTmpCnt]+Violate_CNT[nTmpCnt][j-1];
				}
				total_vio=total_vio+tot_Violate[nTmpCnt];
			} else {
				for(int j=2; j<=Money_CNT+No_Money_CNT+1;j++) {
					Violate_CNT[nTmpCnt][j-1]=rs.getLong(j);
					tot_Violate[nTmpCnt]=tot_Violate[nTmpCnt]+Violate_CNT[nTmpCnt][j-1];
				}
				total_vio=total_vio+tot_Violate[nTmpCnt];
			}
			//System.out.println(oentTypeCode+":"+type_CD[ni]+"<br/>");
			ni++;
			nTmpCnt++;
		}
		rs.close();

		for(int k=1; k<=Money_CNT+No_Money_CNT;k++) {
			for(int m=1; m<=oType_CNT;m++) {
				e_total[k]=e_total[k]+Violate_CNT[m][k];
			}
		}
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if ( rs != null )		try{rs.close();}	catch(Exception e) {}
		if ( pstmt != null )	try{pstmt.close();}	catch(Exception e) {}
		if ( conn != null )		try{conn.close();}	catch(Exception e) {}
		if ( resource != null ) resource.release();}
%>

<meta charset="euc-kr">
<script type="text/javascript">
//<![CDATA[
content="";
content+="<table class='resultTable'>";
content+="	<tr>";
content+="		<th rowspan='3'>구분</th>";
content+="		<th rowspan='3'>위반행위수</th>";
content+="		<th colspan='<%=Money_CNT+1%>'>대금관련 위반사항(<%=Money_CNT%>)</th>";
content+="		<th colspan='<%=No_Money_CNT+1%>'>비대금관련 위반사항(<%=No_Money_CNT%>)</th>";
content+="  </tr>";

content+="	<tr>";
	<%for(int i=1; i<= Money_CNT; i++) {%>
content+="		<th><%=Money_NM[i]%></th>";
	<%}%>
content+="		<th rowspan='2'>소계</th>";
	<%for(int i=1; i<=No_Money_CNT;i++) {%>
content+="		<th><%=No_Money_NM[i]%></th>";
	<%}%>
content+="		<th rowspan='2'>소계</th>";
content+="  </tr>";

content+="	<tr>";
	<%for(int i=1;i<=Money_CNT;i++) {%>
content+="		<th><%=Money_CD[i]%></th>";
	<%}%>
	<%for(int i=1;i<=No_Money_CNT;i++) {%>
content+="		<th><%=No_Money_CD[i]%></th>";
	<%}%>
content+="  </tr>";

<%if( !stt.equals("start") ) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan='2'>계</th>";
content+="		<th rowspan='2'><%=total_vio%></th>";
	<%for(int i=1; i<=Money_CNT; i++) {%>
content+="		<td><%=e_total[i]%></td>";
		<%tot_Money_CNT=tot_Money_CNT + e_total[i];%>
	<%}%>
content+="		<td><%=tot_Money_CNT%></td>";
	<%for(int i=Money_CNT+1; i<= Money_CNT+No_Money_CNT; i++) {%>
content+="		<td><%=e_total[i]%></td>";
		<%tot_No_Money_CNT=tot_No_Money_CNT + e_total[i];%>
	<%}%>
content+="		<td><%=tot_No_Money_CNT%></td>";
content+="  </tr>";

content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
	<%for(int i=1; i<=Money_CNT; i++) {%>
content+="		<td><%=formater.format((float)e_total[i]/(float)total_vio*100F)%>%</td>";
	<%}%>
content+="		<td><%=formater.format((float)tot_Money_CNT/(float)total_vio*100F)%>%</td>";
	<%for(int i=Money_CNT+1; i<=Money_CNT+No_Money_CNT; i++) {%>
content+="		<td><%=formater.format((float)e_total[i]/(float)total_vio*100F)%>%</td>";
	<%}%>
content+="		<td><%=formater.format((float)tot_No_Money_CNT/(float)total_vio*100F)%>%</td>";
content+="  </tr>";

	<%for(int k=1; k <=oType_CNT; k++) {%>
content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
content+="		<th rowspan='2'><%=oType[k]%></th>";
content+="		<th rowspan='2'><%=tot_Violate[k]%></th>";
		<%typ_Money_CNT=(long)0;%>
		<%for(int i=1; i<=Money_CNT;i++) {%>
content+="		<td><%=Violate_CNT[k][i]%></td>";
			<%typ_Money_CNT=typ_Money_CNT + Violate_CNT[k][i];%>
		<%}%>
content+="		<td><%=typ_Money_CNT%></td>";
		<%typ_No_Money_CNT=(long)0;%>
		<%for(int i=Money_CNT+1; i<=Money_CNT+No_Money_CNT; i++) {%>
content+="		<td><%=Violate_CNT[k][i]%></td>";
			<%typ_No_Money_CNT=typ_No_Money_CNT + Violate_CNT[k][i];%>
		<%}%>
content+="		<td><%=typ_No_Money_CNT%></td>";
content+="  </tr>";

content+="	<tr onMouseOver='tbRow_Over(this)' onMouseOut='tbRow_Out(this)'>";
		<%for(int i=1 ; i<=Money_CNT; i++) {%>
			<%if( tot_Violate[k] > 0 ) {%>
content+="		<td><%=formater.format((float)Violate_CNT[k][i]/(float)tot_Violate[k]*100F)%>%</td>";
			<%} else {%>
content+="		<td>0.00%</td>";
			<%}%>
		<%}%>
		
		<%if( tot_Violate[k] > 0) {%>
content+="		<td><%=formater.format((float)typ_Money_CNT/(float)tot_Violate[k]*100F)%>%</td>";
		<%} else {%>
content+="		<td>0.00%</td>";
		<%}%>
		
		<%for(int i=Money_CNT+1 ; i <=Money_CNT+No_Money_CNT; i++) {%>
			<%if( tot_Violate[k] > 0) {%>
content+="		<td><%=formater.format((float)Violate_CNT[k][i]/(float)tot_Violate[k]*100F)%>%</td>";
			<%} else {%>
content+="		<td>0.00%</td>";
			<%}%>
		<%}%>
		
		<%if( tot_Violate[k] > 0) {%>
content+="		<td><%=formater.format((float)typ_No_Money_CNT/(float)tot_Violate[k]*100F)%>%</td>";
		<%} else {%>
content+="		<td>0.00%</td>";
		<%}%>
content+="  </tr>";
	<%}%>
<%}%>
content+="</table>";

top.document.getElementById("divResult").innerHTML=content;
top.setNowProcessFalse();
//]]
</script>

<%@ include file="/hado/wTools/inc/WB_I_Function.jsp"%>