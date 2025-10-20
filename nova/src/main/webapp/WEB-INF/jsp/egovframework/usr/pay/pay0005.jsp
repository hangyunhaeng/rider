<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../inc/header.jsp" />
</head>
	<script type="text/javaScript">


	var pageInit = true;
	var pagePerCnt = 15;
	let gridOptions="";
	var grid="";
	let data;
	var columnDefs= [
		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "오류", field: "err", minWidth: 120, hide:true},
		{ headerName: "etcId", field: "etcId", minWidth: 120, hide:true},
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120},
		{ headerName: "협력사명", field: "cooperatorNm", minWidth: 120},
		{ headerName: "라이더ID", field: "mberId", minWidth: 90},
		{ headerName: "라이더명", field: "mberNm", minWidth: 90},
		{ headerName: "구분", field: "gubun", minWidth: 140, hide:true},
		{ headerName: "구분", field: "gubunNm", minWidth: 40
			, valueGetter:(params) => { return (params.node.data.gubun=='D')?"대여": (params.node.data.gubun=='R')?"리스":"기타"}
		},
		{ headerName: "상환시작일", field: "startDt", minWidth: 100
	        , cellClass: (params) => {return agGrideditClass(params)}
	        , valueGetter:(params) => { return getStringDate(params.data.startDt)}
		},
		{ headerName: "상환<br/>기간(일)", field: "paybackDay", minWidth: 100
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.paybackDay);}
		},
		{ headerName: "일별<br/>상환금액", field: "paybackCost", minWidth: 80
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.paybackCost);}
		},
		{ headerName: "총<br/>상환금액", field: "paybackCostAll", minWidth: 80
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.paybackCostAll);}
		},
		{ headerName: "상환<br/>완료금액", field: "finishCost", minWidth: 70
			, cellClass: (params) => {return agGridUnderBarClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.finishCost);}
			, cellRenderer:(params) => { return '<div data-bs-toggle="modal" data-bs-target="#exampleModal" onclick="clickEtc(\''+params.data.etcId+'\')">'+currencyFormatter(params.data.finishCost)+'</div>';}
		},
		{ headerName: "상환<br/>완료여부", field: "finishAt", minWidth: 50},
		{ headerName: "승인요청일", field: "authRequestDt", minWidth: 100, valueGetter:(params) => { return getStringDate(params.data.authRequestDt)}},
		{ headerName: "라이더<br/>승인일", field: "authResponsDt", minWidth: 100, valueGetter:(params) => { return getStringDate(params.data.authResponsDt)}},
		{ headerName: "라이더<br/>승인여부", field: "responsAt", minWidth: 80},
		{ headerName: "등록일", field: "creatDt", minWidth: 100, valueGetter:(params) => { return getStringDate(params.data.creatDt)}}
	];


	var columnDefs2= [
		{ headerName: "crud", field: "crud", minWidth: 90, hide:true},
		{ headerName: "NO", field: "rnum", minWidth: 50, maxWidth: 100 },
		{ headerName: "날짜", field: "day", minWidth: 250, maxWidth: 250, valueGetter:(params) => { return getStringDate(params.data.day)} },
		{ headerName: "상환액", field: "sendPrice", minWidth: 200, maxWidth: 200, cellClass:"ag-cell-right", valueGetter:(params) => { return currencyFormatter(params.data.sendPrice);}},
		{ headerName: "선지급잔액", field: "balance0", minWidth: 100, maxWidth: 150, hide:true, cellClass:"ag-cell-right", valueGetter:(params) => { return nullToString(params.data.msg) == '' ? '-': currencyFormatter(params.data.balance0); }},
		{ headerName: "확정잔액", field: "balance1", minWidth: 100, maxWidth: 150, hide:true, cellClass:"ag-cell-right", valueGetter:(params) => { return nullToString(params.data.msg) == '' ? '-': currencyFormatter(params.data.balance1); }},
		{ headerName: "미상환사유", field: "msg", minWidth: 480, maxWidth: 480 }

	];


	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		//업로드일 세팅
		var today = new Date();
		var now = new Date();
		var towWeekAgo = new Date(now.setDate(now.getDate()-14));
