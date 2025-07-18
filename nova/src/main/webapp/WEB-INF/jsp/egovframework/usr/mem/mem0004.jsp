<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<!-- Fonts -->
<link href="https://fonts.googleapis.com" rel="preconnect">
<link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">

<!-- Vendor CSS Files -->
<script src="<c:url value='/vendor/admin/bootstrap/js/bootstrap.min.js' />"></script>
<link href="<c:url value='/vendor/admin/bootstrap/css/bootstrap.min.css' />" rel="stylesheet">
<link href="<c:url value='/vendor/admin/bootstrap-icons/bootstrap-icons.css' />" rel="stylesheet">
<%-- <link href="<c:url value='/vendor/admin/aos/aos.css' />" rel="stylesheet"> --%>
<%-- <link href="<c:url value='/vendor/admin/fontawesome-free/css/all.min.css' />" rel="stylesheet"> --%>
<%-- <link href="<c:url value='/vendor/admin/glightbox/css/glightbox.min.css' />" rel="stylesheet"> --%>
<%-- <link href="<c:url value='/vendor/admin/swiper/swiper-bundle.min.css' />" rel="stylesheet"> --%>

<!-- Main CSS File -->
<link href="<c:url value='/css/admin/main.css' />" rel="stylesheet">


<!-- 달력 -->
<link rel="stylesheet" type="text/css" href="<c:url value='/calender/flatpickr.min.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/calender/material_orange.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/calender/style.css' />">
<script src="<c:url value='/calender/flatpickr.js' />"></script>
<script src="<c:url value='/calender/ko.js' />"></script>
<script src="<c:url value='/calender/index.js' />"></script>

<script type="text/javascript"	src="<c:url value='/js/admin/util.js' />"></script>


<!-- keiti용 소스 -->
<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.default.css' /> ">
<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.style.css' />">

<script type="text/javascript"	src="<c:url value='/web2/js/function.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/jquery-1.11.2.min.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/keit.jquery.ui.js' />"></script>

<link rel="stylesheet" href="<c:url value='/ag-grid/ag-grid.css' />">
<link rel="stylesheet" href="<c:url value='/ag-grid/ag-theme-alpine.css' />">
<link rel="stylesheet" href="<c:url value='/ag-grid/ag-custom.css' />">
<script src="<c:url value='/ag-grid/ag-grid-community.noStyle.js' />"></script>
<script src="<c:url value='/ag-grid/ag-grid-community.js' />"></script>
<script src="<c:url value='/ag-grid/ag-custom-header.js' />"></script>
<script src="<c:url value='/js/xlsx.full.min.js' />"></script>
<script src="<c:url value='/js/xlsx-populate.min.js' />"></script>
<script src="<c:url value='/js/axios.min.js' />"></script>
	<link href="<c:url value='/vendor/admin/bootstrap/3.4.1/bootstrap.min.css' />" rel="stylesheet">
<!-- 	<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script> -->

