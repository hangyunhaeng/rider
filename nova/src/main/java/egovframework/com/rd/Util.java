package egovframework.com.rd;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpSession;

import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

public class Util {

	private static final Pattern GET_NUMBER = Pattern.compile("[0-9]+");
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
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
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
}

