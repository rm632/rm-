<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  JSP 四种作用域演示（写入端）
    page      —— 仅当前 JSP 实例有效，离开本页即失效
    request   —— 一次请求内有效，forward 可带过去，redirect 会丢失
    session   —— 一次会话内有效，关浏览器（或超时）才失效
    application —— 整个 Web 应用内有效，所有用户共享，重启才清空
--%>
<%
    // ① 一次性写入四种作用域
    pageContext.setAttribute("pageMsg",   "我是 page 作用域的值（只在当前 JSP 有效）",       PageContext.PAGE_SCOPE);
    pageContext.setAttribute("reqMsg",    "我是 request 作用域的值（forward 后仍在）",        PageContext.REQUEST_SCOPE);
    pageContext.setAttribute("sessMsg",   "我是 session 作用域的值（换页面、刷新都还在）",    PageContext.SESSION_SCOPE);
    pageContext.setAttribute("appMsg",    "我是 application 作用域的值（所有用户共享）",      PageContext.APPLICATION_SCOPE);

    // ② 按动作决定跳转方式，用来观察 request 作用域是否存活
    String action = request.getParameter("action");
    if ("forward".equals(action)) {
        // 服务器内部转发：同一个请求对象，request 作用域保留
        request.getRequestDispatcher("/jsp-scopes-result.jsp").forward(request, response);
        return;
    }
    if ("redirect".equals(action)) {
        // 客户端重定向：浏览器发起新请求，request 作用域丢失
        response.sendRedirect(request.getContextPath() + "/jsp-scopes-result.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>JSP 四种作用域演示</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/demo.css">
</head>
<body>
<div class="wrap">
    <div class="topnav">
        <a href="${pageContext.request.contextPath}/jsp-objects.jsp">九大内置对象</a>
        <a href="${pageContext.request.contextPath}/jsp-scopes.jsp">四种作用域</a>
    </div>

    <h1>JSP 四种作用域</h1>
    <p class="subtitle">
        本页依次向四个作用域写入同名规则的属性，然后立刻读回来验证。
        跳转按钮用于观察不同跳转方式下哪些作用域会丢失。
    </p>

    <h2>① 写入后立刻读取（本页内四个作用域都可见）</h2>
    <table>
        <thead>
        <tr>
            <th class="idx">#</th>
            <th>作用域</th>
            <th>对应对象 / 常量</th>
            <th>属性值</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td class="idx">1</td>
            <td class="obj">page</td>
            <td class="type">pageContext / PageContext.PAGE_SCOPE</td>
            <td class="val"><%= pageContext.getAttribute("pageMsg", PageContext.PAGE_SCOPE) %></td>
        </tr>
        <tr>
            <td class="idx">2</td>
            <td class="obj">request</td>
            <td class="type">request / PageContext.REQUEST_SCOPE</td>
            <td class="val"><%= pageContext.getAttribute("reqMsg", PageContext.REQUEST_SCOPE) %></td>
        </tr>
        <tr>
            <td class="idx">3</td>
            <td class="obj">session</td>
            <td class="type">session / PageContext.SESSION_SCOPE</td>
            <td class="val"><%= pageContext.getAttribute("sessMsg", PageContext.SESSION_SCOPE) %></td>
        </tr>
        <tr>
            <td class="idx">4</td>
            <td class="obj">application</td>
            <td class="type">application / PageContext.APPLICATION_SCOPE</td>
            <td class="val"><%= pageContext.getAttribute("appMsg", PageContext.APPLICATION_SCOPE) %></td>
        </tr>
        </tbody>
    </table>

    <div class="note">
        四种作用域的比较：<br>
        <b>page</b> &lt; <b>request</b> &lt; <b>session</b> &lt; <b>application</b>（由小到大）。<br>
        用 <code>pageContext.findAttribute("x")</code> 会按这个顺序自动向上查找。
    </div>

    <h2>② 用不同方式跳转到结果页，观察哪些作用域活下来</h2>
    <div class="actions">
        <a class="btn" href="?action=forward">① 请求转发 forward（request 应保留）</a>
        <a class="btn ghost" href="?action=redirect">② 重定向 redirect（request 应丢失）</a>
        <a class="btn ghost" href="${pageContext.request.contextPath}/jsp-scopes-result.jsp">
            ③ 直接打开结果页（source 不再执行，request 应丢失）
        </a>
    </div>
</div>
</body>
</html>
