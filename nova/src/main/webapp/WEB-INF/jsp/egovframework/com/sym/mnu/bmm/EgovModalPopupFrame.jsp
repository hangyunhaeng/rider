<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : EgovModalPopupFrame.jsp
  * @Description : 모달 팝업을 위한 외부 프레임
  * @Modification Information
  * @
  * @  수정일      수정자            수정내용
  * @ -------        --------    ---------------------------
  * @ 2009.04.06   이삼섭          최초 생성
  * @ 2020.07.07   윤주호          43L <c:out> 중복 따옴표 문제 수정
  *
  *  @author 공통서비스 개발팀 이삼섭
  *  @since 2009.04.06
  *  @version 1.0
  *
  */
%>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/showModalDialogCallee.js'/>" ></script>
<script type="text/javascript">
	function fn_egov_returnValue(retVal){
		setReturnValue(retVal);

		window.returnValue = retVal;
		window.close();
	}

	function closeWindow(){
		window.close();
	}
</script>
<title>선택 목록</title>
</head>
<body>
	<iframe id="popupFrame" src="<c:url value='${fn:escapeXml(requestUrl)}' />" width="${width}" height="${height}" title="선택목록팝업창호출"></iframe>
</body>
</html>
