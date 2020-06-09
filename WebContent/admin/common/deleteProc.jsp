
<%@page import="model.MemberDAO"%>
<%@page import="model.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- DeleteProc.jsp --%>

<%@include file="isLogin.jsp" %>

<%

String grade = request.getParameter("grade");
String id = request.getParameter("id");

MemberDTO dto = new MemberDTO();

String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");

//DAO객체 생성 및 DB커넥션
MemberDAO dao = new MemberDAO(drv, url);

//세션영역에 저장된 로그인 아이디를 String으로 가져온다.
int affected = 0;

affected = dao.delete(id);

if(affected == 1) {
	JavascriptUtil.jsAlertLocation("삭제되었습니다.", "../member_List.jsp?grade=" + grade, out);
}
else {
	JavascriptUtil.jsAlertLocation("삭제실패하였습니다.", "../member_List.jsp?grade=" + grade, out);
}
%>