<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>

<%
	
	// get variables from account page
	String id = (String) session.getAttribute("id");
	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
	int userID = (int) session.getAttribute("userID");
	String movie_id=(String)session.getAttribute("movie_id");
	
	// to give attributes to other pages
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

<% 
	
	// 1. initialize variables
	request.setCharacterEncoding("EUC-KR");
	int episode_id=0;
	String eptitle = request.getParameter("title");
	String season = request.getParameter("season");
	String epnum = request.getParameter("epnum");
	String upload_date = request.getParameter("upload_date");
	String start_year=upload_date.substring(0,4);
	String runtime=request.getParameter("runtime");
	
	
	// check primary key (title, country) is unique
	try {
		String sql = "select max(id) from episode";
        ResultSet rs = stmt.executeQuery(sql);
        if (rs.next()) {
        	 episode_id = rs.getInt(1) + 1;
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
	
	
	
	// 2. Add new version
	String q = String sql = "insert into episode values(" + movie_id + ", " + episode_id + ", " + season + ", " + epnum + ", '"
            + eptitle + "', " + runtime + ", " + "to_date('" + upload_date + "','yyyy-mm-dd'))";
	// System.out.println(q);

	try{
		int res = stmt.executeUpdate(q);
	   if (res > 0) {
	    	conn.commit();
		%>
	    	<script>
	        	alert("You successfully add new episode of movie.");
	        	location.href = "AdminPage.jsp"
	        </script>
	     <%
	    }else {
	    	%>
	    	<script>
	    		alert("You failed to add new episode of movie.");
	    		location.href = "AddEpisodePage.jsp"
	    	</script>
	    <%	
	    }
	}catch(Exception e){
		e.printStackTrace();
	}
%>