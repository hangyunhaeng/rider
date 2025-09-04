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

	//onLoad
	document.addEventListener('DOMContentLoaded', function() {
		var today = new Date();
		var now = new Date();
		var towWeekAgo = new Date(now.setDate(now.getDate()-14));

		var fromRunDe = flatpickr("#fromRunDe", {
			locale: "ko",
			allowInput: false,
		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
		    dateFormat: 'Y-m-d',     // date format 형식
		    disableMobile: true          // 모바일 지원

		});
		fromRunDe.setDate(towWeekAgo.getFullYear()+"-"+(towWeekAgo.getMonth()+1)+"-"+towWeekAgo.getDate());

		var toRunDe = flatpickr("#toRunDe", {
			locale: "ko",
			allowInput: false,
		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
		    dateFormat: 'Y-m-d',     // date format 형식
		    disableMobile: true          // 모바일 지원
		});
		toRunDe.setDate(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());
		//리스트 검색
		serchList();
	});


	function serchList(){
	    const params = new URLSearchParams();
	    var regex = /[^0-9]/g;
	    params.append('searchFromDate', $($('#fromRunDe')[0]).val().replace(regex, ""));
	    params.append('searchToDate', $($('#toRunDe')[0]).val().replace(regex, ""));

	    if(!limit2Week($($('#fromRunDe')[0]).val(), $($('#toRunDe')[0]).val())){
	    	return;
	    }


		// 로딩 시작
        $('.loading-wrap--js').show();
	    axios.post('${pageContext.request.contextPath}/gnr/pay0005_001.do', params)
	        .then(response => {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	            if(chkLogOut(response.data)){
	            	return;
	            }

				if(response.data.resultCode == "success"){

					//$('#customer-order-table-body').find('tr:hidden')
					//보이는 tr 모두 삭제
					$('#customer-order-table-body').find('tr:visible').remove();
// 					$('#총금액').html(0+"원");


					if(response.data.list == null || response.data.list.length == 0){
						var 내역없음 = $('#customer-order-table-body').find('[repeatObj=no]:hidden').clone();
						$('#customer-order-table-body').append(내역없음);
						내역없음.show();
					} else{
						var 총배달비 = 0;
						response.data.list.forEach(function(dataInfo, idx){
							var 내역 = $('#customer-order-table-body').find('[repeatObj=true]:hidden').clone();
							$('#customer-order-table-body').append(내역);

							내역.find('.accountsStDt').html(getStringDate(dataInfo.accountsStDt));
							내역.find('.accountsEdDt').html(getStringDate(dataInfo.accountsEdDt));
							내역.find('.cnt').html(dataInfo.cnt);
							내역.find('.deliveryCost').html(currencyFormatter(dataInfo.deliveryCost));
							내역.find('.addCost').html(currencyFormatter(dataInfo.addCost));
							내역.find('.sumCost').html(currencyFormatter(dataInfo.sumCost));

							내역.find('.timeInsurance').html(currencyFormatter(dataInfo.timeInsurance));
							내역.find('.necessaryExpenses').html(currencyFormatter(dataInfo.necessaryExpenses));
							내역.find('.pay').html(currencyFormatter(dataInfo.pay));

							내역.find('.ownerEmploymentInsurance').html(currencyFormatter(dataInfo.ownerEmploymentInsurance));
							내역.find('.riderEmploymentInsurance').html(currencyFormatter(dataInfo.riderEmploymentInsurance));
							내역.find('.ownerIndustrialInsurance').html(currencyFormatter(dataInfo.ownerIndustrialInsurance));
							내역.find('.riderIndustrialInsurance').html(currencyFormatter(dataInfo.riderIndustrialInsurance));
							내역.find('.withholdingTaxInsuranceSum').html(currencyFormatter(dataInfo.riderIndustrialInsurance));

							내역.find('.ownerEmploymentInsuranceAccounts').html(currencyFormatter(dataInfo.ownerEmploymentInsuranceAccounts));
							내역.find('.riderEmploymentInsuranceAccounts').html(currencyFormatter(dataInfo.riderEmploymentInsuranceAccounts));
							내역.find('.sumEmploymentInsuranceAccounts').html(currencyFormatter(dataInfo.sumEmploymentInsuranceAccounts));
							내역.find('.ownerIndustrialInsuranceAccounts').html(currencyFormatter(dataInfo.ownerIndustrialInsuranceAccounts));
							내역.find('.riderIndustrialInsuranceAccounts').html(currencyFormatter(dataInfo.riderIndustrialInsuranceAccounts));
							내역.find('.sumIndustrialInsuranceAccounts').html(currencyFormatter(dataInfo.sumIndustrialInsuranceAccounts));

							내역.find('.operatingCostAdd').html(currencyFormatter(dataInfo.operatingCostAdd));

							//라이더별 정산금액
							내역.find('.accountsCost').html(currencyFormatter(dataInfo.accountsCost));


							내역.find('.incomeTax').html(currencyFormatter(dataInfo.incomeTax));
							내역.find('.residenceTax').html(currencyFormatter(dataInfo.residenceTax));
							내역.find('.withholdingTax').html(currencyFormatter(dataInfo.withholdingTax));
							내역.find('.givePay').html(currencyFormatter(dataInfo.givePay));


							내역.find('.sendPriceCost').html(currencyFormatter(dataInfo.sendPriceCost));
							내역.find('.dayFeeCost').html(currencyFormatter(dataInfo.dayFeeCost));
							내역.find('.sendFeeCost').html(currencyFormatter(dataInfo.sendFeeCost));
							내역.find('.etcPriceCost').html(currencyFormatter(dataInfo.etcPriceCost));
							내역.find('.subsum0').html(currencyFormatter(dataInfo.sendPriceCost+dataInfo.dayFeeCost+dataInfo.sendFeeCost+dataInfo.etcPriceCost));


// 							내역.find('.givePay').html(currencyFormatter(dataInfo.givePay));
// 							내역.find('.callFeeCost').html(currencyFormatter(dataInfo.callFeeCost));
// 							내역.find('.programFeeCost').html(currencyFormatter(dataInfo.programFeeCost));
// 							내역.find('.subsum1').html(currencyFormatter(dataInfo.givePay-dataInfo.callFeeCost-dataInfo.programFeeCost));

// 							내역.find('.tmpAblePrice').html(currencyFormatter(dataInfo.tmpAblePrice));
							내역.find('.creatDt').html(getStringDate(dataInfo.creatDt));
							내역.show();
// 							총배달비 += Number(dataInfo.ablePrice, 10);
// 							총배달비 -= Number(dataInfo.sendPrice, 10);
						});

// 						if(총배달비 < 0)총배달비 = 0;
// 						$('#총금액').html(currencyFormatter(총배달비)+"원");
					}

				}

	        })
	        .catch(error => {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
	            console.error('Error fetching data:', error);
	        });
	}
	</script>

