<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- isFlag.jsp --%>

<%
request.setCharacterEncoding("UTF-8");

String grade = (String)session.getAttribute("grade");
String bname = request.getParameter("bname");

if(bname == null || bname.equals("")) {
	JavascriptUtil.jsAlertLocation("필수파라미터 누락됨", "./index.jsp", out);
	return;
}

%>
