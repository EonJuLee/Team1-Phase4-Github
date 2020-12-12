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
<%
	String q = "select login_id, password, account_type, gender, birthdate, address, job, contact, fname, middle, lname, age "+
				"from account where id="+userID;
	try{
		ResultSet rs = stmt.executeQuery(q);
		while(rs.next()){
			out.println("id           : "+rs.getString(1)+"</br>");
			out.println("password     : "+rs.getString(2)+"</br>");
			out.println("account type : "+rs.getString(3)+"</br>");
			out.println("gender       : "+rs.getString(4)+"</br>");
			out.println("birthdate    : "+rs.getString(5)+"</br>");
			out.println("age          : "+rs.getString(12)+"</br>");
			out.println("address      : "+rs.getString(6)+"</br>");
			out.println("job          : "+rs.getString(7)+"</br>");
			out.println("contact      : "+rs.getString(8)+"</br>");
			out.println("first name   : "+rs.getString(9)+"</br>");
			out.println("middle name  : "+rs.getString(10)+"</br>");
			out.println("last name    : "+rs.getString(11)+"</br>");
		}
		rs.close();
	}catch(Exception e){
		e.printStackTrace();
	}
	
%>
</body>
</html>