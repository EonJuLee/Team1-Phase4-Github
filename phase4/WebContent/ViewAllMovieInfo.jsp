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

<script type="text/javascript">
	function goAddMoviePage() {
		location.href="AddMoviePage.jsp";
	}
</script>

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

<h2>View All Movie</h2>
<h3>Select movie of the version you want to manage</h3>
<input type='button' value='Add Movie' onClick='goAddMoviePage()'/>
<br/>
<% 
	String sql = "select id, title from movie order by id asc";
	boolean flag = false;
	try {
	    out.println("<table border=\"1\">");
	    ResultSet rs = stmt.executeQuery(sql);
	    ResultSetMetaData rsmd=rs.getMetaData();
	    int column_count=rsmd.getColumnCount();
	    
	    // print header of table
	    for(int i=1;i<=column_count;i++) {
	    	out.println("<th>"+rsmd.getColumnName(i)+"</th>");
	    }
	    
	    while (rs.next()) {
	        flag = true;
	        out.println("<tr>");
	        String tid = rs.getString(1);
	        String title = rs.getString(2);
	        
	        out.println("<td>"+tid+"</td>");
	        out.println("<td>"+title+"</td>");
	        out.println("<td><form action=\"EditMoviePage.jsp\">");
			out.println("<input type=\"hidden\" name=\"mID\" value=\""+rs.getString(1)+"\" />");
			out.println("<input type=\"submit\" value=\"Edit\"/>");
			out.println("</form></td>");
			out.println("<td><form action=\"DeleteMoviePage.jsp\">");
			out.println("<input type=\"hidden\" name=\"mID\" value=\""+rs.getString(1)+"\" />");
			out.println("<input type=\"submit\" value=\"Delete\"/>");
			out.println("</form></td>");
			out.println("<td><form action=\"VersionInfoPage.jsp\">");
			out.println("<input type=\"hidden\" name=\"mID\" value=\""+rs.getString(1)+"\" />");
			out.println("<input type=\"submit\" value=\"Version Info\"/>");
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
<input type="button" value="Back to Previous Page" onclick="location.href='AdminPage.jsp'"/>