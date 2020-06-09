
<%@page import="java.io.PrintWriter"%>
<%@page import="model.MemberDAO"%>
<%@page import="model.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	
	//폼값전송받기
	String id = request.getParameter("id");		
	String pass = request.getParameter("pass1");	
	String name = request.getParameter("name");	
	String phone1 = request.getParameter("mobile1");
	String phone2 = request.getParameter("mobile2");
	String phone3 = request.getParameter("mobile3");
	String email1 = request.getParameter("email_1");
	String email2 = request.getParameter("email_2");
	
	String email_send_ok;
	String[] open_email = request.getParameterValues("open_email"); 
	if (open_email != null) {
		email_send_ok = "yes"; 
	}
	else {
		email_send_ok = "no";
	}


	String zip = request.getParameter("zip");	
	String addr1 = request.getParameter("addr1");
	String addr2 = request.getParameter("addr2");
	
	String phone = phone1 + "-" + phone2 + "-" + phone3;
	String email = email1 + "@" + email2;
	String addr = addr1 + " " + addr2;
	
	//폼값을 DTO객체에 저장
	MemberDTO dto = new MemberDTO();
	dto.setId(id);
	dto.setPass(pass);
	dto.setName(name);
	dto.setPhone(phone);
	dto.setEmail(email);
	dto.setEmail_send_ok(email_send_ok);
	dto.setZip(zip);
	dto.setAddr(addr);
	
	String drv = application.getInitParameter("MariaJDBCDriver");
	String url = application.getInitParameter("MaiaConnectURL");
	MemberDAO dao = new MemberDAO(drv, url);
	
	int affected = dao.insertMember(dto);
	
	if(affected == 1) {
		response.setContentType("text/html; charset=UTF-8"); 
		PrintWriter writer = response.getWriter();
		
		writer.println("<script>alert('"+ name + "님 환영합니다!!'); location.href='../main/main.do';</script>"); 
		writer.close();
	}
	else {
%>
		<script>
			alert("회원가입에 실패하였습니다ㅜㅜ 관리자에게 문의해주세요!");
			history.go(-1);
		</script>
<%
	}
%>














