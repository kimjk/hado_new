<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
/**
* 프로젝트명   : 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명   : WB_VP_03_02.jsp
* 프로그램설명  : 회사개요(귀사의 일반현황) 등록
* 프로그램버전  : 3.0.1
* 최초작성일자  : 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
* 작성일자    작성자명        내용
*=========================================================
* 2014-09-14   정광식   최초작성
* 2015-05-07   강슬기   조사문구 변경 및 조사제외대상업체 문항 추가
* 2015-05-12   정광식   조사대상 업체 라디오박스 선택해제 기능 추가 (javascript)
* 2015-05-18   강슬기   내부관리툴에서 파일 업로드 제한
* 2015-12-30   정광식   DB변경으로 인한 인코딩 변경
* 2018-06-22    김보선 Infinity 체크 추가
*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<%@ include file="../Include/WB_Inc_chkSession.jsp"%>

<%
ConnectionResource resource = null;
Connection conn  = null;
PreparedStatement pstmt  = null;
ResultSet rs = null;

String sSQLs    = "";
/**
* 입력정보 저장 변수 선언 및 초기화 시작
*/
String sMngNo = "H";    // 관리번호
String sOentGB = "";    // 업종구분
String sOentType = "";    // 세부업종코드
String sOentName = "";    // 업체명
String sOentCaptine = "";   // 대표자명
String sOentMutualName = "";    // 소속 기업집단명
String sOentZipCode = "";   // 우편번호 전체
//String sOentZipCode1 = "";  // 우편번호 앞자리
//String sOentZipCode2 = "";  // 우편번호 뒷자리
String sOentAddress = "";   // 주소
String sOentTel = "";     // 전화번호
String sOentFax = "";     // 팩스
String sOentSale01 = "0";   // 매출액 (조사년도-2)
String sOentSale02 = "0";   // 매출액 (조사년도-1)
String sOentSsale = "0";    // 하도급 거래금액
String sOentAssets = "0";   // 자산총액
String sOentAssets01 = "0";   // 자산총액
String sOentAssets02 = "0";   // 자산총액
String sOentCapa = "";    // 회사규모
String sOentCapaTxt = ""; // 회사규모기타
String sOentConAmt = "0"; // 시공능력평가액
String sOentEmpCnt = "0"; // 상시고용종업원 수
String sOentEmpCnt01 = "0"; // 상시고용종업원 수
String sOentEmpCnt02 = "0"; // 상시고용종업원 수
String sOentCoGB = "";    // 기업규모
String sOentCoNo = "";    // 법인등록번호 전체
String sOentCoNo1 = "";   // 법인등록번호 앞자리
String sOentCoNo2 = "";   // 법인등록번호 뒷자리
String sOentSaNo = "";    // 사업자등록번호 전체
String sOentSaNo1 = "";   // 사업자등록번호 앞자리
String sOentSaNo2 = "";   // 사업자등록번호 중간자리
String sOentSaNo3 = "";   // 사업자등록번호 뒷자리
String sOentEmail = "";   // 이메일 전체
String sOentEmail1 = "";    // 이메일 앞 주소
String sOentEmail2 = "";    // 이메일 뒷 주소
String sWriterName = "";    // 작성자명
String sWriterOrg = "";   // 작성자 부서명
String sWriterJikwi = "";   // 작성자 직위명
String sWriterTel = "";     // 작성자 전화번호
String sWriterFax = "";   // 작성자 FAX
String sWriterDate = "";    // 작성일자
String sCompStatus = "";    // 회사영업상태
String sQ1Etc = "";       // 회사영업상태 기타답변
String sAddrStatus = "";    // 원사업자요건안됨 여부 (3: 원사업자요건 안됨)
String sSubconType = "";    // 하도급거래형태
String sSubconCnt = "0";    // 수급사업자 수
//String sSubconCnt1 = "0";   // 수급사업자 수
String sOentStatus = "";    // 전송여부
String sCompUrl = "";     // 홈페이지 주소
String sOentTypeDetail = "";  // 하도급거래단계
String sOentCnt = "0";      // 총 거래업체 수
//String sOentCnt1 = "0";     // 총 거래업체 수
//2015-05-07 / 조사제외대상여부 변수 설정 / 강슬기
String sOentNoExcept = "";      // 조사제외대상여부

String sOentIncorp = "";    //설립연월
String sOentIncorp1 = "";   //설립연
String sOentIncorp2 = "";   //설립월

String sOentOper01 = "0";
String sOentOper02 = "0";
String sOentOper03 = "0";

String sfile = ""; // 제외대상자 증빙자료 업로드

int nCurrentYear = 0;   // 조사년도 정수 변환
/**
* 입력정보 저장 변수 선언 및 초기화 끝
*/

/* 항목표시중 과년도 항목 표시 계산을 위해 조사년도 정수형 변환 */
if( !ckCurrentYear.equals("") ) {
  nCurrentYear = Integer.parseInt(ckCurrentYear);
}

/* 작성일자 표시를 위해 java 캘린더 라이브러리 참조 */
java.util.Calendar cal = java.util.Calendar.getInstance();

