package com.example.auth.dao;

import com.example.auth.model.User;

import java.sql.SQLException;

/**
 * 用户数据访问接口。Servlet 只依赖这个接口，方便以后换实现或写单元测试。
 */
public interface UserDao {

    /** 按用户名精确查询，不存在返回 null。 */
    User findByUsername(String username) throws SQLException;

    /** 按用户名或邮箱查询（登录时允许两种方式），不存在返回 null。 */
    User findByUsernameOrEmail(String account) throws SQLException;

    /** 按用户名 + 邮箱查询（找回密码时校验身份），不匹配返回 null。 */
    User findByUsernameAndEmail(String username, String email) throws SQLException;

    /** 用户名是否已被占用。 */
    boolean existsByUsername(String username) throws SQLException;

    /** 邮箱是否已被占用。 */
    boolean existsByEmail(String email) throws SQLException;

    /** 新增用户，成功后把自增主键回填到 user.id。 */
    void insert(User user) throws SQLException;

    /** 更新密码（传入的已是编码后的密文）。 */
    void updatePassword(long userId, String encodedPassword) throws SQLException;
}
