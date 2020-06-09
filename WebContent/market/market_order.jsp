<%@page import="model.ProductDTO"%>
<%@page import="java.util.List"%>
<%@page import="model.ProductDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>


<%@include file="../validation/isLogin.jsp" %>
<%@include file="../validation/isFlag.jsp" %>

<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
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

//List컬렉션에 입력된 데이터가 없을 때 true를 반환
if(total == 0) {

	JavascriptUtil.jsAlertLocation("장바구니가 비었습니다.", "market_list.jsp?bname=market_list", out);
	return;

}

//로그인한 아이디에 해당하는 장바구니 품목 내용 가져오기
List<ProductDTO> lists = dao.selectBasket(id);

int sum = 0;
dao.close();


String dtostr = "";
int size = 1;
for(ProductDTO dto : lists) {
	sum += dto.getP_total_price();
	
	dtostr += size + ".[상품사진 : " + dto.getP_ofile() + " / " + 
			"상품명 : " + dto.getP_name() + " / " + 
			"금액 : " + dto.getP_price() + " / " + 
			"적립금 : " + dto.getP_acc() + " / " + 
			"주문량 : " + dto.getP_cnt() + " / " + 
			"주문액 : " + dto.getP_total_price() + " / ";
	size++;
}
dtostr += "최종 주문금액 : " + sum + "] ";
%>

<script>

//다음 우편번호API
function openZipSearch1() {
	new daum.Postcode({
		oncomplete: function(data) {
			$('[name=zip1]').val(data.zonecode); // 우편번호 (5자리)
			$('[name=addr1_1]').val(data.address);
			$('[name=addr1_2]').val(data.buildingName);
		}
	}).open();
}
function openZipSearch2() {
	new daum.Postcode({
		oncomplete: function(data) {
			$('[name=zip2]').val(data.zonecode); // 우편번호 (5자리)
			$('[name=addr2_1]').val(data.address);
			$('[name=addr2_2]').val(data.buildingName);
		}
	}).open();
}

//다음값으로 넘기기
function phone() {
	
	var input = document.getElementsByClassName('join_input');
	
	if(input.phone1_1.value.length == 3){
		input.phone1_2.focus();
	}
	if(input.phone1_2.value.length == 4){
		input.phone1_3.focus();
	}
	if(input.phone1_3.value.length == 4){
		input.email1_1.focus();
	}
	if(input.phone2_1.value.length == 3){
		input.phone2_2.focus();
	}
	if(input.phone2_2.value.length == 4){
		input.phone2_3.focus();
	}
	if(input.phone2_3.value.length == 4){
		input.email2_1.focus();
	}
	
}

$(function() {
	
	//이메일 선택
    $('#selectEmail1').change(function(){

        var text = $('#selectEmail1 option:selected').text();
        var value = $('#selectEmail1 option:selected').val();
        
        if(value == ''){
            $('#email1_2').attr('readonly', true).val('');
        }
        else if(value == 'direct'){
            $('#email1_2').attr('readonly', false).val('');
        }
        else{
            $('#email1_2').attr('readonly', true);
            $('#email1_2').val(value);
        }
    });
    $('#selectEmail2').change(function(){

        var text = $('#selectEmail2 option:selected').text();
        var value = $('#selectEmail2 option:selected').val();
        
        if(value == ''){
            $('#email2_2').attr('readonly', true).val('');
        }
        else if(value == 'direct'){
            $('#email2_2').attr('readonly', false).val('');
        }
        else{
            $('#email2_2').attr('readonly', true);
            $('#email2_2').val(value);
        }
    });
    
    /* 배송지랑 주문자가 동일할때 */
    $('#same').click(function() {
		
    	/* 예 선택시 */
    	if($('#same').val() == 'yes'){
    		/* 값 복사 */
    		$('#name2').val($('#name1').val());
    		$('#zip2').val($('#zip1').val());
    		$('#addr2_1').val($('#addr1_1').val());
    		$('#addr2_2').val($('#addr1_2').val());
    		$('#phone2_1').val($('#phone1_1').val());
    		$('#phone2_2').val($('#phone1_2').val());
    		$('#phone2_3').val($('#phone1_3').val());
    		$('#email2_1').val($('#email1_1').val());
    		$('#email2_2').val($('#email1_2').val());
    		$('#msg').focus();
    	}
    	
	});
    
	$('#pay').click(function() {
		
		if($('#zip1').val() == "") {
			alert("주문자 우편번호를 입력하세요.");
			$('#zip1').focus();
			return false;
		}
		else if($('#addr1_1').val() == "") {
			alert("주문자 주소를 입력하세요.");
			$('#addr1_1').focus();
			return false;
		}
		else if($('#addr1_2').val() == "") {
			alert("주문자 상세주소를 입력하세요.");
			$('#addr1_2').focus();
			return false;
		}
		else if($('#phone1_1').val() == "") {
			alert("주문자 휴대폰번호를 입력하세요.");
			$('#phone1_1').focus();
			return false;
		}
		else if($('#phone1_2').val() == "") {
			alert("주문자 휴대폰번호를 입력하세요.");
			$('#phone1_2').focus();
			return false;
		}
		else if($('#phone1_3').val() == "") {
			alert("주문자 휴대폰번호를 입력하세요.");
			$('#phone1_3').focus();
			return false;
		}
		else if($('#email1_1').val() == "") {
			alert("주문자 이메일을 입력하세요.");
			$('#email1_1').focus();
			return false;
		}
		else if($('#email1_2').val() == "") {
			alert("주문자 이메일을 입력하세요.");
			$('#email1_2').focus();
			return false;
		}
		else if($('#name2').val() == "") {
			alert("배송받을 이름을 입력하세요.");
			$('#name2').focus();
			return false;
		}
		else if($('#zip2').val() == "") {
			alert("배송지 우편번호를 입력하세요.");
			$('#zip2').focus();
			return false;
		}
		else if($('#addr2_1').val() == "") {
			alert("배송지 주소를 입력하세요.");
			$('#addr2_1').focus();
			return false;
		}
		else if($('#addr2_2').val() == "") {
			alert("배송지 상세주소를 입력하세요.");
			$('#addr2_2').focus();
			return false;
		}
		else if($('#phone2_1').val() == "") {
			alert("배송지 휴대폰번호를 입력하세요.");
			$('#phone2_1').focus();
			return false;
		}
		else if($('#phone2_2').val() == "") {
			alert("배송지 휴대폰번호를 입력하세요.");
			$('#phone2_2').focus();
			return false;
		}
		else if($('#phone2_3').val() == "") {
			alert("배송지 휴대폰번호를 입력하세요.");
			$('#phone2_3').focus();
			return false;
		}
		else if($('#email2_1').val() == "") {
			alert("배송지 이메일을 입력하세요.");
			$('#email2_1').focus();
			return false;
		}
		else if($('#email2_2').val() == "") {
			alert("배송지 이메일을 입력하세요.");
			$('#email2_2').focus();
			return false;
		}
		else if($('input:radio[name=pay_kind]').is(':checked') == false) {
			alert("결제방식을 선택하세요.");
			return false;
		}
	});
});

