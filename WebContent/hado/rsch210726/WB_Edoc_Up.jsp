<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
	<title>2021�⵵ �ϵ��ްŷ� ������� ����</title>
	<link rel="stylesheet" href="style.css" type="text/css" />
</head>

<body>


<form name="upform" action="WB_Upload_Edoc.jsp" method="post" enctype="multipart/form-data">

<h1 style="margin:10px; padding-left:15px; background-color:#D0D7E5; color:#666; font:bold 18px/2 ����, Dotum;">�������� ��� �������� ���ε�</h1>
<div style="margin:10px; padding-left:15px;">
	<ul class="lt">
		<li class="fc pt_10"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">1.</font> �Ʒ� <B>[ã�ƺ���...]</B> ��ư�� ���� ÷���� ������ ����Ŭ��<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ϰų�, ÷���� ������ ���� �� <B>[����]</B> ��ư�� �����ֽʽÿ�.</li>
		<li class="fc pt_10"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">2.</font> ������ �����̸�(���)�� �ؽ�Ʈ�ڽ��� ä������ �ϴ��� <B>[���]</B> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ư�� ���� ���ε� �մϴ�.</li>
		<li class="fc pt_10"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">3.</font> ���ȹ���(DRM)�� ���� <b>�������� ��</b> ���ε� �ٶ��ϴ�.</li>
		<li class="fc pt_10"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">4.</font> <font color="red"><b>���ϸ��� ��ü������</b></font> ���� �� ���ε� �Ͻñ� �ٶ��ϴ�.</li>
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
				<th>����</th>
				<td><input type="file" name="sfile" size="30"></td>
			</tr>
		</tbody>
</table>

<div class="fc pt_20"></div>

<!-- ��ư start -->
<div class="fr" style="width:200px;">
	<ul class="lt">
		<li class="fc pr_2"><a href="javascript:document.upform.submit();" onfocus="this.blur()" class="contentbutton2">���</a></li>
	</ul>
</div>

</form>

</body>
</html>
