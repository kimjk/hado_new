function getWindowX()
	{
		// IE
		if( window.screenLeft ) {
			return window.screenLeft;
		} else if( window.screenX ) { // FireFox....
			return window.screenX;
		}
	}

	function getWindowY()
	{
		// IE
		if( window.screenLeft ) {
			return window.screenTop;
		} else if( window.screenX ) { // FireFox....
			return window.screenY;
		}
	}

	function getViewportWidth()
	{
		if( window.innerWidth ){
			return window.innerWidth;
		} else if( document.documentElement && document.documentElement.clientWidth ) {
			// IE8
			return document.documentElement.clientWidth;
		} else if( document.body.clientWidth ) {
			// IE4, IE5, DOCTYPE이 없을때 IE8
			return document.body.clientWidth;
		}
	}

	function getViewportHeight()
	{
		if( window.innerWidth ){
			return window.innerHeight;
		} else if( document.documentElement && document.documentElement.clientWidth ) {
			// IE8
			return document.documentElement.clientHeight;
		} else if( document.body.clientWidth ) {
			// IE4, IE5, DOCTYPE이 없을때 IE8
			return document.body.clientHeight;
		}
	}

	function getHorizontalScroll()
	{
		if( window.innerWidth ){
			return window.pageXOffset;
		} else if( document.documentElement && document.documentElement.clientWidth ) {
			// IE8
			return document.documentElement.scrollLeft;
		} else if( document.body.clientWidth ) {
			// IE4, IE5, DOCTYPE이 없을때 IE8
			return document.body.scrollLeft;
		}
	}

	function getVerticalScroll()
	{
		if( window.innerWidth ){
			return window.pageYOffset;
		} else if( document.documentElement && document.documentElement.clientWidth ) {
			// IE8
			return document.documentElement.scrollTop;
		} else if( document.body.clientWidth ) {
			// IE4, IE5, DOCTYPE이 없을때 IE8
			return document.body.scrollTop;
		}
	}

	// 문서의 크기
	function getDocumentWidth()
	{
		if( document.documentElement && document.documentElement.scrollWidth ) {
			return document.documentElement.scrollWidth;
		} else if( document.body.scrollWidth ) {
			return document.body.scrollWidth;
		}
	}

	function getDocumentHeight()
	{
		if( document.documentElement && document.documentElement.scrollWidth ) {
			return document.documentElement.scrollHeight;
		} else if( document.body.scrollWidth ) {
			return document.body.scrollHeight;
		}
	}

	function bodyhidden()
	{
		var layer1=document.getElementById("ajax_ready");
		var layer2=document.getElementById("ajax_bg");

		//document.body.style.filter="Alpha(opacity='50')";
		layer2.style.width = getDocumentWidth()+getHorizontalScroll()+"px";
		layer2.style.height = getDocumentHeight()+getVerticalScroll()+"px";
		layer2.style.filter="Alpha(opacity='70')";
		layer2.style.display='block';

		layer1.style.top = Math.round(( getDocumentHeight()+getVerticalScroll()-60 )/2)+"px";
		layer1.style.left = Math.round(( getDocumentWidth()+getHorizontalScroll()-60)/2)+"px";
		layer1.style.display='block';
	}

	function bodyview()
	{
		//document.body.style.filter="none";
		var layer1=document.getElementById("ajax_ready");
		var layer2=document.getElementById("ajax_bg");
		layer1.style.top = "1px";
		layer1.style.left = "1px";
		layer1.style.display='none';
		layer2.style.display='none';
	}