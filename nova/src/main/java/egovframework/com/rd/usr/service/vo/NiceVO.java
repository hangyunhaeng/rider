package egovframework.com.rd.usr.service.vo;

import java.io.Serializable;
import java.math.BigDecimal;

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
public class NiceVO extends Sch implements Serializable {

	private String token_version_id;
	private String enc_data;
	private String integrity_value;

	private String req_no;
	private String key;
	private String iv;
	private String hmac_key;

	private String resultMsg;
	private String resultCode;
}
