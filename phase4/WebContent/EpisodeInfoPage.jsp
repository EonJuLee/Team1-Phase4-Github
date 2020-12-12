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
	function goViewAllTVPage() {
		location.href="ViewAllTV.jsp";
	}
	
	function goAddEpisodePage(movie_id) {
		session.setAttribute("movie_id", movie_id);
		location.href="AddEpisodePage.jsp";
	}
	
	function goEditEpisodePage(id) {
		session.setAttribute("episode_id",id);
		location.href="EditEpisodePage.jsp";
	}
	
	function goDeleteEpisodePage(id) {
		session.setAttribute("episode_id",id);
		location.href="DeleteEpisodePage.jsp";
	}
</script>

<!-- Form starts here -->
<h2>Episode Information</h2>
<% 
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
	        for(int i=2;i<column_count;i++) {
	        	out.println("<td>"+rs.getString(i)+"</td>");
	        }
	        out.println("<td>"+"<input type='button' value='Edit' onClick='goEditEpisodePage("+tid+")'/>"+"</td>");
	        out.println("<td>"+"<input type='button' value='Delete' onClick='goDeleteEpisodePage("+tid+")'/>"+"</td>");
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
<input type='button' value='Add' onClick="goAddEpisodePage(movie_id)"/>
<br/>
<input type="button" value="Back to List" onclick="goViewAllTV()">

</body>
</html>