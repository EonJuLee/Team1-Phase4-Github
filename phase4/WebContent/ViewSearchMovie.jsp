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
			String t = rsmd.getColumnName(i);
			if(t.equals("name")) t="genre";
			if(t.equals("movie_type")) t="movie type";
			if(t.equals("country")) t="version";
			out.println("<th>"+rsmd.getColumnName(i)+"</th>");
		}
		while(rs.next()){
			out.println("<tr>");
			for(int i=1;i<=sz;i++){
				out.print("<td>");
				out.println(rs.getString(i));
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
String[] seltype=request.getParameterValues("type");
String[] selgenre=request.getParameterValues("genre");
String[] selversion=request.getParameterValues("version");

String q = "select m.id, m.title, m.movie_type, g.name, v.country from movie m, version v, is_in_genre i, genre g"+
           " where m.id=i.movie_id and v.movie_id = m.id and g.id=i.genre_id"+
			" and m.id not in"+
			" (select distinct(mm.id)"+
			" from movie mm, rating rr"+
			" where mm.id = rr.movie_id and rr.account_id = "+userID+")";
		
boolean chk = false;
if(seltype!=null){
	q += " and (";
	for (int i = 0; i < seltype.length; i++) {
		seltype[i] = seltype[i].replaceAll("\n", "").replaceAll("\r","");
		if (q.charAt(q.length() - 1) != '(')
			q += " or";
		System.out.println(seltype[i]);
		q += " m.movie_type=\'" + seltype[i] + "\'";
	}
	q+=")";
}
if(selgenre!=null){
	q += " and (";
	for (int i = 0; i < selgenre.length; i++) {
		selgenre[i] = selgenre[i].replaceAll("\n", "").replaceAll("\r","");
		if (q.charAt(q.length() - 1) != '(')
			q += " or";
		q += " g.name=\'" + selgenre[i] + "\'";
	}
	q+=")";
}
if(selversion!=null){
	q += " and (";
	for (int i = 0; i < selversion.length; i++) {
		selversion[i] = selversion[i].replaceAll("\n", "").replaceAll("\r","");
		if (q.charAt(q.length() - 1) != '(')
			q += " or";
		q += " v.country=\'" + selversion[i] + "\'";
	}
	q+=")";
}
System.out.println(q);
printTable(conn, q + " order by m.id asc", out);
%>
<script type="text/javascript">
function goBack() {
  window.history.back();
}
</script>
<input type="button" value="Back to Previous Page" onclick="return goBack()"/>
</body>
</html>