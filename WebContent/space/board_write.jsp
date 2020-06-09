<%@page import="util.JavascriptUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%@include file="../validation/isLogin.jsp" %>
<%@include file="../validation/isFlag.jsp" %>

<link rel="stylesheet" href="../common/bootstrap4.4.1/css/bootstrap.css" />
<script src="../common/jquery/jquery-3.5.1.js"></script> 

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
					<img src="../images/space/<%=boardName %>" alt="게시판" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;열린공간&nbsp;>&nbsp;<%=boardTitle %><p>
				</div>
				
				<%if(bname.equals("freeboard")){ %>
				<form name="writefrm" method="post" action="writeProc.jsp?bname=<%=bname %>" onsubmit="return checkValidate(this);" >
					<div class="right_contents">
						<table class="table table-bordered table-striped">
							<colgroup>
								<col width="20%"/>
								<col width="*"/>
							</colgroup>
							<tbody>
							
								<tr>
									<th class="text-center"
										style="vertical-align:middle;">제목</th>
									<td>
										<input type="text" class="form-control" name="title" />
									</td>
								</tr>
								
								<tr>
									<th class="text-center"
										style="vertical-align:middle;">내용</th>
									<td>
										<textarea rows="10" class="form-control" name="content" ></textarea>
									</td>
								</tr>
								<!-- 
								<tr>
									<th class="text-center"
										style="vertical-align:middle;">첨부파일</th>
									<td>
										<input type="file" class="form-control" name="insert_file" />
									</td>
								</tr>
								 -->
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
				
				<form name="writefrm" method="post" action="writeProc.jsp?bname=<%=bname %>" onsubmit="return checkValidate(this);" 
					enctype="multipart/form-data">
					<div class="right_contents">
						<table class="table table-bordered table-striped">
							<colgroup>
								<col width="20%"/>
								<col width="*"/>
							</colgroup>
							<tbody>
							
								<tr>
									<th class="text-center"
										style="vertical-align:middle;">제목</th>
									<td>
										<input type="text" class="form-control" name="title" />
									</td>
								</tr>
								
								<tr>
									<th class="text-center"
										style="vertical-align:middle;">내용</th>
									<td>
										<textarea rows="10" class="form-control" name="content" ></textarea>
									</td>
								</tr>
								
								
								<tr>
									<th class="text-center"
										style="vertical-align:middle;">첨부파일</th>
									<td>
										<input type="file" class="form-control" name="insert_file" />
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
				%>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>