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
		{ headerName: "상품가격", field: "goodsPrice", minWidth: 90, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.distance)}},
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


	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		if('${loginVO.authorCode}' =='ROLE_ADMIN'){
			$('nav > ul').find('li:hidden').show();
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
		// 3. async 대용량 업로드
		$("#uploadAsyncBtn").on("click", function(e){
			async대용량업로드();
		});

		//파일명 가져오기
		loadFileList();

		//그리드 설정
		setGrid();
	});

	//업로드일에 해당하는 파일명 가져오기
	function loadFileList(){

		const params = new URLSearchParams();

	    var regex = /[^0-9]/g;
		params.append('searchKeyword', $($('#searchDate')[0]).val().replace(regex, ""));
		params.append('fileGubun', "DAY");
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
		const params = new URLSearchParams();

		params.append('searchError', $('#searchError').val());
		params.append('searchId', $('#serchFileName').val());
		params.append('searchMberId', $('#searchMberId').val());
		params.append('searchRunDeDate', $('#searchRunDeDate').val().replace(/[^0-9]/g, ""));
		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0001_0004.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
			if(response.data.resultCode == "success"){

	            document.getElementById('TT_CNT0').textContent = currencyFormatter(response.data.list.length);
	            document.getElementById('TT_CNT1').textContent = 0;

	        	if (response.data.list.length == 0 && response.data.listE.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
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
						, deliveryPrice: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.deliveryPrice, 10), 0)
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);	//합계데이터는 정상데이터만 포함한다


	            	//업로드 오류건은 데이터 재설정 해야함
					if(response.data.listE != null && response.data.listE.length != 0){
			            document.getElementById('TT_CNT1').textContent = currencyFormatter(response.data.listE.length);

						for(var i = 0 ; i< response.data.listE.length ; i++ ){
							var dataOne = {};
							try{
								var item = response.data.listE[i];
								var longTxt = item.longtxt.substr(1, item.longtxt.length-2);	//[]자른 내용부
								var txt = longTxt.split(',');
								dataOne.err = true;
								dataOne.cooperatorId = nullToString(txt[0]);
								dataOne.cooperatorNm = nullToString(txt[1]);
								dataOne.registrationSn = nullToString(txt[2]);
								dataOne.registrationNm = nullToString(txt[3]);
								dataOne.runDe = nullToString(txt[4]);
								dataOne.deliverySn = nullToString(txt[5]);
								dataOne.deliveryState = nullToString(txt[6]);
								dataOne.serviceType = nullToString(txt[7]);
								dataOne.deliveryType = nullToString(txt[8]);
								dataOne.riderId = nullToString(txt[9]);
								dataOne.mberId = nullToString(txt[10]);
								dataOne.riderNm = nullToString(txt[11]);
								dataOne.deliveryMethod = nullToString(txt[12]);
								dataOne.shopSn = nullToString(txt[13]);
								dataOne.shopNm = nullToString(txt[14]);
								dataOne.goodsPrice = nullToString(txt[15]);
								dataOne.pickupAddr = nullToString(txt[16]);
								dataOne.destinationAddr = nullToString(txt[17]);
								dataOne.orderDt = nullToString(txt[18]);
								dataOne.operateRiderDt = nullToString(txt[19]);
								dataOne.shopComeinDt = nullToString(txt[20]);
								dataOne.pickupFinistDt = nullToString(txt[21]);
								dataOne.deliveryFinistDt = nullToString(txt[22]);
								dataOne.distance = nullToString(txt[23]);
								dataOne.addDeliveryReason = nullToString(txt[24]);
								dataOne.addDeliveryDesc = nullToString(txt[25]);
								dataOne.pickupLawDong = nullToString(txt[26]);
								dataOne.basicPrice = nullToString(txt[27]);
								dataOne.weatherPrimage = nullToString(txt[28]);
								dataOne.addPrimage = nullToString(txt[29]);
								dataOne.peakPrimageEtc = nullToString(txt[30]);
								dataOne.deliveryPrice = nullToString(txt[31]);
								dataOne.riderCauseYn = nullToString(txt[32]);
								dataOne.addPrimageDesc = nullToString(txt[33]);
// 								dataOne.note = nullToString(txt[34]);
// 								dataOne.atchFileId = nullToString(txt[35]);
// 								dataOne.creatId = nullToString(txt[36]);
							} catch (err){

							}
							lst.unshift(dataOne);	//정상데이터의 앞쪽에 에러데이터를 추가한다.
						}

					}


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
					{cooperatorId:"합계", basicPrice: 0}
		        ]
            };
        const gridDiv = document.querySelector('#myGrid');
        grid = agGrid.createGrid(gridDiv, gridOptions);

        grid.hideOverlay();

	}


	function async대용량업로드(){
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
			url: '${pageContext.request.contextPath}/usr/dty0001_0002.do',
			processData : false,
			contentType : false,
			data : formData,
			type : 'POST',
			success : function(response){
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
				if(response.resultCode == "success"){
					loadFileList();
					alert("업로드 중이니 결과는 조회 하여 확인하세요");

				}
			},
			error : function(data) {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
			}


		}); //$.ajax

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
          <li><a href="${pageContext.request.contextPath}/usr/not0001.do">공지사항<br></a></li>
		  <li><a href="${pageContext.request.contextPath}/usr/inq0001.do">1:1문의<br></a></li>
		  <li><a href="${pageContext.request.contextPath}/usr/pay0001.do">입출금내역<br></a></li>
		  <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0002.do">대사<br></a></li>
          <li><a href="#" onclick="alert('준비중')">수익현황</a></li>
          <li><a href="${pageContext.request.contextPath}/usr/dty0004.do">배달정보 조회</a></li>
          <li class="dropdown"><a href="" onclick="javascript:return false;"><span>라이더/협력사 현황</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
            <ul>
              <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0001.do">협력사관리</a></li>
              <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0003.do">협력사계정관리</a></li>
              <li><a href="${pageContext.request.contextPath}/usr/mem0002.do">라이더관리</a></li>
			  <li><a href="${pageContext.request.contextPath}/usr/mem0004.do">내정보관리</a></li>
            </ul>
          </li>
          <li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;"  class="active"><span>자료 업로드</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
            <ul>
              <li><a href="${pageContext.request.contextPath}/usr/dty0001.do"  class="active">일별 자료 업로드</a></li>
              <li><a href="${pageContext.request.contextPath}/usr/dty0002.do">주별 자료 업로드</a></li>
              <li><a href="${pageContext.request.contextPath}/usr/dty0003.do">자료 업로드 이력</a></li>
            </ul>
          </li>
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
		<p class="tit">일별 자료 업로드</p>

			<input name="pageUnit" type="hidden" value="1000"/>
			<input name="pageSize" type="hidden" value="1000"/>
			<input id="searchError" type="hidden" value="${deliveryInfoVO.searchError}">
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
						<th>업로드일</th>
						<td>
							<input id="searchDate" class="form-control search fs-9" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
						</td>
						<th>파일명</th>
						<td>
							<select name='serchFileName' style='width: 100%' id='serchFileName'></select>
						</td>
					</tr>
					<tr>
						<th>라이더ID</th>
						<td>
							<input id="searchMberId" type="text" value="${deliveryInfoVO.searchMberId}">
						</td>
						<th>배달일</th>
						<td>
							<input id="searchRunDeDate" type="text" value="${deliveryInfoVO.searchRunDeDate}">
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
			<div style="height: 0px;" >
				<span class="pagetotal" style='margin-right:20px;'>업로드 성공<em id="TT_CNT0" >0</em></span>
				<span class="pagetotal">업로드 실패<em id="TT_CNT1">0</em></span>
			</div>

			<br>
			<div id="loadingOverlay" style="display: none;">Loading...</div>
			<div  class="ib_product">
				<div id="myGrid" class="ag-theme-alpine" style="height: 550px; width: 100%;"></div>
			</div>
			</div>
