<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />


<link rel="apple-touch-icon" sizes="57x57" href="<c:url value='/images/fav/apple-icon-57x57.png' />">
<link rel="apple-touch-icon" sizes="60x60" href="<c:url value='/images/fav/apple-icon-60x60.png' />">
<link rel="apple-touch-icon" sizes="72x72" href="<c:url value='/images/fav/apple-icon-72x72.png' />">
<link rel="apple-touch-icon" sizes="76x76" href="<c:url value='/images/fav/apple-icon-76x76.png' />">
<link rel="apple-touch-icon" sizes="114x114" href="<c:url value='/images/fav/apple-icon-114x114.png' />">
<link rel="apple-touch-icon" sizes="120x120" href="<c:url value='/images/fav/apple-icon-120x120.png' />">
<link rel="apple-touch-icon" sizes="144x144" href="<c:url value='/images/fav/apple-icon-144x144.png' />">
<link rel="apple-touch-icon" sizes="152x152" href="<c:url value='/images/fav/apple-icon-152x152.png' />">
<link rel="apple-touch-icon" sizes="180x180" href="<c:url value='/images/fav/apple-icon-180x180.png' />">
<link rel="icon" type="image/png" sizes="192x192"  href="<c:url value='/images/fav/android-icon-192x192.png' />">
<link rel="icon" type="image/png" sizes="32x32" href="<c:url value='/images/fav/favicon-32x32.png' />">
<link rel="icon" type="image/png" sizes="96x96" href="<c:url value='/images/fav/favicon-96x96.png' />">
<link rel="icon" type="image/png" sizes="16x16" href="<c:url value='/images/fav/favicon-16x16.png' />">
<link rel="manifest" href="/manifest.json">
<meta name="msapplication-TileColor" content="#ffffff">
<meta name="msapplication-TileImage" content="/ms-icon-144x144.png">
<meta name="theme-color" content="#ffffff">


<!-- Fonts -->
<link href="https://fonts.googleapis.com" rel="preconnect">
<link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">

<!-- Vendor CSS Files -->
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

<script type="text/javascript"	src="<c:url value='/js/admin/util.js?v=0.1' />"></script>


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
<%-- 	<link href="<c:url value='/vendor/admin/bootstrap/3.4.1/bootstrap.min.css' />" rel="stylesheet"> --%>
<!-- 	<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script> -->



	<!-- phoenix -->
	<script src="<c:url value='/vendor/admin/bootstrap/js/bootstrap.min.js' />"></script>
    <script src="<c:url value='/js/phoenix/simplebar.min.js' />"></script>
    <script src="<c:url value='/js/phoenix/config.js' />"></script>
    <link href="<c:url value='/css/phoenix/choices.min.css' />" rel="stylesheet">
    <link href="<c:url value='/css/phoenix/dhtmlxgantt.css' />" rel="stylesheet">
<%--     <link href="<c:url value='/css/phoenix/flatpickr.min.css' />" rel="stylesheet"> --%>
    <link rel="preconnect" href="https://fonts.googleapis.com/">
    <link rel="preconnect" href="https://fonts.gstatic.com/" crossorigin="">
    <link href="<c:url value='/css/phoenix/css2.css' />" rel="stylesheet">
    <link href="<c:url value='/css/phoenix/simplebar.min.css' />" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/phoenix/line.css' />">
    <link href="<c:url value='/css/phoenix/theme-rtl.min.css' />" type="text/css" rel="stylesheet" id="style-rtl" disabled="true">
    <link href="<c:url value='/css/phoenix/theme.min.css' />" type="text/css" rel="stylesheet" id="style-default">
    <link href="<c:url value='/css/phoenix/user-rtl.min.css' />" type="text/css" rel="stylesheet" id="user-style-rtl" disabled="true">
    <link href="<c:url value='/css/phoenix/user.min.css' />" type="text/css" rel="stylesheet" id="user-style-default">