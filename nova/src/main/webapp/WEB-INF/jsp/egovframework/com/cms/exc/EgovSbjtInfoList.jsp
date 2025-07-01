<%
 /**
  * @Class Name : EgovAdressBookList.jsp
  * @Description : 등록한 주소록목록 조회
  * @Modification Information
  * @
  * @  수정일             수정자                   수정내용
  * @ -------    --------    ---------------------------
  * @ 2009.09.25   윤성록        최초 생성
  *   2016.08.16   장동한        표준프레임워크 v3.6 개선
  *   2016.12.13   최두영        JSP명 변경
  *  @author 공통서비스팀
  *  @since 2009.09.25
  *  @version 1.0
  *  @see
  *
  */
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="pageTitle"><spring:message code="comCopAdb.title"/></c:set>
<!DOCTYPE html>
<html>
<head>
<title>${pageTitle} <spring:message code="title.list" /></title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/com/com.css' />">
<link rel="stylesheet" href="/ag-grid/ag-grid.css">
<link rel="stylesheet" href="/ag-grid/ag-theme-alpine.css">
<script src="/ag-grid/ag-grid-community.noStyle.js"></script>
<script type="text/javascript">

</script>

</head>
<body>

<div class="board">
	<h1>${pageTitle} <spring:message code="title.list" /></h1>
	aaaaaaaaaaaaaa
	<!-- 검색영역 -->
	<form:form name="frm" action="${pageContext.request.contextPath}/cop/adb/selectAdbkList.do" method="post">
		<div class="search_box" title="<spring:message code="common.searchCondition.msg" />">
			<ul>
				<li>
				<select name="searchCnd" class="select" title="<spring:message code="title.searchCondition" /><spring:message code="input.cSelect" />"> <!-- 검색조건선택 -->
					<option value="" <c:if test="${searchVO.searchCnd == ''}">selected="selected"</c:if>><spring:message code="input.select" /></option><!-- 선택하세요 -->
					<option value="0" <c:if test="${searchVO.searchCnd == '0'}">selected="selected"</c:if> ><spring:message code="comCopAdb.searchCondition.searchCnd0" /></option><!-- 주소록명 -->
					<option value="1" <c:if test="${searchVO.searchCnd == '1'}">selected="selected"</c:if> ><spring:message code="comCopAdb.searchCondition.searchCnd1" /></option><!-- 공개범위 -->
					<option value="2" <c:if test="${searchVO.searchCnd == '2'}">selected="selected"</c:if> ><spring:message code="comCopAdb.searchCondition.searchCnd2" /></option><!-- 등록자 -->
			   </select>
				</li><!-- 검색조건선택 -->
				<!-- 검색키워드 및 조회버튼 -->
				<li>
					<input class="s_input" name="searchWrd" type="text"  size="35" title="<spring:message code="title.search" /> <spring:message code="input.input" />" value='<c:out value="${searchVO.searchWrd}"/>'  maxlength="155" >
					<input type="submit" class="s_btn" value="<spring:message code="button.inquire" />" title="<spring:message code="title.inquire" /> <spring:message code="input.button" />" onClick="fn_egov_search_adbkInfs();return false;"/>
					<span class="btn_b"><a href="<c:url value='/cop/adb/addAdbkInf.do'/>" onClick="javascript:fn_egov_addadbkInf();return false;"  title="<spring:message code="button.create" /> <spring:message code="input.button" />"><spring:message code="button.create" /></a></span>
				</li>
			</ul>
		</div>
	<input name="pageIndex" type="hidden" value="<c:out value='${searchVO.pageIndex}'/>">
	<input type="hidden" name="sbjtCd" value = "'<c:out value="${searchVO.sbjtCd}" />'" >
	</form:form>

	<!-- 목록영역 -->
		<table class="board_list" summary="<spring:message code="common.summary.list" arguments="${pageTitle}" />">
			<caption>${pageTitle} <spring:message code="title.list" /></caption>
			<colgroup>
				<col style="width: 9%;">
				<col style="width: ;">
				<col style="width: 20%;">


				<col style="width: 7%;">
				<col style="width: 10%;">
				<col style="width: 13%;">
			</colgroup>
			<thead>
            <tr>
                <th>mnstCd</th>
                <th>sbjtCd</th>
                <th>sbjtN</th>
                <th>orgNm</th>
                <th></th>
                <th></th>
                <th>sbjtNm</th>
                <th>bizCd1</th>
                <th>bizNm1</th>
                <th>bizCd2</th>
                <th>bizNm2</th>
                <th>bizCd3</th>
                <th>bizNm3</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${resultList}">
                <tr>
                    <td>${item.mnstCd}</td>
                    <td>${item.sbjtCd}</td>
                    <td>${item.sbjtN}</td>
                    <td>${item.orgNm}</td>
                    <td></td>
                    <td></td>
                    <td>${item.sbjtNm}</td>
                    <td>${item.bizCd1}</td>
                    <td>${item.bizNm1}</td>
                    <td>${item.bizCd2}</td>
                    <td>${item.bizNm2}</td>
                    <td>${item.bizCd3}</td>
                    <td>${item.bizNm3}</td>
                </tr>
            </c:forEach>
        </tbody>
		</table>
	</div><!-- end div board -->

	<div id="myGrid" class="ag-theme-alpine" style="height: 500px; width: 600px;"></div>
	    <script>
	        var columnDefs = [
	            {headerName: "Make", field: "make"},
	            {headerName: "Model", field: "model"},
	            {headerName: "Price", field: "price"}
	        ];

	        var rowData = [
	            {make: "Toyota", model: "Celica", price: 35000},
	            {make: "Ford", model: "Mondeo", price: 32000},
	            {make: "Porsche", model: "Boxster", price: 72000}
	        ];

	        var gridOptions = {
	            columnDefs: columnDefs,
	            rowData: rowData
	        };

	        document.addEventListener('DOMContentLoaded', function() {
	            var gridDiv = document.querySelector('#myGrid');
	            new agGrid.Grid(gridDiv, gridOptions);
	        });
	    </script>
</body>
</html>
