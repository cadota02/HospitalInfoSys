using System;
using System.Configuration;
using System.Data;
using MySql.Data.MySqlClient;


namespace HospitalInfoSys.Shared
{
    public partial class ChangePass : System.Web.UI.Page
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
        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string oldPass = txtOldPassword.Text.Trim();
            string newPass = txtNewPassword.Text.Trim();
            string confirmPass = txtConfirmPassword.Text.Trim();

            if (newPass != confirmPass)
            {
                lblMessage.Text = "New password and confirm password do not match.";
                return;
            }

            

            using (MySqlConnection conn = new MySqlConnection(con))
            {
                conn.Open();

                // Get the stored password hash
                string selectQuery = "SELECT PasswordHash FROM users WHERE ID = @id";
                MySqlCommand selectCmd = new MySqlCommand(selectQuery, conn);
                selectCmd.Parameters.AddWithValue("@id", userId);

                object result = selectCmd.ExecuteScalar();
                if (result == null)
                {
                    lblMessage.Text = "User not found.";
                    return;
                }

                string dbPass = result.ToString();
                if (!BCrypt.Net.BCrypt.Verify(oldPass, dbPass))
                {
                    lblMessage.Text = "Incorrect old password.";
                    return;
                }

                // Hash the new password
                string hashedNewPass = BCrypt.Net.BCrypt.HashPassword(newPass);

                // Update the new password in the database
                string updateQuery = "UPDATE users SET PasswordHash = @newPass WHERE ID = @id";
                MySqlCommand updateCmd = new MySqlCommand(updateQuery, conn);
                updateCmd.Parameters.AddWithValue("@newPass", hashedNewPass);
                updateCmd.Parameters.AddWithValue("@id", userId);

                updateCmd.ExecuteNonQuery();

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Password changed successfully.";
            }
        }
    }
}