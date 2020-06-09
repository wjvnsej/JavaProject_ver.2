<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%@include file="../validation/loginOk.jsp" %>

<%
String agreement = request.getParameter("agreement");
if(agreement == null || agreement.equals("")) {
	JavascriptUtil.jsAlertLocation("약관에 동의해주세요.", "../member/join01.jsp", out);
	return;
}
%>

<html>
<head>
<script src="../common/jquery/jquery-3.5.1.js"></script>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script>
	
	$(function() {
		
		//아이디 생성 규칙
		$('#id').keyup(function() {
			var id = $(this).val();
			
			if(id == ""){
				$('#id_msg').text('');
			}
			if(id.search(/\s/) != -1) { 
				$('#id_msg').text('* 공백을 지우고 입력해주세요.')
				.css('color','red');
			}
			else if(id.length < 4 || id.length > 12) {
				$('#id_msg').text('* 4자~12자 사이로 입력해주세요.')
				.css('color','red');
			}
			else if(!(id.length < 4 || id.length > 12)) {
				$('#id_msg').text('');
			}
		});
		
		//비밀번호 조합 확인 메소드
		$('#pass1').keyup(function(){
			
            $('#pass2').val("");
            $('#pw_msg2').text('');
            
            var pwd1 = $(this).val();
            var pwd2 = $('#pass2').val();
            var pwdNum = /[0-9]/;
            var pwdChar = /[a-zA-Z]/;

            if(pwd1 == ""){
				$('#pw_msg1').text('');
			}
            else if(pwd1.search(/\s/) != -1) { 
				$('#pw_msg1').text('* 공백을 지우고 입력해주세요.')
				.css('color','red');
			}
            else if(pwd1.length < 4 || pwd1.length > 12 || !pwdNum.test(pwd1) || !pwdChar.test(pwd1)){
            	$('#pw_msg1').text('* 4자~12자 사이의 영문/숫자 조합으로 해주세요.')
            		.css('color','red');
            }
            else {
            	$('#pw_msg1').text('* 올바른 패스워드 조합 입니다.')
            		.css('color','blue');
            }            
        });
		
		//비밀번호 일치여부 확인 메소드
        $('#pass2').keyup(function(){
            var pwd1 = $('#pass1').val();
            var pwd2 = $(this).val();
            
            if(pwd1 == ""){}
            else if(pwd1 == pwd2){
            	$('#pw_msg2').text('* 패스워드가 일치합니다.')
        		.css('color','blue');
            }
            else{
                $('#pw_msg2').css('color','red')
                        .text("* 패스워드가 일치하지 않습니다.");
            }
        });
		
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
		
	});
	
	//아이디 중복검사
	function id_check_person() {
		
		var id = document.joinFrm.id.value;
		
		var url = "join_Check.jsp?id=" + id;		
		window.open(url,"","width=550, height=300, resizable = no, scrollbars = no");
		
	}
	
	//빈값체크
	function checkValidate() {
		var info = document.getElementsByClassName("join_input");
		
		if(info.name.value == "") {
			alert("이름을 입력하세요.");
			info.name.focus();
			return false;
		}
		if(info.id.value == "") {
			alert("아이디를 입력하세요.");
			info.id.focus();
			return false;
		}
		if(info.id_check.value == "") {
			alert("아이디 중복확인 해주세요!");
			return false;
		}		
		if(info.pass1.value == "" || info.pass2.value == "") {
			alert("비밀번호를 입력하세요.");
			info.pass1.focus();
			return false;
		}
		if(info.mobile1.value == "" || info.mobile2.value == "" || info.mobile3.value == "") {
			alert("핸드폰번호를 입력하세요.");
			info.mobile1.focus();
			return false;
		}
		if(info.email_1.value == "" || info.email_2.value == "") {
			alert("이메일을 입력하세요.");
			info.email_1.focus();
			return false;
		}
		if(info.zip.value == "" || info.addr1.value == "" || info.addr2.value == "") {
			alert("주소를 입력하세요.");
			info.addr2.focus();
			return false;
		}
	}
	
	// 다음 우편번호API
	function openZipSearch() {
		new daum.Postcode({
			oncomplete: function(data) {
				$('[name=zip]').val(data.zonecode); // 우편번호 (5자리)
				$('[name=addr1]').val(data.address);
				$('[name=addr2]').val(data.buildingName);
			}
		}).open();
	}
	
