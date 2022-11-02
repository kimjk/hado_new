/** 마우스로 레이어 움직이기 스크립트 시작 */
var bMDown = false;
var pDrag_x,pDrag_y;
var sElement;

function f_DragMDown(objLayer)
{
	//if( event.srcElement.className=="dragLayer" ) {
		bMDown = true;
		sElement = objLayer;
		pDrag_x = event.clientX;
		pDrag_y = event.clientY;
	//}
}

function f_DragMUp()
{
	bMDown = false;
}

function f_DragMove()
{
	if( bMDown ) {
		var pDistX = event.clientX - pDrag_x;
		var pDistY = event.clientY - pDrag_y;
		sElement.style.pixelLeft += pDistX;
		sElement.style.pixelTop += pDistY;
		pDrag_x = event.clientX;
		pDrag_y = event.clientY;
		
		return false;
	}
}

//document.onmousedown = f_DragMDown;
document.onmouseup = f_DragMUp;
document.onmousemove = f_DragMove;
/** 마우스로 레이어 움직이기 스크립트 끝 */

function tbRow_Over(objTR)
{
	objTR.oriClassName = objTR.className ? objTR.className : "";
	objTR.className = "tableRowOver";
}

function tbRow_Out(objTR)
{
	objTR.className = objTR.oriClassName;
}

function closeViewWin(objDiv)
{
	var layer=document.getElementById(objDiv);
	if( layer ) layer.style.display="none";
}

function OpenPost_w(idPost,idAddr)
{
	MsgWindow = window.open("/hado/hado/wTools/searchzipcode.jsp?ITEM=F&pid="+idPost+"&aid="+idAddr,
		"_PostSerch",
		"toolbar=no,width=400,height=500,directories=no,status=no,scrollbars=Yes,resize=no,menubar=no");
}

function hidContent(objID,textTargetID,fText)
{
	var obj=document.getElementById(objID);
	var targetid=document.getElementById(textTargetID);

	if( obj && targetid ) {
		obj.style.display="none";
		targetid.innerHTML="<a href=javascript:showContent('"+objID+"','"+textTargetID+"','"+fText+"'); class='sbutton'>"+fText+" 보기</a>";
	}
}

function showContent(objID,textTargetID,fText)
{
	var obj=document.getElementById(objID);
	var targetid=document.getElementById(textTargetID);

	if( obj && targetid ) {
		obj.style.display="block";
		targetid.innerHTML="<a href=javascript:hidContent('"+objID+"','"+textTargetID+"','"+fText+"'); class='sbutton'>"+fText+" 가리기</a>";
	}
}

function all_replace(str,oldchar,newchar)
{
	var _this = str;

	while( _this.indexOf( oldchar )!=-1 )
	{
		_this = _this.replace( oldchar, newchar );
	}
	
	return _this;
}