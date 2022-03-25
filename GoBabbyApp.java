import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

public class GoBabbyApp
{
    private static Connection con;

    public static void main(String[] args)
    {

        connect();

        while(true)
        {

            String pracid = fetchMidWife();
            ArrayList<Appointment> appointments = fetchAppointments(pracid);
            while(!getOptions(appointments))
            {
                appointments = fetchAppointments(pracid);
            }

        }
    }

    private static void prescribeTest(String appId, String cid, int pregnum)
    {
        System.out.println("Please enter the type of the test:");
        Scanner sc = new Scanner(System.in);
        String type = sc.nextLine();
        Statement stmt = createStmt(con);
        assert stmt != null;
        try
        {
            Long randId = new Random().nextLong();
            LocalDate date = LocalDate.now();
            java.util.Date tmp = new java.util.Date(System.currentTimeMillis());
            String time = new SimpleDateFormat("HH:mm:ss").format(tmp);
            String s1 = "INSERT INTO Test (testid, type, testdate, result, sampletime, sampleaid, " +
                    "tid, babynum, babyofpregnum, babyofcid, pregnum, cid, prescribeaid, prescribedate) VALUES ";
            String s = s1 + String.format("('%1$s', '%2$s', %3$s, %4$s, '%5$s', '%6$s', " +
                    "'%7$s', %8$s, %9$s, '%10$s', %11$s, '%12$s', '%13$s', '%14$s')",
                    randId, type, null, null, time, appId, "tech001", null, null, null, pregnum, cid, appId, date);
            stmt.executeUpdate(s);
            System.out.println();
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        finally
        {
            closeStmt(stmt);
        }
    }

    private static void addNote(String appId)
    {
        System.out.println("Please type your observation:");
        Scanner sc = new Scanner(System.in);
        String obs = sc.nextLine();
        System.out.println();
        Statement stmt = createStmt(con);
        assert stmt != null;
        try
        {
            String s1 = "INSERT INTO Note (notetime, aid, observations) VALUES ";
            java.util.Date tmp = new java.util.Date(System.currentTimeMillis());
            String time = new SimpleDateFormat("HH:mm:ss").format(tmp);
            String s = s1 + String.format("('%1$s', '%2$s', '%3$s')", time, appId, obs);
            stmt.executeUpdate(s);
            System.out.println();
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        finally
        {
            closeStmt(stmt);
        }
    }

    private static void fetchTests(String appId, String cid, int pregnum)
    {
        Statement stmt = createStmt(con);
        assert stmt != null;
        try
        {
            String s = String.format("SELECT t.prescribedate, t.type, t.result " +
                    "FROM Appointment a, Test t, Pregnancy p " +
                    "WHERE t.prescribeaid = a.aid AND a.aid = '%1$s' AND a.cid = p.cid AND a.cid = '%2$s' " +
                    "AND a.pregnum = p.pregnum AND a.pregnum = %3$s", appId, cid, pregnum);
            s = s + " ORDER BY prescribedate DESC";
            ResultSet rs = stmt.executeQuery(s);
            int ctr = 0;
            while(rs.next())
            {
                java.util.Date date = rs.getDate("prescribedate");
                String type = rs.getString("type");
                String res = rs.getString("result");
                if(res == null)
                {
                    System.out.println("" + date + " [" + type + "] PENDING");
                }
                else
                {
                    System.out.println("" + date + " [" + type + "] " + res.substring(0, Math.min(res.length(), 50)));
                }
                ctr ++;
            }
            if(ctr == 0)
            {
                System.out.println("No tests found with the associated pregnancy!");
            }
            System.out.println();
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        finally
        {
            closeStmt(stmt);
        }
    }

    private static void fetchNotes(String appId, String cid, int pregnum)
    {
        Statement stmt = createStmt(con);
        assert stmt != null;
        try
        {
            String s = String.format("SELECT a.appdate, n.notetime, n.observations " +
                        "FROM Appointment a, Note n, Pregnancy p " +
                        "WHERE n.aid = a.aid AND a.aid = '%1$s' AND a.cid = p.cid AND a.cid = '%2$s' " +
                        "AND a.pregnum = p.pregnum AND a.pregnum = %3$s", appId, cid, pregnum);
            s = s + " ORDER BY appdate, notetime DESC";
            ResultSet rs = stmt.executeQuery(s);
            int ctr = 0;
            while(rs.next())
            {
                java.util.Date date = rs.getDate("appdate");
                Time time = rs.getTime("notetime");
                String obs = rs.getString("observations");
                System.out.println("" + date + " " + time + " " + obs.substring(0, Math.min(obs.length(), 50)));
                ctr ++;
            }
            if(ctr == 0)
            {
                System.out.println("No notes found with the associated pregnancy!");
            }
            System.out.println();
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        finally
        {
            closeStmt(stmt);
        }
    }

    private static boolean displayMenu(String name, String hcnum, String appId, String cid, int pregnum)
    {
        while(true)
        {
            System.out.println("For " + name + " " + hcnum + "\n");
            System.out.println("1. Review notes\n" +
                    "2. Review tests\n" +
                    "3. Add a note\n" +
                    "4. Prescribe a test\n" +
                    "5. Go back to the appointments.\n");
            System.out.println("Enter your choice:");
            Scanner sc = new Scanner(System.in);
            int choice = sc.nextInt();
            System.out.println();
            switch(choice)
            {
                case 1:
                    fetchNotes(appId, cid, pregnum);
                    break;
                case 2:
                    fetchTests(appId, cid, pregnum);
                    break;
                case 3:
                    addNote(appId);
                    break;
                case 4:
                    prescribeTest(appId, cid, pregnum);
                    break;
                case 5:
                    return true;
                default:
                    System.out.println("Invalid choice, please choose again!");
            }
        }
    }

    private static boolean getOptions(ArrayList<Appointment> appointments)
    {
        assert appointments != null;

        while(true)
        {
            System.out.println("Enter the appointment number (row number) that you would like to work on.");
            System.out.println("Enter [E] to exit, [D] to go back to another date");
            Scanner sc = new Scanner(System.in);
            String input = sc.next();
            System.out.println();
            if(input.equalsIgnoreCase("E"))
            {
                closeCon();
            }
            else if(input.equalsIgnoreCase("D"))
            {
                return false;
            }
            else
            {
                int rowNum = Integer.parseInt(input);
                if(rowNum < 0 || rowNum > appointments.size())
                {
                    System.out.println("Appointment with row number " + rowNum + " does not exist, please re-enter!");
                }
                else
                {
                    String appId = null, name = null, hcnum = null, cid = null;
                    int pregnum = -1;
                    for(int i=0; i<appointments.size(); i++)
                    {
                        if(i == rowNum)
                        {
                            Appointment app = appointments.get(i);
                            appId = app.appId;
                            name = app.name;
                            hcnum = app.hcnum;
                            cid = app.cid;
                            pregnum = app.pregnum;
                        }
                    }

                    // if user choose 5 in displayMenu, show all appointments again
                    if(displayMenu(name, hcnum, appId, cid, pregnum))
                    {
                        showAppointments(appointments);
                    }
                }
            }
        }
    }

    private static void showAppointments(ArrayList<Appointment> apps)
    {
        for(int i=0; i<apps.size(); i++)
        {
            Appointment app = apps.get(i);
            System.out.println(i + ":  " + app.time + " " + app.type + " " + app.name + " " + app.hcnum);
        }
    }

    private static ArrayList<Appointment> fetchAppointments(String pracid)
    {
        assert pracid != null;

        while(true)
        {
            Statement stmt = createStmt(con);
            assert stmt != null;
            try
            {
                System.out.println("Please enter the date for appointment list, [E] to exit:");
                Scanner sc = new Scanner(System.in);
                String input = sc.next();
                System.out.println();
                if(input.equalsIgnoreCase("E"))
                {
                    closeAll(stmt);
                }
                else
                {
                    java.util.Date tmp = new SimpleDateFormat("yyyy-MM-dd").parse(input);
                    java.sql.Date appDate = new java.sql.Date(tmp.getTime());
                    String s1 = String.format("((SELECT a.apptime, 'P' AS type, m.name, m.hcnum, a.aid, a.cid, a.pregnum " +
                                "FROM Appointment a, Mother m, Pregnancy p, Couple c " +
                                "WHERE c.mhcnum = m.hcnum AND c.cid = p.cid AND a.cid = p.cid AND a.pregnum = p.pregnum " +
                                "AND a.pracid = p.primarypracid AND a.pracid = '%1$s' AND a.appdate = '%2$s')", pracid, appDate);
                    String s2 = String.format("(SELECT a.apptime, 'B' AS type, m.name, m.hcnum, a.aid, a.cid, a.pregnum " +
                                "FROM Appointment a, Mother m, Pregnancy p, Couple c WHERE " +
                                "c.mhcnum = m.hcnum AND c.cid = p.cid AND a.cid = p.cid AND a.pregnum = p.pregnum " +
                                "AND a.pracid = p.backuppracid AND a.pracid = '%1$s' AND a.appdate = '%2$s'))", pracid, appDate);
                    String s = s1 + "UNION" + s2 + " ORDER BY apptime";
                    ResultSet rs = stmt.executeQuery(s);
                    int ctr = 0;
                    ArrayList<Appointment> appointments = new ArrayList<>();
                    while(rs.next())
                    {
                        Time time = rs.getTime("apptime");
                        String type = rs.getString("type");
                        String name = rs.getString("name");
                        String hcnum = rs.getString("hcnum");
                        String appId = rs.getString("aid");
                        String cid = rs.getString("cid");
                        int pregnum = rs.getInt("pregnum");
                        appointments.add(new Appointment(time, type, name, hcnum, appId, cid, pregnum));
                        ctr ++;
                    }
                    if(ctr == 0)
                    {
                        System.out.println("No appointments found on date " + input + "! Please re-enter date.");
                    }
                    else
                    {
                        showAppointments(appointments);
                        return appointments;
                    }
                }
            }
            catch(SQLException | ParseException e)
            {
                e.printStackTrace();
            }
            finally
            {
                closeStmt(stmt);
            }
        }
    }

    private static String fetchMidWife()
    {
        String pracid;

        while(true)
        {
            Statement stmt = createStmt(con);
            assert stmt != null;
            try
            {
                System.out.println("Please enter your practitioner id, [E] to exit:");
                Scanner sc = new Scanner(System.in);
                String input = sc.next();
                System.out.println();
                if(input.equalsIgnoreCase("E"))
                {
                    closeAll(stmt);
                }
                else
                {
                    String s = "SELECT pracid FROM MidWife WHERE pracid = " + input;
                    ResultSet rs = stmt.executeQuery(s);
                    if(rs.next())
                    {
                        pracid = rs.getString("pracid");
                        rs.close();
                        return pracid;
                    }
                    else
                    {
                        System.out.println("MidWife not found! Please re-enter practitioner id.");
                    }
                }
            }
            catch(SQLException e)
            {
                e.printStackTrace();
            }
            finally
            {
                closeStmt(stmt);
            }
        }
    }


    /*----------------------- connect/disconnect to database and create/close statement -----------------------*/


    private static void connect()
    {
        try
        {
            DriverManager.registerDriver(new com.ibm.db2.jcc.DB2Driver());
        }
        catch(Exception e)
        {
            System.out.println("Class not found");
        }

        String url = "jdbc:db2://winter2022-comp421.cs.mcgill.ca:50000/cs421";

        String your_userid = System.getenv("SOCSUSER");
        String your_password = System.getenv("SOCSPASSWD");

        if(your_userid == null || your_password == null)
        {
            System.err.println("Error!! do not have a password to connect to the database!");
            System.exit(1);
        }

        try
        {
            con = DriverManager.getConnection(url, your_userid, your_password);
        }
        catch(SQLException e)
        {
            e.printStackTrace();
            System.out.println("Cannot connect to database and create statement!");
        }
    }

    private static Statement createStmt(Connection con)
    {
        try
        {
            return con.createStatement();
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }

        return null;
    }

    private static void closeStmt(Statement stmt)
    {
        try
        {
            stmt.close();
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
    }

    private static void closeCon()
    {
        try
        {
            con.close();
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        System.exit(0);
    }

    private static void closeAll(Statement stmt)
    {
        closeStmt(stmt);
        closeCon();
    }


    /*---------------------------------------- Inner class Appointment ----------------------------------------*/


    public static class Appointment
    {
        public Time time;
        public String type;
        public String name;
        public String hcnum;
        public String appId;
        public String cid;
        public int pregnum;

        public Appointment(Time time, String type, String name, String hcnum, String appId, String cid, int pregnum)
        {
            this.time = time;
            this.type = type;
            this.name = name;
            this.hcnum = hcnum;
            this.appId = appId;
            this.cid = cid;
            this.pregnum = pregnum;
        }
    }
}