<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
    /*=======================================================
			 프로젝트명    : 2015년 하도급거래 서면실태조사 수행을 위한 개발용역 사업
			 프로그램명    : index.jsp
			 프로그램설명    : 메인 페이지
			 프로그램버전    : 4.0.0-2015
			 최초작성일자    : 2015년 05월 07일
			 작성 이력     :
			 -----------------------------------------------------------------------------------------------------------------
			 작성일자        작성자명                내용
			 -----------------------------------------------------------------------------------------------------------------
			 2015-05-07    정광식       최초작성
			 2015-05-20    정광식       jquery modal script 보완 (레이어 클로즈 시 리소스 remove 적용)
			 2015-10-16    정광식       공지사항 예약사용을 위해 DB에서 시간가져오기 기능 추가
			 2015-12-21     정광식      쿼리스트링 XSS 취약점 제거 (sRtnErrCd - trnType)
			 2018-06-15  김보선 지난해에 입력을 했던 업체가 로그인시 예전 login_new.js 파일을 불러오는 경우가 많아 파일명 변경
			 2020-06-12  김성연	디자인 변경작업
			 2021-07-21  정용덕    초기화면 디자인(2021) 변경 작업
			 =========================================================*/
%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>
<%@ page import="ftc.db.ConnectionResource"%>
<%@ include file="/Include/WB_Inc_Global.jsp"%>
<%
    ConnectionResource resource = null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;

			String sSQLs = "";
			String sNowDd = "Yes";

			//2015-10-16 / DB에서 현재날짜 가져오기
			String sRevDate = "20170621"; //예약일자 변수
			try {
				resource = new ConnectionResource();
				conn = resource.getConnection();

				sSQLs = "SELECT CASE WHEN (TO_DATE('"
						+ sRevDate
						+ "','YYYYMMDD')-SYSDATE) > 0 THEN 'Yes' ELSE 'No' END AS isDd \n";
				sSQLs += "FROM dual \n";
				pstmt = conn.prepareStatement(sSQLs);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					sNowDd = rs.getString("isDd");
				}
				rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (rs != null)
					try {
						rs.close();
					} catch (Exception e) {
					}
				if (pstmt != null)
					try {
						pstmt.close();
					} catch (Exception e) {
					}
				if (conn != null)
					try {
						conn.close();
					} catch (Exception e) {
					}
				if (resource != null)
					resource.release();
			}

			// 2015-12-21     정광식          쿼리스트링 XSS 취약점 제거 (sRtnErrCd - trnType)
			String sRtnErrCd = request.getParameter("rtnType") == null
					? ""
					: UF_replaceXSS(request.getParameter("rtnType").trim());
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
    <!--    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.5, minimum-scale=1.0, user-scalable=yes" />-->
    <meta name="title" content="공정거래위원회 실태조사" />
    <meta name="author" content="공정거래위원회 실태조사" />
    <meta name="keywords" content="공정거래위원회 실태조사" />
    <meta name="description" content="공정거래위원회 실태조사" />
    <link rel="stylesheet" href="css/font.css">
    <link rel="stylesheet" href="css/main.css">
    <script src="js/jquery-1.12.4.min.js"></script>
    <script src="js/jquery.modalEd.js"></script>
    <script src="js/main.js"></script>
    <!--[if lt IE 9]><script src="/common/js/html5_2020.js"></script><![endif]-->
    <title>2021년도 하도급거래 서면실태조사</title>


