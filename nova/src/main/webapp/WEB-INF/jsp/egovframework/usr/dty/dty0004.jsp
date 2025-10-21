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
	let gridOptions="";
	var grid="";
	let data;
	var columnDefs= [
		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "오류", field: "err", minWidth: 120, hide:true},
// 		{ headerName: "chk", field: "chk", minWidth: 70, cellDataType: 'boolean', editable:true },
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120},
		{ headerName: "협력사명", field: "cooperatorNm", minWidth: 140, cellClass: 'ag-cell-left'},
		{ headerName: "사업자등록번호", field: "registrationSn", minWidth: 120},
		{ headerName: "사업자명", field: "registrationNm", minWidth: 140, cellClass: 'ag-cell-left'},
		{ headerName: "운행일", field: "runDe", minWidth: 90},
		{ headerName: "배달번호", field: "deliverySn", minWidth: 100},
		{ headerName: "배달상태", field: "deliveryState", minWidth: 90},
		{ headerName: "서비스타입", field: "serviceType", minWidth: 90},
		{ headerName: "배달방식", field: "deliveryType", minWidth: 90},
		{ headerName: "라이더ID", field: "riderId", minWidth: 150},
		{ headerName: "User ID", field: "mberId", minWidth: 100},
		{ headerName: "라이더명", field: "riderNm", minWidth: 90},
		{ headerName: "배달수단", field: "deliveryMethod", minWidth: 90},
		{ headerName: "가게번호", field: "shopSn", minWidth: 90},
		{ headerName: "가게이름", field: "shopNm", minWidth: 200, cellClass: 'ag-cell-left'},
		{ headerName: "상품가격", field: "goodsPrice", minWidth: 90, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.goodsPrice)}},
		{ headerName: "픽업 주소", field: "pickupAddr", minWidth: 200, cellClass: 'ag-cell-left'},
		{ headerName: "전달지 주소", field: "destinationAddr", minWidth: 200, cellClass: 'ag-cell-left'},
		{ headerName: "주문시간", field: "orderDt", minWidth: 150},
		{ headerName: "배차완료", field: "operateRiderDt", minWidth: 150},
		{ headerName: "가게도착", field: "shopComeinDt", minWidth: 150},
		{ headerName: "픽업완료", field: "pickupFinistDt", minWidth: 150},
		{ headerName: "전달완료", field: "deliveryFinistDt", minWidth: 150},
		{ headerName: "거리", field: "distance", minWidth: 80, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.distance)}},
		{ headerName: "추가배달사유", field: "addDeliveryReason", minWidth: 200},
		{ headerName: "추가배달상세내용", field: "addDeliveryDesc", minWidth: 200},
		{ headerName: "픽업지 법정동 ", field: "pickupLawDong", minWidth: 90},
		{ headerName: "기본단가", field: "basicPrice", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.basicPrice)}},
		{ headerName: "기상할증", field: "weatherPrimage", minWidth: 90, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.weatherPrimage)}},
		{ headerName: "추가할증", field: "addPrimage", minWidth: 90, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.addPrimage)}},
		{ headerName: "피크할증 등 ", field: "peakPrimageEtc", minWidth: 90, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.peakPrimageEtc)}},
		{ headerName: "지역할증", field: "areaPrimage", minWidth: 90, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.areaPrimage)}},
		{ headerName: "대량할증 ", field: "amountPrimage", minWidth: 90, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.amountPrimage)}},
		{ headerName: "배달처리비", field: "deliveryPrice", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.deliveryPrice)}},
		{ headerName: "라이더귀책여부", field: "riderCauseYn", minWidth: 90},
		{ headerName: "추가할증사유", field: "addPrimageDesc", minWidth: 90}
	];


	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		//업로드일 세팅
		var today = new Date();
		var now = new Date();
		var towWeekAgo = new Date(now.setDate(now.getDate()-14));
		var searchFromDate = flatpickr("#searchFromDate", {
			locale: "ko",
			allowInput: false,
		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
		    dateFormat: 'Y-m-d',     // date format 형식
		    disableMobile: true          // 모바일 지원

		});
		var searchToDate = flatpickr("#searchToDate", {
			"locale": "ko",
			allowInput: false,
		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
		    dateFormat: 'Y-m-d',     // date format 형식
		    disableMobile: true          // 모바일 지원
		});

		// 1. 조회버튼
		$('#loadDataBtn').on("click", function(){
			doSearch();
		});

		searchFromDate.setDate(towWeekAgo.getFullYear()+"-"+(towWeekAgo.getMonth()+1)+"-"+towWeekAgo.getDate());
		searchToDate.setDate(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());

		loadCooperatorList();
		//그리드 설정
		setGrid();
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

	//파일별 업로드 내역 조회
	function doSearch(){

	    if(!limit2Week($('#searchFromDate').val(), $('#searchToDate').val())){
	    	return;
	    }

		const params = new URLSearchParams();
		params.append('searchCooperatorId', $('#searchCooperatorId').val());
		params.append('searchFromDate', getOnlyNumber($('#searchFromDate').val()));
		params.append('searchToDate', getOnlyNumber($('#searchToDate').val()));
		params.append('searchNm', $('#searchNm').val().trim());
		params.append('searchDeliveryState', $('#searchDeliveryState').val());

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0004_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

        	if(chkLogOut(response.data)){
            	return;
            }

			if(response.data.resultCode == "success"){

	            document.getElementById('TT_CNT0').textContent = currencyFormatter(response.data.list.length);

	        	if (response.data.list.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정

					var sum = [{cooperatorId:"합계"
						, goodsPrice: 0
						, distance: 0
						, basicPrice: 0
						, weatherPrimage: 0
						, addPrimage: 0
						, peakPrimageEtc: 0
						, areaPrimage: 0
						, amountPrimage: 0
						, deliveryPrice: 0
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);

	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {
					var lst = response.data.list;	//정상데이터


					var sum = [{cooperatorId:"합계"
						, goodsPrice: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.goodsPrice, 10), 0)
						, distance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.distance, 10), 0)
						, basicPrice: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.basicPrice, 10), 0)
						, weatherPrimage: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.weatherPrimage, 10), 0)
						, addPrimage: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.addPrimage, 10), 0)
						, peakPrimageEtc: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.peakPrimageEtc, 10), 0)
						, areaPrimage: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.areaPrimage, 10), 0)
						, amountPrimage: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.amountPrimage, 10), 0)
						, deliveryPrice: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.deliveryPrice, 10), 0)
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);	//합계데이터는 정상데이터만 포함한다

	                grid.setGridOption('rowData', lst);
	            }
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
				pinnedBottomRowData: [
					{cooperatorId:"합계"
						, goodsPrice: 0
						, distance: 0
						, basicPrice: 0
						, weatherPrimage: 0
						, addPrimage: 0
						, peakPrimageEtc: 0
						, areaPrimage: 0
						, amountPrimage: 0
						, deliveryPrice: 0}
		        ],
                getRowStyle: (params) => {
					if (params.node.rowPinned === 'bottom') {
						return { 'background-color': 'lightblue' };
					}
					return null;
				}
            };
        const gridDiv = document.querySelector('#myGrid');
        grid = agGrid.createGrid(gridDiv, gridOptions);

        grid.hideOverlay();

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
		<p class="tit">배달정보 조회</p>

			<input name="pageUnit" type="hidden" value="1000"/>
			<input name="pageSize" type="hidden" value="1000"/>
			<!--과제관리_목록 -->
			<div class="search_box ty2">
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
						<th>배달일</th>
						<td>
							<div>
								<input id="searchFromDate" class="form-control search fs-9 float-start w40p"" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
								<sm class="float-start">&nbsp;~&nbsp;</sm>
								<input id="searchToDate" class="form-control search fs-9 float-start w40p" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
							</div>
						</td>
						<th>배달상태</th>
						<td>
							<select id="searchDeliveryState" name='searchDeliveryState' style='width: 100%'>
								<option value="">전체</option>
								<option value="전달완료">전달완료</option>
								<option value="배달취소">배달취소</option>
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