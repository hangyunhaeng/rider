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


	let gridOptions="";
	var grid="";
	var grid1="";
	let data;
	var columnDefs= [
		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120},
		{ headerName: "협력사이름", field: "cooperatorNm", minWidth: 90},
		{ headerName: "정산시작일", field: "accountsStDt", minWidth: 90},
		{ headerName: "정산종료일", field: "accountsEdDt", minWidth: 90},
		{ headerName: "파일명", field: "orignlFileNm", minWidth: 400, cellClass: 'ag-cell-left tdul'},
		{ headerName: "오류메세지", field: "erorrMsg", minWidth: 270, cellClass: 'ag-cell-left'},
		{ headerName: "삭제", field: "delete", minWidth: 80, cellClass: 'tdul'
			, cellRenderer:(params) => { return '<div onclick="clickDeleteWeek(\''+params.data.atchFileId+'\')">삭제</div>';}
		},
		{ headerName: "등록일", field: "creatDt", minWidth: 90, valueGetter:(params) => { return getStringDate(params.node.data.creatDt)} },
		{ headerName: "atchFileId", field: "atchFileId", minWidth: 90, hide:true},
		{ headerName: "weekId", field: "weekId", minWidth: 90, hide:true}
	];

	var columnDefs1= [
		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120},
		{ headerName: "협력사이름", field: "cooperatorNm", minWidth: 90},
		{ headerName: "배달건수", field: "cnt", minWidth: 90},
		{ headerName: "파일명", field: "orignlFileNm", minWidth: 400, cellClass: 'ag-cell-left tdul'},
		{ headerName: "오류메세지", field: "erorrMsg", minWidth: 270, cellClass: 'ag-cell-left'},
		{ headerName: "삭제", field: "delete", minWidth: 80, cellClass: 'tdul'
			, cellRenderer:(params) => { return '<div onclick="clickDeleteDay(\''+params.data.atchFileId+'\')">삭제</div>';}
		},
		{ headerName: "등록일", field: "creatDt", minWidth: 90, valueGetter:(params) => { return getStringDate(params.node.data.creatDt)} },
		{ headerName: "atchFileId", field: "atchFileId", minWidth: 90, hide:true}
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
		var serchDate = flatpickr("#searchDate", {
			locale: "ko",
			allowInput: false,
		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
		    dateFormat: 'Y-m-d',     // date format 형식
		    disableMobile: true          // 모바일 지원
		    ,plugins: [
		        new monthSelectPlugin({
		          shorthand: true, //defaults to false
		          dateFormat: "Y-m", //defaults to "F Y"
		          altFormat: "Y-m", //defaults to "F Y"
		          theme: "dark" // defaults to "light"
		        })
		    ]

		});
		serchDate.setDate(today.getFullYear()+"-"+(today.getMonth()+1));

		//이벤트 설정
		// 2. 조회버튼
		$('#loadDataBtn').on("click", function(){
			doSearch();
		});

		loadCooperatorList();

		//그리드 설정
		setGrid();
		setGrid1();
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

		const params = new URLSearchParams();
	    var regex = /[^0-9]/g;
		params.append('searchDate', $($('#searchDate')[0]).val().replace(regex, ""));
		params.append('searchCooperatorId', $('#searchCooperatorId').val());

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0003_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

			if(response.data.resultCode == "success"){

	        	if (response.data.resultWeek.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					var lst = response.data.resultWeek;	//정상데이터
	                grid.setGridOption('rowData', lst);
	            }

	        	if (response.data.resultDay.length == 0) {
	        		grid1.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid1.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					var lst = response.data.resultDay;	//정상데이터
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
	function selcetRow(params, gubun){
		if(params.column.colId == "orignlFileNm"){
			if(gubun == "day")
				$('#myForm').attr("action", "/usr/dty0001.do");
			else if(gubun == "week")
				$('#myForm').attr("action", "/usr/dty0002.do");
			$('#myForm').append($("<input/>", {type:"hidden", name:"searchDate", value:params.node.data.creatDt}));
			$('#myForm').append($("<input/>", {type:"hidden", name:"searchId", value:params.node.data.atchFileId}));
 			$('#myForm').submit();
		}

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
			    	selcetRow(event, 'week');
			    }
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
				overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>',
				onCellClicked : function (event) { //onSelectionChanged  :row가 바뀌었을때 발생하는 이벤트인데 잘 안됨.
			    	selcetRow(event, 'day');
			    }
            };
        const gridDiv = document.querySelector('#myGrid1');
        grid1 = agGrid.createGrid(gridDiv, gridOptions);

        grid1.hideOverlay();

	}

	function clickDeleteWeek(atchFileId){
		const params = new URLSearchParams();
	    var regex = /[^0-9]/g;
		params.append('searchDate', $($('#searchDate')[0]).val().replace(regex, ""));
		params.append('searchCooperatorId', $('#searchCooperatorId').val());
		params.append('searchAtchFileId', atchFileId);

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0003_0002.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

            if(response.data.resultCode != "success"){
				if(response.data.resultMsg != '' && response.data.resultMsg != null)
					alert(response.data.resultMsg);
				else alert("삭제 실패하였습니다.");
				return ;
			}
			if(response.data.resultCode == "success"){

	        	if (response.data.resultWeek.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					var lst = response.data.resultWeek;	//정상데이터
	                grid.setGridOption('rowData', lst);
	            }

	        	if (response.data.resultDay.length == 0) {
	        		grid1.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid1.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					var lst = response.data.resultDay;	//정상데이터
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

	function clickDeleteDay(atchFileId){
		const params = new URLSearchParams();
	    var regex = /[^0-9]/g;
		params.append('searchDate', $($('#searchDate')[0]).val().replace(regex, ""));
		params.append('searchCooperatorId', $('#searchCooperatorId').val());
		params.append('searchAtchFileId', atchFileId);

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0003_0003.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

            if(response.data.resultCode != "success"){
				if(response.data.resultMsg != '' && response.data.resultMsg != null)
					alert(response.data.resultMsg);
				else alert("삭제 실패하였습니다.");
				return ;
			}
			if(response.data.resultCode == "success"){

	        	if (response.data.resultWeek.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					var lst = response.data.resultWeek;	//정상데이터
	                grid.setGridOption('rowData', lst);
	            }

	        	if (response.data.resultDay.length == 0) {
	        		grid1.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid1.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					var lst = response.data.resultDay;	//정상데이터
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
		<p class="tit">자료 업로드 이력</p>

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
						<th>업로드월</th>
						<td>
							<input id="searchDate" class="form-control search fs-9" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
						</td>
						<th>협력사</th>
						<td colspan='3'>
							<select name='searchCooperatorId' style='width: 100%' id='searchCooperatorId'></select>
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

<!-- 				<div id="ajaxUp3" class="btnwrap"> -->
<!-- 				<p><input type="file" name="uploadAsync" multiple="multiple" class="btn ty2"/> -->
<!-- 				<button id="uploadAsyncBtn" class="btn btn-primary" >업로드</button> -->
<!-- 				</div> -->
			<!-- grid  -->

			<div style="height: 0px;" >
				<span class="pagetotal" style='margin-right:20px;'>주정산</span>
			</div>
			<div id="loadingOverlay" style="display: none;">Loading...</div>
			<div  class="ib_product">
				<div id="myGrid" class="ag-theme-alpine" style="height: 200px; width: 100%;"></div>
			</div>


			<!-- grid  -->

			<div style="height: 0px;" >
				<span class="pagetotal" style='margin-right:20px;'>일정산</span>
			</div>
			<div  class="ib_product">
				<div id="myGrid1" class="ag-theme-alpine" style="height: 330px; width: 100%;"></div>
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