<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  站点入口：跳转到 AJAX 版登录页（login-ajax.html）。
  传统表单版登录页仍然保留在 /login。
--%>
<% response.sendRedirect(request.getContextPath() + "/login-ajax.html"); %>
