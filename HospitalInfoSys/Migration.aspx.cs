using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using System.Web.Security;


namespace HospitalInfoSys
{
    public partial class Migration : System.Web.UI.Page
    {
     
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDatabases();
                checkversioctrl();


            }
        }
        public void checkversioctrl()
        {
            try
            {

                string dynamicConnectionString = $"server=localhost;port={txtport.Text};user id={txtusname.Text};password={hdpass.Value};database={ Session["SelectedDB"]};SslMode=None;";
                using (MySqlConnection con = new MySqlConnection(dynamicConnectionString))
                {
                    con.Open();
                    int latestVersion = GetLatestMigrationVersion(con);
                    lblVersion.Text = latestVersion.ToString();
                }
            }
            catch (Exception ex)
            {
                lblStatus.Text = "checkversioctrl Error: " + ex.Message;
            }
        }
        protected void btnCreateDB_Click(object sender, EventArgs e)
        {
            try
            {
                string dynamicConnectionString = $"server=localhost;port={txtport.Text};user id={txtusname.Text};password={hdpass.Value};database={ Session["SelectedDB"]};SslMode=None;";
                using (MySqlConnection conn = new MySqlConnection(dynamicConnectionString))
                {
                    conn.Open();

                    string dbName = txtcreatedbname.Text;
                    if (!DatabaseExists(dbName, dynamicConnectionString))
                    {
                       // CreateDatabase(conn, dbName);
                        //  DropDatabaseIfExists(conn, dbName);
                        CreateDatabase(conn, dbName);
                        lblStatus.Text = "Database created successfully!";
                        LoadDatabases();
                    }
                    else
                    {
                        lblStatus.Text = "Database already exists.";
                    }

                 
                }
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error: " + ex.Message;
            }
        }
        public  bool DatabaseExists(string databaseName, string constr)
        {
            

            using (MySqlConnection conn = new MySqlConnection(constr))
            {
                conn.Open();
                string query = $"SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = @dbName";

                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@dbName", databaseName);

                    object result = cmd.ExecuteScalar();
                    return result != null;  // If result is not null, database exists
                }
            }
        }
        private void DropDatabaseIfExists(MySqlConnection conn, string dbName)
        {
            string query = $"DROP DATABASE IF EXISTS `{dbName}`;";
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.ExecuteNonQuery();
            }
        }
        private void CreateDatabase(MySqlConnection conn, string dbName)
        {
            string query = $"CREATE DATABASE `{dbName}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;";
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.ExecuteNonQuery();
            }
        }
        protected void btnMigrate_Click(object sender, EventArgs e)
        {
            try
            {

                string dynamicConnectionString = $"server=localhost;port={txtport.Text};user id={txtusname.Text};password={hdpass.Value};database={ Session["SelectedDB"]};SslMode=None;";
                using (MySqlConnection conn = new MySqlConnection(dynamicConnectionString))
                {
                    conn.Open();
                    EnsureMigrationsTable(conn);

                    int latestVersion = GetLatestMigrationVersion(conn);
                    int nextVersion = latestVersion + 1;

                    // Define migrations with a sequential version
                    var migrations = new[]
                    {
                        new { Version = 1, Name = "Create_Users_Table", Query = @"
                            CREATE TABLE IF NOT EXISTS users (
                            ID INT AUTO_INCREMENT PRIMARY KEY,
                            Firstname VARCHAR(255) NOT NULL,
                            Lastname VARCHAR(255) NOT NULL,
                            Middlename VARCHAR(255),
                            UserPosition VARCHAR(255),
                            Username VARCHAR(100) NOT NULL UNIQUE,
                            PasswordHash VARCHAR(255) NOT NULL,
                            Address TEXT,
                            ContactNo VARCHAR(15),
                            Email VARCHAR(255),
                            Role ENUM('Doctor', 'Nurse', 'Patient') NOT NULL,
                            IsApproved TINYINT(1) DEFAULT 0
                        );"
                        },
                        new { Version = 2, Name = "Alter_Users_Add_Email", Query = @"
                            ALTER TABLE Users 
                            ADD COLUMN Email VARCHAR(100);"
                        },
                        new { Version = 3, Name = "Drop_Functions", Query = @"
                            DROP FUNCTION IF EXISTS MyFunction;"
                        },
                         new { Version = 4, Name = "Create_services_Table", Query = @"
                            DROP TABLE IF EXISTS services;
                    
                            CREATE TABLE services (
                                ID INT AUTO_INCREMENT PRIMARY KEY,
                                ServiceName VARCHAR(255) NOT NULL,
                                Description VARCHAR(255),
                                Price DOUBLE NOT NULL,
                                IsActive INT NOT NULL DEFAULT 1
                            );"
                        },
                          new { Version = 5, Name = "Create_appointments_Table", Query = @"
                        CREATE TABLE appointments (
                                ID INT AUTO_INCREMENT PRIMARY KEY,
                                Firstname VARCHAR(255) NOT NULL,
                                Middlename VARCHAR(255),
                                Lastname VARCHAR(255) NOT NULL,
                                Sex ENUM('Male', 'Female') NOT NULL,
                                BirthDate DATE NOT NULL,
                                Email VARCHAR(255),
                                ContactNo VARCHAR(15),
                                Address TEXT,
                                PreferredDoctorID INT,
                                AppointmentDateTime DATETIME NOT NULL,
                                Reason TEXT,
                                Status ENUM('Pending', 'Approved', 'Rejected') NOT NULL,
                                AppointmentDateApproved DATETIME,
                                AppointmentRemarks VARCHAR(255),
                                AppointmentNumber VARCHAR(45) NULL
                            );"
                        }
                    };

                    // Apply only new migrations
                    foreach (var migration in migrations)
                    {
                        if (migration.Version > latestVersion)
                        {
                            using (MySqlCommand cmd = new MySqlCommand(migration.Query, conn))
                            {
                                cmd.ExecuteNonQuery();
                            }

                            // Record applied migration
                            InsertMigrationRecord(conn, migration.Version, migration.Name);
                        }
                    }
                }

                lblStatus.Text = "Migration completed successfully!";
                checkversioctrl();
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error: " + ex.Message;
            }
        }

        private void EnsureMigrationsTable(MySqlConnection conn)
        {
            string query = @"
                CREATE TABLE IF NOT EXISTS Migrations (
                    Id INT AUTO_INCREMENT PRIMARY KEY,
                    Version INT NOT NULL,
                    MigrationName VARCHAR(255) NOT NULL,
                    AppliedAt DATETIME DEFAULT CURRENT_TIMESTAMP
                );";
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.ExecuteNonQuery();
            }
        }

        private int GetLatestMigrationVersion(MySqlConnection conn)
        {
            string query = "SELECT COALESCE(MAX(Version), 0) FROM Migrations;";
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private void InsertMigrationRecord(MySqlConnection conn, int version, string name)
        {
            string query = "INSERT INTO Migrations (Version, MigrationName) VALUES (@Version, @Name);";
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Version", version);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.ExecuteNonQuery();
            }
        }
        private void LoadDatabases()
        {

              string connString = ConfigurationManager.ConnectionStrings["MasterDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                try
                {
                   

                    string host = GetValue(connString, "server");
                    string port = GetValue(connString, "port");
                    string user = GetValue(connString, "user");
                    string pass = GetValue(connString, "password");

                    txtpass.Text = pass;
                    txtusname.Text = user;
                    txtport.Text = port;
                    hdpass.Value = pass;

                    conn.Open();
                    string query = "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA ORDER BY SCHEMA_NAME;";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        ddlDatabases.DataSource = dt;
                        ddlDatabases.DataTextField = "SCHEMA_NAME";  // Display database names
                        ddlDatabases.DataValueField = "SCHEMA_NAME"; // Value is also database name
                        ddlDatabases.DataBind();
                    }

                    ddlDatabases.Items.Insert(0, new ListItem("-- Select Database --", ""));
                }
                catch (Exception ex)
                {
                    lblStatus.Text = "Error: " + ex.Message;
                }
            }
        }
        private static string GetValue(string connStr, string key)
        {
            foreach (string part in connStr.Split(';'))
            {
                if (part.StartsWith(key + "=", StringComparison.OrdinalIgnoreCase))
                    return part.Split('=')[1];
            }
            return "Not Found";
        }
        protected void ddlDatabases_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedDatabase = ddlDatabases.SelectedValue;

            if (!string.IsNullOrEmpty(selectedDatabase))
            {
                Session["SelectedDB"] = selectedDatabase; // Store selected DB in session
                lblStatus.Text = $"Database selected: {selectedDatabase}";
                checkversioctrl(); 
            }
        }
        public static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["MasterDB"].ConnectionString;
        }

        public static void TestConnection()
        {
            string connectionString = GetConnectionString();

            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    Console.WriteLine("✅ Connection Successful!");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("❌ Connection Failed: " + ex.Message);
                }
            }
        }
    }
}