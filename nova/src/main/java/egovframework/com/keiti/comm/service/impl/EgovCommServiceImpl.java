package egovframework.com.keiti.comm.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.com.keiti.comm.service.EgovCommService;
import egovframework.com.keiti.comm.service.KeyInfoVO;
import egovframework.com.keiti.comm.service.TaskInfoVO;

/**
 * 공통정보를 관리하기 위한 서비스 구현  클래스
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
@Service("EgovCommService")
public class EgovCommServiceImpl extends EgovAbstractServiceImpl implements EgovCommService{


    @Resource(name = "CommDAO")
    private CommDAO commDAO;

    private static final Map<String, List<KeyInfoVO>> cache = new ConcurrentHashMap<>();
    /**
     * 세목리스트를 조회한다.
     * @param AddressBookVO
     * @return  Map<String, Object>
     * @exception Exception
     *
     *
     */
    public Map<String, Object> selectIoeInfoList(TaskInfoVO taskInfoVO) throws Exception {

    	List<Map<String, String>> options = commDAO.selectIoeInfoList(taskInfoVO);

        Map<String, Object> map = new HashMap<String, Object>();


        map.put("resultList", options);
        map.put("options", options);

        return map;
    }

    /**
     * 사업리스트를 조회한다.
     * @param AddressBookVO
     * @return  Map<String, Object>
     * @exception Exception
     *
     *
     */
    public Map<String, Object> selectBizInfoList(TaskInfoVO taskInfoVO) throws Exception {

    	 // TaskInfoVO의 식별자를 기반으로 캐시 키 생성 (여기서는 간단히 toString을 사용)
        String cacheKey = "BIZ_CD";

        // 캐시에 데이터가 있는지 확인
        List<KeyInfoVO> options = cache.get(cacheKey);
        if (options == null) {
            // 캐시에 없으면 DB에서 데이터를 조회하고 캐시에 저장
            options = commDAO.selectBizInfoList(taskInfoVO);
            cache.put(cacheKey, options);
        }

        Map<String, Object> map = new HashMap<String, Object>();


        map.put("resultList", options);
        map.put("options", options);

        return map;
    }
    /**
     * 사업리스트를 조회한다.
     * @param AddressBookVO
     * @return  Map<String, Object>
     * @exception Exception
     *
     *
     */
    public Map<String, Object> selectBizInfoList2(TaskInfoVO taskInfoVO) throws Exception {

    	List<KeyInfoVO> options = commDAO.selectBizInfoList(taskInfoVO);

        Map<String, Object> map = new HashMap<String, Object>();


        map.put("resultList", options);
        map.put("options", options);

        return map;
    }
}
