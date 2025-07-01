<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>한국환경사업기술원 <spring:message code="comCmm.unitContent.1" /></title>
</head>
<body>
	<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopMenu.jsp" />
	<script>
	document.addEventListener('DOMContentLoaded', function() {
	    conv02502();
	    conv02501();
	});
	function clearTable(table) {
	    while (table.rows.length > 1) {
	        table.deleteRow(1);
	    }
	}

	function insertData(table, data) {
	    data.forEach(row => {
	        const tr = document.createElement('tr');

	        const tdBimok = document.createElement('td');
	        tdBimok.textContent = row.bimok;
	        tr.appendChild(tdBimok);

	        const tdSemok = document.createElement('td');
	        tdSemok.textContent = row.semok;
	        tr.appendChild(tdSemok);

	        const tdUse = document.createElement('td');
	        tdUse.textContent = row.use;
	        tr.appendChild(tdUse);

	        const tdCash = document.createElement('td');
	        tdCash.textContent = currencyFormatter(row.csAmt);
	        tdCash.className = 'txtr';
	        tr.appendChild(tdCash);

	        const tdNonCash = document.createElement('td');
	        tdNonCash.textContent = currencyFormatter(row.thAmt);
	        tdNonCash.className = 'txtr';
	        tr.appendChild(tdNonCash);

	        const tdTotal = document.createElement('td');
	        tdTotal.textContent = currencyFormatter(row.totAmt);
	        tdTotal.className = 'txtr';
	        tr.appendChild(tdTotal);

	        const tdRat = document.createElement('td');
	        tdRat.textContent = row.rat + '%';
	        tdRat.className = 'txtr';
	        tr.appendChild(tdRat);

	        const tdLevel = document.createElement('td');
	        tdLevel.textContent = row.level;
	        tdLevel.className = 'hidden-col';
	        tr.appendChild(tdLevel);

	        table.appendChild(tr);
	    });
	}

	function addTotalRow(table, data) {
	    const totalRow = document.createElement('tr');
	    totalRow.className = 'total';

	    const tdTotalLabel = document.createElement('td');
	    tdTotalLabel.colSpan = 3;
	    tdTotalLabel.className = 'txtc';
	    tdTotalLabel.textContent = '합계';
	    totalRow.appendChild(tdTotalLabel);

	    const tdTotalCash = document.createElement('td');
	    tdTotalCash.className = 'txtr';
	    tdTotalCash.textContent = currencyFormatter(
	        data.reduce((sum, row) => row.level == 1 ? sum + parseFloat(row.csAmt) : sum, 0)
	    );
	    totalRow.appendChild(tdTotalCash);

	    const tdTotalNonCash = document.createElement('td');
	    tdTotalNonCash.className = 'txtr';
	    tdTotalNonCash.textContent = currencyFormatter(
	        data.reduce((sum, row) => row.level == 1 ? sum + parseFloat(row.thAmt) : sum, 0)
	    );
	    totalRow.appendChild(tdTotalNonCash);

	    const tdTotalSum = document.createElement('td');
	    tdTotalSum.className = 'txtr';
	    tdTotalSum.textContent = currencyFormatter(
	        data.reduce((sum, row) => row.level == 1 ? sum + parseFloat(row.totAmt) : sum, 0)
	    );
	    totalRow.appendChild(tdTotalSum);

	    const tdTotalRate = document.createElement('td');
	    tdTotalRate.className = 'txtr';
	    tdTotalRate.textContent = '100%';  // 예제에서는 100%로 고정
	    totalRow.appendChild(tdTotalRate);

	    const tdTotalLevel = document.createElement('td');
	    tdTotalLevel.className = 'hidden-col';
	    tdTotalLevel.textContent = '';  //
	    totalRow.appendChild(tdTotalLevel);

	    table.appendChild(totalRow);
	}
	//비목별예산
	function conv02501() {
		const table = document.getElementById('ioebdg-table');
	    const select = document.querySelector('select[name="bdgTp"]');
	    const selectedValue = select.value;

	    // 폼 데이터를 생성
	    const params = new URLSearchParams();
	    params.append('bdgTp', selectedValue);

	    axios.post('/api/conv/conv02501.do', params)
	        .then(response => {
	            const data = response.data.resultList;
	            clearTable(table);
	            insertData(table, data);
	            addTotalRow(table, data);
	        })
	        .catch(error => {
	            console.error('Error fetching data:', error);
	        }).finally(() => {
	        	// params의 'bdgTp' 값에 따른 조건 처리
	            const bdgTp = params.get('bdgTp');
	            if (bdgTp === '01') {
	    			alert('최종변경 예산입니다.');
	            } else if (bdgTp === '06') {
	            	alert('최초협약 예산입니다.');
	            }
	        });
	}

	//사업비 조회(재원별예산)
	function conv02502() {
		const table = document.getElementById('fndbdg-table');
	    const select = document.querySelector('select[name="fndTp"]');
	    const selectedValue = select.value;

	    // 폼 데이터를 생성
	    const params = new URLSearchParams();
	    params.append('fndTp', selectedValue);

	    axios.post('/api/conv/conv02502.do', params)
	        .then(response => {
	            const data = response.data.resultList;
	            clearTable(table);
	            insertFndBdgData(table, data);
	            addFndBdgTotalRow(table, data);
	        })
	        .catch(error => {
	            console.error('Error fetching data:', error);
	        });
	}
	function insertFndBdgData(table, data) {
	    data.forEach(row => {
	        const tr = document.createElement('tr');

	        const fndTpNm = document.createElement('th');
	        fndTpNm.textContent = row.fndTpNm;
	        tr.appendChild(fndTpNm);

	        const tdCash = document.createElement('td');
	        tdCash.textContent = currencyFormatter(row.cash);
	        tdCash.className = 'txtr';
	        tr.appendChild(tdCash);

	        const tdNonCash = document.createElement('td');
	        tdNonCash.textContent = currencyFormatter(row.nonCash);
	        tdNonCash.className = 'txtr';
	        tr.appendChild(tdNonCash);

	        const tdTotal = document.createElement('td');
	        tdTotal.textContent = currencyFormatter(row.tot);
	        tdTotal.className = 'txtr';
	        tr.appendChild(tdTotal);

	        table.appendChild(tr);
	    });
	}

	function addFndBdgTotalRow(table, data) {
	    const totalRow = document.createElement('tr');
	    totalRow.className = 'total';

	    const tdTotalLabel = document.createElement('td');
	    //tdTotalLabel.colSpan = 2;
	    tdTotalLabel.className = 'txtc';
	    tdTotalLabel.textContent = '합계';
	    totalRow.appendChild(tdTotalLabel);

	    const tdTotalCash = document.createElement('td');
	    tdTotalCash.className = 'txtr';
	    tdTotalCash.textContent = currencyFormatter(data.reduce((sum, row) => sum + parseFloat(row.cash), 0));
	    totalRow.appendChild(tdTotalCash);

	    const tdTotalNonCash = document.createElement('td');
	    tdTotalNonCash.className = 'txtr';
	    tdTotalNonCash.textContent = currencyFormatter(data.reduce((sum, row) => sum + parseFloat(row.nonCash), 0));
	    totalRow.appendChild(tdTotalNonCash);

	    const tdTotalSum = document.createElement('td');
	    tdTotalSum.className = 'txtr';
	    tdTotalSum.textContent = currencyFormatter(data.reduce((sum, row) => sum + parseFloat(row.tot), 0));
	    totalRow.appendChild(tdTotalSum);

	    table.appendChild(totalRow);
	}
	</script>
	<div class="keit-header-body innerwrap clearfix">
		<p class="tit"> 비목별예산</p>
		<!-- 숨겨진 폼 -->
		<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopTaskCard.jsp" />

		<form name="form1" method="post">
		<!---BEGIN_ENC--->

			<!-- 비목별예산 -->
		<h4 class="tit">
			<select name="fndTp" onChange="JavaScript:goChgfndTp();" hidden=1>
				<option value="01" >정부출연금</option>
				<option value="02"  selected >기업체출연금</option>
			</select>
			사업비 합계
			<span class="convdate" ></span>
		</h4>
		<span class="unit">(단위:원)</span>
		<table class="list iptr" id="fndbdg-table">
			<colgroup>
				<col style="width:19%">
				<col style="width:27%">
				<col style="width:27%">
				<col style="width:27%">
			</colgroup>
			<tr class="brn">
				<th></th>
				<th>예산(현금)</th>
				<th>예산(현물)</th>
				<th>예산(합계)</th>
			</tr>
			<tr>
				<th>정부출연금</th>
				<td class="txtr">0</td>
				<td class="txtr">0</td>
				<td class="txtr">0</td>
			</tr>
			<tr class="total">
				<th>합계</th>
				<td class="txtr">0</td>
				<td class="txtr">0</td>
				<td class="txtr">0</td>
			</tr>
		</table>


		<h4 class="tit">

		<select name="bdgTp" onChange="JavaScript:conv02501();" >
			<option value="06" >최초협약</option>
			<option value="01"  selected >최종변경</option>
		</select>

		비목별예산
			<span class="convdate" ></span>
		</h4>
		<span class="unit">(단위:원)</span>
		<table class="list iptr" id="ioebdg-table">
			<colgroup>
				<col style="width:12%">
				<col style="width:12%">
				<col style="width:18%">
				<col style="width:16%">
				<col style="width:16%">
				<col style="width:16%">
				<col style="width:8%">
			</colgroup>
			<tr>
				<th class="txtc">비목</th>
				<th class="txtc">세목</th>
				<th class="txtc">사용용도</th>
				<th class="txtc">예산금액(현금)</th>
				<th class="txtc">예산금액(현물)</th>
				<th class="txtc">예산금액(합계)</th>
				<th class="txtc">비율</th>
				<th class="hidden-col">뎁스</th>
			</tr>

			<tr >
				<td >직접비</td>
				<td></td>
				<td class="txtc">인건비</td>
				<td class="txtr">0</td>
				<td class="txtr">0</td>
				<!-- 비입력 -->
				<td class="txtr">0</td>
				<td class="txtr">0</td>
				<td class="hidden-col">0</td>

			</tr>
			<tr class='total'>
				<td class='txtc' colspan='2'>
					합계
				</td>
				<td></td>
				<!-- 입력 -->
				<td class="txtr">0</td>
				<td class="txtr">0</td>
				<!-- 비입력 -->
				<td class="txtr">0</td>
				<td class="txtr">0</td>
				<td class="hidden-col">0</td>

			</tr>


		</table>

		<div class="rbtn">

			<a href="javascript:goSubPage('/conv/conv02410.do')" class="btn detail">전체보기</a>
		</div>


	</form>
	</div>
</body>
</html>