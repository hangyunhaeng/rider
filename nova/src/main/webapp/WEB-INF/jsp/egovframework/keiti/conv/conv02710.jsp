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
	<script>
	// 날짜 포맷터
	function dateFormatter(params) {
	    if (params.value) {
	        // 서버에서 오는 날짜 형식이 "YYYYMMDD" 라고 가정
	        var value = params.value;
	        if (value.length === 8) {
	            var year = value.substring(0, 4);
	            var month = value.substring(4, 6);
	            var day = value.substring(6, 8);
	            return year + "-" + month + "-" + day;
	        }
	    }
	    return params.value; // 날짜 형식이 아니면 원래 값을 반환
	}
	</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopMenu.jsp" />
	<div class="keit-header-body innerwrap clearfix">
		<p class="tit"> 참여인력관리</p>
			<!-- 숨겨진 폼 -->
		<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopTaskCard.jsp" />
		<h4 class="tit"> 참여 연구원 정보
			<span class="convdate" ></span>
		</h4>
		<br><br><br>
		<form name="form1" method="post">
			<span class="pagetotal" style="margin-top:5px;">
				Total <em id="TT_CNT"></em>&nbsp;
			</span>
			<div class="rbtn">
				<a href="javascript:downloadExcel();" class="btn exceldown">엑셀 다운로드</a>
			</div>


			<div id="loadingOverlay" style="display: none;">Loading...</div>
			<div  class="ib_product mt10">
				<div id="myGrid" class="ag-theme-alpine" style="height: 570px; width: 100%;"></div>
				<script>
					let gridOptions="";
					var grid="";
					let data;
					var columnDefs = [
						{ headerName: "NO", field: "no", valueGetter:(params) => { return params.node.rowIndex + 1}, minWidth: 50 },
	                	{ headerName: "이름", field: "nm", minWidth: 80 },
	                    { headerName: "영문이름", field: "engNm", minWidth: 110, cellClass: 'ag-cell-left' },
	                    { headerName: "생년월일", field: "dob", minWidth: 100, valueFormatter: dateFormatter },
	                    { headerName: "성별", field: "gd", minWidth: 50 },
	                    { headerName: "직위", field: "pos", minWidth: 100, cellClass: 'ag-cell-left' },
	                    { headerName: "책임여부", field: "isMng", minWidth: 120 },
	                    { headerName: "이메일", field: "email", minWidth: 150, cellClass: 'ag-cell-left' },
	                    { headerName: "휴대폰", field: "phone", minWidth: 130 },
	                    { headerName: "참여시작일자", field: "partStartdt", minWidth: 100, valueFormatter: dateFormatter },
	                    { headerName: "참여종료일자", field: "partEnddt", minWidth: 100, valueFormatter: dateFormatter },
	                    { headerName: "소속기관", field: "org", minWidth: 150, cellClass: 'ag-cell-left',
	                      valueGetter: (params) => {
	                        return params.data.org ? params.data.org : taskVo.instNm;
	                      }
	                    },
	                    { headerName: "소속부서", field: "dept", minWidth: 150, cellClass: 'ag-cell-left' },
	                    { headerName: "참여율", field: "partRat", minWidth: 100, flex: 1, valueFormatter: percentFormatter }
	                ];
					document.addEventListener('DOMContentLoaded', function() {
				    	gridOptions = {
				                columnDefs: columnDefs,
				                rowData: [], // 초기 행 데이터를 빈 배열로 설정
				                defaultColDef: { headerComponent: 'CustomHeader' },
				                components: { CustomHeader: CustomHeader },
				                //enableRangeSelection: true, // 범위 선택을 활성화합니다.
				                enableCellTextSelection: true, // 셀 텍스트 선택을 활성화합니다.
				                //clipboard: {
				                //	suppressCopyRowsToClipboard: false, // 복사 기능을 활성화합니다.
				                //},
				                //suppressMovableColumns: false, // 열을 이동할 수 있도록 설정합니다.
				                rowHeight: 35,
				                headerHeight: 35,
				                onGridReady: function(params) {
				                    loadData(params.api); // 그리드가 준비된 후 데이터 로드
				                    //params.api.sizeColumnsToFit();
				                },
								overlayLoadingTemplate: '<span class="ag-overlay-loading-center">Loading...</span>',
								overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">No Data</span>'
				            };
				        const gridDiv = document.querySelector('#myGrid');
				        grid = agGrid.createGrid(gridDiv, gridOptions);

				        // 데이터 로드 함수
				        function loadData(api) {
				        	grid.setGridOption('loading', true);
				            axios.get('/api/conv/conv02701.do').then(function(response) {
			                    grid.setGridOption('rowData', response.data.resultList);  //아래 라인과 동일한 의미
			                    data=response.data.resultList;
			                    document.getElementById('TT_CNT').textContent = currencyFormatter(response.data.resultCnt);
			                })
			                .catch(function(error) {
			                    console.error('There was an error fetching the data:', error);
			                })
			            	.finally(function() {
			            		grid.setGridOption('loading', false);
					        	grid.sizeColumnsToFit();
					        });
				        }
				    });
					function downloadExcel() {
						var titleElement = document.querySelector('p.tit');
			            var title = titleElement.textContent.trim();
						const selectedColumns = ['no', 'nm', 'engNm', 'dob', 'gd', 'pos', 'isMng', 'email', 'phone', 'partStartdt', 'partEnddt','org','dept','partRat'];
						downloadEx(grid,columnDefs,selectedColumns,"PART_LIST",title,true);
					}
				</script>
			</div>
			<div class="rbtn">
				<a href="javascript:goSubPage('/conv/conv02410.do')" class="btn detail">전체보기</a>
			</div>
			<br/>
		</form>
	</div>
</body>
</html>