
<%@page import="model.RequestDAO"%>
<%@page import="model.RequestDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- DeleteProc.jsp --%>

<%@include file="isLogin.jsp" %>
<%@ include file="isFlag.jsp" %>
<%

String num = request.getParameter("num");

RequestDTO dto = new RequestDTO();

String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");

//DAO객체 생성 및 DB커넥션
RequestDAO dao = new RequestDAO(drv, url);

//세션영역에 저장된 로그인 아이디를 String으로 가져온다.
int affected = 0;

affected = dao.delete(num, bname);

if(affected == 1) {
	JavascriptUtil.jsAlertLocation("삭제되었습니다.", "../request_List.jsp?bname=" + bname, out);
}
else {
	JavascriptUtil.jsAlertLocation("삭제실패하였습니다.", "../request_List.jsp?bname=" + bname, out);
}
%>