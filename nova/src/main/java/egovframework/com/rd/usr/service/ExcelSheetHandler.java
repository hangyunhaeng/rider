package egovframework.com.rd.usr.service;
import lombok.Getter;
import lombok.Setter;
import org.apache.poi.ss.util.CellReference;
import org.apache.poi.xssf.binary.XSSFBSheetHandler.SheetContentsHandler;
import org.apache.poi.xssf.usermodel.XSSFComment;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Getter
@Setter
public class ExcelSheetHandler implements SheetContentsHandler {

    private int currentCol = -1;
    private int currRowNum = 0;
    private List<String> row = new ArrayList<>();
    private List<List<String>> rows = new ArrayList<>();    // 실제 엑셀을 파싱해서 담아지는 데이터
    private List<String> header = new ArrayList<>();
    private String sheetType = "";
    private List<Map<String, String>> rowsWithHeader = new ArrayList<>();
    private Integer firstRowIndex = 0;

    @Override
    public void startRow(int arg0) {
        this.currentCol = -1;
        this.currRowNum = arg0;
    }

    @Override
    public void cell(String columnName, String value, XSSFComment var3) {
        int iCol = (new CellReference(columnName)).getCol();
        int emptyCol = iCol - currentCol - 1;

        for (int i = 0; i < emptyCol; i++) {
            //row.add("");
        	row.add(null);
        }
        currentCol = iCol;
        row.add(value);
    }

    @Override
    public void headerFooter(String arg0, boolean arg1, String arg2) {
        // 사용 X
    }

    @Override
    public void endRow(int rowNum) {
        if (rowNum == 0) {
            header = new ArrayList(row);
        } else {
            if (row.size() < header.size()) {
                for (int i = row.size(); i < header.size(); i++) {
                    row.add("");
                }
            }
            rows.add(new ArrayList(row));
        }
        row.clear();
    }

    @Override
    public void hyperlinkCell(String arg0, String arg1, String arg2, String arg3, XSSFComment arg4) {
        // TODO Auto-generated method stub

    }
}