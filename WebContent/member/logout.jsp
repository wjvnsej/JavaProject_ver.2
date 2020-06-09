<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- logout.jsp --%> 
  
<%
	PrintWriter writer = response.getWriter();

	session.removeAttribute("id");
	session.removeAttribute("pass");
	session.removeAttribute("name");
	session.removeAttribute("grade");
	
	session.invalidate();
	
	writer.println("<script>alert('로그아웃 되었습니다.'); location.href='../main/main.do';</script>"); 
	writer.close();
	
%>
