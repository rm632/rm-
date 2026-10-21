<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
         import="java.util.Enumeration"
         errorPage="/jsp-error.jsp" %>
<%--
  JSP 九大内置对象演示
  九大内置对象：request / response / session / application / out /
                page / pageContext / config / exception
  说明：exception 只有在 isErrorPage="true" 的页面才可用，所以单独放在 jsp-error.jsp 演示。
--%>
<%
    // 故意抛异常，用于演示 errorPage 与 exception 对象
    if ("1".equals(request.getParameter("boom"))) {
        throw new RuntimeException("这是一次故意抛出的异常，用于演示 exception 内置对象");
    }

    // application 作用域计数器：演示 application 对象跨请求存活
    Integer appCounter = (Integer) application.getAttribute("demoAppCounter");
    appCounter = (appCounter == null) ? 1 : appCounter + 1;
    application.setAttribute("demoAppCounter", appCounter);

    // 给 pageContext 演示准备一个属性
    pageContext.setAttribute("demoPageAttr", "我是 page 作用域里的值");

    Enumeration<String> initNames = config.getInitParameterNames();
    int initCount = 0;
    while (initNames.hasMoreElements()) {
        initNames.nextElement();
        initCount++;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>JSP 九大内置对象演示</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/demo.css">
</head>
<body>
<div class="wrap">
    <div class="topnav">
        <a href="${pageContext.request.contextPath}/jsp-objects.jsp">九大内置对象</a>
        <a href="${pageContext.request.contextPath}/jsp-scopes.jsp">四种作用域</a>
        <a href="${pageContext.request.contextPath}/jsp-objects.jsp?boom=1">触发异常页</a>
    </div>

    <h1>JSP 九大内置对象</h1>
    <p class="subtitle">
        这些对象由容器在 <code>_jspService()</code> 方法中自动创建，JSP 里可以直接使用，无需 <code>new</code>。
    </p>

    <table>
        <thead>
        <tr>
            <th class="idx">#</th>
            <th>内置对象</th>
            <th>类型</th>
            <th>演示值（本次请求实时读取）</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td class="idx">1</td>
            <td class="obj">request</td>
            <td class="type">HttpServletRequest</td>
            <td class="val">
                请求方法：<code><%= request.getMethod() %></code><br>
                请求路径：<code><%= request.getRequestURI() %></code><br>
                客户端 IP：<code><%= request.getRemoteAddr() %></code><br>
                协议：<code><%= request.getProtocol() %></code>
            </td>
        </tr>
        <tr>
            <td class="idx">2</td>
            <td class="obj">response</td>
            <td class="type">HttpServletResponse</td>
            <td class="val">
                字符编码：<code><%= response.getCharacterEncoding() %></code><br>
                Content-Type：<code><%= response.getContentType() %></code><br>
                是否已提交：<code><%= response.isCommitted() %></code>
            </td>
        </tr>
        <tr>
            <td class="idx">3</td>
            <td class="obj">session</td>
            <td class="type">HttpSession</td>
            <td class="val">
                SessionID：<code><%= session.getId() %></code><br>
                是否新建：<code><%= session.isNew() %></code><br>
                创建时间：<code><%= new java.util.Date(session.getCreationTime()) %></code>
            </td>
        </tr>
        <tr>
            <td class="idx">4</td>
            <td class="obj">application</td>
            <td class="type">ServletContext</td>
            <td class="val">
                容器信息：<code><%= application.getServerInfo() %></code><br>
                项目真实路径：<code><%= application.getRealPath("/") %></code><br>
                访问计数：<code><%= application.getAttribute("demoAppCounter") %></code> 次（刷新页面会累加）
            </td>
        </tr>
        <tr>
            <td class="idx">5</td>
            <td class="obj">out</td>
            <td class="type">JspWriter</td>
            <td class="val">
                缓冲区大小：<code><%= out.getBufferSize() %></code> 字节<br>
                剩余空间：<code><%= out.getRemaining() %></code> 字节<br>
                是否自动刷新：<code><%= out.isAutoFlush() %></code>
            </td>
        </tr>
        <tr>
            <td class="idx">6</td>
            <td class="obj">page</td>
            <td class="type">Object（即 this）</td>
            <td class="val">
                当前页面实例：<code><%= this.getClass().getName() %></code><br>
                等价于：<code>this</code>
            </td>
        </tr>
        <tr>
            <td class="idx">7</td>
            <td class="obj">pageContext</td>
            <td class="type">PageContext</td>
            <td class="val">
                取 page 属性：<code><%= pageContext.getAttribute("demoPageAttr", PageContext.PAGE_SCOPE) %></code><br>
                可取出范围：<code><%= pageContext.getAttribute("demoPageAttr") %></code>（默认 PAGE→REQUEST→SESSION→APPLICATION）<br>
                所属 request：<code><%= pageContext.getRequest().getClass().getName() %></code>
            </td>
        </tr>
        <tr>
            <td class="idx">8</td>
            <td class="obj">config</td>
            <td class="type">ServletConfig</td>
            <td class="val">
                Servlet 名称：<code><%= config.getServletName() %></code><br>
                初始化参数个数：<code><%= initCount %></code>（可在 web.xml 里给 jsp-file 配 init-param）<br>
                ServletContext：<code><%= config.getServletContext() == application %></code>
            </td>
        </tr>
        <tr>
            <td class="idx">9</td>
            <td class="obj">exception</td>
            <td class="type">Throwable</td>
            <td class="val">
                仅当页面声明 <code>isErrorPage="true"</code> 时才存在<br>
                本页通过 <code>errorPage="/jsp-error.jsp"</code> 指向错误页
                —— <a href="?boom=1">点这里触发异常查看</a>
            </td>
        </tr>
        </tbody>
    </table>

    <div class="note">
        提示：<code>exception</code> 在普通 JSP 中不可直接使用；只有错误页才能访问它。点上面的「触发异常页」可以看到完整的异常类型、消息与堆栈。
    </div>

    <div class="actions">
        <a class="btn" href="${pageContext.request.contextPath}/jsp-scopes.jsp">去看四种作用域演示</a>
        <a class="btn ghost" href="?">刷新本页（观察 application 计数与 session 状态）</a>
        <a class="btn danger" href="?boom=1">触发异常页</a>
    </div>
</div>
</body>
</html>