<body>

      <div class="loading-wrap loading-wrap--js" style="display: none;z-index:10000;">
        <div class="loading-spinner loading-spinner--js"></div>
        <p id="loadingMessage">로딩중</p>
      </div>

  <jsp:include page="../inc/nav.jsp" />


<main class="main" id="top">
	<div class="content">
<div class="mx-lg-n4 mt-3">
          <div class="row g-3">
            <div class="col-12 col-xxl-7">
              <div class="card h-100">


                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-2">
                    <div class="col-auto">
                      <h3 class="text-body-emphasis">확정 정보 조회</h3>
                    </div>
<!--                        <div class="col-auto d-flex"> -->
<!--                        	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="go선출금();">입금</button> -->
<!--                        </div> -->
                  </div>
                </div>

                <div class="card-body py-0 px-2 scrollbar to-do-list-body">
                <div class="d-flex hover-actions-trigger py-3 border-translucent border-top">
                  <div class="justify-content-between align-items-center mb-0 w-100">
                    <div class="col-auto w-100">
                      <div class="row align-items-center g-0 justify-content-between pb-md-3">
                        <div class="col-12 col-sm-auto">
                          <div class="search-box w-100 mb-2 mb-sm-0 d-flex" style="max-width:30rem;">
                           	<input id="fromRunDe" class="form-control search fs-9" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
                           	<label class="mx-2 py-2">~</label>
                           	<input id="toRunDe" class="form-control search fs-9" type="search" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
                          </div>

                        </div>
                        <div class="col-auto mb-2 d-flex w-25">
                        </div>
                        <div class="col-auto d-flex">
                        	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="serchList();">조회</button>
                        </div>
                      </div>
                      <div class="row align-items-center g-0 justify-content-between border-bottom" >
                      	<div class="col-auto mb-2 d-flex">
                          <p class="mb-0 ms-sm-3 fs-10 text-body-tertiary fw-bold">
                          <font _mstmutation="1">*출금금액은 선지급금액과 기타수수료납부 합계입니다.</font></p>
                      	</div>
                      	<div class="col-auto mb-2 d-flex" style="display:none !important;">
                      		<font class="p-0 ms-3 fs-9 text-primary fw-bold" id="총금액" _mstmutation="1">0원</font>
                      	</div>
                      </div>
                    </div>
                  </div>
                </div>







                <div class="py-3 scrollbar">

				<div class="border-top border-bottom border-translucent" id="customerOrdersTable" data-list="{&quot;valueNames&quot;:[&quot;order&quot;,&quot;total&quot;,&quot;payment_status&quot;,&quot;fulfilment_status&quot;,&quot;delivery_type&quot;,&quot;date&quot;],&quot;page&quot;:6,&quot;pagination&quot;:true}">
                  <div class="table-responsive scrollbar">
                    <table class="table table-sm fs-9 mb-0">
                      <thead>

                        <tr>
                          <th rowspan='2' class="white-space-nowrap align-middle ps-0 pe-0 py-3"" scope="col" data-sort="order" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="9666644" _msthash="429">시작일</th>
                          <th rowspan='2' class="white-space-nowrap align-middle text-center pe-0 py-3"" scope="col" data-sort="total" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="9571315" _msthash="430">종료일</th>
                          <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">처리건</th>
                          <th colspan='3' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">배달료</th>
                          <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">시간제보험료<br/>(D)</th>
                          <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">필요경비</th>
                          <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">보수액</th>
                          <th colspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">고용보험료</th>
                          <th colspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">산재보험료</th>
                          <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">보험료합계<br/>(E)<br/>(①+②+③+④)</th>
                          <th colspan='3' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">고용보험<br/>소급정산</th>
                          <th colspan='3' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">산재보험<br/>소급정산</th>
                          <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">운영비<br/>⑨</th>
                          <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">라이더별정산금액<br/>(H)<br/>C-D-(②+④+⑥+⑧)</th>
                          <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">소득세<br/>(I)<br/>(C×3%)</th>
                          <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">주민세<br/>(J)<br/>(H×10%)</th>
                          <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">원천징수세액<br/>(K)<br/>(H+I)</th>
                          <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431">라이더별<br/>지급금액<br/>(L) (H-K)</th>
                          <th colspan='5' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="22057685" _msthash="431" >출금금액</th>
