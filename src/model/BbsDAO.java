package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletContext;
import javax.sql.DataSource;

public class BbsDAO {
	
	
	//멤버변수 (클래스 전체 멤버메소드에서 접근가능)
	Connection con;
	PreparedStatement psmt;
	ResultSet rs;
	
	public BbsDAO() {
		try {
			Context initctx = new InitialContext();
			
			/*
			Context ctx = (Context)initctx.lookup("java:comp/env"); 
			DataSource source = (DataSource)ctx.lookup("jdbc/myoracle");
			*/
			//위 2번의 lookup을 아래 1번의 lookup으로 병합할 수 있다.
			DataSource source = 
					(DataSource)initctx.lookup("java:comp/env/jdbc/mymaria");
			
			con = source.getConnection();
		}
		catch (Exception e) {
			System.out.println("DBCP 연결실패");
			e.printStackTrace();
		}
	}
		
	//인자생성자1 : DB연결
	/*
	JSP파일에서 web.xml에 등록된 컨텍스트 초기화 파라미터를 가져와서
	생성자 호출시 파라미터로 전달한다.
	*/
	public BbsDAO(String driver, String url) {
	   try {
		   Class.forName(driver);
		   String id = "wjvnsej";
		   String pw = "ehdrjs13!";
		   con =DriverManager.getConnection(url, id, pw);
		   System.out.println("DB연결성공");
	   }
	   catch (Exception e) {
		e.printStackTrace();
	   }
	}
	public BbsDAO(ServletContext ctx) {
		try {
			Class.forName(ctx.getInitParameter("MariaJDBCDriver"));
			String id = "wjvnsej";
			String pw = "ehdrjs13!";
			con =DriverManager.getConnection(
					ctx.getInitParameter("MaiaConnectURL"), id, pw);
			System.out.println("DB연결성공");
		}
		catch (Exception e) {
			System.out.println("DB연결 실패");
			e.printStackTrace();
		}
	}
	
		
	//글쓰지 처리 메소드
	public int insertWrite(BbsDTO dto) {
		
		   //실제 입력된 행의 갯수를 저장하기 위한 변수
			int affected = 0;
			try {
				String query = "INSERT INTO multi_board ( "
						+ "	id, name, title, content, bname) "
						+ "	VALUES ( "
						+ "	?, ?, ?, ?, ?)";
			   
				psmt = con.prepareStatement(query);
				psmt.setString(1, dto.getId());
				psmt.setString(2, dto.getName());
				psmt.setString(3, dto.getTitle());
				psmt.setString(4, dto.getContent());
				psmt.setString(5, dto.getBname());
				
				affected = psmt.executeUpdate();
				System.out.println(query);
			} 
			catch (Exception e) {
				System.out.println("insertWrite중 예외발생");
				e.printStackTrace();
			}
			return affected;
		}
	
	//DB자원해제
	public void close() {
		try {
			if(rs != null) rs.close();
			if(psmt != null) psmt.close();
			if(con != null) con.close();
		} 
		catch (Exception e) {
			System.out.println("자원반납시 예외발생");
			e.printStackTrace();
		}
	}
	
	
	/*
	게시판 리스트에서 게시물의 갯수를 count()함수를 통해 구해서 반환함.
	가상번호, 페이지번호 처리를 위해 사용됨.
	*/
	public int getTotalRecordCount(Map<String, Object> map) {
		//게시물의 수는 0으로 초기화
		int totalCount = 0;
		
		//기본쿼리문(전체레코드를 대상으로 함)
		String query = "SELECT COUNT(*) FROM multi_board"
				+ "	WHERE bname LIKE '" + map.get("bname") + "' ";
		
		//JSP페이지에서 검색어를 입력한 경우 where절이 동적으로 추가됨.
		if(map.get("Word") != null) {
			query += " AND " + map.get("Column") + " " 
					+ " LIKE '%" + map.get("Word") + "%'";
		}
		System.out.println("query = " + query);
		
		try {
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();
			rs.next();
			//반환한 결과값(레코드 수)을 저장
			totalCount = rs.getInt(1);
		}catch (Exception e) {
			System.out.println("getTotalRecordCount 예외발생");
			e.printStackTrace();
		}
		return totalCount;
	}
	
