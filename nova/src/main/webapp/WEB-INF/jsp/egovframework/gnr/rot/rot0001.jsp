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
		$('#dayAblePrice').html(currencyFormatter(${ablePrice.dayAblePrice})+"원");
		$('#weekAblePrice').html(currencyFormatter(${ablePrice.weekAblePrice})+"원");

		//라이더 사용여부에 따라 출금 불가 처리
		if('${ablePrice.useAt}' == 'Y'){
			$('.card').find('button').attr('disabled', false);
		} else {
			$('.card').find('button').attr('disabled', true);
		}


		//공지사항
		공지사항();
		대출();

		//다중협력사
		var cooperatorList = JSON.parse('${cooperatorList}');
	    populateSelectOptions('cooperatorId', cooperatorList.resultList, "${cooperatorId}");

	    if($('#cooperatorId').find('option').length > 1){
	    	$('#다중협력사').show();
	    }


		$("#cooperatorId").on("change", function(e) {
			loadAblePrice();
		});

		var selectCoopId = getCookie('cooperatorId');
		if(selectCoopId != undefined){
			if($('#cooperatorId').find('[value='+selectCoopId+']').length > 0){
				$("#cooperatorId").val(selectCoopId);
				loadAblePrice();
			}
		}
	});

	function 공지사항(){

	    var gongjiList = JSON.parse('${gongjiList}'.replace(/\r/gi, '\\r').replace(/\n/gi, '\\n').replace(/\t/gi, '\\t').replace(/\f/gi, '\\f'));
		var gongjiCnt = 0;
		var gongjiCookie = "";
		if(gongjiList != null && gongjiList.resultList != null){

			gongjiList.resultList.forEach(function(dataInfo, idx){

				if(getCookie("notId") == undefined || getCookie("notId") == 'undefined'){
					gongjiCnt++;						//읽지 않은 공지
				}else if( getCookie("notId").indexOf(dataInfo.notId) < 0){
					gongjiCnt++;						//읽지 않은 공지
				} else {
					gongjiCookie += "^"+dataInfo.notId;	//읽은 공지
				}

			});
		}
		var date = new Date();
		date.setDate(date.getDate() + 14);
		date = date.toUTCString();
		document.cookie = "notId = "+gongjiCookie+"; path=/; expires=" + date;
		$('#공지건수').html(gongjiCnt);
		if(gongjiCnt > 0){
			$('#div공지사항').show();
		}
	}
	function 대출(){
		if(${requestCnt} > 0){
			$('#div대출').show();
		}
	}

	//페이지 이동
	function go선출금() {
		$('#myForm').attr("action", "${pageContext.request.contextPath}/gnr/rot0003.do");
		$('#myForm').append($("<input/>", {type:"hidden", name:"gubun", value:"DAY"}));
		$('#myForm').submit();
	}

	//페이지 이동
	function go출금() {
		$('#myForm').attr("action", "${pageContext.request.contextPath}/gnr/rot0003.do");
		$('#myForm').append($("<input/>", {type:"hidden", name:"gubun", value:"WEK"}));
		$('#myForm').submit();
	}
	function loadAblePrice(){

	    const params = new URLSearchParams();
	    params.append("searchCooperatorId", $('#cooperatorId').val());


	    $('#div대출').hide();
		// 로딩 시작
        $('.loading-wrap--js').show();
	    axios.post('${pageContext.request.contextPath}/gnr/rot0001_0002.do', params)
	        .then(response => {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	            if(chkLogOut(response.data)){
	            	return;
	            }

				if(response.data.resultCode == "success"){

					$('#dayAblePrice').html(currencyFormatter(response.data.ablePrice.dayAblePrice)+"원");
					$('#weekAblePrice').html(currencyFormatter(response.data.ablePrice.weekAblePrice)+"원");
					if(response.data.ablePrice.useAt == 'Y'){
						$('.card').find('button').attr('disabled', false);
					} else {
						$('.card').find('button').attr('disabled', true);
					}

					document.cookie = "cooperatorId = "+$('#cooperatorId').val();

					if(response.data.requestCnt > 0)$('#div대출').show();

				} else {
					if(response.data.resultMsg != '' && response.data.resultMsg != null)
						alert(response.data.resultMsg);
					else alert("실패하였습니다");
					return ;
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
            <div class="col-12">

				  <div id="div공지사항" class="card shadow-none border mb-3" data-component-card="data-component-card" style="display:none;">
		            <div class="card-header p-4 bg-body">
		              <div class="row g-3 justify-content-between align-items-end">
		                <div class="col-12 col-md">
		                  <h4 class="text-body mb-0" data-anchor="data-anchor" id="example"><font _mstmutation="1" _msttexthash="14650168" _msthash="400">공지사항</font><a class="anchorjs-link " aria-label="닻" data-anchorjs-icon="#" href="#example" style="margin-left: 0.1875em; padding-right: 0.1875em; padding-left: 0.1875em;" _mstaria-label="76115" _msthash="399"></a></h4>
		                  <p class="mb-0 mt-2 text-body-secondary" _msttexthash="621365329" _msthash="401">최근 2주간 등록된 공지사항 중<br/>읽지 않은 공지사항 <sm id="공지건수">4</sm>건</p>
		                </div>
		                <div class="col col-md-auto">
		                  <nav class="nav justify-content-end doc-tab-nav align-items-center" role="tablist">
		                  <a class="btn btn-sm btn-phoenix-primary code-btn ms-2 collapsed" role="button" href="${pageContext.request.contextPath}/gnr/not0001.do">
		                  <font _mstmutation="1" _msttexthash="21101600" _msthash="402">공지사항</font></a>
		                  </nav>
		                </div>
		              </div>
		            </div>
		          </div>

              <div id="다중협력사" class="card mb-3" style="display:none;">
                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-2">
                    <div class="col-auto">
                      <h3 class="text-body-emphasis">협력사</h3>
                    </div>
                       <div class="col-auto d-flex">
<!--                        	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="go선출금();">입금</button> -->
                       </div>
                  </div>
                </div>



                <div class="card-body py-0 scrollbar to-do-list-body">


								<div class="d-flex hover-actions-trigger py-3 border-translucent border-top">
									<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer">
										<div class="col-12">

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto w-100">
													<select id="cooperatorId" class="form-select"></select>
												</div>
											</div>

<!-- 											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1"> -->
<!-- 												<div class="col-auto"> -->
<!-- 													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer"></label> -->
<!-- 												</div> -->
<!-- 												<div class="col-auto d-flex"> -->
<!-- 													<span id="dayAblePrice" class="fs-9 mb-2" style="">원</span> -->
<!-- 												</div> -->
<!-- 											</div> -->

										</div>
									</div>
								</div>

							</div>
            </div>


				  <div id="div대출" class="card shadow-none border mb-3" data-component-card="data-component-card" style="display:none;">
		            <div class="card-header p-4 bg-body">
		              <div class="row g-3 justify-content-between align-items-end">
		                <div class="col-12 col-md">
		                  <h4 class="text-body mb-0" data-anchor="data-anchor" id="example"><font _mstmutation="1" _msttexthash="14650168" _msthash="400">대여</font><a class="anchorjs-link " aria-label="닻" data-anchorjs-icon="#" href="#example" style="margin-left: 0.1875em; padding-right: 0.1875em; padding-left: 0.1875em;" _mstaria-label="76115" _msthash="399"></a></h4>
		                  <p class="mb-0 mt-2 text-body-secondary" _msttexthash="621365329" _msthash="401">대여, 리스 승인요청이 있습니다</p>
		                </div>
		                <div class="col col-md-auto">
		                  <nav class="nav justify-content-end doc-tab-nav align-items-center" role="tablist">
		                  <a class="btn btn-sm btn-phoenix-primary code-btn ms-2 collapsed" role="button" href="${pageContext.request.contextPath}/gnr/pay0004.do">
		                  <font _mstmutation="1" _msttexthash="21101600" _msthash="402">대여,리스</font></a>
		                  </nav>
		                </div>
		              </div>
		            </div>
		          </div>

              <div class="card mb-3">
                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-2">
                    <div class="col-auto">
                      <h3 class="text-body-emphasis">선지급 배달비</h3>
                    </div>
                       <div class="col-auto d-flex">
                       	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="go선출금();">입금</button>
                       </div>
                  </div>
                </div>



                <div class="card-body py-0 scrollbar to-do-list-body">


								<div class="d-flex hover-actions-trigger py-3 border-translucent border-top">
									<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer">
										<div class="col-12">

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">선지급수수료1.1% & 보험료 반영</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style=""></span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer"></label>
												</div>
												<div class="col-auto d-flex">
													<span id="dayAblePrice" class="fs-9 mb-2" style="">원</span>
												</div>
											</div>

										</div>
									</div>
								</div>

							</div>
            </div>






              <div class="card mb-3">
                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-2">
                    <div class="col-auto">
                      <h3 class="text-body-emphasis">확정 배달비</h3>
                    </div>
                       <div class="col-auto d-flex">
                       	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="go출금()">입금</button>
                       </div>
                  </div>
                </div>



                <div class="card-body py-0 scrollbar to-do-list-body">


								<div class="d-flex hover-actions-trigger py-3 border-translucent border-top">
									<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer">
										<div class="col-12">

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<span class="fs-9 mb-2" style=""><label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">보험료 반영</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style=""></span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer"></label>
												</div>
												<div class="col-auto d-flex">
													<span id="weekAblePrice" class="fs-9 mb-2" style="">원</span>
												</div>
											</div>

										</div>
									</div>
								</div>

							</div>
            </div>

<!-- 				<div class="row justify-content-between"> -->
<!-- 					<div class="col-auto"></div> -->
<!--                        <div class="col-auto d-flex"> -->
<!--                        	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="go출금()">입금</button> -->
<!--                        </div> -->
<!--                 </div> -->

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