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
	let data1;
	var columnDefs= [
		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "crud", field: "crud", minWidth: 90, hide:true},
		{ headerName: "ID", field: "mberId", minWidth: 90, editable: (params) => {return (params.node.data.crud == 'c')? true: false}, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "식별번호", field: "ihidnum", minWidth: 110, editable: (params) => {return ('${loginVO.authorCode}' == 'ROLE_ADMIN')? true: false}, cellClass: (params) => {return agGrideditClass(params)}
            , valueParser: (params) => {
                return gridRegistrationSn(params);
            }
        },
		{ headerName: "이름", field: "userNm", minWidth: 90, editable: true, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "핸드폰번호", field: "mbtlnum", minWidth: 90, editable: true, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "패스워드", field: "password", minWidth: 90, editable: true, cellClass: (params) => {return agGrideditClass(params)}
			, valueParser: (params) =>{
				return gridCheckPass(params);
			}
		},
		{ headerName: "사용여부", field: "emplyrSttusCode", minWidth: 90, editable: true, valueGetter:(params) => { return (params.node.data.emplyrSttusCode=='P')?"사용": "미사용"} ,cellEditor: 'agSelectCellEditor', cellEditorParams: params => { return {values: ['P', 'D']}; }, cellClass: (params) => {return agGrideditClass(params)} },
		{ headerName: "생성자", field: "creatId", minWidth: 90, hide:true}
	];

	var columnDefs1= [
		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "crud", field: "crud", minWidth: 90, hide:true},
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120},
		{ headerName: "협력사이름", field: "cooperatorNm", minWidth: 90},
		{ headerName: "식별번호", field: "registrationSn", minWidth: 90},
		{ headerName: "상호", field: "companyNm", minWidth: 90},
		{ headerName: "사업자이름", field: "registrationNm", minWidth: 90, cellClass: 'ag-cell-left', hide:true},
		{ headerName: "대표자명", field: "ceoNm", minWidth: 90},
		{ headerName: "사용여부", field: "useAt", minWidth: 90, valueGetter:(params) => { return (params.node.data.useAt=='Y')?"사용": "미사용"}},
		{ headerName: "구분", field: "gubun", minWidth: 90, hide:true}
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
		$("#계정추가버튼").on("click", function(e){
			addCooperator(grid);
		});
		$("#계정삭제버튼").on("click", function(e){
			delCooperator(grid);
		});

		$("#계정저장버튼").on("click", function(e){
			saveCooperatorUsr();
		});



		//그리드 설정
		setGrid();
		setGrid1();

		//협력사 계정 리스트 조회
		loadCooperatorUsrList();
	});
	function loadCooperatorUsrList(){

		const params = new URLSearchParams();

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/mem0003_0001.do',params).then(function(response) {
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
        	}
        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
        });
	}

	function loadCooperatorIdList(value){

		const params = new URLSearchParams();
		params.append("mberId", value);
		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/mem0003_0003.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){
	        	if (response.data.list ==  null || response.data.list.length == 0) {
	        		grid1.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid1.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					grid1.setGridOption("rowData", response.data.list);
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

	function createNewRowData() {

	    var newData = {
    		cooperatorId: null,
    		emplyrSttusCode: 'P',
    		ihidnum : ('${loginVO.authorCode}' == 'ROLE_USER') ? '${loginVO.ihidNum}' : '',
    		crud: "c"
	    };
	    return newData;
	}

	//아이디 중복체크
	function chkId(params){
		const colId = params.column.getId();
		if(colId == 'mberId'){
			if(params.node.data.mberId != ''){

				const inputData = new URLSearchParams();
				const gridIdx = params.node.rowIndex;
				inputData.append("mberId", params.node.data.mberId);
				// 로딩 시작
		        $('.loading-wrap--js').show();
		        axios.post('${pageContext.request.contextPath}/usr/mem0001_0005.do',inputData).then(function(response) {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();

		            if(chkLogOut(response.data)){
		            	return;
		            }

		        	if(response.data.resultCode == "success"){

		        	} else {
		        		alert("중복된 아이디 입니다.");
		        		grid.getRowNode(gridIdx).setDataValue('mberId', '');
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
	}

	var bfSelNode;		//onSelectionChanged가 안되서 임시로 만듬
	function selcetRow(params){
		var nowSelNode = findRowNode(grid, 'mberId', params.node.data.mberId);
		if(bfSelNode != nowSelNode){
			bfSelNode = nowSelNode;
			loadCooperatorIdList(params.node.data.mberId)
		}
	}

	function addCooperator(gridObj) {
		  const newStore = getAllRows(gridObj);
		  const newItem = createNewRowData();
	      newStore.push(newItem);
	      gridObj.setGridOption("rowData", newStore);
	}


	function delCooperator(gridObj){
		gridObj.getRowNode(gridObj.getFocusedCell().rowIndex).setDataValue('emplyrSttusCode', 'N');
		gridObj.getRowNode(gridObj.getFocusedCell().rowIndex).setDataValue('crud', 'd');

	}

	// 변경된 협력사 계정을 저장한다.
	function saveCooperatorUsr(){
		grid.stopEditing();

		setTimeout(function(){
			var updateItem = getEditRows(grid);
			debugger;
			var isNOPass = false;
			for(var i = 0; i < updateItem.length ; i++ ){

				if(updateItem[i].mberId==null || updateItem[i].mberId.trim() == ''){
					alert("아이디는 필수 입력항목입니다");
					return;
				}
				if(updateItem[i].ihidnum==null || updateItem[i].ihidnum.trim() == ''){
					alert("사업자번호는 필수 입력항목입니다");
					return;
				}
				if(updateItem[i].userNm==null || updateItem[i].userNm.trim() == ''){
					alert("이름은 필수 입력항목입니다");
					return;
				}
				if(updateItem[i].crud == 'c'){
					if(updateItem[i].password==null || updateItem[i].password.trim() == ''){
						isNOPass = true;
					}
				}
			}
			if(isNOPass){
				if(!confirm("패스워드 미입력 시 기본 패스워드로 Daon2025!입니다.\n계속 진행하시겠습니까?")){
					return false;
				}
			}
			if(updateItem.length <=0 ){
				alert("저장할 항목이 없습니다");
				return;
			}

			// 로딩 시작
	        $('.loading-wrap--js').show();
	        axios.post('${pageContext.request.contextPath}/usr/mem0003_0002.do',getEditRows(grid)).then(function(response) {
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
						grid.setGridOption("rowData", lst);
		            }
	        	} else {
	        		alert("저장에 실패하였습니다.");
	        	}
	        })
	        .catch(function(error) {
	            console.error('There was an error fetching the data:', error);
	        }).finally(function() {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	        });
		}, 100);
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
			    onCellValueChanged: function (event) {
			        changeCrud(event, grid, 'mberId');
			        chkId(event);
			    },
			    onRowClicked : function (event) { //onSelectionChanged  :row가 바뀌었을때 발생하는 이벤트인데 잘 안됨.
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
				suppressScrollOnNewData: true,
			    onCellValueChanged: function (event) {
			    	changeCrud(event, grid1, 'mberId');
			    }
            };
        const gridDiv = document.querySelector('#myGrid1');
        grid1 = agGrid.createGrid(gridDiv, gridOptions);

        grid1.hideOverlay();

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
		<p class="tit">협력사계정관리</p>

		<input name="pageUnit" type="hidden" value="1000" /> <input
			name="pageSize" type="hidden" value="1000" />
		<!--과제관리_목록 -->
		<div class="search_box ty2">


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
			<br>

			<div style="float: left; width: 49%; margin-right: 1%">
				<div style="height: 0px;">
					<span class="pagetotal" style='margin-right: 20px;'>계정:기존사용자 패스워드 수정시 등록된 핸드폰번호로 패스워드가 카톡으로 전송됩니다</span>
					<div class="btnwrap">
						<button id="계정추가버튼" class="btn btn-primary">추가</button>
						<button id="계정사삭제버튼" class="btn btn-primary" style="display:none;">삭제</button>
						<button id="계정저장버튼" class="btn ty1">저장</button>
					</div>
				</div>
				<div id="loadingOverlay" style="display: none;">Loading...</div>


				<div class="ib_product">
					<div id="myGrid" class="ag-theme-alpine"
						style="height: 550px; width: 100%;"></div>
				</div>
			</div>
			<div style="float: left; width: 50%;">

				<!-- grid  -->

				<div style="height: 0px;">
					<span class="pagetotal" style='margin-right: 20px;'>조회가능한 협력사</span>
					<div class="btnwrap">
					</div>
				</div>
				<div class="ib_product">
					<div id="myGrid1" class="ag-theme-alpine"
						style="height: 550px; width: 100%;"></div>
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