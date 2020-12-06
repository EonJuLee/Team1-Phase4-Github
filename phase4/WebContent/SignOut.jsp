<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
	session.removeAttribute("id");
	session.removeAttribute("isAdmin");
	session.removeAttribute("userID");
    %>
    <script>
    alert("Logout");
    location.href = "WelcomePage.jsp"
    </script>
    <%
%>