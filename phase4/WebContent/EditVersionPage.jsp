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
	String movie_id=request.getParameter("mID");
	String country=request.getParameter("country");
	
	// to give attributes to other pages
	session.setAttribute("id", id);
	session.setAttribute("isAdmin", isAdmin);
	session.setAttribute("userID", userID);
%>

<!-- For check value in movies -->
<script type="text/javascript">
	function checkValue() {
		if(!document.MovieInfo.title.value) {
			alert("please enter version title");
			return false;
		}
		if(!document.MovieInfo.country2.value) {
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
<form action="EditVersionChk.jsp" method="post" name="MovieInfo" onsubmit="return checkValue()">

<h2>Edit new Version</h2>	
<h3>Enter information version of movie</h3>
Version Title : <input type="text" name="title">
<br/>
Version Country : <input type="text" name="country2">
<br/>
Version Start date (YYYY-MM-DD) : <input type="text" name="upload_date">
<br/>
Version End year : <input type="number" name="end_year">
<br/>
Version Language : <input type="text" name="language">
<br/>
<input type="hidden" value="<%=request.getParameter("mID")%>" name="mID">
<input type="hidden" value="<%=request.getParameter("country")%>" name="country">
<input type="submit" value="Edit Version">
<br/>
</form>
<%
out.println("<form action=\"VersionInfoPage.jsp\">");
out.println("<input type=\"hidden\" name=\"mID\" value=\""+request.getParameter("mID")+"\" />");
out.println("<input type=\"submit\" value=\"Back to List\"/>");
out.println("</form>");
%>

</body>
</html>