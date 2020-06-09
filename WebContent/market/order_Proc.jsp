<%@page import="model.ProductDAO"%>
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
String order_record = request.getParameter("order_record");
System.out.println(order_record);

String name1 = request.getParameter("name1");
System.out.println(name1);
String name2 = request.getParameter("name2");
System.out.println(name2);

String phone1_1 = request.getParameter("phone1_1");
String phone1_2 = request.getParameter("phone1_2");
String phone1_3 = request.getParameter("phone1_3");
String phone1 = phone1_1 + "-" +phone1_2 + "-" + phone1_3; 
System.out.println(phone1);

String phone2_1 = request.getParameter("phone2_1");
String phone2_2 = request.getParameter("phone2_2");
String phone2_3 = request.getParameter("phone2_3");
String phone2 = phone2_1 + "-" +phone2_2 + "-" + phone2_3;
System.out.println(phone2);

String email1_1 = request.getParameter("email1_1");
String email1_2 = request.getParameter("email1_2");
String email1 = email1_1 + "@" +email1_2;
System.out.println(email1);

String email2_1 = request.getParameter("email2_1");
String email2_2 = request.getParameter("email2_2");
String email2 = email2_1 + "@" +email2_2;
System.out.println(email2);

String zip1 = request.getParameter("zip1");
String addr1_1 = request.getParameter("addr1_1");
String addr1_2 = request.getParameter("addr1_2");
String addr1 = zip1 + " / " +  addr1_1 + " " + addr1_2;
System.out.println(addr1);

String zip2 = request.getParameter("zip2");
String addr2_1 = request.getParameter("addr2_1");
String addr2_2 = request.getParameter("addr2_2");
String addr2 = zip2 + " / " +  addr2_1 + " " + addr2_2;
System.out.println(addr2);

String msg = request.getParameter("msg");
System.out.println(msg);
String pay_kind = request.getParameter("pay_kind");
System.out.println(pay_kind);


Map<String, String> param = new HashMap<String, String>();
param.put("order_record", order_record);
param.put("name1", name1);
param.put("name2", name2);
param.put("phone1", phone1);
param.put("phone2", phone2);
param.put("email1", email1);
param.put("email2", email2);
param.put("addr1", addr1);
param.put("addr2", addr2);
param.put("msg", msg);
param.put("pay_kind", pay_kind);

//DB연결
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");
ProductDAO dao = new ProductDAO(drv, url);

//데이터 검색 후 Map에 저장
int result =  dao.order_insert(param);
System.out.print(result);

if(result == 0) {
	//값이 없을 때 
%>
	<script>
		alert("주문에 실패했습니다.");
		location.href="market_order.jsp?bname=market_order";
	</script>
<%
}
else {
%>
	<script>
		alert("주문에 성공했습니다.");
		location.href="basket_delete_Proc.jsp";
	</script>
<%	
}

%>