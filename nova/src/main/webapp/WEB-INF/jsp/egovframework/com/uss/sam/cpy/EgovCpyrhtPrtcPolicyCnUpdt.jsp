<%
 /**
  * @Class Name : EgovCpyrhtPrtcPolicyCnUpdt.jsp
  * @Description : EgovCpyrhtPrtcPolicyCnUpdt 화면
  * @Modification Information
  * @
  * @  수정일             수정자                   수정내용
  * @ -------    --------    ---------------------------
  * @ 2009.02.01   박정규              최초 생성
  * @ 2018.09.03   이정은              공통컴포넌트 3.8 개선 
  *
  *  @author 공통서비스팀
  *  @since 2009.02.01
  *  @version 1.0
  *  @see
  *
  */
%>

<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<title><spring:message code="ussSamCpy.cpyrhtPrtcPolicyCnUpdt.cpyrhtPrtcPolicyCnUpdt"/></title><!-- 저작권보호정책 수정 -->
<link href="<c:url value="/css/egovframework/com/com.css"/>" rel="stylesheet" type="text/css">
<link href="<c:url value="/css/egovframework/com/button.css"/>" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="cpyrhtPrtcPolicyVO" staticJavascript="false" xhtml="true" cdata="false"/>

<script type="text/javaScript">

/* ********************************************************
 * 초기화
 ******************************************************** */
function fn_egov_initl_cpyrhtprtcpolicycn(){

	// 첫 입력란에 포커스..
	cpyrhtPrtcPolicyVO.cpyrhtPrtcPolicyCn.focus();

}

/* ********************************************************
 * 저장처리화면
 ******************************************************** */
function fn_egov_updt_cpyrhtprtcpolicycn(form, cpyrhtId){

	// 서버사이드 테스트용
	/*
		form.action = "<c:url value='/uss/sam/cpy/CpyrhtPrtcPolicyCnUpdt.do'/>";
		form.submit();
		return;
	*/

	if (!validateCpyrhtPrtcPolicyVO(form)) {

		return;

	} else {

		form.cpyrhtId.value = cpyrhtId;
		form.action = "<c:url value='/uss/sam/cpy/CpyrhtPrtcPolicyCnUpdt.do'/>";
		form.submit();

	}

}

/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_inqire_cpyrhtprtcpolicylist() {

	cpyrhtPrtcPolicyVO.action = "<c:url value='/uss/sam/cpy/CpyrhtPrtcPolicyListInqire.do'/>";
	cpyrhtPrtcPolicyVO.submit();

}


</script>
</head>
<body onLoad="fn_egov_initl_cpyrhtprtcpolicycn();">

<form:form modelAttribute="cpyrhtPrtcPolicyVO" action="${pageContext.request.contextPath}/uss/sam/cpy/CpyrhtPrtcPolicyCnUpdt.do" method="post">

<div class="wTableFrm">
	<!-- 타이틀 -->
	<h2><spring:message code="ussSamCpy.cpyrhtPrtcPolicyCnUpdt.cpyrhtPrtcPolicyCnUpdt"/></h2><!-- 저작권보호정책내용 수정 -->

	<!-- 등록폼 -->
	<table class="wTable">
		<colgroup>
			<col style="width:21%" />
			<col style="" />
		</colgroup>
		<tr>
			<th><spring:message code="ussSamCpy.cpyrhtPrtcPolicyCnUpdt.cpyrhtPrtcPolicyCn"/> <span class="pilsu">*</span></th><!-- 저작권보호정책내용 -->
			<td class="left">
				<c:set var="cpyrhtPrtcPoliCn"><spring:message code="ussSamCpy.cpyrhtPrtcPolicyCnUpdt.cpyrhtPrtcPolicyCn"/></c:set>
			    <form:textarea path="cpyrhtPrtcPolicyCn" cols="70" rows="20" cssClass="txaClass" title="${cpyrhtPrtcPoliCn}" cssStyle="height:300px" />
      			<div><form:errors path="cpyrhtPrtcPolicyCn"/></div>
			</td>
		</tr>
	</table>

	<!-- 하단 버튼 -->
	<div class="btn">
		<input class="s_submit" type="submit" value='<spring:message code="button.update" />' onclick="fn_egov_updt_cpyrhtprtcpolicycn(document.forms[0],'<c:out value="${result.cpyrhtId}"/>'); return false;" />
		<span class="btn_s"><a href="<c:url value='/uss/sam/cpy/CpyrhtPrtcPolicyListInqire.do'/>" onclick="fn_egov_inqire_cpyrhtprtcpolicylist(); return false;"><spring:message code="button.list" /></a></span>
	</div>
	<div style="clear:both;"></div>
</div>

<input name="cpyrhtId" type="hidden" value="">

</form:form>

</body>
</html>
