<%@page import="java.io.PrintWriter"%>
<%@page import="model.ProductDAO"%>
<%@page import="util.JavascriptUtil"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
response.setContentType("text/html; charset=UTF-8"); 
PrintWriter writer = response.getWriter();
request.setCharacterEncoding("UTF-8");

//값 전달받기
String mode = request.getParameter("mode");
String bname = request.getParameter("bname");
String id = (String)session.getAttribute("id");
int num = Integer.parseInt(request.getParameter("num"));
int count = Integer.parseInt(request.getParameter("count"));
int price = Integer.parseInt(request.getParameter("price"));

int total_price =  price * count;

//DB연결
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");
ProductDAO dao = new ProductDAO(drv, url);

if(mode.equals("insert")){
	int affected =  dao.insert_basket(num, id, count, total_price);
	
	System.out.println("affected : " + affected);
	
	if(affected == 0) {
%>	
		<script>
			alert("장바구니 담기에 실패했습니다.");
			history.go(-1);
		</script>	
<%
	}
	else {
%>	
		<script>
			alert("장바구니에 성공적으로 담았습니다.");
			location.href="market_list.jsp?bname=market_list";
		</script>	
<%	
	}
}
else if(mode.equals("update")){
	
	int affected =  dao.update_basket(num, count, total_price);
	
	System.out.println("affected : " + affected);
	
	if(affected == 0) {
%>	
		<script>
			alert("장바구니 수정에 실패했습니다.");
			history.go(-1);
		</script>	
<%
	}
	else {
%>	
		<script>
			alert("장바구니에 수정에 성공했습니다.");
			location.href="basket_list.jsp?bname=basket_list";
		</script>	
<%	
	}
}
%>
	
	
	
	
	
	
	
	
	
	
	
	
	
	