// 		var searchFromDate = flatpickr("#searchFromDate", {
// 			locale: "ko",
// 			allowInput: false,
// 		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
// 		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
// 		    dateFormat: 'Y-m-d',     // date format 형식
// 		    disableMobile: true          // 모바일 지원

// 		});
// 		var searchToDate = flatpickr("#searchToDate", {
// 			"locale": "ko",
// 			allowInput: false,
// 		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
// 		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
// 		    dateFormat: 'Y-m-d',     // date format 형식
// 		    disableMobile: true          // 모바일 지원
// 		});

		// 1. 조회버튼
		$('#loadDataBtn').on("click", function(){
			doSearch(1, paging.objectCnt);
		});

// 		searchFromDate.setDate(towWeekAgo.getFullYear()+"-"+(towWeekAgo.getMonth()+1)+"-"+towWeekAgo.getDate());
// 		searchToDate.setDate(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());

		//페이징설정
		paging.createPaging('#paging', 1, pagePerCnt, doSearch);

		loadCooperatorList();
		//그리드 설정
		setGrid();
		setGrid2();

	});


	//협력사 정보 가져오기 (정산기준 union 협력사 정보)
	function loadCooperatorList(){

		const params = new URLSearchParams();

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0000_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
        	populateSelectOptions('searchCooperatorId', response.data.list,'', {opt:"all"});
        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
        });
	}

	//내역 조회
	function doSearch(schIdx, schPagePerCnt){
		if($('#searchRegistrationSn').val().trim() != '' && $('#searchRegistrationSn').val().trim().length != 10){
			alert("식별번호는 10자리입니다");
			$('#searchRegistrationSn').focus()
			return ;
		}

// 	    if(!limit2Week($('#searchFromDate').val(), $('#searchToDate').val())){
// 	    	return;
// 	    }

		const params = new URLSearchParams();
		params.append('searchCooperatorId', $('#searchCooperatorId').val());
// 		params.append('searchFromDate', getOnlyNumber($('#searchFromDate').val()));
// 		params.append('searchToDate', getOnlyNumber($('#searchToDate').val()));
		params.append('searchNm', $('#searchNm').val().trim());
		params.append('searchRegistrationSn', $('#searchRegistrationSn').val().trim());
		params.append('searchGubun', $('#searchGubun').val());
		params.append("schIdx", schIdx);
		params.append("schPagePerCnt", schPagePerCnt);

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/pay0005_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

			if(response.data.resultCode == "success"){

	            document.getElementById('TT_CNT0').textContent = currencyFormatter(response.data.cnt);

	        	if (response.data.list.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {
					var lst = response.data.list;	//정상데이터
	                grid.setGridOption('rowData', lst);
	            }
	        	paging.setPageing(schIdx, response.data.cnt);
			}

        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
        });
        pageInit = false;
	}


	function clickEtc(etcId){


		const params = new URLSearchParams();
		params.append('etcId', etcId);

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/pay0005_0002.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

			if(response.data.resultCode == "success"){

	        	if (response.data.list.length == 0) {
	        		grid2.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid2.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

	            	data = response.data.list;	//정상데이터
					grid2.setGridOption("rowData", data);
	            }

			}

        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
        });
	}

	function setGrid(){
		// 사용자 정의 컴포넌트를 글로벌 네임스페이스에 추가
		window.CustomHeader = CustomHeader;
    	gridOptions = {
                columnDefs: columnDefs,
                rowData: [], // 초기 행 데이터를 빈 배열로 설정
                defaultColDef: { headerComponent: 'CustomHeader'}, //
                components: { CustomHeader: CustomHeader },
                enableCellTextSelection: true, // 셀 텍스트 선택을 활성화합니다.
                rowHeight: 35,
                headerHeight: 35,
                alwaysShowHorizontalScroll : true,
                alwaysShowVerticalScroll: true,
                onGridReady: function(params) {
                    //loadData(params.api); // 그리드가 준비된 후 데이터 로드
                    params.api.sizeColumnsToFit();
                },
                rowClassRules: {'ag-cell-err ': (params) => { return params.data.err === true; }},
				overlayLoadingTemplate: '<span class="ag-overlay-loading-center">로딩 중</span>',
				overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>',
				onCellClicked : function (event) { //onSelectionChanged  :row가 바뀌었을때 발생하는 이벤트인데 잘 안됨.
			    	selcetRow(event);
			    }
            };
        const gridDiv = document.querySelector('#myGrid');
        grid = agGrid.createGrid(gridDiv, gridOptions);

        grid.hideOverlay();

	}

	function setGrid2(){
		// 사용자 정의 컴포넌트를 글로벌 네임스페이스에 추가
		window.CustomHeader = CustomHeader;
    	gridOptions = {
                columnDefs: columnDefs2,
                rowData: [], // 초기 행 데이터를 빈 배열로 설정
                defaultColDef: { headerComponent: 'CustomHeader'}, //
                components: { CustomHeader: CustomHeader },
                enableCellTextSelection: true, // 셀 텍스트 선택을 활성화합니다.
                rowHeight: 35,
                headerHeight: 35,
                alwaysShowHorizontalScroll : true,
                alwaysShowVerticalScroll: true,
                onGridReady: function(params) {
                    //loadData(params.api); // 그리드가 준비된 후 데이터 로드
                    params.api.sizeColumnsToFit();
                },
                rowClassRules: {'ag-cell-err ': (params) => { return params.data.err === true; }},
				overlayLoadingTemplate: '<span class="ag-overlay-loading-center">로딩 중</span>',
				overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>'
            };
        const gridDiv = document.querySelector('#myGrid2');
        grid2 = agGrid.createGrid(gridDiv, gridOptions);

        grid2.hideOverlay();

	}

	function selcetRow(params){
		if(params.column.colId == "sendPrice"){

			if(params.node.data.dwGubun == 'DAY'){
				if(params.node.data.ioGubun == '1'){
					$('#myForm').attr("action", "/usr/dty0001.do");
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchDate", value:params.node.data.fileDate}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchId", value:params.node.data.dayAtchFileId}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchMberId", value:params.node.data.mberId}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchRunDeDate", value:params.node.data.accountsStDt}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchError", value:"false"}));

					$('#myForm').submit();
				}
			}
			if(params.node.data.dwGubun == 'WEK'){
				if(params.node.data.ioGubun == '1'){
					$('#myForm').attr("action", "/usr/dty0002.do");
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchDate", value:params.node.data.fileDate}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchId", value:params.node.data.wekAtchFileId}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchMberId", value:params.node.data.mberId}));
					$('#myForm').submit();
				}
			}
		}
	}

	function agGridUnderBarClass(params, addClass){
		var pAddClass = (addClass =='undefined')? "" : addClass;
		return pAddClass+" tdul";
	}

	</script>
