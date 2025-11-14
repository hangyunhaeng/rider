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
		{ headerName: "라이더ID", field: "mberId", minWidth: 140},
		{ headerName: "라이더명", field: "mberNm", minWidth: 140},
		{ headerName: "오류", field: "err", minWidth: 120, hide:true},
		{ headerName: "id", field: "id", minWidth: 120, hide:true},
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 140},
		{ headerName: "협력사명", field: "cooperatorNm", minWidth: 140},
		{ headerName: "입출금", field: "ioGubunNm", minWidth: 80, hide:true},
		{ headerName: "구분", field: "dwGubun", minWidth: 140, valueGetter:(params) => { return params.data.dwGubun== "DAY" ?"선지급":"확정"}},
		{ headerName: "정산여부", field: "weekNm", minWidth: 90},
		{ headerName: "발생일시", field: "creatDt", minWidth: 140},
		{ headerName: "금액", field: "sendPrice", minWidth: 80, cellClass: (params) => {return agGridUnderBarClass(params, 'ag-cell-right')}, valueGetter:(params) => { return currencyFormatter(params.data.sendPrice)}},
		{ headerName: "수수료", field: "fee", minWidth: 80, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.fee)}},
		{ headerName: "출금일", field: "tranDay", minWidth: 100, valueGetter:(params) => { return getStringDate(params.data.tranDay)}},
		{ headerName: "출금은행", field: "rvBankNm", minWidth: 100},
		{ headerName: "출금계좌", field: "rvAccount", minWidth: 140},
		{ headerName: "status", field: "status", minWidth: 140, hide:true},
		{ headerName: "출금상태코드", field: "statusCd", minWidth: 140},
		{ headerName: "출금상태", field: "statusNm", minWidth: 140},
		{ headerName: "errorMessage", field: "errorMessage", minWidth: 140},
		{ headerName: "출금일", field: "sendDt", minWidth: 140},
		{ headerName: "출금시", field: "sendTm", minWidth: 140},
		{ headerName: "telegramNo", field: "telegramNo", minWidth: 140, hide:true},
		{ headerName: "ioGubun", field: "ioGubun", minWidth: 140, hide:true},
		{ headerName: "dayAtchFileId", field: "dayAtchFileId", minWidth: 140, hide:true},
		{ headerName: "wekAtchFileId", field: "wekAtchFileId", minWidth: 140, hide:true},
		{ headerName: "fileDate", field: "wekAtchFileId", minWidth: 140, hide:true},
		{ headerName: "weekYn", field: "weekYn", minWidth: 140, hide:true},
		{ headerName: "정산기간", field: "accountsStDt", minWidth: 140, hide:true},
		{ headerName: "정산기간", field: "accountsEdDt", minWidth: 140, hide:true}
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
	    if(!limit2Week($('#searchFromDate').val(), $('#searchToDate').val(), JSON.parse('${exclus}'), '${loginVO.id}')){
	    	return;
	    }

		const params = new URLSearchParams();
		params.append('searchCooperatorId', $('#searchCooperatorId').val());
		params.append('searchFromDate', getOnlyNumber($('#searchFromDate').val()));
		params.append('searchToDate', getOnlyNumber($('#searchToDate').val()));
		params.append('searchNm', $('#searchNm').val().trim());
		params.append('searchDwGubun', $('#searchDwGubun').val());
// 		params.append('searchGubun', $('#searchGubun').val());

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/pay0001_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

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
				overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>',
				onCellClicked : function (event) { //onSelectionChanged  :row가 바뀌었을때 발생하는 이벤트인데 잘 안됨.
			    	selcetRow(event);
			    }
            };
        const gridDiv = document.querySelector('#myGrid');
        grid = agGrid.createGrid(gridDiv, gridOptions);

        grid.hideOverlay();

	}

	function selcetRow(params){
		if(params.column.colId == "sendPrice"){
			debugger;
			if(params.node.data.dwGubun == 'DAY'){
				if(params.node.data.ioGubun == '1'){
					$('#myForm').attr("action", "/usr/dty0001.do");
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchDate", value:params.node.data.fileDate}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchId", value:params.node.data.dayAtchFileId}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchMberId", value:params.node.data.mberId}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchRunDeDate", value:params.node.data.accountsStDt}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchError", value:"false"}));

					$('#myForm').submit();
				}
			}
			if(params.node.data.dwGubun == 'WEK'){
				if(params.node.data.ioGubun == '1'){
					$('#myForm').attr("action", "/usr/dty0002.do");
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchDate", value:params.node.data.fileDate}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchId", value:params.node.data.wekAtchFileId}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchMberId", value:params.node.data.mberId}));
					$('#myForm').submit();
				}
			}
		}
	}


	function agGridUnderBarClass(params, addClass){
		var pAddClass = (addClass =='undefined')? "" : addClass;
		if(params.node.data.ioGubun == '1' && params.node.data.dwGubun == 'DAY')	//입금 && 일정산
			return pAddClass+" tdul";
		if(params.node.data.ioGubun == '1' && params.node.data.dwGubun == 'WEK')	//입금 && 일정산
			return pAddClass+" tdul";

		else
			return pAddClass;
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
		<p class="tit">라이더 출금내역</p>

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
						<th>이체일</th>
						<td>
							<div>
								<input id="searchFromDate" class="form-control search fs-9 float-start w40p"" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
								<sm class="float-start">&nbsp;~&nbsp;</sm>
								<input id="searchToDate" class="form-control search fs-9 float-start w40p" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
							</div>
						</td>
						<th>구분</th>
						<td>
	 						<select id="searchDwGubun" name='searchDwGubun' style='width: 100%'>
								<option value="">전체</option>
								<option value="DAY">선지급</option>
								<option value="WEK">확정</option>
							</select>
						</td>
					</tr>
<!-- 					<tr> -->
<!-- 						<th>입출금구분</th> -->
<!-- 						<td colspan="3"> -->
<!-- 							<select id="searchGubun" name='searchGubun' style='width: 100%'> -->
<!-- 								<option value="all">전체</option> -->
<!-- 								<option value="1">입금</option> -->
<!-- 								<option value="2">출금</option> -->
<!-- 							</select> -->
<!-- 						</td> -->
<!-- 					</tr> -->
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