<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : EgovLoginUsr.jsp
  * @Description : Login 인증 화면
  * @Modification Information
  *
  * @수정일               수정자            수정내용
  *  ----------   --------   ---------------------------
  *  2024.07.22   조경규            최초 생성
  *
  *  @author 조경규
  *  @since 2024.07.22
  *  @version 1.0
  *  @see
  *
  *  Copyright (C) 2009 by MOPAS  All right reserved.
  */
%>

<!DOCTYPE html>
<html>
<head>
<title><spring:message code="comUatUia.title" /></title><!-- 로그인 -->
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/com/com.css' />">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/com/uat/uia/login.css' />">
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/showModalDialog.js'/>" ></script>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>" ></script>
<link type="text/css" rel="stylesheet" href="<c:url value='/web2/css/keit.default.css' /> ">
<link type="text/css" rel="stylesheet" href="<c:url value='/web2/css/keit.style.css' />" >
<script type="text/javascript" src="<c:url value='/web2/js/jquery-1.11.2.min.js' />" ></script>
<script type="text/javascript" src="<c:url value='/web2/js/function.js' />"></script>
<script type="text/javascript" src="<c:url value='/web2/js/keit.jquery.ui.js' />" ></script>
<script type="text/javascript" src="<c:url value='/web2/js/kaia.pbCommon.js' />" ></script>
<script type="text/javaScript">
function actionLogin() {

	if (document.loginForm.id.value =="") {
        alert("<spring:message code="comUatUia.validate.idCheck" />"); <%-- 아이디를 입력하세요 --%>
    } else if (document.loginForm.password.value =="") {
        alert("<spring:message code="comUatUia.validate.passCheck" />"); <%-- 비밀번호를 입력하세요 --%>
    } else {
    	alert('111');
        document.loginForm.action="<c:url value='/uat/uia/actionLogin.do'/>";
        document.loginForm.submit();
    }
}


function goFindId() {
    document.loginForm.action="<c:url value='/uat/uia/egovIdPasswordSearch.do'/>";
    document.loginForm.submit();
}

function goRegiUsr() {
	// 일반회권관리 등록
	document.loginForm.action="<c:url value='/uss/umt/EgovMberSbscrbView.do'/>";
    document.loginForm.submit();
    return;
}

function fnInit() {
    <c:if test="${not empty fn:trim(loginMessage) &&  loginMessage ne ''}">
    alert("loginMessage:<c:out value='${loginMessage}'/>");
    </c:if>

    if (parent.frames["_top"] == undefined)
    	console.log("'_top' frame is not exist!");
    parent.frames["_top"].location.reload();
}


</script>
</head>
<body onLoad="fnInit();" style="overflow: hidden;height:100%;">

	<!-- javascript warning tag  -->
	<noscript class="noScriptTitle">
		<spring:message code="common.noScriptTitle.msg" />
	</noscript>

	<form name="loginForm" id="loginForm"
		action="<c:url value='/uat/uia/actionLogin.do'/>" method="post">

		<input type="hidden" id="message" name="message"
			value="<c:out value='${message}'/>"> <input name="userSe"
			type="hidden" value="GNR" /> <input name="j_username" type="hidden" />
		<!-- newmain cont -->
		<div class="keit_maincont">
			<div class="keit_mainimg">
				<div class="keit_mcont">
					<table class="keit_mtable">
						<tr>
							<td style="height: 220px">
								<div class="title">
									<img
										src="${pageContext.request.contextPath}/web2/images/main_title.png"
										alt="title">
								</div>
							</td>
						</tr>
						<tr>
							<td class="blanky">
								<table class="keit_mtable">

								</table>
							</td>
						</tr>
						<tr >
							<td class="blanky" ></td>
						</tr>
						<tr>
							<td class="blanky" ></td>
						</tr>

						<tr>
							<td>
								<div class="login" style="">
									<!-- <ul class="loginselect"> <li><a href="#" class="login_id">아이디 로그인</a></li> </ul> -->
									<div id="lf1">
										<div class="loginform">
											<span class="id">
												<input type="text" id="Id" name="id" placeholder="아이디" onKeyDown="javascript:if(event.keyCode==13){actionLogin();}" autocomplete="off" />
											</span>
											<span class="pw">
												<input type="password" id="Pin"name="password" placeholder="비밀번호" onKeyDown="javascript:if(event.keyCode==13){actionLogin();}" autocomplete="off" />
											</span> <a href="#none" onclick="javascript:actionLogin();"
												class="keitbtn">로그인</a>
										</div>
										<ul class="loginmenu">
											<li><a href="javascript:goRegiUsr();">회원가입</a></li>
											<!-- 회원가입  -->
											<li><a href="javascript:goFindId();">아이디/비밀번호 찾기</a></li>
											<!-- 아이디/비밀번호 찾기 -->
										</ul>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td style="height: 100px"></td>
						</tr>
					</table>
				</div>
			</div>
		</div>


	</form>

	<!-- 팝업 폼 -->
	<form name="defaultForm" action ="" method="post" target="_blank">
	<div style="visibility:hidden;display:none;">
	<input name="iptSubmit3" type="submit" value="<spring:message code="comUatUia.loginForm.submit"/>" title="<spring:message code="comUatUia.loginForm.submit"/>">
	</div>
	</form>

</body>
</html>
