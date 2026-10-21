<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.auth.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 首页必须登录后访问，未登录直接打回登录页
    Object current = session.getAttribute("loginUser");
    if (!(current instanceof User)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    User loginUser = (User) current;
    pageContext.setAttribute("loginUser", loginUser);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>首页 - 用户中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="card home-card">
    <div class="avatar"><c:out value="${loginUser.username.substring(0,1).toUpperCase()}"/></div>
    <h1>登录成功</h1>
    <p class="subtitle">欢迎回来，<c:out value="${loginUser.username}"/></p>

    <div class="meta">
        <div>用户名：<b><c:out value="${loginUser.username}"/></b></div>
        <div>邮箱：<b><c:out value="${loginUser.email}"/></b></div>
        <div>注册时间：<b><c:out value="${loginUser.createdAt}"/></b></div>
        <div>用户 ID：<b><c:out value="${loginUser.id}"/></b></div>
    </div>

    <a class="btn-outline" href="${pageContext.request.contextPath}/logout">退出登录</a>
</div>
</body>
</html>
