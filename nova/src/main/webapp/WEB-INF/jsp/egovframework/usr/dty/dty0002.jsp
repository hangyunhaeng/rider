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

            if(chkLogOut(response.data)){
            	return;
            }

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

		debugger;
		// 로딩 시작
        $('.loading-wrap--js').show();

//			url: '${pageContext.request.contextPath}/usr/dty0002_0002.do',	//async
//			url: '${pageContext.request.contextPath}/usr/dty0002_0003.do',	//sync
//			url: '${pageContext.request.contextPath}/usr/dty0002_0005.do',	//대용량 아님
        axios.post('${pageContext.request.contextPath}/usr/dty0002_0005.do',formData).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

            if(response.data.resultCode != "success"){
				if(response.data.resultMsg != '' && response.data.resultMsg != null)
					alert(response.data.resultMsg);
				else alert("주별 자료 업로드에 실패하였습니다\n엑셀 내용을 확인 후 다시 업로드 하시기 바랍니다");
				return ;
			}

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
        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
        });



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

  <jsp:include page="../inc/nav.jsp" />

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