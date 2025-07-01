package egovframework.com.keiti.comm.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.keiti.comm.service.KeyInfoVO;
import egovframework.com.keiti.comm.service.TaskInfoVO;

/**
 * TASK정보를 관리하는 서비스를 정의하기위한 데이터 접근 클래스
 * @author 조경규
 * @since 2024.07.29
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2024.07.29  조경규          최초 생성
 * </pre>
 */
@Repository("CommDAO")
public class CommDAO extends EgovComAbstractDAO{
    /**
     * 주어진 조건에 따른 세목목록을 불러온다.
     *
     * @param TaskInfoVO
     * @return
     * @throws Exception
     */
	public List<Map<String, String>> selectIoeInfoList(TaskInfoVO stifVO) throws Exception {
		return selectList("CommDAO.selectIoeInfoList", stifVO);
    }
	/**
	 * 주어진 조건에 따른 사업목록을 불러온다.
	 *
	 * @param TaskInfoVO
	 * @return
	 * @throws Exception
	 */
	public List<KeyInfoVO> selectBizInfoList(TaskInfoVO stifVO) throws Exception {
		return selectList("CommDAO.selectBizInfoList", stifVO);
	}
}

