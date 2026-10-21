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
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * 登录 Servlet。
 * <ul>
 *   <li>GET  /login  直接打开登录页</li>
 *   <li>POST /login  校验账号密码，成功后写入 Session 并跳转首页</li>
 * </ul>
 */
@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 已登录用户直接进首页，避免重复登录
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loginUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/home.jsp");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String account = ValidationUtil.trim(req.getParameter("account"));
        String password = req.getParameter("password");

        // 回填账号，让用户不用重新输入
        req.setAttribute("account", account);

        if (ValidationUtil.isBlank(account)) {
            fail(req, resp, "请输入用户名或邮箱");
            return;
        }
        if (ValidationUtil.isBlank(password)) {
            fail(req, resp, "请输入密码");
            return;
        }

        try {
            User user = userDao.findByUsernameOrEmail(account);
            if (user == null || !PasswordUtil.matches(password, user.getPassword())) {
                // 不区分「用户不存在」和「密码错误」，避免账号枚举
                fail(req, resp, "用户名或密码错误");
                return;
            }

            // 防止会话固定攻击：登录成功后换一个新会话
            HttpSession old = req.getSession(false);
            if (old != null) {
                old.invalidate();
            }
            HttpSession session = req.getSession(true);
            session.setAttribute("loginUser", user);
            session.setMaxInactiveInterval(30 * 60);

            resp.sendRedirect(req.getContextPath() + "/home.jsp");
        } catch (SQLException e) {
            log("登录查询失败", e);
            fail(req, resp, "系统繁忙，请稍后重试");
        }
    }

    private void fail(HttpServletRequest req, HttpServletResponse resp, String message)
            throws ServletException, IOException {
        req.setAttribute("error", message);
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}
