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
			alert("please enter start date of movie episode");
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
	
	function isValidDate(date) {
	      var valid_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;
	      if(!valid_pattern.test(date)){
	         return false;
	      }
	      return true;
	}
</script>


<!-- Form starts here -->
<form action="EditEpisodeChk.jsp" method="post" name="MovieInfo" onsubmit="return checkValue()">

<h2>Edit new Version</h2>	
<h3>Enter information version of movie</h3>
Episode Season : <input type="text" name="season">
<br/>
Episode number : <input type="text" name="epnum">
<br/>
Episode title : <input type="text" name="eptitle">
<br/>
Episode runtime : <input type="text" name="runtime">
<br/>
Episode Start date (YYYY-MM-DD) : <input type="text" name="upload_date">
<br/>
<input type="hidden" name="mID" value="<%=request.getParameter("mID")%>"/>
<input type="hidden" name="eID" value="<%=request.getParameter("eID")%>"/>
<input type="submit" value="Edit Episode">
<br/>
</form>
<script>
function goBack() {
  window.history.back();
}
</script>
<input type="button" value="Back to Previous Page" onclick="return goBack()"/>
<!-- Form ends here -->

</body>
</html>