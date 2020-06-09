<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="util.PagingUtil"%>
<%@page import="model.BbsDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="./common/isLogin.jsp"%>
<%@ include file="./common/isFlag.jsp"%>
<%@ include file="./common/Head.jsp" %>



<%
//한글깨짐처리 - 검색폼에서 입력된 한글이 전송되기 때문
request.setCharacterEncoding("UTF-8");

//web.xml에 저장된 컨텍스트 초기화 파라미터를 application객체를 통해 가져옴
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");

//DAO객체 생성 및 DB커넥션
BbsDAO dao = new BbsDAO(drv, url);

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
List<BbsDTO> bbs = dao.selectListPage(param);

dao.close();

String boardTitle = "";
switch(bname) {

case "notice":
	boardTitle = "공지사항 리스트"; break;
case "calenboard":
	boardTitle = "프로그램일정 리스트"; break;
case "freeboard":
	boardTitle = "자유게시판 리스트"; break;
case "photoboard":
	boardTitle = "사진게시판 리스트"; break;
case "infoboard":
	boardTitle = "정보자료실 리스트"; break;
case "bohojaboard":
	boardTitle = "보호자게시판 리스트"; break;
case "staffboard":
	boardTitle = "직원자료실 리스트"; break;
}
%>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<script src='https://kit.fontawesome.com/a076d05399.js'></script>


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

