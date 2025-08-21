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


	document.addEventListener('DOMContentLoaded', function() {

		$('#strMbtlnum').html(addHyphenToPhoneNumber("${myInfoVO.mbtlnum}"));
		$('#mbtlnum').val(addHyphenToPhoneNumber("${myInfoVO.mbtlnum}"));

		if('${loginVO.authorCode}' =='ROLE_ADMIN'){
			$('#잔액조회').show();
		}
		if("${myInfoVO.authorCode}" == "ROLE_USER" || "${myInfoVO.authorCode}" == "ROLE_SALES") {
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

		            if(chkLogOut(response.data)){
		            	return;
		            }

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

		            if(chkLogOut(response.data)){
		            	return;
		            }

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

		            if(chkLogOut(response.data)){
		            	return;
		            }

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

	            if(chkLogOut(response.data)){
	            	return;
	            }

				if(response.data.resultCode == "success"){
					if(response.data.doszSchAccoutCostVO.status == "200"){
						$('#잔액').show();
						$('#잔액').html( response.data.doszSchAccoutCostVO.trAfterSign!='+'?response.data.doszSchAccoutCostVO.trAfterSign:"" + currencyFormatter(response.data.doszSchAccoutCostVO.trAfterBac)+"원")
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

	<jsp:include page="../inc/nav.jsp" />

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