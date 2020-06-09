<%@page import="model.MemberDAO"%>
<%@page import="model.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%-- EditProc.jsp --%>

<%@include file="isLogin.jsp" %>


<% 
request.setCharacterEncoding("UTF-8");

//폼값 받기
String frmgrade = request.getParameter("selectGrade");

if(frmgrade.equals("일반")){
	frmgrade = "user";
}
else if(frmgrade.equals("직원")){
	frmgrade = "admin";
}

String id = request.getParameter("id");
//폼값을 DTO객체에 저장
MemberDTO dto = new MemberDTO();
dto.setId(id);
dto.setGrade(frmgrade);

String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");

//DAO객체 생성 및 DB커넥션
MemberDAO dao = new MemberDAO(drv, url);

//DTO객체를 DAO로 전달하여 게시물 업데이트(수정)
int affected = dao.updateEdit(dto);
if(affected == 1) {
	//정상적으로 수정되었다면 수정된 내용의 확인을 위해 상세보기로 이동
	response.sendRedirect("../member_View.jsp?grade=" + frmgrade + "&id=" + dto.getId());
}
else {

	System.out.println("수정오류");
	request.getRequestDispatcher("../list_View.jsp?grade=" + frmgrade).forward(request, response);
}

%>