</script>
</head>
 <body>
 <center>
	<div id="wrap">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/member/sub_image.jpg" id="main_visual" />

		<div class="contents_box">
			<div class="left_contents">
				<%@ include file = "../include/member_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="../images/join_tit.gif" alt="회원가입" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;멤버쉽&nbsp;>&nbsp;회원가입<p>
				</div>

				<p class="join_title"><img src="../images/join_tit03.gif" alt="회원정보입력" /></p>
				<form name="joinFrm" method="post" action="joinProc.jsp" onsubmit="return checkValidate(this);">
					<table cellpadding="0" cellspacing="0" border="0" class="join_box">
						<colgroup>
							<col width="80px;" />
							<col width="*" />
						</colgroup>
						<tr>
							<th><img src="../images/join_tit001.gif" /></th>
							<td><input type="text" name="name" value="" class="join_input" /></td>
						</tr>
						<tr>
							<th><img src="../images/join_tit002.gif" /></th>
							<td>
								<input type="text" name="id" id="id" value="" class="join_input" placeholder="공백없이 4~12자 이내로 기입" />&nbsp;
								<button type="button" style="border: 0px;" onclick="id_check_person();">
									<img src="../images/btn_idcheck.gif" alt="중복확인"/>
								</button>&nbsp;&nbsp;
								<span id="id_msg"></span>
								<input type="hidden" name="id_check" id="id_check" class="join_input"  />
							</td>
						</tr>
						<tr>
							<th><img src="../images/join_tit003.gif" /></th>
							<td>
								<input type="password" name="pass1" id="pass1" value="" class="join_input" placeholder="4~12자 이내의 영문/숫자 조합" />
								&nbsp;&nbsp;<span id="pw_msg1"></span>
							</td>
						</tr>
						<tr> 
							<th><img src="../images/join_tit04.gif" /></th>
							<td>
								<input type="password" name="pass2" id="pass2" value="" class="join_input" />
								&nbsp;&nbsp;<span id="pw_msg2"></span>
							</td>
						</tr>
						<tr>
							<th><img src="../images/join_tit07.gif" /></th>
							<td>
								<input type="text" name="mobile1" value="" maxlength="3" class="join_input" style="width:50px;" />&nbsp;-&nbsp;
								<input type="text" name="mobile2" value="" maxlength="4" class="join_input" style="width:50px;" />&nbsp;-&nbsp;
								<input type="text" name="mobile3" value="" maxlength="4" class="join_input" style="width:50px;" />
							</td>
						</tr>
						<tr>
							<th><img src="../images/join_tit08.gif" /></th>
							<td>
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
								<input type="checkbox" name="open_email" value="1">
								<span>이메일 수신동의</span>
							</td>
						</tr>
						<tr>
							<th><img src="../images/join_tit09.gif" /></th>
							<td>
								<input type="text" name="zip" value=""  class="join_input" style="width:80px;" />
								<a href="#" title="새 창으로 열림" onclick="openZipSearch(); return false;">[우편번호검색]</a>
								
								<br/>
								
								<input type="text" name="addr1" value=""  class="join_input" style="width:550px; margin-top:5px;" readonly="readonly" /><br>
								<input type="text" name="addr2" value=""  class="join_input" style="width:550px; margin-top:5px;" placeholder="상세주소를 입력하세요." />
							</td>
						</tr>
					</table>

					<p style="text-align:center; margin-bottom:20px">
						<button type="submit">
							<img src="../images/btn01.gif" />
						</button>&nbsp;&nbsp;
						<a href="../main/main.do"><img src="../images/btn02.gif" /></a>
					</p>
				</form>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	
	<%@ include file="../include/footer.jsp" %>
</center>
 </body>
</html>