<body class="index-page">

      <div class="loading-wrap loading-wrap--js" style="display: none;z-index:10000;">
        <div class="loading-spinner loading-spinner--js"></div>
        <p id="loadingMessage">로딩중</p>
      </div>

  <jsp:include page="../inc/nav.jsp" />

	<!-- 숨겨진 폼 -->
	<form id="myForm" action="/conv/conv02410.do" method="POST" style="display: none;">
		<!-- <input type="hidden" name=taskNo id="taskNo"> -->
	</form>

	<div class="keit-header-body innerwrap clearfix">
		<p class="tit">협력사 기타(대여, 리스) 현황</p>

			<input name="pageUnit" type="hidden" value="1000"/>
			<input name="pageSize" type="hidden" value="1000"/>
			<!--과제관리_목록 -->
			<div class="search_box ty2">


			<div class="card-body py-0 scrollbar to-do-list-body">
				<!-- 팝업 -->
                  <div class="modal fade" id="exampleModal" tabindex="-1" style="display: none;" aria-hidden="true">
                    <div class="modal-dialog modal-xl">
                      <div class="modal-content bg-body overflow-hidden">
                        <div class="modal-header justify-content-between px-6 py-5 pe-sm-5 px-md-6 dark__bg-gray-1100">
                          <h3 class="text-body-highlight fw-bolder mb-0">상환 이력</h3>
                          <button style="min-width:50px!important; min-height:50px!important;" class="btn btn-phoenix-secondary btn-icon btn-icon-xl flex-shrink-0" type="button" data-bs-dismiss="modal" aria-label="Close"><svg class="svg-inline--fa fa-xmark" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" data-fa-i2svg=""><path fill="currentColor" d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z"></path></svg></button>
                        </div>
                        <div class="modal-body bg-body-highlight px-6 py-0">
                          <div class="row gx-14">
                            <div class="col-12 border-end-lg">
                              <div class="py-6">
                                <div class="mb-7">

