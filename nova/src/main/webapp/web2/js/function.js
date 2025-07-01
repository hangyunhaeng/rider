function getTrim(s) {
	var cnt = 0;	//초기화
	//왼쪽Trim
	for(i=0;i < s.length;i++){
		if(s.substring(i,i+1)==" "){
			cnt += 1;
		} else {
			break;
		}
	}
	s = s.substring(i,s.length);
	cnt = 0;	//카운트 초기화
	//오른쪽Trim
	for(i = s.length;i > 0;i--){
		if(s.substring(i,i-1)==" "){
			cnt += 1;
		} else {
			break;
		}
	}
	s = s.substring(0,s.length - cnt);
	return (s);
}


//----------------------------------------------------------------------------
//날짜형식체크.
//----------------------------------------------------------------------------
function isDate(value) {
	if( value == ""){
		return false;
	}
	var Date = value.replace(/-/g,'');
	if( Date.length != 8){
		return false;
	}
	var daysInMonth = new Array("31", "28", "31", "30", "31", "30", "31", "31", "30", "31", "30", "31");

	var lvYear = "";
	var lvMonth = "";
	var lvDay = "";

	lvYear = Date.substring(0,4);
	lvMonth = Date.substring(4,6);
	lvDay = Date.substring(6,8);

	if(!isNumber(lvYear) || !isNumber(lvMonth) || !isNumber(lvDay)) {
		return false;
	}
	if(eval(lvYear)%4 == 0) daysInMonth[1] = "29";
	else daysInMonth[1] = "28";

	if(eval(lvDay) > 0 && eval(lvDay) <= eval(daysInMonth[eval(lvMonth)-1])) {
		return true;
	} else return false;
}

function isSsn(lvjumin1, lvjumin2) {

	var weight = 0;
	var check = 1;

	if (lvjumin1.value.length != 6 || lvjumin2.value.length != 7 ) {
		return false;
	}

	fgn_reg_no = lvjumin1.value + lvjumin2.value;

    bForeignerResult = false;
    bDomesticResult = true;

	if ((fgn_reg_no.charAt(6) == "5") || (fgn_reg_no.charAt(6) == "6") || (lvjumin2.value.substr(0,1) == 'F') || (lvjumin2.value.substr(0,1) == 'f')) {
        bForeignerResult = true;
    } else {

    	for (var i=0; lvjumin1.value != null && i<lvjumin1.value.length; i++) {
    		if(!(lvjumin1.value.charAt(i) >= '0' && lvjumin1.value.charAt(i) <= '9') ) {
    			return false;
    		}
    	}

    	for (var i=0; lvjumin2.value != null && i<lvjumin2.value.length; i++) {

    		if(!(lvjumin2.value.charAt(i) >= '0' && lvjumin2.value.charAt(i) <= '9') ) {
    			return false;
    	    }
    	}

        weight += (lvjumin1.value.charAt(0) - '0') * 2;
        weight += (lvjumin1.value.charAt(1) - '0') * 3;
        weight += (lvjumin1.value.charAt(2) - '0') * 4;
        weight += (lvjumin1.value.charAt(3) - '0') * 5;
        weight += (lvjumin1.value.charAt(4) - '0') * 6;
        weight += (lvjumin1.value.charAt(5) - '0') * 7;
        weight += (lvjumin2.value.charAt(0) - '0') * 8;
        weight += (lvjumin2.value.charAt(1) - '0') * 9;
        weight += (lvjumin2.value.charAt(2) - '0') * 2;
        weight += (lvjumin2.value.charAt(3) - '0') * 3;
        weight += (lvjumin2.value.charAt(4) - '0') * 4;
        weight += (lvjumin2.value.charAt(5) - '0') * 5;
        check = (11 - weight % 11) % 10;

        if ((lvjumin2.value.charAt(6) - '0') != check) {
		  check = 0;
		  lvjumin1.value="";
		  lvjumin2.value="";
		  lvjumin1.focus();
		  bDomesticResult = false;
        }
  }

	if(!bDomesticResult && !bForeignerResult) {
		return false;
	}

	return true;
}

function nextFocus(size,curElement,nextElement){
	if ( curElement.value.length == size) {
		if (!isNumber(curElement.value)) {
			curElement.value = "";
		} else {
			nextElement.focus();
		}
	}
}


function formatNumber(str) {
   var nam = str.length % 3;
   var value = "";
   for ( var i = 0; i < str.length; i++ ) {
	  var ch = str.charAt(i);
	  for ( var k = 0; k<str.length/3; k++ ) {
		 if ( i == nam + 3 * k && i != 0 ) value =  value + ',';
	  }
	  value = value + ch;
   }
   return value;
}

/*
 * 사업자등록번호
 */
function isBsnRgN(strBussNo) {

    strBussNo = strBussNo.replace('-','');

    if (strBussNo.length != 10) {
    	return false;
    }
    sumMod = 0;
    sumMod += parseInt(strBussNo.substring(0,1));
    sumMod += parseInt(strBussNo.substring(1,2)) * 3 % 10;
    sumMod += parseInt(strBussNo.substring(2,3)) * 7 % 10;
    sumMod += parseInt(strBussNo.substring(3,4)) * 1 % 10;
    sumMod += parseInt(strBussNo.substring(4,5)) * 3 % 10;
    sumMod += parseInt(strBussNo.substring(5,6)) * 7 % 10;
    sumMod += parseInt(strBussNo.substring(6,7)) * 1 % 10;
    sumMod += parseInt(strBussNo.substring(7,8)) * 3 % 10;
    sumMod += Math.floor(parseInt(strBussNo.substring(8,9)) * 5 / 10);
    sumMod += parseInt(strBussNo.substring(8,9)) * 5 % 10;
    sumMod += parseInt(strBussNo.substring(9,10));

    if (sumMod % 10 != 0) {
    	return false;
    }
    // 여기까지 오면 성공
    return true;
}


function isCrpRgN(sRegNo){
	var re = /-/g;
	sRegNo = sRegNo.replace('-','');
	if(sRegNo.length != 13){
		return false;
	}
	var arr_regno = sRegNo.split("");
	var arr_wt = new Array(1,2,1,2,1,2,1,2,1,2,1,2);
	var iSum_regno = 0;
	var iCheck_digit = 0;
	for(i=0; i<12; i++){
		iSum_regno += eval(arr_regno[i])*eval(arr_wt[i]);
	}

	iCheck_digit = 10-(iSum_regno%10);
	iCheck_digit = iCheck_digit%10;
	if(iCheck_digit != arr_regno[12]){
		return false;
	}

	return true;
}

function containsCharsOnly(input,chars) {
	for (var inx = 0; inx < input.length; inx++) {
	   if (chars.indexOf(input.charAt(inx)) == -1)
		   return false;
	}
	return true;
}


function isId(str) {
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-";
	var bcheck = containsCharsOnly(str, chars);
	var engChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-";
	var numChars = "1234567890";
	var ncheck = false;
	var echeck = false;
	for (var inx = 0; inx < str.length; inx++) {
		if( ncheck == false && containsCharsOnly(str.charAt(inx), numChars ) ) ncheck = true;
		if( echeck == false && containsCharsOnly(str.charAt(inx), engChars ) ) echeck = true;
	}
	if(ncheck == false) bcheck = false;
	if(echeck == false) bcheck = false;
	return bcheck;
}


function isEm(input) {
	return /^((\w|[\-\.])+)@((\w|[\-\.])+)\.([A-Za-z]+)$/.test(input);
}

