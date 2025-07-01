
<%
/**
 * @Class Name : EgovOnlinePollPartcptnStatistics.jsp
 * @Description : 온라인POLL관리 통계 페이지
 * @Modification Information
 * @
 * @  수정일             수정자                   수정내용
 * @ -------    --------    ---------------------------
 * @ 2008.03.09	장동한		최초 생성
 *   2016.08.22 	장동한        표준프레임워크 v3.6 개선
 *
 *  @author 공통서비스 개발팀 장동한
 *  @since 2009.03.09
 *  @version 1.0
 *  @see
 *
 */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator"
	uri="http://www.springmodules.org/tags/commons-validator"%>
<c:set var="pageTitle">
	<spring:message code="comUssOlpOpp.title" />
</c:set>
<c:set var="ImgUrl" value="/images/egovframework/com/uss/olp/opp/" />
<%
pageContext.setAttribute("crlf", "\r\n");
%>
<!DOCTYPE html>
<html>
<head>
<title>${pageTitle}<spring:message
		code="comUssOlpOpp.statistics.title" /></title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet"
	href="<c:url value='/css/egovframework/com/com.css' />">
<link type="text/css" rel="stylesheet"
	href="<c:url value='/css/egovframework/com/uss/olp/opp/online_poll.css' />">
<script type="text/javaScript">
	/* ********************************************************
	 * 초기화
	 ******************************************************** */
	function fn_egov_init_OnlinePollPartcptnStatistics() {

	}
</script>
</head>
<body onLoad="fn_egov_init_OnlinePollPartcptnStatistics()">

</body>
</html>