<!--                           <th colspan='4' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;border-right-width:1px;" _msttexthash="37371139" _msthash="432" >확정금액</th> -->
<!--                           <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="37371139" _msthash="432">출금가능금액<br/>(B-A)</th> -->
                          <th rowspan='2' class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3" scope="col" data-sort="fulfilment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="37371139" _msthash="432">등록일</th>
                        </tr>
                        <tr>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">배달료<br/>A</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">추가지급<br/>B</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white; border-right-width:1px;" _msttexthash="22057685" _msthash="431">총배달료<br/>C(A+B)</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">사업주부담<br/>①</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white; border-right-width:1px;" _msttexthash="22057685" _msthash="431">라이더부담<br/>②</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">사업주부담<br/>③</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white; border-right-width:1px;" _msttexthash="22057685" _msthash="431">라이더부담<br/>④</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">사업주<br/>⑤</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">라이더<br/>⑥</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white; border-right-width:1px;" _msttexthash="22057685" _msthash="431">합계<br/>(F)</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">사업주<br/>⑦</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">라이더<br/>⑧</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white; border-right-width:1px;" _msttexthash="22057685" _msthash="431">합계<br/>(G)</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">선지급금<br/>(a)</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">선지급수수료<br/>(b)</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">이체수수료<br/>(c)</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">기타수수료<br/>(d)</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white; border-right-width:1px;" _msttexthash="22057685" _msthash="431">소계(A)<br/>(a+b+c+e)</th>
