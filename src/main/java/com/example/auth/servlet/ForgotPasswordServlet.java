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
 * 忘记密码 Servlet，分两步：
 * <ol>
 *   <li>step=verify（第一步）：用「用户名 + 邮箱」验证身份，通过后展开重置表单</li>
 *   <li>step=reset （第二步）：再次校验身份后写入新密码</li>
 * </ol>
 * 说明：作业环境未接邮件服务，这里用「用户名 + 邮箱同时匹配」代替验证码，
 * 如果要接真实邮件找回，把第二步换成校验邮件里的一次性 token 即可。
 */
@WebServlet(name = "ForgotPasswordServlet", urlPatterns = "/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String step = ValidationUtil.trim(req.getParameter("step"));
        if ("reset".equals(step)) {
            doReset(req, resp);
        } else {
            doVerify(req, resp);
        }
    }

    /** 第一步：校验身份，成功后展示重置密码表单。 */
    private void doVerify(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = ValidationUtil.trim(req.getParameter("username"));
        String email = ValidationUtil.trim(req.getParameter("email"));

        req.setAttribute("username", username);
        req.setAttribute("email", email);

        String error = ValidationUtil.checkUsername(username);
        if (error == null) {
            error = ValidationUtil.checkEmail(email);
        }
        if (error != null) {
            fail(req, resp, error, false);
            return;
        }

        try {
            User user = userDao.findByUsernameAndEmail(username, email);
            if (user == null) {
                fail(req, resp, "用户名与邮箱不匹配", false);
                return;
            }
            // 身份通过，展开第二步
            req.setAttribute("verified", Boolean.TRUE);
            req.setAttribute("username", user.getUsername());
            req.setAttribute("email", user.getEmail());
            req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
        } catch (SQLException e) {
            log("找回密码身份校验失败", e);
            fail(req, resp, "系统繁忙，请稍后重试", false);
        }
    }

    /** 第二步：再次校验身份后更新密码。 */
    private void doReset(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = ValidationUtil.trim(req.getParameter("username"));
        String email = ValidationUtil.trim(req.getParameter("email"));
        String newPassword = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        String error = ValidationUtil.checkPassword(newPassword);
        if (error == null) {
            error = ValidationUtil.checkPasswordConfirm(newPassword, confirm);
        }
        if (error != null) {
            keepVerified(req, username, email);
            fail(req, resp, error, true);
            return;
        }

        try {
            // 第二步仍要校验身份，避免直接构造请求改掉别人密码
            User user = userDao.findByUsernameAndEmail(username, email);
            if (user == null) {
                fail(req, resp, "用户名与邮箱不匹配", false);
                return;
            }
            userDao.updatePassword(user.getId(), PasswordUtil.hash(newPassword));

            req.setAttribute("success", "密码重置成功，请用新密码登录");
            req.setAttribute("account", user.getUsername());
            req.getRequestDispatcher("/login.jsp").forward(req, resp);

        } catch (SQLException e) {
            log("重置密码失败", e);
            keepVerified(req, username, email);
            fail(req, resp, "系统繁忙，请稍后重试", true);
        }
    }

    private void keepVerified(HttpServletRequest req, String username, String email) {
        req.setAttribute("verified", Boolean.TRUE);
        req.setAttribute("username", username);
        req.setAttribute("email", email);
    }

    private void fail(HttpServletRequest req, HttpServletResponse resp,
                      String message, boolean stayOnResetStep)
            throws ServletException, IOException {
        req.setAttribute("error", message);
        if (!stayOnResetStep) {
            req.setAttribute("verified", Boolean.FALSE);
        }
        req.getRequestDispatcher("/forgot-password.jsp").forward(req, resp);
    }
}
