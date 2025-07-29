<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../inc/header.jsp" />

	<!-- phoenix -->
	<script src="<c:url value='/vendor/admin/bootstrap/js/bootstrap.min.js' />"></script>
    <script src="<c:url value='/js/phoenix/simplebar.min.js' />"></script>
    <script src="<c:url value='/js/phoenix/config.js' />"></script>
    <link href="<c:url value='/css/phoenix/choices.min.css' />" rel="stylesheet">
    <link href="<c:url value='/css/phoenix/dhtmlxgantt.css' />" rel="stylesheet">
    <link href="<c:url value='/css/phoenix/flatpickr.min.css' />" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com/">
    <link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin="">
    <link href="<c:url value='/css/phoenix/css2.css' />" rel="stylesheet">
    <link href="<c:url value='/css/phoenix/simplebar.min.css' />" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/phoenix/line.css' />">
    <link href="<c:url value='/css/phoenix/theme-rtl.min.css' />" type="text/css" rel="stylesheet" id="style-rtl" disabled="true">
    <link href="<c:url value='/css/phoenix/theme.min.css' />" type="text/css" rel="stylesheet" id="style-default">
    <link href="<c:url value='/css/phoenix/user-rtl.min.css' />" type="text/css" rel="stylesheet" id="user-style-rtl" disabled="true">
    <link href="<c:url value='/css/phoenix/user.min.css' />" type="text/css" rel="stylesheet" id="user-style-default">

</head>
<script type="text/javaScript">

	//onLoad
	document.addEventListener('DOMContentLoaded', function() {
		loadNotice();
		if('${loginVO.authorCode}' =='ROLE_ADMIN'){
			$('nav > ul').find('li[class!=cooperator]:hidden').show();
		}
		if('${loginVO.authorCode}' =='ROLE_USER'){
			$('nav > ul').find('li[class~=cooperator]:hidden').show();
		}
	});
	function loadNotice(){

		const params = new URLSearchParams();
        axios.post('${pageContext.request.contextPath}/usr/rot0001_0001.do',params).then(function(response) {

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){

				drawNotice(response.data.list);

        	}
        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {

        });
	}
	function drawNotice(list){

		if(list.length > 0){
			for(var i = 0 ; i < list.length ; i++){

				$('#notList').append(
		         '<div class="d-flex hover-actions-trigger py-3 border-translucent border-top" onclick="notView(this)">'
		         +'   <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer" data-bs-toggle="modal" data-bs-target="#exampleModal">'
		         +'     <div class="col-12 col-md-auto col-xl-12 col-xxl-auto">'
		         +'       <div class="mb-1 mb-md-0 d-flex align-items-center lh-1">'
		         +'       	<input type="hidden" name="notId" value="'+list[i].notId+'">'
		         +'			<label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-8 me-2 line-clamp-1 text-body cursor-pointer">'+list[i].title+'</label></div>'
		         +'     </div>'
		         +'   </div>'
		         +'</div>'
		         );

			}
		} else {
			noNotice.append("공지사항이 없습니다")
		}
	}
	function notView(obj){


		const params = new URLSearchParams();
		params.append("notId", $(obj).find("input").val());

        axios.post('${pageContext.request.contextPath}/usr/not0002_0003.do',params).then(function(response) {

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){
        		$('#title').text('');
        		$('#longtxt').text('');
         		$('#title').append(response.data.one.title);
         		$('#longtxt').append(replaceRevTag(response.data.one.longtxt));

         		$('#notList').find('img').attr("width", "100%");
        	}
        })
        .catch(function(error) {
            console.error('There was an error fetching the data:', error);
        }).finally(function() {

        });
	}

