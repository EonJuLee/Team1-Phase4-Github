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
String q = "select age from account where id ="+userID;
String uAge = null;
try{
	ResultSet rs = stmt.executeQuery(q);
	while(rs.next()){
		uAge = rs.getString(1);
	}
	rs.close();
}catch(Exception e){
	e.printStackTrace();
}
%>
<h2>recommend 1.1 : Top 10 / Best Rated at your age</h2>
<%
if(uAge==null){
	out.println("You didn't entered your age information</br>");
}else{
	q = "select m.id, m.title, m.rating"+
			" from movie m, rating r, account a"+
			" where m.id = r.movie_id and r.account_id=a.id"+
			" and a.age/10 = "+Integer.parseInt(uAge)/10+
			" and m.id not in"+
			" (select distinct(mm.id)"+
			" from movie mm, rating rr"+
			" where mm.id = rr.movie_id and rr.account_id = "+userID+")"+
			" group by m.id"+
			" order by m.rating desc"+
			" limit 10";
	System.out.println(q);
	printTable(conn, q, out);
}
%>
<h2>recommend 1.2 : Top 10 / Most Rated at your age</h2>
<%
if(uAge==null){
	out.println("You didn't entered your age information</br>");
}else{
	q = "select m.id, m.title, count(*) as rated_number"+
			" from movie m, rating r, account a"+
			" where m.id = r.movie_id and r.account_id=a.id"+
			" and a.age/10 = "+Integer.parseInt(uAge)/10+
			" and m.id not in"+
			" (select distinct(mm.id)"+
			" from movie mm, rating rr"+
			" where mm.id = rr.movie_id and rr.account_id = "+userID+")"+
			" group by m.id"+
			" order by count(*) desc"+
			" limit 10";
	System.out.println(q);
	printTable(conn, q, out);
}
%>
<h2>recommend 2.1 : Top 10 / Best Rated</h2>
<%
	q = "select m.id, m.title, m.rating, count(*) as rated_number"+
			" from movie m, rating r"+
			" where m.id = r.movie_id"+
					" and m.id not in"+
					" (select distinct(mm.id)"+
					" from movie mm, rating rr"+
					" where mm.id = rr.movie_id and rr.account_id = "+userID+")"+
			" group by m.id"+
			" order by m.rating desc"+
			" limit 10";
	printTable(conn, q, out);
%>
<h2>recommend 2.2 : Top 10 / Most Rated</h2>
<%
	q = "select m.id, m.title, count(*) as rated_number"+
			" from movie m, rating r"+
			" where m.id = r.movie_id"+
					" and m.id not in"+
					" (select distinct(mm.id)"+
					" from movie mm, rating rr"+
					" where mm.id = rr.movie_id and rr.account_id = "+userID+")"+
			" group by m.id"+
			" order by count(*) desc"+
			" limit 10";
	printTable(conn, q, out);
%>
<h2>recommend 3.1 : Top 10 / Best Rated from your Most Rated Movie List</h2>
<%
	q = "select m.id, m.title, m.rating, count(*) as rated_number"+
			" from movie m, rating r, is_in_genre i"+
			" where m.id = r.movie_id"+
			" and m.id=i.movie_id"+
					" and m.id not in"+
					" (select distinct(mm.id)"+
					" from movie mm, rating rr"+
					" where mm.id = rr.movie_id and rr.account_id = "+userID+")"+
			" and i.genre_id=(select i.genre_id"+
			" from movie m, is_in_genre i, rating r"+
			" where m.id=i.movie_id"+
			" and m.id=r.movie_id"+
			" and r.account_id="+userID+
			" group by i.genre_id"+
			" order by count(*) desc"+
			" limit 1)"+
			" group by m.id"+
			" order by m.rating desc"+
			" limit 10";
	printTable(conn, q, out);
%>
<h2>recommend 3.2 : Top 10 / Most Rated from your Most Rated Movie List</h2>
<%
q = "select m.id, m.title, m.rating, count(*) as rated_number"+
		" from movie m, rating r, is_in_genre i"+
		" where m.id = r.movie_id"+
		" and m.id=i.movie_id"+
				" and m.id not in"+
				" (select distinct(mm.id)"+
				" from movie mm, rating rr"+
				" where mm.id = rr.movie_id and rr.account_id = "+userID+")"+
		" and i.genre_id=(select i.genre_id"+
		" from movie m, is_in_genre i, rating r"+
		" where m.id=i.movie_id"+
		" and m.id=r.movie_id"+
		" and r.account_id="+userID+
		" group by i.genre_id"+
		" order by count(*) desc"+
		" limit 1)"+
		" group by m.id"+
		" order by count(*) desc"+
		" limit 10";
	printTable(conn, q, out);
%>
<script type="text/javascript">
function goBack() {
  window.history.back();
}
</script>
<input type="button" value="Back to Previous Page" onclick="return goBack()"/>
</body>
</html>