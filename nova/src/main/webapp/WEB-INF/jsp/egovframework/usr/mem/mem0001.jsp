<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<!-- Fonts -->
<link href="https://fonts.googleapis.com" rel="preconnect">
<link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">

<!-- Vendor CSS Files -->
<link href="<c:url value='/vendor/admin/bootstrap/css/bootstrap.min.css' />" rel="stylesheet">
<link href="<c:url value='/vendor/admin/bootstrap-icons/bootstrap-icons.css' />" rel="stylesheet">
<%-- <link href="<c:url value='/vendor/admin/aos/aos.css' />" rel="stylesheet"> --%>
<%-- <link href="<c:url value='/vendor/admin/fontawesome-free/css/all.min.css' />" rel="stylesheet"> --%>
<%-- <link href="<c:url value='/vendor/admin/glightbox/css/glightbox.min.css' />" rel="stylesheet"> --%>
<%-- <link href="<c:url value='/vendor/admin/swiper/swiper-bundle.min.css' />" rel="stylesheet"> --%>

<!-- Main CSS File -->
<link href="<c:url value='/css/admin/main.css' />" rel="stylesheet">


<!-- 달력 -->
<link rel="stylesheet" type="text/css" href="<c:url value='/calender/flatpickr.min.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/calender/material_orange.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/calender/style.css' />">
<script src="<c:url value='/calender/flatpickr.js' />"></script>
<script src="<c:url value='/calender/ko.js' />"></script>
<script src="<c:url value='/calender/index.js' />"></script>

<script type="text/javascript"	src="<c:url value='/js/admin/util.js' />"></script>


<!-- keiti용 소스 -->
<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.default.css' /> ">
<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.style.css' />">

<script type="text/javascript"	src="<c:url value='/web2/js/function.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/jquery-1.11.2.min.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/keit.jquery.ui.js' />"></script>

<link rel="stylesheet" href="<c:url value='/ag-grid/ag-grid.css' />">
<link rel="stylesheet" href="<c:url value='/ag-grid/ag-theme-alpine.css' />">
<link rel="stylesheet" href="<c:url value='/ag-grid/ag-custom.css' />">
<script src="<c:url value='/ag-grid/ag-grid-community.noStyle.js' />"></script>
<script src="<c:url value='/ag-grid/ag-grid-community.js' />"></script>
<script src="<c:url value='/ag-grid/ag-custom-header.js' />"></script>
<script src="<c:url value='/js/xlsx.full.min.js' />"></script>
<script src="<c:url value='/js/xlsx-populate.min.js' />"></script>
<script src="<c:url value='/js/axios.min.js' />"></script>
	<link href="<c:url value='/vendor/admin/bootstrap/3.4.1/bootstrap.min.css' />" rel="stylesheet">
