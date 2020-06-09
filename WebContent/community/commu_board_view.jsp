<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../validation/isFlag.jsp" %>
<%@ include file="../validation/isLogin.jsp" %>

<link rel="stylesheet" href="../common/bootstrap4.4.1/css/bootstrap.css" />
<script src='https://kit.fontawesome.com/a076d05399.js'></script>

<script>

	function isDelete() {
		
		var result = confirm("정말 삭제하시겠습니까?");
		if(result){
			location.href='./commu_board_delete?bname=${dto.bname}&num=${param.num}&nowPage=${param.nowPage }&searchColumn=${param.searchColumn }&searchWord=${param.searchWord }';
		}else{
		    alert("삭제 취소되었습니다.");
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
			
			
				<table class="table table-bordered">
				<colgroup>
					<col width="20%"/>
					<col width="30%"/>
					<col width="20%"/>
					<col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<th class="text-center table-active align-middle">
							아이디
						</th>
						<td>${dto.id }</td>
						<th class="text-center table-active align-middle">
							작성일
						</th>
						<td>${dto.postDate }</td>
					</tr>
					<tr>
						<th class="text-center table-active align-middle">
							이름
						</th>
						<td>${dto.name }</td>
						<th class="text-center table-active align-middle">
							조회수
						</th>
						<td>${dto.visitcount }</td>
					</tr>
					<tr>
						<th class="text-center table-active align-middle">
							제목
						</th>
						<td colspan="3">
							${dto.title }
						</td>
					</tr>
					<tr>
						<th class="text-center table-active align-middle">
							내용
						</th>
						<td colspan="3" class="align-middle" 
							style="height:200px;">
							${dto.content }							
						</td>
					</tr>
					<tr>
						<th class="text-center table-active align-middle">
							첨부파일
						</th>
						<td colspan="3">
							<!-- 첨부파일이 있는 경우에만 디스플레이 함 -->
							<c:if test="${not empty dto.ofile }">
								${dto.ofile }
								<a href="./commu_board_download?filename=${dto.ofile }&num=${dto.num}">
									[다운로드]
								</a>
							</c:if>
						</td>
					</tr>
				</tbody>
				</table>
				<div class="row mb-3">
				
					<div class="col-6">
						<c:set var="id" value="${ sessionScope.id }"/>
						<c:if test="${ id eq dto.id }">
							<button type="button" class="btn btn-secondary"
								onclick="location.href='./commu_board_edit?bname=${dto.bname}&num=${param.num}&nowPage=${param.nowPage }&searchColumn=${param.searchColumn }&searchWord=${param.searchWord }';">
								수정하기</button>
							
							<button type="button" class="btn btn-success"
								onclick="isDelete();">
								삭제하기</button>
						</c:if>
						
					</div>
					
					<div class="col-6" align="right">
						<button type="button" class="btn btn-warning" 
						onclick="location.href='../commu_board_list?bname=${dto.bname}&nowPage=${param.nowPage }&searchColumn=${param.searchColumn }&searchWord=${param.searchWord }';">리스트보기</button>
					</div>
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>
 </body>
</html>
