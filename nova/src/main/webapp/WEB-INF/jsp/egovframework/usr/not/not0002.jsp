<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="../inc/header.jsp" />


<!-- // 서머노트에 text 쓰기 -->
<!-- $('#summernote').summernote('insertText', 써머노트에 쓸 텍스트); -->

<!-- // 서머노트 쓰기 비활성화 -->
<!-- $('#summernote').summernote('disable'); -->

<!-- // 서머노트 쓰기 활성화 -->
<!-- $('#summernote').summernote('enable'); -->

<!-- // 서머노트 리셋 -->
<!-- $('#summernote').summernote('reset'); -->

<!-- // 마지막으로 한 행동 취소 ( 뒤로가기 ) -->
<!-- $('#summernote').summernote('undo'); -->
<!-- // 앞으로가기 -->
<!-- $('#summernote').summernote('redo'); -->
	<link href="<c:url value='/vendor/admin/bootstrap/3.4.1/bootstrap.min.css' />" rel="stylesheet">
	<script src="<c:url value='/vendor/admin/bootstrap/3.4.1/bootstrap.min.js' />"></script>

	<!-- include summernote css/js -->
<!-- 	<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet"> -->
<!-- 	<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script> -->


	<link href="<c:url value='/summernote/summernote.min.css' />" rel="stylesheet">
	<script src="<c:url value='/summernote/summernote.min.js' />"></script>

