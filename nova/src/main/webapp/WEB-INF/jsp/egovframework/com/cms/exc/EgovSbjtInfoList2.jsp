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
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-theme-alpine.css">
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.noStyle.js"></script>
<script type="text/javascript">

</script>

</head>
<body>
    <div id="myGrid" class="ag-theme-alpine" style="height: 500px; width: 600px;"></div>
    <!-- AG Grid JavaScript -->

    <script>
        // Column definitions
        var columnDefs = [
            { headerName: "mnstCd", field: "mnstCd" },
            { headerName: "sbjtCd", field: "sbjtCd" },
            { headerName: "sbjtN", field: "sbjtN" }
        ];

        // Row data
        var rowData = [
            { mnstCd: "Toyota", sbjtCd: "Celica", sbjtN: 35000 , bizCd1	: "BIZ001"},
            { mnstCd: "Ford", sbjtCd: "Mondeo", sbjtN: 32000 },
            { mnstCd: "Porsche", sbjtCd: "Boxster", sbjtN: 72000 }
        ];

        var resultList = ${resultList};

        console.log(rowData);
        console.log(resultList);
        // Grid options
        var gridOptions = {
            columnDefs: columnDefs,
            rowData: resultList
        };
        var gridOptions2 = {
                columnDefs: columnDefs,
                rowData: rowData
            };
        // Setup the grid
        document.addEventListener('DOMContentLoaded', function() {
            var gridDiv = document.querySelector('#myGrid');
            new agGrid.Grid(gridDiv, gridOptions);

            this.gridOptions.api.setRowData(gridOptions2);
        });
    </script>
</body>
</html>
