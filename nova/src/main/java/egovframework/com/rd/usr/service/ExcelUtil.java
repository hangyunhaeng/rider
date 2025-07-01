package egovframework.com.rd.usr.service;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.xssf.eventusermodel.ReadOnlySharedStringsTable;
import org.apache.poi.xssf.eventusermodel.XSSFReader;
import org.apache.poi.xssf.eventusermodel.XSSFSheetXMLHandler;
import org.apache.poi.xssf.model.StylesTable;
import org.xml.sax.ContentHandler;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;

public class ExcelUtil {
    public List<ExcelSheetHandler> readExcel(InputStream fileInputStream) throws Exception{

        List<ExcelSheetHandler> sheetHandlers = new ArrayList<>();
//        try {
            // 바이트 데이터를 OOXML(오픈 XML 문서)형식으로 압축해서 가져와서 메모리에 올린다
            OPCPackage opc = OPCPackage.open(fileInputStream);

            // OOXML 엑셀파일 읽기 위한 객체 생성
            XSSFReader xssfReader = new XSSFReader(opc);

            // 엑셀 공통 스타일
            StylesTable styles = xssfReader.getStylesTable();

            // 시트 별 데이터 가져오기
            Iterator<InputStream> sheets = xssfReader.getSheetsData();

            // 엑셀 파일의 공유 문자열 테이블을 생성한다
            // 공유 문자열 테이블 : 엑셀 파일에서 N개의 셀에서 중복되는 데이터(문자)가 있을때, 중복되는 동일한 데이터를 공유 문자열 테이블에 넣어서 한번만 읽고 쓰도록 해준다  (각 N개의 셀에는 데이터 자체를 넣지 않고, 해당 데이터가 존재하는 공유 문자열 테이블의 정보를 넣는다)
            // 메모리를 절약하여 매우 효율적으로 엑셀 파일 READ/WRITE를 할수 있게 도와준다.
            ReadOnlySharedStringsTable strings = new ReadOnlySharedStringsTable(opc);

            // 엑셀 시트 별로 읽어서 ExcelSheetHandler 객체 생성 후 리스트 담기
            if (sheets instanceof XSSFReader.SheetIterator) {
                XSSFReader.SheetIterator sheetIterator = (XSSFReader.SheetIterator) sheets;
                while (sheetIterator.hasNext()) {
                InputStream inputStream = sheetIterator.next();

                // OOXML 형식의 엑셀 파일을 SAX parser를 사용하여 읽는다.
                InputSource inputSource = new InputSource(inputStream);

                // XML 파서 생성
                SAXParserFactory saxParserFactory = SAXParserFactory.newInstance();
                saxParserFactory.setNamespaceAware(true);
                SAXParser parser = saxParserFactory.newSAXParser();
                XMLReader xmlReader = parser.getXMLReader();

				// XML 파서의 이벤트 핸들러 등록 (ContentHandler)
                ExcelSheetHandler sheetHandler = new ExcelSheetHandler();
                sheetHandler.setSheetType(sheetIterator.getSheetName());

                DataFormatter dataFormatter = new DataFormatter();
                dataFormatter.addFormat("General", new java.text.DecimalFormat("#.###############")); // ** 셀 값중 숫자 데이터가 지수형태로 변경되지 않게 해주는 세팅

                ContentHandler handle = new XSSFSheetXMLHandler(styles, strings, sheetHandler, dataFormatter, false);

                xmlReader.setContentHandler(handle);

                // 엑셀 시트별로 읽기 (엑셀 파일을 한줄 씩 읽는 이벤트 기반 파싱 방식 사용)
                xmlReader.parse(inputSource);
                inputStream.close();

                // 읽은 결과 저장
                sheetHandlers.add(sheetHandler);
                }
            }

            opc.close();

//        } catch (Exception e) {
//            e.printStackTrace();
//        }

        return sheetHandlers;

    }
}