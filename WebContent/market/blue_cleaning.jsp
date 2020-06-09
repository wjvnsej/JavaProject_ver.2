<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%@include file="../validation/isLogin.jsp" %>
<%@include file="../validation/isFlag.jsp" %>

<script src="../common/jquery/jquery-3.5.1.js"></script>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script>
//다음 우편번호API
function openZipSearch() {
	new daum.Postcode({
		oncomplete: function(data) {
			$('[name=zip]').val(data.zonecode); // 우편번호 (5자리)
			$('[name=addr1]').val(data.address);
			$('[name=addr2]').val(data.buildingName);
		}
	}).open();
}
//평수계산
function calculator(chk){
	
	var area1 = document.getElementById('area1');
	var area2 = document.getElementById('area2');
  	if(chk==2){
   		area1.value = (parseFloat(area2.value) * 3.3058).toFixed(3);
  	}
  	else {
      	area2.value = (parseFloat(area1.value) / 3.3058).toFixed(3);
  	}
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
		input.phone2_1.focus();
	}
	if(input.phone2_1.value.length == 3){
		input.phone2_2.focus();
	}
	if(input.phone2_2.value.length == 4){
		input.phone2_3.focus();
	}
	if(input.phone2_3.value.length == 4){
		input.email_1.focus();
	}
	
}

