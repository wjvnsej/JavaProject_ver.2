<%@page import="model.ProductDTO"%>
<%@page import="model.ProductDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%@include file="../validation/isLogin.jsp" %>
<%@include file="../validation/isFlag.jsp" %>

<script src="../common/jquery/jquery-3.5.1.js"></script>


<%
//폼값 받기 - 파라미터로 전달된 게시물의 일련번호
String num = request.getParameter("num");
ProductDAO dao = new ProductDAO(application);

ProductDTO dto = dao.selectView(num);

String path = "../Upload/" + dto.getP_ofile();

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
			
				<form name="market_Frm" method="post">
					<div class="top_title">
						<img src="../images/market/sub01_title.gif" alt="수아밀 제품 주문" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린장터&nbsp;>&nbsp;수아밀 제품 주문<p>
					</div>
					<div class="market_view_box ml-0">
						<div class="market_left" align="left">
							<img src="<%=path %>" width="300px;" height="250px;" />
						</div>
						<div class="market_right">
							<p class="m_title"><%=dto.getP_name() %>
							<p>- <%=dto.getP_introduce() %></p>
							<ul class="m_list">
								<li>
									<dl>
										<dt>가격</dt>
										<dd class="p_style"><%=dto.getP_price() %></dd>
									</dl>
									<dl>
										<dt>적립금</dt>
										<dd><%=dto.getP_acc() %></dd>
									</dl>
									<dl>
										<dt>수량</dt>
										<dd>
											<input type="number" name="count" value="1" class="n_box" min="1" />
											<input type="hidden" name="num" value="<%=dto.getNum() %>" />
											<input type="hidden" name="price" value="<%=dto.getP_price() %>" />
											<input type="hidden" name="id" value="<%=session.getAttribute("id") %>" />
										</dd>
										
									</dl>
									
									<div style="clear:both;"></div>
								</li>
							</ul>
							<p class="btn_box">
								<a href="market_order.jsp?bname=<%=bname%>">
									<img src="../images/market/m_btn01.gif" alt="바로구매" />
								</a>&nbsp;&nbsp;
								<a href="basket.jsp">
									<input type="image" src="../images/market/m_btn02.gif" onclick="javascript: form.action='basketProc.jsp?mode=insert&bname=market_view';" alt="장바구니" />
								</a>
							</p>
						</div>
					</div>
				</form>
				<img src="<%=path %>" width="600px;" height="700px;" />

			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
