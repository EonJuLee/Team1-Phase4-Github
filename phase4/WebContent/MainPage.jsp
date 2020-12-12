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

	// to give attributes to other pages
	session.setAttribute("id", id);
    session.setAttribute("isAdmin", isAdmin);
    session.setAttribute("userID", userID);
%>
<%=id %> logined
<input type="button" value="Sign out" onclick="location.href='SignOut.jsp'"/><br/>
<hr/>
<input type="button" value="Account Page" onclick="location.href='AccountPage.jsp'"/><br/>
<input type="button" value="Movie Page" onclick="location.href='MoviePage.jsp'"/><br/>
<input type="button" value="Rating Page" onclick="location.href='RatingPage.jsp'"/><br/>
<% 
if(isAdmin==true) {
	out.println("<input type=\"button\" value=\"Admin Page\" onclick=\"location.href='AdminPage.jsp'\"/><br/>");
}
%>
</body>
</html>