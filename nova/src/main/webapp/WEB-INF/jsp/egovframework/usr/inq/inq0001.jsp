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

            if(chkLogOut(response.data)){
            	return;
            }

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

	            if(chkLogOut(response.data)){
	            	return;
	            }

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

            if(chkLogOut(response.data)){
            	return;
            }

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

            if(chkLogOut(response.data)){
            	return;
            }

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



	<jsp:include page="../inc/nav.jsp" />

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