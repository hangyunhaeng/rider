// 로딩 바 표시 함수
function showLoadingOverlay() {
	document.getElementById('loadingOverlay').style.display = 'flex';
}

// 로딩 바 숨기기 함수
function hideLoadingOverlay() {
	document.getElementById('loadingOverlay').style.display = 'none';
}

function downloadTableAsExcel(fileNm) {
	var tableId="projectInfo";
    const table = document.getElementById(tableId);
    const rows = [];

    // 첫 번째 행에 제목 추가
    rows.push(['협약과제정보', '', '', '']);

    // 헤더와 데이터 추출
    Array.from(table.rows).forEach((row) => {
        const rowData = [];
        Array.from(row.cells).forEach((cell) => {
            let value = cell.textContent.trim();
            rowData.push(value);
        });
        rows.push(rowData);
    });

    const ws = XLSX.utils.aoa_to_sheet(rows);

    // 셀 병합 설정
    ws['!merges'] = [
        { s: { r: 0, c: 0 }, e: { r: 0, c: 3 } }, // 첫 번째 행 병합
        { s: { r: 1, c: 1 }, e: { r: 1, c: 3 } }, // 2B:2D
        { s: { r: 2, c: 1 }, e: { r: 2, c: 3 } }, // 3B:3D
        { s: { r: 3, c: 1 }, e: { r: 3, c: 3 } }, // 4B:4D
        { s: { r: 4, c: 1 }, e: { r: 4, c: 3 } }  // 5B:5D
    ];

    // 모든 셀의 형식을 텍스트로 설정
    const range = XLSX.utils.decode_range(ws['!ref']);
    for (let R = range.s.r; R <= range.e.r; ++R) {
        for (let C = range.s.c; C <= range.e.c; ++C) {
            const cell_address = { c: C, r: R };
            const cell_ref = XLSX.utils.encode_cell(cell_address);
            if (!ws[cell_ref]) continue;
            ws[cell_ref].t = 's';  // 셀 형식을 텍스트로 설정
        }
    }

    // 각 열 너비를 고정
    ws['!cols'] = [
        { wch: 15 },   // A열
        { wch: 24 },   // B열
        { wch: 18.5 }, // C열
        { wch: 30 },   // D열
        { wch: 22 },   // E열
        { wch: 22 }    // F열
    ];

    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Sheet1");

    // 현재 날짜 추가하여 파일명 생성
    const currentDate = new Date();
    const formattedDate = currentDate.getFullYear().toString() +
        String(currentDate.getMonth() + 1).padStart(2, '0') +
        String(currentDate.getDate()).padStart(2, '0'); // "YYYYMMDD" 형식
    const filename = fileNm + '_' + formattedDate + '.xlsx';

    // 엑셀 파일을 xlsx-populate로 불러오기
    XlsxPopulate.fromDataAsync(XLSX.write(wb, { bookType: 'xlsx', type: 'array' })).then(workbook => {
        const sheet = workbook.sheet(0);

        // 제목 셀 스타일 적용
        const titleCell = sheet.range("A1:D1");
        titleCell.style({
            bold: true,
            horizontalAlignment: 'center',
            verticalAlignment: 'center',
            fontSize: 16
        });

        // 헤더 셀 스타일 적용
        const headerRange1 = sheet.range("A2:A10");
        const headerRange2 = sheet.range("A1:D10");
        const headerRange3 = sheet.range("C6:C9");

        headerRange1.style({
            bold: true,
            fill: { color: { rgb: 'D3D3D3' } },
            horizontalAlignment: 'center',
            border: {
                top: { style: 'thin', color: '000000' },
                bottom: { style: 'thin', color: '000000' },
                left: { style: 'thin', color: '000000' },
                right: { style: 'thin', color: '000000' }
            }
        });
        headerRange2.style({
            horizontalAlignment: 'center',
            border: {
                top: { style: 'thin', color: '000000' },
                bottom: { style: 'thin', color: '000000' },
                left: { style: 'thin', color: '000000' },
                right: { style: 'thin', color: '000000' }
            }
        });
        headerRange3.style({
            bold: true,
            fill: { color: { rgb: 'D3D3D3' } },
            horizontalAlignment: 'center',
            border: {
                top: { style: 'thin', color: '000000' },
                bottom: { style: 'thin', color: '000000' },
                left: { style: 'thin', color: '000000' },
                right: { style: 'thin', color: '000000' }
            }
        });

        // 데이터 셀 스타일 적용
        for (let rowIndex = 2; rowIndex < rows.length; rowIndex++) {
            for (let colIndex = 0; colIndex < rows[0].length; colIndex++) {
                const cellRef = sheet.cell(rowIndex + 1, colIndex + 1); // colIndex + 1 to match Excel's 1-based index

                const style = {
                    horizontalAlignment: 'center',
                    border: {
                        top: { style: 'thin', color: '000000' },
                        bottom: { style: 'thin', color: '000000' },
                        left: { style: 'thin', color: '000000' },
                        right: { style: 'thin', color: '000000' }
                    }
                };

                cellRef.style(style);
            }
        }

        return workbook.outputAsync("blob").then(blob => {
            const url = URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = url;
            a.download = filename;
            a.click();
            URL.revokeObjectURL(url);
        }).catch(error => {
            console.error('Error during Excel generation:', error);
        });
    });
}

