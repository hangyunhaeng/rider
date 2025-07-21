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
	//https : Spring Security 활용: Spring Security와 같은 프레임워크를 사용하면 보다 정교한 접근 제어를 구현할 수 있습니다. @Secured 어노테이션이나 XML 설정을 통해 특정 URL에 대한 접근 권한을 설정할 수 있습니다.
	if(${isReal}){
		if (document.location.protocol == 'http:') {
		    document.location.href = document.location.href.replace('http:', 'https:');
		}
	}
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