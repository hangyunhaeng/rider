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

    const maxLength0 = 50;
    const maxLength1 = 500;
	//onLoad
	document.addEventListener('DOMContentLoaded', function() {
		if("${one.inqId}" != ""){
			$('#삭제버튼').show();
		}
		$('#title').parent().find('label').text("제목("+$('#title').val().length+"/"+maxLength0+")");
		$('#longtxt').parent().find('label').text("문의내용("+$('#longtxt').val().length+"/"+maxLength1+")");

        const enforceLength0 = (event) => {
            const value = event.target.value;
            if (value.length > maxLength0) {
                event.target.value = value.slice(0, maxLength0);
            }
            $('#title').parent().find('label').text("제목("+$('#title').val().length+"/"+maxLength0+")");
        };

        const enforceLength1 = (event) => {
            const value = event.target.value;
            if (value.length > maxLength1) {
                event.target.value = value.slice(0, maxLength1);
            }
            $('#longtxt').parent().find('label').text("문의내용("+$('#longtxt').val().length+"/"+maxLength1+")");
        };

        document.querySelector("#title").addEventListener("input", enforceLength0);
        document.querySelector("#longtxt").addEventListener("input", enforceLength1);

	});
	function 저장(){
	    const params = new URLSearchParams();

	    params.append("inqId", $('#inqId').val());
	    params.append("title", $('#title').val());
	    params.append("longtxt", $('#longtxt').val());
	    params.append("useAt", 'Y');

		// 로딩 시작
        $('.loading-wrap--js').show();
	    axios.post('${pageContext.request.contextPath}/gnr/inq0002_0001.do', params)
	        .then(response => {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	            if(chkLogOut(response.data)){
	            	return;
	            }

				if(response.data.resultCode == "success"){
					alert("저장되었습니다");
					goList();
				}
	        })
	        .catch(error => {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
	            console.error('Error fetching data:', error);
	        });

	}
	function goList(){
		$('#myForm').attr("action", "/gnr/inq0001.do");
		$('#myForm').append($("<input/>", {type:"hidden", name:"schIdx", value:${inquiryVO.schIdx}}));
		$('#myForm').submit();
	}
	function 삭제(){
		if(confirm("삭제하시겠습니까?")){
		    const params = new URLSearchParams();

		    params.append("inqId", $('#inqId').val());

			// 로딩 시작
	        $('.loading-wrap--js').show();
		    axios.post('${pageContext.request.contextPath}/gnr/inq0002_0002.do', params)
		        .then(response => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();

		            if(chkLogOut(response.data)){
		            	return;
		            }

					if(response.data.resultCode == "success"){
						goList();
					}
		        })
		        .catch(error => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();
		            console.error('Error fetching data:', error);
		        });

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
                      <h3 class="text-body-emphasis">1:1문의</h3>
                    </div>
                       <div class="col-auto d-flex">
                       	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="저장()">저장</button>
                       	<button id="삭제버튼"class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" style="display:none;" type="submit" onclick="삭제()">삭제</button>
                       </div>



                  </div>
                </div>





	<div id="반복부" class="card-body py-0 scrollbar to-do-list-body">
		<div class="d-flex hover-actions-trigger py-3 border-translucent border-top position-relative">
			<div class="col-12">
				<div class="form-floating">
				<input id="inqId" type="hidden" value="${one.inqId}"/>
				<input class="form-control" id="title" type="text" placeholder="제목" value="${one.title}"><label for="floatingInputZipcode">제목</label>
				</div>
			</div>
		</div>
		<div class="d-flex hover-actions-trigger py-3 border-translucent border-top position-relative">
			<div class="col-12">
				<div class="form-floating"><textarea class="form-control" id="longtxt" placeholder="문의내용" style="height: 228px">${one.longtxt}</textarea><label for="floatingProjectOverview">문의내용</label></div>
			</div>
		</div>
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