<!-- 									<div style="height: 0px;"> -->
<!-- 										<span class="pagetotal" style='margin-right: 20px;'>협력사 수수료</span> -->
<!-- 									</div> -->
									<div class="ib_product">
										<div id="myGrid2" class="ag-theme-alpine" style="height: 500px; width: 100%;"></div>
									</div>


                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
				<!-- 팝업 end -->
                </div>


				<table>
					<colgroup>
						<col style="width: 13%">
						<col style="width: 37%">
						<col style="width: 13%">
						<col style="width: 37%">
					</colgroup>

					<tr>
						<th>협력사</th>
						<td>
							<select id="searchCooperatorId" name='searchCooperatorId' style='width: 100%'></select>
						</td>
						<th>라이더명</th>
						<td>
							<input id="searchNm" type="text" >
						</td>
					</tr>
					<tr>
						<th>식별번호</th>
						<td>
<!-- 							<input id="searchRegistrationSn" type="text" oninput="this.value = this.value.replace(/[^0-9-]/g, '').replace(/(\..*)\./g, '$1');"> -->
							<input id="searchRegistrationSn" type="text">
						</td>
						<th>상환완료여부</th>
						<td>
							<select id="searchGubun" name='searchGubun' style='width: 100%'>
								<option value="all">전체</option>
								<option value="END">완료</option>
								<option value="ING">진행중</option>
								<option value="NO">미승인</option>
							</select>
						</td>
					</tr>
				</table>

				<div class="btnwrap">
					<button id="loadDataBtn" class="btn ty1">조회</button>

				</div>

			<!-- grid  -->
			<div style="height: 0px;" >
				<span class="pagetotal" style='margin-right:20px;'><em id="TT_CNT0" >0</em>건</span>
			</div>

			<br>
			<div id="loadingOverlay" style="display: none;">Loading...</div>
			<div  class="ib_product">
				<div id="myGrid" class="ag-theme-alpine" style="height: 550px; width: 100%;"></div>
				<div id="paging" class="d-flex align-items-center justify-content-center mt-3"></div>
			</div>
			</div>

	</div>


  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>



  <!-- Vendor JS Files -->
  <script src="<c:url value='/vendor/admin/aos/aos.js' />"></script>
  <script src="<c:url value='/vendor/admin/purecounter/purecounter_vanilla.js' />"></script>
  <script src="<c:url value='/vendor/admin/glightbox/js/glightbox.min.js' />"></script>

  <!-- Main JS File -->
  <script src="<c:url value='/js/admin/main.js' />"></script>
</body>
</html>