<!--  <script src="js/2015js/jquery.min.js"></script>-->
<!--  <script src="js_2019/jquery.modalEd.js" type="text/javascript"></script>-->
<!--  <script src="js/2015js/common.js"></script>  -->
<!--  <script src="js_2018/common.js"></script>   -->
<!--  <script src="js/commonScript.js" type="text/javascript" charset="euc-kr"></script>  -->
<script src="js/login_2019.js" type="text/javascript" charset="euc-kr"></script>
<script>
	$(function() {
        /* $('#login').click(function(event) {
            event.preventDefault();
            $.get(this.href, function(html) {
                $(html).appendTo('body').modal({
                    modalClass:"modal2"
                });
            });
        }); */

        $('#board').click(function(event) {
            event.preventDefault();
            $.get(this.href, function(html) {
                $(html).appendTo('body').modal();
            });
        });

        $('#subPage03').click(function(event) {
            event.preventDefault();
            $.get(this.href, function(html) {
                $(html).appendTo('body').modal({
                    modalClass : "modal3"
                });
            });
        });

        $('#help').click(function(event) {
            event.preventDefault();
            $.get(this.href, function(html) {
                $(html).appendTo('body').modal();
            });
        });
    });



	</script>
    <script type="text/javascript">

    var sErrCd = "<%=sRtnErrCd%>"; // Error Code

    function entsub(event) {
        if (window.event && window.event.keyCode == 13) {
            actionLogin();
        }
    }

    function HelpWindow2(url, w, h) {
        helpwindow = window.open(url, "HelpWindow", "toolbar=no,width=" + w + ",height=" + h + ",directories=no,status=yes,scrollbars=yes,resize=no,menubar=no,location=no");
        helpwindow.focus();
    }

    function onDocuments() {
        if (sErrCd != "") {
            if (sErrCd == "E001") { // 로그인정보 소멸
                alert("로그인 유지시간이 경과하였습니다.\n다시 로그인 후 이용하시기 바랍니다.\n\n주의 : 로그인 유지시간이 경과한 후 자동 로그아웃된 경우에는 저장하지 않은 정보는 소멸됩니다.");
            }
        }

        /* $.get("notice.jsp", function(html) {
            $(html).appendTo('body').modal();
        });*/

    }

    function popup(furl, names, ws, hs, tps, lps) {
        if ((furl != "") && (names != "") && (tps != "") && (lps != "")) {
            scookie = GetCookie(names);
            if (scookie == "") {
                objPopupWindow = window.open(furl, names, "toolbar=no,width=" + ws + ",height=" + hs + ",directories=no,status=no,scrollbars=no,resize=no,menubar=no,location=no,top=" + tps + ",left=" + lps);
                if (objPopupWindow == null) {
                    //alert("팝업창이 차단되어 있습니다.\n알림표시줄에서 팝업창을 허용하도록 선택하십시요.")
                }
            }
        }
        return 1;
    }

    function check_window() {
        document.getElementById("NoticeLayer").style.visibility = 'hidden';
        document.getElementById("NoticeLayer").style.top = -300;
        document.getElementById("NoticeLayer").style.left = -500;
    }

    function goNonFair() {
        if (confirm("불공정 행위 익명제보 시스템으로 통합되었습니다.\n[확인]을 누르시면 익명제보 시스템으로 이동합니다.")) {
            //window.open("http://www.ftc.go.kr/info/unfairInfo/unfairTrade.jsp","_blank","");
            window.open("http://www.ftc.go.kr/www/contents.do?key=311", "_blank", "");
        }
    }

   
    function brdView(bUrl, sType, sText) {
        $.post(bUrl, {
        searchtype : sType,
        searchtext : sText
        }, function(html) {
            $(html).appendTo('body').modal();
        });
    }

    function srchBoard() {
        var srchType = $("#searchtype").val() == null ? "" : $("#searchtype").val();
        var srchText = $("#searchtext").val() == null ? "" : $("#searchtext").val();
        //brdView("/board/board_new.jsp?searchtype="+srchType+"&searchtext="+encodeURIComponent(srchText));
        brdView("/board/board_new.jsp", srchType, srchText);
        return false;
    }

	$(function(){

	//information_tab
	var tabClick = $('.information_tab .tab_control li button');
	tabClick.click(function(){
		var $this = $(this),
			indexNo = tabClick.index(this),
			$ul = $('.information_tab .tab_control ul');

		$('.information_tab .tab_control li.active').removeClass('active');
		$this.parent('li').addClass('active');
		$('.information_tab .tab_contents .tab_content.active').removeClass('active');
		$('.information_tab .tab_contents .tab_content').eq(indexNo).addClass('active');
	});

	});

