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
	var pagePerCnt = 15;
	let gridOptions="";
	var grid="";
	let data;
	var columnDefs= [
		{ headerName: "NO", field: "rn", minWidth: 70 },
		{ headerName: "fix", field: "fix", minWidth: 120, hide:true},
		{ headerName: "kkoId", field: "kkoId", minWidth: 120, hide:true},
		{ headerName: "upKkoId", field: "upKkoId", minWidth: 120, hide:true},
		{ headerName: "ID", field: "mberId", minWidth: 80},
		{ headerName: "이름", field: "mberNm", minWidth: 80},
		{ headerName: "구분", field: "gubun", minWidth: 80, valueGetter:(params) => { return params.data.gubun== "1" ?"토큰":"알림톡"}},
		{ headerName: "템플릿", field: "temblateNm", minWidth: 80},
		{ headerName: "발송번호", field: "mbtlnum", minWidth: 120},
		{ headerName: "url", field: "url", minWidth: 120, hide:true},
		{ headerName: "발송메세지", field: "sendLongtxt", minWidth: 160},
		{ headerName: "수신", field: "recvLongtxt", minWidth: 160},
		{ headerName: "code", field: "code", minWidth: 120, hide:true},
		{ headerName: "referenceKey", field: "referenceKey", minWidth: 120, hide:true},
		{ headerName: "userKey", field: "userKey", minWidth: 120, hide:true},
		{ headerName: "상태", field: "status", minWidth: 60, valueGetter:(params) => { return params.data.status== "1" ?"발송(접수)": params.data.status== "3" ? "완료" : params.data.status== "2" ? "재발송" :"" }},
		{ headerName: "알림톡CODE", field: "kaorsltcode", minWidth: 80},
		{ headerName: "비고", field: "bigo", minWidth: 170},
		{ headerName: "발송일", field: "sendDt", minWidth: 120, valueGetter:(params) => { return getStringDate(params.data.sendDt)}},
		{ headerName: "알림톡결과", field: "cdNm", minWidth: 80}
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
			doSearch(1, paging.objectCnt);
		});

		searchFromDate.setDate(towWeekAgo.getFullYear()+"-"+(towWeekAgo.getMonth()+1)+"-"+towWeekAgo.getDate());
		searchToDate.setDate(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());

		//페이징설정
		paging.createPaging('#paging', 1, pagePerCnt, doSearch);

		//그리드 설정
		setGrid();


		doSearch((${kkoVO.schIdx}==0)?1: ${kkoVO.schIdx}, paging.objectCnt);
	});



	//내역 조회
	function doSearch(schIdx, schPagePerCnt){

		const params = new URLSearchParams();
		params.append('searchFromDate', getOnlyNumber($('#searchFromDate').val()));
		params.append('searchToDate', getOnlyNumber($('#searchToDate').val()));
		params.append('searchGubun', $('#searchGubun').val());
		params.append("schIdx", schIdx);
		params.append("schPagePerCnt", schPagePerCnt);

	    if(!limit2Week($('#searchFromDate').val(), $('#searchToDate').val())){
	    	return;
	    }

		// 로딩 시작
        $('.loading-wrap--js').show();
		axios.post('${pageContext.request.contextPath}/usr/pay0007_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

			if(response.data.resultCode == "success"){

	            document.getElementById('TT_CNT0').textContent = currencyFormatter(response.data.cnt);

	        	if (response.data.list.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {
					var lst = response.data.list;	//정상데이터
	                grid.setGridOption('rowData', lst);
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

  <jsp:include page="../inc/nav.jsp" />

	<!-- 숨겨진 폼 -->
	<form id="myForm" action="/conv/conv02410.do" method="POST" style="display: none;">
		<!-- <input type="hidden" name=taskNo id="taskNo"> -->
	</form>

	<div class="keit-header-body innerwrap clearfix">
		<p class="tit">알림톡 발송 조회</p>

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
						<th>발송일</th>
						<td>
							<div>
								<input id="searchFromDate" class="form-control search fs-9 float-start w40p"" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
								<sm class="float-start">&nbsp;~&nbsp;</sm>
								<input id="searchToDate" class="form-control search fs-9 float-start w40p" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
							</div>
						</td>
						<th>구분</th>
						<td>
							<select id="searchGubun" name='searchGubun' style='width: 100%'>
								<option value="all">전체</option>
								<option value="1">토큰</option>
								<option value="2">알림톡</option>
							</select>
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
				<div id="paging" class="d-flex align-items-center justify-content-center mt-3"></div>
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