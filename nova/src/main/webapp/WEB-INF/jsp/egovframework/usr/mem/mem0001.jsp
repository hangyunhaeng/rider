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
	var columnDefs= [
		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "crud", field: "crud", minWidth: 90, hide:true},
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120, editable: (params) => {return (params.node.data.crud == 'c')? true: false}
			, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "협력사이름", field: "cooperatorNm", minWidth: 120, editable: (params) => {return ('${loginVO.authorCode}' =='ROLE_ADMIN')? true: false}
			, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "식별번호", field: "registrationSn", minWidth: 110, editable: (params) => {return ('${loginVO.authorCode}' == 'ROLE_ADMIN')? true: false}
            , valueParser: (params) => {
                return gridRegistrationSn(params);
            }
            , cellClass: (params) => {return agGrideditClass(params)}
        },
		{ headerName: "상호", field: "companyNm", minWidth: 160, editable: (params) => {return ('${loginVO.authorCode}' =='ROLE_ADMIN')? true: false}
        	, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "사업자이름", field: "registrationNm", minWidth: 90, editable: (params) => {return ('${loginVO.authorCode}' =='ROLE_ADMIN')? true: false}
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-left")} , hide:true},
		{ headerName: "대표자명", field: "ceoNm", minWidth: 90, editable: (params) => {return ('${loginVO.authorCode}' =='ROLE_ADMIN')? true: false}
			, cellClass: (params) => {return agGrideditClass(params)}},
// 		{ headerName: "사용여부", field: "useAt", minWidth: 90, valueGetter:(params) => { return (params.node.data.useAt=='Y')?"사용": "미사용"}},

		{ headerName: "소속<br/>라이더", field: "rdcnt", minWidth: 80, cellClass: 'ag-cell-right'},
		{ headerName: "출금가능금액", field: "xxx", minWidth: 90, cellClass: 'ag-cell-right'},
		{ headerName: "feeId", field: "feeId", minWidth: 90, hide:true},
		{
		    headerName: '선지급수수료',
		    children: [
				{ headerName: "전체(%)", field: "feeAdminstrator", minWidth: 90, editable: (params) => {return ('${loginVO.authorCode}' =='ROLE_ADMIN')? true: false}
					, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
					, valueGetter:(params) => { return currencyFormatter(params.data.feeAdminstrator);}
		            , valueParser: (params) => { return gridPercent(params);}
				},

				{ headerName: "협력사(%)", field: "feeCooperator", minWidth: 90, editable: (params) => {return ('${loginVO.authorCode}' =='ROLE_ADMIN')? true: false}
					, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
					, valueGetter:(params) => { return currencyFormatter(params.data.feeCooperator);}
		            , valueParser: (params) => { return gridPercent(params);}
				}
		    ]
		},
		{
		    headerName: '보험,세금',
		    children: [
				{ headerName: "고용(%)", field: "feeEmploymentInsurance", minWidth: 90, editable: true
					, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
					, valueGetter:(params) => { return currencyFormatter(params.data.feeEmploymentInsurance);}
		            , valueParser: (params) => { return gridPercent(params);}
				},
				{ headerName: "산재(%)", field: "feeIndustrialInsurance", minWidth: 90, editable: true
					, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
					, valueGetter:(params) => { return currencyFormatter(params.data.feeIndustrialInsurance);}
		            , valueParser: (params) => { return gridPercent(params);}
				},
				{ headerName: "원천세(%)", field: "feeWithholdingTax", minWidth: 90, editable: true
					, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
					, valueGetter:(params) => { return currencyFormatter(params.data.feeWithholdingTax);}
		            , valueParser: (params) => { return gridPercent(params);}
				},
				{ headerName: "시간제(원)", field: "feeTimeInsurance", minWidth: 90, editable: true
					, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
					, valueGetter:(params) => { return currencyFormatter(params.data.feeTimeInsurance);}
		            , valueParser: (params) => { return gridWan(params);}
				}
			]
		},
		{
		    headerName: '콜수수료',
		    children: [
				{ headerName: "전체(원)", field: "feeCall", minWidth: 90, editable: true
					, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
					, valueGetter:(params) => { return currencyFormatter(params.data.feeCall);}
		            , valueParser: (params) => { return gridWan(params);}
				},
				{ headerName: "협력사(%)", field: "feeCooperatorCall", minWidth: 90, editable: (params) => {return ('${loginVO.authorCode}' =='ROLE_ADMIN')? true: false}
					, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
					, valueGetter:(params) => { return currencyFormatter(params.data.feeCooperatorCall);}
		            , valueParser: (params) => { return gridPercent(params);}
				}
			]
		},

		{ headerName: "프로그램료(원)", field: "feeProgram", minWidth: 90, editable: (params) => {return ('${loginVO.authorCode}' =='ROLE_ADMIN')? true: false}
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeProgram);}
            , valueParser: (params) => { return gridWan(params);}
		},

		{ headerName: "사용여부", field: "useAt", minWidth: 90, editable: (params) => {return ('${loginVO.authorCode}' == 'ROLE_ADMIN')? true: false}
		, valueGetter:(params) => { return (params.node.data.useAt=='Y')?"사용": "미사용"}
		, cellEditor: 'agSelectCellEditor'
		, cellEditorParams: params => { return {values: ['Y', 'N']}; }
		, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "등록일", field: "creatDt", minWidth: 100
	        , valueGetter:(params) => { return getStringDate(params.data.creatDt)}
	    },
		{ headerName: "생성자", field: "creatId", minWidth: 90, hide:true},
		{ headerName: "구분", field: "gubun", minWidth: 90, hide:true}


	];

