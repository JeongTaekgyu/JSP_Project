package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class BbsDAO {
	
	private Connection conn;	// db에 접근하게 해주는 하나의 객체
	// private PreparedStatement pstmt;// SQL인젝션 같은 해킹 기법을 방버하기 위한 수단으로써 PreparedStatment를 이용한다. 
	// BbsDAO 클래스는 여러개의 함수가 사용되기 때문에 각각함수끼리 DB접근에 있어서 마찰이 일어나지 않도록 하기위해 이곳에서는 PreparedStatement는 사용하지 않는다.
	private ResultSet rs;	// 정보를 담을 수 있는 하나의 객체
	
	// UserDAO()를 하나의 객체로 만들었을 떄 자동으로 database커넥션이 이루어 질 수 있도록 해준다.
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
	
	// 현재 시간을 가져오는 함수 - 게시판의 글을 작성할떄 현재서버시간을 넣어주려고
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
			
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 첫 번쨰 게시물인 경우
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
			pstmt.setInt(6, 1);
			
			return pstmt.executeUpdate(); // 성공적으로 게시글을 반환
			// executeUpdate는  INSERT / DELETE / UPDATE 관련 구문에서는 반영된 레코드의 건수를 반환한다.
			// CREATE / DROP 관련 구문에서는 -1 을 반환한다.
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
}
