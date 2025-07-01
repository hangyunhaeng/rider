<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>장동한 개발 현황</title></head>


<body style="margin: 0; padding: 0; height: 100vh; display: flex;">
    <div style="width: 130px; border-right: 1px solid #000; box-sizing: border-box; height: 100vh; overflow: hidden;">
        <iframe name="left" src="<c:url value='/uss/olp/mgt/EgovMeetingManageLeft.do' />" title="개별배포페이지메뉴" style="width: 100%; height: 100%; border: none;"></iframe>
    </div>
    <div style="flex: 1; box-sizing: border-box; height: 100vh; overflow: hidden;">
        <iframe name="content" src="<c:url value='/uss/olp/mgt/EgovMeetingManageList.do' />" title="개별배포메인페이지" style="width: 100%; height: 100%; border: none;"></iframe>
    </div>
</body>


</html>
