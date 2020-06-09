<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@page import="util.PagingUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="./common/isLogin.jsp"%>
<%@ include file="./common/isFlag.jsp"%>
<%@ include file="./common/Head.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<%
//폼값받기  - 파라미터로 전달된 게시물의 일련번호
String num = request.getParameter("num");
BbsDAO dao = new BbsDAO(application);

//게시물을 가져와서 DTO객체로 변환
BbsDTO dto = dao.selectView(num);

String boardTitle = "";
switch(bname) {

case "notice":
	boardTitle = "공지사항 수정하기"; break;
case "calenboard":
	boardTitle = "프로그램일정 수정하기"; break;
case "freeboard":
	boardTitle = "자유게시판 수정하기"; break;
case "photoboard":
	boardTitle = "사진게시판 수정하기"; break;
case "infoboard":
	boardTitle = "정보자료실 수정하기"; break;
case "bohojaboard":
	boardTitle = "보호자게시판 수정하기"; break;
case "staffboard":
	boardTitle = "직원자료실 수정하기"; break;
}
%>


<script>
    function checkValidate(obj) {
      	if(obj.title.value==""){
        	alert("제목을 입력해주세요!");
        	obj.title.focus();
        	return false;
      	}
      	else if(obj.content.value==""){
        	alert("내용을 입력해주세요!");
        	obj.content.focus();
       		return false;
      	}
      
<%
	if(bname.equals("photoboard")) {
%>
		else if(!obj.insert_file.value){
 			alert("해당게시판은 파일을 첨부가 필수입니다.");
			return false;
		}
<%
	}
%>
      
   }

	function deleteFile() {
	<%
		int result = dao.deleteFile(num);
		
		if(result == 1){
			System.out.println("정상적으로 파일이 삭제되었습니다.");
		}
		else {
			System.out.println("파일 삭제 오류");
		}
		
		dao.close();
	%>
	window.location.reload();
	}

</script>

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


<h2><%=boardTitle %></h2>


<%if(bname.equals("freeboard")) { %>
	<form name="writefrm" method="post" action="./common/board_editProc.jsp?bname=<%=bname %>" onsubmit="return checkValidate(this);" >
		<div class="right_contents">
			<table class="table table-bordered table-striped">
			
				<input type="hidden" name="num" value="<%=dto.getNum() %>" />
				<input type="hidden" name="bname" value="<%=bname %>" />
				<colgroup>
					<col width="20%"/>
					<col width="*"/>
				</colgroup>
				<tbody>
				
					<tr>
						<th class="text-center"
							style="vertical-align:middle;">제목</th>
						<td>
							<input type="text" class="form-control" name="title"
								 value="<%=dto.getTitle() %>"/>
						</td>
					</tr>
					
					<tr>
						<th class="text-center"
							style="vertical-align:middle;">내용</th>
						<td>
							<textarea rows="10" class="form-control" 
								name="content"><%=dto.getContent() %></textarea>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="row mb-3">
			<div class="col text-right">
				<button type="submit" class="btn btn-danger">전송하기</button>
				<button type="reset" class="btn btn-dark">Reset</button>
				<button type="button" class="btn btn-warning" onclick="location.href='board_List.jsp?bname=<%=bname %>';">리스트보기</button>
			</div>
		</div>
	</form>

<%
}
else {
%>
	<form name="writefrm" method="post" action="./common/board_editProc.jsp?bname=<%=bname %>"  onsubmit="return checkValidate(this);" 
		enctype="multipart/form-data">
		<div class="right_contents">
			<table class="table table-bordered table-striped">
			
				<input type="hidden" name="num" value="<%=dto.getNum() %>" />
				<input type="hidden" name="bname" value="<%=bname %>" />
				<colgroup>
					<col width="20%"/>
					<col width="*"/>
				</colgroup>
				<tbody>
				
					<tr>
						<th class="text-center"
							style="vertical-align:middle;">제목</th>
						<td>
							<input type="text" class="form-control" name="title"
								 value="<%=dto.getTitle() %>"/>
						</td>
					</tr>
					
					<tr>
						<th class="text-center"
							style="vertical-align:middle;">내용</th>
						<td>
							<textarea rows="10" class="form-control" 
								name="content"><%=dto.getContent() %></textarea>
						</td>
					</tr>
					<% if((!bname.equals("freeboard"))) { %>
						<tr>
							<th class="text-center"
								style="vertical-align:middle;">첨부파일</th>
							<td>
							
						<% 
							if(dto.getOfile() != null) { 
						%>
								업로드 된 파일 : 
								<a href="./common/Download.jsp?fileName=<%=dto.getOfile() %>">
									<%=dto.getOfile() %>
								</a> &nbsp;
								<button type="button" style="border: 0px; color: red;" onclick="deleteFile();">
									파일삭제하기 <i class="fa fa-close"></i>
								</button>
						<%
							}
							else {
						%>	
								업로드된 파일 없음
						<%
						}
						%>
								<input type="file" class="form-control" name="insert_file" />
							</td>
						</tr>
					<%} %>
				</tbody>
			</table>
		</div>
		<div class="row mb-3">
			<div class="col text-right">
				<button type="submit" class="btn btn-danger">전송하기</button>
				<button type="reset" class="btn btn-dark">Reset</button>
				<button type="button" class="btn btn-warning" onclick="location.href='board_List.jsp?bname=<%=bname %>';">리스트보기</button>
			</div>
		</div>
	</form>
<%} %>


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


