	/*
	게시판 리스트에서 조건에 맞는 레코드를 select하여 ResultSet(결과셋)을
	List컬렉션에 저장 후 반환하는 메소드
	*/
	public List<BbsDTO> selectList(Map<String, Object> map) {
		
		List<BbsDTO> bbs = new Vector<BbsDTO>();
		//기본쿼리문
		String query = "SELECT * FROM multi_board "
				+ "	WHERE bname LIKE '" + map.get("bname") + "' ";
		
		//검색어가 있는 경우 조건절 동적 추가
		if(map.get("Word") != null) {
			query += " AND " + map.get("Column") + " " 
					+ " LIKE '%" + map.get("Word") + "%'";
		}
		
		//최근게시물이  항상 위로 노출되야 하므로 작성된 순서의 역순으로 정렬한다.
		query += " ORDER BY num DESC";
		System.out.println("query : " + query);
		
		try {
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();
			//오라클이 반환해준 ResultSet의 갯수만큼 반복한다.
			while(rs.next()) {
				//하나의 레코드를 DTO객체에 저장하기 위해 새로운 객체 생성
				BbsDTO dto = new BbsDTO();
				
				//setter()메소드를 사용하여 컬럼에 데이터 저장
				dto.setNum(rs.getString("num"));
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setOfile(rs.getString("ofile"));
				dto.setSfile(rs.getString("sfile"));
				dto.setPostDate(rs.getDate("postdate"));
				dto.setVisitcount(rs.getString("visitcount"));
				
				//저장된 DTO객체를 List컬렉션에 추가
				bbs.add(dto);
			}
		} catch (Exception e) {
			System.out.println("selectList 예외발생");
			e.printStackTrace();
		}
		return bbs;
	}
	
	//게시판 리스트 페이지 처리
	public List<BbsDTO> selectListPage(Map<String, Object> map) {
		
		List<BbsDTO> bbs = new Vector<BbsDTO>();
		
		String query = "	"
				+ " SELECT * FROM multi_board "
				+ "	WHERE bname LIKE '" + map.get("bname") + "' ";
		
		if(map.get("Word") != null) {
			query += " AND " + map.get("Column") + " "
				+ " LIKE '%" + map.get("Word") + "%' ";
		}
		query += " "
			+ " 		ORDER BY num DESC LIMIT ?, ? ";
		System.out.println("query : " + query);
		
		try {
			psmt = con.prepareStatement(query);
			
			//JSP에서 계산한 페이지 범위값을 이용해 인파라미터를 설정함.
			psmt.setInt(1, Integer.parseInt(map.get("start").toString()));
			psmt.setInt(2, Integer.parseInt(map.get("end").toString()));
			
			rs = psmt.executeQuery();
			
			//오라클이 반환해준 ResultSet의 갯수만큼 반복한다.
			while(rs.next()) {
				//하나의 레코드를 DTO객체에 저장하기 위해 새로운 객체 생성
				BbsDTO dto = new BbsDTO();
				
				//setter()메소드를 사용하여 컬럼에 데이터 저장
				dto.setNum(rs.getString("num"));
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setOfile(rs.getString("ofile"));
				dto.setSfile(rs.getString("sfile"));
				dto.setPostDate(rs.getDate("postdate"));
				dto.setVisitcount(rs.getString("visitcount"));
				dto.setBname(rs.getString("bname"));
				
				//저장된 DTO객체를 List컬렉션에 추가
				bbs.add(dto);
			}
		} catch (Exception e) {
			System.out.println("selectListPage 예외발생");
			e.printStackTrace();
		}
		return bbs;
	}
	
