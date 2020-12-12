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
			alert("please enter movie title");
			return false;
		}
		if(!document.MovieInfo.runtime.value) {
			alert("please enter movie runtime");
			return false;
		}
		if(!isNumber(document.MovieInfo.runtime.value)) {
			alert("Runtime should be number");
			return false;
		}
		if(!document.MovieInfo.upload_date.value) {
			alert("please enter start date of movie");
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
		// return false if date is not valid
		var valid_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
		if(!valid_pattern .test(date)){
			return false;
		}
		return true;
	}
	
	function goAdminPage() {
		location.href="AdminPage.jsp";
	}
</script>


<!-- Form starts here -->
<form action="AddMovieChk.jsp" method="post" name="MovieInfo" onsubmit="return checkValue()">
<h2>Add new Movie</h2>

<%-- Info for movie --%>
Movie Title : <input type="text" name="title">
<br/>
Movie Type : 
<select name="type">
	<option value="Movie" selected>Movie</option>
	<option value="TV Series">TV Series</option>
	<option value="knuMovieDB original">knuMovieDB original</option>
</select>
<br/>
Movie Runtime : <input type="text" name="runtime">
<br/>
Movie Start date (YYYY-MM-DD) : <input type="text" name="upload_date">
<br/>
Movie End year : <input type="number" name="end_year">
<br/>
Movie Language : <input type="text" name="language">
<br/>

<input type="submit" value="Add new Movie">
<br/>
<input type="submit" value="Back to previous Page" onclick="goAdminPage()">
</form>
<!-- Form ends here -->


</body>
</html>