</script>
</head>
<body id="main" onload="onDocuments(); return false;">
<div id="wrapper">
    <div class="accessibility">
        <a href="#container">본문 바로가기</a>
    </div>
    <!-- 본문 바로가기 종료 -->
    <header id="header">
         <h1 class="logo"><span>공정거래위원회</span><em>2021년도 하도급거래 실태조사</em><span class="number_mark">국가통계 승인번호 제 152009 호</span></h1>
    </header>
    <nav id="nav">
        <div class="wrap clearfix">
            <div class="nav_title" style="font-size:35px">자유롭고 공정한 경쟁촉진<br>공정거래위원회가<br>만들어 가겠습니다.</div>
            <div class="login_form">
                <div class="login_title"><h2>조사대상 사업자 <span>로그인</span></h2></div>
                <form action="" method="post" name="LoginForm" id="LoginForm">
                	<input type="hidden" id="cmd" name="cmd" value="login" />
                	<input type="hidden" id="mCurrentYear" name="mCurrentYear" value="2021" />
                    <fieldset>
                        <legend>관리번호, 접속코드 입력</legend>
                        <div class="login_form_wrap">
                            <ul class="form_list">
                                <li><label for="mMngNo" class="skip">관리번호</label><input name="mMngNo" id="mMngNo" tabindex="1" value="" maxlength="13" type="text" placeholder="관리번호" /></li>
                                <li><label for="mConnCode" class="skip">접속코드</label><input type="password" name="mConnCode" id="mConnCode" tabindex="2" onkeydown="javascript:if( event.keyCode==13 ) { actionLogin();}" value="" maxlength="13" placeholder="접속코드" /></li>
                            </ul>
                            <div class="login_submit">
                                <input type="submit" value="로그인" class="login_button" onclick="actionLogin();" />
                            </div>
                        </div>
                    </fieldset>
                </form>
            </div>
            <div class="links">
                <ul class="clearfix">
                    <li>
                        <div class="inner">
                            <a href="/doc/index_new.jsp" id="board">
                                <h3>자료실</h3>
                            </a>
                        </div>
                    </li>
                    <li>
                        <div class="inner">
                            <a href="/subPage03_new.jsp" id="subPage03">
                                <h3>조사표 작성 전 확인</h3>
                            </a>
                        </div>
                    </li>
                    <li>
                        <div class="inner">
                            <a href="/board/board_new.jsp" id="help">
                                <h3>도움말 모음(FAQ)</h3>
                            </a>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <div id="container">
        <main>
            <div class="rowgroup1">
                <h3>원사업자 조사 참여기간</h3>
                <span class="day">2021년 <em>7월 26일(월)</em> ~ 2021년 <em>8월 20일(금)</em></span>
            </div>

            <div class="rowgroup1 type2">
                <h3>통합상담센터</h3>
                <div class="row_inner">
                    <div class="colgroup call">
                        <div class="col_inner">
                            <span class="title">1668-3476</span>
                            <span class="go">전화 및 SNS<br>통합상담</span>
                        </div>
                    </div>
                    <div class="colgroup talk">
                        <a href="http://pf.kakao.com/_xjYjxfs/chat" class="col_inner" target="_blank">                           <span class="title">카카오톡</span>
                            <span class="go">카톡 상담<br>하러가기</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="rowgroup2">
                <div class="colgroup video">
                    <a href="https://www.youtube.com/watch?v=dLW4gqn9blE" class="col_inner" target="_blank">
                        <h3>하도급거래 실태조사<br>홍보영상</h3>
                    </a>
                </div>
                <div class="colgroup tip_off">
                    <a href="https://www.ftc.go.kr/www/contents.do?key=311" class="col_inner" target="_blank">
                        <h3>불공정 하도급 행위 제보하기</h3>
                        <span>부당단가인하, 기술자료 부당요구 등<br>원사업자의 불공정 하도급행위제보</span>
                    </a>
                </div>
            </div>
            <div class="rowgroup3">
                <p>
                    해당 사이트는 Internet Explorer는 지원하지 않습니다.<br>
                    <em class="edge">엣지(Edge)</em>와 <em class="chrome">크롬(Chrome)</em>에서 접속 부탁드립니다.
                </p>
            </div>
        </main>
    </div>
    <footer id="footer">
        <div class="wrap">
            <div class="foot_title">공정거래위원회<br>기업거래정책국</div>
            <div class="foot_info">
                <div class="main_address">본부 기업거래정책국: (30108) 세종특별자치시 다솜3로 95 정부세종청사 2동</div>
                <div class="copylight"> COPYRIGHT ⓒ 2021 FAIR TRADE COMMISSION. ALL RIGHTS RESERVED.</div>
            </div>
         </div>
    </footer>
</div>
<iframe src="about:blank" id="procFrame" name="procFrame" style="display:none;" width="1" height="1"></iframe>
</body>
</html>
<%@ include file="/Include/WB_I_Function.jsp"%>