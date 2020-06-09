<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/global_head.jsp" %>

<link rel="stylesheet" href="../common/bootstrap4.4.1/css/bootstrap.css" />
<script src="../common/jquery/jquery-3.5.1.js"></script>

 <body>
	<center>
	<div id="wrap">
		<%@ include file="../include/top.jsp" %>

		<img src="../images/center/sub_image.jpg" id="main_visual" />

		<div class="contents_box">
			<div class="left_contents">
				<img src="../images/center/left_title.gif" alt="센터소개 Center Introduction" class="left_title" />
				<%@ include file="../include/center_leftmenu.jsp" %>
			</div>
			<div class="right_contents">
				<div class="top_title">
					<img src="../images/center/sub07_title.gif" alt="오시는길" class="con_title" />
					<p class="location"><img src="../images/center/house.gif" />&nbsp;&nbsp;센터소개&nbsp;>&nbsp;오시는길<p>
				</div>
				<div class="con_box">
					<p class="con_tit"><img src="../images/center/sub07_tit01.gif" alt="오시는길" /></p>
					
					<!-- 지도 -->
					<div id="map" style="width:713px;height:388px;"></div>
					
					<br /><br />
					
					<p class="con_tit"><img src="../images/center/sub07_tit02.gif" alt="자가용 오시는길" /></p>
					<div class="in_box">
						<p class="dot_tit">서울 ↔ 증평</p>
						<p style="margin-bottom:15px;">중부고속도로 → 증평IC -> 증평군청에서 1분거리</p>
						
						<p class="dot_tit">부산 ↔ 증평</p>
						<p style="margin-bottom:15px;">경부고속도로 → 대전 →중부고속도로 → 증평IC -> 증평군청에서 1분거리</p>
						
						<p class="dot_tit">대전 ↔ 증평</p>
						<p style="margin-bottom:15px;">중부고속도로 → 증평IC -> 증평군청에서 1분거리</p>
						
						<p class="dot_tit">광주 ↔ 증평</p>
						<p style="margin-bottom:15px;">호남고속도로 → 논산 → 호남고속도로 지선 → 대전 →중부고속도로 → 증평IC -> 증평군청에서 1분거리</p>
						
					</div>
					
					<br /><br />
					
					<p class="con_tit"><img src="../images/center/sub07_tit03.gif" alt="대중교통 이용시" /></p>
						<a class="btn btn-outline-secondary" href="https://www.jp.go.kr/kor/prog/pbtrnspInfo/sub05_05_01/TM01/list.do">시내버스 시간표보기</a>
						<a class="btn btn-outline-secondary" href="https://www.jp.go.kr/kor/prog/pbtrnspInfo/sub05_05_02/TM02/list.do">시외버스 시간표보기</a>
						<a class="btn btn-outline-secondary" href="https://www.jp.go.kr/kor/prog/pbtrnspInfo/sub05_05_04/TM04/list.do">증평역 시간표보기</a>
					
					<div class="in_box">
						
						<p class="dot_tit">시내버스</p>
						<p style="margin-bottom:15px;">105번, 105-1번, 111번, 111(단)번, 113번, 118번, 0830번 / 증평우체국 앞 하차 도보 3분</p>
						
						<br />
						
						<p class="dot_tit">시외버스</p>
						<p style="margin-bottom:15px;">동서울종합터미널 → 증평시외버스터미널 -> 증평시외버스터미널에서 도보 3분거리</p>
						
						<br />
						
						<p class="dot_tit">기차</p>
						<p style="margin-bottom:15px;">서울역(경부선) → 조치원(충북선) -> 증평역에서 도보 10분거리</p>
						
					</div>
				</div>
			</div>
		</div>
		<%@ include file="../include/quick.jsp" %>
	</div>
	

	<%@ include file="../include/footer.jsp" %>
	</center>



<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=45fe66a230d5be316aa2ebca7d255c6c"></script>
<script>
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new kakao.maps.LatLng(36.784512, 127.583766), // 지도의 중심좌표
        level: 5 // 지도의 확대 레벨
    };

var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

// 마커가 표시될 위치입니다  
var markerPosition  = new kakao.maps.LatLng(36.784512, 127.583766); 

// 마커를 생성합니다
var marker = new kakao.maps.Marker({
    position: markerPosition
});

// 마커가 지도 위에 표시되도록 설정합니다
marker.setMap(map);

// 아래 코드는 지도 위의 마커를 제거하는 코드입니다
// marker.setMap(null);    
</script>



 </body>
</html>