function setCookie (name, value, expiredays ) {
	 var argv = setCookie.arguments;
	 var argc = setCookie.arguments.length;
	 var expires = (2 < argc) ? argv[2] : null;
	 var path = (3 < argc) ? argv[3] : null;
	 var domain = (4 < argc) ? argv[4] : null;
	 var secure = (5 < argc) ? argv[5] : false;

	 //하루동안 보이지 않도록 설정
	 expires = new Date();
	 expires.setDate( expires.getDate() + expiredays );

	 document.cookie = name + "=" + escape (value) +
	    ((expires == null) ? "" : ("; expires=" + expires.toGMTString())) +
	    ((path == null) ? "" : ("; path=" + path)) +
	    ((domain == null) ? "" : ("; domain=" + domain)) +
	    ((secure == true) ? "; secure" : "");
}

function getCookie( name ) {
	var nameOfCookie = name + "=";
	var x = 0;

	while ( x <= document.cookie.length )
	{
		var y = (x+nameOfCookie.length);
		if ( document.cookie.substring( x, y ) == nameOfCookie )
		{
			if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
				endOfCookie = document.cookie.length;
				return unescape( document.cookie.substring( y, endOfCookie ) );
		}
		x = document.cookie.indexOf( " ", x ) + 1;
		if ( x == 0 )
			break;
	}
	return "";
}

function removeDot(obj) {
	return obj.value.replace(/./g, '');
}

function isAlphaNum(obj) {
    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    return containsCharsOnly(obj,chars);
}

function isAlphabet(obj) {
    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    return containsCharsOnly(obj,chars);
}


function isEmpty(obj) {
	return isNull(obj.value);
}

function isNull(val) {
	if (val == null || val.replace(/ /gi,"") == "" || val == undefined) {
        return true;
    }
    //val = val.trim();
    return false;
}

function isNumber(val){

	var chars = "0123456789";
	return containsCharsOnly(val,chars);
}

function isNumberComma(val) {
  var chars = ",-0123456789.";
  return containsCharsOnly(val,chars);
}

function isNumberDate(val) {
  var chars = "-0123456789";
  return containsCharsOnly(val,chars);
}


function getByteLength(obj) {
	return getByteLengthVal(obj.value);
}

function getByteLengthVal(val) {
	var byteLength = 0;
	for (var inx = 0; inx < val.length; inx++) {
		var oneChar = escape(val.charAt(inx));
		if ( oneChar.length == 1 ) {
			byteLength ++;
		} else if (oneChar.indexOf("%u") != -1) {
			byteLength += 2;
		} else if (oneChar.indexOf("%") != -1) {
			byteLength += oneChar.length/3;
		}
	}
	return byteLength;
}


function setSsnYyyyMmDd(obj){
	if( (event.ctrlKey == true || event.keyCode == "17") && event.keyCode == "86"){
		if( isEmpty(obj) ){
			return;
		}
		if(obj.value.length == 6){
			if( obj.value.substring(0,2) < 30 ) {
				obj.value = "20"+obj.value;
			} else {
				obj.value = "19"+obj.value;
			}
		}
	}
}


function isFromToDate(formObj, toObj, desc){
	if( !isDate(formObj.value) ){
		alert(desc+" 항목이 유효한 날짜가 아닙니다.");
		formObj.focus();
		return false;
	}
	if( !isDate(toObj.value) ){
		alert(desc+" 항목이 유효한 날짜가 아닙니다.");
		toObj.focus();
		return false;
	}
	if( parseInt(formObj.value.replace(/-/g, '')) > parseInt(toObj.value.replace(/-/g, '')) ){
		alert(desc+" 항목의 시작일자("+formObj.value+")는 종료일자("+toObj.value+")보다 작아야 합니다.");
		formObj.focus();
		return false;
	}
	return true;
}



function hasCheckedRadio(obj) {
    if (obj.length > 1) {
        for (var inx = 0; inx < obj.length; inx++) {
            if (obj[inx].checked) return true;
        }
    } else {
        if (obj.checked) return true;
    }
    return false;
}


function addAttachEvent(obj, evnt, fnc) {
	if (obj.attachEvent) {
		obj.attachEvent ('on' + evnt, fnc);
	} else if(obj.addEventListener){
        obj.addEventListener(evnt, fnc, false);
    }
}

//------------------------------------------------------------------------------
// 상담 관련 함수 시작--------------------------------------------------------------
//------------------------------------------------------------------------------
function openWin( path,windowname,w,h,scroll,pos ) {
	var win=null;
	win=window.open(path,windowname,getOpenWinSettings(w,h,scroll,pos));
	if(win.focus) win.focus();
}
function getOpenWinSettings(w,h,scroll,pos) {
	if(pos=="random") {
		LeftPosition=(screen.width)?(screen.width-w)/2:100;
		TopPosition=(screen.height)?(screen.height-h)/2:100;
	}
	if(pos=="center") {
		LeftPosition=(screen.width)?(screen.width-w)/2:100;
		TopPosition=(screen.height)?(screen.height-h)/2:100;
	}
	else if((pos!="center" && pos!="random")) {
		LeftPosition=0;TopPosition=20;
	}
	if(scroll==null) scroll = 'no';

	settings='width='+w+',height='+h+
			 ',top='+TopPosition+
			 ',left='+LeftPosition+
			 ',scrollbars='+scroll+
			 ',location=no,directories=no,status=no,menubar=no,toolbar=no,resizable=no';
	return settings;
}
//------------------------------------------------------------------------------
//달력
//예) 달력호출 fnIBCalendar(document.getElementById("date"));
//------------------------------------------------------------------------------
var iBCalenbarObj = "";
function fnIBCalendar(obj){
	var param = {
			Format : "yyyy-MM-dd",
			Target : obj,
			CalButtonAlign : "Center",
			CalButtons : "Close",
			CallBack : "fnIBCalCallBack"
	};
	iBCalenbarObj = obj;
	IBCalendar.Show(obj.value, param);
}
function fnIBCalendarClose(){
	IBCalendar.Close();
}
function fnIBCalCallBack(date){
	iBCalenbarObj.value = date;
}
function setSplitPhone(val, obj1, obj2, obj3){
	if( isNull(val) ){
		return;
	}
	var data = val.split("-");
	if( data.length == 3){
		obj1.value = data[0];
		obj2.value = data[1];
		obj3.value = data[2];
	} else if( data.length == 2){
		obj2.value = data[0];
		obj3.value = data[1];
	}
}

function validatePhone(obj, obj1, obj2, obj3, desc){

	if( isEmpty(obj1) && isEmpty(obj2) && isEmpty(obj3)){
		return true;
	}
	if( isEmpty(obj1) && !isEmpty(obj2) && !isEmpty(obj3)){
		if( !isNumber(obj2.value) ){
			alert(desc+" 항목은 숫자만 입력하세요.");
			obj2.focus();
			return false;
		}
		if( !isNumber(obj3.value) ){
			alert(desc+" 항목은 숫자만 입력하세요.");
			obj3.focus();
			return false;
		}
		obj.value = obj2.value + "-" + obj3.value;
		return true;
	}
	if( !isEmpty(obj1) && !isEmpty(obj2) && !isEmpty(obj3)){
		if( !isNumber(obj1.value) ){
			alert(desc+" 항목은 숫자만 입력하세요.");
			obj1.focus();
			return false;
		}
		if( !isNumber(obj2.value) ){
			alert(desc+" 항목은 숫자만 입력하세요.");
			obj2.focus();
			return false;
		}
		if( !isNumber(obj3.value) ){
			alert(desc+" 항목은 숫자만 입력하세요.");
			obj3.focus();
			return false;
		}
		obj.value = obj1.value + "-" + obj2.value + "-" + obj3.value;
		return true;
	}
	alert(desc +" 항목을 정확히 입력하세요 예)02-1234-1234");
	return false;
}

