// 크레디앙 커몬 스크립트..

var SU_COMMA = ',';

// 문자열 치환
function kreplace(str,str1,str2) {
	
	if (str == "" || str == null) return str;

	while (str.indexOf(str1) != -1) {
		str = str.replace(str1,str2);
	}
	return str;
//	if (isNaN(str)) return str;
//
//	if (isFloat(str))
//		return parseFloat(str);
//	else
//		return parseInt(str);
}

// 실수인지를 확인한다.
function isFloat(str) {
	return (str.indexOf('.') != -1);
}

// 숫자에 컴마를 삽입한다.
function suwithcomma(su) {
	
	su = kreplace(su,',','');
	
	var rtn = '';
	var fd = false;
	// 입력된 값을 검사하여 숫자가 아닌 경우 0을 돌려준다.
	// 숫자인 경우에는 문자열로 바꾼다.
	if (isNaN(su)) {
		alert("숫자를 입력하셔야 합니다.");
		return 0;
	} else {
		su = new String(su);
	}
	
	n = su.indexOf('.');
	if (n<0) {
		n = parseInt(su.length);
	} else {
		fd = true;
	}
	
	while (su.indexOf('0') == 0 ) {
		if (!fd) {
			su = su.substring(1,su.length);
		} else {
			if (n > 1) {
				su = su.substring(1, su.length);
				n --;
			} else {
				return su;
			}
		}
	}
	cnt = parseInt(n / 3);
//	alert(cnt);
	mod = parseInt(n % 3);
//	alert(mod);
	if (mod>0) {
		rtn = su.substring(0,mod);
		if (cnt > 0) rtn = rtn + SU_COMMA;
	}
	for (i = 0; i < cnt ; i++) {
		idx = i*3 + mod;
		if (idx == 0) {
			rtn = su.substring(idx,idx + 3);
			if (cnt > 1) rtn = rtn + SU_COMMA;
		} else {
			rtn = rtn + su.substring(idx,idx + 3);
			if (idx < n - 3) rtn = rtn + SU_COMMA;
		}
		
	}
	if (fd) rtn = rtn + su.substring(n,su.length);
	return rtn;
}

// 숫자값, "."인지를 체크한다.
function checkStringValid(src){
	var len = src.value.length;

	for(var i=0;i<len;i++){
		if ((!isDecimal(src.value.charAt(i)) || src.value.charAt(i)==" ") && src.value.charAt(i)!="." ){
			assortString(src,i);	
			i=0;
		}
	}

}

// 숫자를 조립한다.
function assortString(source,index){
	var len = source.value.length;
	var temp1 = source.value.substring(0,index);
	var temp2 = source.value.substring(index+1,len);
	source.value = temp1 + temp2;
}

// 10진수값을 가지고 있는지 확인한다.
function isDecimal(number){
	if (number>=0 && number<=9)  return true;
	else return false;
}

// 소수점이 두개 이상입력되면 마지막 점은 삭제한다.
function isPoint(src) {
	if ((p1 = src.value.indexOf('.')) != -1) {
		if ((p2 = src.value.indexOf('.',p1+1)) != -1) {
			src.value = src.value.substring(0,p2);
			return true;
		}
	}
	return false;
}

// 키코드를 검사하고 콘트롤의 값에 컴마를 삽입한다.
function sukeyup(src) {

	if (sukeyup_n(src)) {
		src.value = suwithcomma(src.value);
		return true;
	}
	return false;
}
// 입력값을 검사한다.
function sukeyup_n(src) {

	keycode = window.event.keyCode;
	//alert(isArrowKey(keycode));
	if (isArrowKey(keycode) || keycode == 13 || isPoint(src)) {
		return false;
	}
	checkStringValid(src);

	if (src.value == '' || src.value == '0') {
		src.value = 0;
		return false;
	}

	if (src.value == '.' || src.value == '0.') {
		src.value = '0.';
		return false;
	}

	if(!isNaN(src.value)) {

		if (src.value.indexOf('.') == 1) return false;
		if (src.value.length <= 3) {
			if (src.value.indexOf('0') == 0) 
				src.value = src.value.substring(1,src.value.length);
			return false;
		}

	}
	return true;
}

// 누른 키가 화살표인지를 확인한다.
function isArrowKey(key){
	if(key>=37 && key<=40) return true;
	else return false;
}

// 숫자 최대값 보다 큰 경우 최대값을 입력한다.
// vmax : 최대값
function isMax(src,vmax) {
	
	var sv = src.value;
	var smax = suwithcomma(new String(vmax));
	sv = parseFloat(kreplace(sv,',',''));
	
	if (sv > vmax) {
		alert('최대값(' + smax + ')보다 큰 값이 입력 되었습니다.');
		src.value = smax;
		return false;
	}
	return true;
}
//
//function suMax(src,vmax) {
//	isMax(src,vmax);
//	sukeyup(src);
//}
function suwithdec(src,dec) {
	sukeyup(src);
	wPoint(src,dec);
}

//
function isMonth(src) {

	onlyNumeric(src);
	v = parseInt(src.value);
	if ((v < 1) || (v > 12)) {
		alert("월을 입력 하셔야 합니다.");
		src.value = new Date().getMonth();
		return false;
	}
	return true;
	
}

// 숫자값만을 입력받는다.
function onlyNumeric(src){
	var len = src.value.length;

	for(var i=0;i<len;i++){
		if (!isDecimal(src.value.charAt(i)) || src.value.charAt(i)==" ") {
			assortString(src,i);	
			i=0;
		}
	}

}

// 지정된 소수점 이하의 수는 버린다.
function wPoint(src,dec) {
	if ((p = src.value.indexOf('.')) != -1) {
		if (src.value.length > p + dec + 1) {
			src.value = src.value.substring(0,p+dec+1);
		}
	}
}