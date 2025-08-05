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
public class KkoVO extends Sch implements Serializable {

	private String sendAccessToken;
	private String sendRefreshToken;

	private String kkoId;
	private String upKkoId;
	private String mberId;
	private String gubun;
	private String mbtlnum;
	private String url;
	private String sendLongtxt;
	private String recvLongtxt;
	private String code;
	private String referenceKey;
	private String userKey;
	private String status;
	private String kaorsltcode;
	private String bigo;
	private String sendDt;
	private String creatDt;
	private String creatId;
	private String param0;
	private String param1;
	private String param2;
	private String param3;
	private String param4;
	private String param5;
	private String param6;
	private String param7;
	private String param8;
	private String param9;

	private String rn;
	private String fix;
	private String mberNm;
	private String cdNm;
	private String templateCode;
}
