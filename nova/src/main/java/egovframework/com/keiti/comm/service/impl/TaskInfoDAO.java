package egovframework.com.keiti.comm.service.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.com.cmm.service.impl.EgovComAbstractDAO;
import egovframework.com.keiti.comm.service.TaskInfoVO;

/**
 * TASK 관리하는 서비스를 정의하기위한 데이터 접근 클래스
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
@Repository("TaskInfoDAO")
public class TaskInfoDAO extends EgovComAbstractDAO{

	/**
     * 주어진 조건에 따른 과제목록을 불러온다.
     *
     * @param String
     * @return
     * @throws Exception
     */
	public TaskInfoVO selectTaskInfoOne(String taskNo) throws Exception {
		return selectOne("CommDAO.selectTaskInfoOne", taskNo);
    }
    /**
     * 주어진 조건에 따른 과제목록을 불러온다.
     *
     * @param TaskInfoVO
     * @return
     * @throws Exception
     */
	public List<TaskInfoVO> selectTaskInfoList(TaskInfoVO stifVO) throws Exception {
		return selectList("CommDAO.selectTaskInfoList", stifVO);
    }

    /**
     * 사용자 목록에 대한 전체 건수를 조회한다.
     *
     * @param TaskInfoVO
     * @throws Exception
     */
    public int selectTaskInfoListCnt(TaskInfoVO stifVO) throws Exception {
        return (Integer)selectOne("CommDAO.selectTaskInfoListCnt", stifVO);
    }
}

