<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
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
	
	function goMainPage() {
		location.href="MainPage.jsp";
	}
</script>
<form action="EditProfileChk.jsp" method="post" name="userInfo" onsubmit="return checkValue()">
<%
	// user information
	String[] columns = { "gender", "birthdate", "address", "contact", "job", "fname", "middle", "lname" };
	String[] descriptions = { "gender(F or M)", "birthdate(YYYY-MM-DD)", "address", "contact", "job", "first name", "middle name", "last name" };
	int info_length=columns.length;
	
	out.println("Enter your gender : ");
	out.println("<select name=\"gender\">");
	out.println("<option value=\"F\" selected>F</option>");
	out.println("<option value=\"M\" selected>M</option>");
	out.println("</select>");
	out.println("<br/>");
	for(int i=1;i<info_length;i++){
		out.println("Enter your "+descriptions[i]+" : <input type=\"text\" name=\""+columns[i]+"\"><br/>");
	}
%>
<input type="submit" value="Edit">
<br/>
<input type="button" value="Back to First Page" onclick="goMainPage()"/>
</form>
</body>
</html>
