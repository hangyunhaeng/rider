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

            if(chkLogOut(response.data)){
            	return;
            }

			if(response.data.resultCode == "success"){

	            document.getElementById('TT_CNT0').textContent = currencyFormatter(response.data.list.length);
	            document.getElementById('TT_CNT1').textContent = 0;

	        	if (response.data.list.length == 0 && response.data.listE.length == 0) {
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
        axios.post('${pageContext.request.contextPath}/usr/dty0001_0002.do',formData).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

			if(response.data.resultCode == "success"){

				loadFileList();
				alert("업로드 중이니 결과는 조회 하여 확인하세요");
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

  <jsp:include page="../inc/nav.jsp" />

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
				<span class="pagetotal"style='margin-right:20px;'>업로드 실패<em id="TT_CNT1">0</em></span>
				<span class="pagetotal"> 운영사,협력사 수익은 모두 일정산 파일에서 계산됩니다</span>
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