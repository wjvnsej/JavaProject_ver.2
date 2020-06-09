<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../validation/isFlag.jsp" %>
<%@ include file="../validation/isLogin.jsp" %>

<link rel="stylesheet" href="../common/bootstrap4.4.1/css/bootstrap.css" />
<script src='https://kit.fontawesome.com/a076d05399.js'></script>

<script>
	//유기명함수
	function checkValidate(frm) {
		
		if(frm.name.value == "") {
	              alert("이름을 입력해주세요");
	              frm.name.focus();
	              return false;
	          }
		if(frm.pass.value == "") {
	              alert("비밀번호을 입력해주세요");
	              frm.pass.focus();
	              return false;
	          }
		if(frm.title.value == "") {
	              alert("제목을 입력해주세요");
	              frm.title.focus();
	              return false;
	          }
	          if(frm.content.value == "") {
	              alert("내용을 입력해주세요");
	              frm.content.focus();
	              return false;
	          }
	}
	
</script>

 <body>
	<center>
	<div id="wrap">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/community/sub_image.jpg" id="main_visual" />

		<div class="contents_box">
			<div class="left_contents">
				
				<%@ include file = "../include/community_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="../images/community/<%=boardName %>" alt="직원자료실" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;커뮤니티&nbsp;>&nbsp;<%=boardTitle %><p>
				</div>
				
			
				<form name="writeFrm" method="post" 
				action="../community/commu_board_edit" 
				enctype="multipart/form-data"
				onsubmit="return checkValidate(this);">
				
				<div class="row mt-3 mr-1">
				
				<input type="hidden" name="num" value="${dto.num }" />
				<input type="hidden" name="bname" value="${dto.bname }" />
				<input type="hidden" name="nowPage" value="${param.nowPage }" />
				
				
				<!-- 
					기존에 등록한 파일이 있는 경우 수정시 파일을 첨부하지 않으면 기존파일을
					유지해야 하므로 별도의 hidden폼이 필요하다.
					즉, 새로운 파일을 등록하면 새로운 값으로 업데이트하고
					파일을 등록하지 않으면 기존파일명으로 데이터를 유지하게된다.
				 -->
				<input type="hidden" name="originalfile" value="${dto.ofile }" />
				
				<table class="table table-bordered table-striped">
					<colgroup>
						<col width="20%"/>
						<col width="*"/>
					</colgroup>
					<tbody>
						<tr>
							<th class="text-center align-middle">작성자</th>
							<td>
								<input type="text" class="form-control"	
									style="width:100px;" name="name"
									value="${dto.name }"/>
							</td>
						</tr>
						<tr>
							<th class="text-center"
								style="vertical-align:middle;">제목</th>
							<td>
								<input type="text" class="form-control" 
									name="title" value="${dto.title }" />
							</td>
						</tr>
						<tr>
							<th class="text-center"
								style="vertical-align:middle;">내용</th>
							<td>
								<textarea rows="10" class="form-control" 
								name="content">${dto.content }
								</textarea>
							</td>
						</tr>
						<tr>
							<th class="text-center"
								style="vertical-align:middle;">첨부파일</th>
							<td>
								파일명 : ${dto.ofile }
								<input type="file" class="form-control"
									name="newfile"/>
							</td>
						</tr>
					</tbody>
					</table>
				</div>
				<div class="row mb-3">
					<div class="col text-right">
						<button type="submit" class="btn btn-danger">작성완료</button>
						<button type="reset" class="btn btn-dark">Reset</button>
						<button type="button" class="btn btn-warning" 
							onclick="location.href='../community/commu_board_list?nowPage=${param.nowPage }';">리스트보기</button>
					</div>
				</div>
				</form>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
