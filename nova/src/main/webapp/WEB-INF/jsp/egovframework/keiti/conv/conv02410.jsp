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
	<div class="keit-header-body innerwrap clearfix">
		<!-- 숨겨진 폼 -->
		<p class="tit"> 과제상세정보</p>
		<jsp:include page="/WEB-INF/jsp/egovframework/com/cmm/TopTaskCard.jsp" />
		<h4 class="tit"> 과제상세정보
			<span class="convdate" ></span>
		</h4>
		<table id="projectInfo">
			<colgroup>
				<col style="width: 15%">
				<col style="width: 35%">
				<col style="width: 15%">
				<col style="width: 35%">
			</colgroup>
			<tr>
				<th>과제번호</th>
				<td colspan="3" id="taskNo"></td>
			</tr>
			<tr>
				<th>기관</th>
				<td colspan="3" id="instNm"></td>
			</tr>
			<tr>
				<th>과 제 명</th>
				<td colspan="3" id="taskNm"></td>
			</tr>
			<tr>
				<th>사업분류</th>
				<td colspan="3" id="bizCd"></td>
			</tr>
			<tr>
				<th>총괄책임자</th>
				<td id="mnrNm"></td>
				<th>생년월일(성별)</th>
				<td id="mnrBirthdt"></td>
			</tr>
			<tr>
				<th>영문명</th>
				<td id="mnrEngnm"></td>
				<th>E-mail</th>
				<td id="mnrEmail"></td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td id="mnrPhone"></td>
				<th>Fax 번호</th>
				<td id="mnrFax"></td>
			</tr>
			<tr>
				<th>총사업기간</th>
				<td id="totalStartdt"></td>
				<th>당해사업기간</th>
				<td id="curyrStartdt"></td>
			</tr>
		</table>

		<div class="rbtn">
			<!-- <a href="javascript:downloadTableAsExcel('projectInfo');" class="btn excel">엑셀다운로드</a> -->
		</div>

		<h4 class="tit">과제유형 및 전년도과제정보
			<span class="convdate" ></span>
		</h4>
		<table id="exectp-table">
			<colgroup>
				<col style="width:15%">
				<col style="width:85%">
			</colgroup>
			<tr>
				<th>과제유형지정</th>
				<td colspan="3" id="execTp"></td>
			</tr>
		</table>
		<h4 class="tit">사업비
			<select name="fndTp" onChange="JavaScript:goChgfndTp();" hidden=1>
				<option value="01" >정부출연금</option>
				<option value="02"  selected >기업체부담금</option>
			</select>
			<span class="convdate" ></span>
		</h4>
		<span class="unit">(단위:원)</span>
		<table class="list" id="fndbdg-table">
			<colgroup>
				<col style="width:15%">
				<col style="width:30%">
				<col style="width:25%">
				<col style="width:30%">
			</colgroup>
			<thead>
				<tr>
				<th></th>
					<th class="txtc">현금</th>
					<th class="txtc">현물</th>
					<th class="txtc">계</th>
				</tr>
			</thead>
			<tbody id="fundingTableBody">
			</tbody>

		</table>

		<div class="rbtn">
			<a href="javascript:goSubPage('/conv/conv02510.do')" class="btn detail">상세보기</a>
		</div>

		<h4 class="tit">비목별예산
			<span class="convdate" ></span>
		</h4>
		<span class="unit">(단위:원,%)</span>
		<table class="list" id="ioebdg-table">
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
				<th class="txtc">사용목적</th>
				<th class="txtc">예산금액(현금)</th>
				<th class="txtc">예산금액(현물)</th>
				<th class="txtc">예산금액(합계)</th>
				<th class="txtc">비율</th>
				<th class="hidden-col">뎁스</th>
			</tr>

			<tr>
				<td class="txtc">인건비</td>
				<td class="txtc"></td>
				<td class="txtc"></td>
				<td class="txtr">0</td>
				<td class="txtr">0</td>
				<td class="txtr">0</td>
				<td class="txtr">0%</td>
				<td class="hidden-col">0</td>
			</tr>

		</table>


		<div class="rbtn">
		<a href="javascript:goSubPage('/conv/conv02510.do')"  class="btn detail">상세보기</a>
		</div>

        <h4 class="tit">연구비 수령 계좌</h4>
	    <table>
	        <colgroup>
	            <col style="width:20%">
	            <col style="width:30%">
	            <col style="width:20%">
	            <col style="width:30%">
	        </colgroup>
	        <tr>
	            <th>계좌번호</th>
	            <td id="researchActNo"></td>
	            <th>예금주명</th>
	            <td id="researchActNm"></td>
	        </tr>
	    </table>

	    <h4 class="tit">정산환수금 반납계좌</h4>
	    <table>
	        <colgroup>
	            <col style="width:20%">
	            <col style="width:30%">
	            <col style="width:20%">
	            <col style="width:30%">
	        </colgroup>
	        <tr>
	            <th>가상계좌번호</th>
	            <td id="refundActNo">데이터 없음</td>
	            <th>모계좌번호</th>
	            <td id="refundParentActNo">데이터 없음</td>
	        </tr>
	    </table>

	    <div class="rbtn">
		<a href="javascript:goSubPage('/conv/conv02610.do')"  class="btn detail">상세보기</a>
		</div>

		<h4 class="tit">참여인력
			<span class="convdate" ></span>
		</h4>
		<table id="part-table">
			<colgroup>
				<col style="width:11%">
				<col style="width:12%">
				<col style="width:14%">
				<col style="width:8%">
				<col style="width:12%">
				<col style="width:20%">
				<col style="width:23%">
			</colgroup>
			<tr>
				<th class="txtc">이름</th>
				<th class="txtc">영문이름</th>
				<th class="txtc">생년월일(성별)</th>
				<th class="txtc">직위</th>
				<th class="txtc">책임여부</th>
				<th class="txtc">이메일</th>
				<th class="txtc">참여기간</th>
			</tr>

			<tr>
				<td class="txtc"></td>
				<td class="txtc"></td>
				<td class="txtc"></td>
				<td class="txtc"></td>
				<td class="txtc"></td>
				<td class="txtc"></td>
				<td class="txtc"></td>
			</tr>

		</table>

		<div class="rbtn" style="margin-bottom: 20px;padding-bottom: 20px;">
			<a href="javascript:goSubPage('/conv/conv02710.do')"  class="btn detail">상세보기</a>
		</div>

	</div>
