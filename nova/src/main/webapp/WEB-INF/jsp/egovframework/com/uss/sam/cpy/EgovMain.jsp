<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%--
  Class Name : EgovMain.jsp
  Description : 개별 배포 페이지 메인
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2009.05.15    장동한          최초 생성

    author   : 공통서비스 개발팀 장동한
    since    : 2009.05.15

--%>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>개별배포메인 페이지</title>
<style>
body, html {    margin: 0;    padding: 0;    height: 100%;    display: flex;}
.left {    width: 130px;    border-right: 1px solid #000;    box-sizing: border-box;    height: 100%;    overflow: hidden; }
.content {    flex: 1;    box-sizing: border-box;    height: 100%;    overflow: hidden; }
iframe {    width: 100%;    border: none;}
</style>
</head>
<body>
    <div class="left">
        <iframe name="left" src="<c:url value='/uss/sam/cpy/EgovLeft.do' />" title="개별배포페이지메뉴"></iframe>
    </div>
    <div class="content">
        <iframe name="content" src="<c:url value='/uss/sam/cpy/CpyrhtPrtcPolicyListInqire.do' />" title="개별배포메인페이지"></iframe>
    </div>
</body>
</html>
