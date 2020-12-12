<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile, java.util.Date, java.util.Calendar" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
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
String q;
int id = 0, membership_id = 0;
String[] columns = { "gender", "birthdate", "admincode", "login_id","password", "address", "contact", "job", "fname", "middle", "lname" };
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
	inputs[0] = "\'\'";
} else {
	inputs[0] = "\'\'";
	System.out.println("Unexpected input");
}
	 
// date
if (JavaFile.isValidDate(inputs[1])) {
	inputs[1] = "TO_DATE(\'" + inputs[1] + "\',\'yyyy-mm-dd\')";
} else if (inputs[1].equals("")) {
	inputs[1] = "\'\'";
} else {
	inputs[1] = "\'\'";
	System.out.println("Unexpected input");
}

//admin code
columns[2]="account_type";
String validcode = "12345";
if (inputs[2].equals(validcode)){
	inputs[2]="\'Admin\'";
}else{
	inputs[2]="\'Customer\'";
}

for(int i=3;i<info_length;i++) {
	inputs[i]="\'" + inputs[i] + "\'";
}

	  
//Find artifical key
try {
    int temp = 0;
    stmt = conn.createStatement();
    q = "select max(id) from account";
    ResultSet rs = stmt.executeQuery(q);
    if (rs.next()) {
        temp = rs.getInt(1);
    }
    id = temp + 1;
    rs.close();
} catch (Exception e) {
    e.printStackTrace();
}

// memebership id
try {
    int temp = 0;
    stmt = conn.createStatement();
    q = "select max(id) from membership";
    ResultSet rs = stmt.executeQuery(q);
    if (rs.next()) {
        temp = rs.getInt(1);
    }
    membership_id = temp + 1;
    rs.close();
} catch (Exception e) {
    e.printStackTrace();
}

// Insert new membership
try {
    // Get membership start_date and end_date
    // end_date = start_date + (3 years)
    Date date = new Date();
    SimpleDateFormat dformat = new SimpleDateFormat("yyyy-MM-dd");
    String start_date = dformat.format(date);

    Calendar calendar = Calendar.getInstance();
    calendar.setTime(date);
    calendar.add(Calendar.YEAR, 3);
    String end_date = dformat.format(calendar.getTime());

    q = "insert into membership " + "values(" + membership_id + ", 'Basic', " + "to_date('" + start_date
            + "', 'yyyy-mm-dd'), to_date('" + end_date + "', 'yyyy-mm-dd'))";
    int res = stmt.executeUpdate(q);
    conn.commit();
} catch (Exception e) {
    e.printStackTrace();
}
	  // start query
	  
try {
	q = "insert into account(";
	q += "id,membership_id,";
	for (int i = 0; i < columns.length; i++) {
		q += columns[i];
		if(i!=columns.length-1) q+=',';
	}
	q+=") values(";
	q+=id+","+membership_id+",";
	for (int i = 0; i < inputs.length; i++) {
		if(inputs[i].equals("\'\'")) inputs[i] = "null";
		q += inputs[i];
		if(i!=columns.length-1) q+=',';
	}
	q+=")";
	System.out.println(q);int res = stmt.executeUpdate(q);
	if (res > 0) {
		conn.commit();
        	 
		// generating script request
		%>
		<script>
			alert("You successfully Signed up.");
			location.href = "SignInPage.jsp";
		</script>
		<%
	} else {
		%>
		<script>
			alert("You failed Sign up.");
			location.href = "WelcomePage.jsp"
		</script>
		<%
	}
	
	
} catch (Exception e) {
	System.err.println("ERROR FROM editAccount");
	e.printStackTrace();
}	 
%>
</body>
</html>