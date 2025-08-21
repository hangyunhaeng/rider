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
	var grid2="";
	var grid3="";
	let data;
	var columnDefs= [
		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "오류", field: "err", minWidth: 120, hide:true},
		{ headerName: "coofitId", field: "coofitId", minWidth: 120, hide:true},
		{ headerName: "profitId", field: "profitId", minWidth: 120, hide:true},
		{ headerName: "배달건수", field: "deliveryCnt", minWidth: 70
			, valueGetter:(params) => { return params.data.deliveryCnt > 0 || params.data.deliveryCnt =='합계'? params.data.deliveryCnt: ''}
			, cellClass: 'ag-cell-right'
		},
		{ headerName: "배달일", field: "deliveryDay", minWidth: 120},
		{ headerName: "배달비", field: "deliveryCost", minWidth: 120
			, valueGetter:(params) => { return params.data.deliveryCnt > 0 ? currencyFormatter(params.data.deliveryCost): ''}
			, cellClass: 'ag-cell-right'
		},
		{ headerName: "dypId", field: "dypId", minWidth: 120, hide:true},
		{ headerName: "wkpId", field: "wkpId", minWidth: 120, hide:true},
		{ headerName: "feeId", field: "feeId", minWidth: 120, hide:true},
		{ headerName: "riderFeeId", field: "riderFeeId", minWidth: 120, hide:true},
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 140},
		{ headerName: "협력사명", field: "cooperatorNm", minWidth: 140},
		{ headerName: "라이더ID", field: "mberId", minWidth: 140, valueGetter:(params) => { return params.data.mberId == '${notMberId}' ? '' :params.data.mberId; }},
		{ headerName: "라이더명", field: "mberNm", minWidth: 140},
		{ headerName: "구분", field: "gubun", minWidth: 140, hide:true},
		{ headerName: "구분", field: "gubunNm", minWidth: 140},
		{ headerName: "금액", field: "cost", minWidth: 80
			, cellClass: (params) => {return agGridUnderBarClass(params, 'ag-cell-right')}
			, valueGetter:(params) => { return currencyFormatter(params.data.cost)}
			, cellRenderer:(params) => { return '<div data-bs-toggle="modal" data-bs-target="#exampleModal" onclick="clickFee(\''+params.data.coofitId+'\')">'+currencyFormatter(params.data.cost)+'</div>';}
		},
		{ headerName: "등록일", field: "creatDt", minWidth: 140, valueGetter:(params) => { return getStringDate(params.data.creatDt)}}
	];


	var columnDefs2= [
		{ headerName: "crud", field: "crud", minWidth: 90, hide:true},
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120, hide:true
			, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "협력사이름", field: "cooperatorNm", minWidth: 120
			, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "사업자등록번호", field: "registrationSn", minWidth: 110, hide:true
            , valueParser: (params) => {
                return gridRegistrationSn(params);
            }
            , cellClass: (params) => {return agGrideditClass(params)}
        },
		{ headerName: "상호", field: "companyNm", minWidth: 160, hide:true
        	, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "사업자이름", field: "registrationNm", minWidth: 90, hide:true
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-left")} , hide:true},
		{ headerName: "대표자명", field: "ceoNm", minWidth: 90, hide:true
			, cellClass: (params) => {return agGrideditClass(params)}},
// 		{ headerName: "사용여부", field: "useAt", minWidth: 90, valueGetter:(params) => { return (params.node.data.useAt=='Y')?"사용": "미사용"}},

		{ headerName: "소속<br/>라이더", field: "rdcnt", minWidth: 80, cellClass: 'ag-cell-right', hide:true},
		{ headerName: "출금가능금액", field: "xxx", minWidth: 90, cellClass: 'ag-cell-right', hide:true},
		{ headerName: "feeId", field: "feeId", minWidth: 90, hide:true},
		{ headerName: "선지급수수료(%)", field: "feeAdminstrator", minWidth: 90, maxWidth: 95
			, valueGetter:(params) => { return currencyFormatter(params.data.feeAdminstrator);}
		},
		{ headerName: "협력사<br/>선지급수수료(%)", field: "feeCooperator", minWidth: 90, maxWidth: 95
			, valueGetter:(params) => { return currencyFormatter(params.data.feeCooperator);}
		},
		{ headerName: "영업사원<br/>선지급수수료(%)", field: "feeSalesman", minWidth: 87, maxWidth: 87
			, valueGetter:(params) => { return currencyFormatter(params.data.feeSalesman);}
		},
		{ headerName: "고용보험(%)", field: "feeEmploymentInsurance", minWidth: 90, maxWidth: 95
			, valueGetter:(params) => { return currencyFormatter(params.data.feeEmploymentInsurance);}
		},
		{ headerName: "산재보험(%)", field: "feeIndustrialInsurance", minWidth: 90, maxWidth: 95
			, valueGetter:(params) => { return currencyFormatter(params.data.feeIndustrialInsurance);}
		},
		{ headerName: "원천세(%)", field: "feeWithholdingTax", minWidth: 90, maxWidth: 94
			, valueGetter:(params) => { return currencyFormatter(params.data.feeWithholdingTax);}
		},
		{ headerName: "시간제보험(원)", field: "feeTimeInsurance", minWidth: 90, maxWidth: 93
			, valueGetter:(params) => { return currencyFormatter(params.data.feeTimeInsurance);}
		},
		{ headerName: "콜수수료(원)", field: "feeCall", minWidth: 90, maxWidth: 93
			, valueGetter:(params) => { return currencyFormatter(params.data.feeCall);}
		},
		{ headerName: "협력사<br/>콜수수료(%)", field: "feeCooperatorCall", minWidth: 90, maxWidth: 95
			, valueGetter:(params) => { return currencyFormatter(params.data.feeCooperatorCall);}
		},
		{ headerName: "사용여부", field: "useAt", minWidth: 90, hide:true
			, valueGetter:(params) => { return (params.node.data.useAt=='Y')?"사용": "미사용"}
		},
		{ headerName: "등록일", field: "creatDt", minWidth: 100, maxWidth: 100
	        , valueGetter:(params) => { return getStringDate(params.data.creatDt)}
	    },
		{ headerName: "생성자", field: "creatId", minWidth: 90, hide:true},
		{ headerName: "구분", field: "gubun", minWidth: 90, hide:true}


	];

	var columnDefs3= [
		{ headerName: "crud", field: "crud", minWidth: 90, hide:true},
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120, hide:true},
		{ headerName: "ID", field: "mberId", minWidth: 90, cellClass: (params) => {return agGrideditClass(params)}, maxWidth: 150},
		{ headerName: "이름", field: "mberNm", minWidth: 90, cellClass: (params) => {return agGrideditClass(params)}, maxWidth: 150},
