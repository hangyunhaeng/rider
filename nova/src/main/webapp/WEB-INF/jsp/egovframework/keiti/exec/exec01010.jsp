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
	</script>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopMenu.jsp" />
	<div class="keit-header-body innerwrap clearfix">
		<p class="tit"> 집행 정보 조회</p>
		<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopTaskCard.jsp" />
		<h4 class="tit"> 집행 정보 조회
			<span class="convdate" ></span>
		</h4>
		<form name="form1" method="post" id="form1">
			<input name="pageUnit" type="hidden" value="10000000"/>
			<input name="pageSize" type="hidden" value="10000000"/>
			<input name="srcOrderBy" type="hidden" value="EXEC_TP_${taskVo.execTp}"/>
			<table>
				<colgroup>
				<col style="width:10%">
				<col style="width:23%">
				<col style="width:10%">
				<col style="width:23%">
				<col style="width:10%">
				<col style="width:24%">
				</colgroup>
				<tr>
					<th>등록일자 </th>
					<td colspan="5">
						<div class="period">
						  <input type="text" name="srcSRgDt" id="srcSRgDt" value="" class="date" onkeyup="javascript:dateFormat(this);" onclick="fnFpCalendar(this);" autocomplete="off"/>
						  <a href="javascript:void(0);" onclick="fnFpCalendar(form1.srcSRgDt)" class="ic_cal">시작일 선택</a> ~
						  <input type="text" name="srcERgDt" id="srcERgDt" value="" class="date"  onkeyup="javascript:dateFormat(this);" onclick="fnFpCalendar(this);" autocomplete="off"/>
						  <a href="javascript:void(0);" onclick="fnFpCalendar(form1.srcERgDt)" class="ic_cal mr5">종료일 선택</a>
						  <a href="javascript:dateCalc(0, 0, 7, form1.srcSRgDt, form1.srcERgDt);" onclick="javascript:dateCalClick(this, 'dc1');" class='first' id="dc1">1주일</a>
						  <a href="javascript:dateCalc(0, 1, 0, form1.srcSRgDt, form1.srcERgDt);" onclick="javascript:dateCalClick(this, 'dc1');" id="dc2">1개월</a>
						  <a href="javascript:dateCalc(0, 3, 0, form1.srcSRgDt, form1.srcERgDt);" onclick="javascript:dateCalClick(this, 'dc1');" id="dc3">3개월</a>
						  <a href="javascript:dateCalc(0, 6, 0, form1.srcSRgDt, form1.srcERgDt);" onclick="javascript:dateCalClick(this, 'dc1');" id="dc4">6개월</a>
						  <a href="javascript:dateCalc(1, 0, 0, form1.srcSRgDt, form1.srcERgDt);" onclick="javascript:dateCalClick(this, 'dc1');" id="dc5">1년</a><em>*당일기준</em>
					  </div>
					</td>
				</tr>
				<tr>
					<th>지급일자</th>
					<td colspan="3">
						<div class="period">
						  <input type="text" name="srcSTrnsDt" id="srcSTrnsDt" value="" class="date"  onkeyup="javascript:dateFormat(this);" onclick="fnFpCalendar(this);" autocomplete="off" />
						  <a href="javascript:fnFpCalendar(form1.srcSTrnsDt)" class="ic_cal">시작일 선택</a> ~
						  <input type="text" name="srcETrnsDt" id="srcETrnsDt" value="" class="date"  onkeyup="javascript:dateFormat(this);" onclick="fnFpCalendar(this);" autocomplete="off"/>
						  <a href="javascript:fnFpCalendar(form1.srcETrnsDt)" class="ic_cal mr5">종료일 선택</a>
					      <a href="javascript:dateCalc(0, 0, 7, form1.srcSTrnsDt, form1.srcETrnsDt);" onclick="javascript:dateCalClick(this, 'dc11');" class='first' id="dc11">1주일</a>
					      <a href="javascript:dateCalc(0, 1, 0, form1.srcSTrnsDt, form1.srcETrnsDt);" onclick="javascript:dateCalClick(this, 'dc11');" id="dc12">1개월</a>
					      <a href="javascript:dateCalc(0, 3, 0, form1.srcSTrnsDt, form1.srcETrnsDt);" onclick="javascript:dateCalClick(this, 'dc11');" id="dc13">3개월</a>
					      <a href="javascript:dateCalc(0, 6, 0, form1.srcSTrnsDt, form1.srcETrnsDt);" onclick="javascript:dateCalClick(this, 'dc11');" id="dc14">6개월</a>
					      <a href="javascript:dateCalc(1, 0, 0, form1.srcSTrnsDt, form1.srcETrnsDt);" onclick="javascript:dateCalClick(this, 'dc11');" id="dc15">1년</a><em>*당일기준</em>
					  </div>
					</td>
					<th>집행방법</th>
					<td>
			            <select name='srcExecMtd' style='width:50%' id='srcExecMtd'></select>
					</td>
				</tr>
				<tr>
					<th>비목</th>
					<td>
			           <select name="srcIoeCd" style="width: 50%" id="srcIoeCd"></select>
					</td>
					<th>
						기타
					</th>
					<td>
						<select name='srcOpt' class='w100' id='srcOpt'>
								<option value=''>전체</option>
								<option value='03'>금액</option>
						</select>
			           	<input id="srcOptValue" name="srcOptValue" type=text value="" size='30'>
					</td>
					<th>승인상태</th>
					<td>
						<select name='srcSts' style='width:50%' id='srcSts'></select>
					</td>
				</tr>
			</table>
			<div class="rbtn">
				<a href="javascript:downloadExcel();" class="btn exceldown">엑셀 다운로드</a>
				<a href="javascript:exec04040()" class="btn ty2">공통서류</a>
				<a href="javascript:goRefresh()" class="btn ty2">초기화</a>
				<span id="btnSearch"><button id="loadDataBtn" class="btn ty1">검색</button></span>

			</div>

			<span class="pagetotal">
				Total <em id="TT_CNT"></em>&nbsp;
			</span>

			<div id="loadingOverlay" style="display: none;">Loading...</div>
			<div  class="ib_product">
				<div id="myGrid" class="ag-theme-alpine" style="height: 450px; width: 100%;"></div>
			</div>
			<!-- AG Grid JavaScript -->
			<script>
				let gridOptions="";
				var grid="";
				let data;
				var columnDefs = [
					{ headerName: "NO", field: "no", minWidth: 70 },
					{ headerName: "등록일", field: "rgDt", minWidth: 100, valueFormatter: dateFormatter},
					{ headerName: "집행일", field: "execDt", minWidth: 100, valueFormatter: dateFormatter},
					{ headerName: "지급일", field: "trnsDt", minWidth: 100, valueFormatter: dateFormatter },
					{ headerName: "사용내역", field: "rmk", minWidth: 230, cellClass: 'ag-cell-left' },
					{ headerName: "진행상태", field: "sts", minWidth: 95, valueFormatter: execStsFormatter },
					{ headerName: "집행방법", field: "execMtd", minWidth: 110, valueFormatter: execMtdFormatter },
					{ headerName: "세목", field: "ioeCd", minWidth: 150, valueFormatter: ioeCdFormatter, cellClass: 'ag-cell-left' },
					{ headerName: "지급금액", field: "trnsAmt", minWidth: 120, valueFormatter: currencyFormatter , cellClass: 'ag-cell-right'}, //
					{ headerName: "사용금액", field: "execAmt", minWidth: 120, valueFormatter: currencyFormatter , cellClass: 'ag-cell-right'}, //
					{ headerName: "부가세", field: "vat", minWidth: 80, valueFormatter: currencyFormatter, cellClass: 'ag-cell-right'}, //
					{ headerName: "정산증빙", field: "stlKey", minWidth: 80, cellRenderer: stlKeyRenderer },
					{ headerName: "세금계산서", field: "issueId", minWidth: 80, cellRenderer: taxKeyRenderer },
					{ headerName: "가맹점", field: "mct", minWidth: 80, cellClass: 'ag-cell-left' },
					{ headerName: "집행고유번호", field: "matchId", minWidth: 150, context: { isString: true } }
				];
				document.addEventListener('DOMContentLoaded', function() {
					initializeSrcOpt();
				    //srcSRgDt.value = getCurrentDate(-7); // 7일 전 날짜로 설정
				    //srcERgDt.value = getCurrentDate(); // 현재 날짜로 설정
					gridOptions = {
							columnDefs: columnDefs,
							rowData: [], // 초기 행 데이터를 빈 배열로 설정
							defaultColDef: { headerComponent: 'CustomHeader' },
							components: { CustomHeader: CustomHeader },
							enableCellTextSelection: true, // 셀 텍스트 선택을 활성화합니다.
							rowHeight: 35,
							headerHeight: 35,
							onGridReady: function(params) {
								loadData(params.api); // 그리드가 준비된 후 데이터 로드
								params.api.sizeColumnsToFit();
							},
							overlayNoQueryTemplate: '<span class="ag-overlay-loading-center">조회하지 않았습니다</span>',
							overlayLoadingTemplate: '<span class="ag-overlay-loading-center">로딩 중</span>',
							overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>'
						};
					const gridDiv = document.querySelector('#myGrid');
					grid = agGrid.createGrid(gridDiv, gridOptions);

					// 초기 데이터 로드 및 select 요소 채우기
					populateSelectOptions('srcIoeCd', ioeCdMapping, '');
					populateSelectOptions('srcExecMtd', execMtdMapping,'');
					populateSelectOptions('srcSts', execStsMapping,'');

					 // 조건에 따라 컬럼의 가시성 설정
				    if ('${taskVo.execTp}' =='1') {
				    	grid.setColumnVisible('trnsAmt', true);  // 'address' 컬럼을 보이도록 설정
				    } else {
				    	grid.setColumnVisible('trnsAmt', false); // 'address' 컬럼을 숨김
				    }

					//loadData(params.api);

					// 데이터 로드 함수
					function loadData(api) {
					    grid.setGridOption('loading', true);

					    // 폼 데이터 가져오기
					    var form = document.getElementById('form1');
					    var formData = new FormData(form);

					    var dateFields = ['srcSRgDt', 'srcERgDt', 'srcSTrnsDt', 'srcETrnsDt'];

					    // URLSearchParams 객체 생성 (URL 인코딩된 폼 데이터로 변환)
					    var params = new URLSearchParams();

					    // srcOptValue가 이미 처리되었는지 확인하는 플래그
					    var srcOptValueHandled = false;

					    formData.forEach(function(value, key) {
					        if (key === 'srcOpt' && value === '03') {
					            // srcOpt의 value가 '03'일 때 srcOptValue 처리
					            var srcOptValue = formData.get('srcOptValue');
					            if (srcOptValue) {
					                var modifiedValue = srcOptValue.replace(/,/g, '');
					                params.append('srcOptValue', modifiedValue);
					                srcOptValueHandled = true; // srcOptValue가 처리됨을 표시
					            }
					            params.append(key, value);
					        } else if (dateFields.includes(key)) {
					            params.append(key, formatToYYYYMMDD(value));
					        } else if (key !== 'srcOptValue' || !srcOptValueHandled) {
					            // srcOptValue가 이미 처리된 경우, 다시 추가하지 않음
					            params.append(key, value);
					        }
					    });

					    axios.post('/api/exec/exec01001.do', params).then(function(response) {
					        grid.setGridOption('rowData', response.data.resultList); // 아래 라인과 동일한 의미
					        data = response.data.resultList;
					        document.getElementById('TT_CNT').textContent = currencyFormatter(response.data.resultCnt);
					    })
					    .catch(function(error) {
					        console.error('There was an error fetching the data:', error);
					    })
					    .finally(function() {
					        grid.setGridOption('loading', false);
					    });
					}

					// 조회 버튼 클릭 시 데이터 다시 로드
					document.getElementById('loadDataBtn').addEventListener('click', function(event) {
					    event.preventDefault(); // 버튼의 기본 동작(폼 제출 등)을 막음
					    const api = "";
					    loadData(api);
					});
				});

				function downloadExcel() {
					var titleElement = document.querySelector('p.tit');
		            var title = titleElement.textContent.trim();
					const selectedColumns = ['no','rgDt', 'trnsDt', 'rmk', 'sts', 'execMtd', 'ioeCd', 'trnsAmt','execAmt', 'vat','matchId'];
					downloadEx(grid,columnDefs,selectedColumns,"EXEC",title,true);
				}

				// 세금계산서 cellRenderer
				function taxKeyRenderer(params) {
					if (params.value) {
						// 데이터가 있는 경우 링크로 표시
						return '<a href="javascript:exec04020(\''+params.value+'\')">등록&nbsp;&nbsp;<img src="/web2/images/popup.gif"/></a>';
					} else {
						// 데이터가 없는 경우 "없음" 표시
						return "미등록";
					}
				}
				// 정산증빙 cellRenderer
				function stlKeyRenderer(params) {
					if (params.value) {
						// 데이터가 있는 경우 링크로 표시
						return '<a href="javascript:exec04030(\''+params.value+'\')">등록&nbsp;&nbsp;<img src="/web2/images/popup.gif"/></a>';
					} else {
						// 데이터가 없는 경우 "없음" 표시
						return "미등록";
					}
				}
				// 공통서류 cellRenderer
				function commonDocumentRenderer(params) {
					if (params.value) {
						// 데이터가 있는 경우 링크로 표시
						return '<a href="javascript:exec04030(\''+params.value+'\')">등록&nbsp;&nbsp;<img src="/web2/images/popup.gif"/></a>';
					} else {
						// 데이터가 없는 경우 "없음" 표시
						return "미등록";
					}
				}

				// 세금계산서 팝업창 띄우기
				function exec04020(key) {
					var form = document.form1;
					window.open('','exec04020','height=540,width=850,top=50,left=50,scrollbars=yes,menubar=no,resizable=yes,location=no');
					form.target = "exec04020";
					form.action = "/exec/exec04020.do?issueId="+key;
			        form.submit();
				}
				// 정산증빙 팝업창 띄우기
				function exec04030(key) {
					var form = document.form1;
					window.open('','exec04030','height=700,width=850,top=50,left=50,scrollbars=yes,menubar=no,resizable=yes,location=no');
					form.target = "exec04030";
					form.action = "/exec/exec04030.do?execNo="+key;
			        form.submit();
				}
				// 정산증빙 팝업창 띄우기
				function exec04040() {
					var form = document.form1;
					window.open('','exec04040','height=700,width=850,top=50,left=50,scrollbars=yes,menubar=no,resizable=yes,location=no');
					form.target = "exec04040";
					form.action = "/exec/exec04040.do";
			        form.submit();
				}
				function goRefresh() {
					var form = document.forms['form1'];

				    // 텍스트 입력 필드 초기화
				    form.srcSRgDt.value = '';
				    form.srcERgDt.value = '';
				    form.srcSTrnsDt.value = '';
				    form.srcETrnsDt.value = '';
					form.srcOpt.value = '';
					form.srcOptValue.disabled = true;
				 	form.srcExecMtd.value = '';
				    form.srcIoeCd.value = '';
				    form.srcSts.value = '';
					//document.getElementById("TT_CNT").innerHTML = "0";
				}
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
			</script>
		</form>
	</div>
</body>
</html>