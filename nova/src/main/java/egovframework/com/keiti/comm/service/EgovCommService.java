package egovframework.com.keiti.comm.service;

import java.util.Map;

/**
 * 공통관리하기 위한 서비스 인터페이스 클래스
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
public interface EgovCommService {


    /**
     * 세목리스트을 조회한다.
     * @param ExecInfoVO
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectIoeInfoList(TaskInfoVO taskInfoVO) throws Exception;

    /**
     * 사업리스트을 조회한다.
     * @param ExecInfoVO
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectBizInfoList(TaskInfoVO taskInfoVO) throws Exception;



}