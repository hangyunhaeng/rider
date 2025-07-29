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

	var goActStep2;
	//onLoad
	document.addEventListener('DOMContentLoaded', function() {
		debugger;
		$('#strMbtlnum').html(addHyphenToPhoneNumber("${myInfoVO.mbtlnum}"));
		$('#mbtlnum').val(addHyphenToPhoneNumber("${myInfoVO.mbtlnum}"));
		$('#strRegistrationSn').html(addHyphenToregistrationSn("${myInfoVO.registrationSn}"));

	    var bankList = JSON.parse('${bankList}');
	    populateSelectOptions('bnkCd', bankList.resultList,'', {opt:'-'});


		//  EMAIL (userid) 형식 유효성 검사
// 		let userid = document.querySelector('#mberEmailAdres');
// 		userid.addEventListener('change',(e)=>{  // html 의 onchange="validEmail(this)"와 동일
// 		    validEmail(e.target);
// 		})

	});

	function 기본정보저장(){

		if ($("#pw").val() != "") {

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
	    }


	    // 전화번호 유효성 검사
		if(!validMobile(document.getElementById('mbtlnum'))){
			return;
		}

		//이메일유효성
		if(!validEmail(document.getElementById('mberEmailAdres'))){
			return;
		}
	debugger;
		if(confirm("저장하시겠습니까?")){
			if(${doNice} != true){
				saveInfo();
				return;
			}


			// 로딩 시작
	        $('.loading-wrap--js').show();
			var formData = new FormData();


		    const params = new URLSearchParams();
		    axios.post('${pageContext.request.contextPath}/com/com0010_0000.do', params)
		        .then(response => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();
					if(response.data.resultCode == "success"){
						document.form_chk.token_version_id.value = response.data.token_version_id;
						document.form_chk.enc_data.value = response.data.enc_data;
						document.form_chk.integrity_value.value = response.data.integrity;
						goActStep2 = saveInfo;

						fnPopup();
					} else {
						if(response.data.resultMsg != '' && response.data.resultMsg != null)
							alert(response.data.resultMsg);
						else alert("기본정보 저장에 실패하였습니다");
						return ;
					}
		        })
		        .catch(error => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();
		            console.error('Error fetching data:', error);
		        });

		}
	}


	function saveInfo(){

		    const params = new URLSearchParams();
		    params.append("mberEmailAdres", $('#mberEmailAdres').val());
		    params.append("mbtlnum", getOnlyNumber($('#mbtlnum').val()));
		    if ($("#pw").val() != "") {
		    	params.append("befPassword", $('#befPw').val());
		    	params.append("password", $('#pw').val());
		    }

			// 로딩 시작
	        $('.loading-wrap--js').show();
		    axios.post('${pageContext.request.contextPath}/gnr/rot0002_0001.do', params)
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
		        .catch(error => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();
		            console.error('Error fetching data:', error);
		        });

	}
// 	function 계좌정보저장(){

// 		if($('#bnkCd').val() == ""){
// 			alert("은행을 선택하세요");
// 			$("#bnkCd").focus();
// 			return;
// 		}
// 		if($('#accountNum').val() == ""){
// 			alert("계좌번호를 입력하세요");
// 			$("#accountNum").focus();
// 			return;
// 		}
// 		if(confirm("저장하시겠습니까?")){

// 			if(${doNice} != true){
// 				saveAcc();
// 				return;
// 			}

// 			// 로딩 시작
// 	        $('.loading-wrap--js').show();
// 			var formData = new FormData();


// 		    const params = new URLSearchParams();
// 		    axios.post('${pageContext.request.contextPath}/com/com0010_0000.do', params)
// 		        .then(response => {
// 		        	// 로딩 종료
// 		            $('.loading-wrap--js').hide();
// 					if(response.data.resultCode == "success"){
// 						document.form_chk.token_version_id.value = response.data.token_version_id;
// 						document.form_chk.enc_data.value = response.data.enc_data;
// 						document.form_chk.integrity_value.value = response.data.integrity;
// 						goActStep2 = saveAcc;

