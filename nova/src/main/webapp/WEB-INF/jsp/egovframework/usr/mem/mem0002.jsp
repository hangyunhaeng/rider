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
		{ headerName: "영업사원<br/>선지급수수료(%)", field: "feeSalesman", minWidth: 90},
		{ headerName: "고용보험(%)", field: "feeEmploymentInsurance", minWidth: 90},
		{ headerName: "산재보험(%)", field: "feeIndustrialInsurance", minWidth: 90},
		{ headerName: "원천세(%)", field: "feeWithholdingTax", minWidth: 90},
		{ headerName: "시간제보험(원)", field: "feeTimeInsurance", minWidth: 90},
		{ headerName: "콜수수료(원)", field: "feeCall", minWidth: 90},

		{ headerName: "구분", field: "gubun", minWidth: 90, hide:true},
		{ headerName: "modifyAt", field: "modifyAt", minWidth: 90, hide:true}
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

		{ headerName: "고용보험(%)", field: "feeEmploymentInsurance", minWidth: 90
			, editable: (params) => {return (params.data.modifyAt== true)? true: false}
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
// 			, valueGetter:(params) => { return currencyFormatter(params.data.feeEmploymentInsurance);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "산재보험(%)", field: "feeIndustrialInsurance", minWidth: 90
			, editable: (params) => {return (params.data.modifyAt== true)? true: false}
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
// 			, valueGetter:(params) => { return currencyFormatter(params.data.feeIndustrialInsurance);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "원천세(%)", field: "feeWithholdingTax", minWidth: 90
			, editable: (params) => {return (params.data.modifyAt== true)? true: false}
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
// 			, valueGetter:(params) => { return currencyFormatter(params.data.feeWithholdingTax);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "시간제보험(원)", field: "feeTimeInsurance", minWidth: 90
			, editable: (params) => {return (params.data.modifyAt== true)? true: false}
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeTimeInsurance);}
            , valueParser: (params) => { return gridWan(params);}
		},
		{ headerName: "콜수수료(원)", field: "feeCall", minWidth: 90
			, editable: (params) => {return (params.data.modifyAt== true)? true: false}
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeCall);}
            , valueParser: (params) => { return gridWan(params);}
		},
		{ headerName: "기타<br/>(대여,리스)", field: "etcCall", minWidth: 90
			, cellRenderer:(params) => { return '<div class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" data-bs-toggle="modal" data-bs-target="#exampleModal" onclick="clickEtc(\''+params.data.cooperatorId+'\', \''+params.data.mberId+'\')">관리</div>';}
		},

		{ headerName: "사용여부", field: "useAt", minWidth: 90, editable: true
		,valueGetter:(params) => { return (params.node.data.useAt=='Y')?"사용": "미사용"}
		,cellEditor: 'agSelectCellEditor'
		,cellEditorParams: params => { return {values: ['Y', 'N']}; }
		, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "접속", field: "con", minWidth: 90, hide: true
			, cellRenderer:(params) => {return '<div class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="clickCon(\''+params.data.mberId+'\')">접속</div>';}
		},
		{ headerName: "생성자", field: "creatId", minWidth: 90, hide:true},
		{ headerName: "modifyAt", field: "modifyAt", minWidth: 90, hide:true}
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
		{ headerName: "상환시작일", field: "startDt", minWidth: 100, maxWidth: 100, editable: (params) => {return (params.node.data.responsAt == 'Y')? false: true}
	        , valueParser: (params) => { return gridValidDate(params);}
	        , cellClass: (params) => {return agGrideditClass(params)}
	        , valueGetter:(params) => { return getStringDate(params.data.startDt)}
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
    		modifyAt: grid.getRowNode(grid.getFocusedCell().rowIndex).data.modifyAt,						//수정여부

    		useAt: 'Y',
    		crud: "c"
	    };
	    return newData;
	}


	function createNewRowData2() {
		var today = new Date();
	    var newData = {
    		cooperatorId: $('#modalCooperatorId').val(),
    		mberId: $('#modalMberId').val(),
    		gubun: 'D',
    		startDt : today.getFullYear()+(""+(today.getMonth()+1)).padStart(2, '0')+""+today.getDate(),
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

	// 라이더 정보 저장
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

        if('${loginVO.authorCode}' =='ROLE_ADMIN')
        	grid1.setColumnVisible('con', true);
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