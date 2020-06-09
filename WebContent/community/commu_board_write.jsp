<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../validation/isFlag.jsp" %>
<%@ include file="../validation/isLogin.jsp" %>

<link rel="stylesheet" href="../common/bootstrap4.4.1/css/bootstrap.css" />
<script src='https://kit.fontawesome.com/a076d05399.js'></script>

<script>
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
				
				
									
				<div class="row mt-3 mr-1">
				<table class="table table-bordered table-striped">

				<form name="writeFrm" method="post" 
					action="../community/commu_board_write" 
					enctype="multipart/form-data"
					onsubmit="return checkValidate(this);">
					
					<input type="hidden" name="bname" value="${param.bname }" />
					<input type="hidden" name="id" value="${ sessionScope.id }" />
					
					<colgroup>
						<col width="20%"/>
						<col width="*"/>
					</colgroup>
					<tbody>
						<tr>
							<th class="text-center align-middle">작성자</th>
							<td><input type="text"class="form-control" 
								 name="name" value="${ sessionScope.name }" readonly />
							</td>
						</tr>
						<tr>
							<th class="text-center"
								style="vertical-align:middle;">제목</th>
							<td>
								<input type="text" class="form-control" 
									name="title" />
							</td>
						</tr>
						
						<tr>
							<th class="text-center"
								style="vertical-align:middle;">내용</th>
							<td>
								<textarea rows="10" 
									class="form-control" name="content"></textarea>
							</td>
						</tr>
						<tr>
							<th class="text-center"
								style="vertical-align:middle;">첨부파일</th>
							<td>
								<input type="file" class="form-control"
									name="ofile"/>
							</td>
						</tr>
					</tbody>
					</table>
				</div>
				<div class="row mb-3">
					<div class="col text-right">
						<button type="submit" class="btn btn-danger">전송하기</button>
						<button type="reset" class="btn btn-dark">Reset</button>
						<button type="button" class="btn btn-warning" 
							onclick="location.href='../community/commu_board_list?bname=${param.bname}&nowPage=${param.nowPage }&searchColumn=${param.searchColumn }&searchWord=${param.searchWord }';">리스트보기</button>
					</div>
				</form>
				</div>
				
				
				
				
				
				
				
				
				
				
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
