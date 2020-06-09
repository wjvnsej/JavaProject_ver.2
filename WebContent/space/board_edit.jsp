<%@page import="model.BbsDTO"%>
<%@page import="model.BbsDAO"%>
<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%@include file="../validation/isLogin.jsp" %>
<%@include file="../validation/isFlag.jsp" %>

<link rel="stylesheet" href="../common/bootstrap4.4.1/css/bootstrap.css" />
<script src="../common/jquery/jquery-3.5.1.js"></script> 

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">


<%
//폼값받기  - 파라미터로 전달된 게시물의 일련번호
String num = request.getParameter("num");
BbsDAO dao = new BbsDAO(application);

//게시물을 가져와서 DTO객체로 변환
BbsDTO dto = dao.selectView(num);

%>

<script>
    function checkValidate(obj) {
      	if(obj.title.value==""){
        	alert("제목을 입력해주세요!");
        	obj.title.focus();
        	return false;
      	}
      	else if(obj.content.value==""){
        	alert("내용을 입력해주세요!");
        	obj.content.focus();
       		return false;
      	}
      
<%
	if(bname.equals("photoboard")) {
%>
		else if(!obj.insert_file.value){
 			alert("해당게시판은 파일을 첨부가 필수입니다.");
			return false;
		}
<%
	}
%>
      
   }

	function deleteFile() {
	<%
		int result = dao.deleteFile(num);
		
		if(result == 1){
			System.out.println("정상적으로 파일이 삭제되었습니다.");
		}
		else {
			System.out.println("파일 삭제 오류");
		}
		
		dao.close();
	%>
	window.location.reload();
	}

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
					<img src="../images/space/<%=boardName %>" alt="자유게시판" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;<%=boardTitle %><p>
				</div>
				
				<%if(bname.equals("freeboard")) { %>
					<form name="writefrm" method="post" action="editProc.jsp?bname=<%=bname %>" onsubmit="return checkValidate(this);" >
						<div class="right_contents">
							<table class="table table-bordered table-striped">
							
								<input type="hidden" name="num" value="<%=dto.getNum() %>" />
								<input type="hidden" name="bname" value="<%=bname %>" />
								<colgroup>
									<col width="20%"/>
									<col width="*"/>
								</colgroup>
								<tbody>
								
									<tr>
										<th class="text-center"
											style="vertical-align:middle;">제목</th>
										<td>
											<input type="text" class="form-control" name="title"
												 value="<%=dto.getTitle() %>"/>
										</td>
									</tr>
									
									<tr>
										<th class="text-center"
											style="vertical-align:middle;">내용</th>
										<td>
											<textarea rows="10" class="form-control" 
												name="content"><%=dto.getContent() %></textarea>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="row mb-3">
							<div class="col text-right">
								<button type="submit" class="btn btn-danger">전송하기</button>
								<button type="reset" class="btn btn-dark">Reset</button>
								<button type="button" class="btn btn-warning" onclick="location.href='board_list.jsp?bname=<%=bname %>';">리스트보기</button>
							</div>
						</div>
					</form>
				
				<%
				}
				else {
				%>
					<form name="writefrm" method="post" action="editProc.jsp?bname=<%=bname %>"  onsubmit="return checkValidate(this);" 
						enctype="multipart/form-data">
						<div class="right_contents">
							<table class="table table-bordered table-striped">
							
								<input type="hidden" name="num" value="<%=dto.getNum() %>" />
								<input type="hidden" name="bname" value="<%=bname %>" />
								<colgroup>
									<col width="20%"/>
									<col width="*"/>
								</colgroup>
								<tbody>
								
									<tr>
										<th class="text-center"
											style="vertical-align:middle;">제목</th>
										<td>
											<input type="text" class="form-control" name="title"
												 value="<%=dto.getTitle() %>"/>
										</td>
									</tr>
									
									<tr>
										<th class="text-center"
											style="vertical-align:middle;">내용</th>
										<td>
											<textarea rows="10" class="form-control" 
												name="content"><%=dto.getContent() %></textarea>
										</td>
									</tr>
									<% if((!bname.equals("freeboard"))) { %>
										<tr>
											<th class="text-center"
												style="vertical-align:middle;">첨부파일</th>
											<td>
											
										<% 
											if(dto.getOfile() != null) { 
										%>
												업로드 된 파일 : 
												<a href="Download.jsp?fileName=<%=dto.getOfile() %>">
													<%=dto.getOfile() %>
												</a> &nbsp;
												<button type="button" style="border: 0px; color: red;" onclick="deleteFile();">
													파일삭제하기 <i class="fa fa-close"></i>
												</button>
										<%
											}
											else {
										%>	
												업로드된 파일 없음
										<%
										}
										%>
												<input type="file" class="form-control" name="insert_file" />
											</td>
										</tr>
									<%} %>
								</tbody>
							</table>
						</div>
						<div class="row mb-3">
							<div class="col text-right">
								<button type="submit" class="btn btn-danger">전송하기</button>
								<button type="reset" class="btn btn-dark">Reset</button>
								<button type="button" class="btn btn-warning" onclick="location.href='board_list.jsp?bname=<%=bname %>';">리스트보기</button>
							</div>
						</div>
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