// 	var columnDefs1= [
// 		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
// 		{ headerName: "crud", field: "crud", minWidth: 90, hide:true},
// 		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120},
// 		{ headerName: "타입", field: "feeType", minWidth: 120, editable: (params) => {return (params.node.data.crud == 'c')? true: false}
// 			, valueGetter:(params) => {
// 				if(params.node.data.feeType=='A') return"콜당수술료금액";
// 				else if (params.node.data.feeType=='B') return "콜당수수료율";
// 				else return "기타";
// 				}
// 			, cellEditor: 'agSelectCellEditor', cellEditorParams: {values: ["A", "B"]}
// 			, cellClass: (params) => {return agGrideditClass(params)}
// 		},
// 		{ headerName: "수수료", field: "fee", minWidth: 90
// 			, editable: (params) => {return (params.node.data.crud == 'c')? true: false}
// 			, valueGetter:(params) => { return currencyFormatter(params.data.fee)}
// 			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-left")}
// 		},
// 		{ headerName: "적용시작일", field: "startDt", minWidth: 110, editable: (params) => {return (params.node.data.crud == 'c')? true: false}
// 	        , valueParser: (params) => {
// 	            return gridValidDate(params);
// 	        }
// 	        , cellClass: (params) => {return agGrideditClass(params)}
// 	        , valueGetter:(params) => { return getStringDate(params.data.startDt)}
// 		},
// 		{ headerName: "적용종료일", field: "endDt", minWidth: 110, editable: true
// 	        , valueParser: (params) => {
// 	            return gridValidDate(params);
// 	        }
// 	        , cellClass: (params) => {return agGrideditClass(params)}
// 	        , valueGetter:(params) => { return getStringDate(params.data.endDt)}
// 	    },
// 		{ headerName: "생성자", field: "creatId", minWidth: 90, hide:true}
// 	];

	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		if('${loginVO.authorCode}' =='ROLE_ADMIN'){
			$('nav > ul').find('li[class!=cooperator]:hidden').show();
		}
		if('${loginVO.authorCode}' =='ROLE_USER'){
			$('nav > ul').find('li[class~=cooperator]:hidden').show();
		}

		//이벤트 설정
		// 1. 협력사 추가
		$("#협력사추가버튼").on("click", function(e){
			addCooperator(grid);
		});
		$("#협력사삭제버튼").on("click", function(e){
			delCooperator(grid);
		});

		$("#협력사저장버튼").on("click", function(e){
			saveCooperator();
		});


		// 2. 수수료 추가
// 		$("#수수료추가버튼").on("click", function(e){
// 			addFee(grid1);
// 		});
// 		$("#수수료저장버튼").on("click", function(e){
// 			saveFee();
// 		});

		if('${loginVO.authorCode}' == 'ROLE_ADMIN'){
			$("#협력사추가버튼").show();
		}

		//그리드 설정
		setGrid();
