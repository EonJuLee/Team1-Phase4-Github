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


<%-- Add & Edit movies --%>
<input type="button" value="Movie & Version Management" onclick="location.href='ViewAllMovieInfo.jsp'"/>
<br/>
<input type="button" value="Episode Management" onclick="location.href='ViewAllTV.jsp'"/>
<br/>
<script type="text/javascript">
function goBack() {
  window.history.back();
}
</script>
<input type="button" value="Back to Previous Page" onclick="return goBack()"/>
</body>
</html>
