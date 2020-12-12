<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>

<body>

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
	
	function goAdminPage() {
		location.href="AdminPage.jsp";
	}
</script>


<!-- Form starts here -->
<form action="AddVersionChk.jsp" method="post" name="MovieInfo" onsubmit="return checkValue()">
<h2>Add new Movie</h2>

<%-- Info for movie --%>
Version Title : <input type="text" name="title">
<br/>
Movie Country : <input type="text" name="country">
<br/>
Movie Start date (YYYY-MM-DD) : <input type="text" name="upload_date">
<br/>
Movie End year : <input type="number" name="end_year">
<br/>
Movie Language : <input type="text" name="language">
<br/>

<input type="submit" value="Add new Version">
<br/>
<input type="submit" value="Back to previous Page" onclick="goAdminPage()">
</form>
<!-- Form ends here -->


</body>
</html>