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
	    axios.post('${pageContext.request.contextPath}/gnr/pay0002_001.do', params)
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
					$('#총금액').html(0+"원");


					if(response.data.list == null || response.data.list.length == 0){
						var 내역없음 = $('#customer-order-table-body').find('[repeatObj=no]:hidden').clone();
						$('#customer-order-table-body').append(내역없음);
						내역없음.show();
					} else{
						var 총배달비 = 0;
						response.data.list.forEach(function(dataInfo, idx){
							var 내역 = $('#customer-order-table-body').find('[repeatObj=true]:hidden').clone();
							$('#customer-order-table-body').append(내역);

							내역.find('.day').html(getStringDate(dataInfo.day));
							내역.find('.weekYn').html( nullToString(dataInfo.etcId)!='' ? (dataInfo.dwGubun=='DAY'? "대여<br/>선지급":"대여<br/>확정") : dataInfo.weekYn == "Y" ? "완료":"미정산");
							내역.find('.deliveryCnt').html(currencyFormatter(dataInfo.deliveryCnt));
							내역.find('.deliveryPrice').html(currencyFormatter(dataInfo.deliveryPrice));
							내역.find('.ablePrice').html(currencyFormatter(dataInfo.ablePrice));
							내역.show();
							총배달비 += Number(dataInfo.deliveryPrice, 10);
						});

						$('#총금액').html(currencyFormatter(총배달비)+"원");
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
                      <h3 class="text-body-emphasis">배달 정보 조회</h3>
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
                      <div class="row align-items-center g-0 justify-content-between border-bottom">
                      	<div class="col-auto mb-2 d-flex">
                          <p class="mb-0 ms-sm-3 fs-9 text-body-tertiary fw-bold">
<!--                           <svg class="svg-inline--fa fa-filter me-1 fw-extra-bold fs-10" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="filter" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M3.9 54.9C10.5 40.9 24.5 32 40 32H472c15.5 0 29.5 8.9 36.1 22.9s4.6 30.5-5.2 42.5L320 320.9V448c0 12.1-6.8 23.2-17.7 28.6s-23.8 4.3-33.5-3l-64-48c-8.1-6-12.8-15.5-12.8-25.6V320.9L9 97.3C-.7 85.4-2.8 68.8 3.9 54.9z"></path></svg> -->
                          <font _mstmutation="1">배달비 총액</font></p>
                      	</div>
                      	<div class="col-auto mb-2 d-flex">
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
                          <th class="white-space-nowrap align-middle ps-0 pe-0 py-3"" scope="col" data-sort="order" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="9666644" _msthash="429">배달일</th>
                          <th class="white-space-nowrap align-middle text-center pe-0 py-3"" scope="col" data-sort="total" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="9571315" _msthash="430">구분</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">건수</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3"" scope="col" data-sort="payment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="22057685" _msthash="431">배달비</th>
                          <th class="white-space-nowrap align-middle white-space-nowrap pe-0 py-3" scope="col" data-sort="fulfilment_status" style="text-align:center;background-color:#0f1d33;color:white;" _msttexthash="37371139" _msthash="432">선지급<br/>가능금</th>
                        </tr>
                      </thead>
                      <tbody class="list" id="customer-order-table-body">

                        <tr repeatObj="true" class="hover-actions-trigger btn-reveal-trigger position-static" style="display:none;">
                          <td class="white-space-nowrap order align-middle ps-0 py-3 day">2025-05-05</td>
                          <td class="white-space-nowrap total align-middle text-center fw-semibold pe-0 text-body-highlight py-3 weekYn" _msttexthash="11490804" _msthash="436">완료</td>
                          <td class="white-space-nowrap total align-middle fw-bold text-body-highlight text-end py-3 deliveryCnt">0</td>
                          <td class="white-space-nowrap total align-middle fw-bold text-body-highlight text-end py-3 deliveryPrice">1,522,555</td>
                          <td class="white-space-nowrap total align-middle fw-bold text-body-highlight text-end py-3 ablePrice">1,522,555</td>
                        </tr>

                        <tr repeatObj="no" class="hover-actions-trigger btn-reveal-trigger position-static" style="display:none;">
                          <td class="order align-middle white-space-nowrap ps-0 py-3 text-center" colspan="5">조회된 내역이 없습니다</td>
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