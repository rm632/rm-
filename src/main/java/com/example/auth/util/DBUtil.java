package com.example.auth.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * JDBC 工具类：读取 db.properties，统一创建连接。
 */
public final class DBUtil {

    private static final Properties PROPS = new Properties();
    private static String url;
    private static String username;
    private static String password;

    static {
        try (InputStream in = DBUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in == null) {
                throw new IllegalStateException("classpath 下找不到 db.properties");
            }
            PROPS.load(in);

            String driver = PROPS.getProperty("jdbc.driver", "com.mysql.cj.jdbc.Driver");
            url = PROPS.getProperty("jdbc.url");
            username = PROPS.getProperty("jdbc.username");
            password = PROPS.getProperty("jdbc.password");

            Class.forName(driver);
        } catch (IOException | ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private DBUtil() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    /** 静默关闭，避免每个 DAO 方法里重复写 try/catch。 */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try {
                    r.close();
                } catch (Exception ignored) {
                    // 关闭失败不影响主流程
                }
            }
        }
    }
}
