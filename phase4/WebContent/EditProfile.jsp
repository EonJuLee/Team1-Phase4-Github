<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
</head>
<body>
<h1>Log in</h1>
<form action="EditProfileChk.jsp" method="post">
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
<input type="button" value="Back to First Page" onclick="location.href='MainPage.jsp'"/>
</form>
</body>
</html>
