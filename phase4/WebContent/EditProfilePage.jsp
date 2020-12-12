<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
</head>
<body>
<h1>Edit Profile</h1>
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
<script type="text/javascript">
	function checkValue() {
		if(!document.userInfo.fname.value) {
			alert("please enter your first name");
			return false;
		}
		if(!document.userInfo.lname.value) {
			alert("please enter your last name");
			return false;
		}
		if(!document.userInfo.contact.value) {
			alert("please enter your contact number");
			return false;
		}
		if(!isValidDate(document.MovieInfo.birthdate.value)) {
			alert("Birthdate should be valid");
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
	
	function goMainPage() {
		location.href="MainPage.jsp";
	}
</script>
<form action="EditProfileChk.jsp" method="post" name="userInfo" onsubmit="return checkValue()">
<%
	// user information
	String[] columns = { "gender", "birthdate", "address", "contact", "job", "fname", "middle", "lname" };
	String[] descriptions = { "gender(F or M)", "birthdate(YYYY-MM-DD)", "address", "contact(Essential)", "job", "first name(Essential)", "middle name", "last name(Essential)" };
	String[] values = new String[columns.length];
	int info_length=columns.length;

	out.println("Enter your gender : ");
	out.println("<select name=\"gender\">");

	out.println("<option value=\"null\" selected>none</option>");
	out.println("<option value=\"F\">F</option>");
	out.println("<option value=\"M\">M</option>");
	
	out.println("</select>");
	out.println("<br/>");
	for(int i=1;i<info_length;i++){
		
		out.println("Enter your "+descriptions[i]+" : <input type=\"text\" name=\""+columns[i]+"\" value=\"\"><br/>");
	
	}
%>
<input type="submit" value="Edit">
<br/>

<script type="text/javascript">
function goBack() {
  window.history.back();
}
</script>
<input type="button" value="Back to Previous Page" onclick="return goBack()"/>
</form>
</body>
</html>
