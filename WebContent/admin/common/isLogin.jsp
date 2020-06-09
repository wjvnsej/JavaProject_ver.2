<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- isLogin.jsp --%>

<%
request.setCharacterEncoding("UTF-8");
String log = (String)session.getAttribute("id");

if(log == null || log.equals("")) {
	JavascriptUtil.jsAlertLocation("로그인 후 이용해주세요.", "./login.jsp", out);
	return;
}
%>