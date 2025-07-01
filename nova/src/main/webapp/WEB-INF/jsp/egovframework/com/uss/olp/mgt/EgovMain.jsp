<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>개별배포메인 페이지</title>
</head>
<body style="margin: 0; padding: 0; height: 100vh; display: flex;">
    <div style="width: 130px; border-right: 1px solid #000; box-sizing: border-box; height: 100vh; overflow: hidden;">
        <iframe name="left" src="<c:url value='/uss/olp/mgt/EgovLeft.do' />" title="개별배포페이지메뉴" style="width: 100%; height: 100%; border: none;"></iframe>
    </div>
    <div style="flex: 1; box-sizing: border-box; height: 100vh; overflow: hidden;">
        <iframe name="content" src="<c:url value='/uss/olp/mgt/EgovMeetingManageList.do' />" title="개별배포메인페이지" style="width: 100%; height: 100%; border: none;"></iframe>
    </div>
</body>
</html>