</head>
<script type="text/javaScript">


	document.addEventListener('DOMContentLoaded', function() {

		if('${loginVO.authorCode}' =='ROLE_ADMIN'){
			$('nav > ul').find('li[class!=cooperator]:hidden').show();
		}
		if('${loginVO.authorCode}' =='ROLE_USER'){
			$('nav > ul').find('li[class~=cooperator]:hidden').show();
		}

		$('#strMbtlnum').html(addHyphenToPhoneNumber("${myInfoVO.mbtlnum}"));
		$('#mbtlnum').val(addHyphenToPhoneNumber("${myInfoVO.mbtlnum}"));

		if('${loginVO.authorCode}' =='ROLE_ADMIN'){
			$('#잔액조회').show();
		}
		if("${myInfoVO.authorCode}" == "ROLE_USER") {
			$('#계좌정보수정버튼').show();
		}

	    var bankList = JSON.parse('${bankList}');
	    populateSelectOptions('bnkCd', bankList.resultList,'', {opt:'-'});
	});


	function 비밀번호저장(){
		if ($("#befPw").val() == "") {
	        alert("기존 비밀번호를 입력하세요");
	        $("#befPw").focus();
	        return;
	    }
		if(!chkPass($("#pw"))){
			return false;
		}
		if ($("#pwConfirm").val() == "") {
	        alert("비밀번호 확인를 입력하세요");
	        $("#pwConfirm").focus();
	        return;
	    }
		if($("#pw").val() != $("#pwConfirm").val()){
			alert("비밀번호확인 문자가 다릅니다");
			$("#pwConfirm").focus();
	        return false;
		}
		if(confirm("저장하시겠습니까?")){
		    const params = new URLSearchParams();
	    	params.append("befPassword", $('#befPw').val());
	    	params.append("password", $('#pw').val());

			// 로딩 시작
	        $('.loading-wrap--js').show();
		    axios.post('${pageContext.request.contextPath}/usr/mem0004_0003.do', params)
		        .then(response => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();

					if(response.data.resultCode == "success"){
						goMyInfo();
					} else {
						if(response.data.resultMsg != '' && response.data.resultMsg != null)
							alert(response.data.resultMsg);
						else alert("비밀번호 저장에 실패하였습니다");
						return ;
					}
		        })
		        .catch(function(error) {
		            console.error('There was an error fetching the data:', error);
		        }).finally(function() {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();
		        });
		}
	}

	function 기본정보저장(){

		//이메일유효성
		if(!validEmail(document.getElementById('mberEmailAdres'))){
			return;
		}

	    // 전화번호 유효성 검사
		if(!validMobile(document.getElementById('mbtlnum'))){
			return;
		}


		if(confirm("저장하시겠습니까?")){
		    const params = new URLSearchParams();
		    params.append("mberEmailAdres", $('#mberEmailAdres').val());
		    params.append("mbtlnum", getOnlyNumber($('#mbtlnum').val()));

			// 로딩 시작
	        $('.loading-wrap--js').show();
		    axios.post('${pageContext.request.contextPath}/usr/mem0004_0001.do', params)
		        .then(response => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();
					if(response.data.resultCode == "success"){
						goMyInfo();
					} else {
						if(response.data.resultMsg != '' && response.data.resultMsg != null)
							alert(response.data.resultMsg);
						else alert("기본정보 저장에 실패하였습니다");
						return ;
					}
		        })
		        .catch(function(error) {
		            console.error('There was an error fetching the data:', error);
		        }).finally(function() {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();

		        });
		}
	}

	function 계좌정보저장(){

		if($('#bnkCd').val() == ""){
			alert("은행을 선택하세요");
			$("#bnkCd").focus();
			return;
		}
		if($('#accountNum').val() == ""){
			alert("계좌번호를 입력하세요");
			$("#accountNum").focus();
			return;
		}
		if(confirm("저장하시겠습니까?")){
		    const params = new URLSearchParams();
		    params.append("bnkCd", $('#bnkCd').val());
		    params.append("accountNum", getOnlyNumber($('#accountNum').val()));

			// 로딩 시작
	        $('.loading-wrap--js').show();
		    axios.post('${pageContext.request.contextPath}/usr/mem0004_0002.do', params)
		        .then(response => {        	// 로딩 종료
		            $('.loading-wrap--js').hide();
		        	debugger;
					if(response.data.resultCode == "success"){
						goMyInfo();
					} else {
		        		if(response.data.resultMsg != null && response.data.resultMsg != ''){
		        			alert(response.data.resultMsg);
		        		} else {
		        			alert("저장에 실패하였습니다");
		        		}
					}
		        })
		        .catch(function(error) {
		            console.error('There was an error fetching the data:', error);
		        }).finally(function() {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();

		        });

		}
	}
	//페이지 이동
	function goMyInfo() {
		$('#myForm').attr("action", "${pageContext.request.contextPath}/usr/mem0004.do");
		$('#myForm').submit();
	}
	function 기본정보show(){
		$('#div기본정보').show();
	}

	function 잔액조회(){

	    const params = new URLSearchParams();

		// 로딩 시작
        $('.loading-wrap--js').show();
	    axios.post('${pageContext.request.contextPath}/usr/mem0004_0004.do', params)
	        .then(response => {        	// 로딩 종료
	            $('.loading-wrap--js').hide();
	        	debugger;
				if(response.data.resultCode == "success"){
					if(response.data.doszSchAccoutCostVO.status == "200"){
						$('#잔액').show();
					} else {
						alert(response.data.doszSchAccoutCostVO.errorMessage);
					}
				} else {
	        		if(response.data.resultMsg != null && response.data.resultMsg != ''){
	        			alert(response.data.resultMsg);
	        		} else {
	        			alert("저장에 실패하였습니다");
	        		}
				}
	        })
	        .catch(function(error) {
	            console.error('There was an error fetching the data:', error);
	        }).finally(function() {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	        });

	}
