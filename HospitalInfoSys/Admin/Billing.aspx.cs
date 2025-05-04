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
    public partial class Billing : System.Web.UI.Page
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
                    string sql = "select * from vw_billing where 1=1 ";

                    if (txt_search.Text.Trim() != "")
                    {
                        sql += @"and
                       (FULLNAME LIKE @search 
                        OR HEALTHNO LIKE @search
                        OR InvoiceNo LIKE @search
                        OR TYPECONSULTATION LIKE @search
                        OR DoctorFullName LIKE @search) ";
                    }
                    sql += "  order by InvoiceDate desc ";
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
            // reset();
          
            ScriptManager.RegisterStartupScript(this, this.GetType(), "showModal1", "showModal();", true);
        }
        public void reset()
        {
         
          

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

                Page.Response.Redirect("ManageBill?id=" + hd_idselect.Value);
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message, "");
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
                        String cb = "Delete from patientinvoices where InvoiceID =@id";
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
            Page.Response.Redirect("BillingRecord");

        }

      
        #region modalsearch
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
        protected void btn_selectpat_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn_select = (LinkButton)sender;
                GridViewRow item = (GridViewRow)btn_select.NamingContainer;

                HiddenField hd_idselect = (HiddenField)item.FindControl("hd_id");

                add_invoice(hd_idselect.Value);

               
               // RetrievePatientProfile(hd_idselect.Value);

                // Optionally close modal with JS
              //  ScriptManager.RegisterStartupScript(this, this.GetType(), "HideModal", "$('#myModal').modal('hide');", true);
            }
            catch (Exception ex)
            {
                ErrorLogger.WriteErrorLog(ex);
                ShowMessage(ex.Message, "");
            }
        }
        public void add_invoice(string patrecordid)
        {
            try
            {

                using (MySqlConnection conn = new MySqlConnection(connString))
                {
                    conn.Open();
                    string insertInvoice = @"INSERT INTO patientinvoices 
                    (PatientRecID, InvoiceDate, IsPaid, PaymentDate, CashTendered, Remarks, InvoiceNo, Discount)
                    VALUES (@recID, NOW(), 0, NULL, 0, '',  GenerateInvoiceNo(), 0);
                    SELECT LAST_INSERT_ID();";

                var cmd = new MySqlCommand(insertInvoice, conn);
                cmd.Parameters.AddWithValue("@recID", patrecordid);
             
                int invoiceID = Convert.ToInt32(cmd.ExecuteScalar());
                  if(invoiceID > 0)
                    {
                        Page.Response.Redirect("ManageBill?id=" + invoiceID.ToString());
                    }
                   
                }

           
            }
            catch(Exception ex)
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
                                FROM vw_patientrecord
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
        #endregion

    }
}