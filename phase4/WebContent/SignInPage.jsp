<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
</head>
<body>
<h1>Log in</h1>
<form action="SignInChk.jsp" method="post">
ID : <input type="text" name="id"><br/>
PW : <input type="password" name="pw"><br/>
<input type="submit" value="Login">
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