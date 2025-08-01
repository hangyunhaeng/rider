<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
 /**
  * @Class Name : EgovLoginUsr.jsp
  * @Description : Login 인증 화면
  * @Modification Information
  *
  * @수정일               수정자            수정내용
  *  ----------   --------   ---------------------------
  *  2024.07.22   조경규            최초 생성
  *
  *  @author 조경규
  *  @since 2024.07.22
  *  @version 1.0
  *  @see
  *
  *  Copyright (C) 2009 by MOPAS  All right reserved.
  */
%>

<!DOCTYPE html>
<html>
<head>
<title></title><!-- 로그인 -->
<meta http-equiv="content-type" content="text/html; charset=utf-8" >
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta name="description" content="">
<meta name="keywords" content="">

<!-- Favicons -->
<link rel="apple-touch-icon" sizes="57x57" href="<c:url value='/images/fav/apple-icon-57x57.png' />">
<link rel="apple-touch-icon" sizes="60x60" href="<c:url value='/images/fav/apple-icon-60x60.png' />">
<link rel="apple-touch-icon" sizes="72x72" href="<c:url value='/images/fav/apple-icon-72x72.png' />">
<link rel="apple-touch-icon" sizes="76x76" href="<c:url value='/images/fav/apple-icon-76x76.png' />">
<link rel="apple-touch-icon" sizes="114x114" href="<c:url value='/images/fav/apple-icon-114x114.png' />">
<link rel="apple-touch-icon" sizes="120x120" href="<c:url value='/images/fav/apple-icon-120x120.png' />">
<link rel="apple-touch-icon" sizes="144x144" href="<c:url value='/images/fav/apple-icon-144x144.png' />">
<link rel="apple-touch-icon" sizes="152x152" href="<c:url value='/images/fav/apple-icon-152x152.png' />">
<link rel="apple-touch-icon" sizes="180x180" href="<c:url value='/images/fav/apple-icon-180x180.png' />">
<link rel="icon" type="image/png" sizes="192x192"  href="<c:url value='/images/fav/android-icon-192x192.png' />">
<link rel="icon" type="image/png" sizes="32x32" href="<c:url value='/images/fav/favicon-32x32.png' />">
<link rel="icon" type="image/png" sizes="96x96" href="<c:url value='/images/fav/favicon-96x96.png' />">
<link rel="icon" type="image/png" sizes="16x16" href="<c:url value='/images/fav/favicon-16x16.png' />">
<link rel="manifest" href="<c:url value='/images/fav/manifest.json' />">
<meta name="msapplication-TileColor" content="#ffffff">
<meta name="msapplication-TileImage" content="<c:url value='/images/fav/ms-icon-144x144.png' />">
<meta name="theme-color" content="#ffffff">

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
<script type="text/javaScript">
//onLoad
document.addEventListener('DOMContentLoaded', function() {
	if('${loginMessage}'.trim() != ''){
		alert('${loginMessage}');
	}
});
function 로그인() {

	if ($('#Id').val() =="") {
        alert("<spring:message code="comUatUia.validate.idCheck" />"); <%-- 아이디를 입력하세요 --%>
    } else if ($('#Pin').val() =="") {
        alert("<spring:message code="comUatUia.validate.passCheck" />"); <%-- 비밀번호를 입력하세요 --%>
    } else {


		$('#myForm').attr("action", "<c:url value='/com/com0004.do'/>");
		$('#myForm').append($("<input/>", {type:"hidden", name:"id", value:$('#Id').val()}));
		$('#myForm').append($("<input/>", {type:"hidden", name:"password", value:$('#Pin').val()}));
		$('#myForm').append($("<input/>", {type:"hidden", name:"userSe", value:"GNR"}));
		$('#myForm').submit();
    }
}



function 라이더등록페이지이동(){
// 	document.loginForm.action="<c:url value='/com/com0006.do'/>";
//     document.loginForm.submit();
	location.replace("<c:url value='/com/com0006.do'/>");
}
function 비밀번호찾기페이지이동(){
	location.replace("<c:url value='/com/com0008.do'/>");
}