function isPhone(tmpNum){
	tmpNum = tmpNum.replace(/-/g,'');
	// 1. 이동통신전화번호 : 010, 011, 016, 017, 018, 019 => 10, 11자리만 가능
	if( tmpNum.indexOf("010") == 0 || tmpNum.indexOf("011") == 0 || tmpNum.indexOf("016") == 0 ||
			tmpNum.indexOf("017") == 0 || tmpNum.indexOf("018") == 0 || tmpNum.indexOf("019") == 0 ){
		if( tmpNum.length >= 10 && tmpNum.length <= 11 ){
			return true;
		} else {
			alert("이동통신전화번호 10, 11자리 미준수["+tmpNum+"]["+tmpNum.length+"]");
			return false;
		}
	} else if( tmpNum.indexOf("15") == 0 || tmpNum.indexOf("16") == 0 || tmpNum.indexOf("18") == 0 ){
		if ( tmpNum.length == 8 ){
			return true;
		} else {
			alert("전국대표번호 8자리 미준수["+tmpNum+"]["+tmpNum.length+"]");
			return false;
		}
	// 3. 공통서비스 식별번호 : 0N0번호 8~12자리만 가능
	} else if( tmpNum.indexOf("020") == 0 || tmpNum.indexOf("030") == 0 || tmpNum.indexOf("040") == 0 ||
			  tmpNum.indexOf("050") == 0 || tmpNum.indexOf("060") == 0 || tmpNum.indexOf("070") == 0 ||
			  tmpNum.indexOf("080") == 0 || tmpNum.indexOf("090") == 0 ){
		if( tmpNum.length >= 8 && tmpNum.length <= 12 ){
			return true;
		} else {
			alert("공통서비스 식별번호 8~12자리 미준수["+tmpNum+"]["+tmpNum.length+"]");
			return false;
		}
	// 4. 일반전화 번호
	} else {
		// 4-1. 8~12자리만 가능
		if( tmpNum.length >= 8 && tmpNum.length <= 12 ){
		    // 4-2. 지역번호 17개(02, 031, 032, 033, 041, 042, 043, 044, 051, 052, 053, 054, 055, 061, 062, 063, 064)
		    if( tmpNum.indexOf("02") == 0 || tmpNum.indexOf("031") == 0 || tmpNum.indexOf("032") == 0 ||
		    		tmpNum.indexOf("033") == 0 || tmpNum.indexOf("041") == 0 || tmpNum.indexOf("042") == 0 ||
		    		tmpNum.indexOf("043") == 0 || tmpNum.indexOf("044") == 0 || tmpNum.indexOf("051") == 0 ||
		    		tmpNum.indexOf("052") == 0 || tmpNum.indexOf("053") == 0 || tmpNum.indexOf("054") == 0 ||
		    		tmpNum.indexOf("055") == 0 || tmpNum.indexOf("061") == 0 || tmpNum.indexOf("062") == 0 ||
		    		tmpNum.indexOf("063") == 0 || tmpNum.indexOf("064") == 0 ){
			     // 4-3. 지역번호를 제외한 뒤 2자리가 15,16,18로 시작하는 경우 등록불가
		    	var chkStart = "";
		    	if( tmpNum.indexOf("02") == 0 ){
		    		chkStart = tmpNum.substr(2, 4);
		    	} else {
		    		chkStart = tmpNum.substr(3, 5);
			    }

			    if( "15" == chkStart || "16" == chkStart || "18" == chkStart ){
			    	alert("일반전화 번호 지역번호 뒤 15,16,18로 시작 미준수["+tmpNum+"]["+tmpNum.length+"]");
			    	return false;
			    } else {
			    	return true;
			    }
		    } else {
		    	alert("일반전화 번호 17개 지역번호 미준수["+tmpNum+"]["+tmpNum.length+"]");
				return false;
		    }
		} else {
			alert("일반전화 번호 8~12자리 미준수["+tmpNum+"]["+tmpNum.length+"]");
			return false;
		}
	}
	return true;
}

//------------------------------------------------------------------------------
//텍스트박스에 숫자만 입력 ex)  onkeypress="javascript:onlyNumber();"
//------------------------------------------------------------------------------
function onlyNumber(obj) {
    if( (event.keyCode<48 || event.keyCode>57) ){
    	alert("숫자만 입력해주세요.");
    	event.returnValue=false;
    }
	if( event.altKey ) event.returnValue=false;
    if( obj != null){
		var str = obj.value;
		if( !isNumber(str) ) {
			// 문자면 backspace 됨
			obj.value = str.substr( 0, str.length - 1 );
			alert("숫자만 입력해주세요.");
			obj.focus();
		}
    }
}
function onlyNumber2(obj) {
    if( ((event.keyCode<48)||(event.keyCode>57)) && event.keyCode != 45 ) event.returnValue=false;
}

function onlyNumber3(obj) {
    if( ((event.keyCode<48)||(event.keyCode>57)) && event.keyCode != 44 ) event.returnValue=false;
}

//입력값이 사용자가 정의한 올바른 입력값인지 체크
function validateFormat(input, format) {
    if (input.search(format) != -1) {
        return true; //올바른 포맷 형식
    }
    return false;
}



//------------------------------------------------------------------------------
//상담 관련 함수 종료--------------------------------------------------------------
//------------------------------------------------------------------------------


/**
 * 날짜 범위 설정 함수
 * 두개의 input box 에 검색 시작일과 검색 종료일을 자동 설정하는 함수
 * 사용예:
 * 1주일 : <a href='javascript:dateCalc(0,0,7,form.fromDate,form.toDate);'><img src="../images/btn_d07.gif" width="37" height="14" border="0"></a>
 * 1개월: <a href='javascript:dateCalc(0,1,0,form.fromDate,form.toDate);'>
 * 3개월: <a href='javascript:dateCalc(0,3,0,form.fromDate,form.toDate);'>
 * 6개월: <a href='javascript:dateCalc(0,6,0,form.fromDate,form.toDate);'>
 * 1년     : <a href='javascript:dateCalc(1,0,0,form.fromDate,form.toDate);'>
 */
function dateCalc(y,m,d, fromObj, toObj) {

	fromday = new Date();
	today = new Date();

   	fromday.setFullYear(today.getFullYear() - y);
		fromday.setMonth(today.getMonth() - m);
		fromday.setDate(today.getDate() - d);

   	var fyear  = fromday.getFullYear();
		var fmonth = fromday.getMonth() + 1; // 1월=0,12월=11이므로 1 더함
		var fday   = fromday.getDate();
		var fhour  = fromday.getHours();
		var fmin   = today.getMinutes();

	if (("" + fmonth).length == 1) { fmonth = "0" + fmonth; }
		if (("" + fday).length   == 1) { fday   = "0" + fday;   }
		if (("" + fhour).length  == 1) { fhour  = "0" + fhour;  }
		if (("" + fmin).length   == 1) { fmin   = "0" + fmin;   }

	var tyear  = today.getFullYear();
		var tmonth = today.getMonth() + 1; // 1월=0,12월=11이므로 1 더함
		var tday   = today.getDate();
		var thour  = today.getHours();
		var tmin   = today.getMinutes();

	if (("" + tmonth).length == 1) { tmonth = "0" + tmonth; }
	if (("" + tday).length   == 1) { tday   = "0" + tday;   }
	if (("" + thour).length  == 1) { thour  = "0" + thour;  }
	if (("" + tmin).length   == 1) { tmin   = "0" + tmin;   }

	fromObj.value = fyear+"-"+fmonth+"-"+fday;
	toObj.value = tyear+"-"+tmonth+"-"+tday;

}


