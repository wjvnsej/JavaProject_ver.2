<%@page import="util.PagingUtil"%>
<%@page import="model.MemberDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="./common/isLogin.jsp"%>
<%@ include file="./common/Head.jsp" %>


<%
//한글깨짐처리 - 검색폼에서 입력된 한글이 전송되기 때문
request.setCharacterEncoding("UTF-8");

String grade = request.getParameter("grade");

String id = request.getParameter("id");
//web.xml에 저장된 컨텍스트 초기화 파라미터를 application객체를 통해 가져옴
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");

//DAO객체 생성 및 DB커넥션
MemberDAO dao = new MemberDAO(drv, url);

//게시물을 가져와서 DTO객체로 변환
MemberDTO dto = dao.selectView(id);

%>

<body id="page-top">

  <!-- PageTop -->
  	<%@ include file="./common/PageTop.jsp"%>
  	
    <!-- Navbar Search -->
   	<%@ include file="./common/NavbarSearch.jsp"%>

    <!-- Navbar -->
    <%@ include file="./common/Navbar.jsp"%>


  <div id="wrapper">
 <!-- Sidebar -->
    <%@ include file="./common/Sidebar.jsp"%>


<div id="content-wrapper">

<%
if(grade.equals("user")){
%>
<h2>일반회원 수정하기</h2>
<%
}
else{
%>
<h2>관리자회원 수정하기</h2>
<%
}
%>

<form name="writefrm" method="post" action="./common/editProc.jsp?grade=<%=grade %>">
	<div class="right_contents">
		<table class="table table-bordered table-striped">
		
			<input type="hidden" name="id" value="<%=dto.getId() %>" />
			<input type="hidden" name="grade" value="<%=grade %>" />
			<colgroup>
			<col width="20%"/>
			<col width="30%"/>
			<col width="20%"/>
			<col width="*"/>
		</colgroup>
			<tbody>
			
				<tr>
					<th class="text-center" style="vertical-align:middle;">아이디/비밀번호</th>
					<td>
						<input type="text" class="form-control" name="id" value="<%=dto.getId() %>" readonly="readonly"/>
						<input type="text" class="form-control" name="pass" value="<%=dto.getPass() %>" readonly="readonly"/>
					</td>
					<th class="text-center" style="vertical-align:middle;">회원등급</th>
					<td>
					<%
						if(dto.getGrade().equals("user")){
					%>
						<select id="selectGrade" name="selectGrade" class="form-control" >
							<option value="일반" selected="selected" >일반</option>
							<option value="직원" >직원</option>
						</select>
					<%
						}
						else {
					%>
						<select id="selectGrade" name="selectGrade" class="form-control" >
							<option value="일반" >일반</option>
							<option value="직원" selected="selected" >직원</option>
						</select>
					<%
						}
					%>
					</td>
				</tr>
				<tr>
					<th class="text-center" style="vertical-align:middle;">이름</th>
					<td>
						<input type="text" class="form-control" name="name" value="<%=dto.getName() %>" readonly="readonly"/>
					</td>
					<th class="text-center" style="vertical-align:middle;">전화번호</th>
					<td>
						<input type="text" class="form-control" name="phone" value="<%=dto.getPhone() %>" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th class="text-center" style="vertical-align:middle;">이메일</th>
					<td>
						<input type="text" class="form-control" name="email" value="<%=dto.getEmail() %>" readonly="readonly"/>
					</td>
					<th class="text-center" style="vertical-align:middle;">이메일수신동의</th>
					<td>
						<input type="text" class="form-control" name="email_send_ok" value="<%=dto.getEmail_send_ok() %>" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th class="text-center" style="vertical-align:middle;">우편번호</th>
					<td>
						<input type="text" class="form-control" name="zip" value="<%=dto.getZip() %>" readonly="readonly"/>
					</td>
					<th class="text-center" style="vertical-align:middle;">가입일</th>
					<td>
						<input type="text" class="form-control" name="join_date" value="<%=dto.getJoin_date() %>" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th class="text-center"style="vertical-align:middle;">주소</th>
					<td colspan="3">
						<input type="text" class="form-control" name="addr" value="<%=dto.getAddr() %>" readonly="readonly"/>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="row mb-3">
		<div class="col text-right">
			<button type="submit" class="btn btn-danger">전송하기</button>
			<button type="reset" class="btn btn-dark">Reset</button>
			<button type="button" class="btn btn-warning" onclick="location.href='member_List.jsp?grade=<%=grade %>';">리스트보기</button>
		</div>
	</div>
</form>


<!-- Sticky Footer -->
      <footer class="sticky-footer">
        <div class="container my-auto">
          <div class="copyright text-center my-auto">
            <span>Copyright © Your Website 2019</span>
          </div>
        </div>
      </footer>

    </div>
    <!-- /.content-wrapper -->

  </div>
  <!-- /#wrapper -->

  <!-- Scroll to Top Button-->
  <a class="scroll-to-top rounded" href="#page-top">
    <i class="fas fa-angle-up"></i>
  </a>

  <!-- Logout Modal-->
  <%@include file = "./common/LogoutPage.jsp" %>

  <!-- Bootstrap core JavaScript-->
  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Core plugin JavaScript-->
  <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

  <!-- Page level plugin JavaScript-->
  <script src="vendor/chart.js/Chart.min.js"></script>
  <script src="vendor/datatables/jquery.dataTables.js"></script>
  <script src="vendor/datatables/dataTables.bootstrap4.js"></script>

  <!-- Custom scripts for all pages-->
  <script src="js/sb-admin.min.js"></script>

  <!-- Demo scripts for this page-->
  <script src="js/demo/datatables-demo.js"></script>
  <script src="js/demo/chart-area-demo.js"></script>

</body>
</html>


















