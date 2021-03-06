<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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

<%
	String url = "jdbc:postgresql://localhost/jsy";
	String DBid = "jsy";
	String DBpw = "jsy";
	
	Connection conn = null;
	Statement stmt = null;
	
	try {
	    Class.forName("org.postgresql.Driver");
	    conn = DriverManager.getConnection(url, DBid, DBpw);
	    conn.setAutoCommit(false);
	    stmt = conn.createStatement();
	} catch (Exception e) {
	    e.printStackTrace();
	    System.err.println("ERROR : failed login postgresql");
}
%>

<!-- For check value in movies -->
<script type="text/javascript">
	function checkValue() {
		if(!document.MovieInfo.title.value) {
			alert("please enter version title");
			return false;
		}
		if(!document.MovieInfo.country.value) {
			alert("please enter version country");
			return false;
		}
		if(!document.MovieInfo.upload_date.value) {
			alert("please enter start date of movie version");
			return false;
		}
		if(!isValidDate(document.MovieInfo.upload_date.value)) {
			alert("Start date should be valid");
			return false;
		}
		if(!document.MovieInfo.language.value) {
			alert("please enter movie language");
			return false;
		}
	}
	
	function isValidDate(date) {
	      var valid_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
	      if(!valid_pattern.test(date)){
	         return false;
	      }
	      return true;
	}
	
</script>

<!-- Form starts here -->
<form action="AddVersionChk.jsp" method="post" name="MovieInfo" onsubmit="return checkValue()">

<h2>Add new Version</h2>	
<h3>Enter new version of movie information</h3>
Version Title : <input type="text" name="title">
<br/>
Version Country : <input type="text" name="country">
<br/>
Version Start date (YYYY-MM-DD) : <input type="text" name="upload_date">
<br/>
Version End year : <input type="number" name="end_year">
<br/>
Version Language : <input type="text" name="language">
<br/>
<input type="hidden" value="<%=request.getParameter("mID")%>" name="mID">
<input type="submit" value="Add new Version">
<br/>
</form>
<%
out.println("<td><form action=\"VersionInfoPage.jsp\">");
out.println("<input type=\"hidden\" name=\"mID\" value=\""+request.getParameter("mID")+"\" />");
out.println("<input type=\"hidden\" name=\"country\" value=\""+request.getParameter("country")+"\" />");
out.println("<input type=\"submit\" value=\"Back to List\"/>");
out.println("</form></td>");
%>
<!-- Form ends here -->


</body>
</html>