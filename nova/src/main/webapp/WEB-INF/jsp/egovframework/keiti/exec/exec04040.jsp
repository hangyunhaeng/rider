<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><spring:message code="comCmm.unitContent.1" /></title>
	<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.default.css' /> ">
	<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.style.css' />">

	<script type="text/javascript"	src="<c:url value='/web2/js/jquery-1.11.2.min.js' />"></script>
	<script type="text/javascript"	src="<c:url value='/web2/js/function.js' />"></script>
	<script type="text/javascript"	src="<c:url value='/web2/js/keit.jquery.ui.js' />"></script>
	<script type="text/javascript"	src="<c:url value='/web2/js/keit.custom.js' />"></script>
	<script type="text/javascript"	src="<c:url value='/web2/js/kaia.pbCommon.js' />"></script>

	<link rel="stylesheet" href="/ag-grid/ag-grid.css">
	<link rel="stylesheet" href="/ag-grid/ag-theme-alpine.css">
	<link rel="stylesheet" href="/ag-grid/ag-custom.css">
	<script src="/ag-grid/ag-grid-community.noStyle.js"></script>
	<script src="/ag-grid/ag-grid-community.js"></script>
	<script src="/ag-grid/ag-custom-header.js"></script>
	<script src="/js/xlsx.full.min.js"></script>
	<script src="/js/axios.min.js"></script>
	<style>
	.ag-body-horizontal-scroll-viewport {    display: none !important;  }
	</style>
</head>
<body>
	<div class="pop">
		<h1>공통서류</h1>
		<a href="javascript:window.close()" class="close"
			onclick="javascript:window.close();"></a>
		<section class="cont">
			<div style="overflow-X: hidden">
				<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopTaskCard.jsp" />
				<form name="form1" method="post" enctype="multipart/form-data" id="form1">
					<h4 class="tit">공통서류 자료</h4>
					<!-- grid  -->
					<div  class="ib_product">
						<script type="text/javascript">
						</script>
				    </div>
				</form>
			</div>
		</section>
		<div class="rbtn">
			<span id="btnDownloadAll"><a href="javascript:downloadAll(taskNoFormatter(taskVo.taskNo));" class="btn exceldown">전체 다운로드</a></span> <span id="btnDelete" style="display: none"></span>
		</div>
		<div id="myGrid" class="ag-theme-alpine" style="height: 500px; width: 100%;padding:1px;"></div>
	</div>
	<script>
		let gridOptions="";
		let grid="";
		let data;
		document.addEventListener('DOMContentLoaded', function() {
		    gridOptions = {
		        columnDefs: [
		            { headerName: "No", field: "no", valueGetter: 'node.rowIndex + 1', minWidth: 70, width: 70 },
		            { headerName: "분류", field: "rtmItm", minWidth: 160, width: 200, valueFormatter: rtmItmFormatter},
		            { headerName: "파일명", field: "fileOrgNm", minWidth: 230, width: 140 },
		            { headerName: "거래키", field: "rtmKey", minWidth: 0, width: 0, hide:true },
		            { headerName: "순번", field: "seqN", minWidth: 0, width: 260, hide:true },
		            //{ headerName: "경로", field: "fullPath", minWidth: 250, width: 260 },
		            {
		                headerName: "다운로드",
		                field: "download",
		                minWidth: 100,
		                width: 100,
		                cellRenderer: function(params) {
		                	return '<button class="btn ty1" onclick="downloadFile(\'' + params.data.rtmItm + '\', \'' + params.data.rtmKey + '\', \'' + params.data.seqN + '\', \'' + params.data.fileOrgNm + '\')">다운로드</button>';
		                }
		            }
		        ],
		        rowData: [],
		        defaultColDef: { headerComponent: 'CustomHeader' },
		        components: { CustomHeader: CustomHeader },
		        enableCellTextSelection: true, // 셀 텍스트 선택을 활성화합니다.
		        rowHeight: 35,
		        headerHeight: 35,
		        suppressHorizontalScroll: true,
		        onGridReady: function(params) {
		            loadData(params.api);
		            params.api.sizeColumnsToFit();
		        },
		        overlayLoadingTemplate: '<span class="ag-overlay-loading-center">Loading...</span>',
		        overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">No Data</span>'
		    };

		    const gridDiv = document.querySelector('#myGrid');
		    grid = agGrid.createGrid(gridDiv, gridOptions);

		    function loadData(api) {
		        grid.setGridOption('loading', true);
		        var form = document.getElementById('form1');
		        var formData = new FormData(form);
		        var params = new URLSearchParams();
		        formData.forEach(function(value, key) {
		            params.append(key, value);
		        });

		        axios.post('/api/exec/exec04001.do',params).then(function(response) {
		            if (response.data.resultList.length === 0) {
		                grid.setGridOption('rowData', []);
		                grid.showNoRowsOverlay();
		            } else {
		                grid.setGridOption('rowData', response.data.resultList);
		            }
		            data = response.data.resultList;
		        })
		        .catch(function(error) {
		            console.error('There was an error fetching the data:', error);
		        }).finally(function() {
		            grid.setGridOption('loading', false);
		        });
		    }
		});
		function downloadFile(rtmItm, rtmKey, seqN, fileName) {
		    const downloadUrl = '/api/exec/exec04002.do';

		    // FormData 객체 생성
		    const formData = new FormData();
		    formData.append('rtmItm', rtmItm);
		    formData.append('rtmKey', rtmKey);
		    formData.append('seqN', seqN);

		    axios.post(downloadUrl, formData, { responseType: 'blob' })
		        .then(response => {
		            const url = window.URL.createObjectURL(new Blob([response.data]));
		            const a = document.createElement('a');
		            a.href = url;
		            a.download = fileName; // 다운로드할 파일 이름으로 파라미터 fileName 사용
		            document.body.appendChild(a);
		            a.click();
		            a.remove();
		            window.URL.revokeObjectURL(url);
		        })
		        .catch(error => {
		            if (error.response && error.response.data) {
		                const reader = new FileReader();
		                reader.onload = function () {
		                    const errorMessage = JSON.parse(reader.result).message;
		                    alert(errorMessage);
		                };
		                reader.readAsText(error.response.data);
		            } else {
		                alert("파일 다운로드 중 오류가 발생했습니다.");
		            }
		            console.error('Error during file download:', error);
		        });
		}

		function downloadAll(taskNo) {
		    const downloadUrl = '/api/exec/exec04003.do';
		    const fileName ='공통서류_'+taskNo+'.zip';
		    // FormData 객체 생성
		    const formData = new FormData();

		    axios.post(downloadUrl, formData, { responseType: 'blob' })
		        .then(response => {
		            const url = window.URL.createObjectURL(new Blob([response.data]));
		            const a = document.createElement('a');
		            a.href = url;
		            a.download = fileName; // 다운로드할 파일 이름으로 파라미터 fileName 사용
		            document.body.appendChild(a);
		            a.click();
		            a.remove();
		            window.URL.revokeObjectURL(url);
		        })
		        .catch(error => {
		            if (error.response && error.response.data) {
		                const reader = new FileReader();
		                reader.onload = function () {
		                    const errorMessage = JSON.parse(reader.result).message;
		                    alert(errorMessage);
		                };
		                reader.readAsText(error.response.data);
		            } else {
		                alert("파일 다운로드 중 오류가 발생했습니다.");
		            }
		            console.error('Error during file download:', error);
		        });
		}
    </script>
</body>
</html>