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
	var columnDefs= [
		{ headerName: "NO", field: "no", minWidth: 70, valueGetter:(params) => { return params.node.rowIndex + 1} },
		{ headerName: "협력사아이디", field: "cooperatorId", minWidth: 120},
		{ headerName: "협력사명", field: "cooperatorNm", minWidth: 120},
		{ headerName: "정산시작일", field: "accountsStDt", minWidth: 90},
		{ headerName: "정산종료일", field: "accountsEdDt", minWidth: 90},
		{ headerName: "배달료(A-1)", field: "deliveryCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.deliveryCost)}},
		{ headerName: "추가정산(A-2)", field: "addAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.addAccounts)}},
// 		{ headerName: "운영비(C-2)", field: "operatingCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.operatingCost)}},
		{ headerName: "관리비(B)", field: "managementCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.managementCost)}},
		{ headerName: "운영비©", field: "operatingCostAdd", minWidth: 120, cellClass: 'ag-cell-right edited-bg', valueGetter:(params) => { return currencyFormatter(params.data.operatingCostAdd)}},
// 		{ headerName: "운영수수료(B-2)", field: "operatingFee", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.operatingFee)}},
		{ headerName: "부가세액(C)", field: "etcCost", minWidth: 120, cellClass: 'ag-cell-right edited-bg', valueGetter:(params) => { return currencyFormatter(params.data.etcCost)}},
		{ headerName: "시간제보험료", field: "timeInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.timeInsurance)}},
		{ headerName: "사업주부담<br/>고용보험료(1)", field: "ownerEmploymentInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ownerEmploymentInsurance)}},
		{ headerName: "라이더부담<br/>고용보험료(2) ", field: "riderEmploymentInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.riderEmploymentInsurance)}},
		{ headerName: "사업주부담<br/>산재보험료(3)", field: "ownerIndustrialInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ownerIndustrialInsurance)}},
		{ headerName: "라이더부담<br/>산재보험료(4) ", field: "riderIndustrialInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.riderIndustrialInsurance)}},
		{ headerName: "원천징수보험료합계<br/>(1+2+3+4)(D)", field: "withholdingTaxInsuranceSum", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.withholdingTaxInsuranceSum)}},
		{ headerName: "고용보험<br/>소급정산(E)", field: "employmentInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.employmentInsuranceAccounts)}},
		{ headerName: "산재보험<br/>소급정산(F) ", field: "industrialInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.industrialInsuranceAccounts)}},
// 		{ headerName: "G(G)", field: "g", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.g)}},
		{ headerName: "정산예정금액<br/>(A+B-C)-시간제보험료-(D+E+F+G)", field: "accountsScheduleCost", minWidth: 200, valueGetter:(params) => { return currencyFormatter(params.data.accountsScheduleCost)}},
		{ headerName: "세금계산서<br/>공급가액 ", field: "taxBillSupply", minWidth: 120, cellClass: 'ag-cell-right edited-bg', valueGetter:(params) => { return currencyFormatter(params.data.taxBillSupply)}},
		{ headerName: "세금계산서<br/>부가세액 ", field: "taxBillAdd", minWidth: 120, cellClass: 'ag-cell-right edited-bg', valueGetter:(params) => { return currencyFormatter(params.data.taxBillAdd)}},
		{ headerName: "세금계산서<br/>공급대가 ", field: "taxBillSum", minWidth: 120, cellClass: 'ag-cell-right edited-bg', valueGetter:(params) => { return currencyFormatter(params.data.taxBillSum)}}
	];

	var columnDefs1= [
		{ headerName: "NO", field: "no", minWidth: 70 },
		{ headerName: "User ID", field: "mberId", minWidth: 120, cellClass: 'ag-cell-left'},
		{ headerName: "라이더명", field: "mberNm", minWidth: 120},
		{ headerName: "처리건수", field: "cnt", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.cnt)}},
		{ headerName: "배달료A", field: "deliveryCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.deliveryCost)}},
		{ headerName: "추가지지급B", field: "addCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.addCost)}},
		{ headerName: "총배달료C<br/>(A+B) ", field: "sumCost", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.sumCost)}},
		{ headerName: "시간제보험료", field: "timeInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.timeInsurance)}},
		{ headerName: "필요경비", field: "necessaryExpenses", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.necessaryExpenses)}},
		{ headerName: "보수액", field: "pay", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.pay)}},
		{ headerName: "사업주부담<br/>고용보험료(1)", field: "ownerEmploymentInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ownerEmploymentInsurance)}},
		{ headerName: "라이더부담<br/>고용보험료(2)", field: "riderEmploymentInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.riderEmploymentInsurance)}},
		{ headerName: "사업주부담<br/>산재보험료(3)", field: "ownerIndustrialInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ownerIndustrialInsurance)}},
		{ headerName: "라이더부담<br/>산재보험료(4)", field: "riderIndustrialInsurance", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.riderIndustrialInsurance)}},
		{ headerName: "원천징수보험료 합계<br/>(1+2+3+4)(D)", field: "withholdingTaxInsuranceSum", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.withholdingTaxInsuranceSum)}},
		{ headerName: "사업주부담 고용보험<br/>소급정산(5) ", field: "ownerEmploymentInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ownerEmploymentInsuranceAccounts)}},
		{ headerName: "라이더부담 고용보험<br/>소급정산(6)", field: "riderEmploymentInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.riderEmploymentInsuranceAccounts)}},
		{ headerName: "합계 고용보험<br/>소급정산(E)", field: "sumEmploymentInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.sumEmploymentInsuranceAccounts)}},
		{ headerName: "사업주부담 산재보험<br/>소급정산(7) ", field: "ownerIndustrialInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.ownerIndustrialInsuranceAccounts)}},
		{ headerName: "라이더부담 산재보험<br/>소급정산(8)", field: "riderIndustrialInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.riderIndustrialInsuranceAccounts)}},
		{ headerName: "합계 산재보험<br/>소급정산(F)", field: "sumIndustrialInsuranceAccounts", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.sumIndustrialInsuranceAccounts)}},
		{ headerName: "운영비(9)", field: "operatingCostAdd", minWidth: 120, cellClass: 'ag-cell-right edited-bg', valueGetter:(params) => { return currencyFormatter(params.data.operatingCostAdd)}},
		{ headerName: "라이더별정산금액(G)<br/>C-(2+4+6+8+9)", field: "accountsCost", minWidth: 120, cellClass: 'ag-cell-right  edited-bg', valueGetter:(params) => { return currencyFormatter(params.data.accountsCost)}},
		{ headerName: "소득세(H)<br/>C*3%", field: "incomeTax", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.incomeTax)}},
		{ headerName: "주민세(I)<br/>H*10%", field: "residenceTax", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.residenceTax)}},
		{ headerName: "원천징수세액(J)<br/>(H+I)", field: "withholdingTax", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.withholdingTax)}},
		{ headerName: "라이더별지급금액(K)<br/>(G-J)", field: "givePay", minWidth: 120, cellClass: 'ag-cell-right', valueGetter:(params) => { return currencyFormatter(params.data.givePay)}}
	];

	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		//일 세팅
		var today = new Date();
		var serchDate = flatpickr("#searchDate", {
			locale: "ko",
			allowInput: false,
		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
		    dateFormat: 'Y-m-d',     // date format 형식
		    disableMobile: true          // 모바일 지원
		    ,plugins: [
		        new monthSelectPlugin({
		          shorthand: true, //defaults to false
		          dateFormat: "Y-m", //defaults to "F Y"
		          altFormat: "Y-m", //defaults to "F Y"
		          theme: "dark" // defaults to "light"
		        })
		    ]

		});
		serchDate.setDate(today.getFullYear()+"-"+(today.getMonth()+1));


		//이벤트 설정
		// 1. 일 변경
		$('#searchDate').on('change', function(e){
			loadFileList();
		});
		// 2. 조회버튼
		$('#loadDataBtn').on("click", function(){
			doSearch();
		});

		//파일명 가져오기
		loadFileList();

		//그리드 설정
		setGrid();
		setGrid1();
	});

	//해당하는 파일명 가져오기
	function loadFileList(){

		const params = new URLSearchParams();

	    var regex = /[^0-9]/g;
		params.append('searchDate', $($('#searchDate')[0]).val().replace(regex, ""));

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0006_0001.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
        	populateSelectOptions('serchFileName', response.data.fileList);
        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {
        	// 로딩 종료
            $('.loading-wrap--js').hide();
        });

	}

	// 내역 조회
	function doSearch(){
		const params = new URLSearchParams();
		params.append('searchAtchFileId', $('#serchFileName').val());

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/dty0006_0002.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

			if(response.data.resultCode == "success"){
	        	if (response.data.list.length == 0) {
	        		grid.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
					var sum = [{cooperatorId:"합계"
						, accountsStDt : ''
						, accountsEdDt : ''
						, deliveryCost : 0
						, addAccounts : 0
						, managementCost : 0
// 						, operatingCost : 0
						, operatingCostAdd : 0
// 						, operatingFee : 0
						, etcCost : 0
						, timeInsurance : 0
						, ownerEmploymentInsurance : 0
						, riderEmploymentInsurance : 0
						, ownerIndustrialInsurance : 0
						, riderIndustrialInsurance : 0
						, withholdingTaxInsuranceSum : 0
						, employmentInsuranceAccounts : 0
						, industrialInsuranceAccounts : 0
// 						, g : 0
						, accountsScheduleCost : 0
						, taxBillSupply : 0
						, taxBillAdd : 0
						, taxBillSum : 0
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);
	        		grid.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					var lst = response.data.list;	//정상데이터

					var sum = [{cooperatorId:"합계"
						, accountsStDt : ''
						, accountsEdDt : ''
						, deliveryCost: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.deliveryCost, 10), 0)
						, addAccounts: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.addAccounts, 10), 0)
						, managementCost: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.managementCost, 10), 0)
