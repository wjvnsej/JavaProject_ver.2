package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.BbsDAO;
import model.BbsDTO;
import util.PagingUtil;

public class MainCtrl extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
			throws ServletException, IOException {
		
		//DAO객체 생성 및 커넥션 풀을 통한 DB연결
		ServletContext app = this.getServletContext();
		BbsDAO dao = new BbsDAO(app);
		
		List<BbsDTO> lists_notice = dao.selectListMain("notice", 0, 4);
		List<BbsDTO> lists_free = dao.selectListMain("freeboard", 0, 4);
		List<BbsDTO> lists_photo = dao.selectListMain("photoboard", 0, 6);
		
		//커넥션풀에 커넥션 객체 반납.
		dao.close();
		
		//컬렉션에 저장된 데이터를 View로 전달하기 위해 Request영역에 속성저장
		req.setAttribute("lists_notice", lists_notice);
		req.setAttribute("lists_free", lists_free);
		req.setAttribute("lists_photo", lists_photo);
		req.getRequestDispatcher("/main/main.jsp")
			.forward(req, resp);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
			throws ServletException, IOException {
		
		/*
		만약 게시판 리스트쪽에서 POST방식으로 요청이 등어오더라도
		처리는 doGet()메소드에서 처리할 수 있도록 모든 요청을 토스한다.
		*/
		doGet(req, resp);
	}
	
}
