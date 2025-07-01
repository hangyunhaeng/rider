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
public class UploadStateVO extends Sch implements Serializable {

	private String atchFileId;
	private String orignlFileNm;
	private String cooperatorId;
	private String cooperatorNm;
	private String weekId;
	private String accountsStDt;
	private String accountsEdDt;
	private String cnt;
	private String creatDt;
}
