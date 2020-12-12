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
	String movie_id=(String)session.getAttribute("movie_id");
	
	// to give attributes to other pages
	session.setAttribute("id", id);
	session.setAttribute("isAdmin", isAdmin);
	session.setAttribute("userID", userID);
	session.setAttribute("movie_id",movie_id);
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
	
	function goVersionInfoPage() {
		session.setAttribute("movie_id", movie_id);
		location.href="VersionInfoPage.jsp";
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
Version Country : <input type="text" name="country">
<br/>
Version Start date (YYYY-MM-DD) : <input type="text" name="upload_date">
<br/>
Version End year : <input type="number" name="end_year">
<br/>
Version Language : <input type="text" name="language">
<br/>

<input type="submit" value="Edit Version">
<br/>
<input type="submit" value="Back to List" onclick="goVersionInfoPage()">
</form>
<!-- Form ends here -->

</body>
</html>