<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- isFlag.jsp --%>

<%
request.setCharacterEncoding("UTF-8");

String grade = (String)session.getAttribute("grade");
String bname = request.getParameter("bname");

if(bname == null || bname.equals("")) {
	JavascriptUtil.jsAlertLocation("필수파라미터 누락됨", "../main/main.do", out);
	return;
}

if(bname.equals("staffboard") && grade.equals("user")) {
	JavascriptUtil.jsAlertLocation("관리자만 접근가능합니다.", "../main/main.do", out);
	return;
}


String boardTitle = "";
String boardName = "";

switch(bname) {

	case "notice":
		boardTitle = "공지사항"; break;
	case "calenboard":
		boardTitle = "프로그램일정"; break;
	case "freeboard":
		boardTitle = "자유게시판"; break;
	case "photoboard":
		boardTitle = "사진게시판"; break;
	case "infoboard":
		boardTitle = "정보자료실"; break;
	case "staffboard":
		boardTitle = "직원자료실"; break;
	case "bohojaboard":
		boardTitle = "보호자 게시판"; break;

}
switch(bname) {

	case "notice":
		boardName = "sub01_title.gif"; break;
	case "calenboard":
		boardName = "sub02_title.gif"; break;
	case "freeboard":
		boardName = "sub03_title.gif"; break;
	case "photoboard":
		boardName = "sub04_title.gif"; break;
	case "infoboard":
		boardName = "sub05_title.gif"; break;
	case "staffboard":
		boardName = "sub01_title.gif"; break;
	case "bohojaboard":
		boardName = "sub02_title.gif"; break;

}



%>
