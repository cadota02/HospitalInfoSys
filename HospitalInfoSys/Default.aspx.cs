using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
namespace HospitalInfoSys
{
    public partial class _Default : Page
    {
        string connString = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                LoadServices();
            }
        }

        private void LoadServices()
        {
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT ID, ServiceName, Description, Price FROM services WHERE IsActive = 1";
                    MySqlCommand cmd = new MySqlCommand(query, conn);
                    MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptServices.DataSource = dt;
                    rptServices.DataBind();
                }
                catch (Exception ex)
                {
                    // Handle error (optional logging)
                    Response.Write("Error: " + ex.Message);
                }
            }
        }
        public void testconnection()
        {
            string connString = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;

            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                try
                {
                    conn.Open(); // Open the connection

                    if (conn.State == ConnectionState.Open)
                    {
                        Response.Write("Connection is Open!");
                    }
                    else
                    {
                        Response.Write("Connection is Closed!");
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("Error: " + ex.Message);
                }
            } // Connection automatically closes when using 'using' statement
        }
    }
}