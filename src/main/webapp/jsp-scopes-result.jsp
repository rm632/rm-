<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  四种作用域演示（读取端）
  对照 jsp-scopes.jsp 的三种跳转方式，看四个作用域各自是否存活：
    page        —— 永远读不到（page 只属于原页面实例）
    request     —— forward 时读得到，redirect / 直接访问时读不到
    session     —— 都能读到（同一浏览器会话）
    application —— 都能读到（全局共享）
--%>
<%
    Object pageVal  = pageContext.getAttribute("pageMsg", PageContext.PAGE_SCOPE);
    Object reqVal   = pageContext.getAttribute("reqMsg", PageContext.REQUEST_SCOPE);
    Object sessVal  = pageContext.getAttribute("sessMsg", PageContext.SESSION_SCOPE);
    Object appVal   = pageContext.getAttribute("appMsg", PageContext.APPLICATION_SCOPE);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>四种作用域 - 结果页</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/demo.css">
</head>
<body>
<div class="wrap">
    <div class="topnav">
        <a href="${pageContext.request.contextPath}/jsp-objects.jsp">九大内置对象</a>
        <a href="${pageContext.request.contextPath}/jsp-scopes.jsp">四种作用域</a>
    </div>

    <h1>四种作用域 - 结果页</h1>
    <p class="subtitle">
        本页不写入任何属性，只读取。能否读到，取决于你从上一页用哪种方式跳转过来。
    </p>

    <table>
        <thead>
        <tr>
            <th class="idx">#</th>
            <th>作用域</th>
            <th>状态</th>
            <th>读到的值</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td class="idx">1</td>
            <td class="obj">page</td>
            <td><span class="<%= pageVal == null ? "miss" : "ok" %>"><%= pageVal == null ? "已失效" : "仍存在" %></span></td>
            <td class="val"><%= pageVal == null ? "（读不到，page 只属于原页面实例）" : pageVal %></td>
        </tr>
        <tr>
            <td class="idx">2</td>
            <td class="obj">request</td>
            <td><span class="<%= reqVal == null ? "miss" : "ok" %>"><%= reqVal == null ? "已失效" : "仍存在" %></span></td>
            <td class="val"><%= reqVal == null ? "（读不到，说明是新请求）" : reqVal %></td>
        </tr>
        <tr>
            <td class="idx">3</td>
            <td class="obj">session</td>
            <td><span class="<%= sessVal == null ? "miss" : "ok" %>"><%= sessVal == null ? "已失效" : "仍存在" %></span></td>
            <td class="val"><%= sessVal == null ? "（读不到，会话可能已超时）" : sessVal %></td>
        </tr>
        <tr>
            <td class="idx">4</td>
            <td class="obj">application</td>
            <td><span class="<%= appVal == null ? "miss" : "ok" %>"><%= appVal == null ? "已失效" : "仍存在" %></span></td>
            <td class="val"><%= appVal == null ? "（读不到，应用可能已重启）" : appVal %></td>
        </tr>
        </tbody>
    </table>

    <div class="note">
        结论：<br>
        <b>page</b> 出了本页就没了；<b>request</b> 只在一次请求内有效，所以 <b>forward 保留、redirect 丢失</b>；
        <b>session</b> 与 <b>application</b> 跨请求存活，前者按浏览器会话隔离，后者全应用共享。
    </div>

    <div class="actions">
        <a class="btn" href="${pageContext.request.contextPath}/jsp-scopes.jsp?action=forward">重新走 forward</a>
        <a class="btn ghost" href="${pageContext.request.contextPath}/jsp-scopes.jsp?action=redirect">重新走 redirect</a>
        <a class="btn ghost" href="${pageContext.request.contextPath}/jsp-scopes-result.jsp">再直接刷一次本页</a>
    </div>
</div>
</body>
</html>
