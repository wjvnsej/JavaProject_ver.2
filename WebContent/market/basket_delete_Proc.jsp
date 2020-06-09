<%@page import="model.ProductDAO"%>
<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- DeleteProc.jsp --%>

<%@include file="../validation/isLogin.jsp" %>

<%

ProductDAO dao = new ProductDAO(application);

//세션영역에 저장된 로그인 아이디를 String으로 가져온다.
String id = session.getAttribute("id").toString();

int affected = 0;

affected = dao.basket_delete(id);

if(affected == 1) {
%>
	<script>
		alert("장바구니를 비우기 실패.");
		location.href = "market_order.jsp?bname=market_order";
	</script>
<%
}
else {
%>
	<script>
		alert("장바구니를 비웠습니다.");
		location.href = "market_list.jsp?bname=market_list";
	</script>
<%
}
%>