</head>
<script type="text/javaScript">


	var startDt;
	var endDt;
	//onLoad
	document.addEventListener('DOMContentLoaded', function() {

		if('${loginVO.authorCode}' =='ROLE_ADMIN'){
			$('nav > ul').find('li[class!=cooperator]:hidden').show();
		}
		if('${loginVO.authorCode}' =='ROLE_USER'){
			$('nav > ul').find('li[class~=cooperator]:hidden').show();
		}

		//업로드일 세팅
		var today = new Date();
		startDt = flatpickr("#startDt", {
			locale: "ko",
			allowInput: false,
		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
		    dateFormat: 'Y-m-d',     // date format 형식
		    disableMobile: true          // 모바일 지원

		});
		startDt.setDate(today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate());


		endDt = flatpickr("#endDt", {
			locale: "ko",
			allowInput: false,
		    altInput: true,              // 기존 입력을 숨기고 새 입력을 만듦
		    altFormat: 'Y-m-d',      // 날짜 선택 후 표시 형태
		    dateFormat: 'Y-m-d',     // date format 형식
		    disableMobile: true          // 모바일 지원

		});
		endDt.setDate("9999-12-31");

		putOption();

		//이벤트 설정
		$("#저장버튼").on("click", function(e){
			saveBoard();
		});
		$("#삭제버튼").on("click", function(e){
			delBoard();
		});
		$("#목록버튼").on("click", function(e){
			goList();
		});

		$('#summernote').summernote({

			  // 에디터 크기 설정
			  height: 500,
			  // 에디터 한글 설정
			  lang: 'ko-KR',
			  // 에디터에 커서 이동 (input창의 autofocus라고 생각하시면 됩니다.)
			  toolbar: [
				    // 글자 크기 설정
				    ['fontsize', ['fontsize']],
				    // 글자 [굵게, 기울임, 밑줄, 취소 선, 지우기]
				    ['style', ['bold', 'italic', 'underline','strikethrough', 'clear']],
				    // 글자색 설정
				    ['color', ['color']],
				    // 표 만들기
				    ['table', ['table']],
				    // 서식 [글머리 기호, 번호매기기, 문단정렬]
				    ['para', ['ul', 'ol', 'paragraph']],
				    // 줄간격 설정
				    ['height', ['height']],
				    // 이미지 첨부
				    ['insert',['picture']]
				  ],
				  // 추가한 글꼴
				fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋음체','바탕체'],
				 // 추가한 폰트사이즈
				fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72','96'],
		        // focus는 작성 페이지 접속시 에디터에 커서를 위치하도록 하려면 설정해주세요.
				focus : true,
		        // callbacks은 이미지 업로드 처리입니다.
				callbacks : {
					onImageUpload : function(files, editor, welEditable) {
		                // 다중 이미지 처리를 위해 for문을 사용했습니다.
						for (var i = 0; i < files.length; i++) {
							imageUploader(files[i], this);
						}
					}
				}

		  });

		loadNotice();



	});

	function loadNotice(){
		if("${noticeVO.notId}" != ''){
			const params = new URLSearchParams();
			params.append("notId", "${noticeVO.notId}");
			// 로딩 시작
	        $('.loading-wrap--js').show();
	        axios.post('${pageContext.request.contextPath}/usr/not0002_0003.do',params).then(function(response) {

	            if(chkLogOut(response.data)){
	            	return;
	            }

	        	if(response.data.resultCode == "success"){

	        		if('${loginVO.authorCode}' == 'ROLE_ADMIN'){
	         			$('#notType').append("<option value='CC'>협력사 → 협력사</option>");
	         			$('#notType').append("<option value='CR'>협력사 → 라이더</option>");
	         			$('#notType').attr("readonly", true);
	         			$('#notType').attr("disabled", true);
	        		}

	        		$('#notId').val(response.data.one.notId);
					$('#title').val(response.data.one.title);
					startDt.setDate(getStringDate(response.data.one.startDt));
					endDt.setDate(getStringDate(response.data.one.endDt));
					$('#notType').val(response.data.one.notType);
	        		$('#summernote').summernote('reset');
	        		$('#summernote').summernote('code', replaceRevTag(response.data.one.longtxt));

	        		if(response.data.one.modifyAuth == "Y"){
	        			$("#삭제버튼").show();
	        			$("#저장버튼").show();
	        		}

	        	}
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
	        })
	        .catch(function(error) {
	            console.error('There was an error fetching the data:', error);
	        }).finally(function() {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
	        });
		} else {
			$("#저장버튼").show();
		}
	}


	function imageUploader(file, el) {
		var formData = new FormData();
		formData.append('fileName', file);

		// 로딩 시작
        $('.loading-wrap--js').show();
		$.ajax({
			data : formData,
			type : "POST",
	        // url은 자신의 이미지 업로드 처리 컨트롤러 경로로 설정해주세요.
			url : '/usr/not0002_0001.do',
			contentType : false,
			processData : false,
			enctype : 'multipart/form-data',
			success : function(data) {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();

	            if(chkLogOut(data)){
	            	return;
	            }

				$(el).summernote('insertImage', "${pageContext.request.contextPath}"+"/upload/"+data.name, function($image) {
// 					$image.css('width', "100%");
				});

			},
			error : function(data) {
	        	// 로딩 종료
	            $('.loading-wrap--js').hide();
			}
		});
	}

	function saveBoard(){
		const params = new URLSearchParams();
		params.append('notId', $('#notId').val());
		params.append('title', $('#title').val());
		params.append('longtxt', $('#summernote').summernote('code'));
		params.append('notType', $('#notType').val());
		params.append('startDt',$('#startDt').val().replace(/[^0-9]/g, ""));
		params.append('endDt',$('#endDt').val().replace(/[^0-9]/g, ""));
		params.append('useAt', "Y");

		if($('#title').val().trim() == ''){
			alert('제목을 입력하세요');
			return;
		}
		if($('#summernote').summernote('code').trim() == ''){
			alert('내용을 입력하세요');
			return;
		}

		// 로딩 시작
        $('.loading-wrap--js').show();
        axios.post('${pageContext.request.contextPath}/usr/not0002_0002.do',params).then(function(response) {
        	// 로딩 종료
            $('.loading-wrap--js').hide();

            if(chkLogOut(response.data)){
            	return;
            }

        	if(response.data.resultCode == "success"){

        		$('#summernote').summernote('reset');
        		$('#summernote').summernote('code', replaceRevTag(response.data.one.longtxt));
        		alert('저장되었습니다');
        		goList();
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

	function goList(){
		$('#myForm').attr("action", "/usr/not0001.do");
		$('#myForm').append($("<input/>", {type:"hidden", name:"schIdx", value:${noticeVO.schIdx}}));
		$('#myForm').submit();
	}


	function putOption(){
		if('${loginVO.authorCode}' == 'ROLE_ADMIN'){
			$('#notType').append("<option value='AL'>전체</option>");
			$('#notType').append("<option value='AC'>운영사 → 협력사</option>");
			$('#notType').append("<option value='AR'>운영사 → 라이더</option>");
// 			$('#notType').append("<option value='CC'>협력사 → 협력사</option>");
// 			$('#notType').append("<option value='CR'>협력사 → 라이더</option>");

		} else {
			$('#notType').append("<option value='CC'>협력사 → 협력사</option>");
			$('#notType').append("<option value='CR'>협력사 → 라이더</option>");
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


				<div style="margin-bottom:10px;">
					<span class="pagetotal" style='margin-right: 20px;'></span>
					<div class="btnwrap">
						<button id="저장버튼" class="btn btn-primary" style="display:none;">저장</button>
						<button id="삭제버튼" class="btn btn-primary" style="display:none;">삭제</button>
						<button id="목록버튼" class="btn btn-primary">목록</button>
						<input id="notId" name="notId" type=hidden value="">
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
							<input id="title" name="title" type=text value="">
						</td>
					</tr>
					<tr>
						<th>공지시작</th>
						<td>
							<input id="startDt" class="form-control search fs-9" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
						</td>
						<th>공지종료</th>
						<td>
							<input id="endDt" class="form-control search fs-9" type="date" placeholder="Search" aria-label="Search" _mstplaceholder="181961" _mstaria-label="74607">
						</td>
						<th>공지대상</th>
						<td>
							<select name='notType' style='width: 100%;height:22px; padding:0 5px;' id='notType' class="form-control search fs-9 flatpickr-input"></select>
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
					<div class="post-form">
						<textarea name="postContent" id="summernote">
						</textarea>
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