</script>
<body class="index-page">

      <div class="loading-wrap loading-wrap--js" style="display: none;z-index:10000;">
        <div class="loading-spinner loading-spinner--js"></div>
        <p id="loadingMessage">로딩중</p>
      </div>
	<header id="header" class="header d-flex align-items-center fixed-top">
		<div
			class="container-fluid container-xl position-relative d-flex align-items-center">

			<a href="${pageContext.request.contextPath}/com/com0002.do"
				class="logo d-flex align-items-center me-auto"> <!-- Uncomment the line below if you also wish to use an image logo -->
				<!-- <img src="/images/admin/logo.png" alt=""> -->
				<h1 class="sitename">RIDER BANK</h1>
			</a>


			<nav id="navmenu" class="navmenu">
				<ul>
					<li class="dropdown"><a href="" onclick="javascript:return false;"><span>공지사항&문의</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
			              <li><a href="${pageContext.request.contextPath}/usr/not0001.do">공지사항</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/inq0001.do">1:1문의</a></li>
			            </ul>
					</li>
		            <li class="dropdown"><a href="" onclick="javascript:return false;"><span>수익현황</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
			              <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0003.do">운영사수익현황</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/pay0004.do">협력사수익현황</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/pay0005.do">협력사 기타(대여, 리스) 현황</a></li>
						  <li><a href="${pageContext.request.contextPath}/usr/pay0001.do">입출금내역<br></a></li>
			            </ul>
		            </li>
		            <li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;"><span>관리</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
			          	<ul>
						  <li><a href="${pageContext.request.contextPath}/usr/dty0004.do">배달정보 조회</a></li>
						  <li style="display:none;"><a href="${pageContext.request.contextPath}/usr/pay0002.do">입출금 대사<br></a></li>
			            </ul>
		            </li>

					<li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;"><span>협력사/라이더 현황</span><i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li><a href="${pageContext.request.contextPath}/usr/mem0001.do">협력사 관리</a></li>
              				<li><a href="${pageContext.request.contextPath}/usr/mem0003.do">협력사계정 관리</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/mem0002.do">라이더관리</a></li>
						</ul></li>
					<li class="dropdown" style="display:none;"><a href="" onclick="javascript:return false;"><span>자료 업로드</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li><a href="${pageContext.request.contextPath}/usr/dty0001.do">일별 자료 업로드</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0002.do">주별 자료 업로드</a></li>
							<li><a href="${pageContext.request.contextPath}/usr/dty0003.do">자료 업로드 이력</a></li>
						</ul>
					</li>
					<li class="cooperator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/dty0004.do">배달정보 조회</a></li>
					<li class="cooperator" style="display:none;"><a href="${pageContext.request.contextPath}/usr/mem0002.do">라이더관리</a></li>
					<li><a href="${pageContext.request.contextPath}/usr/mem0004.do" class="active">MyPage</a></li>
				</ul>
				<i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
			</nav>
	<a class="btn-getstarted" href="${pageContext.request.contextPath }/uat/uia/actionLogout.do" style="height: 37px;"><spring:message code="comCmm.unitContent.3"/></a>


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
		 		<sm class="btn-getstarted">${loginVO.name}<c:if test="${loginVO.authorCode eq 'ROLE_ADMIN'}">(운영사)</c:if>님 환영합니다</sm>
		 	</div>
		</section>
	</main>

	<!-- 숨겨진 폼 -->
	<form id="myForm" action="/conv/conv02410.do" method="POST"
		style="display: none;">
		<!-- <input type="hidden" name=taskNo id="taskNo"> -->
	</form>

	<div class="keit-header-body innerwrap clearfix">
		<p class="tit">MyPage</p>

		<input name="pageUnit" type="hidden" value="1000" /> <input
			name="pageSize" type="hidden" value="1000" />


		<div id="divpass" class="search_box ty2 collapse" >

				<div style="margin-bottom:10px;">
					<span class="pagetotal" style='margin-right: 20px;'></span>
					<div class="btnwrap">
						<button id="비밀번호저장버튼" class="btn ty1" onclick="비밀번호저장()">비밀번호저장</button>
					</div>
				</div>

				<table>
					<colgroup>
						<col style="width: 13%">
						<col style="width: *">
					</colgroup>
					<tr>
						<th>기존비밀번호</th>
						<td>
							<input id="befPw" type="password" value=""/>
						</td>
					</tr>
					<tr>
						<th>변경 비밀번호</th>
						<td>
							<input id="pw" type="password" value=""/>
						</td>
					</tr>
					<tr>
						<th>비밀번호 확인</th>
						<td>
							<input id="pwConfirm" type="password" value=""/>
						</td>
					</tr>
				</table>


		</div>

		<div id="divbase" class="search_box ty2 collapse" >

				<div style="margin-bottom:10px;">
					<span class="pagetotal" style='margin-right: 20px;'></span>
					<div class="btnwrap">
						<button id="기본정보저장버튼" class="btn ty1" onclick="기본정보저장()">기본정보저장</button>
					</div>
				</div>

				<table>
					<colgroup>
						<col style="width: 13%">
						<col style="width: *">
					</colgroup>
					<tr>
						<th>휴대전화번호</th>
						<td colspan="5">
							<input id="mbtlnum" type="text" value="${myInfoVO.mbtlnum}"/>
						</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td colspan="5">
							<input id="mberEmailAdres" type="text" value="${myInfoVO.mberEmailAdres}"/>
						</td>
					</tr>
				</table>


		</div>
		<div id="divbnk" class="search_box ty2 collapse" >

				<div style="margin-bottom:10px;">
					<span class="pagetotal" style='margin-right: 20px;'></span>
					<div class="btnwrap">
						<button id="계좌정보저장버튼" class="btn ty1" onclick="계좌정보저장()">계좌정보저장</button>
					</div>
				</div>

				<table>
					<colgroup>
						<col style="width: 13%">
						<col style="width: *">
					</colgroup>
					<tr>
						<th>은행</th>
						<td>
							<select id="bnkCd"></select>
						</td>
					</tr>
					<tr>
						<th>계좌번호</th>
						<td>
							<input id="accountNum" type="text" maxlength="20" oninput="this.value = this.value.replace(/[^0-9-]/g, '').replace(/(\..*)\./g, '$1');"/>
						</td>
					</tr>
				</table>


		</div>

		<div class="search_box ty2">

				<div style="margin-bottom:10px;">
					<span class="pagetotal" style='margin-right: 20px;'></span>
					<div class="btnwrap">
						<button id="기본정보수정버튼" onclick="$('#divbnk').collapse('hide');$('#divpass').collapse('hide');" class="btn btn-primary" data-bs-toggle="collapse" data-bs-target="#divbase" aria-expanded="false">기본정보수정</button>
						<button id="비밀번호수정버튼" onclick="$('#divbnk').collapse('hide');$('#divbase').collapse('hide');" class="btn btn-primary" data-bs-toggle="collapse" data-bs-target="#divpass" aria-expanded="false">비밀번호수정</button>
						<button id="계좌정보수정버튼" onclick="$('#divbase').collapse('hide');$('#divpass').collapse('hide');" class="btn btn-primary" data-bs-toggle="collapse" data-bs-target="#divbnk" aria-expanded="false" style="display:none;">계좌정보수정</button>
					</div>
				</div>

				<table>
					<colgroup>
						<col style="width: 13%">
						<col style="width: *">
					</colgroup>
					<tr>
						<th>아이디</th>
						<td>
							<sm>${myInfoVO.mberId}</sm>
						</td>
					</tr>
					<tr>
						<th>권한</th>
						<td>
							<sm>${myInfoVO.authorCodeNm}</sm>
						</td>
					</tr>
					<tr>
						<th>이름</th>
						<td>
							<sm>${myInfoVO.mberNm}</sm>
						</td>
					</tr>
					<tr>
						<th>비밀번호</th>
						<td>
							<sm>*********</sm>
						</td>
					</tr>
					<tr>
						<th>휴대전화번호</th>
						<td>
							<sm id="strMbtlnum"></sm>
						</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td>
							<sm>${myInfoVO.mberEmailAdres}</sm>
						</td>
					</tr>
					<tr>
						<th>은행</th>
						<td>
							<sm>${myInfoVO.bnkNm}</sm>
						</td>
					</tr>
					<tr>
						<th>계좌번호</th>
						<td>
							<sm>${myInfoVO.accountNum}</sm>
							<button id="잔액조회" onclick="잔액조회()" class="btn btn-primary" style="display:none;">잔액조회</button>
							<sm id="잔액" style="display:none;">0000원</sm>
						</td>
					</tr>
					<tr>
						<th>예금주</th>
						<td>
							<sm>${myInfoVO.accountNm}</sm>
						</td>
					</tr>
				</table>


		</div>


	</div>


  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>



  <!-- Vendor JS Files -->
  <script src="<c:url value='/vendor/admin/aos/aos.js' />"></script>
  <script src="<c:url value='/vendor/admin/purecounter/purecounter_vanilla.js' />"></script>
  <script src="<c:url value='/vendor/admin/glightbox/js/glightbox.min.js' />"></script>

  <!-- Main JS File -->
  <script src="<c:url value='/js/admin/main.js' />"></script>
</body>
</html>