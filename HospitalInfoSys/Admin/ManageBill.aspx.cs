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
    public partial class ManageBill : System.Web.UI.Page
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
                    if (Request.QueryString["id"] != null)
                    {
                        int invoiceId = Convert.ToInt32(Request.QueryString["id"]); // Or any source for InvoiceID
                        LoadBillingData(invoiceId.ToString());
                    }
                }
            }
        }

        private void LoadBillingData(string invoiceId)
        {
         

            using (MySqlConnection con = new MySqlConnection(connString))
            {
                string query = "SELECT * FROM vw_billing WHERE InvoiceID = @InvoiceID";
                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.Parameters.AddWithValue("@InvoiceID", invoiceId);

                con.Open();
                MySqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    hd_invoiceid.Value = reader["InvoiceID"].ToString();
                    lblFullName.Text = reader["FULLNAME"].ToString();
                    lblAge.Text = reader["AGE"].ToString();
                    lblSex.Text = reader["SEX"].ToString();
                    lblDateAdmitted.Text = Convert.ToDateTime(reader["PATLOGDATE"]).ToString("yyyy-MM-dd");
                    lblRoom.Text = reader["TYPECONSULTATION"].ToString(); // Adjust if actual room data exists elsewhere
                       //   lblDays.Text = CalculateDays(Convert.ToDateTime(reader["PATLOGDATE"])).ToString();
                    lblDiagnosis.Text = reader["DIAGNOSIS"].ToString();
                    lbldoctor.Text = reader["DoctorFullName"].ToString();
                    txtInvoiceNo.Text = reader["InvoiceNo"].ToString();
                    txtInvoiceDate.Text = Convert.ToDateTime(reader["InvoiceDate"]).ToString("yyyy-MM-dd");
                    txtPaymentDate.Text = reader["PaymentDate"] != DBNull.Value ? Convert.ToDateTime(reader["PaymentDate"]).ToString("yyyy-MM-dd") : "";
                    txtCashTendered.Text = reader["CashTendered"] != DBNull.Value ? Convert.ToDecimal(reader["CashTendered"]).ToString("F2") : "";
                    txtDiscount.Text = reader["Discount"] != DBNull.Value ? Convert.ToDecimal(reader["Discount"]).ToString("F2") : "";
                    txtRemarks.Text = reader["Remarks"].ToString();
                    lblStatus.Text = reader["Status2"].ToString();
                    BindCharges();


                    btnprint.NavigateUrl = "~/PrintSOA?id=" + hd_invoiceid.Value;
                 


                }
                else
                {
                    ShowMessage("No Record found", "");
                }

                reader.Close();
            }
        }

        private int CalculateDays(DateTime admitDate)
        {
            return (DateTime.Now - admitDate).Days;
        }
        protected void btn_add_Click(object sender, EventArgs e)
        {
            // reset();
            LoadItemTypes();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "showModal1", "showModal();", true);
        }

        private void LoadItemTypes()
        {
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                conn.Open();
                string query = "SELECT DISTINCT ItemType FROM chargeitemslibrary WHERE IsActive = 1";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                MySqlDataReader reader = cmd.ExecuteReader();
                ddlItemType.Items.Clear();
                ddlItemType.Items.Add("");
                while (reader.Read())
                {
                    ddlItemType.Items.Add(reader["ItemType"].ToString());
                }
            }
        }

        protected void ddlItemType_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlItemDescription.Items.Clear();
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                conn.Open();
                string query = "SELECT ChargeID, concat(Name, ' - ', fulldetails) as Names FROM vw_chargeitemlibraries WHERE ItemType = @type AND IsActive = 1";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@type", ddlItemType.SelectedValue);
                MySqlDataReader reader = cmd.ExecuteReader();
                ddlItemDescription.Items.Add("");
                while (reader.Read())
                {
                    ddlItemDescription.Items.Add(new System.Web.UI.WebControls.ListItem(reader["Names"].ToString(), reader["ChargeID"].ToString()));
                }
            }
        }

        protected void ddlItemDescription_SelectedIndexChanged(object sender, EventArgs e)
        {
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                conn.Open();
                string query = "SELECT Price FROM chargeitemslibrary WHERE ChargeID = @id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", ddlItemDescription.SelectedValue);
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    decimal price = Convert.ToDecimal(result);
                    txtUnitPrice.Text = price.ToString("F2");
                    ComputeTotal();
                }
            }
        }

        protected void ComputeTotal(object sender = null, EventArgs e = null)
        {
            int qty = int.TryParse(txtQty.Text, out int q) ? q : 1;
            decimal price = decimal.TryParse(txtUnitPrice.Text, out decimal p) ? p : 0;
            txtTotalAmount.Text = (qty * price).ToString("F2");
        }

        protected void btnAddCharge_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                using (MySqlConnection conn = new MySqlConnection(connString))
                {
                    conn.Open();
                    if (hiddenItemID.Value == "") //insert
                    {
                        string query = "INSERT INTO patientinvoiceitems (InvoiceID, ItemType, ItemRefID, Descriptions, Quantity, UnitPrice) " +
                                       "VALUES (@invoiceID, @itemType, @itemRefID, @desc, @qty, @unitPrice)";
                        MySqlCommand cmd = new MySqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@invoiceID", hd_invoiceid.Value); // example invoice ID
                        cmd.Parameters.AddWithValue("@itemType", ddlItemType.SelectedValue);
                        cmd.Parameters.AddWithValue("@itemRefID", ddlItemDescription.SelectedValue);
                        cmd.Parameters.AddWithValue("@desc", ddlItemDescription.SelectedItem.Text);
                        cmd.Parameters.AddWithValue("@qty", txtQty.Text);
                        cmd.Parameters.AddWithValue("@unitPrice", txtUnitPrice.Text);
          
                        cmd.ExecuteNonQuery();

                    }
                    else
                    {
                        //edit
                        string query = @"UPDATE patientinvoiceitems 
                                 SET ItemType = @itemType, ItemRefID = @itemRefID, Descriptions = @desc, 
                                     Quantity = @qty, UnitPrice = @unitPrice 
                                 WHERE ItemID = @itemID";
                        MySqlCommand cmd = new MySqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@itemType", ddlItemType.SelectedValue);
                        cmd.Parameters.AddWithValue("@itemRefID", ddlItemDescription.SelectedValue);
                        cmd.Parameters.AddWithValue("@desc", ddlItemDescription.SelectedItem.Text);
                        cmd.Parameters.AddWithValue("@qty", txtQty.Text);
                        cmd.Parameters.AddWithValue("@unitPrice", txtUnitPrice.Text);
                        cmd.Parameters.AddWithValue("@itemID", hiddenItemID.Value);
                        cmd.ExecuteNonQuery();
                    }
                }
               BindCharges();
                ClearModalFields();
                ShowMessage(hiddenItemID.Value != "" ? "Succesfully Updated!" : "Succesfully Added!", "");
              
                // Close modal using JavaScript
                ScriptManager.RegisterStartupScript(this, this.GetType(), "cleanModal2", "cleanModal();", true);
              
            }
        }
        private void ClearModalFields()
        {
            hiddenItemID.Value = "";
            ddlItemType.ClearSelection();
            ddlItemDescription.Items.Clear();
            txtQty.Text = "1";
            txtUnitPrice.Text = "0.00";
            txtTotalAmount.Text = "0.00";
        }
        private void BindCharges()
        {
            string query = "SELECT ItemID, Descriptions, Quantity, UnitPrice, TotalPrice, ItemType FROM patientinvoiceitems WHERE InvoiceID = @InvoiceID";
            using (MySqlConnection conn = new MySqlConnection(connString))
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@InvoiceID", hd_invoiceid.Value); // you must set this
                conn.Open();
                using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvCharges.DataSource = dt;
                    gvCharges.DataBind();
                    ComputeBillingSummary();

                 
                }
            }
        }
        protected void gvCharges_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCharges.PageIndex = e.NewPageIndex;
            BindCharges();
        }
        protected void gvCharges_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int itemId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCharge")
            {
                // Load data to modal for editing
                LoadChargeToModal(itemId); // implement this
            }
            else if (e.CommandName == "DeleteCharge")
            {
                DeleteCharge(itemId);
                BindCharges(); // refresh after delete
            }
        }

        private void DeleteCharge(int itemId)
        {
            string query = "DELETE FROM patientinvoiceitems WHERE ItemID = @ItemID";
            using (MySqlConnection conn = new MySqlConnection(connString))
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@ItemID", itemId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        private void LoadChargeToModal(int itemId)
        {
            string query = "SELECT ItemType, ItemRefID, Descriptions, Quantity, UnitPrice, TotalPrice FROM patientinvoiceitems WHERE ItemID = @ItemID";
            using (MySqlConnection conn = new MySqlConnection(connString))
            using (MySqlCommand cmd = new MySqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@ItemID", itemId);
                conn.Open();
                using (MySqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // Fill modal fields using HiddenFields or ScriptManager to pass to JavaScript
                        hiddenItemID.Value = itemId.ToString(); // For tracking during update
                        LoadItemTypes();                                // Set selected item type (make sure ddlItemType is populated before this)
                        if (ddlItemType.Items.FindByValue(reader["ItemType"].ToString()) != null)
                        {
                            ddlItemType.SelectedValue = reader["ItemType"].ToString();
                            ddlItemType_SelectedIndexChanged(null, null); // reload item description list
                        }

                        // Set selected item description
                        if (ddlItemDescription.Items.FindByValue(reader["ItemRefID"].ToString()) != null)
                        {
                            ddlItemDescription.SelectedValue = reader["ItemRefID"].ToString();
                        }

                        // Set textboxes
                        txtQty.Text = reader["Quantity"].ToString();
                        txtUnitPrice.Text = Convert.ToDecimal(reader["UnitPrice"]).ToString("0.00");
                        txtTotalAmount.Text = Convert.ToDecimal(reader["TotalPrice"]).ToString("0.00");
                  
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "showModal1", "showModal();", true);
                    }
                }
            }
        }
        protected void txtDiscount_TextChanged(object sender, EventArgs e)
        {
            ComputeBillingSummary();
        }

        protected void txtCashTendered_TextChanged(object sender, EventArgs e)
        {
            ComputeBillingSummary();
        }
        private void ComputeBillingSummary()
        {
            decimal subtotal = 0;
            decimal discount = 0;
            decimal netTotal = 0;

            // Assuming you fetch all charges for the invoice
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                conn.Open();
                string query = "SELECT Quantity, UnitPrice FROM patientinvoiceitems WHERE InvoiceID = @invoiceID";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@invoiceID", hd_invoiceid.Value);
                using (MySqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        decimal qty = Convert.ToDecimal(reader["Quantity"]);
                        decimal price = Convert.ToDecimal(reader["UnitPrice"]);
                        subtotal += qty * price;
                    }
                }
            }

            lblSubtotal.Text = "₱" + subtotal.ToString("N2");

            if (!string.IsNullOrEmpty(txtDiscount.Text))
                decimal.TryParse(txtDiscount.Text, out discount);

            netTotal = subtotal - discount;
            if (netTotal < 0) netTotal = 0;

            lblNetTotal.Text = "₱" + netTotal.ToString("N2");

            // Compute change if cash tendered is entered
            if (!string.IsNullOrEmpty(txtCashTendered.Text))
            {
                decimal cashTendered;
                if (decimal.TryParse(txtCashTendered.Text, out cashTendered))
                {
                    decimal change = cashTendered - netTotal;
                    txtChange.Text = change >= 0 ? change.ToString("N2") : "0.00";
                }
            }
        }
        protected void UpdateInvoice()
        {
            string invoiceId = hd_invoiceid.Value;

            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                conn.Open();

                string query = @"
            UPDATE patientinvoices
            SET InvoiceDate = @InvoiceDate,
                PaymentDate = @PaymentDate,
                CashTendered = @CashTendered,
                Discount = @Discount,
                Remarks = @Remarks
            WHERE InvoiceID = @InvoiceID";

                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@InvoiceID", invoiceId);
                 
                    cmd.Parameters.AddWithValue("@InvoiceDate", Convert.ToDateTime(txtInvoiceDate.Text.Trim()));

                    if (!string.IsNullOrWhiteSpace(txtPaymentDate.Text))
                        cmd.Parameters.AddWithValue("@PaymentDate", Convert.ToDateTime(txtPaymentDate.Text.Trim()));
                    else
                        cmd.Parameters.AddWithValue("@PaymentDate", DBNull.Value);

                    if (!string.IsNullOrWhiteSpace(txtCashTendered.Text))
                        cmd.Parameters.AddWithValue("@CashTendered", Convert.ToDecimal(txtCashTendered.Text));
                    else
                        cmd.Parameters.AddWithValue("@CashTendered", DBNull.Value);

                    if (!string.IsNullOrWhiteSpace(txtDiscount.Text))
                        cmd.Parameters.AddWithValue("@Discount", Convert.ToDecimal(txtDiscount.Text));
                    else
                        cmd.Parameters.AddWithValue("@Discount", DBNull.Value);

                    cmd.Parameters.AddWithValue("@Remarks", txtRemarks.Text.Trim());

                    cmd.ExecuteNonQuery();
                }
            }
            ShowMessage("Successfully Submitted!", "");
         
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            UpdateInvoice();
          
        }
    }
}