$(function() {
	
	//이메일 선택
    $('#selectEmail').change(function(){

        var text = $('#selectEmail option:selected').text();
        var value = $('#selectEmail option:selected').val();
        
        if(value == ''){
            $('#email_2').attr('readonly', true).val('');
        }
        else if(value == 'direct'){
            $('#email_2').attr('readonly', false).val('');
        }
        else{
            $('#email_2').attr('readonly', true);
            $('#email_2').val(value);
        }
    });
	
	//날짜선택
    $( "#datepicker" ).datepicker({
		dateFormat: 'yy-mm-dd'
    });
	
    $('#blue_save').click(function() {
		
		if($('#name').val() == "") {
			alert("이름을 입력하세요.");
			$('#name').focus();
			return false;
		}
		else if($('#phone1_1').val() == "") {
			alert("휴대폰번호를 입력하세요.");
			$('#phone1_1').focus();
			return false;
		}
		else if($('#phone1_2').val() == "") {
			alert("휴대폰번호를 입력하세요.");
			$('#phone1_2').focus();
			return false;
		}
		else if($('#phone1_3').val() == "") {
			alert("휴대폰번호를 입력하세요.");
			$('#phone1_3').focus();
			return false;
		}
		else if($('#email_1').val() == "") {
			alert("이메일을 입력하세요.");
			$('#email_1').focus();
			return false;
		}
		else if($('#email_2').val() == "") {
			alert("이메일을 입력하세요.");
			$('#email_2').focus();
			return false;
		}
		else if($('#zip').val() == "") {
			alert("우편번호를 입력하세요.");
			$('#zip').focus();
			return false;
		}
		else if($('#addr_1').val() == "") {
			alert("주소를 입력하세요.");
			$('#addr_1').focus();
			return false;
		}
		else if($('#addr_2').val() == "") {
			alert("상세주소를 입력하세요.");
			$('#addr_2').focus();
			return false;
		}
		else if($('input:radio[name=cleankind]').is(':checked') == false) {
			alert("청소종류를 선택하세요.");
			return false;
		}
		else if($('#area1').val() == "") {
			alert("평수를 입력하세요.");
			$('#area1').focus();
			return false;
		}
		else if($('#area2').val() == "") {
			alert("평수를 입력하세요.");
			$('#area2').focus();
			return false;
		}
		else if($('#datepicker').val() == "") {
			alert("청소날짜를 선택하세요.");
			$('#datepicker').focus();
			return false;
		}
		else if($('input:radio[name=recep_type]').is(':checked') == false) {
			alert("접수종류를 선택하세요.");
			return false;
		}
		$.ajax({
			url : 'blue_Proc.jsp',
			type : 'post',
			dataType : "html",
			contentType : "application/x-www-form-urlencoded;charset:UTF-8;",
			data : {
				method : "POST",
				name : $('#name').val(),
				phone1_1 : $('#phone1_1').val(),
				phone1_2 : $('#phone1_2').val(),
				phone1_3 : $('#phone1_3').val(),
				phone2_1 : $('#phone2_1').val(),
				phone2_2 : $('#phone2_2').val(),
				phone2_3 : $('#phone2_3').val(),
				email_1 : $('#email_1').val(),
				email_2 : $('#email_2').val(),
				zip : $('#zip').val(),
				addr1 : $('#addr1').val(),
				addr2 : $('#addr2').val(),
				cleankind : $('#cleankind').val(),
				area1 : $('#area1').val(),
				area2 : $('#area2').val(),
				datepicker : $('#datepicker').val(),
				recep_type : $('#recep_type').val(),
				etc : $('#etc').val(),
				bname : $('#bname').val()
			},
			success : function(resData) {
				var data = JSON.parse(resData);
				
				if(data.result == 0) {
					alert(data.message);
				}
				else if(data.result == 1) {
					alert(data.message);
				}
				else if(data.result == -1) {
					alert(data.message);
				}
				location.reload();
			},
			error : function(e) {
				alert("실패Callback : " + e.status + " : " + 
						e.statusText);
			}
		});
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
					<img src="../images/market/sub03_title.gif" alt="블루크리닝 견적 의뢰" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린장터&nbsp;>&nbsp;블루크리닝 견적 의뢰<p>
				</div>
				
				<span style="color: red; font-size: 1em;">* 표시는 필수입력사항 입니다.</span>
				<table cellpadding="0" cellspacing="0" border="0" class="con_table" style="width:100%;">
					<colgroup>
						<col width="25%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th>고객명/회사명<span style="color: red;"> *</span></th>
							<td style="text-align:left;">
								<input type="text" id="name" class="join_input" />
							</td>
						</tr>
						<tr>
							<th>휴대전화<span style="color: red;"> *</span></th>
							<td style="text-align:left;">
								<input type="text" id="phone1_1" name="phone1_1" onkeyup="phone();" maxlength="3" class="join_input" style="width:50px;" /> - 
								<input type="text" id="phone1_2" name="phone1_2" onkeyup="phone();" maxlength="4" class="join_input" style="width:50px;" /> - 
								<input type="text" id="phone1_3" name="phone1_3" onkeyup="phone();" class="join_input" maxlength="4" style="width:50px;" />
							</td>
						</tr>
						<tr>
							<th>비상연락처</th>
							<td style="text-align:left;">
								<input type="text" id="phone2_1" name="phone2_1" onkeyup="phone();" maxlength="3" class="join_input" style="width:50px;" /> - 
								<input type="text" id="phone2_2" name="phone2_2" onkeyup="phone();" maxlength="4" class="join_input" style="width:50px;" /> - 
								<input type="text" id="phone2_3" name="phone2_3" onkeyup="phone();" maxlength="4" class="join_input" style="width:50px;" />
							</td>
						</tr>
						<tr>
							<th>이메일<span style="color: red;"> *</span></th>
							<td align="left">
								<input type="text" name="email_1" id="email_1" style="width:100px;height:20px;border:solid 1px #dadada;" value="" class="join_input" /> @ 
								<input type="text" name="email_2" id="email_2" style="width:150px;height:20px;border:solid 1px #dadada;" value="" readonly="readonly" class="join_input" />
								
								<select id="selectEmail" >
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
							<th>청소할 곳 주소<span style="color: red;"> *</span></th>
							<td align="left">
							<input type="text" name="zip" id="zip" class="join_input" style="width:80px;" />
							<a href="#" title="새 창으로 열림" onclick="openZipSearch(); return false;">[우편번호검색]</a>
							
							<br/>
							
							<input type="text" name="addr1" id="addr1" class="join_input" style="width:400px; margin-top:5px;" readonly="readonly" /><br>
							<input type="text" name="addr2" id="addr2" class="join_input" style="width:400px; margin-top:5px;" placeholder="상세주소를 입력하세요." />
							</td>
						</tr>
						<tr>
							<th>청소의뢰내역<span style="color: red;"> *</span></th>
							<td style="text-align:left;" style="padding:0px;">
								<table cellpadding="0" cellspacing="0" border="0" style="width:100%;">
									<tr>
										<td>청소종류</td>
										<td style="border-right:0px;">
											<label><input type="radio" name="cleankind" id="cleankind" value="홈클리닝" /> 홈클리닝</label>&nbsp;&nbsp;&nbsp;
											<label><input type="radio" name="cleankind" id="cleankind" value="사업장클리닝" /> 사업장클리닝</label>&nbsp;&nbsp;&nbsp;
											<label><input type="radio" name="cleankind" id="cleankind" value="해충방역" /> 해충방역</label>&nbsp;&nbsp;&nbsp;
											<label><input type="radio" name="cleankind" id="cleankind" value="정기청소"/> 정기청소</label>
										</td>
									</tr>
									<tr>
										<td style="border-bottom:0px;">분양평수/등기평수</td>
										<td style="border:0px;">
											<input type="text"  id="area1" onkeyup="calculator(1);" class="join_input" style="width:100px;" />&nbsp;제곱미터(m2)&nbsp;&nbsp;↔&nbsp;&nbsp;
											<input type="text"  id="area2" onkeyup="calculator(2);" class="join_input" style="width:100px;" />&nbsp;평&nbsp;&nbsp;
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<th>청소 희망날짜<span style="color: red;"> *</span></th>
							<td style="text-align:left;">
								<input type="text" id="datepicker" name="datepicker" size="30" class="join_input" />
							</td>
						</tr>
						<tr>
							<th>접수종류 구분<span style="color: red;"> *</span></th>
							<td style="text-align:left;">
								<label><input type="radio" name="recep_type" id="recep_type" value="예약신청"/> 예약신청</label>&nbsp;&nbsp;&nbsp;
								<label><input type="radio" name="recep_type" id="recep_type" value="견적문의"/> 견적문의</label>
							</td>
						</tr>
						<tr>
							<th>기타특이사항</th>
							<td style="text-align:left;">
								<input type="text" id="etc" class="join_input" style="width:400px;" />
								<input type="hidden" name="bname" id="bname" value="<%=bname %>" />
							</td>
						</tr>
					</tbody>
				</table>
				<p style="text-align:center; margin-bottom:40px">
					<input type="image" id="blue_save" src="../images/btn01.gif" />&nbsp;&nbsp;
					<a href="#"><img src="../images/btn02.gif" alt="취소" /></a>
				</p>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
