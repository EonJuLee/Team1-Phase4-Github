<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>

<%
	// session variables
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
	
	// 1. initialize variables
	request.setCharacterEncoding("EUC-KR");
	int tid=0;
	String title = request.getParameter("title");
	String type = request.getParameter("type");
	String runtime = request.getParameter("runtime");
	String language = request.getParameter("language");
	String upload_date = request.getParameter("upload_date");
	String end_year = request.getParameter("end_year");
	String start_year=upload_date.substring(0,4);
	String rating="0";
	
	// check optional field
	boolean flag=false;
	if(end_year.equals("")) {
		flag=true;
	}
	
	
	
	// 2. set new movie id
	try {
        String sql = "select max(id) from movie";
        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next()) {
            tid = rs.getInt(1) + 1;
        }
        rs.close();

    } catch (Exception e) {
    	%>
    	<script>
        	alert("Check the server connection");
        	location.href = "AdminPage.jsp"
        </script>
        <%
    }
	
	
	String q = "insert into movie values(" + tid + ", '" + type + "', '" + title + "', " + runtime + ", "
            + start_year + ", " + (flag == true ? "null" : end_year) + ", " + "to_date('" + upload_date
            + "','yyyy-mm-dd'), " + rating + ", '" + language + "')";
	// System.out.println(q);

	try{
		int res = stmt.executeUpdate(q);
	   if (res > 0) {
	    	conn.commit();
		%>
	    	<script>
	        	alert("You successfully add new movie.");
	        	location.href = "AdminPage.jsp"
	        </script>
	     <%
	    }else {
	    	%>
	    	<script>
	    		alert("You failed to add new movie.");
	    		location.href = "AddMoviePage.jsp"
	    	</script>
	    <%	
	    }
	}catch(Exception e){
		e.printStackTrace();
	}
%>