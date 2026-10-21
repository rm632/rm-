<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  站点入口：统一跳到登录页。
  已登录的用户会在 LoginServlet 的 doGet 里被直接送到 home.jsp。
--%>
<% response.sendRedirect(request.getContextPath() + "/login"); %>
