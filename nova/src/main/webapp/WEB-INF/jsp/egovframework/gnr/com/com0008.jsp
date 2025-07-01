<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
<title><spring:message code="comUatUia.title" /></title><!-- 로그인 -->
<meta http-equiv="content-type" content="text/html; charset=utf-8" >
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta name="description" content="">
<meta name="keywords" content="">

<!-- Favicons -->

<!-- Fonts -->
<link href="https://fonts.googleapis.com" rel="preconnect">
<link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">

<!-- Vendor CSS Files -->
<link href="<c:url value='/vendor/admin/bootstrap/css/bootstrap.min.css' />" rel="stylesheet">
<link href="<c:url value='/vendor/admin/bootstrap-icons/bootstrap-icons.css' />" rel="stylesheet">
<link href="<c:url value='/vendor/admin/aos/aos.css' />" rel="stylesheet">
<link href="<c:url value='/vendor/admin/fontawesome-free/css/all.min.css' />" rel="stylesheet">
<link href="<c:url value='/vendor/admin/glightbox/css/glightbox.min.css' />" rel="stylesheet">
<link href="<c:url value='/vendor/admin/swiper/swiper-bundle.min.css' />" rel="stylesheet">

<!-- Main CSS File -->
<link href="<c:url value='/css/admin/main.css' />" rel="stylesheet">

<%-- <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/com/com.css' />"> --%>
<%-- <link type="text/css" rel="stylesheet" href="<c:url value='/css/egovframework/com/uat/uia/login.css' />"> --%>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/showModalDialog.js'/>" ></script>
<script type="text/javascript" src="<c:url value='/js/egovframework/com/cmm/jquery.js'/>" ></script>
<%-- <link type="text/css" rel="stylesheet" href="<c:url value='/web2/css/keit.default.css' /> "> --%>
<%-- <link type="text/css" rel="stylesheet" href="<c:url value='/web2/css/keit.style.css' />" > --%>
<script type="text/javascript" src="<c:url value='/web2/js/jquery-1.11.2.min.js' />" ></script>
<script type="text/javascript" src="<c:url value='/web2/js/function.js' />"></script>
<script type="text/javascript" src="<c:url value='/web2/js/keit.jquery.ui.js' />" ></script>
<script type="text/javascript" src="<c:url value='/web2/js/kaia.pbCommon.js' />" ></script>

<script src="<c:url value='/js/axios.min.js' />"></script>

</head>
	<script type="text/javaScript">

	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		$("#조회버튼").on("click", function(e){

			if ($("#mberId").val() == "") {
		        alert("<spring:message code="comUatUia.validate.idCheck" />"); <%-- 아이디를 입력하세요 --%>
		        return;
		    }

		      document.querySelector('.php-email-form .loading').classList.add('d-block');
		      document.querySelector('.php-email-form .error-message').classList.remove('d-block');
		      document.querySelector('.php-email-form .sent-message').classList.remove('d-block');

		    // 폼 데이터를 생성
			    const params = new URLSearchParams();
			    params.append('mberId', document.getElementById('mberId').value);

			    axios.post('${pageContext.request.contextPath}/com/com0008_0001.do', params)
			        .then(response => {

						if(response.data.resultCode.indexOf("fail") >= 0){
							showErrorMessege(response.data.resultMessage);
						}

						if(response.data.resultCode == "failReg"){
							$("#메인버튼").show();
						}

						if(response.data.resultCode == "success"){
							location.replace("${pageContext.request.contextPath}/com/com0009.do");
						}
			        })
			        .catch(error => {
			            console.error('Error fetching data:', error);
			        });

		});
	});


	function showErrorMessege(msg){

	    document.querySelector('.php-email-form .loading').classList.remove('d-block');
	    document.querySelector('.php-email-form .error-message').innerHTML = msg;
	    document.querySelector('.php-email-form .error-message').classList.add('d-block');
	}
	function 메인으로이동(){
		location.replace("${pageContext.request.contextPath}/indexGnr.jsp");
	}
	</script>
