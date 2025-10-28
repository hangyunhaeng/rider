package egovframework.com.rd;

import java.math.BigDecimal;
import java.security.SecureRandom;
import java.text.DecimalFormat;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.rd.usr.service.vo.KkoVO;

public class Util {

	private static final Pattern GET_NUMBER = Pattern.compile("[0-9]+");
	private static final Pattern GET_MINUS_NUMBER = Pattern.compile("[0-9-]+");
    private static final Pattern IS_ONLY_NUMBER = Pattern.compile("^[0-9]*?");
	/**
	 * 사용자가 일반 유저일때 true
	 * @param session
	 * @return
	 */
	public static boolean isGnr() {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if("GNR".equals(user.getUserSe())) {
			return true;
		}
		return false;
	}
	/**
	 * 사용자가 일반 유저일때 true
	 * @param session
	 * @return
	 */
	public static boolean isGnr(HttpSession session) {
		if("GNR".equals(session.getAttribute("memberGubun"))) {
			return true;
		}
		return false;
	}

	/**
	 * 사용자가 운영사일때 true
	 * @param session
	 * @return
	 */
	public static boolean isUsr() {
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if("USR".equals(user.getUserSe())) {
			return true;
		}
		return false;
	}

	/**
	 * 사용자가 운영사일때 true
	 * @param session
	 * @return
	 */
	public static boolean isUsr(HttpSession session) {
//		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if("USR".equals(session.getAttribute("memberGubun"))) {
			return true;
		}
		return false;
	}

	/**
	 * 멤버별 루트디렉토리를 돌려준다
	 * @param session
	 * @return
	 */
	public static String getRootUrl(HttpSession session) {

		String rootUrl = null;
		// 운영사와 사용자를 구분하여 이동시킨다.
		if("GNR".equals(session.getAttribute("memberGubun"))) {
			rootUrl = "gnr";
		} else if("USR".equals(session.getAttribute("memberGubun"))) {
			rootUrl = "usr";
		} else {
			rootUrl = null;
		}
		return rootUrl;
	}
	/**
	 * 숫자인지 확인한다
	 * @param str
	 * @return
	 */
    public static boolean isOnlyNumber(final String str) {
        return IS_ONLY_NUMBER.matcher(str).matches();
    }

    /**
     * 숫자만 추출한다
     * @param str
     * @return
     */
    public static String getOnlyNumber(final String str) {
        StringBuilder sb = new StringBuilder();
        Matcher matcher = GET_NUMBER.matcher((str == null ? "": str));

        while (matcher.find()) {
            sb.append(matcher.group());
        }

        if("".equals(sb.toString()))sb.append("0");
        return sb.toString();
    }

    /**
     * 숫자만 추출한다
     * @param str
     * @return
     */
    public static String getOnlyNumberM(final String str) {
        StringBuilder sb = new StringBuilder();
        Matcher matcher = GET_MINUS_NUMBER.matcher((str == null ? "": str));

        while (matcher.find()) {
            sb.append(matcher.group());
        }

        if("".equals(sb.toString()))sb.append("0");
        return sb.toString();
    }

    public static boolean isEmpty(String str) {
    	if(str == null) {
    		return true;
    	}
    	if("".equals(str.trim())) {
    		return true;
    	}
    	return false;
    }
    public static String getDay(){

		Calendar cal = Calendar.getInstance();
		String YEAR = Integer.toString(cal.get(Calendar.YEAR));
		String MONTH;
		String DAY;

		int mon = cal.get(Calendar.MONTH)+1;
		if(mon < 10) MONTH = "0"+mon;
		else MONTH = Integer.toString(mon);

		int date = cal.get(Calendar.DATE);
		if(date < 10) DAY = "0"+date;
		else DAY = Integer.toString(date);

		return YEAR+MONTH+DAY;
    }
    public static String getTime(){

		Calendar cal = Calendar.getInstance();
		String HOUR = Integer.toString(cal.get(Calendar.HOUR_OF_DAY));
		String MINUTE = Integer.toString(cal.get(Calendar.MINUTE));
		String SECOND  = Integer.toString(cal.get(Calendar.SECOND));


		return HOUR+MINUTE+SECOND;
    }

    public static String getDay(String gubun, int param){

		Calendar cal = Calendar.getInstance();
		if("DAY".equals(gubun) ) {
			cal.add(Calendar.DATE, param);
		}

		String YEAR = Integer.toString(cal.get(Calendar.YEAR));
		String MONTH;
		String DAY;

		int mon = cal.get(Calendar.MONTH)+1;
		if(mon < 10) MONTH = "0"+mon;
		else MONTH = Integer.toString(mon);

		int date = cal.get(Calendar.DATE);
		if(date < 10) DAY = "0"+date;
		else DAY = Integer.toString(date);

		return YEAR+MONTH+DAY;
    }

    public static boolean isReal() {
    	if("REAL".equals(EgovProperties.getProperty("Globals.server")))
    		return true;
    	 else
    		return false;
    }
    public static boolean isStage() {
    	if("STAGE".equals(EgovProperties.getProperty("Globals.server")))
    		return true;
    	 else
    		return false;
    }
    public static boolean isDev() {
    	if("DEV".equals(EgovProperties.getProperty("Globals.server")))
    		return true;
    	 else
    		return false;
    }

    public static String currencyFormatter(BigDecimal input) {
        DecimalFormat df = new DecimalFormat("###,###");
        return df.format(input);

    }
    @SuppressWarnings("unchecked")
	public static JSONObject makeKko(List<KkoVO> kkoList) {


    	if(kkoList.size() == 0) {
    		return null;
    	}

    	String templateCode = null;
        JSONArray jsonArray = new JSONArray();
        for(int i = 0; i < kkoList.size() ; i++) {
        	KkoVO kkoVo = kkoList.get(i);

        	if(i == 0) {
        		templateCode = kkoVo.getTemplateCode();
        	}

	        JSONObject jsonObject = new JSONObject();

	        JSONObject variablesObject = new JSONObject();
	        if(EgovProperties.getProperty("Globals.passAlert").equals(templateCode)) {
	        	variablesObject.put("성명", kkoVo.getParam0());
	        	variablesObject.put("임시패스워드", kkoVo.getParam1());
	        } else if(EgovProperties.getProperty("Globals.etcAlert").equals(templateCode)) {
	        	variablesObject.put("구분명", kkoVo.getParam0());
	        	variablesObject.put("성명", kkoVo.getParam1());
	        	variablesObject.put("금액", kkoVo.getParam2());
	        } else if(EgovProperties.getProperty("Globals.inqAlert").equals(templateCode)) {
	        	variablesObject.put("성명", kkoVo.getParam0());
	        } else if(EgovProperties.getProperty("Globals.inqReqAlert").equals(templateCode)) {
	        	variablesObject.put("성명", kkoVo.getParam0());
	        	variablesObject.put("제목", kkoVo.getParam1());
	        	variablesObject.put("내용", kkoVo.getParam2());
	        } else if(EgovProperties.getProperty("Globals.passUserInitAlert").equals(templateCode)) {
	        	variablesObject.put("성명", kkoVo.getParam0());
	        	variablesObject.put("임시패스워드", kkoVo.getParam1());
	        } else if(EgovProperties.getProperty("Globals.enterUserAlert").equals(templateCode)) {
	        	variablesObject.put("성명", kkoVo.getParam0());
	        	variablesObject.put("임시패스워드", kkoVo.getParam1());
	        } else if(EgovProperties.getProperty("Globals.enterSaleAlert").equals(templateCode)) {
	        	variablesObject.put("성명", kkoVo.getParam0());
	        	variablesObject.put("임시패스워드", kkoVo.getParam1());
	        } else if(EgovProperties.getProperty("Globals.enterAdminAlert").equals(templateCode)) {
	        	variablesObject.put("성명", kkoVo.getParam0());
	        	variablesObject.put("임시패스워드", kkoVo.getParam1());
	        } else if(EgovProperties.getProperty("Globals.passRiderInitAlert").equals(templateCode)) {
	        	variablesObject.put("성명", kkoVo.getParam0());
	        	variablesObject.put("임시패스워드", kkoVo.getParam1());
	        }
	        jsonObject.put("variables", variablesObject);
	        jsonObject.put("phone", kkoVo.getMbtlnum());
	        jsonObject.put("mberId", kkoVo.getMberId());

	        jsonArray.add(jsonObject);
        }

        JSONObject jsonbutton1 = new JSONObject();
        if(!EgovProperties.getProperty("Globals.inqReqAlert").equals(templateCode)
        		&& !EgovProperties.getProperty("Globals.passUserInitAlert").equals(templateCode)
        		&& !EgovProperties.getProperty("Globals.enterUserAlert").equals(templateCode)
        		&& !EgovProperties.getProperty("Globals.enterSaleAlert").equals(templateCode)
        		&& !EgovProperties.getProperty("Globals.enterAdminAlert").equals(templateCode)) {
	        jsonbutton1.put("name", "접속");
	        jsonbutton1.put("type", "WL");
	        jsonbutton1.put("urlMobile", "https://riderbank.co.kr");
	        jsonbutton1.put("urlPc", "https://riderbank.co.kr");
        }

        JSONObject jsonMain = new JSONObject();
        jsonMain.put("phoneList",jsonArray);
        jsonMain.put("callback","01091835541");

        JSONObject jsonKakaoMessage = new JSONObject();
        if(!EgovProperties.getProperty("Globals.inqReqAlert").equals(templateCode)
        		&& !EgovProperties.getProperty("Globals.passUserInitAlert").equals(templateCode)
        		&& !EgovProperties.getProperty("Globals.enterUserAlert").equals(templateCode)
        		&& !EgovProperties.getProperty("Globals.enterSaleAlert").equals(templateCode)
        		&& !EgovProperties.getProperty("Globals.enterAdminAlert").equals(templateCode)) {
        	jsonKakaoMessage.put("button1", jsonbutton1);
        }
        if(EgovProperties.getProperty("Globals.passAlert").equals(templateCode)) {
	        jsonKakaoMessage.put("body", "[라이더뱅크 가입안내]\n\n"
	        		+ "#{성명}님 라이더뱅크에 등록되셨습니다.\n"
	        		+ "RADER BANK에 접속하여 임시패스워드로 로그인 후 임시패스워드를 다시 설정해 주시기 바랍니다.\n\n"
	        		+ "- 임시패스워드 : #{임시패스워드}");
        } else if(EgovProperties.getProperty("Globals.etcAlert").equals(templateCode)) {
	        jsonKakaoMessage.put("body", "[라이더뱅크 #{구분명} 상환 승인 요청]\r\n\n\n"
	        		+ "#{성명}님 라이더뱅크에서 #{구분명} #{금액}원에 대한 상환 승인 요청이 있습니다.\r\n\n"
	        		+ "라이더뱅크 > 대여,리스 현황 메뉴에서 확인 하신 후에 승인해 주시기 바랍니다.\r\n\n"
	        		+ "미승인시 출금 기능이 제한 됩니다.");
        } else if(EgovProperties.getProperty("Globals.inqAlert").equals(templateCode)) {
	        jsonKakaoMessage.put("body", "[라이더뱅크 안내]\r\n\n"
	        		+ "#{성명}님 1:1문의에 대한 답변이 등록되었습니다.");
        } else if(EgovProperties.getProperty("Globals.inqReqAlert").equals(templateCode)) {
        	jsonKakaoMessage.put("body", "[라이더뱅크 1:1문의 등록]\r\n\n\n"
        			+ "#{성명}님이 문의 등록하였습니다.\r\n"
        			+ "내용을 확인하시고 답변 부탁 드립니다.\r\n\n"
        			+ "- #{제목}\r\n\n"
        			+ "#{내용}");
        } else if(EgovProperties.getProperty("Globals.passUserInitAlert").equals(templateCode)) {
        	jsonKakaoMessage.put("body", "[라이더뱅크 패스워드 초기화]\r\n\n\n"
        			+ "#{성명}님 패스워드가 초기화 되었습니다\r\n"
        			+ "RADER BANK에 접속하여 임시패스워드로 로그인 후 임시패스워드를 다시 설정해 주시기 바랍니다.\r\n\n"
        			+ "- 임시패스워드 : #{임시패스워드}");
        } else if(EgovProperties.getProperty("Globals.enterUserAlert").equals(templateCode)) {
        	jsonKakaoMessage.put("body", "[라이더뱅크 가입안내]\r\n\n\n"
        			+ "#{성명}님 라이더뱅크에 협력사로 등록되셨습니다.\r\n"
        			+ "RADER BANK에 접속하여 임시패스워드로 로그인 후 임시패스워드를 다시 설정해 주시기 바랍니다.\r\n\n"
        			+ "- 임시패스워드 : #{임시패스워드}");
        } else if(EgovProperties.getProperty("Globals.enterSaleAlert").equals(templateCode)) {
        	jsonKakaoMessage.put("body", "[라이더뱅크 가입안내]\r\n\n\n"
        			+ "#{성명}님 라이더뱅크에 영업사로 등록되셨습니다.\r\n"
        			+ "RADER BANK에 접속하여 임시패스워드로 로그인 후 임시패스워드를 다시 설정해 주시기 바랍니다.\r\n\n"
        			+ "- 임시패스워드 : #{임시패스워드}");
        } else if(EgovProperties.getProperty("Globals.enterAdminAlert").equals(templateCode)) {
        	jsonKakaoMessage.put("body", "[라이더뱅크 가입안내]\r\n\n\n"
        			+ "#{성명}님 라이더뱅크에 운영사로 등록되셨습니다.\r\n"
        			+ "RADER BANK에 접속하여 임시패스워드로 로그인 후 임시패스워드를 다시 설정해 주시기 바랍니다.\r\n\n"
        			+ "- 임시패스워드 : #{임시패스워드}");
        } else if(EgovProperties.getProperty("Globals.passRiderInitAlert").equals(templateCode)) {
        	jsonKakaoMessage.put("body", "[라이더뱅크 패스워드 초기화]\r\n\n\n"
        			+ "#{성명}님 패스워드가 초기화 되었습니다\r\n"
        			+ "RADER BANK에 접속하여 임시패스워드로 로그인 후 임시패스워드를 다시 설정해 주시기 바랍니다.\r\n\n"
        			+ "- 임시패스워드 : #{임시패스워드}");
        }
        jsonKakaoMessage.put("templateCode", templateCode);
        jsonKakaoMessage.put("senderKey", EgovProperties.getProperty("Globals.senderKey"));
        jsonMain.put("kakaoMessage", jsonKakaoMessage);
        jsonMain.put("messageType", "kat");

        return jsonMain;
    }

    public static String getRandomKey(int len) {
    	SecureRandom random = new SecureRandom();
    	String charar = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789!@#$%^&*()_+";
    	StringBuilder sb = new StringBuilder(len);
    	for (int i = 0; i < len; i++) {
    	    int randomIndex = random.nextInt(charar.length());
    	    sb.append(charar.charAt(randomIndex));
    	}
    	return sb.toString();
    }
}

