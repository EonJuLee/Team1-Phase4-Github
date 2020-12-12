<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>
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
	String movie_id = request.getParameter("mID");
	try {
	    String sql = "delete from movie where id=" + movie_id;
	    int res = stmt.executeUpdate(sql);
	    if (res > 0) {
	        conn.commit();
	        %>
			<script>
		     	alert("You successfully deleted movie");
		     	location.href = "ViewAllMovieInfo.jsp"
		    </script>
	    <%
	    } else {
	    	%>
			<script>
		     	alert("You failed to delete movie");
		     	location.href = "AdminPage.jsp"
		    </script>
	    <%
	    }
	} catch (Exception e) {
	    
	}

%>