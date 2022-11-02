<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* 프로젝트명		: 2014년 하도급거래 서면실태조사 지원을 위한 개발용역 사업
* 프로그램명		: WB_VP_Fileupload_02.jsp
* 프로그램설명	: 회사개요-일반현황 증빙자료 첨부
* 프로그램버전	: 3.0.0-2014
* 최초작성일자	: 2014년 09월 14일
* 작 성 이 력       :
*=========================================================
*	작성일자		작성자명				내용
*=========================================================
*	2014-09-14	정광식       최초작성
*	2015-05-08	강슬기       2015년도 문구 수정
*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--[if lt IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie6"><![endif]-->
<!--[if IE 7]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie7"><![endif]-->
<!--[if IE 8]><html xmlns="http://www.w3.org/1999/xhtml" lang="ko" class="no-js old-ie ie8"><![endif]-->
<!--[if (gt IE 8)|!(IE)]><!-->
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko-KR" class="no-js">
<!--<![endif]-->
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
    <meta http-equiv='Cache-Control' content='no-cache'>
    <meta http-equiv='Pragma' content='no-cache'>

    <title>2019년도 하도급거래 서면실태 조사</title>
    
    <link rel="stylesheet" href="../css/simplemodal.css" type="text/css" media="screen" title="no title" charset="euc-kr">
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
    <script src="../js/login.js" type="text/javascript" charset="euc-kr"></script>
    <script src="../js/credian_common_script.js" type="text/javascript"  charset="euc-kr"></script>
	<script type="text/javascript">
		function actionUpload() {
			var sDocNm = jQuery("#mSubject").val();

			if( sDocNm=="" ) {
				alert("문서명을 입력해 주세요.");
			} else {
				jQuery("#upform").one("submit", function() {
					this.method = "post";
					this.target = "ProceFrame";
					this.action = "WB_SP_Upload_02.jsp";
				}).trigger("submit");
			}
		}

		function rtnProcessResult() {
			parent.opener.top.refreshAttachFileList();
			self.close();
		}
	</script>
</head>

<body>


<form action="" id="upform" name="upform" method="post" enctype="multipart/form-data">

<h1 style="margin:10px; padding-left:15px; background-color:#D0D7E5; color:#666; font:bold 18px/2 굴림, Dotum;">증빙자료 업로드</h1>
<div style="margin:10px; padding-left:15px;">
	<ul class="lt">
		<li class="fc pt_20"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">1.</font> 아래 <B>[찾아보기...]</B> 버튼을 눌러 첨부할 파일을 더블클릭<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;하거나, 첨부할 파일을 선택 후 <B>[열기]</B> 버튼을 눌러주십시오.</li>
		<li class="fc pt_10"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">2.</font> 선택한 파일이름(경로)이 텍스트박스에 채워지면 하단의 <B>[등록]</B> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;버튼을 눌러 업로드 합니다.</li>
		<li class="fc pt_10"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">3.</font> 보안문서(DRM)일 경우는 <b>보안해제 후</b> 업로드 바랍니다.</li>
	</ul>
</div>
<br><br>
<table class="tbl_blue">
		<colgroup>
			<col style="width:20%;" />
			<col style="width:80%;" />
		</colgroup>
		<tbody>
			<tr>
				<th>문서명</th>
				<td><input type="text" id="mSubject" name="mSubject" value="" class="text03b"  maxlength="50" style="width:300px;" /></td>
			</tr>
			<tr>
				<th>파일</th>
				<td><input type="file" name="sfile" size="30"></td>
			</tr>
		</tbody>
</table>

<div class="fc pt_20"></div>

<!-- 버튼 start -->
<div class="fr" style="width:200px;">
	<ul class="lt">
		<li class="fc pr_2"><a href="javascript:actionUpload();" onfocus="this.blur()" class="contentbutton2">등록</a></li>
	</ul>
</div>

</form>

<iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>

</body>
</html>
