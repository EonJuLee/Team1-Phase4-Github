package phase4;

import java.sql.*;
import java.util.Date;
import java.util.ArrayList;
import java.text.*;
import java.util.Calendar;
import java.util.Scanner;

import javax.servlet.jsp.JspWriter;

public class JavaFile {
    static Scanner sc = null;
    static int userID = -1;
    // * determine if user is administrator
    static boolean isAdmin = false;
    
//    public void getQueryResult(Connection conn, String q) {
//    	ResultSet rs = null;
//    	PreparedStatement pstmt = null;
//    	try {
//    		pstmt=conn.prepare
//    	}
//    }

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
    			out.println("</tr>");
    		}
    		out.println("</table>");
    		rs.close();
    		
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    }
    public static void main(String[] args) {
        sc = new Scanner(System.in);
        String url = "jdbc:postgresql://localhost/jsy";
        String id = "jsy";
        String pw = "jsy";
        Connection conn = null;
        Statement stmt = null;
        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, id, pw);
            conn.setAutoCommit(false);
            stmt = conn.createStatement();
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("ERROR : failed login postgresql");
        }

        boolean flag = true;
        while (flag) {
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.println("KNU DB Login Page - comp322");
            System.out.println("1. Sign in");
            System.out.println("2. Sign Up");
            System.out.println("3. Exit");
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.print("Enter Your Order : ");

            String strsel = sc.nextLine();
            if (!isNumber(strsel)) {
                System.out.println("Unexpected input");
                continue;
            }
            int select = Integer.parseInt(strsel);
            switch (select) {
                case 1:
                    signInPage(conn, stmt);
                    break;
                case 2:
                    signUpPage(conn, stmt);
                    break;
                case 3:
                    exitPage();
                    flag = false;
                    break;
                default:
                    System.out.println("Unexpected input");
                    break;
            }
        }
        sc.close();
    }

    public static void setAccountType(String atype) {
        if (atype.equals("Admin"))
            isAdmin = true;
        else
            isAdmin = false;
    }

    public static void signInPage(Connection conn, Statement stmt) {
        // signIn from main
        String id, pw;

        System.out.print("Enter your ID : ");
        id = sc.next();
        System.out.print("Enter your PW : ");
        pw = sc.next();
        try {
            String q = "select login_id, password, id, account_type from account where login_id=\'" + id + "\'";
            ResultSet rs = stmt.executeQuery(q);
            if (rs.next()) {
                if (id.equals(rs.getString(1)) && pw.equals(rs.getString(2))) {
                    userID = rs.getInt(3);
                    System.out.println(userID);
                    setAccountType(rs.getString(4));
                    System.out.println("Login success");
                    rs.close();
                    mainPage(conn, stmt);
                } else {
                    rs.close();
                    System.out.println("Wrong password");
                }
            } else {
                rs.close();
                System.out.println("Wrong Id");
            }
        } catch (Exception e) {
            System.err.println("ERROR FROM signInPage");
            e.printStackTrace();
            System.exit(1);
        }

    }

    public static void signUpPage(Connection conn, Statement stmt) {
        int id = 0, membership_id = 0;
        String login_id, atype, pw, pwchk, contact, fname, lname;

        String q;
        String verifyCode = "12345";

        System.out.print("Enter your login id : ");
        login_id = sc.next();

        // Check login id is not duplicate of others
        try {
            q = "select * from account where login_id=\'" + login_id + "\'";
            ResultSet rs = stmt.executeQuery(q);
            if (rs.next()) {
                rs.close();
                System.out.println("This Id is pre-occupied");
                return;
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        System.out.print("Enter your password : ");
        pw = sc.next();
        System.out.print("Enter your password check : ");
        pwchk = sc.next();

        // Password check
        if (!pw.equals(pwchk)) {
            System.out.println("Password check does not match with password. Retry.");
            return;
        }

        System.out.print("Enter your contact (Format - 01012345678) : ");
        contact = sc.next();
        System.out.print("Enter your first name : ");
        fname = sc.next();
        System.out.print("Enter your last name : ");
        lname = sc.next();

        // Check whether it is admin account
        System.out.print("Enter Admin verified code (Enter ; to skip) : ");
        String inputCode = sc.next();
        if (inputCode.equals(verifyCode)) {
            System.out.println("We found you are administrator. Thank you.");
            atype = "Admin";
        } else {
            atype = "Customer";
        }

        // Find artifical key
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
            if (res > 0) {
                System.out.println("You successfully created new membership.");
            } else {
                System.out.println("You failed to created new membership. Try again");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Insert new account
        try {
            q = "insert into account(id,membership_id,account_type,contact,fname,lname,login_id,password)" + "values("
                    + id + ", " + membership_id + ", '" + atype + "', '" + contact + "', '" + fname + "', '" + lname
                    + "', '" + login_id + "', '" + pw + "')";
            int res = stmt.executeUpdate(q);
            conn.commit();
            if (res > 0) {
                System.out.println("You successfully created new account.");
            } else {
                System.out.println("You failed to created new account.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void exitPage() {
        // exit from main
        // \B8\AE\BCҽ\BA \C1\A4\B8\AE, \B7α׾ƿ\F4
    }

    public static void mainPage(Connection conn, Statement stmt) {
        // mainPage from main
        // \B7α\D7\C0\CE \C8\C4 ȭ\B8\E9
        sc.nextLine();
        boolean flag = true;
        while (flag) {
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.println("KNU DB Main Page - comp322");
            System.out.println("1. Account");
            System.out.println("2. Movie");
            System.out.println("3. Rating");
            System.out.println("4. Sign out"); // 1118 Add
            if (isAdmin == true)
                System.out.println("5. Administrator"); // 1118 Add
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.print("Enter Your Order : ");
            String strsel = sc.nextLine();
            if (!isNumber(strsel)) {
                System.out.println("Unexpected input");
                continue;
            }
            int select = Integer.parseInt(strsel);
            switch (select) {
                case 1:
                    int res = accountPage(conn, stmt);
                    if (res == 1)
                        flag = false;
                    break;
                case 2:
                    moviePage(conn, stmt);
                    break;
                case 3:
                    ratingPage(conn, stmt);
                    break;
                case 4:
                    System.out.println("logout");
                    flag = false;
                    break;
                case 5:
                    if (isAdmin == true)
                        adminPage(conn, stmt);
                    else
                        System.out.println("Unexpected input");
                    break;
                default:
                    System.out.println("Unexpected input");
                    break;
            }
        }
    }

    public static int accountPage(Connection conn, Statement stmt) {
        // accountPage from mainPage
        boolean flag = true;
        while (flag) {
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.println("KNU DB Account Page - comp322");
            System.out.println("1. Edit Account Profile");
            System.out.println("2. Withdrawal");
            System.out.println("3. Back to Previous Page");
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.print("Enter Your Order : ");
            String strsel = sc.nextLine();
            if (!isNumber(strsel)) {
                System.out.println("Unexpected input");
                continue;
            }
            int select = Integer.parseInt(strsel);
            switch (select) {
                case 1:
                    editAccount(conn, stmt);
                    break;
                case 2:
                    withdrawal(conn, stmt);
                    System.out.println("Your account deleted. Back to Login Page");
                    return 1;
                case 3:
                    System.out.println("Back to Main Page");
                    flag = false;
                    break;
                default:
                    System.out.println("Unexpected input");
                    break;
            }
        }
        return 0;
    }

    public static boolean isNumber(String input) {
        try {
            Integer.parseInt(input);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean isValidDate(String input) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            sdf.parse(input);
        } catch (ParseException e) {
            return false;
        } catch (IllegalArgumentException e) {
            return false;
        }
        return true;
    }

    public static void editAccount(Connection conn, Statement stmt) {
        String[] columns = { "gender", "birthdate", "address", "contact", "job", "fname", "middle", "lname" };
        String[] inputs = new String[columns.length];
        printQueryResult(conn, stmt, "select * from account where id = " + userID, 2);
        while (true) {
            System.out.print("Enter your gender (F or M) (Enter ; to skip) : ");
            inputs[0] = sc.nextLine();
            if (inputs[0].equals("F") || inputs[0].equals("M")) {
                inputs[0] = "\'" + inputs[0] + "\'";
                break;
            } else if (inputs[0].equals(";")) {
                inputs[0] = "\'" + inputs[0] + "\'";
                break;
            } else {
                System.out.println("Unexpected input");
            }
        }

        while (true) {
            System.out.print("Enter your birthdate (YYYY-MM-DD) (Enter ; to skip) : ");
            inputs[1] = sc.nextLine();

            if (isValidDate(inputs[1])) {
                inputs[1] = "TO_DATE(\'" + inputs[1] + "\',\'yyyy-mm-dd\')";
                break;
            } else if (inputs[1].equals(";")) {
                inputs[1] = "\'" + inputs[1] + "\'";
                break;
            } else {
                System.out.println("Unexpected input");
            }
        }

        System.out.print("Enter your address (Enter ; to skip) : ");
        inputs[2] = "\'" + sc.nextLine() + "\'";

        System.out.print("Enter your contact (Essential Information) : ");
        inputs[3] = "\'" + sc.nextLine() + "\'";

        System.out.print("Enter your job (Enter ; to skip) : ");
        inputs[4] = "\'" + sc.nextLine() + "\'";

        System.out.print("Enter your first name (Essential Information) : ");
        inputs[5] = "\'" + sc.nextLine() + "\'";

        System.out.print("Enter your middle name (Enter ; to skip) : ");
        inputs[6] = "\'" + sc.nextLine() + "\'";

        System.out.print("Enter your last name (Essential Information) : ");
        inputs[7] = "\'" + sc.nextLine() + "\'";

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
                System.out.println("You successfully update account profile.");
            } else {
                System.out.println("You failed update account profile.");
            }
            conn.commit();
        } catch (Exception e) {
            System.err.println("ERROR FROM editAccount");
            e.printStackTrace();
        }
    }

    public static void withdrawal(Connection conn, Statement stmt) {
        try {
            String q = "delete from account where id =" + userID;
            int res = stmt.executeUpdate(q);
            if (res > 0) {
                System.out.println("You successfully deleted account profile.");
            } else {
                System.out.println("You failed deleted account profile.");
            }
            userID = -1;
            conn.commit();
        } catch (Exception e) {
            System.err.println("ERROR FROM withdrawal");
            e.printStackTrace();
        }
    }

    public static void moviePage(Connection conn, Statement stmt) {
        // moviePage from mainPage
        boolean flag = true;
        while (flag) {
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.println("KNU DB Movie Page - comp322");
            System.out.println("1. Movie List");
            System.out.println("2. Movie Search");
            System.out.println("3. Back to Previous Page");
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.print("Enter Your Order : ");
            String strsel = sc.nextLine();
            if (!isNumber(strsel)) {
                System.out.println("Unexpected input");
                continue;
            }
            int select = Integer.parseInt(strsel);
            switch (select) {
                case 1:
                    printQueryResult(conn, stmt, "select id, title from movie order by id asc", 2);
                    while (true) {
                        System.out.print("Enter Movie ID to see detail(Enter ; to exit) : ");
                        String n = sc.nextLine();
                        if (n.equals(";"))
                            break;
                        printQueryResult(conn, stmt, "select * from movie where id=" + n, 1);
                    }
                    break;
                case 2:
                    movieSearch(conn, stmt);
                    break;
                case 3:
                    System.out.println("Back to Main Page");
                    flag = false;
                    break;
                default:
                    System.out.println("Unexpected input");
                    break;
            }
        }
    }

    public static void printQueryResult(Connection conn, Statement stmt, String q, int sel) {
        try {
            ResultSet rs = stmt.executeQuery(q);
            ResultSetMetaData rsmd = rs.getMetaData();
            int cn = rsmd.getColumnCount();
            for (int i = 1; i <= cn; i++) {
                System.out.printf("%-20s", rsmd.getColumnName(i));
            }
            System.out.println();
            while (rs.next()) {
                for (int i = 1; i <= cn; i++) {
                    String t = rs.getString(i);
                    if (t == null)
                        t = "null";
                    if (sel == 2 && t.length() > 15)
                        t = t.substring(0, 15) + "...";
                    System.out.printf("%-20s", t);
                }
                System.out.println();
            }
            rs.close();
        } catch (Exception e) {
            System.err.println("ERROR FROM movieList");
            e.printStackTrace();
        }
    }

    public static void movieSearch(Connection conn, Statement stmt) {
        boolean flag = true;
        while (flag) {
            String input;
            String q;
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.println("KNU DB Movie Search Page - comp322");
            System.out.println("1. Search by Movie Title");
            System.out.println("2. Search by Movie Attributes");
            System.out.println("3. Exit");
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.print("Enter Your Order : ");
            String strsel = sc.nextLine();
            if (!isNumber(strsel)) {
                System.out.println("Unexpected input");
                continue;
            }
            int select = Integer.parseInt(strsel);
            switch (select) {
                case 1:
                    System.out.print("Enter Movie Title : ");
                    input = sc.nextLine();
                    q = "select * from movie where title=\'" + input + "\'";
                    printQueryResult(conn, stmt, q, 1);
                    break;
                case 2:
                    // type genre version
                    ArrayList<String> type, genre, version;
                    int[] seltype, selgenre, selversion;
                    String inp;
                    int t;
                    type = new ArrayList<>();
                    genre = new ArrayList<>();
                    version = new ArrayList<>();
                    try {
                        ResultSet rs;
                        rs = stmt.executeQuery("select distinct movie_type from movie");
                        while (rs.next()) {
                            type.add(rs.getString(1));
                        }
                        rs = stmt.executeQuery("select distinct name from genre");
                        while (rs.next()) {
                            genre.add(rs.getString(1));
                        }
                        rs = stmt.executeQuery("select distinct country from version");
                        while (rs.next()) {
                            version.add(rs.getString(1));
                        }
                        rs.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    seltype = new int[type.size()];
                    selgenre = new int[genre.size()];
                    selversion = new int[version.size()];
                    while (true) {
                        for (int i = 0; i < type.size(); i++) {
                            System.out.printf("%d. %s\n", i + 1, type.get(i));
                        }
                        System.out.println("You already selected... ");
                        for (int i = 0; i < type.size(); i++) {
                            if (seltype[i] == 1)
                                System.out.print(" " + type.get(i) + " ");
                        }
                        System.out.println();
                        System.out.print("Select Movie Type(Enter ; to skip) : ");

                        inp = sc.nextLine();
                        if (inp.equals(";"))
                            break;
                        if (!isNumber(inp)) {
                            System.out.println("unexpected input");
                            continue;
                        }
                        t = Integer.parseInt(inp);
                        if (t <= 0 || t > type.size())
                            continue;
                        t--;
                        if (seltype[t] == 1) {
                            System.out.print("you already selected. remove?(y/n) : ");
                            inp = sc.nextLine();
                            if (inp.equals("y") || inp.equals("Y"))
                                seltype[t] = 0;
                        } else {
                            seltype[t] = 1;
                        }
                    }
                    while (true) {
                        for (int i = 0; i < genre.size(); i++) {
                            System.out.printf("%d. %s\n", i + 1, genre.get(i));
                        }
                        System.out.println("You already selected... ");
                        for (int i = 0; i < genre.size(); i++) {
                            if (selgenre[i] == 1)
                                System.out.print(" " + genre.get(i) + " ");
                        }
                        System.out.println();
                        System.out.print("Select Movie genre(Enter ; to skip) : ");

                        inp = sc.nextLine();
                        if (inp.equals(";"))
                            break;
                        if (!isNumber(inp)) {
                            System.out.println("unexpected input");
                            continue;
                        }
                        t = Integer.parseInt(inp);
                        if (t <= 0 || t > genre.size())
                            continue;
                        t--;
                        if (selgenre[t] == 1) {
                            System.out.print("you already selected. remove?(y/n) : ");
                            inp = sc.nextLine();
                            if (inp.equals("y") || inp.equals("Y"))
                                selgenre[t] = 0;
                        } else {
                            selgenre[t] = 1;
                        }
                    }
                    while (true) {
                        for (int i = 0; i < version.size(); i++) {
                            System.out.printf("%d. %s\n", i + 1, version.get(i));
                        }
                        System.out.println("You already selected... ");
                        for (int i = 0; i < version.size(); i++) {
                            if (selversion[i] == 1)
                                System.out.print(" " + version.get(i) + " ");
                        }
                        System.out.println();
                        System.out.print("Select Movie version(Enter ; to skip) : ");

                        inp = sc.nextLine();
                        if (inp.equals(";"))
                            break;
                        if (!isNumber(inp)) {
                            System.out.println("unexpected input");
                            continue;
                        }
                        t = Integer.parseInt(inp);
                        if (t <= 0 || t > version.size())
                            continue;
                        t--;
                        if (selversion[t] == 1) {
                            System.out.print("you already selected. remove?(y/n) : ");
                            inp = sc.nextLine();
                            if (inp.equals("y") || inp.equals("Y"))
                                selversion[t] = 0;
                        } else {
                            selversion[t] = 1;
                        }
                    }
                    q = "select m.id, m.title, m.movie_type, g.name, v.country from movie m, version v, is_in_genre i, genre g"
                            + " where m.id=i.movie_id and v.movie_id = m.id and g.id=i.genre_id";
                    q += " and (";
                    for (int i = 0; i < type.size(); i++) {
                        if (seltype[i] == 1) {
                            if (q.charAt(q.length() - 1) != '(')
                                q += " or";
                            q += " m.movie_type=\'" + type.get(i) + "\'";
                        }
                    }
                    q += ") and (";
                    for (int i = 0; i < genre.size(); i++) {
                        if (selgenre[i] == 1) {
                            if (q.charAt(q.length() - 1) != '(')
                                q += " or";
                            q += " g.name=\'" + genre.get(i) + "\'";
                        }
                    }
                    q += ") and (";
                    for (int i = 0; i < version.size(); i++) {
                        if (selversion[i] == 1) {
                            if (q.charAt(q.length() - 1) != '(')
                                q += " or";
                            q += " v.country=\'" + version.get(i) + "\'";
                        }
                    }
                    q += ")";
                    printQueryResult(conn, stmt, q + " order by m.id asc", 2);
                    break;
                case 3:
                    System.out.println("Back to Main Page");
                    flag = false;
                    break;
                default:
                    System.out.println("Unexpected input");
                    break;
            }
        }
    }

    public static void viewMyRates(Connection conn, Statement stmt) {
        String sql = "select m.title, r.rating from movie m, rating r " + "where r.movie_id=m.id and r.account_id='"
                + userID + "'";
        try {
            boolean flag = true;
            ResultSet rs = stmt.executeQuery(sql);

            System.out.format("%-30s %-10s\n", "Movie Title", "Rating");
            while (rs.next()) {
                flag = false;
                String title = rs.getString(1);
                if (title.length() >= 20)
                    title = title.substring(0, 15) + "...";
                float rating = rs.getFloat(2);
                System.out.format("%-30s %-10.2f\n", title, rating);
            }
            if (flag) {
                System.out.println("No ratings have been given yet.");
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error while getting rates from database");
        }
    }

    // 1117 Add
    public static void viewAllRates(Connection conn, Statement stmt) {
        String sql = "select m.title, a.login_id, r.rating from movie m, rating r, account a "
                + "where r.movie_id=m.id and r.account_id=a.id";
        try {
            boolean flag = true;
            ResultSet rs = stmt.executeQuery(sql);

            System.out.format("%-30s %-20s %-10s\n", "Movie Title", "Account_id", "Rating");
            while (rs.next()) {
                flag = false;
                String title = rs.getString(1);
                if (title.length() >= 20)
                    title = title.substring(0, 15) + "...";
                String login_id = rs.getString(2);
                float rating = rs.getFloat(3);
                System.out.format("%-30s %-20s %-10.2f\n", title, login_id, rating);
            }
            if (flag) {
                System.out.println("No ratings have been given yet.");
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error while getting rates from database");
        }
    }

    // 1117 Add
    public static void ratingPage(Connection conn, Statement stmt) {
        // ratingPage from mainPage
        boolean flag = true;
        while (flag) {
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.println("KNU DB Rating Page - comp322");
            System.out.println("1. View my ratings");
            System.out.println("2. Back to Previous Page");
            if (isAdmin == true)
                System.out.println("3. (Admin) View all ratings");
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.print("Enter Your Order : ");

            int select = sc.nextInt();
            switch (select) {
                case 1:
                    viewMyRates(conn, stmt);
                    break;
                case 2:
                    System.out.println("Back to Main Page");
                    flag = false;
                    break;
                case 3:
                    if (isAdmin == true)
                        viewAllRates(conn, stmt);
                    break;
                // if not Admin, should be passed
                default:
                    System.out.println("Unexpected input");
                    break;
            }
        }
    }

    // 1117 Add
    public static boolean isDuplicate(Statement stmt, String title) {
        boolean flag = false;
        String sql = "select * from movie where title='" + title + "'";
        try {
            ResultSet rs = stmt.executeQuery(sql);
            if (rs.next()) {
                flag = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }

    // 1117 Add
    public static void addNewMovie(Connection conn, Statement stmt) {
        boolean flag = false;
        int id = 0, runtime = 0, start_year = 0, end_year = 0;
        float rating = 0.0f;
        String[] types = { "Movie", "TV Series", "knuMovieDB original" };
        String mtype, title, lang, upload_date;

        // Title
        System.out.print("Enter movie title : ");
        sc.nextLine();
        title = sc.nextLine();
        // sc.nextLine();
        System.out.println(title);

        // Movie type
        System.out.println("[Table] Movie Type");
        for (int i = 0; i < types.length; i++) {
            System.out.println("" + (i + 1) + " - " + types[i]);
        }
        System.out.print("Enter movie_type : ");
        String temp = sc.next();
        if (temp.equals("1") || temp.equals("2") || temp.equals("3")) {
            int itemp = Integer.parseInt(temp);
            mtype = types[itemp - 1];
        } else {
            System.out.println("Wrong movie type number");
            return;
        }

        // Runtime
        System.out.print("Enter runtime : ");
        temp = sc.next();
        if (isNumber(temp) == false) {
            System.out.println("Wrong runtime");
            return;
        }
        runtime = Integer.parseInt(temp);

        // Upload date, start year
        System.out.print("Enter start date (format YYYY-MM-DD) : ");
        temp = sc.next();
        if (isValidDate(temp) == false) {
            System.out.println("Start date is not valid");
            return;
        }
        upload_date = temp;
        start_year = Integer.parseInt(temp.substring(0, 4));
        if (start_year < 1980) {
            System.out.println("Valid movie start year is from 1980.");
            return;
        }

        // End year
        System.out.print("Enter end year if exists (Enter ; to skip) : ");
        temp = sc.next();
        if (temp.equals(";")) {
            flag = true;
        } else {
            if (isNumber(temp) == false) {
                System.out.println("End year should be number");
                return;
            }
            end_year = Integer.parseInt(temp);
            if (end_year < start_year || end_year > 9999) {
                System.out.println("End year is not valid");
                return;
            }
        }

        // Language
        System.out.print("Enter language : ");
        lang = sc.next();

        // Id
        try {
            String sql = "select max(id) from movie";
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                id = rs.getInt(1) + 1;
            }
            rs.close();

        } catch (Exception e) {
            System.out.println("Error while setting new movie id");
        }

        // Add
        try {
            String sql = "insert into movie values(" + id + ", '" + mtype + "', '" + title + "', " + runtime + ", "
                    + start_year + ", " + (flag == true ? "null" : end_year) + ", " + "to_date('" + upload_date
                    + "','yyyy-mm-dd'), " + rating + ", '" + lang + "')";
            int res = stmt.executeUpdate(sql);
            if (res > 0) {
                System.out.println("New movie successfully added");
                conn.commit();
            } else {
                System.out.println("Failed to process");
            }
        } catch (Exception e) {
            System.out.println("Error while adding new movie.");
            e.printStackTrace();
        }

    }

    public static void returnMenu() {
        System.out.println("Press key to return to menu");
        sc.nextLine();
        sc.nextLine();
    }

    public static void addNewVersion(Connection conn, Statement stmt) {
        boolean flag = viewAllMovie(conn, stmt);
        if (flag == false) {
            returnMenu();
            return;
        }

        int movie_id = 0, start_year = 0, end_year = 0;
        String country, title, lang, upload_date, temp;
        flag = false; // end_year is not null

        // movie_id
        System.out.print("Enter the movie id of new version : ");
        movie_id = Integer.parseInt(sc.next());

        // Verify movie_id
        try {
            String sql = "select * from movie where id=" + movie_id;
            ResultSet rs = stmt.executeQuery(sql);
            if (rs.next() == false) {
                System.out.println("Wrong movie_id input");
                return;
            }
        } catch (Exception e) {
            System.out.println("Error while reading movie database");
        }

        // Country
        System.out.print("Enter country : ");
        country = sc.next();
        try {
            String sql = "select * from version where movie_id=" + movie_id + " and country='" + country + "'";
            ResultSet rs = stmt.executeQuery(sql);
            if (rs.next()) {
                System.out.println(country + " version of movie is already added");
                return;
            }
        } catch (Exception e) {
            System.out.println("Error while reading version database");
        }

        // Upload date, start year
        System.out.print("Enter start date (format YYYY-MM-DD) : ");
        temp = sc.next();
        if (isValidDate(temp) == false) {
            System.out.println("Start date is not valid");
            return;
        }
        upload_date = temp;
        start_year = Integer.parseInt(temp.substring(0, 4));
        if (start_year < 1980) {
            System.out.println("Valid movie start year is from 1980.");
            return;
        }

        // End year
        System.out.print("Enter end year if exists (Enter ; to skip) : ");
        temp = sc.next();
        if (temp.equals(";")) {
            flag = true;
        } else {
            if (isNumber(temp) == false) {
                System.out.println("End year should be number");
                return;
            }
            end_year = Integer.parseInt(temp);
            if (end_year < start_year || end_year > 9999) {
                System.out.println("End year is not valid");
                return;
            }
        }
        // Language
        System.out.print("Enter language : ");
        lang = sc.next();

        // Title
        System.out.print("Enter title : ");
        title = sc.nextLine();
        sc.nextLine();

        // Add
        try {
            String sql = "insert into version values(" + movie_id + ", " + "'" + country + "', '" + title + "', '"
                    + lang + "', " + "to_date('" + upload_date + "','yyyy-mm-dd'), " + start_year + ", "
                    + (flag == true ? "null" : end_year) + ")";
            int res = stmt.executeUpdate(sql);
            if (res > 0) {
                System.out.println("New version of movie successfully added");
                conn.commit();
            } else {
                System.out.println("Failed to process");
            }
        } catch (Exception e) {
            System.out.println("Error while adding new version.");
            e.printStackTrace();
        }

    }

    public static void addNewEpisode(Connection conn, Statement stmt) {
        boolean flag = viewAllMovie(conn, stmt);
        if (flag == false) {
            returnMenu();
            return;
        }

        int movie_id = 0, id = 0, season, epnum, runtime;
        String eptitle, upload_date, temp;

        System.out.print("Enter the movie id of new episode : ");
        movie_id = Integer.parseInt(sc.next());

        // Verify movie_id
        try {
            String sql = "select * from movie where id=" + movie_id;
            ResultSet rs = stmt.executeQuery(sql);
            if (rs.next() == false) {
                System.out.println("Wrong movie_id input");
                return;
            }
        } catch (Exception e) {
            System.out.println("Error while reading movie database");
        }

        // id
        try {
            String sql = "select max(id) from episode";
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                id = rs.getInt(1) + 1;
            }
            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error while setting new version id");
        }

        // season
        System.out.print("Enter season number : ");
        temp = sc.next();
        if (isNumber(temp) == false) {
            System.out.println("Wrong runtime");
            return;
        }
        season = Integer.parseInt(temp);

        // epnum
        System.out.print("Enter episode number : ");
        temp = sc.next();
        if (isNumber(temp) == false) {
            System.out.println("Wrong runtime");
            return;
        }
        epnum = Integer.parseInt(temp);

        // runtime
        System.out.print("Enter runtime: ");
        temp = sc.next();
        if (isNumber(temp) == false) {
            System.out.println("Wrong runtime");
            return;
        }
        runtime = Integer.parseInt(temp);

        // eptitle
        System.out.print("Enter episode title : ");
        eptitle = sc.nextLine();
        sc.nextLine();

        // upload_date
        System.out.print("Enter start date (format YYYY-MM-DD) : ");
        temp = sc.next();
        if (isValidDate(temp) == false) {
            System.out.println("Start date is not valid");
            return;
        }
        upload_date = temp;

        // Add
        try {
            String sql = "insert into episode values(" + movie_id + ", " + id + ", " + season + ", " + epnum + ", '"
                    + eptitle + "', " + runtime + ", " + "to_date('" + upload_date + "','yyyy-mm-dd'))";
            int res = stmt.executeUpdate(sql);
            if (res > 0) {
                System.out.println("New version of movie successfully added");
                conn.commit();
            } else {
                System.out.println("Failed to process");
            }
        } catch (Exception e) {
            System.out.println("Error while adding new version.");
            e.printStackTrace();
        }

    }

    // 1118 Add
    public static boolean viewAllMovie(Connection conn, Statement stmt) {
        boolean flag = false;
        String sql = "select id, title from movie order by id asc";
        try {
            System.out.println("[Table] Movie Id & Title");
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                flag = true;
                String id = rs.getString(1);
                String title = rs.getString(2);
                if (title.length() >= 20) {
                    title = title.substring(0, 15) + "...";
                }
                System.out.format("%-5s %-30s\n", id, title);
            }
            rs.close();
            if (flag == false) {
                System.out.println("No Movie available");
            }

        } catch (Exception e) {
            System.out.println("Error while loading all movies");
            return false;
        }
        return flag;
    }

    public static boolean viewAllEpisode(Connection conn, Statement stmt, String movie_id) {
        boolean flag = false;
        String sql = "select id,eptitle from episode where movie_id=" + movie_id + " order by movie_id asc";
        try {
            System.out.println("[Table] Episode ID & Title");
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                flag = true;
                String id = rs.getString(1);
                String title = rs.getString(2);
                if (title.length() >= 20)
                    title = title.substring(0, 15) + "...";
                System.out.format("%-5s %-30s\n", id, title);
            }
            rs.close();
            if (flag == false) {
                System.out.println("No episode found");
            }
        } catch (Exception e) {
            System.out.println("Error while loading movie versions");
            return false;
        }
        return flag;
    }

    public static boolean viewAllTV(Connection conn, Statement stmt) {
        boolean flag = false;
        String sql = "select id, title from movie where movie_type='TV Series' order by id asc";
        try {
            System.out.println("[Table] Movie Id & Title");
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                flag = true;
                String id = rs.getString(1);
                String title = rs.getString(2);
                if (title.length() >= 20) {
                    title = title.substring(0, 15) + "...";
                }
                System.out.format("%-5s %-30s\n", id, title);
            }
            rs.close();
            if (flag == false) {
                System.out.println("No Movie available");
            }

        } catch (Exception e) {
            System.out.println("Error while loading all movies");
            return false;
        }
        return flag;
    }

    // 1117 Add
    public static void editMovieInfo(Connection conn, Statement stmt) {
        boolean flag = viewAllMovie(conn, stmt);
        String movie_id;
        if (flag == false) {
            returnMenu();
            return;
        }

        // key and inputs
        String[] keys = { "ID", "Movie_type", "Title", "Runtime", "Start_year", "End_year", "Upload_date", "Language" };
        String[] inputs = new String[keys.length];
        int start_year = 0, end_year = 0;

        System.out.print("Enter the movie id you want to change: ");
        movie_id = sc.next();

        // Verify movie_id
        try {
            String sql = "select * from movie where id=" + movie_id;
            ResultSet rs = stmt.executeQuery(sql);
            if (rs.next()) {
                for (int i = 0; i < 20; i++)
                    System.out.print("-");
                System.out.println();
                System.out.println(movie_id + " Movie Info");
                for (int i = 0; i < keys.length; i++) {
                    String value = rs.getString(i + 1);
                    if (i == 4)
                        start_year = Integer.parseInt(value);
                    if (i == 5 && value != null)
                        end_year = Integer.parseInt(value);
                    if (value == null)
                        value = "null";
                    System.out.format("%-15s %-30s\n", keys[i], value);
                }
                for (int i = 0; i < 20; i++)
                    System.out.print("-");
                System.out.println("");
            } else {
                System.out.println("Wrong movie_id input");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error while reading movie database");
        }

        System.out.println("1. Change Info");
        System.out.println("2. Delete");
        String temp = sc.next();
        if (isNumber(temp) == false) {
            System.out.println("It is not a number");
            return;
        }

        int det = Integer.parseInt(temp);

        // Update
        if (det == 1) {

            // Movie type
            String[] types = { "Movie", "TV Series", "knuMovieDB original" };
            System.out.println("[Table] Movie Type");
            for (int i = 0; i < types.length; i++) {
                System.out.println("" + (i + 1) + "-" + types[i]);
            }
            System.out.print("Enter movie type(; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[1] = "";
            } else if (isNumber(temp) == false) {
                System.out.println("Wrong input type");
                return;
            } else if (temp.equals("1") || temp.equals("2") || temp.equals("3")) {
                int itemp = Integer.parseInt(temp);
                inputs[1] = "'" + types[itemp - 1] + "'";
            } else {
                System.out.println("Wrong input type");
                return;
            }

            // Title
            System.out.print("Enter movie title(; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[2] = "";
            } else {
                inputs[2] = "'" + temp + "'";
            }

            // Runtime
            System.out.print("Enter runtime(; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[3] = "";
            } else if (isNumber(temp) == false) {
                System.out.println("Wrong input type");
                return;
            } else {
                inputs[3] = temp;
            }

            // start_year
            System.out.print("Enter start date (format YYYY-MM-DD) ; to skip: ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[4] = "";
                inputs[6] = "";
            } else if (isValidDate(temp) == false) {
                System.out.println("Wrong input type");
                return;
            } else {
                inputs[6] = "to_date('" + temp + "', 'yyyy-mm-dd')";
                inputs[4] = temp.substring(0, 4);
                start_year = Integer.parseInt(inputs[4]);
                if (start_year < 1980) {
                    System.out.println("Valid movie start year is from 1980");
                    return;
                }
            }

            // end_year
            System.out.print("Enter end year (; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[5] = "";
                if (start_year > end_year) {
                    System.out.println("Start year should be proir to end eyar");
                    return;
                }
            } else if (isNumber(temp) == false) {
                System.out.println("Wrong input type");
                return;
            } else {
                end_year = Integer.parseInt(temp);
                if (end_year < start_year || end_year > 9999) {
                    System.out.println("End year is not valid");
                    return;
                }
                inputs[5] = "" + end_year;
            }

            // language
            System.out.print("Enter language (; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[7] = "";
            } else {
                inputs[7] = "'" + temp + "'";
            }

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

                if (added == false) {
                    System.out.println("No addition occurred");
                } else {
                    int res = stmt.executeUpdate(sql);
                    if (res > 0) {
                        System.out.println("You successfully updated movie");
                        conn.commit();
                    } else {
                        System.out.println("You failed to update movie");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Delete
        else if (det == 2) {
            System.out.print("Are you sure to delete this data?(y/n)");
            String answer = sc.next();
            if (answer.equals("y")) {
                try {
                    String sql = "delete from movie where id=" + movie_id;
                    int res = stmt.executeUpdate(sql);
                    if (res > 0) {
                        System.out.println("You successfully deleted movie");
                        conn.commit();
                    } else {
                        System.out.println("You failed to delete movie");
                    }
                } catch (Exception e) {
                    System.out.println("Error while deleting the data");
                }
            } else if (answer.equals("n")) {
                System.out.println("Cancel deleting");
            } else {
                System.out.println("This direction is not supported");
            }
        }

        else {
            System.out.println("You inserted wrong number");
        }
    }

    public static boolean viewAllVersion(Connection conn, Statement stmt, String movie_id) {
        boolean flag = false;
        String sql = "select country,title from version where movie_id=" + movie_id + " order by movie_id asc";
        try {
            System.out.println("[Table] Version country & Title");
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                flag = true;
                String country = rs.getString(1);
                String title = rs.getString(2);
                if (title.length() >= 20)
                    title = title.substring(0, 15) + "...";
                System.out.format("%-5s %-30s\n", country, title);
            }
            rs.close();
            if (flag == false) {
                System.out.println("No version found");
            }
        } catch (Exception e) {
            System.out.println("Error while loading movie versions");
            return false;
        }
        return flag;
    }

    public static void editVersionInfo(Connection conn, Statement stmt) {
        boolean flag = viewAllMovie(conn, stmt);
        if (flag == false) {
            returnMenu();
            return;
        }

        String[] keys = { "country", "title", "lang", "upload_date", "start_year", "end_year" };
        String[] inputs = new String[keys.length];
        int start_year = 0, end_year = 0;

        System.out.print("Enter the movie id you want to change: ");
        String movie_id = sc.next();

        // Verify movie_id
        try {
            String sql = "select * from movie where id=" + movie_id;
            ResultSet rs = stmt.executeQuery(sql);
            if (rs.next()) {
                flag = viewAllVersion(conn, stmt, movie_id);
                if (flag == false) {
                    returnMenu();
                    return;
                }
            } else {
                System.out.println("Wrong movie_id input");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error while reading movie database");
        }

        System.out.print("Enter the version country you want to change: ");
        String version_country = sc.next();

        // Verify version_country
        try {
            String sql = "select * from version where movie_id=" + movie_id + " and country='" + version_country + "'";
            ResultSet rs = stmt.executeQuery(sql);
            if (rs.next()) {
                for (int i = 0; i < 20; i++)
                    System.out.print("-");
                System.out.println();
                System.out.println(movie_id + " Version Info");
                for (int i = 0; i < keys.length; i++) {
                    String value = rs.getString(i + 2);
                    if (i == 4)
                        start_year = Integer.parseInt(value);
                    if (i == 5 && value != null)
                        end_year = Integer.parseInt(value);
                    if (value == null)
                        value = "null";
                    System.out.format("%-15s %-30s\n", keys[i], value);
                }
                for (int i = 0; i < 20; i++)
                    System.out.print("-");
                System.out.println("");
            } else {
                System.out.println("Wrong version country input");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error while reading version database");
        }

        System.out.println("1. Change Info");
        System.out.println("2. Delete");
        String temp = sc.next();
        if (isNumber(temp) == false) {
            System.out.println("It is not a number");
            return;
        }

        int det = Integer.parseInt(temp);

        // Update
        if (det == 1) {

            // Country
            System.out.print("Enter movie country(; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[0] = "";
            } else {
                inputs[0] = "'" + temp + "'";
            }

            // Title
            System.out.print("Enter movie title(; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[1] = "";
            } else {
                inputs[1] = "'" + temp + "'";
            }

            // Lang
            System.out.print("Enter movie lang(; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[2] = "";
            } else {
                inputs[2] = "'" + temp + "'";
            }

            // start_year
            System.out.print("Enter start date (format YYYY-MM-DD) ; to skip: ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[3] = "";
                inputs[4] = "";
            } else if (isValidDate(temp) == false) {
                System.out.println("Wrong input type");
                return;
            } else {
                inputs[3] = "to_date('" + temp + "', 'yyyy-mm-dd')";
                inputs[4] = temp.substring(0, 4);
                start_year = Integer.parseInt(inputs[4]);
                if (start_year < 1980) {
                    System.out.println("Valid movie start year is from 1980");
                    return;
                }
            }

            // end_year
            System.out.print("Enter end year (; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[5] = "";
                if (start_year > end_year) {
                    System.out.println("Start year should be proir to end eyar");
                    return;
                }
            } else if (isNumber(temp) == false) {
                System.out.println("Wrong input type");
                return;
            } else {
                end_year = Integer.parseInt(temp);
                if (end_year < start_year || end_year > 9999) {
                    System.out.println("End year is not valid");
                    return;
                }
                inputs[5] = "" + end_year;
            }

            // update
            try {
                boolean added = false;
                String sql = "update version set ";

                for (int i = 0; i < inputs.length; i++) {
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
                sql += " where movie_id=" + movie_id + " and country='" + version_country + "'";

                if (added == false) {
                    System.out.println("No addition occurred");
                } else {
                    int res = stmt.executeUpdate(sql);
                    if (res > 0) {
                        System.out.println("You successfully updated version");
                        conn.commit();
                    } else {
                        System.out.println("You failed to update version");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }

        // Delete
        else if (det == 2) {

            System.out.print("Are you sure to delete this data?(y/n)");
            String answer = sc.next();
            if (answer.equals("y")) {
                try {
                    String sql = "delete from version where movie_id=" + movie_id + " and country='" + version_country
                            + "'";
                    int res = stmt.executeUpdate(sql);
                    if (res > 0) {
                        System.out.println("You successfully deleted version");
                        conn.commit();
                    } else {
                        System.out.println("You failed to delete version");
                    }
                } catch (Exception e) {
                    System.out.println("Error while deleting the data");
                }
            } else if (answer.equals("n")) {
                System.out.println("Cancel deleting");
            } else {
                System.out.println("This direction is not supported");
            }
        }

        else {
            System.out.println("You inserted wrong number");
        }
    }

    public static void editEpisodeInfo(Connection conn, Statement stmt) {
        boolean flag = viewAllTV(conn, stmt);
        if (flag == false) {
            returnMenu();
            return;
        }

        String[] keys = { "id", "season", "epnum", "eptitle", "runtime", "upload_date" };
        String[] inputs = new String[keys.length];

        System.out.print("Enter the movie id you want to change: ");
        String movie_id = sc.next();

        // Verify movie_id
        try {
            String sql = "select * from movie where id=" + movie_id;
            ResultSet rs = stmt.executeQuery(sql);
            if (rs.next()) {
                flag = viewAllEpisode(conn, stmt, movie_id);
                if (flag == false) {
                    returnMenu();
                    return;
                }
            } else {
                System.out.println("Wrong movie_id input");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error while reading movie database");
        }

        System.out.print("Enter the episode id you want to change: ");
        String episode_id = sc.next();
        if (isNumber(episode_id) == false) {
            System.out.println("This is not a number");
            return;
        }

        // Verify episode id
        try {
            String sql = "select * from episode where movie_id=" + movie_id + " and id=" + episode_id;
            ResultSet rs = stmt.executeQuery(sql);
            if (rs.next()) {
                for (int i = 0; i < 20; i++)
                    System.out.print("-");
                System.out.println();
                System.out.println(movie_id + " Episode Info");
                for (int i = 0; i < keys.length; i++) {
                    String value = rs.getString(i + 2);
                    if (value == null)
                        value = "null";
                    System.out.format("%-15s %-30s\n", keys[i], value);
                }
                for (int i = 0; i < 20; i++)
                    System.out.print("-");
                System.out.println("");
            } else {
                System.out.println("Wrong episode id");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error while reading episode database");
        }

        System.out.println("1. Change Info");
        System.out.println("2. Delete");
        String temp = sc.next();
        if (isNumber(temp) == false) {
            System.out.println("It is not a number");
            return;
        }

        int det = Integer.parseInt(temp);

        // Update
        if (det == 1) {

            // Season
            System.out.print("Enter Season(; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[1] = "";
            } else if (isNumber(temp) == false) {
                System.out.println("Wrong input type");
                return;
            } else {
                inputs[1] = temp;
            }

            // epnum
            System.out.print("Enter episode number(; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[2] = "";
            } else if (isNumber(temp) == false) {
                System.out.println("Wrong input type");
                return;
            } else {
                inputs[2] = temp;
            }

            // eptitle
            // Title
            System.out.print("Enter episode title(; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[3] = "";
            } else {
                inputs[3] = "'" + temp + "'";
            }

            // runtime
            System.out.print("Enter runtime(; to skip) : ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[4] = "";
            } else if (isNumber(temp) == false) {
                System.out.println("Wrong input type");
                return;
            } else {
                inputs[4] = temp;
            }

            // start_year
            System.out.print("Enter start date (format YYYY-MM-DD) ; to skip: ");
            temp = sc.next();
            if (temp.equals(";")) {
                inputs[5] = "";
            } else if (isValidDate(temp) == false) {
                System.out.println("Wrong input type");
                return;
            } else {
                inputs[5] = "to_date('" + temp + "', 'yyyy-mm-dd')";
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
                    System.out.println("No addition occurred");
                } else {
                    int res = stmt.executeUpdate(sql);
                    if (res > 0) {
                        System.out.println("You successfully updated episode");
                        conn.commit();
                    } else {
                        System.out.println("You failed to update episode");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }

        // Delete
        else if (det == 2) {
            System.out.print("Are you sure to delete this data?(y/n)");
            String answer = sc.next();
            if (answer.equals("y")) {
                try {
                    String sql = "delete from episode where movie_id=" + movie_id + " and id=" + episode_id;
                    int res = stmt.executeUpdate(sql);
                    if (res > 0) {
                        System.out.println("You successfully deleted episode");
                        conn.commit();
                    } else {
                        System.out.println("You failed to delete episode");
                    }
                } catch (Exception e) {
                    System.out.println("Error while deleting the data");
                }
            } else if (answer.equals("n")) {
                System.out.println("Cancel deleting");
            } else {
                System.out.println("This direction is not supported");
            }
        }

        else {
            System.out.println("You inserted wrong number");
        }

    }

    // 1117 Add
    public static void adminPage(Connection conn, Statement stmt) {
        // adminPage from mainPage
        boolean flag = true;
        while (flag) {
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.println("KNU DB Administrator Page - comp322");
            System.out.println("1. Add New Movie");
            System.out.println("2. Add New Version");
            System.out.println("3. Add New Episode");
            System.out.println("4. Edit Movie Information");
            System.out.println("5. Edit Version Information");
            System.out.println("6. Edit Episode Information");
            System.out.println("7. Back to Previous Page");
            for (int i = 0; i < 20; i++)
                System.out.print("-");
            System.out.println();
            System.out.print("Enter Your Order : ");

            int select = sc.nextInt();
            switch (select) {
                case 1:
                    addNewMovie(conn, stmt);
                    break;
                case 2:
                    addNewVersion(conn, stmt);
                    break;
                case 3:
                    addNewEpisode(conn, stmt);
                    break;
                case 4:
                    editMovieInfo(conn, stmt);
                    break;
                case 5:
                    editVersionInfo(conn, stmt);
                    break;
                case 6:
                    editEpisodeInfo(conn, stmt);
                    break;
                case 7:
                    System.out.println("Back to Main Page");
                    flag = false;
                    break;
                default:
                    System.out.println("Unexpected input");
                    break;
            }
        }
    }

    public static void logoutPage() {
        // logoutPage from mainPage
    }
}