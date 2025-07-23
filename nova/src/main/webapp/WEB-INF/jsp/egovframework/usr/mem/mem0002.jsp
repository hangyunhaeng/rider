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
<%-- 	<link href="<c:url value='/vendor/admin/bootstrap/3.4.1/bootstrap.min.css' />" rel="stylesheet"> --%>
<!-- 	<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script> -->


	<!-- phoenix -->
	<script src="<c:url value='/vendor/admin/bootstrap/js/bootstrap.min.js' />"></script>
    <script src="<c:url value='/js/phoenix/simplebar.min.js' />"></script>
    <script src="<c:url value='/js/phoenix/config.js' />"></script>
    <link href="<c:url value='/css/phoenix/choices.min.css' />" rel="stylesheet">
    <link href="<c:url value='/css/phoenix/dhtmlxgantt.css' />" rel="stylesheet">
    <link href="<c:url value='/css/phoenix/flatpickr.min.css' />" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com/">
    <link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin="">
    <link href="<c:url value='/css/phoenix/css2.css' />" rel="stylesheet">
    <link href="<c:url value='/css/phoenix/simplebar.min.css' />" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/phoenix/line.css' />">
    <link href="<c:url value='/css/phoenix/theme-rtl.min.css' />" type="text/css" rel="stylesheet" id="style-rtl" disabled="true">
    <link href="<c:url value='/css/phoenix/theme.min.css' />" type="text/css" rel="stylesheet" id="style-default">
    <link href="<c:url value='/css/phoenix/user-rtl.min.css' />" type="text/css" rel="stylesheet" id="user-style-rtl" disabled="true">
    <link href="<c:url value='/css/phoenix/user.min.css' />" type="text/css" rel="stylesheet" id="user-style-default">

</head>
<script type="text/javaScript">


	let gridOptions="";
	var grid="";
	var grid1="";
	var grid2="";
	let data;
	let data1;
	var columnDefs= [
		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "crud", field: "crud", minWidth: 90, hide:true},
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 150},
		{ headerName: "협력사이름", field: "cooperatorNm", minWidth: 90, cellClass: 'ag-cell-left'},
		{ headerName: "사업자등록번호", field: "registrationSn", minWidth: 90, hide:true},
		{ headerName: "상호", field: "companyNm", minWidth: 150, cellClass: 'ag-cell-left'},
		{ headerName: "사업자이름", field: "registrationNm", minWidth: 90, hide:true},
		{ headerName: "대표자명", field: "ceoNm", minWidth: 90, hide:true},
		{ headerName: "소속라이더", field: "rdcnt", minWidth: 90, cellClass: 'ag-cell-right'},
		{ headerName: "사용여부", field: "useAt", minWidth: 90, hide:true, valueGetter:(params) => { return (params.node.data.useAt=='Y')?"사용": "미사용"}},
		{ headerName: "생성자", field: "creatId", minWidth: 90, hide:true},

		{ headerName: "선지급수수료(%)", field: "feeAdminstrator", minWidth: 90},
		{ headerName: "협력사<br/>선지급수수료(%)", field: "feeCooperator", minWidth: 90},
		{ headerName: "고용보험(%)", field: "feeEmploymentInsurance", minWidth: 90},
		{ headerName: "산재보험(%)", field: "feeIndustrialInsurance", minWidth: 90},
		{ headerName: "원천세(%)", field: "feeWithholdingTax", minWidth: 90},
		{ headerName: "시간제보험(원)", field: "feeTimeInsurance", minWidth: 90},
		{ headerName: "콜수수료(원)", field: "feeCall", minWidth: 90},

		{ headerName: "구분", field: "gubun", minWidth: 90, hide:true}
	];

	var columnDefs1= [
		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "crud", field: "crud", minWidth: 90, hide:true},
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120},
		{ headerName: "ID", field: "mberId", minWidth: 90, editable: (params) => {return (params.node.data.crud == 'c')? true: false}, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "이름", field: "mberNm", minWidth: 90, editable: true, cellClass: (params) => {return agGrideditClass(params)}},
