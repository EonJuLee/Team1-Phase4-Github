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
	String movie_id=request.getParameter("mID");
	String title = request.getParameter("title");
	String country = request.getParameter("country");
	String language = request.getParameter("language");
	String upload_date = request.getParameter("upload_date");
	String end_year = request.getParameter("end_year");
	String start_year=upload_date.substring(0,4);
	
	// check optional field
	boolean flag=false;
	if(end_year.equals("")) {
		flag=true;
	}
	
	// check primary key (title, country) is unique
	try {
        String sql = "select * from version where movie_id=" + movie_id + " and country='" + country + "'";
        ResultSet rs = stmt.executeQuery(sql);
        if (rs.next()) {
        	%>
        	<script>
            	alert(country + " version of movie is already added");
            	location.href = "AddVersionPage.jsp"
            </script>
            <%
        }
    } catch (Exception e) {
    	%>
    	<script>
        	alert("Check the server connection");
        	location.href = "AdminPage.jsp"
        </script>
        <%
    }
	
	
	
	// 2. Add new version
	String q = "insert into version values(" + movie_id + ", " + "'" + country + "', '" + title + "', '"
            + language + "', " + "to_date('" + upload_date + "','yyyy-mm-dd'), " + start_year + ", "
            + (flag == true ? "null" : end_year) + ")";
	// System.out.println(q);

	try{
		int res = stmt.executeUpdate(q);
	   if (res > 0) {
	    	conn.commit();
		%>
	    	<script>
	        	alert("You successfully add new version of movie.");
	        	location.href = "VersionInfoPage.jsp?mID="+<%=movie_id%>
	        </script>
	     <%
	    }else {
	    	%>
	    	<script>
	    		alert("You failed to add new version of movie.");
	    		location.href = "AddVersionPage.jsp"
	    	</script>
	    <%	
	    }
	}catch(Exception e){
		e.printStackTrace();
	}
%>