<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>

<%
	// session variables
	// get variables from account page
	String id = (String) session.getAttribute("id");
	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
	int userID = (int) session.getAttribute("userID");
	
	// to give attributes to other pages
	session.setAttribute("id", id);
	session.setAttribute("isAdmin", isAdmin);
	session.setAttribute("userID", userID);
%>

<%
	String url = "jdbc:postgresql://localhost/jsy";
	String DBid = "jsy";
	String DBpw = "jsy";
	
	Connection conn = null;
	Statement stmt = null;

	try {
	    Class.forName("org.postgresql.Driver");
	    conn = DriverManager.getConnection(url, DBid, DBpw);
	    conn.setAutoCommit(false);
	    stmt = conn.createStatement();
	} catch (Exception e) {
	    e.printStackTrace();
	    System.err.println("ERROR : failed login postgresql");
	}
%>

<% 
	request.setCharacterEncoding("EUC-KR");
	String pw = request.getParameter("pw");
	
	String q = "update password from account where login_id=\'" + id + "\'";
	// System.out.println(q);

	try{
		int res = stmt.executeUpdate(q);
	   if (res > 0) {
	    	conn.commit();
		%>
	    	<script>
	        	alert("You successfully update account password.");
	        	location.href = "AccountPage.jsp"
	        </script>
	     <%
	    }else {
	    	%>
	    	<script>
	    		alert("You failed to update account password.");
	    		location.href = "EditPassword.jsp"
	    	</script>
	    <%	
	    }
	}catch(Exception e){
		e.printStackTrace();
	}
%>