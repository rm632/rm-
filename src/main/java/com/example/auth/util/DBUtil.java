package com.example.auth.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * JDBC 工具类：读取 classpath 下的 db.properties 创建连接。
 * <p>
 * 如果同时存在 {@code db-local.properties}，会用它的内容覆盖同名项，
 * 这样真实的数据库密码可以放在本地覆盖文件里，不提交到 git。
 */
public final class DBUtil {

    private static final Properties PROPS = new Properties();
    private static final String BASE_CONFIG = "db.properties";
    private static final String LOCAL_CONFIG = "db-local.properties";

    private static String url;
    private static String username;
    private static String password;

    static {
        try {
            load(BASE_CONFIG, true);
            load(LOCAL_CONFIG, false); // 可选：本地覆盖，缺失时静默跳过

            String driver = PROPS.getProperty("jdbc.driver", "com.mysql.cj.jdbc.Driver");
            url = PROPS.getProperty("jdbc.url");
            username = PROPS.getProperty("jdbc.username");
            password = PROPS.getProperty("jdbc.password");

            Class.forName(driver);
        } catch (Exception e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private DBUtil() {
    }

    private static void load(String resource, boolean required) throws IOException {
        try (InputStream in = DBUtil.class.getClassLoader().getResourceAsStream(resource)) {
            if (in == null) {
                if (required) {
                    throw new IllegalStateException("classpath 下找不到 " + resource);
                }
                return;
            }
            PROPS.load(new InputStreamReader(in, StandardCharsets.UTF_8));
        }
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
