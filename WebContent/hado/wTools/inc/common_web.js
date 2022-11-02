// ũ����� Ŀ�� ��ũ��Ʈ..

var SU_COMMA = ',';

// ���ڿ� ġȯ
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

// �Ǽ������� Ȯ���Ѵ�.
function isFloat(str) {
	return (str.indexOf('.') != -1);
}

// ���ڿ� �ĸ��� �����Ѵ�.
function suwithcomma(su) {
	
	su = kreplace(su,',','');
	
	var rtn = '';
	var fd = false;
	// �Էµ� ���� �˻��Ͽ� ���ڰ� �ƴ� ��� 0�� �����ش�.
	// ������ ��쿡�� ���ڿ��� �ٲ۴�.
	if (isNaN(su)) {
		alert("���ڸ� �Է��ϼž� �մϴ�.");
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

// ���ڰ�, "."������ üũ�Ѵ�.
function checkStringValid(src){
	var len = src.value.length;

	for(var i=0;i<len;i++){
		if ((!isDecimal(src.value.charAt(i)) || src.value.charAt(i)==" ") && src.value.charAt(i)!="." ){
			assortString(src,i);	
			i=0;
		}
	}

}

// ���ڸ� �����Ѵ�.
function assortString(source,index){
	var len = source.value.length;
	var temp1 = source.value.substring(0,index);
	var temp2 = source.value.substring(index+1,len);
	source.value = temp1 + temp2;
}

// 10�������� ������ �ִ��� Ȯ���Ѵ�.
function isDecimal(number){
	if (number>=0 && number<=9)  return true;
	else return false;
}

// �Ҽ����� �ΰ� �̻��ԷµǸ� ������ ���� �����Ѵ�.
function isPoint(src) {
	if ((p1 = src.value.indexOf('.')) != -1) {
		if ((p2 = src.value.indexOf('.',p1+1)) != -1) {
			src.value = src.value.substring(0,p2);
			return true;
		}
	}
	return false;
}

// Ű�ڵ带 �˻��ϰ� ��Ʈ���� ���� �ĸ��� �����Ѵ�.
function sukeyup(src) {

	if (sukeyup_n(src)) {
		src.value = suwithcomma(src.value);
		return true;
	}
	return false;
}
// �Է°��� �˻��Ѵ�.
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

// ���� Ű�� ȭ��ǥ������ Ȯ���Ѵ�.
function isArrowKey(key){
	if(key>=37 && key<=40) return true;
	else return false;
}

// ���� �ִ밪 ���� ū ��� �ִ밪�� �Է��Ѵ�.
// vmax : �ִ밪
function isMax(src,vmax) {
	
	var sv = src.value;
	var smax = suwithcomma(new String(vmax));
	sv = parseFloat(kreplace(sv,',',''));
	
	if (sv > vmax) {
		alert('�ִ밪(' + smax + ')���� ū ���� �Է� �Ǿ����ϴ�.');
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
		alert("���� �Է� �ϼž� �մϴ�.");
		src.value = new Date().getMonth();
		return false;
	}
	return true;
	
}

// ���ڰ����� �Է¹޴´�.
function onlyNumeric(src){
	var len = src.value.length;

	for(var i=0;i<len;i++){
		if (!isDecimal(src.value.charAt(i)) || src.value.charAt(i)==" ") {
			assortString(src,i);	
			i=0;
		}
	}

}

// ������ �Ҽ��� ������ ���� ������.
function wPoint(src,dec) {
	if ((p = src.value.indexOf('.')) != -1) {
		if (src.value.length > p + dec + 1) {
			src.value = src.value.substring(0,p+dec+1);
		}
	}
}