function downloadEx(grid, columnDefs, selectedColumns, fileNm, title, infoFlag) {
    showLoadingOverlay(); // 로딩 바 표시
    const rows = [];
    const options = []; // 컬럼 옵션을 저장할 변수

    // 평탄화된 컬럼 정의
    const flatColumnDefs = flattenColumnDefs(columnDefs);

    // 상단에 추가할 정보
    const additionalInfo = [[title], []];

    if (infoFlag && typeof taskVo !== 'undefined' && taskVo) {
        additionalInfo.push(
            ['과제번호 : ' + taskNoFormatter(taskVo.taskNo)],
            ['과제 상태 : ' + taskStatusFormatter(taskVo.taskSt)],
            ['실행 유형 : ' + execTpFormatter(taskVo.execTp)],
            ['과제명 : ' + taskVo.taskNm],
            ['과제 유형 : ' + taskTpFormatter(taskVo.taskTp)],
            ['연구기관 : ' + taskVo.instNm],
            []
        );
    }

    // 추가 정보를 rows의 최상단에 추가
    additionalInfo.forEach(info => {
        rows.push(info);
    });

    // 부모와 자식 헤더 분리
    let parentHeaders = [];
    const childHeaders = [];

    columnDefs.forEach(colDef => {
	    if (colDef.children) {
	        colDef.children.forEach(child => {
	            if (selectedColumns.includes(child.field)) {
	                parentHeaders.push(colDef.headerName.replace(/<br>/g, ''));
	                childHeaders.push(child.headerName.replace(/<br>/g, ''));
	            }
	        });
	    } else {
	        if (selectedColumns.includes(colDef.field)) {
	            parentHeaders.push(colDef.headerName.replace(/<br>/g, '')); // 자식 헤더가 없으면 부모 헤더의 동일 값을 추가
	            childHeaders.push(colDef.headerName.replace(/<br>/g, ''));
	        }
	    }
	});

    // 부모 헤더가 있는 경우에만 rows에 추가
    if (parentHeaders.some(header => header !== '')) {
        rows.push(parentHeaders); // 부모 헤더 추가
    }
    rows.push(childHeaders); // 자식 헤더 추가

    // 데이터를 rows에 추가하고, 각 컬럼의 옵션을 options에 추가
	grid.forEachNode((node) => {
	    const rowData = [];
	    selectedColumns.forEach(col => {
	        const colDef = flatColumnDefs.find(c => c.field === col);
	        let value;

	        if (colDef && typeof colDef.valueGetter === 'function') {
	            // valueGetter가 함수인 경우에만 호출합니다.
	            value = colDef.valueGetter({ data: node.data, node: node });
	        } else {
	            // 그렇지 않은 경우 일반 데이터 필드 값을 가져옵니다.
	            value = node.data[col];
	        }

	        if (colDef && colDef.valueFormatter) {
	            value = colDef.valueFormatter({ value: value });
	        }

	        if (value === null || value === undefined) {
	            value = ''; // null 또는 undefined인 경우 빈 문자열로 설정
	        }

	        rowData.push(value.toString());
	    });
	    rows.push(rowData);
	});

    // 첫 번째 노드 처리 시에만 options에 추가
    if (options.length === 0) {
        selectedColumns.forEach(col => {
            const colDef = flatColumnDefs.find(c => c.field === col);
            options.push({
                isRightAligned: colDef?.cellClass === 'ag-cell-right' || colDef?.isRightAligned || false,
                isLeftAligned: colDef?.cellClass === 'ag-cell-left' || colDef?.isLeftAligned || false,
                isString: colDef?.context?.isString || false
            });
        });
    }

    const ws = XLSX.utils.aoa_to_sheet(rows);

    // 모든 셀의 형식을 텍스트로 설정
    const range = XLSX.utils.decode_range(ws['!ref']);
    for (let R = range.s.r; R <= range.e.r; ++R) {
        for (let C = range.s.c; C <= range.e.c; ++C) {
            const cell_address = { c: C, r: R };
            const cell_ref = XLSX.utils.encode_cell(cell_address);
            if (!ws[cell_ref]) continue;
            ws[cell_ref].t = 's';  // 셀 형식을 텍스트로 설정
        }
    }

    // 열 너비를 텍스트 길이에 맞춰 자동 조정 (additionalInfo 길이 제외)
    const colWidths = childHeaders.map((headerText, colIndex) => {
        return Math.max(
            headerText.length,
            ...rows.slice(additionalInfo.length + (parentHeaders.some(header => header !== '') ? 2 : 1)).map(row => (row[colIndex] ? row[colIndex].toString().length : 0))
        ) + 5; // 텍스트 길이 + 여유 공간
    });

    ws['!cols'] = colWidths.map(width => ({ wch: width }));

    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Sheet1");

    // 현재 날짜 추가하여 파일명 생성
    const currentDate = new Date();
    const formattedDate = currentDate.getFullYear().toString() +
        String(currentDate.getMonth() + 1).padStart(2, '0') +
        String(currentDate.getDate()).padStart(2, '0'); // "YYYYMMDD" 형식
    const filename = fileNm + '_' + formattedDate + '.xlsx';

    // 엑셀 파일을 xlsx-populate로 불러오기
    XlsxPopulate.fromDataAsync(XLSX.write(wb, { bookType: 'xlsx', type: 'array' })).then(workbook => {
        const sheet = workbook.sheet(0);

        // 제목 셀 스타일 적용
        const titleCell = sheet.cell("A1");
        titleCell.style({
            bold: true,
            fontSize: 15
        });

        // 부모 헤더 병합 및 스타일 적용
        if (parentHeaders.some(header => header !== '')) {
            for (let colIndex = 0; colIndex < parentHeaders.length; colIndex++) {
                const startCol = colIndex;
                while (colIndex < parentHeaders.length - 1 && parentHeaders[colIndex] === parentHeaders[colIndex + 1]) {
                    colIndex++;
                }
                if (colIndex > startCol) {
                    sheet.range(sheet.cell(additionalInfo.length + 1, startCol + 1), sheet.cell(additionalInfo.length + 1, colIndex + 1)).merged(true).style({
                        horizontalAlignment: 'center',
                        verticalAlignment: 'center',
                        bold: true,
                        fill: { color: { rgb: 'D3D3D3' } },
                        border: {
                            top: { style: 'thin', color: '000000' },
                            bottom: { style: 'thin', color: '000000' },
                            left: { style: 'thin', color: '000000' },
                            right: { style: 'thin', color: '000000' }
                        }
                    });
                } else {
                    sheet.cell(additionalInfo.length + 1, startCol + 1).style({
                        horizontalAlignment: 'center',
                        verticalAlignment: 'center',
                        bold: true,
                        fill: { color: { rgb: 'D3D3D3' } },
                        border: {
                            top: { style: 'thin', color: '000000' },
                            bottom: { style: 'thin', color: '000000' },
                            left: { style: 'thin', color: '000000' },
                            right: { style: 'thin', color: '000000' }
                        }
                    });
                }
            }
        }

        // 자식 헤더 병합 및 스타일 적용
        for (let colIndex = 0; colIndex < childHeaders.length; colIndex++) {
            const startCol = colIndex;
            while (colIndex < childHeaders.length - 1 && childHeaders[colIndex] === childHeaders[colIndex + 1]) {
                colIndex++;
            }
            if (colIndex > startCol) {
                sheet.range(sheet.cell(additionalInfo.length + (parentHeaders.some(header => header !== '') ? 2 : 1), startCol + 1), sheet.cell(additionalInfo.length + (parentHeaders.some(header => header !== '') ? 2 : 1), colIndex + 1)).merged(true).style({
                    horizontalAlignment: 'center',
                    verticalAlignment: 'center',
                    bold: true,
                    fill: { color: { rgb: 'D3D3D3' } },
                    border: {
                        top: { style: 'thin', color: '000000' },
                        bottom: { style: 'thin', color: '000000' },
                        left: { style: 'thin', color: '000000' },
                        right: { style: 'thin', color: '000000' }
                    }
                });
            } else {
                sheet.cell(additionalInfo.length + (parentHeaders.some(header => header !== '') ? 2 : 1), startCol + 1).style({
                    horizontalAlignment: 'center',
                    verticalAlignment: 'center',
                    bold: true,
                    fill: { color: { rgb: 'D3D3D3' } },
                    border: {
                        top: { style: 'thin', color: '000000' },
                        bottom: { style: 'thin', color: '000000' },
                        left: { style: 'thin', color: '000000' },
                        right: { style: 'thin', color: '000000' }
                    }
                });
            }
        }

        // 데이터 셀 스타일 적용
		for (let rowIndex = additionalInfo.length + (parentHeaders.some(header => header !== '') ? 2 : 1); rowIndex < rows.length; rowIndex++) {
		    const isLastRow = rowIndex === rows.length - 1;
		    const isTotalRow = isLastRow && sheet.cell(rowIndex + 1, 1).value() === '합계';

		    for (let colIndex = 0; colIndex < childHeaders.length; colIndex++) {
		        const cellRef = sheet.cell(rowIndex + 1, colIndex + 1); // colIndex + 1 to match Excel's 1-based index

		        const colOption = options[colIndex];
		        const alignment = colOption.isRightAligned ? 'right' : colOption.isLeftAligned ? 'left' : 'center';
		        const isString = colOption.isString;

		        const style = {
		            horizontalAlignment: alignment,
		            border: {
		                top: { style: 'thin', color: '000000' },
		                bottom: { style: 'thin', color: '000000' },
		                left: { style: 'thin', color: '000000' },
		                right: { style: 'thin', color: '000000' }
		            }
		        };

		        // 마지막 행이면서 첫 번째 셀이 '합계'인 경우 스타일 추가
		        if (isTotalRow) {
		            style.fill = {
		                color: { rgb: 'BDDC98' }
		            };
		            style.bold = true; // Bold 텍스트 설정
		        }

		        if (isString) {
		            cellRef.value("" + cellRef.value());
		            style.numberFormat = '@';
		        }

		        cellRef.style(style);
		    }
		}

        // 동일한 부모 헤더와 자식 헤더 병합
        for (let colIndex = 0; colIndex < parentHeaders.length; colIndex++) {
            if (parentHeaders[colIndex] === childHeaders[colIndex]) {
                sheet.range(sheet.cell(additionalInfo.length + 1, colIndex + 1), sheet.cell(additionalInfo.length + 2, colIndex + 1)).merged(true).style({
                    horizontalAlignment: 'center',
                    verticalAlignment: 'center',
                    bold: true,
                    fill: { color: { rgb: 'D3D3D3' } },
                    border: {
                        top: { style: 'thin', color: '000000' },
                        bottom: { style: 'thin', color: '000000' },
                        left: { style: 'thin', color: '000000' },
                        right: { style: 'thin', color: '000000' }
                    }
                });
            }
        }

        return workbook.outputAsync("blob").then(blob => {
            const url = URL.createObjectURL(blob);
            const a = document.createElement("a");
            a.href = url;
            a.download = filename;
            a.click();
            URL.revokeObjectURL(url);
            hideLoadingOverlay(); // 로딩바 숨기기
        }).catch(error => {
            console.error('Error during Excel generation:', error);
            hideLoadingOverlay(); // 로딩바 숨기기 (에러 발생 시)
        });
    });
}
function flattenColumnDefs(columnDefs, parentHeaderName = '') {
    const flatColumnDefs = [];

    columnDefs.forEach(colDef => {
        const headerName = parentHeaderName ? parentHeaderName + '\n' + colDef.headerName.replace(/<br>/g, '') : colDef.headerName.replace(/<br>/g, '');
        if (colDef.children) {
            flatColumnDefs.push(...flattenColumnDefs(colDef.children, headerName));
        } else {
            flatColumnDefs.push({
                ...colDef,
                headerName: headerName
            });
        }
    });

    return flatColumnDefs;
}
// 달력불러오기
function fnFpCalendar(inputElement) {
	if (inputElement) {
		flatpickr(inputElement, {
			locale: "ko",  // 한글 로케일 설정
			dateFormat: "Y-m-d",
			defaultDate: inputElement.value,
			onChange: function(selectedDates, dateStr) {
				inputElement.value = dateStr;
			},
			onOpen: function(selectedDates, dateStr, instance) {
                // Flatpickr가 열린 후 클래스 수정
                inputElement.className = 'date';
                inputElement.removeAttribute('readonly');
            }
		}).open();
	} else {
		console.error("Element not found.");
	}
}
function getStatusValue(key, mapping) {
    if (!key) {
        return '';
    }
    const item = mapping.find(entry => entry.key === key);
    return item ? item.value : key;
}

