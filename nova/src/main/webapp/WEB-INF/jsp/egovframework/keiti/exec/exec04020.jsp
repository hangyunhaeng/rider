<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><spring:message code="comCmm.unitContent.1" /></title>
<script type="text/javascript"	src="<c:url value='/web2/js/jquery-1.11.2.min.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/function.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/keit.jquery.ui.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/kaia.pbCommon.js' />"></script>
<script type="text/javascript"	src="<c:url value='/web2/js/keit.custom.js' />"></script>
<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.default.css' /> ">
<link type="text/css" rel="stylesheet"	href="<c:url value='/web2/css/keit.style.css' />">
<link rel="stylesheet" href="/ag-grid/ag-grid.css">
<link rel="stylesheet" href="/ag-grid/ag-theme-alpine.css">
<link rel="stylesheet" href="/web2/css/taxinvoice.css">
<script src="/ag-grid/ag-grid-community.noStyle.js"></script>
<script src="/ag-grid/ag-grid-community.js"></script>
<script src="/js/xlsx.full.min.js"></script>
<script src="/js/axios.min.js"></script>
<script type="text/javascript">
    // Java에서 전달된 JSON 데이터를 자바스크립트 객체로 변환
    var taxInvInfoData = JSON.parse('${taxInvInfoJson}');
    var taxInvInfo = taxInvInfoData.resultList[0];

 	// JSON 데이터를 자바스크립트 객체로 변환
    var taxInvInfoItmData = JSON.parse('${taxInvInfoItmJson}');
    var taxInvInfoItm = taxInvInfoItmData.resultList;
    // 각 ID에 맞게 값을 삽입하는 함수
    function populateTaxInfo() {
    	document.getElementById('issueId').innerText = taxInvInfo.issueId || ''; // 세금계산서 승인번호
    	document.getElementById('sndBsnRgN').innerText = taxInvInfo.sndBsnRgN || ''; // 공급자 사업자등록번호
    	document.getElementById('sndTxId').innerText = taxInvInfo.sndTxId || ''; // 공급어체 종사업장 식별코드
    	document.getElementById('rcvBsnRgN').innerText = taxInvInfo.rcvBsnRgN || ''; // 수신업체 사업자등록번호
    	document.getElementById('rcvTxId').innerText = taxInvInfo.rcvTxId || ''; // 수신업체 종사업장 식별코드
    	document.getElementById('sndName').innerText = taxInvInfo.sndName || ''; // 공급업체 사업체명
    	document.getElementById('sndRprsndNm').innerText = taxInvInfo.sndRprsndNm || ''; // 공금업체 대표자명
    	document.getElementById('rcvName').innerText = taxInvInfo.rcvName || ''; // 수신업체 사업체명
    	document.getElementById('rcvRprsNm').innerText = taxInvInfo.rcvRprsNm || ''; // 수신업체 대표자명
    	document.getElementById('sndAdr').innerText = taxInvInfo.sndAdr || ''; // 공급업체 주소
    	document.getElementById('rcvAdr').innerText = taxInvInfo.rcvAdr || ''; // 수신업체 주소
    	document.getElementById('sndBcnd').innerText = taxInvInfo.sndBcnd || ''; // 공급업체 업태
    	document.getElementById('sndItp').innerText = taxInvInfo.sndItp || ''; // 공급업체 업종
    	document.getElementById('rcvBcnd').innerText = taxInvInfo.rcvBcnd || ''; // 수신업체 업태
    	document.getElementById('rcvItp').innerText = taxInvInfo.rcvItp || ''; // 수신업체 업종
    	document.getElementById('sndChpEm').innerText = taxInvInfo.sndChpEm || ''; // 공급업체 담당자 이메일
    	document.getElementById('rcvChpEm').innerText = taxInvInfo.rcvChpEm || ''; // 수신업체 담당자 이메일
    	document.getElementById('rcvSubChpEm').innerText = taxInvInfo.rcvSubChpEm || ''; // 수신업체 담당자 이메일
    	document.getElementById('isD').innerText = taxInvInfo.isD || ''; // 전사세금계산서 작성일자
    	document.getElementById('supplyAmt').innerText = currencyFormatter(taxInvInfo.supplyAmt) || ''; // 총 공급가액
    	document.getElementById('taxAmt').innerText = currencyFormatter(taxInvInfo.taxAmt) || ''; // 총 세액
    	document.getElementById('mdfRsn').innerText = taxInvInfo.mdfRsn || ''; // 수정 사유 코드
    	document.getElementById('rmk').innerText = taxInvInfo.rmk || ''; // 비고
    	document.getElementById('totAmt').innerText = currencyFormatter(taxInvInfo.totAmt) || ''; // 총액 (공급가액 + 세액)
    	document.getElementById('csAmt').innerText = currencyFormatter(taxInvInfo.csAmt) || ''; // 현금 금액
    	document.getElementById('chkAmt').innerText = currencyFormatter(taxInvInfo.chkAmt) || ''; // 수표 금액
    	document.getElementById('bilAmt').innerText = currencyFormatter(taxInvInfo.bilAmt) || ''; // 어음 금액
    	document.getElementById('crdtAmt').innerText = currencyFormatter(taxInvInfo.crdtAmt) || ''; // 외상 금액
    	document.getElementById('prpsCd').innerText =  '이 금액을 (' + prpsCdFormatter(taxInvInfo.prpsCd || '') + ') 함'; // 영수/청구 구분자
    }

 // 데이터를 테이블에 추가하는 함수
    function populateTaxItems() {
        var tableBody = document.getElementById('divSubTaxDetail');

        // taxInvInfoItm 리스트에 담긴 데이터를 하나씩 처리
        taxInvInfoItm.forEach(function(item) {
            // 새로운 행(row) 생성
            var row = document.createElement('tr');

            // 월일 (splD)
            var cellSplD = document.createElement('td');
            cellSplD.innerText = item.splD || ''; // (월일)물품 공급일자
            row.appendChild(cellSplD);

            // 품목 (nm)
            var cellNm = document.createElement('td');
            cellNm.innerText = item.nm || ''; // (품목)물품명
            row.appendChild(cellNm);

            // 규격 (infoTxt)
            var cellInfoTxt = document.createElement('td');
            cellInfoTxt.innerText = item.infoTxt || ''; // (규격)물품에 대한 규격
            row.appendChild(cellInfoTxt);

            // 수량 (qty)
            var cellQty = document.createElement('td');
            cellQty.innerText = item.qty || ''; // (수량)물품 수량
            row.appendChild(cellQty);

            // 단가 (uprc)
            var cellUprc = document.createElement('td');
            cellUprc.innerText = currencyFormatter(item.uprc) || ''; // (단가)물품 단가
            row.appendChild(cellUprc);

            // 공급가액 (supplyAmt)
            var cellSupplyAmt = document.createElement('td');
            cellSupplyAmt.innerText = currencyFormatter(item.supplyAmt) || ''; // (공급가액)물품 공급 가액
            row.appendChild(cellSupplyAmt);

            // 세액 (taxAmt)
            var cellTaxAmt = document.createElement('td');
            cellTaxAmt.innerText = currencyFormatter(item.taxAmt) || ''; // (세액)물품 세액
            row.appendChild(cellTaxAmt);

            // 비고 (itmDesc)
            var cellItmDesc = document.createElement('td');
            cellItmDesc.innerText = item.itmDesc || ''; // (비고)물품과 관련된 자유기술문
            row.appendChild(cellItmDesc);

            // 생성한 행을 테이블에 추가
            tableBody.appendChild(row);
        });
    }
    // 페이지 로드 시 값을 설정
    window.onload = populateTaxInfo;
    document.addEventListener('DOMContentLoaded', function() {
    	populateTaxInfo();
    	populateTaxItems();
    });
