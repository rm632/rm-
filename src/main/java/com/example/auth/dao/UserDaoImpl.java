package com.example.auth.dao;

import com.example.auth.model.User;
import com.example.auth.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * UserDao 的 JDBC 实现。全部使用 PreparedStatement，杜绝 SQL 注入。
 */
public class UserDaoImpl implements UserDao {

    private static final String COLUMNS = "id, username, email, password, created_at, updated_at";

    @Override
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT " + COLUMNS + " FROM t_user WHERE username = ?";
        return queryOne(sql, username);
    }

    @Override
    public User findByUsernameOrEmail(String account) throws SQLException {
        String sql = "SELECT " + COLUMNS + " FROM t_user WHERE username = ? OR email = ? LIMIT 1";
        return queryOne(sql, account, account);
    }

    @Override
    public User findByUsernameAndEmail(String username, String email) throws SQLException {
        String sql = "SELECT " + COLUMNS + " FROM t_user WHERE username = ? AND email = ? LIMIT 1";
        return queryOne(sql, username, email);
    }

    @Override
    public boolean existsByUsername(String username) throws SQLException {
        return exists("SELECT 1 FROM t_user WHERE username = ? LIMIT 1", username);
    }

    @Override
    public boolean existsByEmail(String email) throws SQLException {
        return exists("SELECT 1 FROM t_user WHERE email = ? LIMIT 1", email);
    }

    @Override
    public void insert(User user) throws SQLException {
        String sql = "INSERT INTO t_user (username, email, password) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet keys = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.executeUpdate();
            keys = ps.getGeneratedKeys();
            if (keys.next()) {
                user.setId(keys.getLong(1));
            }
        } finally {
            DBUtil.close(keys, ps, conn);
        }
    }

    @Override
    public void updatePassword(long userId, String encodedPassword) throws SQLException {
        String sql = "UPDATE t_user SET password = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, encodedPassword);
            ps.setLong(2, userId);
            ps.executeUpdate();
        } finally {
            DBUtil.close(ps, conn);
        }
    }

    // ---------------- 内部辅助 ----------------

    private User queryOne(String sql, String... params) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                ps.setString(i + 1, params[i]);
            }
            rs = ps.executeQuery();
            return rs.next() ? map(rs) : null;
        } finally {
            DBUtil.close(rs, ps, conn);
        }
    }

    private boolean exists(String sql, String param) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, param);
            rs = ps.executeQuery();
            return rs.next();
        } finally {
            DBUtil.close(rs, ps, conn);
        }
    }

    private User map(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getLong("id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));
        return u;
    }
}
