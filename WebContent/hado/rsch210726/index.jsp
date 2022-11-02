<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
    /*=======================================================
			 ������Ʈ��    : 2015�� �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
			 ���α׷���    : index.jsp
			 ���α׷�����    : ���� ������
			 ���α׷�����    : 4.0.0-2015
			 �����ۼ�����    : 2015�� 05�� 07��
			 �ۼ� �̷�     :
			 -----------------------------------------------------------------------------------------------------------------
			 �ۼ�����        �ۼ��ڸ�                ����
			 -----------------------------------------------------------------------------------------------------------------
			 2015-05-07    ������       �����ۼ�
			 2015-05-20    ������       jquery modal script ���� (���̾� Ŭ���� �� ���ҽ� remove ����)
			 2015-10-16    ������       �������� �������� ���� DB���� �ð��������� ��� �߰�
			 2015-12-21     ������      ������Ʈ�� XSS ����� ���� (sRtnErrCd - trnType)
			 2018-06-15  �躸�� �����ؿ� �Է��� �ߴ� ��ü�� �α��ν� ���� login_new.js ������ �ҷ����� ��찡 ���� ���ϸ� ����
			 2020-06-12  �輺��	������ �����۾�
			 2021-07-21  �����    �ʱ�ȭ�� ������(2021) ���� �۾�
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

			//2015-10-16 / DB���� ���糯¥ ��������
			String sRevDate = "20170621"; //�������� ����
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

			// 2015-12-21     ������          ������Ʈ�� XSS ����� ���� (sRtnErrCd - trnType)
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
    <meta name="title" content="�����ŷ�����ȸ ��������" />
    <meta name="author" content="�����ŷ�����ȸ ��������" />
    <meta name="keywords" content="�����ŷ�����ȸ ��������" />
    <meta name="description" content="�����ŷ�����ȸ ��������" />
    <link rel="stylesheet" href="css/font.css">
    <link rel="stylesheet" href="css/main.css">
    <script src="js/jquery-1.12.4.min.js"></script>
    <script src="js/jquery.modalEd.js"></script>
    <script src="js/main.js"></script>
    <!--[if lt IE 9]><script src="/common/js/html5_2020.js"></script><![endif]-->
    <title>2021�⵵ �ϵ��ްŷ� �����������</title>


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
            if (sErrCd == "E001") { // �α������� �Ҹ�
                alert("�α��� �����ð��� ����Ͽ����ϴ�.\n�ٽ� �α��� �� �̿��Ͻñ� �ٶ��ϴ�.\n\n���� : �α��� �����ð��� ����� �� �ڵ� �α׾ƿ��� ��쿡�� �������� ���� ������ �Ҹ�˴ϴ�.");
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
                    //alert("�˾�â�� ���ܵǾ� �ֽ��ϴ�.\n�˸�ǥ���ٿ��� �˾�â�� ����ϵ��� �����Ͻʽÿ�.")
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
        if (confirm("�Ұ��� ���� �͸����� �ý������� ���յǾ����ϴ�.\n[Ȯ��]�� �����ø� �͸����� �ý������� �̵��մϴ�.")) {
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
        <a href="#container">���� �ٷΰ���</a>
    </div>
    <!-- ���� �ٷΰ��� ���� -->
    <header id="header">
         <h1 class="logo"><span>�����ŷ�����ȸ</span><em>2021�⵵ �ϵ��ްŷ� ��������</em><span class="number_mark">������� ���ι�ȣ �� 152009 ȣ</span></h1>
    </header>
    <nav id="nav">
        <div class="wrap clearfix">
            <div class="nav_title" style="font-size:35px">�����Ӱ� ������ ��������<br>�����ŷ�����ȸ��<br>����� ���ڽ��ϴ�.</div>
            <div class="login_form">
                <div class="login_title"><h2>������ ����� <span>�α���</span></h2></div>
                <form action="" method="post" name="LoginForm" id="LoginForm">
                	<input type="hidden" id="cmd" name="cmd" value="login" />
                	<input type="hidden" id="mCurrentYear" name="mCurrentYear" value="2021" />
                    <fieldset>
                        <legend>������ȣ, �����ڵ� �Է�</legend>
                        <div class="login_form_wrap">
                            <ul class="form_list">
                                <li><label for="mMngNo" class="skip">������ȣ</label><input name="mMngNo" id="mMngNo" tabindex="1" value="" maxlength="13" type="text" placeholder="������ȣ" /></li>
                                <li><label for="mConnCode" class="skip">�����ڵ�</label><input type="password" name="mConnCode" id="mConnCode" tabindex="2" onkeydown="javascript:if( event.keyCode==13 ) { actionLogin();}" value="" maxlength="13" placeholder="�����ڵ�" /></li>
                            </ul>
                            <div class="login_submit">
                                <input type="submit" value="�α���" class="login_button" onclick="actionLogin();" />
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
                                <h3>�ڷ��</h3>
                            </a>
                        </div>
                    </li>
                    <li>
                        <div class="inner">
                            <a href="/subPage03_new.jsp" id="subPage03">
                                <h3>����ǥ �ۼ� �� Ȯ��</h3>
                            </a>
                        </div>
                    </li>
                    <li>
                        <div class="inner">
                            <a href="/board/board_new.jsp" id="help">
                                <h3>���� ����(FAQ)</h3>
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
                <h3>������� ���� �����Ⱓ</h3>
                <span class="day">2021�� <em>7�� 26��(��)</em> ~ 2021�� <em>8�� 20��(��)</em></span>
            </div>

            <div class="rowgroup1 type2">
                <h3>���ջ�㼾��</h3>
                <div class="row_inner">
                    <div class="colgroup call">
                        <div class="col_inner">
                            <span class="title">1668-3476</span>
                            <span class="go">��ȭ �� SNS<br>���ջ��</span>
                        </div>
                    </div>
                    <div class="colgroup talk">
                        <a href="http://pf.kakao.com/_xjYjxfs/chat" class="col_inner" target="_blank">                           <span class="title">īī����</span>
                            <span class="go">ī�� ���<br>�Ϸ�����</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="rowgroup2">
                <div class="colgroup video">
                    <a href="https://www.youtube.com/watch?v=dLW4gqn9blE" class="col_inner" target="_blank">
                        <h3>�ϵ��ްŷ� ��������<br>ȫ������</h3>
                    </a>
                </div>
                <div class="colgroup tip_off">
                    <a href="https://www.ftc.go.kr/www/contents.do?key=311" class="col_inner" target="_blank">
                        <h3>�Ұ��� �ϵ��� ���� �����ϱ�</h3>
                        <span>�δ�ܰ�����, ����ڷ� �δ�䱸 ��<br>��������� �Ұ��� �ϵ�����������</span>
                    </a>
                </div>
            </div>
            <div class="rowgroup3">
                <p>
                    �ش� ����Ʈ�� Internet Explorer�� �������� �ʽ��ϴ�.<br>
                    <em class="edge">����(Edge)</em>�� <em class="chrome">ũ��(Chrome)</em>���� ���� ��Ź�帳�ϴ�.
                </p>
            </div>
        </main>
    </div>
    <footer id="footer">
        <div class="wrap">
            <div class="foot_title">�����ŷ�����ȸ<br>����ŷ���å��</div>
            <div class="foot_info">
                <div class="main_address">���� ����ŷ���å��: (30108) ����Ư����ġ�� �ټ�3�� 95 ���μ���û�� 2��</div>
                <div class="copylight"> COPYRIGHT �� 2021 FAIR TRADE COMMISSION. ALL RIGHTS RESERVED.</div>
            </div>
         </div>
    </footer>
</div>
<iframe src="about:blank" id="procFrame" name="procFrame" style="display:none;" width="1" height="1"></iframe>
</body>
</html>
<%@ include file="/Include/WB_I_Function.jsp"%>