if ( !ckMngNo.equals("") && !ckCurrentYear.equals("") && !ckOentGB.equals("") ) {
  /* 이미 회사개요(귀사의 일반현황)이 입력되어 있는 경우 정보 가져오기  시작*/
  try {
    resource = new ConnectionResource();
    conn = resource.getConnection();

    sSQLs   = "SELECT A.*, \n";  
      sSQLs   += "(SELECT file_name \n";  
      sSQLs   += "FROM hado_tb_oent_attach_file \n";
      sSQLs   += "WHERE mng_no = ? \n";
      sSQLs   += "AND current_year = ? \n";
      sSQLs   += "AND oent_gb = ? \n";
      sSQLs   += "AND file_sn = (SELECT MAX(file_sn) FROM hado_tb_oent_attach_file \n";
      sSQLs   += "WHERE mng_no = ? \n";
      sSQLs   += "AND current_year = ? \n";
      sSQLs   += "AND oent_gb = ? ) ) sfile \n";    
      sSQLs   += "FROM hado_tb_oent_" +ckCurrentYear+ " A \n";
      sSQLs   += "WHERE A.mng_no = ? AND A.current_year = ? AND A.oent_gb = ? \n";
    
        pstmt = conn.prepareStatement(sSQLs);
    
        pstmt = conn.prepareStatement(sSQLs);
        pstmt.setString(1, ckMngNo);
        pstmt.setString(2, ckCurrentYear);
        pstmt.setString(3, ckOentGB);
        pstmt.setString(4, ckMngNo);
        pstmt.setString(5, ckCurrentYear);
        pstmt.setString(6, ckOentGB);
        pstmt.setString(7, ckMngNo);
        pstmt.setString(8, ckCurrentYear);
        pstmt.setString(9, ckOentGB);
        
    rs = pstmt.executeQuery();
    
    if (rs.next()) {
      sMngNo = rs.getString("mng_no")==null ? "H":rs.getString("mng_no");
      sOentGB = rs.getString("oent_gb")==null ? "":rs.getString("oent_gb");
      sOentType = rs.getString("oent_type")== null ? "":rs.getString("oent_type");
      sOentName = rs.getString("oent_name")==null ? "":rs.getString("oent_name");
      sOentCaptine = rs.getString("oent_captine")==null ? "":rs.getString("oent_captine");
      sOentMutualName = rs.getString("oent_mutual_name")==null ? "":rs.getString("oent_mutual_name");
      sOentZipCode = rs.getString("zip_code")==null ? "":rs.getString("zip_code");
      sOentAddress = rs.getString("oent_address")==null ? "":rs.getString("oent_address");
      sOentTel = rs.getString("oent_tel")==null ? "":rs.getString("oent_tel");
      sOentFax = rs.getString("oent_fax")==null ? "":rs.getString("oent_fax");
      sOentSale01 = rs.getString("oent_sale01")==null ? "0":rs.getString("oent_sale01");
      sOentSale02 = rs.getString("oent_sale02")==null ? "0":rs.getString("oent_sale02");
      sOentSsale = rs.getString("oent_ssale")==null ? "0":rs.getString("oent_ssale");
      sOentAssets = rs.getString("oent_assets")==null ? "0":rs.getString("oent_assets");
      sOentAssets01 = rs.getString("oent_assets01")==null ? "0":rs.getString("oent_assets01");
      sOentAssets02 = rs.getString("oent_assets02")==null ? "0":rs.getString("oent_assets02");
      sOentConAmt = rs.getString("oent_con_amt")==null ? "0":rs.getString("oent_con_amt");
      sOentCapa = rs.getString("oent_capa")==null ? "":rs.getString("oent_capa");
      sOentCapaTxt = rs.getString("sp_fld_05")==null ? "":rs.getString("sp_fld_05");
      sOentEmpCnt = rs.getString("oent_emp_cnt")==null ? "0":rs.getString("oent_emp_cnt");
      sOentEmpCnt01 = rs.getString("oent_emp_cnt01")==null ? "0":rs.getString("oent_emp_cnt01");
      sOentEmpCnt02 = rs.getString("oent_emp_cnt02")==null ? "0":rs.getString("oent_emp_cnt02");
      sOentCoGB = rs.getString("oent_co_gb")==null ? "":rs.getString("oent_co_gb");
      sOentCoNo = rs.getString("oent_co_no")==null ? "":rs.getString("oent_co_no");
      sOentSaNo = rs.getString("oent_sa_no")==null ? "":rs.getString("oent_sa_no");
      sCompUrl = rs.getString("comp_url")==null ? "":new String(rs.getString("comp_url"));
      sOentEmail = rs.getString("assign_mail")==null ? "":new String(rs.getString("assign_mail"));
      sWriterName = rs.getString("writer_name")==null ? "":rs.getString("writer_name");
      sWriterOrg = rs.getString("writer_org")==null ? "":rs.getString("writer_org");
      sWriterJikwi = rs.getString("writer_jikwi")==null ? "":rs.getString("writer_jikwi");
      sWriterTel = rs.getString("writer_tel")==null ? "":rs.getString("writer_tel");
      sWriterFax = rs.getString("writer_fax")==null ? "":rs.getString("writer_fax");
      sWriterDate = rs.getString("write_date")==null ? "":rs.getString("write_date");
      sCompStatus = rs.getString("comp_status")==null ? "":rs.getString("comp_status");
      sQ1Etc = rs.getString("sp_fld_03")==null ? "":rs.getString("sp_fld_03");
      sSubconType = rs.getString("subcon_type")==null ? "":rs.getString("subcon_type");
      sSubconCnt = rs.getString("subcon_cnt")==null ? "0":rs.getString("subcon_cnt");
      //sSubconCnt1 = rs.getString("subcon_cnt1")==null ? "0":rs.getString("subcon_cnt1");
      sAddrStatus = rs.getString("addr_status")==null ? "":rs.getString("addr_status");
      sOentStatus = rs.getString("oent_status")==null ? "":rs.getString("oent_status");
      sOentTypeDetail = rs.getString("sp_fld_01")==null ? "":rs.getString("sp_fld_01");
      sOentCnt = rs.getString("subcon_tot_cnt")==null ? "0":rs.getString("subcon_tot_cnt");
      //sOentCnt1 = rs.getString("subcon_tot_cnt1")==null ? "0":rs.getString("subcon_tot_cnt1");
      //2015-05-07 / DB에 등록할 Record 설정 / 강슬기
      sOentNoExcept = rs.getString("sp_fld_02")==null ? "":rs.getString("sp_fld_02");
      
      sOentIncorp = rs.getString("oent_incorp")==null ? "":rs.getString("oent_incorp");
      
      sOentOper01 = rs.getString("oent_oper01")==null ? "0":rs.getString("oent_oper01");
      sOentOper02 = rs.getString("oent_oper02")==null ? "0":rs.getString("oent_oper02");
      sOentOper03 = rs.getString("oent_oper03")==null ? "0":rs.getString("oent_oper03");
      
      // 제외대상자 증빙자료 업로드 파일 (최종 파일)
        sfile = rs.getString("sfile")==null ? "":rs.getString("sfile"); 
      
      /* 법인등록번호 분할 */
      String[] arrTmpCoNo = sOentCoNo.split("-");
      if( arrTmpCoNo.length==2 ) {
        sOentCoNo1  = arrTmpCoNo[0];
        sOentCoNo2  = arrTmpCoNo[1];
      }

      /* 사업자등록번호 분할 */
      String[] arrTmpSaNo = sOentSaNo.split("-");
      if( arrTmpSaNo.length==3 ) {
        sOentSaNo1 = arrTmpSaNo[0];
        sOentSaNo2 = arrTmpSaNo[1];
        sOentSaNo3 = arrTmpSaNo[2];
      }

      /* 이메일주소 분할 */
      String[] arrTmpEmail = sOentEmail.split("@");
      if( arrTmpEmail.length==2 ) {
        sOentEmail1 = arrTmpEmail[0];
        sOentEmail2 = arrTmpEmail[1];
      }
      
      /* 설립연월 */
      String[] arrTmpIncorp = sOentIncorp.split("-");
      if( arrTmpIncorp.length==2 ) {
        sOentIncorp1 = arrTmpIncorp[0];
        sOentIncorp2 = arrTmpIncorp[1];
      }

      /* 원사업자 요건안됨 보정 (요건안됨 '3' 만 허용) */
      /* 2015-05-07 / 조사제외대상여부 문구 추가에 따른 문구 숨김 / 강슬기
      if( !sAddrStatus.equals("3") ) sAddrStatus = "";
      */
    }
    rs.close();
  } catch(Exception e){
    e.printStackTrace();
  } finally {
    if ( rs != null ) try{rs.close();}    catch(Exception e){}
    if ( pstmt != null )  try{pstmt.close();} catch(Exception e){}
    if ( conn != null )   try{conn.close();}  catch(Exception e){}
    if ( resource != null ) resource.release();
  }
  /* 이미 회사개요(귀사의 일반현황)이 입력되어 있는 경우 정보 가져오기  끝 */
}
/*=====================================================================================================*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--[if lt IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie6"><![endif]-->
<!--[if IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie7"><![endif]-->
<!--[if IE 8]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie8"><![endif]-->
<!--[if (gt IE 8)|!(IE)]><!-->
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko-KR" class="no-js">
<!--<![endif]-->
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta http-equiv='Cache-Control' content='no-cache' />
    <meta http-equiv='Pragma' content='no-cache' />
    <title><%= nCurrentYear %>년도 하도급거래 서면실태 조사</title>
    <link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="euc-kr" />
    <link href="style.css" rel="stylesheet" type="text/css" />
    <!-- // IE  // -->
  <!--[if IE]><script src="../js/html5.js"></script><![endif]-->
  <!--[if IE 7]>
  <script src="../js/ie7/IE7.js"  type="text/javascript"></script>
  <script src="../js/ie7/ie7-squish.js"  type="text/javascript"></script>
  <![endif]-->
    <script src="../js/jquery-1.7.min.js"></script>
    <script type="text/javascript">jQuery.noConflict();</script>
    <script src="../js/mootools-core-1.3.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/mootools-more-1.3.1.1.js" type="text/javascript" charset="utf-8"></script>
    <script src="../js/simplemodal.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/commonScript.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/login_2019.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/credian_common_script.js" type="text/javascript"  charset="euc-kr"></script>
    <script language="JavaScript">
    ns4 = (document.layers)? true:false
    ie4 = (document.all)? true:false

    var msg = "";

    function savef() {
      var cchekc = "no", i, j;
      var main = document.info;
      msg = "";

      // 필수사항 확인 
      if(main.rcomp.value=="")
        msg+="\n회사명을 입력해 주세요.";
      if(main.rcogb[0].checked!=true&&main.rcogb[1].checked!=true)
        msg+="\n법인등록여부를 입력해주세요.";
      else {
        if(main.rcogb[0].checked==true) {
          if(main.rlawno1.value=="" || main.rlawno2.value=="")
            msg+="\n법인등록번호를 입력해 주세요.";
          else
            main.rlawno.value = main.rlawno1.value + "-" + main.rlawno2.value;
        }
      }
      if(main.rregno1.value=="" || main.rregno2.value=="" || main.rregno3.value==""){
        msg+="\n사업자등록번호를 입력해 주세요.";
      } else {
        main.rregno.value = main.rregno1.value+"-"+main.rregno2.value+"-"+main.rregno3.value;
      }
      if(main.raddr.value=="")
        msg+="\n본사 소재지를 입력해 주세요.";
      if(main.remail1.value=="" || main.remail2.value=="")
        msg+="\작성책임자 E-mail주소를 입력해 주세요.";
      if(main.rname.value=="")
        msg+="\n작성책임자 성명을 입력해 주세요.";
      if(main.rposition.value=="")
        msg+="\n작성책임자 직위를 입력해 주세요.";
      if(main.rtel.value=="")
        msg+="\n작성책임자 전화번호를 입력해 주세요.";

        // 영업상태 검증
      if( jQuery("input:radio[name='q0']").is(":checked")) {
          if( jQuery("input[name='fileCheck']").val() == "N" ) {
            msg += "\n제외대상자 증빙서류를 첨부하여 주세요.";
          }
      }
      // 첨부파일 업로드 되면 조사제외 항목 선택 필수
      if( jQuery("input[name='fileCheck']").val() == "Y" ) {
          if(!jQuery("input:radio[name='q0']").is(":checked") ){
            msg += "\n조사제외 대상 항목을 선택해주세요.";
          }
      }
      
      var cstatus = jQuery("input:radio[name='q1']:checked").val();
    if( cstatus!="1" ) {
      if(!jQuery("input:radio[name='q0']").is(":checked")) {
          msg += "\n정상영업이 아닌경우 조사제외 대상 항목을 선택해주세요.";
        }
    }
      

      if(msg!="") msg+="\n";


      researchf(main.q1,2,"회사개요의 1번 영업상태를 선택해주세요");
      researchf(main.q2,2,"회사개요의 2번 회사규모를 선택해주세요");
      researchf(main.q3_3,1,"회사개요의 3번 <%= nCurrentYear-3%>년 매출액을 입력해주세요");
      researchf(main.q3_1,1,"회사개요의 3번 <%= nCurrentYear-2%>년 매출액을 입력해주세요");
      researchf(main.q3_2,1,"회사개요의 3번 <%= nCurrentYear-1%>년 매출액을 입력해주세요");
      researchf(main.q3_4,1,"회사개요의 3번 <%= nCurrentYear-3%>년 영업비용을 입력해주세요");
      researchf(main.q3_5,1,"회사개요의 3번 <%= nCurrentYear-2%>년 영업비용을 입력해주세요");
      researchf(main.q3_6,1,"회사개요의 3번 <%= nCurrentYear-1%>년 영업비용을 입력해주세요");
      researchf(main.q3_7,1,"회사개요의 3번 <%= nCurrentYear-3%>년 자산총액을 입력해주세요");
      researchf(main.q3_8,1,"회사개요의 3번 <%= nCurrentYear-2%>년 자산총액을 입력해주세요");
      researchf(main.q3_9,1,"회사개요의 3번 <%= nCurrentYear-1%>년 자산총액을 입력해주세요");
      researchf(main.q4,1,"회사개요의 4번 총근 로자수를 입력해주세요");
      researchf(main.q4_1,1,"회사개요의 4번 상용 근로자수를 입력해주세요");
      researchf(main.q4_2,1,"회사개요의 4번 임시 및 일용 근로자수를 입력해주세요");
      

      if(msg!="") msg+="\n";

      var mutualName = main.mutualName.value;
      if(mutualName != null && mutualName != "") {
        mutualName = mutualName.replace(/\'/g, '');
        mutualName = mutualName.replace(/\"/g, '');
        
        main.mutualName.value = mutualName;
      }

      if(msg=="") {
        if(confirm("[ 회사개요를 저장합니다. ]\n\n접속자가 많을경우 다소 시간이 걸릴수도 있습니다.\n정상적으로 저장이 안될경우\n수십분후에 다시시도하여 주십시오.\n\n서버의 부하로 저장에 실패할경우\n응답하신 조사내용을 복구할 수 없습니다.\n응답하신 조사표를 인쇄하여 보관하시고\n오류페이지에서 마우스오른쪽 버튼을 눌러\n새로고침을 선택하여 재저장을 시도하십시오.\n\n확인을 누르시면 저장합니다.")) {

          processSystemStart("[1/1] 입력한 회사개요을 저장합니다.");

          main.target = "ProceFrame";
          main.action = "WB_CP_Research_Qry.jsp?type=Srv&step=Basic";
          main.submit();
        }
      } else {
        alert(msg+"\n\n저장이 취소되었습니다.")
      }
    }

    function researchf(obj,type,mm) {
      var ccheck="no", i;

      switch (type) {
        case 1:
          if(obj.value=="") msg+="\n"+mm;
          break;
        case 2:
          for(i=0;i<obj.length;i++)
            if(obj[i].checked==true) ccheck="yes";
          if(ccheck=="no") msg+="\n"+mm;
          break;
      }
    }
    

    function formatmoney(m) {
      var money, pmoney, mlength, z, textsize, i;
      textsize=20;
      pmoney="";
      z=0;
      money=m;
      money=clearstring(money);
      money=Number(money);
      money=money+"";
      for(i=money.length-1;i>=0;i--) {
        z+=1;
        if(z%3==0) {
          pmoney=money.substr(i,1)+pmoney;
          if(i!=0)
            pmoney=","+pmoney;
        }
        else pmoney=money.substr(i,1)+pmoney;
      }
      return pmoney;
    }

    function clearstring(s) {
      var pstr, sstr, iz;
      sstr=s;
      pstr="";
      for(iz=0;iz<sstr.length;iz++)
        {
        if(!isNaN(sstr.substr(iz,1))||sstr.substr(iz,1)==".") pstr=pstr+sstr.substr(iz,1);
        }
      return pstr;
    }

    function HelpWindow(url, w, h) {
      helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=no,scrollbars=no,resize=no,menubar=no,location=no");
      helpwindow.focus();
    }

    function HelpWindow2(url, w, h) {
      helpwindow = window.open(url, "HelpWindow", "toolbar=no,width="+w+",height="+h+",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
      helpwindow.focus();
    }

    function fMoveTo(url) {
      if(confirm("다음단계로의 이동을 선택하셨습니다.\n\n선택하신 기능은 최후 저장 후 변경한 내용을\n저장하지 않고 이동합니다.\n변경한 내용이 있을경우 저장 후 선택하십시오.\n\n확인을 누르시면 이동합니다.")) {
        location.href = url;
      }
    }

    function OpenPost() {
      MsgWindow = window.open("WB_Find_Zip.jsp?ITEM=F&stype=nomr","_PostSerch","toolbar=no,width=430,height=320,directories=no,status=yes,scrollbars=yes,resize=no,menubar=no");
    }

    function onDocument() {
    }

    function goPrint() {
      print();
    }

    function chkCompStatus() {
      var cstatus = jQuery("input:radio[name='q1']:checked").val();
      if( cstatus!="1" ) {
        if( jQuery("#attachFileYN").val()!="Y" ) {
          alert("정상영업이 아닌경우 증빙자료를 첨부하여야 합니다.\n첨부할 증빙서류는 본페이지 상단 안내를 참고하시기 바랍니다.");
        }
        jQuery("#lyAttachFile").css({"display":"block"});
      } else {
        jQuery("#lyAttachFile").css({"display":"none"});
      }
    }


    function doFileupload() {
      window.open("WB_Edoc_Up.jsp","_blank","toolbar=no,width=450,height=380,directories=no,status=no,scrollbars=Yes,resize=no,menubar=no");
    }

    function refreshAttachFileList() {
      jQuery.ajax({
        type : "post",
        url : "WB_AP_getAttachFile_List.jsp",
        cache : false,
        data : "",
        ascync : false,
        datatype : "html",
        success : function(data) {
          var msg = data.replace(/(^\s*)|(\s*$)/gi,""); // 공백제거 정규식
          if( msg!= "") {
            jQuery("#lyAttachFileBody").html(msg);
            jQuery("#attachFileYN").attr("value","Y");
                    }
        },
        error : function() {
          alert("서버와 통신중 오류가 발생하였습니다.\n\n잠시 후 다시 시도해 주시기 바랍니다.");
        }
      });
    }

    // Radio object 재선택시 초기화
    function checkradioUnit(valObj,radioObj) {
      eval("oldValue = document.info."+valObj+".value");
      eval("obj = document.info."+radioObj);
      selValue = "";

      for(i=0; i<obj.length; i++) {
        if(obj[i].checked==true) {
          selValue = obj[i].value;
          if( selValue==oldValue ) {
            obj[i].checked = false;
            eval("document.info."+valObj+".value=''");
          } else {
            eval("document.info."+valObj+".value='"+selValue+"'");
          }
          break;
        }
      }
    }
    
    function Cnum(aa) {
      bb  = aa + "";

      while (bb.indexOf(",") != -1)
      {
        bb=bb.replace(",","") ;
      }

      if(isNaN(bb)||bb==''||bb==null) return 0
      else              return Number(bb);
    }
    
    
    function f_oent(main) {
          
      <%/* 2018-06-22   김보선 9번 항목에서 수급사업자 수를 0으로 할 경우 Infinity 로 출력 되어 오라클에 저장 시 오류 남.
        Infinity 체크 추가
       */%>
      main.q12_1.value= isFinite(avg(main.q10_1.value, main.q11_1.value))?avg(main.q10_1.value, main.q11_1.value):0;
      main.q12_2.value= isFinite(avg(main.q10_2.value, main.q11_2.value))?avg(main.q10_2.value, main.q11_2.value):0;
      main.q9_3.value = percent(main.q9_2.value, main.q9_1.value);
      main.q10_3.value = percent(main.q10_2.value, main.q10_1.value);
      main.q11_3.value = percent(main.q11_2.value, main.q11_1.value);
      main.q12_3.value = percent(main.q12_2.value, main.q12_1.value);
      
    }
    
    function f_oent01(main) {
      
      main.q8_0.value = Number(main.q8_1.value)+Number(main.q8_2.value)+Number(main.q8_3.value)+Number(main.q8_4.value)+Number(main.q8_5.value)+Number(main.q8_6.value);
      
    }
    
    function avg(a, b) {
            if(!a || a < 1) {
                return 0;
            }
            if(!b) {
              b = 0;
            }
            return Cnum(Math.round(Cnum(a)/Cnum(b)));
        }
        
        function percent(a, b) {
          if(!b || b < 1) {
                return 0;
            }
          if(!a) {
            a = 0;
          }
            return Cnum(Math.round(Cnum(a)/Cnum(b) * 100));
        }
        
        var beforeChecked = -1;
        jQuery(function(){
            jQuery(document).on("click", "input[type=radio][name=q0]", function(e){
                var index = jQuery(this).val();
                //alert(index);
                if(beforeChecked == index){
                    beforeChecked = -1;
                    jQuery(this).prop("checked", false);
                }else{
                    beforeChecked = index;   
                }
            });
        });
        
  </script>
