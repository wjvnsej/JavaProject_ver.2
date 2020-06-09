<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<%
Cookie[] cookies = request.getCookies();
String user = "";
if(cookies!=null){
   for(Cookie ck : cookies){
      if(ck.getName().equals("id")){
         user = ck.getValue();
      }         
   }
}
%>
<head>

	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="">
	<meta name="author" content="">
	
	<title>SB Admin - Login</title>
	
	<!-- Custom fonts for this template-->
	<link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
	
	<!-- Custom styles for this template-->
	<link href="css/sb-admin.css" rel="stylesheet">
	
	
	<script>
		function loginValidate(fn){
			if(!fn.id.value){
				alert("아이디를 입력하세요");
				fn.id.focus();
				return false;
			}
			if(fn.pass.value==""){
				alert("패스워드를 입력하세요");
				fn.pass.focus();
				return false;
			}
		}
	</script>	
	
</head>

<body class="bg-dark">

	<div class="container">
		<div class="card card-login mx-auto mt-5">
		<div class="card-header">Login</div>
			<div class="card-body">
    
				<form action="./common/loginProc.jsp" method="post" name="loginFrm" onsubmit="return loginValidate(this);">
       				<input type="hidden" name="admin" value="admin" />
					<div class="form-group">
						<div class="form-label-group">
							<input type="text" id="id" name="id" value="<%=(user == null) ? "" : user %>" class="form-control" placeholder="Id" required="required" autofocus="autofocus">
							<label for="id">Id</label>
						</div>
					</div>
					<div class="form-group">
						<div class="form-label-group">
							<input type="password" id="pass" name="pass" class="form-control" placeholder="Password" required="required">
							<label for="pass">Password</label>
						</div>
					</div>
					<div class="form-group">
            			<div class="checkbox">
							<label>
								<input type="checkbox" name="id_save" id="id_save" value="remember-me"
								<% if(user.length()!=0){ %>
					                        checked="checked"
	                     		<%}%>>Remember ID
							</label>
						</div>
					</div>
          
					<button type="submit" class="btn btn-primary btn-block">Login</button>
       
				</form>
			</div>
		</div>
	</div>

	<!-- Bootstrap core JavaScript-->
	<script src="vendor/jquery/jquery.min.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

	<!-- Core plugin JavaScript-->
	<script src="vendor/jquery-easing/jquery.easing.min.js"></script>

</body>

</html>
