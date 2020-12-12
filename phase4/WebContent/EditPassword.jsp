<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
</head>
<body>
<h1>Edit Password</h1>

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

<!-- For check value in password -->
<script type="text/javascript">
	function checkValue() {
		if(!document.userInfo.pw) {
			alert("please enter your password");
			return false;
		}
	}
	
	function goMainPage() {
		location.href="MainPage.jsp";
	}
</script>

<form action="EditPasswordChk.jsp" method="post" name="userInfo" onsubmit="return checkValue()">
PW : <input type="text" name="pw"><br/>
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
