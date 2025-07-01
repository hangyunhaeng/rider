package egovframework.com.keiti.conv.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.com.keiti.conv.service.ActInfoVO;
import egovframework.com.keiti.conv.service.EgovConvInfoService;
import egovframework.com.keiti.conv.service.FndBdgInfoVO;
import egovframework.com.keiti.conv.service.IoeBdgInfoVO;
import egovframework.com.keiti.conv.service.PartInfoVO;

/**
 * 협약관리하기 위한 서비스 구현 클래스
 *
 * @author 조경규
 * @since 2024.07.29
 * @version 1.0
 * @see
 *
 *      <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2024.07.29  조경규          최초 생성
 *
 *      </pre>
 */
@Service("EgovConvInfoService")
public class EgovConvInfoServiceImpl extends EgovAbstractServiceImpl implements EgovConvInfoService {

	@Resource(name = "ConvInfoDAO")
	private ConvInfoDAO convInfoDAO;

	/**
	 * 과제 목록을 조회한다.
	 *
	 * @param AddressBookVO
	 * @return Map<String, Object>
	 * @exception Exception
	 *
	 *
	 */
	public Map<String, Object> selectPartInfoList(String taskNo) throws Exception {

		List<PartInfoVO> result = convInfoDAO.selectPartInfoList(taskNo);

		int cnt = convInfoDAO.selectPartInfoListCnt(taskNo);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);
		map.put("resultCnt", Integer.toString(cnt));

		return map;
	}

	@Override
	public Map<String, Object> selectIoeBdgInfoList(String taskNo, String bdgTp) throws Exception {

		List<IoeBdgInfoVO> result = convInfoDAO.selectIoeBdgInfoList(taskNo,bdgTp);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);

		return map;
	}

	@Override
	public Map<String, Object> selectFndBdgInfoList(String taskNo, String fndTp) throws Exception {
		List<FndBdgInfoVO> result = convInfoDAO.selectFndBdgInfoList(taskNo,fndTp);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);

		return map;
	}

	@Override
	public Map<String, Object> selectActInfoList(String taskNo) throws Exception {
		List<ActInfoVO> result = convInfoDAO.selectActInfoList(taskNo);


		Map<String, Object> map = new HashMap<String, Object>();

		map.put("resultList", result);

		return map;
	}

}
