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


	let gridOptions="";
	var pagePerCnt = 15;
	var grid="";
	var grid1="";
	let data;
	let data1;
	var columnDefs= [
		{ headerName: "NO", field: "rn", minWidth: 70},
		{ headerName: "crud", field: "crud", minWidth: 90, hide:true},
		{ headerName: "inqId", field: "inqId", minWidth: 90, hide:true},
		{ headerName: "제목", field: "title", minWidth: 300, cellClass: 'ag-cell-left'},
		{ headerName: "등록일", field: "creatDt", minWidth: 90},
		{ headerName: "등록자", field: "creatNm", minWidth: 90}
	];

    const maxLength0 = 50;
    const maxLength1 = 500;

	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		if('${loginVO.authorCode}' =='ROLE_ADMIN'){
			$('nav > ul').find('li:hidden').show();
		}

		$('#reTitle').parent().find('span').text($('#reTitle').val().length+"/"+maxLength0);
        $('#reLongtxt').parent().find('span').text($('#reLongtxt').val().length+"/"+maxLength1);

		//이벤트 설정
        const enforceLength0 = (event) => {
            const value = event.target.value;
            if (value.length > maxLength0) {
                event.target.value = value.slice(0, maxLength0);
            }
            $('#reTitle').parent().find('span').text($('#reTitle').val().length+"/"+maxLength0);
        };

        const enforceLength1 = (event) => {
            const value = event.target.value;
            if (value.length > maxLength1) {
                event.target.value = value.slice(0, maxLength1);
            }
            $('#reLongtxt').parent().find('span').text($('#reLongtxt').val().length+"/"+maxLength1);
        };

        document.querySelector("#reTitle").addEventListener("input", enforceLength0);
        document.querySelector("#reLongtxt").addEventListener("input", enforceLength1);

		//페이징설정
		paging.createPaging('#paging', 1, pagePerCnt, loadList);

		//그리드 설정
		setGrid();
		loadList(1, paging.objectCnt);
	});


	function loadList(schIdx, schPagePerCnt){

		const params = new URLSearchParams();
		params.append("schIdx", schIdx);
		params.append("schPagePerCnt", schPagePerCnt);

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/inq0001_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
        	if(response.data.resultCode == "success"){
	        	if (response.data.list.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

	            	data = response.data.list;	//정상데이터
					grid.setGridOption("rowData", data);
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
	}


	var bfSelNode;		//onSelectionChanged가 안되서 임시로 만듬
	function selcetRow(params){

		var nowSelNode = findRowNode(grid, 'inqId', params.node.data.inqId);
		if(bfSelNode != nowSelNode){
			bfSelNode = nowSelNode;

			drawInquiry(params.node.data.inqId);


		}
	}

	function doModify(obj){
		debugger;
		$('#reInqId').val( $(obj).closest('.drawTable').find('[name=inqId]').val() );
		$('#reTitle').val( $(obj).closest('.drawTable').find('[name=title]').text() );
		$('#reLongtxt').val( replaceRevTag(replaceN($(obj).closest('.drawTable').find('[name=longtxt]').html()) ));
	}
	function doDelete(obj){
		if(confirm("삭제하시겠습니까?")){
			const inputParams = new URLSearchParams();
			inputParams.append("inqId", $(obj).closest('.drawTable').find('[name=inqId]').val());

			// 로딩 시작
	        $('.loading-wrap--js').show();
	        axios.post('${pageContext.request.contextPath}/usr/inq0001_0004.do',inputParams).then(function(response) {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
	        	if(response.data.resultCode == "success"){
	        		drawInquiry($('#inqId').val());
	        	}
	        })
	        .catch(function(error) {
	            console.error('There was an error fetching the data:', error);
	        }).finally(function() {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
	        });
		}

	}
	function drawInquiry(inqId){
		const inputParams = new URLSearchParams();
		inputParams.append("inqId", inqId);

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/inq0001_0002.do',inputParams).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

        	if(response.data.resultCode == "success"){
        		$('#reTitle').val('');
        		$('#reLongtxt').val('');
        		$('#myGrid1').find('.drawTable:visible').remove();
        		$('#답변버튼').hide();
        		if (response.data.list.length > 0){

        			for(var i = 0 ; i < response.data.list.length ; i++){
        				var one = response.data.list[i];

						if(one.gubun == 'Q'){
							$('#inqId').val(one.inqId);
							$('#title').text('').append(one.title);
							$('#longtxt').text('').append(replaceRevN(one.longtxt));
							$('#creatNm').text('').append(one.creatNm);
							$('#creatDt').text('').append(one.creatDt);
							$('#답변버튼').show();
						} else {
							var 내역 = $('.drawTable:hidden').clone();
							$('#myGrid1').append(내역);
							if(one.modifyAuth=='Y'){
								내역.find(".btn:hidden").show();
							}
							내역.find("[name=inqId]").val(one.inqId);
							내역.find("[name=title]").text(one.title);
							내역.find("[name=creatNm]").text(one.creatNm);
							내역.find("[name=creatDt]").text(one.creatDt);
							내역.find("[name=longtxt]").html(replaceRevN(one.longtxt));
							내역.show();
						}

        			}
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
				suppressScrollOnNewData: true,
				onCellClicked : function (event) { //onSelectionChanged  :row가 바뀌었을때 발생하는 이벤트인데 잘 안됨.
			    	selcetRow(event);
			    },
			    getRowStyle: params => {
			        if (params.node.data.crud == 'c' || params.node.data.crud == 'u') {
			            return { background: '#e99494' };
			        }
			        if (params.node.data.crud == 'd') {
			            return { background: '#65676b' };
			        }
			    }
            };
        const gridDiv = document.querySelector('#myGrid');
        grid = agGrid.createGrid(gridDiv, gridOptions);

        grid.hideOverlay();

	}
	function doTask(){


		if($('#reTitle').val().trim() == ''){
			alert('제목을 입력하세요');
			return;
		}
		if($('#reLongtxt').val().trim() == ''){
			alert('내용을 입력하세요');
			return;
		}

		const inputParams = new URLSearchParams();
		inputParams.append("inqId", $('#reInqId').val());
		inputParams.append("upInqId", $('#inqId').val());
		inputParams.append("title", $('#reTitle').val());
		inputParams.append("longtxt", $('#reLongtxt').val());
		inputParams.append("useAt", "Y");


		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/inq0001_0003.do',inputParams).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

        	if(response.data.resultCode == "success"){
        		alert("저장되었습니다");
        		drawInquiry($('#inqId').val());
        	} else {
        		alert("저장에 실패하였습니다");
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
		<div
			class="container-fluid container-xl position-relative d-flex align-items-center">

			<a href="${pageContext.request.contextPath}/com/com0002.do"
				class="logo d-flex align-items-center me-auto"> <!-- Uncomment the line below if you also wish to use an image logo -->
				<!-- <img src="/images/admin/logo.png" alt=""> -->
				<h1 class="sitename">RIDER BANK</h1>
			</a>


			<nav id="navmenu" class="navmenu">
				<ul>
					<li><a href="${pageContext.request.contextPath}/usr/not0001.do">공지사항<br></a></li>
					<li><a href="${pageContext.request.contextPath}/usr/inq0001.do" class="active">1:1문의<br></a></li>
					<li><a href="${pageContext.request.contextPath}/usr/pay0001.do">입출금내역<br></a></li>
		  			<li style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0002.do">대사<br></a></li>
			        <li class="dropdown"><a href="" onclick="javascript:return false;"><span>수익현황</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
			              <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0003.do">운영사수익현황</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/pay0004.do">협력사수익현황</a></li>
			            </ul>
			        </li>
					<li><a href="${pageContext.request.contextPath}/usr/dty0004.do">배달정보 조회</a></li>
					<li class="dropdown"><a href="" onclick="javascript:return false;"><span>라이더/협력사 현황</span><i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0001.do">협력사관리</a></li>
              				<li style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0003.do">협력사계정관리</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/mem0002.do">라이더관리</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/mem0004.do">내정보관리</a></li>
						</ul></li>
					<li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;"><span>자료 업로드</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li><a href="${pageContext.request.contextPath}/usr/dty0001.do">일별 자료 업로드</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0002.do">주별 자료 업로드</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0003.do">자료 업로드 이력</a></li>
						</ul></li>
				</ul>
				<i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
			</nav>
			<a class="btn-getstarted" href="${pageContext.request.contextPath }/uat/uia/actionLogout.do" style="height: 37px;"><spring:message code="comCmm.unitContent.3" /></a>


		</div>
	</header>

	<main class="main" style="height: 60px;">

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
	<form id="myForm" action="/conv/conv02410.do" method="POST"
		style="display: none;">
		<!-- <input type="hidden" name=taskNo id="taskNo"> -->
	</form>

	<div class="keit-header-body innerwrap clearfix">
		<p class="tit">1:1문의</p>

		<input name="pageUnit" type="hidden" value="1000" /> <input
			name="pageSize" type="hidden" value="1000" />
		<!--과제관리_목록 -->
		<div class="search_box ty2">

			<br>

			<div style="float: left; width: 49%; margin-right: 1%">
				<div style="margin-bottom:10px;">
					<span class="pagetotal" style='margin-right: 20px;'>문의사항</span>
					<div class="btnwrap" style="">
<!-- 						<button id="추가버튼" class="btn btn-primary">추가</button> -->
					</div>
				</div>
				<div id="loadingOverlay" style="display: none;">Loading...</div>


				<div class="ib_product">
					<div id="myGrid" class="ag-theme-alpine" style="height: 550px; width: 100%;"></div>
					<div id="paging" class="d-flex align-items-center justify-content-center mt-3"></div>
				</div>
			</div>
			<div style="float: left; width: 50%;">

				<!-- grid  -->

				<div style="height: 0px;">
					<span class="pagetotal" style='margin-right: 20px;'>답변</span>
					<div class="btnwrap">
						<button id="답변버튼" class="btn btn-primary" style="display:none;" onclick="doTask();">저장</button>
					</div>
				</div>
				<div class="ib_product">
					<div id="myGrid1" class="ag-theme-alpine" style="height: 550px; width: 100%;">

						<input id="reInqId" name="reInqId" type=hidden value="">
						<table>
							<colgroup>
								<col style="width: 13%">
								<col style="width: *">
							</colgroup>
							<tr>
								<th>제목</th>
								<td>
									<input id="reTitle" name="reTitle" type=text value="" style="max-width: calc(100% - 50px);width:100%;"><span>100/100</span>
								</td>
							</tr>
							<tr>
								<th>내용</th>
								<td>
									<textarea id="reLongtxt" name="reLongtxt" type=text value="" style="height:200px; max-width: calc(100% - 50px);"></textarea><span>100/100</span>
								</td>
							</tr>
						</table>

						<br/>

						<input type="hidden" id="inqId" />
						<table>
							<colgroup>
								<col style="width: 13%">
								<col style="width: 37%">
								<col style="width: 13%">
								<col style="width: *">
							</colgroup>
							<tr>
								<th>제목</th>
								<td colspan='3'>
									<sm id="title"></sm>
								</td>
							</tr>
							<tr>
								<th>등록자</th>
								<td>
									<sm id="creatNm"></sm>
								</td>
								<th>등록일</th>
								<td>
									<sm id="creatDt"></sm>
								</td>
							</tr>
							<tr>
								<th>내용</th>
								<td colspan='3'>
									<sm id="longtxt"></sm>
								</td>
							</tr>
						</table>

						<!-- 반복부 시작 -->
						<div class="drawTable" style="display:none;">
							<div style="margin-bottom:10px;">
								<span class="pagetotal" style="margin-right: 20px;"><img src="/images/egovframework/com/cmm/bul/bul_i.jpg" style="width:30px;" />답변</span>

									<div class="btnwrap">
										<button class="btn btn-primary" style="display:none;" onclick="doModify(this)">수정</button>
										<button class="btn btn-primary" style="display:none;" onclick="doDelete(this)">삭제</button>
									</div>
							</div>
							<input type="hidden" name="inqId" />
							<table>
								<colgroup>
									<col style="width: 13%">
									<col style="width: 37%">
									<col style="width: 13%">
									<col style="width: *">
								</colgroup>
								<tr>
									<th>제목</th>
									<td colspan="3">
										<sm name="title"></sm>
									</td>
								</tr>
								<tr>
									<th>등록자</th>
									<td>
										<sm name="creatNm"></sm>
									</td>
									<th>등록일</th>
									<td>
										<sm name="creatDt"></sm>
									</td>
								</tr>
								<tr>
									<th>내용</th>
									<td colspan="3">
										<sm name="longtxt"></sm>
									</td>
								</tr>
							</table>
						</div>
						<!-- 반복부 종료 -->

					</div>
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