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

	var sendFee = ${sendFee};
	//onLoad
	document.addEventListener('DOMContentLoaded', function() {
		if("${myInfoVOData.gubun}" == "DAY"){
			$('#divDay').show();
			$('#divdDayFee').show();		//선지긊 수수료
			$('#title').html("선지급 배달비 입금");
			$('#선정산메뉴').addClass("active");
			$('#ablePrice').html(currencyFormatter(minWon0(${ablePrice.dayAblePrice})));

		}
		if("${myInfoVOData.gubun}" == "WEK"){
			$('#divWek').show();
			$('#title').html("확정 배달비 입금");
			$('#확정메뉴').addClass("active");
			$('#ablePrice').html(currencyFormatter(minWon0(${ablePrice.weekAblePrice})));
		}
		if('${ablePrice.useAt}' == 'Y'){
			$('.mx-lg-n4').find('button').attr('disabled', false);
			$('.mx-lg-n4').find('input').attr('disabled', false);
		} else {
			$('.mx-lg-n4').find('button').attr('disabled', true);
			$('.mx-lg-n4').find('input').attr('disabled', true);
		}

		$('#dayAblePrice').html(currencyFormatter(minWon0(${ablePrice.dayAblePrice}))+"원");
		$('#weekAblePrice').html(currencyFormatter(minWon0(${ablePrice.weekAblePrice}))+"원");
		$('#sendFee').html(currencyFormatter(sendFee));
		$("#dayPrice").on("propertychange change keyup paste input", function(e) {
			calPrice();
		});


		$("#weekPrice").on("propertychange change keyup paste input", function(e) {
			calPrice();
		});

		calPrice();
	});

	function onInputVal(obj, maxInt){

		//빈값이면 0으로
		if(obj.value == "") obj.value = 0;
		//모두 숫자로 변환
		obj.value = obj.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');
		maxInt = String(maxInt).replace(/[^0-9-]/g, '').replace(/(\..*)\./g, '$1');
		maxInt = minWon0(maxInt);	//-는 없음

		//최대값보다 큰값이 들어오면 최대값으로 변환
		if(typeof(maxInt) != 'undefined'){
			if(parseInt(obj.value, 10)> parseInt(maxInt, 10)){
				obj.value = maxInt;
			}
		}

		//콤마 붙여서 리턴
		obj.value = currencyFormatter(parseInt(obj.value, 10));
	}
	function calPrice(){
		var dayPrice = $("#dayPrice").val().replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');
		var weekPrice = $("#weekPrice").val().replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');
		var sumPrice = parseInt(dayPrice, 10) + parseInt(weekPrice, 10);	//출금신청금액
		var inputPrice = parseInt(dayPrice, 10) + parseInt(weekPrice, 10) + parseInt(sendFee, 10);//차감 금액
		$('#sumPrice').html(currencyFormatter(sumPrice));
		$('#inputPrice').html(currencyFormatter(inputPrice));


		//선지급수수료
		if("${myInfoVOData.gubun}" == "DAY"){
			$('#dayFee').html(currencyFormatter(Math.ceil((dayPrice*${fee.feeAdminstrator}).toFixed(5))));
		}
	}

    window.name="Parent_window";

    function fnPopup(){
        window.open('', 'popupChk', 'width=480, height=812, top=100, fullscreen=no, menubar=no, status=no, toolbar=no,titlebar=yes, location=no, scrollbar=no');
        document.form_chk.action = "https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb";
        document.form_chk.target = "popupChk";
        document.form_chk.submit();
    }

    function preAct(){

	    const params = new URLSearchParams();
	    axios.post('${pageContext.request.contextPath}/gnr/rot0003_0000.do', params)
	        .then(response => {
	            $('.loading-wrap--js').hide();
				if(response.data.resultCode == "success"){
					goAct();
				} else {
					if(response.data.resultMsg != '' && response.data.resultMsg != null)
						alert(response.data.resultMsg);
					else alert("입금 실패하였습니다");
					return ;
				}
	        })
	        .catch(error => {
	            $('.loading-wrap--js').hide();
	            console.error('Error fetching data:', error);
	        });
    }

	function goAct(){

		if("${myInfoVO.mbtlnum}" == "null" || "${myInfoVO.mbtlnum}".trim() == '' ){
			alert('핸드폰번호가가 등록되어있지 않습니다.\n상위업체에  정보등록 후 사용하기 바랍니다');
			return;
		}

		if("${myInfoVO.accountNum}" == null || "${myInfoVO.accountNum}".trim() == '' ){
			if(confirm('계좌가 등록되어있지 않습니다.\n내정보관리 메뉴에서 계좌등록을 하셔야 합니다.\n\n계좌등록화면으로 이동하시겠습니까?')){
				$('#myForm').attr("action", "${pageContext.request.contextPath}/gnr/rot0002.do");
				$('#myForm').submit();
				return;
			}
			return;
		}

// 		if(Number($('#inputPrice').html().replace(/[^0-9]-/g, '').replace(/(\..*)\./g, '$1'), 10) <= 0){
// 			alert('출금금액이 이체 수수료보다 커야 합니다.');

// 			if("${myInfoVOData.gubun}" == "DAY")
// 				$('#dayPrice').focus();
// 			if("${myInfoVOData.gubun}" == "WEK")
// 				$('#weekPrice').focus();

// 			return;
// 		}

		if("${myInfoVOData.gubun}" == "DAY"){
			if(Number($('#dayPrice').val().replace(/[^0-9]-/g, '').replace(/(\..*)\./g, '$1'), 10) <= 0){
				alert('입금금액을 입력하세요');
				$('#dayPrice').focus();
				return;
			}
		}
		if("${myInfoVOData.gubun}" == "WEK"){
			if(Number($('#weekPrice').val().replace(/[^0-9]-/g, '').replace(/(\..*)\./g, '$1'), 10) <= 0){
				alert('입금금액을 입력하세요');
				$('#weekPrice').focus();
				return;
			}
		}


		if(confirm("입금하시겠습니까?")){

			if(${doNice} != true){
				goActStep2();
				return;
			}


			// 로딩 시작
	        $('.loading-wrap--js').show();
			var formData = new FormData();


		    const params = new URLSearchParams();
		    axios.post('${pageContext.request.contextPath}/com/com0010_0000.do', params)
		        .then(response => {
		            $('.loading-wrap--js').hide();
					if(response.data.resultCode == "success"){
						document.form_chk.token_version_id.value = response.data.token_version_id;
						document.form_chk.enc_data.value = response.data.enc_data;
						document.form_chk.integrity_value.value = response.data.integrity;

						fnPopup();
					} else {
						if(response.data.resultMsg != '' && response.data.resultMsg != null)
							alert(response.data.resultMsg);
						else alert("기본정보 저장에 실패하였습니다");
						return ;
					}
		        })
		        .catch(error => {
		            $('.loading-wrap--js').hide();
		            console.error('Error fetching data:', error);
		        });

		}
	}
	function goActStep2(){

		    const params = new URLSearchParams();

		    var url;
		    if("${myInfoVOData.gubun}" == "DAY"){
		    	url = '${pageContext.request.contextPath}/gnr/rot0003_0001.do';
			    params.append("inputPrice", $('#dayPrice').val().replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1'));
		    }
		    if("${myInfoVOData.gubun}" == "WEK"){
		    	url = '${pageContext.request.contextPath}/gnr/rot0003_0002.do';
			    params.append("inputPrice", $('#weekPrice').val().replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1'));
		    }
			// 로딩 시작
	        $('.loading-wrap--js').show();
		    axios.post(url, params)
		        .then(response => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();

		            if(chkLogOut(response.data)){
		            	return;
		            }

					if(response.data.resultCode == "success"){
						goResult();
					} else{
						if(response.data.resultMsg != '' && response.data.resultMsg != null)
							alert(response.data.resultMsg);
						else alert("입금에 실패하였습니다");
						return ;
					}
		        })
		        .catch(error => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();
		            console.error('Error fetching data:', error);
		        });

	}
	function goResult(){
		$('#myForm').attr("action", "${pageContext.request.contextPath}/gnr/pay0003.do");
		$('#myForm').submit();
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
            <div class="col-12">

              <div class="card mb-3">
<!-- 							<div class="card-header border-bottom-0 pb-0"> -->
<!-- 								<div class="row justify-content-between align-items-center mb-2"> -->
<!-- 									<div class="col-auto"> -->
<!-- 										<h3 class="text-body-emphasis">입금</h3> -->
<!-- 									</div> -->
<!-- 									                       <div class="col-auto d-flex"> -->
<!-- 									                       	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="$('.collapseExample1').collapse('hide');" data-bs-toggle="collapse" data-bs-target=".collapseExample0" aria-expanded="false">변경</button> -->
<!-- 									                       </div> -->
<!-- 								</div> -->
<!-- 							</div> -->


                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-2">
                    <div class="col-auto">
                      <h3 id="title" class="text-body-emphasis">입금</h3>
                    </div>
                  </div>
                </div>

							<div class="card-body py-0 scrollbar to-do-list-body">


								<div class="d-flex hover-actions-trigger py-3 border-translucent">
									<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer">
										<div class="col-12">


							<div id="divDay" class="d-flex hover-actions-trigger py-2 border-translucent position-relative" style="display:none !important;">
								<div class="col-12">
									<div class="form-floating">
									<input id="dayPrice" class="form-control" id="1" type="text" maxlength="15" oninput="onInputVal(this, ${ablePrice.dayAblePrice-sendFee});" placeholder="선지급가능금액" value="0"><label for="floatingInputZipcode">선지급가능금액<em id="dayAblePrice" style="color:red;"> 0원</em></label>
									</div>
								</div>
							</div>


							<div id="divWek" class="d-flex hover-actions-trigger py-2 border-translucent position-relative" style="display:none !important;">
								<div class="col-12">
									<div class="form-floating">
									<input id="weekPrice" class="form-control" id="2" type="text" maxlength="15" oninput="onInputVal(this, ${ablePrice.weekAblePrice-sendFee});" placeholder="정산완료입금가능금액" value="0"><label for="floatingInputZipcode">정산완료입금가능금액<em id="weekAblePrice" style="color:red;"> 0원</em></label>
									</div>
								</div>
							</div>




											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1  border-top pt-3">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer"> - 지급가능금액</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style=""></span>
												</div>
											</div>




											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">지급가능금액</label>
												</div>
												<div class="col-auto d-flex">
													<span id="ablePrice" class="fs-9 mb-2" style="color:red;">300</span><span class="fs-9 mb-2" style="">원</span>
												</div>
											</div>




											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1  border-top pt-3">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer"> - 입금 내역</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style=""></span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">계좌 입금 금액</label>
												</div>
												<div class="col-auto d-flex">
													<span id="sumPrice" class="fs-9 mb-2" style="">100</span><span class="fs-9 mb-2" style="">원</span>
												</div>
											</div>

<!-- 											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1"> -->
<!-- 												<div class="col-auto"> -->
<!-- 													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">선지급 수수료</label> -->
<!-- 												</div> -->
<!-- 												<div class="col-auto d-flex"> -->
<!-- 													<span id="dayFee" class="fs-9 mb-2" style="">500</span><span class="fs-9 mb-2" style="">원</span> -->
<!-- 												</div> -->
<!-- 											</div> -->

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">계좌 이체 수수료</label>
												</div>
												<div class="col-auto d-flex">
													<span id="sendFee" class="fs-9 mb-2" style="">300</span><span class="fs-9 mb-2" style="">원</span>
												</div>
											</div>

											<div id="divdDayFee" class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1" style="display:none !important;">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">선지급 수수료</label>
												</div>
												<div class="col-auto d-flex">
													<span id="dayFee" class="fs-9 mb-2" style="">0</span><span class="fs-9 mb-2" style="">원</span>
												</div>
											</div>



											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1" style="display:none !important;">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">차감액</label>
												</div>
												<div class="col-auto d-flex">
													<span id="inputPrice" class="fs-9 mb-2" style="">300</span><span class="fs-9 mb-2" style="">원</span>
												</div>
											</div>




											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1  border-top pt-3">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer"> - 입금 계좌 정보</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style=""></span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">은행</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style="">${myInfoVO.bnkNm}</span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">계좌번호</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style="">${myInfoVO.accountNum}</span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">예금주</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style="">${myInfoVO.accountNm}</span>
												</div>
											</div>

										</div>
									</div>
								</div>

							</div>
            </div>







				<div class="row justify-content-between">
					<div class="col-auto"></div>
                       <div class="col-auto d-flex">
                       	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="preAct();" >입금하기</button>
                       </div>
                </div>

          </div>
         </div>
       </div>

	</div>
</main>



  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>


	<!-- 숨겨진 폼 -->
	<form id="myForm" action="" method="POST"style="display: none;">
	</form>


    <form name="form_chk" method="post">
        <input type="hidden" name="m" value="service"/>
        <input type="hidden" name="token_version_id"/>
        <input type="hidden" name="enc_data"/>
        <input type="hidden" name="integrity_value"/>
    </form>


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