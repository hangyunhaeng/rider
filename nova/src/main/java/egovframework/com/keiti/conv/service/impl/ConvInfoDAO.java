package egovframework.com.keiti.conv.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.keiti.conv.service.ActInfoVO;
import egovframework.com.keiti.conv.service.FndBdgInfoVO;
import egovframework.com.keiti.conv.service.IoeBdgInfoVO;
import egovframework.com.keiti.conv.service.PartInfoVO;

/**
 * 협약관리하는 서비스를 정의하기위한 데이터 접근 클래스
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
@Repository("ConvInfoDAO")
public class ConvInfoDAO extends EgovComAbstractDAO {

	/**
	 * 주어진 조건에 따른 참여연구원을 불러온다.
	 *
	 * @param TaskInfoVO
	 * @return
	 * @throws Exception
	 */
	public List<PartInfoVO> selectPartInfoList(String taskNo) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("taskNo", taskNo);
		return selectList("ConvInfoDAO.selectPartInfoList", params);
	}

	/**
	 * 참여연구원목록에 대한 전체 건수를 조회한다.
	 *
	 * @param TaskInfoVO
	 * @throws Exception
	 */
	public int selectPartInfoListCnt(String taskNo) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("taskNo", taskNo);
		return (Integer) selectOne("ConvInfoDAO.selectPartInfoListCnt", params);
	}

	/**
	 * 주어진 조건에 따른 비목별예산을 불러온다.
	 *
	 * @param TaskInfoVO
	 * @return
	 * @throws Exception
	 */
	public List<IoeBdgInfoVO> selectIoeBdgInfoList(String taskNo, String bdgTp) throws Exception {
		Map<String, Object> params = new HashMap<>();
        params.put("taskNo", taskNo);
        params.put("bdgTp", bdgTp);
		return selectList("ConvInfoDAO.selectIoeBdgInfoList", params);
	}
	/**
	 * 주어진 조건에 따른 재원별예산을 불러온다.
	 *
	 * @param taskNo,fndTp
	 * @return
	 * @throws Exception
	 */
	public List<FndBdgInfoVO> selectFndBdgInfoList(String taskNo, String fndTp) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("taskNo", taskNo);
		params.put("fndTp", fndTp);
		return selectList("ConvInfoDAO.selectFndBdgInfoList", params);
	}
	/**
	 * 주어진 조건에 따른 계좌정보를 불러온다.
	 *
	 * @param taskNo
	 * @return
	 * @throws Exception
	 */
	public List<ActInfoVO> selectActInfoList(String taskNo) throws Exception {
		Map<String, Object> params = new HashMap<>();
		params.put("taskNo", taskNo);
		return selectList("ConvInfoDAO.selectActInfoList", params);
	}
}