// 						fnPopup();
// 					} else {
// 						if(response.data.resultMsg != '' && response.data.resultMsg != null)
// 							alert(response.data.resultMsg);
// 						else alert("기본정보 저장에 실패하였습니다");
// 						return ;
// 					}
// 		        })
// 		        .catch(error => {
// 		        	// 로딩 종료
// 		            $('.loading-wrap--js').hide();
// 		            console.error('Error fetching data:', error);
// 		        });


// 		}
// 	}


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
		    params.append("bnkCd", $('#bnkCd').val());								//은행코드
		    params.append("accountNum", getOnlyNumber($('#accountNum').val()));		//계좌번호
		    params.append("accountNm", $('#accountNm').val());		//에금주명

			// 로딩 시작
	        $('.loading-wrap--js').show();
		    axios.post('${pageContext.request.contextPath}/gnr/rot0002_0003.do', params)	//얘금주명 조회
		        .then(response => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();

		            if(chkLogOut(response.data)){
		            	return;
		            }

					if(response.data.resultCode == "success"){
						//개발계는 pass 않태우고 바로 저장
						if(${doNice} != true){
							saveAcc();
							return;
						}
						//pass 개인정보 조회
						pass();
					} else {
						if(response.data.resultMsg != '' && response.data.resultMsg != null)
							alert(response.data.resultMsg);
						else alert("실패하였습니다");
					}
		        })
		        .catch(error => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();
		            console.error('Error fetching data:', error);
		        });
		}
	}

	function pass(){
			// 로딩 시작
	        $('.loading-wrap--js').show();
			var formData = new FormData();


		    const params = new URLSearchParams();
		    axios.post('${pageContext.request.contextPath}/com/com0010_0000.do', params)
		        .then(response => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();
					if(response.data.resultCode == "success"){
						document.form_chk.token_version_id.value = response.data.token_version_id;
						document.form_chk.enc_data.value = response.data.enc_data;
						document.form_chk.integrity_value.value = response.data.integrity;
						goActStep2 = saveAcc;

						fnPopup();
					} else {
						if(response.data.resultMsg != '' && response.data.resultMsg != null)
							alert(response.data.resultMsg);
						else alert("pass인증에 실패하였습니다");
						return ;
					}
		        })
		        .catch(error => {
		        	// 로딩 종료
		            $('.loading-wrap--js').hide();
		            console.error('Error fetching data:', error);
		        });
	}

// 	function saveAcc(){

// 	    const params = new URLSearchParams();
// 	    params.append("bnkCd", $('#bnkCd').val());
// 	    params.append("accountNum", getOnlyNumber($('#accountNum').val()));

// 		// 로딩 시작
//         $('.loading-wrap--js').show();
// 	    axios.post('${pageContext.request.contextPath}/gnr/rot0002_0002.do', params)
// 	        .then(response => {
// 	        	// 로딩 종료
// 	            $('.loading-wrap--js').hide();

//             if(chkLogOut(response.data)){
//             	return;
//             }

