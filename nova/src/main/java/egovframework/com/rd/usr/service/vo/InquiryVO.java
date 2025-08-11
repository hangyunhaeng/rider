package egovframework.com.rd.usr.service.vo;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@SuppressWarnings("serial")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@EqualsAndHashCode(callSuper = true)
public class InquiryVO extends Sch implements Serializable {

	//INQ_ID
	private String inqId;
	//원본글_ID
	private String upInqId;
	//제목
	private String title;
	//내용
	private String longtxt;
	//사용여부
	private String useAt;
	//등록일
	private String creatDt;
	//생성자 ID
	private String creatId;
	//생성자 이름
	private String creatNm;
	//최종수정시점
	private String lastUpdtPnttm;
	//최종수정자ID
	private String lastUpdusrId;
	//수정권한
	private String modifyAuth;
	//게시중 여부
	private String notYn;
	//원글, 답글 구분
	private String gubun;
	//rownum
	private String rn;

	private String mbtlnum;

}
