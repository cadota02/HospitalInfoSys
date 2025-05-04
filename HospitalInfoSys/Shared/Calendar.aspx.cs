using System;
using System.Configuration;
using System.Data;
using MySql.Data.MySqlClient;

namespace HospitalInfoSys.Shared
{
    public partial class Calendar : System.Web.UI.Page
    {
        protected void Page_PreInit(object sender, EventArgs e)
        {
            // Dynamically set master page
            string role = Session["UserRole"]?.ToString();
            if (role == "Patient")
                MasterPageFile = "~/SitePatient.Master";
            else
                MasterPageFile = "~/SiteAdmin.master";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserId"] == null)
                Response.Redirect("~/Login.aspx");
        }
        public string con = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
    }
}