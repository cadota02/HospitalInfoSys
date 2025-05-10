using System;
using System.Configuration;
using System.Data;
using System.Web.Security;
using MySql.Data.MySqlClient;

namespace HospitalInfoSys.Shared
{
    public partial class Calendar : System.Web.UI.Page
    {
        protected void Page_PreInit(object sender, EventArgs e)
        {
            // Dynamically set master page
                 get_userinfo(Page.User.Identity.Name.ToString());
             
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserId"] == null)
                Response.Redirect("~/Login.aspx");

            if (!this.Page.User.Identity.IsAuthenticated)
            {
                FormsAuthentication.RedirectToLoginPage();
            }
        }
        public string con = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
        public void get_userinfo(string username)
        {
            //try
            //{
            using (MySqlConnection conn = new MySqlConnection(con))
            {
                conn.Open();
                String cb = "select * from users where Username='" + username + "' ";
                MySqlCommand cmd = new MySqlCommand(cb);
                cmd.Connection = conn;
                MySqlDataReader rdr = cmd.ExecuteReader();
                if (rdr.Read())
                {

                    string role = rdr["Role"].ToString();
               
                    if (role == "Patient")
                        MasterPageFile = "~/SitePatient.Master";
                    else
                        MasterPageFile = "~/SiteAdmin.master";

                }
                rdr.Close();
                conn.Close();
            }
            //}
            //catch (Exception ex)
            //{
            //    ShowMessage(ex.Message.ToString(), "");

            //}

        }
    }
}