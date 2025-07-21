<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>RIDER BANK</title>

</head>
<style>
body, html {    margin: 0;    padding: 0;    height: 100%;    display: flex;    flex-direction: column;    overflow:hidden;}
.header {    height: 27px;    flex: 0 0 27px;}
.content {    flex: 1;    display: flex;}
.footer {    height: 45px;    flex: 0 0 45px;}
iframe {    width: 100%;    border: none;}
</style>
<script language="javascript">
    function ifmHeight(){
    }
</script>

<body>
	<div class="content">
	    <iframe id="ifm" onLoad="ifmHeight();" name="_content" src="${pageContext.request.contextPath}/com/com0002.do" title="메인페이지"></iframe>
		</div>
	</div>

</body>
</html>