<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>한국환경사업기술원 <spring:message code="comCmm.unitContent.1" /></title>
	<style>
	.input_readonly_right {background-color:#e4e4e4; border:1x SOLID #cbcbcb; height:20px; color: #777777; font-size: 12px; line-height:16px; font-family:"돋움"; text-align:right;}
	.cell-span {    vertical-align: top;    line-height: 32px;}
	</style>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopMenu.jsp" />
	<div class="keit-header-body innerwrap clearfix">
		<p class="tit"> 세부 비목별 내역서</p>
		<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopTaskCard.jsp" />
		<form name="form1" method="post" id="form1">
			<input name="pageUnit" type="hidden" value="10000000"/>
			<input name="pageSize" type="hidden" value="10000000"/>
			<input name="srcOrderBy" type="hidden" value="IOE_CD"/>
		<h4 class="tit"> 예산 실적 대비표
			<span class="convdate" >
			</span>
		</h4>

		<div class="rbtn" style="width: 40%;">
			<span>집행방법 :</span>
			<select name="srcExecMtd" style="width:30%"  id="srcExecMtd">
			</select>
			<a href="javascript:downloadExcel();" class="btn exceldown">엑셀 다운로드</a>
		</div>

		<div  class="ib_product">
			<div id="myGrid" class="ag-theme-alpine" style="height: 500px; width: 100%;"></div>
		</div>
		<h4 class="tit"> 집행내역
			<span class="convdate" ></span>
		</h4>
		<div class="rbtn">
			<a href="javascript:downloadExcel2();" class="btn exceldown">엑셀 다운로드</a>
		</div>
		<div id="loadingOverlay" style="display: none;">Loading...</div>
		<div  class="ib_product">
			<div id="myGrid2" class="ag-theme-alpine" style="height: 500px; width: 100%;"></div>
		</div>
		<br/>
		<br/>
		</form>
		<!-- AG Grid JavaScript -->
		<script>
			let gridOptions="";
			let grid="";
			let grid2="";
			let data;
			var columnDefs = [
                { headerName: "비목명", field: "ioeNm", minWidth: 200, width: 260
                	,cellStyle: function(params) {
	                    if (params.data.ioeNm === '합계') {
	                        return { 'text-align': 'center' }; // 합계 행의 셀을 가운데 정렬
	                    }
	                    return null;
	                }, cellClass: 'ag-cell-left', cellRenderer: (params) => { return params.value.replace(/ /g, '&nbsp;'); } },
                { headerName: "예산", field: "bdg", minWidth: 300,
                	children: [
                        { headerName: "현금<br>(A)", field: "bdgCash", minWidth: 100, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                        { headerName: "현물<br>(B)", field: "bdgNon", minWidth: 100, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                        { headerName: "소계<br>(C=A+B)", field: "bdgTot", minWidth: 100, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' }
                    ]
                },
                { headerName: "예산변동분", field: "chg" ,
                	children: [
                        { headerName: "전년도<br>이월액(D)", field: "chgCa", minWidth: 100, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                        { headerName: "예산이자<br>발생액(E)", field: "chgIa", minWidth: 100, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                        { headerName: "예산총계<br>(F=C+D+E)", field: "chgTot", minWidth: 100, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' }
                    ]
                },
                { headerName: "총사용액<br>(G=H+I)", field: "execSum", minWidth: 100, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right'},
                { headerName: "부가세<br>(H)", field: "execVat", minWidth: 80, width: 100, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right'},
                { headerName: "실사용액<br>(I)", field: "execTot", minWidth: 100, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                { headerName: "잔액<br>(J=F-I)", field: "balTot", minWidth: 100, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                { headerName: "건수", field: "execCnt", minWidth: 50, width: 80, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right'},
                { headerName: "비율", field: "execRat", minWidth: 50, width: 80, valueFormatter: (params) => {if (params.value !== null && params.value !== undefined) { return params.value + '%';} return params.value;}, cellClass: 'ag-cell-right' }
            ];
			var columnDefs2 = [
                { headerName: "번호", field: "no", width: 200 },
                { headerName: "비목", field: "ioeCd", minWidth: 150, valueFormatter: ioeCdFormatter  },
                { headerName: "집행일", field: "execDt", minWidth: 100, valueFormatter: dateFormatter },
                { headerName: "등록일", field: "rgDt", minWidth: 100, valueFormatter: dateFormatter },
                { headerName: "지급처", field: "usg", minWidth: 80 },
                { headerName: "사용금액", field: "chg" ,
                	children: [
                        { headerName: "총사용액", field: "totAmt", minWidth: 110, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                        { headerName: "부가세", field: "vat", minWidth: 110, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                        { headerName: "실집행액", field: "execAmt", minWidth: 130, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' }
                    ]
                },
                { headerName: "사용목적", field: "rmk", width: 300, cellClass: 'ag-cell-left' },
                { headerName: "사용구분", field: "execMtd", width: 200, valueFormatter: execMtdFormatter },
                { headerName: "비고", field: "bigo", width: 200, hide: true }
            ];
			document.addEventListener('DOMContentLoaded', function() {
		    	gridOptions = {
		                columnDefs: columnDefs,
		                rowData: [],
		                getRowStyle: function(params) {
		                    if (params.data.ioeNm === '합계') {
		                        return { background: '#bddc98',
		                        	'font-weight': 'bold'
		                        };
		                    }
		                    return null;
		                },
		                defaultColDef: { headerComponent: 'CustomHeader' },
		                components: { CustomHeader: CustomHeader },
		                pinnedBottomRowData: [], // 고정 행에 사용할 데이터, 초기에는 빈 배열
		                enableCellTextSelection: true, // 셀 텍스트 선택을 활성화합니다.
		                rowHeight: 35,
		                headerHeight: 35,
		                onGridReady: function(params) {
		                    loadData(params.api); // 그리드가 준비된 후 데이터 로드
		                    //params.api.sizeColumnsToFit();
		                },
						overlayLoadingTemplate: '<span class="ag-overlay-loading-center">Loading...</span>',
						overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">No Data</span>'
		            };

		    	gridOptions2 = {
		                columnDefs: columnDefs2,
		                rowData: [],
		                defaultColDef: { headerComponent: 'CustomHeader' },
		                components: { CustomHeader: CustomHeader },
		                enableCellTextSelection: true, // 셀 텍스트 선택을 활성화합니다.
		                rowHeight: 35,
		                headerHeight: 35,
		                onGridReady: function(params) {
		                    loadData2(params.api); // 그리드가 준비된 후 데이터 로드
		                    params.api.sizeColumnsToFit();
		                },
		                overlayLoadingTemplate: '<span class="ag-overlay-loading-center">Loading...</span>',
						overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">No Data</span>'
		            };

		        const gridDiv = document.querySelector('#myGrid');
		        grid = agGrid.createGrid(gridDiv, gridOptions);

		        const gridDiv2 = document.querySelector('#myGrid2');
		        grid2 = agGrid.createGrid(gridDiv2, gridOptions2);

				loadIoeCdMapping(); //비목코드 로드
				populateSelectOptions('srcExecMtd', execMtdMapping,'');
		        // 데이터 로드 함수
		        function loadData(api) {
		        	grid.setGridOption('loading', true);

		        	var params = new URLSearchParams();
				    params.append('srcExecMtd', document.getElementById('srcExecMtd').value);
		            axios.post('/api/exec/exec03001.do',params)
		                .then(function(response) {
		                    //grid.setGridOption('rowData', response.data.resultList);  //아래 라인과 동일한 의미
		                    const resultList = response.data.resultList;
		                    // 마지막 행을 추출하고 rowData와 pinnedBottomRowData에 각각 설정
				            const rowData = resultList.slice(0, -1);  // 마지막 행 제외
				            const lastRow = resultList[resultList.length - 1];  // 마지막 행

				            grid.setGridOption('rowData', rowData);  // rowData 설정
				            grid.setGridOption('pinnedBottomRowData', [lastRow]);  // 마지막 행을 고정 행으로 설정
		                })
		                .catch(function(error) {
		                    console.error('There was an error fetching the data:', error);
		                }).finally(function() {
		                	grid.setGridOption('loading', false);
						});
		        }

		     // 데이터 로드 함수
		        function loadData2(api) {
		        	grid.setGridOption('loading', true);
		        	 // 폼 데이터 가져오기
				    var form = document.getElementById('form1');
				    var formData = new FormData(form);
				    var params = new URLSearchParams();

				    formData.forEach(function(value, key) {
			            params.append(key, value);
				    });
		            axios.post('/api/exec/exec01001.do', params)
		                .then(function(response) {
		                    grid2.setGridOption('rowData', response.data.resultList);  //아래 라인과 동일한 의미
		                }).catch(function(error) {
		                    console.error('There was an error fetching the data:', error);
		                }).finally(function() {
		                	grid.setGridOption('loading', false);
						});
		        }
		        document.getElementById('srcExecMtd').addEventListener('change', function(event) {
		            const api = ""; // 필요한 경우 적절한 API 값을 설정합니다.
		            loadData(api);
		        });

		    });
			function downloadExcel() {
				var titleElement = document.querySelector('p.tit');
	            var title = titleElement.textContent.trim();
	            const selectedColumns = ["ioeNm", "bdgCash", "bdgNon", "bdgTot", "chgCa", "chgIa", "chgTot", "execSum", "execVat", "execTot", "balTot", "execCnt", "execRat"];
				downloadEx(grid,columnDefs,selectedColumns,"BDG_SUMMARY2",title,true);
			}
			function downloadExcel2() {
				const selectedColumns = ["no", "ioeCd", "execDt", "rgDt", "mct", "totAmt", "vat", "execAmt", "rmk", "execMtd", "bigo"];
				downloadEx(grid2,columnDefs2,selectedColumns,"EXEC_LIST",'집행내역',true);
			}
	    </script>
	</div>
</body>
</html>