</script>

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
				
				<!-- 상품리스트 -->
				<p class="con_tit"><img src="../images/market/basket_title01.gif" /></p>
				<form name="order_Frm" method="post" action='order_Proc.jsp'>
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
						//List컬렉션에 입력된 데이터가 없을 때 true를 반환
						if(lists.isEmpty()) {
						%>
							<tr>
								<td colspan="9" align="center" height="100">
									장바구니에 등록된 상품이 없습니다.
								</td>
							</tr>
						<%
						}
						else {
					
						String path = "";
						int i = 1;
					
						for(ProductDTO dto : lists) {
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
								<td>
									[무료]
								</td>
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
					</p>
					
					<br /><br />
					
					<!-- 주문자정보 -->
					<p class="con_tit" ><img src="../images/market/basket_title02.gif" /></p>
					<p style="text-align:right; color: red;"><span>**빈칸없이 모두 입력해주세요.**</span></p>
					<table cellpadding="0" cellspacing="0" border="0" class="con_table" style="width:100%;" style="margin-bottom:50px;">
						<colgroup>
							<col width="15%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th>성명</th>
								<td style="text-align:left;"><input type="text" id="name1" name="name1" value="<%=session.getAttribute("name") %>" class="join_input" readonly="readonly" /></td>
							</tr>
							<tr>
								<th>주소</th>
								<td style="text-align: left;">
									<input type="text" id="zip1" name="zip1" value=""  class="join_input" style="width:80px;" />
									<a href="#" title="새 창으로 열림" onclick="openZipSearch1(); return false;">[우편번호검색]</a>
									
									<br/>
									
									<input type="text" name="addr1_1" id="addr1_1" value=""  class="join_input" style="width:550px; margin-top:5px;" readonly="readonly" /><br>
									<input type="text" name="addr1_2" id="addr1_2" value=""  class="join_input" style="width:550px; margin-top:5px;" placeholder="상세주소를 입력하세요." />
								</td>
							</tr>
							<tr>
								<th>휴대폰</th>
								<td style="text-align:left;">
									<input type="text" id="phone1_1" name="phone1_1" onkeyup="phone();" maxlength="3" class="join_input" style="width:50px;" /> - 
									<input type="text" id="phone1_2" name="phone1_2" onkeyup="phone();" maxlength="4" class="join_input" style="width:50px;" /> - 
									<input type="text" id="phone1_3" name="phone1_3" onkeyup="phone();" class="join_input" maxlength="4" style="width:50px;" />
								</td>
							</tr>
							<tr>
								<th>이메일주소</th>
								<td align="left">
									<input type="text" name="email1_1" id="email1_1" style="width:100px;height:20px;border:solid 1px #dadada;" value="" class="join_input" /> @ 
									<input type="text" name="email1_2" id="email1_2" style="width:150px;height:20px;border:solid 1px #dadada;" value="" readonly="readonly" class="join_input" />
									
									<select id="selectEmail1" >
										<option selected="selected" value="">선택해주세요</option>
										<option value="direct" >직접입력</option>
										<option value="hanmail.net" >hanmail.net</option>
										<option value="nate.com" >nate.com</option>
										<option value="naver.com" >naver.com</option>
										<option value="gmail.com" >gmail.com</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
					
					<br /><br />
	
					<!-- 배송지정보 -->
					<p class="con_tit"><img src="../images/market/basket_title03.gif" /></p>
					<p style="text-align:right">
						배송지 정보가 주문자 정보와 동일합니까? 
						예<input type="radio" name="same" id="same" value="yes" /> 
						아니오<input type="radio" name="same" id="same" checked="checked" value="" />
					</p>
					<p style="text-align:right; color: red;"><span>**빈칸없이 모두 입력해주세요.**</span></p>
					<table cellpadding="0" cellspacing="0" border="0" class="con_table" style="width:100%;" style="margin-bottom:50px;">
						<colgroup>
							<col width="15%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th>성명</th>
								<td style="text-align:left;"><input type="text" id="name2" name="name2" value="" class="join_input" readonly="readonly" /></td>
							</tr>
							<tr>
								<th>주소</th>
								<td style="text-align: left;">
									<input type="text" id="zip2" name="zip2" value=""  class="join_input" style="width:80px;" />
									<a href="#" title="새 창으로 열림" onclick="openZipSearch2(); return false;">[우편번호검색]</a>
									
									<br/>
									
									<input type="text" name="addr2_1" id="addr2_1" value=""  class="join_input" style="width:550px; margin-top:5px;" readonly="readonly" /><br>
									<input type="text" name="addr2_2" id="addr2_2" value=""  class="join_input" style="width:550px; margin-top:5px;" placeholder="상세주소를 입력하세요." />
								</td>
							</tr>
							<tr>
								<th>휴대폰</th>
								<td style="text-align:left;">
									<input type="text" id="phone2_1" name="phone2_1" onkeyup="phone();" maxlength="3" class="join_input" style="width:50px;" /> - 
									<input type="text" id="phone2_2" name="phone2_2" onkeyup="phone();" maxlength="4" class="join_input" style="width:50px;" /> - 
									<input type="text" id="phone2_3" name="phone2_3" onkeyup="phone();" class="join_input" maxlength="4" style="width:50px;" />
								</td>
							</tr>
							<tr>
								<th>이메일주소</th>
								<td align="left">
									<input type="text" name="email2_1" id="email2_1" style="width:100px;height:20px;border:solid 1px #dadada;" value="" class="join_input" /> @ 
									<input type="text" name="email2_2" id="email2_2" style="width:150px;height:20px;border:solid 1px #dadada;" value="" readonly="readonly" class="join_input" />
									
									<select id="selectEmail2" >
										<option selected="selected" value="">선택해주세요</option>
										<option value="direct" >직접입력</option>
										<option value="hanmail.net" >hanmail.net</option>
										<option value="nate.com" >nate.com</option>
										<option value="naver.com" >naver.com</option>
										<option value="gmail.com" >gmail.com</option>
									</select>
								</td>
							</tr>
							<tr>
								<th>배송메세지</th>
								<td style="text-align:left;">
									<input type="text" id="msg" name="msg"  value="" class="join_input" style="width:500px;" placeholder="※필수사항아님※" />
								</td>
							</tr>
						</tbody>
					</table>
					
					<br /><br />
					
					<!-- 결제정보 -->
					<p class="con_tit"><img src="../images/market/basket_title04.gif" /></p>
					<table cellpadding="0" cellspacing="0" border="0" class="con_table" style="width:100%;" style="margin-bottom:30px;">
						<colgroup>
							<col width="15%" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th>결제금액</th>
								<td style="text-align:left;"><span class="money"><%=sum %>원</span></td>
							</tr>
							<tr>
								<th>결제방식선택</th>
								<td style="text-align:left;">
									<label><input type="radio" id="pay_kind" name="pay_kind" value="카드결제" /> 카드결제</label>&nbsp;&nbsp;&nbsp;
									<label><input type="radio" id="pay_kind" name="pay_kind" value="무통장입금" /> 무통장입금</label>&nbsp;&nbsp;&nbsp;
									<label><input type="radio" id="pay_kind" name="pay_kind" value="실시간 계좌이체" /> 실시간 계좌이체</label>
									<input type="hidden" id="order_record" name="order_record" value="<%=dtostr %>" />
									<input type="hidden" id="sum" name="sum" value="<%=sum %>" />
								</td>
							</tr>
						</tbody>
					</table>
					
					<p style="text-align:right;">
						<a href="">
							<input type="image" src="../images/market/basket_btn04.gif" id="pay" name="pay" alt="결제하기" />
						</a>
					</p>
				</form>
				<%} %>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
