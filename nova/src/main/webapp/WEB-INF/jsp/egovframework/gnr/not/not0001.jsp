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

		//리스트 검색
 		serchList();
	});


	function serchList(){
	    const params = new URLSearchParams();

		// 로딩 시작
        $('.loading-wrap--js').show();
	    axios.post('${pageContext.request.contextPath}/gnr/not0001_0001.do', params)
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
						var 내역없음 = $('#반복부').find('[repeatObj=no]:hidden').clone();
						$('#반복부').append(내역없음);
						내역없음.show();
						return;
					}

					response.data.list.forEach(function(dataInfo, idx){
						var 내역 = $('#반복부').find('[repeatObj=true]:hidden').clone();
						$('#반복부').append(내역);
						내역.find('div[data-bs-toggle=collapse]').attr("data-bs-target", ".collapseExample"+idx);
						내역.find('[name=notId]').val(dataInfo.notId);
						내역.find('span[class~=tag-badge-tag-phoenix]').addClass("tag-badge-tag-phoenix-"+(dataInfo.authorCode == "ROLE_ADMIN" ? "warning" : "success"));
						내역.find('span[class~=tag-badge-tag-phoenix]').text(dataInfo.authorCodeNm);
						내역.find('label[class~=cursor-pointer]').text(dataInfo.title);
						내역.find('p:eq(0)').text(dataInfo.creatDt);
						내역.find('p:eq(1)').text(dataInfo.creatNm);
						내역.find('div[class~=collapse]').addClass("collapseExample"+idx);
						내역.find('div[class~=collapse]').append(replaceRevTag(dataInfo.longtxt));
						내역.show();

					});

					$('#반복부').find('img').attr("width", "100%");

				}
	        })
	        .catch(error => {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
	            console.error('Error fetching data:', error);
	        });
	}

	function veiwNoti(obj){
		if(getCookie("notId") == undefined || getCookie("notId").indexOf($(obj).find('input[name="notId"]').val()) < 0){

			var date = new Date();
			date.setDate(date.getDate() + 14);
			date = date.toUTCString();
			document.cookie = "notId = "+getCookie("notId")+"^"+$(obj).find('input[name="notId"]').val()+"; path=/; expires=" + date;
		}

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
                      <h3 class="text-body-emphasis">공지사항</h3>
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

					<!-- 반복부 시작 -->
					<div repeatObj="true" class="d-flex hover-actions-trigger py-3 border-translucent border-top" style="display:none !important;">
						<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer" data-bs-toggle="collapse" data-bs-target="" aria-expanded="false" onclick="veiwNoti(this)">
							<input type="hidden" name="notId" value="" />
								<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
									<div class="mb-1 mb-md-0 d-flex align-items-center lh-1">
										<span class="tag-badge-tag tag-badge-tag-phoenix fs-10 mb-0 me-2"></span>
										<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-8 me-2 line-clamp-1 text-body cursor-pointer"></label>
									</div>
								</div>
								<div class="col-12 col-md-auto col-xl-12 col-xxl-auto">
									<div class="d-flex lh-1 align-items-center">
										<p class="text-body-tertiary fs-10 mb-md-0 me-2 me-md-3 me-xl-2 me-xxl-3 mb-0"></p>
										<div class="hover-md-hide hover-xl-show hover-xxl-hide">
											<p class="text-body-tertiary fs-10 fw-bold mb-md-0 mb-0 ps-md-3 ps-xl-0 ps-xxl-3 border-start-md border-xl-0 border-start-xxl"></p>
										</div>
									</div>
								</div>

							<div class="collapse">
							</div>
						</div>
					</div>
					<!-- 반복부 종료 -->

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