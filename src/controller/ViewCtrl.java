package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.BbsDAO;
import model.BbsDTO;

public class ViewCtrl extends HttpServlet {
	
	/*
	서블릿이 요청을 받을 때  doGet(), doPost()로 받아서 처리하지만
	service()메소드는 위 두가지 방식의 요청을 동시에 받을 수 있다.
	*/
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp) 
			throws ServletException, IOException {
		
		//게시물의 일련번호를 파라미터로 받아온다.
		String num = req.getParameter("num");
		
		BbsDAO dao = new BbsDAO();
		//일련번호를 통해 게시물을 가져오고, 조회수를 증가시킨다.
		BbsDTO dto = dao.selectView(num);
		dao.updateVisitCount(num);
		
		//게시물의 줄바꿈 처리를 위해 replaceAll()메소드를 사용한다.
		dto.setContent(dto.getContent().replaceAll("\r\n", "<br>"));
		dao.close();
		
		//request영역에 DTO객체 저장
		req.setAttribute("dto", dto);
		
		req.getRequestDispatcher("/community/commu_board_view.jsp")
			.forward(req, resp);
	}
	
}
