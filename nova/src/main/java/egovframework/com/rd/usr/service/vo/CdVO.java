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
public class CdVO extends Sch implements Serializable {
	private String cd;
}
