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
String[] columns = { "gender", "birthdate", "address", "contact", "job", "fname", "middle", "lname" };
String[] inputs=new String[columns.length];
int info_length=columns.length;
	
request.setCharacterEncoding("EUC-KR");

for(int i=0;i<info_length;i++) {
	inputs[i]=request.getParameter(columns[i]);
}
	
	// gender
if (inputs[0].equals("F") || inputs[0].equals("M")) {
	inputs[0] = "\'" + inputs[0] + "\'";
} else if (inputs[0].equals("")) {
	inputs[0] = "\'" + inputs[0] + "\'";
} else {
	System.out.println("Unexpected input");
}
	 
	 // date
	 
if (JavaFile.isValidDate(inputs[1])) {
	inputs[1] = "TO_DATE(\'" + inputs[1] + "\',\'yyyy-mm-dd\')";
} else if (inputs[1].equals("")) {
	inputs[1] = "\'" + inputs[1] + "\'";
} else {
	System.out.println("Unexpected input");
}
	  
for(int i=2;i<info_length;i++) {
	inputs[i]="'" + inputs[i] + "'";
}
	  
	  
	  // start query
	  
try {
	String q = "update account set ";
	int cnt = -1;
	for (int i = 0; i < inputs.length; i++) {
		if (!inputs[i].equals("';'")) {
			cnt = i;
		}
	}
	if (cnt == -1)
		return;
	for (int i = 0; i < inputs.length; i++) {
		if (inputs[i].equals("';'"))
			continue;

		q += columns[i] + "=" + inputs[i];
		if (i == cnt)
			continue;
		q += ", ";
	}

	q += " where id=" + userID;
	int res = stmt.executeUpdate(q);
	if (res > 0) {
		conn.commit();
        	 
		// generating script request
		%>
		<script>
			alert("You successfully update account profile.");
			location.href = "AccountPage.jsp";
		</script>
		<%
	} else {
		%>
		<script>
			alert("You failed update account profile.");
			location.href = "EditProfilePage.jsp"
		</script>
		<%
	}
} catch (Exception e) {
	System.err.println("ERROR FROM editAccount");
	e.printStackTrace();
}	 
%>