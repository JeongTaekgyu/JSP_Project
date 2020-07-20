package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	
	private Connection conn;	// db에 접근하게 해주는 하나의 객체
	// private PreparedStatement pstmt;// SQL인젝션 같은 해킹 기법을 방버하기 위한 수단으로써 PreparedStatment를 이용한다. 
	// BbsDAO 클래스는 여러개의 함수가 사용되기 때문에 각각함수끼리 DB접근에 있어서 마찰이 일어나지 않도록 하기위해 이곳에서는 PreparedStatement는 사용하지 않는다.
	private ResultSet rs;	// 정보를 담을 수 있는 하나의 객체
	
	// UserDAO()를 하나의 객체로 만들었을  자동으로 database커넥션이 이루어 질 수 있도록 해준다.
	public BbsDAO() {
		try {
			String dbURL ="jdbc:mysql://localhost:3333/BBS";
			String dbID ="root";
			String dbPassword = "013174zz";
			Class.forName("com.mysql.jdbc.Driver"); // Driver는 mysql에 접속할 수 있도록 매개체 역할을 해주는 하나의 라이브러리이다.
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e){
			e.printStackTrace();	// 해당 예외를 출력한다.
		}
	}
	
	// 현재 시간을 가져오는 함수 - 게시판의 글을 작성할 현재서버시간을 넣어주려고
	public String getDate() {
		String SQL ="SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();	// 실제로 실행했을 때 나오는 결과
			
			if(rs.next()) {
				return rs.getString(1);	// 현재의 날짜를 그대로 반환한다. (getString(n)해당 순서에 있는 열을 반환한다.)
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return ""; // 데이터베이스 오류
	}
	
	public int getNext() {
		String SQL ="SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();	// 실제로 실행했을 때 나오는 결과
			
			//System.out.println("rs: "+rs); -> rs: com.mysql.jdbc.JDBC42ResultSet@6384bd78 이런식으로 출력됨
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 첫 번 게시물인 경우
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	// 하나의 게시물을 실제로 삽입하는 함수
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);	// bbsAvailable을 1로 만듦
			
			return pstmt.executeUpdate(); // 성공적으로 게시글을 반환
			// executeUpdate는  INSERT / DELETE / UPDATE 관련 구문에서는 반영된 레코드의 건수를 반환한다.
			// CREATE / DROP 관련 구문에서는 -1 을 반환한다.
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public ArrayList<Bbs> getList(int pageNumber){
		// bbsID가 특정값보다 작고, 삭제가 되지 않아서 bbsAvailable이 1 인 글들만 가져올 수 있도록 함 , bbsID로 내림차순 정렬하고, 위에서 10개 까지만 불러옴
		String SQL ="SELECT *FROM BBS WHERE bbsID < ? And bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			// getNext : 그 다음으로 작성될 글의 번호
			// 현재 글이 5개이고 다음으로 작성될 글의 번호가 6일, 6 - (1-1)*10
			// 즉 한 페이지에 최대 10개 까지만 보여주기로 했으므로 글이 5개 있을때는 pageNumber = 1 이다.
			rs = pstmt.executeQuery();	// 실제로 실행했을 때 나오는 결과
			 
			while(rs.next()) {
				Bbs bbs = new Bbs();
				
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				
				list.add(bbs);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return list; // 게시글 리스트를 반환한다.
	}
	
	// 페이지 처리를 위한 메서드 ( 게시글이 10개 단위니까 10개 이하이면 다음페이지가 없다. )
	public boolean nextPage(int pageNumber) {
		String SQL ="SELECT *FROM BBS WHERE bbsID < ? And bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			// getNext : 그 다음으로 작성될 글의 번호
			// 현재 글이 5개이고 다음으로 작성될 글의 번호가 6일, 6 - (1-1)*10
			// 즉 한 페이지에 최대 10개 까지만 보여주기로 했으므로 글이 5개 있을때는 pageNumber = 1 이다.
			rs = pstmt.executeQuery();	// 실제로 실행했을 때 나오는 결과
			 
			if(rs.next()) {
				return true; // 다음페이지로 넘어갈 수 있다.
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return false; // 다음 페이지가 없다면
	}
	
	// 하나의 글 내용을 불러오는 함수
	public Bbs getBbs(int bbsID) {
		// 특정한 아이디에 해당하는 게시글을 불러온다.
		String SQL ="SELECT *FROM BBS WHERE bbsID = ?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);

			rs = pstmt.executeQuery();	// 실제로 실행했을 때 나오는 결과
			 
			if(rs.next()) {
				Bbs bbs = new Bbs();
				
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				
				return bbs;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null; // 해당 글이 존재하지 않으면
	}
	
	// 글을 수정하는 함수
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		// 특정 bbsID에 해당하는 제목과 내용을 바꿔주겠다.
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			
			return pstmt.executeUpdate(); // 성공적으로 게시글을 반환
			// executeUpdate는  INSERT / DELETE / UPDATE 관련 구문에서는 반영된 레코드의 건수를 반환한다.
			// CREATE / DROP 관련 구문에서는 -1 을 반환한다.
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	// 글을 삭제하는 함수
	public int delete(int bbsID) {
		// 글을 삭제하더라도 글에 대한 정보가 남아 있을 수 있도록 한다.
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
				
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate(); // 성공적으로 게시글을 반환
			// executeUpdate는  INSERT / DELETE / UPDATE 관련 구문에서는 반영된 레코드의 건수를 반환한다.
			// CREATE / DROP 관련 구문에서는 -1 을 반환한다.
		} catch(Exception e) {
				e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
}