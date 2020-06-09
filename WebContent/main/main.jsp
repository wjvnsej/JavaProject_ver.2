<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
Cookie[] cookies = request.getCookies();
String user = "";
if(cookies!=null){
   for(Cookie ck : cookies){
      if(ck.getName().equals("id")){
         user = ck.getValue();
      }         
   }
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>마포구립장애인 직업재활센터</title>
<style type="text/css" media="screen">
@import url("../css/common.css");
@import url("../css/main.css");
@import url("../css/sub.css");
</style>
<script src="../common/jquery/jquery-3.5.1.js"></script>
<script>

$(function () {
	   $('#calendar_view').load('../include/Calendar.jsp');
	   $('#month_prev').click(function(){
	      var n_year = parseInt($('#now_year').val());
	      var n_month = parseInt($('#now_month').val());
	      if(n_month==0){
	         n_year--;
	         n_month=11;
	      }else{
	         n_month--;
	      }
	      
	      $('#now_year').val(n_year);
	      $('#now_month').val(n_month);
	      $('#calendar_n_view').html(n_year+"년"+(n_month+1)+'월');
	      
	      $.get('../include/Calendar.jsp',
	         {
	            y : n_year,
	            m: n_month
	         },
	         function(d){
	            $('#calender_view').html(d);
	         }
	      );
	   });
	   
	   $('#month_next').click(function(){
	      var n_year = parseInt($('#now_year').val());
	      var n_month = parseInt($('#now_month').val());
	      
	      if(n_month==11){
	         n_year++;
	         n_month=0;
	      }else{
	         n_month++;
	      }
	      $('#now_year').val(n_year);
	      $('#now_month').val(n_month);
	      $('#calendar_n_view').html(n_year+'년'+(n_month+1)+'월');
	      
	      $.ajax({
	         url : "../include/Calendar.jsp",
	         dataType : "html",
	         type : "post",
	         contentType : "application/x-www-form-urlencoded;charset=",
	         data : {
	            y : n_year, m : n_month
	         },
	         success : function(responseData){
	            $('#calendar_view').html(responseData);
	         },
	         error : function(errorData){
	            alert("오류발생: "+errorData.status+":"+errorData.statusText);
	         }
	      });
	   });
	});
	   
</script>
<%
/* 캘린터 클래스로 현재 년/월 구하기 */
Calendar nowDay = Calendar.getInstance();
int now_year = nowDay.get(Calendar.YEAR);
int now_month = nowDay.get(Calendar.MONTH);
%>
<input type="hidden" id="now_year" value="<%=now_year %>" />
<!-- Calendar클래스의 월은 0~11까지 표현된다. -->
<input type="hidden" id="now_month" value="<%=now_month %>" />

</head>
<body>
<center>

	<div id="wrap">
		<%@ include file="../include/top.jsp"%>
		
		<div id="main_visual">
		<a href="/product/sub01.jsp"><img src="../images/main_image_01.jpg" /></a><a href="/product/sub01_02.jsp"><img src="../images/main_image_02.jpg" /></a><a href="/product/sub01_03.jsp"><img src="../images/main_image_03.jpg" /></a><a href="/product/sub02.jsp"><img src="../images/main_image_04.jpg" /></a>
		</div>

		<div class="main_contents">
		
			<div class="main_con_left">
				<p class="main_title" style="border:0px; margin-bottom:0px;"><img src="../images/main_title01.gif" alt="로그인 LOGIN" /></p>
				
				<%
					//로그인 전이거나 로그인에 실패했을 때 출력되는 내용
					if(session.getAttribute("id")==null){
				%>
						<script>
						function loginValidate(fn){
							if(!fn.id.value){
								alert("아이디를 입력하세요");
								fn.id.focus();
								return false;
							}
							if(fn.pass.value==""){
								alert("패스워드를 입력하세요");
								fn.pass.focus();
								return false;
							}
						}
						</script>
						<div class="login_box">
							<form action="../member/loginProc.jsp" method="post" name="loginFrm" onsubmit="return loginValidate(this);">
								<table cellpadding="0" cellspacing="0" border="0">
									<colgroup>
										<col width="45px" />
										<col width="120px" />
										<col width="55px" />
									</colgroup>
									<tr>
										<th><img src="../images/login_tit01.gif" alt="아이디" /></th>
										<td><input type="text" name="id" value="<%=(user == null) ? "" : user %>" class="login_input" tabindex="1" /></td>
										<td rowspan="2"><input type="image" src="../images/login_btn01.gif" alt="로그인" tabindex="4" /></td>
									</tr>
									<tr>
										<th><img src="../images/login_tit02.gif" alt="패스워드" /></th>
										<td><input type="password" name="pass" value="" class="login_input" tabindex="2" /></td>
									</tr>
								</table>
								<p>
									<input type="checkbox" name="id_save" id="id_save" value="Y"
										 <% if(user.length()!=0){ %>
					                        checked="checked"
					                     <%}%>
					                />
						<img src="../images/login_tit03.gif" alt="저장" />
						<a href="../member/id_pw.jsp"><img src="../images/login_btn02.gif" alt="아이디/패스워드찾기" /></a>
						<a href="../member/join01.jsp"><img src="../images/login_btn03.gif" alt="회원가입" /></a>
								</p>
							</form>
						</div>
					<% 
					}
					else { 
					%>
						<!-- 로그인 후 -->
						<p style="padding:10px 0px 10px 10px"><span style="font-weight:bold; color:#333;">
							<%=session.getAttribute("name") %>님,</span> 반갑습니다.<br />로그인 하셨습니다.</p>
						<p style="text-align:right; padding-right:10px;">
							<a href=""><img src="../images/login_btn04.gif" alt="회원정보수정" /></a>
							<a href="../member/logout.jsp"><img src="../images/login_btn05.gif" alt="로그아웃" /></a>
						</p>
					<%
					}
					%>
			</div>
			
			
			<div class="main_con_center">
				<p class="main_title"><img src="../images/main_title02.gif" alt="공지사항 NOTICE" /><a href="../space/board_list.jsp?bname=notice"><img src="../images/more.gif" alt="more" class="more_btn" /></a></p>
				<c:choose>
					<c:when test="${empty lists_notice}">
						<center>
							<p>등록된 게시물이 없습니다.</p>
						</center>
					</c:when>
					<c:otherwise>
						<c:forEach items="${lists_notice}" var="notice_row" varStatus="loop">
								<ul class="main_board_list">
									<li >
										<p >
											<a style="overflow:hidden; text-overflow: ellipsis; white-space: nowrap; width: 200px; display: inline-block;"
											 href="../space/board_view.jsp?bname=notice&num=${notice_row.num}">${notice_row.title}</a>
											<span>${notice_row.postDate}</span>
										</p>
									</li>
								</ul>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>
			<div class="main_con_right">
				<p class="main_title"><img src="../images/main_title03.gif" alt="자유게시판 FREE BOARD" /><a href="../space/board_list.jsp?bname=freeboard"><img src="../images/more.gif" alt="more" class="more_btn" /></a></p>
				<c:choose>
					<c:when test="${empty lists_free}">
						<center>
							<p>등록된 게시물이 없습니다.</p>
						</center>
					</c:when>
					<c:otherwise>
						<c:forEach items="${lists_free}" var="free_row" varStatus="loop">
								<ul class="main_board_list">
									<li >
										<p>
											<a style="overflow:hidden; text-overflow: ellipsis; white-space: nowrap; width: 200px; display: inline-block;" 
												href="../space/board_view.jsp?bname=freeboard&num=${free_row.num}">${free_row.title}
											</a>
											<span>
												${free_row.postDate}
											</span>
										</p>
									</li>
								</ul>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		<div class="main_contents">
			<div class="main_con_left">
				<p class="main_title"><img src="../images/main_title04.gif" alt="연락처  CONTACT" /></p>
				<img src="../images/main_tel.gif" />
			</div>
			<div class="main_con_center">
				<p class="main_title" style="border:0px; margin-bottom:0px;"><img src="../images/main_title05.gif" alt="월간일정 CALENDAR" /></p>
				<div class="cal_top">
					<table cellpadding="0" cellspacing="0" border="0">
						<colgroup>
							<col width="13px;" />
							<col width="*" />
							<col width="13px;" />
						</colgroup>
						<tr>
							<!-- 이전달보기 -->
							<td><img src="../images/cal_a01.gif" style="margin-top:3px; cursor:pointer;" id="month_prev"/></td>
							<!-- 년/월 표시 -->
							<td style="font-weight: bold; font-size: 24px;" id="calendar_n_view">
								2020년 06월
							</td>
							<!-- 다음달 보기 -->
							<td><img src="../images/cal_a02.gif" style="margin-top:3px; cursor:pointer;" id="month_next" /></td>
						</tr>
					</table>
				</div>
				<div class="cal_bottom" id="calendar_view">
					<!-- 실제 달력이 출력되는 영역 -->
					<%-- <table cellpadding="0" cellspacing="0" border="0" class="calendar">
						<colgroup>
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="14%" />
							<col width="*" />
						</colgroup>
						<tr>
							<th><img src="../images/day01.gif" alt="S" /></th>
							<th><img src="../images/day02.gif" alt="M" /></th>
							<th><img src="../images/day03.gif" alt="T" /></th>
							<th><img src="../images/day04.gif" alt="W" /></th>
							<th><img src="../images/day05.gif" alt="T" /></th>
							<th><img src="../images/day06.gif" alt="F" /></th>
							<th><img src="../images/day07.gif" alt="S" /></th>
						</tr>
						<tr>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">1</a></td>
							<td><a href="">2</a></td>
							<td><a href="">3</a></td>
						</tr>
						<tr>
							<td><a href="">4</a></td>
							<td><a href="">5</a></td>
							<td><a href="">6</a></td>
							<td><a href="">7</a></td>
							<td><a href="">8</a></td>
							<td><a href="">9</a></td>
							<td><a href="">10</a></td>
						</tr>
						<tr>
							<td><a href="">11</a></td>
							<td><a href="">12</a></td>
							<td><a href="">13</a></td>
							<td><a href="">14</a></td>
							<td><a href="">15</a></td>
							<td><a href="">16</a></td>
							<td><a href="">17</a></td>
						</tr>
						<tr>
							<td><a href="">18</a></td>
							<td><a href="">19</a></td>
							<td><a href="">20</a></td>
							<td><a href="">21</a></td>
							<td><a href="">22</a></td>
							<td><a href="">23</a></td>
							<td><a href="">24</a></td>
						</tr>
						<tr>
							<td><a href="">25</a></td>
							<td><a href="">26</a></td>
							<td><a href="">27</a></td>
							<td><a href="">28</a></td>
							<td><a href="">29</a></td>
							<td><a href="">30</a></td>
							<td><a href="">31</a></td>
						</tr>
						<tr>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
							<td><a href="">&nbsp;</a></td>
						</tr>
					</table> --%>
				</div>
			</div>
			
			<div class="main_con_right">
				<p class="main_title"><img src="../images/main_title06.gif" alt="사진게시판 PHOTO BOARD" /><a href="../space/board_list.jsp?bname=photoboard"><img src="../images/more.gif" alt="more" class="more_btn" /></a></p>
				<ul class="main_photo_list">
				<c:choose>
					<c:when test="${empty lists_photo}">
						<center>
							<p>등록된 게시물이 없습니다.</p>
						</center>
					</c:when>
					<c:otherwise>
						
						<c:forEach items="${lists_photo}" var="photo_row" varStatus="loop">
							<c:set var="path" value="../Upload/${photo_row.ofile }"/>
								<li>
					                <dl>
					                    <dt>
											<a href="../space/board_view.jsp?num=${photo_row.num}">
										        <div class="grid_4"  style="padding: 2%;">
										            <div class="img" >
										            	<div class="lazy-img">
										            		<img src="${path}" width="80px;" height="60px;">
										            	</div>
										            </div>
										        </div>
										    </a>
									    </dt>
				                    	<dd style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap; width: 100px; display: inline-block;">${photo_row.title }</dd>
				                	</dl>
				           		</li>
							<%-- 
							<p>
								<a style="overflow:hidden; text-overflow: ellipsis; white-space: nowrap; width: 200px; display: inline-block;"
									href="../space/board_view.jsp?bname=photoboard&num=${photo_row.num}">
										<img src="${path}+${photo_row.ofile}" width="30px" height="30px" >
								</a>
								<span style="overflow:hidden; text-overflow: ellipsis; white-space: nowrap;">
									${photo_row.postDate}
								</span>
							</p>
									 --%>
						</c:forEach>
					</c:otherwise>
				</c:choose>
				</ul>
			</div>
			
		</div>
		<%@ include file="../include/quick.jsp"%>
	</div>

	<%@ include file="../include/footer.jsp"%>
	
</center>
</body>
</html>