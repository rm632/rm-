package com.example.auth.servlet;

import com.example.auth.dao.UserDao;
import com.example.auth.dao.UserDaoImpl;
import com.example.auth.model.User;
import com.example.auth.util.PasswordUtil;
import com.example.auth.util.ValidationUtil;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

/**
 * AJAX 登录接口：POST /api/login，返回 JSON，不刷新页面。
 *
 * 返回体：
 *   {"code":0,"message":"登录成功","redirect":"/home.jsp"}
 *   {"code":1,"message":"请输入用户名"}
 *   {"code":2,"message":"用户名或密码错误"}
 *   {"code":3,"message":"系统繁忙，请稍后重试"}
 */
@WebServlet(name = "AjaxLoginServlet", urlPatterns = "/api/login")
public class AjaxLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");

        String account = ValidationUtil.trim(req.getParameter("account"));
        String password = req.getParameter("password");

        if (ValidationUtil.isBlank(account)) {
            write(resp, 1, "请输入用户名或邮箱", null);
            return;
        }
        if (ValidationUtil.isBlank(password)) {
            write(resp, 1, "请输入密码", null);
            return;
        }

        try {
            User user = userDao.findByUsernameOrEmail(account);
            if (user == null || !PasswordUtil.matches(password, user.getPassword())) {
                // 不区分「用户不存在」和「密码错误」，避免账号枚举
                write(resp, 2, "用户名或密码错误", null);
                return;
            }

            // 防会话固定：登录成功后换新会话
            HttpSession old = req.getSession(false);
            if (old != null) {
                old.invalidate();
            }
            HttpSession session = req.getSession(true);
            session.setAttribute("loginUser", user);
            session.setMaxInactiveInterval(30 * 60);

            write(resp, 0, "登录成功", req.getContextPath() + "/home.jsp");

        } catch (SQLException e) {
            log("AJAX 登录查询失败", e);
            write(resp, 3, "系统繁忙，请稍后重试", null);
        }
    }

    /** 只允许 POST，GET 直接告诉调用方。 */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        write(resp, 4, "请使用 POST 提交", null);
    }

    private void write(HttpServletResponse resp, int code, String message, String redirect)
            throws IOException {
        StringBuilder sb = new StringBuilder(96);
        sb.append("{\"code\":").append(code)
          .append(",\"message\":\"").append(escape(message)).append('"');
        if (redirect != null) {
            sb.append(",\"redirect\":\"").append(escape(redirect)).append('"');
        }
        sb.append('}');

        PrintWriter out = resp.getWriter();
        out.write(sb.toString());
        out.flush();
    }

    /** 极简 JSON 字符串转义，避免额外引入 JSON 库。 */
    private static String escape(String s) {
        if (s == null) {
            return "";
        }
        StringBuilder sb = new StringBuilder(s.length() + 16);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '"':  sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\n': sb.append("\\n");  break;
                case '\r': sb.append("\\r");  break;
                case '\t': sb.append("\\t");  break;
                case '\b': sb.append("\\b");  break;
                case '\f': sb.append("\\f");  break;
                default:
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }
}
