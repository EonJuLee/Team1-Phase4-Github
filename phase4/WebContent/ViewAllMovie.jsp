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
<%!
public void printTable(Connection conn, String q, JspWriter out){
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	try{
		pstmt = conn.prepareStatement(q);
		rs = pstmt.executeQuery();
	}catch(Exception e){
		e.printStackTrace();
	}
	try{
		out.println("<table border=\"1\">");
		ResultSetMetaData rsmd = rs.getMetaData();
		int sz = rsmd.getColumnCount();
		for(int i=1;i<=sz;i++){
			out.println("<th>"+rsmd.getColumnName(i)+"</th>");
		}
		while(rs.next()){
			out.println("<tr>");
			for(int i=1;i<=sz;i++){
				out.print("<td>");
				if(rsmd.getColumnName(i).equals("HOURS")) out.println(String.format("%.1f", rs.getFloat(i)));
				else out.println(rs.getString(i));
				out.println("</td>");
			}
			out.println("<td><form action=\"ViewMovieDetail.jsp\">");
			out.println("<input type=\"hidden\" name=\"mID\" value=\""+rs.getString(1)+"\" />");
			out.println("<input type=\"submit\" value=\"View Detail\"/>");
			out.println("</form></td>");
			out.println("</tr>");
		}
		out.println("</table>");
		rs.close();
		
	}catch(Exception e){
		e.printStackTrace();
	}
}
%>
<%
	printTable(conn, "select id, title from movie order by id asc", out);
%>
<input type="button" value="Back to Previous Page" onclick="location.href='MoviePage.jsp'"/><br/>
</body>
</html>