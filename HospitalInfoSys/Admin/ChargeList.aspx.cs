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
    public partial class ChargeList : System.Web.UI.Page
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
                    string sql = "select * from vw_chargeitemlibraries where 1=1 ";

                    if (txt_search.Text.Trim() != "")
                    {
                        sql += @"and
                       (Name LIKE @search 
                        OR fulldetails LIKE @search
                        OR ItemType LIKE @search) ";
                    }
                    sql += "  order by Name asc ";
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
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Open", "openModal(0);", true);
        }
        public void reset()
        {
            hd_chargeitemid.Value = "0";
            txtName.Text = "";
            ddlItemType.SelectedIndex = 0;
            txtBrand.Text = "";
            txtUnit.Text = "";
            txtDescription.Text = "";
            ddlCategory.SelectedIndex = 0;
            txtRoomType.Text = "";
            txtPrice.Text = "";
            dpstatus.SelectedIndex = 0;

            bind_record();
            txt_search.Focus();
        }
        protected void ddlItemType_SelectedIndexChanged(object sender, EventArgs e)
        {
            string type = ddlItemType.SelectedValue;

            // Reset visibility
            panelBrand.Visible = false;
            panelUnit.Visible = false;
            panelDescription.Visible = false;
            panelCategory.Visible = false;
            panelRoomType.Visible = false;

            switch (type)
            {
                case "Medicine":
                    panelBrand.Visible = true;
                    panelUnit.Visible = true;
                    break;
                case "Medical Supply":
                    panelDescription.Visible = true;
                    break;
                case "Examination":
                    panelCategory.Visible = true;
                    break;
                case "Room":
                    panelRoomType.Visible = true;
                    break;
            }
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
                    String cb = "select * from chargeitemslibrary where ChargeID=@ID ";
                    MySqlCommand cmd = new MySqlCommand(cb);
                    cmd.Parameters.AddWithValue("@ID", id);
                    cmd.Connection = conn;
                    MySqlDataReader rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                    {
                        hd_chargeitemid.Value = id;

                        // Populate base fields
                        ddlItemType.SelectedValue = rdr["ItemType"]?.ToString() ?? "";
                        txtName.Text = rdr["Name"]?.ToString() ?? "";
                        txtPrice.Text = rdr["Price"]?.ToString() ?? "";
                        ddlCategory.SelectedValue = rdr["Category"]?.ToString() ?? "";
                        dpstatus.SelectedValue = rdr["IsActive"]?.ToString() ?? "1";

                        // Optional fields: show & populate if not empty
                        string itemType = ddlItemType.SelectedValue;

                        switch (itemType)
                        {
                            case "Medicine":
                                panelBrand.Visible = true;
                                panelUnit.Visible = true;
                                txtBrand.Text = rdr["Brand"]?.ToString() ?? "";
                                txtUnit.Text = rdr["Unit"]?.ToString() ?? "";
                                break;
                            case "Medical Supply":
                                panelDescription.Visible = true;
                                txtDescription.Text = rdr["Description"]?.ToString() ?? "";
                                break;
                            case "Examination":
                                panelCategory.Visible = true;
                                ddlCategory.SelectedValue = rdr["Category"]?.ToString() ?? "";
                                break;
                            case "Room":
                                panelRoomType.Visible = true;
                                txtRoomType.Text = rdr["RoomType"]?.ToString() ?? "";
                                break;
                        }


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
                        String cb = "Delete from chargeitemslibrary where ChargeID =@id";
                        cmd.CommandText = cb;
                        cmd.Connection = conn;
                        cmd.Parameters.AddWithValue("@id", hd_idselect.Value);
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
            Page.Response.Redirect("ManageCharges");

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string id = hd_chargeitemid.Value;
                string name = txtName.Text.Trim();
                string price = txtPrice.Text.Trim();
                string status = dpstatus.SelectedValue;
                string itemType = ddlItemType.SelectedValue;
                string description = txtDescription.Text.Trim();
                string brand = txtBrand.Text.Trim();
                string unit = txtUnit.Text.Trim();
                string category = ddlCategory.SelectedValue;
                string roomType = txtRoomType.Text.Trim();

                using (MySqlConnection con = new MySqlConnection(connString))
                {
                    try
                    {
                        con.Open();

                        string checkQuery = id == "0"
                            ? "SELECT COUNT(*) FROM chargeitemslibrary WHERE Name = @Name"
                            : "SELECT COUNT(*) FROM chargeitemslibrary WHERE Name = @Name AND ChargeID != @ID";

                        using (MySqlCommand checkCmd = new MySqlCommand(checkQuery, con))
                        {
                            checkCmd.Parameters.AddWithValue("@Name", name);
                            if (id != "0")
                                checkCmd.Parameters.AddWithValue("@ID", id);

                            int exists = Convert.ToInt32(checkCmd.ExecuteScalar());

                            if (exists > 0)
                            {
                                txtName.Text = "";
                                txtName.Focus();
                                ShowMessage("Charge Name already exists!", "");
                                return;
                            }
                        }

                        string query;
                        if (id == "0")
                        {
                            // INSERT
                            query = @"INSERT INTO chargeitemslibrary 
                                (ItemType, Name, Price, IsActive, Description, Brand, Unit, Category, RoomType)
                              VALUES 
                                (@ItemType, @Name, @Price, @IsActive, @Description, @Brand, @Unit, @Category, @RoomType)";
                        }
                        else
                        {
                            // UPDATE
                            query = @"UPDATE chargeitemslibrary SET 
                                ItemType=@ItemType, Name=@Name, Price=@Price, IsActive=@IsActive,
                                Description=@Description, Brand=@Brand, Unit=@Unit, Category=@Category, RoomType=@RoomType
                              WHERE ChargeID = @ID";
                        }

                        using (MySqlCommand cmd = new MySqlCommand(query, con))
                        {
                            if (id != "0") cmd.Parameters.AddWithValue("@ID", id);
                            cmd.Parameters.AddWithValue("@ItemType", itemType);
                            cmd.Parameters.AddWithValue("@Name", name);
                            cmd.Parameters.AddWithValue("@Price", price);
                            cmd.Parameters.AddWithValue("@IsActive", status);
                            cmd.Parameters.AddWithValue("@Description", description);
                            cmd.Parameters.AddWithValue("@Brand", brand);
                            cmd.Parameters.AddWithValue("@Unit", unit);
                            cmd.Parameters.AddWithValue("@Category", category);
                            cmd.Parameters.AddWithValue("@RoomType", roomType);

                            cmd.ExecuteNonQuery();

                            reset();
                            string message = id == "0" ? "Successfully Created!" : "Successfully Updated!";
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertAndCloseModal", $"alert('{message}'); closeModal();", true);
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error: " + ex.Message, "");
                    }
                }
            }
        }

    }
}