<!-- 	<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script> -->

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
		{ headerName: "사업자등록번호", field: "registrationSn", minWidth: 110, editable: (params) => {return ('${loginVO.authorCode}' == 'ROLE_ADMIN')? true: false}
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
		{ headerName: "선지급수수료(%)", field: "feeAdminstrator", minWidth: 90, editable: (params) => {return ('${loginVO.authorCode}' =='ROLE_ADMIN')? true: false}
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeAdminstrator);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "협력사<br/>선지급수수료(%)", field: "feeCooperator", minWidth: 90, editable: (params) => {return ('${loginVO.authorCode}' =='ROLE_ADMIN')? true: false}
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeCooperator);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "고용보험(%)", field: "feeEmploymentInsurance", minWidth: 90, editable: true
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeEmploymentInsurance);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "산재보험(%)", field: "feeIndustrialInsurance", minWidth: 90, editable: true
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeIndustrialInsurance);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "원천세(%)", field: "feeWithholdingTax", minWidth: 90, editable: true
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeWithholdingTax);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "시간제보험(원)", field: "feeTimeInsurance", minWidth: 90, editable: true
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeTimeInsurance);}
            , valueParser: (params) => { return gridWan(params);}
		},
		{ headerName: "콜수수료(원)", field: "feeCall", minWidth: 90, editable: true
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeCall);}
            , valueParser: (params) => { return gridWan(params);}
		},
		{ headerName: "협력사<br/>콜수수료(%)", field: "feeCooperatorCall", minWidth: 90, editable: (params) => {return ('${loginVO.authorCode}' =='ROLE_ADMIN')? true: false}
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeCooperatorCall);}
            , valueParser: (params) => { return gridPercent(params);}
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

	<header id="header" class="header d-flex align-items-center fixed-top">
		<div
			class="container-fluid container-xl position-relative d-flex align-items-center">

			<a href="${pageContext.request.contextPath}/com/com0002.do"
				class="logo d-flex align-items-center me-auto"> <!-- Uncomment the line below if you also wish to use an image logo -->
				<!-- <img src="/images/admin/logo.png" alt=""> -->
				<h1 class="sitename">RIDER BANK</h1>
			</a>


			<nav id="navmenu" class="navmenu">
				<ul>
					<li class="dropdown"><a href="" onclick="javascript:return false;"><span>공지사항&문의</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
			              <li><a href="${pageContext.request.contextPath}/usr/not0001.do">공지사항</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/inq0001.do">1:1문의</a></li>
			            </ul>
					</li>
		            <li class="dropdown"><a href="" onclick="javascript:return false;"><span>수익현황</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
			              <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0003.do">운영사수익현황</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/pay0004.do">협력사수익현황</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/pay0005.do">협력사 기타(대여, 리스) 현황</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/pay0001.do">라이더 출금내역<br></a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/pay0006.do">협력사 출금내역<br></a></li>
			            </ul>
		            </li>
		            <li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;"><span>관리</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
						  <li><a href="${pageContext.request.contextPath}/usr/dty0004.do">배달정보 조회</a></li>
						  <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0002.do">입출금 대사<br></a></li>
			            </ul>
		            </li>

					<li class="cooperator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/dty0004.do">배달정보 조회</a></li>

					<li class="dropdown"><a href="" onclick="javascript:return false;" class="active"><span>협력사/라이더 현황</span><i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li><a href="${pageContext.request.contextPath}/usr/mem0001.do" class="active">협력사 관리</a></li>
              				<li style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0003.do">협력사계정 관리</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/mem0002.do">라이더관리</a></li>
						</ul>
					</li>
					<li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;"><span>자료 업로드</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li><a href="${pageContext.request.contextPath}/usr/dty0001.do">일별 자료 업로드</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0002.do">주별 자료 업로드</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0003.do">자료 업로드 이력</a></li>
						</ul>
					</li>
					<li><a href="${pageContext.request.contextPath}/usr/mem0004.do">MyPage</a></li>
				</ul>
				<i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
			</nav>
	<a class="btn-getstarted" href="${pageContext.request.contextPath }/uat/uia/actionLogout.do" style="height: 37px;"><spring:message code="comCmm.unitContent.3"/></a>


		</div>
	</header>

	<main class="main" style="height: 60px;">

		<!-- Hero Section -->
		<section id="hero" class="hero section dark-background"
			style="min-height: 50px; padding: 70px 0 30px 0;">

			<img src="<c:url value='/images/admin/world-dotted-map.png' />" alt="" class="hero-bg"
				data-aos="fade-in">
			<div class="container-fluid container-xl position-relative d-flex align-items-center">
				<div class="d-flex align-items-center me-auto"></div>
		 		<sm class="btn-getstarted">${loginVO.name}<c:if test="${loginVO.authorCode eq 'ROLE_ADMIN'}">(운영사)</c:if>님 환영합니다</sm>
		 	</div>
		</section>
	</main>

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
					<span class="pagetotal" style='margin-right: 20px;'>협력사 : 미사용으로 변경시 하위 모든 라이더 출금이 막힘(%는 소수점 이하 3자리)</span>
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