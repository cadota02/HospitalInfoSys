using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Configuration;
namespace HospitalInfoSys
{
    public partial class Contact : Page
    {
        string connString = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string name = txtName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string message = txtMessage.Text.Trim();

                using (MySqlConnection conn = new MySqlConnection(connString))
                {
                    try
                    {
                        conn.Open();
                        string query = "INSERT INTO contact_messages (Name, Email, Message) VALUES (@Name, @Email, @Message)";
                        MySqlCommand cmd = new MySqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@Name", name);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Message", message);
                        cmd.ExecuteNonQuery();

                        lblStatus.ForeColor = System.Drawing.Color.Green;
                        lblStatus.Text = "Message sent successfully!";
                        txtName.Text = txtEmail.Text = txtMessage.Text = "";
                    }
                    catch (Exception ex)
                    {
                        lblStatus.ForeColor = System.Drawing.Color.Red;
                        lblStatus.Text = "Error: " + ex.Message;
                    }
                }
            }
        }
    }
}