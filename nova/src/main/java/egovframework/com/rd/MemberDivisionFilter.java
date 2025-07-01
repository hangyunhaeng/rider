package egovframework.com.rd;

import java.io.IOException;
import java.net.InetAddress;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.com.cmm.service.EgovProperties;
import egovframework.com.sec.security.filter.EgovSpringSecurityLoginFilter;

public class MemberDivisionFilter implements Filter{

	private FilterConfig config;

	private static final Logger LOGGER = LoggerFactory.getLogger(MemberDivisionFilter.class);

	public void destroy() {
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

		LOGGER.info("MemberDivisionFilter called...");

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		HttpSession session = httpRequest.getSession();

		if(httpRequest.getServerName().equals(EgovProperties.getProperty("Globals.usrDomain").trim())) {
			session.setAttribute("memberGubun", "USR");	//운영사
		} else if(httpRequest.getServerName().equals(EgovProperties.getProperty("Globals.gnrDomain").trim())) {
			session.setAttribute("memberGubun", "GNR");	//일반사용자
		}else if(httpRequest.getServerName().equals(EgovProperties.getProperty("Globals.gnrDomain1").trim())) {
			session.setAttribute("memberGubun", "GNR");	//일반사용자
		}

//		if(Util.isDev()) {
			if(httpRequest.getServerName().equals(EgovProperties.getProperty("Globals.usrDevDomain").trim())) {
				session.setAttribute("memberGubun", "USR");	//운영사
			} else if(httpRequest.getServerName().equals(EgovProperties.getProperty("Globals.gnrDevDomain").trim())) {
				session.setAttribute("memberGubun", "GNR");	//일반사용자
			}else if(httpRequest.getServerName().equals(EgovProperties.getProperty("Globals.gnrDevDomain1").trim())) {
				session.setAttribute("memberGubun", "GNR");	//일반사용자
			}
//		}

		chain.doFilter(request, response);
	}

	public void init(FilterConfig filterConfig) throws ServletException {
		this.config = filterConfig;
	}
}

class RequestWrapperForSecurity extends HttpServletRequestWrapper {
	private String username = null;
	private String password = null;

	public RequestWrapperForSecurity(HttpServletRequest request, String username, String password) {
		super(request);

		this.username = username;
		this.password = password;
	}

	@Override
	public String getServletPath() {
		return ((HttpServletRequest) super.getRequest()).getContextPath() + "/egov_security_login";
	}

	@Override
	public String getRequestURI() {
		return ((HttpServletRequest) super.getRequest()).getContextPath() + "/egov_security_login";
	}

	@Override
	public String getParameter(String name) {
		if (name.equals("egov_security_username")) {
			return username;
		}

		if (name.equals("egov_security_password")) {
			return password;
		}

		return super.getParameter(name);
	}
}
