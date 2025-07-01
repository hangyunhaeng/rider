<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script>
	// 협약과제목록 팝업창 띄우기
	function comm00820() {
		var form = document.formtask;
		window.open('','comm00820','height=750,width=950,top=50,left=50,scrollbars=no,menubar=no,resizable=yes,location=no');
		form.target = "comm00820";
		form.action = "/comm/comm00820.do";
        form.submit();
	}

	// 팝업창 닫힌 이후 화면 Reloading
	function pop00820End(popVal) {
		var form = document.formtask;
	    form.taskNo.value = popVal;
	    form.target = '_self';
		form.action = ' <c:out value="${requestURI}" />';
		form.submit();
	}

	// 과제정보창 설정
	function taskSet() {
		var ExpDate = new Date();
        ExpDate.setTime(ExpDate.getTime() + 1000*60*60*24);
        if($("#BT").hasClass('open')){
			delCookie("task_toggle");
		} else{
			setCookie("task_toggle","open",ExpDate);
		}
		$("#BT").parents('.slide_box').find('.viewbox').slideToggle(300);
	    $("#BT").toggleClass('open');


	}

	// 쿠키 셋팅
	function setCookie (name, value, expiredays) {
		//하루동안 보이지 않도록 설정
		expires = new Date();
		expires.setDate( expires.getDate() + expiredays );
		document.cookie = name + "=" + escape (value) + "; expires=" + expires.toGMTString() + "; path=/;";
	}

	// 쿠키 삭제
	function delCookie (name) {
		var expires = new Date();
		expires.setDate( expires.getDate()-1 );
		document.cookie = name + "=" + "; expires=" + expires.toGMTString() + "; path=/;";

	}

	// Toggle 오픈
	function toggleOpen() {
		$("#BT").parents('.slide_box').find('.viewbox').slideToggle(0);
	    $("#BT").toggleClass('open');
	}

	if(getCookie("task_toggle") == "open") {
		addAttachEvent(window, "load", toggleOpen);
	}

	// 날짜 형식을 변환하는 함수
	function formatDate(dateStr) {
	    if (!dateStr || dateStr.length !== 8) {
	        return dateStr; // 유효하지 않은 날짜 형식이면 그대로 반환
	    }
	    const year = dateStr.substring(0, 4);
	    const month = dateStr.substring(4, 6);
	    const day = dateStr.substring(6, 8);
	    return year+'-'+month+'-'+day;
	}

	// 변환된 값을 HTML 요소에 설정하는 함수
	function setTaskInfo(taskVo) {
	    const taskStValue = taskStatusFormatter(taskVo.taskSt);
	    const execTpValue = execTpFormatter(taskVo.execTp);
	    const taskTpValue = taskTpFormatter(taskVo.taskTp);
	    const startdt = formatDate(taskVo.curyrStartdt);
	    const enddt = formatDate(taskVo.curyrEnddt);

	    document.getElementById('taskNoInfoCard').innerHTML = '협약과제번호 : ' + taskNoFormatter(taskVo.taskNo) + ' [' + taskStValue + '] <span style="color: red;">[' + execTpValue + ']</span>';
	    document.getElementById('taskNmCard').innerHTML = '과제명 : ' + taskVo.taskNm;
	    document.getElementById('instNmCard').innerHTML = '연구기관 :<span style="color: blue;">[' + taskTpValue + '] </span> ' + taskVo.instNm + ' / ' + taskVo.mnrNm;
	    document.getElementById('curyrPeriodCard').innerHTML = '당해년도기간 : ' + startdt + ' ~ ' + enddt;
	    document.getElementById('stlAgcCard').innerHTML = '회계법인 : ' + taskVo.stlAgc;
	    document.getElementById('stlPhoneCard').innerHTML = '연락처 : ' + taskVo.stlPhone;
	    document.getElementById('stlEmailCard').innerHTML = '이메일 : ' + taskVo.stlEmail;
	    document.getElementById('taskTotCard').innerHTML = '총연구비 : ' + currencyFormatter(taskVo.totBdg);

	}
	// TASK정보
	const taskVo = {
		taskNo: '${taskVo.taskNo}',
		taskSt: '${taskVo.taskSt}',
		execTp: '${taskVo.execTp}',
		taskNm: '${taskVo.taskNm}',
		taskTp: '${taskVo.taskTp}',
		instNm: '${taskVo.instNm}',
		mnrNm: '${taskVo.mnrNm}',
		curyrStartdt: '${taskVo.curyrStartdt}',
		curyrEnddt: '${taskVo.curyrEnddt}',
		totBdg: '${taskVo.totBdg}',
		stlAgc: '${taskVo.stlAgc}',
		stlPhone: '${taskVo.stlPhone}',
		stlEmail: '${taskVo.stlEmail}',
		bizNm: '${taskVo.bizNm}'
	};
	// 페이지 로드 시 변환된 날짜를 설정
	document.addEventListener('DOMContentLoaded', () => {
		setTaskInfo(taskVo);
	});

</script>
<div>
	<form method='post' name='formtask'>
		<input type="hidden" name="taskNo" />

		<article class="slide_box">
			<div class="slide_wrap" >
				<dl>
					<dt>과제명</dt>
					<dd class="txt" title="${taskVo.taskNm}">
						${taskVo.taskNm}
					</dd>
				</dl>
				<div class="info">

				    <a href="javascript:comm00820();">협약과제변경</a> |

				    <a href="javascript:taskSet();">과제정보 열기</a>
				    <button type="button" id="BT" class="btn--toggle-summary ir" title="과제 정보 열고 닫기" onclick="javascript:taskSet();">과제 정보 열고 닫기</button>
				</div>
			</div><!--//slide_wrap -->
			<div class="viewbox">
				<ul>
					<c:set var="taskNo" value="${sessionScope.taskVo}" />
					<li id="taskNoInfoCard">협약과제번호 : </li>
					<li id="taskNmCard">과제명 : </li>
					<li id="instNmCard">연구기관 : </li>
					<li id="curyrPeriodCard">당해년도기간 : </li>
					<li id="taskTotCard">총연구비 : </li>
				</ul>
				<ul>
					<li id="stlAgcCard">회계법인 : </li>
					<li id="stlPhoneCard">연락처 : </li>
					<li id="stlEmailCard">이메일 : </li>
				</ul>
				<!-- <a href="#none" class="btn detail">과제상세보기</a> 버튼 추가  -->
			</div>
		</article><!--//slide_box -->
	</form>
</div>