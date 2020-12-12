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
		if(!document.MovieInfo.eptitle.value) {
			alert("please enter episode title");
			return false;
		}
		if(!document.MovieInfo.season.value) {
			alert("please enter episode season");
			return false;
		}
		if(!document.MovieInfo.epnum.value) {
			alert("please enter episode number");
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
		if(!document.MovieInfo.runtime.value) {
			alert("please enter episode runtime");
			return false;
		}
	}
	
	function goAdminPage() {
		location.href="AdminPage.jsp";
	}
</script>


<!-- Form starts here -->
<form action="AddEpisodeChk.jsp" method="post" name="MovieInfo" onsubmit="return checkValue()">
<h2>Add new Movie</h2>

<%-- Info for movie --%>
Episode Title : <input type="text" name="eptitle">
<br/>
Episode season : <input type="text" name="season">
<br/>
Episode number : <input type="text" name="epnum">
<br/>
Episode Start date (YYYY-MM-DD) : <input type="text" name="upload_date">
<br/>
Episode End year : <input type="number" name="end_year">
<br/>
Movie runtime : <input type="text" name="runtime">
<br/>

<input type="submit" value="Add new Episode">
<br/>
<input type="submit" value="Back to previous Page" onclick="goAdminPage()">
</form>
<!-- Form ends here -->


</body>
</html>