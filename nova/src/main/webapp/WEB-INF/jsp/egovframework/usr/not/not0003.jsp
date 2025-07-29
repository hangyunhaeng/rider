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

		if('${loginVO.authorCode}' =='ROLE_ADMIN'){
			$('nav > ul').find('li[class!=cooperator]:hidden').show();
		}
		if('${loginVO.authorCode}' =='ROLE_USER'){
			$('nav > ul').find('li[class~=cooperator]:hidden').show();
		}

		//이벤트 설정
		$("#목록버튼").on("click", function(e){
			goList();
		});
		$("#수정버튼").on("click", function(e){
			addBoard($("#notId").val());
		});
		$("#삭제버튼").on("click", function(e){
			delBoard();
		});

		$('#summernote').append(replaceRevTag("${one.longtxt}"));
		$('#startDt').append(getStringDate("${one.startDt}"));
		$('#endDt').append(getStringDate("${one.endDt}"));

		$('#summernote').find('img').attr("width", "100%");

		var notType;
		if("${one.notType}" == 'AL')
			notType = "전체";
		if("${one.notType}" == 'AC')
			notType = "운영사 → 협력사";
		if("${one.notType}" == 'AR')
			notType = "운영사 → 라이더";
		if("${one.notType}" == 'CC')
			notType = "협력사 → 협력사";
		if("${one.notType}" == 'CR')
			notType = "협력사 → 라이더";

		$('#notType').append(notType);

		if("${one.modifyAuth}" == "Y"){
			$("#수정버튼").show();
			$("#삭제버튼").show();
		}
	});

	function goList(){
		$('#myForm').attr("action", "/usr/not0001.do");
		$('#myForm').append($("<input/>", {type:"hidden", name:"schIdx", value:${noticeVO.schIdx}}));
		$('#myForm').submit();
	}
	//페이지 이동
	function addBoard(notId) {
		$('#myForm').attr("action", "/usr/not0002.do");
		$('#myForm').append($("<input/>", {type:"hidden", name:"notId", value:notId}));
		$('#myForm').append($("<input/>", {type:"hidden", name:"schIdx", value:${noticeVO.schIdx}}));
		$('#myForm').submit();
	}

	function delBoard(){
		if(confirm("삭제하시겠습니까?")){
			const params = new URLSearchParams();
			params.append('notId', $('#notId').val());

			// 로딩 시작
	        $('.loading-wrap--js').show();
	        axios.post('${pageContext.request.contextPath}/usr/not0002_0004.do',params).then(function(response) {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	            if(chkLogOut(response.data)){
	            	return;
	            }

	        	if(response.data.resultCode == "success"){
	        		alert('삭제되었습니다');
	        		goList();
	        	} else {
	        		if(response.data.resultMsg != null && response.data.resultMsg != ''){
	        			alert(response.data.resultMsg);
	        		} else {
	        			alert("삭제 실패하였습니다");
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
		<p class="tit">공지사항</p>

		<input name="pageUnit" type="hidden" value="1000" /> <input
			name="pageSize" type="hidden" value="1000" />
		<!--과제관리_목록 -->
		<div class="search_box ty2">

				<input id="notId" type="hidden" style="display:none;" value="${one.notId}">
				<div style="margin-bottom:10px;">
					<span class="pagetotal" style='margin-right: 20px;'></span>
					<div class="btnwrap">
						<button id="수정버튼" class="btn btn-primary" style="display:none;">수정</button>
						<button id="삭제버튼" class="btn btn-primary" style="display:none;">삭제</button>
						<button id="목록버튼" class="btn btn-primary">목록</button>
					</div>
				</div>

				<table>
					<colgroup>
						<col style="width: 13%">
						<col style="width: 17%">
						<col style="width: 13%">
						<col style="width: 17%">
						<col style="width: 13%">
						<col style="width: *">
					</colgroup>
					<tr>
						<th>제목</th>
						<td colspan='5'>
							<sm id="title">${one.title}</sm>
						</td>
					</tr>
					<tr>
						<th>공지시작</th>
						<td>
							<sm id="startDt"></sm>
						</td>
						<th>공지종료</th>
						<td>
							<sm id="endDt"></sm>
						</td>
						<th>공지대상</th>
						<td>
							<sm id="notType"></sm>
						</td>
					</tr>
<!-- 					<tr> -->
<!-- 						<th>첨부파일</th> -->
<!-- 						<td colspan='5'> -->
<!-- 							<input id="atchFileId" type="file" name="atchFileId" multiple="multiple" class="btn ty2" style="width:100%;"/> -->
<!-- 						</td> -->
<!-- 					</tr> -->
				</table>

			<br>

			<div style="float: left; width: 100%;">


				<div class="ib_product">
					<div class="post-form" id="summernote">

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