<!--                           <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="37371139" _msthash="432">확정금액<br/>(e)</th> -->
<!--                           <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="37371139" _msthash="432">콜수수료<br/>(f)</th> -->
<!--                           <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="37371139" _msthash="432">프로그램료<br/>(g)</th> -->
<!--                           <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white; border-right-width:1px;" _msttexthash="37371139" _msthash="432">소계(B)<br/>(e-f-g)</th> -->

                        </tr>
                      </thead>
                      <tbody class="list" id="customer-order-table-body">

                        <tr repeatObj="true" class="hover-actions-trigger btn-reveal-trigger position-static" style="display:none;">
                          <td class="white-space-nowrap order align-middle pe-1 ps-3 py-3 accountsStDt">2025-05-05</td>
                          <td class="white-space-nowrap total align-middle text-center pe-1 text-body-highlight py-3 accountsEdDt">2025-05-05</td>
                          <td class="white-space-nowrap total align-middle text-center pe-1 text-body-highlight py-3 cnt">2025-05-05</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 deliveryCost">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 addCost">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 sumCost">0</td>

                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 timeInsurance">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 necessaryExpenses">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 pay">0</td>


                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 ownerEmploymentInsurance">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 riderEmploymentInsurance">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 ownerIndustrialInsurance">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 riderIndustrialInsurance">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 withholdingTaxInsuranceSum">0</td>


                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 ownerEmploymentInsuranceAccounts">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 riderEmploymentInsuranceAccounts">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 sumEmploymentInsuranceAccounts">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 ownerIndustrialInsuranceAccounts">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 riderIndustrialInsuranceAccounts">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 sumIndustrialInsuranceAccounts">0</td>


                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 operatingCostAdd">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 accountsCost">0</td>

                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 incomeTax">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 residenceTax">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 withholdingTax">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 givePay">0</td>


                          <td class="white-space-nowrap total align-middle pe-1 text-body-highlight text-end py-3 sendPriceCost">0</td>
                          <td class="white-space-nowrap total align-middle pe-1 text-body-highlight text-end py-3 dayFeeCost">0</td>
                          <td class="white-space-nowrap total align-middle pe-1 text-body-highlight text-end py-3 sendFeeCost">0</td>
                          <td class="white-space-nowrap total align-middle pe-1 text-body-highlight text-end py-3 etcPriceCost">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 subsum0">0</td>


<!--                           <td class="white-space-nowrap total align-middle pe-1 text-body-highlight text-end py-3 givePay">0</td> -->
<!--                           <td class="white-space-nowrap total align-middle pe-1 text-body-highlight text-end py-3 callFeeCost">0</td> -->
<!--                           <td class="white-space-nowrap total align-middle pe-1 text-body-highlight text-end py-3 programFeeCost">0</td> -->
<!--                           <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 subsum1">0</td> -->


<!--                           <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 ablePrice">1,522,555</td> -->
<!--                           <td class="white-space-nowrap total align-middle fw-bold pe-1 text-body-highlight text-end py-3 tmpAblePrice">1,522,555</td> -->
                          <td class="white-space-nowrap total align-middle pe-1 text-end py-3 creatDt">1,522,555</td>
                        </tr>

                        <tr repeatObj="no" class="hover-actions-trigger btn-reveal-trigger position-static" style="display:none;">
                          <td class="order align-middle white-space-nowrap ps-0 py-3 text-center" colspan="14">조회된 내역이 없습니다</td>
                        </tr>

                        </tbody>
                    </table>
                  </div>
                </div>
				  <!-- 반복부 end -->



                </div>


              </div>
            </div>
          </div>
        </div>


	</div>
	</div>
</main>



  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>



  <!-- Vendor JS Files -->
<%--   <script src="<c:url value='/vendor/admin/bootstrap/js/bootstrap.bundle.min.js' />"></script> --%>
  <script src="<c:url value='/vendor/admin/php-email-form/validate.js' />"></script>
  <script src="<c:url value='/vendor/admin/aos/aos.js' />"></script>
  <script src="<c:url value='/vendor/admin/purecounter/purecounter_vanilla.js' />"></script>
  <script src="<c:url value='/vendor/admin/glightbox/js/glightbox.min.js' />"></script>
  <script src="<c:url value='/vendor/admin/swiper/swiper-bundle.min.js' />"></script>

  <!-- Main JS File -->
  <script src="<c:url value='/js/admin/main.js' />"></script>

</body>
</html>