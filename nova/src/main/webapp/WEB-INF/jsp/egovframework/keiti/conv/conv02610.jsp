<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>한국환경사업기술원 <spring:message code="comCmm.unitContent.1" /></title>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 페이지 로드 시 데이터를 로드하는 함수 호출
    conv02601();
});

// 데이터 로드 함수
function conv02601() {
    axios.get('/api/conv/conv02601.do')
    .then(function(response) {
        // response.data가 Map<String, Object> 형태로 반환됩니다.
        var data = response.data.resultList;

        // 받은 데이터에 따라 각 요소의 내용을 업데이트합니다.
        data.forEach(function(item) {
            if (item.actTp === '01') {
            	document.getElementById('researchActNo').textContent = item.actNo ? item.actNo : '데이터 없음';
                document.getElementById('researchBnkNm').textContent = item.bnkNm ? item.bnkNm : '데이터 없음';
                document.getElementById('researchActNm').textContent = item.actNm ? item.actNm : '데이터 없음';
            } else if (item.actTp === '05') {
                document.getElementById('refundActNo').textContent = item.actNo ? item.actNo : '데이터 없음';
            } else if (item.actTp === '06') {
                document.getElementById('refundParentActNo').textContent = item.actNo ? item.actNo : '데이터 없음';
            }
        });

        // 세션에서 사업분류 값을 가져와서 해당 셀에 넣습니다.
        var refundAccountType = taskVo.bizNm;
        document.getElementById('refundAccountType').textContent = refundAccountType ? refundAccountType : '데이터 없음';

    })
    .catch(function(error) {
        console.error('Error fetching data:', error);
        // 에러가 발생한 경우 적절한 에러 처리를 합니다.
    });
}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopMenu.jsp" />
	<div class="keit-header-body innerwrap clearfix">
		<c:set var="taskNo" value="${sessionScope.taskVo}" />
		<p class="tit">계좌정보</p>
		<!-- 숨겨진 폼 -->
		<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopTaskCard.jsp" />

	    <h4 class="tit">연구비 수령 계좌</h4>
	    <table>
	        <colgroup>
	            <col style="width:20%">
	            <col style="width:30%">
	            <col style="width:20%">
	            <col style="width:30%">
	        </colgroup>
	        <tr>
	            <th>계좌번호</th>
	            <td id="researchActNo">데이터 없음</td>
	            <th>은행</th>
	            <td id="researchBnkNm">데이터 없음</td>
	        </tr>
	        <tr>
	            <th>예금주명</th>
	            <td id="researchActNm">데이터 없음</td>
	            <!-- <th>예금주 인증정보</th>
	            <td id="researchConFirm"></td> -->
	        </tr>
	    </table>

	    <h4 class="tit">정산환수금 반납계좌</h4>
	    <table>
	        <colgroup>
	            <col style="width:20%">
	            <col style="width:30%">
	            <col style="width:20%">
	            <col style="width:30%">
	        </colgroup>
	        <tr>
	            <th>가상계좌번호</th>
	            <td id="refundActNo">데이터 없음</td>
	            <th>사업분류</th>
	            <td id="refundAccountType">데이터 없음</td>
	        </tr>
	        <tr>
	            <th>모계좌번호</th>
	            <td id="refundParentActNo">데이터 없음</td>

	        </tr>
	    </table>

        <div class="rbtn">
		<a href="javascript:goSubPage('/conv/conv02410.do')" class="btn detail">전체보기</a>
		</div>
	</div>

</body>
</html>