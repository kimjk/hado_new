<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<%
/**
* ������Ʈ��		: 2014�� �ϵ��ްŷ� ����������� ������ ���� ���߿뿪 ���
* ���α׷���		: WB_VP_Fileupload_02.jsp
* ���α׷�����	: ȸ�簳��-�Ϲ���Ȳ �����ڷ� ÷��
* ���α׷�����	: 3.0.0-2014
* �����ۼ�����	: 2014�� 09�� 14��
* �� �� �� ��       :
*=========================================================
*	�ۼ�����		�ۼ��ڸ�				����
*=========================================================
*	2014-09-14	������       �����ۼ�
*	2015-05-08	������       2015�⵵ ���� ����
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

    <title>2019�⵵ �ϵ��ްŷ� ������� ����</title>
    
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
				alert("�������� �Է��� �ּ���.");
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

<h1 style="margin:10px; padding-left:15px; background-color:#D0D7E5; color:#666; font:bold 18px/2 ����, Dotum;">�����ڷ� ���ε�</h1>
<div style="margin:10px; padding-left:15px;">
	<ul class="lt">
		<li class="fc pt_20"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">1.</font> �Ʒ� <B>[ã�ƺ���...]</B> ��ư�� ���� ÷���� ������ ����Ŭ��<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ϰų�, ÷���� ������ ���� �� <B>[����]</B> ��ư�� �����ֽʽÿ�.</li>
		<li class="fc pt_10"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">2.</font> ������ �����̸�(���)�� �ؽ�Ʈ�ڽ��� ä������ �ϴ��� <B>[���]</B> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ư�� ���� ���ε� �մϴ�.</li>
		<li class="fc pt_10"></li>
		<li><font style="font-family:georgia, nanum,dotum; font-size:14px; font-weight:bold;">3.</font> ���ȹ���(DRM)�� ���� <b>�������� ��</b> ���ε� �ٶ��ϴ�.</li>
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
				<th>������</th>
				<td><input type="text" id="mSubject" name="mSubject" value="" class="text03b"  maxlength="50" style="width:300px;" /></td>
			</tr>
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
		<li class="fc pr_2"><a href="javascript:actionUpload();" onfocus="this.blur()" class="contentbutton2">���</a></li>
	</ul>
</div>

</form>

<iframe src="/blank.jsp" name="ProceFrame" id="ProceFrame" width="1" height="1" marginwidth="0" marginheight="0" frameborder="0" frameborder="1" style="visibility:'hidden';"></iframe>

</body>
</html>
