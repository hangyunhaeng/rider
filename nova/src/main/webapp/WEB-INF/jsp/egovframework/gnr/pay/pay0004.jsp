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

	var pagePerCnt = 10;
	var nowPage;
	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		//페이징설정
		paging.createPaging('#paging', 1, pagePerCnt, serchList);
 		serchList((${etcVO.schIdx}==0)?1: ${etcVO.schIdx}, paging.objectCnt);
	});
	function serchList(schIdx, schPagePerCnt){

		nowPage = schIdx;
	    const params = new URLSearchParams();
		params.append("schIdx", schIdx);
		params.append("schPagePerCnt", schPagePerCnt);

		// 로딩 시작
        $('.loading-wrap--js').show();
	    axios.post('${pageContext.request.contextPath}/gnr/pay0004_001.do', params)
	        .then(response => {

	        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	            if(chkLogOut(response.data)){
	            	return;
	            }

				if(response.data.resultCode == "success"){
					draw(response, schIdx);
				}
	        })
	        .catch(error => {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
	            console.error('Error fetching data:', error);
	        });
	}
	function 승인(obj){

	    const params = new URLSearchParams();
		params.append("schIdx", nowPage);
		params.append("schPagePerCnt", paging.objectCnt);
		params.append("etcId", $(obj).closest('.card').find('input[name=etcId]').val());

		// 로딩 시작
        $('.loading-wrap--js').show();
	    axios.post('${pageContext.request.contextPath}/gnr/pay0004_002.do', params)
	        .then(response => {

	        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	            if(chkLogOut(response.data)){
	            	return;
	            }

				if(response.data.resultCode == "success"){
					draw(response, nowPage);

				} else {
					if(response.data.resultMsg != '' && response.data.resultMsg != null)
						alert(response.data.resultMsg);
					else alert("승인에 실패하였습니다");
					return ;
				}
	        })
	        .catch(error => {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
	            console.error('Error fetching data:', error);
	        });

	}

	function draw(response, schIdx){

		//보이는 내역 모두 삭제
		$('#반복부').find('div:visible').remove();

		if(response.data.list == null || response.data.list.length == 0){
			debugger;
			var 내역없음 = $('#반복부').find('[repeatObj=no]:hidden').clone();
			$('#반복부').append(내역없음);
			내역없음.show();
			return;
		}


		response.data.list.forEach(function(dataInfo, idx){

			var 내역 = $('#반복부').find('[repeatObj=true]:hidden:eq(0)').clone();
			$('#반복부').append(내역);
			내역.find('input[name=etcId]').val(dataInfo.etcId);
			내역.find('h3[class~=text-body-emphasis]').html(dataInfo.gubun == "D" ? "대여" :dataInfo.gubun == "R" ? "리스" :"기타" );
			if(nullToString(dataInfo.authRequestDt) != null && nullToString(dataInfo.authResponsDt) == ''){
				내역.find('button').show();
			} else{
				if(dataInfo.finishAt == 'Y'){
					내역.find('label:eq(0)').html("정산종료");
				} else {
					내역.find('label:eq(0)').html("진행중");
				}
				내역.find('label:eq(0)').show();
			}
			내역.find('label[class~=form-check-label]:eq(1)').html(dataInfo.paybackDay+'일동안 '+currencyFormatter(dataInfo.paybackCost)+'원 출금');
			내역.find('label[class~=text-body-tertiary]').html(getStringDate(dataInfo.authRequestDt));
			내역.find('span[class~=총금액]').html('입금 '+currencyFormatter(dataInfo.finishCost)+'원 / 총 '+currencyFormatter(dataInfo.paybackCostAll)+'원');

			내역.find('div[data-bs-toggle=collapse]').attr("data-bs-target", ".collapseExample"+dataInfo.etcId);
			내역.find('div[class~=collapse]:eq(0)').addClass("collapseExample"+dataInfo.etcId);
			//대출 입금이력 붙일 div세팅
			내역.find('.card').addClass(dataInfo.etcId);
			내역.show();

			$('#paging').show();

		});


    	paging.setPageing(schIdx, response.data.cnt);
	}
	function 리스트(obj){

		if($('#반복부 .' + $(obj).closest('.card').find('[name=etcId]').val()).children().length > 0){
// 			alert('닫는다');
			setTimeout(function(){
				$('#반복부 .'+$(obj).closest('.card').find('[name=etcId]').val()).children().remove();
			}, 500);
			return false;
		}
// 		if($('.collapseExample'+$(obj).closest('.card').find('[name=etcId]').val()).attr('class').indexOf('show') >= 0){
// 			alert('리턴')
// 			return false;
// 		}

// 		debugger;
		$('.collapseExample'+$(obj).closest('.card').find('[name=etcId]').val()).collapse('hide');
	    const params = new URLSearchParams();
		params.append("etcId", $(obj).closest('.card').find('[name=etcId]').val());


		//내역삭제
		$('#반복부 .'+$(obj).closest('.card').find('[name=etcId]').val()).children().remove();
// 		$('#반복부 .'+$(obj).closest('.card').find('[name=etcId]').val()).hide();
		// 로딩 시작
        $('.loading-wrap--js').show();
	    axios.post('${pageContext.request.contextPath}/gnr/pay0004_003.do', params)
	        .then(response => {

	        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	            if(chkLogOut(response.data)){
	            	return;
	            }

				if(response.data.resultCode == "success"){

					var a = "";
					response.data.list.forEach(function(dataInfo, idx){
						var 내역 = $('#반복부').find('[repeatObj=true]:hidden:eq(1)').clone();
						내역.find('p:eq(0)').html(getStringDate(dataInfo.day));
						내역.find('p:eq(1)').html(currencyFormatter(dataInfo.sendPrice));
						내역.find('p:eq(2)').html(dataInfo.rnum+'회차');
						$('#반복부').find('.'+dataInfo.etcId).append(내역);
						$('#반복부').find('.'+dataInfo.etcId).show();
						내역.show();
// 						a = dataInfo.etcId;
					});
// 					$('.collapseExample'+a).collapse('show');

				} else {
					if(response.data.resultMsg != '' && response.data.resultMsg != null)
						alert(response.data.resultMsg);
					else alert("조회에 실패하였습니다");
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
            <div class="col-12" id="반복부">

			<!-- 조회내역 없음 -->
            <div repeatObj="no" class="card h-100" style="display:none;">
                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-4">
                    <div class="col-auto">
                      <h3 class="text-body-emphasis">대여.리스</h3>
                    </div>

                  </div>
                </div>
					<div class="d-flex hover-actions-trigger py-1 border-translucent border-top" style="">
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer" data-bs-toggle="modal" data-bs-target="#exampleModal">
							<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1 justify-content-center">
									<label class="form-check-label mb-md-0 mb-xl-1 mb-xxl-0 fs-8 me-2 text-body cursor-pointer my-4">조회된 내역이 없습니다.</label>
								</div>
							</div>
						</div>
					</div>
			</div>
			<!-- 조회내역 없음 -->

			<!-- 대여.리스 start -->
              <div repeatObj="true" class="card mb-3" style="display:none;">
                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-2">
                    <div class="col-auto">
                    	<input type="hidden" name="etcId" />
                      <h3 class="text-body-emphasis">대여</h3>
                    </div>
                       <div class="col-auto d-flex">
                       		<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="승인(this);" style="display:none;">승인</button>
							<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer" style="display:none;">진행중</label>
                       </div>
                  </div>
                </div>


                <div class="card-body py-0 scrollbar to-do-list-body">
					<div class="d-flex hover-actions-trigger py-3 border-translucent border-top">
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer">
							<div class="col-12">

								<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
									<div class="col-auto" data-bs-toggle="collapse" data-bs-target="" aria-expanded="false" onclick="리스트(this);">
										<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer" >30일간 10,000원 출금</label>
									</div>
									<div class="col-auto d-flex">
										<span class="fs-9 mb-2" style=""></span>
									</div>
								</div>

								<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
									<div class="col-auto d-flex">
										<label class="text-body-tertiary fs-10 mb-md-0 me-4  mb-0">2025-07-01</label>
									</div>
									<div class="col-auto d-flex">
										<span class="fs-9 mb-1 총금액" style="">입금 5,000원 / 총 30,000원</span>
									</div>
								</div>

							</div>
						</div>
					</div>

					<!-- 대출입금리스트 여기 하단에 붙여야함 -->
					<div class="collapse py-2">
						<div class="collapse card col-12 col-md-auto col-xl-12 col-xxl-auto pt-2 mb-3 px-2" style="display:none !important;">
						</div>
					</div>


				</div>

            </div>
			<!-- 대여.리스 end -->


			<!-- 대출 입금 리스트 start -->
			<div repeatObj="true" class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1" style="display:none !important;">
				<div class="col-auto">
					<p class="fs-9 mb-1">2025-07-14</p>
				</div>
				<div class="col-auto">
					<p class="fs-9 mb-1">30,000원</p>
				</div>
				<div class="col-auto">
					<p class="fs-9 mb-1">2회차</p>
				</div>
			</div>
			<!-- 대출 입금 리스트 end -->


          </div>
		<!-- 페이징 -->
		<div id="paging" class="d-flex align-items-center justify-content-center mt-3" style="display:none !important;"></div>
         </div>
       </div>

	</div>
</main>




  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
	<form id="myForm" action="" method="POST" style="display: none;"></form>


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