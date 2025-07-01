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
<script src="https://unpkg.com/@ag-grid-enterprise/all-modules@23.0.2/dist/ag-grid-enterprise.min.js"></script>
<head>
<title>${pageTitle} <spring:message code="title.list" /></title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/com/com.css' />">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-theme-alpine.css">
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.noStyle.js"></script>
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.16.2/xlsx.full.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script type="text/javascript">

</script>

</head>
<body>
	<button id="loadDataBtn">Load Data</button>
	<button onclick="onBtExport()">엑셀로 내보내기</button>
	<button onclick="downloadExcel()">엑셀로 내보내기2</button>
    <div id="myGrid" class="ag-theme-alpine" style="height: 500px; width: 600px;"></div>
    <!-- AG Grid JavaScript -->
    <script>
    let gridOptions="";
    let grid="";
    let data;
    document.addEventListener('DOMContentLoaded', function() {
    	gridOptions = {
                columnDefs: [
                    { headerName: "mnstCd", field: "mnstCd" },
                    { headerName: "sbjtCd", field: "sbjtCd" },
                    { headerName: "sbjtN", field: "sbjtN" },
                    { headerName: "sbjtNm", field: "sbjtNm" }
                ],
                rowData: [], // 초기 행 데이터를 빈 배열로 설정
                onGridReady: function(params) {
                    loadData(params.api); // 그리드가 준비된 후 데이터 로드
                }
            };
        const gridDiv = document.querySelector('#myGrid');
        grid = agGrid.createGrid(gridDiv, gridOptions);

        //loadData(params.api);

        // 데이터 로드 함수
        function loadData(api) {
            axios.get('/api/cms/exc/selectstifList4.do')
                .then(function(response) {
                    //const resultList = JSON.parse(response.data.resultList);

                    // 새로운 데이터로 그리드 업데이트
                    //api.setRowData(resultList);
                    //grid.setGridOption('rowData', resultList);  //아래 라인과 동일한 의미
                    grid.setGridOption('rowData', response.data.resultList);  //아래 라인과 동일한 의미
                    data=response.data.resultList;
                })
                .catch(function(error) {
                    console.error('There was an error fetching the data:', error);
                });
        }

        // 조회 버튼 클릭 시 데이터 다시 로드

        document.getElementById('loadDataBtn').addEventListener('click', function() {
            const api = gridOptions.api;
            loadData(api);
        });

    });

    function onBtExport() {
    	var v_params = {
                suppressQuotes: "true",                 // none, true
                columnSeparator: ",",                 // default값이 ,
                fileName: 'exported-data.csv',
                allColumns: true
                //customHeader: "이름 별명 장점 단점",    // 헤더명 추가 출력
                //customFooter: "이거슨 푸터"             // 데이타 아래에 footer추가
            };
    	grid.exportDataAsCsv(v_params);
    	/*gridOptions.api.exportDataAsCsv({
            fileName: 'exported-data.csv',
            allColumns: true
        });*/

    }

    function downloadExcel() {
        const rows = [];
        grid.forEachNode((node) => {
            rows.push([node.data.mnstCd, node.data.sbjtCd, node.data.sbjtN]);
        });

        // 첫 번째 행을 추가하여 헤더를 포함
        rows.unshift(['mnstCd', 'sbjtCd', 'sbjtN']);

        const ws = XLSX.utils.aoa_to_sheet(rows);

        // 모든 셀의 형식을 텍스트로 설정
        const range = XLSX.utils.decode_range(ws['!ref']);
        for (let R = range.s.r; R <= range.e.r; ++R) {
            for (let C = range.s.c; C <= range.e.c; ++C) {
                const cell_address = {c: C, r: R};
                const cell_ref = XLSX.utils.encode_cell(cell_address);
                if (!ws[cell_ref]) continue;
                ws[cell_ref].t = 's';  // 셀 형식을 텍스트로 설정
            }
        }

        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
        XLSX.writeFile(wb, 'exported-data.xlsx');
    }

    </script>
</body>
</html>
