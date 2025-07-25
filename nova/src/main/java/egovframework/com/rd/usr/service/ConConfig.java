package egovframework.com.rd.usr.service;

import org.egovframe.rte.fdl.idgnr.EgovIdGnrService;
import org.egovframe.rte.fdl.idgnr.impl.EgovTableIdGnrServiceImpl;
import org.egovframe.rte.fdl.idgnr.impl.strategy.EgovIdGnrStrategyImpl;

import javax.annotation.Resource;
import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @Class Name : EgovPrivacyConfig.java
 * @Description : 개인정보 조회 이력 관리를 위한 JavaConfig
 * @Modification Information
 *
 *    수정일         수정자         수정내용
 *    -------        -------     -------------------
 *    2014.09.11	표준프레임워크		최초생성
* @author Vincent Han
 * @since 2014.09.11
 * @version 3.5
 */
@Configuration
public class ConConfig {

	@Resource(name = "egov.dataSource")
	DataSource dataSource;

	@Bean(destroyMethod = "destroy")
	public EgovIdGnrService egovWeekIdGnrService() {

		EgovIdGnrStrategyImpl strategy = new EgovIdGnrStrategyImpl();
		strategy.setPrefix("CON_");
		strategy.setCipers(14);
		strategy.setFillChar('0');

		EgovTableIdGnrServiceImpl idGnrService = new EgovTableIdGnrServiceImpl();
		idGnrService.setDataSource(dataSource);
		idGnrService.setStrategy(strategy);
		idGnrService.setBlockSize(10);
		idGnrService.setTable("RD_COOPERATOR_RIDER_CONNECT");
		idGnrService.setTableName("CONLOG_ID");

		return idGnrService;
	}

}
