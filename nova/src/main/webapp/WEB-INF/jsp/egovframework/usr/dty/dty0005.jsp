<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<link rel="apple-touch-icon" sizes="57x57" href="<c:url value='/images/fav/apple-icon-57x57.png' />">
<link rel="apple-touch-icon" sizes="60x60" href="<c:url value='/images/fav/apple-icon-60x60.png' />">
<link rel="apple-touch-icon" sizes="72x72" href="<c:url value='/images/fav/apple-icon-72x72.png' />">
<link rel="apple-touch-icon" sizes="76x76" href="<c:url value='/images/fav/apple-icon-76x76.png' />">
<link rel="apple-touch-icon" sizes="114x114" href="<c:url value='/images/fav/apple-icon-114x114.png' />">
<link rel="apple-touch-icon" sizes="120x120" href="<c:url value='/images/fav/apple-icon-120x120.png' />">
<link rel="apple-touch-icon" sizes="144x144" href="<c:url value='/images/fav/apple-icon-144x144.png' />">
<link rel="apple-touch-icon" sizes="152x152" href="<c:url value='/images/fav/apple-icon-152x152.png' />">
<link rel="apple-touch-icon" sizes="180x180" href="<c:url value='/images/fav/apple-icon-180x180.png' />">
<link rel="icon" type="image/png" sizes="192x192"  href="<c:url value='/images/fav/android-icon-192x192.png' />">
<link rel="icon" type="image/png" sizes="32x32" href="<c:url value='/images/fav/favicon-32x32.png' />">
<link rel="icon" type="image/png" sizes="96x96" href="<c:url value='/images/fav/favicon-96x96.png' />">
<link rel="icon" type="image/png" sizes="16x16" href="<c:url value='/images/fav/favicon-16x16.png' />">
<link rel="manifest" href="/manifest.json">
<meta name="msapplication-TileColor" content="#ffffff">
<meta name="msapplication-TileImage" content="/ms-icon-144x144.png">
<meta name="theme-color" content="#ffffff">


<!-- Fonts -->
<link href="https://fonts.googleapis.com" rel="preconnect">
<link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">

<!-- Vendor CSS Files -->
<link href="<c:url value='/vendor/admin/bootstrap/css/bootstrap.min.css' />" rel="stylesheet">
<link href="<c:url value='/vendor/admin/bootstrap-icons/bootstrap-icons.css' />" rel="stylesheet">
<%-- <link href="<c:url value='/vendor/admin/aos/aos.css' />" rel="stylesheet"> --%>
<%-- <link href="<c:url value='/vendor/admin/fontawesome-free/css/all.min.css' />" rel="stylesheet"> --%>
<%-- <link href="<c:url value='/vendor/admin/glightbox/css/glightbox.min.css' />" rel="stylesheet"> --%>
<%-- <link href="<c:url value='/vendor/admin/swiper/swiper-bundle.min.css' />" rel="stylesheet"> --%>

<!-- Main CSS File -->
<link href="<c:url value='/css/admin/main.css' />" rel="stylesheet">


<!-- 달력 -->
<link rel="stylesheet" type="text/css" href="<c:url value='/calender/flatpickr.min.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/calender/material_orange.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/calender/style.css' />">
<script src="<c:url value='/calender/flatpickr.js' />"></script>
<script src="<c:url value='/calender/ko.js' />"></script>
<script src="<c:url value='/calender/index.js' />"></script>

<script type="text/javascript"	src="<c:url value='/js/admin/util.js' />"></script>


<!-- keiti용 소스 -->
<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.default.css' /> ">
<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.style.css' />">

<script type="text/javascript"	src="<c:url value='/web2/js/function.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/jquery-1.11.2.min.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/keit.jquery.ui.js' />"></script>

