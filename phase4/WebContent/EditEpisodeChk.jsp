<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>
<%
	// get variables from account page
	String id = (String) session.getAttribute("id");
	Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
	int userID = (int) session.getAttribute("userID");
	String movie_id=request.getParameter("mID");
	String episode_id=request.getParameter("eID");
	
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
	//1. initialize variables
	request.setCharacterEncoding("EUC-KR");
	String eptitle = request.getParameter("eptitle");
	String season = request.getParameter("season");
	String epnum = request.getParameter("epnum");
	String runtime = request.getParameter("runtime");
	String upload_date = request.getParameter("upload_date");
	String start_year=upload_date.substring(0,4);
	
	// keys and values
	String[] keys = { "id", "season", "epnum", "eptitle", "runtime", "upload_date" };
	String[] inputs=new String[keys.length];
	
	// set values in the input array
	if(season.equals("")) {
		inputs[1]="";
	}
	else {
		inputs[1]=season;
	}
	
	if(epnum.equals("")) {
		inputs[2]="";
	}
	else {
		inputs[2]=epnum;
	}
	
	if(eptitle.equals("")) {
		inputs[3]="";
	}
	else {
		inputs[3]="'"+eptitle+"'";
	}
	
	if(runtime.equals("")) {
		inputs[4]="";
	}
	else {
		inputs[4]=runtime;
	}
	
	
	if(start_year.equals("")) {
		inputs[5]="";
	}
	else {
		inputs[5]="to_date('"+upload_date+"','yyyy-mm-dd')";
	}
	
	// update
	try {
        boolean added = false;
        String sql = "update episode set ";

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
        sql += " where movie_id=" + movie_id + " and id=" + episode_id + "";

        if (added == false) {
        	%>
        	<script>
            	alert("No extra information provided");
            	location.href = "EpisodeInfoPage.jsp"
            </script>
            <%
        } else {
            int res = stmt.executeUpdate(sql);
            if (res > 0) {
            	conn.commit();
            	%>
            	<script>
                	alert("You successfully updated episode");
                	location.href = "EpisodeInfoPage.jsp?mID="+<%=movie_id%>;
                </script>
                <%       
            } else {
            	%>
            	<script>
                	alert("You failed to update episode");
                	location.href = "AdminPage.jsp"
                </script>
                <%
            }
        }
	} catch (Exception e) {
        e.printStackTrace();
	}

%>