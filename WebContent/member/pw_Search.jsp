<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@page import="smtp.SMTPAuth"%>
<%@page import="java.util.Map"%>
<%@page import="model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
//json객체 생성
JSONObject json = new JSONObject();

//값 전달받기
String pw_id = request.getParameter("pw_id");
String pw_name = request.getParameter("pw_name");
String pw_email = request.getParameter("pw_email");

//DB연결
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");
MemberDAO dao = new MemberDAO(drv, url);

//데이터 검색 후 Map에 저장
Map<String, String> map =  dao.pw_Search(pw_id, pw_name, pw_email);

//클라이언트에게 데이터를 전송하기 위한 변수 생성 및 초기화
String pass = map.get("pass");; 
String email = map.get("email");;

if(map.isEmpty()) {
	//값이 없을 때 
	json.put("result", 0);
	json.put("message", "회원가입된 데이터가 없습니다.");
}
else {
	
	System.out.println("key:"+ pass + ",value:" + email);
	
	//메일 전송을 위한 객체 생성
	SMTPAuth smtp = new SMTPAuth();
	
	//메일을 보내기 위한 변수 생성
	String from = "wjvnsej1@naver.com";
	String subject = "**비밀번호 찾기 결과 메일 발송 드립니다.**";
	String content = "귀하의 비밀번호는 '" + pass + "'입니다.";
	
	//메일 전송에 사용할 변수를 저장하는 Map 생성
	Map<String, String> emailContent = new HashMap<String, String>();
	
	//Map에 메일전송을 위한 변수 저장
	emailContent.put("from", from);
	emailContent.put("to", email);
	emailContent.put("subject", subject);
	emailContent.put("content", content);
		
	//메일 전송여부를 반환할 변수 생성
	boolean emailResult = smtp.emailSending(emailContent);
	
	if(emailResult == true) {
		//메일 전송 성공시
		json.put("result", 1);
		json.put("message", "입력하신 메일로 비밀번호를 전송하였습니다.");
	}
	else {
		//메일 전송 실패시
		json.put("result", -1);
		json.put("message", "메일 전송에 실패하였습니다.\n관리자에게 문의해주세요.");
	}

}

//json에 저장한 내용을 String형 변수에 담아 보낸다
String jsonData = json.toJSONString();
out.println(jsonData);
%>