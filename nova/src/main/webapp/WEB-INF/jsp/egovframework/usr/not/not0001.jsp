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
		{ headerName: "NO", field: "rn", minWidth: 70 },
		{ headerName: "crud", field: "crud", minWidth: 90, hide:true},
		{ headerName: "notId", field: "notId", minWidth: 90, hide:true},
		{ headerName: "제목", field: "title", minWidth: 300, cellClass: 'ag-cell-left tdul'},
		{ headerName: "공지대상", field: "notType", minWidth: 90
			, valueGetter:(params) => {
				if(params.node.data.notType == 'AL')
					return "전체"
				if(params.node.data.notType == 'AC')
					return "운영사 → 협력사"
				if(params.node.data.notType == 'AR')
					return "운영사 → 라이더"
				if(params.node.data.notType == 'CC')
					return "협력사 → 협력사"
				if(params.node.data.notType == 'CR')
					return "협력사 → 라이더"
				}
		},
// 		{ headerName: "첨부파일", field: "atchFileId", minWidth: 90, cellRenderer:(params) => { return (params.node.data.atchFileId != null) ?'<img src="/images/egovframework/com/cmm/toolbar/ed_paste.gif" alt="">' : ''}},
		{ headerName: "공지주체", field: "authorCodeNm", minWidth: 90},
		{ headerName: "등록일", field: "creatDt", minWidth: 90},
		{ headerName: "등록자", field: "creatNm", minWidth: 90},
		{ headerName: "게시중", field: "notYn", minWidth: 90, cellRenderer:(params) => { return (params.node.data.notYn == 'Y')?'<img src="/images/egovframework/com/cop/bbs/tbl_check.png" alt="">':''}},
		{ headerName: "수정", field: "modifyAuth", minWidth: 90, cellRenderer:(params) => { return (params.node.data.modifyAuth == 'Y')?'<img src="/images/egovframework/com/cop/bbs/pencil.png" alt="">':''}, cellClass: 'tdul'}
	];


	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		if('${loginVO.authorCode}' =='ROLE_ADMIN'){
			$('nav > ul').find('li[class!=cooperator]:hidden').show();
		}
		if('${loginVO.authorCode}' =='ROLE_USER'){
			$('nav > ul').find('li[class~=cooperator]:hidden').show();
		}

		//이벤트 설정
		// 1. 계정 추가
		$("#추가버튼").on("click", function(e){
			addBoard();
		});

		//페이징설정
		paging.createPaging('#paging', 1, pagePerCnt, loadNoticeList);
		//그리드 설정
		setGrid();
		loadNoticeList((${noticeVO.schIdx}==0)?1: ${noticeVO.schIdx}, paging.objectCnt);


	});


	function loadNoticeList(schIdx, schPagePerCnt){

		const params = new URLSearchParams();
		params.append("schIdx", schIdx);
		params.append("schPagePerCnt", schPagePerCnt);
		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/not0001_0001.do',params).then(function(response) {
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

	//페이지 이동
	function addBoard(notId) {
		$('#myForm').attr("action", "/usr/not0002.do");
		$('#myForm').append($("<input/>", {type:"hidden", name:"notId", value:notId}));
		$('#myForm').append($("<input/>", {type:"hidden", name:"schIdx", value:paging.pIdx}));
		$('#myForm').submit();
	}

	var bfSelNode;		//onSelectionChanged가 안되서 임시로 만듬
	function selcetRow(params){
// 		var nowSelNode = findRowNode(grid, 'notId', params.node.data.notId);
// 		if(bfSelNode != nowSelNode){
// 			bfSelNode = nowSelNode;
			if(params.column.colId == "modifyAuth"){
				if(params.node.data.modifyAuth == "Y"){
					addBoard(params.node.data.notId);
				}
			} else if(params.column.colId == "title"){
				$('#myForm').attr("action", "/usr/not0003.do");
				$('#myForm').append($("<input/>", {type:"hidden", name:"notId", value:params.node.data.notId}));
				$('#myForm').append($("<input/>", {type:"hidden", name:"schIdx", value:paging.pIdx}));
				$('#myForm').submit();
			}

// 		}
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
		<p class="tit">공지사항</p>

		<input name="pageUnit" type="hidden" value="1000" /> <input
			name="pageSize" type="hidden" value="1000" />
		<!--과제관리_목록 -->
		<div class="search_box ty2">

			<br>

			<div style="float: left; width: 100%;">
				<div style="margin-bottom:10px;">
					<span class="pagetotal" style='margin-right: 20px;'></span>
					<div class="btnwrap" style="">
						<button id="추가버튼" class="btn btn-primary">추가</button>
					</div>
				</div>
				<div id="loadingOverlay" style="display: none;">Loading...</div>


				<div class="ib_product">
					<div id="myGrid" class="ag-theme-alpine" style="height: 580px; width: 100%;"></div>
					<div id="paging" class="d-flex align-items-center justify-content-center mt-3"></div>
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