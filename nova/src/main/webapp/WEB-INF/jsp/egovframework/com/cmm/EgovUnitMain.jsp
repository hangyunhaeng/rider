<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>한국환경산업기술원</title>

</head>
<style>
body, html {    margin: 0;    padding: 0;    height: 100%;    display: flex;    flex-direction: column;    overflow:hidden;}
.header {    height: 27px;    flex: 0 0 27px;}
.content {    flex: 1;    display: flex;}
.footer {    height: 45px;    flex: 0 0 45px;}
iframe {    width: 100%;    border: none;}
</style>
<body>
	<div class="header">
	        <iframe name="_top" src="${pageContext.request.contextPath}/EgovTop.do" title="헤더"></iframe>
	</div>
	<div class="content">
	    <!-- 만약 왼쪽 메뉴를 추가해야 한다면, 이 부분에 추가하면 됩니다.
	    <iframe name="_left" src="${pageContext.request.contextPath}/EgovLeft.do" title="메뉴페이지" scrolling="yes"></iframe>
	    -->
	    <iframe name="_content" src="${pageContext.request.contextPath}/EgovContent.do" title="메인페이지"></iframe>
	</div>

	<!-- <div class="footer">
	    <iframe name="_bottom" src="${pageContext.request.contextPath}/EgovBottom.do" title="푸터"></iframe>
	</div>
	 -->
</body>
</html>