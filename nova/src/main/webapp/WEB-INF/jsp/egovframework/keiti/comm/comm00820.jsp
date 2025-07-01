<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko" style="overflow:hidden;">
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
				<h1>협약과제목록팝업</h1>
				<a href="javascript:window.close()" class="close" onclick="javascript:window.close();"></a>
				<section class="cont">
					<script>
					    function goRefresh() {
					    	var form = document.forms['form1'];
							form.srcBizCd.selectedIndex = 0;
							form.srcChildBizCd.selectedIndex = 0;
				            form.srcTaskNo.value = '';
							form.srcTaskNm.value ='';
							form.srcMnrNm.value ='';
							form.srcInstNm.value ='';

					    }
					</script>

					<div id="topdeck" onmouseover="this.style.visibility='visible'"
						onMouseOut="kill()" style="position: absolute; left:460px; top:470px; width:30px; height:300px; z-index:1; visibility:	hidden " CLASS="popper"></div>

					<script>
						var nav = (document.layers);
						var iex = (document.all);
						var skn = (nav) ? document.topdeck : topdeck.style;
						var x, y;
						if (nav) {
							document.captureEvents(Event.MOUSEMOVE);
						}
					</script>

					<form id="form1" name="form1" method="post">
						<input name="pageUnit" type="hidden" value="1000"/>
						<input name="pageSize" type="hidden" value="1000"/>
					<!--과제관리_목록 -->
						<div class="search_box ty2">
							<table>
								<colgroup>
									<col style="width:15%">
									<col style="width:35%">
									<col style="width:15%">
									<col style="width:35%">
								</colgroup>

								<tr>
									<th>사업명</th>
									<td colspan='3'>
										<select name='srcBizCd' style='width: 49%' id='srcBizCd'><option></option> </select>
										<select name='srcChildBizCd' style='width: 49%' id='srcChildBizCd'><option value=''>전체</option> </select>
									</td>
								</tr>
								<tr>
									<th>과제번호</th>
									<td>
										<input id="srcTaskNo" name="srcTaskNo" type="text" value="">
									</td>
									<th>과제명</th>
									<td>
										<input id="srcTaskNm" name="srcTaskNm" type="text" value="">
									</td>
								</tr>
								<tr>
									<th>책임자명</th>
									<td>
										<input id="srcMnrNm" name="srcMnrNm" type="text" value="">
									</td>
									<th>기관명</th>
									<td>
										<input id="srcInstNm" name="srcInstNm" type="text" value="">
									</td>
								</tr>
							</table>
							<div class="btnwrap">
								<a href="javascript:goRefresh()" class="btn ty2">초기화</a>
								<button id="loadDataBtn" class="btn ty1">조회</button>
							</div>
						</div>

						<!-- grid  -->
						<span class="pagetotal" style="margin-bottom:-10px;">Total <em id="TT_CNT"></em></span>
						<div  class="ib_product">
							<script type="text/javascript">
							</script>
					    </div>
					    <!-- grid //-->
					</form>
				</section>
		</div>
		<div id="myGrid" class="ag-theme-alpine" style="height: 500px; width: 100%;padding:1px;"></div>
	<script>
		let gridOptions="";
		let grid="";
		let data;
		document.addEventListener('DOMContentLoaded', function() {
	    	gridOptions = {
	                columnDefs: [
	                    { headerName: "협약<br>년도", field: "taskYr", minWidth: 70, width: 70 },
	                    { headerName: "과제고유번호", field: "taskNo", minWidth: 200, width: 200, valueFormatter: taskNoFormatter,
	        		        cellRenderer: function(params) {
	        		        	var taskNo = params.data.taskNo;
	        		        	return '<a href="javascript:conv02401(\'' + taskNo + '\')" class="task-link">' + taskNoFormatter(params.value) + '</a>';
	        		        }
	                    },
	                    { headerName: "과제명", field: "taskNm", minWidth: 250, width: 260,
	        		        cellRenderer: function(params) {
	        		        	var taskNo = params.data.taskNo;
	        		        	return '<a href="javascript:conv02401(\'' + taskNo + '\')" class="task-link">' + params.value + '</a>';
	        		        }
	                    },
	                    { headerName: "기관명", field: "instNm", minWidth: 100, width: 105,
	        		        cellRenderer: function(params) {
	        		        	var taskNo = params.data.taskNo;
	        		        	return '<a href="javascript:conv02401(\'' + taskNo + '\')" class="task-link">' + params.value + '</a>';
	        		        }
	                    },
	                    { headerName: "책임자명", field: "mnrNm", minWidth: 100, width: 105 },
	                    { headerName: "사업명", field: "bizNm", minWidth: 130, width: 140 }
	                ],
	                rowData: [], // 초기 행 데이터를 빈 배열로 설정
	                defaultColDef: { headerComponent: 'CustomHeader' },
	                components: { CustomHeader: CustomHeader },
	                enableCellTextSelection: true, // 셀 텍스트 선택을 활성화합니다.
	                rowHeight: 35,
	                headerHeight: 35,
	                suppressHorizontalScroll: true,
	                onCellDoubleClicked: function(event) {
	                    // 행 데이터 가져오기
	                    var rowData = event.data;
	                    //alert('Double clicked on: ' + rowData.taskNo);
	                    axios.post('${pageContext.request.contextPath}/api/conv/conv02401.do', {
	                    	taskNo: rowData.taskNo
	                    })
	                    .then(function(response) {
	                        // 성공적으로 응답을 받은 경우
	                        opener.pop00820End(rowData.taskNo);
	                    })
	                    .catch(function(error) {
	                        // 에러가 발생한 경우
	                        alert("err : " + error);
	                    });
	                },
	                onGridReady: function(params) {
	                    //loadData(params.api); // 그리드가 준비된 후 데이터 로드
	                    params.api.sizeColumnsToFit();
	                },
					overlayLoadingTemplate: '<span class="ag-overlay-loading-center">Loading...</span>',
					overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">No Data</span>'
	            };
	        const gridDiv = document.querySelector('#myGrid');
	        grid = agGrid.createGrid(gridDiv, gridOptions);

	        populateSelectOptions('srcBizCd', bizCdMapping,'');
	        //populateSelectOptions('srcTaskSt', taskStMapping,'');
	        //populateSelectOptions('srcTaskYr', taskYrMapping,'');

	        // 데이터 로드 함수
	        function loadData(api) {

	        	grid.setGridOption('loading', true);
	        	// 폼 데이터 가져오기
			    var form = document.getElementById('form1');
			    var formData = new FormData(form);

			    // URLSearchParams 객체 생성 (URL 인코딩된 폼 데이터로 변환)
			    var params = new URLSearchParams();
			    formData.forEach(function(value, key) {
			    	if (key === "srcTaskNo") {
			            // '-' 제거 후 값을 params에 추가
			            params.append(key, value.replace(/-/g, ""));
			        } else {
			            // 다른 값은 그대로 추가
			            params.append(key, value);
			        }
			    });

	            axios.post('/api/comm/comm00801.do',params).then(function(response) {
	            	if (response.data.resultList.length === 0) {
	            		grid.setGridOption('rowData',[]);  // 데이터가 없는 경우 빈 배열 설정
	            		grid.showNoRowsOverlay();  // 데이터가 없는 경우
	                } else {
	                    grid.setGridOption('rowData', response.data.resultList);  //아래 라인과 동일한 의미
	                }
                    data=response.data.resultList;
                    document.getElementById('TT_CNT').textContent = response.data.resultCnt;
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
	        grid.setGridOption('loading', false);
	        //grid.hideOverlay();

	     	// <select> 요소에 change 이벤트 리스너 추가
			document.getElementById('srcBizCd').addEventListener('change', onBizCdChange);
	    });

		// <select> 값 변경 시 호출되는 이벤트 핸들러
		function onBizCdChange(event) {
		    const selectedKey = event.target.value; // 선택된 key 값을 가져옴
		    populateSelectOptions('srcChildBizCd', bizCdMapping, selectedKey);
		}
		function conv02401(taskNo){
            axios.post('${pageContext.request.contextPath}/api/conv/conv02401.do', {
            	taskNo: taskNo
            })
            .then(function(response) {
                // 성공적으로 응답을 받은 경우
                opener.pop00820End(taskNo);
            })
            .catch(function(error) {
                // 에러가 발생한 경우
                alert("err : " + error);
            });
		}
    </script>
</body>
</html>