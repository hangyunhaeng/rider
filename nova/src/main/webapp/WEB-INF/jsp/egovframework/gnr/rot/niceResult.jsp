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

	//onLoad
	document.addEventListener('DOMContentLoaded', function() {
		if("${resultCode}" == "success"){
			window.opener.goActStep2();
			window.close();
		} else {
			window.opener.alert(`${resultMsg}`);
			window.close();
		}
	});

	</script>

<body>





  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>


    <form name="form_chk" method="post">
        <input type="hidden" name="m" value="service"/>
        <input type="hidden" name="token_version_id"/>
        <input type="hidden" name="enc_data"/>
        <input type="hidden" name="integrity_value"/>
    </form>


  <!-- Vendor JS Files -->
  <script src="<c:url value='/vendor/admin/bootstrap/js/bootstrap.bundle.min.js' />"></script>
  <script src="<c:url value='/vendor/admin/php-email-form/validate.js' />"></script>
  <script src="<c:url value='/vendor/admin/aos/aos.js' />"></script>
  <script src="<c:url value='/vendor/admin/purecounter/purecounter_vanilla.js' />"></script>
  <script src="<c:url value='/vendor/admin/glightbox/js/glightbox.min.js' />"></script>
  <script src="<c:url value='/vendor/admin/swiper/swiper-bundle.min.js' />"></script>

  <!-- Main JS File -->
  <script src="<c:url value='/js/admin/main.js' />"></script>

</body>
</html>