// 				if(response.data.resultCode == "success"){
// 					goMyInfo();
// 				} else {
// 					if(response.data.resultMsg != '' && response.data.resultMsg != null)
// 						alert(response.data.resultMsg);
// 					else alert("실패하였습니다");
// 				}
// 	        })
// 	        .catch(error => {
// 	        	// 로딩 종료
// 	            $('.loading-wrap--js').hide();
// 	            console.error('Error fetching data:', error);
// 	        });
// 	}


	function saveAcc(){

	    const params = new URLSearchParams();
		// 로딩 시작
        $('.loading-wrap--js').show();
	    axios.post('${pageContext.request.contextPath}/gnr/rot0002_0004.do', params)
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
					else alert("계좌정보 저장에 실패하였습니다");
				}
	        })
	        .catch(error => {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
	            console.error('Error fetching data:', error);
	        });
	}

	//페이지 이동
	function goMyInfo() {
		$('#myForm').attr("action", "${pageContext.request.contextPath}/gnr/rot0002.do");
		$('#myForm').submit();
	}

    function fnPopup(){
        window.open('', 'popupChk', 'width=480, height=812, top=100, fullscreen=no, menubar=no, status=no, toolbar=no,titlebar=yes, location=no, scrollbar=no');
        document.form_chk.action = "https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb";
        document.form_chk.target = "popupChk";
        document.form_chk.submit();
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
            <div class="col-12">


              <div class="card mb-3">
                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-2">
                    <div class="col-auto">
                      <h3 class="text-body-emphasis">기본정보</h3>
                    </div>
                       <div class="col-auto d-flex">
                       	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="$('.collapseExample1').collapse('hide');" data-bs-toggle="collapse" data-bs-target=".collapseExample0" aria-expanded="false">변경</button>
                       </div>
                  </div>
                </div>

                <div class="card-body py-0 scrollbar to-do-list-body">


								<div class="d-flex hover-actions-trigger py-3 border-translucent border-top">
									<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer">
										<div class="col-12">

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">아이디</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style="">${myInfoVO.mberId}</span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">이름</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style="">${myInfoVO.mberNm}</span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto"">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">비밀번호</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style="">**********</span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">휴대전화번호</label>
												</div>
												<div class="col-auto d-flex"">
													<span id="strMbtlnum" class="fs-9 mb-2" style="">${myInfoVO.mbtlnum}</span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">이메일</label>
												</div>
												<div class="col-auto d-flex"">
													<span class="fs-9 mb-2" style="">${myInfoVO.mberEmailAdres}</span>
												</div>
											</div>


										</div>
									</div>
								</div>

							</div>
            </div>
			<div class="mb-3 collapse collapseExample0">
			    <div class="d-flex row justify-content-between align-items-center">
	                <div class="col-auto">
	                </div>
	                <div class="d-flex col-auto">
	                	<button class="btn btn-primary mb-0 mb-sm-0 mx-1 fs-9 mt-2" type="submit" onclick="기본정보저장()">기본정보저장</button>
	                </div>
                </div>
				<div class="d-flex hover-actions-trigger py-2 border-translucent  position-relative">
					<div class="col-12">
						<div class="form-floating">
						<input class="form-control" id="befPw" type="password" placeholder="기존 비밀번호"><label for="floatingInputZipcode">기존 비밀번호<em style="color:red;"> 변경시 입력</em></label>
						</div>
					</div>
				</div>
				<div class="d-flex hover-actions-trigger py-2 border-translucent  position-relative">
					<div class="col-12">
						<div class="form-floating">
						<input class="form-control" id="pw" type="password" placeholder="변경 비밀번호"><label for="floatingInputZipcode">변경 비밀번호<em style="color:red;"> 변경시 입력</em></label>
						</div>
					</div>
				</div>
				<div class="d-flex hover-actions-trigger py-2 border-translucent position-relative">
					<div class="col-12">
						<div class="form-floating">
						<input class="form-control" id="pwConfirm" type="password" placeholder="비밀번호 확인"><label for="floatingInputZipcode">비밀번호 확인<em style="color:red;"> 변경시 입력</em></label>
						</div>
					</div>
				</div>

				<div class="d-flex hover-actions-trigger py-2 border-translucent position-relative">
					<div class="col-12">
						<div class="form-floating">
						<input class="form-control" id="mbtlnum" type="text" maxlength="15" oninput="this.value = this.value.replace(/[^0-9-]/g, '').replace(/(\..*)\./g, '$1');" placeholder="휴대전화번호" value="${myInfoVO.mbtlnum}"><label for="floatingInputZipcode">휴대전화번호</label>
						</div>
					</div>
				</div>

				<div class="d-flex hover-actions-trigger py-2 border-translucent  position-relative">
					<div class="col-12">
						<div class="form-floating">
						<input class="form-control" id="mberEmailAdres" type="text" placeholder="이메일" value="${myInfoVO.mberEmailAdres}"><label for="floatingInputZipcode">이메일</label>
						</div>
					</div>
				</div>
<!--                 <div class="d-flex border-bottom row justify-content-between align-items-center"> -->
<!-- 	                <div class="col-auto"> -->
<!-- 	                </div> -->
<!-- 	                <div class="d-flex col-auto"> -->
<!-- 	                	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="기본정보저장()">기본정보저장</button> -->
<!-- 	                </div> -->
<!--                 </div> -->
			</div>



              <div class="card mb-3">
                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-2">
                    <div class="col-auto">
                      <h3 class="text-body-emphasis">계좌정보</h3>
                    </div>
                       <div class="col-auto d-flex">
                       	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" onclick="$('.collapseExample0').collapse('hide');" type="submit" data-bs-toggle="collapse" data-bs-target=".collapseExample1" aria-expanded="false">변경</button>
                       </div>
                  </div>
                </div>

                <div class="card-body py-0 scrollbar to-do-list-body">

								<div class="d-flex hover-actions-trigger py-3 border-translucent border-top">
									<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer">
										<div class="col-12">

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">은행</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style="">${myInfoVO.bnkNm}</span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">계좌번호</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style="">${myInfoVO.accountNum}</span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">예금주명</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style="">${myInfoVO.accountNm}</span>
												</div>
											</div>


										</div>
									</div>
								</div>

							</div>
            </div>
			<div class="mb-3 collapse collapseExample1">
                <div class="d-flex row justify-content-between align-items-center">
	                <div class="col-auto">
	                </div>
	                <div class="d-flex col-auto">
	                	<button class="btn btn-primary mb-2 mb-sm-0 mx-1 fs-9" type="submit" onclick="계좌정보저장()">계좌정보저장</button>
	                </div>
                </div>
				<div class="d-flex hover-actions-trigger py-2 border-translucent position-relative">
					<div class="col-12">
					<div class="form-floating">
						<select id="bnkCd" class="form-select"></select>
		                <label for="bnkCd">은행</label></div>
					</div>
				</div>
				<div class="d-flex hover-actions-trigger py-2 border-translucent position-relative">
					<div class="col-12">
						<div class="form-floating">
						<input id="accountNum" class="form-control" type="number" placeholder="계좌번호" maxlength="20" oninput="maxLengthCheck(this)"><label for="floatingInputZipcode">계좌번호</label>
						</div>
					</div>
				</div>

				<div class="d-flex hover-actions-trigger py-2 border-translucent position-relative">
					<div class="col-12">
						<div class="form-floating">
						<input id="accountNm" class="form-control" type="text" placeholder="예금주명"><label for="floatingInputZipcode">예금주명<em style="color:red;">타인명의 계좌일 경우 입력하세요</em></label>
						</div>
					</div>
				</div>

			</div>


              <div class="card mb-3">
                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-2">
                    <div class="col-auto">
                      <h3 class="text-body-emphasis">협력사정보</h3>
                    </div>
                  </div>
                </div>

                <div class="card-body py-0 scrollbar to-do-list-body">

								<div class="d-flex hover-actions-trigger py-3 border-translucent border-top">
									<div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer">
										<div class="col-12">

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">협력사명</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style="">${myInfoVO.cooperatorNm}</span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">상호</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style="">${myInfoVO.companyNm}</span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">사업자등록번호</label>
												</div>
												<div class="col-auto d-flex">
													<span id="strRegistrationSn" class="fs-9 mb-2" style="">${myInfoVO.registrationSn}</span>
												</div>
											</div>

											<div class="row justify-content-between mb-1 mb-md-0 d-flex align-items-center lh-1">
												<div class="col-auto">
													<label class="form-check-label mb-2 mb-md-0 fs-9 me-2 line-clamp-1 text-body cursor-pointer">대표자</label>
												</div>
												<div class="col-auto d-flex">
													<span class="fs-9 mb-2" style="">${myInfoVO.ceoNm}</span>
												</div>
											</div>


										</div>
									</div>
								</div>

							</div>
            </div>



          </div>
         </div>
       </div>
	</div>
</main>



  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>


	<!-- 숨겨진 폼 -->
	<form id="myForm" action="" method="POST"style="display: none;">
	</form>


    <form name="form_chk" method="post">
        <input type="hidden" name="m" value="service"/>
        <input type="hidden" name="token_version_id"/>
        <input type="hidden" name="enc_data"/>
        <input type="hidden" name="integrity_value"/>
    </form>

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