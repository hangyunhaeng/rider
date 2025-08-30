<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script>

	//onLoad
	document.addEventListener('DOMContentLoaded', function() {
		if('${loginVO.authorCode}' =='ROLE_ADMIN'){
			$('nav > ul').find('li[class~=administrator]:hidden').show();
		}
		if('${loginVO.authorCode}' =='ROLE_USER'){
			$('nav > ul').find('li[class~=cooperator]:hidden').show();
		}
		if('${loginVO.authorCode}' =='ROLE_SALES'){
			$('nav > ul').find('li[class~=salesman]:hidden').show();
		}
	});

  $(function(){

    var str = location.pathname; //URI 경로 끝까지
    var filename = str.split('/')[2];

    if(filename.indexOf('not0001.do') == 0) {
    	$('.com0002').addClass('active');
    	$('.com0002_1').addClass('active');
    } else if(filename.indexOf('inq0001.do') == 0) {
    	$('.com0002').addClass('active');
    	$('.inq0001').addClass('active');
    } else if(filename.indexOf('pay0003.do') == 0) {
	  	$('.pay').addClass('active');
	  	$('.pay0003').addClass('active');
  	} else if(filename.indexOf('pay0004.do') == 0) {
	  	$('.pay').addClass('active');
	  	$('.pay0004').addClass('active');
  	} else if(filename.indexOf('pay0009.do') == 0) {
	  	$('.pay').addClass('active');
	  	$('.pay0009').addClass('active');
  	} else if(filename.indexOf('pay0005.do') == 0) {
	  	$('.search').addClass('active');
	  	$('.pay0005').addClass('active');
  	} else if(filename.indexOf('pay0001.do') == 0) {
	  	$('.withdraw').addClass('active');
	  	$('.pay0001').addClass('active');
  	} else if(filename.indexOf('pay0006.do') == 0) {
	  	$('.withdraw').addClass('active');
	  	$('.pay0006').addClass('active');
  	} else if(filename.indexOf('pay0008.do') == 0) {
	  	$('.withdraw').addClass('active');
	  	$('.pay0008').addClass('active');
  	} else if(filename.indexOf('dty0006.do') == 0) {
	  	$('.pay').addClass('active');
	  	$('.dty0006').addClass('active');
  	} else if(filename.indexOf('dty0004.do') == 0) {
	  	$('.search').addClass('active');
	  	$('.dty0004').addClass('active');
  	} else if(filename.indexOf('pay0002.do') == 0) {
	  	$('.dty').addClass('active');
	  	$('.pay0002').addClass('active');
  	} else if(filename.indexOf('pay0007.do') == 0) {
	  	$('.dty').addClass('active');
	  	$('.pay0007').addClass('active');
  	} else if(filename.indexOf('sts0001.do') == 0) {
	  	$('.dty').addClass('active');
	  	$('.sts0001').addClass('active');
  	} else if(filename.indexOf('mem0001.do') == 0) {
	  	$('.mem').addClass('active');
	  	$('.mem0001').addClass('active');
  	} else if(filename.indexOf('mem0003.do') == 0) {
	  	$('.mem').addClass('active');
	  	$('.mem0003').addClass('active');
  	} else if(filename.indexOf('mem0005.do') == 0) {
	  	$('.mem').addClass('active');
	  	$('.mem0005').addClass('active');
  	} else if(filename.indexOf('mem0002.do') == 0) {
	  	$('.mem').addClass('active');
	  	$('.mem0002').addClass('active');
  	} else if(filename.indexOf('dty0001.do') == 0) {
	  	$('.upload').addClass('active');
	  	$('.dty0001').addClass('active');
  	} else if(filename.indexOf('dty0002.do') == 0) {
	  	$('.upload').addClass('active');
	  	$('.dty0002').addClass('active');
  	} else if(filename.indexOf('dty0003.do') == 0) {
	  	$('.upload').addClass('active');
	  	$('.dty0003').addClass('active');
  	} else if(filename.indexOf('dty0005.do') == 0) {
	  	$('.upload').addClass('active');
	  	$('.dty0005').addClass('active');
  	} else if(filename.indexOf('mem0004.do') == 0) {
	  	$('.mypage').addClass('active');
  	}

  })
</script>

<header id="header" class="header d-flex align-items-center fixed-top">
		<div
			class="container-fluid container-xl position-relative d-flex align-items-center">

			<a href="${pageContext.request.contextPath}/com/com0002.do"
				class="logo d-flex align-items-center me-auto"> <!-- Uncomment the line below if you also wish to use an image logo -->
				<!-- <img src="/images/admin/logo.png" alt=""> -->
				<h1 class="sitename">RIDER BANK</h1>
			</a>
<%
System.out.println("==================================");
System.out.println("==================================");
System.out.println("==================================");
System.out.println("==================================");
System.out.println("==================================");
System.out.println("==================================");
	System.out.println("request.getServletPath() ==> " + request.getServletPath());
