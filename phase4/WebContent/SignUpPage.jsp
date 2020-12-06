<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
<form action="SignUpChk.jsp" method="post">
<h2>Essential Data</h2>
ID<br/>
<input type="text" name="id"><br/>
PW<br/>
<input type="password" id="password" class="classpw" name="pw"><br/>
<%--
pw check section. doesn't work for some reason.......... why........
PW check<br/>
<input type="password" id="password_chk" class="classpw">
<span id="alert-success" style="display: none;">correct PW</span>
<span id="alert-danger" style="display: none; color: #d92742; font-weight: bold; ">incorrect PW</span>
<br/>
<script>
    $('.classpw').focusout(function () {
        var pwd1 = $("#password").val();
        var pwd2 = $("#password_chk").val();
 
        if (pwd1 != '' && pwd2 == '') {
            null;
        } else if (pwd1 != "" || pwd2 != "") {
            if (pwd1 == pwd2) {
                $("#alert-success").css('display', 'inline-block');
                $("#alert-danger").css('display', 'none');
            } else {
                $("#alert-success").css('display', 'none');
                $("#alert-danger").css('display', 'inline-block');
            }
        }
    });
</script> --%>

<br/>
<h2>Non-essential Data</h2>

</form>
</body>

</html>