</script>
</head>
<body>
	<div class="pop">
		<h1>전자세금계산서</h1>
		<a href="javascript:window.close()" class="close" onclick="javascript:window.close();"></a>
		<section class="cont">
			<form name="form1">
				<input type="hidden" name="issueId" value='' />
				<div style='width: 100%;'>
					<table class="custom-table">
						<tr>
							<td align="center">
								<div id="divTitle" class="ml2">
									<table class="tax_to" summary="(수정) 전자세금계산서 테이블입니다.">
										<colgroup>
											<col width="322px" />
											<col width="78px" />
											<col width="247px" />
										</colgroup>
										<tbody>
											<tr>
												<th><strong class="f20 c3">&nbsp;전자세금계산서</strong></th>
												<th><strong class="f14">승인번호</strong></th>
												<td><strong class="f14 taxPut" id='issueId'></strong></td>
											</tr>
										</tbody>
									</table>
									<table class="tax_col02" summary="전자세금계산서 정보 테이블입니다.">
										<colgroup>
											<col width="17px" />
											<col width="48px" />
											<col width="90px" />
											<col width="53px" />
											<col width="52px" />
											<col width="59px" />
											<col width="17px" />
											<col width="48px" />
											<col width="97px" />
											<col width="53px" />
											<col width="52px" />
											<col width="59px" />
										</colgroup>
										<tbody>
											<tr>
												<th rowspan="6" class="red2" scope="row">공급자</th>
												<th class="t_red2">등록<br />번호
												</th>
												<td colspan="2" align="center" class="t_red fbo"><a
													class="f14 taxPut" id='sndBsnRgN'></a></td>
												<th class="t_red2">종사업장번호</th>
												<td align="center" class="t_red fbo"><a
													class="f14 taxPut" id='sndTxId'></a></td>
												<th rowspan="6" class="blue2" scope="row">공급받는자</th>
												<th class="t_blue2">등록<br />번호
												</th>
												<td colspan="2" align="center" class="t_blue fbo"><a
													class="f14 taxPut" id='rcvBsnRgN'></a></td>
												<th class="t_blue2">종사업장번호</th>
												<td align="center" class="t_blue c fbo"><a
													class="f14 taxPut" id='rcvTxId'></a></td>
											</tr>
											<tr>
												<th class="reds">상호</th>
												<td colspan="2" class="reds taxPut" id='sndName'></td>
												<th class="reds">성명</th>
												<td class="reds taxPut" id='sndRprsndNm'></td>
												<th class="blues2">상호</th>
												<td colspan="2" class="blues taxPut" id='rcvName'></td>
												<th class="blues2">성명</th>
												<td class="blues taxPut" id='rcvRprsNm'></td>
											</tr>
											<tr>
												<th class="reds">사업장<br />주소
												</th>
												<td colspan="4" class="reds taxPut" align="left"
													id='sndAdr'></td>
												<th class="blues2">사업장<br />주소
												</th>
												<td colspan="4" class="blues taxPut" align="left"
													id='rcvAdr'></td>
											</tr>
											<tr>
												<th class="reds">업태</th>
												<td class="reds taxPut" id='sndBcnd'></td>
												<th class="reds">종목</th>
												<td colspan="2" class="reds taxPut" id='sndItp'></td>
												<th class="blues2">업태</th>
												<td class="blues taxPut" id='rcvBcnd'></td>
												<th class="blues2">종목</th>
												<td colspan="2" class="blues taxPut" id='rcvItp'></td>
											</tr>
											<tr>
												<th class="b_red2" rowspan="2">이메일</th>
												<td colspan="4" rowspan="2" class="b_red taxPut"
													id='sndChpEm'></td>
												<th class="blues2">이메일</th>
												<td colspan="4" class="blues taxPut" id='rcvChpEm'></td>
											</tr>
											<tr>
												<th class="b_blue2">이메일</th>
												<td colspan="4" class="b_blue taxPut" id='rcvSubChpEm'></td>
											</tr>
										</tbody>
									</table>
									<table class="tax_tb02" summary="전자세금계산서 정보 테이블입니다.">
										<colgroup>
											<col width="81px" />
											<col width="122px" />
											<col width="122px" />
											<col width="320px" />
										</colgroup>
										<thead>
											<tr>
												<th scope="col">작성일자</th>
												<th scope="col">공급가액</th>
												<th scope="col">세액</th>
												<th scope="col">수정사유</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td class='taxPut' id='isD'></td>
												<td class="r taxPut" id='supplyAmt'></td>
												<td class="r taxPut" id='taxAmt'></td>
												<td class="l taxPut" id='mdfRsn'></td>
											</tr>
											<tr>
												<th class="th_line">비고</th>
												<td colspan="3" class="l taxPut" id='rmk'></td>
											</tr>
										</tbody>
									</table>
									<div class="onlyprint">
										<table class="tax_tb02" summary="전자세금계산서 물품정보 테이블입니다.">
											<colgroup>
												<col width="70px" />
												<col width="160px" />
												<col width="58px" />
												<col width="58px" />
												<col width="80px" />
												<col width="105px" />
												<col width="85px" />
												<col width="55px" />
											</colgroup>
											<thead>
												<tr>
													<th scope="col">월일</th>
													<th scope="col">품목</th>
													<th scope="col">규격</th>
													<th scope="col">수량</th>
													<th scope="col">단가</th>
													<th scope="col">공급가격</th>
													<th scope="col">세액</th>
													<th scope="col">비고</th>
												</tr>
											</thead>
											<tbody id='divSubTaxDetail'>
											</tbody>
										</table>
									</div>
									<table class="tax_tb02" summary="전자세금계산서 합계정보 테이블입니다.">
										<colgroup>
											<col width="100px" />
											<col width="100px" />
											<col width="100px" />
											<col width="100px" />
											<col width="100px" />
											<col width="145px" />
										</colgroup>
										<tbody>
											<tr>
												<th scope="col">합계금액</th>
												<th scope="col">현금</th>
												<th scope="col">수표</th>
												<th scope="col">어음</th>
												<th scope="col">외상미수금</th>
												<td rowspan="2" class='taxPut' id='prpsCd'></td>
											</tr>
											<tr>
												<td class="r taxPut" id='totAmt'></td>
												<td class="r taxPut" id='csAmt'></td>
												<td class="r taxPut" id='chkAmt'></td>
												<td class="r taxPut" id='bilAmt'></td>
												<td class="r taxPut" id='crdtAmt'></td>
											</tr>
										</tbody>
									</table>
								</div>
								<!--
								<br>

								<table class="tax_tb02" summary="전자세금계산서 합계정보 테이블입니다.">
									<colgroup>
										<col width="40px" />
										<col width="60px" />
									</colgroup>
									<tbody>
										<tr>
											<th scope="col" style='border-bottom: none;'>과제번호</th>
											<td scope="col">X18-00227-0804-0</th>
										</tr>
										<tr>
											<th scope="col" style='border-bottom: none;'>과제명</th>
											<td scope="col">외래양서 파충류 확산 변화 예측 및</th>
										</tr>
										<tr>
											<th scope="col" style='border-bottom: none;'>금액/부가세</th>
											<td scope="col">6,000,000 / 0</th>
										</tr>
										<tr>
											<th scope="col" style='border-bottom: none;'>상태</th>
											<td scope="col">지급</th>
										</tr>
										<tr>
											<th scope="col" style='border-bottom: none;'>비목</th>
											<td scope="col">기기 장비, 연구시설 설치 구입 임차비 등</th>
										</tr>
										<tr>
											<th scope="col" style='border-bottom: none;'>세부내역</th>
											<td scope="col">용존산소량 측정기 외 2종 구매</th>
										</tr>
									</tbody>
								</table>
								<br>
								 <table class="tax_col02" summary="집행내역">
									<colgroup>
										<col width="17px" />
										<col width="48px" />
									</colgroup>
									<tbody>
										<tr>
											<th class="t_blue2" scope="row">과제번호</th>
											<td align="center" class="t_blue c fbo"><a
												class="f14 taxPut" id='rcvTxId'>X18-00227-0804-0</a></td>
										</tr>
										<tr>
											<th class="blues2">과제명</th>
											<td class="blues taxPut" id='rcvRprsNm'>외래양서 파충류 확산 변화 예측 및</td>

										</tr>
										<tr>
											<th class="blues2">금액/부가세
											<td class="blues taxPut" id='rcvRprsNm'>6,000,000 / 0</td>
										</tr>
										<tr>
											<th class="blues2">상태
											<td class="blues taxPut" id='rcvRprsNm'>지급</td>
										</tr>
										<tr>
											<th class="blues2">비목
											<td class="blues taxPut" id='rcvRprsNm'>기기 장비, 연구시설 설치 구입 임차비 등</td>
										</tr>
										<tr>
											<th class="blues2">세부내역
											<td class="blues taxPut" id='rcvRprsNm'>용존산소량 측정기 외 2종 구매</td>
										</tr>
									</tbody>
								</table> -->
							</td>
						</tr>
					</table>

				</div>

				<span id="divEnd"></span>
			</form>
		</section>
	</div>
</body>
</html>