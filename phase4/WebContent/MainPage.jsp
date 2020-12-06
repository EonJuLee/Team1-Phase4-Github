<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>MainPage</title>
</head>
<body>
<%
// session attribute : id(String), isAdmin(Boolean), userID(int)
	String id = (String) session.getAttribute("id");
	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
	int userID = (int) session.getAttribute("userID");
%>
<%=id %> logined
<input type="button" value="Sign out" onclick="location.href='SignOut.jsp'"/><br/>

</body>
</html>