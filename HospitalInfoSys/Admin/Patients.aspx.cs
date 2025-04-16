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
    public partial class Patients : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
        protected DashboardCountsPatients dashboardCountsPatients;
        DashboardService dashboardService = new DashboardService();
        protected int TodayAdmitted;
        protected int TotalAdmitted;
        protected int TodayOPD;
        protected int TotalOPD;
        protected int TodayER;
        protected int TotalER;
        private void DisplayCountsPatient()
        {
           
            TodayAdmitted = dashboardCountsPatients.TodayAdmitted;
            TotalAdmitted = dashboardCountsPatients.TotalAdmitted;
            TodayOPD = dashboardCountsPatients.TodayOPD;
            TotalOPD = dashboardCountsPatients.TotalOPD;
            TodayER = dashboardCountsPatients.TodayER;
            TotalER = dashboardCountsPatients.TotalER;
        }
        public void ShowMessage(string message, string jsfunction)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Message", "alert('" + message + "'); " + jsfunction + "", true);
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
                    dashboardCountsPatients = await dashboardService.GetCountsPatientsAsync();
                    DisplayCountsPatient();
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
                    string sql = "select * from vw_patientrecord where 1=1 ";

                    if (txt_search.Text.Trim() != "")
                    {
                        sql += @"and
                       (FULLNAME LIKE @search 
                       OR RoomName LIKE @search
                       OR RoomNumber LIKE @search
                       OR HEALTHNO LIKE @search
                       OR DoctorFullName LIKE @search) ";
                    }
                    if (dpfilterstatus.SelectedIndex > 0)
                    {
                        sql += @" and TYPECONSULTATION =@status";
                    }
                    sql += "  order by PRID desc ";
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
            //txtdateapproved.Text = "";
            //txtremarks.Text = "";
          //  dpstatus.SelectedIndex = 0;

            bind_record();
            txt_search.Focus();
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
                        String cb = "Delete from patientrecord where PRID = " + hd_idselect.Value + "";
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
            Page.Response.Redirect("PatientRecord");

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (Page.IsValid) // Ensure all required fields are filled
            {
                //string AppointmentDateApproved = txtdateapproved.Text.Trim();
                //string AppointmentRemarks = txtremarks.Text.Trim();

                //string status = dpstatus.SelectedValue;

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
                                //cmd.Parameters.AddWithValue("@AppointmentRemarks", AppointmentRemarks);
                                //cmd.Parameters.AddWithValue("@AppointmentDateApproved", AppointmentDateApproved);
                                //cmd.Parameters.AddWithValue("@Status", status);

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
            //string approved = "Approved";
            //string rejected = "Rejected";
            //lbldt.Text = "Optional";
            //rfvdateapproved.Enabled = false;
            //if (dpstatus.SelectedValue == approved)
            //{
            //    rfvdateapproved.Enabled = true;
            //    lbldt.Text = approved;
            //}
            //else if (dpstatus.SelectedValue == rejected)
            //{
            //    rfvdateapproved.Enabled = true;
            //    lbldt.Text = rejected;
            //}
            //else
            //{
            //    lbldt.Text = "Optional";
            //    rfvdateapproved.Enabled = false;
            //}
        }
    }

}