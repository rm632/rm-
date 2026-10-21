package com.example.auth.servlet;

import com.example.auth.dao.UserDao;
import com.example.auth.dao.UserDaoImpl;
import com.example.auth.model.User;
import com.example.auth.util.PasswordUtil;
import com.example.auth.util.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * 注册 Servlet。
 * <ul>
 *   <li>GET  /register  打开注册页</li>
 *   <li>POST /register  校验表单、查重、写库，成功后回到登录页</li>
 * </ul>
 */
@WebServlet(name = "RegisterServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = ValidationUtil.trim(req.getParameter("username"));
        String email = ValidationUtil.trim(req.getParameter("email"));
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirmPassword");

        // 出错时回填（不含密码），提升体验
        req.setAttribute("username", username);
        req.setAttribute("email", email);

        // 1. 格式校验
        String error = ValidationUtil.checkUsername(username);
        if (error == null) {
            error = ValidationUtil.checkEmail(email);
        }
        if (error == null) {
            error = ValidationUtil.checkPassword(password);
        }
        if (error == null) {
            error = ValidationUtil.checkPasswordConfirm(password, confirm);
        }
        if (error != null) {
            fail(req, resp, error);
            return;
        }

        // 2. 查重 + 写库
        try {
            if (userDao.existsByUsername(username)) {
                fail(req, resp, "该用户名已被注册");
                return;
            }
            if (userDao.existsByEmail(email)) {
                fail(req, resp, "该邮箱已被注册");
                return;
            }

            User user = new User(username, email, PasswordUtil.hash(password));
            userDao.insert(user);

            // 3. 成功：带提示回登录页
            req.setAttribute("success", "注册成功，请使用新账号登录");
            req.setAttribute("account", username);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);

        } catch (SQLException e) {
            // 并发下唯一索引可能先触发，这里兜底识别
            String msg = String.valueOf(e.getMessage());
            if (msg.contains("uk_user_username")) {
                fail(req, resp, "该用户名已被注册");
            } else if (msg.contains("uk_user_email")) {
                fail(req, resp, "该邮箱已被注册");
            } else {
                log("注册写库失败", e);
                fail(req, resp, "系统繁忙，请稍后重试");
            }
        }
    }

    private void fail(HttpServletRequest req, HttpServletResponse resp, String message)
            throws ServletException, IOException {
        req.setAttribute("error", message);
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }
}
