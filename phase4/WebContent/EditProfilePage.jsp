<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
</head>
<body>
<h1>Log in</h1>
<script type="text/javascript">
	function checkValue() {
		if(!document.userInfo.fname) {
			alert("please enter your first name");
			return false;
		}
		if(!document.userInfo.lname) {
			alert("please enter your last name");
			return false;
		}
		if(!document.userInfo.contact) {
			alert("please enter your contact number");
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
	
	for(int i=0;i<info_length;i++){
		out.println("Enter your "+descriptions[i]+" : <input type=\"text\" name=\""+columns[i]+"\"><br/>";
	}
%>
<input type="submit" value="Edit">
<br/>
<input type="button" value="Back to First Page" onclick="goMainPage()"/>
</form>
</body>
</html>
