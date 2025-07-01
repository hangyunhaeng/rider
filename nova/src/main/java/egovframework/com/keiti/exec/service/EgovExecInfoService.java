package egovframework.com.keiti.exec.service;

import java.util.Map;

/**
 * 집행관리를 위한 서비스 인터페이스 클래스
 * @author 조경규
 * @since 2024.07.19
 * @version 1.0
 * @see
 *
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2024.7.19  조경규          최초 생성
 *
 */
public interface EgovExecInfoService {


    /**
     * 집행내역을 조회한다.
     * @param ExecInfoVO
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectExecInfoList(ExecInfoVO exifVO) throws Exception;

    /**
     * 예실대비표를 조회한다.
     * @param ExecInfoVO
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectBdgSummaryInfoList(ExecInfoVO eiVO) throws Exception;
    /**
     * 집행 방법별 집행내역 조회한다.
     * @param ExecInfoVO
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectExecSummaryInfoList(String taskNo) throws Exception;
    /**
     * 공통서류내역 조회한다.
     * @param ExecInfoVO
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectCommonDocInfoList(CommonDocInfoVO cdVO) throws Exception;
    /**
     * 정산증빙 조회한다.
     * @param ExecFileInfoVO
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectExecFileInfoList(ExecInfoVO eiVO) throws Exception;
    /**
     * 세금계산서 조회한다.
     * @param ExecInfoVO
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectTaxInvInfoList(ExecInfoVO eiVO) throws Exception;
    /**
     * 세금계산서 항목 조회한다.
     * @param ExecInfoVO
     * @return  Map<String, Object>
     * @exception Exception
     */
    public Map<String, Object> selectTaxInvItmInfoList(ExecInfoVO eiVO) throws Exception;


}