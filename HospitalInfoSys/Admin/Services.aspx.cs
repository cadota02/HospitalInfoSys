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

namespace HospitalInfoSys.Admin
{
    public partial class Services : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
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
                    string sql = "select *, " +
                        "CASE WHEN IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status " +
                        "from services where 1=1 ";

                    if (txt_search.Text.Trim() != "")
                    {
                        sql += @"and
                       (ServiceName LIKE @search 
                       OR Description LIKE @search) ";
                    }
                    sql += "  order by ServiceName asc ";
                    cmd.CommandText = sql;
                    cmd.Parameters.AddWithValue("@search", "%" + txt_search.Text + "%");
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
        protected void btn_add_Click(object sender, EventArgs e)
        {
            reset();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "CloseModal", "closeModal();", true);
        }
        public void reset()
        {
            hd_serviceid.Value = "0";
            txtservicename.Text = "";
            txtdescription.Text = "";
            txtPrice.Text = "";
            dpstatus.SelectedIndex = 0;
          
            bind_record();
            txt_search.Focus();
        }
        protected void btn_select_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn_select = (LinkButton)sender;
                GridViewRow item = (GridViewRow)btn_select.NamingContainer;
                HiddenField hd_idselect = (HiddenField)item.FindControl("hd_id");
                HiddenField hd_name = (HiddenField)item.FindControl("hd_name");
                HiddenField hd_status = (HiddenField)item.FindControl("hd_status");

                get_data(hd_idselect.Value);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "EditModal", "openModal(" + hd_idselect.Value + ");", true);
            }
            catch (Exception ex)
            {

                ShowMessage(ex.Message.ToString(), "");
            }
        }
        public void get_data(string id)
        {
            try
            {
                using (MySqlConnection conn = new MySqlConnection(connString))
                {
                    conn.Open();
                    String cb = "select * from services where ID=" + id + " ";
                    MySqlCommand cmd = new MySqlCommand(cb);
                    cmd.Connection = conn;
                    MySqlDataReader rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                    {
                        hd_serviceid.Value = id;
                        txtservicename.Text = rdr["ServiceName"].ToString();
                        txtdescription.Text = rdr["Description"].ToString();
                        dpstatus.SelectedValue = rdr["IsActive"].ToString();
                        txtPrice.Text = rdr["Price"].ToString();


                    }
                    rdr.Close();
                    conn.Close();
                }
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message.ToString(), "");

            }

        }
        protected void btn_delete_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn_select = (LinkButton)sender;
                GridViewRow item = (GridViewRow)btn_select.NamingContainer;

                HiddenField hd_idselect = (HiddenField)item.FindControl("hd_id");
                HiddenField hd_name = (HiddenField)item.FindControl("hd_name");


                using (MySqlConnection conn = new MySqlConnection(connString))
                {
                    conn.Open();
                    using (MySqlCommand cmd = new MySqlCommand())
                    {
                        String cb = "Delete from services where ID = " + hd_idselect.Value + "";
                        cmd.CommandText = cb;
                        cmd.Connection = conn;

                        int result = cmd.ExecuteNonQuery();
                        conn.Close();

                        if (result >= 1)
                        {

                            ShowMessage("Successfully Deleted!", "");

                            bind_record();

                        }
                    }
                    conn.Close();

                }
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message, "");
            }

        }

        protected void btn_filter_Click(object sender, EventArgs e)
        {
            bind_record();
        }

        protected void btn_reset_Click(object sender, EventArgs e)
        {
            Page.Response.Redirect("ManageServices");

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (Page.IsValid) // Ensure all required fields are filled
            {
                string description = txtdescription.Text.Trim();
                string ServiceName = txtservicename.Text.Trim();
                string price = txtPrice.Text.Trim();
                string status = dpstatus.SelectedValue;

                /// int isApproved = int.Parse(status); // Approval pending


                if (hd_serviceid.Value == "0") // INSERT IF NOT SELECT ID
                {

                    using (MySqlConnection con = new MySqlConnection(connString))
                    {
                        try
                        {
                            con.Open();

                            string checkUserQuery = "SELECT COUNT(*) FROM services WHERE ServiceName = @ServiceName;";
                            using (MySqlCommand checkCmd = new MySqlCommand(checkUserQuery, con))
                            {
                                checkCmd.Parameters.AddWithValue("@ServiceName", ServiceName);
                                int servicenameExist = Convert.ToInt32(checkCmd.ExecuteScalar());
                                con.Close();
                                if (servicenameExist > 0)
                                {
                                    txtservicename.Text = "";
                                    txtservicename.Focus();
                                    ShowMessage("Service Name already exist!", "");
                                }
                                else
                                {
                                    con.Open();
                                    string query = "INSERT INTO services (ServiceName,Description,Price,IsActive) " +
                                           "VALUES (@ServiceName,@Description,@Price,@IsActive)";

                                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                                    {
                                        cmd.Parameters.AddWithValue("@ServiceName", ServiceName);
                                        cmd.Parameters.AddWithValue("@Description", description);
                                        cmd.Parameters.AddWithValue("@Price", price);
                                 
                                        cmd.Parameters.AddWithValue("@IsActive", status);


                                        cmd.ExecuteNonQuery();

                                        reset();
                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertAndCloseModal", "alert('Successfully Created!'); closeModal();", true);

                                    }
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
                        }
                    }
                }
                else // UPDATE IF HAS ID
                {
                    using (MySqlConnection con = new MySqlConnection(connString))
                    {
                        try
                        {
                            con.Open();

                            string checkUserQuery = "SELECT COUNT(*) FROM services WHERE ServiceName=@ServiceName AND ID !=@ID;";
                            using (MySqlCommand checkCmd = new MySqlCommand(checkUserQuery, con))
                            {
                                checkCmd.Parameters.AddWithValue("@ServiceName", ServiceName);
                                checkCmd.Parameters.AddWithValue("@ID", hd_serviceid.Value);
                                int servicenameExist = Convert.ToInt32(checkCmd.ExecuteScalar());
                                con.Close();
                                if (servicenameExist > 0)
                                {

                                    txtservicename.Text = "";
                                    txtservicename.Focus();
                                    ShowMessage("Service Name already exist!", "");
                                }
                                else
                                {
                                    con.Open();


                                    string query = "UPDATE services SET ServiceName=@ServiceName, Description=@Description, Price=@Price, " +
                                        "IsActive=@IsActive " +
                                        " WHERE ID =@ID ";

                                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                                    {
                                        cmd.Parameters.AddWithValue("@ID", hd_serviceid.Value);
                                        cmd.Parameters.AddWithValue("@ServiceName", ServiceName);
                                        cmd.Parameters.AddWithValue("@Description", description);
                                        cmd.Parameters.AddWithValue("@Price", price);
                                        cmd.Parameters.AddWithValue("@IsActive", status);
                                      

                                        cmd.ExecuteNonQuery();
                                        reset();

                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertAndCloseModal", "alert('Successfully Updated!'); closeModal();", true);

                                    }
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            ShowMessage(ex.Message.ToString(), "");
                        }
                    }

                }
            }
        }

    }
}