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
    public partial class Home : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
        protected DashboardCounts dashboardCounts;
        DashboardService dashboardService = new DashboardService();
        protected int pendingCount;
        protected int approvedCount;
        protected int rejectedCount;
        public void ShowMessage(string message, string jsfunction)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Message", "alert('" + message + "'); " + jsfunction + "", true);
        }
        private void DisplayCounts()
        {
            // Display the counts in your page
            pendingCount = dashboardCounts.Pending;
            approvedCount = dashboardCounts.Approved;
            rejectedCount = dashboardCounts.Rejected;
        }
        protected async void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!this.Page.User.Identity.IsAuthenticated)
                {
                    FormsAuthentication.RedirectToLoginPage();
                }
                else
                {
                    dashboardCounts = await dashboardService.GetCountsAsync();
                    DisplayCounts();
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
                    string sql = "SELECT *, CONCAT(b.Firstname, ' ', LEFT(b.Middlename, 1), '. ', b.Lastname) AS Fullname, " +
                                 "TIMESTAMPDIFF(YEAR, b.BirthDate, CURDATE()) AS Age, " +
                                 "CONCAT(a.Firstname, ' ', LEFT(a.Middlename, 1), '. ', a.Lastname) AS PreferedDoctorName, "+
                                 " (case when b.Status = 'Pending' then (CASE " +
                                    "WHEN DATEDIFF(CURDATE(), DATE(b.AppointmentDateTime)) < 0 "+
                                    "THEN CONCAT(b.Status,' - ',ABS(DATEDIFF(CURDATE(), DATE(b.AppointmentDateTime))), ' day(s) remaining') " +
                                    "ELSE CONCAT(b.Status,' - ',DATEDIFF(CURDATE(), DATE(b.AppointmentDateTime)), ' day(s) overdue') " +
                                "END) else b.Status end) AS remainingdays, " +
                                 "DATEDIFF(CURDATE(), DATE(b.AppointmentDateTime)) as dayscount" +
                                   " FROM appointments b left join users a on a.ID = b.PreferredDoctorID where 1=1 ";

                    if (txt_search.Text.Trim() != "")
                    {
                        sql += @"and
                       (b.Firstname LIKE @search 
                       OR b.Middlename LIKE @search
                       OR b.Lastname LIKE @search
                       OR b.Status LIKE @search
                       OR b.AppointmentNumber LIKE @search) ";
                    }
                    if(dpfilterstatus.SelectedIndex >=0)
                    {
                        sql += @" and Status =@status";
                    }
                    sql += "  order by dayscount desc ";
                    cmd.CommandText = sql;
                    cmd.Parameters.AddWithValue("@search", "%" + txt_search.Text + "%");
                    cmd.Parameters.AddWithValue("@status", dpfilterstatus.SelectedValue);
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
            dpfilterstatus.SelectedIndex = 0;
            hd_appointmentid.Value = "0";
            txtdateapproved.Text = "";
            txtremarks.Text = "";
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
            //try
            //{
                using (MySqlConnection conn = new MySqlConnection(connString))
                {
                    conn.Open();
                    String cb = "select * from vw_appointments where ID=" + id + " ";
                    MySqlCommand cmd = new MySqlCommand(cb);
                    cmd.Connection = conn;
                    MySqlDataReader rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                    {
                        hd_appointmentid.Value = id;
                        txtremarks.Text = rdr["AppointmentRemarks"].ToString();
                    lblFullname.Text= rdr["Fullname"].ToString();
                    lblDateOfAppointment.Text = DateTime.Parse(rdr["AppointmentDateTime"].ToString()).ToString("MMM d, yyyy hh tt");
                    lblReason.Text = rdr["Reason"].ToString();
                    lbldoctor.Text = rdr["PreferedDoctorName"].ToString();

                    if (rdr["AppointmentDateApproved"] != DBNull.Value)
                        {
                                    DateTime appointmentDate;

                                    if (DateTime.TryParse(rdr["AppointmentDateApproved"].ToString(), out appointmentDate))
                                    {
                                        txtdateapproved.Text = appointmentDate.ToString("yyyy-MM-ddTHH:mm:ss"); // Required format
                                    }
                                    else
                                    {
                                        txtdateapproved.Text = ""; // Leave empty if parsing fails
                                    }
                        }
                        else
                        {
                            txtdateapproved.Text = "";
                        }
                        dpstatus.SelectedValue = rdr["Status"].ToString();
                      


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
                        String cb = "Delete from appointments where ID = " + hd_idselect.Value + "";
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
            Page.Response.Redirect("AdminHome");

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (Page.IsValid) // Ensure all required fields are filled
            {
                string AppointmentDateApproved = txtdateapproved.Text.Trim();
                string AppointmentRemarks = txtremarks.Text.Trim();
               
                string status = dpstatus.SelectedValue;

                /// int isApproved = int.Parse(status); // Approval pending


                if (hd_appointmentid.Value == "0") // INSERT IF NOT SELECT ID
                {

                  
                }
                else // UPDATE IF HAS ID
                {
                    using (MySqlConnection con = new MySqlConnection(connString))
                    {
                        try
                        {
                            con.Open();
                           string query = "UPDATE appointments SET AppointmentRemarks=@AppointmentRemarks, AppointmentDateApproved=@AppointmentDateApproved, Status=@Status " +
                                          " WHERE ID =@ID ";

                                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                                    {
                                        cmd.Parameters.AddWithValue("@ID", hd_appointmentid.Value);
                                        cmd.Parameters.AddWithValue("@AppointmentRemarks", AppointmentRemarks);
                                        cmd.Parameters.AddWithValue("@AppointmentDateApproved", AppointmentDateApproved);
                                        cmd.Parameters.AddWithValue("@Status", status);
                                   
                                        cmd.ExecuteNonQuery();
                                        reset();

                                        ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertAndCloseModal", "alert('Successfully Updated!'); closeModal();", true);

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

        protected void dpstatus_SelectedIndexChanged(object sender, EventArgs e)
        {
             string approved = "Approved";
            string rejected = "Rejected";
            lbldt.Text = "Optional";
            rfvdateapproved.Enabled = false;
            if (dpstatus.SelectedValue == approved)
            {
                rfvdateapproved.Enabled = true;
                lbldt.Text = approved;
            }
            else if(dpstatus.SelectedValue == rejected)
            {
                rfvdateapproved.Enabled = true;
                lbldt.Text = rejected;
            }
            else
            {
                lbldt.Text = "Optional";
                rfvdateapproved.Enabled = false;
            }
        }
    }

}