// 						, operatingCost: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.operatingCost, 10), 0)
						, operatingCostAdd: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.operatingCostAdd, 10), 0)
// 						, operatingFee: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.operatingFee, 10), 0)
						, etcCost: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.etcCost, 10), 0)
						, timeInsurance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.timeInsurance, 10), 0)
						, ownerEmploymentInsurance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.ownerEmploymentInsurance, 10), 0)
						, riderEmploymentInsurance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.riderEmploymentInsurance, 10), 0)
						, ownerIndustrialInsurance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.ownerIndustrialInsurance, 10), 0)
						, riderIndustrialInsurance: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.riderIndustrialInsurance, 10), 0)
						, withholdingTaxInsuranceSum: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.withholdingTaxInsuranceSum, 10), 0)
						, employmentInsuranceAccounts: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.employmentInsuranceAccounts, 10), 0)
						, industrialInsuranceAccounts: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.industrialInsuranceAccounts, 10), 0)
// 						, g: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.g, 10), 0)
						, accountsScheduleCost: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.accountsScheduleCost, 10), 0)
						, taxBillSupply: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.taxBillSupply, 10), 0)
						, taxBillAdd: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.taxBillAdd, 10), 0)
						, taxBillSum: response.data.list.reduce((acc, num) => Number(acc, 10) + Number(num.taxBillSum, 10), 0)
						}
					];
					grid.setGridOption('pinnedBottomRowData', sum);	//합계데이터는 정상데이터만 포함한다
	                grid.setGridOption('rowData', lst);
	            }

	        	if (response.data.listRider.length == 0) {
	        		grid1.setGridOption('rowData',[]);  	// 데이터가 없는 경우 빈 배열 설정
					var sum = [{cooperatorId:"합계"
						, mberId : ''
						, mberNm : ''
						, cnt : 0
						, deliveryCost : 0
						, addCos : 0
						, sumCost : 0
						, timeInsurance : 0
						, necessaryExpenses : 0
						, pay : 0
						, ownerEmploymentInsurance : 0
						, riderEmploymentInsurance : 0
						, ownerIndustrialInsurance : 0
						, riderIndustrialInsurance : 0
						, withholdingTaxInsuranceSum : 0
						, ownerEmploymentInsuranceAccounts : 0
						, riderEmploymentInsuranceAccounts : 0
						, sumEmploymentInsuranceAccounts : 0
						, ownerIndustrialInsuranceAccounts : 0
						, riderIndustrialInsuranceAccounts : 0
						, sumIndustrialInsuranceAccounts : 0
						, operatingCostAdd : 0
						, accountsCost : 0
						, incomeTax : 0
						, residenceTax : 0
						, withholdingTax : 0
						, givePay : 0
						}
					];
					grid1.setGridOption('pinnedBottomRowData', sum);
	        		grid1.showNoRowsOverlay();  			// 데이터가 없는 경우
	            } else {

					var lst = response.data.listRider;	//정상데이터

					var sum = [{cooperatorId:"합계"
						, mberId : ''
						, mberNm : ''
						, cnt: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.cnt, 10), 0)
						, deliveryCost: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.deliveryCost, 10), 0)
						, addCost: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.addCost, 10), 0)
						, sumCost: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.sumCost, 10), 0)
						, timeInsurance: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.timeInsurance, 10), 0)
						, necessaryExpenses: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.necessaryExpenses, 10), 0)
						, pay: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.pay, 10), 0)
						, ownerEmploymentInsurance: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.ownerEmploymentInsurance, 10), 0)
						, riderEmploymentInsurance: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.riderEmploymentInsurance, 10), 0)
						, ownerIndustrialInsurance: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.ownerIndustrialInsurance, 10), 0)
						, riderIndustrialInsurance: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.riderIndustrialInsurance, 10), 0)
						, withholdingTaxInsuranceSum: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.withholdingTaxInsuranceSum, 10), 0)
						, ownerEmploymentInsuranceAccounts: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.ownerEmploymentInsuranceAccounts, 10), 0)
						, riderEmploymentInsuranceAccounts: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.riderEmploymentInsuranceAccounts, 10), 0)
						, sumEmploymentInsuranceAccounts: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.sumEmploymentInsuranceAccounts, 10), 0)
						, ownerIndustrialInsuranceAccounts: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.ownerIndustrialInsuranceAccounts, 10), 0)
						, riderIndustrialInsuranceAccounts: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.riderIndustrialInsuranceAccounts, 10), 0)
						, sumIndustrialInsuranceAccounts: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.sumIndustrialInsuranceAccounts, 10), 0)
						, operatingCostAdd: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.operatingCostAdd, 10), 0)
						, accountsCost: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.accountsCost, 10), 0)
						, incomeTax: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.incomeTax, 10), 0)
						, residenceTax: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.residenceTax, 10), 0)
						, withholdingTax: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.withholdingTax, 10), 0)
						, givePay: response.data.listRider.reduce((acc, num) => Number(acc, 10) + Number(num.givePay, 10), 0)
						}
					];
					grid1.setGridOption('pinnedBottomRowData', sum);	//합계데이터는 정상데이터만 포함한다
	                grid1.setGridOption('rowData', lst);
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
				pinnedBottomRowData: [
					{cooperatorId:"합계", basicPrice: 0}
		        ],
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
				pinnedBottomRowData: [
					{cooperatorId:"합계", basicPrice: 0}
		        ],
                getRowStyle: (params) => {
					if (params.node.rowPinned === 'bottom') {
						return { 'background-color': 'lightblue' };
					}
					return null;
				}
            };
        const gridDiv = document.querySelector('#myGrid1');
        grid1 = agGrid.createGrid(gridDiv, gridOptions);

        grid1.hideOverlay();

	}


	function subMenuClick(obj){
// 		debugger;
// 		document.querySelectorAll('.navmenu .toggle-dropdown').click();
// 	    document.querySelector('body').classList.toggle('mobile-nav-active');
// 	    const mobileNavToggleBtn = document.querySelector('.mobile-nav-toggle');
// 	    mobileNavToggleBtn.classList.toggle('bi-list');
// 	    mobileNavToggleBtn.classList.toggle('bi-x');
// 		$(obj).find(".toggle-dropdown").click();
// 		$(obj).find(".toggle-dropdown").click();
// 		$(obj).find("i").click()
// $(obj).find('i').trigger('click');
// 		$(obj).find('.toggle-dropdown').click();
		return false;
	}


    function downloadExcel() {
    	var fileName;
        const rows = [];
        const sum = [];
        const rows1 = [];
        const sum1 = [];
        grid.forEachNode((node) => {
            rows.push([node.data.cooperatorId, getStringDate(node.data.accountsStDt), getStringDate(node.data.accountsEdDt)
            	, currencyFormatter(node.data.deliveryCost)
            	, currencyFormatter(node.data.addAccounts)
            	, currencyFormatter(node.data.managementCost)
            	, currencyFormatter(node.data.operatingCostAdd)
            	, currencyFormatter(node.data.etcCost)
            	, currencyFormatter(node.data.timeInsurance)
            	, currencyFormatter(node.data.ownerEmploymentInsurance)
            	, currencyFormatter(node.data.riderEmploymentInsurance)
            	, currencyFormatter(node.data.ownerIndustrialInsurance)
            	, currencyFormatter(node.data.riderIndustrialInsurance)
            	, currencyFormatter(node.data.withholdingTaxInsuranceSum)
            	, currencyFormatter(node.data.employmentInsuranceAccounts)
            	, currencyFormatter(node.data.industrialInsuranceAccounts)
            	, currencyFormatter(node.data.accountsScheduleCost)
            	, currencyFormatter(node.data.taxBillSupply)
            	, currencyFormatter(node.data.taxBillAdd)
            	, currencyFormatter(node.data.taxBillSum)]);
            fileName = node.data.cooperatorId+"_"+node.data.cooperatorNm+"_"+node.data.accountsStDt+"_"+node.data.accountsEdDt+'.xlsx';

        });

        $.each(grid.getGridOption('pinnedBottomRowData')[0], function(index, item){
        	if(item == '합계')
        		sum.push(item);
        	else
        		sum.push(currencyFormatter(item));
        });
        rows.push(sum);


        grid1.forEachNode((node) => {
            rows1.push([node.data.no, node.data.mberId, node.data.mberNm
            	, currencyFormatter(node.data.cnt)
            	, currencyFormatter(node.data.deliveryCost)
            	, currencyFormatter(node.data.addCost)
            	, currencyFormatter(node.data.sumCost)
            	, currencyFormatter(node.data.timeInsurance)
            	, currencyFormatter(node.data.necessaryExpenses)
            	, currencyFormatter(node.data.pay)
            	, currencyFormatter(node.data.ownerEmploymentInsurance)
            	, currencyFormatter(node.data.riderEmploymentInsurance)
            	, currencyFormatter(node.data.ownerIndustrialInsurance)
            	, currencyFormatter(node.data.riderIndustrialInsurance)
            	, currencyFormatter(node.data.withholdingTaxInsuranceSum)
            	, currencyFormatter(node.data.ownerEmploymentInsuranceAccounts)
            	, currencyFormatter(node.data.riderEmploymentInsuranceAccounts)
            	, currencyFormatter(node.data.sumEmploymentInsuranceAccounts)
            	, currencyFormatter(node.data.ownerIndustrialInsuranceAccounts)
            	, currencyFormatter(node.data.riderIndustrialInsuranceAccounts)
            	, currencyFormatter(node.data.sumIndustrialInsuranceAccounts)
            	, currencyFormatter(node.data.operatingCostAdd)
            	, currencyFormatter(node.data.accountsCost)
            	, currencyFormatter(node.data.incomeTax)
            	, currencyFormatter(node.data.residenceTax)
            	, currencyFormatter(node.data.withholdingTax)
            	, currencyFormatter(node.data.givePay)]);
        });


        $.each(grid1.getGridOption('pinnedBottomRowData')[0], function(index, item){
        	if(item == '합계')
        		sum1.push(item);
        	else
        		sum1.push(currencyFormatter(item));
        });
        rows1.push(sum1);

        // 첫 번째 행을 추가하여 헤더를 포함
        rows.unshift(['협력사아이디', '정산시작일', '정산종료일'
        	, '배달료(A-1)', '추가정산(A-2)', '관리비(B)', '운영비©', '부가세액(C)', '시간제보험료', '사업주부담고용보험료(1)', '라이더부담고용보험료(2)', '사업주부담산재보험료(3)', '라이더부담산재보험료(4)'
        	, '원천징수보험료합계(1+2+3+4)(D)', '고용보험소급정산(E)', '산재보험소급정산(F)', '정산예정금액(A+B-C)-시간제보험료-(D+E+F+G)', '세금계산서공급가액', '세금계산서부가세액', '세금계산서공급대가']);
        rows1.unshift(['NO', 'User ID', '라이더명', '처리건수', '배달료A'
        	, '추가지지급B', '총배달료C<br/>(A+B)', '시간제보험료', '필요경비', '보수액', '사업주부담<br/>고용보험료(1)', '라이더부담<br/>고용보험료(2)', '사업주부담<br/>산재보험료(3)'
        	, '라이더부담<br/>산재보험료(4)', '원천징수보험료 합계<br/>(1+2+3+4)(D)', '사업주부담 고용보험<br/>소급정산(5)', '라이더부담 고용보험<br/>소급정산(6)', '합계 고용보험<br/>소급정산(E)'
        	, '사업주부담 산재보험<br/>소급정산(7)', '라이더부담 산재보험<br/>소급정산(8)', '합계 산재보험<br/>소급정산(F)'
        	, '운영비(9)', '라이더별정산금액(G)<br/>C-(2+4+6+8+9)', '소득세(H)<br/>C*3%', '주민세(I)<br/>H*10%', '원천징수세액(J)<br/>(H+I)', '라이더별지급금액(K)<br/>(G-J)']);



        const ws = XLSX.utils.aoa_to_sheet(rows);
        const ws1 = XLSX.utils.aoa_to_sheet(rows1);

        // 모든 셀의 형식을 텍스트로 설정
        const range = XLSX.utils.decode_range(ws['!ref']);
        for (let R = range.s.r; R <= range.e.r; ++R) {
            for (let C = range.s.c; C <= range.e.c; ++C) {
                const cell_address = {c: C, r: R};
                const cell_ref = XLSX.utils.encode_cell(cell_address);
                if (!ws[cell_ref]) continue;
                //ws[cell_ref].t = 's';  // 셀 형식을 텍스트로 설정
            }
        }

        // 모든 셀의 형식을 텍스트로 설정
        const range1 = XLSX.utils.decode_range(ws1['!ref']);
        for (let R = range1.s.r; R <= range1.e.r; ++R) {
            for (let C = range1.s.c; C <= range1.e.c; ++C) {
                const cell_address = {c: C, r: R};
                const cell_ref = XLSX.utils.encode_cell(cell_address);
                if (!ws1[cell_ref]) continue;
                //ws1[cell_ref].t = 's';  // 셀 형식을 텍스트로 설정
            }
        }

        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
        XLSX.utils.book_append_sheet(wb, ws1, "Sheet2");
        XLSX.writeFile(wb, fileName);
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
		<p class="tit">협력사 주정산 조회</p>

			<input name="pageUnit" type="hidden" value="1000"/>
			<input name="pageSize" type="hidden" value="1000"/>
			<!--과제관리_목록 -->
			<div class="search_box ty2">
				<table>
					<colgroup>
						<col style="width: 13%">
						<col style="width: 17%">
						<col style="width: 13%">
						<col style="width: 13%">
						<col style="width: 13%">
						<col style="width: *">
					</colgroup>
					<tr>
						<th>정산일</th>
						<td>
							<input id="searchDate" class="form-control search fs-9" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
						</td>
						<th>파일명</th>
						<td colspan='3'>
							<select name='serchFileName' style='width: 100%' id='serchFileName'></select>
						</td>
					</tr>
				</table>

				<div class="btnwrap">
					<button class="btn btn-primary" onclick="downloadExcel();">엑셀 다운로드</button>
					<button id="loadDataBtn" class="btn ty1">조회</button>

				</div>

				<br/>
			<!-- grid  -->
			<br>
			<div id="loadingOverlay" style="display: none;">Loading...</div>
			<div  class="ib_product">
				<div id="myGrid" class="ag-theme-alpine" style="height: 150px; width: 100%;"></div>
			</div>


			<!-- grid  -->

			<br>
			<div  class="ib_product">
				<div id="myGrid1" class="ag-theme-alpine" style="height: 380px; width: 100%;"></div>
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