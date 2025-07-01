<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="pageTitle"><spring:message code="comCmmErr.dataAccessFailure.code"/></c:set><!-- 데이터처리 에러 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title><spring:message code="title.html"/></title>
<link href="<c:url value='/css/egovframework/com/com.css' />" rel="stylesheet" type="text/css" />
<!-- Vendor CSS Files -->
<link href="<c:url value='/vendor/admin/bootstrap/css/bootstrap.min.css' />" rel="stylesheet">
<script src="<c:url value='/vendor/admin/bootstrap/js/bootstrap.min.js' />"></script>
<link href="<c:url value='/vendor/admin/bootstrap-icons/bootstrap-icons.css' />" rel="stylesheet">

<script>
function fncGoAfterErrorPage(){
    history.back(-2);
}
</script>
</head>
<body>
<div style="width: 100%; margin: 50px auto 50px;">
<%-- 	<p style="font-size: 18px; color: #000; margin-bottom: 10px; "><img src="<c:url value='/images/egovframework/com/cmm/er_logo.jpg' />" width="379" height="57" /></p> --%>
	<div style="border: ppx solid #666; padding: 20px;">

		<p style="color:red; margin-bottom: 8px; ">${pageTitle}<br /></p>

		<div class="boxType1" style="width: 86%;margin-left:7%;">
			<div class="box" style="height:170px;">
				<div class="error" style="padding:25px 0 25px 20px;">
					<p class="title"><spring:message code="comCmmErr.dataAccessFailure.title" /></p><!-- 데이터 처리 중 오류가 발생하였습니다! -->
					<p class="cont mb20">${pageTitle}<br /></p>
					<button class="btn btn-primary mb-2 mb-sm-0 mx-3 fs-9" onclick="fncGoAfterErrorPage();">이전 페이지</a></span>
				</div>
			</div>
		</div>
	</div>
</div>

</body>
</html>