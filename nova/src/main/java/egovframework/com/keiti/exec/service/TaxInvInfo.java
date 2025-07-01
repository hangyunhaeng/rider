package egovframework.com.keiti.exec.service;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
/**
 * 세금계산서를 위한 모델 클래스
 * @author 조경규
 * @since 2024.07.19
 * @version 1.0
 * @see
 *
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2024.7.19  조경규          최초 생성
 *
 */
@SuppressWarnings("serial")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TaxInvInfo implements Serializable{
    private String issueId;          // 세금계산서 승인번호 (Primary Key)
    private String aspOrgCd;         // ASP 업체코드
    private String aspId;            // 서비스 사업자 관리번호
    private String aspRefDocId;      // 사업자 관리 번호
    private String aspIsD;           // 전자세금계산서 발행일시
    private String isD;              // 전자세금계산서 작성일자
    private String typeCd;           // 전자세금계산서 종류
    private String prpsCd;           // 영수/청구 구분자
    private String mdfRsn;           // 수정 사유 코드
    private String rmk;              // 비고
    private String imDocId;          // 수입 신고서 번호
    private String imAcpStD;         // 일괄발급 시작일자
    private String imAcpEndD;        // 일괄발급 종료일자
    private String imItmQty;         // 일괄발급 수입 총건
    private String sndBsnRgN;        // 공급자 사업자등록번호
    private String sndTxId;          // 공급자 종사업장 식별코드
    private String sndName;          // 공급업체 사업체명
    private String sndRprsndNm;      // 공급업체 대표자명
    private String sndAdr;           // 공급업체 주소
    private String sndBcnd;          // 공급업체 업태
    private String sndItp;           // 공급업체 업종
    private String sndChpDpt;        // 공급업체 담당부서
    private String sndChpNm;         // 공급업체 담당자명
    private String sndChpPhn;        // 공급업체 담당자 전화번호
    private String sndChpEm;         // 공급업체 담당자 이메일
    private String rcvBsnCd;         // 수신업체 사업자등록번호 구분코드
    private String rcvBsnRgN;        // 수신업체 사업자등록번호
    private String rcvTxId;          // 수신업체 종사업장 식별코드
    private String rcvName;          // 수신업체 사업체명
    private String rcvRprsNm;        // 수신업체 대표자명
    private String rcvAdr;           // 수신업체 주소
    private String rcvBcnd;          // 수신업체 업태
    private String rcvItp;           // 수신업체 업종
    private String rcvChpDpt;        // 수신업체 담당부서
    private String rcvChpNm;         // 수신업체 담당자명
    private String rcvChpPhn;        // 수신업체 담당자 전화번호
    private String rcvChpEm;         // 수신업체 담당자 이메일
    private String rcvSubChpDpt;     // 수신업체 부서 담당부서
    private String rcvSubChpNm;      // 수신업체 부서 담당자명
    private String rcvSubChpPhn;     // 수신업체 부서 담당자 전화번호
    private String rcvSubChpEm;      // 수신업체 부서 담당자 이메일
    private String brkBsnRgN;        // 수탁사업자 사업자등록번호
    private String brkTxId;          // 수탁사업자 종사업장 식별코드
    private String brkName;          // 수탁사업자 사업체명
    private String brkRprsNm;        // 수탁사업자 대표자명
    private String brkAdr;           // 수탁사업자 주소
    private String brkBcnd;          // 수탁사업자 업태
    private String brkItp;           // 수탁사업자 업종
    private String brkChpDpt;        // 수탁사업자 담당부서
    private String brkChpNm;         // 수탁사업자 담당자명
    private String brkChpPhn;        // 수탁사업자 담당자 전화번호
    private String brkChpEm;         // 수탁사업자 담당자 이메일
    private String csAmt;            // 현금 금액
    private String chkAmt;           // 수표 금액
    private String bilAmt;           // 어음 금액
    private String crdtAmt;          // 외상 금액
    private String supplyAmt;        // 총 공급가액
    private String taxAmt;           // 총 세액
    private String totAmt;           // 총액 (공급가액 + 세액)
    private String shcEtcInfo;       // 기타 정보
    private String exeRgAmt;         // 이행액
    private String rsnRmk;           // 비고
}