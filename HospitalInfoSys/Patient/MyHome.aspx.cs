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
    public partial class MyHome : System.Web.UI.Page
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
                    if (userIDS == -1)
                    {
                        Response.Write("<script>alert('Please signup before you can book appointment.');</script>");
                        // Response.Redirect("Login.aspx");
                        // return;
                    }
                    get_userinfo(Page.User.Identity.Name.ToString());
                    linkprint.Visible = false;
                    LoadDoctorsDropdown();
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
                                 "CONCAT(a.Firstname, ' ', LEFT(a.Middlename, 1), '. ', a.Lastname) AS PreferedDoctorName, " +
                                 " (case when b.Status = 'Pending' then (CASE " +
                                    "WHEN DATEDIFF(CURDATE(), DATE(b.AppointmentDateTime)) < 0 " +
                                    "THEN CONCAT(b.Status,' - ',ABS(DATEDIFF(CURDATE(), DATE(b.AppointmentDateTime))), ' day(s) remaining') " +
                                    "ELSE CONCAT(b.Status,' - ',DATEDIFF(CURDATE(), DATE(b.AppointmentDateTime)), ' day(s) overdue') " +
                                "END) else b.Status end) AS remainingdays, " +
                                 "DATEDIFF(CURDATE(), DATE(b.AppointmentDateTime)) as dayscount" +
                                   " FROM appointments b left join users a on a.ID = b.PreferredDoctorID where 1=1 and userid=@userid ";

                    if (txt_search.Text.Trim() != "")
                    {
                        sql += @"and
                       (b.Firstname LIKE @search 
                       OR b.Middlename LIKE @search
                       OR b.Lastname LIKE @search
                       OR b.Status LIKE @search
                       OR b.AppointmentNumber LIKE @search) ";
                    }
                   
                    sql += "  order by dayscount desc ";
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
        protected void btn_add_Click(object sender, EventArgs e)
        {
           
             reset();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Open2", "openModal(0);", true);
        }
        public void reset()
        {
            // txt_reason.Text = "";
            //  txt_apptdate.Text = "";
            hd_apptid.Value = "0";
            lblappointmentNumber.Text = string.Empty;

            Firstname.Text = string.Empty;
            Middlename.Text = string.Empty;
            Lastname.Text = string.Empty;
            Sex.SelectedIndex = 0;

            BirthDate.Text = string.Empty;
            Email.Text = string.Empty;
            ContactNo.Text = string.Empty;
            Address.Text = string.Empty;

            PreferredDoctorID.SelectedIndex = 0;
            AppointmentDateTime.Text = string.Empty;
            Reason.Text = string.Empty;
            PreferredDoctorID.SelectedIndex = 0;
            get_userinfo(Page.User.Identity.Name.ToString());
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
                    hd_apptid.Value = rdr["ID"].ToString();
                    Firstname.Text = rdr["Firstname"].ToString();
                    Middlename.Text = rdr["Middlename"].ToString();
                    Lastname.Text = rdr["Lastname"].ToString();
                    Sex.SelectedValue = rdr["Sex"].ToString();
                    BirthDate.Text = Convert.ToDateTime(rdr["BirthDate"]).ToString("yyyy-MM-dd");
                    Email.Text = rdr["Email"].ToString();
                    ContactNo.Text = rdr["ContactNo"].ToString();
                    Address.Text = rdr["Address"].ToString();
                    PreferredDoctorID.SelectedValue = rdr["PreferredDoctorID"].ToString();

                    if (rdr["AppointmentDateTime"] != DBNull.Value)
                        AppointmentDateTime.Text = Convert.ToDateTime(rdr["AppointmentDateTime"]).ToString("yyyy-MM-ddTHH:mm");

                    Reason.Text = rdr["Reason"].ToString();
                    lblappointmentNumber.Text = rdr["AppointmentNumber"].ToString();




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
            Page.Response.Redirect("MyHome");

        }
        private string GenerateAppointmentNumber()
        {
            // Generate a custom appointment number
            string prefix = "";
            string datePart = DateTime.Now.ToString("yyMMdd");
            string randomNumber = new Random().Next(1000, 9999).ToString();

            return $"{prefix}{datePart}-{randomNumber}";
        }
        private string GenerateUniqueAppointmentNumber(MySqlConnection conn)
        {
            string appointmentNumber;
            bool isUnique = false;
            int attempts = 0;

            do
            {
                appointmentNumber = GenerateAppointmentNumber();
                string checkQuery = "SELECT COUNT(*) FROM appointments WHERE AppointmentNumber = @AppointmentNumber";
                using (MySqlCommand checkCmd = new MySqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@AppointmentNumber", appointmentNumber);
                    long count = (long)checkCmd.ExecuteScalar();
                    isUnique = count == 0;
                }
                attempts++;
                if (attempts > 10)
                    throw new Exception("Unable to generate a unique appointment number after 10 attempts.");
            } while (!isUnique);

            return appointmentNumber;
        }
        private bool IsExistDateName(string firstname, string middlename, string lastname, string appointmentDateTime, string id = "0")
        {
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                conn.Open();
                string query = @"SELECT COUNT(*) FROM appointments 
                         WHERE Firstname = @Firstname 
                           AND Middlename = @Middlename 
                           AND Lastname = @Lastname 
                           AND DATE(AppointmentDateTime) = DATE(@AppointmentDateTime)
                           AND ID != @ID";

                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Firstname", firstname);
                    cmd.Parameters.AddWithValue("@Middlename", middlename);
                    cmd.Parameters.AddWithValue("@Lastname", lastname);
                    cmd.Parameters.AddWithValue("@AppointmentDateTime", appointmentDateTime);
                    cmd.Parameters.AddWithValue("@ID", id);

                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
        }
        protected void btn_submitappt_Click(object sender, EventArgs e)
        {
            string id = hd_apptid.Value;
            

            string firstname = Firstname.Text;
            string middlename = Middlename.Text;
            string lastname = Lastname.Text;
            string sex = Sex.SelectedValue;
            string birthdate = BirthDate.Text;
            string email = Email.Text;
            string contactNo = ContactNo.Text;
            string address = Address.Text;
            int preferredDoctorID = int.Parse(PreferredDoctorID.SelectedValue);
            string appointmentDateTime = AppointmentDateTime.Text;
            string reason = Reason.Text;
          //  int userId = UserHelper.GetCurrentUserId();
            string userId = Session["UserID"] != null ? Session["UserID"].ToString() : null;

            if (IsExistDateName(firstname, middlename, lastname,  appointmentDateTime, id))
            {
               
                 ShowMessage("Duplicate appointment exists with same name and date.", "");
                return;
            }

            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                try
                {
                    conn.Open();

                    string appointmentNumber = id != "0"
                        ? lblappointmentNumber.Text
                        : GenerateAppointmentNumber();

                    string query;

                    if (id != "0")
                    {
                        query = @"UPDATE appointments SET 
                            Firstname=@Firstname, Middlename=@Middlename, Lastname=@Lastname, Sex=@Sex,
                            BirthDate=@BirthDate, Email=@Email, ContactNo=@ContactNo, Address=@Address,
                            PreferredDoctorID=@PreferredDoctorID, AppointmentDateTime=@AppointmentDateTime, 
                            Reason=@Reason, userid=@userid
                          WHERE ID=@ID";
                    }
                    else
                    {
                        query = @"INSERT INTO appointments 
                            (Firstname, Middlename, Lastname, Sex, BirthDate, Email, ContactNo, Address, 
                             PreferredDoctorID, AppointmentDateTime, Reason, Status, 
                             AppointmentDateApproved, AppointmentRemarks, AppointmentNumber, userid)
                          VALUES 
                            (@Firstname, @Middlename, @Lastname, @Sex, @BirthDate, @Email, @ContactNo, @Address, 
                             @PreferredDoctorID, @AppointmentDateTime, @Reason, 'Pending', 
                             @AppointmentDateApproved, @AppointmentRemarks, @AppointmentNumber, @userid)";
                    }

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Firstname", firstname);
                        cmd.Parameters.AddWithValue("@Middlename", middlename);
                        cmd.Parameters.AddWithValue("@Lastname", lastname);
                        cmd.Parameters.AddWithValue("@Sex", sex);
                        cmd.Parameters.AddWithValue("@BirthDate", DateTime.Parse(birthdate));
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@ContactNo", contactNo);
                        cmd.Parameters.AddWithValue("@Address", address);
                        cmd.Parameters.AddWithValue("@PreferredDoctorID", preferredDoctorID);
                        cmd.Parameters.AddWithValue("@AppointmentDateTime", DateTime.Parse(appointmentDateTime));
                        cmd.Parameters.AddWithValue("@Reason", reason);
                        cmd.Parameters.AddWithValue("@userid", userIDS);

                        if (id != "0")
                        {
                            cmd.Parameters.AddWithValue("@ID", id);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@AppointmentDateApproved", DBNull.Value);
                            cmd.Parameters.AddWithValue("@AppointmentRemarks", DBNull.Value);
                            cmd.Parameters.AddWithValue("@AppointmentNumber", appointmentNumber);
                        }

                       int stat= cmd.ExecuteNonQuery();
                       if(stat > 0)
                        {
                            reset();
                            bind_record();

                            string action = (id == "0") ? "submitted" : "updated";
                            ShowMessage($"Appointment successfully {action}!", "closeModal();");
                        }
                    }

                    if (hd_apptid.Value=="0")
                    {
                        using (MySqlCommand getIdCmd = new MySqlCommand("SELECT LAST_INSERT_ID();", conn))
                        {
                            int newId = Convert.ToInt32(getIdCmd.ExecuteScalar());
                            linkprint.NavigateUrl = "~/AppointmentPrint?id=" + newId.ToString();
                            linkprint.Visible = true;
                        }
                    }
                   
                
                }
              
                catch (Exception ex)
                {
                    ShowMessage("Error: " + ex.ToString().Substring(0, 20), "");
                   // Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
                    ErrorLogger.WriteErrorLog(ex);
                }
                finally
                {
                    conn.Close();
                }
            }
        }


        private void LoadDoctorsDropdown()
        {

            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT ID, CONCAT(Firstname ,' ', LEFT(Middlename, 1), '. ', Lastname, ' (', UserPosition, ')') AS FullName FROM users WHERE role = 'Doctor'"; // assuming you have a "role" field to distinguish doctors
                    MySqlDataAdapter da = new MySqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    // Bind data to DropDownList
                    PreferredDoctorID.DataSource = dt;
                    PreferredDoctorID.DataTextField = "FullName"; // Display name in the dropdown
                    PreferredDoctorID.DataValueField = "ID"; // Value to be submitted (Doctor ID)
                    PreferredDoctorID.DataBind();

                    // Add default item (Select a doctor)
                    PreferredDoctorID.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select a Doctor", ""));
                }
                catch (Exception ex)
                {
                    // Handle exception (e.g., log the error)
                    Response.Write($"Error: {ex.Message}");
                    ErrorLogger.WriteErrorLog(ex);
                }
            }
        }

        public void get_userinfo(string username)
        {
            //try
            //{
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                conn.Open();
                String cb = "select * from users where Username='" + username + "' ";
                MySqlCommand cmd = new MySqlCommand(cb);
                cmd.Connection = conn;
                MySqlDataReader rdr = cmd.ExecuteReader();
                if (rdr.Read())
                {
                  
                    Firstname.Text = rdr["Firstname"].ToString();
                    Middlename.Text = rdr["Middlename"].ToString();
                    Lastname.Text = rdr["Lastname"].ToString();
                
                  
                    Email.Text = rdr["Email"].ToString();
                    ContactNo.Text = rdr["ContactNo"].ToString();
                    Address.Text = rdr["Address"].ToString();
                 
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