</script>
<body class="index-page">

	<jsp:include page="../inc/nav.jsp" />

	<!-- 숨겨진 폼 -->
	<form id="myForm" action="/conv/conv02410.do" method="POST"
		style="display: none;">
		<!-- <input type="hidden" name=taskNo id="taskNo"> -->
	</form>

	<div class="keit-header-body innerwrap clearfix">
		<p class="tit"></p>

		<input name="pageUnit" type="hidden" value="1000" /> <input
			name="pageSize" type="hidden" value="1000" />
		<!--과제관리_목록 -->
		<div class="search_box ty2" style="height:200px;">

			<div class="card todo-list h-100">
                <div class="card-header border-bottom-0 pb-0">
                  <div class="row justify-content-between align-items-center mb-4">
                    <div class="col-auto">
                      <h3 class="text-body-emphasis">공지사항</h3>
                      <p class="mb-2 mb-md-0 mb-lg-2 text-body-tertiary" id="noNotice"></p>
                    </div>
                    <div class="col-auto w-100 w-md-auto">
                      <div class="row align-items-center g-0 justify-content-between">
                        <div class="col-12 col-sm-auto">
                          <div class="search-box w-100 mb-2 mb-sm-0" style="max-width:30rem;">
                          </div>
                        </div>
                        <div class="col-auto d-flex">
                          <p class="mb-0 ms-sm-3 fs-9 text-body-tertiary fw-bold">
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="card-body py-0 scrollbar to-do-list-body" id="notList">

<!--                   <div class="d-flex hover-actions-trigger py-3 border-translucent border-top"> -->
<!--                     <div class="row justify-content-between align-items-md-center btn-reveal-trigger border-translucent gx-0 flex-1 cursor-pointer" data-bs-toggle="modal" data-bs-target="#exampleModal"> -->
<!--                       <div class="col-12 col-md-auto col-xl-12 col-xxl-auto"> -->
<!--                         <div class="mb-1 mb-md-0 d-flex align-items-center lh-1"><label class="form-check-label mb-1 mb-md-0 mb-xl-1 mb-xxl-0 fs-8 me-2 line-clamp-1 text-body cursor-pointer">Designing the dungeon</label></div> -->
<!--                       </div> -->
<!--                     </div> -->
<!--                   </div> -->

				<!-- 팝업 -->
                  <div class="modal fade" id="exampleModal" tabindex="-1" style="display: none;" aria-hidden="true">
                    <div class="modal-dialog modal-xl">
                      <div class="modal-content bg-body overflow-hidden">
                        <div class="modal-header justify-content-between px-6 py-5 pe-sm-5 px-md-6 dark__bg-gray-1100">
                          <h3 class="text-body-highlight fw-bolder mb-0" id="title">Designing the Dungeon Blueprint</h3>
                          <button style="min-width:50px!important; min-height:50px!important;" class="btn btn-phoenix-secondary btn-icon btn-icon-xl flex-shrink-0" type="button" data-bs-dismiss="modal" aria-label="Close"><svg class="svg-inline--fa fa-xmark" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="xmark" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512" data-fa-i2svg=""><path fill="currentColor" d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z"></path></svg></button>
                        </div>
                        <div class="modal-body bg-body-highlight px-6 py-0">
                          <div class="row gx-14">
                            <div class="col-12 border-end-lg">
                              <div class="py-6">
                                <div class="mb-7">
<!--                                   <div class="d-flex align-items-center mb-3"> -->
<!--                                     <h4 class="text-body me-3">Description</h4> -->
<!--                                   </div> -->
                                  <p class="text-body-highlight mb-0" id="longtxt">The female circus horse-rider is a recurring subject in Chagall’s work. In 1926 the art dealer Ambroise Vollard invited Chagall to make a project based on the circus. They visited Paris’s historic Cirque d’Hiver Bouglione together; Vollard lent Chagall his private box seats. Chagall completed 19 gouaches Chagall’s work. In 1926 the art dealer Ambroise Vollard invited Chagall to make a project based on the circus.</p>
                                </div>
                                <div class="mb-3">
                                  <div>
                                    <h4 class="mb-3">Files</h4>
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