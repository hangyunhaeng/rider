package egovframework.com.keiti.exec.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.keiti.exec.service.BdgSummaryInfoVO;
import egovframework.com.keiti.exec.service.CommonDocInfoVO;
import egovframework.com.keiti.exec.service.ExecFileInfoVO;
import egovframework.com.keiti.exec.service.ExecInfoVO;
import egovframework.com.keiti.exec.service.ExecSummaryInfoVO;
import egovframework.com.keiti.exec.service.TaxInvInfoVO;
import egovframework.com.keiti.exec.service.TaxInvItmInfoVO;

/**
 * 집행관리 서비스를 정의하기 위한 데이터 접근 클래스
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
@Repository("ExecInfoDAO")
public class ExecInfoDAO extends EgovComAbstractDAO{

    /**
     * 집행내역을 조회한다.
     *
     * @param ExecInfoVO
     * @return List<ExecInfoVO>
     * @throws Exception
     */
	public List<ExecInfoVO> selectExecInfoList(ExecInfoVO exifVO) throws Exception {
		return selectList("ExecInfoDAO.selectExecInfoList", exifVO);
    }

    /**
     * 집행내역의 전체 건수를 조회한다.
     *
     * @param exifVO
     * @throws Exception
     */
    public int selectExecInfoListCnt(ExecInfoVO exifVO) throws Exception {
        return (Integer)selectOne("ExecInfoDAO.selectExecInfoListCnt", exifVO);
    }
    /**
     * 집행내역을 조회한다.
     *
     * @param ExecInfoVO
     * @return List<ExecInfoVO>
     * @throws Exception
     */
    public List<BdgSummaryInfoVO> selectBdgSummaryInfoList(ExecInfoVO eiVO) throws Exception {
    	return selectList("ExecInfoDAO.selectBdgSummaryInfoList", eiVO);
    }
    /**
     * 집행 방법별 집행내역을 조회한다.
     *
     * @param ExecInfoVO
     * @return List<ExecInfoVO>
     * @throws Exception
     */
    public List<ExecSummaryInfoVO> selectExecSummaryInfoList(String taskNo) throws Exception {
    	return selectList("ExecInfoDAO.selectExecSummaryInfoList", taskNo);
    }
    /**
     * 공통서류 조회
     *
     * @param ExecInfoVO
     * @return List<ExecInfoVO>
     * @throws Exception
     */
    public List<CommonDocInfoVO> selectCommonDocInfoList(CommonDocInfoVO cdVO) throws Exception {
    	return selectList("ExecInfoDAO.selectCommonDocInfoList", cdVO);
    }

    /**
     * 정산증빙 조회
     *
     * @param ExecInfoVO
     * @return List<ExecInfoVO>
     * @throws Exception
     */
    public List<ExecFileInfoVO> selectExecFileInfoList(ExecInfoVO eiVO) throws Exception {
    	return selectList("ExecInfoDAO.selectExecFileInfoList", eiVO);
    }
    /**
     * 세금계산서 조회
     *
     * @param ExecInfoVO
     * @return List<ExecInfoVO>
     * @throws Exception
     */
    public List<TaxInvInfoVO> selectTaxInvInfoList(ExecInfoVO eiVO) throws Exception {
    	return selectList("ExecInfoDAO.selectTaxInvInfoList", eiVO);
    }
    /**
     * 세금계산서항목 조회
     *
     * @param ExecInfoVO
     * @return List<ExecInfoVO>
     * @throws Exception
     */
    public List<TaxInvItmInfoVO> selectTaxInvItmInfoList(ExecInfoVO eiVO) throws Exception {
    	return selectList("ExecInfoDAO.selectTaxInvItmInfoList", eiVO);
    }
}

