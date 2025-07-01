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
  	.ag-sticky-bottom {    display: none !important;  }
	</style>
</head>
	<script type="text/javaScript">
		parent.frames["_top"].location.reload();
		// 서버에서 데이터를 가져와 셀렉트 박스에 옵션을 추가하는 함수
		function initializeSrcOpt() {
			const srcOpt = document.getElementById('srcOpt');
			const srcOptValue = document.getElementById('srcOptValue');

			srcOpt.addEventListener('change', function() {
				if (this.value === '') {
					srcOptValue.value = '';
					srcOptValue.disabled = true;
				} else {
					srcOptValue.disabled = false;
				}
			});

			// 초기 로드 시 선택된 값에 따라 입력 필드의 상태를 설정합니다.
			if (srcOpt.value === '') {
				srcOptValue.disabled = true;
			}
		}

		function goRefresh() {
			var form = document.forms['form1'];

			form.srcTaskYr.value ='';
			form.srcTaskSt.value ='';
			form.srcTaskTp.value ='RL_TASK_C';
			form.srcOpt.value ='';
			form.srcExecTp.value ='';
			form.srcOptValue.value = '';
			form.srcOptValue.disabled = true;
			form.srcStartdt.value = '';
			form.srcEnddt.value = '';
			form.srcBizCd.selectedIndex = 0;
			form.srcChildBizCd.selectedIndex = 0;

		}
		document.addEventListener('DOMContentLoaded', function() {
			//loadSelectBizOptions(); // 페이지 로드 시 옵션을 로드
			initializeSrcOpt();
			// 'tit' 클래스를 가진 첫 번째 'p' 요소를 찾습니다.
            var titleElement = document.querySelector('p.tit');

            // 요소가 존재하면 텍스트 콘텐츠를 콘솔에 출력합니다.
            if (titleElement) {
                console.log(titleElement.textContent.trim());
            } else {
                console.log('해당 요소를 찾을 수 없습니다.');
            }
		});

		// <select> 값 변경 시 호출되는 이벤트 핸들러
		function onBizCdChange(event) {
		    const selectedKey = event.target.value; // 선택된 key 값을 가져옴
		    populateSelectOptions('srcChildBizCd', bizCdMapping, selectedKey);
		}
	</script>
