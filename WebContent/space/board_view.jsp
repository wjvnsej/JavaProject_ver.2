<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.File"%>
<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%@include file="../validation/isFlag.jsp" %>

<link rel="stylesheet" href="../common/bootstrap4.4.1/css/bootstrap.css" />
<script src="../common/jquery/jquery-3.5.1.js"></script> 

<%
//폼값 받기 - 파라미터로 전달된 게시물의 일련번호
String num = request.getParameter("num");
String year = request.getParameter("year");
String month = request.getParameter("month");
BbsDAO dao = new BbsDAO(application);

/*
검색 후 파라미터 처리를 위한 추가부분
	: 리스트에서 검색 후 상세보기, 그리고 다시 리스트 보기를
	눌렀을 때 검색이 유지되도록 처리하기 위한 코드 삽입.
*/
String queryStr = "bname=" + bname + "&year=" + year + "&month" + month + "&" ;

if(bname.equals("freeboard")) {
	String searchColumn = request.getParameter("searchColumn");
	String searchWord = request.getParameter("searchWord");
	if(searchWord != null) {
		queryStr += "searchColumn=" + searchColumn 
						+ "&searchWord=" + searchWord + "&";
	}
	//3페이지에서 상세보기 했다면 리스트로 돌아갈때도 3페이지로 가야한다.
	String nowPage = request.getParameter("nowPage");
	if(nowPage == null || nowPage.equals("")) {
		nowPage = "1";
	}
	queryStr += "&nowPage=" + nowPage;

	//게시물을 가져와서 DTO객체로 반환
}
BbsDTO dto = dao.selectView(num);
//게시물의 조회수 +1증가
dao.updateVisitCount(num);


dao.close();

%>

<script>
	function isDelete() {
		var c = confirm("삭제할까요?");
		if(c) {
			var f = document.deleteFrm;
			f.method = "post";
			f.action = "deleteProc.jsp";
			f.submit();
		}
	}
	
	function noEvent(){
		if(event.keyCode==116 || event.keyCode==9){
	    	return false;
	   }
	   else if(event.ctrlKey && (event.keyCode =78 || event.keyCode == 82)){
		   return false;
	   }
	}
	document.onkeydown = noEvent;
	
</script>

<body>
	<center>
		<div id="wrap">
			<%@ include file="../include/top.jsp" %>
	
			<img src="../images/space/sub_image.jpg" id="main_visual" />
	
			<div class="contents_box">
				<div class="left_contents">
					<%@ include file = "../include/space_leftmenu.jsp" %>
				</div>
				<div class="right_contents">
					<div class="top_title">
						<img src="../images/space/<%=boardName %>" alt="공지사항" class="con_title" />
						<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;<%=boardTitle %><p>
					</div>
	
					<table class="table table-bordered" style="word-break:break-all;">
						<colgroup>
							<col width="20%"/>
							<col width="30%"/>
							<col width="20%"/>
							<col width="*"/>
						</colgroup>
						<tbody>
							<tr>
								<th class="text-center table-active align-middle">아이디</th>
								<td><%=dto.getId() %></td>
								<th class="text-center table-active align-middle">작성일</th>
								<td><%=dto.getPostDate() %></td>
							</tr>
							<tr>
								<th class="text-center table-active align-middle">이름</th>
								<td><%=dto.getName() %></td>
								<th class="text-center table-active align-middle">조회수</th>
								<td><%=dto.getVisitcount() %></td>
							</tr>
							<tr>
								<th class="text-center table-active align-middle">제목</th>
								<td colspan="3">
									<%=dto.getTitle() %>
								</td>
							</tr>
							<tr>
								<th class="text-center table-active align-middle">내용</th>
								<td colspan="3" class="align-middle" style="height:200px;">
									<%--
									textarea에서 엔터키로 줄바꿈을 한 후 DB에 저장하면 \r\n으로
									저장되므로, HTML 페이지에서 출력할 때는 <br>태그로 문자열을
									변경해야 한다.
									--%>
									<%=dto.getContent() %>
								</td>
							</tr>
							<% 
							if(!(bname.equals("freeboard")) && !(bname.equals("calenboard"))) {
							%>
								<tr>
									<th class="text-center table-active align-middle">첨부파일</th>
									<td colspan="3">
									<%
									if(dto.getOfile() != null){
										if(bname.equals("photoboard")) {
									%>
										<a href="Download.jsp?fileName=<%=dto.getOfile() %>">
											<%=dto.getOfile() %> [다운로드]</a>
										<br /><br />
										<img src="../Upload/<%=dto.getOfile() %>"/>
									<%
										}
										else {
									%>
										<a href="Download.jsp?fileName=<%=dto.getOfile() %>">
											<%=dto.getOfile() %> [다운로드]</a>
									<%
										}
									%>
									<%
									}else{
									%>
										첨부파일 없음
									<%
									}
									%>
									</td>
								</tr>
							<%
							}
							%>
						</tbody>
					</table>
	
					<div class="row mb-3">
					<%
					if(!(bname.equals("calenboard")) && !(bname.equals("notice")) ) {
					%>
						<div class="col-6"> 
							<%
								/* 
								로그인이 완료된 상태이면서, 동시에 해당 게시물의 작성자라면
								수정, 삭제 버튼을 보이게 처리한다.
								*/
								if(session.getAttribute("id") != null && 
									session.getAttribute("id").toString().equals(dto.getId())) {
							%>
									<!-- 수정, 삭제의 경우 특정게시물에 대해 수행하는 작업이므로 반드시
									게시물의 일련번호(PK)가 파라미터로 전달되어야 한다. -->
									<button type="button" class="btn btn-secondary"
										onclick="location.href='board_edit.jsp?num=<%=dto.getNum()%>&bname=<%=bname %>';">
										수정하기</button>
									<!-- 회원제게시판에서 삭제처리는 별도의 폼이 필요없이, 사용자에 대한
									인증처리만 되면 즉시 삭제처리한다. -->
									<button type="button" class="btn btn-success" onclick="isDelete();">삭제하기</button>
							<%
								}
							%>
						</div>
					<%
					}
					%>
					<%
					if(bname.equals("notice") || bname.equals("calenboard")) {
					%>
						<div class="col-12 " align="right">
					<%
					}
					else {
					%>
						<div class="col-6" align="right">
					<%
					}
					%>
							<button type="button" class="btn btn-warning" 
								onclick="location.href='board_list.jsp?<%=queryStr %>';">리스트보기</button>
						</div>
					</div>
					
					<form name="deleteFrm">
						<input type="hidden" name="num" value="<%=dto.getNum() %>" />
						<input type="hidden" name="bname" value="<%=bname %>" />
					</form>
				</div>
			</div>
			<%@ include file="../include/quick.jsp" %>
		</div>
		<%@ include file="../include/footer.jsp" %>
	</center>
</body>
</html>