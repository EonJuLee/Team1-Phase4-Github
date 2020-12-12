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
	//0. get stored_start_year, stored_end_year
	String movie_id = request.getParameter("mID");
	
	String stored_start_year="0", stored_end_year="0";
	try {
	    String sql = "select start_year, end_year from movie where id=" + movie_id;
	    System.out.println(sql);
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
	String title = request.getParameter("title");
	String type = request.getParameter("type");
	String runtime = request.getParameter("runtime");
	String language = request.getParameter("language");
	String upload_date = request.getParameter("upload_date");
	String end_year = request.getParameter("end_year");
	String start_year=upload_date.substring(0,4);
	System.out.println(stored_start_year);
	System.out.println(end_year);
	if(!end_year.equals("") && Integer.parseInt(stored_start_year)>Integer.parseInt(end_year) && start_year.equals("")) {
		%>
		<script>
	     	alert("end year is before than start year in the database");
	     	location.href = "EditMoviePage.jsp"
        </script>
        <%
	}
	if(!start_year.equals("") && !end_year.equals("") && Integer.parseInt(start_year)>Integer.parseInt(end_year)) {
		%>
		<script>
	     	alert("end year is before than start year now");
	     	location.href = "EditMoviePage.jsp"
	    </script>
    <%
	}
	
	// keys and values
	String[] keys = { "ID", "Movie_type", "Title", "Runtime", "Start_year", "End_year", "Upload_date", "Lang" };
	String[] inputs=new String[keys.length];
	
	
	
	// set values in the input array
	if(type.equals("")) {
		inputs[1]="";
	}
	else {
		inputs[1]="'"+type+"'";
	}
	
	if(title.equals("")) {
		inputs[2]="";
	}
	else {
		inputs[2]="'"+title+"'";
	}
	
	if(runtime.equals("")) {
		inputs[3]="";
	}
	else {
		inputs[3]=runtime;
	}
	
	if(start_year.equals("")) {
		inputs[4]="";
		inputs[6]="";
	}
	else {
		inputs[4]=start_year;
		inputs[6]="to_date('"+upload_date+"','yyyy-mm-dd')";
	}
	
	if(end_year.equals("")) {
		inputs[5]="";
	}
	else {
		inputs[5]=end_year;
	}
	
	if(language.equals("")) {
		inputs[7]="";
	}
	else {
		inputs[7]="'"+language+"'";
	}
	
	// update
	try {
        boolean added = false;
        String sql = "update movie set ";

        for (int i = 1; i < inputs.length; i++) {
            if (inputs[i].equals("")) {
                continue;
            } else {
                if (added == false)
                    added = true;
                else
                    sql += ", ";
                sql += keys[i] + "=" + inputs[i];
            }
        }
        sql += " where id=" + movie_id;
		System.out.println(sql);
        if (added == false) {
        	%>
        	<script>
            	alert("No extra information provided");
            	location.href = "ViewAllMovieInfo.jsp"
            </script>
            <%
        } else {
            int res = stmt.executeUpdate(sql);
            if (res > 0) {
            	conn.commit();
            	%>
            	<script>
                	alert("You successfully updated movie");
                	location.href = "ViewAllMovieInfo.jsp"
                </script>
                <%       
            } else {
            	%>
            	<script>
                	alert("You failed to update movie");
                	location.href = "AdminPage.jsp"
                </script>
                <%
            }
        }
	} catch (Exception e) {
        e.printStackTrace();
	}

%>