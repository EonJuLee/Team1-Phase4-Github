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
	//0. get stored_start_year, stored_end_year
	String stored_start_year=0, stored_end_year=0;
	try {
	    String sql = "select start_year, end_year from movie where id=" + movie_id;
	    ResultSet rs = stmt.executeQuery(sql);
	    if (rs.next()) {
	        stored_start_year=rs.getString(1);
	        stored_end_year=rs.getString(2);
	    } 
	    rs.close();
	} catch (Exception e) {
	    e.printStackTrace();
	}

	
	//1. initialize variables
	request.setCharacterEncoding("EUC-KR");
	int id=0;
	String title = request.getParameter("title");
	String type = request.getParameter("type");
	String runtime = request.getParameter("runtime");
	String language = request.getParameter("language");
	String upload_date = request.getParameter("upload_date");
	String end_year = request.getParameter("end_year");
	String start_year=upload_date.substring(0,4);
	
	if(!upload_date.equals("")) {
		upload_date="to_date('" + upload_date + "', 'yyyy-mm-dd')";
	}
	if(Integer.parseInt(stored_start_year)>Integer.parseInt(end_year)) {
		<script>
	     	alert("end year is before than start year in the database");
	     	location.href = "EditMoviePage.jsp"
        </script>
	}
	if(Integer.parseInt(start_year)>Integer.parseInt(end_year)&&!start_year.equals("")) {
		<script>
	     	alert("end year is before than start year now");
	     	location.href = "EditMoviePage.jsp"
    </script>
	}
	
	// 여기서부터해야함
	// keys and values
	String[] keys = { "ID", "Movie_type", "Title", "Runtime", "Start_year", "End_year", "Upload_date", "Language" };
	String[] inputs=new String[keys.length];
	
	// 2. set new movie id
	try {
     String sql = "select max(id) from movie";
     ResultSet rs = stmt.executeQuery(sql);
     while (rs.next()) {
         id = rs.getInt(1) + 1;
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
	
	
	String q = "insert into movie values(" + id + ", '" + type + "', '" + title + "', " + runtime + ", "
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