//css
function dateCalClick(obj, firstObjId) {

	var sFisrt = "";
	if( obj.id == firstObjId) {
		sFisrt = "first ";
	}

	for( var i=0; i<document.getElementsByName(obj.name).length; i++) {

		if( document.getElementsByName(obj.name)[i].id == obj.id ) {

			obj.className = sFisrt + "on";
			continue;
		}

		document.getElementsByName(obj.name)[i].className = "first";

	}

}

/**
 * 날짜 형식 YYYY-MM-DD
 * @param obj
 * @returns {Boolean}
 */
function dateFormat(obj)
{
	var str = obj.value;

	if( str.length>0) {
		if( "-" == str.charAt(0)){
			obj.value = "";
			obj.focus();
			return false;
		}
	}

	// 날짜형 숫자만
	if( !isNumberDate(str) ) {
		// 문자면 backspace 됨
		obj.value = obj.value.substr( 0, obj.value.length - 1 );
		obj.focus();
		return false;
	}

	var change,cnt;
	change = obj.value;
	cnt = change.length;
	var returnValue = false;

	if(cnt == 4 ){                             //자릿수에 맞추어 '-' 넣기
		obj.value = obj.value + "-";
	}
	if(cnt == 7 ){                             //자릿수에 맞추어 '-' 넣기
		obj.value = obj.value + "-";
	}

	if(cnt == 8 ){                             //자릿수에 맞추어 '-' 넣기

		var aa = killChar(obj.value,'-','') + "";
		if(aa.length == 8) {

			obj.value = aa.substr(0, 4) + "-" + aa.substr(4, 2) + "-" + aa.substr(6);
		}
	}

	if(cnt >= 10){                             //입력한 날짜가 유효한지 검사
		if (!isDate(killChar(obj.value,'-',''))) {
			alert('유효한 날짜가 아닙니다.');
			obj.value = "";
			obj.focus();
		}
	    return returnValue;
	}

	if( event.keyCode == 8 && cnt == 9  ){		// 일자를 지우고 '-'넣어줌
		obj.value = obj.value.substr( 0, obj.value.length - 2 )+"-";
	}else if( event.keyCode == 8 && cnt == 7  ){// 월을지움
		obj.value = obj.value.substr( 0, obj.value.length - 3 );
	}else if( event.keyCode == 8 ){				//년도지움
		obj.value = "";
	}
}

/**
 * 날짜 형식 YYYY-MM
 * @param obj
 * @returns {Boolean}
 */
function YYYYMMFormat(obj)
{
	var str = obj.value;

	if( str.length>0) {
		if( "-" == str.charAt(0)){
			obj.value = "";
			obj.focus();
			return false;
		}
	}

	// 날짜형 숫자만
	if( !isNumberDate(str) ) {
		// 문자면 backspace 됨
		obj.value = obj.value.substr( 0, obj.value.length - 1 );
		obj.focus();
		return false;
	}

	var change,cnt;
	change = obj.value;
	cnt = change.length;
	var returnValue = false;

	if(cnt == 4 ){                             //자릿수에 맞추어 '-' 넣기
		obj.value = obj.value + "-";
	}
	if(cnt == 7 ){                             //자릿수에 맞추어 '-' 넣기
		obj.value = obj.value;
	}

	if(cnt >= 10){                             //입력한 날짜가 유효한지 검사
		if (!isDate(killChar(obj.value,'-',''))) {
			alert('유효한 날짜가 아닙니다.');
			obj.value = "";
			obj.focus();
		}
	    return returnValue;
	}

	if( event.keyCode == 8 && cnt == 9  ){		// 일자를 지우고 '-'넣어줌
		obj.value = obj.value.substr( 0, obj.value.length - 2 )+"-";
	}else if( event.keyCode == 8 && cnt == 7  ){// 월을지움
		obj.value = obj.value.substr( 0, obj.value.length - 3 );
	}else if( event.keyCode == 8 ){				//년도지움
		obj.value = "";
	}
}

//str중 chr값을 제거
function killChar(str,chr){
	return trimall(XreplaceAll(str,chr,''));
}

//----------------------------------------------------------------------------
//공백문자를 모두 없앰. 추가 (2002.08.23 전수진)
//----------------------------------------------------------------------------
function trimall (str) {
if (str == null) return "";

var dest = str;

for (; dest.indexOf(" ") != -1 ;) {
  dest = dest.replace(" ","") ;
}
return dest;
}

//특정한 문자값을 특정한 문자값으로 치환후 리턴한다.
function XreplaceAll(str,c1,c2){
	var strTmp = "";
	if(c1.length > 1){
		alert("치환할 값이 너무 큽니다.");
		return;
	}
	if(c2.length >1){
		alert("치환될 값이 너무 큽니다.");
		return;
	}
	for ( var i = 0; i < str.length; i++ ) {
		var t = str.charAt(i);
		if(t == c1){
			strTmp = strTmp + c2;
		} else {
			strTmp = strTmp + t;
		}
	}
	return strTmp;
}

// -- 금액


//string형의 숫자에서 계산을 위해 컴마(',')를 제거
function removeComma(str) {

	var value = "";
	for ( var i = 0; i < str.length; i++ ) {
	  var ch = str.charAt(i);
	  if ( ch != ',' ) value = value + ch;
	}
	return value;
}

//string형의 숫자를 금액 형식[###,##0]으로 변환
function getWon(obj) {

	var str = removeComma(obj.value);

	if( !isNumber(str) ) {

		obj.value = "";
		obj.focus();
		return false;
	}

	if( str.length>1) {
		if( "0" == str.charAt(0)){
			obj.value = str.substr(1);
			obj.focus();
			return false;
		}
	}

	obj.value = addComma(str);
}

function getActN(obj) {

	var str = removeComma(obj.value);

	if( !isNumber(str) ) {

		obj.value = "";
		obj.focus();
		return false;
	}

	/*if( str.length>1) {
		if( "0" == str.charAt(0)){
			obj.value = str.substr(1);
			obj.focus();
			return false;
		}
	}*/
}



//paramiter의 값과 문자열의 첫번째 문자 값이 같을경우 true를 반환
function compChar(str,cmp){
	var rtnType = false;
	if(str.length > 0){
		if(str.charAt(0) == cmp){
			rtnType = true;
		}
    }
    return rtnType;
}


//받은 블리언 값이 true일 경우 '-'를 문자열 앞에 붙여 리턴
function addMinus(bol,str){
	str = trimall(str);
	if(eval(bol)){
		str = '-' + str;
	}
	//예외처리
	if(str == "-0"){
		str = "0";
	}
	return str;
}

function addComma(str) {

	var nam = str.length % 3;
	var value = "";

	for ( var i = 0; i < str.length; i++ ) {
	  var ch = str.charAt(i);
	  for ( var k = 0; k<str.length/3; k++ ) {
		 if ( i == nam + 3 * k && i != 0 ) value =  value + ',';
	  }
	  value = value + ch;
	}

	return value;
}


function addCommaM(obj) {
	obj.value = addCommaM2(obj.value);
}

function addCommaM2(str) {
	var head = '';
	var tail = '';

	if(str.indexOf('.') >= 0 ){
		head = str.substr(0,str.indexOf('.'));
		tail = str.substr(str.indexOf('.'));

		str = head;
	}
	var minus = false;

	if(str.charAt(0) == '-'){
		str = str.substr(1);
		minus = true;
	}
	var nam = str.length % 3;
	var value = "";

	for ( var i = 0; i < str.length; i++ ) {
	  var ch = str.charAt(i);
	  for ( var k = 0; k<str.length/3; k++ ) {
		 if ( i == nam + 3 * k && i != 0 ) value =  value + ',';
	  }
	  value = value + ch;
	}
	if(minus){
		value = '-' + value;
	}
	if(tail != ''){
		value = value + tail;
	}
	return value;
}

