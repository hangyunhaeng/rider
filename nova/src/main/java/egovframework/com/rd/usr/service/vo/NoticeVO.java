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
public class NoticeVO extends Sch implements Serializable {

	//NOT_ID
	private String notId;
	//제목
	private String title;
	//내용
	private String longtxt;
	//공지대상-총판->협력사(AC),총판->라이더(AR),협력사->협력사(CC),협력사->라이더(CR)
	private String notType;
	//첨부파일ID
	private String atchFileId;
	//적용시작일
	private String startDt;
	//적용종료일
	private String endDt;
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
	//rownum
	private String rn;
	private String authorCode;
	private String authorCodeNm;

}
