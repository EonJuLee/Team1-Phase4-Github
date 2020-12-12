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
	
	// give attributes to other pages
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

<!-- For check value in movies -->
<script type="text/javascript">
	function goViewAllTVPage() {
		location.href="ViewAllTV.jsp";
	}
</script>

<!-- Form starts here -->
<h2>Episode Information</h2>
<% 
	String movie_id = request.getParameter("mID");
	try {
	    String sql = "select * from episode where movie_id=" + movie_id;
	    System.out.println(sql);
	    boolean flag = false;
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
	       String tid=rs.getString(2);
	        
	       out.println("<tr>");
	       for(int i=1;i<column_count;i++) {
	     	 	out.println("<td>"+rs.getString(i)+"</td>");
	        }
	       out.println("<td><form action=\"EditEpisodePage.jsp\">");
			 out.println("<input type=\"hidden\" name=\"mID\" value=\""+rs.getString(1)+"\" />");
			 out.println("<input type=\"hidden\" name=\"eID\" value=\""+rs.getString(2)+"\" />");
			 out.println("<input type=\"submit\" value=\"Edit\"/>");
			 out.println("</form></td>");
			 out.println("<td><form action=\"DeleteEpisodePage.jsp\">");
			 out.println("<input type=\"hidden\" name=\"mID\" value=\""+rs.getString(1)+"\" />");
			 out.println("<input type=\"hidden\" name=\"eID\" value=\""+rs.getString(2)+"\" />");
			 out.println("<input type=\"submit\" value=\"Delete\"/>");
			 out.println("</form></td>");
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
<%
out.println("<form action=\"AddEpisodePage.jsp\">");
out.println("<input type=\"hidden\" name=\"mID\" value=\""+movie_id+"\" />");
out.println("<input type=\"submit\" value=\"Add\"/>");
out.println("</form>");
%>
<br/>
<script>
function goBack() {
  window.history.back();
}
</script>
<input type="button" value="Back to Previous Page" onclick="location.href='ViewAllTV.jsp'"/>

</body>
</html>