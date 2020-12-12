<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>
<html>
<%
	// session variables
	String id = (String) session.getAttribute("id");
	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
	int userID = (int) session.getAttribute("userID");
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
	
try {
	String q = "delete from account where id =" + userID;
    int res = stmt.executeUpdate(q);
    
	    if (res > 0) {
	    	conn.commit();
	    	session.removeAttribute("id");
	    	session.removeAttribute("isAdmin");
	    	session.removeAttribute("userID");
	    	%>
	    	<script>
	        	alert("You successfully deleted account");
	        	location.href = "WelcomePage.jsp"
	        </script>
	        <%
	    } 
	    else {
	    	%>
	    	<script>
		    	alert("You failed to delete account");
		    	location.href = "AccountPage.jsp"
		    </script>
		    <%
	    }
	    
	}catch (Exception e) {
          System.err.println("ERROR FROM withdrawal");
          e.printStackTrace();
    }
%>
</html>
