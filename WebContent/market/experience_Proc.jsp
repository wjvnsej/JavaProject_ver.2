<%@page import="model.RequestDAO"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@page import="smtp.SMTPAuth"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
//json객체 생성
JSONObject json = new JSONObject();

//값 전달받기
String name = request.getParameter("name");

String disabled_Check = request.getParameter("disabled");
String disabled_kind = request.getParameter("disabled_kind");
String disabled = disabled_Check + " / " +disabled_kind;

String equip_Check = request.getParameter("equip");
String equip_name = request.getParameter("equip_name");
String equip = equip_Check + " / " +equip_name;

String phone1_1 = request.getParameter("phone1_1");
String phone1_2 = request.getParameter("phone1_2");
String phone1_3 = request.getParameter("phone1_3");
String phone1 = phone1_1 + "-" +phone1_2 + "-" + phone1_3; 

String email_1 = request.getParameter("email_1");
String email_2 = request.getParameter("email_2");
String email = email_1 + "@" +email_2;

String cakeCheck = request.getParameter("cake");
String cakeCnt = request.getParameter("cakeCnt");
String cake = cakeCheck + " / " +cakeCnt + "명";

String cookieCheck = request.getParameter("cookie");
String cookieCnt = request.getParameter("cookieCnt");
String cookie = cookieCheck + " / " +cookieCnt + "명";

String breadCheck = request.getParameter("bread");
String breadCnt = request.getParameter("breadCnt");
String bread = breadCheck + " / " +breadCnt + "명";

String datepicker = request.getParameter("datepicker");

String etc = request.getParameter("etc");

String bname = request.getParameter("bname");

Map<String, String> param = new HashMap<String, String>();
param.put("name", name);
param.put("disabled", disabled);
param.put("equip", equip);
param.put("phone1", phone1);
param.put("email", email);
param.put("cake", cake);
param.put("cookie", cookie);
param.put("bread", bread);
param.put("datepicker", datepicker);
if(etc.equals("") || etc == null){
	param.put("etc", "없음");	
}
else{
	param.put("etc", etc);
}
param.put("bname", bname);

//DB연결
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");
RequestDAO dao = new RequestDAO(drv, url);

//데이터 검색 후 Map에 저장
int result =  dao.experience_insert(param);

if(result == 0) {
	//값이 없을 때 
	json.put("result", 0);
	json.put("message", "체험학습 신청서 저장에 실패했습니다. 관리자에게 문의해주세요.");
}
else {
	
	//메일 전송을 위한 객체 생성
	SMTPAuth smtp = new SMTPAuth();
	
	//메일을 보내기 위한 변수 생성
	String from = "wjvnsej1@naver.com";
	String subject = "**수아밀 체험학습 신청서 보내드립니다.**";
	String content = "**수아밀 체험학습 신청서 입니다.**" + "<br><br>" +  
					"고객명/회사명 : " + name + "<br>" + 
					"장애유무 : " + disabled + "<br>" + 
					"보장구 사용유무 : " + equip + "<br>" + 
					"휴대전화 : " + phone1 + "<br>" + 
					"이메일 : " + email + "<br>" +  
					"체험내용 : " + cake + cookie + bread + "<br>" + 
					"청소 희망날짜 : " + datepicker + "<br>" + 
					"기타특이사항 : " + etc + "<br>";
	
	//메일 전송에 사용할 변수를 저장하는 Map 생성
	Map<String, String> emailContent = new HashMap<String, String>();
	
	//Map에 메일전송을 위한 변수 저장
	emailContent.put("from", from);
	emailContent.put("to", email);
	emailContent.put("subject", subject);
	emailContent.put("content", content);
		
	//메일 전송여부를 반환할 변수 생성
	boolean emailResult = smtp.emailSending(emailContent);
	//사용자전송
	if(emailResult == true) {
		//메일 전송 성공시
		json.put("result", 1);
		json.put("message", "입력하신 메일로 수아밀 체험학습 신청서를 전송하였습니다.");
	}
	else {
		//메일 전송 실패시
		json.put("result", -1);
		json.put("message", "메일 전송에 실패하였습니다.\n관리자에게 문의해주세요.");
	}
	
	//관리자전송
	emailContent.put("to", from);
	smtp.emailSending(emailContent);

}

//json에 저장한 내용을 String형 변수에 담아 보낸다
String jsonData = json.toJSONString();
out.println(jsonData);
%>