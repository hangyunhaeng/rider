/** 날짜 */
function getStringDate(str){
	if(str == null)
		return null;
	if(str.length < 8 )
		return null;

	return str.substr(0, 4)+"-"+str.substr(4, 2)+"-"+str.substr(6, 2);

}
/**
 * null을 ""반환
 */
function nullToString(str){
	var descStr = str;
	if(descStr == null){
		return "";
	}
	if(descStr.trim() == "null"){
		return "";
	}

	return descStr.trim();
}
/**
 * 숫자만 반환
 */
function getOnlyNumber(str){
	 var regex = /[^0-9]/g;
	 return str.replace(regex, "");
}

/**
 * 핸드폰 번호 하이픈 처리
 */
function addHyphenToPhoneNumber(phoneNumberInput) {
    const phoneNumber = nullToString(phoneNumberInput);

    const length = phoneNumber.length;
    if(length >= 9) {
        let numbers = phoneNumber.replace(/[^0-9]/g, "").replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`);
        return numbers;
    }
    return phoneNumberInput;
}

/**
 * 사업자번호 하이픈 처리
 */
function addHyphenToregistrationSn(registrationSnInput) {
    const registrationSn = nullToString(registrationSnInput);
    const length = registrationSn.length;
    if(length >= 10) {
        let numbers = registrationSn.replace(/[^0-9]/g, "").replace(/^(\d{3})(\d{2})(\d{5})$/, `$1-$2-$3`);
        return numbers;
    }
    return registrationSnInput;
}

/**
 * 비밀번호 체크
 */
function chkPass(jqueryObj){
	let pw_check = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$/; // 패스워드 정규식 체크
	let enterPW = jqueryObj.val();

	if(enterPW.length == 0 || enterPW.length < 8){
		alert("새 비밀번호 는 8자리 이상이어야 합니다");
		jqueryObj.focus()
		return false;
	}

    if(!pw_check.test(enterPW)){
        alert("영문, 숫자, 특수문자를 1자리씩 포함해야 합니다");
        jqueryObj.focus()
        return  false;
    }
    return true;
}
// populateSelectOptions 함수
async function populateSelectOptions(selectId, mapping, selectedValue = '', option) {
    // 필요한 경우 ioeCdMapping 데이터 로드
    if (selectId === 'srcIoeCd') {
       await loadIoeCdMapping();
       mapping = ioeCdMapping;
    }
    // 필요한 경우 ioeCdMapping 데이터 로드
    if (selectId === 'srcBizCd') {
       await loadBizCdMapping();
       mapping = getFilteredBizCdMapping(1, '');
    }
    // 필요한 경우 ioeCdMapping 데이터 로드
    if (selectId === 'srcChildBizCd') {
       await loadBizCdMapping();
       mapping = getFilteredBizCdMapping(2, selectedValue);
       selectedValue = '';
    }

    const selectElement = document.getElementById(selectId);

    if (!selectElement) {
        console.error(`Element with id '${selectId}' not found.`);
        return;
    }

    // 기존 옵션 제거
    selectElement.innerHTML = '';
	if(option != null){
		if(option.opt == "all"){
	        const option = document.createElement('option');
	        const key = 'all';
	        const value = '전체'
	        option.value = key;
	        option.textContent = value;
	        selectElement.appendChild(option);
		} else if(option.opt == "-"){
	        const option = document.createElement('option');
	        const key = '';
	        const value = '선택'
	        option.value = key;
	        option.textContent = value;
	        selectElement.appendChild(option);
		}
	}

    // 옵션 추가
    mapping.forEach(item => {
        // display가 'none'인 항목은 추가하지 않음
        if (item.display && item.display.toLowerCase() === 'none') {
            return;
        }

        const option = document.createElement('option');
        // key와 value를 대소문자 구분 없이 처리
        const key = item.seleceKey || item.SELECEKEY || '';
        const value = item.selectValue || item.SELECTVALUE || '';
        option.value = key;
        option.textContent = value;
        if (key.toLowerCase() === selectedValue.toLowerCase()) {
            option.selected = true;
        }
        selectElement.appendChild(option);
    });
}

/**
 * 숫자 컴마처리 / 화폐처리
 */
function currencyFormatter(params) {
    if (params === null || params === undefined) {
        return '0'; // null 또는 undefined인 경우 빈 문자열 반환
    }

	var inputDataArr;
    if (typeof params === 'string' || typeof params === 'number') {
        inputDataArr = params.toString().split(".");
    } else if (params.value !== undefined && params.value !== null) {
        inputDataArr = params.value.toString().split(".");
    } else {
        inputDataArr = params.toString().split(".");
    }

    return getOnlyNumber(inputDataArr[0]).replace(/\B(?=(\d{3})+(?!\d))/g, ",")+(inputDataArr[1] != undefined ? "."+inputDataArr[1] : "");
}

/**
 * 그리드 - 사업자번호
 */
function gridRegistrationSn(params){
    if (new RegExp(/[^0-9+-]/).test(params.newValue)) {
        alert('숫자만 입력하세요');
        return params.oldValue;
    }

    var regex = /[^0-9]/g;
    if(params.newValue.replace(regex, "").length != 10){
		alert('사업자번호는 총 10자리 입니다.');
		//return params.newValue.replace(regex, "").substring(0, 10);
		return params.oldValue;
	}
    return params.newValue;
}
/**
 * 그리드 - 비밀번호
 */
function gridCheckPass(params){
	let pw_check = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$/; // 패스워드 정규식 체크

	if(params.newValue.length == 0 || params.newValue.length < 8){
		alert("새 비밀번호 는 8자리 이상이어야 합니다");
		return params.oldValue;
	}

    if(!pw_check.test(params.newValue)){
        alert("영문, 숫자, 특수문자를 1자리씩 포함해야 합니다");
		return params.oldValue;
    }

    return params.newValue;
}

/**
 * 그리드 전화번호 검사
 */
function gridValidPhoneNumber(params){

	if(!validMobileCheck(params.newValue)){
		alert("유효한 핸드폰 번호가 아닙니다");
		return params.oldValue;
	}
    return params.newValue;
}
/**
 * 그리드 수수료 퍼센트 검사
 */
function gridPercent(params) {

	var inputDate = params.newValue.toString();


    if (new RegExp(/[^0-9.]/).test(inputDate)) {
        alert('숫자만 입력하세요');
        return params.oldValue;
    }

    var arrInputData = inputDate.split('.');
    if(arrInputData.length > 2){
		alert("정확한 숫자를 입력하세요");
        return params.oldValue;
	}

    if(arrInputData[1] != undefined && arrInputData[1].length > 3){
		alert("소수점 이하 3자리까지만 허용됩니다");
        return params.oldValue;
	}
	if(arrInputData[0] != undefined && arrInputData[0].length > 2){
		alert("100%이상은 적용할 수 없습니다");
        return params.oldValue;
	}

    return params.newValue;
}

/**
 * 그리드 수수료 금액 검사
 */
function gridWan(params) {

	var inputDate = params.newValue;

    if (new RegExp(/[^0-9,]/).test(inputDate)) {
        alert('숫자만 입력하세요');
        return params.oldValue;
    }

    inputDate = getOnlyNumber(inputDate);
    if(inputDate.length > 10){
		alert("10자리 이상 적용할 수 없습니다");
        return params.oldValue;
	}

    return params.newValue;
}
/** 유효한 날짜 체크 */
function gridValidDate(params) {

	var inputDate = params.newValue;
	if(inputDate.length == 8){
		inputDate = getStringDate(inputDate)
	}

	if(nullToString(inputDate) == ""){
		return "";
	}
	// 날짜 형식이 YYYY-MM-DD 인지 확인 (정규 표현식 사용)
    const regex = /^\d{4}-\d{2}-\d{2}$/;
    if (!regex.test(inputDate)) {
        alert('유효한 날짜가 아닙니다');
    	return '';
    }

	const date = new Date(inputDate);

	const [year, month, day] = inputDate.split('-').map(num => parseInt(num, 10));

    // Date 객체가 입력된 날짜와 일치하는지 확인
    if(date.getFullYear() === year && date.getMonth() + 1 === month && date.getDate() === day)
    	return getOnlyNumber(inputDate);
	else {
		alert('유효한 날짜가 아닙니다');
    	return '';
    }

}


const add = new Function('i','a', 'b', 'c', 'return (a.getRowNode(i).data[b] == c) ? a.getRowNode(i) : null ;');
//그리드 내에서 값이 같은 node를 리턴한다.(그런데 루프문에 break가 안되네..)
function findRowNode(gridObj, fileId, value){
	var node;
	gridObj.forEachNode( function(rowNode, index) {
		if(add(index, gridObj, fileId, value) != null){
			node = add(index, gridObj, fileId, value);
			return true;	//break,(break가 되지 않음)
		}

	});
	return node;
}

//필드를 수정하면 crud 값을 변경 해준다.
function changeCrud(params, gridObj, key){
	const colId = params.column.getId();
	if(colId != 'crud' && colId != 'chk'){
		if(params.data.crud != 'c'){
			var nodeObj = findRowNode(gridObj, key, params.data[key]);
			if(colId == 'useAt' && params.data.useAt == 'N'){
				nodeObj.setDataValue('crud', 'd');
				return;
			}
			nodeObj.setDataValue('crud', 'u');
		}

	}
}
//모든 노드 가져오기
function getAllRows(gridObj) {
	  let rowData = [];
	  gridObj.forEachNode(node => rowData.push(node.data));
	  return rowData;
}
//수정된 노드 가져오기
function getEditRows(gridObj){
	var updateRows = [];
	gridObj.forEachNode( function(rowNode, index) {
		if(rowNode.data.crud == 'c' || rowNode.data.crud == 'u'|| rowNode.data.crud == 'd'){
			updateRows.push(rowNode.data);
		}
	});
	return updateRows;
}
//체크된 노드 가져오기
function getChkRows(gridObj){
	var updateRows = [];
	gridObj.forEachNode( function(rowNode, index) {
		if(rowNode.data.chk == true || rowNode.data.chk == 'true' ){
			updateRows.push(rowNode.data);
		}
	});
	return updateRows;
}

function replaceRevTag(str){
	var returnStr = str;
	returnStr = returnStr.replaceAll(/\&lt;/gi, "<");
	returnStr = returnStr.replaceAll(/\&quot;/gi, "\"");
	returnStr = returnStr.replaceAll(/\&gt;/gi, ">");
	returnStr = returnStr.replaceAll(/\&amp;/gi, "&");
	returnStr = returnStr.replaceAll(/\&#039;/gi, "'");
	returnStr = returnStr.replaceAll(/\&#035;/gi, "#");
	return returnStr;
}
function replaceRevN(str){
	return str.replaceAll(/\n/gi,  "<br/>");
}
function replaceN(str){
	var returnStr = str;
	returnStr = returnStr.replaceAll(/<br\/>/gi, "\n")
	returnStr = returnStr.replaceAll(/<br>/gi, "\n")
	return returnStr;
}

let paging = {
	    pIdx: 1,	//현재 페이지
		maxIdx : 5,	//최대 페이지
		totalCnt : 0,	//총 갯수
		objectCnt : 15,	//페이지당 갯수
		toPageCnt : 0,	//총 페이지
		div:null,
		fnc:null,
	    createPaging: function(obj, cnt, maxCnt, fnc) {

	    	this.div = obj;
	    	this.totalCnt = cnt;
	    	this.objectCnt = maxCnt;
	    	this.fnc = fnc;
	    	this.toPageCnt = Math.ceil(this.totalCnt/this.objectCnt);

	    },
	    setPageing: function(paramIdx,paramCnt){
			this.pIdx = paramIdx;
	    	this.totalCnt = Number(paramCnt);
	    	this.toPageCnt = Math.ceil(this.totalCnt/this.objectCnt);
	    	this.drawPaging();
	    },
	    setPaging: function(idx){
	    	this.pIdx = idx;
	    	this.fnc(this.pIdx, this.objectCnt);

	    },
	    drawPaging: function(){
	    	var str ='<ul class="pagination">';
	    	str +='    <li class="page-item '+(this.pIdx > this.maxIdx?"":"disabled")+'"><a class="page-link" href="#" onclick="paging.goFirst(this)">&lt;&lt;</a></li>';
	    	str +='    <li class="page-item '+(this.pIdx != 1?"":"disabled")+'"><a class="page-link" href="#" onclick="paging.goPrev(this)">&lt;</a></li>';
			for(var i = 1+(Math.floor((this.pIdx-1)/this.maxIdx)*this.maxIdx) ; i <= this.maxIdx+(Math.floor((this.pIdx-1)/this.maxIdx)*this.maxIdx) ; i++){
				if(i <= this.toPageCnt){
					str +='    <li class="page-item '+(this.pIdx == i ? "active": "")+'"><a class="page-link" href="#" onclick="paging.setPaging('+i+')">'+i+'</a></li>';
				}
			}
			str +='    <li class="page-item '+(this.pIdx < this.toPageCnt?"":"disabled")+'"><a class="page-link" href="#" onclick="paging.goNext(this)">&gt;</a></li>';
			str +='    <li class="page-item '+(this.toPageCnt > this.pIdx?"":"disabled")+'"><a class="page-link" href="#" onclick="paging.goEnd(this)">&gt;&gt;</a></li>';
			str +='</ul>';
			$(this.div).html('');
	    	$(this.div).append(str);
	    },
	    goNext: function(obj){
			this.setPaging(Number($(obj).closest("ul").find(".active").find("a").text())+1);
	    },
	    goPrev: function(obj){
			this.setPaging(Number($(obj).closest("ul").find(".active").find("a").text())-1);
	    },
	    goEnd: function(obj){
	    	this.setPaging(this.toPageCnt);
	    },
	    goFirst: function(obj){
	    	this.setPaging(1);
	    }

	};
	function agGrideditClass(params, addClass){
		var pAddClass = (addClass =='undefined')? "" : addClass;
    	if(typeof(params.colDef.editable) == 'function'){
    		return params.colDef.editable(params) == true ? "edited-bg "+pAddClass:" "+pAddClass;
    	} else {
    		return params.colDef.editable == true ? "edited-bg "+pAddClass:" "+pAddClass;
    	}
	}

	/**
	 * html용 이메일 검사
	 */
	function validEmail(obj){
		if(nullToString(obj.value) == ""){
	    	return true;
	    }
	    if(validEmailCheck(obj)==false){
	        alert('올바른 이메일 주소를 입력해주세요.')
	        obj.focus();
	        return false;
	    }
	    return true;
	}
	/**
	 * 이메일 유효성 검사
	 */
	function validEmailCheck(obj){
	    var pattern = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	    return (obj.value.match(pattern)!=null)
	}

	/**
	 * html용 전화번호 검사
	 */
	function validMobile(obj){
		if(nullToString(obj.value) == ""){
	    	return true;
	    }

		if(!validMobileCheck(obj.value)){
	    	alert('핸드폰 번호를 확인해주세요.');  // swal == alert대용
	    	obj.focus();
	    	return false;
		}
	    return true;
	}

	/**
	 * 전화번호 유효성 검사
	 */
	function validMobileCheck(val){
	    // 전화번호 유효성 검사
	    let mobile_pattern0 = /^[0-9]{3}-[0-9]{3,4}-[0-9]{4}/;
	    let mobile_pattern1 = /^[0-9]{3}[0-9]{3,4}[0-9]{4}/;
	    var p = /^010/;
	    if(!mobile_pattern0.test(val) &&!mobile_pattern1.test(val)) {
	        return false;
	    }
		if(!p.test(val)){
	        return false;
        }
	    return true;
	}
	function maxLengthCheck(object){
	    if (object.value.length > object.maxLength){
	      //object.maxLength : 매게변수 오브젝트의 maxlength 속성 값입니다.
	      object.value = object.value.slice(0, object.maxLength);
	    }
	}

	function getCookie(name) {
		  let matches = document.cookie.match(new RegExp(
		    "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
		  ));
		  return matches ? decodeURIComponent(matches[1]) : undefined;
	}

