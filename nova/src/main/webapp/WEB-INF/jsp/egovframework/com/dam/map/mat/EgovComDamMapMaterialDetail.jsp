<%
 /**
  * @Class Name  : EgovComDamMapMaterialDetail.jsp
  * @Description : EgovComDamMapMaterialDetail 화면
  * @Modification Information
  * @
  * @ 수정일             수정자           수정내용
  * @ ----------  --------  ---------------------------
  * @ 2010.08.12  박종선          최초 생성
  *   2018.09.11  신용호          공통컴포넌트 3.8 개선
  *
  *  @author 공통서비스팀 
  *  @since 2010.05.01
  *  @version 1.0
  *  @see
  *  
  *  Copyright (C) 2009 by MOPAS  All right reserved.
  */
%>

<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8">
		<title><spring:message code="comDamMapMat.comDamMapMaterialDetail.title"/></title><!-- 지식맵(유형별) 상세조회 -->
		<link href="<c:url value="/css/egovframework/com/com.css"/>" rel="stylesheet" type="text/css">
		<link href="<c:url value="/css/egovframework/com/button.css"/>" rel="stylesheet" type="text/css">				
		
		<script type="text/javaScript">
		<!--
		/* ********************************************************
		 * 초기화
		 ******************************************************** */
		function fnInit(){
		}
		/* ********************************************************
		 * 목록 으로 가기
		 ******************************************************** */
		function fnList(){
			location.href = "<c:url value='/dam/map/mat/EgovComDamMapMaterialList.do'/>";
		}
		/* ********************************************************
		 * 수정화면으로  바로가기
		 ******************************************************** */
		function fnModify(){
			var varForm				 = document.all["Form"];
			varForm.action           = "<c:url value='/dam/map/mat/EgovComDamMapMaterialModify.do'/>";
			varForm.knoTypeCd.value   = "${result.knoTypeCd}";
			varForm.submit();
		}
		/* ********************************************************
		 * 삭제 처리 함수
		 ******************************************************** */
		function fnDelete(){
			if (confirm("<spring:message code="common.delete.msg" />")) {
				var varForm				 = document.all["Form"];
				varForm.action           = "<c:url value='/dam/map/mat/EgovComDamMapMaterialRemove.do'/>";
				varForm.knoTypeCd.value   = "${result.knoTypeCd}";
				varForm.submit();
			}
		}
		-->
		</script>
	</head>
	
	<body>
	
	<!-- 자바스크립트 경고 태그  -->
	<noscript class="noScriptTitle"><spring:message code="common.noScriptTitle.msg" /></noscript><!-- 자바스크립트를 지원하지 않는 브라우저에서는 일부 기능을 사용하실 수 없습니다. -->
	
	<form name="Form" action="<c:url value='/dam/map/mat/EgovComDamMapMaterialModify.do'/>" method="post">
	<input name="knoTypeCd" type="hidden">
	
	<div class="wTableFrm">
		<!-- 타이틀 -->
		<h2><spring:message code="comDamMapMat.comDamMapMaterialDetail.pageTop.title"/></h2><!-- 지식맵(유형별) 상세조회 -->
	
		<!-- 등록폼 -->
		<table class="wTable">
			<colgroup>
				<col style="width:16%" />
				<col style="" />
			</colgroup>
			<tr>
				<th><spring:message code="comDamMapMat.comDamMapMaterialDetail.orgnztId"/> <span class="pilsu">*</span></th><!-- 조직ID -->
				<td class="left">
				    ${result.orgnztId}
				</td>
			</tr>
			<tr>
				<th><spring:message code="comDamMapMat.comDamMapMaterialDetail.orgnztNm"/> <span class="pilsu">*</span></th><!-- 조직명 -->
				<td class="left">
				    ${result.orgnztNm}
				</td>
			</tr>
			<tr>
				<th><spring:message code="comDamMapMat.comDamMapMaterialDetail.knoTypeCd"/> <span class="pilsu">*</span></th><!-- 지식유형코드 -->
				<td class="left">
				    ${result.knoTypeCd}
				</td>
			</tr>
			<tr>
				<th><spring:message code="comDamMapMat.comDamMapMaterialDetail.knoTypeNm"/> <span class="pilsu">*</span></th><!-- 지식유형명 -->
				<td class="left">
				    ${result.knoTypeNm}
				</td>
			</tr>
			<tr>
				<th><spring:message code="comDamMapMat.comDamMapMaterialDetail.knoUrl"/> <span class="pilsu">*</span></th><!-- 지식URL -->
				<td class="left">
				    ${result.knoUrl}
				</td>
			</tr>
			<tr>
				<th><spring:message code="comDamMapMat.comDamMapMaterialDetail.clYmd"/> <span class="pilsu">*</span></th><!-- 분류일자 -->
				<td class="left">
				    ${result.clYmd}
				</td>
			</tr>
		</table>
	
		<!-- 하단 버튼 -->
		<div class="btn">
			<input class="s_submit" type="submit" value='<spring:message code="button.update" />' onclick="fnModify(); return false;" /><!-- 수정 -->
			<input class="s_submit" type="submit" value='<spring:message code="button.delete" />' onclick="fnDelete(); return false;" /><!-- 삭제 -->
			<input class="s_submit" type="submit" value='<spring:message code="button.list" />' onclick="fnList(); return false;" /><!-- 목록 -->
		</div>
		<div style="clear:both;"></div>
	</div>
	
	</form>	
	</body>
</html>