// 		{ headerName: "수수료", field: "fee", minWidth: 90, editable: true, cellClass: (params) => {return agGrideditClass(params, 'ag-cell-right')} },
		{ headerName: "핸드폰번호", field: "mbtlnum", minWidth: 120, hide:true
	        , valueParser: (params) => {
	            return gridValidPhoneNumber(params);
	        }
			, cellClass: (params) => {return agGrideditClass(params, 'ag-cell-left')}
			,valueGetter:(params) => { return addHyphenToPhoneNumber(params.data.mbtlnum)}
		},
		{ headerName: "등록일", field: "regDt", minWidth: 100, hide:true
	        , valueParser: (params) => {
	            return gridValidDate(params);
	        }
	        , cellClass: (params) => { return agGrideditClass(params)}
	        , valueGetter:(params) => { return getStringDate(params.data.regDt)}
		},
		{ headerName: "종료일", field: "endDt", minWidth: 100, hide:true
	        , valueParser: (params) => {
	            return gridValidDate(params);
	        }
	        , cellClass: (params) => {return agGrideditClass(params)}
	        , valueGetter:(params) => { return getStringDate(params.data.endDt)}
		},

		{ headerName: "고용보험(%)", field: "feeEmploymentInsurance", minWidth: 90, maxWidth: 150
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
// 			, valueGetter:(params) => { return currencyFormatter(params.data.feeEmploymentInsurance);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "산재보험(%)", field: "feeIndustrialInsurance", minWidth: 90, maxWidth: 150
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
// 			, valueGetter:(params) => { return currencyFormatter(params.data.feeIndustrialInsurance);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "원천세(%)", field: "feeWithholdingTax", minWidth: 90, maxWidth: 150
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
// 			, valueGetter:(params) => { return currencyFormatter(params.data.feeWithholdingTax);}
            , valueParser: (params) => { return gridPercent(params);}
		},
		{ headerName: "시간제보험(원)", field: "feeTimeInsurance", minWidth: 90, maxWidth: 150
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeTimeInsurance);}
            , valueParser: (params) => { return gridWan(params);}
		},
		{ headerName: "콜수수료(원)", field: "feeCall", minWidth: 90, maxWidth: 150
			, cellClass: (params) => {return agGrideditClass(params, "ag-cell-right");}
			, valueGetter:(params) => { return currencyFormatter(params.data.feeCall);}
            , valueParser: (params) => { return gridWan(params);}
		},
		{ headerName: "기타<br/>(대여,리스)", field: "etcCall", minWidth: 90, hide:true
			, cellRenderer:(params) => { return '<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer" data-bs-toggle="modal" data-bs-target="#exampleModal" onclick="clickEtc(\''+params.data.cooperatorId+'\', \''+params.data.mberId+'\')">관리</div>';}
		},

		{ headerName: "사용여부", field: "useAt", minWidth: 90, hide:true
		,valueGetter:(params) => { return (params.node.data.useAt=='Y')?"사용": "미사용"}
		,cellEditor: 'agSelectCellEditor'
		,cellEditorParams: params => { return {values: ['Y', 'N']}; }
		, cellClass: (params) => {return agGrideditClass(params)}},
		{ headerName: "생성자", field: "creatId", minWidth: 90, hide:true}
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

		loadCooperatorList();
		//그리드 설정
		setGrid();
		setGrid2();
		setGrid3();
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
		if($('#searchRegistrationSn').val().trim() != '' && $('#searchRegistrationSn').val().trim().length != 10){
			alert("식별번호는 10자리입니다");
			$('#searchRegistrationSn').focus()
			return ;
		}

	    if(!limit2Week($('#searchFromDate').val(), $('#searchToDate').val())){
	    	return;
	    }

		const params = new URLSearchParams();
		params.append('searchCooperatorId', $('#searchCooperatorId').val());
		params.append('searchFromDate', getOnlyNumber($('#searchFromDate').val()));
		params.append('searchToDate', getOnlyNumber($('#searchToDate').val()));
		params.append('searchNm', $('#searchNm').val().trim());
		params.append('searchRegistrationSn', $('#searchRegistrationSn').val().trim());
		params.append('searchGubun', $('#searchGubun').val());

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/pay0004_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

			if(response.data.resultCode == "success"){

	            document.getElementById('TT_CNT0').textContent = currencyFormatter(response.data.list.length);

	        	if (response.data.list.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
					var sum = [{deliveryCnt:"합계"
						, cost: 0
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {
					var lst = response.data.list;	//정상데이터

					var sum = [{deliveryCnt:"합계"
						, cost: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.cost, 10), 0)
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);

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
				overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>',
				pinnedBottomRowData: [
					{deliveryCnt:"합계", cost: 0}
		        ],
				onCellClicked : function (event) { //onSelectionChanged  :row가 바뀌었을때 발생하는 이벤트인데 잘 안됨.
			    	selcetRow(event);
			    },
                getRowStyle: (params) => {
					if (params.node.rowPinned === 'bottom') {
						return { 'background-color': 'lightblue' };
					}
					return null;
				}
            };
        const gridDiv = document.querySelector('#myGrid');
        grid = agGrid.createGrid(gridDiv, gridOptions);

        grid.hideOverlay();

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
				overlayNoRowsTemplate: '<span class="ag-overlay-loading-center">데이터가 없습니다</span>'
            };
        const gridDiv = document.querySelector('#myGrid2');
        grid2 = agGrid.createGrid(gridDiv, gridOptions);

        grid2.hideOverlay();

	}

	function setGrid3(){
		// 사용자 정의 컴포넌트를 글로벌 네임스페이스에 추가
		window.CustomHeader = CustomHeader;
    	gridOptions = {
                columnDefs: columnDefs3,
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
        const gridDiv = document.querySelector('#myGrid3');
        grid3 = agGrid.createGrid(gridDiv, gridOptions);

        grid3.hideOverlay();

	}
	function selcetRow(params){
		if(params.column.colId == "sendPrice"){
			debugger;
			if(params.node.data.dwGubun == 'DAY'){
				if(params.node.data.ioGubun == '1'){
					$('#myForm').attr("action", "/usr/dty0001.do");
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchDate", value:params.node.data.fileDate}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchId", value:params.node.data.dayAtchFileId}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchMberId", value:params.node.data.mberId}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchRunDeDate", value:params.node.data.accountsStDt}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchError", value:"false"}));

					$('#myForm').submit();
				}
			}
			if(params.node.data.dwGubun == 'WEK'){
				if(params.node.data.ioGubun == '1'){
					$('#myForm').attr("action", "/usr/dty0002.do");
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchDate", value:params.node.data.fileDate}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchId", value:params.node.data.wekAtchFileId}));
					$('#myForm').append($("<input/>", {type:"hidden", name:"searchMberId", value:params.node.data.mberId}));
					$('#myForm').submit();
				}
			}
		}
	}

	function agGridUnderBarClass(params, addClass){
		var pAddClass = (addClass =='undefined')? "" : addClass;
		if(params.node.data.gubun == 'C' || params.node.data.gubun == 'D')
			return pAddClass+" tdul";
		else
			return pAddClass;
	}

	function clickFee(coofitId){


		const params = new URLSearchParams();
		params.append('coofitId', coofitId);

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/pay0004_0002.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

			if(response.data.resultCode == "success"){

	        	if (response.data.list.length == 0) {
	        		grid2.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid2.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

	            	data = response.data.list;	//정상데이터
					grid2.setGridOption("rowData", data);
	            }

	        	if (response.data.riderList.length == 0) {
	        		grid3.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
	        		grid3.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

	            	data = response.data.riderList;	//정상데이터
					grid3.setGridOption("rowData", data);
	            }
	        	if(response.data.base.gubun == 'C'){	//콜수수료
	        		$('#근거금액').html("배달비 : "+currencyFormatter(response.data.base.cost)+' / 배달건수 : '+response.data.base.deliveryCnt);
	        		var iFee = Math.floor(response.data.base.deliveryCnt*grid3.getRowNode(0).data.feeCall*0.01*grid2.getRowNode(0).data.feeCooperatorCall);
	        		$('#계산식').html(currencyFormatter(response.data.base.deliveryCnt) +" * "+currencyFormatter(grid3.getRowNode(0).data.feeCall)+" * 0.01 * "+grid2.getRowNode(0).data.feeCooperatorCall+" = "+currencyFormatter(iFee));

					//협력사 수수료 색상 바꾸기
					const imsiColumnDefs = grid2.getColumnDefs(); // 현재 컬럼정의 가져오깅(당근 배열임)
					for (let colDef of imsiColumnDefs) {
						if (colDef.field == "feeCall" || colDef.field == "feeCooperatorCall") {
							colDef.cellClass = "edited-bg";
						} else {
							colDef.cellClass = "";
						}
					}
	                grid2.setGridOption("columnDefs", imsiColumnDefs);

					//라이더 수수료 색상 바꾸기
					const imsiColumnDefs1 = grid3.getColumnDefs(); // 현재 컬럼정의 가져오깅(당근 배열임)
					for (let colDef of imsiColumnDefs1) {
						if (colDef.field == "feeCall") {
							colDef.cellClass = "edited-bg";
						} else {
							colDef.cellClass = "";
						}
					}
	                grid3.setGridOption("columnDefs", imsiColumnDefs1);

	        	} else if(response.data.base.gubun == 'D'){	//선지급수수료
	        		$('#근거금액').html(currencyFormatter(response.data.base.cost));
	        		var iFee = Math.floor(response.data.base.cost*0.01*grid2.getRowNode(0).data.feeCooperator);
	        		$('#계산식').html(currencyFormatter(response.data.base.cost)+" * 0.01 * "+grid2.getRowNode(0).data.feeCooperator+" = "+currencyFormatter(iFee));

					//협력사 수수료 색상 바꾸기
					const imsiColumnDefs = grid2.getColumnDefs(); // 현재 컬럼정의 가져오깅(당근 배열임)
					for (let colDef of imsiColumnDefs) {
						if (colDef.field == "feeCooperator") {
							colDef.cellClass = "edited-bg";
						} else {
							colDef.cellClass = "";
						}
					}
	                grid2.setGridOption("columnDefs", imsiColumnDefs);
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
		<p class="tit">협력사수익현황</p>

			<input name="pageUnit" type="hidden" value="1000"/>
			<input name="pageSize" type="hidden" value="1000"/>
			<!--과제관리_목록 -->
			<div class="search_box ty2">



			<div class="card-body py-0 scrollbar to-do-list-body" id="notList">
				<!-- 팝업 -->
                  <div class="modal fade" id="exampleModal" tabindex="-1" style="display: none;" aria-hidden="true">
                    <div class="modal-dialog modal-xl">
                      <div class="modal-content bg-body overflow-hidden">
                        <div class="modal-header justify-content-between px-6 py-5 pe-sm-5 px-md-6 dark__bg-gray-1100">
                          <h3 class="text-body-highlight fw-bolder mb-0">수수료 계산 근거</h3>
                          <button style="min-width:50px!important; min-height:50px!important;" class="btn btn-phoenix-secondary btn-icon btn-icon-xl flex-shrink-0" type="button" data-bs-dismiss="modal" aria-label="Close"><svg class="svg-inline--fa fa-xmark" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" data-fa-i2svg=""><path fill="currentColor" d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z"></path></svg></button>
                        </div>
                        <div class="modal-body bg-body-highlight px-6 py-0">
                          <div class="row gx-14">
                            <div class="col-12 border-end-lg">
                              <div class="py-6">
                                <div class="mb-7">

									<div style="height: 0px;">
										<span class="pagetotal" style='margin-right: 20px;'>협력사 수수료</span>
									</div>
									<div class="ib_product">
										<div id="myGrid2" class="ag-theme-alpine" style="height: 90px; width: 100%;"></div>
									</div>

									<div style="height: 0px;">
										<span class="pagetotal" style='margin-right: 20px;'>라이더 수수료</span>
									</div>
									<div class="ib_product">
										<div id="myGrid3" class="ag-theme-alpine" style="height: 90px; width: 100%;"></div>
									</div>
<br/>

				<table>
					<colgroup>
						<col style="width: 13%">
						<col style="width: 87%">
					</colgroup>

					<tr>
						<th>근거금액</th>
						<td>
							<sm id="근거금액" class="float-start"></sm>
						</td>
					</tr>
					<tr>
						<th>계산식</th>
						<td>
							<sm id="계산식" class="float-start"></sm>
						</td>
					</tr>
				</table>

                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
				<!-- 팝업 end -->
                </div>



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
						<th>라이더명</th>
						<td>
							<input id="searchNm" type="text" >
						</td>
					</tr>
					<tr>
						<th>배달일</th>
						<td>
							<div>
								<input id="searchFromDate" class="form-control search fs-9 float-start w40p"" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
								<sm class="float-start">&nbsp;~&nbsp;</sm>
								<input id="searchToDate" class="form-control search fs-9 float-start w40p" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
							</div>
						</td>
						<th>식별번호</th>
						<td>
<!-- 							<input id="searchRegistrationSn" type="text" oninput="this.value = this.value.replace(/[^0-9-]/g, '').replace(/(\..*)\./g, '$1');"> -->
							<input id="searchRegistrationSn" type="text" >
						</td>
					</tr>
					<tr>
						<th>구분</th>
						<td colspan="3">
							<select id="searchGubun" name='searchGubun' style='width: 100%'>
								<option value="all">전체</option>
								<option value="C">콜수수료</option>
								<option value="E">기타수수료</option>
								<option value="D">선지급수수료</option>
								<option value="B">부가세</option>
								<option value="O">원천세</option>
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