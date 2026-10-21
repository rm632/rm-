<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>注册 - 用户中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="card">
    <h1>创建账号</h1>
    <p class="subtitle">只需几秒，开始使用</p>

    <c:if test="${not empty error}">
        <div class="alert alert-error"><c:out value="${error}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="field">
            <label for="username">用户名</label>
            <input type="text" id="username" name="username" maxlength="20"
                   placeholder="3-20 位字母、数字或下划线"
                   pattern="[A-Za-z0-9_]{3,20}"
                   title="3-20 位字母、数字或下划线"
                   value="<c:out value='${username}'/>" required autofocus>
            <span class="hint">登录时可用用户名或邮箱</span>
        </div>
        <div class="field">
            <label for="email">邮箱</label>
            <input type="email" id="email" name="email" maxlength="100"
                   placeholder="请输入常用邮箱"
                   value="<c:out value='${email}'/>" required>
        </div>
        <div class="field">
            <label for="password">密码</label>
            <input type="password" id="password" name="password" minlength="6" maxlength="32"
                   placeholder="6-32 位" required>
        </div>
        <div class="field">
            <label for="confirmPassword">确认密码</label>
            <input type="password" id="confirmPassword" name="confirmPassword" minlength="6" maxlength="32"
                   placeholder="请再次输入密码" required>
        </div>
        <button class="btn" type="submit">注 册</button>
    </form>

    <div class="links">
        <span style="color:#6b7280;font-size:13px;">已有账号？</span>
        <a href="${pageContext.request.contextPath}/login">返回登录</a>
    </div>
</div>

<script>
    // 前端先挡一次「两次密码不一致」，后端仍会再校验一遍
    document.querySelector('form').addEventListener('submit', function (e) {
        var p = document.getElementById('password').value;
        var c = document.getElementById('confirmPassword').value;
        if (p !== c) {
            e.preventDefault();
            alert('两次输入的密码不一致');
        }
    });
</script>
</body>
</html>