<div class="right_contents">
		<% 
		if(bname.equals("calenboard")) {
			
			int year;
			int month;
			Calendar today=Calendar.getInstance();
			Calendar cal = new GregorianCalendar();
			
			year = (request.getParameter("year")==null) ?  today.get(Calendar.YEAR) : Integer.parseInt(request.getParameter("year").trim()) ;
			month = (request.getParameter("month")==null) ?   today.get(Calendar.MONTH)+1: Integer.parseInt(request.getParameter("month").trim());
			
			if (month<=0){
			
			 month = 12;
			 year  =year- 1;
			}
			else if (month>=13){
			
			 month = 1;
			 year =year+ 1;
			}
			cal.set(Calendar.YEAR,year);
			cal.set(Calendar.MONTH,(month-1));
			cal.set(Calendar.DATE,1);
		
		%>
		<br />
		<table align="center" width='100%' style="border: 1px solid black; table-layout: fixed; word-wrap:break-word;word-break:break-all; ">  
			<tr >
				<td align="left" height='50' valign="top" style="border: 0px;">  
					<button style="height: 40" type="button" class="btn btn-outline-dark" 
						onclick="location.href='board_List.jsp?bname=<%=bname %>';">이번달</button>
				</td>
				<td align="center" height='50' valign="middle" colspan="5" style="border: 0px;">
					<a href='board_List.jsp?bname=<%=bname %>&year=<%=(cal.get(Calendar.YEAR)-1)%>&month=<%=((cal.get(Calendar.MONTH)+1))%>'><font color='484848' size='2'>◀◀ </font></a>
					<a href='board_List.jsp?bname=<%=bname %>&year=<%=cal.get(Calendar.YEAR)%>&month=<%=((cal.get(Calendar.MONTH)+1)-1)%>'><font color='484848' size='2'>◀ </font></a>
					<font color='484848' size='2'><%=cal.get(Calendar.YEAR)%>년  <%=(cal.get(Calendar.MONTH)+1)%> 월</font>
					<a href='board_List.jsp?bname=<%=bname %>&year=<%=cal.get(Calendar.YEAR)%>&month=<%=((cal.get(Calendar.MONTH)+1)+1)%>'><font color='484848' size='2'>▶ </font></a>
					<a href='board_List.jsp?bname=<%=bname %>&year=<%=(cal.get(Calendar.YEAR)+1)%>&month=<%=((cal.get(Calendar.MONTH)+1))%>'><font color='484848' size='2'>▶▶ </font></a>
				</td>
				
				<td align="right" height='50' valign="bottom" style="border: 0px;">
					<button type="button" class="btn btn-outline-dark" 
						onclick="location.href='board_Write.jsp?bname=<%=bname %>';">글쓰기</button>
				</td>
				
			</tr>
			<tr align="center" bgcolor="#FAF4C0"  style="border: 1px solid black;">
				<td style="color: red;word-wrap:break-word;word-break:break-all;" width="14%;">
					SUN
				</td>
				<td width="14%" style="table-layout:fixed; word-break:break-all;">
					MUN
				</td>
				<td width="14%" style="table-layout:fixed; word-break:break-all;">
					TUE
				</td>
				<td width="14%" style="table-layout:fixed; word-break:break-all;"> 
					WED
				</td>
				<td width="14%" style="table-layout:fixed; word-break:break-all;">
					THU
				</td>
				<td width="14%" style="table-layout:fixed; word-break:break-all;">
					FRI
				</td>
				<td style="color: blue; word-wrap:break-word;word-break:break-all;" width="14%">
					SAT
				</td>
			</tr>

			<%  
			cal.set(year, month-1, 1);
			int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
			%>
			<!-- 맨윗줄 -->
			<tr >
			<%
		
			for(int i=1;i<dayOfWeek;i++){ 
			%>
				<td valign='top' align='left' height='92px' style="table-layout:fixed; word-break:break-all; border: 1px solid black;"></td> 
			<% 
			}
			for(int i=1; i<=cal.getActualMaximum(Calendar.DAY_OF_MONTH);i++){
			
				String Stryear = String.valueOf(year);
				String Strmonth = String.valueOf(month);
				String day = String.valueOf(i);
				
				if(day.length() == 1){
					day = "0" + day; 
				}
				if(Strmonth.length() == 1){
					Strmonth = "0" + Strmonth; 
				}
				
				String date = Stryear + "-" + Strmonth + "-" + day;
		
				%>
				<td valign='top' height='92px' style="overflow:hidden; text-overflow: ellipsis; white-space: nowrap; border: 1px solid black;">
 						<%=i %>
 						<br />
 					
 					<% 
 						String DTOdate = "";
 						String title = "";
 						
 						for(BbsDTO dto : bbs) {
 							DTOdate = dto.getPostDate().toString();
 							if(date.equals(DTOdate)){
 					%>
 								<a href='board_View.jsp?bname=<%=bname %>&num=<%=dto.getNum() %>&year=<%=cal.get(Calendar.YEAR)%>&month=<%=((cal.get(Calendar.MONTH)+1))%>'><%=dto.getTitle() %></a>
	  						<br />
 					<%
 							}
 						}
 					%>
 					</td>
  				<%
            		if((dayOfWeek-1+i)%7==0){
        		%>
           	</tr>
           	<tr align="left" >
			<%
					}
			}
		
			%> 
			</tr>
		</table>
	</div>	
		
		<!-- 사진게시판인경우 -->
		<%
		}else if(bname.equals("photoboard")){ 
		%>
			
			<div class="row mr-1" align="right">
				<!-- 검색부분 -->
				<form class="form-inline ml-auto" name="searchFrm" method="get">
				
				<!-- 검색시 필수파라미터인 bname이 전달되야 한다. -->
				<input type="hidden" name="bname" value="<%=bname %>"  />	
					
					<div class="form-group">
						<select name="searchColumn" class="form-control">
							<option value="title">제목</option>
							<option value="content">내용</option>
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
			</div> <!-- 검색 끝 -->
			
			<br /><br />
			
			<div class="container">
			
			    <div class="row box-2">
					
			        <!-- <center> -->
			    <%
			    String path = "";
			    int vNum = 0;
				int countNum = 0;
				
			    for(BbsDTO dto : bbs) {
			    	
			    	path += "../Upload/" + dto.getOfile();

					vNum = totalRecordCount - 
							(((nowPage - 1) * pageSize) + countNum++);	
			    	
			    %>
			    	<table style="table-layout: fixed;"  >
			        	<tr>
		        			<td width="370px;" height="320px;" style="border: 0px; " nowrap="nowrap">
		        	    		<a href="board_View.jsp?num=<%=dto.getNum() %>&nowPage=<%=nowPage %>&<%=queryStr %>">
							        <div class="grid_4"  style="padding: 5%; " >
							            <div class="img" >
							            	<div class="lazy-img">
							            		<img src=<%=path %> width="320px;" height="200px;">
							            	</div>
							            </div>
							            <br/>
							           	<span style="font-size: 1.5em; overflow:hidden; text-overflow: ellipsis; display: block; "><%=dto.getTitle() %></span>
							           	<br/>
							           	<span style="font-size: 1.2em; overflow:hidden; text-overflow: ellipsis; display: block; white-space:nowrap; ">
							           		<i class="material-icons" style="font-size:12px">person</i>&nbsp;<%=dto.getName() %> &nbsp;&nbsp;
							           		<i class='far fa-clock' style="font-size:12px"></i>&nbsp;<%=dto.getPostDate() %> &nbsp;&nbsp;
							           		<i class='far fa-eye' style='font-size:12px'></i>&nbsp;<%=dto.getVisitcount() %>
							           	</span>
									</div>
				           		</a>
					    	</td>
			       		</tr>
					</table>
					
					
				<%
					path = "";
			    }
				%>
				</div>
				
				<div class="ml-auto" align="right">
					<button type="button" class="btn btn-outline-dark" 
						onclick="location.href='board_Write.jsp?bname=<%=bname %>';">글쓰기</button>		   
				</div>
				
				<div class="row mt-3">
					<div class="col">
						<!-- 페이지번호 부분 -->
						<ul class="pagination justify-content-center">
							<%=PagingUtil.pagingBS4(totalRecordCount,
									pageSize, blockpage, nowPage, 
									"board_List.jsp?" + queryStr) 
							%>
						</ul>
					</div>
				</div>
				
			</div>
		
		<!-- 캘린더게시판/사진게시판 이 아닌경우 -->
		<% }else {%>
			<div class="row mr-1" align="right">
				<!-- 검색부분 -->
				<form class="form-inline ml-auto" name="searchFrm" method="get">
				
				<!-- 검색시 필수파라미터인 bname이 전달되야 한다. -->
				<input type="hidden" name="bname" value="<%=bname %>"  />	
					
					<div class="form-group">
						<select name="searchColumn" class="form-control">
							<option value="title">제목</option>
							<option value="content">내용</option>
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
						<tr style="background-color: rgb(133, 133, 133); " class="text-center text-white">
							<th width="10%">번호</th>
							<th width="45%">제목</th>
							<th width="14%">작성자</th>
							<th width="14%">작성일</th>
							<th width="10%">조회수</th>
						<% if(!bname.equals("freeboard")) { %>
							<th width="14%">첨부</th>
						<%} %>
						</tr>
					</thead>				
					<tbody>
					<%
					//List컬렉션에 입력된 데이터가 없을 때 true를 반환
					if(bbs.isEmpty()) {
					%>
						<tr>
						<% if(bname.equals("freeboard")) { %>
							<td colspan="5" align="center" height="100">
								등록된 게시물이 없습니다.
							</td>
						<%} else{ %>
							<td colspan="6" align="center" height="100">
								등록된 게시물이 없습니다.
							</td>
						<%} %>
						</tr>
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
						for(BbsDTO dto : bbs) {
							
							vNum = totalRecordCount - 
									(((nowPage - 1) * pageSize) + countNum++);	
					%>
					<!-- 리스트반복 start -->
						<tr>
						
							<td class="text-center"><%=vNum %></td>
							
							<td class="text-left" width="600px;" style="overflow:hidden; text-overflow: ellipsis; display: block; white-space: nowrap;">
								
								<a href="board_View.jsp?num=<%=dto.getNum() %>
									&nowPage=<%=nowPage %>&<%=queryStr %>">
									<%=dto.getTitle() %>
								</a>
							</td>
									
							<td class="text-center"><%=dto.getName() %></td>
							<td class="text-center"><%=dto.getPostDate() %></td>
							<td class="text-center"><%=dto.getVisitcount() %></td>
						<%
							if(!(bname.equals("freeboard"))) { 
						%>
							<td class="text-center"> <!-- 첨부파일 -->
						<%
							}
							if(!(bname.equals("freeboard")) && dto.getOfile() != null){
						%>
								<a href="./common/Download.jsp?fileName=<%=dto.getOfile() %>">
									<img src="../images/space/disk.png" width="20" />
								</a>
						<%
							}
						%>
							</td>
						</tr>
					<!-- 리스트반복 end -->
					<%
						} //for-each end
					}//if end
					%>
				
					
					
					</tbody>
				</table>
			
			
			<div class="ml-auto" align="right">
				<button type="button" class="btn btn-outline-dark" 
					onclick="location.href='board_Write.jsp?bname=<%=bname %>';">글쓰기</button>
			</div>
			<% 
			if(!(bname.equals("calenboard"))) {
			%>
			<div class="row mt-3">
				<div class="col">
					<!-- 페이지번호 부분 -->
					<ul class="pagination justify-content-center">
						<%=PagingUtil.pagingBS4(totalRecordCount,
								pageSize, blockpage, nowPage, 
								"board_List.jsp?" + queryStr) 
						%>
					</ul>
				</div>
			</div>
			<%}%>
		</div>
	<%}%>
		
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


















