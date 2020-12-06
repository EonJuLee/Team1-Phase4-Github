<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.text.*, java.sql.*, phase4.JavaFile" %>
<!DOCTYPE html>
<%
String url = "jdbc:postgresql://localhost/jsy";
String id = "jsy";
String pw = "jsy";
Connection conn = null;
Statement stmt = null;
try {
    System.out.println("!!");
    Class.forName("org.postgresql.Driver");
    System.out.println("!!");
    conn = DriverManager.getConnection(url, id, pw);
    conn.setAutoCommit(false);
    stmt = conn.createStatement();
} catch (Exception e) {
    e.printStackTrace();
    System.err.println("ERROR : failed login postgresql");
}
%>
<%
request.setCharacterEncoding("EUC-KR");
String eID = request.getParameter("id");
String ePW = request.getParameter("pw");

int userID = -1;
boolean isAdmin = false;
try {
    String q = "select login_id, password, id, account_type from account where login_id=\'" + eID + "\'";
    System.out.println(q);
    
    ResultSet rs = stmt.executeQuery(q);
    if (rs.next()) {
        if (eID.equals(rs.getString(1)) && ePW.equals(rs.getString(2))) {
            userID = rs.getInt(3);
            System.out.println(userID);
            if(rs.getString(4).equals("Admin")) isAdmin = true;
            System.out.println("Login success");
            session.setAttribute("id", eID);
            session.setAttribute("isAdmin", isAdmin);
            session.setAttribute("userID", userID);
            rs.close();
            %>
            <script>
            alert("Login Success");
            location.href = "MainPage.jsp"
            </script>
            <%
        } else {
            rs.close();
            %>
            <script>
            alert("Login Failed : Wrong password");
            location.href = "SignInPage.jsp"
            </script>
            <%
        }
    } else {
        rs.close();
        %>
        <script>
        alert("Login Failed : Wrong Id");
        location.href = "SignInPage.jsp"
        </script>
        <%
    }
} catch (Exception e) {
    System.err.println("ERROR FROM signInPage");
    e.printStackTrace();
    System.exit(1);
}
%>