// 		setGrid1();

		//협력사 리스트 조회
		loadCooperatorList();
	});
	function loadCooperatorList(){
		const params = new URLSearchParams();

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/mem0001_0000.do',params).then(function(response) {
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

					grid.setGridOption("rowData", response.data.list);
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

// 	function loadCooperatorFeeList(value){

// 		const params = new URLSearchParams();
// 		params.append("cooperatorId", value);
// 		// 로딩 시작
//         $('.loading-wrap--js').show();
//         axios.post('${pageContext.request.contextPath}/usr/mem0001_0006.do',params).then(function(response) {
//         	// 로딩 종료
//             $('.loading-wrap--js').hide();
//         	if(response.data.resultCode == "success"){
// 	        	if (response.data.list.length == 0) {
// 	        		grid1.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
// 	        		grid1.showNoRowsOverlay();  			// 데이터가 없는 경우
// 	            } else {

// 	            	data = response.data.list;	//정상데이터
// 					grid1.setGridOption("rowData", data);
// 	            }
//         	}
//         })
//         .catch(function(error) {
//             console.error('There was an error fetching the data:', error);
//         }).finally(function() {
//         	// 로딩 종료
//             $('.loading-wrap--js').hide();
//         });
// 	}

	function createNewRowData() {

	    var newData = {
    		cooperatorId: null,
    		useAt: 'Y',
    		crud: "c"
	    };
	    return newData;
	}
	function createNewRowData1() {
	    var newData = {
    		cooperatorId: grid.getRowNode(grid.getFocusedCell().rowIndex).data.cooperatorId,
    		feeType : 'A',
    		endDt : '99991231',
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
		        		grid1.getRowNode(gridIdx).setDataValue('mberId', '');
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

// 	var bfSelNode;		//onSelectionChanged가 안되서 임시로 만듬
// 	function selcetRow(params){
// 		var nowSelNode = findRowNode(grid, 'cooperatorId', params.node.data.cooperatorId);
// 		if(bfSelNode != nowSelNode){
// 			bfSelNode = nowSelNode;
//  			loadCooperatorFeeList(params.node.data.cooperatorId)
// 		}
// 	}

	function addCooperator(gridObj) {
		  const newStore = getAllRows(gridObj);
		  const newItem = createNewRowData();
	      newStore.push(newItem);
	      gridObj.setGridOption("rowData", newStore);
	}

	function delCooperator(gridObj){
		gridObj.getRowNode(gridObj.getFocusedCell().rowIndex).setDataValue('useAt', 'N');
		gridObj.getRowNode(gridObj.getFocusedCell().rowIndex).setDataValue('crud', 'd');

	}

// 	function addFee(gridObj) {
// 		  const newStore = getAllRows(gridObj);
// 		  const newItem = createNewRowData1();
// 	      newStore.push(newItem);
// 	      gridObj.setGridOption("rowData", newStore);
// 	}

	// 변경된 협력사를 저장한다.
	function saveCooperator(){
		grid.stopEditing();

		setTimeout(function(){
			var updateItem = getEditRows(grid);

			if(updateItem.length <=0 ){
				alert("저장할 항목이 없습니다");
				return;
			}

			// 로딩 시작
	        $('.loading-wrap--js').show();
	        axios.post('${pageContext.request.contextPath}/usr/mem0001_0002.do',getEditRows(grid)).then(function(response) {
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
// 	function saveFee(){
// 		grid1.stopEditing();

// 		setTimeout(function(){
// 			var updateItem = getEditRows(grid1);


// 			for(var i = 0; i < updateItem.length ; i++ ){

// 				if(updateItem[i].startDt==null || updateItem[i].startDt.trim() == ''){
// 					alert("적용시작일은 필수 입력항목입니다");
// 					return;
// 				}
// 			}

// 			if(updateItem.length <=0 ){
// 				alert("저장할 항목이 없습니다");
// 				return;
// 			}

// 			// 로딩 시작
// 	        $('.loading-wrap--js').show();
// 	        axios.post('${pageContext.request.contextPath}/usr/mem0001_0007.do',getEditRows(grid1)).then(function(response) {
// 	        	// 로딩 종료
// 	            $('.loading-wrap--js').hide();
// 	        	debugger;
// 	        	if(response.data.resultCode == "success"){
// 		        	if (response.data.list.length == 0) {
// 		        		grid1.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
// 		        		grid1.showNoRowsOverlay();  			// 데이터가 없는 경우
// 		            } else {

// 						var lst = response.data.list;	//정상데이터
// 						grid1.setGridOption("rowData", lst);
// 		            }
// 	        	} else {
// 	        		if(response.data.resultMsg != null && response.data.resultMsg != ''){
// 	        			alert(response.data.resultMsg);
// 	        		} else {
// 	        			alert("저장에 실패하였습니다");
// 	        		}
// 	        	}
// 	        })
// 	        .catch(function(error) {
// 	            console.error('There was an error fetching the data:', error);
// 	        }).finally(function() {
// 	        	// 로딩 종료
// 	            $('.loading-wrap--js').hide();
// 	        });
// 		}, 100);
// 	}

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
			        changeCrud(event, grid, 'cooperatorId');
			    },
// 			    onRowClicked : function (event) { //onSelectionChanged  :row가 바뀌었을때 발생하는 이벤트인데 잘 안됨.
// 			    	selcetRow(event);
// 			    },
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

// 	function setGrid1(){
// 		// 사용자 정의 컴포넌트를 글로벌 네임스페이스에 추가
// 		window.CustomHeader = CustomHeader;
//     	gridOptions = {
//                 columnDefs: columnDefs1,
//                 rowData: [], // 초기 행 데이터를 빈 배열로 설정
//                 defaultColDef: { headerComponent: 'CustomHeader'}, //
//                 components: { CustomHeader: CustomHeader },
//                 enableCellTextSelection: true, // 셀 텍스트 선택을 활성화합니다.
//                 rowHeight: 35,
//                 headerHeight: 35,
//                 alwaysShowHorizontalScroll : true,
//                 alwaysShowVerticalScroll: true,
//                 onGridReady: function(params) {
//                     //loadData(params.api); // 그리드가 준비된 후 데이터 로드
//                     params.api.sizeColumnsToFit();
//                 },
//                 rowClassRules: {'ag-cell-err ': (params) => { return params.data.err === true; }},
// 				overlayLoadingTemplate: '<span class="ag-overlay-loading-center">로딩 중</span>',
// 				overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>',
// 				suppressScrollOnNewData: true,
// 			    onCellValueChanged: function (event) {
// 			    	changeCrud(event, grid1, 'mberId');
// 			        chkId(event);
// 			    },
// 			    getRowStyle: params => {
// 			        if (params.node.data.crud == 'c' || params.node.data.crud == 'u') {
// 			            return { background: '#e99494' };
// 			        }
// 			        if (params.node.data.crud == 'd') {
// 			            return { background: '#65676b' };
// 			        }
// 			    }
//             };
//         const gridDiv = document.querySelector('#myGrid1');
//         grid1 = agGrid.createGrid(gridDiv, gridOptions);

//         grid1.hideOverlay();

// 	}

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
		<p class="tit">협력사 관리</p>

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

<!-- 			<div style="float: left; width: 49%; margin-right: 1%"> -->
				<div style="height: 0px;">
					<span class="pagetotal" style='margin-right: 20px;'>협력사 : 미사용으로 변경시 하위 모든 라이더 출금이 막힘(%는 소수점 이하 3자리). 시간제(원), 콜수수료, 프로그램료는 콜당 부과되는 금앱입니다.</span>
					<div class="btnwrap">
						<button id="협력사추가버튼" class="btn btn-primary" style='display:none;'>추가</button>
						<button id="협력사삭제버튼" class="btn btn-primary" style="display:none;">삭제</button>
						<button id="협력사저장버튼" class="btn ty1">저장</button>
					</div>
				</div>

				<div id="loadingOverlay" style="display: none;">Loading...</div>
				<div  class="ib_product">
					<div id="myGrid" class="ag-theme-alpine" style="height: 550px; width: 100%;"></div>
				</div>
<!-- 			</div> -->
<!-- 			<div style="float: left; width: 50%;"> -->

				<!-- grid  -->

<!-- 				<div style="height: 0px;"> -->
<!-- 					<span class="pagetotal" style='margin-right: 20px;'>수수료 : 기존데이터는 종료일만 수정가능</span> -->
<!-- 					<div class="btnwrap"> -->
<!-- 						<button id="수수료추가버튼" class="btn btn-primary">추가</button> -->
<!-- 						<button id="수수료저장버튼" class="btn ty1">저장</button> -->
<!-- 					</div> -->
<!-- 				</div> -->
<!-- 				<div  class="ib_product"> -->
<!-- 					<div id="myGrid1" class="ag-theme-alpine" style="height: 380px; width: 100%;"></div> -->
<!-- 				</div> -->
<!-- 			</div> -->
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