<!-- 		</form> -->

		<!-- AG Grid JavaScript -->
	<script>




			function 엑셀업로드(){
	            axios.post('/file/fileUpload.do',params).then(function(response) {
	            	debugger;
	            	if (response.data.resultList.length === 0) {
	            		grid.setGridOption('rowData',[]);  // 데이터가 없는 경우 빈 배열 설정
	            		grid.showNoRowsOverlay();  // 데이터가 없는 경우
	                   // grid.setGridOption('noRowsOverlay', true);  //데이터가 없는 경우
//	                    gridOptions.api.setGridOption('noRowsOverlay', true); // 데이터가 없는 경우
	                } else {
	                    grid.setGridOption('rowData', response.data.resultList);  //아래 라인과 동일한 의미
//	                    gridOptions.api.setGridOption('rowData', response.data.resultList); // 데이터가 있는 경우
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


			//jQuery를 이용한 Ajax 파일 업로드
			$("#uploadBtn").on("click", function(e){
				var formData = new FormData();
				var inputFile = $("input[name='fileName']");
				var files = inputFile[0].files;
				console.log(files);

				for(var i =0;i<files.length;i++){

					formData.append("fileName", files[i]);
				}

				$.ajax({
					//url: '${pageContext.request.contextPath}/uploadAjaxAction',
					url: '/file/fileUpload.do',
					processData : false,
					contentType : false,
					data : formData,
					type : 'POST',
					success : function(response){
		            	if (response.excelData.length === 0) {
		            		grid.setGridOption('rowData',[]);  // 데이터가 없는 경우 빈 배열 설정
		            		grid.showNoRowsOverlay();  // 데이터가 없는 경우
		                } else {
		                    grid.setGridOption('rowData', response.excelData);  //아래 라인과 동일한 의미
		                }
	                    data=response.resultList;
	                    document.getElementById('TT_CNT').textContent = currencyFormatter(response.excelData.length);

					}


				}); //$.ajax

			});



			//업로드 후 에러건만 화면 표기
			$("#uploadAfterErrorOutBtn").on("click", function(e){
				var formData = new FormData();
				var inputFile = $("input[name='uploadAfterErrorOut']");
				var files = inputFile[0].files;
				console.log(files);

				for(var i =0;i<files.length;i++){

					formData.append("fileName", files[i]);
				}

				$.ajax({
					//url: '${pageContext.request.contextPath}/uploadAjaxAction',
					url: '${pageContext.request.contextPath}/usr/dty0001_0001.do',
					processData : false,
					contentType : false,
					data : formData,
					type : 'POST',
					success : function(response){
						debugger;
		            	if (response.excelData.length === 0) {
		            		grid.setGridOption('rowData',[]);  // 데이터가 없는 경우 빈 배열 설정
		            		grid.showNoRowsOverlay();  // 데이터가 없는 경우
		                } else {
		                    grid.setGridOption('rowData', response.excelData);  //아래 라인과 동일한 의미
		                }
	                    data=response.resultList;
	                    document.getElementById('TT_CNT0').textContent = currencyFormatter(response.sCnt);
	                    document.getElementById('TT_CNT1').textContent = currencyFormatter(response.fCnt);
					}


				}); //$.ajax

			});



	</script>
	<!-- grid //-->
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