function validateNumber(obj) {

	var str = obj.value;

	if( !isNumber(str) ) {
		// 문자면 backspace 됨
		obj.value = str.substr( 0, str.length - 1 );
		obj.focus();
		alert("숫자만 입력해주세요.")
		return false;
	}

	return true;
}

/**
 * 날짜가 적합한 날짜인지를 검사한다.
 */
function isValidateDate(strYear, strMonth, strDay) {
	// 숫자인지 검사한다.
	if(!isNumeric(strYear) || !isNumeric(strMonth) || !isNumeric(strDay)) {
		return false;
	}

	iYear = eval(strYear);
	iMonth = eval(strMonth);
	iDay = eval(strDay);

	if(iMonth >= 1 && iMonth <=12) {
		if(iMonth == 2) {
			// 2월달의 일을 검사
			if(iYear%4 == 0 && (iYear%100 != 0 || iYear%400 ==0)) {
				if(iDay >= 1 && iDay <=29) {
					 return true;
				}
			} else {
				if(iDay >= 1 && iDay <=28) {
					 return true;
				}
			}
		} else if((iMonth%2 == 0 && iMonth>=8) || (iMonth%2 == 1 && iMonth<=7)){
			// 짝수인 달의 일을 검사
			if(iDay >= 1 && iDay <= 31){
				return true;
			}
		} else {
			// 홀수인 달의 일을 검사
			if(iDay >= 1 && iDay <= 30){
				return true;
			}
		}
	}

	return false;

}

/**
 * 주어진 문자열이 숫자인지를 검사한다.
 */
function isNumeric(strTarget) {
	for(iIndex = 0; iIndex < strTarget.length; iIndex++) {

		if(strTarget.charAt(iIndex) < '0' || strTarget.charAt(iIndex) > '9') {
			return false;
		}
	}

	return true;
}

//addEvent(window, "load", init);
function addEvent(obj, evnt, fnc) {
	if (obj.attachEvent) {
		obj.attachEvent ('on' + evnt, fnc);
	} else if(obj.addEventListener){
        obj.addEventListener(evnt, fnc, false);
    }
}

/**
 * 기능 : 숫자가 지정된 범위인지 체크
 * 파라미터 : obj(대상값)
 *            int min(최소값)
 *            int max(최대값)
 * 반환값 : true:범위내, false:범위밖
*/
function isNumBetween(obj, iMin, iMax) {

	var num = parseFloat(obj.value);
	var min = parseFloat(iMin);
	var max = parseFloat(iMax);

	if (num >= min && num <= max ) {
		return true;
	}

	return false;
}

