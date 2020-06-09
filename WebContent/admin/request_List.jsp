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


//web.xml에 저장된 컨텍스트 초기화 파라미터를 application객체를 통해 가져옴
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");

//DAO객체 생성 및 DB커넥션
RequestDAO dao = new RequestDAO(drv, url);

/* 
파라미터를 저장 할 용도로 생성한 Map컬렉션. 여러개의 파라미터가
있는 경우 한꺼번에 저장한 후 DAO로 전달할것임.
*/
Map<String, Object> param = new HashMap<String, Object>();

//필수파라미터인 bname을 DAO로 전달하기 위해 Map컬렉션에 저장한다.
param.put("bname", bname);

//폼값을 받아서 파라미터를 저장할 변수 생성
String queryStr = ""; //검색시 페이지번호로 쿼리스트링을 넘겨주기 위한 용도

//필수파라미터에 대한 쿼리스트링 처리
queryStr = "bname=" + bname + "&";

//검색어 입력시 전송된 폼값을 받아 Map에 저장
String searchColumn = request.getParameter("searchColumn");
String searchWord = request.getParameter("searchWord");
if(searchWord != null) {
 //검색어를 입력한 경우 Map에 값을 입력함.
 param.put("Column", searchColumn);
 param.put("Word", searchWord);
 //검색어가 있을 때 쿼리스트링을 만들어 준다.
 queryStr += "searchColumn=" + searchColumn + "&searchWord=" + searchWord + "&";
}

//board테이블에 입력된 전체 레코드 갯수를 카운트하여 반환받음
int totalRecordCount = dao.getTotalRecordCount(param);

 
/*** 페이지처리 ***/
//web.xml의 초기화 파라미터 가져와서 정수로 변경 후 저장
int pageSize = Integer.parseInt(application.getInitParameter("PAGE_SIZE"));
int blockpage = Integer.parseInt(application.getInitParameter("BLOCK_PAGE"));

//전체페이지수 계산 => 105개 / 10 => 10.5 => ceil(10.5) => 11
int totalPage = (int)Math.ceil((double)totalRecordCount/pageSize);

/*
현재 페이지 번호 : 파라미터가 없을 때는 무조건 1페이지로 지정하고, 있을때는 해당 값을
	얻어와서 지정한다. 즉, 리스트에 처음 진입했을때는 1페이지가 된다.
*/
int nowPage = (request.getParameter("nowPage") == null
		 		|| request.getParameter("nowPage").equals("")) 
	? 1 : Integer.parseInt(request.getParameter("nowPage"));

//MariaDB를 통해 한 페이지에 출력할 게시물의 범위를 결정한다.
//limit의 첫번째 인자 : 시작인덱스
int start = (nowPage - 1) * pageSize;
//limit의 두번째 인자 : 가져올 레코드의 갯수
int end = pageSize;

//게시물의 범위를 Map컬렉션에 저장하고 DAO로 전달한다.
param.put("start", start);
param.put("end", end);
/*** 페이지처리 end ***/
 
//조건에 맞는 레코드를 select하여 결과셋을 List컬렉션으로 반환받음.
List<RequestDTO> bbs = dao.selectListPage(param);

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
if(bname.equals("apply")) {
%>
<h2>체험학습 신청서</h2>
<%
}
else if(bname.equals("request")) {
%>
<h2>블루클리닝 견적 의뢰서</h2>
<%
}
%>

