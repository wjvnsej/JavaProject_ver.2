<%@page import="util.JavascriptUtil"%>
<%@page import="java.util.Map"%>
<%@page import="model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>
<%@include file="../validation/loginOk.jsp" %>
<link rel="stylesheet" href="../common/bootstrap4.4.1/css/bootstrap.css" />
<script src="../common/jquery/jquery-3.5.1.js"></script>

<html>
<head>

<script type="text/javascript">
	
	$(function(){
		
		//아이디 찾기
		$('#id_search').click(function() {
			
			if($('#id_name').val() == "") {
				alert("이름을 입력하세요.");
				$('#id_name').focus();
				return false;
			}
			else if($('#id_email').val() == "") {
				alert("이메일을 입력하세요.");
				$('#id_email').focus();
				return false;
			}
			$.ajax({	
				url : 'id_Search.jsp',
				type : 'post',
				dataType : "html",
				contentType : "application/x-www-form-urlencoded;charset:UTF-8;",
				data : {
					method : "POST",
					id_name : $('#id_name').val(),
					id_email : $('#id_email').val()
				},
				success : function(resData) {
					var data = JSON.parse(resData);
					
					if(data.result == 0) {
						alert(data.message);
					}
					else if(data.result == 1) {
						alert(data.message);
					}
				},
				error : function(e) {
					alert("실패Callback : " + e.status + " : " + 
							e.statusText);
				}
			});
		});
		
		//비밀번호 찾기
		$('#pw_search').click(function() {
			
			if($('#pw_id').val() == "") {
				alert("아이디를 입력하세요.");
				$('#pw_id').focus();
				return false;
			}
			else if($('#pw_name').val() == "") {
				alert("이름을 입력하세요.");
				$('#pw_name').focus();
				return false;
			}
			else if($('#pw_email').val() == "") {
				alert("이메일을 입력하세요.");
				$('#pw_email').focus();
				return false;
			}
			$.ajax({
				url : 'pw_Search.jsp',
				type : 'post',
				dataType : "html",
				contentType : "application/x-www-form-urlencoded;charset:UTF-8;",
				data : {
					method : "POST",
					pw_id : $('#pw_id').val(),
					pw_name : $('#pw_name').val(),
					pw_email : $('#pw_email').val()
				},
				success : function(resData) {
					var data = JSON.parse(resData);
					
					if(data.result == 0) {
						alert(data.message);
					}
					else if(data.result == 1) {
						alert(data.message);
					}
					else if(data.result == -1) {
						alert(data.message);
					}
				},
				error : function(e) {
					alert("실패Callback : " + e.status + " : " + 
							e.statusText);
				}
			});
		});
		
	});
	
</script>
	
</head>
 <body>
	<center>
	<div id="wrap">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/member/sub_image.jpg" id="main_visual" />

		<div class="contents_box">
			<div class="left_contents">
				<%@ include file = "../include/member_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="../images/member/id_pw_title.gif" alt="" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;멤버쉽&nbsp;>&nbsp;아이디/비밀번호찾기<p>
				</div>
				
				<div class="idpw_box">
				
					<div class="id_box">
						<ul>
							<li><input type="text" id="id_name" value="" class="login_input01" /></li>
							<li><input type="text" id="id_email" value="" class="login_input01" /></li>
						</ul>
						<input type="image" id="id_search" src="../images/member/id_btn01.gif" class="id_btn" />
						<a href="./join01.jsp"><img src="../images/login_btn03.gif" class="id_btn02" /></a>
					</div>
				</div>
				
				
				<div class="idpw_box">	
					<div class="pw_box">
						<ul>
							<li><input type="text" id="pw_id" value="" class="login_input01" /></li>
							<li><input type="text" id="pw_name" value="" class="login_input01" /></li>
							<li><input type="text" id="pw_email" value="" class="login_input01" /></li>
						</ul>
						<input type="image" id="pw_search" src="../images/member/id_btn01.gif" class="pw_btn" />
					</div>
					
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>