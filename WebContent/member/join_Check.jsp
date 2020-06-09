<%@page import="util.JavascriptUtil"%>
<%@page import="model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String id = request.getParameter("id");
if(id == null || id.equals("")) {
	JavascriptUtil.jsAlertLocation("잘못된 접근입니다.", "../main/main.do", out);
	return;
}
%>
<style>

	input[type="button"] { 
		width: 100px;
	}
	
</style>

<% 
	String drv = application.getInitParameter("MariaJDBCDriver");
	String url = application.getInitParameter("MaiaConnectURL");
	
	MemberDAO dao = new MemberDAO(drv, url);
	boolean result =  dao.isMember(id);
	
	if(result == true) {
%>
	<center>
		<br /><br />
		<h4>입력하신 <%=id %>는 이미 사용중인 ID 입니다.</h4>
			<input id="cancelBtn" type="button" value="취소" onclick="window.close()">
	</center>
<%
	}
	else {
%>
<script>
	function idUse(){
		opener.document.joinFrm.id.value = "<%=id %>";
		opener.document.joinFrm.id.readOnly = true;
		opener.document.joinFrm.id_check.value = "<%=id %>";
		self.close();
	}
</script>
	<center>
		<br /><br />
		<h4>입력하신 <%=id %>는 사용가능한 ID 입니다.</h4>
		<input id="useBtn" type="button" value="사용하기" onclick="idUse();">
		<input id="cancelBtn" type="button" value="취소" onclick="window.close()">
	</center>
<%
	} 
%>

