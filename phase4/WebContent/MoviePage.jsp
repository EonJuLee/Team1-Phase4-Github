<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
</head>
<body>

<%
	// get variables from account page
	String id = (String) session.getAttribute("id");
	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
	int userID = (int) session.getAttribute("userID");
	
	// to give attributes to other pages
	session.setAttribute("id", id);
	session.setAttribute("isAdmin", isAdmin);
	session.setAttribute("userID", userID);
%>

<%-- Jsp for Movie Page --%>
<%-- I think it makes more sense to list all the movies in this page --%>
<input type="button" value="Movie List" onclick="location.href='ViewAllMovie.jsp'"/><br/>
<input type="button" value="Serach Movie" onclick="location.href='SearchMoviePage.jsp'"/><br/>
<input type="button" value="Back to Previous Page" onclick="location.href='MainPage.jsp'"/><br/>
</body>
</html>
