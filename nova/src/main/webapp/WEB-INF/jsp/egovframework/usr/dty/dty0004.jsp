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
<link href="<c:url value='/vendor/admin/aos/aos.css' />" rel="stylesheet">
<link href="<c:url value='/vendor/admin/fontawesome-free/css/all.min.css' />" rel="stylesheet">
<link href="<c:url value='/vendor/admin/glightbox/css/glightbox.min.css' />" rel="stylesheet">
<link href="<c:url value='/vendor/admin/swiper/swiper-bundle.min.css' />" rel="stylesheet">

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
		{ headerName: "상품가격", field: "goodsPrice", minWidth: 90},
		{ headerName: "픽업 주소", field: "pickupAddr", minWidth: 200, cellClass: 'ag-cell-left'},
		{ headerName: "전달지 주소", field: "destinationAddr", minWidth: 200, cellClass: 'ag-cell-left'},
		{ headerName: "주문시간", field: "orderDt", minWidth: 150},
		{ headerName: "배차완료", field: "operateRiderDt", minWidth: 150},
		{ headerName: "가게도착", field: "shopComeinDt", minWidth: 150},
		{ headerName: "픽업완료", field: "pickupFinistDt", minWidth: 150},
		{ headerName: "전달완료", field: "deliveryFinistDt", minWidth: 150},
		{ headerName: "거리", field: "distance", minWidth: 80},
		{ headerName: "추가배달사유", field: "addDeliveryReason", minWidth: 200},
		{ headerName: "추가배달상세내용", field: "addDeliveryDesc", minWidth: 200},
		{ headerName: "픽업지 법정동 ", field: "pickupLawDong", minWidth: 90},
		{ headerName: "기본단가", field: "basicPrice", minWidth: 90},
		{ headerName: "기상할증", field: "weatherPrimage", minWidth: 90},
		{ headerName: "추가할증", field: "addPrimage", minWidth: 90},
		{ headerName: "피크할증 등 ", field: "peakPrimageEtc", minWidth: 90},
		{ headerName: "배달처리비", field: "deliveryPrice", minWidth: 90},
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
		var now = new Date();
		var oneMonthAgo = new Date(now.setMonth(now.getMonth()-1));
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

		searchFromDate.setDate(oneMonthAgo.getFullYear()+"-"+(oneMonthAgo.getMonth()+1)+"-"+oneMonthAgo.getDate());
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
		if($('#searchRegistrationSn').val().trim() != '' && getOnlyNumber($('#searchRegistrationSn').val().trim()).length != 10){
			alert("사업자번호는 10자리입니다");
			$('#searchRegistrationSn').focus()
			return ;
		}

		const params = new URLSearchParams();
		params.append('searchCooperatorId', $('#searchCooperatorId').val());
		params.append('searchFromDate', getOnlyNumber($('#searchFromDate').val()));
		params.append('searchToDate', getOnlyNumber($('#searchToDate').val()));
		params.append('searchNm', $('#searchNm').val().trim());
		params.append('searchRegistrationSn', getOnlyNumber($('#searchRegistrationSn').val().trim()));

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0004_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
			if(response.data.resultCode == "success"){

	            document.getElementById('TT_CNT0').textContent = currencyFormatter(response.data.list.length);

	        	if (response.data.list.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {
					var lst = response.data.list;	//정상데이터
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
				overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>'
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
          <li class="dropdown"><a href="" onclick="javascript:return false;"><span>수익현황</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
          	<ul>
              <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0003.do">운영사수익현황</a></li>
			  <li><a href="${pageContext.request.contextPath}/usr/pay0004.do">협력사수익현황</a></li>
            </ul>
          </li>
          <li><a href="${pageContext.request.contextPath}/usr/dty0004.do" class="active">배달정보 조회</a></li>
          <li class="dropdown"><a href="" onclick="javascript:return false;"><span>라이더/협력사 현황</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
            <ul>
              <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0001.do">협력사관리</a></li>
              <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0003.do">협력사계정관리</a></li>
              <li><a href="${pageContext.request.contextPath}/usr/mem0002.do">라이더관리</a></li>
			  <li><a href="${pageContext.request.contextPath}/usr/mem0004.do">내정보관리</a></li>
            </ul>
          </li>
          <li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;"><span>자료 업로드</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
            <ul>
              <li><a href="${pageContext.request.contextPath}/usr/dty0001.do">일별 자료 업로드</a></li>
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
						<th>사업자번호</th>
						<td>
							<input id="searchRegistrationSn" type="text" oninput="this.value = this.value.replace(/[^0-9-]/g, '').replace(/(\..*)\./g, '$1');">
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