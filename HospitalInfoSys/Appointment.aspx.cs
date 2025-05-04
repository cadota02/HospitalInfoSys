using System;
using System.Data;
using MySql.Data.MySqlClient;
using System.Configuration;
using PdfSharp.Pdf;
using PdfSharp.Drawing;
namespace HospitalInfoSys
{
    public partial class Appointment : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
     
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                if (!User.Identity.IsAuthenticated)
                {

                }
                    linkprint.Visible = false;
                LoadDoctorsDropdown();
                int userId = UserHelper.GetCurrentUserId();

                if (userId == -1)
                {
                    Response.Write("<script>alert('Please signup before you can book appointment.');</script>");
                    // Response.Redirect("Login.aspx");
                    // return;
                }

            }
        }
        protected void SubmitAppointment(object sender, EventArgs e)
        {
            string appointmentNumber = GenerateAppointmentNumber();
            // Get the form data
            string firstname = Firstname.Text;
            string middlename = Middlename.Text;
            string lastname = Lastname.Text;
            string sex = Sex.SelectedValue;
            string birthdate = BirthDate.Text;
            string email = Email.Text;
            string contactNo = ContactNo.Text;
            string address = Address.Text;
            int preferredDoctorID = int.Parse(PreferredDoctorID.SelectedValue);
            string preferredDoctorName = PreferredDoctorID.SelectedItem.Text;
            string appointmentDateTime = AppointmentDateTime.Text;
            string reason = Reason.Text;
            int userId = UserHelper.GetCurrentUserId();
            // Set the MySQL connection string (ensure you update this with your credentials)


            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                try
                {
                    // Open the connection
                    conn.Open();

                    string query = @"INSERT INTO appointments 
                                       (Firstname, Middlename, Lastname, Sex, BirthDate, Email, ContactNo, Address, PreferredDoctorID, AppointmentDateTime, Reason, Status, AppointmentDateApproved, AppointmentRemarks, AppointmentNumber, userid)
                                          VALUES 
                                        (@Firstname, @Middlename, @Lastname, @Sex, @BirthDate, @Email, @ContactNo, @Address, @PreferredDoctorID, @AppointmentDateTime, @Reason, 'Pending', @AppointmentDateApproved, @AppointmentRemarks, @AppointmentNumber,@userid);";
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
                        cmd.Parameters.AddWithValue("@AppointmentDateApproved", DBNull.Value);
                        cmd.Parameters.AddWithValue("@AppointmentRemarks", DBNull.Value);
                        cmd.Parameters.AddWithValue("@AppointmentNumber", appointmentNumber);
                        cmd.Parameters.AddWithValue("@userid", userId);
                        cmd.ExecuteNonQuery();
                    }

                    // Get last inserted ID without closing the connection
                    using (MySqlCommand getIdCmd = new MySqlCommand("SELECT LAST_INSERT_ID();", conn))
                    {
                        int ids = Convert.ToInt32(getIdCmd.ExecuteScalar());
                        linkprint.NavigateUrl = "~/AppointmentPrint?id=" + ids.ToString();
                        linkprint.Visible = true;
                    }
                    Response.Write("<script>alert('Successfully Submitted!');</script>");



                }
                catch (MySqlException ex)
                {
                    Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
                    ErrorLogger.WriteErrorLog(ex);
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
                    ErrorLogger.WriteErrorLog(ex);
                }
                finally
                {
                    conn.Close();
                }
            }
        }
        private string GenerateAppointmentNumber()
        {
            // Generate a custom appointment number
            string prefix = "";
            string datePart = DateTime.Now.ToString("yyMMdd");
            string randomNumber = new Random().Next(1000, 9999).ToString();

            return $"{prefix}{datePart}-{randomNumber}";
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
      

    }
}