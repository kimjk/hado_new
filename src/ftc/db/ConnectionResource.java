package ftc.db;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * ################################################
 * Test용 Connection 운영환경에 배포하지 마십시오.
 * ################################################
 */
public class ConnectionResource {
    private Connection conn;

    public Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@210.223.37.191:1521:XE", "hado", "hado");
        return conn;
    }

    public void release() {
        if (null != conn) {
            try {
                conn.close();
            } catch (Exception e) {
                // TODO: handle exception
            }
        }
    }
}
