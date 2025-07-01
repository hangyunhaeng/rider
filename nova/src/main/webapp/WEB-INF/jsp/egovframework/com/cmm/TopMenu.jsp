<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.default.css' /> ">
<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.style.css' />">

<script type="text/javascript"	src="<c:url value='/web2/js/function.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/keit.custom.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/jquery-1.11.2.min.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/keit.jquery.ui.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/kaia.pbCommon.js' />"></script>

<link rel="stylesheet" href="/ag-grid/ag-grid.css">
<link rel="stylesheet" href="/ag-grid/ag-theme-alpine.css">
<link rel="stylesheet" href="/ag-grid/ag-custom.css">
<script src="/ag-grid/ag-grid-community.noStyle.js"></script>
<script src="/ag-grid/ag-grid-community.js"></script>
<script src="/ag-grid/ag-custom-header.js"></script>
<script src="/js/xlsx.full.min.js"></script>
<script src="/js/xlsx-populate.min.js"></script>

<script src="/js/axios.min.js"></script>

<link rel="stylesheet" href="/css/flatpickr.min.css">
<script src="/js/flatpickr.min.js"></script>
<script src="/js/ko.js"></script>


<c:set var="taskNo" value="${sessionScope.taskVo}" />
<div class="fixed-header">
	<form name='menuTop1' method='post'>
		<input type="hidden" name="taskNo" value="${taskVo.taskNo}">
			<header class="keit-header">
				<div class="keit-header innerwrap clearfix">
					<a href="/" class="keit-logo ir keit-sprite" title="사업비관리시스템" target="_top">사업비관리시스템</a>
					<div class="keit-header-aside fr clearfix">
						<span class="keit-sitemap ir keit-sprite fl"></span>
					</div>
					<c:if test="${loginVO != null}">
						<nav class="fr">
							<ul id="gnb" class="clearfix">
								<!-- //menu1 -->
								<li class="keit-gnb-item"><a href="#gnb02">협약관리</a>
									<div id="gnb02" class="gnbDiv" style="top:70px;">
										<div class="layerWrap">
											<div class="section">
												<div class="areas">
													<div class="area">
														<h3>과제관리</h3>
														<ul class="dep2">
															<li><a href="javascript:goSubPage('/comm/comm00800.do')">과제목록</a></li>
															<li><a href="javascript:goSubPage('/conv/conv02410.do')">과제상세정보</a></li>
															<li><a href="javascript:goSubPage('/conv/conv02510.do')">비목별예산</a></li>
															<li><a href="javascript:goSubPage('/conv/conv02610.do')">계좌정보</a></li>
															<li><a href="javascript:goSubPage('/conv/conv02710.do')">참여연구원</a></li>
														</ul>
													</div>
													<div class="area ir txtr">
														<img src="/web2/images/gnb-space-sprite_02.png" alt="">
													</div>
												</div>
												<div class="gnb-slide-control">
													<div class="innerwrap">
														<span class="on">협약관리</span>
														<a href="#gnb04" class="next">집행관리</a>
														<button type="button" class="close">닫기</button>
													</div>
												</div>
												<!-- //slideLinks -->
											</div>
										</div>
									</div></li>

								<li class="keit-gnb-item"><a href="#gnb04">집행관리</a>
									<div id="gnb04" class="gnbDiv" style="top:70px;">
										<div class="layerWrap">
											<div class="section">
												<div class="areas">
													<div class="area">
														<h3>집행</h3>
														<ul class="dep2">
															<li><a href="javascript:goSubPage('/exec/exec01010.do')">집행내역 조회</a></li>
															<li><a href="javascript:goSubPage('/exec/exec02010.do')">세부비목별 내역서</a></li>
														</ul>
													</div>
													<div class="area">
														<h3>예실대비표</h3>
														<ul class="dep2">
															<li><a href="javascript:goSubPage('/exec/exec03010.do')">예산실적대비표</a></li>
														</ul>
													</div>
													<div class="area ir txtr">
														<img src="/web2/images/gnb-space-sprite_04.png" alt="">
													</div>
												</div>
												<div class="gnb-slide-control">
													<div class="innerwrap">
														<a href="#gnb02" class="prev">협약관리</a> <span class="on">집행관리</span>
														<button type="button" class="close">닫기</button>
													</div>
												</div>
												<!-- //slideLinks -->
											</div>
										</div>
									</div>
								</li>
							</ul>
						</nav>
				</c:if>
			</div>
			<div class="sitemap_wrap" id="sitemap" style="display: none;">
				<div class="allmenu_area">
					<div class="allmenu_top">
						<h2>전체메뉴</h2>
						<a href="#none" class="btn_close">닫기</a>
					</div>
					<div class="allmenu_box">
						<dl>
							<dt>협약관리</dt>
							<dd>
								<div class="area">
									<div class="areain" style="height: 247px;">
										<h3>과제관리</h3>
										<ul class="dep2">
											<li><a href="javascript:goSubPage('/comm/comm00800.do')">과제목록</a></li>
											<li><a href="javascript:goSubPage('/conv/conv02410.do')">과제상세정보</a></li>
											<li><a href="javascript:goSubPage('/conv/conv02510.do')">비목별예산</a></li>
											<li><a href="javascript:goSubPage('/conv/conv02610.do')">계좌정보</a></li>
											<li><a href="javascript:goSubPage('/conv/conv02710.do')">참여연구원</a></li>
										</ul>
									</div>
								</div>
							</dd>
						</dl>
						<dl>
							<dt>집행관리</dt>
							<dd>
								<div class="area">
									<div class="areain" style="height: 151px;">
										<h3>사업비집행</h3>
										<ul class="dep2">
											<li><a href="javascript:goSubPage('/exec/exec01010.do')">집행내역 조회</a></li>
											<li><a href="javascript:goSubPage('/exec/exec02010.do')">세부비목별 내역서</a></li>
										</ul>
									</div>
								</div>
								<div class="area">
									<div class="areain" style="height: 151px;">
										<h3>예실대비표</h3>
										<ul class="dep2">
											<li><a href="javascript:goSubPage('/exec/exec03010.do')">예산실적대비표</a></li>
										</ul>
									</div>
								</div>
							</dd>
						</dl>
					</div>
				</div>
			</div>

		</header>
	</form>
</div>