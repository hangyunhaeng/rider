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
		{ headerName: "배달일", field: "day", minWidth: 100, valueGetter:(params) => { return getStringDate(params.data.day)}},
		{ headerName: "협력사명", field: "cooperatorNm", minWidth: 140},
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 140},
		{ headerName: "배달건수", field: "deliveryCnt", minWidth: 80, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.deliveryCnt)}},
		{ headerName: "배달비", field: "deliveryPrice", minWidth: 130, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.deliveryPrice)}},
		{
		    headerName: '콜수수료',
		    children: [
		    	{ headerName: "합계", field: "costC", minWidth: 140, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.costCOper+params.data.costCCoop)}},
				{ headerName: "운영사<br/>콜수수료", field: "costCOper", minWidth: 140, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.costCOper)}},
				{ headerName: "협력사<br/>콜수수료", field: "costCCoop", minWidth: 140, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.costCCoop)}}
		    ]
		},
		{
		    headerName: '프로그램료',
		    children: [
		    	{ headerName: "합계", field: "costP", minWidth: 140, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.costPOper+params.data.costPSale)}},
				{ headerName: "운영사<br/>프로그램료", field: "costPOper", minWidth: 140, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.costPOper)}},
				{ headerName: "영업사원<br/>프로그램료", field: "costPSale", minWidth: 140, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.costPSale)}}
		    ]
		}

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

	//내역 조회
	function doSearch(){
	    if(!limit2Week($('#searchFromDate').val(), $('#searchToDate').val())){
	    	return;
	    }

		const params = new URLSearchParams();
		params.append('searchCooperatorId', $('#searchCooperatorId').val());
		params.append('searchFromDate', getOnlyNumber($('#searchFromDate').val()));
		params.append('searchToDate', getOnlyNumber($('#searchToDate').val()));

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/sts0002_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

			if(response.data.resultCode == "success"){

	            document.getElementById('TT_CNT0').textContent = currencyFormatter(response.data.list.length);

	        	if (response.data.list.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
					var sum = [{cooperatorNm:"합계"
						, deliveryCnt: 0
						, deliveryPrice: 0, costC: 0, costCOper: 0, costCCoop: 0, costP: 0, costPOper: 0, costPSale: 0
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {
					var lst = response.data.list;	//정상데이터
					var sum = [{cooperatorNm:"합계"
						, deliveryCnt: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.deliveryCnt, 10), 0)
						, deliveryPrice: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.deliveryPrice, 10), 0)
						, costC: response.data.list.reduce((acc, num) => Number(acc, 10) + (Number(num.costCOper, 10)+Number(num.costCCoop, 10)), 0)
						, costCOper: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.costCOper, 10), 0)
						, costCCoop: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.costCCoop, 10), 0)
						, costP: response.data.list.reduce((acc, num) => Number(acc, 10) + (Number(num.costPOper, 10)+Number(num.costPSale, 10)), 0)
						, costPOper: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.costPOper, 10), 0)
						, costPSale: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.costPSale, 10), 0)
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);
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
					{cooperatorNm:"합계", deliveryCnt: 0, deliveryPrice: 0, costC: 0, costCOper: 0, costCCoop: 0, costP: 0, costPOper: 0, costPSale: 0}
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
		<p class="tit">협력사 일별 배달현황</p>

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
						<th>배달일</th>
						<td>
							<div>
								<input id="searchFromDate" class="form-control search fs-9 float-start w40p"" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
								<sm class="float-start">&nbsp;~&nbsp;</sm>
								<input id="searchToDate" class="form-control search fs-9 float-start w40p" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
							</div>
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