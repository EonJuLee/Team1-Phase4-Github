<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>

<body>

<%
	// get variables from ViewAllMoviePage
	String id = (String) session.getAttribute("id");
	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
	int userID = (int) session.getAttribute("userID");
	String movie_id=(String)session.getAttribute("movie_id");
	
	// give attributes to other pages
	session.setAttribute("id", id);
	session.setAttribute("isAdmin", isAdmin);
	session.setAttribute("userID", userID);
	session.setAttribute("movie_id",movie_id);
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

<!-- For check value in movies -->
<script type="text/javascript">
	function goViewAllMoviePage() {
		location.href="ViewAllMovieInfo.jsp";
	}
	
	function goAddVersionPage(movie_id) {
		session.setAttribute("movie_id", movie_id);
		location.href="AddVersionPage.jsp";
	}
	
	function goEditVersionPage(country) {
		session.setAttribute("country", country);
		location.href="EditVersionPage.jsp";
	}
	
	function goDeleteVersionPage(country) {
		session.setAttribute("country", country);
		location.href="DeleteVersionPage.jsp";
	}
</script>

<!-- Form starts here -->
<h2>Version Information</h2>
<% 
	try {
	    String sql = "select * from version where movie_id=" + movie_id;
	    boolean flag= false;
	    out.println("<table border=\"1\">");
	    ResultSet rs = stmt.executeQuery(sql);
	    ResultSetMetaData rsmd=rs.getMetaData();
	    int column_count=rsmd.getColumnCount();
	    
	    // print header of table
	    for(int i=2;i<=column_count;i++) {
	    	out.println("<th>"+rsmd.getColumnName(i)+"</th>");
	    }
	    
	    while (rs.next()) {
	        flag = true;
	        String country=rs.getString(2);
	        
	        out.println("<tr>");
	        for(int i=2;i<column_count;i++) {
	        	out.println("<td>"+rs.getString(i)+"</td>");
	        }
	        out.println("<td>"+"<input type='button' value='Edit' onClick='goEditVersionPage(country)'/>"+"</td>");
	        out.println("<td>"+"<input type='button' value='Delete' onClick='goDeleteVersionPage(country)'/>"+"</td>");
	        out.println("</tr>");
	    }
	    rs.close();
	    if (flag == false) {
	        out.println("<td align='center' colspan='3'>No entry found</td>");
	    }
	    out.println("</table>");
	} catch (Exception e) {
		%>
    	<script>
        	alert("Check the server connection");
        	location.href = "AdminPage.jsp"
        </script>
        <%
	}
%>

<%-- Info for movie --%>
<input type='button' value='Add' onClick='goAddVersionPage(movie_id)'/>
<br/>
<input type="button" value="Back to List" onclick="goViewAllMoviePage()">

</body>
</html>