<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : EgovUnitTop.jsp
  * @Description : 상단 헤더 영역
  * @Modification Information
  *
  * @수정일               수정자            수정내용
  *  ----------   --------   ---------------------------
  *  2020.06.23   신용호            세션만료시간 보여주기
  *
  *  @author 공통서비스 개발팀 신용호
  *  @since 2009.03.03
  *  @version 1.0
  *  @see
  *
  *  Copyright (C) 2009 by MOPAS  All right reserved.
  */
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link type="text/css" rel="stylesheet"	href="<c:url value='/css/egovframework/com/cmm/main.css' />">
<link type="text/css" rel="stylesheet"	href="<c:url value="/css/egovframework/com/com.css"/>">
<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.default.css' /> ">
<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.style.css' />">
<script type="text/javascript"	src="<c:url value='/web2/js/jquery-1.11.2.min.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/function.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/keit.jquery.ui.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/kaia.pbCommon.js' />"></script>
<title>사업비관리시스템</title>
<script type="text/javascript"
	src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>"></script>
<%

	String egovLatestServerTime = "";
	String egovExpireSessionTime = "";
	// 쿠키값 가져오기
	Cookie[] cookies = request.getCookies() ;
	if(cookies != null){
		for(int i=0; i < cookies.length; i++){
			Cookie c = cookies[i] ;
			// 저장된 쿠키 이름을 가져온다
			String cName = c.getName();
			// 쿠키값을 가져온다
			String cValue = c.getValue() ;
			if ("egovLatestServerTime".equals(cName)) {
				System.out.println("===>>> egovLatestServerTime = "+cName+":"+cValue);
				egovLatestServerTime = cValue;
			}
			if ("egovExpireSessionTime".equals(cName)) {
				System.out.println("===>>> egovExpireSessionTime = "+cName+":"+cValue);
				egovExpireSessionTime = cValue;
			}
		}
	}