// 집행진행상태 포맷터
function statusFormatter(params) {
	const statusMapping = {
		'200': '결의등록',
		'250': '결의오류',
		'501': '거절',
		'700': '확인완료',
		'800': '지급',
		'850': '지급취소',
		'999': '여입'
	};
	// params가 문자열인 경우 처리
	if (typeof params === 'string') {
		return statusMapping[params] || params;
	}
	// params.value가 있는 경우 처리
	if (params && params.value) {
		return statusMapping[params.value] || params.value;
	}
	// 기본 반환 값
	return params;
}
// 과제진행상태 포맷터
const taskStMapping = [
	{ key: '', value: '전체' },
	{ key: '200', value: '과제등록중' },
	{ key: '300', value: '과제심사신청' },
	{ key: '501', value: '부처과제담당부서심사반려' },
	{ key: '550', value: '지급상태변경(환수)' },
	{ key: '560', value: '지급상태변경(계좌변경)' },
	{ key: '570', value: '지급상태변경(지급)' },
	{ key: '700', value: '과제 수행중' },
	{ key: '900', value: '과제종료(사용내역 입력가능)' },
	{ key: '910', value: '과제중단' },
	{ key: '920', value: '과제종료(사용내역 입력불가)' },
	{ key: '930', value: '과제종료(전년도과제지정)' },
	{ key: '940', value: '사용실적 접수' },
	{ key: '941', value: '사용실적 미접수' },
	{ key: '942', value: '사용실적 제출독촉' },
	{ key: '944', value: '제재조치 통보(사용실적)' },
	{ key: '945', value: '소명자료 요청' },
	{ key: '946', value: '소명자료 접수' },
	{ key: '947', value: '소명자료 미접수' },
	{ key: '948', value: '부당집행' },
	{ key: '949', value: '정산결과 통보' },
	{ key: '950', value: '정산결과 반려' },
	{ key: '951', value: '정산결과 확정(이의제기 가능)' },
	{ key: '952', value: '이의신청 접수' },
	{ key: '953', value: '이의신청 소명자료요청' },
	{ key: '954', value: '이의신청 결과통보' },
	{ key: '955', value: '최종확정대기' },
	{ key: '956', value: '최종환수종료' },
	{ key: '957', value: '제재조치 통보(정산환수금 미납)' },
	{ key: '958', value: '사용실적 검토결과 통보' },
	{ key: '960', value: '정산최종완료' }
];

