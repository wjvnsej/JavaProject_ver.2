<%@page import="util.PagingUtil"%>
<%@page import="model.RequestDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model.RequestDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="./common/isLogin.jsp"%>
<%@ include file="./common/Head.jsp" %>


<%
//한글깨짐처리 - 검색폼에서 입력된 한글이 전송되기 때문
request.setCharacterEncoding("UTF-8");

String bname = request.getParameter("bname");
String num = request.getParameter("num");

//web.xml에 저장된 컨텍스트 초기화 파라미터를 application객체를 통해 가져옴
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");

//DAO객체 생성 및 DB커넥션
RequestDAO dao = new RequestDAO(drv, url);


/*
검색 후 파라미터 처리를 위한 추가부분
	: 리스트에서 검색 후 상세보기, 그리고 다시 리스트 보기를
	눌렀을 때 검색이 유지되도록 처리하기 위한 코드 삽입.
*/
String queryStr = "bname=" + bname + "&" ;

String searchColumn = request.getParameter("searchColumn");
String searchWord = request.getParameter("searchWord");
if(searchWord != null) {
	queryStr += "searchColumn=" + searchColumn 
					+ "&searchWord=" + searchWord + "&";
}
//3페이지에서 상세보기 했다면 리스트로 돌아갈때도 3페이지로 가야한다.
String nowPage = request.getParameter("nowPage");
if(nowPage == null || nowPage.equals("")) {
	nowPage = "1";
}
queryStr += "&nowPage=" + nowPage;

//게시물을 가져와서 DTO객체로 반환
RequestDTO dto = dao.selectView(num);

dao.close();
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
if(bname.equals("request")){
%>
<h2>블루클리닝 견적서 상세보기</h2>
<%
}
else{
%>
<h2>체험학습 신청저 상세보기</h2>
<%
}
%>


<table class="table table-bordered" style="word-break:break-all;">
	<colgroup>
		<col width="20%"/>
		<col width="30%"/>
		<col width="20%"/>
		<col width="*"/>
	</colgroup>
	<tbody>
		<%
		if(bname.equals("request")){
		%>	
			<tr>
				<th class="text-center table-active align-middle">고객명/회사명</th>
				<td><%=dto.getName() %></td>
				<th class="text-center table-active align-middle">휴대전화/비상전화</th>
				<td><%=dto.getPhone1() %> / <%=dto.getPhone2() %></td>
			</tr>
			<tr>
				<th class="text-center table-active align-middle">이메일</th>
				<td ><%=dto.getEmail() %></td>
				<th class="text-center table-active align-middle">청소희망날짜</th>
				<td><%=dto.getApplydate() %></td>
			</tr>
			<tr>
				<th class="text-center table-active align-middle">청소할 곳 주소</th>
				<td colspan="3">
					<%=dto.getZip() %> / <%=dto.getAddr() %>
				</td>
			</tr>
			<tr>
				<th class="text-center table-active align-middle">청소의뢰내역</th>
				<td colspan="3">
					<%=dto.getCleankind() %> / <%=dto.getArea() %>
				</td>
			</tr>
			<tr>
				<th class="text-center table-active align-middle">접수종류</th>
				<td><%=dto.getRecep_type() %></td>
				<th class="text-center table-active align-middle">특이사항</th>
				<td><%=dto.getEtc() %></td>
			</tr>
		<%
		}
		else {
		%>
			<tr>
				<th class="text-center table-active align-middle">고객명/회사명</th>
				<td><%=dto.getName() %></td>
				<th class="text-center table-active align-middle">휴대전화</th>
				<td ><%=dto.getPhone1() %></td>
			</tr>
			<tr>
				<th class="text-center table-active align-middle">장애유무/장애유형</th>
				<td><%=dto.getDisabled() %></td>
				<th class="text-center table-active align-middle">보장구유무/보장구명</th>
				<td><%=dto.getEquip() %></td>
			</tr>
			<tr>
				<th class="text-center table-active align-middle">체험희망날짜</th>
				<td><%=dto.getApplydate() %></td>
				<th class="text-center table-active align-middle">이메일</th>
				<td><%=dto.getEmail() %></td>
			</tr>
			<tr>
				<th class="text-center table-active align-middle">체험내용</th>
				<td><%=dto.getCake() %> / <%=dto.getCookie() %> / <%=dto.getBread() %></td>
				<th class="text-center table-active align-middle">특이사항</th>
				<td><%=dto.getEtc() %></td>
			</tr>
		<%
		}
		%>
	</tbody>
</table>

<div class="row mb-3">

	<div class="col-6">
		<button type="button" class="btn btn-outline-danger" 
			onclick="location.href='./common/request_deleteProc.jsp?bname=<%=bname %>&num=<%=dto.getNum() %>';">신청내역삭제</button>

	</div>

	<div class="col-6" align="right">

		<button type="button" class="btn btn-outline-secondary" 
			onclick="location.href='request_List.jsp?bname=<%=bname %>';">리스트보기</button>
	</div>
</div>

<form name="deleteFrm">
	<input type="hidden" name="num" value="<%=dto.getNum() %>" />
	<input type="hidden" name="bname" value="<%=bname %>" />
	</form>
</div>






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


















