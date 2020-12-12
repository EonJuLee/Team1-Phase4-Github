<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
<script type="text/javascript">
	function checkValue() {
		if(!document.signUpInfo.fname.value) {
			alert("please enter your first name");
			return false;
		}
		if(!document.signUpInfo.lname.value) {
			alert("please enter your last name");
			return false;
		}
		if(!document.signUpInfo.contact.value) {
			alert("please enter your contact number");
			return false;
		}
		if(!document.signUpInfo.password) {
			alert("please enter your password");
			return false;
		}
		if(!document.signUpInfo.login_id) {
			alert("please enter your ID");
			return false;
		}
	}
</script>
<form action="SignUpChk.jsp" method="post" name="signUpInfo" onsubmit="return checkValue()">
ID(Essentail) :
<input type="text" name="login_id"><br/>
PW(Essentail) :
<input type="password" id="password" class="classpw" name="password"><br/>
<%
	// user information
	String[] columns = { "gender", "birthdate", "address", "contact", "job", "fname", "middle", "lname", "admincode" };
	String[] descriptions = { "gender(F or M)", "birthdate(YYYY-MM-DD)", "address", "contact(Essentail)", "job", "first name(Essentail)", "middle name", "last name(Essentail)", "If you are ADMIN, INPUT validation code" };
	int info_length=columns.length;
	
	for(int i=0;i<info_length;i++){
		out.println("Enter your "+descriptions[i]+" : <input type=\"text\" name=\""+columns[i]+"\"><br/>");
	}
%>
<input type="submit" value="Sign Up">
</form>
<br/>
<script type="text/javascript">
function goBack() {
  window.history.back();
}
</script>
<input type="button" value="Back to Previous Page" onclick="return goBack()"/>
</body>

</html>