// 		{ headerName: "수수료", field: "fee", minWidth: 90, editable: true, cellClass: (params) => {return agGrideditClass(params, 'ag-cell-right')} },
		{ headerName: "핸드폰번호", field: "mbtlnum", minWidth: 120, editable: true
	        , valueParser: (params) => {
	            return gridValidPhoneNumber(params);
	        }
			, cellClass: (params) => {return agGrideditClass(params, 'ag-cell-left')}
			,valueGetter:(params) => { return addHyphenToPhoneNumber(params.data.mbtlnum)}
		},
		{ headerName: "등록일", field: "regDt", minWidth: 100
	        , valueParser: (params) => {
	            return gridValidDate(params);
	        }
	        , cellClass: (params) => { return agGrideditClass(params)}
	        , valueGetter:(params) => { return getStringDate(params.data.regDt)}
		},
		{ headerName: "종료일", field: "endDt", minWidth: 100, editable: true
	        , valueParser: (params) => {
	            return gridValidDate(params);
	        }
	        , cellClass: (params) => {return agGrideditClass(params)}
	        , valueGetter:(params) => { return getStringDate(params.data.endDt)}
		},

		{ headerName: "고용보험(%)", field: "feeEmploymentInsurance", minWidth: 90, editable: true
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
// 			, valueGetter:(params) => { return currencyFormatter(params.data.feeEmploymentInsurance);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "산재보험(%)", field: "feeIndustrialInsurance", minWidth: 90, editable: true
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
// 			, valueGetter:(params) => { return currencyFormatter(params.data.feeIndustrialInsurance);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "원천세(%)", field: "feeWithholdingTax", minWidth: 90, editable: true
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
// 			, valueGetter:(params) => { return currencyFormatter(params.data.feeWithholdingTax);}
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
		{ headerName: "기타<br/>(대여,리스)", field: "etcCall", minWidth: 90
			, cellRenderer:(params) => { return '<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer" data-bs-toggle="modal" data-bs-target="#exampleModal" onclick="clickEtc(\''+params.data.cooperatorId+'\', \''+params.data.mberId+'\')">관리</div>';}
		},

		{ headerName: "사용여부", field: "useAt", minWidth: 90, editable: true
		,valueGetter:(params) => { return (params.node.data.useAt=='Y')?"사용": "미사용"}
		,cellEditor: 'agSelectCellEditor'
		,cellEditorParams: params => { return {values: ['Y', 'N']}; }
		, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "생성자", field: "creatId", minWidth: 90, hide:true}
	];

	var columnDefs2= [
		{ headerName: "chk", field: "chk", minWidth: 10, maxWidth: 60, cellDataType: 'boolean', editable: (params) => {return (params.node.data.responsAt == 'Y')? false: true} },
		{ headerName: "NO", field: "no", minWidth: 10, maxWidth: 60, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "uniq", field: "uniq", minWidth: 70, hide:true},
		{ headerName: "crud", field: "crud", minWidth: 90, hide:true},
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120, maxWidth: 130, hide:true},
		{ headerName: "ID", field: "mberId", minWidth: 90, maxWidth: 130},

		//대여:D, 리스,:R 기타:E
		{ headerName: "구분", field: "gubun", minWidth: 10, maxWidth: 80, editable: (params) => {return (params.node.data.responsAt == 'Y')? false: true}
			, valueGetter:(params) => { return (params.node.data.gubun=='D')?"대여": (params.node.data.gubun=='R')?"리스":"기타"}
			, cellEditor: 'agSelectCellEditor'
			, cellEditorParams: params => { return {values: ['D', 'R', 'E']}; }
			, cellClass: (params) => {return agGrideditClass(params)}
		},
		{ headerName: "상환기간(일)", field: "paybackDay", minWidth: 10, maxWidth: 100, editable: (params) => {return (params.node.data.responsAt == 'Y')? false: true}
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.paybackDay);}
		},
		{ headerName: "일별상환금액", field: "paybackCost", minWidth: 10, maxWidth: 100, editable: (params) => {return (params.node.data.responsAt == 'Y')? false: true}
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.paybackCost);}
		},
		{ headerName: "총상환금액", field: "paybackCostAll", minWidth: 10, maxWidth: 100
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.paybackCostAll);}
		},
		{ headerName: "등록일", field: "creatDt", minWidth: 10, maxWidth: 100, valueGetter:(params) => { return getStringDate(params.data.creatDt)}},
		{ headerName: "상환완료금액", field: "finishCost", minWidth: 10, maxWidth: 100
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.finishCost);}
		},
		{ headerName: "상환완료여부", field: "finishAt", minWidth: 10, maxWidth: 100},
		{ headerName: "승인요청일", field: "authRequestDt", minWidth: 10, maxWidth: 100, valueGetter:(params) => { return getStringDate(params.data.authRequestDt)}},
		{ headerName: "라이더<br/>승인일", field: "authResponsDt", minWidth: 10, maxWidth: 100, valueGetter:(params) => { return getStringDate(params.data.authResponsDt)}},
		{ headerName: "라이더<br/>승인여부", field: "responsAt", minWidth: 10, maxWidth: 100}
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
		// 아이디 추가
		$("#아이디추가버튼").on("click", function(e){
			addCooperator1(grid1);
		});
		$("#아이디저장버튼").on("click", function(e){
 			saveCooperatorUsr();
		});

		$("#기타추가버튼").on("click", function(e){
			addEtc(grid2);
		});
		$("#기타저장버튼").on("click", function(e){
 			saveEtc();
		});
		$("#기타요청버튼").on("click", function(e){
 			requestEtc();
		});
		$("#기타삭제버튼").on("click", function(e){
			deleteEtc();
		});





		//그리드 설정
		setGrid();
		setGrid1();
		setGrid2();

		//협력사 리스트 조회
		loadCooperatorList();
	});
	function loadCooperatorList(){

		const params = new URLSearchParams();
		params.append('searchGubun', "R");
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

	function loadCooperatorRiderList(value){

		const params = new URLSearchParams();
		params.append("cooperatorId", value);
		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/mem0002_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){
	        	if (response.data.list.length == 0) {
	        		grid1.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid1.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

	            	data = response.data.list;	//정상데이터
					grid1.setGridOption("rowData", data);
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
	function clickEtc(strCooperatorId, strMberId){
		$('#modalCooperatorId').val(strCooperatorId);
		$('#modalMberId').val(strMberId);

		const params = new URLSearchParams();
		params.append("cooperatorId", strCooperatorId);
		params.append("mberId", strMberId);
		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/mem0002_0004.do',params).then(function(response) {

            if(chkLogOut(response.data)){
            	return;
            }

        	// 로딩 종료
            $('.loading-wrap--js').hide();
        	if(response.data.resultCode == "success"){
	        	if (response.data.list.length == 0) {
	        		grid2.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid2.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

	            	data = response.data.list;	//정상데이터
					grid2.setGridOption("rowData", data);
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

	function createNewRowData1() {
	    var newData = {
    		cooperatorId: grid.getRowNode(grid.getFocusedCell().rowIndex).data.cooperatorId,

    		feeEmploymentInsurance: grid.getRowNode(grid.getFocusedCell().rowIndex).data.feeEmploymentInsurance,	//고용보험
    		feeIndustrialInsurance: grid.getRowNode(grid.getFocusedCell().rowIndex).data.feeIndustrialInsurance,	//산재보험
    		feeWithholdingTax: grid.getRowNode(grid.getFocusedCell().rowIndex).data.feeWithholdingTax,		//원천세
    		feeTimeInsurance: grid.getRowNode(grid.getFocusedCell().rowIndex).data.feeTimeInsurance,		//시간제보험
    		feeCall: grid.getRowNode(grid.getFocusedCell().rowIndex).data.feeCall,							//콜수수료

    		useAt: 'Y',
    		crud: "c"
	    };
	    return newData;
	}


	function createNewRowData2() {
	    var newData = {
    		cooperatorId: $('#modalCooperatorId').val(),
    		mberId: $('#modalMberId').val(),
    		gubun: 'D',
    		useAt: 'Y',
    		uniq: grid2.getDisplayedRowCount()+1,
    		crud: "c",
    		chk: false
	    };
	    return newData;
	}

	var bfSelNode;		//onSelectionChanged가 안되서 임시로 만듬
	function selcetRow(params){
		var nowSelNode = findRowNode(grid, 'cooperatorId', params.node.data.cooperatorId);
		if(bfSelNode != nowSelNode){
			bfSelNode = nowSelNode;
			loadCooperatorRiderList(params.node.data.cooperatorId)
		}
	}


	function addCooperator1(gridObj) {
		  const newStore = getAllRows(gridObj);
		  const newItem = createNewRowData1();
	      newStore.push(newItem);
	      gridObj.setGridOption("rowData", newStore);
	}

	function addEtc(gridObj){
		  const newStore = getAllRows(gridObj);
		  const newItem = createNewRowData2();
	      newStore.push(newItem);
	      gridObj.setGridOption("rowData", newStore);
	}

	// 변경된 협력사 id를 저장한다.
	function saveCooperatorUsr(){
		grid1.stopEditing();

		setTimeout(function(){
			var updateItem = getEditRows(grid1);

			var err = false;
			if(updateItem.length <=0 ){
				alert("저장할 항목이 없습니다");
				return;
			}
				debugger;

			for(var i = 0 ; i < updateItem.length ; i++){
				var one = updateItem[i];
				if(nullToString(one.mberId) == ''){
					alert('아이디는 필수 항목입니다\n저장을 취소합니다.');
					err = true;
					return ;
				}
				if(nullToString(one.mberNm) == ''){
					alert('이름은 필수 항목입니다\n저장을 취소합니다.');
					err = true;
					return ;
				}
			}
			if(err){
				return;
			}
			// 로딩 시작
	        $('.loading-wrap--js').show();
	        axios.post('${pageContext.request.contextPath}/usr/mem0002_0002.do',getEditRows(grid1)).then(function(response) {        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	            if(chkLogOut(response.data)){
	            	return;
	            }

	        	if(response.data.resultCode == "success"){

		        	if (response.data.orglist.length == 0) {
		        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
		        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
		            } else {

						var lst = response.data.orglist;	//정상데이터
						grid.setGridOption("rowData", lst);
		            }

		        	if (response.data.list.length == 0) {
		        		grid1.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
		        		grid1.showNoRowsOverlay();  			// 데이터가 없는 경우
		            } else {

						var lst = response.data.list;	//정상데이터
						grid1.setGridOption("rowData", lst);
		            }

	        	} else {
	        		if(response.data.resultMsg != null && response.data.resultMsg != ''){
	        			alert(response.data.resultMsg);
	        		} else {
	        			alert("저장에 실패하였습니다");
	        		}
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

	function saveEtc(){
		grid2.stopEditing();

		setTimeout(function(){
			var updateItem = getEditRows(grid2);

			if(updateItem.length <=0 ){
				alert("저장할 항목이 없습니다");
				return;
			}
			// 로딩 시작
	        $('.loading-wrap--js').show();
	        axios.post('${pageContext.request.contextPath}/usr/mem0002_0005.do',getEditRows(grid2)).then(function(response) {        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	            if(chkLogOut(response.data)){
	            	return;
	            }

	        	if(response.data.resultCode == "success"){

		        	if (response.data.list.length == 0) {
		        		grid2.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
		        		grid2.showNoRowsOverlay();  			// 데이터가 없는 경우
		            } else {

						var lst = response.data.list;	//정상데이터
						grid2.setGridOption("rowData", lst);
		            }

	        	} else {
	        		if(response.data.resultMsg != null && response.data.resultMsg != ''){
	        			alert(response.data.resultMsg);
	        		} else {
	        			alert("저장에 실패하였습니다");
	        		}
	        	}
	        })
	        .catch(function(error) {
	            console.error('There was an error fetching the data:', error);
	        }).finally(function() {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
	        });
		}, 500);

	}

	function requestEtc(){
		grid2.stopEditing();

		setTimeout(function(){
			var updateItem = getChkRows(grid2);

			if(updateItem.length <=0 ){
				alert("승인요청할 항목을 체크해주세요");
				return;
			}
			// 로딩 시작
	        $('.loading-wrap--js').show();
	        axios.post('${pageContext.request.contextPath}/usr/mem0002_0006.do',updateItem).then(function(response) {        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	            if(chkLogOut(response.data)){
	            	return;
	            }

	        	if(response.data.resultCode == "success"){

		        	if (response.data.list.length == 0) {
		        		grid2.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
		        		grid2.showNoRowsOverlay();  			// 데이터가 없는 경우
		            } else {

						var lst = response.data.list;	//정상데이터
						grid2.setGridOption("rowData", lst);
		            }

	        	} else {
	        		if(response.data.resultMsg != null && response.data.resultMsg != ''){
	        			alert(response.data.resultMsg);
	        		} else {
	        			alert("요청에 실패하였습니다");
	        		}
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

	function deleteEtc(){
		grid2.stopEditing();

		setTimeout(function(){
			var updateItem = getChkRows(grid2);

			if(updateItem.length <=0 ){
				alert("삭제할 항목을 체크해주세요");
				return;
			}
			// 로딩 시작
	        $('.loading-wrap--js').show();
	        axios.post('${pageContext.request.contextPath}/usr/mem0002_0007.do',updateItem).then(function(response) {        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	            if(chkLogOut(response.data)){
	            	return;
	            }

	        	if(response.data.resultCode == "success"){

		        	if (response.data.list.length == 0) {
		        		grid2.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
		        		grid2.showNoRowsOverlay();  			// 데이터가 없는 경우
		            } else {

						var lst = response.data.list;	//정상데이터
						grid2.setGridOption("rowData", lst);
		            }

	        	} else {
	        		if(response.data.resultMsg != null && response.data.resultMsg != ''){
	        			alert(response.data.resultMsg);
	        		} else {
	        			alert("삭제에 실패하였습니다");
	        		}
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
			        changeCrud(event, grid);
			    },
			    onRowClicked: function (event) {
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
	//아이디가 존재하면 기존 개인 정보를 불러온다
	function chkId(params){
		const colId = params.column.getId();
		if(colId == 'mberId'){

			if(params.node.data.mberId != ''){

				const inputData = new URLSearchParams();
				const gridIdx = params.node.rowIndex;
				inputData.append("mberId", params.node.data.mberId);

				// 로딩 시작
		        $('.loading-wrap--js').show();

		        axios.post('${pageContext.request.contextPath}/usr/mem0002_0003.do',inputData).then(function(response) {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();

		            if(chkLogOut(response.data)){
		            	return;
		            }

		        	if(response.data.resultCode == "success"){

		        		grid1.getRowNode(gridIdx).setDataValue('mberNm', response.data.userVo.mberNm);
		        		grid1.getRowNode(gridIdx).setDataValue('mbtlnum', response.data.userVo.mbtlnum);
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
	function changeCost(params){
		debugger;
		const colId = params.column.getId();
		if(colId == 'paybackDay' || colId == 'paybackCost'){
// 			const gridIdx = params.node.rowIndex;
// 			grid2.getRowNode(gridIdx).setDataValue('paybackCostAll', Number(params.node.data.paybackDay, 10)*Number(params.node.data.paybackCost, 10));
			var nowSelNode = findRowNode(grid2, 'uniq', params.node.data.uniq);
			if(params.node.data.paybackDay != undefined && params.node.data.paybackCost != undefined){
				nowSelNode.setDataValue('paybackCostAll', Number(params.node.data.paybackDay, 10)*Number(params.node.data.paybackCost, 10));
			}
		}
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
			        changeCrud(event, grid1, "mberId");
			        chkId(event);
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
        const gridDiv = document.querySelector('#myGrid1');
        grid1 = agGrid.createGrid(gridDiv, gridOptions);

        grid1.hideOverlay();

	}

	function setGrid2(){
		// 사용자 정의 컴포넌트를 글로벌 네임스페이스에 추가
		window.CustomHeader = CustomHeader;
    	gridOptions = {
                columnDefs: columnDefs2,
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
			        changeCrud(event, grid2, "etcId");
			        changeCost(event);
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
        const gridDiv = document.querySelector('#myGrid2');
        grid2 = agGrid.createGrid(gridDiv, gridOptions);

        grid2.hideOverlay();

	}


	function onInputVal(obj){

		//빈값이면 0으로
		if(obj.value == "") obj.value = 0;

		//모두 숫자로 변환
		obj.value = obj.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');

		//콤마 붙여서 리턴
		obj.value = currencyFormatter(obj.value);
	}


	function 고용보험일괄(){
		if(!chkPercent($('#일괄숫자').val())){
			return false;
		}
		grid1.forEachNode( function(rowNode, index) {
			rowNode.setDataValue('feeEmploymentInsurance', $('#일괄숫자').val());
		});
	}
	function 산재보험일괄(){
		if(!chkPercent($('#일괄숫자').val())){
			return false;
		}
		grid1.forEachNode( function(rowNode, index) {
			rowNode.setDataValue('feeIndustrialInsurance', $('#일괄숫자').val());
		});
	}
	function 원천세일괄(){
		if(!chkPercent($('#일괄숫자').val())){
			return false;
		}
		grid1.forEachNode( function(rowNode, index) {
			rowNode.setDataValue('feeWithholdingTax', $('#일괄숫자').val());
		});

	}
	function 시간쪠보험일괄(){
		if(!chkWan($('#일괄숫자').val())){
			return false;
		}
		grid1.forEachNode( function(rowNode, index) {
			rowNode.setDataValue('feeTimeInsurance', $('#일괄숫자').val());
		});
	}
	function 콜수수료일괄(){
		if(!chkWan($('#일괄숫자').val())){
			return false;
		}
		grid1.forEachNode( function(rowNode, index) {
			rowNode.setDataValue('feeCall', $('#일괄숫자').val());
		});
	}

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
							<li><a href="${pageContext.request.contextPath}/usr/mem0001.do">협력사 관리</a></li>
              				<li style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0003.do">협력사계정 관리</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/mem0002.do" class="active">라이더관리</a></li>
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
		<p class="tit">라이더 관리</p>

		<input name="pageUnit" type="hidden" value="1000" /> <input
			name="pageSize" type="hidden" value="1000" />
		<!--과제관리_목록 -->
		<div class="search_box ty2">


			<div class="card-body py-0 scrollbar to-do-list-body" id="notList">
				<!-- 팝업 -->
                  <div class="modal fade" id="exampleModal" tabindex="-1" style="display: none;" aria-hidden="true">
                    <div class="modal-dialog modal-xl">
                      <div class="modal-content bg-body overflow-hidden">
                        <div class="modal-header justify-content-between px-6 py-5 pe-sm-5 px-md-6 dark__bg-gray-1100">
                          <h3 class="text-body-highlight fw-bolder mb-0" id="title">기타(대여.리스) 관리</h3>
                          <button style="min-width:50px!important; min-height:50px!important;" class="btn btn-phoenix-secondary btn-icon btn-icon-xl flex-shrink-0" type="button" data-bs-dismiss="modal" aria-label="Close"><svg class="svg-inline--fa fa-xmark" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" data-fa-i2svg=""><path fill="currentColor" d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z"></path></svg></button>
                        </div>
                        <div class="modal-body bg-body-highlight px-6 py-0">
                          <div class="row gx-14">
                            <div class="col-12 border-end-lg">
                              <div class="py-6">
                                <div class="mb-7">
<!--                                   <div class="d-flex align-items-center mb-3"> -->
<!--                                     <h4 class="text-body me-3">Description</h4> -->
<!--                                   </div> -->
<!--                                   <p class="text-body-highlight mb-0" id="longtxt">The female circus horse-rider is a recurring subject in Chagall’s work. In 1926 the art dealer Ambroise Vollard invited Chagall to make a project based on the circus. They visited Paris’s historic Cirque d’Hiver Bouglione together; Vollard lent Chagall his private box seats. Chagall completed 19 gouaches Chagall’s work. In 1926 the art dealer Ambroise Vollard invited Chagall to make a project based on the circus.</p> -->
									<input type="hidden" id="modalCooperatorId" />
									<input type="hidden" id="modalMberId" />

									<div style="height: 0px;">
										<span class="pagetotal" style='margin-right: 20px;'>라이더 승인 후에는 정보 변경이 안됩니다. 신중히 승인 요청해 주세요</span>
										<div class="btnwrap">
											<button id="기타추가버튼" class="btn btn-primary">추가</button>
											<button id="기타저장버튼" class="btn ty1">저장</button>
											<button id="기타요청버튼" class="btn ty1">승인요청</button>
											<button id="기타삭제버튼" class="btn ty1">삭제</button>
										</div>
									</div>
									<div class="ib_product">
										<div id="myGrid2" class="ag-theme-alpine" style="height: 420px; width: 100%;"></div>
									</div>
                                </div>
<!--                                 <div class="mb-3"> -->
<!--                                   <div> -->
<!--                                     <h4 class="mb-3">Files</h4> -->
<!--                                   </div> -->
<!--                                 </div> -->
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
				<!-- 팝업 end -->
                </div>
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
					<span class="pagetotal" style='margin-right: 20px;'>협력사</span>
					<div class="btnwrap">
<!-- 						<button id="협력사추가버튼" class="btn btn-primary">추가</button> -->
<!-- 						<button id="협력사삭제버튼" class="btn btn-primary" style="display:none;">삭제</button> -->
<!-- 						<button id="협력사저장버튼" class="btn ty1">저장</button> -->
					</div>
				</div>
				<div id="loadingOverlay" style="display: none;">Loading...</div>


				<div class="ib_product">
					<div id="myGrid" class="ag-theme-alpine"
						style="height: 150px; width: 100%;"></div>
				</div>
<!-- 			</div> -->
<!-- 			<div style="float: left; width: 50%;"> -->

				<!-- grid  -->

				<div style="height: 0px;">
					<span class="pagetotal" style='margin-right: 20px;'>ID : 미사용으로 변경시 or 종료일 이후 라이더 출금이 막힘</span>
					<div class="btnwrap">
						<sm>일괄적용 : </sm>
						<input type="text" size='10' id="일괄숫자" oninput="onInputVal(this)"/>
						<button class="btn btn-primary" onclick="고용보험일괄()">고용보험</button>
						<button class="btn btn-primary" onclick="산재보험일괄()">산재보험</button>
						<button class="btn btn-primary" onclick="원천세일괄()">원천세</button>
						<button class="btn btn-primary" onclick="시간쪠보험일괄()">시간쪠보험</button>
						<button class="btn btn-primary me-md-4" onclick="콜수수료일괄()">콜수수료</button>
						<button id="아이디추가버튼" class="btn btn-primary">추가</button>
						<button id="아이디저장버튼" class="btn ty1">저장</button>
					</div>
				</div>
				<div class="ib_product">
					<div id="myGrid1" class="ag-theme-alpine"
						style="height: 420px; width: 100%;"></div>
				</div>
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