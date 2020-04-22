package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class BbsDAO {
	
	private Connection conn;	// db�� �����ϰ� ���ִ� �ϳ��� ��ü
	// private PreparedStatement pstmt;// SQL������ ���� ��ŷ ����� ����ϱ� ���� �������ν� PreparedStatment�� �̿��Ѵ�. 
	// BbsDAO Ŭ������ �������� �Լ��� ���Ǳ� ������ �����Լ����� DB���ٿ� �־ ������ �Ͼ�� �ʵ��� �ϱ����� �̰������� PreparedStatement�� ������� �ʴ´�.
	private ResultSet rs;	// ������ ���� �� �ִ� �ϳ��� ��ü
	
	// UserDAO()�� �ϳ��� ��ü�� ������� �� �ڵ����� databaseĿ�ؼ��� �̷�� �� �� �ֵ��� ���ش�.
	public BbsDAO() {
		try {
			String dbURL ="jdbc:mysql://localhost:3333/BBS";
			String dbID ="root";
			String dbPassword = "013174zz";
			Class.forName("com.mysql.jdbc.Driver"); // Driver�� mysql�� ������ �� �ֵ��� �Ű�ü ������ ���ִ� �ϳ��� ���̺귯���̴�.
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e){
			e.printStackTrace();	// �ش� ���ܸ� ����Ѵ�.
		}
	}
	
	// ���� �ð��� �������� �Լ� - �Խ����� ���� �ۼ��ҋ� ���缭���ð��� �־��ַ���
	public String getDate() {
		String SQL ="SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();	// ������ �������� �� ������ ���
			
			if(rs.next()) {
				return rs.getString(1);	// ������ ��¥�� �״�� ��ȯ�Ѵ�. (getString(n)�ش� ������ �ִ� ���� ��ȯ�Ѵ�.)
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return ""; // �����ͺ��̽� ����
	}
	
	public int getNext() {
		String SQL ="SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();	// ������ �������� �� ������ ���
			
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // ù ���� �Խù��� ���
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // �����ͺ��̽� ����
	}
	
	// �ϳ��� �Խù��� ������ �����ϴ� �Լ�
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
			
			return pstmt.executeUpdate(); // ���������� �Խñ��� ��ȯ
			// executeUpdate��  INSERT / DELETE / UPDATE ���� ���������� �ݿ��� ���ڵ��� �Ǽ��� ��ȯ�Ѵ�.
			// CREATE / DROP ���� ���������� -1 �� ��ȯ�Ѵ�.
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // �����ͺ��̽� ����
	}
	
}