<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>忘记密码 - 用户中心</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="card">
    <c:choose>
        <%-- ========== 第二步：重置密码 ========== --%>
        <c:when test="${verified}">
            <h1>设置新密码</h1>
            <p class="subtitle">身份验证已通过，请设置新密码</p>

            <c:if test="${not empty error}">
                <div class="alert alert-error"><c:out value="${error}"/></div>
            </c:if>

            <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                <input type="hidden" name="step" value="reset">
                <input type="hidden" name="username" value="<c:out value='${username}'/>">
                <input type="hidden" name="email" value="<c:out value='${email}'/>">

                <div class="field">
                    <label for="newPassword">新密码</label>
                    <input type="password" id="newPassword" name="newPassword" minlength="6" maxlength="32"
                           placeholder="6-32 位" required autofocus>
                </div>
                <div class="field">
                    <label for="confirmPassword">确认新密码</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" minlength="6" maxlength="32"
                           placeholder="请再次输入新密码" required>
                </div>
                <button class="btn" type="submit">重置密码</button>
            </form>

            <div class="links">
                <a href="${pageContext.request.contextPath}/forgot-password">重新验证身份</a>
                <a href="${pageContext.request.contextPath}/login">返回登录</a>
            </div>

            <script>
                document.querySelector('form').addEventListener('submit', function (e) {
                    if (document.getElementById('newPassword').value !==
                        document.getElementById('confirmPassword').value) {
                        e.preventDefault();
                        alert('两次输入的密码不一致');
                    }
                });
            </script>
        </c:when>

        <%-- ========== 第一步：验证身份 ========== --%>
        <c:otherwise>
            <h1>忘记密码</h1>
            <p class="subtitle">验证用户名和邮箱后即可重置</p>

            <c:if test="${not empty error}">
                <div class="alert alert-error"><c:out value="${error}"/></div>
            </c:if>

            <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                <input type="hidden" name="step" value="verify">
                <div class="field">
                    <label for="username">用户名</label>
                    <input type="text" id="username" name="username" maxlength="20"
                           placeholder="请输入注册时的用户名"
                           value="<c:out value='${username}'/>" required autofocus>
                </div>
                <div class="field">
                    <label for="email">注册邮箱</label>
                    <input type="email" id="email" name="email" maxlength="100"
                           placeholder="请输入注册时填写的邮箱"
                           value="<c:out value='${email}'/>" required>
                    <span class="hint">用户名与邮箱需同时匹配</span>
                </div>
                <button class="btn" type="submit">验证身份</button>
            </form>

            <div class="links">
                <a href="${pageContext.request.contextPath}/login">返回登录</a>
                <a href="${pageContext.request.contextPath}/register">注册新账号</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
