
<%@page import="model.OrderDAO"%>
<%@page import="model.OrderDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- DeleteProc.jsp --%>

<%@include file="isLogin.jsp" %>
<%

String name1 = request.getParameter("name1");
String idx = request.getParameter("idx");

OrderDTO dto = new OrderDTO();

String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");

//DAO객체 생성 및 DB커넥션
OrderDAO dao = new OrderDAO(drv, url);

//세션영역에 저장된 로그인 아이디를 String으로 가져온다.
int affected = 0;

affected = dao.delete(idx, name1);

if(affected == 1) {
	JavascriptUtil.jsAlertLocation("삭제되었습니다.", "../order_List.jsp", out);
}
else {
	JavascriptUtil.jsAlertLocation("삭제실패하였습니다.", "../order_List.jsp", out);
}
%>