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



<%-- Jsp for Account Page --%>
<input type="button" value="View my Ratings" onclick="location.href='ViewMyRating.jsp'"/>
<br/>
<input type="button" value="Back to Previous Page" onclick="location.href='MainPage.jsp'"/>

<%
	if(isAdmin==true) {
		out.println("<br/>")
		out.println("<input type=\"button\" value=\"View all ratings\" onclick=\"location.href='ViewAllRating.jsp'\"/>");
	}

%>
</body>
</html>
