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

namespace HospitalInfoSys.Patient
{
    public partial class MyRecord : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
        static int userIDS = 0;

        public void ShowMessage(string message, string jsfunction)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Message", "alert('" + message + "'); " + jsfunction + "", true);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!this.Page.User.Identity.IsAuthenticated)
                {
                    FormsAuthentication.RedirectToLoginPage();
                }
                else
                {
                    userIDS = UserHelper.GetCurrentUserId();
                    bind_record();
                }
            }
        }
        public void bind_record()
        {
           
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                conn.Open();
                using (MySqlCommand cmd = new MySqlCommand())
                {
                    string sql = "select * from vw_patientrecord where userid=@userid ";
                   // ShowMessage(sql + " " + userIDS.ToString(), "");
                    if (txt_search.Text.Trim() != "")
                    {
                        sql += @"and
                       (FULLNAME LIKE @search 
                       OR RoomName LIKE @search
                       OR RoomNumber LIKE @search
                       OR HEALTHNO LIKE @search
                       OR DoctorFullName LIKE @search) ";
                    }
                    
                    sql += "  order by PRID desc ";
                    cmd.CommandText = sql;
                    cmd.Parameters.AddWithValue("@search", "%" + txt_search.Text + "%");
                    cmd.Parameters.AddWithValue("@userid", userIDS.ToString());
                    cmd.Connection = conn;
                    using (MySqlDataAdapter sda = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gv_masterlist.DataSource = dt;
                        gv_masterlist.DataBind();
                       

                    }
                   
                }
                conn.Close();
                // lbl_item.Text = gb.footerinfo_gridview(gv_masterlist).ToString();
            }
        }
        protected void OnPaging(object sender, GridViewPageEventArgs e)
        {
            gv_masterlist.PageIndex = e.NewPageIndex;
            this.bind_record();
        }
        
        public void reset()
        {
     
        

            bind_record();
            txt_search.Focus();
        }



    

        protected void btn_filter_Click(object sender, EventArgs e)
        {
            bind_record();
        }

        protected void btn_reset_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("MyRecord");

        }

        
        public void printpreview(string apptno)
        {
            if (apptno != "")
            {
                string filePath = Server.MapPath("~/Content/pdf/" + apptno + ".pdf");
                string filename = apptno + ".pdf"; // Name of the file to show in the browser tab

                // Check if the file exists before attempting to send it to the browser
                if (System.IO.File.Exists(filePath))
                {

                    string script = $"window.open('/Content/pdf/{filename}', '_blank');";
                    ClientScript.RegisterStartupScript(this.GetType(), "OpenPdf", script, true);

                }
                else
                {
                    // Handle case where the file doesn't exist or couldn't be generated
                    Response.Write("Error: PDF file not found.");
                }
            }
        }

       
    }

}