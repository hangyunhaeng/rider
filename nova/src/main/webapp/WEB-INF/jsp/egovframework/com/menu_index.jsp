<!DOCTYPE html>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
 /**
  * @Class Name : EgovMainMenuIndex.jsp
  * @Description : MainMenuIndex Page
  * @Modification Information
  * @
  * @  수정일         수정자                   수정내용
  * @ -------    --------    ---------------------------
  * @ 2009.03.10    이용          최초 생성
  *
  *  @author 공통서비스 개발팀 이용
  *  @since 2009.03.10
  *  @version 1.0
  *  @see
  *  ?vStartP=<c:out value="${result.menuNo}"/> <c:out value="${result.chkURL}"/>
  */

%>

<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Menu Index frame</title>
<style>
	body, html {	margin: 0;	padding: 0;	height: 100%;}
	.container {	display: flex;	flex-direction: column;	height: 100vh;}
	.header {	height: 122px;	flex: 0 0 122px;}
	.main {	display: flex;	flex: 1;}
	.left {	width: 273px;	flex: 0 0 273px;}
	.right {	flex: 1;}
	.footer {	height: 50px;	flex: 0 0 50px;}
	iframe {	width: 100%;	height: 100%;	border: none;}
</style>
</head>

    <div class="container">
        <div class="header">
            <iframe src="<c:url value='/sym/mnu/mpm/EgovMainMenuHead.do' />" name="main_top"></iframe>
        </div>
        <div class="main">
            <div class="left">
                <iframe src="<c:url value='/sym/mnu/mpm/EgovMainMenuLeft.do' />?vStartP=<c:out value='${resultVO.menuNo}' />" name="main_left"></iframe>
            </div>
            <div class="right">
                <iframe src="<c:url value='/sym/mnu/mpm/EgovMainMenuRight.do' />?vStartP=<c:out value='${resultVO.menuNo}' />" name="main_right"></iframe>
            </div>
        </div>
        <div class="footer">
            <iframe src="<c:url value='/EgovPageLink.do' />?linkIndex=2" name="main_bottom"></iframe>
        </div>
    </div>
</html>