<div class="row mr-1" align="right">
	<!-- 검색부분 -->
	<form class="form-inline ml-auto" name="searchFrm" method="get">
	
	<!-- 검색시 필수파라미터인 bname이 전달되야 한다. -->
	<input type="hidden" name="bname" value="<%=bname %>"  />	
	
	<div class="form-group">
		<select name="searchColumn" class="form-control">
			<option value="name">이름</option>
			<option value="phone1">연락처</option>
		</select>
	</div>
	<div class="input-group">
		<input type="text" name="searchWord"  class="form-control"/>
		<div class="input-group-btn">
			<button type="submit" class="btn btn-warning">
				<i class='fa fa-search' style='font-size:20px'></i>
					</button>
				</div>
			</div>
		</form>	
	</div>
	<br />
	
	<div class="right_contents">
		<!-- 게시판리스트부분 -->
		<table class="table table-bordered table-hover table-striped" >
			<colgroup>
				<col width="60px"/>
				<col width="*"/>
				<col width="120px"/>
				<col width="120px"/>
				<col width="80px"/>
				<col width="60px"/>
			</colgroup>				
			<thead>
			<%
			if(bname.equals("request")){
			%>
				<tr style="background-color: rgb(133, 133, 133); " class="text-center text-white">
					<th width="5%">번호</th>
					<th width="15%">이름</th>
					<th width="15%">전화번호</th>
					<th width="15%">이메일</th>
					<th width="15%">신청날짜</th>
					<th width="10%">접수종류</th>
					<th width="25%">주소</th>
				</tr>
			<%
			}
			else{
			%>
				<tr style="background-color: rgb(133, 133, 133); " class="text-center text-white">
					<th width="5%">번호</th>
					<th width="15%">이름</th>
					<th width="15%">장애유무/장애유형</th>
					<th width="15%">보장구유무/보장구명</th>
					<th width="15%">전화번호</th>
					<th width="20%">이메일</th>
					<th width="15%">체험희망날짜</th>
				</tr>
			<%
			} 
			%>
			</thead>				
			<tbody>
			<%
			//List컬렉션에 입력된 데이터가 없을 때 true를 반환
			if(bbs.isEmpty()) {
			%>
				<%if(bname.equals("request")){ %>
					<tr>
						<td colspan="7" align="center" height="100">
							등록된 블루클리닝 견적서가 없습니다.
						</td>
					</tr>
				<%
				}
				else{
				%>
					<tr>
						<td colspan="7" align="center" height="100">
							등록된 체험학습 신청서가 없습니다.
						</td>
					</tr>
				<%
				} 
				%>
			<% 
			}
			else {
				//게시물의 가상번호로 사용할 변수
				int vNum = 0;
				int countNum = 0;
				/*
				컬렉션에 입력된 데이터가 있다면 저장된 BbsDTO의 갯수만큼
				즉, DB가 반환해준 레코드릐 갯수 만큼 반복하면서 출력한다.
				*/
				for(RequestDTO dto : bbs) {
					
					vNum = totalRecordCount - 
							(((nowPage - 1) * pageSize) + countNum++);	
			%>
			<!-- 리스트반복 start -->
				<%if(bname.equals("request")){ %>	
					<tr>
						<td class="text-center"><%=vNum %></td>
						<td class="text-center" style="overflow:hidden; text-overflow: ellipsis;  white-space: nowrap;">
							<a href="request_View.jsp?bname=<%=bname %>&num=<%=dto.getNum() %>&nowPage=<%=nowPage %>&<%=queryStr %>">
								<%=dto.getName() %>
							</a>
						</td>
						<td class="text-center"><%=dto.getPhone1() %></td>				
						<td class="text-center"><%=dto.getEmail() %></td>
						<td class="text-center"><%=dto.getApplydate() %></td>
						<td class="text-center"><%=dto.getRecep_type() %></td>
						<td class="text-center"><%=dto.getAddr() %></td>
					</tr>
				<%
				}
				else {
				%>
					<tr>
						<td class="text-center"><%=vNum %></td>
						<td class="text-center" style="overflow:hidden; text-overflow: ellipsis;  white-space: nowrap;">
							<a href="request_View.jsp?bname=<%=bname %>&num=<%=dto.getNum() %>&nowPage=<%=nowPage %>&<%=queryStr %>">
								<%=dto.getName() %>
							</a>
						</td>
						<td class="text-center"><%=dto.getDisabled() %></td>				
						<td class="text-center"><%=dto.getEquip() %></td>
						<td class="text-center"><%=dto.getPhone1() %></td>
						<td class="text-center"><%=dto.getEmail() %></td>
						<td class="text-center"><%=dto.getApplydate() %></td>
					</tr>
				<%
				}
				%>
			<!-- 리스트반복 end -->
			<%
				} //for-each end
			}//if end
			%>
			</tbody>
		</table>
		
		<div class="row mt-3">
			<div class="col">
				<!-- 페이지번호 부분 -->
				<ul class="pagination justify-content-center">
					<%=PagingUtil.pagingBS4(totalRecordCount,
							pageSize, blockpage, nowPage, 
							"member_List.jsp?" + queryStr) 
					%>
				</ul>
			</div>
		</div>
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


















