package egovframework.com.keiti.conv.service;

import java.util.Map;

/**
 * 주소록정보를 관리하기 위한 서비스 인터페이스 클래스
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
public interface EgovConvInfoService {


    /**
     * 참여연구원을 조회한다.
     * @param taskInfoVO
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectPartInfoList(String taskNo) throws Exception;
    /**
     * 비목별예산 조회한다.
     * @param taskNo , bdgTp
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectIoeBdgInfoList(String taskNo,String bdgTp) throws Exception;
    /**
     * 재원별예산 조회한다.
     * @param taskNo , fndTp
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectFndBdgInfoList(String taskNo,String fndTp) throws Exception;
    /**
     * 계좌정보 조회한다.
     * @param taskNo , fndTp
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectActInfoList(String taskNo) throws Exception;


}