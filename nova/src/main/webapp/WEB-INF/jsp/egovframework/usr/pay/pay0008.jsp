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
		{ headerName: "copId", field: "copId", minWidth: 120, hide:true},
		{ headerName: "금액", field: "sendPrice", minWidth: 140
			, cellClass : "ag-cell-right"
			, valueGetter:(params) => { return currencyFormatter(params.data.sendPrice);}
		},
		{ headerName: "수수료", field: "sendFee", minWidth: 90
			, cellClass : "ag-cell-right"
			, valueGetter:(params) => { return currencyFormatter(params.data.sendFee);}
		},
		{ headerName: "출금일", field: "tranDay", minWidth: 100, valueGetter:(params) => { return getStringDate(params.data.tranDay)}},
		{ headerName: "출금은행", field: "rvBankNm", minWidth: 100},
		{ headerName: "출금계좌", field: "rvAccount", minWidth: 140},
		{ headerName: "status", field: "status", minWidth: 140, hide:true, hide:true},
		{ headerName: "statusCd", field: "statusCd", minWidth: 140, hide:true},
		{ headerName: "상태", field: "statusNm", minWidth: 140},
		{ headerName: "오류메세지", field: "errorMessage", minWidth: 140},
		{ headerName: "출금일", field: "sendDt", minWidth: 140, hide:true},
		{ headerName: "출금시", field: "sendTm", minWidth: 140, hide:true}

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

		//그리드 설정
		setGrid();

		var ablePrice = JSON.parse('${ablePrice}');

		var 내역 = $('#반복부').find('[repeatObj=true]:hidden:eq(0)').clone();
		내역.find('sm[name=coopAblePrice]').html(currencyFormatter(ablePrice.result.salesAblePrice));
		내역.find('input[name=cost]').on("input", function(e){
			onInputVal(this, ablePrice.result.salesAblePrice-${sendFee});
			calPrice(this);
		});
		내역.find('button').on("click", function(e){
			doAct(this);
		});

		$('#반복부').append(내역);
		내역.show();

		if('${loginVO.authorCode}' =='ROLE_SALES'){
			$('#div출금').show();
		}

	});

	//내역 조회
	function doSearch(){

		const params = new URLSearchParams();
		params.append('searchFromDate', getOnlyNumber($('#searchFromDate').val()));
		params.append('searchToDate', getOnlyNumber($('#searchToDate').val()));

	    if(!limit2Week($('#searchFromDate').val(), $('#searchToDate').val(), JSON.parse('${exclus}'), '${loginVO.id}')){
	    	return;
	    }

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/pay0008_0001.do',params).then(function(response) {
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

	function onInputVal(obj, maxInt){
		//빈값이면 0으로
		if(obj.value == "") obj.value = 0;
		//모두 숫자로 변환
		obj.value = obj.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');
		maxInt = String(maxInt).replace(/[^0-9-]/g, '').replace(/(\..*)\./g, '$1');
		maxInt = minWon0(maxInt);	//-는 없음

		//최대값보다 큰값이 들어오면 최대값으로 변환
		if(typeof(maxInt) != 'undefined'){
			if(parseInt(obj.value, 10)> parseInt(maxInt, 10)){
				obj.value = maxInt;
			}
		}

		//콤마 붙여서 리턴
		obj.value = currencyFormatter(parseInt(obj.value, 10));
	}
	function calPrice(obj){

		var cost = $(obj).closest('tr').find('input[name=cost]').val().replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');

	}


	var actObj;
	//출금요청
	function doAct(obj){

		if("${myInfoVO.accountNum}" == null || "${myInfoVO.accountNum}".trim() == '' ){
			if(confirm('계좌가 등록되어있지 않습니다.\n내정보관리 메뉴에서 계좌등록을 하셔야 합니다.\n\n계좌등록화면으로 이동하시겠습니까?')){
				$('#myForm').attr("action", "${pageContext.request.contextPath}/usr/mem0004.do");
				$('#myForm').submit();
				return;
			}
			return;
		}

		if(Number($(obj).closest('tr').find('input[name=cost]').val().replace(/[^0-9]-/g, '').replace(/(\..*)\./g, '$1'), 10) <= 0){
			alert('출금금액을 입력하세요');
			$(obj).closest('tr').find('input[name=cost]').focus();
			return;
		}


		actObj = obj;

		const params = new URLSearchParams();
		params.append('cooperatorId', $(obj).closest('tr').find('input[name=cooperatorId]').val());
		params.append('inputPrice', $(obj).closest('tr').find('input[name=cost]').val().replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1'));

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/pay0008_0002.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
			if(response.data.resultCode == "success"){
				var gubun = $(actObj).closest('tr').find('input[name="gubun"]').val();
				$(actObj).closest('tr').find('sm[name=coopAblePrice]').html(currencyFormatter(response.data.ablePrice.salesAblePrice));
				$(actObj).closest('tr').find('input[name=cost]').on("input", function(e){
					onInputVal(this, response.data.ablePrice.salesAblePrice-${sendFee});
				});
				$(actObj).closest('tr').find('input[name=cost]').val(0);
				calPrice($(actObj).closest('tr').find('input[name=cost]'));
				doSearch();
			} else{
				if(response.data.resultMsg != '' && response.data.resultMsg != null)
					alert(response.data.resultMsg);
				else alert("출금에 실패하였습니다");
				return ;
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
		<p class="tit">영업사원 출금내역 현황</p>

			<input name="pageUnit" type="hidden" value="1000"/>
			<input name="pageSize" type="hidden" value="1000"/>
			<!--과제관리_목록 -->
			<div class="search_box ty2">

			<div id="div출금" style="display:none;">
				<table id="반복부">
					<colgroup>
						<col style="width: 13%">
						<col style="width: 17%">
						<col style="width: 13%">
						<col style="width: *">
					</colgroup>

					<tr repeatObj="true" style="display:none;">
						<th>출금가능금액</th>
						<td>
							<sm name="coopAblePrice"></sm>
						</td>
						<th>출금금액</th>
						<td>
							<input name="cost" type="text" style="width:calc(100% - 240px);" maxlength="15" oninput="">
							<button class="btn ty1">출금요청</button>
							<sm>&nbsp;&nbsp;이체 수수료 - 300원</sm>
						</td>
					</tr>
					<tr>
						<th>은행</th>
						<td>
							<sm>${myInfoVO.bnkNm}</sm>
						</td>
						<th>계좌번호</th>
						<td>
							<sm>${myInfoVO.accountNum} / ${myInfoVO.accountNm}</sm>
						</td>
					</tr>
				</table>

				<br/>
				<br/>
			</div>
				<table>
					<colgroup>
						<col style="width: 13%">
						<col style="width: 37%">
						<col style="width: 13%">
						<col style="width: 37%">
					</colgroup>

					<tr>
						<th>출금일</th>
						<td colspan='3'>
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
					<button id="loadDataBtn" class="btn ty1">조회</button>

				</div>

			<!-- grid  -->
			<div style="height: 0px;" >
				<span class="pagetotal" style='margin-right:20px;'><em id="TT_CNT0" >0</em>건</span>
			</div>

			<br>
			<div id="loadingOverlay" style="display: none;">Loading...</div>
			<div  class="ib_product">
				<div id="myGrid" class="ag-theme-alpine" style="height: 410px; width: 100%;"></div>
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