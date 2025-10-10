package egovframework.com.rd.usr.service.vo;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


/**
 * 일일 배달처리비 VO 클래스
 * @author
 * @since
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------      --------    ---------------------------
 *
 * </pre>
 */
@SuppressWarnings("serial")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@EqualsAndHashCode(callSuper = true)
public class DeliveryInfoVO extends Sch implements Serializable {

	/* 협력사아이디 */
	private String cooperatorId = "";
	/* 협력사명 */
	private String cooperatorNm = "";
	/* 사업자등록번호 */
	private String registrationSn = "";
	/* 사업자명 */
	private String registrationNm = "";
	/* 운행일 */
	private String runDe = "";
	/* 배달번호 */
	private String deliverySn = "";
	/* 배달상태 */
	private String deliveryState = "";
	/* 서비스타입 */
	private String serviceType = "";
	/* 배달방식 */
	private String deliveryType = "";
	/* 라이더ID */
	private String riderId = "";
	/* User ID */
	private String mberId = "";
	/* 라이더명 */
	private String riderNm = "";
	/* 배달수단 */
	private String deliveryMethod = "";
	/* 가게번호 */
	private String shopSn = "";
	/* 가게이름 */
	private String shopNm = "";
	/* 상품가격 */
	private String goodsPrice = "";
	/* 픽업 주소 */
	private String pickupAddr = "";
	/* 전달지 주소 */
	private String destinationAddr = "";
	/* 주문시간 */
	private String orderDt = "";
	/* 배차완료 */
	private String operateRiderDt = "";
	/* 가게도착 */
	private String shopComeinDt = "";
	/* 픽업완료 */
	private String pickupFinistDt = "";
	/* 전달완료 */
	private String deliveryFinistDt = "";
	/* 거리 */
	private String distance = "";
	/* 추가배달사유 */
	private String addDeliveryReason = "";
	/* 추가배달상세내용 */
	private String addDeliveryDesc = "";
	/* 픽업지 법정동 */
	private String pickupLawDong = "";
	/* 기본단가 */
	private int basicPrice = 0;
	/* 기상할증 */
	private int weatherPrimage = 0;
	/* 추가할증 */
	private int addPrimage = 0;
	/* 피크할증 등 */
	private int peakPrimageEtc = 0;
	/* 지역할증 */
	private int areaPrimage = 0;
	/* 대량할증 */
	private int amountPrimage = 0;
	/* 배달처리비 */
	private int deliveryPrice = 0;
	/* 라이더귀책여부 */
	private String riderCauseYn = "";
	/* 추가할증사유 */
	private String addPrimageDesc = "";
	/* 비고 */
	private String note = "";
	/* 업로드 파일 id */
	private String atchFileId = "";
	/* 생성자ID */
	private String creatId = "";



}
