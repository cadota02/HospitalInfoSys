﻿using System;
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
    public partial class Rooms : System.Web.UI.Page
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
                        "CASE WHEN IsVacant = 1 THEN 'Vacant' ELSE 'Occupied' END AS Status " +
                        "from rooms where 1=1 ";

                    if (txt_search.Text.Trim() != "")
                    {
                        sql += @"and
                       (RoomName LIKE @search 
                       OR RoomNumber LIKE @search 
                       OR Type LIKE @search  ) ";
                    }
                    sql += "  order by RoomNumber asc ";
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
            hd_roomid.Value = "0";
            txtroomname.Text = "";
            txtroomno.Text = "";
            dptype.SelectedIndex = 0;
            txtbedoccupancy.Text = "";
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
                    String cb = "select * from rooms where ID=" + id + " ";
                    MySqlCommand cmd = new MySqlCommand(cb);
                    cmd.Connection = conn;
                    MySqlDataReader rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                    {
                        hd_roomid.Value = id;
                        txtroomname.Text = rdr["RoomName"].ToString();
                        txtroomno.Text = rdr["RoomNumber"].ToString();
                        dptype.SelectedValue = rdr["Type"].ToString();
                        txtbedoccupancy.Text = rdr["BedOccupancy"].ToString();
                        

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
                        String cb = "Delete from rooms where ID = " + hd_idselect.Value + "";
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
            Page.Response.Redirect("ManageRoom");

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (Page.IsValid) // Ensure all required fields are filled
            {
                string roomno = txtroomno.Text.Trim();
                string roomname = txtroomname.Text.Trim();
                string bedoccupancy = txtbedoccupancy.Text.Trim();
                string type = dptype.SelectedValue;
              
               /// int isApproved = int.Parse(status); // Approval pending


                if (hd_roomid.Value == "0") // INSERT IF NOT SELECT ID
                {

                    using (MySqlConnection con = new MySqlConnection(connString))
                    {
                        try
                        {
                            con.Open();

                            string checkUserQuery = "SELECT COUNT(*) FROM rooms WHERE RoomNumber = @RoomNumber;";
                            using (MySqlCommand checkCmd = new MySqlCommand(checkUserQuery, con))
                            {
                                checkCmd.Parameters.AddWithValue("@RoomNumber", roomno);
                                int roomExist = Convert.ToInt32(checkCmd.ExecuteScalar());
                                con.Close();
                                if (roomExist > 0)
                                {
                                    txtroomno.Text = "";
                                    txtroomno.Focus();
                                    ShowMessage("Room number already exist!", "");
                                }
                                else
                                {
                                    con.Open();
                                    string query = "INSERT INTO rooms (RoomName,RoomNumber,Type,BedOccupancy,IsVacant) " +
                                           "VALUES (@RoomName,@RoomNumber,@Type,@BedOccupancy,@IsVacant)";

                                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                                    {
                                        cmd.Parameters.AddWithValue("@RoomName", roomname);
                                        cmd.Parameters.AddWithValue("@RoomNumber", roomno);
                                        cmd.Parameters.AddWithValue("@Type", type);
                                        cmd.Parameters.AddWithValue("@BedOccupancy", bedoccupancy);
                                        cmd.Parameters.AddWithValue("@IsVacant", "1");
                                      

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

                            string checkUserQuery = "SELECT COUNT(*) FROM rooms WHERE RoomNumber=@RoomNumber AND ID !=@ID;";
                            using (MySqlCommand checkCmd = new MySqlCommand(checkUserQuery, con))
                            {
                                checkCmd.Parameters.AddWithValue("@RoomNumber", roomno);
                                checkCmd.Parameters.AddWithValue("@ID", hd_roomid.Value);
                                int roomExist = Convert.ToInt32(checkCmd.ExecuteScalar());
                                con.Close();
                                if (roomExist > 0)
                                {

                                    txtroomno.Text = "";
                                    txtroomno.Focus();
                                    ShowMessage("Room number already exist!", "");
                                }
                                else
                                {
                                    con.Open();


                                    string query = "UPDATE rooms SET RoomName=@RoomName, RoomNumber=@RoomNumber, Type=@Type, " +
                                        "BedOccupancy=@BedOccupancy " +
                                        " WHERE ID =@ID ";

                                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                                    {
                                        cmd.Parameters.AddWithValue("@ID", hd_roomid.Value);
                                        cmd.Parameters.AddWithValue("@RoomName", roomname);
                                        cmd.Parameters.AddWithValue("@RoomNumber", roomno);
                                        cmd.Parameters.AddWithValue("@Type", type);
                                        cmd.Parameters.AddWithValue("@BedOccupancy", bedoccupancy);

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