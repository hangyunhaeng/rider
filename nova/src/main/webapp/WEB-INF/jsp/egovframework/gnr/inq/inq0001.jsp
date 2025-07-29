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
	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		//페이징설정
		paging.createPaging('#paging', 1, pagePerCnt, serchList);
 		serchList((${inquiryVO.schIdx}==0)?1: ${inquiryVO.schIdx}, paging.objectCnt);
	});
	function 문의하기(inqId){
		$('#myForm').attr("action", "/gnr/inq0002.do");
		$('#myForm').append($("<input/>", {type:"hidden", name:"inqId", value:inqId}));
		$('#myForm').append($("<input/>", {type:"hidden", name:"schIdx", value:paging.pIdx}));
		$('#myForm').submit();
	}
	function serchList(schIdx, schPagePerCnt){
		    const params = new URLSearchParams();
			params.append("schIdx", schIdx);
			params.append("schPagePerCnt", schPagePerCnt);

			// 로딩 시작
	        $('.loading-wrap--js').show();
		    axios.post('${pageContext.request.contextPath}/gnr/inq0001_0001.do', params)
		        .then(response => {

		        	// 로딩 종료
		            $('.loading-wrap--js').hide();

		            if(chkLogOut(response.data)){
		            	return;
		            }

					if(response.data.resultCode == "success"){
						//보이는 내역 모두 삭제
						$('#반복부 > div :visible').remove();

						if(response.data.list == null || response.data.list.length == 0){

							$('#반복부').append(
							          '         <div class="d-flex hover-actions-trigger py-1 border-translucent border-top">                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                '
							         +'           <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer" data-bs-toggle="modal" data-bs-target="#exampleModal">                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     '
							         +'             <div class="col-12 col-md-auto col-xl-12 col-xxl-auto">                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  '
							         +'               <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '
							         +'               	<label class="form-check-label mb-md-0 mb-xl-1 mb-xxl-0 fs-8 me-2 text-body cursor-pointer my-4">조회된 내역이 없습니다.</label>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              '
							         +'               </div>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 '
									 +'			</div>'
							);
							return;
						}



						response.data.list.forEach(function(dataInfo, idx){
							if(dataInfo.upInqId == null){
								//질문원본
								var 내역 = $('#반복부').find('[repeatObj=true]:hidden:eq(0)').clone();
								$('#반복부').append(내역);
								내역.addClass(dataInfo.inqId);
								내역.find('div[data-bs-toggle=collapse]').attr("data-bs-target", ".collapseExample"+idx);
								내역.find('[name=inqId]').val(dataInfo.inqId);
								내역.find('p[class~=cursor-pointer]').text(dataInfo.title);
								내역.find('p[class~=text-body-tertiary]').text(dataInfo.creatDt);
								내역.find('div[class~=collapse]').addClass("collapseExample"+idx);
								내역.find('div[class~=collapse]').append(replaceRevN(dataInfo.longtxt));
								내역.show();

							} else {
								//답변
								$('.'+dataInfo.upInqId+'').find('[name=replayCnt]').text(Number($('.'+dataInfo.upInqId+'').find('[name=replayCnt]').text())+1);
								$('.'+dataInfo.upInqId+'').find('[name=replayCnt]').parent().show();


								var 내역 = $('#반복부').find('[repeatObj=true]:hidden:eq(1)').clone();
								$('.'+dataInfo.upInqId+'').find('.collapse').append(내역);
								내역.find('p[class~=cursor-pointer]').text(dataInfo.title);
								내역.find('p[class~=text-body-tertiary]').text(dataInfo.creatDt);
								내역.find('span:eq(0)').text(dataInfo.creatNm);
								내역.find('div[class~=text-body-tertiary]').html(replaceRevN(dataInfo.longtxt));
								내역.show();

							}

						});


						$('#반복부').find('img').attr("width", "100%");

			        	paging.setPageing(schIdx, response.data.cnt);

					}
		        })
		        .catch(error => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();
		            console.error('Error fetching data:', error);
		        });
	}
	function modifyInq(obj){

		문의하기($(obj).closest('.drawTable').find('[name=inqId]').val());
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
                  <div class="row justify-content-between align-items-center mb-4">
                    <div class="col-auto">
                      <h3 class="text-body-emphasis">1:1문의</h3>
                    </div>
                       <div class="col-auto d-flex">
                       	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="문의하기()">문의하기</button>
                       </div>



                  </div>
                </div>








                <div id="반복부" class="card-body py-0 scrollbar to-do-list-body">


					<!-- 조회내역 없음 -->
					<div repeatObj="no" class="d-flex hover-actions-trigger py-1 border-translucent border-top" style="display:none !important;">
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer" data-bs-toggle="modal" data-bs-target="#exampleModal">
							<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
								<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
									<label class="form-check-label mb-md-0 mb-xl-1 mb-xxl-0 fs-8 me-2 text-body cursor-pointer my-4">조회된 내역이 없습니다.</label>
								</div>
							</div>
						</div>
					</div>
					<!-- 조회내역 없음 -->

					<!-- 1:1문의 질문 start -->
					<div repeatObj="true" class="drawTable d-flex hover-actions-trigger py-3 border-translucent border-top" style="display:none !important;">
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer w-100">
							<div class="col-12">
								<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
									<div style="width: calc(100% - 55px);"class="col-auto" data-bs-toggle="collapse" data-bs-target="" aria-expanded="false">
									<input type="hidden" name="inqId" value="" />
									<p class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-8 me-2 text-body cursor-pointer"></p>
									</div>
									<div class="col-auto d-flex">
									<a class="fw-bold fs-9" href="#" onclick="modifyInq(this);">수정</a>
									</div>
								</div>


								<div class="col-12">
									<div class="d-flex lh-1 align-items-center">
									<p class="text-body-tertiary fs-10 mb-md-0 me-6  mb-0"></p>
									<span class="fs-9 mb-0" style="display:none;">답변 <em name="replayCnt" >0</em>건</span>
									</div>
								</div>

								<div class="collapse  py-2">
								</div>
							</div>
						</div>
					</div>
					<!-- 1:1문의 질문 end -->

					<!-- 1:1문의 답변 start -->
					<div repeatObj="true" class="card col-12 col-md-auto col-xl-12 col-xxl-auto mt-3" style="display:none !important;">
						<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
							<div class="col-auto gy-3">
								<p class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-8 me-2 text-body cursor-pointer ms-2"></p>
							</div>
						</div>
						<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
							<div class="d-flex lh-1 align-items-center">
								<p class="text-body-tertiary fs-10 mb-md-0 me-2 me-md-3 me-xl-2 me-xxl-3 mb-0 ms-2"></p>
								<span class="fs-9 mb-0" style=""></span>
							</div>
						</div>
						<div class="ms-2 text-body-tertiary fw-semibold py-2" style="">
						</div>
					</div>
					<!-- 1:1문의 답변 end -->

<!-- 								<div class="INQ_000000000000030 drawTable d-flex hover-actions-trigger py-3 border-translucent border-top"> -->
<!-- 									<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer"> -->
<!-- 										<div class="col-12 col-md-auto col-xl-12 col-xxl-auto"> -->
<!-- 											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1"> -->
<!-- 												<div class="col-auto" data-bs-toggle="collapse" -->
<!-- 													data-bs-target=".collapseExample0" aria-expanded="true"> -->
<!-- 													<input type="hidden" name="inqId" -->
<!-- 														value="INQ_000000000000030"> <label -->
<!-- 														class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-8 me-2 line-clamp-1 text-body cursor-pointer">엔터는?</label> -->
<!-- 												</div> -->
<!-- 												<div class="col-auto d-flex"> -->
<!-- 													<a class="fw-bold fs-9" href="#" onclick="modifyInq(this);">수정</a> -->
<!-- 												</div> -->
<!-- 											</div> -->
<!-- 											<div class="col-12 col-md-auto col-xl-12 col-xxl-auto"> -->
<!-- 												<div class="d-flex lh-1 align-items-center"> -->
<!-- 													<p -->
<!-- 														class="text-body-tertiary fs-10 mb-md-0 me-2 me-md-3 me-xl-2 me-xxl-3 mb-0">2025-05-21</p> -->
<!-- 													<span class="fs-9 mb-0" style="">답변 <em -->
<!-- 														name="replayCnt">4</em>건 -->
<!-- 													</span> -->
<!-- 												</div> -->
<!-- 											</div> -->
<!-- 											<div class="collapseExample0 collapse show" style=""> -->
<!-- 												내용<br>엔터<br>엔터<br> -->
<!-- 												<br>수정 -->




<!-- 										<div class="card col-12 col-md-auto col-xl-12 col-xxl-auto mt-3"> -->
<!-- 											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1"> -->
<!-- 												<div class="col-auto gy-4"> -->
<!-- 													<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-8 me-2 line-clamp-1 text-body cursor-pointer ms-2">답변 제목</label> -->
<!-- 												</div> -->
<!-- 											</div> -->
<!-- 											<div class="col-12 col-md-auto col-xl-12 col-xxl-auto"> -->
<!-- 												<div class="d-flex lh-1 align-items-center"> -->
<!-- 													<p class="text-body-tertiary fs-10 mb-md-0 me-2 me-md-3 me-xl-2 me-xxl-3 mb-0 ms-2">2025-05-21</p> -->
<!-- 													<span class="fs-9 mb-0" style="">답변자</span> -->
<!-- 												</div> -->
<!-- 											</div> -->
<!-- 											<div class="ms-2 text-body-tertiary fw-semibold" style="">내용</div> -->
<!-- 										</div> -->



											</div>
											<div id="paging" class="d-flex align-items-center justify-content-center mt-3"></div>

										</div>
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