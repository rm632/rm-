package com.example.auth.util;

import java.util.regex.Pattern;

/**
 * 表单校验工具：把校验规则集中在一处，Servlet 只负责取返回值。
 * 每个方法返回 {@code null} 表示通过，否则返回给用户看的错误提示。
 */
public final class ValidationUtil {

    private static final Pattern USERNAME = Pattern.compile("^[A-Za-z0-9_]{3,20}$");
    private static final Pattern EMAIL =
            Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private ValidationUtil() {
    }

    public static String checkUsername(String username) {
        if (isBlank(username)) {
            return "请输入用户名";
        }
        if (!USERNAME.matcher(username).matches()) {
            return "用户名需为 3-20 位字母、数字或下划线";
        }
        return null;
    }

    public static String checkEmail(String email) {
        if (isBlank(email)) {
            return "请输入邮箱";
        }
        if (email.length() > 100 || !EMAIL.matcher(email).matches()) {
            return "邮箱格式不正确";
        }
        return null;
    }

    public static String checkPassword(String password) {
        if (isBlank(password)) {
            return "请输入密码";
        }
        if (password.length() < 6 || password.length() > 32) {
            return "密码长度需为 6-32 位";
        }
        return null;
    }

    public static String checkPasswordConfirm(String password, String confirm) {
        if (isBlank(confirm)) {
            return "请再次输入密码";
        }
        if (!password.equals(confirm)) {
            return "两次输入的密码不一致";
        }
        return null;
    }

    public static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    /** 统一 trim，避免用户复制粘贴时带空格。 */
    public static String trim(String s) {
        return s == null ? null : s.trim();
    }
}
