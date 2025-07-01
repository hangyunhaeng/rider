package egovframework.com.keiti.exec.service;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
/**
 * 세금계산서 항목별조회를 위한 모델 클래스
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
public class TaxInvItmInfo implements Serializable{
    private String issueId;          // 세금계산서 승인번호
    private String itmSeqN;          // ()물품 일련번호
    private String splD;             // (월일)물품 공급일자
    private String nm;               // (품목)물품명
    private String infoTxt;          // (규격)물품에 대한 규격
    private String itmDesc;          // (기타)물품과 관련된 자유기술문
    private String qty;              // (수량)물품 수량
    private String uprc;             // (단가)물품 단가
    private String supplyAmt;        // (공급가액)물품 공급 가액
    private String taxAmt;           // (세액)물품 세액
}