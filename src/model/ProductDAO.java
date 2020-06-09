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

public class ProductDAO {
	
	
	//멤버변수 (클래스 전체 멤버메소드에서 접근가능)
	Connection con;
	PreparedStatement psmt;
	ResultSet rs;
	
	public ProductDAO() {
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
	public ProductDAO(String driver, String url) {
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
	public ProductDAO(ServletContext ctx) {
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
	
		
	//장바구니 넣기
	public int insert_basket(int num, String id, int count, int total_price) {
		
		//실제 입력된 행의 갯수를 저장하기 위한 변수
		int affected = 0;
		try {
			String query = "INSERT INTO shop_basket ( "
					+ "	p_num, u_id, p_cnt, p_total_price) "
					+ "	VALUES ( ?, ?, ?, ?)";
		   
			psmt = con.prepareStatement(query);
			psmt.setInt(1, num);
			psmt.setString(2, id);
			psmt.setInt(3, count);
			psmt.setInt(4, total_price);
			
			affected = psmt.executeUpdate();
			System.out.println(query);
		} 
		catch (Exception e) {
			System.out.println("insert_basket중 예외발생");
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
		String query = "SELECT COUNT(*) FROM shop_products"
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
			
			System.out.println("totalCount : " + totalCount);
		}catch (Exception e) {
			System.out.println("getTotalRecordCount 예외발생");
			e.printStackTrace();
		}
		return totalCount;
	}
	
	
	//게시판 리스트 페이지 처리
	public List<ProductDTO> selectListPage(Map<String, Object> map) {
		
		List<ProductDTO> Product = new Vector<ProductDTO>();
		
		String query = "	"
				+ " SELECT * FROM shop_products "
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
				ProductDTO dto = new ProductDTO();
				
				//setter()메소드를 사용하여 컬럼에 데이터 저장
				dto.setNum(rs.getString("num"));
				dto.setP_name(rs.getString("p_name"));
				dto.setP_price(rs.getString("p_price"));
				dto.setP_acc(rs.getInt("p_acc"));
				dto.setP_ofile(rs.getString("p_ofile"));
				dto.setP_sfile(rs.getString("p_sfile"));
				dto.setP_introduce(rs.getString("p_introduce"));
				dto.setBname(rs.getString("bname"));
				
				//저장된 DTO객체를 List컬렉션에 추가
				Product.add(dto);
			}
		} catch (Exception e) {
			System.out.println("selectListPage 예외발생");
			e.printStackTrace();
		}
		return Product;
	}
	
	//모든게시물 가져오기
	public ProductDTO selectView(String num) {
		ProductDTO dto = new ProductDTO();
	
		String query = "SELECT * FROM shop_products " + 
						"	WHERE num = ?";
		
		System.out.println("query : " + query);
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, num);
			rs = psmt.executeQuery();
			while(rs.next()) {
				dto.setNum(rs.getString("num"));
				dto.setP_name(rs.getString("p_name"));
				dto.setP_price(rs.getString("p_price"));
				dto.setP_acc(rs.getInt("p_acc"));
				dto.setP_ofile(rs.getString("p_ofile"));
				dto.setP_sfile(rs.getString("p_sfile"));
				dto.setP_introduce(rs.getString("p_introduce"));
				dto.setBname(rs.getString("bname"));
			}
		} 
		catch (Exception e) {
			System.out.println("selectView 예외발생");
			e.printStackTrace();
		}
		return dto;
	}
	
	//장바구니 개수 카운트
	public int getTotalBasketCount(String id) {
		//게시물의 수는 0으로 초기화
		int totalCount = 0;
		
		//기본쿼리문(전체레코드를 대상으로 함)
		String query = "SELECT COUNT(*) FROM shop_basket"
				+ "	WHERE u_id LIKE ?";
		
		System.out.println("query = " + query);
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, id);
			rs = psmt.executeQuery();
			rs.next();
			//반환한 결과값(레코드 수)을 저장
			totalCount = rs.getInt(1);
			
			System.out.println("getTotalBasketCount : " + totalCount);
		}catch (Exception e) {
			System.out.println("getTotalBasketCount 예외발생");
			e.printStackTrace();
		}
		return totalCount;
	}
	
	//모든장바구니 가져오기
	public List<ProductDTO> selectBasket(String id) {
		List<ProductDTO> bbs = new Vector<ProductDTO>();
		
		
		String query = "SELECT B.*, P.* "+ 
				"	FROM shop_products P, shop_basket B" + 
				"	WHERE P.num = B.p_num AND B.u_id LIKE ? ";
		
		System.out.println("query : " + query);
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, id);
			rs = psmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setNum(rs.getString("p_num"));
				dto.setU_id(rs.getString("u_id"));
				dto.setP_cnt(rs.getInt("p_cnt"));
				dto.setP_total_price(rs.getInt("p_total_price"));
				dto.setP_ofile(rs.getString("p_ofile"));
				dto.setP_name(rs.getString("p_name"));
				dto.setP_price(rs.getString("p_price"));
				dto.setP_acc(rs.getInt("p_acc"));
				dto.setP_cnt(rs.getInt("p_cnt"));
				
				bbs.add(dto);
			}
		} 
		catch (Exception e) {
			System.out.println("selectBasket 예외발생");
			e.printStackTrace();
		}
		return bbs;
	}
		
	//게시물 수정하기
	public int update_basket(int num, int count, int total_price) {
		int affected = 0;
		try {
			String query = "UPDATE shop_basket SET "
					+ " p_cnt = ?, p_total_price = ? "
					+ " WHERE p_num = ? ";
			psmt = con.prepareStatement(query);
			psmt.setInt(1, count);
			psmt.setInt(2, total_price);
			psmt.setInt(3, num);
			
			affected = psmt.executeUpdate();
			
		} 
		catch (Exception e) {
			System.out.println("update_basket중 예외 발생");
			e.printStackTrace();
		}
		return affected;
	}
	
	//장바구니 삭제 처리
	public int basket_delete(String id) {
		int affected = 0;
		try {
			String query = "DELETE FROM shop_basket WHERE u_id LIKE ?";
			
			psmt = con.prepareStatement(query);
			psmt.setString(1, id);
			
			affected = psmt.executeUpdate();
		}
		catch (Exception e) {
			System.out.println("basket_delete중 예외 발생");
			e.printStackTrace();
		}
		return affected;
	}
	
	public int order_insert(Map<String, String> param){
   		
   		int affected = 0;
   		String query = "INSERT INTO shop_ordering "
   				+ "(order_record, name1, addr1, phone1, email1, name2, addr2, phone2, email2, msg, pay_kind) "
   				+ " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
   		
   		try {
   			psmt = con.prepareStatement(query);
   			psmt.setString(1, param.get("order_record").toString());
   			psmt.setString(2, param.get("name1").toString());
   			psmt.setString(3, param.get("addr1").toString());
   			psmt.setString(4, param.get("phone1").toString());
   			psmt.setString(5, param.get("email1").toString());
   			psmt.setString(6, param.get("name2").toString());
   			psmt.setString(7, param.get("addr2").toString());
   			psmt.setString(8, param.get("phone2").toString());
   			psmt.setString(9, param.get("email2").toString());
   			psmt.setString(10, param.get("msg").toString());
   			psmt.setString(11, param.get("pay_kind").toString());
   			
   			affected = psmt.executeUpdate();
   			System.out.println(query);
   		}
   		catch (Exception e) {
   			System.out.println("order_insert오류");
   			e.printStackTrace();
   		}
   		return affected;
   	}
	
}
