// 진행상태 포맷터 함수
function taskStatusFormatter(params) {
    // params가 문자열인 경우 처리
    if (typeof params === 'string') {
        return getStatusValue(params, taskStMapping);
    }
    // params.value가 있는 경우 처리
    if (params && params.value) {
        return getStatusValue(params.value, taskStMapping);
    }
    // 기본 반환 값
    return params;
}
// 과제유형포맷터
const taskTpMapping = [
    { key: '', value: '전체' },
    { key: 'A0', value: '사업단총괄' },
    { key: 'GA', value: '총괄과제' },
    { key: 'U0', value: '사업총괄' },
    { key: 'S0', value: '위탁과제' },
    { key: 'M0', value: '주관과제' },
    { key: 'C0', value: '공동과제' },
    { key: 'GM', value: '세부과제' },
    { key: 'RL_TASK_C', value: '위탁과제/주관과제/공동과제/세부과제' },
    { key: 'NOT_RL_TASK_C', value: '사업단총괄/총괄과제/사업총괄' }
];
// 과제유형 포맷터 함수
function taskTpFormatter(params) {
    // params가 문자열인 경우 처리
    if (typeof params === 'string') {
        return getStatusValue(params, taskTpMapping);
    }
    // params.value가 있는 경우 처리
    if (params && params.value) {
        return getStatusValue(params.value, taskTpMapping);
    }
    // 기본 반환 값
    return params;
}
// 과제 방식 포맷터
const execTpMapping = [
    { key: '', value: '전체' },
    { key: '1', value: '건별지급' },
    { key: '2', value: '일괄지급' }
];
// 과제 방식 포맷터 함수
function execTpFormatter(params) {
    // params가 문자열인 경우 처리
    if (typeof params === 'string') {
        return getStatusValue(params, execTpMapping);
    }
    // params.value가 있는 경우 처리
    if (params && params.value) {
        return getStatusValue(params.value, execTpMapping);
    }
    // 기본 반환 값
    return params;
}
const taskYrMapping = [
	{ key: '', value: '전체' },
	{ key: '2025', value: '2025년' },
	{ key: '2024', value: '2024년' },
	{ key: '2023', value: '2023년' },
	{ key: '2022', value: '2022년' },
	{ key: '2021', value: '2021년' },
	{ key: '2020', value: '2020년' },
	{ key: '2019', value: '2019년' },
	{ key: '2018', value: '2018년' },
	{ key: '2017', value: '2017년' },
	{ key: '2016', value: '2016년' },
	{ key: '2015', value: '2015년' },
	{ key: '2014', value: '2014년' },
	{ key: '2013', value: '2013년' },
	{ key: '2012', value: '2012년' },
	{ key: '2011', value: '2011년' },
	{ key: '2010', value: '2010년' },
	{ key: '2009', value: '2009년' },
	{ key: '2008', value: '2008년' },
	{ key: '2007', value: '2007년' },
	{ key: '2006', value: '2006년' },
	{ key: '2005', value: '2005년' },
	{ key: '2004', value: '2004년' },
	{ key: '2003', value: '2003년' },
	{ key: '2002', value: '2002년' },
	{ key: '2001', value: '2001년' },
	{ key: '2000', value: '2000년' },
	{ key: '1999', value: '1999년' }
];

