<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
String rating = request.getParameter("rating");
String mID = request.getParameter("mID");
int rID = 0;
String q;
try {
    int temp = 0;
    q = "select max(id) from rating";
    ResultSet rs = stmt.executeQuery(q);
    if (rs.next()) {
        temp = rs.getInt(1);
    }
    rID = temp + 1;
    rs.close();
} catch (Exception e) {
    e.printStackTrace();
}
q = "insert into rating values("+rID+","+userID+","+mID+","+rating+")";
try{
	int res = stmt.executeUpdate(q);
	if (res > 0) {
		conn.commit();
        	 
		// generating script request
		%>
		<script>
			alert("You successfully rated movie.");
			location.href = "MoviePage.jsp";
		</script>
		<%
	} else {
		%>
		<script>
			alert("You failed update rated movie.");
			location.href = "WelcomPage.jsp"
		</script>
		<%
	}
}catch(Exception e){
	e.printStackTrace();
}
%>
</body>
</html>