<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         isErrorPage="true" %>
<%--
  错误页：只有声明 isErrorPage="true"，内置对象 exception 才可用。
  被 jsp-objects.jsp 的 errorPage="/jsp-error.jsp" 引用。
--%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>异常页 - exception 内置对象</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/demo.css">
</head>
<body>
<div class="wrap">
    <div class="topnav">
        <a href="${pageContext.request.contextPath}/jsp-objects.jsp">返回九大内置对象</a>
        <a href="${pageContext.request.contextPath}/jsp-scopes.jsp">四种作用域</a>
    </div>

    <h1>第 9 个内置对象：exception</h1>
    <p class="subtitle">
        本页声明了 <code>isErrorPage="true"</code>，因此可以直接使用内置对象 <code>exception</code>。
    </p>

    <table>
        <thead>
        <tr>
            <th class="idx">#</th>
            <th>内置对象</th>
            <th>类型</th>
            <th>演示值</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td class="idx">9</td>
            <td class="obj">exception</td>
            <td class="type">Throwable</td>
            <td class="val">
                异常类型：<code><%= exception.getClass().getName() %></code><br>
                异常消息：<code><%= exception.getMessage() %></code><br>
                发生页面：<code><%= request.getAttribute("javax.servlet.error.request_uri") %></code>
            </td>
        </tr>
        <tr>
            <td class="idx">—</td>
            <td class="obj">config</td>
            <td class="type">ServletConfig</td>
            <td class="val">
                错误页同样具备全部内置对象，例如 config：<code><%= config.getServletName() %></code>
            </td>
        </tr>
        </tbody>
    </table>

    <h2>异常堆栈</h2>
    <div class="stack"><%
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        exception.printStackTrace(pw);
        pw.flush();
        out.print(sw.toString());
    %></div>

    <div class="actions" style="margin-top:20px">
        <a class="btn" href="${pageContext.request.contextPath}/jsp-objects.jsp">返回演示首页</a>
    </div>
</div>
</body>
</html>