// populateSelectOptions 함수
async function populateSelectOptions(selectId, mapping, selectedValue = '') {
    // 필요한 경우 ioeCdMapping 데이터 로드
    if (selectId === 'srcIoeCd') {
       await loadIoeCdMapping();
       mapping = ioeCdMapping;
    }
    // 필요한 경우 ioeCdMapping 데이터 로드
    if (selectId === 'srcBizCd') {
       await loadBizCdMapping();
       mapping = getFilteredBizCdMapping(1, '');
    }
    // 필요한 경우 ioeCdMapping 데이터 로드
    if (selectId === 'srcChildBizCd') {
       await loadBizCdMapping();
       mapping = getFilteredBizCdMapping(2, selectedValue);
       selectedValue = '';
    }

    const selectElement = document.getElementById(selectId);

    if (!selectElement) {
        console.error(`Element with id '${selectId}' not found.`);
        return;
    }

    // 기존 옵션 제거
    selectElement.innerHTML = '';

    // 옵션 추가
    mapping.forEach(item => {
        // display가 'none'인 항목은 추가하지 않음
        if (item.display && item.display.toLowerCase() === 'none') {
            return;
        }

        const option = document.createElement('option');
        // key와 value를 대소문자 구분 없이 처리
        const key = item.key || item.KEY || '';
        const value = item.value || item.VALUE || '';
        option.value = key;
        option.textContent = value;
        if (key.toLowerCase() === selectedValue.toLowerCase()) {
            option.selected = true;
        }
        selectElement.appendChild(option);
    });
}
// 서버에서 ioeCdMapping 데이터 가져오기
let ioeCdMapping = [];

