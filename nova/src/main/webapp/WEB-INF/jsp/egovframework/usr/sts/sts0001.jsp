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
	let data;
	var columnDefs= [
		{ headerName: "NO", field: "rn", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "기준일자", field: "day", minWidth: 120},
		{ headerName: "협력사ID", field: "cooperatorId", minWidth: 120},
		{ headerName: "협력사명", field: "cooperatorNm", minWidth: 120},
		{ headerName: "라이더ID", field: "mberId", minWidth: 120},
		{ headerName: "라이더명", field: "mberNm", minWidth: 120},
		{ headerName: "관리용DB_선지급", field: "balance0", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.balance0)}},
		{ headerName: "관리용DB_확정금", field: "balance1", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.balance1)}},
		{ headerName: "실시간잔액_선지급", field: "ableBalance0", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ableBalance0)}},
		{ headerName: "실시간잔액_확정금", field: "ableBalance1", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ableBalance1)}},
		{ headerName: "접속", field: "con", minWidth: 90
			, cellRenderer:(params) => {return params.data.gubunNm== '라이더' ? '<div class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="clickCon(\''+params.data.mberId+'\')">접속</div>' : '';}
		},
		{ headerName: "gubunNm", field: "gubunNm", minWidth: 120, hide: true}
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

		searchFromDate.setDate(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());
		searchToDate.setDate(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());

		//그리드 설정
		setGrid();


		doSearch();
	});



	//내역 조회
	function doSearch(){

		const params = new URLSearchParams();
		params.append('searchFromDate', getOnlyNumber($('#searchFromDate').val()));
		params.append('searchToDate', getOnlyNumber($('#searchToDate').val()));
		params.append('searchGubun', $('#searchGubun').val());

	    if(!limit2Week($('#searchFromDate').val(), $('#searchToDate').val(), JSON.parse('${exclus}'), '${loginVO.id}')){
	    	return;
	    }

		// 로딩 시작
        $('.loading-wrap--js').show();
		axios.post('${pageContext.request.contextPath}/usr/sts0001_0001.do',params).then(function(response) {
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
                rowClassRules: {'ag-cell-err ': (params) => { debugger; return (params.data.balance0 !=  params.data.ableBalance0 || params.data.balance1 !=  params.data.ableBalance1) == true}},
				overlayLoadingTemplate: '<span class="ag-overlay-loading-center">로딩 중</span>',
				overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>'
            };
        const gridDiv = document.querySelector('#myGrid');
        grid = agGrid.createGrid(gridDiv, gridOptions);

        grid.hideOverlay();

	}


	function clickCon(mberId){

		const params = new URLSearchParams();
		params.append("mberId", mberId);
		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/mem0002_0008.do',params).then(function(response) {

            if(chkLogOut(response.data)){
            	return;
            }

        	// 로딩 종료
            $('.loading-wrap--js').hide();
        	if(response.data.resultCode == "success"){
        		window.open("${riderUrl}/com/com0004.do", "myForm");
        		$('#myForm').empty();
				$('#myForm').attr("action","${riderUrl}/com/com0004.do");
	            $('#myForm').attr("target", "myForm");
	            $('#myForm').append($("<input/>", {type:"hidden", name:"id", value:mberId}));
	            $('#myForm').append($("<input/>", {type:"hidden", name:"emplyrId", value:"${loginVO.id}"}));
	            $('#myForm').append($("<input/>", {type:"hidden", name:"gubun", value:"admin"}));
	            $('#myForm').append($("<input/>", {type:"hidden", name:"userSe", value:"GNR"}));
	            $('#myForm').append($("<input/>", {type:"hidden", name:"key", value:response.data.key}));
				$('#myForm').submit();
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
		<p class="tit">잔액 조회</p>

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
						<th>기준일</th>
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
								<option value="R">라이더</option>
								<option value="C">협력사</option>
								<option value="S">영업사원</option>
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