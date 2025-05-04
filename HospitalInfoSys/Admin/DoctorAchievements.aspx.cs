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
using System.IO;

namespace HospitalInfoSys.Admin
{
    public partial class DoctorAchievements : System.Web.UI.Page
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
                    LoadDoctor();
                    bind_record();
                }
            }
        }
        private void LoadDoctor()
        {

            dpdoctor.Items.Clear();
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                conn.Open();
                string query = "SELECT ID,  CONCAT(Firstname,  ' ',LEFT(Middlename, 1),   '. ',Lastname) AS Fullname FROM users WHERE Role='Doctor' AND IsApproved = 1";
                MySqlCommand cmd = new MySqlCommand(query, conn);
               
                MySqlDataReader reader = cmd.ExecuteReader();
                dpdoctor.Items.Add("Select Doctor");
                while (reader.Read())
                {
                    dpdoctor.Items.Add(new System.Web.UI.WebControls.ListItem(reader["Fullname"].ToString(), reader["ID"].ToString()));
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
                    string sql = "select * from vw_doctorachievement where 1=1 ";

                    if (txt_search.Text.Trim() != "")
                    {
                        sql += @"and
                       (specialty LIKE @search 
                       OR descriptions LIKE @search
                        OR Fullname LIKE @search) ";
                    }
                    sql += "  order by Fullname asc ";
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
            hd_achievementid.Value = "0";
           dpdoctor.SelectedIndex =0;
            txtdescription.Text = "";
            txtspecialty.Text = "";
            hdimagepath.Value = "";
            imgPreview.ImageUrl = "";
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
                    String cb = "select * from vw_doctorachievement where id=" + id + " ";
                    MySqlCommand cmd = new MySqlCommand(cb);
                    cmd.Connection = conn;
                    MySqlDataReader rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                    {
                        hd_achievementid.Value = id;
                        dpdoctor.SelectedValue = rdr["doctor_id"].ToString();
                        txtdescription.Text = rdr["descriptions"].ToString();
                        txtspecialty.Text = rdr["specialty"].ToString();
                        string imgPath = rdr["photo_url"].ToString();
                        hdimagepath.Value = imgPath;
                        if (!string.IsNullOrEmpty(imgPath))
                        {
                            imgPreview.ImageUrl = imgPath;
                            imgPreview.Visible = true;
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
                        String cb = "Delete from doctor_achievements where id = " + hd_idselect.Value + "";
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
            Page.Response.Redirect("ManageAchievements");

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (Page.IsValid) // Ensure all required fields are filled
            {
                string description = txtdescription.Text.Trim();
                string docid = dpdoctor.SelectedValue;
                string specialty = txtspecialty.Text;
              

                if (hd_achievementid.Value == "0") // INSERT IF NOT SELECT ID
                {

                    using (MySqlConnection con = new MySqlConnection(connString))
                    {
                        try
                        {
                            con.Open();

                            string checkUserQuery = "SELECT COUNT(*) FROM doctor_achievements WHERE doctor_id = @doctor_id;";
                            using (MySqlCommand checkCmd = new MySqlCommand(checkUserQuery, con))
                            {
                                checkCmd.Parameters.AddWithValue("@doctor_id", docid);
                                int servicenameExist = Convert.ToInt32(checkCmd.ExecuteScalar());
                                con.Close();
                                if (servicenameExist > 0)
                                {
                                    dpdoctor.SelectedIndex = 0;
                                    dpdoctor.Focus();
                                    ShowMessage("Doctor Achievements already exist!", "");
                                }
                                else
                                {
                                    con.Open();
                                    string query = "INSERT INTO doctor_achievements (doctor_id,specialty,photo_url,descriptions) " +
                                           "VALUES (@doctor_id,@specialty,@photo_url,@descriptions)";

                                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                                    {
                                        cmd.Parameters.AddWithValue("@doctor_id", docid);
                                        cmd.Parameters.AddWithValue("@specialty", specialty);
                                        cmd.Parameters.AddWithValue("@descriptions", description);
                                     

                                        string imagePath = "";
                                        if (fuImage.HasFile)
                                        {
                                            string filename = Path.GetFileName(fuImage.FileName);
                                            imagePath = "~/images/doctor/" + filename;
                                            fuImage.SaveAs(Server.MapPath(imagePath));
                                        }
                                        cmd.Parameters.AddWithValue("@photo_url", imagePath);

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

                            string checkUserQuery = "SELECT COUNT(*) FROM doctor_achievements WHERE doctor_id=@doctor_id AND id !=@ID;";
                            using (MySqlCommand checkCmd = new MySqlCommand(checkUserQuery, con))
                            {
                                checkCmd.Parameters.AddWithValue("@doctor_id", docid);
                                checkCmd.Parameters.AddWithValue("@ID", hd_achievementid.Value);
                                int servicenameExist = Convert.ToInt32(checkCmd.ExecuteScalar());
                                con.Close();
                                if (servicenameExist > 0)
                                {
                                    dpdoctor.SelectedIndex = 0;
                                    dpdoctor.Focus();
                                    ShowMessage("Doctor Achievements already exist!", "");
                                }
                                else
                                {
                                    con.Open();


                                    string query = "UPDATE doctor_achievements SET doctor_id=@d1,specialty=@d2,photo_url=@d3,descriptions=@d4 " +
                                        " WHERE id =@ID ";

                                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                                    {
                                        cmd.Parameters.AddWithValue("@ID", hd_achievementid.Value);
                                        cmd.Parameters.AddWithValue("@d1", docid);
                                        cmd.Parameters.AddWithValue("@d2", specialty);
                                 
                                        cmd.Parameters.AddWithValue("@d4", description);
                                        string imagePath = ""; // Store old path here
                                        if (fuImage.HasFile)
                                        {
                                            string filename = Path.GetFileName(fuImage.FileName);
                                            imagePath = "~/images/doctor/" + filename;
                                            fuImage.SaveAs(Server.MapPath(imagePath));
                                        }
                                        else
                                        {
                                            imagePath = hdimagepath.Value;
                                        }
                                        cmd.Parameters.AddWithValue("@d3", imagePath);


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