</head>

<body onload="onDocument();">

  <div id="container">
  <div id="wrapper">
    <!-- Begin Header -->
    <div id="subheader">
      <ul class="lt">
        <li class="fl"><a href="#none" onfocus="this.blur()"><img src="img/logo.jpg" width="242" height="55"/></a></li>
        <li class="fr">
          <ul class="lt">
            <li class="pt_20"><font color="#FF6600">[용역업]</font>
              <%=ckOentName%>&nbsp;/&nbsp;<iframe src="../Include/WB_CLOCK_2011.jsp" name="TimerArea" id="TimerArea" width="220" height="22" marginwidth="0" marginheight="1" align="center" frameborder="0"></iframe></li>
          </ul>
        </li>
      </ul>
    </div>
    <div id="submenu">
      <ul class="lt fr">
        <li class="fl pr_2"><a href="./WB_VP_Introduction.jsp" onfocus="this.blur()" class="mainmenu">1. 조사 안내</a></li>
        <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_02.jsp" onfocus="this.blur()" class="mainmenuup">2. 회사개요</a></li>
        <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="mainmenu">3. 하도급 거래상황</a></li>
        <li class="fl pr_2"><a href="./WB_VP_Subcon.jsp" onfocus="this.blur()" class="mainmenu">4. 수급사업자 명부</a></li>
        <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="mainmenu">5. 조사표 전송</a></li>
      </ul>
    </div>
    <!-- End Header -->
    <form action="" method="post" id="info" name="info">
    <!-- Begin subcontent -->
    <div id="subcontent">
      <!-- title start -->
      <h1 class="contenttitle">2. 회사개요</h1>
      <!-- title end -->


      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="lt">
            <li class="boxcontenttitle">회사개요 작성안내</li>
            <li class="boxcontentsubtitle">조사제외 대상 안내 및 제출방법 안내</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="clt">
            <li><span>▣ </span><strong>다음의 경우</strong>는 <strong>조사 대상이 아닐 수 있으므로</strong>,&nbsp;①<strong>「2. 회사 개요」부분까지 입력</strong>하고, ③ 조사제외 대상임을 입증할 수 있는 <strong>증빙자료(PDF파일)를 사이트에 업로드</strong>하신 후, ③ <strong>「3. 하도급거래상황」의 5번문항(하도급거래형태)에 "다. 하도급거래를 하지 않음"을 선택하고 저장</strong>, ④<strong>&lt;조사표 전송&gt; 메뉴를 실행</strong>하여 주시기 바랍니다.</li>
            <%-- <li><span>▣ </span>조사제외 대상 사유가<strong> 정상영업이 아닌경우(아래의 ③, ④, ⑤항목에 해당하는 경우)</strong>는 <strong>증빙자료를 파일로 첨부</strong>하여 전송하여 주시기 바랍니다.</li>--%>
            <li><span>▣ </span>다만, 조사제외 대상으로 자료를 제출하실 경우, 제출 자료의 사실관계 여부를 확인하기 위해 추후 현장조사를 실시할 수 있음</li>
            <li>&nbsp;</li>
            <li><p align="center">- 다 음 - </p></li>
            <li>&nbsp;</li>
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:50%;" />
                  <col style="width:50%;" />
                </colgroup>
                <thead>
                  <tr>
                    <th height="35"><strong>조사 제외 대상</strong></th>
                    <th height="35"><strong>관련 증빙자료(제출해야 할 자료)</strong></th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>① '원사업자' 요건에 해당하지 않는 경우</td>
                    <td>- <%=nCurrentYear-2%>년도 손익계산서 (제조, 용역 업종)<br/>
                    - <%=nCurrentYear-1%>년 시공능력평가액 (건설 업종)</td>
                  </tr>
                  <tr>
                    <td>② 하도급거래가 없거나 하도급을 받기만 하는 경우</td>
                    <td>- 귀사의 거래내용(품목) 및 거래형태 등을 이해할<br/>
                      &nbsp;&nbsp;&nbsp;수 있는 소명자료(별도 양식 없음)<br/>
                      - 원료구입부터 제품완성 및 포장까지의 생산공정 <br/>
                      &nbsp;&nbsp;&nbsp;프로세스 등을 포함하여 설명</td>
                  </tr>
                  <tr>
                    <td>③ "채무자회생 및 파산에 관한법률" 에 의한 회생절<br/>
                      &nbsp;&nbsp;&nbsp;&nbsp;차 또는 기업개선작업(work-out)이 진행 중인 경우</td>
                    <td>- 회생절차 개시결정 관련 법원판결문 또는 기업개선<br/>
                      &nbsp;&nbsp;&nbsp;작업이 진행 중임을 알 수 있는 증빙자료</td>
                  </tr>
                  <tr>
                    <td>④ 부도나 영업중단 또는 폐업한 경우</td>
                    <td>- 부도사실 확인원 또는 폐업사실증명원 등</td>
                  </tr>
                  <tr>
                    <td>⑤ 다른 회사에 흡수합병된 경우</td>
                    <td>- 합병관련 계약서, 법인등기부 등본 등</td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="lt">
            <li class="boxcontenttitle">조사제외 대상 증빙자료</li>
            <li class="boxcontentsubtitle"></li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="clt">
            <li><span>▣ </span>조사제외 대상이 되시는 경우 조사제외 대상임을 입증할 수 있는 <strong>증빙자료(PDF 파일)를 업로드</strong> 해 주시기 바랍니다.</li>
            <li></li>
            <li><span>▣</span><strong>Step1. 제외대상 항목 선택 (택1)</strong></li>
            <li><input type="radio" name="q0" value="1" <%if(sOentNoExcept!=null && sOentNoExcept.equals("1")){out.print("checked");}%>></input> 1. ‘원사업자’ 요건에 해당하지 않는 경우</li>
            <li><input type="radio" name="q0" value="2" <%if(sOentNoExcept!=null && sOentNoExcept.equals("2")){out.print("checked");}%>></input> 2. 하도급거래가 없거나 하도급을 받기만 하는 경우</li>
            <li><input type="radio" name="q0" value="3" <%if(sOentNoExcept!=null && sOentNoExcept.equals("3")){out.print("checked");}%>></input> 3. “채무자회생 및 파산에 관한법률”에 의한 회생절차 또는 기업개선작업(work-out)이 진행 중인 경우</li>
            <li><input type="radio" name="q0" value="4" <%if(sOentNoExcept!=null && sOentNoExcept.equals("4")){out.print("checked");}%>></input> 4. 부도나 영업중단 또는 폐업한 경우</li>
            <li><input type="radio" name="q0" value="5" <%if(sOentNoExcept!=null && sOentNoExcept.equals("5")){out.print("checked");}%>></input> 5. 다른 회사에 흡수합병된 경우</li>
            <li><input type="radio" name="q0" value="6" <%if(sOentNoExcept!=null && sOentNoExcept.equals("6")){out.print("checked");}%>></input> 6. 2020년 전체 하도급거래에 대해 별도의 공정위 직권조사를 받았거나 받고 있는 경우</li>
            <li></li>
            <li><span>▣</span><strong>Step2. 파일 업로드</strong></li>
            <li><p style="padding-left:60px; width:200px;"><a href="javascript:doFileupload()" onfocus="this.blur()" class="contentbutton2">제외대상자 증빙자료 업로드</a></p></li>
            <li>
                <c:set var="sfile" value="<%=sfile%>" />
                <input type="hidden" name="fileCheck" value="${sfile eq '' ? 'N':'Y'}" />
                <c:if test="${sfile ne ''}">
                  <p style="padding-left:60px; margin: 10px 0px 10px;"><strong>등록한 파일 :</strong><a href="WB_File_Down.jsp?Type=O"><%=sfile%></a></p>
                </c:if>
            </li>
            <li><span>▣</span><strong>Step3. 회사개요 입력 및 내용 저장 후 "3. 하도급거래상황"의 5번문항 (하도급거래형태) 응답, "5. 조사표전송" 으로 이동하여 조사표 전송</strong></li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>


      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="lt">
            <li class="boxcontenttitle">I. 회사개요</li>
            <li class="boxcontentsubtitle">* 회사명은 공백없이 입력.<br/>
            &nbsp;&nbsp;&nbsp;- 입력예시) (주) 회 사 명 <font color="#FF0066">(X)</font> --> (주)회사명 <font color="#FF0066">(0)</font><br/>
            * 사업자등록증에 명시된 회사명(한글/영문)으로 기입.</li>
            <li class="boxcontentsubtitle">&nbsp;</li>
            <li class="boxcontentsubtitle">* 귀사의 소속 기업집단명을 기입하되, 만일<br/> 소속 기업집단이 없을 경우 '해당사항 없음'으로 기입</li>
            <li class="boxcontentsubtitle">&nbsp;</li>
            <li class="boxcontentsubtitle">* 소재지는 우편번호 검색 후 상세주소를 추가로 입력<br/>
              &nbsp;&nbsp;&nbsp;하세요.</li>
            <li class="boxcontentsubtitle">&nbsp;</li>
            <li class="boxcontentsubtitle">* 전화번호 입력 예: 02-123-4567 (대표전화 1개 입력)</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:15%;" />
                  <col style="width:30%;" />
                  <col style="width:15%;" />
                  <col style="width:40%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>관리번호</th>
                    <td><strong><%=sMngNo%></strong></td>
                    <th>회 사 명</th>
                    <td><input type="text" name="rcomp" value="<%=sOentName%>" maxlength="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input></td>
                  </tr>
                  <tr>
                    <th>법인여부</th>
                    <td>
                      <input type="radio" name="rcogb" value="1" <%if(sOentCoGB!=null && sOentCoGB.equals("1")){out.print("checked");}%>></input>법인
                      <input type="radio" name="rcogb" value="0" <%if(sOentCoGB!=null && sOentCoGB.equals("0")){out.print("checked");}%>></input>비법인
                    </td>
                    <th>법인등록번호</th>
                    <td><input type="hidden" name="rlawno" value="<%=sOentCoNo%>"></input>
                      <input type="text" name="rlawno1" value="<%=sOentCoNo1%>" maxlength="6" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rlawno1',6,'rlawno2');"></input>-
                      <input type="text" name="rlawno2" value="<%=sOentCoNo2%>" maxlength="7" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';"></input>
                    </td>
                  </tr>
                  <tr>
                    <th>설립연월</th>
                    <td><input type="hidden" name="rincorp" value="<%=sOentIncorp%>"></input>
                      <input type="text" name="rincorp1" value="<%=sOentIncorp1%>" maxlength="6" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rincorp1',4,'rincorp2');"></input>년
                      <input type="text" name="rincorp2" value="<%=sOentIncorp2%>" maxlength="7" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';"></input>월
                    </td>
                    <th>사업자등록번호</th>
                    <td><input type="hidden" name="rregno" value="<%=sOentSaNo%>"></input>
                      <input type="text" name="rregno1" value="<%=sOentSaNo1%>" maxlength="3" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rregno1',3,'rregno2');"></input>-
                      <input type="text" name="rregno2" value="<%=sOentSaNo2%>" maxlength="2" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';" onKeyUp="fnextTextMove('rregno2',2,'rregno3');"></input>-
                      <input type="text" name="rregno3" value="<%=sOentSaNo3%>" maxlength="5" class="text02b" onFocus="javascript:this.className='text02o';" onBlur="javascript:this.className='text02b';"></input>
                    </td>
                  </tr>
                  <tr>
                    <th>대표자명</th>
                    <td colspan="3">
                      <input type="text" name="rowner" value="<%=sOentCaptine%>" maxlength="16" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
                      <input type="hidden" name="roenttype" value="<%=sOentType%>"/>
                    </td>
                    <%-- <th>산업분류코드</th>
                    <td>
                      <input type="text" name="roenttype" value="<%=sOentType%>" maxlength="5" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>
                    </td> --%>
                  </tr>
                  <tr>
                    <th>소속 기업집단명</th>
                    <td colspan="3"><input type="text" name="mutualName" value="<%=sOentMutualName%>" maxlength="16" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <th rowspan="3">본사</th>
                    <td colspan="3">우편번호 : <input type="text" name="rpost" value="<%=sOentZipCode%>" class="text03b"></input>&nbsp;&nbsp;<a href="javascript:OpenPost();"><img src="img/btn_post.gif" border="0" alt="우편번호 찾기" align="absmiddle"></img></a></td>
                  </tr>
                  <tr>
                    <td colspan="3">소  재  지 : <input type="text" name="raddr" value="<%=sOentAddress%>" maxlength="76" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <td colspan="3">전화번호(지역번호 포함) : <input type="text" name="mtel01" value="<%=sOentTel%>" maxlength="20" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input></td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="lt">
            <li class="boxcontenttitle">II. 조사표 작성책임자</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:20%;" />
                  <col style="width:80%;" />
                </colgroup>
                <tbody>
                  <tr>
                    <th>소속 부서</th>
                    <td><input type="text" name="rdept" value="<%=sWriterOrg%>" maxlength="33" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <th>직위</th>
                    <td><input type="text" name="rposition" value="<%=sWriterJikwi%>" maxlength="16" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <th>성명</th>
                    <td><input type="text" name="rname" value="<%=sWriterName%>" maxlength="16" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <th>전화번호</th>
                    <td><input type="text" name="rtel" value="<%=sWriterTel%>" maxlength="20" class="text01b" onFocus="javascript:this.className='text01o';" onBlur="javascript:this.className='text01b';"></input></td>
                  </tr>
                  <tr>
                    <th>E-mail 주소</th>
                    <td><input type="text" name="remail1" value="<%=sOentEmail1%>" maxlength="26" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input>@<input type="text" name="remail2" value="<%=sOentEmail2%>" maxlength="50" class="text03b" onFocus="javascript:this.className='text03o';" onBlur="javascript:this.className='text03b';"></input></td>
                  </tr>
                  <tr>
                    <th>조사표작성일</th> 
                    <td>
                      <%if ( sWriterDate==null || sWriterDate.equals("") ) {%>
                        <%=cal.get(Calendar.YEAR)%>년 <%=cal.get(Calendar.MONTH)+1%>월 <%=cal.get(Calendar.DATE)%>일
                      <%} else {%><%=sWriterDate%><%}%>
                    </td> 
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>1. </span>귀사의 <%=nCurrentYear-1%>년도 12월 말 기준 영업 상태는 어떠합니까?</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <input type="hidden" name="rnoexptVal" value="<%=sOentNoExcept%>"></input>
          <ul class="lt">
            <li><input type="radio" name="q1" value="1" <%if(sCompStatus!=null && sCompStatus.equals("1")){out.print("checked");}%> onclick="chkCompStatus();"></input> 1. 정상영업</li>
            <li><input type="radio" name="q1" value="2" <%if(sCompStatus!=null && sCompStatus.equals("2")){out.print("checked");}%> onclick="chkCompStatus();"></input> 2. 기업회생 절차 진행 중</li>
            <li><input type="radio" name="q1" value="3" <%if(sCompStatus!=null && sCompStatus.equals("3")){out.print("checked");}%> onclick="chkCompStatus();"></input> 3. 영업중단 중 또는 폐업 진행 중</li>
            <li><input type="radio" name="q1" value="4" <%if(sCompStatus!=null && sCompStatus.equals("4")){out.print("checked");}%> onclick="chkCompStatus();"></input> 4. 다른 회사와 합병 진행 중</li>
            <li><input type="radio" name="q1" value="5" <%if(sCompStatus!=null && sCompStatus.equals("5")){out.print("checked");}%> onclick="chkCompStatus();"></input> 5. 기타(<input type="text" name="q1Etc" value="<%=sQ1Etc%>" size="30" class="text04bl" onFocus="javascript:this.className='text04ol';" onBlur="javascript:this.className='text04bl';"></input>)</li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>
      
      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>2. </span>귀사의 <%=nCurrentYear-1%>년도 12월 말 기준 회사규모는 무엇입니까?</li>
            <li class="boxcontentsubtitle">* 대기업은 공정거래법 제14조제1항의 규정에 의한 '상호출자제한기업집단'에 소속된 회사임</li>
            <li class="boxcontentsubtitle">* 중견기업은 중견기업법 제2조제1호의 규정에 해당하는 회사임</li>
            <li class="boxcontentsubtitle">* 중소기업은 중소기업기본법 제2조의 규정에 해당하는 회사임</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <input type="radio" name="q2" value="1" <%if(sOentCapa!=null && sOentCapa.equals("1")){out.print("checked");}%>></input> 1. 대기업<br/>
              <input type="radio" name="q2" value="2" <%if(sOentCapa!=null && sOentCapa.equals("2")){out.print("checked");}%>></input> 2. 중견기업<br/>
              <input type="radio" name="q2" value="3" <%if(sOentCapa!=null && sOentCapa.equals("3")){out.print("checked");}%>></input> 3. 중소기업(중기업·소기업·소상공인)<br/>
            </li>
            <div class="fc pt_50"></div>
            <div class="fc pt_30"></div>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>3. </span>귀사의 지난 3년간(<%=nCurrentYear-3%>년~<%=nCurrentYear-1%>년) 매출액, 영업비용, 자산총액을 응답해 주십시오.</li>
            <li class="boxcontentsubtitle">* 영업비용은 매출원가, 인건비, 임차료, 세금과공과, 감가상각비 등 생산활동에 소요된 비용을 포괄하며, 손익계산서 상 매출원가와 판매비 및 관리비의 합으로 계산함.</li>
                        <li class="boxcontentsubtitle">* 영업비용의 경우 경제와 관련된 조사들에 대부분 포함되는 질문임. 업계전반을 살피는 목적으로(업황을 파악하는 목적)으로 사용될 예정임.(하도급법 위반과는 상관 없음.)</li>
                        <li class="boxcontentsubtitle">* 영업비용은 손익계산서에 있는 자료 기준으로 입력하되, 영업비용을 구하기 어려우면 대략적인 금액으로 가입</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:30%;" />
                  <col style="width:70%;" />
                </colgroup>
                <tbody>
                  <tr align="center">
                    <th colspan="2">매출액</th>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-3%>년도</th>
                    <td height="40" valign="top"><input type="text" name="q3_3" value="<%=sOentSsale%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount003');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
                      <div id="hanAmount003" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-2%>년도</th>
                    <td height="40" valign="top"><input type="text" name="q3_1" value="<%=sOentSale01%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount001');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
                      <div id="hanAmount001" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-1%>년도</th>
                    <td height="40" valign="top"><input type="text" name="q3_2" value="<%=sOentSale02%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount002');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
                      <div id="hanAmount002" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                </tbody>
              </table>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:30%;" />
                  <col style="width:70%;" />
                </colgroup>
                <tbody>
                  <tr align="center">
                    <th colspan="2">영업비용</th>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-3%>년도</th>
                    <td height="40" valign="top"><input type="text" name="q3_4" value="<%=sOentOper01%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount004');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
                      <div id="hanAmount004" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-2%>년도</th>
                    <td height="40" valign="top"><input type="text" name="q3_5" value="<%=sOentOper02%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount005');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
                      <div id="hanAmount005" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-1%>년도</th>
                    <td height="40" valign="top"><input type="text" name="q3_6" value="<%=sOentOper03%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount006');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
                      <div id="hanAmount006" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                </tbody>
              </table>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:30%;" />
                  <col style="width:70%;" />
                </colgroup>
                <tbody>
                  <tr align="center">
                    <th colspan="2">자산총액</th>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-3%>년도</th>
                    <td height="40" valign="top"><input type="text" name="q3_7" value="<%=sOentAssets%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount007');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
                      <div id="hanAmount007" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-2%>년도</th>
                    <td height="40" valign="top"><input type="text" name="q3_8" value="<%=sOentAssets01%>" onKeyUp="sukeyup(this); amountToHangul(this,'hanAmount008');" maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
                      <div id="hanAmount008" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                  <tr align="center">
                    <th><%= nCurrentYear-1%>년도</th>
                    <td height="40" valign="top"><input type="text" name="q3_9" value="<%=sOentAssets02%>" onkeyup ="sukeyup(this); amountToHangul(this,'hanAmount009');"  maxlength="13" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" ></input> 백만원
                      <div id="hanAmount009" style="color:#ff6600; font-weight:bold; text-align:left;"></div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent">
        <div class="boxcontentleft">
          <ul class="clt">
            <li class="boxcontenttitle"><span>4. </span><%= nCurrentYear-1%>년 12월 말 기준, 귀사의 고용종업원 수를 응답해 주십시오.</li>
            <li class="boxcontentsubtitle">* 상용 근로자 : 계약기간이 1년 이상 또는 무기 계약 중인 근로자로서 원천징수 이행상황 신고서상의 근로소득 같이세액(A01)의 총인원</li>
            <li class="boxcontentsubtitle">* 임시 및 일용 근로자 : 계약기간이 1년 미만인 근로자</li>
          </ul>
        </div>
        <div class="boxcontentright">
          <ul class="lt">
            <li>
              <table class="tbl_blue">
                <colgroup>
                  <col style="width:30%;" />
                  <col style="width:70%;" />
                </colgroup>
                <tbody>
                  <tr align="center">
                    <th>구분</th>
                    <th>근로자 수</th>
                  </tr>
                  <tr align="center">
                    <th>총 근로자</th>
                    <td>
                      <input type="text" name="q4" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=sOentEmpCnt%>" size="6"></input> 명
                    </td>
                  </tr>
                  <tr align="center">
                    <th>상용 근로자</th>
                    <td>
                      <input type="text" name="q4_1" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=sOentEmpCnt01%>" size="6"></input> 명
                    </td>
                  </tr>
                  <tr align="center">
                    <th>임시 및 일용 근로자</th>
                    <td>
                      <input type="text" name="q4_2" onkeyup ="sukeyup(this)" class="text04br" onFocus="javascript:this.className='text04or';" onBlur="javascript:this.className='text04br';" value="<%=sOentEmpCnt02%>" size="6"></input> 명
                    </td>
                  </tr>
                </tbody>
              </table>
            </li>
            <div class="fc pt_10"></div>
          </ul>
        </div>
        <div class="fc"></div>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent2">
        <ul class="boxcontenthelp lt">
          <li class="boxcontenttitle">귀사가 조사제외 대상에 해당하는 경우(맨 윗부분 "작성안내" 란 참조)는 「2. 회사개요」 및「3. 하도급거래현황」의 5번문항 작성 및 저장하시고,「5. 조사표 전송」으로 가셔서 입력내용을 전송해 주십시오. (<span class="pinktext">증빙자료는 파일로 업로드 할 것</span>)</li>
        </ul>
      </div>

      <div class="fc pt_10"></div>

      <div class="boxcontent2">
        <ul class="boxcontenthelp lt">
          <li class="boxcontenttitle"><p align="center"><span class="pinktext">다음 단계로 이동하기 전에 "저장" 버튼을 눌러 작성하신 내용을 저장하시기 바랍니다.</span></p></li>
        </ul>
      </div>

      <div class="fc pt_20"></div>

      <!-- 버튼 start -->
      <div class="fr">
        <ul class="lt">
        <%// 조사마감으로 저장버튼 가림 / 20180716 / 김보선%>
          <%
          String oStatus = sOentStatus; // 조사표 제출 ("1")
          if (oStatus.equals("1")) {%>
          <li class="fl pr_2"><a href="#none" onfocus="this.blur()" class="contentbutton2">제출완료</a></li>
          <%}else{%>
          <li class="fl pr_2"><a href="javascript:savef();" onfocus="this.blur()" class="contentbutton2">저 장</a></li>
          <%} %>
          <li class="fl pr_2"><a href="javascript:goPrint();" onfocus="this.blur()" class="contentbutton2">화면 인쇄하기</a></li>
          <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_03.jsp" onfocus="this.blur()" class="contentbutton2">3. 하도급 거래 상황으로 가기</a></li>
          <li class="fl pr_2"><a href="./WB_VP_0<%=ckOentGB%>_05.jsp" onfocus="this.blur()" class="contentbutton2">5. 조사표 전송으로 가기</a></li>
        </ul>
      </div>

      <!-- 버튼 end -->

    </div>
    </form>
    <!-- End subcontent  -->

    <!-- Begin Footer -->
    <div id="subfooter"><img src="img/bottom.gif"></div>
    <!-- End Footer -->

  </div>
  </div>

  <%/*-----------------------------------------------------------------------------------------------
  2010년 4월 26일 / iframe 추가 / 정광식
  :: 하도급거래상황 (설문문항) 선택 후 저장 시 오류발생으로 기존정보 소실되는 경우를 방지하기 위해
  :: 선택사항을 iframe 타겟으로 submit 시킴
  */%>
  <iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>
  <%/*-----------------------------------------------------------------------------------------------*/%>

<script language="JavaScript">
  <%if ( StringUtil.checkNull(request.getParameter("isSaved")).equals("1") ) {%>
    alert("회사개요가 저장되었습니다.")
  <%}%>
</script>

</body>
</html>
<%@ include file="../Include/WB_I_Function.jsp"%>