package ftc.dao;

import ftc.db.ConnectionResource;
import ftc.db.ConnectionResource2;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

public class SamleDao {
	public void testDB2(){
		ConnectionResource2 resource = null;
		Statement stmt = null;
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "";
		try {
		  resource = new ConnectionResource2();
		  Connection conn = resource.getConnection();
			
		  System.out.println( "connS = " + conn );
		  
		  sql = 	" SELECT Dept_Seq, Center_Name, Dept_Name, User_Name, " +
			" Permision2005, Permision FROM TB_FTC_User " +
			" WHERE (ID = ?) AND (Password = ?)";
	
		  pstmt = conn.prepareStatement(sql);
		  rs = pstmt.executeQuery();
		  rs.getRow(); 
		  ArrayList tmpDept = null;
		  Integer.parseInt("");
//		  /tmpDept.add(index, element)
//		  /Math.round(a)
		  Long[] arrSum = new Long[7];

		  String aaa= rs.getString("columnName");

		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
		  if ( stmt != null ) try{stmt.close();}catch(Exception e){}
		  if ( resource != null ) resource.release();
		}
	}
	
	public void testDB(){
		ConnectionResource resource = null;
		Statement stmt = null;
		try {
		  resource = new ConnectionResource();
		  Connection conn = resource.getConnection();
			
		  System.out.println( "connS = " + conn );
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
		  if ( stmt != null ) try{stmt.close();}catch(Exception e){}
		  if ( resource != null ) resource.release();
		}
	}
}
