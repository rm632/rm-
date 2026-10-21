<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>登录 - 用户中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="card">
    <h1>欢迎回来</h1>
    <p class="subtitle">登录你的账号以继续</p>

    <c:if test="${not empty error}">
        <div class="alert alert-error"><c:out value="${error}"/></div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="alert alert-success"><c:out value="${success}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="field">
            <label for="account">用户名 / 邮箱</label>
            <input type="text" id="account" name="account" maxlength="100"
                   placeholder="请输入用户名或邮箱"
                   value="<c:out value='${account}'/>" required autofocus>
        </div>
        <div class="field">
            <label for="password">密码</label>
            <input type="password" id="password" name="password" maxlength="32"
                   placeholder="请输入密码" required>
        </div>
        <button class="btn" type="submit">登 录</button>
    </form>

    <div class="links">
        <a href="${pageContext.request.contextPath}/forgot-password">忘记密码？</a>
        <a href="${pageContext.request.contextPath}/register">还没有账号？立即注册</a>
    </div>
</div>
</body>
</html>
