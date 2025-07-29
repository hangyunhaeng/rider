<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<header id="header" class="header d-flex align-items-center fixed-top" style="background-color:#0e1d34;">
    <div class="container-fluid container-xl position-relative d-flex align-items-center">

      <a href="${pageContext.request.contextPath}/com/com0002.do" class="logo d-flex align-items-center me-auto">
<!--         Uncomment the line below if you also wish to use an image logo -->
<!--         <img src="assets/img/logo.png" alt=""> -->
        <h4 class="sitename">RIDER BANK</h4>
      </a>

      <nav id="navmenu" class="navmenu">
        <ul>
          <li><a href="${pageContext.request.contextPath}/com/com0002.do">Home<br></a></li>
		  <li><a href="${pageContext.request.contextPath}/gnr/not0001.do">공지사항</a></li>
		  <li><a href="${pageContext.request.contextPath}/gnr/inq0001.do" class="active">1:1문의</a></li>
		  <li><a href="${pageContext.request.contextPath}/gnr/pay0004.do">대여.리스</a></li>
          <li class="dropdown"><a href="#"><span>입금</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
            <ul>
              <li><a href="${pageContext.request.contextPath}/gnr/rot0003.do?gubun=DAY">선지급 배달비</a></li>
              <li><a href="${pageContext.request.contextPath}/gnr/rot0003.do?gubun=WEK">확정 배달비</a></li>
            </ul>
          </li>
          <li><a href="${pageContext.request.contextPath}/gnr/pay0003.do">입금 내역</a></li>
          <li><a href="${pageContext.request.contextPath}/gnr/pay0002.do">배달 정보 조회</a></li>
          <li><a href="${pageContext.request.contextPath}/gnr/rot0002.do">내정보관리</a></li>
        </ul>
        <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
      </nav>

      <a class="btn-getstarted" href="${pageContext.request.contextPath }/uat/uia/actionLogout.do" style="height: 37px;"><spring:message code="comCmm.unitContent.3"/></a>

    </div>
  </header>