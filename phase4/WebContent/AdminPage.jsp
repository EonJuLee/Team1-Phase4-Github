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


<%-- Add new movies --%>
<input type="button" value="Add new Movie" onclick="location.href='AddMoviePage.jsp'"/>
<br/>
<input type="button" value="Add new Version" onclick="location.href='AddVersionPage.jsp'"/>
<br/>
<input type="button" value="Add new Episode" onclick="location.href='AddEpisodePage.jsp'"/>
<br/>

<%-- Edit movies --%>
<input type="button" value="Edit Movie Information" onclick="location.href='EditMoviePage.jsp'"/>
<br/>
<input type="button" value="Edit Version Information" onclick="location.href='EditVersionPage.jsp'"/>
<br/>
<input type="button" value="Edit Episode Information" onclick="location.href='EditEpisodePage.jsp'"/>
<br/>
<input type="button" value="Back to Previous Page" onclick="location.href='MainPage.jsp'"/>
</body>
</html>
