<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%@include file="../validation/isLogin.jsp" %>
<%@include file="../validation/isFlag.jsp" %>

<script src="../common/jquery/jquery-3.5.1.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<script>

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
	
    $("input:checkbox[name=cake]").click(function(){
    	if($("input:checkbox[name=cake]").is(":checked") == true){
        	$("#cakeCnt").attr("readonly",false);
        	$("#cakeCnt").focus();
    	}
    	else if($("input:checkbox[name=cake]").is(":checked") == false){
        	$("#cakeCnt").attr("readonly",true);
        	$("#cakeCnt").val("");
    	} 
    });
    $("input:checkbox[name=cookie]").click(function(){
    	if($("input:checkbox[name=cookie]").is(":checked") == true){
        	$("#cookieCnt").attr("readonly",false);
        	$("#cookieCnt").focus();
    	}
    	else if($("input:checkbox[name=cookie]").is(":checked") == false){
        	$("#cookieCnt").attr("readonly",true);
        	$("#cookieCnt").val("");
    	} 
    });
    $("input:checkbox[name=bread]").click(function(){
    	if($("input:checkbox[name=bread]").is(":checked") == true){
        	$("#breadCnt").attr("readonly",false);
        	$("#breadCnt").focus();
    	}
    	else if($("input:checkbox[name=bread]").is(":checked") == false){
        	$("#breadCnt").attr("readonly",true);
        	$("#breadCnt").val("");
    	}
    });
    
    $('#ex_save').click(function() {
    	
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
		else if($('#ex_check').is(":checked") == false){
    		alert("체험내용을 선택해주세요.");
    		$('#cake').focus();
    		return false;
    	}
	    else if($('#datepicker').val() == "") {
			alert("청소날짜를 선택하세요.");
			$('#datepicker').focus();
			return false;
		}
	    else if($("#disabled1").is(":checked") == true){
    		if($("#disabled_kind").val() == ""){
            	alert("주요장애유형을 작성해주세요.");
            	$("#disabled_kind").focus();
            	return false;
            }
    	}
    	else if($("#equip1").is(":checked") == true){
    		if($("#equip_name").val() == ""){
            	alert("보장구명을 작성해주세요.");
            	$("#equip_name").focus();
            	return false;
            }
    	}
    	$.ajax({
    		url : 'experience_Proc.jsp',
    		type : 'post',
    		dataType : "html",
    		contentType : "application/x-www-form-urlencoded;charset:UTF-8;",
    		data : {
    			method : "POST",
    			name : $('#name').val(),
    			disabled : $('input[name="disabled"]:checked').val(),
    			disabled_kind : $('#disabled_kind').val(),
    			equip : $('input[name="equip"]:checked').val(),
    			equip_name : $('#equip_name').val(),
    			phone1_1 : $('#phone1_1').val(),
    			phone1_2 : $('#phone1_2').val(),
    			phone1_3 : $('#phone1_3').val(),
    			email_1 : $('#email_1').val(),
    			email_2 : $('#email_2').val(),
    			cake : $('input:checkbox[id="ex_check"]').val(),
    			cakeCnt : $('#cakeCnt').val(),
    			cookie : $('input:checkbox[id="ex_check"]').val(),
    			cookieCnt : $('#cookieCnt').val(),
    			bread : $('input:checkbox[id="ex_check"]').val(),
    			breadCnt : $('#breadCnt').val(),
    			datepicker : $('#datepicker').val(),
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
					<img src="../images/market/sub05_title.gif" alt="체험학습신청" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린장터&nbsp;>&nbsp;체험학습신청<p>
				</div>
				<p class="con_tit"><img src="../images/market/sub05_tit01.gif" /></p>
				<ul class="dot_list">
					<li>무 방부제 • 무첨가제 수제 빵 제작 체험</li>
					<li>사전에 준비된 반죽으로 성형 및 굽기 체험</li>
					<li>참가비 : 일인당 20,000원 (교육비, 재료비 포함)</li>
				</ul>
				<p class="con_tit"><img src="../images/market/sub05_tit02.gif" /></p>
				<ul class="dot_list">
					<li>내가만든 맛있는 쿠키~!</li>
					<li>쿠키의 반죽 ,성형, 굽기 기술 경험의 기회! </li>
					<li>참가비 : 일인당 15,000원 (교육비, 재료비 포함)</li>
				</ul>
				<p class="con_tit"><img src="../images/market/sub05_tit03.gif" /></p>
				<ul class="dot_list">
					<li>만드는 즐거움 받는이에겐 감동을~!</li>
					<li>직접 데코레이션한 세상에서 하나뿐인
						케익을 소중한 사람에게 전하세요~!
					</li>
					<li>준비된 케익시트에 테코레이션 과정 체험</li>
					<li>참가비 : 일인당 25,000원 (교육비, 재료비 포함)</li>
				</ul>
				<div style="text-align:left">
					<img src="../images/market/sub05_img01.jpg" style="margin-bottom:30px;" />
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
								<input type="text" id="name" name="name" class="join_input" />
							</td>
						</tr>
						<tr>
							<th>장애유무<span style="color: red;"> *</span></th>
							<td style="text-align:left;" style="padding:0px;">
								<table cellpadding="0" cellspacing="0" border="0" style="width:100%;">
									<tr>
										<td style="border-bottom:0px;">
											<label><input type="radio" name="disabled" id="disabled1"  value="유" /> 유</label>&nbsp;&nbsp;&nbsp;
											<label><input type="radio" name="disabled" id="disabled2" value="무" checked="checked" /> 무</label>
										</td>
										
										<th style="border-bottom:0px;" width="100px">주요장애유형</th>
										<td style="border-right:0px; border-bottom:0px;">
											<input type="text" name="disabled_kind" id="disabled_kind" class="join_input" />
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<th>보장구 사용유무<span style="color: red;"> *</span></th>
							<td style="text-align:left;" style="padding:0px;">
								<table cellpadding="0" cellspacing="0" border="0" style="width:100%;">
									<tr>
										<td style="border-bottom:0px;">
											<label><input type="radio" name="equip" id="equip1" value="유" /> 유&nbsp;&nbsp;&nbsp;</label>
											<label><input type="radio" name="equip" id="equip2" value="무" checked="checked" /> 무</label>
										</td>
										
										<th style="border-bottom:0px;" width="100px">보장구 명</th>
										<td style="border-right:0px; border-bottom:0px;">
											<input type="text" name="equip_name" id="equip_name" class="join_input" />
										</td>
									</tr>
								</table>
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
							<th>체험내용<span style="color: red;"> *</span></th>
							<td style="text-align:left;" style="padding:0px;">
								<table cellpadding="0" cellspacing="0" border="0" style="width:100%;">
									<tr>
										<td align="center" style="width: 100px;">
											<input type="checkbox" id="ex_check" name="cake" value="케익체험" />&nbsp;&nbsp;케익체험
										</td>
										<td style="border-right:0px;">
											<input type="number" style="width: 50px;" name="cakeCnt" id="cakeCnt" class="join_input" readonly />&nbsp;명
										</td>
									</tr>
									<tr>
										<td align="center">
											<input type="checkbox" id="ex_check" name="cookie" value="쿠키체험" />&nbsp;&nbsp;쿠키체험
										</td>
										<td>
											<input type="number" style="width: 50px;" name="cookieCnt" id="cookieCnt" class="join_input" readonly/>&nbsp;명
										</td>
									</tr>
									<tr>
										<td align="center">
											<input type="checkbox" id="ex_check" name="bread" value="빵체험" />&nbsp;&nbsp;빵체험
										</td>
										<td style="border:0px;">
											<input type="number" style="width: 50px;" name="breadCnt" id="breadCnt" class="join_input" readonly/>&nbsp;명
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<th>체험희망날짜<span style="color: red;"> *</span></th>
							<td style="text-align:left;">
								<input type="text" id="datepicker" name="datepicker" size="30" class="join_input" />
							</td>
						</tr>
						<tr>
							<th>기타특이사항</th>
							<td style="text-align:left;">
								<input type="text" name="etc"  id="etc" class="join_input" style="width:400px;" />
								<input type="hidden" name="bname" id="bname" value="<%=bname %>" />
							</td>
						</tr>
					</tbody>
				</table>
				<p style="text-align:center; margin-bottom:40px">
					<input type="image" id="ex_save" src="../images/btn01.gif" />&nbsp;&nbsp;
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