	//일련번호 num에 해당하는 게시물의 조회수 증가
	public void updateVisitCount(String num) {
		String query = "UPDATE multi_board SET "
				+ "	visitcount = visitcount + 1 " 
				+ "	WHERE num = ?";
		System.out.println("조회수 증가 : " + query);
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, num);
			psmt.executeQuery();
		} 
		catch (Exception e) {
			System.out.println("조회수 증가시 예외발생");
			e.printStackTrace();
		}
	}
	
	
	//모든게시물 가져오기
	public BbsDTO selectView(String num) {
		BbsDTO dto = new BbsDTO();
	
		String query = "SELECT * FROM multi_board " + 
						"	WHERE num = ?";
		System.out.println("query : " + query);
		
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, num);
			rs = psmt.executeQuery();
			while(rs.next()) {
				dto.setNum(rs.getString("num"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setOfile(rs.getString("ofile"));
				dto.setSfile(rs.getString("sfile"));
				dto.setPostDate(rs.getDate("postdate"));
				dto.setId(rs.getString("id"));
				dto.setVisitcount(rs.getString("visitcount"));
				dto.setDowncount(rs.getString("downcount"));
				dto.setName(rs.getString("name"));
				dto.setBname(rs.getString("bname"));
			}
		} 
		catch (Exception e) {
			System.out.println("selectView 예외발생");
			e.printStackTrace();
		}
		return dto;
	}
		
	//게시물 수정하기
	public int updateEdit(BbsDTO dto) {
		int affected = 0;
		try {
			String query = "UPDATE multi_board SET "
					+ " title = ?, content = ?, ofile = ?, sfile = ? "
					+ " WHERE num = ? ";
			psmt = con.prepareStatement(query);
			psmt.setString(1, dto.getTitle());
			psmt.setString(2, dto.getContent());
			psmt.setString(3, dto.getOfile());
			psmt.setString(4, dto.getSfile());
			psmt.setString(5, dto.getNum());
			
			affected = psmt.executeUpdate();
			
		} 
		catch (Exception e) {
			System.out.println("UPDATE중 예외 발생");
			e.printStackTrace();
		}
		return affected;
	}
	
	//게시물 삭제 처리
	public int delete(BbsDTO dto) {
		int affected = 0;
		try {
			String query = "DELETE FROM multi_board WHERE num = ?";
			
			psmt = con.prepareStatement(query);
			psmt.setString(1, dto.getNum());
			
			affected = psmt.executeUpdate();
		}
		catch (Exception e) {
			System.out.println("DELETE중 예외 발생");
			e.printStackTrace();
		}
		return affected;
	}
		
		
	public int fileInsert(BbsDTO dto) {
		
		int affected = 0;
		 
		try {
			 String query = " INSERT INTO multi_board ( "
		               + " id, name, title, content, ofile, sfile, bname) "
		               + " VALUES ( "
		               + " ?, ?, ?, ?, ?, ?, ?)";
	         psmt = con.prepareStatement(query);
	         psmt.setString(1, dto.getId());
	         psmt.setString(2, dto.getName());
	         psmt.setString(3, dto.getTitle());
	         psmt.setString(4, dto.getContent());
	         psmt.setString(5, dto.getOfile());
	         psmt.setString(6, dto.getSfile());
	         psmt.setString(7, dto.getBname());
	         
	         affected = psmt.executeUpdate();

			System.out.println("query : " + query);
		} 
		catch (Exception e) {
			System.out.println("fileInsert 중 예외 발생");
			e.printStackTrace();
		}
		return affected;
	}
	
	//첨부파일 삭제
	public int deleteFile(String num) {
		
		int affected = 0;
		try {
			String query = "UPDATE multi_board SET "
					+ " ofile = null, sfile = null "
					+ " WHERE num = ? ";
			psmt = con.prepareStatement(query);
			psmt.setString(1, num);
			
			affected = psmt.executeUpdate();
			
		} 
		catch (Exception e) {
			System.out.println("deleteFile중 예외 발생");
			e.printStackTrace();
		}
		return affected;
		
	}
	
	//파일 다운로드 수 증가
	public void downCountPlus(String num) {
		String sql = "UPDATE multi_board SET "
				+ "	downcount = downcount + 1 "
				+ "	WHERE num = ?";
		try {
			
			psmt = con.prepareStatement(sql);
			psmt.setString(1, num);
			psmt.executeUpdate();
		} 
		catch (Exception e) {}
	}
	
	public List<BbsDTO> selectListMain(String bname, int start, int end) {
		
		List<BbsDTO> bbs = new Vector<BbsDTO>();
		
		String query = "	"
				+ " SELECT * FROM multi_board "
				+ "	WHERE bname = ? "
				+ "	ORDER BY num DESC LIMIT ?, ? ";
		System.out.println("query : " + query);
		
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setString(1, bname);
			psmt.setInt(2, start);
			psmt.setInt(3, end);
			
			rs = psmt.executeQuery();
			
			//오라클이 반환해준 ResultSet의 갯수만큼 반복한다.
			while(rs.next()) {
				//하나의 레코드를 DTO객체에 저장하기 위해 새로운 객체 생성
				BbsDTO dto = new BbsDTO();
				
				//setter()메소드를 사용하여 컬럼에 데이터 저장
				dto.setNum(rs.getString("num"));
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setOfile(rs.getString("ofile"));
				dto.setSfile(rs.getString("sfile"));
				dto.setPostDate(rs.getDate("postdate"));
				dto.setVisitcount(rs.getString("visitcount"));
				dto.setBname(rs.getString("bname"));
				
				//저장된 DTO객체를 List컬렉션에 추가
				bbs.add(dto);
			}
		} catch (Exception e) {
			System.out.println("selectListMain 예외발생");
			e.printStackTrace();
		}
		return bbs;
	}
	
	
}
















