<%@page import="util.JavascriptUtil"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
//json객체 생성
JSONObject json = new JSONObject();

//값 전달받기
String id_name = request.getParameter("id_name");
String id_email = request.getParameter("id_email");

//DB연결
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");
MemberDAO dao = new MemberDAO(drv, url);

//데이터 검색 후 Map에 저장
Map<String, String> map =  dao.id_Search(id_name, id_email);

//클라이언트에게 데이터를 전송하기 위한 변수 생성 및 초기화
String id = map.get("id");
String join_date = map.get("join_date");

if(map.isEmpty()) {
	//값이 없을 때
	json.put("result", 0);
	json.put("message", "회원가입된 데이터가 없습니다.");
}
else {
	System.out.println("key:"+ id + ",value:" + join_date);
	
	//값이 있을 때
	json.put("result", 1);
	json.put("message", "아이디 : " + id + "\n가입일 : " + join_date);
	
}

//json에 저장한 내용을 String형 변수에 담아 보낸다
String jsonData = json.toJSONString();
out.println(jsonData);
%>