<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
</head>
<body>
<h1>Edit Password</h1>

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

<!-- For check value in password -->

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
	String sql = "select m.title, a.login_id, r.rating from movie m, rating r, account a "
			   + "where r.movie_id=m.id and r.account_id=a.id";
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		pstmt=conn.prepareStatement(sql);
		rs=pstmt.executeQuery();
		
		out.println("<table border=\"1\">");
		ResultSetMetaData rsmd=rs.getMetaData();
		
		int cnt=rsmd.getColumnCount();
		for(int i=1;i<=cnt;i++){
			out.println("<th>"+rsmd.getColumnName(i)+"</th>");
		}
		
		while(rs.next()){
			out.println("<tr>");
			
			String title=rs.getString(1);
			float rating=rs.getFloat(3);
			
			 if (title.length() >= 30)
	             title = title.substring(0, 25) + "...";
			
			out.println("<td>"+title+"</td>");
			out.println("<td>"+rs.getString(2)+"</td>");
			out.println("<td>"+rating+"</td>");
			out.println("</tr>");
		}
		
		out.println("</table>");
		rs.close();
		pstmt.close();
		conn.close();
	}
	catch(Exception e) {
		
	}
%>
<input type="button" value="Back to Rating Page" onclick="location.href='RatingPage.jsp'"/>
</body>
</html>