%>

			<nav id="navmenu" class="navmenu">
				<ul>
					<li class="dropdown administrator cooperator" style="display:none;"><a href="" onclick="javascript:return false;" class="com0002"><span>공지사항&문의</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
			              <li><a href="${pageContext.request.contextPath}/usr/not0001.do" class="com0002_1">공지사항</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/inq0001.do" class="inq0001">1:1문의</a></li>
			            </ul>
					</li>
		            <li class="dropdown administrator salesman cooperator" style="display:none;"><a href="" onclick="javascript:return false;" class="pay"><span>수익현황</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
			              <li class="administrator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0003.do" class="pay0003">운영사수익현황(세금)</a></li>
						  <li class="administrator cooperator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0004.do" class="pay0004">협력사수익현황(세금)</a></li>
						  <li class="administrator salesman" style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0009.do" class="pay0009">영업사원수익현황</a></li>
						  <li class="administrator cooperator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/dty0006.do" class="dty0006">협력사 주정산 조회<br></a></li>
			            </ul>
		            </li>
		            <li class="dropdown administrator salesman cooperator" style="display:none;"><a href="" onclick="javascript:return false;" class="withdraw"><span>출금내역</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
						  <li class="administrator cooperator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0001.do" class="pay0001">라이더 출금내역<br></a></li>
						  <li class="administrator cooperator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0006.do" class="pay0006">협력사 출금내역<br></a></li>
						  <li class="administrator salesman" style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0008.do" class="pay0008">영업사원 출금내역<br></a></li>
			            </ul>
		            </li>
		            <li class="dropdown administrator cooperator" style="display:none;"><a href="" onclick="javascript:return false;" class="search"><span>정보조회</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>

						  <li class="administrator cooperator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/dty0004.do" class="dty0004">배달정보 조회</a></li>
						  <li class="administrator cooperator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0005.do" class="pay0005">협력사 기타(대여, 리스) 현황</a></li>

			            </ul>
		            </li>
					<li class="dropdown administrator" style="display:none;"><a href="" onclick="javascript:return false;" class="dty"><span>관리</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
						  <li class="administrator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0002.do" class="pay0002">입출금 대사<br></a></li>
						  <li class="administrator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0007.do" class="pay0007">알림톡 발송 조회<br></a></li>
						  <li class="administrator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/sts0001.do" class="sts0001">잔액 조회<br></a></li>
			            </ul>
		            </li>

					<li class="dropdown administrator cooperator" style="display:none;"><a href="" onclick="javascript:return false;" class="mem"><span>협력사/라이더 현황</span><i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li><a href="${pageContext.request.contextPath}/usr/mem0001.do" class="mem0001">협력사 관리</a></li>
              				<li class="administrator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0003.do" class="mem0003">협력사계정 관리</a></li>
              				<li class="administrator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0005.do" class="mem0005">영업사원계정 관리</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/mem0002.do" class="mem0002">라이더관리</a></li>
						</ul>
					</li>
					<li class="dropdown administrator" style="display:none;"><a href="" onclick="javascript:return false;" class="upload"><span>자료 업로드</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li><a href="${pageContext.request.contextPath}/usr/dty0001.do" class="dty0001">일별 자료 업로드</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0002.do" class="dty0002">주별 자료 업로드</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0003.do" class="dty0003">자료 업로드 이력</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0005.do" class="dty0005">자료 확정</a></li>
						</ul>
					</li>
					<li class="administrator cooperator salesman" style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0004.do" class="mypage">MyPage</a></li>
				</ul>
				<i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
			</nav>
			<a class="btn-getstarted" href="${pageContext.request.contextPath }/uat/uia/actionLogout.do" style="height: 37px;"><spring:message code="comCmm.unitContent.3" /></a>


		</div>
	</header>
<main class="main" style="height: 60px;">

		<!-- Hero Section -->
		<section id="hero" class="hero section dark-background"
			style="min-height: 50px; padding: 70px 0 30px 0;">

			<img src="<c:url value='/images/admin/world-dotted-map.png' />" alt="" class="hero-bg"
				data-aos="fade-in">
			<div class="container-fluid container-xl position-relative d-flex align-items-center">
				<div class="d-flex align-items-center me-auto"></div>
		 		<sm class="btn-getstarted">${loginVO.name}
		 		<c:if test="${loginVO.authorCode eq 'ROLE_ADMIN'}">(운영사)</c:if>
		 		<c:if test="${loginVO.authorCode eq 'ROLE_USER'}">(협력사)</c:if>
		 		<c:if test="${loginVO.authorCode eq 'ROLE_SALES'}">(영업)</c:if>
		 		님 환영합니다</sm>
		 	</div>
		</section>
	</main>