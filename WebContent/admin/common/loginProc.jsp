<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.Map"%>
<%@page import="model.MemberDTO"%>
<%@page import="model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<%-- LoginProcess.jsp --%>
 
<% 
	response.setContentType("text/html; charset=UTF-8"); 
	PrintWriter writer = response.getWriter();
	
	String id = request.getParameter("id");
	String pass = request.getParameter("pass");
	String id_save = request.getParameter("id_save");
	
	System.out.println("id" + id);
	System.out.println("pass" + pass);
	System.out.println("id_save" + id_save);
	
	
	String drv = application.getInitParameter("MariaJDBCDriver");
	String url = application.getInitParameter("MaiaConnectURL");
	
	MemberDAO dao = new MemberDAO(drv, url);
	

	Map<String, String> memberinfo = dao.getMemberMap(id, pass);
	//Map의 id키값에 저장된 값이 있는지 확인
	if(memberinfo.get("id") != null) {
		//저장된 값이 있다면.. 세션영역에 아이디, 패스워드, 이름을 속성으로 저장한다.
		
		if(!(memberinfo.get("grade").equals("user"))) {
			
			session.setAttribute("id", memberinfo.get("id"));
			session.setAttribute("pass", memberinfo.get("pass"));
			session.setAttribute("name", memberinfo.get("name"));
			session.setAttribute("grade", memberinfo.get("grade"));
			
			if(id_save == null){
		        System.out.println("id 저장안함");
				Cookie ck = new Cookie("id","");
				ck.setPath(request.getContextPath());
				ck.setMaxAge(0);//유효시간이 0이므로 사용할수 없는 쿠키가 된다.
				response.addCookie(ck);
			}
			else{
			   Cookie ck = new Cookie("id", id);
			   System.out.println("id 저장");
			   ck.setPath(request.getContextPath());
			   ck.setMaxAge(3600);
			   response.addCookie(ck);
		    }
			
			writer.println("<script>alert('"+ memberinfo.get("grade") + "님 환영합니다!!'); location.href='../index.jsp';</script>");
			writer.close();
			
		}
		else{
			
			writer.println("<script>alert('관리자만 접속가능합니다.'); location.href='../../main/main.do';</script>");
			writer.close();
			
		}
		
	}
	else {
		writer.println("<script>alert('회원가입 후 이용해 주세요.'); location.href='../../main/main.do';</script>"); 
		writer.close();
	}
%>