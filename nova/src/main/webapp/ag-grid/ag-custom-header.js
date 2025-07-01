class CustomHeader {
    init(params) {
        this.params = params;

        // 컨테이너 요소 생성
        this.eGui = document.createElement('div');
        this.eGui.className = 'ag-header-cell-comp-wrapper custom-header';
        this.eGui.innerHTML = `
            <div class="custom-header-container">
                <div class="custom-header-label">${this.params.displayName}</div>
                <div class="custom-header-sort-icons">
                    <span class="asc-icon" style="display: none;">▲</span>
                    <span class="desc-icon" style="display: none;">▼</span>
                </div>
            </div>
        `;

        // 헤더 전체에 클릭 이벤트 리스너 추가
        this.eGui.addEventListener('click', () => {
            this.customSort();
            this.updateSortIcons();
        });

        // 초기 정렬 상태 설정
        this.updateSortIcons();
    }

    getGui() {
        return this.eGui;
    }

    updateSortIcons() {
        const sortState = this.params.column.getSort();
        const ascIcon = this.eGui.querySelector('.asc-icon');
        const descIcon = this.eGui.querySelector('.desc-icon');

        if (sortState === 'asc') {
            ascIcon.style.display = 'inline';
            descIcon.style.display = 'none';
        } else if (sortState === 'desc') {
            ascIcon.style.display = 'none';
            descIcon.style.display = 'inline';
        } else {
            ascIcon.style.display = 'none';
            descIcon.style.display = 'none';
        }
    }

    customSort() {
        // 현재 컬럼의 모든 행 데이터를 가져옵니다.
        const row = this.params.api.getDisplayedRowAtIndex(0);
        if (!row) return; // 행이 없으면 정렬하지 않음

        const firstValue = row.data[this.params.column.getColId()];

        // 데이터가 null 또는 undefined가 아닌지 확인하고 쉼표를 제거한 후 숫자 변환을 시도합니다.
        const isNumeric = firstValue != null && !isNaN(parseFloat(firstValue.replace(/,/g, ''))) && isFinite(firstValue.replace(/,/g, ''));

        if (isNumeric) {
            // 숫자형 정렬을 위해 comparator를 설정
            this.params.column.colDef.comparator = (valueA, valueB) => {
                const numA = parseFloat(valueA.replace(/,/g, ''));
                const numB = parseFloat(valueB.replace(/,/g, ''));
                return numA - numB;
            };

            // 정렬 상태 변경
            this.params.api.refreshCells({ force: true });
        }

        // 기본 정렬
        this.params.progressSort();
    }
}

// 등록된 사용자 정의 컴포넌트를 글로벌 네임스페이스에 추가
window.CustomHeader = CustomHeader;
