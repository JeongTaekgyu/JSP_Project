package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

// jsp에서 회원 db 테이블에 접근할 수 있도록 DAO(database access object)를 만들어 야한다. 
// DAO(database access object) : 실제로 db에 접근해서 데이터를 가져오거나 넣거나하는 데이터 접근 객체이다.
// 실질적으로 회원정보를 불러오거나 db에 회원정보를 넣고자 할때 사용한다.
public class UserDAO {
	
	private Connection conn;	// db에 접근하게 해주는 하나의 객체
	private PreparedStatement pstmt;// SQL인젝션 같은 해킹 기법을 방버하기 위한 수단으로써 PreparedStatment를 이용한다. 
	private ResultSet rs;	// 정보를 담을 수 있는 하나의 객체
	
	// UserDAO()를 하나의 객체로 만들었을  자동으로 database커넥션이 이루어 질 수 있도록 해준다. (실제로 mysql에 접속을 하게 해주는 부분)
	public UserDAO() {
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
	
	// 실제로 로그인을 시도하는 하나의 함수
	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID =?"; // PreparedStatement 하나의 문장을 준비해 놨다가~
		// 매개변수로 들어온 userID를 ? 로 받아서 실제로 DB에는 현재 접속을 시도하고 자하는 그 사용자의 아이디를 받아서
		// 그아이디가 실제로 존재하는지 실제로 존재한다면 그 비번은 뭔지 db에서 가져온다.
		
		try {
			pstmt = conn.prepareStatement(SQL); // pstmt에 어떤 정해진 SQL문장을 DB에 삽입하는 형식으로 인스턴스를 가져온다.
			pstmt.setString(1, userID);	// setString으로 SQL타입을 처리해준다. int형이면 setInt()
			rs = pstmt.executeQuery();	// 실행한 결과를 넣어준다
			
			if(rs.next()) // 결과가 존재한다면(id가 있음)
			{	// 음 근데 이거 일일이 탐색 하는 건가? next를 봐선 그게 맞는데
				//System.out.println("rs.getString(1) : " + rs.getString(1));
				if(rs.getString(1).equals(userPassword)) // getString()함수는 해당 순서의 열에있는 데이터를 String형으로 받아온단 뜻이다. 여기서 1열에는 userPassword가 있다.
				{  
					return 1; // 비밀번호 일치 -> 로그인 성공
				}else {
					return 0; // 비밀번호 불일치
				}
			}
			return -1; // 아이디가 없음
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -2;	// 데이터베이스 오류 
	}
	
	// 해당 유저의 정보를 insert한다.
	public int join(User user) {
		String SQL ="INSERT INTO USER VALUES(?, ?, ?, ?, ?)";
		
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();
			// executeUpdate는  INSERT / DELETE / UPDATE 관련 구문에서는 반영된 레코드의 건수를 반환한다.
			// CREATE / DROP 관련 구문에서는 -1 을 반환한다.
		} catch(Exception e){
			e.printStackTrace();
		}
		return -1;	// 데이터 베이스 오류
	}
}