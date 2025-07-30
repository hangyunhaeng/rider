package egovframework.com.rd.usr.service.impl;

import java.util.Random;

import javax.annotation.Resource;

import org.apache.commons.net.nntp.Threadable;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.ibm.icu.math.BigDecimal;

import egovframework.com.rd.usr.service.BalanceService;
import egovframework.com.rd.usr.service.impl.PayDAO;
import egovframework.com.rd.usr.service.vo.BalanceVO;

@Service("myThread")
public class MyThread extends EgovAbstractServiceImpl{


	@Resource(name = "BalanceService")
	private BalanceService balanceService;

	private static final Logger LOGGER = LoggerFactory.getLogger(MyThread.class);



	public void execute() {				// 2.run()메소드 오버라이드 및 스레드 코드 작성

		Random random = new Random();
		int idx = random.nextInt(8);

		LOGGER.debug("start : "+idx);


		int randomInt =  random.nextInt(100);

		BalanceVO vo = new BalanceVO();
		vo.setSchIdx(idx);
		try {

			BalanceVO inputVo = balanceService.selectBalanceByIdx(vo);	//랜덤으로 사용자 추출
			inputVo.setCost(randomInt);
			LOGGER.debug("inputVo  MberId : "+inputVo.getMberId()+" cost : "+inputVo.getCost()+" Banlance : "+inputVo.getBalance0());
			balanceService.transactionBalance(inputVo);	//  금액 설정
			BalanceVO returnVo = balanceService.selectBalanceByMberId(inputVo);

			LOGGER.debug("returnVo  MberId : "+returnVo.getMberId()+" cost : "+inputVo.getCost()+" Banlance : "+returnVo.getBalance0());
		} catch (Exception e) {
			e.printStackTrace();
		}

		LOGGER.debug("end : "+idx);

	}

}
