package egovframework.com.keiti.exec.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.com.keiti.exec.service.BdgSummaryInfoVO;
import egovframework.com.keiti.exec.service.CommonDocInfoVO;
import egovframework.com.keiti.exec.service.EgovExecInfoService;
import egovframework.com.keiti.exec.service.ExecFileInfoVO;
import egovframework.com.keiti.exec.service.ExecInfoVO;
import egovframework.com.keiti.exec.service.ExecSummaryInfoVO;
import egovframework.com.keiti.exec.service.TaxInvInfoVO;
import egovframework.com.keiti.exec.service.TaxInvItmInfoVO;

/**
 * 집행관리를 위한 서비스 구현  클래스
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
@Service("EgovExecInfoService")
public class EgovExecInfoServiceImpl extends EgovAbstractServiceImpl implements EgovExecInfoService{


    @Resource(name = "ExecInfoDAO")
    private ExecInfoDAO exifDAO;

    /**
     * 과제 목록을 조회한다.
     * @param AddressBookVO
     * @return  Map<String, Object>
     * @exception Exception
     *
     *
     */
    public Map<String, Object> selectExecInfoList(ExecInfoVO exifVO) throws Exception {

        List<ExecInfoVO> result = exifDAO.selectExecInfoList(exifVO);

        int cnt = exifDAO.selectExecInfoListCnt(exifVO);

        Map<String, Object> map = new HashMap<String, Object>();


        map.put("resultList", result);
        map.put("resultCnt", Integer.toString(cnt));

        return map;
    }

	@Override
	public Map<String, Object> selectBdgSummaryInfoList(ExecInfoVO eiVO) throws Exception {
	    List<BdgSummaryInfoVO> result = exifDAO.selectBdgSummaryInfoList(eiVO);
	    Map<String, Object> map = new HashMap<String, Object>();

	    BigDecimal totalBdgCash = BigDecimal.ZERO;
	    BigDecimal totalBdgNon = BigDecimal.ZERO;
	    BigDecimal totalBdgTot = BigDecimal.ZERO;
	    BigDecimal totalExecCash = BigDecimal.ZERO;
	    BigDecimal totalExecNon = BigDecimal.ZERO;
	    BigDecimal totalExecVat = BigDecimal.ZERO;
	    BigDecimal totalExecTot = BigDecimal.ZERO;
	    BigDecimal totalExecSum = BigDecimal.ZERO;
	    BigDecimal totalBalCash = BigDecimal.ZERO;
	    BigDecimal totalBalNon = BigDecimal.ZERO;
	    BigDecimal totalBalTot = BigDecimal.ZERO;
	    BigDecimal totalChgCa = BigDecimal.ZERO;
	    BigDecimal totalChgIa = BigDecimal.ZERO;
	    BigDecimal totalChgTot = BigDecimal.ZERO;
	    BigDecimal totalExecCnt = BigDecimal.ZERO;

	    // 레벨 2 처리
	    for (BdgSummaryInfoVO lev2Item : result) {
	    	BigDecimal bdgCashSum = BigDecimal.ZERO, bdgNonSum = BigDecimal.ZERO, bdgTotSum = BigDecimal.ZERO,
                    execCashSum = BigDecimal.ZERO, execNonSum = BigDecimal.ZERO, execVatSum = BigDecimal.ZERO,
                    execTotSum = BigDecimal.ZERO, balCashSum = BigDecimal.ZERO,
                    balNonSum = BigDecimal.ZERO, balTotSum = BigDecimal.ZERO, chgCaSum = BigDecimal.ZERO,
                    chgIaSum = BigDecimal.ZERO, chgTotSum = BigDecimal.ZERO, execCntSum = BigDecimal.ZERO;
	        if ("2".equals(lev2Item.getLev())) {
	            String lev2Path = lev2Item.getPath();


	            for (BdgSummaryInfoVO lev3Item : result) {
	                if (lev3Item.getPath().startsWith(lev2Path) && "1".equals(lev3Item.getSumInptF())) {
	                    bdgCashSum = bdgCashSum.add(parseBigDecimal(lev3Item.getBdgCash()));
	                    bdgNonSum = bdgNonSum.add(parseBigDecimal(lev3Item.getBdgNon()));
	                    bdgTotSum = bdgTotSum.add(parseBigDecimal(lev3Item.getBdgTot()));
	                    execCashSum = execCashSum.add(parseBigDecimal(lev3Item.getExecCash()));
	                    execNonSum = execNonSum.add(parseBigDecimal(lev3Item.getExecNon()));
	                    execVatSum = execVatSum.add(parseBigDecimal(lev3Item.getExecVat()));
	                    execTotSum = execTotSum.add(parseBigDecimal(lev3Item.getExecTot()));
	                    balCashSum = balCashSum.add(parseBigDecimal(lev3Item.getBalCash()));
	                    balNonSum = balNonSum.add(parseBigDecimal(lev3Item.getBalNon()));
	                    balTotSum = balTotSum.add(parseBigDecimal(lev3Item.getBalTot()));
	                    chgCaSum = chgCaSum.add(parseBigDecimal(lev3Item.getChgCa()));
	                    chgIaSum = chgIaSum.add(parseBigDecimal(lev3Item.getChgIa()));
	                    chgTotSum = chgTotSum.add(parseBigDecimal(lev3Item.getChgTot()));
	                    execCntSum = execCntSum.add(parseBigDecimal(lev3Item.getExecCnt()));
	                }
	            }

	            lev2Item.setBdgCash(bdgCashSum.toString());
	            lev2Item.setBdgNon(bdgNonSum.toString());
	            lev2Item.setBdgTot(bdgTotSum.toString());
	            lev2Item.setExecCash(execCashSum.toString());
	            lev2Item.setExecNon(execNonSum.toString());
	            lev2Item.setExecVat(execVatSum.toString());
	            lev2Item.setExecTot(execTotSum.toString());
	            //lev2Item.setExecSum(execSumSum.toString());
	            lev2Item.setBalCash(balCashSum.toString());
	            lev2Item.setBalNon(balNonSum.toString());
	            lev2Item.setBalTot(balTotSum.toString());
	            lev2Item.setChgCa(chgCaSum.toString());
	            lev2Item.setChgIa(chgIaSum.toString());
	            lev2Item.setChgTot(chgTotSum.toString());
	            lev2Item.setExecCnt(execCntSum.toString());
	        }
	        if ("3".equals(lev2Item.getLev())) {
		        chgTotSum = parseBigDecimal(lev2Item.getChgTot());
		        execTotSum = parseBigDecimal(lev2Item.getExecTot());
	        }
	     // execRat 계산
            if (chgTotSum.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal execRat = execTotSum.divide(chgTotSum, 4, RoundingMode.DOWN).multiply(BigDecimal.valueOf(100));
                lev2Item.setExecRat(execRat.compareTo(BigDecimal.valueOf(100)) == 0 ? "100" : execRat.setScale(2, RoundingMode.DOWN).toString());
            } else {
                lev2Item.setExecRat("0.00");
            }
	    	BigDecimal execSumSum = BigDecimal.ZERO;
	    	BigDecimal execCash = parseBigDecimal(lev2Item.getExecCash());
	    	BigDecimal execNon = parseBigDecimal(lev2Item.getExecNon());
	    	BigDecimal execVat = parseBigDecimal(lev2Item.getExecVat());
	    	execSumSum = execSumSum.add(execSumSum.add(execCash).add(execNon).add(execVat));  // execSum 계산
	    	lev2Item.setExecSum(execSumSum.toString());

	    }

	    // 레벨 1 처리
	    for (BdgSummaryInfoVO lev1Item : result) {
	        if ("1".equals(lev1Item.getLev())) {
	            String lev1Path = lev1Item.getPath();
	            BigDecimal bdgCashSum = BigDecimal.ZERO, bdgNonSum = BigDecimal.ZERO, bdgTotSum = BigDecimal.ZERO,
	                       execCashSum = BigDecimal.ZERO, execNonSum = BigDecimal.ZERO, execVatSum = BigDecimal.ZERO,
	                       execTotSum = BigDecimal.ZERO, execSumSum = BigDecimal.ZERO, balCashSum = BigDecimal.ZERO,
	                       balNonSum = BigDecimal.ZERO, balTotSum = BigDecimal.ZERO, chgCaSum = BigDecimal.ZERO,
	                       chgIaSum = BigDecimal.ZERO, chgTotSum = BigDecimal.ZERO, execCntSum = BigDecimal.ZERO;

	            for (BdgSummaryInfoVO lev3Item : result) {
	                if (lev3Item.getPath().startsWith(lev1Path) && "1".equals(lev3Item.getSumInptF())) {
	                    bdgCashSum = bdgCashSum.add(parseBigDecimal(lev3Item.getBdgCash()));
	                    bdgNonSum = bdgNonSum.add(parseBigDecimal(lev3Item.getBdgNon()));
	                    bdgTotSum = bdgTotSum.add(parseBigDecimal(lev3Item.getBdgTot()));
	                    execCashSum = execCashSum.add(parseBigDecimal(lev3Item.getExecCash()));
	                    execNonSum = execNonSum.add(parseBigDecimal(lev3Item.getExecNon()));
	                    execVatSum = execVatSum.add(parseBigDecimal(lev3Item.getExecVat()));
	                    execTotSum = execTotSum.add(parseBigDecimal(lev3Item.getExecTot()));
	                    //execSumSum = execSumSum.add(execCashSum.add(execNonSum).add(execVatSum));  // execSum 계산
	                    balCashSum = balCashSum.add(parseBigDecimal(lev3Item.getBalCash()));
	                    balNonSum = balNonSum.add(parseBigDecimal(lev3Item.getBalNon()));
	                    balTotSum = balTotSum.add(parseBigDecimal(lev3Item.getBalTot()));
	                    chgCaSum = chgCaSum.add(parseBigDecimal(lev3Item.getChgCa()));
	                    chgIaSum = chgIaSum.add(parseBigDecimal(lev3Item.getChgIa()));
	                    chgTotSum = chgTotSum.add(parseBigDecimal(lev3Item.getChgTot()));
	                    execCntSum = execCntSum.add(parseBigDecimal(lev3Item.getExecCnt()));
	                }
	            }

	            lev1Item.setBdgCash(bdgCashSum.toString());
	            lev1Item.setBdgNon(bdgNonSum.toString());
	            lev1Item.setBdgTot(bdgTotSum.toString());
	            lev1Item.setExecCash(execCashSum.toString());
	            lev1Item.setExecNon(execNonSum.toString());
	            lev1Item.setExecVat(execVatSum.toString());
	            lev1Item.setExecTot(execTotSum.toString());
	            lev1Item.setExecSum(execSumSum.toString());
	            lev1Item.setBalCash(balCashSum.toString());
	            lev1Item.setBalNon(balNonSum.toString());
	            lev1Item.setBalTot(balTotSum.toString());
	            lev1Item.setChgCa(chgCaSum.toString());
	            lev1Item.setChgIa(chgIaSum.toString());
	            lev1Item.setChgTot(chgTotSum.toString());
	            lev1Item.setExecCnt(execCntSum.toString());

	            // execRat 계산
	            if (chgTotSum.compareTo(BigDecimal.ZERO) > 0) {
	                BigDecimal execRat = execTotSum.divide(chgTotSum, 4, RoundingMode.DOWN).multiply(BigDecimal.valueOf(100));
	                lev1Item.setExecRat(execRat.compareTo(BigDecimal.valueOf(100)) == 0 ? "100" : execRat.setScale(2, RoundingMode.DOWN).toString());
	            } else {
	                lev1Item.setExecRat("0.00");
	            }
		    	BigDecimal execCash = parseBigDecimal(lev1Item.getExecCash());
		    	BigDecimal execNon = parseBigDecimal(lev1Item.getExecNon());
		    	BigDecimal execVat = parseBigDecimal(lev1Item.getExecVat());
		    	execSumSum = execSumSum.add(execSumSum.add(execCash).add(execNon).add(execVat));  // execSum 계산
		    	lev1Item.setExecSum(execSumSum.toString());
	        }
	    }

	    // 총합 계산
	    for (BdgSummaryInfoVO lev3Item : result) {
	        if ("1".equals(lev3Item.getSumInptF())) {
	            totalBdgCash = totalBdgCash.add(parseBigDecimal(lev3Item.getBdgCash()));
	            totalBdgNon = totalBdgNon.add(parseBigDecimal(lev3Item.getBdgNon()));
	            totalBdgTot = totalBdgTot.add(parseBigDecimal(lev3Item.getBdgTot()));
	            totalExecCash = totalExecCash.add(parseBigDecimal(lev3Item.getExecCash()));
	            totalExecNon = totalExecNon.add(parseBigDecimal(lev3Item.getExecNon()));
	            totalExecVat = totalExecVat.add(parseBigDecimal(lev3Item.getExecVat()));
	            totalExecTot = totalExecTot.add(parseBigDecimal(lev3Item.getExecTot()));
	            totalExecSum = totalExecSum.add(parseBigDecimal(lev3Item.getExecCash()).add(parseBigDecimal(lev3Item.getExecNon())).add(parseBigDecimal(lev3Item.getExecVat())));  // execSum 계산
	            totalBalCash = totalBalCash.add(parseBigDecimal(lev3Item.getBalCash()));
	            totalBalNon = totalBalNon.add(parseBigDecimal(lev3Item.getBalNon()));
	            totalBalTot = totalBalTot.add(parseBigDecimal(lev3Item.getBalTot()));
	            totalChgCa = totalChgCa.add(parseBigDecimal(lev3Item.getChgCa()));
	            totalChgIa = totalChgIa.add(parseBigDecimal(lev3Item.getChgIa()));
	            totalChgTot = totalChgTot.add(parseBigDecimal(lev3Item.getChgTot()));
	            totalExecCnt = totalExecCnt.add(parseBigDecimal(lev3Item.getExecCnt()));
	        }
	    }

	    // 총합 객체 생성 및 설정
	    BdgSummaryInfoVO totalSummary = new BdgSummaryInfoVO();
	    totalSummary.setLev("합계");
	    totalSummary.setIoeNm("합계");
	    totalSummary.setBdgCash(totalBdgCash.toString());
	    totalSummary.setBdgNon(totalBdgNon.toString());
	    totalSummary.setBdgTot(totalBdgTot.toString());
	    totalSummary.setExecCash(totalExecCash.toString());
	    totalSummary.setExecNon(totalExecNon.toString());
	    totalSummary.setExecVat(totalExecVat.toString());
	    totalSummary.setExecTot(totalExecTot.toString());
	    totalSummary.setExecSum(totalExecSum.toString());
	    totalSummary.setBalCash(totalBalCash.toString());
	    totalSummary.setBalNon(totalBalNon.toString());
	    totalSummary.setBalTot(totalBalTot.toString());
	    totalSummary.setChgCa(totalChgCa.toString());
	    totalSummary.setChgIa(totalChgIa.toString());
	    totalSummary.setChgTot(totalChgTot.toString());
	    totalSummary.setExecCnt(totalExecCnt.toString());

	    // execRat 계산
	    if (totalChgTot.compareTo(BigDecimal.ZERO) > 0) {
	        BigDecimal execRat = totalExecTot.divide(totalChgTot, 4, RoundingMode.DOWN).multiply(BigDecimal.valueOf(100));
	        totalSummary.setExecRat(execRat.compareTo(BigDecimal.valueOf(100)) == 0 ? "100" : execRat.setScale(2, RoundingMode.DOWN).toString());
	    } else {
	        totalSummary.setExecRat("0.00");
	    }

	    // 총합 객체를 리스트에 추가
	    result.add(totalSummary);

	    map.put("resultList", result);

	    return map;
	}


    private BigDecimal parseBigDecimal(String value) {
        try {
            return new BigDecimal(value);
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }

	@Override
	public Map<String, Object> selectExecSummaryInfoList(String taskNo) throws Exception {
		List<ExecSummaryInfoVO> result = exifDAO.selectExecSummaryInfoList(taskNo);
        Map<String, Object> map = new HashMap<String, Object>();

        map.put("resultList", result);

        return map;
	}
	@Override
	public Map<String, Object> selectCommonDocInfoList(CommonDocInfoVO cdVO) throws Exception {
		List<CommonDocInfoVO> result = exifDAO.selectCommonDocInfoList(cdVO);

    	//int cnt = exifDAO.selectCommonDocInfoListCnt(taskNo);

    	Map<String, Object> map = new HashMap<String, Object>();


    	map.put("resultList", result);
    	//map.put("resultCnt", Integer.toString(cnt));

    	return map;

	}

	@Override
	public Map<String, Object> selectExecFileInfoList(ExecInfoVO eiVO) throws Exception {
		List<ExecFileInfoVO> result = exifDAO.selectExecFileInfoList(eiVO);
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("resultList", result);

    	return map;
	}

	@Override
	public Map<String, Object> selectTaxInvInfoList(ExecInfoVO eiVO) throws Exception {
		List<TaxInvInfoVO> result = exifDAO.selectTaxInvInfoList(eiVO);
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("resultList", result);

    	return map;
	}

	@Override
	public Map<String, Object> selectTaxInvItmInfoList(ExecInfoVO eiVO) throws Exception {
		List<TaxInvItmInfoVO> result = exifDAO.selectTaxInvItmInfoList(eiVO);
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("resultList", result);

    	return map;
	}

}
