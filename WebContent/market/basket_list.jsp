<%@page import="model.ProductDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="model.ProductDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%@include file="../validation/isLogin.jsp" %>
<%@include file="../validation/isFlag.jsp" %>

<link rel="stylesheet" href="../common/bootstrap4.4.1/css/bootstrap.css" />
<script src="../common/jquery/jquery-3.5.1.js"></script>


<%
//한글깨짐처리 - 검색폼에서 입력된 한글이 전송되기 때문
request.setCharacterEncoding("UTF-8");

String id = (String)session.getAttribute("id");

//web.xml에 저장된 컨텍스트 초기화 파라미터를 application객체를 통해 가져옴
String drv = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MaiaConnectURL");

//DAO객체 생성 및 DB커넥션
ProductDAO dao = new ProductDAO(drv, url);

//로그인한 아이디에 해당하는 장바구니 품목 개수 가져오기
int total = dao.getTotalBasketCount(id);
//로그인한 아이디에 해당하는 장바구니 품목 내용 가져오기
List<ProductDTO> lists = dao.selectBasket(id);
dao.close();

if(lists.isEmpty()) {
%>

<script>
	alert("장바구니가 비었습니다.");
	history.go(-1);
</script>

<%	
}
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
				<table cellpadding="0" cellspacing="0" border="0" class="basket_list">
					<colgroup>
						<col width="7%" />
						<col width="10%" />
						<col width="*" />
						<col width="10%" />
						<col width="8%" />
						<col width="10%" />
						<col width="10%" />
						<col width="10%" />
						<col width="8%" />
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>이미지</th>
							<th>상품명</th>
							<th>판매가</th>
							<th>적립금</th>
							<th>수량</th>
							<th>배송구분</th>
							<th>배송비</th>
							<th>합계</th>
						</tr>
					</thead>
					<tbody>
				
				<%
					//게시물의 가상번호로 사용할 변수
					
					String path = "";
					int sum = 0;
					int i = 1;
				
					for(ProductDTO dto : lists) {
						sum += dto.getP_total_price();
						path += "../Upload/" + dto.getP_ofile();
				%>
						<tr>
							<td><%=i %></td>
							<td><img src="<%=path %>" width="100px;" height="100px;" /></td>
							<td><%=dto.getP_name() %></td>
							<td><%=dto.getP_price() %></td>
							<td>
								<img src="../images/market/j_icon.gif" />&nbsp;
								<%=dto.getP_acc() * dto.getP_cnt() %>원
							</td>
							<td>
								<form name="update_Frm" method="post">
									<input type="hidden" name="num" value="<%=dto.getNum() %>" />
									<input type="hidden" name="price" value="<%=dto.getP_price() %>" />
									<input type="text" name="count" value="<%=dto.getP_cnt() %>" class="basket_num" />&nbsp;
									<input type="image" src="../images/market/m_btn.gif" onclick="javascript: form.action='basketProc.jsp?mode=update&bname=basket_list';" alt="수정" />
								</form>
							</td>
							<td>무료배송</td>
							<td>[무료]</td>
							<td id="sum"><%=dto.getP_total_price() %>원</td>
						</tr>
				<%
						path = "";
						i++;
					}
				
				%>
					</tbody>
				</table>
				<p class="basket_text">
					[ 기본 배송 ] <span>상품구매금액</span> <%=sum %> + <span>배송비</span> 0 = 합계 : <span class="money"><%=sum %>원</span>
					<br /><br />
					<a href="market_list.jsp?bname=market_list">
						<img src="../images/market/basket_btn01.gif" alt="쇼핑계속하기" />
					</a>&nbsp;
					<a href="market_order.jsp?bname=order">
						<img src="../images/market/basket_btn02.gif" alt="전체상품주문" />
					</a>
				</p>
					
			</div>
		</div>
	</div>
	

	
	</center>
		<%@ include file="../include/quick.jsp" %>
	<%@ include file="../include/footer.jsp" %>
 </body>
</html>
