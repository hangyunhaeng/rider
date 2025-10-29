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
		{ headerName: "구분", field: "gubunNm", minWidth: 120},
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120},
		{ headerName: "성명", field: "nm", minWidth: 120},
		{ headerName: "출금일", field: "tranDay", minWidth: 100, valueGetter:(params) => { return getStringDate(params.data.tranDay)}},
		{ headerName: "출금시", field: "sendTm", minWidth: 140},
		{ headerName: "수취인", field: "drwAccountCntn", minWidth: 140},
		{ headerName: "수취은행", field: "rvBankNm", minWidth: 140},
		{ headerName: "수취계좌", field: "rvAccount", minWidth: 140},
		{ headerName: "금액", field: "sendPrice", minWidth: 140
			, cellClass : "ag-cell-right"
			, valueGetter:(params) => { return currencyFormatter(params.data.sendPrice);}
		},
		{ headerName: "잔액", field: "trAfterBac", minWidth: 140
			, cellClass : "ag-cell-right"
			, valueGetter:(params) => { debugger; return params.data.trAfterBac == null? "-" : currencyFormatter(params.data.trAfterBac);}
		},
		{ headerName: "오류메세지", field: "errorMessage", minWidth: 140},
		{ headerName: "statusCd", field: "statusCd", minWidth: 140, hide:true},


		{ headerName: "이체수수료", field: "sendFee", minWidth: 90
			, cellClass : "ag-cell-right"
			, valueGetter:(params) => { return currencyFormatter(params.data.sendFee);}
		},
		{ headerName: "선지급수수료", field: "dayFee", minWidth: 90
			, cellClass : "ag-cell-right"
			, valueGetter:(params) => { return currencyFormatter(params.data.dayFee);}
		}

	];


	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		//업로드일 세팅
		var today = new Date();
		var now = new Date();
		var oneMonthAgo = new Date(now.setMonth(new Date().getMonth() - 1));
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

	//내역 조회
	function doSearch(){

		const params = new URLSearchParams();
		params.append('searchGubun', $('#searchGubun').val());
		params.append('searchCooperatorId', $('#searchCooperatorId').val());
		params.append('searchNm', $('#searchNm').val());
		params.append('searchFromDate', getOnlyNumber($('#searchFromDate').val()));
		params.append('searchToDate', getOnlyNumber($('#searchToDate').val()));

// 	    if(!limit2Week($('#searchFromDate').val(), $('#searchToDate').val())){
// 	    	return;
// 	    }

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/pay0010_0001.do',params).then(function(response) {
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
				overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>'
            };
        const gridDiv = document.querySelector('#myGrid');
        grid = agGrid.createGrid(gridDiv, gridOptions);

        grid.hideOverlay();

	}


    function downloadExcel() {
    	var fileName;
        const rows = [];
        const sum = [];
        grid.forEachNode((node) => {
            rows.push([node.data.gubunNm, node.data.cooperatorId, node.data.nm, getStringDate(node.data.tranDay)
            	, node.data.sendTm, node.data.drwAccountCntn, node.data.rvBankNm, node.data.rvAccount
            	, node.data.errorMessage
            	, (node.data.sendPrice)
            	, node.data.trAfterBac
            	, (node.data.sendFee)
            	, (node.data.dayFee)
            	]);


        });




        // 첫 번째 행을 추가하여 헤더를 포함
        rows.unshift(['구분', '협력사아이디', '성명', '출금일', '출금시', '수취인', '수취은행', '수취계좌'
        	, '오류메세지', '금액', '잔액', '이체수수료', '선지급수수료']);



        const ws = XLSX.utils.aoa_to_sheet(rows);

        // 모든 셀의 형식을 텍스트로 설정
        const range = XLSX.utils.decode_range(ws['!ref']);
        for (let R = range.s.r; R <= range.e.r; ++R) {
            for (let C = range.s.c; C <= range.e.c; ++C) {
                const cell_address = {c: C, r: R};
                const cell_ref = XLSX.utils.encode_cell(cell_address);

                if (!ws[cell_ref]) continue;
                if(cell_address.c == 9 && cell_address.r != 0)ws[cell_ref].t = 'n';  // 셀 형식을 숫자로 설정(금액)
                if(cell_address.c == 10 && cell_address.r != 0)ws[cell_ref].t = 'n';  // 셀 형식을 숫자로 설정(금액)
                if(cell_address.c == 8)ws[cell_ref].t = 's';  // 셀 형식을 텍스트로 설정(수취계좌)
            }
        }


        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
        XLSX.writeFile(wb, '출금내역.xlsx');
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
		<p class="tit">출금내역 현황 및 다운로드</p>

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
						<th>이름</th>
						<td>
							<input id="searchNm" type="text" >
						</td>
					</tr>
					<tr>
						<th>이체구분</th>
						<td>
							<select id="searchGubun" name='searchGubun' style='width: 100%'>
								<option value="all">전체</option>
								<option value="success" selected>성공</option>
								<option value="fail">실패</option>
							</select>
						</td>
						<th>출금일</th>
						<td>
							<div>
								<input id="searchFromDate" class="form-control search fs-9 float-start w40p"" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
								<sm class="float-start">&nbsp;~&nbsp;</sm>
								<input id="searchToDate" class="form-control search fs-9 float-start w40p" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
							</div>
						</td>
					</tr>
					<tr>

					</tr>
				</table>

				<div class="btnwrap">
					<button class="btn btn-primary" onclick="downloadExcel();">엑셀 다운로드</button>
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