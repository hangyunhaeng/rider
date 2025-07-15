<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

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


	var pageInit = true;
	let gridOptions="";
	var grid="";
	var grid1="";
	let data;
	var columnDefs= [
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

	var columnDefs1= [
		{ headerName: "NO", field: "no", minWidth: 70 },
		{ headerName: "User ID", field: "mberId", minWidth: 120, cellClass: 'ag-cell-left'},
		{ headerName: "라이더명", field: "mberNm", minWidth: 120},
		{ headerName: "처리건수", field: "cnt", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.cnt)}},
		{ headerName: "배달료A", field: "deliveryCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.deliveryCost)}},
		{ headerName: "추가지지급B", field: "addCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.addCost)}},
		{ headerName: "총배달료C<br/>(A+B) ", field: "sumCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.sumCost)}},
		{ headerName: "시간제보험료", field: "timeInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.timeInsurance)}},
		{ headerName: "필요경비", field: "necessaryExpenses", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.necessaryExpenses)}},
		{ headerName: "보수액", field: "pay", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.taxBillSum)}},
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

		//업로드일 세팅
		var today = new Date();
		var searchDate = flatpickr("#searchDate", {
			locale: "ko",
			allowInput: false,
		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
		    dateFormat: 'Y-m-d',     // date format 형식
		    disableMobile: true          // 모바일 지원

		});
		searchDate.setDate(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());

		if("${deliveryInfoVO.searchDate}" != ""){
			searchDate.setDate(getStringDate('${deliveryInfoVO.searchDate}'));
		}

		//이벤트 설정
		// 1. 업로드일 변경
		$('#searchDate').on('change', function(e){
			loadFileList();
		});
		// 2. 조회버튼
		$('#loadDataBtn').on("click", function(){
			doSearch();
		});
		// 3. 주별자료업로드
		$("#uploadAsyncBtn").on("click", function(e){
			주별자료업로드();
		});

		//파일명 가져오기
		loadFileList();

		//그리드 설정
		setGrid();
		setGrid1();
	});

	//업로드일에 해당하는 파일명 가져오기
	function loadFileList(){

		const params = new URLSearchParams();

	    var regex = /[^0-9]/g;
		params.append('searchKeyword', $($('#searchDate')[0]).val().replace(regex, ""));
		params.append('fileGubun', "WEEK");

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0001_0003.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
        	populateSelectOptions('serchFileName', response.data.fileList, "${deliveryInfoVO.searchId}");
        	if(pageInit){
        		doSearch();
        	}
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
		debugger;
		const params = new URLSearchParams();
		params.append('searchAtchFileId', $('#serchFileName').val());
		params.append('searchMberId', $('#searchMberId').val());

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0002_0004.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
			if(response.data.resultCode == "success"){
	        	if (response.data.list.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					var lst = response.data.list;	//정상데이터
	                grid.setGridOption('rowData', lst);
	            }

	        	if (response.data.listRider.length == 0) {
	        		grid1.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid1.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					var lst = response.data.listRider;	//정상데이터
	                grid1.setGridOption('rowData', lst);
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
				overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>'
            };
        const gridDiv = document.querySelector('#myGrid');
        grid = agGrid.createGrid(gridDiv, gridOptions);

        grid.hideOverlay();

	}

	function setGrid1(){
		// 사용자 정의 컴포넌트를 글로벌 네임스페이스에 추가
		window.CustomHeader = CustomHeader;
    	gridOptions = {
                columnDefs: columnDefs1,
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
        const gridDiv = document.querySelector('#myGrid1');
        grid1 = agGrid.createGrid(gridDiv, gridOptions);

        grid1.hideOverlay();

	}


	function 주별자료업로드(){
		var formData = new FormData();
		var inputFile = $("input[name='uploadAsync']");
		var files = inputFile[0].files;

		if(files == null || files.length <=0 ){
			alert('업로드할 파일을 선택하세요\n업로드를 취소합니다');
			return;
		}

		for(var i =0;i<files.length;i++){
			formData.append("fileName", files[i]);
		}
		// 로딩 시작
        $('.loading-wrap--js').show();
		$.ajax({
// 			url: '${pageContext.request.contextPath}/usr/dty0002_0002.do',	//async
// 			url: '${pageContext.request.contextPath}/usr/dty0002_0003.do',	//sync
			url: '${pageContext.request.contextPath}/usr/dty0002_0005.do',	//대용량 아님
			processData : false,
			contentType : false,
			data : formData,
			type : 'POST',
			success : function(response){
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
				loadFileList();
				if(response.resultCode != "success"){
					if(response.resultMsg != '' && response.resultMsg != null)
						alert(response.resultMsg);
					else alert("주별 자료 업로드에 실패하였습니다\n엑셀 내용을 확인 후 다시 업로드 하시기 바랍니다");
					return ;
				}

	        	if (response.list.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					var lst = response.list;	//정상데이터
	                grid.setGridOption('rowData', lst);
	            }

	        	if (response.listRider.length == 0) {
	        		grid1.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid1.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					var lst = response.listRider;	//정상데이터
	                grid1.setGridOption('rowData', lst);
	            }

			},
			error : function(xhr, status, error){
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
			}


		}); //$.ajax

	}
	function subMenuClick(obj){
// 		debugger;
// 		document.querySelectorAll('.navmenu .toggle-dropdown').click();
// 	    document.querySelector('body').classList.toggle('mobile-nav-active');
// 	    const mobileNavToggleBtn = document.querySelector('.mobile-nav-toggle');
// 	    mobileNavToggleBtn.classList.toggle('bi-list');
// 	    mobileNavToggleBtn.classList.toggle('bi-x');
// 		$(obj).find(".toggle-dropdown").click();
// 		$(obj).find(".toggle-dropdown").click();
// 		$(obj).find("i").click()
// $(obj).find('i').trigger('click');
// 		$(obj).find('.toggle-dropdown').click();
		return false;
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
						  <li><a href="${pageContext.request.contextPath}/usr/pay0001.do">입출금내역<br></a></li>
			            </ul>
		            </li>
		            <li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;"><span>관리</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
						  <li><a href="${pageContext.request.contextPath}/usr/dty0004.do">배달정보 조회</a></li>
						  <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0002.do">입출금 대사<br></a></li>
			            </ul>
		            </li>

					<li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;"><span>협력사/라이더 현황</span><i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li><a href="${pageContext.request.contextPath}/usr/mem0001.do">협력사 관리</a></li>
              				<li><a href="${pageContext.request.contextPath}/usr/mem0003.do">협력사계정 관리</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/mem0002.do">라이더관리</a></li>
						</ul></li>
					<li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;" class="active"><span>자료 업로드</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li><a href="${pageContext.request.contextPath}/usr/dty0001.do">일별 자료 업로드</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0002.do" class="active">주별 자료 업로드</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0003.do">자료 업로드 이력</a></li>
						</ul>
					</li>
					<li class="cooperator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/dty0004.do">배달정보 조회</a></li>
					<li class="cooperator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0002.do">라이더관리</a></li>
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
		<p class="tit">주별 자료 업로드</p>

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
						<th>업로드일</th>
						<td>
							<input id="searchDate" class="form-control search fs-9" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
						</td>
						<th>파일명</th>
						<td colspan='3'>
							<select name='serchFileName' style='width: 100%' id='serchFileName'></select>
						</td>
					</tr>
					<tr>
						<th>라이더ID</th>
						<td colspan='5'>
							<input id="searchMberId" type="text" value="${deliveryInfoVO.searchMberId}">
						</td>
					</tr>
				</table>

				<div class="btnwrap">
					<button id="loadDataBtn" class="btn ty1">조회</button>

				</div>

<!-- 				<div id="ajaxUp2" class="btnwrap"> -->
<!-- 				<p> ajax파일 : <input type="file" name="fileName" multiple="multiple"/> -->
<!-- 				<button id="uploadBtn" class="btn btn-primary" >ajax업르드</button> -->
<!-- 				</div> -->

<!-- 				<div id="ajaxUp3" class="btnwrap"> -->
<!-- 				<p> 업로드 후 에러건만 화면 표기 : <input type="file" name="uploadAfterErrorOut" multiple="multiple"/> -->
<!-- 				<button id="uploadAfterErrorOutBtn" class="btn btn-primary" >업로드</button> -->
<!-- 				</div> -->

				<div id="ajaxUp3" class="btnwrap" style="float:right;">
				<input type="file" name="uploadAsync" multiple="multiple" class="btn ty2 me-2" style="float:left;"/>
				<button id="uploadAsyncBtn" class="btn btn-primary" >업로드</button>
				</div>
				<br/>
			<!-- grid  -->
			<br>
			<div id="loadingOverlay" style="display: none;">Loading...</div>
			<div  class="ib_product">
				<div id="myGrid" class="ag-theme-alpine" style="height: 150px; width: 100%;"></div>
			</div>


			<!-- grid  -->

			<br>
			<div  class="ib_product">
				<div id="myGrid1" class="ag-theme-alpine" style="height: 380px; width: 100%;"></div>
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