<%@page import="util.PagingUtil"%>
<%@page import="model.ProductDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model.ProductDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>


<%@include file="../validation/isLogin.jsp" %>
<%@include file="../validation/isFlag.jsp" %>

<link rel="stylesheet" href="../common/bootstrap4.4.1/css/bootstrap.css" />
<script src="../common/jquery/jquery-3.5.1.js"></script>

<script src='https://kit.fontawesome.com/a076d05399.js'></script>

<%
//한글깨짐처리 - 검색폼에서 입력된 한글이 전송되기 때문
request.setCharacterEncoding("UTF-8");
//web.xml에 저장된 컨텍스트 초기화 파라미터를 application객체를 통해 가져옴
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");

//DAO객체 생성 및 DB커넥션
ProductDAO dao = new ProductDAO(drv, url);

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
List<ProductDTO> p_list = dao.selectListPage(param);

dao.close();
%>


 <body>
	<center>
	<div id="wrap">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/market/sub_image.jpg" id="main_visual" />

		<div class="contents_box">
			<div class="left_contents">
				
				<%@ include file = "../include/market_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="../images/market/sub01_title.gif" alt="수아밀 제품 주문" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린장터&nbsp;>&nbsp;수아밀 제품 주문<p>
				</div>
				
				
				<div class="row mr-1" align="right">
					<button type="button" class="btn btn-outline-danger" 
						onclick="location.href='basket_list.jsp?bname=<%=bname %>';">장바구니 바로가기</button>	
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
				
				<br />
				
				<table cellpadding="0" cellspacing="0" border="0" class="market_board01 ">
					<colgroup>
						<col width="10%" />
						<col width="20%" />
						<col width="*" />
						<col width="10%" />
						<col width="10%" />
						<col width="15%" />
					</colgroup>
					<tr>
						<th>번호</th>
						<th>상품이미지</th>
						<th>상품명</th>
						<th>가격</th>
						<th>수량</th>
						<th>구매</th>
					</tr>
					
				<%
				//List컬렉션에 입력된 데이터가 없을 때 true를 반환
				if(p_list.isEmpty()) {
				%>
					<tr>
						<td colspan="6" align="center" height="100">
							등록된 상품이 없습니다.
						</td>
					</tr>
				<%
				}
				else {
					//게시물의 가상번호로 사용할 변수
					int vNum = 0;
					int countNum = 0;
					String path = "";
					/* 리스트반복 start */
					for(ProductDTO dto : p_list) {
						
						path += "../Upload/" + dto.getP_ofile();
						
						vNum = totalRecordCount - 
								(((nowPage - 1) * pageSize) + countNum++);	
				%>
						<form name="market_Frm" method="post">
							<tr>
								<td class="text-center"><%=vNum %></td>
								<td>
									<a href="market_view.jsp?bname=<%=bname %>&num=<%=dto.getNum() %>&nowPage=<%=nowPage %>&<%=queryStr %>">
										<img src="<%=path %>" width="100px;" height="100px;" />
									</a>
								</td>
								<td class="t_left">
									<a href="market_view.jsp?bname=<%=bname %>&num=<%=dto.getNum() %>&nowPage=<%=nowPage %>&<%=queryStr %>">
											<%=dto.getP_name() %>
									</a>
								</td>
								<td class="p_style"><%=dto.getP_price() %></td>
								<td>
									<input type="number" value="1" name="count" class="n_box" min="1" />
									<input type="hidden" name="num" value="<%=dto.getNum() %>" />
									<input type="hidden" name="price" value="<%=dto.getP_price() %>" />
									<input type="hidden" name="id" value="<%=session.getAttribute("id") %>" />
								</td>
								<td>
								
									<input type="image" src="../images/market/btn01.gif" onclick="javascript: form.action='market_order.jsp?&bname=market_order';" alt="바로구매" />
									
									<br />
									
									<input type="image" src="../images/market/btn02.gif" onclick="javascript: form.action='basketProc.jsp?mode=insert&bname=market_list';" alt="장바구니" />
									
								</td>
							</tr>
						</form>
				<%
						path = "";
					}/* 리스트반복 end */
				}/* if end */
				%>
				</table>
				
				<br />
				
				<div class="row mt-3">
					<div class="col">
						<!-- 페이지번호 부분 -->
						<ul class="pagination justify-content-center">
							<%=PagingUtil.pagingBS4(totalRecordCount, pageSize, blockpage, nowPage, "market_list.jsp?" + queryStr) 
							%>
						</ul>
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
