package egovframework.com.keiti.comm.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;

import egovframework.com.keiti.comm.service.EgovTaskInfoService;
import egovframework.com.keiti.comm.service.TaskInfoVO;

/**
 * TASK정보를 관리하기 위한 서비스 구현  클래스
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
@Service("EgovTaskInfoService")
public class EgovTaskInfoServiceImpl extends EgovAbstractServiceImpl implements EgovTaskInfoService{


    @Resource(name = "TaskInfoDAO")
    private TaskInfoDAO taskInfoDAO;

    /**
     * 과제 목록을 조회한다.
     * @param AddressBookVO
     * @return  Map<String, Object>
     * @exception Exception
     *
     *
     */
    public Map<String, Object> selectTaskInfoList(TaskInfoVO taskInfoVO) throws Exception {

        List<TaskInfoVO> result = taskInfoDAO.selectTaskInfoList(taskInfoVO);

        int cnt = taskInfoDAO.selectTaskInfoListCnt(taskInfoVO);

        Map<String, Object> map = new HashMap<String, Object>();


        map.put("resultList", result);
        map.put("resultCnt", Integer.toString(cnt));

        return map;
    }
    /**
     * 과제정보를 조회한다.
     * @param AddressBookVO
     * @return  Map<String, Object>
     * @exception Exception
     *
     *
     */
    public TaskInfoVO selectTaskInfoOne(String taskNo) throws Exception {

    	TaskInfoVO result = taskInfoDAO.selectTaskInfoOne(taskNo);
        return result;
    }

    public static <T> String convertToJSON(List<T> data) {
        Gson gson = new Gson();
        return gson.toJson(data);
    }

}