</body>
<script>
//데이터 로드 함수
document.addEventListener('DOMContentLoaded', function() {
	// 데이터 로드
	conv02402();	//협약상세정보
	conv02502();	//사업비(재원별예산)
	conv02501();	//비목별예산
	conv02701();	//참여연구원조회
	conv02601();    //계좌정보 조회
});

function conv02402() {
	axios.get('/api/conv/conv02402.do')
		.then(function(response) {
			const data = response.data.taskVo;
			document.getElementById('taskNo').textContent = taskNoFormatter(data.taskNo);
			document.getElementById('instNm').textContent = data.instNm;
			document.getElementById('taskNm').textContent = data.taskNm;
			document.getElementById('bizCd').textContent = data.bizNm;
			document.getElementById('mnrNm').textContent = data.mnrNm;
			document.getElementById('mnrBirthdt').textContent = formatDate(data.mnrBirthdt) + ' (' + (data.mnrGd == 1 ? '남' : '여') + ')'
			document.getElementById('mnrEngnm').textContent = data.mnrEngnm;
			document.getElementById('mnrEmail').textContent = data.mnrEmail;
			document.getElementById('mnrPhone').textContent = data.mnrPhone;
			document.getElementById('mnrFax').textContent = data.mnrFax;
			document.getElementById('totalStartdt').textContent = formatDate(data.totalStartdt) + '~' + formatDate(data.totalEnddt);
			document.getElementById('curyrStartdt').textContent = formatDate(data.curyrStartdt) + '~' + formatDate(data.curyrEnddt);
			document.getElementById('execTp').textContent = execTpFormatter(data.execTp);
		})
		.catch(function(error) {
			console.error('There was an error fetching the data:', error);
		});
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

	// 폼 데이터를 생성
    const params = new URLSearchParams();
    params.append('bdgTp', '');
    axios.post('/api/conv/conv02501.do', params)
        .then(response => {
            const data = response.data.resultList;
            clearTable(table);
            insertData(table, data);
            addTotalRow(table, data);
        })
        .catch(error => {
            console.error('Error fetching data:', error);
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
//참여연구원 조회
function conv02701() {
	const table = document.getElementById('part-table');

    axios.post('/api/conv/conv02701.do')
        .then(response => {
            const data = response.data.resultList;
            clearTable(table);
            insertPartData(table, data);
        })
        .catch(error => {
            console.error('Error fetching data:', error);
        });
}
//계좌정보 조회
function conv02601() {
    axios.get('/api/conv/conv02601.do')
    .then(function(response) {
        // response.data가 Map<String, Object> 형태로 반환됩니다.
        var data = response.data.resultList;

        // 받은 데이터에 따라 각 요소의 내용을 업데이트합니다.
        data.forEach(function(item) {
            if (item.actTp === '01') {
                document.getElementById('researchActNo').textContent = item.actNo ? item.actNo : '데이터 없음';
                document.getElementById('researchActNm').textContent = item.actNm ? item.actNm : '데이터 없음';
            } else if (item.actTp === '05') {
                document.getElementById('refundActNo').textContent = item.actNo ? item.actNo : '데이터 없음';
            } else if (item.actTp === '06') {
                document.getElementById('refundParentActNo').textContent = item.actNo ? item.actNo : '데이터 없음';
            }
        });
    })
    .catch(function(error) {
        console.error('Error fetching data:', error);
        // 에러가 발생한 경우 적절한 에러 처리를 합니다.
    });
}

function clearTable(table) {
    while (table.rows.length > 1) {
        table.deleteRow(1);
    }
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
function insertPartData(table, data) {
    data.forEach(row => {
        const tr = document.createElement('tr');

        const tdNm = document.createElement('td');	//이름
        tdNm.textContent = row.nm;
        tdNm.className = 'txtc';
        tr.appendChild(tdNm);

        const tdEngNm = document.createElement('td');	//영문이름
        tdEngNm.textContent = row.engNm;
        tdEngNm.className = 'txtc';
        tr.appendChild(tdEngNm);

        const tdDob = document.createElement('td');		//생년월일(성별)
        tdDob.textContent = formatDate(row.dob) + '('+row.gd+')';
        tdDob.className = 'txtc';
        tr.appendChild(tdDob);

        const tdPos = document.createElement('td');		//직위
        tdPos.textContent = row.pos;
        tdPos.className = 'txtc';
        tr.appendChild(tdPos);

        const tdIsMng = document.createElement('td');	//책임자여부
        tdIsMng.textContent = row.isMng;
        tdIsMng.className = 'txtc';
        tr.appendChild(tdIsMng);

        const tdEmail = document.createElement('td');	//이메일
        tdEmail.textContent = row.email;
        tdEmail.className = 'txtc';
        tr.appendChild(tdEmail);

        const tdPartStartdt = document.createElement('td'); //참여기간 (YYYY-MM-DD~YYYY-MM-DD)
        if (row.partStartdt === null || row.partEnddt === null) {
            tdPartStartdt.textContent = '';
        } else {
            tdPartStartdt.textContent = formatDate(row.partStartdt) + '~' + formatDate(row.partEnddt);
        }
        tdPartStartdt.className = 'txtc';
        tr.appendChild(tdPartStartdt);

        table.appendChild(tr);
    });
}
</script>
</html>