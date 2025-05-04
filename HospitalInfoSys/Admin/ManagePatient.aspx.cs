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
    public partial class ManagePatient : System.Web.UI.Page
    {

        string connString = ConfigurationManager.ConnectionStrings["myconnection"].ConnectionString;
        protected string statusentry = "New";
        static int userIDS = 0;
        public void ShowMessage(string message, string jsfunction)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Message", "alert('" + message + "'); " + jsfunction + "", true);
        }
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                LoadRoomList();
                LoadDoctorList();
                cvBirthDate.ValueToCompare = DateTime.Now.ToString("yyyy-MM-dd");
                if (Request.QueryString["prid"] != null)
                {
                    string prid = Request.QueryString["prid"].ToString();
                    RetrievePatientRecord(prid);
                    btnOpenModal.Visible = false;
                    statusentry = "Edit";
                }
                else
                {
                    userIDS = UserHelper.GetCurrentUserId();
                    GenerateHealthNo();
                    txtDateRegistered.Text = DateTime.Now.ToString("yyyy-MM-dd");
                }




            }
        }
        private void GenerateHealthNo()
        {
            string prefix = DateTime.Now.ToString("yyMMdd");
            using (MySqlConnection con = new MySqlConnection(connString))
            {
                con.Open();
                string query = $"SELECT MAX(PID) FROM patientlist WHERE HEALTHNO LIKE '{prefix}%'";
                MySqlCommand cmd = new MySqlCommand(query, con);
                object result = cmd.ExecuteScalar();
                int nextId = (result != DBNull.Value) ? Convert.ToInt32(result) + 1 : 1;
                txtHealthNo.Text = $"{prefix}-{nextId.ToString("D5")}";
            }
        }
        protected void btnSaveConsultation_Click(object sender, EventArgs e)
        {
            string patientid = GetPatientIDByHealthNo(txtHealthNo.Text);
            if (patientid.Length <= 0)
            {
                ShowMessage("No record of patient profile!", "");
                return;
            }
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    if (hd_medicalid.Value == "0") //SAVE MEDICAL
                    {

                        string query = @"INSERT INTO patientrecord 
                             (PATID, PATLOGDATE, TYPECONSULTATION, CHIEFCOMPLAINT, MEDICALHISTORY, ALLERGIES, RoomID, DoctorID, DIAGNOSIS, PATDISCHARGE, PATDISPOSITION)
                              VALUES (@PATID, @PATLOGDATE, @TYPECONSULTATION, @CHIEFCOMPLAINT, @MEDICALHISTORY, @ALLERGIES, @RoomID, @DoctorID, @DIAGNOSIS, @PATDISCHARGE, @PATDISPOSITION);
                                  SELECT LAST_INSERT_ID(); ";
                        MySqlCommand cmd = new MySqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@PATID", patientid); // From Patient Registration
                        AddParametersMedical(cmd);
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            int PRID = Convert.ToInt32(result);
                            hd_medicalid.Value = PRID.ToString();
                            ShowMessage("Medical Record Saved Successfully.", "");
                        }
                    }
                    else //UPDATE MEDICAL
                    {
                        string query = @"UPDATE patientrecord 
                                    SET PATLOGDATE = @PATLOGDATE, TYPECONSULTATION = @TYPECONSULTATION, 
                                        CHIEFCOMPLAINT = @CHIEFCOMPLAINT, MEDICALHISTORY = @MEDICALHISTORY, 
                                        ALLERGIES = @ALLERGIES, RoomID = @RoomID, DoctorID = @DoctorID, 
                                        DIAGNOSIS = @DIAGNOSIS, PATDISCHARGE = @PATDISCHARGE, 
                                        PATDISPOSITION = @PATDISPOSITION
                                    WHERE PRID = @PRID";
                        MySqlCommand cmd = new MySqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@PRID", hd_medicalid.Value);
                        AddParametersMedical(cmd);
                        cmd.ExecuteNonQuery();
                        ShowMessage("Medical Record Updated Successfully.", "");

                    }

                }
                catch (Exception ex)
                {
                    ErrorLogger.WriteErrorLog(ex);
                    ShowMessage(ex.Message, "");
                }

            }

        }
        //protected void btntest2_Click(object sender, EventArgs e)
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "SwitchTab", "$('#profile-tab').tab('show');", true);
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "showAlert", "alert('proceed to 1sttab');", true);
        //}
        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            try
            {
                // Retrieve the values from the form for detection
                string firstName = txtFirstName.Text.Trim();
                string lastName = txtLastName.Text.Trim();
                DateTime birthDate = Convert.ToDateTime(txtBirthDate.Text); // Ensure proper date format
                string middleName = txtMiddleName.Text.Trim();
                string sex = ddlSex.SelectedValue; // Assuming sex is selected from a dropdown list

                // Call the function to check if the patient exists and retrieve the full details
                DataRow existingPatient = GetExistingPatientDetails(firstName, lastName, birthDate, middleName, sex);

                if (existingPatient != null && hd_profileid.Value == "0")
                {
                    // If a matching record is found, auto-fill the form with existing data
                    string hno = existingPatient["HEALTHNO"].ToString();
                    txtHealthNo.Text = hno;
                    txtFirstName.Text = existingPatient["FIRSTNAME"].ToString();
                    txtLastName.Text = existingPatient["LASTNAME"].ToString();
                    txtMiddleName.Text = existingPatient["MIDDLENAME"].ToString();
                    txtBirthDate.Text = Convert.ToDateTime(existingPatient["BIRTHDATE"]).ToString("yyyy-MM-dd");
                    ddlSex.SelectedValue = existingPatient["SEX"].ToString();
                    txtAddress.Text = existingPatient["ADDRESS"].ToString();
                    txtContactNo.Text = existingPatient["CONTACTNO"].ToString();
                    txtEmail.Text = existingPatient["EMAIL"].ToString();
                    txtOccupation.Text = existingPatient["OCCUPATION"].ToString();
                    txtCPContactNo.Text = existingPatient["CPCONTACTNO"].ToString();
                    txtCPName.Text = existingPatient["CPNAME"].ToString();
                    // You can continue for other fields based on your table structure

                    // You can also retrieve the patient ID if needed
                    string existingPatientID = existingPatient["PID"].ToString();
                    hd_profileid.Value = existingPatientID;
                    // Inform the user that the record exists
                    string message = "Patient already exists. Existing Patient No: " + hno + ", Do you want to continue with a new patient encounter? Just Continue Medical record";
                    ShowMessage(message, "");
                    return;
                }


                using (MySqlConnection con = new MySqlConnection(connString))
                {
                    if (hd_profileid.Value == "0") //SAVE
                    {
                        con.Open();
                        string checkUserQuery = "SELECT COUNT(PID) FROM patientlist WHERE HEALTHNO=@HEALTHNO;";
                        using (MySqlCommand checkCmd = new MySqlCommand(checkUserQuery, con))
                        {
                            checkCmd.Parameters.AddWithValue("@HEALTHNO", txtHealthNo.Text.Trim());
                            int healthnoExist = Convert.ToInt32(checkCmd.ExecuteScalar());
                            con.Close();
                            if (healthnoExist > 0)
                            {
                                GenerateHealthNo();

                            }
                            con.Open();

                            string query = @"INSERT INTO patientlist 
                                    (HEALTHNO, FIRSTNAME, LASTNAME, MIDDLENAME, ADDRESS, CONTACTNO, EMAIL, SEX, BIRTHDATE, OCCUPATION, CPNAME, CPCONTACTNO, DATEREGISTERED,userid)
                                    VALUES (@HEALTHNO, @FIRSTNAME, @LASTNAME, @MIDDLENAME, @ADDRESS, @CONTACTNO, @EMAIL, @SEX, @BIRTHDATE, @OCCUPATION, @CPNAME, @CPCONTACTNO, @DATEREGISTERED,@userid); 
                                    SELECT LAST_INSERT_ID(); ";
                            MySqlCommand cmd = new MySqlCommand(query, con);
                            AddParameters(cmd);
                            object result = cmd.ExecuteScalar();
                            if (result != null)
                            {
                                int PID = Convert.ToInt32(result);
                                hd_profileid.Value = PID.ToString();
                                ShowMessage("Record Saved Successfully.", "");
                            }
                        }
                    }
                    else
                    {
                        con.Open();
                        string query = @"UPDATE patientlist SET 
                                        HEALTHNO=@HEALTHNO, FIRSTNAME=@FIRSTNAME, LASTNAME=@LASTNAME, MIDDLENAME=@MIDDLENAME,
                                        ADDRESS=@ADDRESS, CONTACTNO=@CONTACTNO, EMAIL=@EMAIL, SEX=@SEX,
                                        BIRTHDATE=@BIRTHDATE, OCCUPATION=@OCCUPATION, CPNAME=@CPNAME,
                                        CPCONTACTNO=@CPCONTACTNO, DATEREGISTERED=@DATEREGISTERED
                                        WHERE PID=@PID";
                        MySqlCommand cmd = new MySqlCommand(query, con);


                        cmd.Parameters.AddWithValue("@PID", hd_profileid.Value);
                        AddParameters(cmd);
                        cmd.ExecuteNonQuery();

                        ShowMessage("Updated Successfully!", "");


                    }
                }



            }
            catch (Exception ex)
            {
                ErrorLogger.WriteErrorLog(ex);
                ShowMessage(ex.Message, "");

            }
        }
        private void AddParametersMedical(MySqlCommand cmd)
        {
            cmd.Parameters.AddWithValue("@PATLOGDATE", DateTime.Parse(txtConsultDate.Text));
            cmd.Parameters.AddWithValue("@TYPECONSULTATION", ddlConsultType.SelectedValue);
            cmd.Parameters.AddWithValue("@CHIEFCOMPLAINT", txtChiefComplaint.Text);
            cmd.Parameters.AddWithValue("@MEDICALHISTORY", txtMedicalHistory.Text);
            cmd.Parameters.AddWithValue("@ALLERGIES", txtAllergies.Text);
            cmd.Parameters.AddWithValue("@RoomID", ddlRoom.SelectedValue);
            cmd.Parameters.AddWithValue("@DoctorID", ddlDoctor.SelectedValue);
            cmd.Parameters.AddWithValue("@DIAGNOSIS", txtDiagnosis.Text);
            cmd.Parameters.AddWithValue("@PATDISCHARGE", string.IsNullOrWhiteSpace(txtDischarge.Text) ? (object)DBNull.Value : DateTime.Parse(txtDischarge.Text));
            cmd.Parameters.AddWithValue("@PATDISPOSITION", txtDisposition.Text);
        }
        private void AddParameters(MySqlCommand cmd)
        {
            cmd.Parameters.AddWithValue("@HEALTHNO", txtHealthNo.Text.Trim());
            cmd.Parameters.AddWithValue("@FIRSTNAME", txtFirstName.Text.Trim());
            cmd.Parameters.AddWithValue("@LASTNAME", txtLastName.Text.Trim());
            cmd.Parameters.AddWithValue("@MIDDLENAME", txtMiddleName.Text.Trim());
            cmd.Parameters.AddWithValue("@ADDRESS", txtAddress.Text.Trim());
            cmd.Parameters.AddWithValue("@CONTACTNO", txtContactNo.Text.Trim());
            cmd.Parameters.AddWithValue("@EMAIL", txtEmail.Text.Trim());
            cmd.Parameters.AddWithValue("@SEX", ddlSex.SelectedValue);
            cmd.Parameters.AddWithValue("@BIRTHDATE", DateTime.Parse(txtBirthDate.Text));
            cmd.Parameters.AddWithValue("@OCCUPATION", txtOccupation.Text.Trim());
            cmd.Parameters.AddWithValue("@CPNAME", txtCPName.Text.Trim());
            cmd.Parameters.AddWithValue("@CPCONTACTNO", txtCPContactNo.Text.Trim());
            cmd.Parameters.AddWithValue("@DATEREGISTERED", DateTime.Parse(txtDateRegistered.Text));
            cmd.Parameters.AddWithValue("@userid", userIDS);
        }
        protected void btnNext_Click(object sender, EventArgs e)
        {

            ScriptManager.RegisterStartupScript(this, this.GetType(), "SwitchTab", "$('#medical-tab').tab('show');", true);

        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {



        }
        public void reset_profile()
        {
            hd_profileid.Value = "0";
            txtHealthNo.Text = "";
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtMiddleName.Text = "";
            txtAddress.Text = "";
            txtContactNo.Text = "";
            txtEmail.Text = "";
            ddlSex.SelectedIndex = 0;
            txtBirthDate.Text = "";
            txtOccupation.Text = "";
            txtCPName.Text = "";
            txtCPContactNo.Text = "";
            txtDateRegistered.Text = DateTime.Now.ToString("yyyy-MM-dd");
        }
        private void LoadRoomList()
        {

            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT ID, CONCAT(RoomName, ' - (', RoomNumber, ')') AS RoomDisplay FROM rooms where IsVacant=1";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        ddlRoom.DataSource = dt;
                        ddlRoom.DataTextField = "RoomDisplay";
                        ddlRoom.DataValueField = "ID";
                        ddlRoom.DataBind();

                        // Optional: add a default item
                        ddlRoom.Items.Insert(0, new ListItem("Select Room", "0"));
                    }
                }
                catch (Exception ex)
                {
                    ErrorLogger.WriteErrorLog(ex);
                    // Handle or log error
                    // lblError.Text = "Error loading rooms: " + ex.Message;
                }
            }
        }
        private void LoadDoctorList()
        {

            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    // Adjust table/column names based on your actual DB structure
                    string query = "SELECT ID, CONCAT(LastName, ', ', FirstName, ' (', UserPosition, ')') AS DoctorDisplay FROM users where Role='Doctor' and IsApproved=1";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        ddlDoctor.DataSource = dt;
                        ddlDoctor.DataTextField = "DoctorDisplay";
                        ddlDoctor.DataValueField = "ID";
                        ddlDoctor.DataBind();

                        ddlDoctor.Items.Insert(0, new ListItem("Select Doctor", "0"));
                    }
                }
                catch (Exception ex)
                {
                    ErrorLogger.WriteErrorLog(ex);
                    // Handle or log error
                    // lblError.Text = "Error loading doctors: " + ex.Message;
                }
            }
        }
        private string GetPatientIDByHealthNo(string healthNo)
        {
            string patientID = string.Empty;

            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    string query = "SELECT PID FROM patientlist WHERE HEALTHNO = @HEALTHNO";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@HEALTHNO", healthNo);

                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            patientID = result.ToString();
                        }
                    }
                }
                catch (Exception ex)
                {
                    ErrorLogger.WriteErrorLog(ex);
                    // Handle error (logging, showing error message, etc.)
                    // lblError.Text = "Error getting PatientID: " + ex.Message;
                }
            }

            return patientID;
        }
        private DataRow GetExistingPatientDetails(string firstName, string lastName, DateTime birthDate, string middleName, string sex)
        {

            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                try
                {
                    conn.Open();

                    // Define the query to check for existing patient based on provided fields
                    string query = @"SELECT * 
                             FROM patientlist
                             WHERE FIRSTNAME = @FirstName
                               AND LASTNAME = @LastName
                               AND BIRTHDATE = @BirthDate
                               AND MIDDLENAME = @MiddleName
                               AND SEX = @Sex";

                    // Set up the command
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        // Add parameters to prevent SQL injection
                        cmd.Parameters.AddWithValue("@FirstName", firstName);
                        cmd.Parameters.AddWithValue("@LastName", lastName);
                        cmd.Parameters.AddWithValue("@BirthDate", birthDate);
                        cmd.Parameters.AddWithValue("@MiddleName", middleName);
                        cmd.Parameters.AddWithValue("@Sex", sex);

                        // Execute the query and get the result
                        using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            // If a record is found, return the first row (patient details)
                            if (dt.Rows.Count > 0)
                            {
                                return dt.Rows[0];
                            }
                            else
                            {
                                // If no matching record is found, return null
                                return null;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Handle any errors
                    throw new Exception("Error detecting existing patient record: " + ex.Message);
                }
            }
        }

        protected void ddlConsultType_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedText = ddlConsultType.SelectedItem.Text;
            rfvRoom.Enabled = true;
            if (selectedText == "Outpatient")
            {
                rfvRoom.Enabled = false;
            }
        }
        private void RetrievePatientRecord(string prid)
        {
            try
            {
                using (MySqlConnection con = new MySqlConnection(connString))
                {
                    string query = "SELECT * FROM vw_patientrecord WHERE PRID = @PRID";
                    MySqlCommand cmd = new MySqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@PRID", prid);

                    con.Open();
                    MySqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // Fill in the TextBoxes with the data retrieved from the database
                        hd_profileid.Value = reader["PID"].ToString();
                        txtHealthNo.Text = reader["HEALTHNO"].ToString();
                        txtFirstName.Text = reader["FIRSTNAME"].ToString();
                        txtLastName.Text = reader["LASTNAME"].ToString();
                        txtMiddleName.Text = reader["MIDDLENAME"].ToString();
                        txtAddress.Text = reader["ADDRESS"].ToString();
                        txtContactNo.Text = reader["CONTACTNO"].ToString();
                        txtEmail.Text = reader["EMAIL"].ToString();
                        ddlSex.SelectedValue = reader["SEX"].ToString();
                        txtBirthDate.Text = Convert.ToDateTime(reader["BIRTHDATE"]).ToString("yyyy-MM-dd");
                        txtOccupation.Text = reader["OCCUPATION"].ToString();
                        txtCPName.Text = reader["CPNAME"].ToString();
                        txtCPContactNo.Text = reader["CPCONTACTNO"].ToString();
                        txtDateRegistered.Text = Convert.ToDateTime(reader["DATEREGISTERED"]).ToString("yyyy-MM-dd");

                        // Medical record information (Tab 2)
                        hd_medicalid.Value = reader["PRID"].ToString();
                        txtDiagnosis.Text = reader["DIAGNOSIS"].ToString();
                        txtConsultDate.Text = Convert.ToDateTime(reader["PATLOGDATE"]).ToString("yyyy-MM-ddTHH:mm:ss");
                        ddlConsultType.SelectedValue = reader["TYPECONSULTATION"].ToString();
                        txtChiefComplaint.Text = reader["CHIEFCOMPLAINT"].ToString();
                        txtAllergies.Text = reader["ALLERGIES"].ToString();
                        txtMedicalHistory.Text = reader["MEDICALHISTORY"].ToString();
                        ddlRoom.SelectedValue = reader["RoomID"].ToString();
                        ddlDoctor.SelectedValue = reader["DoctorID"].ToString();
                        txtDiagnosis.Text = reader["DIAGNOSIS"].ToString();
                        txtDischarge.Text = reader["PATDISCHARGE"] != DBNull.Value ? Convert.ToDateTime(reader["PATDISCHARGE"]).ToString("yyyy-MM-ddTHH:mm:ss") : "";
                        txtDisposition.Text = reader["PATDISPOSITION"].ToString();
                        ;
                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                ErrorLogger.WriteErrorLog(ex);
            }
        }
        protected void btnOpenModal_Click(object sender, EventArgs e)
        {
            //Search Patient Modal
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowModalScript", "showModal();", true);
        }
        //protected void btnSubmitModal_Click(object sender, EventArgs e)
        //{
        //    ShowMessage("test", "");
        //  //  ScriptManager.RegisterStartupScript(this, this.GetType(), "CleanupModal", "cleanModal();", true);
        //   // ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowModalScript", "showModal();", true);
        //}

        protected void btnResetSearch_Click(object sender, EventArgs e)
        {
            txt_searchmi.Text = "";
            txt_searchlname.Text = "";
            txt_searchfname.Text = "";
            gvPatients.DataSource = null;
            gvPatients.DataBind();
            txt_searchlname.Focus();
          //  UpdatePanelSearch.Update();
          

        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
                GetPatientsSearch();

        }
        protected void btn_select_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn_select = (LinkButton)sender;
                GridViewRow item = (GridViewRow)btn_select.NamingContainer;

                HiddenField hd_idselect = (HiddenField)item.FindControl("hd_id");
        
               
               RetrievePatientProfile(hd_idselect.Value);
            
                // Optionally close modal with JS
                ScriptManager.RegisterStartupScript(this, this.GetType(), "HideModal", "$('#myModal').modal('hide');", true);
            }
            catch (Exception ex)
            {
                ErrorLogger.WriteErrorLog(ex);
                ShowMessage(ex.Message, "");
            }
        }
      private void GetPatientsSearch()
        {
            try
            {
                using (MySqlConnection conn = new MySqlConnection(connString))
                {
                    string query = @" SELECT *
                                FROM patientlist
                                WHERE (@LASTNAME = '' OR LASTNAME LIKE CONCAT('%', @LASTNAME, '%'))
                                  AND (@FIRSTNAME = '' OR FIRSTNAME LIKE CONCAT('%', @FIRSTNAME, '%'))
                                  AND (@MIDDLENAME = '' OR MIDDLENAME LIKE CONCAT('%', @MIDDLENAME, '%'))
                                ORDER BY LASTNAME, FIRSTNAME; ";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@LASTNAME", txt_searchlname.Text.Trim());
                        cmd.Parameters.AddWithValue("@FIRSTNAME", txt_searchfname.Text.Trim());
                        cmd.Parameters.AddWithValue("@MIDDLENAME", txt_searchmi.Text.Trim());

                        using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            gvPatients.DataSource = dt;
                            gvPatients.DataBind();
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                ErrorLogger.WriteErrorLog(ex);
                ShowMessage(ex.Message, "");
            }


        }

        
        private void RetrievePatientProfile(string pid)
        {
            try
            {
                using (MySqlConnection con = new MySqlConnection(connString))
                {
                    string query = "SELECT * FROM patientlist WHERE PID =@PID";
                    MySqlCommand cmd = new MySqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@PID", pid);

                    con.Open();
                    MySqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        //  ShowMessage(reader["PID"].ToString(), "");
                        // Fill in the TextBoxes with the data retrieved from the database
                        hd_profileid.Value = reader["PID"].ToString();
                        txtHealthNo.Text = reader["HEALTHNO"].ToString();
                        txtFirstName.Text = reader["FIRSTNAME"].ToString();
                        txtLastName.Text = reader["LASTNAME"].ToString();
                        txtMiddleName.Text = reader["MIDDLENAME"].ToString();
                        txtAddress.Text = reader["ADDRESS"].ToString();
                        txtContactNo.Text = reader["CONTACTNO"].ToString();
                        txtEmail.Text = reader["EMAIL"].ToString();
                        ddlSex.SelectedValue = reader["SEX"].ToString();
                        txtBirthDate.Text = Convert.ToDateTime(reader["BIRTHDATE"]).ToString("yyyy-MM-dd");
                        txtOccupation.Text = reader["OCCUPATION"].ToString();
                        txtCPName.Text = reader["CPNAME"].ToString();
                        txtCPContactNo.Text = reader["CPCONTACTNO"].ToString();
                        txtDateRegistered.Text = Convert.ToDateTime(reader["DATEREGISTERED"]).ToString("yyyy-MM-dd");
                        txtFirstName.Focus();
                        UpdatePanelProfile.Update();


                    }
                    reader.Close();
                }
            }
            catch (Exception ex)
            {
                ErrorLogger.WriteErrorLog(ex);
                ShowMessage(ex.Message, "");
            }
        }
    }
}