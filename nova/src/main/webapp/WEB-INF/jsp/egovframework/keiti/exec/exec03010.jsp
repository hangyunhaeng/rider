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
	#myGrid2 .ag-body-horizontal-scroll-viewport {    display: none !important;  }
	.ag-sticky-bottom {    display: none !important;  }
	</style>

</head>
<body>
	<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopMenu.jsp" />
	<div class="keit-header-body innerwrap clearfix">
		<p class="tit"> 예산 실적 대비표</p>
		<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopTaskCard.jsp" />
		<form name="form1" method="post" id="form1">
		<h4 class="tit"> 예산
			<span class="convdate" >
			</span>
		</h4>
		<div class="rbtn">
			<span>집행방법 :</span>
			<select name="srcExecMtd" class="w30p" id="srcExecMtd">
			</select>
			<a href="javascript:goSubPage('/exec/exec02010.do')"  class="btn detail">세부비목별 내역서</a>
			<a href="javascript:downloadExcel();" class="btn exceldown">엑셀 다운로드</a>
		</div>
		<div  class="ib_product">
			<div id="myGrid" class="ag-theme-alpine" style="height: 500px; width: 100%;"></div>
		</div>
		<h4 class="tit"> 집행 방법별 집행내역
			<span class="convdate" ></span>
		</h4>
			<div class="rbtn">
			<a href="javascript:downloadExcel2();" class="btn exceldown">엑셀 다운로드</a>
		</div>
		<input name="srcUnionF" type="hidden" value="Y" id="srcUnionF"/>
		<div id="loadingOverlay" style="display: none;">Loading...</div>
		<div  class="ib_product" style="margin-bottom:-10px;">
			<div id="myGrid2" class="ag-theme-alpine" style="height: 500px; width: 100%;margin-bottom: 20px;"></div>
		</div>
		<br/>
		<br/>
		</form>
		<!-- AG Grid JavaScript -->
		<script>
			let gridOptions="";
			var grid="";
			var grid2="";
			let data;
			var columnDefs = [
                { headerName: "비목명", field: "ioeNm", minWidth: 220, width: 260, cellClass: 'ag-cell-left', cellRenderer: (params) => { return params.value.replace(/ /g, '&nbsp;'); },
                	cellStyle: function(params) {
                    if (params.data.ioeNm === '합계') {
                        return { 'text-align': 'center' }; // 합계 행의 셀을 가운데 정렬
                    }
                    return null;
                } },
                { headerName: "예산", field: "bdg", minWidth: 330,headerClass: 'ag-header-center',
                	children: [
                        { headerName: "현금<br>(A)", field: "bdgCash", minWidth: 110, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right'},
                        { headerName: "현물<br>(B)", field: "bdgNon", minWidth: 110, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right'},
                        { headerName: "계<br>(C=A+B)", field: "bdgTot", minWidth: 110, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right'}
                    ]
                },
                { headerName: "실집행액", field: "exec" ,
                	children: [
                        { headerName: "현금<br>(D)", field: "execCash", minWidth: 110, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                        { headerName: "현물<br>(E)", field: "execNon", minWidth: 110, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                        { headerName: "부가세<br>(F)", field: "execVat", minWidth: 100, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right'},
                        { headerName: "합계<br>(G=D+E)", field: "execTot", minWidth: 110, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' }
                    ]
                },
                { headerName: "집행잔액", field: "bal" ,
                	children: [
                        { headerName: "현금<br>(H=A+N+O-D)", field: "balCash", minWidth: 110, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                        { headerName: "현물<br>(I=B-E)", field: "balNon", minWidth: 110, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                        { headerName: "합계<br>(J=H+I)", field: "balTot", minWidth: 110, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' }
                    ]
                },
                { headerName: "집행<br>비율<br>(K)", field: "execRat", minWidth: 90, width: 90, valueFormatter: percentFormatter, cellClass: 'ag-cell-right'  },
                { headerName: "집행<br>건수<br>(L)", field: "execCnt", minWidth: 90, width: 90, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right'  },
                { headerName: "예산변동분", field: "chg" ,
                	children: [
                        { headerName: "전년도<br>이월액(N)", field: "chgCa", minWidth: 110, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                        { headerName: "예산이자<br>발생액(O)", field: "chgIa", minWidth: 110, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                        { headerName: "예산총계<br>(P=C+N+O)", field: "chgTot", minWidth: 110, width: 120, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' }
                    ]
                }
            ];
			var columnDefs2 = [
            	{ headerName: "구분", field: "gb", width: 150, cellRenderer: function(params) {
                    const rowIndex = params.node.rowIndex;
                 	// 합계 행일 경우 group 검사를 건너뜁니다.
                    if (params.data.gb === '합계') {
                        return params.value;
                    }
                    const currentGroup = params.data.group;
                    const displayedRowAtIndex = params.api.getDisplayedRowAtIndex(rowIndex - 1);

                    if (displayedRowAtIndex && displayedRowAtIndex.data.group === currentGroup) {
                        return '';
                    }
                    return params.value;
                },
                cellClass: 'cell-span' },
                { headerName: "종류", field: "execMtd", width: 200, valueFormatter: execMtdFormatter },
                { headerName: "건수", field: "cnt", width: 150, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                { headerName: "금액", field: "amt", width: 220, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                { headerName: "부가세", field: "vat", width: 200, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                { headerName: "등록된집행액", field: "execAmt", width: 200, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right' },
                { headerName: "집행비율", field: "execRat", width: 150, valueFormatter: percentFormatter, cellClass: 'ag-cell-right'}
            ];

			document.addEventListener('DOMContentLoaded', function() {
		    	gridOptions = {
		                columnDefs: columnDefs,
		                rowData: [],
		                getRowStyle: function(params) {
		                    if (params.data.ioeNm === '합계') {
		                        return { background: '#bddc98' ,
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
		                suppressHorizontalScroll: false,
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
		                getRowStyle: function(params) {
		                    if (params.data.gb.includes('소계')) {
		                        return { background: '#e9f8e1','font-weight': 'bold' }; // 소계 행의 배경색을 연초록색으로 설정
		                    } else if (params.data.gb === '합계') {
		                        return { background: '#bddc98','font-weight': 'bold' }; // 합계 행의 배경색을 초록색으로 설정, 글자색은 흰색으로
		                    }
		                    return null;
		                },
		                suppressHorizontalScroll: true,
		                defaultColDef: { headerComponent: 'CustomHeader' },
		                components: { CustomHeader: CustomHeader },
		                enableCellTextSelection: true, // 셀 텍스트 선택을 활성화합니다.
		                rowHeight: 35,
		                headerHeight: 35,
		                onGridReady: function(params) {
		                    //loadData2(params.api); // 그리드가 준비된 후 데이터 로드
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

		        //loadData(params.api);

		        // 데이터 로드 함수
		        function loadData(api) {
		        	grid.setGridOption('loading', true);

		        	//var params = new URLSearchParams();
				    //params.append('srcExecMtd', document.getElementById('srcExecMtd').value);
				    //params.append('srcUnionF', document.getElementById('srcUnionF').value);
				    // 폼 데이터 가져오기
				    var form = document.getElementById('form1');
				    var formData = new FormData(form);
				    var params = new URLSearchParams();

				    formData.forEach(function(value, key) {
			            params.append(key, value);
				    });

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
		                	loadData2(api);
						});
		        }
		        document.getElementById('srcExecMtd').addEventListener('change', function(event) {
		            const api = ""; // 필요한 경우 적절한 API 값을 설정합니다.
		            loadData(api);
		        });
		     // 데이터 로드 함수
		        function loadData2(api) {
		        	grid.setGridOption('loading', true);
		            axios.get('/api/exec/exec03002.do')
		                .then(function(response) {
		                	const rowData = response.data.resultList;
		                    const processedData = calculateSubtotalsAndTotals(rowData, 'gb');
		                    const totalExecAmt = getChgTotFromSummaryRow(grid);
		                	// execRat 값을 계산하여 추가
		                    processedData.forEach(row => {
		                        if (totalExecAmt && totalExecAmt !== 0) {  // totalExecAmt가 0이 아닌 경우에만 계산
		                        	row.execRat = (Math.floor((row.execAmt / totalExecAmt) * 100 * 100) / 100).toFixed(2);  // 소수점 둘째 자리까지 버림
		                        } else {
		                            row.execRat = '0.00';  // totalExecAmt가 0인 경우 0.00으로 설정
		                        }
		                    });
		                    //grid2.setGridOption('rowData', processedData);

		                    const resultList = processedData;
		                    // 마지막 행을 추출하고 rowData와 pinnedBottomRowData에 각각 설정
				            const rowDataWithoutLastRow = resultList.slice(0, -1);  // 마지막 행 제외
				            const lastRow = resultList[resultList.length - 1];  // 마지막 행

				            grid2.setGridOption('rowData', rowDataWithoutLastRow);  // rowData 설정
				            grid2.setGridOption('pinnedBottomRowData', [lastRow]);  // 마지막 행을 고정 행으로 설정

		                    //grid2.setGridOption('rowData', response.data.resultList);  //아래 라인과 동일한 의미
		                }).catch(function(error) {
		                    console.error('There was an error fetching the data:', error);
		                }).finally(function() {
		                	grid.setGridOption('loading', false);
						});
		        }
		    });

			function downloadExcel() {
				var titleElement = document.querySelector('p.tit');
	            var title = titleElement.textContent.trim();
	            const selectedColumns = ["ioeNm", "bdgCash", "bdgNon", "bdgTot", "execCash", "execNon", "execVat", "execTot", "balCash", "balNon", "balTot", "execRat", "execCnt", "chgCa", "chgIa", "chgTot"];
				downloadEx(grid,columnDefs,selectedColumns,"BDG_SUMMARY",title,true);
			}
			function downloadExcel2() {
				const selectedColumns = ["gb", "execMtd", "cnt", "amt","vat","execAmt","execRat"];
				downloadEx(grid2,columnDefs2,selectedColumns,"EXEC_MTD_SUMMARY",'집행 방법별 집행내역',true);
			}
			function calculateSubtotalsAndTotals(data, groupByField) {
			    let resultData = [];
			    let currentGroup = null;
			    let groupTotals = null;
			    let grandTotal = {
			        gb: '합계',
			        execMtd: '',
			        cnt: 0,
			        amt: 0,
			        vat: 0,
			        execAmt: 0,
			        execRat: 0 // execRat 합산을 위한 초기값
			    };

			    // 전체 execAmt 합계 계산
			    const totalExecAmt = getChgTotFromSummaryRow(grid);

			    data.forEach((row) => {
			        if (!currentGroup || currentGroup !== row[groupByField]) {
			            if (groupTotals) {
			                // 소계 execRat을 최종 계산
			                groupTotals.execRat = ((groupTotals.execAmt / totalExecAmt) * 100).toFixed(2);
			                resultData.push(groupTotals);
			            }
			            currentGroup = row[groupByField];
			            groupTotals = {
			                gb: '소계',
			                execMtd: '',
			                cnt: 0,
			                amt: 0,
			                vat: 0,
			                execAmt: 0,
			                execRat: 0 // execRat 합산을 위한 초기값
			            };
			        }
			        groupTotals.cnt += parseFloat(row.cnt) || 0;
			        groupTotals.amt += parseFloat(row.amt) || 0;
			        groupTotals.vat += parseFloat(row.vat) || 0;
			        groupTotals.execAmt += parseFloat(row.execAmt) || 0;

			        resultData.push({ ...row, group: currentGroup });

			        grandTotal.cnt += parseFloat(row.cnt) || 0;
			        grandTotal.amt += parseFloat(row.amt) || 0;
			        grandTotal.vat += parseFloat(row.vat) || 0;
			        grandTotal.execAmt += parseFloat(row.execAmt) || 0;
			    });

			    if (groupTotals) {
			        // 소계 execRat을 최종 계산
			        groupTotals.execRat = ((groupTotals.execAmt / totalExecAmt) * 100).toFixed(2);
			        resultData.push(groupTotals);
			    }

			    // grandTotal execRat 최종 계산
			    grandTotal.execRat = ((grandTotal.execAmt / totalExecAmt) * 100).toFixed(2);

			    resultData.push(grandTotal);

			    return resultData;
			}

			function getChgTotFromSummaryRow(api) {
			    // 모든 행 데이터 가져오기
			    const allRows = [];
			    api.forEachNodeAfterFilterAndSort((node) => {
			        allRows.push(node.data);
			    });

			    // ioeNm이 '합계'인 행 찾기
			    const summaryRow = allRows.find(row => row.ioeNm === '합계');

			    if (summaryRow) {
			        // '합계' 행의 chgTot 값 반환
			        return summaryRow.chgTot;
			    } else {
			        return null;  // '합계' 행이 없을 경우 null 반환
			    }
			}
	    </script>
	</div>
</body>
</html>