<body onLoad="" style="" class="contact-page">



  <header id="header" class="header d-flex align-items-center fixed-top">
    <div class="container-fluid container-xl position-relative d-flex align-items-center">

      <a href="${pageContext.request.contextPath}/indexGnr.jsp" class="logo d-flex align-items-center me-auto">
        <!-- Uncomment the line below if you also wish to use an image logo -->
        <!-- <img src="assets/img/logo.png" alt=""> -->
        <h1 class="sitename">RIDER BANK</h1>
      </a>

      <nav id="navmenu" class="navmenu" style="display:none;">
        <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
      </nav>

<!--       <a class="btn-getstarted" href="get-a-quote.html">Get a Quote</a> -->

    </div>
  </header>

  <main class="main">

    <!-- Page Title -->
    <div class="page-title dark-background" data-aos="fade" style="">
      <div class="container position-relative">
        <h1>비밀번호 변경</h1>
        <p>아이디를 조회 하세요</p>
      </div>
    </div><!-- End Page Title -->

    <!-- Contact Section -->
    <section id="contact" class="contact section">

      <div class="container" data-aos="fade-up" data-aos-delay="100">

        <div class="row gy-4">

          <div class="col-lg-8">
            <div name="조회폼" id="조회폼" action="" method="post" class="php-email-form" data-aos="fade-up" data-aos-delay="200">
              <div class="row gy-4">

                <div class="col-md-6">
                  <input type="text" id="mberId" name="mberId" class="form-control" placeholder="배달의민족 ID" required="">
                </div>

                <div class="col-md-12 text-center">
                  <div class="loading">Loading</div>
                  <div class="error-message"></div>
                  <div class="sent-message">Your message has been sent. Thank you!</div>

                  <button id="조회버튼" type="submit" onclick="javascript:조회();">조회</button>
                  <button id="메인버튼" type="submit" style="display:none;" onclick="javascript:메인으로이동();">메인으로</button>
                </div>

              </div>
            </form>
          </div><!-- End Contact Form -->

        </div>

      </div>

    </section><!-- /Contact Section -->

  </main>


  <footer id="footer" class="footer dark-background">

    <div class="container footer-top">
      <div class="row gy-4">

        <div class="col-md-12 footer-contact text-center text-md-start">
          <h4>Contact Us</h4>
          <p>(15012) 경기도 시흥시 서울대학로 5-20 807호  다온플랜(주)</p>
          <p>고객센터 주소 : 경기도 시흥시 서울대학로 5-20 807호  다온플랜(주) 고객센터 Tel : 1833-5364</p>
          <p class="mt-4"><strong>대표:</strong> <span>류세현 </span></p>
          <p><strong>사업자등록번호:</strong> <span>355-87-03378 </span></p>
          <p><strong>Email:</strong> <span>k2wild@naver.com</span></p>
        </div>

      </div>
    </div>

    <div class="container copyright text-center mt-4">
      <p>© <span>Copyright</span> <strong class="px-1 sitename">Daon Information Service,</strong> <span> All rights reserved.</span></p>
      <div class="credits">
      </div>
    </div>

  </footer>


  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>



  <!-- Vendor JS Files -->
  <script src="<c:url value='/vendor/admin/bootstrap/js/bootstrap.bundle.min.js' />"></script>
<!--   <script src="/vendor/admin/php-email-form/validate.js"></script> -->
  <script src="<c:url value='/vendor/admin/aos/aos.js' />"></script>
  <script src="<c:url value='/vendor/admin/purecounter/purecounter_vanilla.js' />"></script>
  <script src="<c:url value='/vendor/admin/glightbox/js/glightbox.min.js' />"></script>
  <script src="<c:url value='/vendor/admin/swiper/swiper-bundle.min.js' />"></script>

  <!-- Main JS File -->
  <script src="<c:url value='/js/admin/main.js' />"></script>


	<!-- 팝업 폼 -->
	<form name="defaultForm" action ="" method="post" target="_blank">
	<div style="visibility:hidden;display:none;">
	<input name="iptSubmit3" type="submit" value="<spring:message code="comUatUia.loginForm.submit"/>" title="<spring:message code="comUatUia.loginForm.submit"/>">
	</div>
	</form>

</body>

</html>