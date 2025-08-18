<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script>
  $(function(){

    var str = location.pathname; //URI 경로 끝까지
    var filename = str.split('/')[2];
    var str2 = window.location.search;

    if(filename.indexOf('com0002.do') == 0) {
    	$('.home').addClass('active');
    } else if(filename.indexOf('not0001.do') == 0) {
    	$('.not0001').addClass('active');
    } else if(filename.indexOf('inq0001.do') == 0) {
	  	$('.inq0001').addClass('active');
  	} else if(filename.indexOf('pay0004.do') == 0) {
	  	$('.pay0004').addClass('active');
  	} else if(filename.indexOf('rot0003.do') == 0 && str2.includes("DAY")) {
	  	$('.deposit').addClass('active');
	  	$('.before').addClass('active');
  	} else if(filename.indexOf('rot0003.do') == 0 && str2.includes("WEK")) {
	  	$('.deposit').addClass('active');
	  	$('.after').addClass('active');
  	} else if(filename.indexOf('pay0003.do') == 0) {
	  	$('.pay0003').addClass('active');
  	} else if(filename.indexOf('pay0002.do') == 0) {
	  	$('.pay0002').addClass('active');
  	} else if(filename.indexOf('pay0005.do') == 0) {
	  	$('.pay0005').addClass('active');
  	} else if(filename.indexOf('rot0002.do') == 0) {
	  	$('.rot0002').addClass('active');
  	}
  })
</script>
<header id="header" class="header d-flex align-items-center fixed-top" style="background-color:#0e1d34;">
    <div class="container-fluid container-xl position-relative d-flex align-items-center">

      <a href="${pageContext.request.contextPath}/com/com0002.do" class="logo d-flex align-items-center me-auto">
<!--         Uncomment the line below if you also wish to use an image logo -->
<!--         <img src="assets/img/logo.png" alt=""> -->
        <h4 class="sitename">RIDER BANK</h4>
      </a>

      <nav id="navmenu" class="navmenu">
        <ul>
          <li><a href="${pageContext.request.contextPath}/com/com0002.do" class="home">Home<br></a></li>
		  <li><a href="${pageContext.request.contextPath}/gnr/not0001.do" class="not0001">공지사항</a></li>
		  <li><a href="${pageContext.request.contextPath}/gnr/inq0001.do" class="inq0001">1:1문의</a></li>
		  <li><a href="${pageContext.request.contextPath}/gnr/pay0004.do" class="pay0004">대여.리스</a></li>
          <li class="dropdown"><a href="#" class="deposit"><span>입금</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
            <ul>
              <li><a href="${pageContext.request.contextPath}/gnr/rot0003.do?gubun=DAY" class="before">선지급 배달비</a></li>
              <li><a href="${pageContext.request.contextPath}/gnr/rot0003.do?gubun=WEK" class="after">확정 배달비</a></li>
            </ul>
          </li>
          <li><a href="${pageContext.request.contextPath}/gnr/pay0003.do" class="pay0003">입금 내역</a></li>
          <li><a href="${pageContext.request.contextPath}/gnr/pay0002.do" class="pay0002">배달 정보 조회</a></li>
          <li><a href="${pageContext.request.contextPath}/gnr/pay0005.do" class="pay0005">확정 정보 조회</a></li>
          <li><a href="${pageContext.request.contextPath}/gnr/rot0002.do" class="rot0002">내정보관리</a></li>
        </ul>
        <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
      </nav>

      <a class="btn-getstarted" href="${pageContext.request.contextPath }/uat/uia/actionLogout.do" style="height: 37px;"><spring:message code="comCmm.unitContent.3"/></a>

    </div>
  </header>