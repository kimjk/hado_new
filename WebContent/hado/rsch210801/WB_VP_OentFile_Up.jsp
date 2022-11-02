<%@ page session="true" language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
/*=======================================================
프로젝트명		: 2015년 하도급거래 서면실태조사 수행을 위한 개발용역 사업
프로그램명		: WB_VP_OentFile_Up.jsp
프로그램설명	: 원사업자명부 업로드
프로그램버전	: 1.0.0-2015
최초작성일자	: 2015년 07월 23일
작성 이력        :
-----------------------------------------------------------------------------------------------------------------
	작성일자		작성자명				내용
-----------------------------------------------------------------------------------------------------------------
2015-07-23	정광식       최초작성
=========================================================*/
%>

<%@ include file="../Include/WB_Inc_Global.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
	<title>2016년도 하도급거래 서면실태 조사</title>
	<link rel="stylesheet" href="style.css" type="text/css">
	<script type="text/javascript">
		var fDoProc = false;	// 실행여부
		function doUpload() {
			if( fDoProc ) {
				alert("업로드가 실행중입니다.\n파일의 용량 및 네트워크 상황에 따라 수분이 소요될 수 있습니다.\n\n오랜시간이 지나도 반응이 없을 경우 다시 시도해 주세요.");
				return false;
			} else {
				if( confirm("파일의 용량 및 네트워크 상황에 따라 수분이 소요될 수 있습니다.\n오랜시간이 지나도 반응이 없을 경우 다시 시도해 주세요.\n\n[확인]을 누르면 업로드를 실행합니다.") ) {
					fDoProc = true;
					return true;
				} else {
					return false;
				}
			}
		}
	</script>
</head>

<body>


<form name="upform" action="WB_CP_OentUpload_Qry.jsp" method="post" enctype="multipart/form-data" onsubmit="return doUpload();">

<h1 style="margin:10px; padding-left:15px; background-color:#D0D7E5; color:#666; font:bold 18px/2 굴림, Dotum;">원사업자명부 업로드</h1>
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
				<th>파일</th>
				<td><input type="file" name="sfile" size="30"></td>
			</tr>
		</tbody>
</table>

<div class="fc pt_20"></div>

<!-- 버튼 start -->
<div class="fr" style="width:200px;">
	<ul class="lt">
		<li class="fc pr_2"><input type="submit" value="등록" style="width:180px;height:40px;"/><!--a href="javascript:document.upform.submit();" onfocus="this.blur()" class="contentbutton2">등록</a--></li>
	</ul>
</div>

</form>

</body>
</html>