async function loadIoeCdMapping() {
    try {
        const response = await axios.get('/api/comm/comm09901.do');
        // 초기화 후 맨 위에 '전체' 항목 추가
        ioeCdMapping = [{ key: '', value: '전체' }];

        // 조회한 데이터 붙이기
        const fetchedData = response.data.resultList;
        ioeCdMapping = ioeCdMapping.concat(fetchedData.map(item => ({
            key: item.key || item.KEY,
            value: item.value || item.VALUE,
            display: item.display || item.DISPLAY
        })));
    } catch (error) {
        console.error('There was an error fetching the ioeCdMapping data:', error);
    }
}
// 비목 코드 포맷터 함수
function ioeCdFormatter(params) {
    // params가 문자열인 경우 처리
    if (typeof params === 'string') {
        return getStatusValue(params, ioeCdMapping);
    }
    // params.value가 있는 경우 처리
    if (params && params.value) {
        return getStatusValue(params.value, ioeCdMapping);
    }
    // 기본 반환 값
    return params;
}
// 서버에서 ioeCdMapping 데이터 가져오기
let bizCdMapping = [];

async function loadBizCdMapping() {
    try {
        // bizCdMapping이 비어있는 경우에만 통신
        if (!bizCdMapping || bizCdMapping.length === 0) {
            const response = await axios.get('/api/comm/comm09902.do');

            // 초기화 후 맨 위에 '전체' 항목 추가
            bizCdMapping = [{ key: '', value: '전체', path: '' }];

            // 조회한 데이터 붙이기
            const fetchedData = response.data.resultList;
            bizCdMapping = bizCdMapping.concat(fetchedData.map(item => ({
                key: item.key || item.KEY,
                value: item.value || item.VALUE,
                path: item.path || item.PATH // PATH 값 추가
            })));
        }
    } catch (error) {
        console.error('There was an error fetching the bizCdMapping data:', error);
    }
}
// 비목 코드 포맷터 함수
function bizCdFormatter(params) {
    // params가 문자열인 경우 처리
    if (typeof params === 'string') {
        return getStatusValue(params, bizCdMapping);
    }
    // params.value가 있는 경우 처리
    if (params && params.value) {
        return getStatusValue(params.value, bizCdMapping);
    }
    // 기본 반환 값
    return params;
}
function getFilteredBizCdMapping(level, code) {
    // bizCdMapping 데이터가 있는지 확인
    if (!bizCdMapping || bizCdMapping.length === 0) {
        console.error('bizCdMapping is empty or not initialized.');
        return [];
    }

    // code가 빈 문자열일 경우 '전체'만 반환
    if (level === 2 && code === '') {
        return [{ key: '', value: '전체', path: '' }];
    }

    // level 파라미터에 따른 필터링
    const filteredMapping = bizCdMapping.filter(item => {
        const path = item.path || '';
        const slashCount = (path.match(/\//g) || []).length;

        if (level === 1) {
            // 레벨 1인 경우 코드값과 무관하게 필터링 (슬래시가 하나만 포함된 항목)
            return slashCount === 1;
        } else {
            // 레벨 2 이상일 경우 코드값으로 필터링
            const isMatchingCode = code ? path.startsWith(`/${code}/`) : true;
            return slashCount > 1 && isMatchingCode;
        }
    });

    // '전체' 항목을 맨 앞에 추가
    const mapping = [{ key: '', value: '전체', path: '' }, ...filteredMapping];

    return mapping;
}

// 집행 방법 포맷터
const execMtdMapping = [
    { key: '', value: '전체' },
    { key: 'CD', value: '연구비(사업비)카드' },
    { key: 'TR', value: '계좌이체' },
    { key: 'IB', value: '인터넷뱅킹' },
    { key: 'CS', value: '현금' },
    { key: 'TH', value: '현물' },
    { key: 'GR', value: '지로' },
    { key: 'PC', value: '개인신용카드' },
    { key: 'CK', value: '체크카드예산지급' },
    { key: 'CC', value: '법인신용카드' },
    { key: 'AC', value: '수용비 및 수수료' },
    { key: 'WT', value: '위탁연구개발비' },
    { key: 'CDCC', value: '중앙구매카드', display: 'none'},
    { key: 'CDIC', value: '과제통합카드', display: 'none' },
    { key: 'X1', value: '미등록카드건', display: 'none' },
    { key: 'PC', value: '개인신용카드', display: 'none' },
    { key: 'IB', value: '인터넷뱅킹', display: 'none' },
    { key: 'X2', value: '미등록계좌이체건', display: 'none' }
];
// 집행 방법 포맷터 함수
function execMtdFormatter(params) {
    // params가 문자열인 경우 처리
    if (typeof params === 'string') {
        return params === '' ? '' : getStatusValue(params, execMtdMapping);
    }
    // params가 객체이면서 params.value가 있는 경우 처리
    if (params && params.value) {
        return params.value === '' ? '' : getStatusValue(params.value, execMtdMapping);
    }
    // 기본 반환 값 (빈 문자열로 처리)
    return '';
}
// 집행 상태 포맷터
const execStsMapping = [
    { key: '', value: '전체' },
    { key: '200', value: '등록' },
    { key: '300', value: '지급요청' },
    { key: '700', value: '반려' },
    { key: '800', value: '지급' },
    { key: '750', value: '환급' },
    { key: '999', value: '집행완료' }
];
// 집행 상태 포맷터 함수
function execStsFormatter(params) {
    // params가 문자열인 경우 처리
    if (typeof params === 'string') {
        return getStatusValue(params, execStsMapping);
    }
    // params.value가 있는 경우 처리
    if (params && params.value) {
        return getStatusValue(params.value, execStsMapping);
    }
    // 기본 반환 값
    return params;
}
// 등록방법 포맷터
const rgMtdMapping = [
    { key: '', value: '전체' },
    { key: '01', value: '직접등록' },
    { key: '02', value: '시스템매칭' }
];
// 등록방법 포맷터 함수
function rgMtdFormatter(params) {
    // params가 문자열인 경우 처리
    if (typeof params === 'string') {
        return getStatusValue(params, rgMtdMapping);
    }
    // params.value가 있는 경우 처리
    if (params && params.value) {
        return getStatusValue(params.value, rgMtdMapping);
    }
    // 기본 반환 값
    return params;
}
// 공통서류 포맷터
const rtmItmMapping = [
    { key: '', value: '전체' },
    { key: '01', value: '통장거래내역 사본' },
    { key: '02', value: '[내부규정] 인건비' },
    { key: '03', value: '[내부규정] 여비규정' },
    { key: '04', value: '[내부규정] 산출근거규정' },
    { key: '05', value: '기반납액 계좌이체증' },
    { key: '99', value: '기타' }
];
// 등록방법 포맷터 함수
function rtmItmFormatter(params) {
    // params가 문자열인 경우 처리
    if (typeof params === 'string') {
        return getStatusValue(params, rtmItmMapping);
    }
    // params.value가 있는 경우 처리
    if (params && params.value) {
        return getStatusValue(params.value, rtmItmMapping);
    }
    // 기본 반환 값
    return params;
}
// 영수/청구 구분
const prpsCdMapping = [
    { key: '', value: '전체' },
    { key: '01', value: '영수' },
    { key: '02', value: '청구' },
    { key: '1', value: '영수' },
    { key: '2', value: '청구' }
];
// 등록방법 포맷터 함수
function prpsCdFormatter(params) {
    // params가 문자열인 경우 처리
    if (typeof params === 'string') {
        return getStatusValue(params, prpsCdMapping);
    }
    // params.value가 있는 경우 처리
    if (params && params.value) {
        return getStatusValue(params.value, prpsCdMapping);
    }
    // 기본 반환 값
    return params;
}
// 이체처리구분 포맷터
const trnsTypeMapping = [
    { key: '', value: '전체' },
    { key: '1', value: '이체미실행' },
    { key: '2', value: '이체성공' },
    { key: '3', value: '이체재실행' },
    { key: '4', value: '이체대상아님' }
];
// 이체처리구분 포맷터 함수
function trnsTypeFormatter(params) {
    // params가 문자열인 경우 처리
    if (typeof params === 'string') {
        return getStatusValue(params, trnsTypeMapping);
    }
    // params.value가 있는 경우 처리
    if (params && params.value) {
        return getStatusValue(params.value, trnsTypeMapping);
    }
    // 기본 반환 값
    return params;
}
// 숫자 컴마처리 / 화폐처리
function currencyFormatter(params) {
    if (params === null || params === undefined) {
        return '0'; // null 또는 undefined인 경우 빈 문자열 반환
    } else if (typeof params === 'string' || typeof params === 'number') {
        return params.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    } else if (params.value !== undefined && params.value !== null) {
        return params.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    } else {
        return params;
    }
}

// 퍼센테이지 처리 함수
function percentFormatter(params, decimalPlaces = 2, roundingMode = 'floor') {
    if (params == null || params === undefined || params.value == null) {
    	return '0.00%'; // null, undefined 또는 params.value가 null인 경우 0.00% 반환
	}  else {
    	let value;

        // 값이 문자열 또는 숫자인 경우 처리
        if (typeof params === 'string' || typeof params === 'number') {
            value = parseFloat(params);
        } else if (params.value !== undefined && params.value !== null) {
            value = parseFloat(params.value);
        } else {
            return params;
        }

        // 소수점 자릿수 처리 및 반올림/올림/버림 처리
        switch (roundingMode) {
            case 'ceil':
                value = Math.ceil(value * Math.pow(10, decimalPlaces)) / Math.pow(10, decimalPlaces);
                break;
            case 'floor':
                value = Math.floor(value * Math.pow(10, decimalPlaces)) / Math.pow(10, decimalPlaces);
                break;
            case 'round':
            default:
                value = Math.round(value * Math.pow(10, decimalPlaces)) / Math.pow(10, decimalPlaces);
                break;
        }

        // 100%일 경우 소수점 없애기
        if (value === 100) {
            return '100%';
        }

        // 퍼센트로 변환하고 반환
        return value.toFixed(decimalPlaces) + '%';
    }
}


function taskNoFormatter(params) {
	 // params가 undefined나 null인 경우 바로 반환
    if (params === undefined || params === null) {
        return params;
    }
    // 문자열 또는 숫자인 경우 바로 처리
    if (typeof params === 'string' || typeof params === 'number') {
        return formatString(params.toString());
    }
    // 객체에서 value 속성을 가지고 있는 경우 처리
    else if (params.value !== undefined && params.value !== null) {
        return formatString(params.value.toString());
    }
    // 다른 경우는 그대로 반환
    else {
        return params;
    }
    // 내부 포맷팅 함수
    function formatString(input) {
        // 5-1. GT로 시작하는 경우
        if (input.startsWith("GT")) {
            return input.replace(/^GT(\d{2})(\w)(\d{2})(\d{3})(\d)$/, "GT-$1-$2-$3-$4-$5");
        }

        // 5-2. 000000000000(12개)로 끝나는 경우
        if (/000000000000$/.test(input)) {  // 숫자와 문자 모두 포함된 문자열의 끝이 '000000000000'인지 확인
	        const trimmedInput = input.slice(0, -12); // 마지막 12자리 '000000000000'을 제거
	        // 문자와 숫자가 섞여있는 경우도 고려하여 포맷팅
	        return trimmedInput.replace(/^(.{4})(.{5})(.{4})(.{1})$/, "$1-$2-$3-$4");
    	}

        // 5-3. 길이가 22자리 이상인 경우
        if (input.length >= 22) {
            return input.replace(/^(\d{14})(\w{2})(\d)(\d{3})(\d)(\d)(.*)$/, "$1-$2-$3-$4-$5-$6-$7");
        }

        // 매칭되지 않는 경우 원본 반환
        return input;
    }
}
// 날짜 포맷터
function dateFormatter(params) {
	// 입력 값이 문자열인지 확인
//	console.log("params 타입:", typeof params);
 //   console.log("params 값:", params);
    if (typeof params === 'string' && params.length >= 8) {
        params = params.substring(0, 8); // 앞 8자리만 추출
    } else if (params.value) {
		if(params.value.length >= 8){
			params.value = params.value.substring(0, 8); // 앞 8자리만 추출
		}
		// params가 객체이고 value 속성이 있는 경우
		return formatDate(params.value);
	}
	return params.value; // 날짜 형식이 아니면 원래 값을 반환
}
function formatDate(value) {
	if (value.length === 8) {
		var year = value.substring(0, 4);
		var month = value.substring(4, 6);
		var day = value.substring(6, 8);
		return year + "-" + month + "-" + day;
	}
	return value; // 길이가 8이 아닌 경우 원래 값을 반환
}

function initializeSelectOptions() {
	const srcOpt = document.getElementById('srcOpt');
	const srcOptValue = document.getElementById('srcOptValue');

	srcOpt.addEventListener('change', function() {
		if (this.value === '') {
			srcOptValue.value = '';
			srcOptValue.disabled = true;
		} else {
			srcOptValue.disabled = false;
		}
	});

	// 초기 로드 시 선택된 값에 따라 입력 필드의 상태를 설정합니다.
	if (srcOpt.value === '') {
		srcOptValue.disabled = true;
	}
}

function formatToYYYYMMDD(dateStr) {
    if (!dateStr) return '';
    return dateStr.replace(/-/g, '');
}
function getCurrentDate(offsetDays = 0) {
    var date = new Date();
    date.setDate(date.getDate() + offsetDays); // offsetDays 만큼 날짜를 조정
    var year = date.getFullYear();
    var month = ('0' + (date.getMonth() + 1)).slice(-2);
    var day = ('0' + date.getDate()).slice(-2);
    return year + '-' + month + '-' + day;
}