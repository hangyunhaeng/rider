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
public class MyInfoVO extends Sch implements Serializable {

	private String mberId;
	private String mberNm;
	private String mberEmailAdres;
	private String mbtlnum;
	private String password;
	private String befPassword;

	private String bnkCd;
	private String accountNum;
	private String accountNm;
	private String bnkNm;
	private String bnkId;
	private String esntlId;
	private String creatId;
	private String lastUpdusrId;
	private String cooperatorNm;
	private String companyNm;
	private String registrationSn;
	private String ceoNm;

	private int dayAblePrice;
	private int weekAblePrice;
	private String useAt;
	private String gubun;
	private String authorCode;
	private String authorCodeNm;
}