%>
<script type="text/javaScript" defer="defer">
	function getCookie(cname) {
 	  var name = cname + "=";
 	  var decodedCookie = decodeURIComponent(document.cookie);
 	  var ca = decodedCookie.split(';');
 	  for(var i = 0; i <ca.length; i++) {
 	    var c = ca[i];
 	    while (c.charAt(0) == ' ') {
 	      c = c.substring(1);
 	    }
 	    if (c.indexOf(name) == 0) {
 	      return c.substring(name.length, c.length);
 	    }
 	  }
 	  return "";
 	}

  	function pad(n, width) {
  	  n = n + '';
  	  return n.length >= width ? n : new Array(width - n.length + 1).join('0') + n;
  	}

	var objLeftTime;
	var objClickInfo;
	var latestTime;
	var expireTime;
	var timeInterval = 1000; // 1초 간격 호출
	var firstLocalTime = 0;
	var elapsedLocalTime = 0;
	var stateExpiredTime = false;
	var logoutUrl = "<c:url value='/uat/uia/actionLogout.do'/>";
	var timer;

	function init() {
		objLeftTime = document.getElementById("leftTimeInfo");

		if (objLeftTime == null) {
			console.log("'leftTimeInfo' ID is not exist!");
			return;
		}
		objClickInfo = document.getElementById("clickInfo");
		//console.log(objLeftTime.textContent);

		latestTime = <%=egovLatestServerTime%>; //getCookie("egovLatestServerTime")
		expireTime = <%=egovExpireSessionTime%>; //getCookie("egovExpireSessionTime");
		console.log("latestServerTime = "+latestTime);
		console.log("expireSessionTime = "+expireTime);

		elapsedTime = 0;
		firstLocalTime = (new Date()).getTime();
		showRemaining();

		timer = setInterval(showRemaining, timeInterval); // 1초 간격 호출
	}

	function showRemaining() {
		elapsedLocalTime = (new Date()).getTime() - firstLocalTime;

		var timeRemaining = expireTime - latestTime - elapsedLocalTime;
		if ( timeRemaining < timeInterval ) {
			clearInterval(timer);
			objLeftTime.innerHTML = "00:00:00";
			objClickInfo.text = '<spring:message code="comCmm.top.expiredSessionTime"/>'; //시간만료
			stateExpiredTime = true;
			alert('<spring:message code="comCmm.top.expireSessionTimeInfo"/>');//로그인 세션시간이 만료 되었습니다.
			// reload content main page
			$("#sessionInfo").hide();

			parent.frames["_content"].location.href = logoutUrl;
			//parent.frames["_content"].location.reload();

			return;
		}
		var timeHour = Math.floor(timeRemaining/1000/60 / 60);
		var timeMin = Math.floor((timeRemaining/1000/60) % 60);
		var timeSec = Math.floor((timeRemaining/1000) % 60);
		//objLeftTime.textContent = pad(timeHour,2) +":"+ pad(timeMin,2) +":"+ pad(timeSec,2);
		//objLeftTime.outerText = pad(timeHour,2) +":"+ pad(timeMin,2) +":"+ pad(timeSec,2);
		objLeftTime.innerHTML = pad(timeHour,2) +":"+ pad(timeMin,2) +":"+ pad(timeSec,2);
		//console.log("call showRemaining() = "+objLeftTime.innerHTML);
	}

	function reqTimeAjax() {

	  	if (stateExpiredTime==true) {
	  		alert('<spring:message code="comCmm.top.cantIncSessionTime"/>');//시간을 연장할수 없습니다.
	  		return;
	  	}

		$.ajax({
		    url:'${pageContext.request.contextPath}/uat/uia/refreshSessionTimeout.do', //request 보낼 서버의 경로
		    type:'get', // 메소드(get, post, put 등)
		    data:{}, //보낼 데이터
		    success: function(data) {
		        //서버로부터 정상적으로 응답이 왔을 때 실행
	        	latestTime = getCookie("egovLatestServerTime");
	        	expireTime = getCookie("egovExpireSessionTime");
	        	console.log("latestServerTime = "+latestTime);
	        	console.log("expireSessionTime = "+expireTime);
	        	init();
		        //alert("정상수신 , data = "+data);
		    },
		    error: function(err) {
		    	alert("err : "+err);
		        //서버로부터 응답이 정상적으로 처리되지 못햇을 때 실행
		    	//alert("오류발생 , error="+err.state());
		    }
		});
		return false;
	}

	function logout() {
		$("#sessionInfo").hide();

		parent.frames["_content"].location.href = logoutUrl;
	}

	function goinfo() {
		var form = document.menuTop1;
		window.open('','EgovMberPasswordUpdtView','height=390,width=760,top=50,left=50,scrollbars=no,menubar=no,resizable=yes,location=no');
		form.target = "EgovMberPasswordUpdtView";
		form.action = "/uss/umt/EgovMberPasswordUpdtView.do";
        form.submit();
	}

</script>
</head>
<body onload="init()" class='no-scroll'>
	<div id="wrap">
		<form name='menuTop1' method='post'>
			<input type="hidden" name="userTyForPassword" value="USR01" />
			<input type="hidden" name="mberId" value="<c:out value='${loginVO.id}'/>" />
			<input type="hidden" name="uniqId" value="<c:out value='${loginVO.uniqId}'/>" />
			<input type="hidden" name="userTy" value="USR01" />
			<header class="keit-header">
				<div class="keit-header-upper">
						<div class="innerwrap clearfix txtr">
							<c:if test="${loginVO != null}">
								<span class="keit-header-user">
								<a onclick="javascript:goinfo('${loginVO.id}');" style='color:#FFF;'>${loginVO.name}(${loginVO.id})</a>

								</span>
							</c:if>
							<div class="keit-header-upper-links fr">
								<c:if test="${loginVO == null}">
									<a href="javascript:logout()">로그인</a>
								</c:if>
								<c:if test="${loginVO != null}">
									<a href="#" onclick="logout();return false;">로그아웃</a>
									<a href="#" onclick="reqTimeAjax();return false;">시간연장</a>
									<span style="display: none;">세션시간2</span>
									<span>세션시간 - <span id="leftTimeInfo">00:00:00</span></span>
								</c:if>
							</div>
					</div>
				</div>
			</header>
			<!-- //header -->
		</form>
	</div>
</body>
</html>