<link rel="stylesheet" href="<c:url value='/ag-grid/ag-grid.css' />">
<link rel="stylesheet" href="<c:url value='/ag-grid/ag-theme-alpine.css' />">
<link rel="stylesheet" href="<c:url value='/ag-grid/ag-custom.css' />">
<script src="<c:url value='/ag-grid/ag-grid-community.noStyle.js' />"></script>
<script src="<c:url value='/ag-grid/ag-grid-community.js' />"></script>
<script src="<c:url value='/ag-grid/ag-custom-header.js' />"></script>
<script src="<c:url value='/js/xlsx.full.min.js' />"></script>
<script src="<c:url value='/js/xlsx-populate.min.js' />"></script>
<script src="<c:url value='/js/axios.min.js' />"></script>
	<link href="<c:url value='/vendor/admin/bootstrap/3.4.1/bootstrap.min.css' />" rel="stylesheet">
<!-- 	<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script> -->

</head>
	<script type="text/javaScript">


	let gridOptions="";
	var grid="";
	var grid2="";
	var grid3="";
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
		{ headerName: "기본단가", field: "basicPrice", minWidth: 90, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.basicPrice)}},
		{ headerName: "기상할증", field: "weatherPrimage", minWidth: 90, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.weatherPrimage)}},
		{ headerName: "추가할증", field: "addPrimage", minWidth: 90, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.addPrimage)}},
		{ headerName: "피크할증 등 ", field: "peakPrimageEtc", minWidth: 90, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.peakPrimageEtc)}},
		{ headerName: "배달처리비", field: "deliveryPrice", minWidth: 90, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.deliveryPrice)}},
		{ headerName: "라이더귀책여부", field: "riderCauseYn", minWidth: 90},
		{ headerName: "추가할증사유", field: "addPrimageDesc", minWidth: 90}
	];

	var columnDefs2= [
		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120},
		{ headerName: "정산시작일", field: "accountsStDt", minWidth: 90},
		{ headerName: "정산종료일", field: "accountsEdDt", minWidth: 90},
		{ headerName: "배달료(A-1)", field: "deliveryCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.deliveryCost)}},
		{ headerName: "추가정산(A-2)", field: "addAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.addAccounts)}},
		{ headerName: "운영비(C-2)", field: "operatingCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.operatingCost)}},
		{ headerName: "관리비(B-1)", field: "managementCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.managementCost)}},
		{ headerName: "운영수수료(B-2)", field: "operatingFee", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.operatingFee)}},
		{ headerName: "관리비등 부가세(B-3)", field: "etcCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.etcCost)}},
		{ headerName: "시간제보험료", field: "timeInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.timeInsurance)}},
		{ headerName: "사업주부담<br/>고용보험료(1)", field: "ownerEmploymentInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ownerEmploymentInsurance)}},
		{ headerName: "라이더부담<br/>고용보험료(2) ", field: "riderEmploymentInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.riderEmploymentInsurance)}},
		{ headerName: "사업주부담<br/>산재보험료(3)", field: "ownerIndustrialInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ownerIndustrialInsurance)}},
		{ headerName: "라이더부담<br/>산재보험료(4) ", field: "riderIndustrialInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.riderIndustrialInsurance)}},
		{ headerName: "원천징수보험료합계<br/>(1+2+3+4)(D)", field: "withholdingTaxInsuranceSum", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.withholdingTaxInsuranceSum)}},
		{ headerName: "고용보험<br/>소급정산(E)", field: "employmentInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.employmentInsuranceAccounts)}},
		{ headerName: "산재보험<br/>소급정산(F) ", field: "industrialInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.industrialInsuranceAccounts)}},
		{ headerName: "G(G)", field: "g", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.g)}},
		{ headerName: "정산예정금액<br/>(A+B-C)-시간제보험료-(D+E+F+G)", field: "accountsScheduleCost", minWidth: 200, valueGetter:(params) => { return currencyFormatter(params.data.accountsScheduleCost)}},
		{ headerName: "세금계산서<br/>공급가액 ", field: "taxBillSupply", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.taxBillSupply)}},
		{ headerName: "세금계산서<br/>부가세액 ", field: "taxBillAdd", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.taxBillAdd)}},
		{ headerName: "세금계산서<br/>공급대가 ", field: "taxBillSum", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.taxBillSum)}}
	];

	var columnDefs3= [
		{ headerName: "NO", field: "no", minWidth: 70 },
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120},
		{ headerName: "User ID", field: "mberId", minWidth: 120, cellClass: 'ag-cell-left'},
		{ headerName: "라이더명", field: "mberNm", minWidth: 120},
		{ headerName: "처리건수", field: "cnt", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.cnt)}},
		{ headerName: "배달료A", field: "deliveryCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.deliveryCost)}},
		{ headerName: "추가지지급B", field: "addCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.addCost)}},
		{ headerName: "총배달료C<br/>(A+B) ", field: "sumCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.sumCost)}},
		{ headerName: "시간제보험료", field: "timeInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.timeInsurance)}},
		{ headerName: "필요경비", field: "necessaryExpenses", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.necessaryExpenses)}},
		{ headerName: "보수액", field: "pay", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.pay)}},
		{ headerName: "사업주부담<br/>고용보험료(1)", field: "ownerEmploymentInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ownerEmploymentInsurance)}},
		{ headerName: "라이더부담<br/>고용보험료(2)", field: "riderEmploymentInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.riderEmploymentInsurance)}},
		{ headerName: "사업주부담<br/>산재보험료(3)", field: "ownerIndustrialInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ownerIndustrialInsurance)}},
		{ headerName: "라이더부담<br/>산재보험료(4)", field: "riderIndustrialInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.riderIndustrialInsurance)}},
		{ headerName: "원천징수보험료 합계<br/>(1+2+3+4)(D)", field: "withholdingTaxInsuranceSum", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.withholdingTaxInsuranceSum)}},
		{ headerName: "사업주부담 고용보험<br/>소급정산(5) ", field: "ownerEmploymentInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ownerEmploymentInsuranceAccounts)}},
		{ headerName: "라이더부담 고용보험<br/>소급정산(6)", field: "riderEmploymentInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.riderEmploymentInsuranceAccounts)}},
		{ headerName: "합계 고용보험<br/>소급정산(E)", field: "sumEmploymentInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.sumEmploymentInsuranceAccounts)}},
		{ headerName: "사업주부담 산재보험<br/>소급정산(7) ", field: "ownerIndustrialInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ownerIndustrialInsuranceAccounts)}},
		{ headerName: "라이더부담 산재보험<br/>소급정산(8)", field: "riderIndustrialInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.riderIndustrialInsuranceAccounts)}},
		{ headerName: "합계 산재보험<br/>소급정산(F)", field: "sumIndustrialInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.sumIndustrialInsuranceAccounts)}},
		{ headerName: "운영비(9)", field: "operatingCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.operatingCost)}},
		{ headerName: "라이더별정산금액(G)<br/>C-(2+4+6+8+9)", field: "accountsCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.accountsCost)}},
		{ headerName: "소득세(H)<br/>C*3%", field: "incomeTax", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.incomeTax)}},
		{ headerName: "주민세(I)<br/>H*10%", field: "residenceTax", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.residenceTax)}},
		{ headerName: "원천징수세액(J)<br/>(H+I)", field: "withholdingTax", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.withholdingTax)}},
		{ headerName: "라이더별지급금액(K)<br/>(G-J)", field: "givePay", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.givePay)}}
	];

	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		if('${loginVO.authorCode}' =='ROLE_ADMIN'){
			$('nav > ul').find('li[class!=cooperator]:hidden').show();
		}
		if('${loginVO.authorCode}' =='ROLE_USER'){
			$('nav > ul').find('li[class~=cooperator]:hidden').show();
		}

		//일정산 조회일 세팅
		var today = new Date();
		var oneMonthAgo = new Date(new Date().setMonth(new Date().getMonth()-1));
		var threeDayAgo = new Date(new Date().setDate(new Date().getDate()-3));

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
		searchFromDate.setDate(threeDayAgo.getFullYear()+"-"+(threeDayAgo.getMonth()+1)+"-"+threeDayAgo.getDate());
		searchToDate.setDate(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());


		//주정산 조회일 세팅
		var searchFromDate1 = flatpickr("#searchFromDate1", {
			locale: "ko",
			allowInput: false,
		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
		    dateFormat: 'Y-m-d',     // date format 형식
		    disableMobile: true          // 모바일 지원

		});
		var searchToDate1 = flatpickr("#searchToDate1", {
			"locale": "ko",
			allowInput: false,
		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
		    dateFormat: 'Y-m-d',     // date format 형식
		    disableMobile: true          // 모바일 지원
		});
		searchFromDate1.setDate(oneMonthAgo.getFullYear()+"-"+(oneMonthAgo.getMonth()+1)+"-"+oneMonthAgo.getDate());
		searchToDate1.setDate(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());


		//그리드 설정
		setGrid();
		setGrid2();
		setGrid3();
	});

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
					{cooperatorId:"합계", basicPrice: 0}
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
				overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>',
				pinnedBottomRowData: [
					{cooperatorId:"합계", basicPrice: 0}
		        ],
                getRowStyle: (params) => {
					if (params.node.rowPinned === 'bottom') {
						return { 'background-color': 'lightblue' };
					}
					return null;
				}
            };
        const gridDiv = document.querySelector('#myGrid2');
        grid2 = agGrid.createGrid(gridDiv, gridOptions);

        grid2.hideOverlay();

	}

	function setGrid3(){
		// 사용자 정의 컴포넌트를 글로벌 네임스페이스에 추가
		window.CustomHeader = CustomHeader;
    	gridOptions = {
                columnDefs: columnDefs3,
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
					{cooperatorId:"합계", basicPrice: 0}
		        ],
                getRowStyle: (params) => {
					if (params.node.rowPinned === 'bottom') {
						return { 'background-color': 'lightblue' };
					}
					return null;
				}
            };
        const gridDiv = document.querySelector('#myGrid3');
        grid3 = agGrid.createGrid(gridDiv, gridOptions);

        grid3.hideOverlay();

	}

	//일정산 내역 조회
	function doSearchDay(){
		const params = new URLSearchParams();

		params.append('searchFromDate', getOnlyNumber($('#searchFromDate').val()));//배달일
		params.append('searchToDate', getOnlyNumber($('#searchToDate').val()));	//배달일
		params.append('searchNm', $('#searchNm').val());			//라이더
		params.append('searchFixGubun', $('#searchFixGubun').val());		//확정여부
		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0005_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){
	        	if (response.data.list.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
					var sum = [{cooperatorId:"합계"
						, goodsPrice: 0
						, distance: 0
						, basicPrice: 0
						, weatherPrimage: 0
						, addPrimage: 0
						, peakPrimageEtc: 0
						, deliveryPrice: 0
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {
	            	data = response.data.list;	//정상데이터

					var sum = [{cooperatorId:"합계"
						, goodsPrice: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.goodsPrice, 10), 0)
						, distance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.distance, 10), 0)
						, basicPrice: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.basicPrice, 10), 0)
						, weatherPrimage: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.weatherPrimage, 10), 0)
						, addPrimage: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.addPrimage, 10), 0)
						, peakPrimageEtc: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.peakPrimageEtc, 10), 0)
						, deliveryPrice: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.deliveryPrice, 10), 0)
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);	//합계데이터는 정상데이터만 포함한다
					grid.setGridOption("rowData", data);
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
	function doFixDay(){

		if($('#searchFixGubun').val() != 'NO'){
			alert('대상확정은 미확정 대상으로만 진행 할 수 있습니다\n확정을 취소합니다');
			return;
		}

		if(!confirm('대상확정은 조회 대상이 아닌 검색 조건 대상으로 진행됩니다!\n확정 하시겠습니까?')){
			return;
		}
		const params = new URLSearchParams();

		params.append('searchFromDate', getOnlyNumber($('#searchFromDate').val()));//배달일
		params.append('searchToDate', getOnlyNumber($('#searchToDate').val()));	//배달일
		params.append('searchNm', $('#searchNm').val());			//라이더
		params.append('searchFixGubun', $('#searchFixGubun').val());		//확정여부
		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0005_0003.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){
	        	if (response.data.list.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
					var sum = [{cooperatorId:"합계"
						, goodsPrice: 0
						, distance: 0
						, basicPrice: 0
						, weatherPrimage: 0
						, addPrimage: 0
						, peakPrimageEtc: 0
						, deliveryPrice: 0
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {
	            	data = response.data.list;	//정상데이터

					var sum = [{cooperatorId:"합계"
						, goodsPrice: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.goodsPrice, 10), 0)
						, distance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.distance, 10), 0)
						, basicPrice: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.basicPrice, 10), 0)
						, weatherPrimage: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.weatherPrimage, 10), 0)
						, addPrimage: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.addPrimage, 10), 0)
						, peakPrimageEtc: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.peakPrimageEtc, 10), 0)
						, deliveryPrice: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.deliveryPrice, 10), 0)
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);	//합계데이터는 정상데이터만 포함한다
					grid.setGridOption("rowData", data);
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

	//주정산 내역 조회
	function doSearchWeek(){
		const params = new URLSearchParams();

		params.append('searchFromDate', getOnlyNumber($('#searchFromDate1').val()));//배달일
		params.append('searchToDate', getOnlyNumber($('#searchToDate1').val()));	//배달일
		params.append('searchNm', $('#searchNm1').val());			//라이더
		params.append('searchFixGubun', $('#searchFixGubun1').val());		//확정여부
		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0005_0002.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){
	        	if (response.data.list.length == 0) {
	        		grid2.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
					var sum = [{cooperatorId:"합계"
						, deliveryCost : 0
						, addAccounts : 0
						, operatingCost : 0
						, managementCost : 0
						, operatingFee : 0
						, etcCost : 0
						, timeInsurance : 0
						, ownerEmploymentInsurance : 0
						, riderEmploymentInsurance : 0
						, ownerIndustrialInsurance : 0
						, riderIndustrialInsurance : 0
						, withholdingTaxInsuranceSum : 0
						, employmentInsuranceAccounts : 0
						, industrialInsuranceAccounts : 0
						, g : 0
						, accountsScheduleCost : 0
						, taxBillSupply : 0
						, taxBillAdd : 0
						, taxBillSum : 0
						}
					];
					grid2.setGridOption('pinnedBottomRowData', sum);
	        		grid2.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {
	            	data = response.data.list;	//정상데이터

					var sum = [{cooperatorId:"합계"
						, deliveryCost: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.deliveryCost, 10), 0)
						, addAccounts: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.addAccounts, 10), 0)
						, operatingCost: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.operatingCost, 10), 0)
						, managementCost: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.managementCost, 10), 0)
						, operatingFee: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.operatingFee, 10), 0)
						, etcCost: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.etcCost, 10), 0)
						, timeInsurance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.timeInsurance, 10), 0)
						, ownerEmploymentInsurance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.ownerEmploymentInsurance, 10), 0)
						, riderEmploymentInsurance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.riderEmploymentInsurance, 10), 0)
						, ownerIndustrialInsurance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.ownerIndustrialInsurance, 10), 0)
						, riderIndustrialInsurance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.riderIndustrialInsurance, 10), 0)
						, withholdingTaxInsuranceSum: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.withholdingTaxInsuranceSum, 10), 0)
						, employmentInsuranceAccounts: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.employmentInsuranceAccounts, 10), 0)
						, industrialInsuranceAccounts: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.industrialInsuranceAccounts, 10), 0)
						, g: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.g, 10), 0)
						, accountsScheduleCost: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.accountsScheduleCost, 10), 0)
						, taxBillSupply: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.taxBillSupply, 10), 0)
						, taxBillAdd: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.taxBillAdd, 10), 0)
						, taxBillSum: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.taxBillSum, 10), 0)
						}
					];
					grid2.setGridOption('pinnedBottomRowData', sum);	//합계데이터는 정상데이터만 포함한다
					grid2.setGridOption("rowData", data);
	            }

	        	if (response.data.listRider.length == 0) {
	        		grid3.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
					var sum = [{cooperatorId:"합계"
						, cnt : 0
						, deliveryCost : 0
						, addCos : 0
						, sumCost : 0
						, timeInsurance : 0
						, necessaryExpenses : 0
						, pay : 0
						, ownerEmploymentInsurance : 0
						, riderEmploymentInsurance : 0
						, ownerIndustrialInsurance : 0
						, riderIndustrialInsurance : 0
						, withholdingTaxInsuranceSum : 0
						, ownerEmploymentInsuranceAccounts : 0
						, riderEmploymentInsuranceAccounts : 0
						, sumEmploymentInsuranceAccounts : 0
						, ownerIndustrialInsuranceAccounts : 0
						, riderIndustrialInsuranceAccounts : 0
						, sumIndustrialInsuranceAccounts : 0
						, operatingCost : 0
						, accountsCost : 0
						, incomeTax : 0
						, residenceTax : 0
						, withholdingTax : 0
						, givePay : 0
						}
					];
					grid3.setGridOption('pinnedBottomRowData', sum);
	        		grid3.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {
	            	debugger;
	            	data = response.data.listRider;	//정상데이터

					var sum = [{cooperatorId:"합계"
						, cnt: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.cnt, 10), 0)
						, deliveryCost: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.deliveryCost, 10), 0)
						, addCost: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.addCost, 10), 0)
						, sumCost: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.sumCost, 10), 0)
						, timeInsurance: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.timeInsurance, 10), 0)
						, necessaryExpenses: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.necessaryExpenses, 10), 0)
						, pay: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.pay, 10), 0)
						, ownerEmploymentInsurance: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.ownerEmploymentInsurance, 10), 0)
						, riderEmploymentInsurance: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.riderEmploymentInsurance, 10), 0)
						, ownerIndustrialInsurance: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.ownerIndustrialInsurance, 10), 0)
						, riderIndustrialInsurance: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.riderIndustrialInsurance, 10), 0)
						, withholdingTaxInsuranceSum: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.withholdingTaxInsuranceSum, 10), 0)
						, ownerEmploymentInsuranceAccounts: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.ownerEmploymentInsuranceAccounts, 10), 0)
						, riderEmploymentInsuranceAccounts: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.riderEmploymentInsuranceAccounts, 10), 0)
						, sumEmploymentInsuranceAccounts: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.sumEmploymentInsuranceAccounts, 10), 0)
						, ownerIndustrialInsuranceAccounts: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.ownerIndustrialInsuranceAccounts, 10), 0)
						, riderIndustrialInsuranceAccounts: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.riderIndustrialInsuranceAccounts, 10), 0)
						, sumIndustrialInsuranceAccounts: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.sumIndustrialInsuranceAccounts, 10), 0)
						, operatingCost: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.operatingCost, 10), 0)
						, accountsCost: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.accountsCost, 10), 0)
						, incomeTax: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.incomeTax, 10), 0)
						, residenceTax: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.residenceTax, 10), 0)
						, withholdingTax: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.withholdingTax, 10), 0)
						, givePay: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.givePay, 10), 0)
						}
					];
					grid3.setGridOption('pinnedBottomRowData', sum);	//합계데이터는 정상데이터만 포함한다
					grid3.setGridOption("rowData", data);
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

	function doFixWeek(){

		if($('#searchFixGubun1').val() != 'NO'){
			alert('대상확정은 미확정 대상으로만 진행 할 수 있습니다\n확정을 취소합니다');
			return;
		}

		if(!confirm('대상확정은 조회 대상이 아닌 검색 조건 대상으로 진행됩니다!\n확정 하시겠습니까?')){
			return;
		}

		const params = new URLSearchParams();

		params.append('searchFromDate', getOnlyNumber($('#searchFromDate1').val()));//배달일
		params.append('searchToDate', getOnlyNumber($('#searchToDate1').val()));	//배달일
		params.append('searchNm', $('#searchNm1').val());			//라이더
		params.append('searchFixGubun', $('#searchFixGubun1').val());		//확정여부
		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0005_0004.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

            if(response.data.resultCode != "success"){
				if(response.data.resultMsg != '' && response.data.resultMsg != null)
					alert(response.data.resultMsg);
				else alert("대상확정에 실패하였습니다.");
				return ;
			}

        	if(response.data.resultCode == "success"){
	        	if (response.data.list.length == 0) {
	        		grid2.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid2.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {
	            	data = response.data.list;	//정상데이터
					grid2.setGridOption("rowData", data);
	            }

	        	if (response.data.listRider.length == 0) {
	        		grid3.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid3.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {
	            	data = response.data.listRider;	//정상데이터
					grid3.setGridOption("rowData", data);
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
	</script>
<body class="index-page">

      <div class="loading-wrap loading-wrap--js" style="display: none;z-index:10000;">
        <div class="loading-spinner loading-spinner--js"></div>
        <p id="loadingMessage">로딩중</p>
      </div>

  <header id="header" class="header d-flex align-items-center fixed-top">
    <div class="container-fluid container-xl position-relative d-flex align-items-center">

      <a href="${pageContext.request.contextPath}/com/com0002.do" class="logo d-flex align-items-center me-auto">
        <!-- Uncomment the line below if you also wish to use an image logo -->
        <!-- <img src="/images/admin/logo.png" alt=""> -->
        <h1 class="sitename">RIDER BANK</h1>
      </a>


			<nav id="navmenu" class="navmenu">
				<ul>
					<li class="dropdown"><a href="" onclick="javascript:return false;"><span>공지사항&문의</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
			              <li><a href="${pageContext.request.contextPath}/usr/not0001.do">공지사항</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/inq0001.do">1:1문의</a></li>
			            </ul>
					</li>
		            <li class="dropdown"><a href="" onclick="javascript:return false;"><span>수익현황</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
			              <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0003.do">운영사수익현황</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/pay0004.do">협력사수익현황</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/pay0005.do">협력사 기타(대여, 리스) 현황</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/pay0001.do">라이더 출금내역<br></a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/pay0006.do">협력사 출금내역<br></a></li>
			            </ul>
		            </li>
		            <li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;"><span>관리</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
						  <li><a href="${pageContext.request.contextPath}/usr/dty0004.do">배달정보 조회</a></li>
						  <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0002.do">입출금 대사<br></a></li>
			            </ul>
		            </li>

					<li class="cooperator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/dty0004.do">배달정보 조회</a></li>

					<li class="dropdown"><a href="" onclick="javascript:return false;"><span>협력사/라이더 현황</span><i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li><a href="${pageContext.request.contextPath}/usr/mem0001.do">협력사 관리</a></li>
              				<li style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0003.do">협력사계정 관리</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/mem0002.do">라이더관리</a></li>
						</ul>
					</li>
					<li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;" class="active"><span>자료 업로드</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li><a href="${pageContext.request.contextPath}/usr/dty0001.do">일별 자료 업로드</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0002.do">주별 자료 업로드</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0003.do">자료 업로드 이력</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0005.do" class="active">자료 확정</a></li>
						</ul>
					</li>
					<li><a href="${pageContext.request.contextPath}/usr/mem0004.do">MyPage</a></li>
				</ul>
				<i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
			</nav>
	<a class="btn-getstarted" href="${pageContext.request.contextPath }/uat/uia/actionLogout.do" style="height: 37px;"><spring:message code="comCmm.unitContent.3"/></a>


    </div>
  </header>

  <main class="main" style="height:60px;">

		<!-- Hero Section -->
		<section id="hero" class="hero section dark-background"
			style="min-height: 50px; padding: 70px 0 30px 0;">

			<img src="<c:url value='/images/admin/world-dotted-map.png' />" alt="" class="hero-bg"
				data-aos="fade-in">
			<div class="container-fluid container-xl position-relative d-flex align-items-center">
				<div class="d-flex align-items-center me-auto"></div>
		 		<sm class="btn-getstarted">${loginVO.name}<c:if test="${loginVO.authorCode eq 'ROLE_ADMIN'}">(운영사)</c:if>님 환영합니다</sm>
		 	</div>
		</section>
  </main>

	<!-- 숨겨진 폼 -->
	<form id="myForm" action="/conv/conv02410.do" method="POST" style="display: none;">
		<!-- <input type="hidden" name=taskNo id="taskNo"> -->
	</form>

	<div class="keit-header-body innerwrap clearfix">
<!-- 		<p class="tit">확정</p> -->

			<input name="pageUnit" type="hidden" value="1000"/>
			<input name="pageSize" type="hidden" value="1000"/>
			<!--과제관리_목록 -->
			<div class="search_box ty2">


			<!-- 좌 -->
			<div style="float: left; width: 49%; margin-right: 1%">
				<p class="tit">일별 자료 확정</p>
				<table>
					<colgroup>
						<col style="width: 13%">
						<col style="width: 37%">
						<col style="width: 13%">
						<col style="width: 37%">
					</colgroup>
					<tr>
						<th>배달일</th>
						<td colspan='3'>
							<div>
								<input id="searchFromDate" class="form-control search fs-9 float-start w40p"" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
								<sm class="float-start">&nbsp;~&nbsp;</sm>
								<input id="searchToDate" class="form-control search fs-9 float-start w40p" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
							</div>
						</td>
					</tr>
					<tr>
						<th>라이더</th>
						<td>
							<input id="searchNm" type="text" value="">
						</td>
						<th>확정여부</th>
						<td>
							<select style='width: 100%' id='searchFixGubun'>
								<option value="NO">미확정</option>
								<option value="YES">확정</option>
							</select>
						</td>
					</tr>
				</table>

				<div class="btnwrap">
					<button class="btn ty1" onclick="doSearchDay();">조회</button>
					<button class="btn ty1" onclick="doFixDay();">대상확정</button>
				</div>

			<!-- grid  -->

			<br>
			<div id="loadingOverlay" style="display: none;">Loading...</div>
			<div  class="ib_product">
				<div id="myGrid" class="ag-theme-alpine" style="height: 550px; width: 100%;"></div>
			</div>
			</div>

			<!-- 우 -->
			<div style="float: left; width: 50%;">
				<p class="tit">주별 자료 확정</p>

				<table>
					<colgroup>
						<col style="width: 13%">
						<col style="width: 37%">
						<col style="width: 13%">
						<col style="width: 37%">
					</colgroup>
					<tr>
						<th>기간</th>
						<td colspan='3'>
							<div>
								<input id="searchFromDate1" class="form-control search fs-9 float-start w40p"" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
								<sm class="float-start">&nbsp;~&nbsp;</sm>
								<input id="searchToDate1" class="form-control search fs-9 float-start w40p" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
							</div>
						</td>
					</tr>
					<tr>
						<th>라이더</th>
						<td>
							<input id="searchNm1" type="text" value="">
						</td>
						<th>확정여부</th>
						<td>
							<select style='width: 100%' id='searchFixGubun1'>
								<option value="NO">미확정</option>
								<option value="YES">확정</option>
							</select>
						</td>
					</tr>
				</table>

				<div class="btnwrap">
					<button class="btn ty1" onclick="doSearchWeek();">조회</button>
					<button class="btn ty1"onclick="doFixWeek();">대상확정</button>

				</div>

				<!-- grid  -->
				<br>
				<div id="loadingOverlay" style="display: none;">Loading...</div>
				<div  class="ib_product">
					<div id="myGrid2" class="ag-theme-alpine" style="height: 200px; width: 100%;"></div>
				</div>


				<!-- grid  -->

				<br>
				<div  class="ib_product">
					<div id="myGrid3" class="ag-theme-alpine" style="height: 330px; width: 100%;"></div>
				</div>
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