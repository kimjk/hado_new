<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
	<title>2021년도 하도급거래 서면실태 조사</title>
	<link rel="stylesheet" href="style.css" type="text/css" />
</head>

<body>


<form name="upform" action="WB_Upload_Edoc.jsp" method="post" enctype="multipart/form-data">

<h1 style="margin:10px; padding-left:15px; background-color:#D0D7E5; color:#666; font:bold 18px/2 굴림, Dotum;">조사제외 대상 증빙서류 업로드</h1>
<div style="margin:10px; padding-left:15px;">
	<ul class="lt">
		<li class="fc pt_10"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">1.</font> 아래 <B>[찾아보기...]</B> 버튼을 눌러 첨부할 파일을 더블클릭<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;하거나, 첨부할 파일을 선택 후 <B>[열기]</B> 버튼을 눌러주십시오.</li>
		<li class="fc pt_10"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">2.</font> 선택한 파일이름(경로)이 텍스트박스에 채워지면 하단의 <B>[등록]</B> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;버튼을 눌러 업로드 합니다.</li>
		<li class="fc pt_10"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">3.</font> 보안문서(DRM)일 경우는 <b>보안해제 후</b> 업로드 바랍니다.</li>
		<li class="fc pt_10"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">4.</font> <font color="red"><b>파일명은 업체명으로</b></font> 변경 후 업로드 하시기 바랍니다.</li>
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
		<li class="fc pr_2"><a href="javascript:document.upform.submit();" onfocus="this.blur()" class="contentbutton2">등록</a></li>
	</ul>
</div>

</form>

</body>
</html>
