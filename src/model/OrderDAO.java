package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletContext;

public class OrderDAO {
	
	//멤버변수 (클래스 전체 멤버메소드에서 접근가능)
	Connection con;
	PreparedStatement psmt;
	ResultSet rs;
	
	//기본생성자
   public OrderDAO() {
	   System.out.println("RequestDAO 생성자 호출");
   }
   
   public OrderDAO(String driver, String url) {
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
 	
 	
	
	//모든게시물 가져오기
	public OrderDTO selectView(String name1) {
		OrderDTO dto = new OrderDTO();
		
		String query = "SELECT * FROM shop_ordering " + 
				"	WHERE name1 = ?";
		System.out.println("query : " + query);
		
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, name1);
			rs = psmt.executeQuery();
			while(rs.next()) {
				dto.setIdx(rs.getString("idx"));
				dto.setOrder_record(rs.getString("order_record"));
				dto.setName1(rs.getString("name1"));
				dto.setAddr1(rs.getString("addr1"));
				dto.setPhone1(rs.getString("phone1"));
				dto.setEmail1(rs.getString("email1"));
				dto.setName2(rs.getString("name2"));
				dto.setAddr2(rs.getString("addr2"));
				dto.setPhone2(rs.getString("phone2"));
				dto.setEmail2(rs.getString("email2"));
				dto.setMsg(rs.getString("msg"));
				dto.setPay_kind(rs.getString("pay_kind"));
			}
		}
		catch (Exception e) {
			System.out.println("selectView 예외발생");
			e.printStackTrace();
		}
		return dto;
	}
	
	
	public int getTotalRecordCount(Map<String, Object> map) {
		//게시물의 수는 0으로 초기화
		int totalCount = 0;
		
		//기본쿼리문(전체레코드를 대상으로 함)
		String query = "SELECT COUNT(*) FROM shop_ordering";
		
		//JSP페이지에서 검색어를 입력한 경우 where절이 동적으로 추가됨.
		if(map.get("Word") != null) {
			query += " WHERE " + map.get("Column") + " " 
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
	public List<OrderDTO> selectList(Map<String, Object> map) {
		
		List<OrderDTO> bbs = new Vector<OrderDTO>();
		//기본쿼리문
		String query = "SELECT * FROM shop_ordering ";
		
		//검색어가 있는 경우 조건절 동적 추가
		if(map.get("Word") != null) {
			query += " WHERE " + map.get("Column") + " " 
					+ " LIKE '%" + map.get("Word") + "%'";
		}
		
		//최근게시물이  항상 위로 노출되야 하므로 작성된 순서의 역순으로 정렬한다.
		query += " ORDER BY idx DESC";
		System.out.println("query : " + query);
		
		try {
			psmt = con.prepareStatement(query);
			rs = psmt.executeQuery();
			//오라클이 반환해준 ResultSet의 갯수만큼 반복한다.
			while(rs.next()) {
				//하나의 레코드를 DTO객체에 저장하기 위해 새로운 객체 생성
				OrderDTO dto = new OrderDTO();
				
				//setter()메소드를 사용하여 컬럼에 데이터 저장
				dto.setIdx(rs.getString("idx"));
				dto.setOrder_record(rs.getString("order_record"));
				dto.setName1(rs.getString("name1"));
				dto.setAddr1(rs.getString("addr1"));
				dto.setPhone1(rs.getString("phone1"));
				dto.setEmail1(rs.getString("email1"));
				dto.setName2(rs.getString("name2"));
				dto.setAddr2(rs.getString("addr2"));
				dto.setPhone2(rs.getString("phone2"));
				dto.setEmail2(rs.getString("email2"));
				dto.setMsg(rs.getString("msg"));
				dto.setPay_kind(rs.getString("pay_kind"));
				
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
	public List<OrderDTO> selectListPage(Map<String, Object> map) {
		
		List<OrderDTO> bbs = new Vector<OrderDTO>();
		
		String query = "	"
				+ " SELECT * FROM shop_ordering ";
		
		if(map.get("Word") != null) {
			query += " WHERE " + map.get("Column") + " "
				+ " LIKE '%" + map.get("Word") + "%' ";
		}
		query += " "
			+ " 		ORDER BY idx DESC LIMIT ?, ? ";
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
				OrderDTO dto = new OrderDTO();
				
				dto.setIdx(rs.getString("idx"));
				dto.setOrder_record(rs.getString("order_record"));
				dto.setName1(rs.getString("name1"));
				dto.setAddr1(rs.getString("addr1"));
				dto.setPhone1(rs.getString("phone1"));
				dto.setEmail1(rs.getString("email1"));
				dto.setName2(rs.getString("name2"));
				dto.setAddr2(rs.getString("addr2"));
				dto.setPhone2(rs.getString("phone2"));
				dto.setEmail2(rs.getString("email2"));
				dto.setMsg(rs.getString("msg"));
				dto.setPay_kind(rs.getString("pay_kind"));
				//저장된 DTO객체를 List컬렉션에 추가
				bbs.add(dto);
			}
		} catch (Exception e) {
			System.out.println("selectListPage 예외발생");
			e.printStackTrace();
		}
		return bbs;
	}
 	
	//게시물 삭제 처리
  	public int delete(String idx, String name1) {
  		int affected = 0;
  		try {
  			String query = "DELETE FROM shop_ordering "
  					+ "WHERE idx = ? AND name1 = ?";
  			
  			System.out.println("idx : " + idx);
  			System.out.println("name1 : " + name1);
  			psmt = con.prepareStatement(query);
  			psmt.setInt(1, Integer.parseInt(idx));
  			psmt.setString(2, name1);
  			
  			System.out.println("query : " + query);
  			
  			affected = psmt.executeUpdate();
  			
  			System.out.println("affected : " + affected);
  		}
  		catch (Exception e) {
  			System.out.println("DELETE중 예외 발생");
  			e.printStackTrace();
  		}
  		return affected;
  	}
   
}
















