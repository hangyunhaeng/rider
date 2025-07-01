package egovframework.com.rd.usr.service.vo;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@SuppressWarnings("serial")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class Sch implements Serializable {

	//사업자번호
	private String schIhidNum;
	//사용자 권한(ROLE_ADMIN : 총판 , ROLE_USER : 협력사)
	private String schAuthorCode;
	//사용자 구분(GNR : 라이더, USR: 운영사)
	private String schUserSe;
	private String schId;

	private String searchAtchFileId;
	private String searchWeekId;
	private String searchDate;
	private String searchRunDeDate;

	private String searchFromDate;
	private String searchToDate;

	private String searchCooperatorId;
	private String searchGubun;
	/* 조회조건 */
	private String searchId;
	private String searchNm;
	private String searchMberId;
	private String searchRegistrationSn;



    /** select box용도 */
    private String seleceKey;
    /** select box용도 */
	private String selectValue;
	private String schCdGroup;



	private String schTotal;
	private int schIdx;		//현재페이지
	private int schPagePerCnt;	//페이지당갯수
	private int totalCnt;	//공지사항 총갯수


	private String chk;
	private boolean isSum;		//합계 여부
	private String searchError;	//에러건 조회 여부


}