function checkPin_new(pin) {

	if (pin.length < 8 || pin.length > 15 ) {

		alert('비밀번호는 8~15자리입니다.');
		return false;
	}

	var num = pin.search(/[0-9]/g);
	var eng = pin.search(/[a-z]/ig);
	var spe = pin.search(/[`~!@@#$%^&*|_\\\';:,.\/?\+\-]/g);
	var il_spe = pin.search(/[\"<>\[\](){}]/g);

	var chkFlg = false;

	if(il_spe >= 0) {
		alert('"<>{}[]() 문자는 입력 할수 없습니다.');
		return false;
	}
	if(num >= 0 && eng >= 0 && spe >= 0 && checkPin2(pin)) {
    	chkFlg = true;
    }

    if(!chkFlg){
		alert('비밀번호 입력 조건\n\n1. 영문/숫자/특수문자를 혼합하여 8~15자리를 입력하셔야 합니다. 비밀번호 사용 예 : [ A413vnee# ]\n\n2. 본인 아이디  4자리 이상 포함 불가, 4자리 연속된 동일한 문자 및 증가되는 문자 불가');
		return false;
	}
	return true;
}

/**
 * 기능 : 패스워드 연속3자리 체크
 * 파라미터 :
 * 반환값 : true/false
 */
function isCheckValue(value){
	var intCnt1 = 0;
	var intCnt2 = 0;

	var temp0 ="";
	var temp1 ="";
	var temp2 ="";
	//var temp3 ="";

	for(var i= 0; i <value.length; i++){
		temp0 = value.charAt(i);
		temp1 = value.charAt(i+1);
		temp2 = value.charAt(i+2);

		if(temp0.charCodeAt(0)-temp1.charCodeAt(0) == 1 &&
		   temp1.charCodeAt(0)-temp2.charCodeAt(0) == 1
		   )
		{
			intCnt1 = intCnt1+1;
		}
		if(temp0.charCodeAt(0)-temp1.charCodeAt(0) == -1 &&
				   temp1.charCodeAt(0)-temp2.charCodeAt(0) == -1
				    )
		{
			intCnt2 = intCnt2+1;
		}
	}

	if(intCnt1 > 0 || intCnt2 > 0 ){
		return true;
	}else{
		return false;
	}
}

/**
 * 기능 : 패스워드 동일 3자리 체크
 * 파라미터 :
 * 반환값 : true/false
 */
function isCheckSamValue(value){

	var temp = "";
	var intCnt = 0;
	for (var i=0; i < value.length; i ++){
		temp = value.charAt(i);
		if(temp == value.charAt(i+1) && temp == value.charAt(i+2)  ){
			intCnt = intCnt +1;
		}
	}
	if(intCnt > 0 ){
		return true;
	}else{
		return false;
	}
}

function checkPin_pwd(id,pin) {

	var t = id.length;
	for (var i = 0; i < t; i++) {
		var sp = i;
		var ep = i + 4;

		if (ep > t) {
			break;
		}

		var check = id.substring(sp, ep);
		if (pin.indexOf(check) >= 0) {
			alert('아이디의 문자중 4자리가 포함된 패스워드는 사용할수 없습니다.');
			return false;
		}
	}
	return true;
}

function checkPin2(pin) {

	var t = pin.length;
	for (var i = 0; i < t; i++) {

		if (i + 4 > t) {
			break;
		}

		var char1 =  pin.charCodeAt(i);
		var char2 =  pin.charCodeAt(i + 1);
		var char3 =  pin.charCodeAt(i + 2);
		var char4 =  pin.charCodeAt(i + 3);

		// 똑같은 문자열
		if (char1 == char2) {
			if (char2 == char3) {
				if (char3 == char4) {
					return false;
				}
			}
		}

		// 증가되는 문자열
		if (char1 == char2 - 1) {
			if (char2 == char3 - 1) {
				if (char3 == char4 - 1) {
					return false;
				}
			}

		}

	}

	return true;
}

//비번찾기 질문 관련
function checkReqItem(item1, itemname, minsize, maxsize)
{
	if(item1.value == '')
	{
		alert(itemname + ' 항목은 필수 항목입니다.');
		item1.focus();
		return false;
	}

	if(minsize > 0 && item1.value.length < minsize)
	{
		alert(itemname + ' 항목의 내용이 너무 작습니다. 최소 문자열 길이 : ' + minsize);
		item1.focus();
		return false;
	}

	if(maxsize > 0 && item1.value.length > maxsize)
	{
		alert(itemname + ' 항목의 내용이 너무 큽니다. 최대 문자열 길이 : ' + maxsize);
		item1.focus();
		return false;
	}

	return true;
}

//trim
function trim(s){
	var cnt

	cnt = 0;	//초기화
	//왼쪽Trim
	for(i=0;i < s.length;i++){
		if(s.substring(i,i+1)==" "){
			cnt += 1;
		}
		else
			break;
	}

	s = s.substring(i,s.length);

	cnt = 0;	//카운트 초기화
	//오른쪽Trim
	for(i = s.length;i > 0;i--){
		if(s.substring(i,i-1)==" "){
			cnt += 1;
		}
		else
			break;
	}
	s = s.substring(0,s.length - cnt);

	return (s);
}


/**
* 날짜 차이 일수 계산
*/
function getGAPDate(vSdate, vEdate, mode) {

	var sdate = (vSdate.replace("-","")).replace("-","");
	var edate = (vEdate.replace("-","")).replace("-","");

	if(sdate == "" || sdate.length < 8 || edate == "" || edate.length < 8) return "0";

	var day = 0;
	var month = 0;
	var year = 0;
	var week = 0;

	var dm1 = (parseFloat(sdate.substring(0,4)) - 1990)*365 + parseFloat(sdate.substring(4,6))*30 + parseFloat(sdate.substring(6,8));
	var dm2 = (parseFloat(edate.substring(0,4)) - 1990)*365 + parseFloat(edate.substring(4,6))*30 + parseFloat(edate.substring(6,8));

	var gap = dm2 - dm1;
	day = gap  + 1 ;
	month = day / 30;
	week = day / 7;

	var returnVal = "";

	if(mode == "1"){
		returnVal = day ;
	}else if(mode == "2"){
		returnVal = week;
	}else if(mode == "3"){
		returnVal = month;
	}else if(mode == "4"){
		if(day > 365) {
			year = gap / 365;
			day = gap%365;
			month = day / 30;
		}
		returnVal = year + "년 " + month +"개월";
    }else {
    	returnVal = "잘못된 mode";
    }

	return returnVal;
}

/**
 * 사업자등록번호 체크
 * @param bussno
 * @returns
 */
function validateBussno(bussno) {

	chkval = new Array(9);

	chkval[0] = 1;
	chkval[1] = 3;
	chkval[2] = 7;
	chkval[3] = 1;
	chkval[4] = 3;
	chkval[5] = 7;
	chkval[6] = 1;
	chkval[7] = 3;
	chkval[8] = 5;

	var sum = 0;
	var flag;

	for (var i=0; i<8; i++) {

		sum = sum + (chkval[i] * parseInt(bussno.charAt(i)));

	}

	imsi = chkval[8] * parseInt(bussno.charAt(8));

	s_imsi = new String(imsi);

	if (s_imsi.length == 2)
		sum = sum + parseInt(s_imsi.substring(0,1)) + parseInt(s_imsi.substring(1,2));
	else
		sum = sum + parseInt(s_imsi);

	remainder = sum % 10;

	if (remainder==0)
		bussno_chk = 0;
	else
		bussno_chk = 10 - remainder;

	if (bussno_chk == parseInt(bussno.charAt(9))) {
		flag = true;
	}
	else {
		flag = false;
		alert("사업자등록번호가 잘못되었습니다.");
	}

	return flag;

}

/**
 * 입력값이 사용자가 정의한 올바른 입력값인지 체크
 */
function isValidFormat(input, format) {
    if (input.search(format) != -1) {
        return true; //올바른 포맷 형식
    }
    return false;
}

/**
* 이메일주소 형식 체크
*/
function isValidateEmail(input) {
    var format = /^((\w|[\-\.])+)@((\w|[\-\.])+)\.([A-Za-z]+)$/;
    return isValidFormat(input,format);
}

/**
* 휴대폰 형식 체크- ibsheet
*/
function isValidateHdpN(input) {

	var hdpN = input.replace(/-/g,'');
	var rgEx = /(01[016789])(\d{4}|\d{3})\d{4}$/g;
	var chkFlg = rgEx.test(hdpN);
	if(!chkFlg){
		return false;
	}
	return true;
}

/**
* 전화번호 체크- ibsheet
*/
function isValidateTelN(input) {

	var telN = input.replace(/-/g,'');
	var rgEx = /(\d{3}|\d{2})(\d{4}|\d{3})\d{4}$/g;
	var chkFlg = rgEx.test(telN);
	if(!chkFlg){
		return false;
	}
	return true;
}

/**
 * 소수점이하 두째자리까지만 처리
 * ex) 참여율 : 80.00
 */
function isValidateRt(obj, dotIdx,  desc) {

	if (obj.value == '' ){
		obj.value = 0;
		obj.focus();
		return;
	}

	obj.value = trim(obj.value);

	if ( !isNumberComma(obj.value) ) {
		alert(desc+ "은 숫자만 입력가능합니다. ex)###.#0");
		obj.focus();
		return false;
	}

	if(!isNumBetween(obj, 1, 130) ) {
		alert(desc+ "은 0%초과 ~ 130%이하 까지만 입력가능합니다.");
		if(obj.value.length > 3) {
			obj.value = obj.value.substring(0, 3);
		}
		obj.focus();
		return false;
	}

	var zeroCount = 0;
	for(var i = 0 ; i < obj.value.length ; i++)
	{
		if(obj.value.charAt(i) == '0')
			zeroCount++;
		else
			break;
	}

	if(zeroCount == obj.value.length)
	{
		obj.value = '0';
	}else
	{
		obj.value = obj.value.substring(zeroCount);
	}

	var txtValue = removeComma(obj.value);

	var point = txtValue.indexOf(".");
	var prePoint = "";
	var afterPoint = "";

	// 소수점이 아닌경우
	if(point == -1) prePoint = txtValue;
	else {
		// 소수점일 경우
		prePoint = txtValue.substring(0, point);
		afterPoint = txtValue.substring(point, txtValue.length);

		if(afterPoint.length > (dotIdx+1)) {
			alert(desc+"은 소수점이하 "+ dotIdx+"째자리까지만 입력하십시오.");
			obj.focus();
			obj.value = prePoint + txtValue.substring(point, point+3);
			return false;
		}
	}

	var tmpstr = "";
	if ( !isNumber(prePoint)
			|| !isNumber(afterPoint.substring(1))) {
		alert(desc + "은 숫자를 입력하십시오.");
		obj.focus();
		obj.value = 0;
		obj.focus();
		return;
	}  else if ( txtValue.length > 0 ) {


		if ( prePoint.substring(0, 1) == "-" ) {

			tmpstr = prePoint.length > 4 ? "-" +getWon(prePoint.substring(1)) : prePoint;
		} else {

			tmpstr =  prePoint;

		}

		obj.value = tmpstr + afterPoint;
	}

}

//한글만 입력
function onlyKorean(){
	if(event.keyCode != 13){
		if( (event.keyCode<12592)||(event.keyCode>12687) ) {
			alert("한글만 입력해주세요.");
			event.returnValue=false;
		}
		if( event.altKey ) event.returnValue=false;
	}
}



function cardAuthTab(obj, cnt, nextObj) {

	if(!validateNumber(obj)) {

		obj.focus();

	}

	if( nextObj != "end") {
		if( obj.value.length == cnt) {
			nextObj.focus();
		}
	}

}

//입력문자의종류를확인(ID 확인시 자주 사용)
function isStringKind(obj) {
	var objlen = obj.value.length;
	var retvalue = 0;

	for (i=0; i<objlen; i++)
	{
		// 숫자일 경우
		if ( obj.value.charAt(i) >= '0' && obj.value.charAt(i) <= '9' )
		{
			if (retvalue == 0 || retvalue == 1)
				retvalue = 1;
			else if (retvalue == 2)
				retvalue = 2;
			else if (retvalue == 3 || retvalue == 4 || retvalue == 5)
				retvalue = 5;
		}

		// 문자일 경우
		else if ( (obj.value.charAt(i) >= 'a' && obj.value.charAt(i) <= 'z') || (obj.value.charAt(i) >= 'A' && obj.value.charAt(i) <= 'Z') )
		{
			if (retvalue == 0 || retvalue == 3)
				retvalue = 3;
			else if (retvalue == 4)
				retvalue = 4;
			else if (retvalue == 1 || retvalue == 2 || retvalue == 5)
				retvalue = 5;
		}

		// "-"일 경우
		else if ( obj.value.charAt(i) == '-' )
		{
			if (retvalue == 0 || retvalue == 5)
				retvalue = 5;
			else if (retvalue == 1 || retvalue == 2)
				retvalue = 2;
			else if (retvalue == 3 || retvalue == 4)
				retvalue = 4;
		}

		// 그 외의 문자일 경우
		else
		{
			retvalue = 0;
			break;
		}

	}

	return retvalue;
}

// 자리수 확인
function isLenBetween(obj,min,max) {
	if (obj.value.length >= min && obj.value.length <= max )
		return true;

	return false;
}

//사업자 번호 체크
function fun_bussno_chk(bussno) {

	chkval = new Array(9);

	chkval[0] = 1;
	chkval[1] = 3;
	chkval[2] = 7;
	chkval[3] = 1;
	chkval[4] = 3;
	chkval[5] = 7;
	chkval[6] = 1;
	chkval[7] = 3;
	chkval[8] = 5;

	var sum = 0;
	var flag;

	for (var i=0; i<8; i++) {

		sum = sum + (chkval[i] * parseInt(bussno.charAt(i)));

	}

	imsi = chkval[8] * parseInt(bussno.charAt(8));

	s_imsi = new String(imsi);

	if (s_imsi.length == 2)
		sum = sum + parseInt(s_imsi.substring(0,1)) + parseInt(s_imsi.substring(1,2));
	else
		sum = sum + parseInt(s_imsi);

	remainder = sum % 10;

	if (remainder==0)
		bussno_chk = 0;
	else
		bussno_chk = 10 - remainder;

	if (bussno_chk == parseInt(bussno.charAt(9))) {
		flag = true;
	}
	else {
		flag = false;
		alert("사업자등록번호가 잘못되었습니다.");
	}

	return flag;

}
function getPrnCrn(val){
	if( isNull(val) ) return "";
	if( val.length == 16){
		return val.substr(0, 4)+"-"+val.substr(4, 4)+"-"+val.substr(8, 4)+"-"+val.substr(12, 4);
	} else {
		return val;
	}
}
function XecureWebPrintFileObjectTag () {
    var tag;
    var agent;
    //agent = Agent();
    if((navigator.appName == 'Netscape' ) && (navigator.userAgent.indexOf("Trident") == -1)) {
    	tag = "<EMBED type='application/x-SoftForum-XWFile' hidden=true name='FileAccess'>";
    }else {
        tag = '<OBJECT ID="FileAccess" CLASSID="CLSID:6AC69002-DAD5-11D4-B065-00C04F0CD404" CODEBASE="http://download.softforum.co.kr/Published/XecureWeb/v7.2.5.0/xw_install.cab#Version=7,2,5,0" width=0 height=0><PARAM NAME="SECKEY" VALUE="XW_SKS_INCA_DRIVER"><PARAM NAME="lang" VALUE="KOREAN"><PARAM NAME="STORAGE" VALUE="HARD,REMOVABLE,ICCARD,MPHONE,PKCS11">No XecureWeb 7.2 PlugIn</OBJECT>';
    }
    document.write(tag);
}
function XecureWebFileUpload(link, uploadForm){
	var qs;
	var errCode;
	var errMsg='';
	var extname;
	var filename;
	var docKind;
	var agent = Agent();
	qs = link.search;
	if ( qs.length > 1 ) {
    	qs = link.search.substring(1);
	}
	path = link.pathname;
	ext = path.lastIndexOf('.');
	//php확장자가 php3 php4 phps php 인 경우에 대해서 처리한다. 그 이외의 경우에는 조건문에 추가해 준다.
	extname = path.substring(ext + 1, ext + 4);
	if(extname == 'php')
		docKind = "php";
	else
		docKind	= "jsp";

	if((navigator.appName == 'Netscape' ) && (navigator.userAgent.indexOf("Trident") == -1)) {
    	if(agent != 'Mozilla/5') {
			filename = document.FileAccess.FileSelect();
   			if( filename == "" ) {
    			errCode = document.FileAccess.LastErrCode();
    			errMsg = unescape(document.FileAccess.LastErrMsg());
				EAlert( errCode, errMsg );
    			return false;
			}
			if(docKind == "php")
				r = document.FileAccess.FileUpload(xgate_addr, "/cgi-bin/xw_upload.cgi", "", hostname, port,filename, escape(desc_upload));
			else
    			r = document.FileAccess.FileUpload(xgate_addr, path, escape(qs), hostname, port,filename, escape(desc_upload));

   			if( r== "" )
   			{
   				errCode = document.FileAccess.LastErrCode();
   				errMsg = unescape(document.FileAccess.LastErrMsg());
				EAlert( errCode, errMsg );
   				return false;
   			}
		}
	}else{
    	path = "/" + path;
		filename = document.FileAccess.FileSelect();

   		if( filename == "" ) {
   			errCode = document.FileAccess.LastErrCode();
   			errMsg = unescape(document.FileAccess.LastErrMsg());
			EAlert( errCode, errMsg );
   			return false;
		}

   		//alert("xgate_addr=>"+xgate_addr+":path=>"+path+":qs=>"+qs+":hostname=>"+hostname+":port=>"+port);

		if(docKind == "php")
			r = document.FileAccess.FileUpload(xgate_addr, "/cgi-bin/xw_upload.cgi" ,"", hostname, port, filename, desc_upload);
		else
			r = document.FileAccess.FileUpload(xgate_addr,path ,qs, hostname, port, filename, desc_upload);

   		if( r== "" || r== null ){
   			errCode = document.FileAccess.LastErrCode();
   			errMsg = document.FileAccess.LastErrMsg();
			EAlert( errCode, errMsg );
   			return false;
   		}
	}
	if( r == 'CANCEL'){
		alert('암호화 파일 전송이 취소 되었습니다!');
		return false;
	}
	if(r == "SFE20" || r == "SFE21" || r == "SFE22" || r == "SFE23"){
		return false;
	}
	if( r == 'OK' ){
		alert('암호화 파일 전송이 완료 되었습니다!');
		return false;
	}
	if( r.indexOf("USR_DFN_ERR") >= 0){
		alert(r.substring(11));
		return false;
	}
	var v_uploadForm = document.getElementById(uploadForm);
	v_uploadForm.fileSeq.value = r;
	v_uploadForm.filePath.value = filename;
	return false;
}

//'-' 제거
function removeHyphen(str) {
   var value = "";
   for ( var i = 0; i < str.length; i++ ) {
	  var ch = str.charAt(i);
	  if ( ch != '-' ) value = value + ch;
   }
   return value;
}


function fnIBYMCalendar(obj){
	var param = {
			Format : "yyyy-MM",
			Target : obj,
			CalButtonAlign : "Center",
			CalButtons : "Close",
			CallBack : "fnIBCalCallBack"
	};
	iBCalenbarObj = obj;
	IBCalendar.Show(obj.value, param);
}


function isFromToMonth(formObj, toObj, desc){
	if( !isMonth(formObj.value) ){
		alert(desc+" 항목이 유효한 날짜가 아닙니다.");
		formObj.focus();
		return false;
	}
	if( !isMonth(toObj.value) ){
		alert(desc+" 항목이 유효한 날짜가 아닙니다.");
		toObj.focus();
		return false;
	}
	if( parseInt(formObj.value.replace(/-/g, '')) > parseInt(toObj.value.replace(/-/g, '')) ){
		alert(desc+" 항목의 시작월("+formObj.value+")는 종료월("+toObj.value+")보다 작아야 합니다.");
		formObj.focus();
		return false;
	}
	return true;
}

function isMonth(value) {
	var strDate = value+"01";
	return isDate(strDate);
}

/**
 * 날짜 형식 YYYY-MM
 * @param obj
 * @returns {Boolean}
 */
function monthFormat(obj)
{
	var str = obj.value;

	if( str.length>0) {
		if( "-" == str.charAt(0)){
			obj.value = "";
			obj.focus();
			return false;
		}
	}

	// 날짜형 숫자만
	if( !isNumberDate(str) ) {
		// 문자면 backspace 됨
		obj.value = obj.value.substr( 0, obj.value.length - 1 );
		obj.focus();
		return false;
	}

	var change,cnt;
	change = obj.value;
	cnt = change.length;
	var returnValue = false;

	if(cnt == 4 ){                             //자릿수에 맞추어 '-' 넣기
		obj.value = obj.value + "-";
	}

	if(cnt == 7 ){                             //자릿수에 맞추어 '-' 넣기

		var aa = killChar(obj.value,'-','') + "";
		if(aa.length == 6) {

			obj.value = aa.substr(0, 4) + "-" + aa.substr(4);
		}
	}

	if(cnt >= 7){                             //입력한 날짜가 유효한지 검사
		if (!isMonth(killChar(obj.value,'-',''))) {
			alert('유효한 날짜가 아닙니다.');
			obj.value = "";
			obj.focus();
		}
	    return returnValue;
	}

}


/**
 * - 포함 금액 처리 관련
 */
function getMinusWon(obj) {

	if (obj.value == '' ){
		obj.value = 0;
		obj.focus();
		return;
	}

	obj.value = trim(obj.value);

	var zeroCount = 0;
	for(var i = 0 ; i < obj.value.length ; i++)
	{
		if(obj.value.charAt(i) == '0')
			zeroCount++;
		else
			break;
	}

	if(zeroCount == obj.value.length)
	{
		obj.value = '0';
	}else
	{
		obj.value = obj.value.substring(zeroCount);
	}

	var txtValue = removeComma(obj.value);

	// -처리
	var bln = compChar(txtValue,'-');

	if(bln){
		//값을 제거
		txtValue = killChar(txtValue,'-');
	}

	if ( isNumber(txtValue) == false ) {
		alert("금액 형태의 자료에 문자가 입력되었습니다.");
		obj.value = 0;
		obj.focus();
		return;
	}

	var value = addComma(txtValue);
	obj.value = addMinus(bln, value);
}


// 영문과 숫자만 입력 가능
function onlyEngNum(obj){
	var patten = /^[A-Za-z0-9]*$/;
	patten = obj.value.match(patten);

	if(patten == null){
		alert("영문과 숫자만 입력할 수 있습니다.");
		return false;
	}
	return true;
}

//'-' 제거
function comRemoveHyphen(p_obj) {
	p_obj.value = removeHyphen(p_obj.value);
	p_obj.select();
}

/**
 * 유효한 날짜인지 검사
 */
function isValidateDate2(p_date) {
	if(!isNumeric(p_date)){
		return false;
	}
	if(p_date.length != 8){
		return false;
	}
	var iYear  = eval(p_date.substring(0,4));
	var iMonth = eval(p_date.substring(4,6));
	var iDay   = eval(p_date.substring(6,8));

	if(iMonth >= 1 && iMonth <=12) {
		if(iMonth == 2) {
		    // 2월달의 일을 검사
		    if(iYear%4 == 0 && (iYear%100 != 0 || iYear%400 ==0)) {
		    	if(iDay >= 1 && iDay <=29) {
		    		return true;
		        }
		    } else {
		    	if(iDay >= 1 && iDay <=28) {
		    		return true;
		        }
		    }
	    } else if((iMonth%2 == 0 && iMonth>=8) || (iMonth%2 == 1 && iMonth<=7)){
		    // 짝수인 달의 일을 검사
		    if(iDay >= 1 && iDay <= 31){
		    	return true;
		    }
	    } else {
	    	// 홀수인 달의 일을 검사
	    	if(iDay >= 1 && iDay <= 30){
	    		return true;
	    	}
	    }
	}
	return false;
}

/**
 * 유효한 날짜인지 검사
 */
function isDate2(p_obj) {
	// '-' 제거
	p_obj.value = trim(removeHyphen(p_obj.value));
	var l_date = p_obj.value;

	// 날자를 입력하지 않은 경우
	if(l_date.length == 0){
		return;
	}
	if(!isValidateDate2(l_date)){
		alert('유효한 날짜가 아닙니다.');
		p_obj.value = "";
		return;
	}
	// '-' 추가
	p_obj.value = l_date.substring(0,4) + "-" + l_date.substring(4,6) + "-" + l_date.substring(6,8);
}

/**
 * 숫자, -(마이너스) 가능
 */
function onlyNum() {
	if ((event.keyCode >= 48 && event.keyCode <= 57) || event.keyCode == 45) {
		return true;
	} else {
		event.returnValue = false;
	}
}

/**
 * 숫자만 가능
 */
function onlyNum1() {
	if (event.keyCode >= 48 && event.keyCode <= 57) {
		return true;
	} else {
		event.returnValue = false;
	}
}


/**
 * 날짜가 적합한 날짜인지를 검사한다.
 */
function isValidDate(strYear, strMonth, strDay) {
	// 숫자인지 검사한다.
	if(!isNumeric(strYear) || !isNumeric(strMonth) || !isNumeric(strDay)) {
		return false;
	}

	iYear = eval(strYear);
	iMonth = eval(strMonth);
	iDay = eval(strDay);

	if(iMonth >= 1 && iMonth <=12) {
		if(iMonth == 2) {
			// 2월달의 일을 검사
			if(iYear%4 == 0 && (iYear%100 != 0 || iYear%400 ==0)) {
				if(iDay >= 1 && iDay <=29) {
					 return true;
				}
			} else {
				if(iDay >= 1 && iDay <=28) {
					 return true;
				}
			}
		} else if((iMonth%2 == 0 && iMonth>=8) || (iMonth%2 == 1 && iMonth<=7)){
			// 짝수인 달의 일을 검사
			if(iDay >= 1 && iDay <= 31){
				return true;
			}
		} else {
			// 홀수인 달의 일을 검사
			if(iDay >= 1 && iDay <= 30){
				return true;
			}
		}
	}

	return false;

}


function EmptyChk(obj) {
	var lvString;
	lvString = obj.value;
	for( i = 0 ; i < lvString.length ; i++)
	{
		if(lvString.charAt(i) != " ")
			return true;
	}
	return false;
}

/**
 * 법인비대면 함수
 */
//한글명
function krName036(e) {
	var con = /[^ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/g;
	var del = e.target;
	if(con.test(del.value)) {
		del.value = del.value.replace(con, "");
	}
}
//영문명
function engName036(e) {
	var con = /[^A-Z ]/g;
	var del = e.target;
	if(con.test(del.value)) {
		del.value = del.value.replace(con, "");
	}
}
function num0361(e) {
	var pattern = /[^0-9]/g;
	var del = e.target;
	if(pattern.test(del.value)) {
		del.value = del.value.replace(pattern, "");
	}
}
function num0362(obj) {
	obj.value = obj.value.replace(/[^0-9]/g,'');
}
function goSubPage(arg) {
	var form = document.menuTop1;
	form.action = arg;
	form.target="_self";
	form.method="get";
	if(arg == "/comm/comm00800.do") {
		form.submit();
		return;
	}
	if(form.taskNo.value == "") {
		alert("과제선택 후 사용가능합니다.");
		return;
	}
	form.submit();
}
function addEvent(element, event, handler) {
	    if (element.addEventListener) {
	        element.addEventListener(event, handler, false);
	    } else if (element.attachEvent) {
	        element.attachEvent('on' + event, handler);
	    } else {
	        element['on' + event] = handler;
	    }
	}