</script>
</head>
<body style="" class="index-page">

	<!-- javascript warning tag  -->
	<noscript class="noScriptTitle">
		<spring:message code="common.noScriptTitle.msg" />
	</noscript>


  <header id="header" class="header d-flex align-items-center fixed-top">
    <div class="container-fluid container-xl position-relative d-flex align-items-center" style="padding-top:30px;">

      <a href="${pageContext.request.contextPath}/indexGnr.jsp" class="logo d-flex align-items-center me-auto">
        <!-- Uncomment the line below if you also wish to use an image logo -->
        <!-- <img src="/images/admin/logo.png" alt=""> -->
        <h1 class="sitename">RIDER BANK</h1>
      </a>

      <nav id="navmenu" class="navmenu" style="display:none;">
        <ul>
          <li></li>
        </ul>
        <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
      </nav>

    </div>
  </header>

  <main class="main">

    <!-- Hero Section -->
    <section id="hero" class="hero section dark-background" style="min-width:100%;">

      <img src="<c:url value='/images/admin/world-dotted-map.png' />" alt="" class="hero-bg" data-aos="fade-in">

      <div class="container">
        <div class="row gy-4 d-flex justify-content-between">
          <div class="col-lg-6 order-2 order-lg-1 d-flex flex-column justify-content-center">
            <h2 data-aos="fade-up">라이더</h2>
            <p data-aos="fade-up" data-aos-delay="100">배달비 관리</br>배달정보 조회</br></p>

			<div class="formdiv form-search d-flex align-items-stretch mb-3" data-aos="fade-up" data-aos-delay="200">
				<input type="hidden" id="message" name="message" value="<c:out value='${message}'/>">
				<input name="userSe" type="hidden" value="GNR" />
				<input name="j_username" type="hidden" />
              <input id="Id" name="id" onKeyDown="javascript:if(event.keyCode==13){로그인();}" autocomplete="off"  type="text" class="form-control" placeholder="아이디">
              <input id="Pin" name="password" onKeyDown="javascript:if(event.keyCode==13){로그인();}" autocomplete="off" type="password" class="form-control" placeholder="비밀번호">
              <button class="btn btn-primary" onclick="javascript:로그인();">로그인</button>
			</div>

            <form method="post" name="myForm" id="myForm" action="" style="display:none;"></form>


<!-- 			<div class="col-lg-2 col-6 footer-links"> -->
<!-- 				<h4>Useful Links</h4> -->
<!-- 			</div> -->

<!-- 			<div class="sectionrow gy-4"> -->
<!-- 				<div class="col-lg-4 col-md-6 d-flex" data-aos="fade-up" data-aos-delay="100"> -->
<!-- 					<a href="javascript:라이더등록페이지이동();" class="" style="color:#ffffff"><span>라이더 등록</span><i class="bi bi-arrow-right"></i></a> -->
<!-- 				</div> -->
<!-- 			</div> -->
			<div class="sectionrow gy-4">
				<div class="col-lg-4 col-md-6 d-flex" data-aos="" data-aos-delay="100">
					<a href="javascript:비밀번호찾기페이지이동();" class="" style="color:#ffffff"><span>비밀번호 변경</span><i class="bi bi-arrow-right"></i></a>
				</div>
			</div>

          </div>

          <div class="col-lg-5 order-1 order-lg-2 hero-img" data-aos="zoom-out" style="height:200px;">
            <img src="<c:url value='/images/admin/hero-img.svg' />" class="img-fluid mb-3 mb-lg-0" alt="">
          </div>


        </div>
      </div>

    </section><!-- /Hero Section -->








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
  <script src="<c:url value='/vendor/admin/php-email-form/validate.js' />"></script>
  <script src="<c:url value='/vendor/admin/aos/aos.js' />"></script>
  <script src="<c:url value='/vendor/admin/purecounter/purecounter_vanilla.js' />"></script>
  <script src="<c:url value='/vendor/admin/glightbox/js/glightbox.min.js' />"></script>
  <script src="<c:url value='/vendor/admin/swiper/swiper-bundle.min.js' />"></script>

  <!-- Main JS File -->
  <script src="<c:url value='/js/admin/main.js"' />></script>


	<!-- 팝업 폼 -->
	<form name="defaultForm" action ="" method="post" target="_blank">
	<div style="visibility:hidden;display:none;">
	<input name="iptSubmit3" type="submit" value="<spring:message code="comUatUia.loginForm.submit"/>" title="<spring:message code="comUatUia.loginForm.submit"/>">
	</div>
	</form>

</body>
</html>