<body>
	<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopMenu.jsp" />
	<!-- 숨겨진 폼 -->
	<form id="myForm" action="/conv/conv02410.do" method="POST" style="display: none;">
		<!-- <input type="hidden" name=taskNo id="taskNo"> -->
	</form>
	<div class="keit-header-body innerwrap clearfix">
		<p class="tit">협약과제목록</p>

		<form name="form1" METHOD="post" id="form1">
			<input name="pageUnit" type="hidden" value="1000"/>
			<input name="pageSize" type="hidden" value="1000"/>
			<!--과제관리_목록 -->
			<div class="search_box ty2">
				<table>
					<colgroup>
						<col style="width: 13%">
						<col style="width: 17%">
						<col style="width: 13%">
						<col style="width: 13%">
						<col style="width: 13%">
						<col style="width: *">
					</colgroup>
					<tr>
						<th>과제구분</th>
						<td><select name="srcTaskTp" style="width: 100%" id="srcTaskTp">
						</select></td>
						<th>과제검색</th>
						<td colspan="5">
							<select name='srcOpt' class='w100' id='srcOpt'>
								<option value=''>전체</option>
								<option value='01'>과제번호</option>
								<option value='02'>과제명</option>
								<option value='03'>기관명</option>
								<option value='04'>책임자명</option>
							</select>
							<input id="srcOptValue" name="srcOptValue" type=text value="" size='30'>
						</td>
					</tr>
					<tr>
						<th>과제상태</th>
						<td>
							<select name='srcTaskSt' style='width: 100%' id='srcTaskSt'>
							</select>
						</td>
						<th>협약년도</th>
						<td><select name='srcTaskYr' style='width: 100%' id='srcTaskYr'>
							</select>
						</td>
						<th>당해년도 시작일자</th>
						<td>
							<div class="period">
						  		<input type="text" name="srcStartdt" id="srcStartdt" value="" class="date"  onkeyup="javascript:dateFormat(this);" onclick="fnFpCalendar(this);" autocomplete="off" />
								<a href="javascript:void(0);" onclick="fnFpCalendar(form1.srcStartdt)" class="ic_cal">시작일 선택</a> ~
								<input type="text" name="srcEnddt" id="srcEnddt" value="" class="date"  onkeyup="javascript:dateFormat(this);" onclick="fnFpCalendar(this);" autocomplete="off" />
								<a href="javascript:void(0);" onclick="fnFpCalendar(form1.srcEnddt)" class="ic_cal mr5">종료일 선택</a>
						  	</div>
						</td>
					</tr>
					<tr>
						<th>사업명</th>
						<td colspan="3">
							<select name='srcBizCd' style='width: 49%' id='srcBizCd'>
							</select>
							<select name='srcChildBizCd' style='width: 49%' id='srcChildBizCd'>
								<option value=''>전체</option>
							</select>
						</td>
						<th>집행유형</th>
						<td>
							<select name='srcExecTp' style='width: 100%' id='srcExecTp'></select>
						</td>
					</tr>
					<tr>

					</tr>
				</table>

				<div class="btnwrap">
					<!-- <a href="javascript:loadData(grid)" class="btn ty1">검색</a> -->
					<a href="javascript:downloadExcel()" class="btn_tb excel_dw">엑셀다운로드</a>
					<a href="javascript:goRefresh()" class="btn ty2">초기화</a>
					<button id="loadDataBtn" class="btn ty1">조회</button>
				</div>

			<!-- grid  -->
			<div style="height: 0px;" >
				<span class="pagetotal">Total <em id="TT_CNT"></em></span>
			</div>

			<br>
			<div id="loadingOverlay" style="display: none;">Loading...</div>
			<div  class="ib_product">
				<div id="myGrid" class="ag-theme-alpine" style="height: 550px; width: 100%;"></div>
			</div>
			</div>
		</form>

		<!-- AG Grid JavaScript -->
	<script>
		let gridOptions="";
		var grid="";
		let data;
		var columnDefs= [
			//{ headerName: "NO", valueGetter: "node.rowIndex + 1",width: 50 },
			{ headerName: "NO", field: "no", minWidth: 70 },
			{ headerName: "과제고유번호", field: "taskNo", minWidth: 200, valueFormatter: taskNoFormatter,
		        cellRenderer: function(params) {
		        	var taskNo = params.data.taskNo;
		        	return '<a href="javascript:conv02410(\'' + taskNo + '\')" class="task-link">' + taskNoFormatter(params.value) + '</a>';
		        }
			},  //, cellClass: 'ag-cell-left'
			{ headerName: "과제명", field: "taskNm", minWidth: 350, cellClass: 'ag-cell-left',
		        cellRenderer: function(params) {
		        	var taskNo = params.data.taskNo;
		        	return '<a href="javascript:conv02410(\'' + taskNo + '\')" class="task-link">' + params.value + '</a>';
		        }
			},
			{ headerName: "기관명", field: "instNm", minWidth: 200, cellClass: 'ag-cell-left',
		        cellRenderer: function(params) {
		        	var taskNo = params.data.taskNo;
		        	return '<a href="javascript:conv02410(\'' + taskNo + '\')" class="task-link">' + params.value + '</a>';
		        }
			},
			{ headerName: "책임자명", field: "mnrNm", minWidth: 50 },
			{ headerName: "과제상태", field: "taskSt", minWidth: 150, valueFormatter: taskStatusFormatter, cellClass: 'ag-cell-left' },
			{ headerName: "사업명", field: "bizNm", minWidth: 230, cellClass: 'ag-cell-left' },
			{ headerName: "중분야", field: "subFd", minWidth: 120, cellClass: 'ag-cell-left' },
			{ headerName: "정산기관", field: "stlAgc", minWidth: 50 }
		];
		// 사용자 정의 컴포넌트를 글로벌 네임스페이스에 추가
		window.CustomHeader = CustomHeader;
		document.addEventListener('DOMContentLoaded', function() {

	    	gridOptions = {
	                columnDefs: columnDefs,
	                rowData: [], // 초기 행 데이터를 빈 배열로 설정
	                defaultColDef: { headerComponent: 'CustomHeader'}, //
	                components: { CustomHeader: CustomHeader },
	                enableCellTextSelection: true, // 셀 텍스트 선택을 활성화합니다.
	                rowHeight: 35,
	                headerHeight: 35,
	                suppressHorizontalScroll: true,
	                /*onCellDoubleClicked: function(event) {
	                    var rowData = event.data;
	                   	//document.getElementById('taskNo').value = rowData.taskNo;
	                   	var elements = document.getElementsByName('taskNo');
	                   	elements[0].value = rowData.taskNo;
	                    //document.getElementById('myForm').submit();
	                    goSubPage('/conv/conv02410.do');
	                },*/
	                onGridReady: function(params) {
	                    //loadData(params.api); // 그리드가 준비된 후 데이터 로드
	                    params.api.sizeColumnsToFit();
	                },

					overlayLoadingTemplate: '<span class="ag-overlay-loading-center">로딩 중</span>',
					overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>'
	            };
	        const gridDiv = document.querySelector('#myGrid');
	        grid = agGrid.createGrid(gridDiv, gridOptions);

	        populateSelectOptions('srcTaskTp', taskTpMapping,'RL_TASK_C');
	        populateSelectOptions('srcTaskSt', taskStMapping,'');
	        populateSelectOptions('srcTaskYr', taskYrMapping,'');
	        populateSelectOptions('srcExecTp', execTpMapping,'');
	        populateSelectOptions('srcBizCd', bizCdMapping,'');

	        // 데이터 로드 함수
	        function loadData(api) {
	        	grid.setGridOption('loading', true);
	        	// 폼 데이터 가져오기
			    var form = document.getElementById('form1');
			    var formData = new FormData(form);

			    var srcStartdt = document.getElementById('srcStartdt').value;
			    var srcEnddt = document.getElementById('srcEnddt').value;

			    // YYYY-MM-DD 형식을 YYYYMMDD 형식으로 변환
			    var formattedStartdt = formatToYYYYMMDD(srcStartdt);
			    var formattedEnddt = formatToYYYYMMDD(srcEnddt);

			    // URLSearchParams 객체 생성 (URL 인코딩된 폼 데이터로 변환)
			    var params = new URLSearchParams();
			    formData.forEach(function(value, key) {
					if (key === 'srcStartdt') {
					    params.append(key, formattedStartdt);
					} else if (key === 'srcEnddt') {
					    params.append(key, formattedEnddt);
					} else {
					    params.append(key, value);
					}
			    });

	            axios.post('/api/comm/comm00801.do',params).then(function(response) {
		            	if (response.data.resultList.length === 0) {
		            		grid.setGridOption('rowData',[]);  // 데이터가 없는 경우 빈 배열 설정
		            		grid.showNoRowsOverlay();  // 데이터가 없는 경우
		                   // grid.setGridOption('noRowsOverlay', true);  //데이터가 없는 경우
//		                    gridOptions.api.setGridOption('noRowsOverlay', true); // 데이터가 없는 경우
		                } else {
		                    grid.setGridOption('rowData', response.data.resultList);  //아래 라인과 동일한 의미
//		                    gridOptions.api.setGridOption('rowData', response.data.resultList); // 데이터가 있는 경우
		                }
	                    data=response.data.resultList;
	                    document.getElementById('TT_CNT').textContent = currencyFormatter(response.data.resultCnt);
	                })
	                .catch(function(error) {
	                    console.error('There was an error fetching the data:', error);
	                }).finally(function() {
			        	//grid.hideOverlay();
			        	grid.setGridOption('loading', false);
			        });
	        }

	        // 조회 버튼 클릭 시 데이터 다시 로드

	        document.getElementById('loadDataBtn').addEventListener('click', function() {
	            event.preventDefault(); // 버튼의 기본 동작(폼 제출 등)을 막음
	            const api="";
	            loadData(api);
	        });
	        grid.hideOverlay();

	     	// <select> 요소에 change 이벤트 리스너 추가
			document.getElementById('srcBizCd').addEventListener('change', onBizCdChange);

	    });
		function conv02410(taskNo){
           	var elements = document.getElementsByName('taskNo');
           	elements[0].value = taskNo;
            goSubPage('/conv/conv02410.do');
        }
		function downloadExcel() {
			var titleElement = document.querySelector('p.tit');
            var title = titleElement.textContent.trim();
			const selectedColumns = ["taskNo", "taskNm", "instNm", "mnrNm", "taskSt", "bizNm", "subFd", "stlAgc"];
			downloadEx(grid,columnDefs,selectedColumns,"TASK_LIST",title,false);
		}
	</script>
	<!-- grid //-->
	</div>
</body>
</html>