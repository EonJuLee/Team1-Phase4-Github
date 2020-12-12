<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile, java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
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
ArrayList<String> type, genre, version;

type = new ArrayList<>();
genre = new ArrayList<>();
version = new ArrayList<>();
try {
    ResultSet rs;
    rs = stmt.executeQuery("select distinct movie_type from movie");
    while (rs.next()) {
        type.add(rs.getString(1));
    }
    rs = stmt.executeQuery("select distinct name from genre");
    while (rs.next()) {
        genre.add(rs.getString(1));
    }
    rs = stmt.executeQuery("select distinct country from version");
    while (rs.next()) {
        version.add(rs.getString(1));
    }
    rs.close();
} catch (Exception e) {
    e.printStackTrace();
}
%>
<script type="text/javascript">
	function checkValue1() {
		if(!document.byTitle.mTitleSel) {
			alert("please enter your password");
			return false;
		}
	}
</script>
<hr/>
<h2>Search by Movie Title</h2>
<form method="post" action="ViewMovieSearchByTitle.jsp" name="byTitle" onSubmit="return checkValue()">
including <input type="radio" name="mTitleSel" value="including"/>
identical <input type="radio" name="mTitleSel" value="identical"/>
<br/>
<input type="text" name="mTitle"/> 
<input type="submit" value="Search"/>
</form>
<hr/>
<h2>Search by Movie Attributes</h2>
<form method="post" action="ViewSearchMovie.jsp">
<%
out.println("<h4>movie type</h4>");
for(String t : type){
	out.println(t);
	out.println("<input type=\"checkbox\" name=\"type\" value=\"");
	out.println(t);
	out.println("\"/>");
}
out.println("<br/>");
out.println("<h4>genre</h4>");
for(String t : genre){
	out.println(t);
	out.println("<input type=\"checkbox\" name=\"genre\" value=\"");
	out.println(t);
	out.println("\"/>");
}
out.println("<br/>");
out.println("<h4>genre</h4>");
for(String t : version){
	out.println(t);
	out.println("<input type=\"checkbox\" name=\"version\" value=\"");
	out.println(t);
	out.println("\"/>");
}
out.println("<br/>");
%>
<input type="submit" value="Search"/>
</form>
<script type="text/javascript">
function goBack() {
  window.history.back();
}
</script>
<input type="button" value="Back to Previous Page" onclick="return goBack()"/>
</body>
</html>