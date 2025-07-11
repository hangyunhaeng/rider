<%--
  Class Name : EgovBatchResultDetail.jsp
  Description : 배치결과 상세조회 페이지
  Modification Information
 
       수정일                 수정자              수정내용
    ----------    --------    ---------------------------
    2010.08.31    김진만              최초 생성
    2018.09.04    신용호              공통컴포넌트 3.8 개선
 
    author   : 공통서비스 개발팀 김진만
    since    : 2010.08.31
   
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
//  배치결과의 executBeginTime, executEndTime의 화면 표시용 임시 변수 .... 
%>
<c:set var="tempDate" value=""/>
<%pageContext.setAttribute("crlf", "\r\n"); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" >
<title><spring:message code="comSymBat.batchResultDetail.title"/></title><!-- 배치결과 상세조회 -->
<link href="<c:url value="/css/egovframework/com/com.css"/>" rel="stylesheet" type="text/css">
<link href="<c:url value="/css/egovframework/com/button.css"/>" rel="stylesheet" type="text/css">
<script type="text/javaScript">


/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list(){
    var varForm = document.getElementById("batchResultForm");
    varForm.action = "<c:url value='/sym/bat/getBatchResultList.do' />";
    varForm.submit()
}
/* ********************************************************
 * 삭제 처리
 ******************************************************** */
 function fn_egov_delete(){
        var vForm = document.batchResultForm;
        if(confirm("<spring:message code='common.delete.msg' />")){
            vForm.action = "<c:url value='/sym/bat/deleteBatchResult.do' />";
            vForm.submit();
        }
}
</script>
</head>

<body >

<noscript class="noScriptTitle"><spring:message code="common.noScriptTitle.msg" /></noscript><!-- 자바스크립트를 지원하지 않는 브라우저에서는 일부 기능을 사용하실 수 없습니다. -->

<div class="wTableFrm">
	<!-- 타이틀 -->
	<h2><spring:message code="comSymBat.batchResultDetail.pageTop.title"/></h2><!-- 배치결과 상세조회 -->

<form name="batchResultForm"  id="batchResultForm" action="<c:url value='/sym/bat/getBatchResult.do'/>" method="post">
    <input name="batchResultId" type="hidden" value="<c:out value='${resultInfo.batchResultId}'/>"/>
    <!-- 검색조건 유지 -->
    <input type="hidden" name="searchCondition" value="<c:out value='${searchVO.searchCondition}'/>"/>
    <input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
    <input type="hidden" name="searchKeywordFrom" value="<c:out value='${searchVO.searchKeywordFrom}'/>"/>
    <input type="hidden" name="searchKeywordTo" value="<c:out value='${searchVO.searchKeywordTo}'/>"/>
    <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}' default="1"/>"/>

	<!-- 등록폼 -->
	<table class="wTable">
		<colgroup>
			<col style="width:16%" />
			<col style="" />
		</colgroup>
		<tr>
			<th><spring:message code="comSymBat.batchResultDetail.batchResultId"/></th><!-- 배치결과ID -->
			<td class="left">
			    <c:out value="${resultInfo.batchResultId}" escapeXml="false" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="comSymBat.batchResultDetail.batchSchdulId"/></th><!-- 배치스케줄ID -->
			<td class="left">
			    <c:out value="${resultInfo.batchSchdulId}" escapeXml="false" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="comSymBat.batchResultDetail.batchOpertId"/></th><!-- 배치작업ID -->
			<td class="left">
			    <c:out value="${resultInfo.batchOpertId}" escapeXml="false" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="comSymBat.batchResultDetail.batchOpertNm"/></th><!-- 배치작업명 -->
			<td class="left">
			    <c:out value="${resultInfo.batchOpertNm}" escapeXml="false" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="comSymBat.batchResultDetail.batchProgrm"/></th><!-- 배치프로그램 -->
			<td class="left">
			    <c:out value="${resultInfo.batchProgrm}" escapeXml="false" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="comSymBat.batchResultDetail.paramtr"/></th><!-- 파라미터 -->
			<td class="left">
			    <c:out value="${resultInfo.paramtr}" escapeXml="false" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="comSymBat.batchResultDetail.sttusNm"/></th><!-- 상태 -->
			<td class="left">
			    <c:out value="${resultInfo.sttusNm}" escapeXml="false" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="comSymBat.batchResultDetail.errorInfo"/></th><!-- 에러정보 -->
			<td class="left">
			    <c:out value="${resultInfo.errorInfo}" escapeXml="false" />
			</td>
		</tr>
		<tr>
			<th><spring:message code="comSymBat.batchResultDetail.executBeginTime"/></th><!-- 실행시작시각 -->
			<td class="left">
			    <fmt:parseDate value="${resultInfo.executBeginTime}" pattern="yyyyMMddHHmmss" var="tempDate"/>
            	<fmt:formatDate value="${tempDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
			</td>
		</tr>
		<tr>
			<th><spring:message code="comSymBat.batchResultDetail.executEndTime"/></th><!-- 실행종료시각 -->
			<td class="left">
			    <fmt:parseDate value="${resultInfo.executEndTime}" pattern="yyyyMMddHHmmss" var="tempDate"/>
            	<fmt:formatDate value="${tempDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
			</td>
		</tr>
	</table>

	<!-- 하단 버튼 -->
	<div class="btn">
		<input class="s_submit" type="submit" value='<spring:message code="button.delete" />' onclick="fn_egov_delete(); return false;" /><!-- 삭제 -->
		<span class="btn_s"><a href="<c:url value='/sym/bat/getBatchResultList.do'></c:url>" onclick="fn_egov_list(); return false;"><spring:message code="button.list" /></a></span><!-- 목록 -->
	</div>
	<div style="clear:both;"></div>

</form>

</div>


</body>
</html>