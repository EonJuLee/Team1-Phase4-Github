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
<input type="button" value="My Page" onclick="location.href='MyPage.jsp'"/>
<br/>
<input type="button" value="Edit Account Profile" onclick="location.href='EditProfilePage.jsp'"/>
<br/>
<input type="button" value="Withdrawl" onclick="location.href='Withdrawl.jsp'"/>
<br/>
<input type="button" value="Edit Password" onclick="location.href='EditPassword.jsp'"/>
<br/>
<script type="text/javascript">
function goBack() {
  window.history.back();
}
</script>
<input type="button" value="Back to Previous Page" onclick="location.href='MainPage.jsp'"/>
</body>
</html>
