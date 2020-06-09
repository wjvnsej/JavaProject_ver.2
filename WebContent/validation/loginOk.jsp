<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- loginOk.jsp --%>

<%
request.setCharacterEncoding("UTF-8");
String log = (String)session.getAttribute("id");

if(!(log == null || log.equals(""))) {
	JavascriptUtil.jsAlertLocation("잘못된 접근입니다.", "../main/main.do", out);
	return;
}
%>